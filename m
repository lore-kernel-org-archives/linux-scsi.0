Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45C3043B2
	for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376317; cv=none; b=L2oVGWpITvAvxzjgmtebJeY3/1oEDz1BsbTNa86nHoAgw1fWO7/nUwUuG7lUgsR2CC4k/PS58FHdSEtKKJGl07N52KU1x6/zBcFmkUtHFcZAn3lfsF44b65bIr6lqLxziy3vn5VQ1pNcVdli8vN5rzf0lZ5evXSozPiF5bKb4W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376317; c=relaxed/simple;
	bh=RU6oU5V9Jd55+3BhZdYaEx6qEvtKNNlahl3xWR6s8Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iiJNYZL2KMbIIF3AUQFoZVx8JSAHZIIhDV06C3EEn6peLiAemykBySJrIU4nqXxB3acdCZjBzkB6Jl+VjSK6wlwfYnSEZmIFZaVmrfoNudBpu/qQFO56iNUU+8anzbhvByvUEplGHbNIrlUz5Z7k8CtW1TVRAPuKQfhrW2QoU5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sPQKIZbk; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sPQKIZbk"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67c2b4809baso13473330a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2026 08:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779376312; x=1779981112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7tUwlivnxdHdof7RvuWQ2n+t4BjAy5qaJWU1MgyZM/w=;
        b=sPQKIZbko+1GhnUwrlZA854tY9cal++hxEWrT3N9sG4EeAiXUDWQw/P3tdTO4b+5Kz
         dD3mm9ALgzWtRFVERTRuB/jggsCFUlVZzz/rFjU2E3j2eGnkIHblc/Fr1cxBq1RlHxwl
         a9Igg2pxZ/cwgTlsrpCP/Rtg8r1vhJFF1zcHbHHwBrjf9Oi2/jCv8tIvNIJUWuTyXjNd
         3AkRZJtwsfgPu1pAPFcgsgRnxU4xX5rGQUEeZCKX86290f7jlLK/SdvAzMZkpLe1p0nk
         8vcmq5yhpaM5th6qj6ED+XWB67M20z0BFbUgJfe9G8wVdBWTdsdF2nd/wT9NZUQ820vI
         LbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779376312; x=1779981112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tUwlivnxdHdof7RvuWQ2n+t4BjAy5qaJWU1MgyZM/w=;
        b=WmsG7+q5pkWgtv12aTAzhEqHNVdHm3Fj6KnRWrzyfmQayFkMij0EqztZPYdjmwgTuc
         mSL3xpk2uAB6zqIPYe7k7AUKJvBREFkf4Z8dBXkH2ra3BM7XIAtdHguk6dkdbzUSHZkn
         LN0hrbNyvmnv9ItEPFbDALobF1aqtMXvnT20HKhpiZTOKG2EdnPHejvm6DzELMYc40eJ
         xrW0vctV3EwcLM8FrL7yP++cE/l6MjdtDJSjNC/Q//r0EHUGhrS65YfiouAZ+iDAu3Ti
         eToAJW5wXDTktH8oFK9C4YJQYY0+3SczpPWO/e9F2j99fWHQt/Azh2LJG/jnjiXHkyc7
         PRNQ==
X-Forwarded-Encrypted: i=1; AFNElJ8d3+t5VKxuagksTdiZNhY7K2EnXg9KNTnyeSxVdDLbC+I6pYKOuyRfmq9znYZcEoKhwu/2G92HDT1C@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/yFGpYv0y4STSDqqVZAS/7SZGihdzoUVX2gLcVUJLZmfXul0M
	Q9BuJiD/XjM8Iga/IXauj4FlYb0pWFZfDziXwq1Miq63SAEVhRvHmlGl
