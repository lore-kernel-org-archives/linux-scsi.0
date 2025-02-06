Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8342B22331B;
	Thu,  6 Feb 2025 05:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738819529; cv=none; b=nfHE46J45jxEfvZoSQd712H5h7CByPswzLoWdHKveK7w748Gzi4tE0O01Ge9AB++aysYVjfPkqTv/yw2LDjT69QahOMuG8zEbWuumcP9FwKlVRNVz2EEnzPvVMjHMu3IWjMpnWojpQZKNYPm+0yE0AkOw2dFoiZHepECVe3AJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738819529; c=relaxed/simple;
	bh=vXyCl9SilfkikfO441reB6bkS6c3y/DfUUW37yY2Uw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bTXtenSS9Bao6NkvTYpHn/EyrD0SIqKrYLQ+7kEuVxVZrQ+W3WGF20YXfsfHhZ3jMu0pR2hGT2NaeVz28mLVnviy3STFqOllpDGpom5xPhDE/pkQAl3Vr45Cv73X1tlvM5PYtkuZoHLxDFC8oiE9rFBk7jq7YQGbwSEGFfPlmD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WHGQjNvQ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHGQjNvQ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4679eacf25cso3374561cf.3;
        Wed, 05 Feb 2025 21:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738819526; x=1739424326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mibdIAvyUautevhu0ZzHdeSyLXYMpG009IafaNwdP0g=;
        b=WHGQjNvQ2l+2lLNNVw9X7o2N/FrQdqPz4kMEksAMoKW6cz5vuv5r3sECnD5+x9sINB
         fhu5QhdvbWajPjhLh5o7Oor1J4ZHAGwIIWhhmweMOsoz5WG5x0qB7rhiZno6fDtuMR7f
         7C37g++PuSCnIEa8u5hO42JjVC3zG1pN1zfxO2C/M2rJBAALBSj7G8yu1CPXJ+fMAa99
         YILKbcglCJf8TZGy5GCcgiKkhoiZPoNPGd5ar3k0oRElubUHm3HyOWlDNOGKHuIY4ODK
         jtdTW3y+v26KCSpgSU8xMP1cY3GPliuWCyz2ULopUGRtiBwWTWuHIeOVOas/GWs9Jqpk
         S+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738819526; x=1739424326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mibdIAvyUautevhu0ZzHdeSyLXYMpG009IafaNwdP0g=;
        b=s+t7NDVqIGf1eIsHPbm70W6FJkI3qYnVUo0WwOI23M0eSuZpgFkYcFP+XuOX5wddOg
         Irp7ULnepujb8EH8cBA3qGvjzIW54RCr0Xy0Nuqr0QfBY+B4AvyerOvKvrP4wcUkTt84
         jkVOVuE9DmUJC8cdMFLy6j5e0dVf5eNopA2c4bHPSTMhRKiMHCj+MBLUEps9GksmDrL+
         23k/mzVLFhbmxlYdcUmH5EYL+4UAn8uAPTU10rxn7Xl5vdx7ZXlrhirMXZHYM+3185N1
         DzSJcyjMuPSNgKeQnx3umgPN7VqHUCw8OlM8ZtzU/szOBwBDv8eoR0qM6og1ffl64DgP
         uV1g==
X-Forwarded-Encrypted: i=1; AJvYcCVy1HH1M5vjixZLllr6M6VDiJ2TiPvXT09RgP1GmVzfbBz3VMnGisO5KkUFsO7t62vK2FIQYg7o5Cpj9aY=@vger.kernel.org, AJvYcCXWi1fmOrprtUQP4tWikEPuHaXHjya+L4xwebaH04aonCtKk5VLfnaNH5geEoGVcv3n1yMXLszMglVRnw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw10lZrO2Ii+76UWpuM4MoxpAAZYbvLz0qZLpHVnNbQRtCR/4Z5
	cQlqtOCQgTcKv5eOXedA2l521jy+uaEAbFqHhkcxMepsO0n+oyrL
X-Gm-Gg: ASbGncvb9oJLkUtZG9FwQUI0Ii28i3sXbmr8jwUuc4zx9oxLrvgvNYNpZmy6M73SsqK
	Pa0yIjWr7NJNG6AROy5mQA3x+FYJEpp74WFmoRlyU/0ANA54aI3TZKa3ORV2kDGGc2qNiZQ+Nsc
	CKm9+iuoC9HZ7UNCsveHXjKZJ54KYL+PYWwc5zDPavvYWyYoaZNgU9ubAqVmhAEaexQv9Ed6THV
	YLf4UX9IFjrfFC9y0PjiCk1moJodhPdh4wndG69utDzhC+RRfC/zhfIuTuA8DTLEwivXyiZL+ia
	1E+2DzoL1nWA1V3NZd6lE5LZ+taPOzMEbjNeFA==
X-Google-Smtp-Source: AGHT+IET75VaOyvvzrk2GvMWyri2hYqaHj4L2oi12euyM1wZDIXh9QkXbmiFTx49jy8pIFAsczskjA==
X-Received: by 2002:a05:622a:610d:b0:466:b1b2:6f0d with SMTP id d75a77b69052e-4702829dc09mr78544641cf.36.1738819526268;
        Wed, 05 Feb 2025 21:25:26 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47153beaacasm2285571cf.67.2025.02.05.21.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 21:25:26 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com
Subject: [PATCH 0/2] scsi: qedf: Replace alloction API and add null check
Date: Thu,  6 Feb 2025 05:25:21 +0000
Message-Id: <20250206052523.16683-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
References: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series improves memory safety in the qedf SCSI driver by:

1. Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
   used/freed.
2. Add a check for "bdt_info". Otherwise, if one of the allocations
   for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
   pointer dereference.

### Changelog:
#### v2:
- Replace kzalloc() with kcalloc().

Jiasheng Jiang (2):
  scsi: qedf: Replace kmalloc_array() with kcalloc()
  scsi: qedf: Add check for bdt_info

 drivers/scsi/qedf/qedf_io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.25.1

