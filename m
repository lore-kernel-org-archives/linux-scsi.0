From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Wed, 27 Apr 2016 01:25:11 -0400
Message-ID: <57204D37.3050302@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
 <571FE840.1010304@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35875 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbcD0FZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 01:25:16 -0400
In-Reply-To: <571FE840.1010304@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 2016-04-26 06:14 PM, Bart Van Assche wrote:
> On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
>> -    if ((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
>> -        (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
>> -        ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
>> +    if (unlikely((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
>> +             (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
>> +             ((lba + num) > OPT_MEDIUM_ERR_ADDR))) {
>  > [ ... ]
>> -    if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
>> +    if (unlikely((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE))) {
>  > [ ... ]
>> -    if ((qdepth > 0) && (num_in_q >= qdepth)) {
>> +    if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
>  > [ ... ]
>> -    } else if ((sdebug_every_nth != 0) &&
>> -           (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
>> -           (scsi_result == 0)) {
>> +    } else if (unlikely((sdebug_every_nth != 0) &&
>> +                (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
>> +                (scsi_result == 0))) {
>
> Since you are modifying this code, please remove the superfluous parentheses.

I can find no reference to "superfluous parentheses" in
Documentation/CodingStyle . As for the improved readability of:

            else if (unlikely(sdebug_every_nth != 0 &&
                       SDEBUG_OPT_RARE_TSF & sdebug_opts &&
                       scsi_result == 0)) {
I have my doubts.

>  > -    struct sdebug_host_info * sdbg_host;
>  > -    struct sdebug_dev_info * open_devip = NULL;
>  > -    struct sdebug_dev_info * devip =
>  > -            (struct sdebug_dev_info *)sdev->hostdata;
>  > +    struct sdebug_host_info *sdbg_host;
>  > +    struct sdebug_dev_info *open_devip = NULL;
>  > +    struct sdebug_dev_info *devip;
>  >
>  > -    if (devip)
>  > -        return devip;
>
> Has this change been described in the patch description?

The function was previously called devInfoReg() and was called
irrespective of whether a suitable sdebug_dev_info instance
existed or not. So that function call just wasted time if an
instance existed. That function is replaced by
find_build_dev_info() which is only called when non trivial work
is needed. Its invocation looks like this:
         if (NULL == devip) {
                 devip = find_build_dev_info(sdp);
                 if (NULL == devip)
                         return 1;  /* no resources, will be marked offline */
         }

Do all re-factorings of code need a patch description?

>> @@ -4632,9 +4617,11 @@ static int __init scsi_debug_init(void)
>>       switch (sdebug_dif) {
>>
>>       case SD_DIF_TYPE0_PROTECTION:
>> +        break;
>>       case SD_DIF_TYPE1_PROTECTION:
>>       case SD_DIF_TYPE2_PROTECTION:
>>       case SD_DIF_TYPE3_PROTECTION:
>> +        have_dif_prot = true;
>>           break;
>
> Same comment for this code: has this change been explained in the patch
> description?

The code previously did things like
         if (!sdebug_dif) { /* whatever */ }
which annoyed me because it relied on knowing that the badly
named SD_DIF_TYPE0_PROTECTION (which is _no_ protection) has
the value 0. So I introduced a bool at file scope (thus it is
initialized to false and checkpatch.pl complains if that is
stated explicitly). The above code is where the bool (i.e.
have_dif_prot) is set.

Doug Gilbert

