From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Fri, 14 Feb 2014 12:37:28 +0100
Message-ID: <52FDFFF8.8030507@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de> <52F435B3.3090600@cs.wisc.edu> <52F43CD7.5050900@cs.wisc.edu> <52FB9353.7040807@suse.de> <52FB9D20.5060900@cs.wisc.edu> <52FBA0D3.50907@cs.wisc.edu> <52FBAFDE.4060104@cs.wisc.edu> <52FC90F6.7020005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:45901 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750975AbaBNLhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:37:33 -0500
In-Reply-To: <52FC90F6.7020005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/13/14 10:31, Hannes Reinecke wrote:
> On 02/12/2014 06:31 PM, Mike Christie wrote:
>> On 2/12/14 10:26 AM, Mike Christie wrote:
>>> On 2/12/14 10:11 AM, Mike Christie wrote:
>>>> On 2/12/14 9:29 AM, Hannes Reinecke wrote:
>>>>> On 02/07/2014 02:54 AM, Mike Christie wrote:
>>>>>> On 02/06/2014 07:24 PM, Mike Christie wrote:
>>>>>>> On 01/31/2014 03:29 AM, Hannes Reinecke wrote:
>>>>>>>> We should be issuing STPG synchronously as we need to
>>>>>>>> evaluate the return code on failure.
>>>>>>>>
>>>>>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>>>>>
>>>>>>> I think we need to also make dm-mpath.c use a non-ordered
>>>>>>> workqueue
>>>>>>> for
>>>>>>> kmpath_handlerd. With this patch and the current ordered
>>>>>>> workqueue in
>>>>>>> dm-mpath I think we will only be able to do one STPG at a time. I
>>>>>>> think
>>>>>>> if we use a normal old non-ordered workqueue then we would be
>>>>>>> limited to
>>>>>>> have max_active STPGs executing.
>>>>>>
>>>>>> I goofed and commented in the order I saw the patches :) I take
>>>>>> this
>>>>>> comment back for this patch, because I see in 16/16 you added a
>>>>>> new
>>>>>> workqueue to scsi_dh_alua to do rtpgs and stpgs.
>>>>>>
>>>>>> For 16/16 though, do we want to make kmpath_aluad a non single
>>>>>> threaded
>>>>>> workqueue? It looks like max_active for single threaded is only
>>>>>> one
>>>>>> work
>>>>>> at a time too.
>>>>>>
>>>>> Well, that was by intention.
>>>>>
>>>>> The workqueue will be triggered very infrequently (basically for
>>>>> every path switch).
>>>>> For implicit ALUA we just need to issue a RTPG to get the new path
>>>>> status; there we might be suffering from single threaded behaviour.
>>>>> But we need to issue it only once and it should be processed
>>>>> reasonably fast.
>>>>> For explicit ALUA we'll have to send an STPG, which has potentially
>>>>> system-wide implications. So sending several to (supposedly)
>>>>> different targets might actually be contraproductive, as the first
>>>>> might have already set the status for the second call.
>>>>> Here we most definitely _want_ serialisation to avoid
>>>>> superfluous STPGs.
>>>>>
>>>>
>>>> What target is this?
>>>>
>>>> For our target it adds a regression. It only affects devices on
>>>> the same
>>>> port group. We then have multiple groups. Before the patch, we could
>>>> failover/failback multiple devices in parallel. To do 64 devices
>>>> it took
>>>> about 3 seconds. With your patch it takes around 3 minutes.
>>>>
>>>
>>> Also, with your pg change patch, I think we can serialize based on
>>> group
>>> and it will do what you want and also allow us to do STPGs to
>>> different
>>> groups in parallel.
>>
>> I guess that would work for me, but I think if you had the same
>> target port in multiple port groups then you could hit the issue you
>> described, right?
>>
> Yes, we might. But it's worth a shot anyway.
> 
> So to alleviate all this, this patch:
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_ha
> ndler/scsi_dh_alua.c
> index 569af9d..46cc1ef 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1353,7 +1353,7 @@ static int __init alua_init(void)
>  {
>         int r;
> 
> -       kmpath_aluad = create_singlethread_workqueue("kmpath_aluad");
> +       kmpath_aluad = create_workqueue("kmpath_aluad");
>         if (!kmpath_aluad) {
>                 printk(KERN_ERR "kmpath_aluad creation failed.\n");
>                 return -EINVAL;
> 
> should be sufficient, right?

I think this will only be sufficient if there are more CPU threads
available than the number of LUNs for which an STPG has to be issued.
My preference is also to keep the asynchronous invocation of the STPG
commands to avoid introducing a regression if the number of LUNs that
has to be failed over is large. Has it been considered to add the "if
(err == SCSI_DH_RETRY) err = alua_rtpg(sdev, h)" code in the
stpg_endio() handler, together with a counter mechanism that prevents
infinite retries ? And if a storage array reports that the target portal
group state is transitioning, shouldn't the retry be delayed instead of
submitting it immediately ?

Bart.

