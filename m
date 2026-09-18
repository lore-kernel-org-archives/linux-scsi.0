Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105F738E8BD
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753956; cv=none; b=bryCQEThDT8CzWEkc/H7Ct7hGv/uFEnkQfjonOFIQnepyZOobNRfZ6nIRygt71h7QG1Vs4rQou8czc3bdHMPXciTxn4zP2CJygqYgUh8v1Egm0quZ+c8696ZGD1lq8SzmAS88q+3lcWF8lKhDYdMuUKrGfuK00OqiGVOx2ySnjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753956; c=relaxed/simple;
	bh=FhB3MzXvMRrT8tN3nejFN13vQ0JrcsHthrfuNz+/Pqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HQtvS2YFACTnapDgoPggWukWPxLRm+VW1zNcNEnjlsE4eDhvfFHtP1UqrQCDqlpK+2T6QXfUKZ6bdZVhoPk6TAKKOyBSi+SBsZ6Fj1ksejHBlObXkzUkZNfnWmYYQGxDvEv7XsxcocO7sO+Z2/jiBU3TZtL4oBG/H523h1pY2C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D/Bnb0Ap; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/Bnb0Ap"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b9184fa80so1090100a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789753949; x=1790358749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kxgu93Rsz/WkmkOGG8BARMKb+vTZl3FHpJlkwcMBl3I=;
        b=D/Bnb0AptX9F1ivlBh0LoAvDI/xcCRjTSP/53jUFJtiYhAqEjfaASUMKX4pInBO2Ix
         RtRtLgw4YONzV1QHJEkuCiSLm0nhETLSx1Y3vO/Oj0gxhkcz6W3iEnHXwitxBMWmkE1s
         c44JLb0xR5oeTnzOyE9xxagB0CPQ3sGMsyhMZVyUhTK1OVYUISRH0Jgpcrnd6q6dGMNV
         VOpNX+281mXYB3A3KXJg6iPYW93L4oc87JZPqROPoj+EODklrEcweBYsbPKjarQPwYzC
         94oJqWqopH8JaB5+CRW4T8VzMuWRKrC8nAOC7ypqiWYb2lXL0SvAId7RoSDz1BfLOwAY
         exow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789753949; x=1790358749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kxgu93Rsz/WkmkOGG8BARMKb+vTZl3FHpJlkwcMBl3I=;
        b=I9UIA+L4V/gfMC+DvZcMMFE6uX3YllGA8Z3G2oXGfC1yFMf5YXqvOvK/8E7MZO1bnU
         5Zt1yTS0G49vP2nwW01r8lahgwFuUF421LGG0hncl1owfz0EBB2pKMlaza+/ps0TsDIJ
         oURHGruVQ01KmaBxDYVKnoyw1VbQ37dqa/DlMnfk62oeEFEulfq/VKdsRkdWC4vFT70n
         NehUvfSouz7RySdcpCoVeMtAfUv9MWOWo0ufosv1Dp4OtMObcclhy9v0VXPHGR5XUQJc
         RXKIttCZIQJdzXDH5LiGEPY9V3+rLbF+UtyiMLtWj2g4mUJssr0liR1U98L/dNzpzE1E
         CfJg==
X-Forwarded-Encrypted: i=1; AKwUvBwJjhVfeb0Xcq9CyQq30j+0HjqaoD/mcBED0aL7I5HFU9B11GC2EgF4m+1E12k2KMSrYqRzDhHm4S1I@vger.kernel.org
X-Gm-Message-State: AFuF++n/gWxAGqlNZwmcn1hI++YIfY873KQFjqlQ1JXujzRzajblINAE
	JTtWpP16DOetTbCVwWrtaR0RejBW/g0GXSFNToD+reYmEQvpycuXZtXE
X-Gm-Gg: AYBFou1PAmD6KdRWrYGrPiGr5hPEEf5Xy/PETg+1eixucez3ZZq7ULWussuRteF6ryM
	pF3Mi1csL+0GSbxVDmvsrvjrRlhmPAn2qDGiB8rVVc4Nxx9Z1hgrkGSZuXpGALridEZumVUdHTz
	CrijTErj5w2lM0hU0uXFZNKGoLA0lJqHHz11sZf2oqu8+VSrM1ScpGQ7846M6lt8daPIeKES9w9
	F5s6/JldC8fqwxymCmNK3KGnSjT61Jc2E6bE4x+sYyyyxH74na31SE+lG3W4gjk29htfZ/ekE4d
	KDmUZ4PRVKUukFnYp6kJqolQJ7NvryTQ7Tty4f5beZBBtTKgiA5nP45n2YisIG8omhi+MufE53i
	o+tNyfSGOVbOEX+bogW2sCM+qgKIIfx7V2Ml0FQoe0JfPdn6maeA7ztZSyir1THABYNzifJWq15
	velLTAtcAHy5SEAHCQhMc9o55ymxEP2wl1MQwi6pl3wCmRXRcSYs0EEKk=
X-Received: by 2002:a17:90b:2b8e:b0:39d:efa9:cd25 with SMTP id 98e67ed59e1d1-39e54c59c74mr12953197a91.2.1789753949341;
        Fri, 18 Sep 2026 10:52:29 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c3145dasm528803a91.4.2026.09.18.10.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:52:28 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sni_53c710: put SCSI host on remove
Date: Sat, 19 Sep 2026 01:52:18 +0800
Message-ID: <20260918175218.3616645-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

snirm710_probe() obtains a SCSI host through NCR_700_detect(). The
probe failure path drops the host reference with scsi_host_put(), but
the normal remove path does not perform the corresponding cleanup.

As a result, the SCSI host reference remains allocated after the
device is removed.

Call scsi_host_put() after all users of the SCSI host have been torn
down to release the reference acquired during probe.

This issue was found by manual code inspection.

Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/sni_53c710.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index b504a2cc5041..7c5b1929a6a7 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -115,6 +115,7 @@ static void snirm710_driver_remove(struct platform_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
+	scsi_host_put(host);
 }
 
 static struct platform_driver snirm710_driver = {
-- 
2.43.0

