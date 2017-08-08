From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] megaraid_sas: move command counter to correct place
Date: Tue, 08 Aug 2017 08:39:17 -0700
Message-ID: <1502206757.2736.21.camel@HansenPartnership.com>
References: <20170728140359.15424-1-thenzl@redhat.com>
         <yq1lgmv9t51.fsf@oracle.com>
         <730abe70a796241670b9443bd72e395b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52680 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752565AbdHHPjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 11:39:19 -0400
In-Reply-To: <730abe70a796241670b9443bd72e395b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>

On Tue, 2017-08-08 at 13:07 +0530, Sumit Saxena wrote:
> > 
> > -----Original Message-----
> > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > Sent: Monday, August 07, 2017 11:07 PM
> > To: Tomas Henzl
> > Cc: linux-scsi@vger.kernel.org; sumit.saxena@broadcom.com;
> > kashyap.desai@broadcom.com
> > Subject: Re: [PATCH] megaraid_sas: move command counter to correct
> > place
> > 
> > 
> > Tomas,
> > 
> > > 
> > > the eh reset function returns success when fw_outstanding equals
> > > zero,
> > > that means that the counter shouldn't be decremented when the
> > > driver
> > > still owns the command
> > 
> > Applied to 4.13/scsi-fixes. Thank you!
> 
> Just realized that this patch may cause performance regression.
> With this patch below scenario may occur-
> 
> -Consider outstanding IOs reaches to controller's Queue depth.
> -Driver frees up command and complete it back to SML.
> -Since host_busy is decremented, SML can issue one new  IO to driver.
> -By the time, if "fw_outstanding" is not decremented by driver, then
> driver will return newly submitted IO back to SML with return status
> SCSI_MLQUEUE_HOST_BUSY because of below code
>   in megaraid_sas driver's IO submission path-
> 
>     if (atomic_inc_return(&instance->fw_outstanding) >
>             instance->host->can_queue) {
>         atomic_dec(&instance->fw_outstanding);
>         return SCSI_MLQUEUE_HOST_BUSY;
>     }
> 
> This situation will be more evident when RAID1 fastpath IOs are
> running as in that case driver will be issuing two IOs to firmware
> for single IO issued from SML. Above situation can be avoided, if
> this patch is removed.
> 
> Regarding Tomas' concern, there should not be any problem as driver
> calls "synchronize_irq" before checking "fw_outstanding". Once
> fw_outstanding is decremented and driver frees up command, then only
> driver will be checking "fw_outstanding" equals to zero or not so all
> this will always fall in a sequence and will not cause the problem
> stated by Tomas.
> 
> I am sorry for confusion and would request to revert this patch.

OK, I've taken it out of the fixes tree.

Martin: this means my fixes branch got rebased; can you rebase your
fixes branch on top of mine before we all get a beating from Stephen
Rothwell because of a mismerge in linux-next due to the tree
differences?

Thanks,

James
