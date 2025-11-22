Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA6218027
	for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 22:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763849744; cv=none; b=pDGLHCUGe+jKoJEg7U/4n1HAznIDhhSPlhlvt/9PWvETyHG7m2kkjWjMSEtpECIjUAVAFxXCDqx5ZuxoP4QgNKgS4Bxny+o37LqMmhl31kZVEy9h2vLiO3pcCYHU+xwU982AFkcn2W0DGnv4DoysOSPALz3GFmUL1UmKpVuQsYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763849744; c=relaxed/simple;
	bh=ZbypScHbAO+VX+ph/T3ZdsLo8gmuwSU4A1hRC3pmB4A=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0y+n2jeeZxeYbitLPqaaVXvCVJKL96MWUhSWx1iDp4JMtJVuO7BhMuJuXNE6RxL6qX6U4bA3fjNu1j/y+9TMnf3jHkbbLrLhyCe4Qi8FSqn2G4r+nmSOxc3hasBp9qndGBGCwRAtwUH4wjms31JM9mDhTxIEyEfyTKioWZOzTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GIrzr6TC; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GIrzr6TC"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47798f4059fso2994165e9.2
        for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 14:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763849741; x=1764454541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVgHtHLQUB4Ofl49yROKnRqGj/eOZU46fNyXcNC6ijs=;
        b=GIrzr6TC+rC1jHBhWNEZHbBgJmTviV0usGrOPIU+ew74Kzt0DMYxoU3w2YmSrfwIta
         9+BFuDAaKhloAGgefwaCm1GBN3TPvIU5CqXZyrzjS3CLnf/A8vdoGj5uz0hLeCljPhgU
         TZW8uvXbMZNSwNDU9yD1zNN5inrq3XPpvTwLqWcQuKKO7CoNYBB2QqplIIYNQdja5k9X
         zFrVMK3x2dGV+YUTzURTsf+MgF59oJ6pgRwArRrjL/jREte1DeIspHGow0fjZToCyQTf
         vZw77It9LxL72kaGNF91wIoWtzZIEdQztuNzE5iigbyfcc4PNshnuxpZJfsS4uqZMV0P
         wfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763849741; x=1764454541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVgHtHLQUB4Ofl49yROKnRqGj/eOZU46fNyXcNC6ijs=;
        b=LrO1LpM/n3LDOLUfFa/sNjOOFpqMDRubHyv1AK2s2RhlkmcnDbGIeryLBPFIParh4A
         eKGKgJGHCoSBot2e3mYKpfoRHAbiLbf5ikkdVpPiI+FjiIAqEeZb5Q5UV0TOkcHIxAJu
         XqAKI979dp7IMNO+JR1MHqWj1hxQezGsgZLlaNrissW34cP1GDMNnC9DGpVL0+zMPFwc
         /1LZL93OpfQe67hjhE8+Q4zH32tMEZsNHwGwvp/9qoi1NZP66qNj0Zzy0IG1wvensA2K
         zxFndkJXD/Awka0a1CPIwSnR0jkQoNjN+8EdLD8+XhDcf5m71VEljt+L9IqJxGucfQid
         Tydw==
X-Forwarded-Encrypted: i=1; AJvYcCXUXrNxfPQVTulJ/dTiE++dP+mWL5DW2edBRolwytmsmG5zk9QAhD1PH0j9HTx8+Mbz3ssUAmyvIqZA@vger.kernel.org
X-Gm-Message-State: AOJu0YyOkGz2R0ZPKFAKXXb41YNXg6EKgrEsbQVYpcDiOv8IBX/nzkn1
	sISjKV2WHxQnWf6pjhILjYnJMTC4P474Jkb6VX+QGKcDELKXu5fdO1wCHWDOUmE=
X-Gm-Gg: ASbGnctgHy8t3fhCkcSQ7mVF36ZAfMZYatjoa1NJ0NOwsHVvJyuF2YkexuvRB4BWlGM
	zmGtUXJ+9mNo0yH4JLxrSoiGYQIv5h1tuZmb1b5f3WRIVhI4qtlTMH9+Xa1nxCd8d7FJTXpp3BE
	7WMEENYNzM3CAYjxY3gDjbbFDDGL2JnVG+bOG2BBqAdTVIFu2gz/pH5QKPmJqEKKiG1/18117OI
	gPL4eGFFt4w6DD6qLYgvPhwC1gZqcZPmRcIyX1wwzks/cIsGwrzFDZU4FIq6bo7nlqSenETXtUh
	KX6L3zXd271BJECP1MYgxTtb9WalDm+TsJ9Wktg5OZKWF+XYmcRjq+3JM6NJJ8oX8TrL7i8IGu8
	4GKP2OEyScZY3N7pleqtCXu9jVMF/v9gF7oSKPeOtMrjnP1rc2VgJAcIGPlaaxTdp3MYvPa9iw5
	824bBXs1B5qC+fk5KotbFMphzlLlcARQjvsHRYIV4BTqlLSDNIjuXmPtzCVJk=
