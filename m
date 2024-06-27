Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B167196D9A
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719504048; cv=none; b=ppBaY1pYUhOCM1W5nuu3zPw3/CNpa24344aEXYpDXHXFOvAQ+Uz3R9WoPoWpgIZwvom6nm3UHKbyOPFboMURbbQKf/EyVgeKydloAigwO4rP2hJUVGYX8k4YyQopI5xwxdfMZMxB0pvyY7Qu0eFHwn+2nyONh+0r0MJb0Cyo67Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719504048; c=relaxed/simple;
	bh=PjFxXhZBQ3YOoiLUbSULnSeyZ0B4n/ydFPCYsgkc8zo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KeR3+4os1KumCYkMhUKIibK4dWYW0J8ebCneH1fycJAL6mYFiSWXusFuH+OtW4q97QhN2Rycpw9g6oqDy48cN4mI9MWy5enicKh00Ohe0uVdwRfxrR8tPw+wzlpGLjUuWldWBc1QqD0c9y+nnARRh/+NRnXDYnQFi3VLKAmNzrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MOlWlj+v; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MOlWlj+v"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-64530966cd7so90879047b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719504045; x=1720108845; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wBmflmuG6b3QD/JJZqnH7ANZPZOxKvJMgQxIVX2Hods=;
        b=MOlWlj+vuZM/yO66VsaRHz2NPjKhDUxYl7A1MQ/udGGBEbI4DE1bpXg+H5snQ9ooHm
         +N+TtrWoA92Mdy3mNU48pQy28K+sF5fndaC+CVN9IygFKdq+HoixuMhH44iX5/+bxfWR
         9usaHmbTJIVawf3Zr/NhEMm0JDyKNSBIHxrmvYf3mtf/R0i0KaeH9MJBTFxA2SdMZMc8
         klvKJ+bsZprVi/uT//X8qOrsQjeCSlH5rqByVEQKJZ3NNUz1DjDII7LbM/k3Blf8IlD1
         nMhSMIJK/lRWJ+hYg6ov8ME0U3afFrlS5qjnGvmnIx+6jGIz+5iA5ZmyTGjo3ELhbrT6
         O33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719504045; x=1720108845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBmflmuG6b3QD/JJZqnH7ANZPZOxKvJMgQxIVX2Hods=;
        b=ofin0db96t6iNfF7yYwkcUQ4tI3QaMDC/W9d3jBkEDALmH37tMbCYcFChr4jea9Ggk
         lh7Io5qUZWdThlSUXY2w24cR6iig21TzC5CBViKMEcxBbuHmaSnUDq2Hc6w+rfWRpn8e
         0+SUbAUZj29YvnIte5Q9RcD6s/GSCUYoD9r00IZCL4kCo7vnPBVVJu7crBEabhVkxHiV
         Ln2Og8sNKwfNKTFDwqC66GPq/e+0q/ayuhDFlNIlkmrY0K0PB0l5TY+GbWTQfY24A/a+
         UkTcG68WAqTUu9RQ2fnvL6DF7rkZmXCdG9FY1cR+dPAq+mkiZybnaJq+v4hyzn8nyi0D
         YaPg==
X-Gm-Message-State: AOJu0Yz1QSV8dHI+RMwVLbgZI5LM/TbyZCVk8N+/T4iQqytkwJTzC0DG
	lLeEp+WEyHYj4TLH7abalTcR8yNx1hZvbDxzYmSNA17op564fe03LFkYvHbLBsyKcqYI3wxa//m
	EVTECqZU/cw==
X-Google-Smtp-Source: AGHT+IHDjNCDNw6QyaA7/gjrlgQDqX4gJ2i7YlTKjmmref9WPz1DVGy8xHki9sjtZsutgW1R4w16b0ZCQJGUng==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:177c])
 (user=tadamsjr job=sendgmr) by 2002:a05:690c:6208:b0:630:28e3:2568 with SMTP
 id 00721157ae682-643aba464a1mr951317b3.3.1719504045006; Thu, 27 Jun 2024
 09:00:45 -0700 (PDT)
Date: Thu, 27 Jun 2024 15:59:24 +0000
In-Reply-To: <20240627155924.2361370-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240627155924.2361370-1-tadamsjr@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240627155924.2361370-3-tadamsjr@google.com>
Subject: [PATCH v2 2/2] scsi: pm8001: Update log level when reading config table
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>, 
	Jack Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"

From: Terrence Adams <tadamsjr@google.com>

Reading the main config table occurs as a part of initialization in
pm80xx_chip_init(). Because of this it makes more sense to have it be a
part of the INIT logging.

Signed-off-by: Terrence Adams <tadamsjr@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a52ae6841939..8fe886dc5e47 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -568,13 +568,13 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version =
 		pm8001_mr32(address, MAIN_MPI_INACTIVE_FW_VERSION);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "Main cfg table: sign:%x interface rev:%x fw_rev:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.signature,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "table offset: gst:%x iq:%x oq:%x int vec:%x phy attr:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.gst_offset,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inbound_queue_offset,
@@ -582,7 +582,7 @@ static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.int_vec_table_offset,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offset);
 
-	pm8001_dbg(pm8001_ha, DEV,
+	pm8001_dbg(pm8001_ha, INIT,
 		   "Main cfg table; ila rev:%x Inactive fw rev:%x\n",
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version,
 		   pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version);
-- 
2.45.2.741.gdbec12cfda-goog

