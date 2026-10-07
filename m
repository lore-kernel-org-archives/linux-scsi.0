Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3977E345EA9
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 01:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338343; cv=none; b=Nd3Itf4rjqKtNVYOGqiTB6KEkgyY/D7bOC6ImSWsgenwz9PrIK0R2s6Mgt04T5fKRZpJVmTfpwx47QPqM8VzLZe19RdmV2CITszG1V2iqCwHQIydrMp8xmuHZ8y0ARANwy0HA5AzgyIyVq9dOo3S9ilMS6fp/WHbJkZRYW/N2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338343; c=relaxed/simple;
	bh=EZTytLJPuPOgQJUNN9FUi58KLq76F5niRA5earn65yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADcRtsS/SfoyeqwY6W37sAUTC6eWqEuR10wK2zUHMy4JSz/MPA92N1NYg1RbduBWinGPmCTaa6260kbuCRmZM01sYK3m5CBGZQFe77+H0iGUHI1gMZgA5pmd/6Vqs0QHvXBFRZ3xRrHGk17LO6S/RDuyA3AlC3AJZ076l61ARBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dnlEmCCk; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dnlEmCCk"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a4c47bb6e3so734174a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 18:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791338341; x=1791943141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WOeySBvyscq5Ntop794z4L0CrJE57/KDEPi0ZX/QhCo=;
        b=dnlEmCCkgK1wSj4PCJEtQbaZCdsXXvGooxvoTYU+ltRhuDLBw02KlkR3Ogi7R6Il0V
         hNTsMQThH5D66mbg3xuqL+mLRRM+18dOigYItvzHsRQ78KDI5p/QqLAeu6xSMdATmaSq
         SXpEQ+Eu8SPzfhOrSk6BBjI4MI1E1ztDW0JXSEfi0M+nxuqnOyXHOVpJUFu2UQRP5WOW
         dIIVs85jNvDX/K9KsQL8D8SUGFlX0sQezh9xHFEnDnO1HXz29iYHI/0Ys+e4SnD8ffhF
         roJ/SY7ii7zz6t5MXQ5D1KRyXe7bs8ZPEHw1y25nwLbhU9bQPYjp8f3wA2E5FAfyaENb
         SOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791338341; x=1791943141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WOeySBvyscq5Ntop794z4L0CrJE57/KDEPi0ZX/QhCo=;
        b=yKqk3a/6KdGLGOdm+vzWyn0Jj72lwEKWTRpMAC6IXX2kbVawCa4KSCf9F1qUhl5K62
         PYMi5Fbh3XCioSjwpbliTwqresxroRLzz+B6QfTT7X0nFtWF3kFC+luZmOudt5WIPkwX
         6yrkUxo8n9jiEcvj6zxPjKD8ubUkLQoPlt8PPEhfL+7whHrWfqi0qNuh6FV8FK9y4Iau
         yghBY9yc5GXid8OV7I1IilUZyW8EV6JQdNaW10JpVkTx4TIWj+PdDy846h0AK5x9ATHK
         9vDidqjWjibFTyYxKf0bjkvpAHrx25Cn65nTynHJ9/v5mRA85F1KNIcmlJ3yKEWGkXgD
         9I9Q==
X-Gm-Message-State: AFq9FYJqyeY8C7+K8zs1tsmsP7rrMDs+8Msvm+NXFV7P5lJysxWLNBIY
	QOUXlji1O3Q8a0M790dLPE71GzAVoOJDfdPq2A61OgMXzz9K2DJ3ijD87LemyyJw15w=
X-Gm-Gg: AYBFou0O0LGj5GXUsHyAdh9FPFwZC4xpN/VnIn8C8EoXDsCbghogWExCij3YwQEVUy4
	QRWvv/CIpcIf3SdqHaOikj6MM32lNGuhZ2pJxaYSxDHqagsyw3iCwUcN8I5syIyXymOK4m9nVUf
	wguE90mX2yZvkJ8vGNy+GLv8X0Vj1Lqso7b4StN0eZryBAMSYuNRcL3+0IRgfh3TMet8uTMYMSg
	GXeXL99Nz3+pr6pYEqn/nvKLgv8ufIMNCOS5UouhxGxMrTFN7Q9REuLFs7jeHJ+IygP67kveJpq
	YT/Fv/4UldMdnqDdFC+gl+LsWBsfwErt9IFeKzyVSIqRDQbjsDNs/hfjnSBkoBOuwz5NEr0DHyk
	NEe2dg6UAnKMUoaxtKW0d7/6FIl6zDTaSUB+1mm40oU/fwitcX4hHCm4jiweVXQZ0SaDglBF8Tx
	Iw/u/tPTUJ5pc0IeM0M4vQMHtAxn6/Jhbe8Pwf1zZ/NsUYy3+ftsCWw5VLpaamJeO9ncC/gYQop
	2120g==
X-Received: by 2002:a17:90b:564e:b0:3a6:e8fb:76b5 with SMTP id 98e67ed59e1d1-3a8a1b48770mr662557a91.37.1791338341545;
        Tue, 06 Oct 2026 18:59:01 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543e8478sm8777205a91.17.2026.10.06.18.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:59:01 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 1/3] scsi: libiscsi: reject a negative task index from parse_pdu_itt
Date: Wed,  7 Oct 2026 10:58:40 +0900
Message-ID: <20261007015842.634893-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
References: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A transport that implements parse_pdu_itt hands libiscsi an index taken
from the PDU, and both lookups bound it from above only:

      if (i >= session->cmds_max)

i and cmds_max are both int, so a negative index passes and
session->cmds[i] is read from before the array.

be2iscsi produces one. beiscsi_parse_pdu() assigns the raw tag,

      *index = (int)itt;

and beiscsi_complete_pdu() forwards an unsolicited NOP-In from the
hardware async ring without replacing its ITT, so the value is the
target's. It also reports the session's own age rather than the one in
the tag, which leaves the age comparison in iscsi_verify_itt() with
nothing to reject.

Bound the index from below in both lookups.

Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 160f02f2f51d1..7a74bc697d23b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1191,7 +1191,7 @@ struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
+	if (i < 0 || i >= session->cmds_max)
 		return NULL;
 
 	return session->cmds[i];
@@ -1384,7 +1384,7 @@ int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
+	if (i < 0 || i >= session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
 				   "%u.\n", i, session->cmds_max);
-- 
2.43.0

