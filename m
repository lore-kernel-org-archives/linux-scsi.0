Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186765;
	b=HCE1m9LNUGkM6Rgl5gIBjyFZfiEDp5GvqDj4GjBaqx9MotChAkU0hDLBfQuyOJN/MSVe
	 C/sBpC28NJVwjP+tR++M3oyQgOjMgB2jtt5FSJdH34kO1jahEdNOP8e4883E8Xd6CCLOt
	 gjguEHrzn2OXgKma4Awyf/KliVMIaRsO/jTiV9Jvvm61Z7GjIlaWsntOvjkKpaY4Jnd1G
	 qDskI+7NPhd1SCV2mBCgumDjCxR5vzrkssz0Jch8L2AnLKjXz28K/EYPLSLgFsC2/aQX7
	 3ywrQoUBnTFwYNrO7/7ZNbOsPwDvqs5iha6uwQu2irvtUxs9XiXUoEuV9ZHUyGEKQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186765;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zBpLW0x8ZVchVdhStQD8QpkUQBh+hAeVrLYn+/WBzRc=;
	b=GP+zqbhB0E6KWpYX1vdn3PeOhDrwT/YLPZ+n/+JklUT6B3Cp9MBhqXncivLWpPKKLwa7
	 S0sPNnj0V/G1V2QCwPLQXzJKyZCSk2shYCzgWpAbADomzExomRhlEO6hgg4CqkM9GzCiy
	 XQrfljXO/2F4Rg+K9UfwkU+h0LVV3CdEVg63X+SRJyY6kX4ebaINXVe2YTivj12GpSL9r
	 TXVuAglAGjIJKXrVwFTboH44GR4T9cbuKRm3+eem8P5iL+E/wNigiwXY/Q13lH1HETpes
	 hwInsgFQJgruNl+NCqGsCnQDP2FD/fvsSfmd4KMtPgZkrl2dzSxB/wWZbfs44veYZsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oTYu6TJA;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003C3606A33C
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 14:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 003C3606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=oTYu6TJA
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a06e79e152so516675b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 06:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186764; x=1795791564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zBpLW0x8ZVchVdhStQD8QpkUQBh+hAeVrLYn+/WBzRc=;
        b=oTYu6TJA/HT9v5Pt4CJo2mEpnEHUPOakjZIEx95IuY8Jb1EhiRu21yXlkZg/Rh8fm3
         tJYbd7/ad0D2wAPjqpPRwbeQMrxWctS8zqR+RtAwsJdUos05jDAF2t6sH3e50DokM1za
         plZGjmuLd+seev2t4qZ8hVvf5zDt5KQ8019J/yofkYADLxApBan9V0t90sNlT0UHQBu5
         4winSFSvteGdfzqTTbULSvhnB9aFHuTI+lAMnu7XzlCqy7Zsa9GsOHPGa2eR+9hNkbDh
         zSweGZJsPqXK5We4sgvsG2uPXuW2y091pK+D7Axpxmicj3kKWd3BR2x47x6h5ZxwWlTR
         n5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186764; x=1795791564;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zBpLW0x8ZVchVdhStQD8QpkUQBh+hAeVrLYn+/WBzRc=;
        b=xYuNI7kJKMu/cXieGh3u2sSwIieWwDAL7vmLfPGl9T71B5C4kN8ieHelFMG+dFMIT4
         g+X6qUbI71wHGoPwFKQWMfam2onAeGYOuCeBmAxgLFAcWNbWHWjHXxnjM1FKs8INK1Aj
         G6W6WHzC9tCYEfwoQ47Z61nM+1S6U1oTkxKWpt5DBwMRY79krWd2/YL+mFn+8fpupvQb
         j632VNQsVnGRRr6bnrsl9FEdbFuP1Q0mjv6OD/wE7Ve7tFUa4dEepav2YBngOyNEU5TQ
         S6YlarKmTnGm6gSyRnCnY85cuuNanBrktHc7na15wIIXJ9xYSHOSrdoKv8DvJB6hnN8L
         8U6Q==
X-Forwarded-Encrypted: i=1; AL+hErEsc3bQ5YE/GSGJC6whqHmRlF5lY2E8JsCcFPXAFOoeZG1/7E6vPlGsCGyXhGVKqL9WnWROYUo9bvHH@vger.kernel.org
X-Gm-Message-State: APuU4Z+f+njLVes8N0x3XbZbVEdNYQDrWSW1ybf8UVE/Y6ITS3JczcgJ
	Ex8FIRUvTFCPmSAx0zxnBQBR06YJuMaf+FTD1ZoFpBmuWgt95MmxDwsedTPOe8awxoE=
X-Gm-Gg: AYBFou0k1NCQg5tdiMYYempap9plGOiwYXCtuhWoDsnAG+B8jhAdqhMou3Kwk9Q4/4j
	4zwHAtiJnq2lO5nqi7LEeX2ILFLX+QvnvFK1YeyjM3ofBS5po2mZg41OMdqHuf27Y8F+zFvIPgE
	U+ZR49x6XdPT6oAt8PctWLVtwjhW16LLSPfOtRm3vqKsVWu0vxmzEl2WZ4oQnLoaQ7QFyJIukn7
	laxaufrUVzwCRVYYwI8zWIA1aT55jhqjVz79ocr8nEKDS82gXMBUCI6ryjoGurHVtbtHM8r0NQm
	s2qw0eon53GVlJaELFfto67rLWwpHRK1Fd0vnPxY9QgCzF5GfdHOj89m68i48UngBucuBbfo+W1
	Sx+jHFVejn38LFUNPngPNPXbHdpdXE/SNPdFqKglBXbsfccJXnWiDlTACybuTWn9PJLa6kDlFJ6
	J9469cmj1LnUP8Dj30PQr68XOxzSevnELUK0/kF/5/EN9wG3V9BJsjTVQQbRaDzk9lHb9TLzxYe
	XdhgIg+A1ozTjLVHR+feocPr/Pid+eIm5hfl4NPhaTNn2m37juVS/cdgPjMSId0u44razX7a71b
	nabKud1jYpeVDYX0DqOVwnmNip4UnCio5cUhBhdrOIj0yQqCyVNTg/XaoYa4h88s6Fpf0gNMsDu
	AhMVznJ8TejLSjVa+8Le9ag8jNgi5dSwcz2uo
X-Received: by 2002:a05:6a21:898c:b0:3fb:5a07:e08b with SMTP id adf61e73a8af0-4014e255372mr2496997637.80.1795186764309;
        Fri, 20 Nov 2026 06:59:24 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc80d4sm1461584a12.6.2026.11.20.06.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:59:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: njavali@marvell.com
Cc: mrangankar@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: bound the ISP83xx reset template to its buffer
Date: Fri, 20 Nov 2026 23:59:18 +0900
Message-ID: <20261120145918.3127879-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
References: <20261010181139.1911817-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, Oct 11, 2026 at 03:11:38AM +0900, Yehyeong Lee wrote:
> qla4_83xx_read_reset_template() reads the reset template out of the
> adapter flash into a fixed buffer:

This is superseded by v3:
  https://lore.kernel.org/all/20261011144752.2063334-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
