Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F493093D1;
	Mon, 25 Aug 2025 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756147301; cv=none; b=F5buBAnMj6+LTEOZkI6hmd+HaRmnVQEU6RVq87IlznYNS2q81SSO5XDV0LCHF8Y5Qt7heVe1IWqcAcoLJz5vP2ESbWRkEImAJnO2cv6kt55AJTNpIZPG+gBU1OxUF9f5B5wUyHfcLiMj7dfiQy7oQ3LsVaMzC40xW9oYUs2kV34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756147301; c=relaxed/simple;
	bh=pgn6gzU3pn1AK1VslDXB7/8CWb0b4PcXumQr/otUY60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEzbTkhYwZickSE5doY79eEQgd46rFsBi+ExOf+xZC9kvZ4jdIfkE8A6BoxaAsq/yrOtK340/KOvcDr1oH7RI3mIUB7WIZjtydk/NzAw/BIATMuz+SnKvo0EU6nFTH4lS92yc0JHGR5v2vDVnFtU+TE8al8vwyKr6CFnpD1fw8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUSvg9AM; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUSvg9AM"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so4141439b3a.2;
        Mon, 25 Aug 2025 11:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756147298; x=1756752098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/mYfrRoCZPYxBucW78DtwkSqbfXOy38wcoN5hsPFkk=;
        b=bUSvg9AM6lgoWUZsTPG9mEto2uMHATUz4JsMCs/7XJMyZ3gwoYOeWvCZbuoFPPYqxX
         OoDNXMzB16TKvrnfc8q8DxX4TlMzstZXHWPrOxKZ3OhbLr354NjBlr5tshTzJQzs1GC9
         j3w6l/PckXu7egcx2XvuK0rW0YXQSOOumsQW4XlZs72xG666Q69RO6/tmKdYStr11qfo
         dmuM0CjbjpRpoxUnEsXLAkih3BSAKJWWKuZHdUVy7FPhgpFja/ySpqexuShtk2p8SKzL
         GB5SJrMgZM4Hy84rAWCs1XpvGkl7A7XrG6gu6pjIQ+Xom/NyR2ntwduIGSfuwOjlkUJt
         hMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756147298; x=1756752098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/mYfrRoCZPYxBucW78DtwkSqbfXOy38wcoN5hsPFkk=;
        b=ZnCTbCiyOioC9VUSXgu5kVh/6rPrmaMGU8YE8yRoX/7EKvm5YK2/YuYaLENAGzhu1J
         qHfgaYZEmcozLFEO5RhLatxsZ3BKJpPKgciddAioo5DyROziimlpUT1u4PbZ2dIK0SSY
         zWXAESdZsBvu4JPEG8i9JbkpBn9X2iw8S14DuTLdX4vp2KnutUP3Ii8sm1jTlPkp9glT
         wB4i+WEnsBa+tSCpdNV8T0cJJFiv9VQfBT+AE61/ZtOBCAPFaIZjklSEwVnyKG/Lx1nk
         lGmGcYyHKygQ7Fpa2+150OYtd3YWmZGRZr+SDiY7NioQd3W59Y/43kMmieDQILAgLvaR
         q4WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbN11Tw48AIGIr8Z8gv3WBvI6TRIme5TPdyKXpnxb65I6e3LdibO023KTa9uTMP4JgmfHBiaH8TynoGA==@vger.kernel.org, AJvYcCUcSchzvU6bETGozUygwNGWQE+qR9ihxpdMMlHaxsoqjEpLtPWBq/NAqFsqUT14lKho33qQcwZOEAwG9NE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP7T/qo7TTEHYMznbEIp3wAhQS+Pn1DQX4czxVm3QMzM4Obizk
	WkqUG9QcGIdbny8A+efZ/a0peuETNJAoW+6v2COPrzhsQHia/a98zZWC
X-Gm-Gg: ASbGncsQAR0K0LpNV+K9erC4P5XpPQ/v7YtItSzMP+Lv/XRhtZ50JcAwOWocPeZcDZn
	7LEGD4mzpAOg6R7Aq9tlTF/ku4eK4Q0BTYZfMZMD03EJxnGohN9B+UAmrtwbs3wh/O61upbZUNo
	ShVJU+OPN1bdrveMnJ6w7pEzRt2wNTWrxMCEY7JsKiG03JE3jWQiHeJwYiRQGDW+S7B0HSUQtvu
	IqGhTm8xq9UOL0PyRze+QkPzGpbTHRkqpMDMF66ClhxX92swJU+u89QBs6Q0CWK+8wJDyEYqgL0
	S9zX+swtSa2+g5CJsIdTQS0F+U0KKEMnt8if4AaPcBCV+I4zpKx4z7ss219hC5rbS+WCK5SUybU
	gXXA6s1cUjN3cRfW6ngoLeFwKoXp1LaOcGBVbTDbAP9E8Fw==
X-Google-Smtp-Source: AGHT+IFKymXKYJu1fmGxhMaEMlp8uDoZc8k61uvOCmhmOFZvsqKTjVwmpnR6U6d0ZfCnkT5vPkIPLw==
X-Received: by 2002:a05:6a00:2314:b0:770:49ac:50b3 with SMTP id d2e1a72fcca58-77049ac5261mr9859191b3a.24.1756147298084;
        Mon, 25 Aug 2025 11:41:38 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040249e37sm8155142b3a.105.2025.08.25.11.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:41:37 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v10 2/3] scsi: sd: Remove redundant printk after kmalloc failure
Date: Tue, 26 Aug 2025 00:09:39 +0530
Message-ID: <20250825183940.13211-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SCSI disk driver prints a warning when kmalloc() fails in
sd_revalidate_disk(). This is redundant because the page allocator
already reports failures unless __GFP_NOWARN is used. Keeping the
extra message only adds noise to the kernel log.

Remove the unnecessary sd_printk() call. Control flow is unchanged.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bf12e23f1212..35856685d7fa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3716,11 +3716,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		goto out;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!buffer) {
-		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
-			  "allocation failure.\n");
+	if (!buffer)
 		goto out;
-	}
 
 	sd_spinup_disk(sdkp);
 
-- 
2.43.0

