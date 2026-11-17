Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916254;
	b=1bvVYYKU9N5x/i6tx1WD422pTL5mJRRD0248CYJu+H96299AE3SBVGq49v6neADaxr3l
	 g5/bBwoqIR78Yczob5MGxKnK+bLBPoiGNNiJXEYkmuKoGzHhbWWpYauUZvRZIKDqu0cHN
	 e1C0DRxfXWaMHVYhgwrMLoriCKytILq6L/wX8mEWkpawYmIy+ryaJ4qzgxIst8tK9wrlJ
	 V+cmVONpdxhFO4MLCvv3z8cDThfflS/VwIjAuSMGp1jcen/fCHie7mDxHSZZ12WO1PY0y
	 6rHMcrVM3ECfNXaEfU72pp5+3UzxppO2JXAtUNQB8SLuXj/3OdemS/IGbh4QnQEwPAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
	b=LNaQPC7b8zqET2xJmhVZc0xph6GQFP0zf+oPs3LnOHwTgJ/1b92b+Tco5UxuBpinJx5j
	 1/FsecgJraWHPA85by3ZgkKw23I7UCK2PDgaAwaRJ91mMB9hPbnY3YjHUVIIMNemNKtE4
	 BLo/KFsL2lxi3dDPf7zMkfr5ml9mor/LX2RRjZ58c11M2faU1gNIjh1Z1xqNfuY7iLfEu
	 CCejFRJjbN1EnCCk2NK7CGPYkC3gj4rk+i+cddmP6RYm5rBiqB7r/2//AZiOov4l4VsxQ
	 KRkBP2M83YPItGU7DOnZCZWSidRh+ZbNbTZ4b1KoBlS2uGqfOEzPknU+YLZrHc61MQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T8sAbKSm;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B4606A323
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 11:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 276B4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T8sAbKSm
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso3350510a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 03:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794916253; x=1795521053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
        b=T8sAbKSmnqw0foDwoe4J88XYmKh/nE0/+nZQKU39t/Rq3a9Kzm5WmmULo+Wtw5SnwO
         rNAiT05lr8OFMBtVKlkDoozNpq5TVnWVk42lx8hlW9j62ntNvPmwVMDuqwxYMb0FU43h
         GhEqQ9G0dkZvRn4aZTtFaVkSqav5z67WRcKkKQJYQSj8t4WpMGNlRAOuLg9e3oOs7hKM
         NSVtAE9dhQ6mDwQ6lY/kaZfUlLPGHWeiJb3cy+45BUjs+/KfOw+Aw6DD13bLPpyMnTuj
         QGJyBUd+QzoUD1phhN68QsZNRSwusVTL9n0up9cP5fLwZd7RAUeAmrTs1y6TbNjK7Htw
         O63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794916253; x=1795521053;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
        b=Gi7M5zBZ/1dtqEqv3IiWpUga7HiGaISH/mi1gbPq25YJ2FP4J1/yHU9uqAlwNbracd
         Q1BPz1HetBJkJmWGocQcTqRofCR+WIto5YdMLt5NIitUJhS5U/3Sl/T0/6manFWjC9Au
         kQs1XxRgnEryc3/QyqDgW2ah0NU6HeoGi42TgR/8EtxffMTLHOJZju1AUk0sX8NDv+K/
         FaYkV3IBrDMoETvkYLSSaYlWMfFBcP/jixIHyB6Qgw9DkldmmcTurLhR8ao2hp9hVOhI
         LDEjj2Un84cb+Uug3qPqtk87BN/8YIxfNFxrYa0Z5JORO9kGze+Ia+DxWO8EIIOk52S7
         UgUQ==
X-Forwarded-Encrypted: i=1; AL+hErHWKUCcPm3WL7qD+mjhsckVmy1Q+6ZbvaSQtX79HcgXOwld9zdtS1V/FFV7s6oKxBy3ExGHSAoCL/Bo@vger.kernel.org
X-Gm-Message-State: APuU4Z/yA6z6GNhC7xxHUDvbacV0JsPYySJogfaFRNGA4gAaLPX1q2B+
	u54g7TODWU5NWakdCrOoOeM1xWOZn8f500Bid4WNQ8vmMo3L4eZ4v+7lOarLFacJHok=
X-Gm-Gg: AZFdTZeRoAs6oHK4Lt0YIIYY0i8si3EAwzM7U7AdByZaboGAiw09tOKzq7/FrzFRWwJ
	G4/OeAo1N3YTMWLua6j0EXB5FFPDSss0WzkzJQaXeuznkmr+0DZE+DpQQKnLsGJuvY5x9pTLyqe
	b7WqlVyRU6qiecNTKXIpVvaYWNH2HAOL2vDwD3uLmpSrmE63r+S/QQM407hFoReynq0MdIuw6KB
	sxc/Np6WZeS936AXBX8A2TfLupF1t44H50e/hctvFa4gCkiLJHatcftKqn+R4Vp2dDO3WahhjhB
	8SqWvOP/76eLgQye/CqJ3X+yCuv9/JSZ8mB1UnquuxhTi0zBFTvbgoLDEML9DZKOjprTYa3Edia
	pGBGXbr//GRL0RtKgCTbt0U8kz7sFn+WllFpU2plKE3B1jd+o6dP0TenLCH0VvRgoRDKwdeW5f3
	UowpWdFoUOm8NCJp0B1QstK5jAviGhpfvzUHFq8nZADI7zflUqXo5FD0lTRfIVfj0+1uaQbsqQ5
	hXHqYS3rQSbHDGyEWSepMJAy7mNSxUqjUazUlfvH6Jy7cW840rowjAhCOhBsJ2tN/gWVEIb6f4I
	eTWClEw4hugdCgyPSFJRIxx1v/DfLKvHabPBtKLyiidd5Y85cwZgHxWUJJy1Fh2aLlaJMaND9iJ
	PVFXqCIeIGVhP77xalWGKfZJBVzigCKULx4azag==
X-Received: by 2002:a17:90a:c88b:b0:3ac:9c37:9430 with SMTP id 98e67ed59e1d1-3b1b09e6a07mr13635182a91.21.1794916253425;
        Tue, 17 Nov 2026 03:50:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe8b263sm4173884a91.13.2026.11.17.03.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:50:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Tue, 17 Nov 2026 20:50:46 +0900
Message-ID: <20261117115046.1955877-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
References: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2:
  https://lore.kernel.org/all/20261117114920.1955697-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
