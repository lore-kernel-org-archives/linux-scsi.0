Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE54D1E0DD8
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779633482; cv=none; b=CfOkqrCRPcIApDKhWiAUfeOiwd6OHWet2GlXk7tJSVVHgNMr7dlrnoBiRlqi8vDo58aAblF/ODu4H5OZy5xy7Jq8r3z3FEQdfvuAiOuC8Jq9ysPCXv/p5UQEhon46Ur748+kmEWhn06E9Jj21fAZGFV2kWvLxE07fgqf9yrx1ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779633482; c=relaxed/simple;
	bh=jlmiftGiH8yYOwl7Mns81kkQhPs/uDW3kHOWZH57OKU=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqSbuL+vivF1OtuWkJB3YXOsB5227mMYDRNg7wGFgL4lWyxglyyau6tLONa7MqwDACdaYxPyappY3XmCvbwdqZr+Gx1HZAKlVfN65wK8KGHtPIBa/Os3MFHrXkuoxn4+qHfNF/WgI8D5cI6dK42A2Y2oqjpioPnfBDs5DljgN4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzYojdUS; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzYojdUS"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d7828221bso795104f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779633479; x=1780238279; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nNd/5GrCRhON/bCbiazAZBD/KzVHuOQgR+Ccle8O2bs=;
        b=MzYojdUSF5lao57mOH2L4sjzMrdmJa6mCqZki6EmRdyue2D14dAT1Bh5hmHc2Gflk/
         kGGz6y+V9SoReip+SdXTeb+LIzNcPikJr5f+p5axi6SZPqbNjGl3mPXq/E0TD9lXq0ev
         X2ZQjkordhejgLjE3JQ6C6kzs5fqRG5XCpIrap3swmMZujn1cM2LOJ3pxv8D/8YoN45b
         WOF+UNt9WQde2Wo1cFqWR4WNsn2b+5UqGJKAdyKv3twmZZH1F1ljT7MVUM1o6TolcXb9
         m0LNyF1cD8JRAL072uX7g4UteY7grkHV96Sb5z3MkcSlXP/A+4Z4EyQwksEGpzUx8vcW
         ftgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779633479; x=1780238279;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNd/5GrCRhON/bCbiazAZBD/KzVHuOQgR+Ccle8O2bs=;
        b=eQ7tfoH0unQ/AvPrdvexOMWph+sNLlhHDtwnO+m60TK1ikJt84uuOetebQVsgRvIoi
         5FeC/zMnF5f0zc3Pu6xqgr/58zikxMd70o8h75oOFC1PNLGhOiBLufX/0OFn172M7DsE
         cbzAAGLY9DWdVRyjPFcyGMx5KstJZh+ZpvvoRvTe8h7Otw2IRzWizOAbHvlhLwd3VWVX
         kZNhx5xE0eVgCfv9ZB+yUhGYqJv3v6vFs9C+BeVQNg1Kt4j6Qob+S86W4966SIfITKOd
         L4a3I6EKH75F82xUE0NGkzZtoJMTKOHemrZAtPWkZBy895B8LoPUxVHLqPYpUXBiFpwR
         DrvQ==
X-Forwarded-Encrypted: i=1; AFNElJ/S8GioxuGuLtp9sUNt6/gB9pk5jbZm8mcKOB1GrrcUJmNtTLJYQ9eAL40VtFvMO8shldkg6PBStdQ5@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2RuPpGmlvXEAIH9zPahNXN4dbgbdTpGt5vp7LTkqYi7D+8hmj
	sImsQYcN4+jUrchw84+lh5aJL9aa8KDXUe8R3S29zLelU8gWJAoluMc=
