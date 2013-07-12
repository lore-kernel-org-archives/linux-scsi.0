From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv3 0/9] New EH command timeout handler
Date: Fri, 12 Jul 2013 18:00:57 +0800
Message-ID: <51DFD3D9.4080306@cn.fujitsu.com>
References: <1372688671-85639-1-git-send-email-hare@suse.de> <51DF82B9.8030406@cn.fujitsu.com> <51DF9DB0.7080502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932725Ab3GLJ5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 05:57:03 -0400
In-Reply-To: <51DF9DB0.7080502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

Hi, Hannes:

On 07/12/2013 02:09 PM, Hannes Reinecke wrote:
> On 07/12/2013 06:14 AM, Ren Mingxin wrote:
>> On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
>>> With the original SCSI EH I got:
>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>> 4096+0 records in
>>> 4096+0 records out
>>> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
>>>
>>> real    2m22.657s
>>> user    0m0.013s
>>> sys    0m0.145s
>>>
>>> With this patchset I got:
>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>> 4096+0 records in
>>> 4096+0 records out
>>> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
>>>
>>> real    0m52.163s
>>> user    0m0.012s
>>> sys    0m0.145s
>>>
>>> Test was to disable RSCN on the target port, disable the
>>> target port, and then start the 'dd' command as indicated.
>>
>> Do you mean disabling RSCN/port is enough? I'm afraid I couldn't
>> reproduce the problem by your steps. Both with and without your
>> patchset are the same 'dd' result: 27s. Please let me know where I
>> neglected or mistook:
>>
>> 1) I made a dm-multipath target 'dm-0' whose grouping policy was
>>     failover;
>> 2) Disable RSCN/port via brocade fc switch:
>>     SW300:root>  portcfg rscnsupr 15 --enable; portDisable 15
>> 3) Start the 'dd' command:
>>     # time dd if=/dev/zero of=/dev/dm-0 bs=4k count=4k oflag=direct
>>     dd: writing `/dev/sde': Input/output error
>>     1+0 records in
>>     0+0 records out
>>     0 bytes (0 B) copied, 27.8588 s, 0.0 kB/s
>>
>>     real    0m27.860s
>>     user    0m0.001s
>>     sys     0m0.000s
>
> You are aware that you have to disable RSCNs on the _target_ port,
> right?
> Disabling RSCNs on the _initiator_ ports is a well-tested case, and
> the one which actually makes sense (and is even implemented in
> QLogic switches).
> Disabling RSCNs for the _target_ port, OTOH, has a very questionable
> nature (hence QLogic switches don't even allow you to do this).

You're right. By disabling RSCNs on target port, I've reproduced this
problem. Thank you so much. But I've encountered the bug I said
before. I'll test again with your new patchset once you send.

Thanks,
Ren

>
>
> [ .. ]
>
>> Another question:
>>
>> I also tried to produce timeouts by modifying Yasui's module(please
>> see APPENDIX A):
>> http://www.spinics.net/lists/linux-scsi/msg35091.html
>>
>> But I got a bug with your this patchset by follwing steps(there was
>> not such bug without your patchset):
>>
>> # grep lpfc_template /proc/kallsyms
>> ffffffffa00f9240 d lpfc_template    [lpfc]
>> # multipath -ll
>> ...
>> mpathb (36000b5d0006a0000006a14e7000c0000) dm-1 FUJITSU,ETERNUS_DX400
>> size=50G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> |-+- policy='round-robin 0' prio=130 status=active
>> | `- 2:0:0:1 sdf 8:80  active ready running
>> `-+- policy='round-robin 0' prio=130 status=enabled
>>    `- 3:0:0:1 sdh 8:112 active ready running
>> # insmod scsi_tmo_mod.ko param=0xffffffffa00f9240,2:0:0:1; time dd
>> if=/dev/zero of=/dev/dm-1 bs=4k count=4k oflag=direct
>> 4096+0 records in
>> 4096+0 records out
>> 16777216 bytes (17 MB) copied, 151.194 s, 111 kB/s
>>
>> real    2m31.195s
>> user    0m0.004s
>> sys    0m0.111s
>>
>> Please see logs in APPENDIX B. Do you think this bug is irrelevant to
>> your patchset?
>>
> Hmm. No, sadly not.
>
> 'cancel_work_sync' cannot be called from an interrupt context;
> guess I'll need to convert it to delayed work.
>
> Thanks for testing; will be updating the patchset.

