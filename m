Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9C942AA9
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506151; cv=none; b=EwVtz48ocYdws4S1BjFRxyWUsTQxPn6TA0f6wMxbkhoF6D/tQUesvRxptvESm08Wie9Ws1FeWEZWbB6maQ4JXBabinh2bho8ggS/8FrHvVdQDW/nian1TEmfxTZvH1yWcfxEiBymBiQFRJd2cFIHu4bV1gBSyZVuiJwGAhbCzzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506151; c=relaxed/simple;
	bh=3pzmoegqDuSliAkTdeqycBq5aa62YqQO38QkmiiEiTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDsNG5URzwaimSWhcAw0ggDfvss9VA+jXnRWxAeCZzIaLNqnJTpFBv9uyKv7d4F12N2Mx/TdXDC7cMptKciPY6WCdQyImxnnB8HY0fqfZzB92OUhNhU8y8oFscq91d5k+qLfbcO5NSpt07RAtceG1CZf5PgbQKPO9byjr6PGeAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HgvBlffs; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgvBlffs"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-988cd9b6036so31051241.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 17:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506147; x=1792110947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uDiCydjZ9y2SRlO9gdJts9J1fvejuYVS4OsVz5QeIVg=;
        b=HgvBlffsiavrVkl2PlcLpjXVZcuTdi02bX6PwF6uEG8mqC4+8FN2b0J1XisV+EyjNn
         8XGsf6z46VAfvFFTg35NvhhmwWLQIf8uiGPcZ5k73JcwMk2A84+ermOEDkyy+GwPfbSU
         pzddC/q71vaWOP3KEOd5uy8ZqDptiKSpTYcY+iayopZiakFgP6CDTr+JgLQXIVckx9w/
         9+f90XB5lz/Ol8FlbUddz/v7OlqgRrxQDBzijxT3WMv2irYce+Rn6pT04R/OWEdFuviK
         wV13SLQEzvtEFkKsy7YFLOwb5Ls3EUtabhiu8EJ4vKi2msKmXZuQm5Mn8JZyjqYF0H+c
         QWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506147; x=1792110947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uDiCydjZ9y2SRlO9gdJts9J1fvejuYVS4OsVz5QeIVg=;
        b=SFc+TJHcn5FRF0cKpLyIhuG4CVX2Ejuh2mIgZZJcfZzqzlNMJWDvAy0TdScSNZJL9t
         8R6KIRu8J7JREbEZvruUNHF/cv9yOXMymOrXDt4N99fooS7ypsiUoTg9YmSAuJ+SNtAA
         v8JFhrrlNJKgpTmQpQfu9jYUCY+4JHpP0ZonWPV62U1fHip8VLzGzC/1bd4YneW2BA5Y
         EBG/Fl1HI7Zd1Ex0ShYJxZrEz/Cx4KQu5iw2QOfGY8SH1M/Dz7nr1oeN+xypRdjoKa5b
         lPCjtTI91JsuzFDyJ7FOYRoHILPyOeIe56AE8Clm9TKFNIsrXvtQesm0O5Oada/4t0ih
         or/Q==
X-Forwarded-Encrypted: i=1; AKwUvBz3avAlCKXdDSK+Ud7jnB+eLvouFmE6FrJUBQBmtSnxgqnz66jm/lxbyVCEGvGhsD9eLAHVFXHYcTBT@vger.kernel.org
X-Gm-Message-State: AFq9FYKW/RPKprhb7N3pAUDmSm5GR05mO1K9+A8GmsV5BXx3P7JLpxXA
	Kd5whNu7h/txTkVBekOUBD4tsUrz3aAUdrBjAKpxA1i84lZL+oUih4+CdYkywWf68bk=
X-Gm-Gg: AYBFou0N3yMp/D1iNx6Yt+N3QubsAn9OAWrQOvPNE9Qy5Mi9Ud4DqL2jlaVL/EEtSym
	8a22qr8Wy+AUgXqQbW2lrAmyn+qvID02tvip8WCww17s8xZnvKyjxs5SD7jXevjzCST2EYQWAO3
	fZ4eUOUdA9+OCFp1Uclkm2sA4UmAS23xEAlxk5p8yjMZqFW9qFxn8tbral/KCpNVc62PWQgHoBI
	ieb6EQXEN8WkaGt6LSEU3Z+UNRi6vlUPIgb0plUl6MRIJvDOP2JLPHHp2f6jTcpmTsDdiZPlbP4
	v4s27kfEngvXr2Hung7xUIe7zJlUR79w2Um/9TH1DlHrWiM25M5C5TDwNiEAB55zWwvBk6RtWFv
	Yqu9UFs8HV2ISRVSmqlgCS4d+xfwQL7kW3hrO37IiH/UKLTMP5IIRypu6XAwRUn9/hAGz7k6Cp7
	4fiFVZTBlGFcMp0YN1QJ5t3bpY/KAjKtQZVK3NthiO0AwL5ovb+ULEUKQs9L3GzWZUu6GdRej+U
	lE9WYjv2wSU3gdjcTTfM/kVWfJ5jqKCcGFBH1IFqEn2daB7wNthqJZw1S7IZ6WJxlV3mqtVR96w
	I6NrLK6S+0KoRR8CzVg=
X-Received: by 2002:a05:6102:a4f:b0:7c3:83a9:edb2 with SMTP id ada2fe7eead31-7cb367883bdmr130748137.1.1791506146842;
        Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 4/4] scsi: target: rd: Avoid 32-bit overflow in protection space size
Date: Thu,  8 Oct 2026 20:35:34 -0400
Message-ID: <20261009003537.62265-5-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

rd_build_prot_space() computes the number of protection pages as
rd_page_count * prot_length / block_size. rd_page_count is a u32 and
prot_length an int, so the multiplication is done in 32 bits and wraps
once rd_page_count reaches 2^29 with 8-byte protection information,
that is for a 2 TiB ramdisk. The protection sg tables are then
allocated much smaller than the device needs. A command whose
protection data starts inside the allocated range but extends past its
end makes sbc_dif_copy_prot() walk off the last scatterlist and
dereference the NULL returned by sg_next().

Do the multiplication in 64 bits. The quotient still fits in a u32
because prot_length is smaller than block_size.

Fixes: d7e8eb5d9216 ("target/rd: Add support for protection SGL setup + release")
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 2613342be..d7752fd34 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -253,7 +253,8 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	 * 		   (prot_length/block_size) + pad
 	 * PGSZ canceled each other.
 	 */
-	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
+	total_sg_needed = div_u64((u64)rd_dev->rd_page_count * prot_length,
+				  block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 	sg_table = kvzalloc_objs(*sg_table, sg_tables);
-- 
2.48.1

