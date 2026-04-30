Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1233A1CE3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777585074; cv=none; b=XDLwFteY7DxsLWsVg68AFrDaU30kafJ9TEaMrd9xvAskqmEVy0+WBt5uLF8CKj3/n2LNsjs6t7+RhrSSaV1uO0gnHhEC02LF0Jb6Tvat8iO5MGGHgaI/mzQfm0rBcFUWhPUl2mUK50yD23d6wxgG5z9OwNmBI88HntBFHyiZB5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777585074; c=relaxed/simple;
	bh=c2Ue0d5dnQuSgdhyZTErCXmSWET+7z2AcM46R4grQiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p49Eh8cblR639BdruWvFsBS8pYx3k9YOznWBlCe4EKk4mc2eo3No+IF4UAw4koUIsmtBC8FLz6OhtOFGdGolZ37jMmxbJ0ZW3hYe9mqYQLqNun2336fv4SYXU2+nBhNc5YL6EGtkZ8dGUpgnDL1+PsrpwXq0pZu8pkLkFsLK7Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sD8Y+TDa; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sD8Y+TDa"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8f231f3b130so100979285a.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777585072; x=1778189872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hHJoDDBr2oAx8wtDzL3IYfvbd18fgZiJD6KgdBMVEpE=;
        b=sD8Y+TDaDC8j+WlMpMnW/frQAtMujBnUG6StUV6oLXa5wxQW/dyYCg9iBQMmYkFKjx
         E3Opv4WtnLQHI6H0hbB8i65DkHzuwF1sZADpzy2XmeV9q0nTLgzMvYNGPSoxksqPCPc1
         LpoRwl8y25BSdWmBfHB/dGG/PZDjb4RMr9wDUEMi+nibAP0VBCUdGYnuN8UmacdXdQ4Y
         8FfuwbXa/BHGHwcJhxOUaJMAyU2iQm6nTv0KZDI0UJzz/C5HZeerU36E/Tb0UEvvjuWD
         bSkgbXOUYq3sxaDINsoPUPqnI5VWhCQr3PYauSD5f/QC2IAxeYbQujYMsb+kL9AbVyrA
         UEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777585072; x=1778189872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHJoDDBr2oAx8wtDzL3IYfvbd18fgZiJD6KgdBMVEpE=;
        b=HSnatQHSmBzPgEwc/GYe4s2+6U1jmUi8kx9qUz+s2edTuzuc+Y6W+ZDCaX35S4BjEx
         zyWPrH6nzJrcZOOYv0FS+e9i/qGgTHc7UUYgCOQItkbH6fSaqCyvTfFhT+NYba3L0HYS
         U1+ry3T4dNsLiXKqrPZ7rthO+wt41fnkO4bx2mfvaL0p4/dzS89ynTPP5GuKZduKOtmG
         XQ8tYXBWc5iwgE3LKwhOqrNeDcJ+3b2n3H9q3X+XEBFazJjfPix//pdHy/KbTlHXhUiV
         060YPKH4YeN2rSC6Sb2m9hwKO/0N4Umy4Ts6w0GH6r0ZlYXfBowQ3T6vwlwY6sRDFei5
         quFg==
X-Gm-Message-State: AOJu0YzIEb7cQ+Xs1TZk+ZbY4YTm28rfHIIStBtovABE1f6BZtPltGRy
	Z5rAXYD0uUk68xJLtLHFwxFrkCvJ9zksUIQHoDawBw8WAkh/YS0137KMzpUOzQ==
X-Gm-Gg: AeBDievY1Ly4ujEuBOoWLh4yS3asFoTuKQfbjYak86bGt3AxF7+i6VCAo7a+VHow6xY
	sdQkb/21u1nm9AVpFT72xnC3Ep/NN3txnzb7eykR2UIcqbPjGXk7NUMsqPLjSNvnXXgeN2WS9Cn
	0GRljBnuhk8acS/YoSA/ewwzNm4k66aRjs6DdfvNiLt1LsVdDgCg9j9K6JK7NIFr6NqZZyvoADX
	k0B5EC2Sy/znm88UPH2142NWlsI/Ay+ohRIP6tmxaTY6ytzdCo8lAA5w9bYWhmkZQao2NY5Qrlz
	XpAdGSfeKCm/LPw/Dru2BSVHX/mPgQH43IHgubhUqCV76QkNCkTU2sgkSCcKSeOg5FkvH+IE5ry
	/D2x/qI+EyXJ0rdDAPKIPa54rgwxNylZtIX1g9cotFLdDIPHcG4IdzXZ5mL5Y9tHK4cEn7PmP+e
	tHNzg6b3DWQiY8EatSMSg9lyaw+DrhXesvIpK4xOux4Ox1aKrM3CzC4pDeRZmuWJPEJ2JM6Y7J9
	BMzRPix8jFKVBnho/BKcKTlRt7/DDcLCCCF1fL1qsI1Mw==
X-Received: by 2002:a05:620a:f15:b0:8ed:c0bf:2c24 with SMTP id af79cd13be357-8fa8a0e1779mr743357285a.62.1777585072297;
        Thu, 30 Apr 2026 14:37:52 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fbf078618csm28281485a.8.2026.04.30.14.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:37:51 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCHv2 0/2] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
Date: Thu, 30 Apr 2026 14:37:31 -0700
Message-ID: <20260430213733.54840-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split up previous submission into two patches.

v2: fix unused variable warning.

Rosen Penev (2):
  scsi: be2iscsi: simplify cid_array allocation
  scsi: be2iscsi: simplify hwi_controller allocation

 drivers/scsi/be2iscsi/be_main.c | 33 +++------------------------------
 drivers/scsi/be2iscsi/be_main.h |  4 ++--
 2 files changed, 5 insertions(+), 32 deletions(-)

--
2.54.0

