Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACEA311C01
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772814818; cv=none; b=MLCeqAgRl0Ubli5cXECRkMjESlnibDOptK9xl23QCGsI1+qh7DwtWi/XdEUJu8u9IrhEvU5oDkXVtZTolkIga3F6YwvMTls5pshd1Ank8BnRB+KXFWKpo7tpspXCIHhWNMpe2cymxp/gTaSP7y1GCSrTWv+jOuKsPkIBAeri7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772814818; c=relaxed/simple;
	bh=soa4Mb9x9BiXMb92DMhtNIfidjS8cfTIKTboAYQ0Vc0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t2I7UdvJ+PLvdIJJCjO7G7WMvpqNPA7F5uUuy7nZ61+7KUyvV7Tcje+fjlBfZkuP5gdEC+IvdbgsH5FLhGgL3n0B/fZarvZS0yrUGAXkmws6wicAla5p+UCdhiC8MtnKfoeMJlvMOqswbePtfX0vwalFkCvpiMQRfiowBTWLWus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWtuj3YD; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWtuj3YD"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d556c1a79eso10906217a34.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 08:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772814816; x=1773419616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9pXUn7snFM4BRtZU/N9MNTM6OBp5OTyzGBpocsYFXUI=;
        b=XWtuj3YDu4pCuYPXxYZJ9wagRTUjwCJ975j0QyslqmtfNSqsCD+aUiBYVnr4P11e9C
         fvCqJYpIvgYP+dgG0JWaZSZ0Bd3IHunw8kMpWg3Nxm1lSw7SLk/dDB7XbJljtJBr0nUt
         0AKM6pw9aODs99q5PnUBb14InwBFBB4RgFG3t0so5VNLOVKHZz48/h0yB9ADzwvNkVv0
         ApM1ynN2B0G1+TMEryQTfjrmy/XBdgjH3GAcBUkizAoyzPBtECyBVsnOUBmQmoO+9ybJ
         A84FnQXTcmDm1YIi8j+VygEdMfJu9Wm9SePcxSNEcfPKyw3/pAl/5aATT4B4YBvoqqQp
         0z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772814816; x=1773419616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pXUn7snFM4BRtZU/N9MNTM6OBp5OTyzGBpocsYFXUI=;
        b=iONF+/5XPYa//QngPPl+7hRugHpXOm+vxw1fNOjwY5LKpayhHwB7kfUuww8TojH2r/
         cZpQCC4yJ1beGQ1tYYL90VGheLaKlCQuiQVaHS1n2GgywixXxl9dt+UyZ8+SDQtNSe7b
         Q6/zSlWFrx4O/pruGNBkVL9MpHchS4NoOZtqVo3uXWC0Ac7p1S35/hgd7zID9sdXbrTn
         bdUvTnkPUYf115rOLCzL3DHGTfGwEo53NHCcUUHtnI6XPC6qsO0JH0x1fw6XR2vno/1c
         kch5h6GIt//XUXUNHe2mXam7p951Qw+i3toDGxBMpmbGFy6DwAncrZ+3Gnytnedd3st7
         pzMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7r7tdlhAGRgXQ+08TOg+wmaCp1Ccb2LYd1A14t94SV16N6dgcigFnpdj4/ccKvWSYhVpAACA25jyu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw36yjlJrG7wORrtOJkpxcThdewX6gOA9c3j9DB/fyCD9HJzmkx
	4tTBu/FheRwcpzNc7vH64QT5JMANB0LhjfpM9zNFNsPWpkblGrboF4C/
X-Gm-Gg: ATEYQzzexCKmchSjNfV9IloPBs2iNMNBBjADbse0qkkK5YSOhxffNWx3TmnJZ1H2i6W
	8uQ8laPnSnjqPjxbNRYDQ3AP/aQ3w6gvFKzjNhgCi3nYdumJimuB9sRSkr+mw/jaKZDEmCI3iiC
	OIgnrsvyd7HxeLyI8+70tp+ivQglYtiWS5ksyVZeYTVzA8q6o8yZjePxMMxS3awS6Tjte3/oCed
	bp/wdYV+Vi4iMefYgPJJpJ79F4NdB79Q+iWxUV69hh4MDFrGp6KK6vsyoyPtQzzMFODtNP2ZSQN
	pYPzMeFfp7ZqrdoUZXkQeEYjrJ6AqjRx4K7XPAlFx46ynsxwCGpAoPZJrlbUBTJWNKGNCYdV8dA
	LxujmhsnMTKePwDCBC5u+gG32QThIzw6YBrxRxpx8e3uHniAjhCE/7Jj92VutkIgv8CgbEjToZu
	VGrLUt/hbGnV3laL35DybG9Sp69XGJDbaQGfgIwJ0dqIA=
X-Received: by 2002:a05:6830:82bd:b0:7d1:9e9a:a55e with SMTP id 46e09a7af769-7d726e96dfdmr1929554a34.11.1772814816456;
        Fri, 06 Mar 2026 08:33:36 -0800 (PST)
Received: from localhost.localdomain ([143.166.81.254])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d728c5b5f8sm1202567a34.3.2026.03.06.08.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 08:33:35 -0800 (PST)
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH] scsi: target: Allow FUA if no write cache enabled
Date: Fri,  6 Mar 2026 10:33:10 -0600
Message-Id: <20260306163310.11065-1-stuart.w.hayes@gmail.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify target_check_fua() to allow FUA support for devices with no write
cache enabled.

Without this patch, accesses with FUA set will be rejected, even though
they always go directly to the media when there's no write cache.

This is needed because EDK2 FAT filesystem code sets the FUA bit when
writing, regardless of whether the device advertises support of DPOFUA. If
a UEFI pre-boot write fails, the filesystem can become inaccessible until a
reboot.  This can cause linux installs to iSCSI to be unbootable, because
some systems have firmware that will try to write a file in a
vendor-specific directory under /boot/EFI (such as /boot/EFI/Dell) before
attempting to boot to a UEFI boot entry pointing to a file in the FAT
filesystem.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a7330c4fedde..f8da0dfcb5ae 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3684,5 +3684,6 @@ target_check_wce(struct se_device *dev)
 bool
 target_check_fua(struct se_device *dev)
 {
-	return target_check_wce(dev) && dev->dev_attrib.emulate_fua_write > 0;
+	/* Allow FUA if there's no write cache */
+	return target_check_wce(dev) ? dev->dev_attrib.emulate_fua_write > 0 : 1;
 }
-- 
2.39.3

