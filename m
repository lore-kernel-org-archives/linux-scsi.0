Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE048560AB0;
	Tue, 22 Sep 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092007; cv=none; b=sksIaDCUw2Dx7CvCyDXca+jkLeo4LG7R3BKhatyxcpbWNmyK9AJ+7rnelaVW9EQfC3uCi9T5/ZQJkKqH1ZDgPHW/Fsxk5oPfGi5LE1lyWRnLil3H8Lq/pEhx0DCQCRaUPJaBmqAhBfAyAStW/P8/ufvZpAFlHApDDxOB3FGPVek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092007; c=relaxed/simple;
	bh=/84ulKuRLrs8JM+UqU/ZGjQ8z7YJ3q+WX3pPrJ/0BE4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=WgVutZi/B23ji3oE0D23rf1uDQHulfXckFG/WI0rVOOd3ZS9SPoH2OriLgmRuSwXtyBYQSmO/Y533FjZ2pfPxgTeYBLUakMD8HWwzRyDSrU35Rf5AiEfa0SM/f/wOIRLw1ilyDojgci8ERRyxg9cVYMrh20skRpbVlVnHDwYskQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mh7fk7Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mh7fk7Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5192BC2BCF6;
	Tue, 22 Sep 2026 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790092007;
	bh=/84ulKuRLrs8JM+UqU/ZGjQ8z7YJ3q+WX3pPrJ/0BE4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=mh7fk7YxHnYpkeWneEvQsAc0QHC6gr9hTS+oaTBa34n/zKwDJOJvm+Pct87ecV8G3
	 xW5/pCTzkNTkMYFFXfLyCcrlB/BXQFG/kE0wVZbfs6HLwxochCmdS3wvopn3gjmc1v
	 /oqd7dG1E8E2WcDARe5UngNDGDG1rCzd3ylL/k7KXk2MQftDh11DsAfS4mdxNaeZVL
	 SQ289HaPYT9x2fMjlcgyv2u0jOyNKA1eOkLMyT3aBTd5Qdz7oZVvDgpWWpy/mIsNXx
	 a4zQYocKypw3njVdxuD/XqQwc70GbQAnBXqsR2wGdJHmM7DoA7F1N+6m5BePaw/O+X
	 /KeURuc+qUDLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F5AC98302;
	Tue, 22 Sep 2026 15:46:47 +0000 (UTC)
From: Ahmed Abdelhaleem Ahmed via B4 Relay <devnull+ahmedhal.gmail.com@kernel.org>
Date: Tue, 22 Sep 2026 15:46:46 +0000
Subject: [PATCH] scsi: ch: Do not keep references to data transfer element
 devices
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-ch-dt-leak-v1-1-2b2e40bf1624@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOWismoC/yXMQQ5AMBBA0avIrE2isxBcRSyqHQyCtIikcXfF8
 i3+D+DZCXuokgCOT/GyLhEqTcAMeukZxUYDZZRnJRGaAe2OM+sJDalCtbntrC4gBpvjTq5vVje
 //dGObPb3APf9AEgl7kZuAAAA
X-Change-ID: 20260922-ch-dt-leak-c2181b6dfda8
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yang Hao <yanghao_ht@163.com>, stable@vger.kernel.org, 
 Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790092005; l=4470;
 i=ahmedhal@gmail.com; s=20260922; h=from:subject:message-id;
 bh=iZVNPPB7mUfBqJBncawixvxcm8hSCLkSxjGpPuZxEew=;
 b=2UeofKhw6wI3aDTyud1oM5f9gWPbzV/lXmlrRTDrU5Zin6Goi0XrWOYBjoukeqmobkRtEamLV
 Q4zxzAKCxGeAIi45BP/0CXWSByCib97cq3Wj7wrIAU2JschKSHZPQU6
X-Developer-Key: i=ahmedhal@gmail.com; a=ed25519;
 pk=UEFWTgykG696wvaHZw+52zx9UkpJCW3L3hvdRay28Fo=
X-Endpoint-Received: by B4 Relay for ahmedhal@gmail.com/20260922 with
 auth_id=1049
X-Original-From: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
Reply-To: ahmedhal@gmail.com

From: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>

