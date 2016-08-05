From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] aacraid: prevent out-of-bounds access due to changing
 fip header sizes
Date: Fri, 5 Aug 2016 10:05:56 +0200
Message-ID: <20160805080555.6yq4lnvs2i3up2z3@c203.arch.suse.de>
References: <1470299764-96617-1-git-send-email-jthumshirn@suse.de>
 <423FD6710FB8FB4F8728F93591889F9A15FA5D6A@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A15FA5D6A@avsrvexchmbx1.microsemi.net>
Sender: stable-owner@vger.kernel.org
To: David Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Pengfei Wang <wpengfeinudt@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 04, 2016 at 04:38:30PM +0000, David Carroll wrote:
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
> > Sent: Thursday, August 04, 2016 2:36 AM
> > To: Martin K . Petersen; James Bottomley
> > Cc: Linux SCSI Mailinglist; Pengfei Wang; Johannes Thumshirn;
> > stable@vger.kernel.org
> > Subject: [PATCH] aacraid: prevent out-of-bounds access due to changing fip
> > header sizes
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > In aacraid's ioctl_send_fib() we do two fetches from userspace, one the get the
> > fib header's size and one for the fib itself. Later we use the size field from the
> > second fetch to further process the fib. If for some reason the size from the
> > second fetch is different than from the first fix, we may encounter an out-of-
> > bounds access in aac_fib_send(). This was reported in
> > https://bugzilla.kernel.org/show_bug.cgi?id=116751 and was assigned CVE-
> > 2016-6480.
> > 
> > Reported-by: Pengfei Wang <wpengfeinudt@gmail.com>
> > Fixes: 7c00ffa31 '[SCSI] 2.6 aacraid: Variable FIB size (updated patch)'
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/aacraid/commctrl.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> > index 4b3bb52..2d4acd1 100644
> > --- a/drivers/scsi/aacraid/commctrl.c
> > +++ b/drivers/scsi/aacraid/commctrl.c
> > @@ -118,6 +118,12 @@ static int ioctl_send_fib(struct aac_dev * dev, void
> > __user *arg)
> >                 goto cleanup;
> >         }
> > 
> > +       if (size != le16_to_cpu(kfib->header.Size)
> > +                       + sizeof(struct aac_fibhdr)) {
> > +               retval = -EINVAL;
> > +               goto cleanup;
> > +       }
> > +
> >         if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
> >                 aac_adapter_interrupt(dev);
> >                 /*
> > --
> > 1.8.5.6
> > 
> 
> NAK, size is the MAX((header.size+hdr), sender_size). I will send a patch tomorrow which will insure that neither of those values is larger than size on the second fetch.
> 
> Thanks, -Dave


OK, not sure if I understood you correctly, did you mean something like that:

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index b381b37..a671b54 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -118,6 +118,10 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		goto cleanup;
 	}
 
+	size = max((le16_to_cpu(kfib->header.Size)
+		       + sizeof(struct aac_fibhdr)),
+		      le16_to_cpu(kfib->header.SenderSize));
+
 	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
 		aac_adapter_interrupt(dev);
 		/*
@@ -127,7 +131,7 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		kfib->header.XferState = 0;
 	} else {
 		retval = aac_fib_send(le16_to_cpu(kfib->header.Command), fibptr,
-				le16_to_cpu(kfib->header.Size) , FsaNormal,
+				size , FsaNormal,
 				1, 1, NULL, NULL);
 		if (retval) {
 			goto cleanup;

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
