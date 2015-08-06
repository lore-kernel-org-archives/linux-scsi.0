From: Yi Zhang <yizhan@redhat.com>
Subject: Re: [dm-devel] kernel BUG at drivers/scsi/scsi_lib.c:1101! observed
 during md5sum for one file on (RAID4->RAID0) device
Date: Thu, 6 Aug 2015 02:52:45 -0400 (EDT)
Message-ID: <2095050658.4693864.1438843965011.JavaMail.zimbra@redhat.com>
References: <1710310402.852769.1438246982906.JavaMail.zimbra@redhat.com> <1438262886.2229.1.camel@HansenPartnership.com> <20150731112058.6e97b491@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48978 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbHFGwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2015 02:52:49 -0400
In-Reply-To: <20150731112058.6e97b491@noble>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>, xni@redhat.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi Neil
I test 10 times with below patch on Linux 4.2-rc5, didn't reproduce the issue, thanks.



----- Original Message -----
From: "NeilBrown" <neilb@suse.com>
To: "yizhan" <yizhan@redhat.com>
Sent: Thursday, August 6, 2015 1:21:29 PM
Subject: Re: [dm-devel] kernel BUG at drivers/scsi/scsi_lib.c:1101! observed during md5sum for one file on (RAID4->RAID0) device

On Wed, 05 Aug 2015 22:11:07 +0800 yizhan <yizhan@redhat.com> wrote:

> Hi Neil
> Could you send me one patch for this issue, I cannot apply below code, 
> thanks.

Sorry - didn't notice that had wrapped.

Try this:

http://git.neil.brown.name/?p=md.git;a=commitdiff;h=927d881980b74fa653e3992fd4a7283b0e11952b

or for that raw patch

http://git.neil.brown.name/?p=md.git;a=patch;h=927d881980b74fa653e3992fd4a7283b0e11952b

NeilBrown


Best Regards,
  Yi Zhang


----- Original Message -----
From: "NeilBrown" <neilb@suse.com>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Yi Zhang" <yizhan@redhat.com>, linux-raid@vger.kernel.org, "Jes Sorensen" <Jes.Sorensen@redhat.com>, xni@redhat.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
Sent: Friday, July 31, 2015 9:20:58 AM
Subject: Re: [dm-devel] kernel BUG at drivers/scsi/scsi_lib.c:1101! observed during md5sum for one file on (RAID4->RAID0) device

On Thu, 30 Jul 2015 06:28:06 -0700 James Bottomley
<James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2015-07-30 at 05:03 -0400, Yi Zhang wrote:
> > Hi SCSI/RAID maintainer
> > 
> > During raid test with 4.2.0-rc3, I observed below kernel BUG, pls check below info for the test log/environment/test steps.
> > 
> > Log:
> > [  306.741662] md: bind<sdb1>
> > [  306.750865] md: bind<sdc1>
> > [  306.753993] md: bind<sdd1>
> > [  306.764475] md: bind<sde1>
> > [  306.786156] md: bind<sdf1>
> > [  306.789362] md: bind<sdh1>
> > [  306.792555] md: bind<sdg1>
> > [  306.868166] raid6: sse2x1   gen() 10589 MB/s
> > [  306.889143] raid6: sse2x1   xor()  8218 MB/s
> > [  306.910121] raid6: sse2x2   gen() 13453 MB/s
> > [  306.931102] raid6: sse2x2   xor()  8990 MB/s
> > [  306.952079] raid6: sse2x4   gen() 15539 MB/s
> > [  306.973063] raid6: sse2x4   xor() 10771 MB/s
> > [  306.994039] raid6: avx2x1   gen() 20582 MB/s
> > [  307.015017] raid6: avx2x2   gen() 24019 MB/s
> > [  307.035998] raid6: avx2x4   gen() 27824 MB/s
> > [  307.040755] raid6: using algorithm avx2x4 gen() 27824 MB/s
> > [  307.046869] raid6: using avx2x2 recovery algorithm
> > [  307.058793] async_tx: api initialized (async)
> > [  307.075428] xor: automatically using best checksumming function:
> > [  307.091942]    avx       : 32008.000 MB/sec
> > [  307.147662] md: raid6 personality registered for level 6
> > [  307.153584] md: raid5 personality registered for level 5
> > [  307.159505] md: raid4 personality registered for level 4
> > [  307.165698] md/raid:md0: device sdf1 operational as raid disk 4
> > [  307.172300] md/raid:md0: device sde1 operational as raid disk 3
> > [  307.178899] md/raid:md0: device sdd1 operational as raid disk 2
> > [  307.185497] md/raid:md0: device sdc1 operational as raid disk 1
> > [  307.192093] md/raid:md0: device sdb1 operational as raid disk 0
> > [  307.199052] md/raid:md0: allocated 6482kB
> > [  307.203573] md/raid:md0: raid level 4 active with 5 out of 6 devices, algorithm 0
> > [  307.211958] md0: detected capacity change from 0 to 53645148160
> > [  307.218658] md: recovery of RAID array md0
> > [  307.223226] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> > [  307.229729] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> > [  307.240427] md: using 128k window, over a total of 10477568k.
> > [  374.670951] md: md0: recovery done.
> > [  375.722806] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
> > [  447.553364] md: unbind<sdh1>
> > [  447.559905] md: export_rdev(sdh1)
> > [  447.572684] md: cannot remove active disk sdg1 from md0 ...
> > [  447.578909] md/raid:md0: Disk failure on sdg1, disabling device.
> > [  447.578909] md/raid:md0: Operation continuing on 5 devices.
> > [  447.594850] md: unbind<sdg1>
> > [  447.601834] md: export_rdev(sdg1)
> > [  447.615446] md: raid0 personality registered for level 0
> > [  447.629275] md/raid0:md0: md_size is 104775680 sectors.
> > [  447.635094] md: RAID0 configuration for md0 - 1 zone
> > [  447.640627] md: zone0=[sdb1/sdc1/sdd1/sde1/sdf1]
> > [  447.645833]       zone-offset=         0KB, device-offset=         0KB, size=  52387840KB
> > [  447.654949] 
> > [  447.739443] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
> > [  447.749258] bio too big device sde1 (768 > 512)
> 
> This is the actual error.  It looks like an md problem (md list copied).

