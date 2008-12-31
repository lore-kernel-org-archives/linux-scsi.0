From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Wed, 31 Dec 2008 06:50:15 -0700
Message-ID: <20081231135014.GE2002@parisc-linux.org>
References: <20081223164703.GB19967@parisc-linux.org> <yq1sko4y7e4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52585 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYLaNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 08:50:31 -0500
Content-Disposition: inline
In-Reply-To: <yq1sko4y7e4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 31, 2008 at 05:18:59AM -0500, Martin K. Petersen wrote:
> I've been running with this on my DIF drives for a few days and
> everything looked fine.

You really know how to set up a sense of foreboding ;-)

> The bad news is that I have one particular drive model that after a
> failed READ CAPACITY(16) command responds correctly to READ
> CAPACITY(10).  And *then* the drive firmware commits suicide.

That's really special.  *sigh*.

> At least for DIF I have an innocuous INQUIRY field to key off of.  Long
> term I think we should check the Block Limits thin provisioning bits.

Yes, I think you're right.  At least until we find drives that put
garbage into those fields ...

> For now may I suggest a much more conservative approach:
> 
> -       if (sdp->scsi_level > SCSI_2) {
> +       if (scsi_device_protection(sdp) || sdp->scsi_level > SCSI_SPC_2) {

It was first defined in SBC-2 (2005) which corresponds to SPC-3 (also
2005), so I'm OK with this change.  I'll send updated patches (the first
patch now needs an extra NULL argument to scsi_execute_request).
Patches also available as part of this git tree:
http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20081231
aka
git://git.kernel.org/pub/scm/linux/kernel/git/willy/ssd.git trim-20081231

Here's the replacement for the second patch (I changed the line you had
above into a function so it's easier to add more conditions later).

commit de2d519582b141fb6ca4b1f6febcd93d243c3276
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sun Dec 21 13:55:05 2008 -0500

    sd: Try READ CAPACITY 16 first for SBC-2 devices
    
    New features are being added to the READ CAPACITY 16 results, so we
    want to issue it in preference to READ CAPACITY 10.  Unfortunately, some
    devices misbehave when they see a READ CAPACITY 16, so we restrict this
    command to devices which claim conformance to SPC-3 (aka SBC-2), or claim
    they have features which are only reported in the READ CAPACITY 16 data.
    
    The READ CAPACITY 16 command is optional, even for SBC-2 devices, so
    we fall back to READ CAPACITY 10 if READ CAPACITY 16 fails.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Tested-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 06bb638..ef01aad 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1416,6 +1416,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	return sector_size;
 }
 
+static int sd_try_rc16_first(struct scsi_device *sdp)
+{
+	if (sdp->scsi_level > SCSI_SPC_2)
+		return 1;
+	if (scsi_device_protection(sdp))
+		return 1;
+	return 0;
+}
+
 /*
  * read disk capacity
  */
@@ -1425,11 +1434,14 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
-	/* Force READ CAPACITY(16) when PROTECT=1 */
-	if (scsi_device_protection(sdp)) {
+	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
+		if (sector_size == -ENODEV)
+			return;
+		if (sector_size < 0)
+			sector_size = read_capacity_10(sdkp, sdp, buffer);
 		if (sector_size < 0)
 			return;
 	} else {

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