X-Gm-Gg: Acq92OGMs0widkj3bVP6A60Q0SbElkIGhmlGzAcnGa8ru27VKhX5X1T7bzg3PQ846kO
	mnFJOh14pZ+4e8B1O7Y6cuHsBCRWnVpsOgBsVsjbSZgxdr79dbMCcYyS2nfZh5bTnnoG18DqC9K
	Px27VtgpNFPVpszuNMEWJgiKW5GeSy0gX35lX7F9f7FrhmFo8pPtuf7bzQMVhONRO6zLhioreYH
	uIXC2pXvwV8qTl76Caquh6YyP9K7O3XIIhAWNKz8cyG4b9FeXWUpib7ZSUrZj07Q9WOA3oCe2+C
	yddotoPTCr2UUlfMz2jhdVCifdtMsnHAgKlplqI0zrTaHM9hokOogOxBtikUVSon8iwmc/R2DXP
	7+e3G7rjr8ci3/NTCY6BJaqYpscU9Z/M+eTOA3IlQkZNSRytD6lqEQ8jkl6m0K4d3W4aPQgyv/K
	kbLvtiHoz8fp91CbYIwILjk3gRSq9ldzNAUQXlctnpDQgdBnUGj6cp2vxxx42d5c3UPd4gjx8=
X-Received: by 2002:a05:600c:8484:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-490428cde40mr86291185e9.3.1779633479130;
        Sun, 24 May 2026 07:37:59 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9f6ffsm19980923f8f.1.2026.05.24.07.37.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 07:37:58 -0700 (PDT)
Message-ID: <43c4907c-81cc-46cf-8665-73608fc175fa@gmail.com>
Date: Sun, 24 May 2026 16:37:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: devinfo: drop "Promise"/"" entry from
 scsi_static_device_list
Cc: Christoph Hellwig <hch@lst.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20260523142027.352969-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260523142027.352969-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/23/26 4:20 PM, Xose Vazquez Perez wrote:

> "Promise" "" is too generic, and affects any device from this vendor,
> regardless of its actual bugs. Applying BLIST_SPARSELUN globally is an
> overbroad approach.
> 
> It was originally intended solely for "st_shasta" family of controllers
> (SuperTrak EX8350/8300/16350/16300/EX12350/EX4350/EX24350), as established
> in commit e0b2e597d5dd ([SCSI] stex: fix id mapping issue):
> "   -- add an entry in scsi_devindo.c to force sequential lun scan
>         (for st_shasta controllers)"
> 
> Removing this catch-all entry prevents unintended behavior on other
> Promise storage products that do not require this legacy workaround.
> 
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> All email addresses from @tw.promise.com or @promise.com, in the git
> rep, no longer exist.
> ---
>   drivers/scsi/scsi_devinfo.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 3a9b691d7e72..5988d941e76b 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -216,7 +216,6 @@ static struct {
>   	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> -	{"Promise", "", NULL, BLIST_SPARSELUN},
>   	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
>   	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
>   	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},

Please, drop this patch.

The stex driver forces a sequential LUN scan for st_shasta by failing
REPORT_LUNS:
         case REPORT_LUNS:
                 /*
                  * The shasta firmware does not report actual luns in the
                  * target, so fail the command to force sequential lun
                  * scan.
                  * Also, the console device does not support this command.
                  */
                 if (hba->cardtype == st_shasta || id == host->max_id - 1) {
                         stex_invalid_field(cmd, done);
                         return 0;
                 }
                 break;

Without the BLIST_SPARSELUN flag, this scan will truncate at the first LUN gap.

Although later firmware versions might fix this problem:
8<---
Version/Build - 1.1.0.25
Date Release - 11/2/2005
2. Compact Lun mapping during firmware initialize to avoid lun gap.
[...]
Version/Build - 1.2.0.10
Date Release - 02/09/2006
3. Add REPORT LUNS support. (not enabled yet)
[...]
Version/Build - 1.3.0.20
1. Enable ENGINE_SUPPORT_REPORT_LUNS,ENGINE_SUPPORT_SCSIOP_MODE_SENSE_SELECT
and ENGINE_SUPPORT_SCSIOP_INQUIRY_EVPD to support Vista SCSI compliance test.
2. To work with item 1, firmware needs to return actual transferred data
length.
         This requires driver update at the same time.
8<---

The driver logic remains tied to this legacy behavior. And given the lack
of active maintenance and vendor support to verify firmware-level changes,
it is safer to keep the current BLIST_SPARSELUN entry to prevent any regression.
