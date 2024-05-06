Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD16BB29;
	Mon,  6 May 2024 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999131; cv=none; b=t81EAzHpBRstg3tgJo864napycq+ZYQvsniISNYyDy6iyQJJZNvqvgqLJrrzJSWkdl2wHne22r9tSf66zZ0v5FnRTR2SostDyIdDZlb/umHvEzsjVg1Kve2ubtZ2WcqmedwkmohiinTVmgYS5yi5Bp/t0dkEVazsTmgxU7N4n4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999131; c=relaxed/simple;
	bh=eWrOgBVa2EmHuxqtg40uOKlcNUfV+CKaFyYDMzRD35s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FBNTsEDWMJ6FrYRGdaYDxtAIMB67duwPtFf8cFFKBT4caa7+JLrocDaxbBUbOU1Gi6Q+Afde/g7bXUAeVtZujS4P/BnewVtgR+zVmcCpLFdILk3VwItIVqWOW6HOX4iEoaa2zdovXdacG88Asl2Anosx+U/tY5zV7mKzD8kbAlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NlTfrhir; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlTfrhir"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f4603237e0so934968b3a.0;
        Mon, 06 May 2024 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714999129; x=1715603929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ivPrH3iqpRFf2SkjzhVx3cB/47VKRE6zwyw0zr+fHU=;
        b=NlTfrhir11ptPPAyJIT4NdgZotiEVIuu1xjkGGOsl3SVwIbz+IobryzTmscvbUC0qg
         pd2MJSl11SP80Fw2JLu9lwCd1qeQL2BgoJeoAVmn7k6T2jxEyFaa5neKYJcA0c+jVhMJ
         RrO1HXmqnnikq5T5TgdkYAH/kzG2/tEYsw9u7OqkzG3eLoC0uDaA8NC4EOGjciuf1n88
         744X6RtZ4kKGiEhq5xsbFizY12BKxfnKfMAvf6vj9+hRVGtr7O0N57ZiV13UnTGGlyTJ
         ZHW8cJ2Jbj2VOXmmgERI+CK7Li+m9L62FX/6BqyWghQmsOTnH6Wc8F6K2SayMnR1/Vwv
         HKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999129; x=1715603929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ivPrH3iqpRFf2SkjzhVx3cB/47VKRE6zwyw0zr+fHU=;
        b=J8M1X5K0PS2CT0pV2bZPYn3GJAos2CQKSzszaXuMu5Klqp8oZhqxzMWx5s1hN/tgct
         k3p34upSm8GUcAOPiEtaShNl5RD2rY8SIdjtP4qWzKG4PC/3s58hl2WE+TttOnMQBACP
         rkjOAd/byxH6lZt/0iM5e7F9oI9xlid/sP2vQy9Yo+CNsiTOAUVp02qsMJ+ZWsnLoN4h
         OyHByAB+zd5MfwFJNYHNUpvh5fOmjciuuK9P2EYauDVjooK3qaSllg5mLT2+QsGhrtPQ
         jOXlrXcT0oQho08GhAOkiDN3JfTv45EsBoofRjRLqaNfvIZj2ZRRTjPNZ2VlZYsLtoeH
         Ke2A==
X-Forwarded-Encrypted: i=1; AJvYcCXwnFK3Fco8ANsVcmeOvO10n3GiTXSOL22722r+rirm7q/jp+QAvKLwrurONo1kQlM+DfoKlSXWdyDiYV6h2gc5GD9Vi/INLUrwhTRhva+i6W8oAgSos7a5RVsEF2GkJEPHTu5qvemvHg==
X-Gm-Message-State: AOJu0Yxxq+qOs6aLWPrFs7HNRzxKirdK002LzUQZ1MRK0neBKSvsE8cv
	XWj1x5z8rENZzcJdNDcAGYj+Ia+oG3VvTD7FlOBP2YKP+8RxZsG5
X-Google-Smtp-Source: AGHT+IG5pY8s694cDWwv9l7B1q6NCRT4A3Nn4RoexOrqwWXZeF0prJ2aX9gL5nOU6nbz3jRbZLzc8A==
X-Received: by 2002:a05:6a21:3a4a:b0:1ac:dead:68 with SMTP id zu10-20020a056a213a4a00b001acdead0068mr16483660pzb.24.1714999128985;
        Mon, 06 May 2024 05:38:48 -0700 (PDT)
Received: from VM-147-239-centos.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id w6-20020a634746000000b005dc4829d0e1sm7940433pgk.85.2024.05.06.05.38.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2024 05:38:48 -0700 (PDT)
From: Yongzhi Liu <hyperlyzcs@gmail.com>
To: skashyap@marvell.com,
	Markus.Elfring@web.de,
	njavali@marvell.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: himanshu.madhani@oracle.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jitxie@tencent.com,
	huntazhang@tencent.com,
	Yongzhi Liu <hyperlyzcs@gmail.com>
Subject: [PATCH V4 0/2] Bugfix and optimisation of exception handling
Date: Mon,  6 May 2024 20:38:33 +0800
Message-Id: <20240506123835.17527-1-hyperlyzcs@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <230af978-c834-423b-8d42-78c164be40b9@web.de>
References: <230af978-c834-423b-8d42-78c164be40b9@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi maintainers,

This patch series includes two patches that address a double free
bug in the driver scsi/qla2xxx, and optimize error handling code
in the qla24xx_els_dcmd_iocb().

Patch 1/2: Fix double free of fcport in qla24xx_els_dcmd_iocb()

Patch 2/2: Use common error handling code in qla24xx_els_dcmd_iocb()

The changelog for the patch series is as follows.

V3 -> V4: Improve patch summary and description
V2 -> V3: Improve patch summary and provide a patch serises with
two separate update steps
V1 -> V2: Optimisation of exception handling

Please review and let me know if you have any questions or concerns.

Best regards,
Yongzhi Liu

 drivers/scsi/qla2xxx/qla_iocb.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
2.36.1

