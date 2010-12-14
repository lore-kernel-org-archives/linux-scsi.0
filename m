From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Tue, 14 Dec 2010 14:57:32 -0600
Message-ID: <4D07DA3C.2080209@cs.wisc.edu>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>	 <4CBBDC19.1090806@cs.wisc.edu> <1288040021.5487.826.camel@mulgrave.site>	 <4CC75F42.9030603@cs.wisc.edu> <1288134569.19649.5.camel@mulgrave.site> <4CC86CF5.1080204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39806 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759636Ab0LNU6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2010 15:58:12 -0500
In-Reply-To: <4CC86CF5.1080204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>, linux-scsi@vger.kernel.org

On 10/27/2010 01:18 PM, Mike Christie wrote:
> On 10/26/2010 06:09 PM, James Bottomley wrote:
>> On Tue, 2010-10-26 at 18:07 -0500, Mike Christie wrote:
>>> On 10/25/2010 03:53 PM, James Bottomley wrote:
>>>>
>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>>> index 1de30eb..484b128 100644
>>>> --- a/drivers/scsi/scsi_error.c
>>>> +++ b/drivers/scsi/scsi_error.c
>>>> @@ -1156,51 +1156,40 @@ static int scsi_eh_target_reset(struct
>>>> Scsi_Host *shost,
>>>> struct list_head *work_q,
>>>> struct list_head *done_q)
>>>> {
>>>> - struct scsi_cmnd *scmd, *tgtr_scmd, *next;
>>>> - unsigned int id = 0;
>>>> - int rtn;
>>>> + LIST_HEAD(tmp_list);
>>>>
>>>> - do {
>>>> - tgtr_scmd = NULL;
>>>> - list_for_each_entry(scmd, work_q, eh_entry) {
>>>> - if (id == scmd_id(scmd)) {
>>>> - tgtr_scmd = scmd;
>>>> - break;
>>>> - }
>>>> - }
>>>> - if (!tgtr_scmd) {
>>>> - /* not one exactly equal; find the next highest */
>>>> - list_for_each_entry(scmd, work_q, eh_entry) {
>>>> - if (scmd_id(scmd)> id&&
>>>> - (!tgtr_scmd ||
>>>> - scmd_id(tgtr_scmd)> scmd_id(scmd)))
>>>> - tgtr_scmd = scmd;
>>>> - }
>>>> - }
>>>> - if (!tgtr_scmd)
>>>> - /* no more commands, that's it */
>>>> - break;
>>>> + list_splice(work_q,&tmp_list);
>>>
>>>
>>> I think I am hitting multiple bugs. One might be with this patch, but
>>> strangely they both hit __list_add bugs in the scsi eh. I think this
>>> needs to be list_splice_init().
>>
>> I think that's exactly right ... I keep getting tripped up by the _init
>> requirements for reusing lists (and list_heads).
>>
>>>> + list_for_each_entry_safe(scmd, next,&tmp_list, eh_entry) {
>>>> + if (scmd_id(scmd) != id)
>>>> + continue;
>>>> +
>>>> + if ((rtn == SUCCESS || rtn == FAST_IO_FAIL)
>>>> + && (!scsi_device_online(scmd->device) ||
>>>> + rtn == FAST_IO_FAIL || !scsi_eh_tur(scmd)))
>>>> + scsi_eh_finish_cmd(scmd, done_q);
>>>
>>> Because if the target resets work and move all the commands to the
>>> done_q here.
>>>
>>>
>>>> + else
>>>> + /* push back on work queue for further processing */
>>>> + list_move(&scmd->eh_entry, work_q);
>>>> + }
>>>>
>>>> return list_empty(work_q);
>>>> }
>>>
>>>
>>> Then this work_q is showing garbage in it from the splice I think.
>>> Without the list_splice_init I get that trace I cut and pasted in the
>>> other mail when I just force the scsi eh to run the target reset code.
>>>
>>> In the test, the target reset succeeds. The scsi_eh_finish_cmd call
>>> above moves all the cmds to the done_q. But the work_q still has junk in
>>> it, and so we return that we need to do more work and eventually we end
>>> up running scsi_eh_offline_sdevs which calls scsi_eh_finish_cmd on a
>>> command we already moved to the done_q.
>>
>> So does changing to the _init version fix at least the junk done_q
>> problem?
>>
>
> Yeah.


Hey James,

Your patch with the _init fixed the problem for me. Were you going to 
merge the patch or did you want me to test Hilf's version?
