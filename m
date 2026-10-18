Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F714C8C5A
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792331991; cv=none; b=k9HipdBxZyeDM54fgL4Sj8JLus1GuV+CrDJcbXH7Euxu4UPokqt2tqOkJN/PdmCYGjcQIk4mYd5cTu9WbYlBvm4+mJCym/SMMjcx5HjNeuLL5yLv3oH43BcNlbZHZ62VYOc7/b9aTiywTirXlWWGLbHUvM/VCjJysAKZFFQ4JBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792331991; c=relaxed/simple;
	bh=8+dudQneRtlky3L0134Uq63K6jUPTy15f15f59Dl2JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eeOXg2uZZdGsJ5d3p82bVLce9XeytW0JDnWkF1wrFn3SRXxePa28dnM1IWLsUQVsJBqQxF9PxwaAlHNKLyZuSsOnsEwr9hu7KwmihSMT/lYZ69C4/BqIJ1dPvxArFMfYOtyFCoj/GhpF9wNDSHhm63g9i7qIhyN1/QSFOQGR7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=k0BaWAeN; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="k0BaWAeN"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1215231a91.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 06:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792331987; x=1792936787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TfIM6O5XGdPMggK0iswqZ9O/3wNWaaWuby0Fr894zwY=;
        b=k0BaWAeNPfZXhxMf4MJ8V7Tw2vl9R2PUPGSlaRy79qs3r96Qg3re0F0U6ZOE/Z7zWF
         aOCqtMVHxrUs6YEje2YWPqamyYnC/HL0xPswbRf132ToWKcpuDNDHSgu0YmIt9jkMR+V
         UmTIxs62vQ1tEzId3UcJCFeKZRlCH/+1P2zYhUMQntONodK3DnqM7wX9g9CFHm+BcGUN
         l2bwLTcRzBR3P7w+Eat8/sT+trU32uzcXay/GxGYxUu8UyDAOHIMADU6jfICzTwSmw0i
         vsqOe0BsMkRPeAdfnzxALdEvrwMBNPFmfIE4dJ6q2uCB4QK6bDVNeiYzT6kdzM9gAoIU
         fBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792331987; x=1792936787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TfIM6O5XGdPMggK0iswqZ9O/3wNWaaWuby0Fr894zwY=;
        b=HsabOlcZewGM2qJT90u+T5bYoe2D8tYASorVbdGZNHzMme0uvgTbnIqy0t6L1Nt1NR
         AvAbBeE4nNWfWSF6VrvyPniX0SoaAirSIJoyJOMZxUxfVGM1K7FMxIZqLDCIsVSiCvpq
         qdTilSh4P9AzoiAPIhmfME+UHaZ9j7qROoIRDzIRW/F/Gfv5z0l6qAv4SbQVH8K8+syG
         rs/A8lDIBoeysyFTA8shtrNy0l0zd0zKWiT0uNbJFwhAxQuuOraIyLf2r0J4S8qfdn5s
         piVltCw7K6l8KZmUoWUDBx3xpZTvstSFQtXYk/WcWaADLGYg8s6D54z68S5UAZLn+GI4
         qkNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwBoOZj5aYD99FYHNxUhvdXutGVxbgoWLWn5VJdamxPpIfixyYsy4AY4G2nrzplY58rFqNJ4aLG6Pvq@vger.kernel.org
X-Gm-Message-State: AFq9FYIOF5uJYsh87p7URs0T2UQgB2z85bVWdwe1gnAvHqrh9Xh/n5r9
	PRQ/gKnGekEpbO60gL1YJMIUjigYdN4A2l21vZsjDJnZpHLhWPp8ItbtEeQPi10e4b6mA+wm6CT
	GhOro
X-Gm-Gg: AYBFou34zHREOuwb+WOb0z3GjPB87MjNbBgzX1Yc6Nx5MBblpGVdb48S3PMBJhnPnnc
	MiZDzUDnwGZhqyzyBJPkU1hvZ9PAHZS6UBIH3Iw4XX4HzzGVYr9rTU7GimLNazDq2L3jltf2QX+
	rg1ShfYC3keagO+s/3Oo6CpFWD6qpZxe2DMeVmqqsFSN9+Cgus2NbCeB37f1FPGONBkZeEvWm8S
	EWoolFWF+1EvykQf0ClrdoEY7792avZSpSW6qNRV5b9COIU2sZdNbgiIWMCxcSFUa4vxQhmfeSy
	QxSQcZIgTZ0HHulJ0+3oLMW6i6Qw/AcOdQa2BqzGYhNcCVF7tWhsceMxb+J2msLVpx2YdHPRwYR
	90efewKnuxyS4Y6Gdx1lwn473aJQxXbU1OEbsLHNEWU/c3Bz8l73m9saUxXszC+ATp+Us2SA8K3
	QvOLmgiM4dvCnOLl7Yjkzq9mbfmf4UKilFUKtJVIN/uAIk7tQTx9P6HN5JGZ+5mkzN9AQ+/E+Wm
	+jRY3mHwtfp/sfM6Rbp6A==
X-Received: by 2002:a17:90b:1806:b0:3ab:e588:c2a8 with SMTP id 98e67ed59e1d1-3acef538909mr4550140a91.64.1792331986138;
        Sun, 18 Oct 2026 06:59:46 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:6c71:58da:ec95:3c04])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm16263797a91.11.2026.10.18.06.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 06:59:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Karan Tilak Kumar <kartilak@cisco.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: snic: reject a target count larger than the response buffer
Date: Sun, 18 Oct 2026 22:59:30 +0900
Message-ID: <20261018135930.3190279-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

