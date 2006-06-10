From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 6657] New: Domain validation failures on
	aic7xxx
Date: Sat, 10 Jun 2006 11:26:00 -0500
Message-ID: <1149956760.3335.18.camel@mulgrave.il.steeleye.com>
References: <20060606091840.a39afe5a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35244 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751578AbWFJQ0p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:26:45 -0400
In-Reply-To: <20060606091840.a39afe5a.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin J. Bligh" <mbligh@mbligh.org>, william@brodie-tyrrell.org, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-06-06 at 09:18 -0700, Andrew Morton wrote:
> Apparently a regression.
> 
> (I thought the plan was to make scsi_drivers-other@kernel-bugs.osdl.org
> auto-forward stuff to linux-scsi?)

It is ... let me go and give mbligh a swift kick [administered by this
email] to see if I can get him to move on this.

> In 2.6.14 and 2.6.16 I get domain validation errors on my WD18310 connected to a
> 19160, causing it to drop back to asynchronous rather than 40 or 80MHz wide.  
> 
> Domain validation reports parity errors, write buffer failures, performs resets
> and generally stuffs around for a few minutes before deciding it will allow async.
> 
> I have 2 other discs (Seagate SX118202LS) attached to the same chain which still
> work.  My scsi system works perfectly in 2.6.10 with no data corruption.

I'd say that's pretty conclusive. The theory being that the WD doesn't
have a functional echo buffer, or it lies about the size and in either
case we get errors back not because of a syndrome test failure but
because of a problem in the WD echo buffer.

Try this patch for diagnosis only ... what it's doing is disabling the
echo buffer tests globally.  If everything boots up OK (please send
dmesg output so I can see what the echo buffer length is), then we get
to try to figure out if the WD can do any echo buffer tests or if it has
to be globally blacklisted (not fun ... LVD really shouldn't be
configured without the echo buffer test of the transmission line).

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 780aaed..88bb4ff 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -859,7 +859,9 @@ spi_dv_device_internal(struct scsi_devic
 	if (len == -1 && spi_dt(starget))
 		len = spi_dv_device_get_echo_buffer(sdev, buffer);
 
-	if (len <= 0) {
+	starget_printk(KERN_INFO, starget, "Echo buffer length %d\n", len);
+
+	if (1) {
 		starget_printk(KERN_INFO, starget, "Domain Validation skipping write tests\n");
 		return;
 	}


