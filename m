Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83C2877DE
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 20:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763410206; cv=none; b=cBAvO3PeEtOGXPccu2IunZGwsHok6ZaOrHxIUVKpl4n0FxJdD/PrM7+hHSGweHfnWz2jYRZdRdZNVNqlAPqR0nxJOe6hU0D+G1FX2cYqyW9dEOcpd90rOb9JTy7UD518HVG8w1vnf/40DvKBzw0imXiW1W2xqA4vrQlyCVfL4Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763410206; c=relaxed/simple;
	bh=/OT14Qj14QYNJ2+jby8nc27nMgj0Wyhxeh+3+JrI0pE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n79c/CKYrRFhaKZbM484WbbkAS+3Ayt3ZodG7ngQ5iOhFHUeFjyTVraJwqIuo/LMoDqtTh7g3HnJUn+PSIjzfLndZIxWkxGuJitpj2Ngo2DH+sZzKmaW3r/iiTX1/t4u54s53rlmqYZ2ShdYmCCETjEvwaZs5V8eNKez+BC7Y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfeguheY; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfeguheY"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7baf61be569so3085082b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 12:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763410203; x=1764015003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wNVyQjdIJyiB/j7sfNaFf+EDZJ2152TcarPOH8080mg=;
        b=JfeguheYvcBGt6YTk9HQ8N3N3opac0GNr86oL+BcMIboeDBj5FY+WBVi/CJDUQmMK0
         nfz1OtB/47reK/SxvfxHIh1mL3DU3DHTVvVY82kgWEtR6iiQ5mkQ7F9M0OOZUgML7PVZ
         yqUuwe74DRuOOGGhA+mEoxBl9AHi4KNHmQYmwxTjFCQ+PTPugs9ERz5Q7iEcTydWglAR
         TSiYcqZZeAiN9EhVv8VIB0Iv+TrMTMso8YYXAA5SOlntBN85LnzWwR3lYkVEKN3xE5Q9
         o8TTJaOb6S87/XuahN7yC3d4IcxrKAv/FOyz5VTG0iDGwFdDMd8VFkXZAi4orZ4Jyott
         yS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763410203; x=1764015003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNVyQjdIJyiB/j7sfNaFf+EDZJ2152TcarPOH8080mg=;
        b=uXS+UHN8Y+5ai8mhTm9Ibgj+mhUlnfm1gLw8z8Z24wdGAeQJKqvx+5ltyJRvShI+2E
         BFnUCQFSsKiFBng/SwqEz7nzIc21Dt+UllQjbbCcWr+vvfP0wv3vSno9PugO3mhxMNNL
         EmbtGQqsDfnHTGPV0YgL1HI3R3HAZPFvuTIFvXVqUvrMwf7pOCPolZ48DjgWI5WOkiFY
         75w0rqlQusGOXldrVXbVkPranafWtat5g9CtbX0tBn390lTkYMdn1c7T6K3NDn11mx6I
         BN5BHo9fY0otQgWkG2m6sanzmjsSso7dfjkdcRBNvZSvwtOClJLEn5dgmqVkTZQmzSYJ
         vwlA==
X-Forwarded-Encrypted: i=1; AJvYcCWOgFzykpqH8Tnu0nk4k4cWgV1ceyssu5J3gbERPn3ZuQOh1Iqqh43kSgiknHBxDMQD12OoX6eXmIQo@vger.kernel.org
X-Gm-Message-State: AOJu0YzMmC2a/7lJ8IFUWr+RTOSr9SgYAmcSniiN40C2HsK9oVWNN9HF
	hKQn0+Rp/1uviPr92YRzZSt0vyfP059DXwodWIiEFewdnye3zyl3nOve
X-Gm-Gg: ASbGncuh38D1KfoP7FWFGBabiO8vmeBTK+bXhqYJxIyCbzn4nuvkc+ER8Wh4QoLqf2k
	z0meBRkPQ5/xJ9w3sKXtZBAG0rOxLV9jRZPxkXvc8F+ct/nWDTupyv1SBc+JmKfp/8wfltRMx3j
	lpQDDQI5PEwfQTEzMk7gHChazI26l1bDPLKnWWVO3nOow80vYECauTomDuckv4PawCpV+9Nk7OP
	63218nrx1f2Y776wyjIM7QZoKVfHKafPAmqajb2ZXntNvKEnSbi3wwAkiwua67q2HpOvoyXz5q4
	vz7I2UpTb0SeoUAL78Lr2NvlkkwOl0csCjcEk66xS5NFEm78myZ4nBw6+il/PTBjyVv5N1qNkWD
	LXLrkwMoGGzPJ6miJrYhcmWXSldMKRtGSOBYMuxA2JiFMIq9i8cPXDmpcqEntsWdly7Tw/CjuHY
	uzYxfhDZqlqyjYXqz+xww6
X-Google-Smtp-Source: AGHT+IFDTDmcdOPgHf+QKrXV9d1kH/RUYe0WpicepP1GsaZ99vjLgEBDobVVjlqfYbrmehjtQceuwg==
X-Received: by 2002:a05:6a20:6721:b0:35e:1a80:448 with SMTP id adf61e73a8af0-35e1a80051dmr6530226637.49.1763410203359;
        Mon, 17 Nov 2025 12:10:03 -0800 (PST)
Received: from fedora ([2404:7c80:5c:6769:b0bb:547d:696c:eb69])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36ed72cd1sm12800964a12.11.2025.11.17.12.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 12:10:03 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	i.shihao.999@gmail.com
Subject: [PATCH] scsi: qla4xxx: use time conversion macros
Date: Tue, 18 Nov 2025 01:39:49 +0530
Message-ID: <20251117200949.42557-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the raw use of 500 value in schedule_timeout()
function with msecs_to_jiffies() to ensure intended value
across different kernel configurations regardless of HZ
value.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index da2fc66ffedd..b0a62aaa1cca 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1552,7 +1552,7 @@ static int qla4_82xx_cmdpeg_ready(struct scsi_qla_host *ha, int pegtune_val)
 			    (val == PHAN_INITIALIZE_ACK))
 				return 0;
 			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(500);
+			schedule_timeout(msecs_to_jiffies(500));

 		} while (--retries);

--
2.51.0

