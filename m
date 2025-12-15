Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BAD313525;
	Mon, 15 Dec 2025 08:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765788939; cv=none; b=JYA/wAoBvcdhKmWZFPS8pmbVBXGkbZFF68ceoA66oX0/z+v9Fmtc3HlChA0+orra8ylG00ZH9nVSpaOafDjQA+fQxnqtc9XFd4gLhZwM+2kqf0iGc5oZqseKdDMR6i1zAO5AUvpTfrEKwEZLtGjAsXDVrep4vDjw+JIcskM9B/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765788939; c=relaxed/simple;
	bh=mKOVBT8Z5U1vkTW9JyaQUhTZ30gcz6nEmR1z2tTAagI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Eg8RuM935yhDE88TbAnEzBGey6kAqSkMjZ1xotrEmw+xsXcSarKpez+96HRutfw9ckBkF4yIrW38woBv0EagjBk9oZfAUZkVG5xhB5zL46RY9SmarDWzeZgnDktW4x7pjCWeuaaEUEhUrkV2wX0Qns7G3g2aurmZq8UvaO76YlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6bhVDck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6bhVDck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C506C4CEF5;
	Mon, 15 Dec 2025 08:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765788939;
	bh=mKOVBT8Z5U1vkTW9JyaQUhTZ30gcz6nEmR1z2tTAagI=;
	h=From:To:Cc:Subject:Date:From;
	b=m6bhVDckaMDPuIlebKz7bfXbIJIdsSjSONNCvFbWZQPxJPgvzOIRDxPto+y8z+8PL
	 A+Xh15qmxWU4NV246DsBCWTnSH3/Zin+25Ofqbw5K2IC0+LgIm9wP5FLleM65/yZPE
	 vF5DAwFclhQ5HadzKSTgqJGBPcZx0G6PVWJPXeLT3d2xZw3LshfffFGt6g7CUT6V3r
	 ICmirxwpb+F4P8HZAm1WE0iqDL8+9Kug+ALhD6lajxVC/G82nkXtI8UIKzBQnLBfkP
	 feAfFpGD/c/7hZCz9cu6YvODoUopCaLT0pB5Na5Kq+ZQn20s/2PIoiLuOvAV7soO0a
	 qF42+VFV7APeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] scsi: mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1
Date: Mon, 15 Dec 2025 03:55:24 -0500
Message-ID: <20251215085533.2931615-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 4588e65cfd66fc8bbd9969ea730db39b60a36a30 ]

Avoid scanning SAS/SATA devices in channel 1 when SAS transport is
enabled, as the SAS/SATA devices are exposed through channel 0.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/stable/20251120071955.463475-1-suganath-prabu.subramani%40broadcom.com
Link: https://patch.msgid.link/20251120071955.463475-1-suganath-prabu.subramani@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### DEPENDENCY VERIFICATION

The `non_stl` field and `sas_transport_enabled` were both introduced in
commit c4723e68a0d81 ("scsi: mpi3mr: Enable STL on HBAs where multipath
is disabled") from August 2022 (Linux 6.0 cycle).

This means the patch is only applicable to stable kernels 6.1.y and
later (not 5.15.y).

### SUMMARY

**Bug being fixed**: Duplicate SAS/SATA device entries appearing in both
channel 0 (SAS transport) and channel 1 (generic SCSI) when SAS
transport is enabled, causing user confusion and management issues.

**Stable kernel criteria assessment**:
- ✅ **Obviously correct**: Simple conditional checks with clear logic
- ✅ **Fixes a real bug**: Duplicate device enumeration is a real user-
  visible issue
- ✅ **Small and contained**: Only 4 lines of actual code change
- ✅ **No new features**: Just corrects existing device enumeration logic
- ✅ **Tested**: Merged through maintainer tree with proper sign-offs
- ✅ **Intentional stable submission**: Link to stable mailing list
  present

**Risk vs Benefit**:
- **Risk**: Very low - simple conditional check, worst case is device
  visibility issue
- **Benefit**: Fixes confusing duplicate device entries for MPI3MR users
  with SAS transport

**Concerns**:
1. Requires commit c4723e68a0d81 to be present (6.1.y and later only)
2. Version bump in header should be stripped for stable backport

The explicit submission to the stable mailing list, the small surgical
nature of the fix, and the clear bug it addresses make this a valid
stable backport candidate for kernels 6.1.y and newer.

**YES**

 drivers/scsi/mpi3mr/mpi3mr.h    | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6742684e2990a..31d68c151b207 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"12-August-2025"
+#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
+#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b88633e1efe27..d4ca878d08869 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1184,6 +1184,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	if (is_added == true)
 		tgtdev->io_throttle_enabled =
 		    (flags & MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED) ? 1 : 0;
+	if (!mrioc->sas_transport_enabled)
+		tgtdev->non_stl = 1;
 
 	switch (flags & MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_MASK) {
 	case MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_256_LB:
@@ -4844,7 +4846,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	if (starget->channel == mrioc->scsi_device_channel) {
 		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
-		if (tgt_dev && !tgt_dev->is_hidden) {
+		if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
 			scsi_tgt_priv_data->starget = starget;
 			scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 			scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
-- 
2.51.0

