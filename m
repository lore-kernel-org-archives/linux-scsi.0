From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Wed, 26 Aug 2015 15:52:35 -0700
Message-ID: <1440629555.2196.92.camel@HansenPartnership.com>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
		<CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>
		<55DAB673.10903@suse.de>
	 <CAOMFOmUHzLad4wLMJdAxj+CPKM_GCY3dTZUqpD2icoEJKdJ8uw@mail.gmail.com>
	 <55DD5F45.7010905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49876 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbbHZWwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 18:52:37 -0400
In-Reply-To: <55DD5F45.7010905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de, Tejun Heo <tj@kernel.org>

On Wed, 2015-08-26 at 08:40 +0200, Hannes Reinecke wrote:
> On 08/26/2015 06:53 AM, Anatol Pomozov wrote:
> > Hi
> > 
> > On Sun, Aug 23, 2015 at 11:15 PM, Hannes Reinecke <hare@suse.de> wrote:
> >>> I looked at this commit and it actually adds SMR support to SCSI
> >>> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
> >>> algorithms. It is suboptimal but still much better than IO failures
> >>> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors I see
> >>> at my computer.
> >>>
> >>> If this SMR support is considered as non-stable, can we at least get a
> >>> kernel boot (or config) option that disables ZAC?
> >>>
> >> Again: Has anybody actually _tested_ that reverting this patch fixes
> >> this issue?
> > 
> > Yes I tested it.
> > 
> > This error happens only under heavy load with a lot of read/writes
> > (like btrfs rebalance).
> > 
> > With current Linux-4.1.6 'btrfs balance' fails after ~10 minutes after
> > start. I reverted ZAC related changes and then ran rebalancing. The
> > operation finished successfully after 3 hours of running.
> > 
> Can you be a bit more specific about the 'ZAC related changes'?
> There have been several patches, and we really would need to know
> which one was the offending one.
> Can you try to bisect things here?

OK, let's stop shooting the messenger here.  There are multiple reports
of this problem.  The pattern seems to be some type of error causes
everything to die.

There looks to be an obvious bug in
9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb in that there's no
ATA_DEV_ZAC_UNSUP class which means that any attempt to disable the
device pushes it up to ATA_DEV_NONE.  I'm not sure ... don't have time
to follow the code ... but doesn't this interfere with the speed
dropping routines which seems to disable then re-enable the device?
Does adding ATA_DEV_ZAC_UNSUP fix this problem? patch (compile tested
only) below.

James

---

diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index d6c37bc..fa83320 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -144,6 +144,7 @@ static struct {
 	{ ATA_DEV_SEMB,			"semb" },
 	{ ATA_DEV_SEMB_UNSUP,		"semb" },
 	{ ATA_DEV_ZAC,			"zac" },
+	{ ATA_DEV_ZAC_UNSUP,		"zac" },
 	{ ATA_DEV_NONE,			"none" }
 };
 ata_bitfield_name_search(class, ata_class_names)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 36ce37b..49c5b98 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -191,7 +191,8 @@ enum {
 	ATA_DEV_SEMB		= 7,	/* SEMB */
 	ATA_DEV_SEMB_UNSUP	= 8,	/* SEMB (unsupported) */
 	ATA_DEV_ZAC		= 9,	/* ZAC device */
-	ATA_DEV_NONE		= 10,	/* no device */
+	ATA_DEV_ZAC_UNSUP	= 10,	/* ZAC (unsupported) */
+	ATA_DEV_NONE		= 11,	/* no device */
 
 	/* struct ata_link flags */
 	ATA_LFLAG_NO_HRST	= (1 << 1), /* avoid hardreset */
@@ -1517,7 +1518,8 @@ static inline unsigned int ata_class_enabled(unsigned int class)
 static inline unsigned int ata_class_disabled(unsigned int class)
 {
 	return class == ATA_DEV_ATA_UNSUP || class == ATA_DEV_ATAPI_UNSUP ||
-		class == ATA_DEV_PMP_UNSUP || class == ATA_DEV_SEMB_UNSUP;
+		class == ATA_DEV_PMP_UNSUP || class == ATA_DEV_SEMB_UNSUP ||
+		class == ATA_DEV_ZAC_UNSUP;
 }
 
 static inline unsigned int ata_class_absent(unsigned int class)


