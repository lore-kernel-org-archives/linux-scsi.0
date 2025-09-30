Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0327262FF3
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759235896; cv=none; b=sftl6W1DIbfAkbLnDTAJjfDWXo3j9X5OqbJDLpAU/VaJsOm+mxGifrUU2gYhHKOsEI+3LwUmMcFCm/5GRPZrMvq9SAE9qolArc2Cd9A55fd8VqHch9ZvWwQ2GBkbH+fUDg43zeUfQ5GGHRNJhkbiyaQISSzkjS99u8ZvLEMyivY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759235896; c=relaxed/simple;
	bh=TRuZEMG8YWoD7AC+4GOrUJfg5Kr9NAw2G8HZG37cXV8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HrJ99NWur6cVhLMCD0374L6p/g9+l36IIqjQhEqME1FzPd4qlqaG2lMnAUZJZinS5i6SfV3kqkfbbOl8qAdiuynmiXBPZk9jPVXHZ4VyCPgBTYv3uuilgQJxEFa54pSbB+En7FTn4cCglR+golrkFSpibxtdKCri4lOPjAiiHN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RTzF2xwq; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RTzF2xwq"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-421b93ee372so1130595f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 05:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759235893; x=1759840693; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3qy5r7hvv1J3r6dinn0Sogr/iaDbB6XdxwCfFluXsU=;
        b=RTzF2xwqP5ucDaqwVyKuJCvbxjhr8lHVdMvDIHBUXvNEnw+CkJeDaSXZQqyi9kBB5W
         vemrsIb5U/uO3+kD7+zhkrwIzjB6hAvu9BJwCew6ZzteQwlM2Qo1fWf7Jn2Ut7l7Bc7Y
         Ck0Ffc2eVx0z5TgFqit3AR7O7kENCDcyKVWpUMoDbA9IeVF5EnHsqPPqe51o+9xqnBTX
         iJO9en09s1r3QhSo4l+EvSb1PVkh8HAcjBVI22V60MQxa6AGtsWLHQVePrY9KZsmuj7U
         /gtiLw1jaainPQ/tMx76iE9xp1ZqMsqMx/CgiC3ExlQQHkqqpxvPobSB/fFzjdPC8uut
         JV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759235893; x=1759840693;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3qy5r7hvv1J3r6dinn0Sogr/iaDbB6XdxwCfFluXsU=;
        b=sJpHAj2rPct+vqrq74SazAAoQelZOnOC2/Y0nkf5ucHKm2jn/aQgiAtTZLli+f9Mum
         UmqEVpe67xJWNa9aBVCbYKTS5wLgk0/q1yGD7HVIXuf37pvNtXKOI50Kaz6F0TjRrvfV
         i9ILFw/XLaVJqxgSob1vzbd4daw4ZFU6LSptI4Ay263MTfrN6mhIrKJQIpNm7vrqhpbU
         6SLzU4e4+Ldlx4n1578gH/xsvgu9VxUidLE0Qi7qdTU65KwRLfbND73qOULFeegktlkb
         SAFLHSdhMyf2d2NUebrlBpkiphMLnE0QmN1FK1Pu6VDY93aH0iF7hlfjmQZqgn5ERsRq
         Jddw==
X-Forwarded-Encrypted: i=1; AJvYcCUreKpNKjxbsGXvQ2TihIbfCngR+xpVcj8XAAhWF+SuXgkiYZonvcxGnJ+I2nRBvbdoeyvMMdtHrqc7@vger.kernel.org
X-Gm-Message-State: AOJu0YwOy4sJSpDf7+5Zkf5Uucw0hHF/rJKi3bW9Xlxk5P6jFuwdGRXP
	KRJla2ZK+TNjcKTe1/U2gqEPn7zwUFJQAKrvRHqfGTeERHR+T78EYmj46V9Xe8oqZRY=
X-Gm-Gg: ASbGncvFTycs1U1tJsoFfcctIlmsFL4qI+eSYW6Tl2fRC7JJw/vGpc/KY02nhNdY4AK
	GEeBl4zHUoWMDnSwCXRgt01VTfI6Ro2g0SjJ5iMKIJRrGDatz2rpRF6TAdaCNjtO40TvidASkDV
	TNQg0tuUjsX3/NnJil9HMaIv52akxiRl/8qoBoiKlRQzgQErP0NPkoPES2KJJncPBuUpxTBKw6P
	6kYHzvB6t+BYGCT3nMi///RFhh4PrrEX8PTQAp7X1DEF96yfY0Mu55nbvdCZNYTWkYM5TP65Hoc
	y0i95f8jUFDXqQjgcpOQe5ZqhL/8ebZn/xXoBF/bJx8IV/jA3g9Adf0ciltlqDaa2HMYqOWAEua
	/gYbQLjdqa2YCnloffaanqCoFoc270VH1x5cYFvJbpd2NMs2hlYgE
X-Google-Smtp-Source: AGHT+IF4ajsY7TSW0w2cltpeiR3Y44gTYcWo/2pv8CO+hAiKdk1ZuHmaFqdShvixe7b/cut30bzhRw==
X-Received: by 2002:a05:6000:2002:b0:3ee:126a:7aab with SMTP id ffacd0b85a97d-40e4dabf373mr19174181f8f.57.1759235893126;
        Tue, 30 Sep 2025 05:38:13 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fc88b0779sm22291541f8f.58.2025.09.30.05.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 05:38:12 -0700 (PDT)
Date: Tue, 30 Sep 2025 15:38:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Robert Love <robert.w.love@intel.com>
Cc: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: libfc: Prevent integer overflow in fc_fcp_recv_data()
Message-ID: <aNvPMet7TPtM9CY1@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "offset" comes from the skb->data that we received.  Here the code is
verifying that "offset + len" is within bounds however it does not take
integer overflows into account.  Use size_add() to be safe.

This would only be an issue on 32bit systems which are probably a very
small percent of the users.  Still, it's worth fixing just for
correctness sake.

Fixes: 42e9a92fe6a9 ("[SCSI] libfc: A modular Fibre Channel library")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 16d0f02af1e4..31d08c115521 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -503,7 +503,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		host_bcode = FC_ERROR;
 		goto err;
 	}
-	if (offset + len > fsp->data_len) {
+	if (size_add(offset, len) > fsp->data_len) {
 		/* this should never happen */
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
-- 
2.51.0