X-Gm-Gg: Acq92OEKHrpv6Vcr+Ns7EeeJgWyJ4/ZtKQcov8mYHo7Ukiw4ccpxr5AZlnnX/WM8iDz
	LNhuKPM9JJp7OgMuoBV2gs0hwPFVsPwD1EVRh6C/PBDrFelpYQSuRZTQCLTu12rulqgziYL1jmc
	fMthXbmYScMJ+qa6s15m1ErzUFvqrSw0HrPwejTTSqw+u0Lcau1X1frrflnA7SHOMnbhIt78JUG
	Pwke7fgkNMsaX3bBsQfmm7933vb4KfKzUKHUX8k3EongV2Cqt3IVj2sFI8L99iPBfvyplsoOTjk
	msVwLI44kg/rBdJmkLINU9xAD+ZPEqRDday4lR9RKmnSBqwTF8jBUx/R7cDLHIR8qoWPpzqyI44
	E7Ychivi1lE/RA2EpqTIdStR5zpL8vBpbXbiNzITOuf4bUZwAamzfQlMnv6aP+gZiwoGRFKiKO4
	yRqnyrNi5Uhf9XgKcT5YSnWN06CMeJXPxMuFQKKjs/fhxOJ9Js6eEb/4lRyp3suigHcaWH7DGmX
	jQfHkXGNNkZ9Lz5Dvh3ToMnEp+Ag6xXHnV7Ht1y2JJ7U7cO6iMCcgxP3bzNWbKuKLzh5ZP8UTG0
	7sNMeQH9EO2k3qhGWaTy1nl1KtKv
X-Received: by 2002:a17:907:784:b0:bcb:98cf:1a82 with SMTP id a640c23a62f3a-bdc12f8637fmr174232466b.14.1779376312188;
        Thu, 21 May 2026 08:11:52 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bdc8aef5459sm59846966b.59.2026.05.21.08.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:11:51 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: martin.petersen@oracle.com
Cc: bvanassche@acm.org,
	mlombard@arkamax.eu,
	ddiss@suse.de,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	hossu.alexandru@gmail.com
Subject: [PATCH v4] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Thu, 21 May 2026 17:11:21 +0200
Message-ID: <20260521151121.808477-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
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

The mutual CHAP path decodes CHAP_C into initiatorchg_binhex, which is
kzalloc(CHAP_CHALLENGE_STR_LEN). extract_param() caps initiatorchg at
CHAP_CHALLENGE_STR_LEN characters, so at most CHAP_CHALLENGE_STR_LEN-1
base64 characters reach the decoder. The maximum decoded size,
DIV_ROUND_UP((CHAP_CHALLENGE_STR_LEN-1) * 3, 4), is less than
CHAP_CHALLENGE_STR_LEN, so no overflow is possible there. A comment is
added at the call site to document this.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
v4: add comment in mutual CHAP BASE64 path explaining why no overflow
    check is needed there (David Disseldorp)
v3: strip trailing '=' before length check to handle padded encodings
    (Maurizio Lombardi)
v2: use DIV_ROUND_UP(digest_size * 4, 3) as suggested by David Disseldorp

v3: https://lore.kernel.org/r/20260520165259.272808-1-hossu.alexandru@gmail.com
v2: https://lore.kernel.org/r/20260519015100.837422-1-hossu.alexandru@gmail.com
v1: https://lore.kernel.org/r/20260518121811.385350-1-hossu.alexandru@gmail.com

 drivers/target/iscsi/iscsi_target_auth.c | 19 ++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a28e97..a3ad2d244dbe 100644
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
@@ -473,6 +482,14 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		/*
+		 * No overflow check needed: initiatorchg_binhex is
+		 * CHAP_CHALLENGE_STR_LEN bytes and extract_param() caps
+		 * initiatorchg at CHAP_CHALLENGE_STR_LEN characters, so
+		 * the decoded output is at most DIV_ROUND_UP(
+		 * (CHAP_CHALLENGE_STR_LEN - 1) * 3, 4) bytes, which is
+		 * less than CHAP_CHALLENGE_STR_LEN.
+		 */
 		initiatorchg_len = chap_base64_decode(initiatorchg_binhex,
 						      initiatorchg,
 						      strlen(initiatorchg));
--
2.54.0

