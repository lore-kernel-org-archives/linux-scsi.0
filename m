Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED8847F787
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791203769; cv=none; b=nAVnkqbFw3EoO8MwOTom4e4sA+fF7hmbzPW4mEatYlam6Or5bR2mpcIqBZCUXe1HwzxC5UwGtm4quVgBLN+qP881nrNXwjPcLFhBCXCeuuzYA6AlWsRvSpl9D1jheNtv/xaLvipX22/lTARvZq8YmLdMZF0cPZ3goXWK9umPWAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791203769; c=relaxed/simple;
	bh=QQ//D5UNEFrMdGNsE0x2XqrDjRfkmbQnZlSDOkPsLjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sl8ncra3zBpmjF3Ec+48shSHG8jHXpnrdjV8Eq7clofkT8SYzLPyoY4SIIec93NAxgHq4fyMWmb0CveqGBSt+gDXQvjJa+iGVFKHlHKe45VXYmadS8cqqDdPVdQA2Et96S4q+awEr8JBgJoKtx7nhX+ZjJHVJwez9juPwqEJ9x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=LRrDNRz0; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="LRrDNRz0"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db1ca069c8so7008695ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2026 05:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791203765; x=1791808565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4jU8vbkoMdpm/iDka5HS8l6OLmahdMWqgTkrbnwvknU=;
        b=LRrDNRz0pHvIpLpLE2H9qGw9RxTzk6KPEJByVvSTdcI1tFZDoj7i+fjzwbHLVVRtD3
         gpxJcOa4kN5oAMIlIIjX1aH+s8EW5f2m+zEsQ0s0JRIef8mYDo7iUh3DyU5lxbT6Pz/2
         VaDBzU9Zm50NzDVD66drpFqOyuGdNHTdU+qlxAPuLgVheNowU5BjxlMs7iSq4mNQBw+F
         2P33Z9u4PwhNUfLS7hEM5vv8FstSBsKehuH2jAuPUTI1YONbm59kB2rWd+BWBf1PMNOi
         wOKSm2Afa2Xi9OR/yzXxBQekswq5Y2sTrn8y/56E2bCtDBDH/RxV01xpAnDMSqw/89me
         c4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791203765; x=1791808565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4jU8vbkoMdpm/iDka5HS8l6OLmahdMWqgTkrbnwvknU=;
        b=2GI6D3jXLIWvxQwYXXPQn3v0Xs/xyIGCyTdK6LpynMQG67mfbvDeR07lV6HiPe0AOe
         NOwQj1Seu+AVkioWxR3KtwhaFn+UJJbenOKK1UBxIQbb/7pF81tXJx4l/ln4z7DxTOCZ
         JDs2sA9J2irnW5nNC44jc4qE2FMfLgmoGTW1eMSArYDOOkwPd6MKMnWm9l6Cr9+osN6s
         92I+mQYYPmdqxbmWPckUmOvBZ3zlVoPmSOG0X+I2KNcgd52y5bbotYB29zwJmynJMcQb
         +qQ5L5XDkg92p0Mk+pWQvY3pH4mSOcD2lEGW+G8N/9LRVT+VmdKgpehqzSyq2Icc3+TP
         Z7vg==
X-Forwarded-Encrypted: i=1; AKwUvBxfVb/E5TBugk3rHaOnjgudcdVOOPx9i1oHhndEa1lh6I/pwLg4CEDX6Q+8JV2Kybsecmz8PwK/3oxm@vger.kernel.org
X-Gm-Message-State: AFq9FYIzHhbrXE0QSa4VJXN67AhhLXn0NNbVv7/b0vQAXnsmdl5dcfy6
	ikzWTSRk03wv2CrMtJ0fFttgnnVefPnJ/TOnDKj8SfD9hjmuprEWWIJiisnBf1I6AAo=
X-Gm-Gg: AYBFou0Mit31kmYmW5TrwM//TfMUByxLkYzFzXruM7ARjJVf+Wuz/jN2/0ernlpZJTm
	6+ZjT9z8Ww33gofBGKCcs/jxzs3m1RAvqGSiHNF7FOeVCk2YDhu61G4E22UuzKj+kPKRCVnBArL
	pie5JSkwVjmYkab7ONeqQn3IVs11EZ5RO7opYcBsvsWr5AtrF0TjZyeorm9Kp2cZo45FpGI1bIu
	jvH2QMlWy1tREwSlbu8F6GysGs/bKi5XNUQnKRJxCc0BTiBfJ9hxROvT+IfnWIHPmDFhPhKRQRX
	gFNN/7GQlnMqPl7x+Boi7REH45Tc6nLY5qOegqYoRtbGpGUswVlxpJLDYYXAzWOZMDStLvcHxgR
	AjoPWwvl9lXdC9QFqRg81BSTlPsVAZJrkIAeBFSHJX+8rmjtVR8XHjxpMHaUC/RuyZFDxUYk9BU
	jPGxziYtirF4y6ZNEyLpQVUGFpHMUHyE6GR7AbotXjrA5RTvTghB53k8OuTcXyaMUBxYkz1MBwh
	sSHl1EkLZtDrSWotXoojw==
X-Received: by 2002:a17:903:186:b0:2dd:c053:c209 with SMTP id d9443c01a7336-2e49b6df076mr106567665ad.37.1791203765331;
        Mon, 05 Oct 2026 05:36:05 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5364:bba9:2adf:d611])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5caea48sm6542495ad.14.2026.10.05.05.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:36:04 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] xen/scsifront: check for a NULL shadow entry on a backend response
Date: Mon,  5 Oct 2026 21:35:54 +0900
Message-ID: <20261005123555.253995-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsifront_do_response() validates the rqid in a backend response against
VSCSIIF_MAX_REQS before using it to index info->shadow[], but then
dereferences the entry to test ->inflight without checking that the slot
is populated.  Shadow slots are NULL before a command is submitted (the
host private area is zeroed at allocation) and are reset to NULL in
_scsifront_put_rqid() once a request completes, so an in-range rqid that
does not correspond to an outstanding request makes the frontend
dereference a NULL pointer.

A malicious or buggy backend can thus crash the guest by returning a
response whose rqid is in range but not in flight -- for example a
spurious response before any command has been issued, or a duplicate of
one already completed.  The ring has only VSCSIIF_MAX_REQS (16) slots, so
before the first command every in-range rqid selects a NULL slot.

Reject a response whose shadow slot is not populated.

Fixes: 6d1c2f48f3fc ("xen/scsifront: harden driver against malicious backend")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/xen-scsifront.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 989bcaee42caf..aa44a233eac8d 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -367,6 +367,7 @@ static void scsifront_do_response(struct vscsifrnt_info *info,
 	struct vscsifrnt_shadow *shadow;
 
 	if (ring_rsp->rqid >= VSCSIIF_MAX_REQS ||
+	    !info->shadow[ring_rsp->rqid] ||
 	    !info->shadow[ring_rsp->rqid]->inflight) {
 		scsifront_set_error(info, "illegal rqid returned by backend!");
 		return;
-- 
2.43.0