Thanks.  It certainly does look like an md problem.... ah, found it.

level_store in drivers/md/md.c calls blk_set_stacking_limits after
calling ->takeover and before calling ->run.
->run should impose the limits from the underlying device, but for
RAID0, ->takeover is doing that.

I can fix that... hopefully it will become irrelevant soon when the
immutable-bio patches go in.


This patch isn't quite right, but it should be pretty close.
Can you test and confirm?
Thanks,
NeilBrown

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index efb654eb5399..17804f374709 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -83,7 +83,6 @@ static int create_strip_zones(struct mddev *mddev,
struct r0conf **private_conf) char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	bool discard_supported = false;
 
 	if (!conf)
 		return -ENOMEM;
@@ -188,19 +187,12 @@ static int create_strip_zones(struct mddev
*mddev, struct r0conf **private_conf) }
 		dev[j] = rdev1;
 
-		if (mddev->queue)
-			disk_stack_limits(mddev->gendisk, rdev1->bdev,
-					  rdev1->data_offset << 9);
-
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
 			conf->has_merge_bvec = 1;
 
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
-
-		if (blk_queue_discard(bdev_get_queue(rdev1->bdev)))
-			discard_supported = true;
 	}
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "md/raid0:%s: too few disks (%d of %d)
- " @@ -272,17 +264,6 @@ static int create_strip_zones(struct mddev
*mddev, struct r0conf **private_conf) goto abort;
 	}
 
-	if (mddev->queue) {
-		blk_queue_io_min(mddev->queue, mddev->chunk_sectors <<
9);
-		blk_queue_io_opt(mddev->queue,
-				 (mddev->chunk_sectors << 9) *
mddev->raid_disks); -
-		if (!discard_supported)
-			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
mddev->queue);
-		else
-			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
mddev->queue);
-	}
-
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
@@ -433,12 +414,6 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	if (mddev->queue) {
-		blk_queue_max_hw_sectors(mddev->queue,
mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue,
mddev->chunk_sectors);
-		blk_queue_max_discard_sectors(mddev->queue,
mddev->chunk_sectors);
-	}
-
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
@@ -447,6 +422,29 @@ static int raid0_run(struct mddev *mddev)
 		mddev->private = conf;
 	}
 	conf = mddev->private;
+	if (mddev->queue) {
+		struct md_rdev *rdev;
+		bool discard_supported = false;
+
+		rdev_for_each(rdev, mddev) {
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
+			if
(blk_queue_discard(bdev_get_queue(rdev->bdev)))
+				discard_supported = true;
+		}
+		blk_queue_max_hw_sectors(mddev->queue,
mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue,
mddev->chunk_sectors);
+		blk_queue_max_discard_sectors(mddev->queue,
mddev->chunk_sectors); +
+		blk_queue_io_min(mddev->queue, mddev->chunk_sectors <<
9);
+		blk_queue_io_opt(mddev->queue,
+				 (mddev->chunk_sectors << 9) *
mddev->raid_disks); +
+		if (!discard_supported)
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
mddev->queue);
+		else
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
mddev->queue);
+	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
