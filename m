From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Thu, 10 Nov 2011 10:06:18 -0600
Message-ID: <1320941178.11745.11.camel@dabdike.int.hansenpartnership.com>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	 <1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	 <4EBBF307.4070000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EBBF307.4070000@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, LKML <linux-kernel@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-11-10 at 16:51 +0100, Steffen Maier wrote:
> On 11/07/2011 03:51 PM, James Bottomley wrote:
> > On Mon, 2011-11-07 at 17:24 +1100, Stephen Rothwell wrote:
> 
> >> WARNING: at drivers/scsi/scsi_lib.c:1704
> 
> >> I get lots more of these.  The obvious commit to point the finger at
> >> is 3308511c93e6 ("[SCSI] Make scsi_free_queue() kill pending SCSI
> >> commands") but the root cause may be something different.
> >
> > Actually, I don't think it's anything to do with this: it's Anton's
> > fault
> >
> > commit f7c9c6bb14f3104608a3a83cadea10a6943d2804
> > Author: Anton Blanchard<anton@samba.org>
> > Date:   Thu Nov 3 08:56:22 2011 +1100
> >
> >      [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sdev
> >
> > Doesn't completely do the teardown.  The true fix is to do a proper
> > teardown instead of hand rolling it.  Does this fix it for you?
> >
> > James
> >
> > ---
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 72273a0..b3c6d95 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -319,11 +319,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
> >   	return sdev;
> >
> >   out_device_destroy:
> > -	scsi_device_set_state(sdev, SDEV_DEL);
> > -	transport_destroy_device(&sdev->sdev_gendev);
> > -	put_device(&sdev->sdev_dev);
> > -	scsi_free_queue(sdev->request_queue);
> > -	put_device(&sdev->sdev_gendev);
> > +	__scsi_remove_device(sdev);
> >   out:
> >   	if (display_failure_msg)
> >   		printk(ALLOC_FAILURE_MSG, __func__);
> 
> James, is it OK that __scsi_remove_device() now also calls 
> sdev->host->hostt->slave_destroy(sdev) which wasn't there before?
> 
> I cannot prove it yet, but with this patch and some asorted others on 
> top of 3.1 our zfcp LLD gets called with an sdev argument that was freed 
> before or at least before dereferencing (found with DEBUG_PAGEALLOC).

You can argue it either way, but we're supposed to pair slave_destroy
with slave_alloc and we already called the latter.

zfcp just unconditionally assumes that if destroy is called, the
allocation returned success.  This fixes it, doesn't it?

James

---

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 11f07f8..4008ec0 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -55,8 +55,10 @@ static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
-	put_device(&zfcp_sdev->port->dev);
+	if (zfcp_sdev->port) {
+		zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
+		put_device(&zfcp_sdev->port->dev);
+	}
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
