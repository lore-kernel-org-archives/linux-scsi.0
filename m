Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4523DD530
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782322897; cv=none; b=aOS7JUt3dprbEMYKNSebCOCDnnDjy4ETKNpjoDW2PRPjIwlOcnWMm5y4kJDNZIa2hlz5zSsWbEnThrORXcLbJbIieSWctrtqUCz3mNBds+3UhaDdeyGFD1uEtWx9G9cgNFUTCDSw8CKmxxnwn9aBrL4sE5jWRrZOZQZpaDbbhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782322897; c=relaxed/simple;
	bh=npyuxLyC34N4ailXQ+nN2GEYKireZlUeTOmaMfKtfLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fazu0nPAlLBnXNK6s4KAo2dlsqfmZpCvMbvzOnEZEHTOrCRQhwykW8A1UrD+LfSYgT4Bmfq2qypZFDnKa3czEc11FVDl83bMfemHf9zPqRjSp4K18PdlySeiwLR/8YvmuRvacnMouBczbyFq6mMaSyItgZaFwKfRwJr2eNJDpXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxjqCuFG; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxjqCuFG"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7e1916922b9so17938317b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 10:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782322895; x=1782927695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bk2JWJT+IMK1imtRA+Nz3um6+QfqqNZDkbSELUA7PEg=;
        b=nxjqCuFG3LIp98+1Bn08qtyROwK1GOxIj+hakkueETDMYulRUZGwcOr87r29KvNaMW
         cWscjKsZOFeY30N4kZjoTW5tPoLP4yWdLNd61jqJd6tQzfibLqQokv7+OxvUFqZRR794
         TQgB/xb9u2zMoND+FBV8qRtnAR6NXoC5Rq6Pg7VR3BnwIYyq6UFzkSJfqPa72ho/wedQ
         hZKGm4/eYIslA3EfvUyZ0qAJXg4f2qvgftBuCWgRepEaoSxRQoO8ulAkvifjyh/4SEv3
         xUBJ0v01GNWUIUvihj2BeNySy1E+FW/B3+hBi96F8uWP1p6PbqFA+Wh3TfLX870FrLkW
         Ep5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782322895; x=1782927695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bk2JWJT+IMK1imtRA+Nz3um6+QfqqNZDkbSELUA7PEg=;
        b=YtdnrrTH6H6KJQogIV6jhP9gnOB8wBvtMrMVg4CGdDOw6+eDZWbY1Fu6lqtwSuhUTj
         fQWMAgyXj2+NxpnSBMc6Vmu0UV+Sw7U7Xmi/pdtyyyzk66vgH8MVZZBAFf4HkqDSfSiz
         spGeQsvdGbcSI8HhHIfFe5slpwDWss5cF7IpAXD9auKzzv3qpzym4UJZYM/VFhUhHGdL
         3Ufy5zH5wO9tvS2WRNlv8IkkA0djl7oeGZRMhtbLMAMepKKs74ISFWdMlJ1cV48IKPc+
         g4PdA+YiPaDOhXLpxXbw8F/ig1QsuCZ4+Rvuj8ogfTXhjyJyNrMdvaTSQXu9Ki6SvNqr
         vb3w==
X-Forwarded-Encrypted: i=1; AHgh+Rp036AmMZa+gxZAxBC6I2L0uh0oZYL0Chyje1fslOOWMksbgSk0I6xSzWlK4SBWKV1WZqvBLNg78F4l@vger.kernel.org
X-Gm-Message-State: AOJu0YxqpdCl/6aCaQHP4oDJSNEwhnFrDZCIr+mK10HV/PrF+KekOKeT
	mL7XYF2GQrnt2AXIM10FQiiaSPw70TBLfanfy1iqi3kOhd3IOPezUb5E
X-Gm-Gg: AfdE7ckgXznDrkN2aJyZ8rDDO1TUzFIspI5m8ph65aSEx5xPGEtvK7BTZTc0KgUx5+G
	hytdDamSfU7wCv4oPqyLFa7uaHTpIdq8YPcQ+u7vZ4AEuWn85/rE116tbXlEzIUe/8VrZ2Avo/V
	MAVAs4FLwlYIbTnFskG2poWQE5L9vb6f6bjMD1XQXc1er9CK3N9un4cbMtSTy9He+VODiE3YDTS
	/rGKHHClM9K+tiMHrorfOls4N/eJZTLtUEoXEwoRYMPJx6TKrLDZJr/2s24t1D063p7YNJFz8fu
	9495F35bKzOMDxVeg6xB5VmNoEORuI0GZPuOxcgsj/k1EFgOZLk+K95ztTX78X2KT/qvNg/REkp
	Vsp7SJFi21e15H3vJGKfxHcPMiQD/vKGa7fmhW5LbYNKrvgWwO4bjsKvsvvUUeV8lCXvcesyNUM
	9oQoIjQveC0eDhwduH3usgXV9tyKqvaNcHbTn7
X-Received: by 2002:a05:690c:6b07:b0:7b7:5f48:d9ae with SMTP id 00721157ae682-807f457c51cmr41718467b3.24.1782322895346;
        Wed, 24 Jun 2026 10:41:35 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025f8ddf97sm61766847b3.29.2026.06.24.10.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 10:41:34 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] scsi: megaraid: cap passthrough copyout length
Date: Wed, 24 Jun 2026 19:40:53 +0200
Message-ID: <20260624174053.5274-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MIMD passthrough commands store the DMA transfer length in dataxferlen.

The common ioctl path copied xferlen bytes back to userspace instead.

For read commands, a larger xferlen can expose stale DMA buffer bytes.

Those bytes are beyond the data returned by the controller.

Validate dataxferlen for both directions and copy back only that length.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/megaraid/megaraid_mm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index e57266590..75f6b7198 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -480,12 +480,14 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 		return (-EFAULT);
 	}
 
+	if (pthru32->dataxferlen > kioc->xferlen)
+		return -EINVAL;
+	kioc->user_data_len = pthru32->dataxferlen;
+
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
-		if (pthru32->dataxferlen > kioc->xferlen)
-			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
-						pthru32->dataxferlen)) {
+							pthru32->dataxferlen)) {
 			return (-EFAULT);
 		}
 	}
-- 
2.54.0

