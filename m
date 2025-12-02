Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188BE3FF1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661064; cv=none; b=c/CS00odxIhz89U1Qyz7vUXxKEJFbQi1KMd4cisCdaRH0n/EPQcG6NfoCcThm/oyghgH7DqpWHi4qEWYAfUKXwhk+A1nM2CCZzDV47SKWBTzGphVmyUBVJ2fMWFQVLJW8glmYMpcq77ExrwyRADI/LNiEimR9PJ2c7sdLSjEybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661064; c=relaxed/simple;
	bh=oeo6FQDW3fXLzjxga/4/2KYjk+Py5rovP0IkAsamuDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R4UZTGaHS5CdYtrPfyFg2qIByZNVRhQvo67ZR4QatzpJoxRpU5dzC2vxuowRpru9t9Y4j+xfwbwiHt5vbSN0oQRkwkQOlS750yrFza8JvVnfd0Ix+o+IF5XlpU1Bb93wt5+V5EBNc5p1gVKLyqLEAd0R8oToyjuz9xwB7fBhL5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lNy6tdO1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lNy6tdO1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLCKd2xNmzlfdCr;
	Tue,  2 Dec 2025 07:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764661059; x=1767253060; bh=Zs7uwc6VpuS9SqHAig9Xe24m
	q2/r7fZ5T8aLoe6MeII=; b=lNy6tdO1HHgeTUUG3SJktReg9MeYwq4PpdOxa1nn
	nJvp2ywQnJ5xWm4jQOFKV2Eps9yZUoSbGX/NzVMtRjcv0LsXDLJaBbSdVRBu6GhA
	TrgS/nC5CCTLDWNoewVA7KVpTsSufPvtjqTMoIlc2Q1I6rK6wynrkSSKg10PA+2G
	cGaQugw2DLI8Ll+Poq7PAI0WjW3qqqbq8lfRksW/+2LD5BxuIgM+BFZFFEsvQCwP
	GBTv4uLg7nj/2/eTMUQftLsiFYr1A6higKdO2n0L6wniRoqKsPHFk7XAax4MuXcI
	copSmfI9coC0nKwGlRNTSXblcs2ibMnk2G2Zqdsz79b/Lw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9C3H2ojphm29; Tue,  2 Dec 2025 07:37:39 +0000 (UTC)
Received: from [10.25.100.232] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLCKV2yN6zlfdff;
	Tue,  2 Dec 2025 07:37:34 +0000 (UTC)
Message-ID: <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
Date: Mon, 1 Dec 2025 21:37:32 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Roger Shimizu <rosh@debian.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 6:46 PM, Manivannan Sadhasivam wrote:
> I checked out 1d0af94ffb5d and applied the diff, but it didn't help:
> 
> [    3.878314] scsi host0: ufshcd
> [    3.881687] scsi host0: nr_reserved_cmds set but no method to queue
> [    3.888310] ufshcd-qcom 1d84000.ufshc: scsi_add_host failed
> [    3.895031] ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with error -22
> [    3.903705] ufshcd-qcom 1d84000.ufshc: error -EINVAL: ufshcd_pltfrm_init() failed
> [    3.911572] ufshcd-qcom 1d84000.ufshc: probe with driver ufshcd-qcom failed with error -22
> 
> I'm running out of time to debug this issue. I hope Nitin can also look into
> this.

Unfortunately the series is not bisectable. Does this patch on top of
commit 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
request") help? If not, does the combination of the patch below and the
previous patch help?

Thanks,

Bart.

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..ad1476fb5035 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -231,12 +231,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, 
struct device *dev,
                 goto fail;
         }

-       if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
-               shost_printk(KERN_ERR, shost,
-                            "nr_reserved_cmds set but no method to 
queue\n");
-               goto fail;
-       }
-
         /* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
         shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
                                    shost->can_queue);

