From: James Bottomley <James.Bottomley@Hansenpartnership.com>
Subject: Re: SCSI regression in 4.11
Date: Thu, 02 Mar 2017 11:18:23 -0800
Message-ID: <1b325703-b823-4304-9d9d-86071811e000@email.android.com>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk> <1488301573.3046.9.camel@linux.vnet.ibm.com> <20170228105741.6253bb8a@xeon-e3> <1488325732.11610.9.camel@linux.vnet.ibm.com> <20170228172532.280811ed@xeon-e3> <1488349258.20321.11.camel@linux.vnet.ibm.com> <20170228224845.1da358ee@xeon-e3> <20170301155057.GA13167@lst.de> <20170301075412.2e5f1e98@xeon-e3> <20170302000135.GA22886@lst.de> <20170302005615.GA23687@lst.de> <20170301174058.383da142@xeon-e3> <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de> <20170302102324.47dbe3ad@xeon-e3> <895c4f2e-7faa-41e1-b5de-eedb4ae0f882@email.android.com> <20170302110505.6ad2eb61@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44276 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750736AbdCBTxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 14:53:16 -0500
In-Reply-To: <20170302110505.6ad2eb61@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On March 2, 2017 11:05:05 AM PST, Stephen Hemminger <stephen@networkplumber.org> wrote:
>On Thu, 02 Mar 2017 10:36:17 -0800
>James Bottomley <James.Bottomley@Hansenpartnership.com> wrote:
>
>> On March 2, 2017 10:23:24 AM PST, Stephen Hemminger
><stephen@networkplumber.org> wrote:
>> >On Thu, 2 Mar 2017 14:25:14 +0100
>> >Hannes Reinecke <hare@suse.de> wrote:
>> >  
>> >> On 03/02/2017 02:40 AM, Stephen Hemminger wrote:  
>> >> > On Thu, 2 Mar 2017 01:56:15 +0100
>> >> > Christoph Hellwig <hch@lst.de> wrote:
>> >> >    
>> >> >> On Thu, Mar 02, 2017 at 01:01:35AM +0100, Christoph Hellwig
>wrote:  
>> >   
>> >> >>> On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger  
>> >wrote:    
>> >> >>>>>  
>>
>>	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4
>> >   
>> >> >>>>
>> >> >>>> It appears that is already in the code I am testing in  
>> >linux-next...    
>> >> >>>
>> >> >>> It's in -next now, but it wasn't at the time you reported the 
>
>> >bug.  
>> >> >>>
>> >> >>> And it would sortof explain the bug if the INQUIRY data is  
>> >correct  
>> >> >>> in the scatterlist, but we ignore it, given that
>scsi_probe_lun
>> >> >>> ignores the result based on sense data.
>> >> >>>
>> >> >>> Can you check what happens with the horrible hack below:    
>> >> >>
>> >> >> Strike that - we're checking result later, so this can't be the
> 
>> >case.  
>> >> >>
>> >> >> Now the other interesting thing is the memset in
>__scsi_exectute,
>> >> >> which looks very suspicious.  Try the following please:
>> >> >>
>> >> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> >> >> index 3e32dc954c3c..22f4fb550561 100644
>> >> >> --- a/drivers/scsi/scsi_lib.c
>> >> >> +++ b/drivers/scsi/scsi_lib.c
>> >> >> @@ -253,7 +253,8 @@ static int __scsi_execute(struct
>scsi_device  
>> >*sdev, const unsigned char *cmd,  
>> >> >>  	 * and prevent security leaks by zeroing out the excess data.
>> >> >>  	 */
>> >> >>  	if (unlikely(rq->resid_len > 0 && rq->resid_len <= bufflen))
>> >> >> -		memset(buffer + (bufflen - rq->resid_len), 0,
>rq->resid_len);
>> >> >> +//		memset(buffer + (bufflen - rq->resid_len), 0,
>rq->resid_len);
>> >> >> +		printk_ratelimited("%s: got resid %d\n", __func__,  
>> >rq->resid_len);  
>> >> >>
>> >> >>  	if (resid)
>> >> >>  		*resid = rq->resid_len;    
>> >> >
>> >> >
>> >> > Still fails but does print resid on some of the later INQUIRY  
>> >commands (not the initial one).  
>> >> >    
>> >> Can you test what happens if you blank out the storvsc_drv  
>> >workaround:  
>> >> 
>> >> diff --git a/drivers/scsi/storvsc_drv.c
>b/drivers/scsi/storvsc_drv.c
>> >> index 585e54f..c36f42d 100644
>> >> --- a/drivers/scsi/storvsc_drv.c
>> >> +++ b/drivers/scsi/storvsc_drv.c
>> >> @@ -1060,13 +1060,13 @@ static void
>storvsc_on_io_completion(struct 
>> >> storvsc_device *stor_device,
>> >>           * We do this so we can distinguish truly fatal failues
>> >>           * (srb status == 0x4) and off-line the device in that
>case.
>> >>           */
>> >> -
>> >> +#if 0
>> >>          if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
>> >>             (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
>> >>                  vstor_packet->vm_srb.scsi_status = 0;
>> >>                  vstor_packet->vm_srb.srb_status =  
>> >SRB_STATUS_SUCCESS;  
>> >>          }
>> >> -
>> >> +#endif
>> >> 
>> >>          /* Copy over the status...etc */
>> >>          stor_pkt->vm_srb.scsi_status =  
>> >vstor_packet->vm_srb.scsi_status;  
>> >> 
>> >> It might thappen that we're fail to interpret the 'Device not  
>> >present'   
>> >> status correctly (which will happen for non-connected DVDs)
>causing  
>> >the   
>> >> SCSI stack to make incorrect decisions later on.
>> >> 
>> >> Cheers,
>> >> 
>> >> Hannes  
>> >
>> >There are several oddities about the host SCSI interface that I see:
>> > 1. The host bus seems to report up to 6 devices even though only 2
>are
>> >     present (Disk and CDROM).
>> >2. The CDROM emulation doesn't report the same status as a real
>device.
>> > 3. The host emulation of SCSI doesn't support all the page codes
>which
>> >     is why there is the hack.
>> >
>> >But as James said, these don't appear to be related to the failure
>> >because
>> >the code worked before and only in post 4.11 merege is there a
>problem.  
>> 
>> Your wait for the hang trace is the most suggestive.   It says we're
>waiting for a partition read to the spurious device.  Previously this
>would have failed or timed out, so this seems to be the root cause.
>> 
>> James
>> 
>> 
>
>Where is the number of valid LUN's determined during the scan process?

Depends.  If you can do a report lun scan then that's definitive.  You seem to be probing (SCSI_probe_and_add_lun)  and you make us think there's something there by responding wrongly to the initial inquiry.

James




-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
