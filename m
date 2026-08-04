Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC936433BD4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816373; cv=none; b=eoBydrDRLfwYtY9ldHsHkVP2jWkfn6LDnAOJhTDp+HwBNhcOcRrnQ2FmdnpRZ9zm4uoo0kxCiP80t+SH6OtAio5JMYHdpK0m4uhiVN8G7/NhDM9aPDXYu8IganzHdOpbyc+neLZpJdhk8nb1UxatxStjfrbXOGfsX5q3FMNNOmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816373; c=relaxed/simple;
	bh=5DE4KQsM7346xeBKvK3gf4RPk9kJfK5f72ku+Z9mtWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTg4YsyzXkU/0mj150m+wqTpxd8aXXAwUCO84Yzw+PBl5xF0BB0ioXri6YpMLPmJqRUNjDGrGCOmGqQIVs6tSif4JXbYdE5kMdJfAsHyxWi6Gb6eyDHj9Uubp9bf9CgMo27T8PdZv7HgBFtwMYIJ+wXMJB0fwjF1ufIYssdxEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=lUKemQmm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="lUKemQmm"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cca0c5799eso35686915ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 21:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785816370; x=1786421170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=za1Dlg5MtkIibFTGSkfNOwAtn76AnP6HPzWNLsvhv18=;
        b=lUKemQmm9QETeTffwq36G+BrDLCxd2IMl2zffaNwjs1HjIMRzDZtCXA6J55TUy2ue2
         fHe4ZSEnS1Kn01UeKuMjCCpZEW9pKdX0up+XicdeqRXhcwwfgym6sraP75+L6kuNMHsG
         D48K9pNjwVOwTYlvJMLOAMhl1b4QpvPU3GUbkqeCm38V97eC/S1tPlefMa7mtU7ECcJ8
         07JUMPi8xxGqR0+54hrrElvgDz0JZ1zbcv+St1mcgNMOs8EGtO5vZE/UFs/K/e6JcJ/j
         TdwxhxpsYdfz5IGuE2uW2Tle1Ip0e5RUa5QBLQ/KsDA9Es6xC67Vg0DbzZlPC5oL2qOU
         OrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785816370; x=1786421170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=za1Dlg5MtkIibFTGSkfNOwAtn76AnP6HPzWNLsvhv18=;
        b=dB6ma+wMOmF/TRhAkRXO03ZWg3wbuF7SipgByJR0EERmJWc08nuJruKuxMYtxO4Dwd
         OgzutKgwk4sOrQ6mC/Rh2thazPu+yPOc2uqTFwslh3K4lOjRnEahLvcDK447lLTJozIO
         rmLBFV858nvaT6N0/7Np8IwKw9/DJuUgwRkIu2r5Px0VMkhMZ13ZHgVEupJZHwedqOPC
         33ZleQ4UJO3cYkDzwBe9kddRDk5URZzgiCOj83NngjPtYlJgReSGoB4ryU9B4b/LiLXl
         xY2VtnppOmtC+K4RpW28UXa8t+UBFEquYm5uapocOouwhH2wlTlCv01O7plQTxjfeZAz
         Q/lQ==
X-Forwarded-Encrypted: i=1; AHgh+RoOjOsA3k7zbAgpbYhz+tVNiYw+VpdTucTrnAtGZsYWinfop/kFxu1POORs/q1vchmVNJPb2nKtEhsy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz88RgAjdBfMkfo9u3GhCG30myVoMIBQMpkOGo5aOKOnGNMxMS8
	tCyYNKNJUw3G4WXEQdG82Rce9/WyeYaDzac5bOG4opgH9zwJ5ajdC+3q4PKmPWYryEU=
X-Gm-Gg: AR+sD10gkkHTzzNiXgnN8rUcgk13rmiwDOcsPt4raBTLHfT2MGA+7hHwSyWKIAasnZE
	AM/T3UZKo8spqAVs4uubdRh+SSJBqvAvTlqTmj2EtyWdCyp6kf6lCE+0tDGo6hJo1VF7tmQTarU
	07696ytyfTFpFWezyhQ7hxWBySQJ04cELeGN8LI2VwKLoatNlS7kSsN+M98cOUGnLunRESJlsOo
	YwpwiRncXNdwaaCqZwyU4VLj2EUMClXCFupoD8xoNSltNGyjidRJWEHMfPTuXaU5tnKnGakjf7a
	8AOOW9jqPYjy32yrHFuGOQc9YGRRpxziPFnqgfAtrAEff5OEwhSJzEWlsN6hnitwzCJ4p7Aec59
	dMOowzs6eQkLYSi9N56JczWYT+U+r8cFG0/XA9otc3gI98rGNiN594/n0oVCSWoy9uxai83ugc2
	Wlv0TSOe7v9fAD6j4G0oSMhlNgwSwc/QSE71V4CdgajPuatQKchnkwILckvtOzF0JlHyh7
X-Received: by 2002:a17:902:ea0d:b0:2cf:83bf:6b05 with SMTP id d9443c01a7336-2d0523e144emr111189575ad.41.1785816370167;
        Mon, 03 Aug 2026 21:06:10 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11f9a9sm46075465ad.57.2026.08.03.21.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:06:09 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: libiscsi: reject a negative task index from parse_pdu_itt
Date: Tue,  4 Aug 2026 13:05:44 +0900
Message-ID: <20260804040546.2264137-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
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
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Not reproduced: I have no be2iscsi hardware. The reachability argument
is in the commit message.
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 160f02f2f51d..7a74bc697d23 100644
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

