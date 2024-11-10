Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62193A923
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268088; cv=none; b=lPJ40a3gB5HA1xXhW2sAcfrb2H5Ymp9WR2rCMuoWXIXPx7ySekASZVQZHsuJ1Xk/YnjFVrk1trRZAbGeh3YzVL9bUq3RvPZMbyJQ6YeqY4i89gLTdH8YQtZV4+4TDrTDUnN267BUQXHQYFWo8elqvpUG5YheFlIKN1Ic+gLT2f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268088; c=relaxed/simple;
	bh=hzCXfHfW67SjgO5O2pziickemf7vfWDhDW72/CGJ5ng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dX7AfQi/4iO6n2PQ1JiEXpSaZExe7/dWGYNaZUxByc8yV4eFGFT/7lhdlqrjypEsXp/NLMiCkYzfHjNi8MReusBpU4AfUEL34fMMcdjQbbtLuI/0fmf9weLcSQpDeD0COi6c+fU7DjWHjt3ae7Wz2uIZPnzHy1Z7ekurb45vzuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ddcsKUz3; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ddcsKUz3"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c7edf2872so39080685ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268086; x=1731872886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EBIY+0O+pt7fPTz7+QgoNQ+K3HhWf2LUMic/OhdXTZA=;
        b=ddcsKUz30gnj5fqsmOT49Jan2cWmfpvjjlgTiTSAxqPMjUtz5jQHwSzztZDhbueq0c
         vDnEHIl//dsbsa2yRL5BGTJaqdfuHc0fyxCNZ6okhv9jDgUh7RhntJ0B0rcmaQlExASW
         d18Sd1m8nKS37clAqdaWF1Lvo3lxVoAbtipbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268086; x=1731872886;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EBIY+0O+pt7fPTz7+QgoNQ+K3HhWf2LUMic/OhdXTZA=;
        b=L+Ac2uxa/r1+ZdqqTB8FPY1bwdMhSK1RWTjW1fMX/IPGcBTYWRVeE0WTL9p05LjAhR
         rChzqRGYcvVx+zpizYfmA2I+Z6wsI1Kh3Tx2yCIMAWnIVsJDr1TFzqKTaNug7kY77Qkb
         xOgAFra40nDfxA/JEx16i9N/L3pA94Dmgwycf14yyfdsMkL7Gbz5Yl8WjMCJ2RPhAf89
         yPif1Mt9nirbYdzEj0kpbWopoEnPDNz8XUDPWUheW5vlf298Zv26QdOhPeFZJ4FIybck
         EjLt2cnfDwA4wLtBTIU2/+ZlQu3j32znhBHJ47IsKO6cLzsnL7bm4/s1waEE9I58kNSo
         U/1Q==
X-Gm-Message-State: AOJu0YzW1b9U5HZpKFkFZ2LSbg0XJqCkmLjtRp16ZC8/ontJ6QFsGOCI
	R6o7rJTQt82hkdluajJshfxS/vS2VYkFihd+ZAORzUB08tcm5nmGJVzWsxoHhhsJUBkIkBjaJ+K
	fzqs9OqZqJF9XFC2N2HMQ1T5OsD+qV5JpH5nlW/ToSfaaE0uIkFMo7Tx5zbja+pbtCUncwCScPW
	bfqW3NfA8gkk8n3AFGw7FocHxD3QG7N5KIGQfG/+7E8hxpMg==
X-Google-Smtp-Source: AGHT+IFkZO+dnhniHHNLEvlxwwtbEAd1/RW8EoA7x5nzVEbvq3qHnZjvszbKFqZo1794M3UPwzfbog==
X-Received: by 2002:a17:90a:e7c1:b0:2e2:c1d0:68dc with SMTP id 98e67ed59e1d1-2e9b0a50f2bmr15810626a91.9.1731268085664;
        Sun, 10 Nov 2024 11:48:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:05 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/5] mpi3mr: Few Enhancements and minor fixes
Date: Mon, 11 Nov 2024 01:14:00 +0530
Message-Id: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Ranjan Kumar (5):
  mpi3mr: synchronize the access to ioctl data buffer
  mpi3mr: Config pages corrupt when back-to-back PHY enable/disable is
    executed via sysfs
  mpi3mr: mpi3mr: Start controller indexing from 0 in the driver
  mpi3mr: Handling of fault code for insufficient power
  mpi3mr: Update driver version to 8.12.0.3.50

 drivers/scsi/mpi3mr/mpi3mr.h     |  13 +---
 drivers/scsi/mpi3mr/mpi3mr_app.c |  36 ++++++---
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 121 ++++++++++++++-----------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |   2 +-
 4 files changed, 81 insertions(+), 91 deletions(-)

-- 
2.31.1

