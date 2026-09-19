Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98646282F0C
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789839292; cv=none; b=Z2C3IPA0DdYLeQDpBHpU+l8W5Epk91N+GowAcDHhdiMw8jqkLRLRG5nwfOuRTlDTPTBw6c7PzYncl/ksAnTS8YP8zXsanZH8+xpbl24DDo4OfJDrsfCRWZTMAxczfmi3d7FLyI6UOh9BK7pwL2kOxChKyEl5IJtUc+TwcDyefUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789839292; c=relaxed/simple;
	bh=tXPMv/Z528AzLwHoqZJSLZNkBxU0ltXfHPgB+kUGM0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TKYBMJL6BSXFS7pg8YPGStFDpZAoxVJhyTDCMNno6naEqApJzqXWh5oGvWt7Iyuk/luqV9V0v2qSO0KDm8G5aYQpAArdrTqEIZ0ZTw+s35sQ3agTURAm/ZbWla8divv69a2NSon2GTXgZVkmWfOJK2Wzo2zwC4lPXb3g4/++KkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCoFo3lF; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCoFo3lF"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1632684a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 10:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789839291; x=1790444091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3sjbzhb8LLlJu3Xq4nSK1HUp2gy9IN+rCu4DEVUfQU=;
        b=aCoFo3lFTKMrg7PIcA1ejGDI13I3vmHJBmZnC8El2K/sCTwSTghub9PQNrVm3hIzPH
         zE91qUQTHGt+8hP1wjX0wJ6p02E6neQ4IActu8nvkh50uU44QbP7FN3ApDSpIDUH5QgJ
         n8ReyfqBrdL0GMSrmXp4my3nW6LGdKXxuXC2ttTnT8VD9B1dCEHXj4cpGxW7XFZnfz/O
         kIMAr9bqHrz1WQ0sy0//sk/uumvk0YjDluST7jUh95HELb/m4lTa0UGAUrqG81uoVlHe
         BJtDY8BbuSBo9aL1o80wIQLCeEkVbUNc0MvIhuMmAGR467maNOrQk3JeFPL8osGhgGYw
         08TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789839291; x=1790444091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3sjbzhb8LLlJu3Xq4nSK1HUp2gy9IN+rCu4DEVUfQU=;
        b=q4SSnwd9Kt6Hb3MAaWmtfH0HjbAfqYFnvW1WUCOnPP8E8w2e9UzLfZuvOvKFPqqvIC
         5PMb3cwD3XV+drnnhU3sjDTdZNfWOmkgx+DZdca8eC0lru9XonYA2EAWCgVhEEjJb3wQ
         itNNNboXACJCntOlv70CmDByY54PyEIYOVo3P4bcl6NhfmfsOxLbrBzdeEMWMW2lsFW1
         QOaQqUHniv7tangoP+2o+H/xxDA98ONPhBTZJM+mjKvfff8mRHMFVZUShZK4gqChjMIG
         ywrotqWghkMVFDRhK5gyCtqayo9hurlFjghmndoYRYHEDW/QTvNL0w4dbGhBvGdFjChP
         IpFg==
X-Forwarded-Encrypted: i=1; AKwUvByeB6w/Z2hNreTKpX4JawMFOoEhTFCHqVZo1fOm6cQo+1OV37Dkk1Ra7/ZU3zNuN78lx8noDGc7yKkd@vger.kernel.org
X-Gm-Message-State: AFuF++mvIoU5h3FvhU9GKltX73tNAW18vkmtQMEpWpwf2XXotIqC5C/W
	AaVyYHd/WVWUG6lNRgGYljDhK8aYCKfQI1XK00Vo4Lymv7ucz8eKAxYF
X-Gm-Gg: AYBFou1YVQ6WjJ0gkVnZuqW6ME+kzN/4ogL5F1VpF7PeyDpChMLevwFXcdk4qDdBEnq
	Exi9o26XH4Oo0jeGzF50AtEoZ65o2KnjadRtjM8O8Ln4NXLk+GPL/b5VysMbciqo5sIOuQBIhjJ
	MYx56Ubi7DmIo8QFXdTOkR1FU4OjMpWdQeiOppv11Gf3tFBtBRpqS3XofuzGZIwYLNUOZuX3CYx
	p6zuOUOvWbJZm/I0fbb4Bk/L9WtVlkUnXAeOMUYKWGJpApB8xd9d792g3E3FmiJfOFs1Cut37CV
	C5QnfOj3+O86NMNC9lOetrvot0bvRJfDneXMwH0TAcOVY1JaIg0N0/qpmISgkZ2XzjXRilwHc/a
	Bvvlsjs1xTG1sFb2KkLdEmk+aQ5My5DixgkClKMpStJ+syWPN0pfWNnsXaX6IBMlhrnIaWeKOFa
	YWBCPVqYqxGElcP4/XZoe8GbQwd7Q6EuY4Mcx9PFo1WspMZ39yrF8n2Q==
X-Received: by 2002:a17:90b:1dce:b0:39e:6a80:dda3 with SMTP id 98e67ed59e1d1-39e6a810c76mr4792250a91.42.1789839290805;
        Sat, 19 Sep 2026 10:34:50 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a026898b76sm3234229a91.16.2026.09.19.10.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 10:34:50 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Robert Love <robert.w.love@intel.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Joe Eykholt <jeykholt@cisco.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: libfc: fix directory server rport memory leak
Date: Sun, 20 Sep 2026 01:34:05 +0800
Message-ID: <20260919173405.3718408-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fc_rport_recv_plogi_req() creates an rport before allocating the frame
used for the PLOGI LS_ACC response.

fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
rport list. If fc_frame_alloc() fails while handling a PLOGI from the
directory server, the function returns without starting the rport state
machine or dropping the initial rport reference.

Since the directory server rport is not present in the discovery list,
there is no later teardown path that can find the object and release
that reference. The allocated fc_rport_priv is therefore leaked.

Record when the failed frame allocation leaves an unlisted directory
server rport behind and drop its initial reference after releasing the
rport mutex. Keep the existing lifetime unchanged for ordinary rports,
which remain owned by the discovery list.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/libfc/fc_rport.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c25979d96808..884b233c2f72 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1848,6 +1848,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	struct fc_els_flogi *pl;
 	struct fc_seq_els_data rjt_data;
 	u32 sid;
+	bool drop_rdata = false;
 
 	lockdep_assert_held(&lport->lp_mutex);
 
@@ -1940,8 +1941,10 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	 * Send LS_ACC.	 If this fails, the originator should retry.
 	 */
 	fp = fc_frame_alloc(lport, sizeof(*pl));
-	if (!fp)
+	if (!fp) {
+		drop_rdata = sid == FC_FID_DIR_SERV;
 		goto out;
+	}
 
 	fc_plogi_fill(lport, fp, ELS_LS_ACC);
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
@@ -1949,6 +1952,8 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	fc_rport_enter_prli(rdata);
 out:
 	mutex_unlock(&rdata->rp_mutex);
+	if (drop_rdata)
+		kref_put(&rdata->kref, fc_rport_destroy);
 	fc_frame_free(rx_fp);
 	return;
 
-- 
2.43.0

