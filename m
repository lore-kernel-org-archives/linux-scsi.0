Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA2E2AD37
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 06:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766471429; cv=none; b=qEVOrIjTRFfJ/NYgCWTHINJcji+mjGMMPMP3ZAhRMnxczlnrweVl4cX04QIvlb6aDFhVx5cWw5YfHgnUuUU9exPfZQcp0l4z1fFcPetklswaHVCnY08jjXgGZprlgLh+90JcdGOZu8CgNIUgnvVzRYr0l/kgvPRzEWIMcdwXmzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766471429; c=relaxed/simple;
	bh=UOwytaD1y1ivrxR36EtXG7k6vUSMWBbdELoZYS/80io=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pdHu7qpPQvcOUcp/qrAQW5CL0cfXbCLuJQ77PHdtaUsp3bJUKiHDXhnzoq9duysBtE9U24SfsHLWJ11FLE1yoL7jhNswB4VovmjyM81i2REGtE+cqI/vdzGkdC8E9k/Ltuzmtj58u17OIFDNOUGiQOywWH7eS3i2GeCR3enmctQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b=NsQLe06q; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b="NsQLe06q"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0c20ee83dso59136185ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2025 22:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20230601.gappssmtp.com; s=20230601; t=1766471426; x=1767076226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=txAko9zSpGY/XVp6x32IGp3T6LuAmbYnWNpv6bzw+e0=;
        b=NsQLe06quPlxn1aj3i75rRZHkx2ViwWIeW0sdVpN03nK1qKQz9h89lmExZNqnEae9H
         uGrc30SOhPThzEhMdG6GuOY189xRy+K4Va1K8HRTfe7JXPzGuZxYsx8D6S6ZC9wzEMzK
         oG/HN2iEFjKu+/GmMS0V+e2g+vpzIBoUEz+H0cDzakdh4wWAiEjrrbNNop3DoRbn3qux
         WrBvswHWG+lQVkDZphdqfd3AktBMuwRi3vJdje6Zv9Y+nP8Pt9wdvRjdqYt05m6Y+cHl
         T56Y1QN5KO2ZPkhxQXo+I0/XTSg6cEiZKf7lEfDiMBuOKc1BI4z38qgVvrfOpGTUt8dc
         lBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766471426; x=1767076226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txAko9zSpGY/XVp6x32IGp3T6LuAmbYnWNpv6bzw+e0=;
        b=kLOdtmCKJ8qOQsWT5k5ktsu9YKsLcYqXrQEQ03oFhgAELKv0aVWs44GWE/davEe4al
         bfr1wXeJ5ukP6JJfuGhsAwCvRzkJoy/LAJyZv84jzgoaErkMZ+Uy3yhWRgKL/TNESPIO
         aTLO3t9ge7jQDc9+bD6//ww3Xm7acDAkxaZtOCfuvIcR0q0to6BB60uVgemjQ40HeqFZ
         y2oqOTGMnmcUEUcNnVYPXPXXO2VJmekTH+Shc/ttpd4AIj0aXvamHeWWYD6F9GU9YFRl
         DCU1Zli7Gwt+f5kXv7uJMjtgxK7YfLKFvwtF03Bc9OF9+hzGpk0AFwZtd0uKaSJZsmFi
         oEVw==
X-Forwarded-Encrypted: i=1; AJvYcCX+CiPcQ4ZfVBjiPi2fdCUp6tVE3AItewcvRyNgOmVoWjhhoiYDn+NFDWHLBng1XLTMci7jILtmZpIJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4KLCm8YSv7/Miyce1940Ip58f2X18meCRA05O7fFdcesP5+tI
	SfL+u0Hj4SVK4X8jrkP1MTJAN942ptXl/NkXbOURjFA8HoG401NxT7E81iNER1m8wT8=
X-Gm-Gg: AY/fxX7BFWGXCd1Kazbup4KJZW0AQFtG+zFXKBCsMuGGLzoQGaEg+n9ZHUj2iYGdZhN
	KYgx/75k3qx4iQmZb2zoLm2krfDaNtaShDCaabP63ZfWPwOM+/ueyKa9NA7eFSIxTvZeS+wTPsz
	xyxPax57EwRXcP/JrS1jQnqOWHw0qn7R8QF95tFsRAiJlnjjnr6llf6Tf/ByfI3yJ33viN6/j9O
	sPvXjxy/PHpFA0w5hlTLSlbI4OtL33zPBg2Oll7FvvvPPk2MnLqmvs0a9yxrkVITwpDlshSzQ3r
	OyAIEQmCfDcZmN6aqAqAte19WVHGLEU9FwER2QFqrKmxethy+s+ehbvXPNXNgJsOPsv/p5zFJDn
	/FcJLq6uNZParar9fM2dhbOchS8NnXks7fmvHEHE1gZeNgxF+kQn2anHW54Oo6XHuCwmtWX9NsW
	VKxxvDainEbT+7uhIgDaWR4RXQ
X-Google-Smtp-Source: AGHT+IGgb03I6lSiPUZBtWVnd1QchQMvNYrRHjdG4XZUhFVdzG/yKL5vDYSme6j4qe45ab0hfvjdeQ==
X-Received: by 2002:a17:903:2a8e:b0:290:ac36:2ed6 with SMTP id d9443c01a7336-2a2f2426c79mr137786605ad.14.1766471426463;
        Mon, 22 Dec 2025 22:30:26 -0800 (PST)
Received: from localhost.localdomain ([103.158.43.19])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d5d32dsm116266405ad.70.2025.12.22.22.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 22:30:26 -0800 (PST)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: jgross@suse.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] xen/scsiback: fix potential memory leak in scsiback_remove()
Date: Tue, 23 Dec 2025 12:00:11 +0530
Message-ID: <20251223063012.119035-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memory allocated for struct vscsiblk_info in scsiback_probe() is not
freed in scsiback_remove() leading to potential memory leaks on remove,
as well as in the scsiback_probe() error paths. Fix that by freeing it
in scsiback_remove().

Cc: stable@vger.kernel.org
Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/xen/xen-scsiback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 0c51edfd13dc..7d5117e5efe0 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1262,6 +1262,7 @@ static void scsiback_remove(struct xenbus_device *dev)
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 }
 
 static int scsiback_probe(struct xenbus_device *dev,
-- 
2.43.0

