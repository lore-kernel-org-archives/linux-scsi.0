Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD7239085
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 18:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776191279; cv=none; b=Ol+a/6xW20nZBgCf6D4WjCenJDdSA5J3lSm2rq0WVap7ZQo4t7s1vVFdLTFeD4BjpD2oNU5DzNyhChDCTK39bwv0nbx8lxB1Rlyr6/Qlh+LCK9w6vmmQ52+FywBLY7x+yJWX55Ew6Y7lmc9O+46HVy0ojC/j1flE8MhbytUa2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776191279; c=relaxed/simple;
	bh=8gwCerpFoANTyeFIg6zJ5hdhDyEcsr7Ud7TvbBYHiuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdC70J1LG2Z9RH1Zzk54Cg5v0oU99aHkUcYI9hgKG0NG+a2ZaihestWRprZrVBxH2czavACJTFjI1egT5SK1Yi7Fid3VSa7FCaEMqlAloU7fptkiZoW1cKo7IwQB/jMdGCigIh/aKKiqOWmN6LCTpKFE3bDNkxsd3wEXhgqViWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z/CRzHWU; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z/CRzHWU"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c15849aa2cso6838934eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 11:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776191277; x=1776796077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8if9N+gBLKffFrczesRiajZLxzzDbxrq8j+fE/A/OJI=;
        b=Z/CRzHWUI42Q5DN47rlPZxdJzmVIfYu0NZ8GNRziaELG3O2OfdYcOyx4VLT7VCOzFq
         DQ7/JRQTW93bkwK9tTK4ZS5xSXXh1ABLLKZcs9HkSpZuVAoYCrUarQ71KGqZO1mCBb+7
         Ds34YZevNtvULcyr4VxcUF6ovuggS4WJC5zis0wzy2KFw6hM4/XWUBxFHzWXcUpKPhtn
         9qS8M9u+JxFnF9aopyJG3bcSh5CbGytQAgRyDnP+liWs5fJZjFcyH4dyAt6JgU5Kn8X6
         9qi6EyjrqkVd/wnF/9CMYwm7t/X3+qX9a9fCUvkMwbxfu+Ob7haKEZtXJngAljSXq/t6
         DBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776191277; x=1776796077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8if9N+gBLKffFrczesRiajZLxzzDbxrq8j+fE/A/OJI=;
        b=KvozSkAWTFCibBcomHYbRW3v53hEBfP+LDnjPr2IesTGmDMGEkgDBhHSPv9xBcOFm9
         cJ5lAa7y2cmv/Fv6NkEMABus3pluP0V/JvxfLNxkqr/ucSo72xwppYwFat09Qv8SZMJJ
         aK0692c7jj8+o6r+i6u2lHmc/CBGqPHpdyDBge/MkASSkueIha65cRcz2IheE/rgjWwm
         LphecKYnyyi/saQVxuKWZiMF462JUBCDtyPth1oxNaAwJ/jSOD6FGElSdEUFaMckaoIV
         elxVy7ueJUCfzrzDGOlFgsmEsW2YsQ3Adl9BNtwg2tabv9Db/rLn1R1+FPG2smk3CiA9
         6dYA==
X-Forwarded-Encrypted: i=1; AFNElJ8x5YFBQz/v0yY4K5aftwJfUDyEU71Ps9l1xldiCLINhmZOrIu0l/trlyTHl4BCch4nwLqdAkppRwxE@vger.kernel.org
X-Gm-Message-State: AOJu0YwDklIxbROVe3Gfq69BJ8B2fftVmO58O+SwooegKVXeifOcFlYF
	XQKDSo5KM76bcvl+Doy8v2FBMcHn9UeKmQrB701lfg8Xq9+t6IC7Y6RsAhok13tzE7i/j2eCCqL
	PxxNH
X-Gm-Gg: AeBDieuy2fyLF5sW8V07OAZiZrXWzctBsPwFsmm7Faggp0D31L94XqzXfKgXan9XeXi
	ciqx18zM/tZBJfgsXOvjdvYc57VECLg37Gy50IcB5KrrOmttNJxw4vOBIVREV/hdFw9TtUUDGDa
	HGO+Xotha7HlW05t1N4Hup6vGlS2rwW4pebpHOmE5s0W+SgTsbpk9ltkh5w0IwOO1YzTNkwbINX
	UbBB3eVwRI2oFF3T0pFsi1SjGodl+uJLhQGe+n2KBmloaljPYGAStnfb/rC4D9YRp+wtDHdMFQt
	WAMk8Nzc/axfVrRKdn6fz4Jn2po//ZxP8UPw2bFiEzG3tv8UjDZ+Mn+d43sNfUFQhSYU1bGEhE2
	uSbLFGqfNRJLtqNuQ7a3iz+7Bco8Fih9limnv8BYxiBSA7Zhwh/nWbyNoQ1yoTudTRyoF/haR4N
	HpL13p9rWyL3C6m33sNERmIS7cABd1pNuMmbRYeNqwifufYbTojdQBqsmqmNxv8nK+Sb/61tSON
	06ku8y/RCyOGBcCu6i930NpDQZm5B1qhzWrQJXZefBSXbpK/q7GZZtdluIBf09IH4lUT01fR6hU
	8xiF7xSULphS2vmCkoyYSEI15ApcLEZg+jE=
X-Received: by 2002:a05:7300:dc88:b0:2d8:c484:6b6c with SMTP id 5a478bee46e88-2d8c4846f3cmr4738799eec.25.1776191277068;
        Tue, 14 Apr 2026 11:27:57 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.104])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm25813550eec.15.2026.04.14.11.27.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Apr 2026 11:27:56 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>,
	Riya Savla <rsavla@purestorage.com>
Subject: [PATCH v3 1/1] scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec value
Date: Tue, 14 Apr 2026 11:27:48 -0700
Message-ID: <20260414182748.39776-2-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260414182748.39776-1-brian@purestorage.com>
References: <20260414182748.39776-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ALUA handler maps a 0 value (no implicit transition timeout provided
by the target) to the ALUA_FAILOVER_TIMEOUT constant, currently 60
seconds. This means the kernel already does not accept an infinite
transition time.

However, 60 seconds is insufficient for some arrays that may take
longer to complete ALUA transitions. Since the highest value allowed
by the SCSI specification for the implicit transition timeout is a
single byte (255 seconds), change the default to U8_MAX. This way,
when a target does not provide an explicit transition timeout, we
default to the maximum value the spec allows rather than an arbitrary
60 second limit.

Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Riya Savla <rsavla@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a1..8ef1eecf9f9c3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -37,7 +37,7 @@
 #define TPGS_MODE_EXPLICIT		0x2
 
 #define ALUA_RTPG_SIZE			128
-#define ALUA_FAILOVER_TIMEOUT		60
+#define ALUA_FAILOVER_TIMEOUT		U8_MAX
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
-- 
2.50.1 (Apple Git-155)

