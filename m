Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13373431E6
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790965333; cv=none; b=iDJ+JsRikQ4/xrQwh4uKNnOuRZqe15Ie0JnJ4juHv2mEITA3Hp5/kM0QXiUTXBJBdfQdxXqgZrBIJyL6kLqAULMi1wzz0YwlkOVha1OSNBkGb4tkcIwLm046Z2hhEHnFcbXNyo0Zt5tVWaXUALWupz4iouoSvKBr/Ksa/xv9hD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790965333; c=relaxed/simple;
	bh=OmZ056pmE8+XuTrAcBI80z+F4NvkY+1WYs3uFfA6dFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DGjX9K2m+VHZU3cKBfpHxhRo3QX+iQ+gzy7pfK4gB12+jD1oy2HfqPEr2qnnErzsihvcbP5uydPiFWjUsmF2LBVWtmqZvNYHnY6/GIM0aK6pJOuMR5pClAkaUmujEjC419DWYqn+Q7HI1ODhJmiirTfprUjX/gZoq47HzIBxn1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=YUaS7erp; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="YUaS7erp"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33c24422d4dso9748621eec.2
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2026 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790965330; x=1791570130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1c+AY9BIFo0QsNiuYQN2LRK0yYw3P5G1Duk5ldfMSDA=;
        b=YUaS7erp4DjEMTmicFflWCIkZt2ku3n9hmYKBIBMcaNhMd9TdOyHqga/yYBu+iDjBs
         zt1I10CopicUzE1SBbEuiac7/daL/rMCOjpEjmMab8/rlvAhYUTdHPhJFvgcu5a9KQAE
         vL19bZKXGVz/0+TL52Lg69Uw4KrA85GjdZ8GSzee2IgZ3v8iVkm0CPT1FVtLfr9+nczB
         yPrbROREOK2bqc6gI+EaNnyjcmVXmb/n3aiyrNyyo8wwgHd8t3nFRlTVIU04ESio/vQY
         Mbx9KHWOoQfuV8D/i8X0iE6KLhqMdz2h6dq3YVFmxEj5E27QE+hodmoWd7NDzYVK1OA1
         nl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790965330; x=1791570130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1c+AY9BIFo0QsNiuYQN2LRK0yYw3P5G1Duk5ldfMSDA=;
        b=iEl6rm0le25z3E3ytp5km5I5MS0pV3Dw7vyCZtp9nk/Tfz4GPouvjLZhuR0jAvApNj
         7UjZ3BqbyBiYZ0OquZb00LgCDzV0ZM9ZApLWqSPEmF2JP9QON8Sbw6KYhvc4YZIxd974
         zKqoohSuksSrD2Q8mxrUHx05MYL6RwkAEHHbZmfZ3FtUByAsYJU4ReqU4QbPD1belMqe
         SFt3BVImG+iGAZqTeGf4lSr9foE4d6wFN8fVWCgiUXQqT6GZrH2PmcYIjkOEG6gVVy9E
         8goq2h4RcGv0rmztcbCQj1NGXg43wjd/p2+Emmpt02jo4dsUHyg0Oe4cEStbwmtzMPir
         u4Hw==
X-Forwarded-Encrypted: i=1; AKwUvBwDgC4AhnkNopfmmZv+NILotbqqi+H+II0hYrpWi4uXwjN2Q2B4Q02t7JaQGCX7wuNe0a6lp4yr8v1n@vger.kernel.org
X-Gm-Message-State: AFuF++m1i6XvR0AXm3AuogQ5w9OWcXjZ+dzHlajLN8v8W8YD7VQ1e02a
	+PzSpQ0NVLdJyO6NadRAJDaoVAdWIzuWI6GHL3PjDKBGpuenTAGI9sISC6lAfG3Bzlk=
X-Gm-Gg: AYBFou0Ms0X36z2itUbVdV/uVJ2MBryvGiSSofmorTvdV7MLwU8AMzCZyWDHMWsAzly
	8+A1wN190vmyQwwzFan41IYPzrL0Pk0hSdBAZc2HWl5ZCQ/O//RuEDDa/YcwBNieVNASfvb5w7E
	lUoTsacZlXmYw4ke364BbsDTYl95oUiuJL73+gBFOogk/s08X69+Lp3u8Wle8cC9QQu+sA0mlH/
	unZeJWimolKKW88wg7RM2OGsA57w7WCEx5yrru17DC/j6Jn48PFmIE/si1tQQUtZ8VHtqfXpLP0
	GUKUEWRB5TfoLjshd+YJkRpoMw8w/3sBk6oJPxphFaBvXRJUGVOztSoD8haw5YcvXtuQABb8HXr
	5+qziPCPW0TEtPEG2dL835GzTAonZx2m8SFAO1Td5IKQ6cP1uEVVa8gmpTDRF7G3S7XDHnuWH34
	CliBFhXTr8UoJFaRKdOV3D/j5pil2j40sftkvjq/36pKNqipWoBmNRhPPnS2uigGNpdAjWWNm7L
	2YqDDotTQ6u4Z6cnmzOlMd5GCrxlFV+T+6R0Dc9RzsyCVxNLJKrzODTSg2DiYnHDqPvG211
X-Received: by 2002:a05:693c:87d5:10b0:34b:e2cf:43b6 with SMTP id 5a478bee46e88-34f14f2b9edmr3878021eec.2.1790965329727;
        Fri, 02 Oct 2026 11:22:09 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bcf9:6140:24a9:d1e7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c2d1sm10551449eec.4.2026.10.02.11.22.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 02 Oct 2026 11:22:09 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Martin Petersen <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.6.y v2 0/2] scsi: lpfc: Backport SFP mailbox timeout handling
Date: Fri,  2 Oct 2026 14:22:01 -0400
Message-ID: <20261002182205.11550-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sasha and lpfc maintainers,

Thanks for catching the SLI3 overflow in v1.

This v2 takes the ext_buf portion of upstream commit 115d137aa918 first.
That leaves the SLI3 response in the existing 1,024-byte DMA buffer while
ctx_buf continues to point to the descriptor used by cleanup. Patch 2 then
backports the original CVE-2024-46842 fix from ede596b1434b.

Could you please queue these two patches for 6.6.y?

Changes in v2:
- replace the unsafe ctx_buf restoration with the ext_buf prerequisite;
- send the prerequisite and CVE fix as a two-patch series;
- keep the generic upstream ownership race out of this backport; and
- rebase and rebuild after the current 6.6 stable queue.

v1: https://lore.kernel.org/r/20260930024505.96440-1-artem@trailofbits.com
Review: https://lore.kernel.org/r/2026-09-30-1-daily-reply-0014-lpfc-sfp-info-mbox-timeout-6-6@kernel.org

Thanks,
Artem Dinaburg

Justin Tee (2):
  scsi: lpfc: Define lpfc_dmabuf type for ctx_buf ptr
  scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info

 drivers/scsi/lpfc/lpfc_bsg.c |  2 +-
 drivers/scsi/lpfc/lpfc_els.c | 21 +++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.h |  1 +
 4 files changed, 25 insertions(+), 19 deletions(-)

base-commit: 79643295eba17affbd16ca97f3ef04c90266b28c
-- 
2.39.5
