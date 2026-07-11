Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC31FBEBC;
	Sat, 11 Jul 2026 09:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783760964; cv=none; b=DPInO7GnZb0soLerSgn0PQ/oFZafwAavlKW5wEAVb4dqbv/ET4gM1tfEt8WXrbP40Ols1d1UWphZYLVggut6XxoGh4zfH9mVQyIsiKB1tflbpvduKKLK3erD6HlDNLsey9rP8zuR+9J8CdKYvyZO70h12Enh/7K2J+0hMLLFXXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783760964; c=relaxed/simple;
	bh=j/psRqZC2zyMs5v+BpWb9Fw3XxGllXyvripiwJktUjw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=aMGI0+bfzB3xB6v/N3jDxYBBSQ2qgJfZXPJRg/yFrbh5zrlBIFrhVHbkDDa6SttBZ4T9JHsiSTbgMyMHXypmed10v1BgbQOE3UAH/CoMPE9RZyibkdePs4vuID+RDITd+xhqtHhobF1w7x+ktArOdJBkrJU+sRUaz2/qoPbnq08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCSQ5ERa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCSQ5ERa"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95CE6C2BCB9;
	Sat, 11 Jul 2026 09:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783760963;
	bh=j/psRqZC2zyMs5v+BpWb9Fw3XxGllXyvripiwJktUjw=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=bCSQ5ERaeor70zDjIOW75rrQLoPGhaftuCOyirRpdHaqvC1W+FUYZSQsMY1p6rX0f
	 v7Fh+4FEzjrPx5UeHinA1LHrllYIm0XfLse6xwWVim5vziF9Xqv2ZWTlDSq6nkUpxS
	 2G/wGyk2ZHwTMFlllYyValxHLMZZYUAUqxDFW2G4uVJf8gMFS1RNkrmH0ePiVcY9Es
	 2Lg5zZw40IN34yCDaxlE3bpbOHkeAiKcv52NitrP5alqG0tLIHTPHfRzTqFzbktCtw
	 cXPWeH31dxLH4ImPeZ9qrBorAqcXr/EcDN+5WUJ82rxQA7C5vs+xUa2FFel5E3BoUX
	 zH48HcGvnNojg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81958C43458;
	Sat, 11 Jul 2026 09:09:23 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 11 Jul 2026 04:09:23 -0500
Subject: [PATCH v2] scsi: ses: validate the page 1 geometry before walking
 it
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-disp-414d08d4-v2-1-784a01e8e2dd@proton.me>
X-B4-Tracking: v=1; b=H4sIAEIIUmoC/x3MMQqAMAxA0atIZgNJrVa8ijioTTWLSgsiSO9uc
 XzD/y8kiSoJhuqFKLcmPY8CU1ew7vOxCaovBkOmI8eMi0Wv6ULL1lPvLToibhy3oWkNlOyKEvT
 5l+OU8wezmJNyYgAAAA==
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783760962; l=4018;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=aGkqMij/fwiXWZbOxSwO7lO1Cb5QwO5aWgWs0GueIsg=;
 b=680iIPzuHZui8S3CwahOi6/WyhLQIEqbo7lI3t5qnYpeP3uXyWUDldfzivVzh39qoXtFpmJLd
 XNWCDkvqTDYB/XOCeac59jJNqxkHDtJdb8+lfDAGyTlfVppydNL3+Mu
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

ses_intf_add() stores the enclosure's page 1 type-descriptor pointer and
count (page1_types, page1_num_types); the page 2 walks,
ses_enclosure_data_process() and the logical-id read in ses_show_id() all
trust them.  Three device-supplied values go unbounded: the enclosure-
descriptor skip loop reads a descriptor's length bytes while only checking
its first byte is in range; the stored count is a device sum unrelated to
what page 1 carries; and it is truncated into a short before being range-
checked.  A short or inflated page 1 thus drives an out-of-bounds read of
adjacent slab, some of which ses_show_id() returns to user space.

Bound the skip loop to a whole descriptor and validate the geometry once
where it is parsed: reject a page too short for its logical id, a type
array that ran past the buffer, or a count larger than the array holds --
checking it before it is stored also keeps it inside the short.  Conforming
enclosures are unaffected.

Fixes: 9927c68864e9 ("[SCSI] ses: add new Enclosure ULD")
Closes: https://sashiko.dev/#/patchset/20260711-b4-disp-26cc3226-v1-1-e04c11c88996@proton.me?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Changes since v1 [1], addressing the Sashiko review of that posting:
 - Bound the enclosure-descriptor skip loop itself (type_ptr + 4 <= buf +
   len).  v1 validated only after that loop ran, so a page 1 a few bytes
   short of a descriptor was still read out of bounds inside the loop
   before the check.
 - Validate the int type count before it is stored, not the short it
   truncates to.  A device count of 65280 wraps a signed short to -256,
   which slipped past the v1 range check; the int is bounded to
   (buf+len-type_ptr)/4, below the short's range, so it cannot wrap once
   stored.

Verified with an in-kernel KASAN model (7.2.0-rc1, kasan.fault=report) that
replays the skip loop over a real kzalloc'd page 1:
 - old guard, 10-byte page 1 -> BUG: KASAN: slab-out-of-bounds read, 1 byte,
   0 bytes to the right of the region; the tightened guard stops before it.
 - count 65280 -> the pre-store int check rejects it, the post-store short
   check (v1) did not.
 - a conforming page 1 walks unchanged.
Reproducer available on request.

[1] https://lore.kernel.org/all/20260711-b4-disp-26cc3226-v1-1-e04c11c88996@proton.me
---
 drivers/scsi/ses.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 4c348645b04e..907bb489252a 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -742,11 +742,28 @@ static int ses_intf_add(struct device *cdev)
 	/* begin at the enclosure descriptor */
 	type_ptr = buf + 8;
 	/* skip all the enclosure descriptors */
-	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
+	for (i = 0; i < num_enclosures && type_ptr + 4 <= buf + len; i++) {
 		types += type_ptr[2];
 		type_ptr += type_ptr[3] + 4;
 	}
 
+	/*
+	 * Validate the device-reported page 1 geometry before the accessors
+	 * walk it.  page1_types and page1_num_types come straight from the
+	 * enclosure; the page 2 descriptor walks (ses_get_page2_descriptor(),
+	 * ses_set_page2_descriptor()), ses_enclosure_data_process() and the
+	 * logical-id read in ses_show_id() all trust them.  Reject a page 1
+	 * shorter than its logical id, one whose descriptors ran past the end,
+	 * or one declaring more type descriptors than it carries.  Bounding the
+	 * count before it is stored also keeps it within its short.
+	 */
+	if (len < 8 + 4 + (int)sizeof(u64) ||
+	    type_ptr > buf + len ||
+	    types > (buf + len - type_ptr) / 4) {
+		err = -EINVAL;
+		goto err_free;
+	}
+
 	ses_dev->page1_types = type_ptr;
 	ses_dev->page1_num_types = types;
 

---
base-commit: dd3210c47e8d3ac6b4e9141fc68acc03b38c0ba3
change-id: 20260711-b4-disp-414d08d4-70013715f352

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


