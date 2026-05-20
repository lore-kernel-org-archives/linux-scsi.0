Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BDE2F0C62
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 16:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296013; cv=none; b=EF4tQvK/J/D3C9pqjC02z3EltKfVDoT6BBMqjM3JhjJ3h+XDESdND4pjXMHoKUjSxjHsmD9M1jmy4tDL3isJAqkhbCpd6YGLLgC1LPwi5Ffy631yvR5C2ndF8zihzi4iuqIw+PeEpnY75Qk77lynZbjXg7hchBMFeZvy6GdN3Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296013; c=relaxed/simple;
	bh=OqrZM/EZQoDxpdqsw83Tctk6QvpP+RDSvRPve3kZib4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAg0YZyyNG2lFGB5g5tGbWVgzK83OP7Ii/GIuIGpUW2EbhI/83BE194USxAyTeRvRLty8i23X00GlHNBbYLuQz3RSDPhsdDOR6+4WP8xvrvizD9LiPiGZpoBiWWHNoeRIUPGxt5AZqBjHF6xyVF7u65QXVtlOvasCBi2N8QtrLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkU4GBL/; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkU4GBL/"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67e43a8996fso6415613a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 09:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779296011; x=1779900811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKcl0f+YiSx0kT0A06n+DmaHMn0z0MjpQEGjfw2KSV8=;
        b=JkU4GBL/LH8SDTqhqu2PMj/k2XBBu/ZymgoIeyqLDzs6PDk+Rjb8URfzCw/X4fEo4Y
         mjzq4W6gOob6o8+/kl3IAwkel7yQDIg+Ohu+KCBSsciZ6ewBj8U9ieMmGdOyFf9DgZxT
         uPR1MU23R1mOWxe74+LzQLz0KcAZnj7mIKtXgOfRz8R/LKaIn4nNuvFUb8JM9TZ5g3me
         BXbRy6vnk2N7wScACVRVHEUX5jRVj5CLu1Pf2x8/QIKw+YLf3guPazizAtlQQIbKjlzR
         aUD++Oztv4iRHkPIyckIwwwLik0fdmIOZqrFGBKPHavtt2ZKY+VnPTNa3Tkb91Oh+8Wm
         sjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779296011; x=1779900811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kKcl0f+YiSx0kT0A06n+DmaHMn0z0MjpQEGjfw2KSV8=;
        b=cylXlQkXsa7/DOIMNkiSprIFl/oJgGQVYgMECC6zBVlCH2L2NmPoXJ8RClMWonuPcb
         e+X5R7o2e5pnD4PIAFyOWJFqZG9Cunpr8Nnsc7bdRKU0yFvpvSOgUj/bKWb/UAn85XpV
         4BVDm5Vi5KfYL+1OLCZ/ucBrVT7xLNp4fgdqFpYwOhM8EY9HPz9PM5vRi3cQJFlQM6G/
         58U9kP0e5TN17MSxwheUXuiAO8tAQrL+wAA7p0ytFZDyLkU4Jrjele7G/gWrbo973Ef7
         HgYmOwABbrl46W/yV6RaGP8pdnw5YqnRKGOa+m1SppV5uocZNccOTdLi3AoeAHoOYU1m
         3nIg==
X-Forwarded-Encrypted: i=1; AFNElJ+tipnCWWm6AB2zFaPtdeTt9sJLRC3aemnhPvGVR5HUd0Lxkh3IdK9WTCeru4dvDS+Tt478lAjHQSHu@vger.kernel.org
X-Gm-Message-State: AOJu0YxGxJr4YjPaSLIeYRWoujF02aeoE+wnRiT+LVBHWe7zZB9LTMIw
	+FspsUWUNcaLhO4ZXvNyNim9mXKvKgWeS05Cl5VA69iUZwmXIQHFzLwa
X-Gm-Gg: Acq92OFq/H95Lb0OBUgQPekugspK3tQlWRuO8YmWwzzm2t6XwvsnvmymW49OhPD/taZ
	bzdF4/trT2RjjoZnBQYiShmsejQ7AKMHqlimcd1vK7ZhOLKBRBzhqdG/GxBi6bYBY6JJQ/cvChV
	9J/9Ug3VPgcXFterJSLqBL0gbfJpMhDw7DId2iIBda4O+b3b6SmsjrGFJlUYaZ/FEYZ7BlOi3kA
	iS002NrSBePf/+apz2N6IBxvv3tiPklMpr9dCxSgAZYjn+1K5qDzTQlqo+pYnZu3ZDWOEPP9I8c
	W17Fp5xSuRQdVYiFbLaMfwAnJnHCwPmp7XfiNCB5nrQxFCl9Ql1ELAm+7f9CkNapHGq0bhrhAre
	lOnXhi6oUVDCktC9UMB+Kjw7wqtvXEF+4QxZGBpzNlQ4l0Rm64ToPPodeq3uMNTDKbpUO2v4F5B
	XrC29aANuorubKsFQQvGkx3/041vBCwS++ahD0qAeD2Hh6MpUe23f2RpSoaDDaekZk3OBahk2Im
	6X0LqmvDssC7xs3+SgzSIf6S9gaNcXWPj3z+Unk9PPjshEnFDwyjy/N+Gw6aBhH7xIUhrXs7qcD
	0ar6CDwwiOKSG/UHSJR/950vPjyH
X-Received: by 2002:aa7:d14f:0:b0:674:7363:3e91 with SMTP id 4fb4d7f45d1cf-683bce9cec6mr9495273a12.12.1779296010835;
        Wed, 20 May 2026 09:53:30 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6831187ecb7sm7966009a12.29.2026.05.20.09.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 09:53:29 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	mlombard@arkamax.eu,
	ddiss@suse.de,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	hossu.alexandru@gmail.com
Subject: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Wed, 20 May 2026 18:52:59 +0200
Message-ID: <20260520165259.272808-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260518121811.385350-1-hossu.alexandru@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chap_server_compute_hash() allocates client_digest as
kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
passes chap_r directly to chap_base64_decode() without checking whether
the input length could produce more than digest_size bytes of output.

chap_base64_decode() writes to the destination unconditionally as long
as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
the "0b" prefix stripped by extract_param(), up to 127 base64 characters
can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
(digest_size=32) this overflows client_digest by 63 bytes; for MD5
(digest_size=16) the overflow is 79 bytes.

The length check at line 344 fires after the write has already happened.

The HEX branch in the same switch statement already validates the length
up front. Apply the same approach to the BASE64 branch: strip trailing
base64 padding characters, then reject any input whose data length
exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.

Stripping trailing '=' before the comparison handles both padded and
unpadded encodings. chap_base64_decode() already returns early on '=',
so the full original string is still passed to the decoder unchanged.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
v3: strip trailing '=' before length check to handle padded encodings
    (reported by Maurizio Lombardi)
v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp

 drivers/target/iscsi/iscsi_target_auth.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a..00487d0 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -340,13 +340,22 @@ static int chap_server_compute_hash(
 			goto out;
 		}
 		break;
-	case BASE64:
+	case BASE64: {
+		size_t r_len = strlen(chap_r);
+
+		while (r_len > 0 && chap_r[r_len - 1] == '=')
+			r_len--;
+		if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
 			goto out;
 		}
 		break;
+	}
 	default:
 		pr_err("Could not find CHAP_R\n");
 		goto out;
-- 
2.54.0

