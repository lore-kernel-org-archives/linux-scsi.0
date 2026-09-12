Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B87E3603C3
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789194489; cv=none; b=lqHB79JEYJ2BTkWv105eD3yuqrKkcjASNOP8I87XWFuKnICLU7d5GbsZIKZBonPUdcoYRPA/SFih9j4xexR/aZyyxNOZcYkztoEs9H+ezgac7tpykLUMyRMALjmfjDMcQPjHGehQJRHqHKY9PKU9S5DxbSbvaQ+xNbq9x3Qnc5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789194489; c=relaxed/simple;
	bh=Tgfw+bR1PxAXAQBy+XRLskdLb5gIhfOBvMohuAAe0u0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ijqV8XdEgIQnwX1idAuIM9PD8ONyqwRDxBicc1L2W/BiKN8K4SpW+yhpuVDcwV6kQGCBFCR8dfQbZuNIhsOVUSI7tQxo/fbh6JBHF3kAjKFObZQhzTmZpL+KVadBEkIcRuZfoM9N+bYeBrh2phQ/CZilKKERe7CU2+oNT5wRlYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MsTur5kT; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MsTur5kT"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so124129f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 23:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789194486; x=1789799286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rsRnOmGwT1DNso6iLHvZBhAmNRKCLZB/9f/AeAbBVZg=;
        b=MsTur5kTZCftDCgm8CUjh8Nf+KCP78wrj9TvPTfHJlH/0+EW7TVtfa/rgEbOJw5kHb
         qkimqiIDXt1oPcpTKEkhw4AEUouFRNPhPNbKU4u5e7d4HuTtFn+wiXkF4CrKQW1jbT9t
         ZcqcbYJU2Dg0RL5u5iX/QAVuUakZHdSLlWHgJih3Txw3kGmOjGkymE3jWXR8NFofnBeO
         xWmoGbdGiLqP/t03jWSlkf5GHwji4wP77mjysG9vXkt8mySRd1BabRt9p6Ld/vhyD76d
         SUBiMx/g2XusUIFRewxKfc/Fsc5nqxAN0wJkqFMWb/lLR18H9hqYqaKxndEBGUWFSAYA
         125Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789194486; x=1789799286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rsRnOmGwT1DNso6iLHvZBhAmNRKCLZB/9f/AeAbBVZg=;
        b=nx65w4pUy7acY2veVktoSSs3GIYrpI4/u/14WQlpRRZYCXT9N6dGW51tFDU+p7x0FJ
         3AN/vSoEEfeN6z6gOmd8vZB24KIOvzeB66OE/Z/lzyE96dHLqxD8yGIMhyE0fDIizojQ
         KyKs2xMpufpn/DJLqKLBuHEXz7o7531qwAUzMgr47DFAoHXZxym8YhdnsIPjoLymdRT2
         Dhk2ZPbyYkNSabLARN8UkoB2JjWg4DJGKTPlZAU6hx1jMV4/6hJaVV9iXBxl07iwtq+6
         bNsMAvTbRA+HI2bGo58Smpu/rWvbsnbONGREkY/V5shC0pNhvVCwGXCJi6f5SN4JcEBU
         VCMA==
X-Forwarded-Encrypted: i=1; AKwUvBxakNUj9o3MAv0jaFRIx+y+7q+cbHYk/bfxdKLDbUl2esbdQEXGYrS87MKFF8Syp04Pta6JOYxOr/L5@vger.kernel.org
X-Gm-Message-State: AFuF++nnpHTg7hBWf2E3/CbY6gX5T9M3DJ8QWynZu8FPE7v1XxAZx5pt
	LyyB409JCI/m4218ii3KgOgzk+CGIoGE+RjQK3FqUdUFeuKto9VWIsDMW9yNYXSj
X-Gm-Gg: AYBFou0xj4tl/ERbpv3dbrrwVyvddvEwOJHgPCU5AEQZ/4HZTJXdGOXF9gZrxdufkyc
	v5uj/05/Crx/JQwhm4Jtmyw0bBb6d8nd7mvjTK/ij9Frn0Gv9sv4umQmnKan3vK7gJOXVyIIzIS
	hDBODWZ+3jsim/bAEc+DDGo52488UbgDx2SCphfUkXYAajo6DjgEocqk9VWDq5Wi34XPYy6q9zD
	IDsPTYVrYFvU/iVek6Pp2mhuQrvad6wVx1yzeU2eVR+8+yXpht7vyYofyuErEvdVS/4jJdSGhEp
	PYzfXZphUai6V8Ocny3tErxaVQLleukS6OFcl5ty/GJYGteh4E+1GjWFT67bZWvwxJLY0TPJj2j
	5QyECLouy2sy2zU/7G4XRV+1IRmkFXHin2zQyTFab4I6cIw/xzo0XkdSRV/47b5znhjCSvRI7WR
	wAmzdsbBzLEqhSpUxbvne6rv2SAdV22A4JTZegVp7GyaVFZ8ll+w+L4crgCKNEKzd6Jp6agOetg
	RaAmfyZOXh+o5x7PEtMaGIbdeXxKjnE0Bqfsirh9fZ82U5UTORd5lrIZ5oCq27/c/+NX3Hu5mEN
	fHOxzSbx77avrroc2K4hBQ0bdHp7DoC9vVMkr5S4oxizq9qFKwzKuBz2ysvYDHeSUCYyQgTWcWK
	4qw==
X-Received: by 2002:a05:600c:4713:b0:49e:6838:c813 with SMTP id 5b1f17b1804b1-49e6cc102ddmr12126115e9.33.1789194485973;
        Fri, 11 Sep 2026 23:28:05 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6af095d7sm45068765e9.0.2026.09.11.23.28.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 23:28:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Chris Leech <cleech@redhat.com>,
	Robert Love <robert.w.love@intel.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fcoe: Fix the return value in fcoe_interface_create() kernel-doc
Date: Sat, 12 Sep 2026 08:28:03 +0200
Message-Id: <20260912062803.42969-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fcoe_interface_create() returns an ERR_PTR() on failure, but its
kernel-doc still promises NULL on error. Its error paths switched to
error pointers when FCoE module references were added for vports.

Update the return documentation to match the implementation.

Fixes: 7287fb911409 ("[SCSI] fcoe: Fix module reference count for vports")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 438ac7c3a9e3fd548a42779c4d753320ec79a854..2c86d8a06e410c99e02f5c7f2ab96a908dda199a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -375,7 +375,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
  * @netdev: The net device to create the FCoE interface on
  * @fip_mode: The mode to use for FIP
  *
- * Returns: pointer to a struct fcoe_interface or NULL on error
+ * Returns: pointer to a struct fcoe_interface or an ERR_PTR() on error
  */
 static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 						    enum fip_mode fip_mode)
-- 
2.39.5 (Apple Git-154)

