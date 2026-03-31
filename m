Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BA73590A9
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988587; cv=none; b=ORabroq82qknOfVKW1bbAQuB6zei60c5d48tMAlZpJHZIWiEaos3FogkdPzZ3yMI4LbsY+mWUxkCUbg7Zk1I+1jcbogfIZfq+wSuwryEACLrdyEAGkj2/fkHGxXYMgKBV5S4FaApfkOGT1l8gLy0aCNlhABrAf8sUdtsGe2AxM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988587; c=relaxed/simple;
	bh=utIl5z0r4yFACrcwAndbmQTNjo8IpN7VukoBBQ1jmqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hIAKs7aNKTOgCgMQym/RGs9a1AD0hfO/mPFKGTVuBtVzUZLZoK2X7gMWGQ6+aUaCbJH5jgM1mMyIm3V+qEEmq/uYpMGQe7iBkiPx0eLg1QVKaF5xJfin4FX4xipwO18isBYmB+snJgF3IKYQrEEKSTw1q6VR6bkObTiwNW30eMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIaoUQhR; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIaoUQhR"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89fc4147f2eso62870066d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988585; x=1775593385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxbJvSvF5eWlWDfT7/r6Llgl9tNW5Xl4MZ4vyx4wsfw=;
        b=aIaoUQhRjUAA1kNjfU+C/7zkuZtHobaZQk2s7d9B9/o9Uk76eXUEU5WX2LuNKOnjlA
         8Jgx4kjOcEHgTMiO94HDaT7fAoPmiLgBzK70nvsx2WhXsu6RDVnPzedy4rWXPd/CKhlL
         Hs8bBN43DO15cM7sv0U/rCh2BLxHybom+8rWZ84iwnQXVwOHCglQGpRG3tenJ/p413Te
         o7G3uJpGdTZFFfdPs5rlcAY7j5oVa8OQHVzOCav47zdaDsJC5tamAPL0slvL1jujU+6S
         RAD/O4mgkJ0cm++W4bBt9Z5grlDJGH0edS4mRCiK2/m77BieTSuXSzXhdfQaJcIgblhF
         1yGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988585; x=1775593385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fxbJvSvF5eWlWDfT7/r6Llgl9tNW5Xl4MZ4vyx4wsfw=;
        b=AB0EiUdsVBm6Cm/XT9TuhEeOm6tivRZJJy/shnMMh495qOLXKcEVq/IEmsWqCswyYx
         0dK1/i0vAZuVZoNhCekRXBaUq+lA7csQ/B2ezJRz1TG6GEpJEY9gcxyZVi/c7DZlozDz
         jynYHZS0rhTjXc36BP+pSR/Yb0c8VTyd6hngGEfUvcP27DkSmswf7r6Xn04G5r8uwqcN
         061kGpCuOuB3JlHjEkW3er5W32fDNqj+IQtza1+pjPEIg8hFQdfXtPD4HIM5HnAt7HPF
         PbfZ0fAAhfgyNsm/+P6vtLvQClyKM+u1504sUD2vcS/d7UTewVxySbvcwtkx/k0wplyM
         QQig==
X-Gm-Message-State: AOJu0YwRlb4PhxpbIGbdaMGIbD0lHViAZPBszGYHZlqS2PCk7EHaOedr
	gkYsvKaZPnpyUhwuKt778GAz9YhDJaIQhTKyeD1TdWvWTl9YuqbOvf7zajGZnA==
X-Gm-Gg: ATEYQzyDOk3fyYyiHOotQ5wPeYm+PICVOsK2XyCIpp5qKmCuxCzDEH8B3Sm7/Ic4kKy
	ed8D93cfGtmADJoN+S6/moC5Nc9sWKD/RnQAs+geEZySYQQRARSkmJEusfmEqk1j2nl4BtyBLZP
	JmWLBCtvj7F3z17fnP3F6brNy7Y1cVWnb74OKZIU/CjyVAILTjKNIvGIoUyI8m00UGwEnJQGSHV
	VETgo1X2CgU0kmG5eSZzl89AaQFJsT0y95yRQolPCq0csjhjRBzns7fPMJplK61qi8Sopeau+Wl
	+GEcXm01jK8k2m5voo4R3ptSdooW1bRMMMLDxWMDE4DrYj6ekYPWL9eX75L1ze6tx1flMAphv6D
	BvAf2c3qXFip9J+gu03oXy8E75ly8TwXOPVnCHU/hKQ5qMg6g414HaXAN8tHMMXCMbjb8NirhDe
	jIsm+TDclhv0KGGpyWtDRrffZhW9UOhpecfF/1a77lXOPEgm7VZ9CkUMUK5XTuQSyFPYZVhjTd+
	+E4tH6H01NEgMSMoD9gwMU21QRer8ywD/uEo6UAy+g=
X-Received: by 2002:a05:6214:1c46:b0:89c:c668:9d3a with SMTP id 6a1803df08f44-8a436a23dc9mr16597216d6.12.1774988585088;
        Tue, 31 Mar 2026 13:23:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/10] lpfc: Select mailbox rq_create cmd version based on sli4 if_type
Date: Tue, 31 Mar 2026 13:59:20 -0700
Message-Id: <20260331205928.119833-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When specifying rq version, it is preferred to refer to sli4 interface type
instead of the get_sli4_parameters mailbox command response.  If sli4
if_type is 2 or above, then the newer version 1 is used for rq_create
mailbox commands.  Otherwise, version 0 is used and is meant for older
adapters.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cc2ecfe1c907..aa3917f4756a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13716,7 +13716,9 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	sli4_params->cqv = bf_get(cfg_cqv, mbx_sli4_parameters);
 	sli4_params->mqv = bf_get(cfg_mqv, mbx_sli4_parameters);
 	sli4_params->wqv = bf_get(cfg_wqv, mbx_sli4_parameters);
-	sli4_params->rqv = bf_get(cfg_rqv, mbx_sli4_parameters);
+	sli4_params->rqv =
+		(sli4_params->if_type < LPFC_SLI_INTF_IF_TYPE_2) ?
+			LPFC_Q_CREATE_VERSION_0 : LPFC_Q_CREATE_VERSION_1;
 	sli4_params->eqav = bf_get(cfg_eqav, mbx_sli4_parameters);
 	sli4_params->cqav = bf_get(cfg_cqav, mbx_sli4_parameters);
 	sli4_params->wqsize = bf_get(cfg_wqsize, mbx_sli4_parameters);
-- 
2.38.0