snic_queue_report_tgt_req() sizes the REPORT TARGETS response buffer for
min(fwinfo.max_tgts, shost->max_id) entries.  The completion handler walks
that buffer for as many entries as the adapter reports in tgt_cnt, and the
only thing in the way is

	SNIC_BUG_ON(tgt_cnt > snic->fwinfo.max_tgts);

which compares against the adapter's exchange-version value rather than
the bound the allocation was built with, and which is a WARN_ON_ONCE in
any build without DEBUG, so it falls through into the walk.  An adapter
reporting more targets than were asked for reads past the buffer, and the
count is also stored for snic_handle_tgt_disc() to walk a second time and
create a target per entry.

The same exchange-version handler already clamps max_sgs_per_cmd against a
driver limit; max_tgts is taken as it arrives.

Compare the reported count against the bound the request was built with,
and fail the completion the way an empty target list is already failed.

I have no Cisco VIC hardware; the completion is injected under a KUnit
harness so that the adapter reports 259 targets for a 256-entry request.
The W taint below is the UML test machine's own virtio_pcidev warning:

BUG: KASAN: slab-out-of-bounds in snic_report_tgt_cmpl_handler+0x266/0x410
Read of size 4 at addr 00000000622c0810 by task kunit_try_catch/20

CPU: 0 UID: 0 PID: 20 Comm: kunit_try_catch Tainted: G        W        N  7.3.0-rc7-g58161ead29e5-dirty #7 VOLUNTARY
Tainted: [W]=WARN, [N]=TEST
Stack:
60d4e7dc 6220f200 622c20d8 00000000
ffffff00 60d4e7dc 60d56045 622c0810
60dcd680 6009aac3 622cfce0 6003e621
Call Trace:
[<6009aac3>] ? dump_stack_lvl+0x5e/0x7a
[<6003e621>] ? _printk+0x0/0xd7
[<6004b21d>] ? print_report+0x14b/0x517
[<603bdf3b>] ? kasan_save_track+0x1b/0x40
[<6003e621>] ? _printk+0x0/0xd7
[<600897a3>] ? snic_report_tgt_cmpl_handler+0x266/0x410
[<603beebb>] ? kasan_report+0x11b/0x160
[<600897a3>] ? snic_report_tgt_cmpl_handler+0x266/0x410
[<60073dad>] ? _dev_printk+0x0/0xe8
[<600897a3>] ? snic_report_tgt_cmpl_handler+0x266/0x410
[<6008a11c>] ? snic_lt_silent_overrun.cold+0x46/0x4da
[<6089d880>] ? snic_lt_silent_overrun+0x0/0x330
[<600bf62d>] ? os_nsecs+0x2d/0x40
[<600a16a4>] ? timer_read+0x14/0x30
[<602235de>] ? ktime_get_ts64+0x8e/0x2c0
[<60223550>] ? ktime_get_ts64+0x0/0x2c0
[<606fa06c>] ? kunit_try_run_case+0x1bc/0x310
[<606f9eb0>] ? kunit_try_run_case+0x0/0x310
[<603c08f0>] ? __kasan_check_read+0x0/0x20
[<600bf020>] ? um_set_signals+0x0/0x60
[<600bf020>] ? um_set_signals+0x0/0x60
[<6013e3cd>] ? __kthread_parkme+0xdd/0x1c0
[<606f9eb0>] ? kunit_try_run_case+0x0/0x310
[<60700130>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
[<607001ac>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
[<6014464e>] ? kthread+0x36e/0x560
[<601442e0>] ? kthread+0x0/0x560
[<6009f0de>] ? new_thread_handler+0xce/0x130

The buggy address belongs to the object at 00000000622c0000
which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes to the right of
allocated 2064-byte region [00000000622c0000, 00000000622c0810)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22c0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x40(head|zone=0)
page_type: f5(slab)
raw: 0000000000000040 0000000061402140 0000000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000000f5000000
head: 0000000000000040 0000000061402140 0000000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000003
head: 000000009f279a01 00000000ffffffff 00000000ffffffff 0000000000000000
head: 0000000000000000 00000000ffffffff
page dumped because: kasan: bad access detected

Memory state around the buggy address:
00000000622c0700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000000622c0780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>00000000622c0800: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                        ^
00000000622c0880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
00000000622c0900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/snic/snic_disc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 71d34a702f2ab..df7da6413f84a 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -385,7 +385,7 @@ snic_report_tgt_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 {
 
 	u8 typ, cmpl_stat;
-	u32 cmnd_id, hid, tgt_cnt = 0;
+	u32 cmnd_id, hid, tgt_cnt = 0, ntgts;
 	ulong ctx;
 	struct snic_req_info *rqi = NULL;
 	struct snic_tgt_id *tgtid;
@@ -406,7 +406,19 @@ snic_report_tgt_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	/* printing list of targets here */
 	SNIC_HOST_INFO(snic->shost, "Target Count = %d\n", tgt_cnt);
 
-	SNIC_BUG_ON(tgt_cnt > snic->fwinfo.max_tgts);
+	if (snic->fwinfo.max_tgts)
+		ntgts = min_t(u32, snic->fwinfo.max_tgts, snic->shost->max_id);
+	else
+		ntgts = snic->shost->max_id;
+
+	if (tgt_cnt > ntgts) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Target count %u exceeds the %u requested.\n",
+			      tgt_cnt, ntgts);
+		ret = 1;
+
+		goto end;
+	}
 
 	for (i = 0; i < tgt_cnt; i++)
 		SNIC_HOST_INFO(snic->shost,
-- 
2.43.0

