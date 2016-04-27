From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Wed, 27 Apr 2016 07:29:26 -0700
Message-ID: <5720CCC6.70202@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
 <571FE840.1010304@sandisk.com> <57204D37.3050302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:27424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbcD0O3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 10:29:33 -0400
In-Reply-To: <57204D37.3050302@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/26/16 22:25, Douglas Gilbert wrote:
> On 2016-04-26 06:14 PM, Bart Van Assche wrote:
>> On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
>>> -    if ((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
>>> -        (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
>>> -        ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
>>> +    if (unlikely((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
>>> +             (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
>>> +             ((lba + num) > OPT_MEDIUM_ERR_ADDR))) {
>>  > [ ... ]
>>> -    if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
>>> +    if (unlikely((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE))) {
>>  > [ ... ]
>>> -    if ((qdepth > 0) && (num_in_q >= qdepth)) {
>>> +    if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
>>  > [ ... ]
>>> -    } else if ((sdebug_every_nth != 0) &&
>>> -           (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
>>> -           (scsi_result == 0)) {
>>> +    } else if (unlikely((sdebug_every_nth != 0) &&
>>> +                (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
>>> +                (scsi_result == 0))) {
>>
>> Since you are modifying this code, please remove the superfluous
>> parentheses.
>
> I can find no reference to "superfluous parentheses" in
> Documentation/CodingStyle . As for the improved readability of:
>
>             else if (unlikely(sdebug_every_nth != 0 &&
>                        SDEBUG_OPT_RARE_TSF & sdebug_opts &&
>                        scsi_result == 0)) {
> I have my doubts.

Hello Doug,

With my comment I wanted to refer to the parentheses around comparisons 
only and not to the parentheses around bitwise operations. Leaving out 
these parentheses is the most common style in the Linux kernel. But this 
is a stylistic issue only and hence not that important to me.

Bart.