ch_readconfig() looks up the scsi_device of every data transfer element
whose SCSI id the changer reports in READ ELEMENT STATUS, and stores it
in ch->dt[]. scsi_device_lookup() takes a reference, and nothing ever
drops it: ch_destroy() frees the array with kfree(). ch->dt[] is read
nowhere else - it only supplies the vendor, model and revision printed
in the same loop.

Once such a drive is removed, its scsi_device can never be released. It
stays on the host's device list at its address, so a new device there is
refused by anything that walks the list - target_core_pscsi reports
"scsi_device_get() failed for H:C:T:L" - and the low-level driver's
module can no longer be unloaded. Only a reboot recovers.

It shows with any changer that reports its drives' ids; with the mhvtl
virtual library (IBM 3573-TL personality), each create and remove of a
library with four drives leaves four references behind, counted by the
module's use count in lsmod. With ch not bound the count is unchanged,
and with this patch applied it is unchanged too.

Drop the reference as soon as the name has been printed, and remove the
now unused dt[] array. That also removes the array leaked when
ch_probe() fails after ch_readconfig().

The same leak was reported with an RFC patch in 2022, which was not
merged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-scsi/20220719075442.6215-1-yanghao_ht@163.com/
Signed-off-by: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
---
Reproduced and tested on RHEL 9 (5.14.0-687.47.1.el9_8) with mhvtl,
IBM 3573-TL personality, four ULT3580-HHA drives, library created and
removed; mhvtl module use count leaked:

  stock ch.ko:                          4
  ch.ko with this fix:                  0
  ch.ko with this fix, changer daemon
  restarted twice while it existed:     0

Build-tested on mkp/scsi.git for-next.
---
 drivers/scsi/ch.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 87e51e50a..b2c9fb71c 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -112,7 +112,6 @@ typedef struct {
 	int                 minor;
 	char                name[8];
 	struct scsi_device  *device;
-	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
 	u_int		    voltags;
@@ -354,15 +353,10 @@ ch_readconfig(scsi_changer *ch)
 			vendor_labels[i]);
 	}
 
-	/* look up the devices of the data transfer elements */
-	ch->dt = kzalloc_objs(*ch->dt, ch->counts[CHET_DT]);
-
-	if (!ch->dt) {
-		kfree(buffer);
-		return -ENOMEM;
-	}
-
+	/* report the devices of the data transfer elements */
 	for (elem = 0; elem < ch->counts[CHET_DT]; elem++) {
+		struct scsi_device *sdev;
+
 		id  = -1;
 		lun = 0;
 		if (elem < CH_DT_MAX  &&  -1 != dt_id[elem]) {
@@ -378,10 +372,8 @@ ch_readconfig(scsi_changer *ch)
 			VPRINTK(KERN_INFO, "dt 0x%x: ",elem+ch->firsts[CHET_DT]);
 			if (data[6] & 0x80) {
 				VPRINTK(KERN_CONT, "not this SCSI bus\n");
-				ch->dt[elem] = NULL;
 			} else if (0 == (data[6] & 0x30)) {
 				VPRINTK(KERN_CONT, "ID/LUN unknown\n");
-				ch->dt[elem] = NULL;
 			} else {
 				id  = ch->device->id;
 				lun = 0;
@@ -391,18 +383,16 @@ ch_readconfig(scsi_changer *ch)
 		}
 		if (-1 != id) {
 			VPRINTK(KERN_CONT, "ID %i, LUN %i, ",id,lun);
-			ch->dt[elem] =
-				scsi_device_lookup(ch->device->host,
-						   ch->device->channel,
-						   id,lun);
-			if (!ch->dt[elem]) {
+			sdev = scsi_device_lookup(ch->device->host,
+						  ch->device->channel,
+						  id, lun);
+			if (!sdev) {
 				/* should not happen */
 				VPRINTK(KERN_CONT, "Huh? device not found!\n");
 			} else {
 				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
-					ch->dt[elem]->vendor,
-					ch->dt[elem]->model,
-					ch->dt[elem]->rev);
+					sdev->vendor, sdev->model, sdev->rev);
+				scsi_device_put(sdev);
 			}
 		}
 	}
@@ -566,7 +556,6 @@ static void ch_destroy(struct kref *ref)
 	scsi_changer *ch = container_of(ref, scsi_changer, ref);
 
 	ch->device = NULL;
-	kfree(ch->dt);
 	kfree(ch);
 }
 

---
base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
change-id: 20260922-ch-dt-leak-c2181b6dfda8

Best regards,
--  
Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>