X-Google-Smtp-Source: AGHT+IGlTo5VXic6dl+yY2Jsj7NKBqSSLOSj+GOyTKWsJ+gPRPcGzyPc5UizW5yfkzUy5ex5L1HyRw==
X-Received: by 2002:a05:600c:45d1:b0:477:5b01:7d42 with SMTP id 5b1f17b1804b1-477c01dcbb6mr39268015e9.5.1763849740508;
        Sat, 22 Nov 2025 14:15:40 -0800 (PST)
Received: from localhost (98.red-80-39-32.staticip.rima-tde.net. [80.39.32.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3558d5sm111214545e9.1.2025.11.22.14.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 14:15:40 -0800 (PST)
Message-ID: <d7d58136-9730-4ed5-a0b5-42a33281da28@gmail.com>
Date: Sat, 22 Nov 2025 23:15:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] scsi: qla2xxx: remove references to unavailable
 firmware files
Cc: Nilesh Javali <njavali@marvell.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20250928141859.215307-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250928141859.215307-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/25 4:18 PM, Xose Vazquez Perez wrote:

Is there any problem/drawback?

> They are not in linux-firmware, and some(all???) of them are loaded only from flash.
> This should have been done in f8ac60855ebfa and 940a7f09ad645
> 
> v2: remove firmware upload code
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 30 ------------------------------
>   1 file changed, 30 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d4b484c0fd9d..cc0bb30c1963 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7606,12 +7606,6 @@ qla2x00_timer(struct timer_list *t)
>   #define FW_ISP2322	3
>   #define FW_ISP24XX	4
>   #define FW_ISP25XX	5
> -#define FW_ISP81XX	6
> -#define FW_ISP82XX	7
> -#define FW_ISP2031	8
> -#define FW_ISP8031	9
> -#define FW_ISP27XX	10
> -#define FW_ISP28XX	11
>   
>   #define FW_FILE_ISP21XX	"ql2100_fw.bin"
>   #define FW_FILE_ISP22XX	"ql2200_fw.bin"
> @@ -7619,12 +7613,6 @@ qla2x00_timer(struct timer_list *t)
>   #define FW_FILE_ISP2322	"ql2322_fw.bin"
>   #define FW_FILE_ISP24XX	"ql2400_fw.bin"
>   #define FW_FILE_ISP25XX	"ql2500_fw.bin"
> -#define FW_FILE_ISP81XX	"ql8100_fw.bin"
> -#define FW_FILE_ISP82XX	"ql8200_fw.bin"
> -#define FW_FILE_ISP2031	"ql2600_fw.bin"
> -#define FW_FILE_ISP8031	"ql8300_fw.bin"
> -#define FW_FILE_ISP27XX	"ql2700_fw.bin"
> -#define FW_FILE_ISP28XX	"ql2800_fw.bin"
>   
>   
>   static DEFINE_MUTEX(qla_fw_lock);
> @@ -7636,12 +7624,6 @@ static struct fw_blob qla_fw_blobs[] = {
>   	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
>   	{ .name = FW_FILE_ISP24XX, },
>   	{ .name = FW_FILE_ISP25XX, },
> -	{ .name = FW_FILE_ISP81XX, },
> -	{ .name = FW_FILE_ISP82XX, },
> -	{ .name = FW_FILE_ISP2031, },
> -	{ .name = FW_FILE_ISP8031, },
> -	{ .name = FW_FILE_ISP27XX, },
> -	{ .name = FW_FILE_ISP28XX, },
>   	{ .name = NULL, },
>   };
>   
> @@ -7663,18 +7645,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>   		blob = &qla_fw_blobs[FW_ISP24XX];
>   	} else if (IS_QLA25XX(ha)) {
>   		blob = &qla_fw_blobs[FW_ISP25XX];
> -	} else if (IS_QLA81XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP81XX];
> -	} else if (IS_QLA82XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP82XX];
> -	} else if (IS_QLA2031(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP2031];
> -	} else if (IS_QLA8031(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP8031];
> -	} else if (IS_QLA27XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP27XX];
> -	} else if (IS_QLA28XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP28XX];
>   	} else {
>   		return NULL;
>   	}

