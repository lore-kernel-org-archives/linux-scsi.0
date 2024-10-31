Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2B12D1EA
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730397078; cv=none; b=pJ25L2CKBfES+mYIpmBaARc1hHqANXpold0T/WyYN2gf0vENKTiYH7FrYBkf8SSxSF7Z+XsiRVCcYrYEhBA6H6j0eCKrkWS50ltY9Z6KGIVE7uNDCiVPnXaaG7Y8G9cTBR5wFBuHuNzsSueoUwGS+oPnyGo1/6YSPRmD7prl6S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730397078; c=relaxed/simple;
	bh=Ni1U9fho0Th+IMuZ/0qhiHmfcftjau0wpXzqemeDSqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XGxqwhYlBUHhI6xt73Q0fClZI7E5c7Z0MOtijDqe18ckGLsv71cu0cDk+Jkea8POCISbMK9DLsP6t5STryL3wl0liNSXLVf4g5TpB7Y0UIF9fY+3c5vqYV1uJ7gwvIeZe6IZ5D/ORv9bzoZ9whfO38lmAvExnj7pHqkqrt/mm8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JlkluKwV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JlkluKwV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XfWkq37K1zlgMVS;
	Thu, 31 Oct 2024 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730397072; x=1732989073; bh=mcMtxgkYfstL28H76lbFBjyE
	8qpLNUWiXaPuEM575W0=; b=JlkluKwV4S1/tH/FNHsZ87uDgIQQmul4BrZeat7a
	r0ZyncxD5SpdrWA8mH6kTtpB9rYs2iGASfFA9xGAktLq5e1kmAAKTzm4i2qkiLhl
	IlZH4/pcf5SPNX7ny9nuHIJuvDCgrcLnXq3IUr9q7/LH4vjsz+SbZJSO0wE73/Bh
	36ZJm4CuHUcDuSlqC2qoyFPUWtXd1x8z6Q4poiyor++MhFG/PX0nBgppHA51KGJb
	QIua2ZbF/J/4pj3QE57Hu8Eh5nliH51558AYEYcLGNfi0GyF8aOUCAwp0E3eAtgw
	+E4vk9Gn6mYap8umR2znKkJufjw1PlCy2+i/xAuUBOjrOg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j3T0tZbXzYKv; Thu, 31 Oct 2024 17:51:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XfWkl6sJwzlgTWK;
	Thu, 31 Oct 2024 17:51:11 +0000 (UTC)
Message-ID: <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
Date: Thu, 31 Oct 2024 10:51:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
To: neil.armstrong@linaro.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/31/24 7:46 AM, Neil Armstrong wrote:
> This change regresses the Qualcomm SM8650 Platforms, QRD and HDK boards=
=20
> fails to boot:
> https://git.codelinaro.org/linaro/qcomlt/ci/staging/cdba-tester/-/jobs/=
182758#L1200
>=20
> [=C2=A0=C2=A0=C2=A0 5.155432] ufshcd-qcom 1d84000.ufshc: Resource ufs_m=
em not provided
> [=C2=A0=C2=A0=C2=A0 5.155439] ufshcd-qcom 1d84000.ufshc: MCQ mode is di=
sabled, err=3D-19
> [=C2=A0=C2=A0=C2=A0 5.155443] ufshcd-qcom 1d84000.ufshc: ufshcd_add_scs=
i_host: failed=20
> to initialize (legacy doorbell mode not supported)
> [=C2=A0=C2=A0=C2=A0 5.155874] ufshcd-qcom 1d84000.ufshc: error -EINVAL:=
 Initialization=20
> failed with error -22
>=20
> then causes system crash:
> [=C2=A0=C2=A0 15.400948] Internal error: Oops: 0000000096000006 [#1] PR=
EEMPT SMP
> [=C2=A0=C2=A0 15.667218] Call trace:
> [=C2=A0=C2=A0 15.669833]=C2=A0 _raw_spin_lock_irqsave+0x34/0x8c (P)
> [=C2=A0=C2=A0 15.674829]=C2=A0 pm_runtime_get_if_active+0x24/0x9c (L)
> [=C2=A0=C2=A0 15.679998]=C2=A0 pm_runtime_get_if_active+0x24/0x9c
> [=C2=A0=C2=A0 15.684811]=C2=A0 ufshcd_rtc_work+0x138/0x1b4
> [=C2=A0=C2=A0 15.688991]=C2=A0 process_one_work+0x148/0x288
> [=C2=A0=C2=A0 15.693258]=C2=A0 worker_thread+0x2cc/0x3d4
> [=C2=A0=C2=A0 15.697248]=C2=A0 kthread+0x110/0x114
> [=C2=A0=C2=A0 15.700703]=C2=A0 ret_from_fork+0x10/0x20
> [=C2=A0=C2=A0 15.704516] Code: b9000841 d503201f 52800001 52800022 (88e=
17c02)
> [=C2=A0=C2=A0 15.710956] ---[ end trace 0000000000000000 ]---

Hi Neil,

Thank you for the very detailed report. I think that two bugs are being
reported:
* Support for non-MCQ UFSHCI 4.0 controllers is broken.
* The RTC update code is activated too early.

Is the patch below sufficient to fix both issues?

Thanks,

Bart.


diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0787387b7ce1..0b6b0cd4af33 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8620,6 +8620,13 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
  		ufshcd_init_clk_scaling_sysfs(hba);
  	}

+	/*
+	 * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
+	 * pointer.
+	 */
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
  	ufs_bsg_probe(hba);
  	scsi_scan_host(hba->host);

@@ -8714,8 +8721,6 @@ static int ufshcd_post_device_init(struct ufs_hba=20
*hba)
  	ufshcd_force_reset_auto_bkops(hba);

  	ufshcd_set_timestamp_attr(hba);
-	schedule_delayed_work(&hba->ufs_rtc_update_work,
-			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));

  	if (!hba->max_pwr_info.is_valid)
  		return 0;
@@ -10345,8 +10350,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
  			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
  				err);
  		}
-	}
-	if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
+	} else if (!hba->lsdb_sup) {
  		dev_err(hba->dev,
  			"%s: failed to initialize (legacy doorbell mode not supported)\n",
  			__func__);

