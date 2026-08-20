Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B54F3C8732
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212572; cv=none; b=BR3p4JOiICPjl8m86O1H136FAlVEfRJxe+jNO7mrLVByV1bVjwAAFmoD5GgTstuOWSMiy4osOoaDmqkpJPvO9+4SQVacrkcXQsCXvGvRa1O2vugo9h94w97LA/owjnRPjbQVt8u+2v+1nl2Ky/D+x5x+4DU/mZHtNwOhLOPr7LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212572; c=relaxed/simple;
	bh=bOzLz21hfS6/UWod+/Gevi36WLHH4EcAxWDzp3cGBcU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5okYtvsbyzLHg81V27cNqHKsEZHEVTYEu6TR0Er9+jjJu5oASXmvFVdUZiynJ971WRui0EUkmXnwtvRTkqJZicbNRjUib/U2a/fO6D0HMxRLZWuxR7jn+SWbyOeMKrHXIDLdILY3gLqZc5iIBcsVdWAAE4AnnCkwEtrBdb/D0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kk67/tHj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L/+Fhtn7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kk67/tHj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L/+Fhtn7"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K65mVx1258546
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=cJJanPQdnYkmxln2DE9mTJ/v
	awF2EeRoo1KhLh8CXvk=; b=Kk67/tHj05tORbZDb4S2h24QBuHWvLhbtf+zhCI/
	W9g00kGynvm5jXoHm+sfMxQnHm5hJP6kvsgu937/91NsGoxG/brIB1zIEcE7GzHY
	BfsIKTyM960StSfUrZhQ+GSntm2odZ5IDjf+vdeDSq8OqkbBhx0GR4W1lXHybMCY
	ClGplfxziqiTCc/XRCsmYYibScwaQAWlkIVmPZfSwkHNrgRy02CW29/c9zoPxA2Q
	hF29D2ZPtHu1dY5qHf/UdBD0oFsTDIzDhUgYxk1NtIELpARjMi4Q84raSwCKp7Io
	depWS7rEQaI6xbntHw5toq3TmKNCVhHjSi5OYRgTut8Lmw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es63r3b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 07:56:09 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e9a2b95b5so339985285a.2
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 00:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787212569; x=1787817369; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cJJanPQdnYkmxln2DE9mTJ/vawF2EeRoo1KhLh8CXvk=;
        b=L/+Fhtn7ktcoCAtEYgxWQMW6YRobi2GsZBiqFhNM7wI523RWVi+gfV1rcO72Zp5irL
         spVZivmUSa08k0PsB+7GtemtlHSYUnKUaSCoRWOJb3Ly2eKYzwDEWTpgMe4avR39g6UG
         o4ZNkBWsAsNAtNo5yaPShkl1gNZ1in0/Ow61LaEX13FxJOdqq65dmZ+e+/MZQiXmfKzI
         GEkYolSh2wOe/BLliV+jfAJNiceONDUHud2thRYD7p9Z4AWFDYjEBDYuEyygXwunnlZT
         jH6K8WuUH5Owf6oPq6ed5HmT4czy0aLmoCIrDIVe/BpqUyHKHtSetySa2dk4pP6XBm2q
         GsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212569; x=1787817369;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cJJanPQdnYkmxln2DE9mTJ/vawF2EeRoo1KhLh8CXvk=;
        b=m+nnWNQfWUipUjC+g06MuBcQcEU8Fc1eWwVfxbmH98uy/pFDOp4bxKJ2y8A6QXqt0F
         Q3zDUybEAT8i81AHW2eGvETEAuKJdAW1oxt2SUfDa962yEwDzHDNKYRCdffG8ROPWqIx
         KpCWYFjKpqyld5WjElFa193AlLu5cjtoMdCYY3rxvTDBkmVmToUbTpBKqngjsxnSeAbL
         55Jl6G63fjKUnJnBwiOxMb59UsRUJjAkZfZ4CQHdQQoscwQRuIEvI9J80aEYKQWphn8c
         HfLTweto8bEuyVwQq801+pf57wCyAPCHXcnnywCIv3Lkzb/A1pTWYAukU2z54+VDNw15
         qXSA==
X-Forwarded-Encrypted: i=1; AHgh+Rpch9ddLUJv5KEGieocME33F2XFSaKnwO2lH5lIbr9XpGW0Jjf6wJVk0yO9Zd95TkQ96jjlOXvT3vWD@vger.kernel.org
X-Gm-Message-State: AOJu0YynrO7+5rMn9hWpeiriv1nzVo+DO2LTs/pNDJaxCmU9bMrl0hEB
	cNToAzxBBrzBpH1cFWscGiyZ3ommW41t8cI3ORvr4kHty6y59VY0tD+5tgr1MNhstieYTu+5tSC
	YkGDbp7E4eoO/XsfL7q48ljRkeQ5CfOMWRTVJtaS5VCcs0GATpiqyHp3o3/sAIpmi
X-Gm-Gg: AR+sD12EuayJfhOD2SEz9oX8NC4zi+IloFRcAMYKzkV5Oc+Vm0Mr6m5GN9FrOHzGRHf
	IIR8txQZq/c5uoKUrVJu47fJwCyxs0r+kh/QtKTwFwRZMGQ7jI4SkkSUqhR1brGqfJDhIJ0e8Fj
	P7xHcpGqEdMPy5RTu3+NFgS8vDe1bFX/oX3++E1g2ZYxKyhC+1KYoIJPVVqdYg5Y4bddYMkt1VK
	gTIXVjMo5rwj4nvg4vHV1lW73KHMMNsfdWpnnPiDWpUyHecS/lLwecCvsN7l/pdD1v6p/f7FMyL
	wjnPmK+kA5bVQZ3zhYjQnymFua+PlgpzrxmKvQ5yrwr/ZrcMl/vZT7hqIknZjkbuB2V7xmShFA2
	y0zp6wS2wuUb75s/2dLDQA77I/QZRoQ==
X-Received: by 2002:a05:620a:2847:b0:936:75ba:7c5a with SMTP id af79cd13be357-9371e6f65damr876707985a.31.1787212569129;
        Thu, 20 Aug 2026 00:56:09 -0700 (PDT)
X-Received: by 2002:a05:620a:2847:b0:936:75ba:7c5a with SMTP id af79cd13be357-9371e6f65damr876705585a.31.1787212568711;
        Thu, 20 Aug 2026 00:56:08 -0700 (PDT)
Received: from trex (189.red-83-60-95.dynamicip.rima-tde.net. [83.60.95.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9e784b3sm107828335e9.3.2026.08.20.00.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:56:07 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Thu, 20 Aug 2026 09:56:06 +0200
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        can.guo@oss.qualcomm.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v2 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Message-ID: <aoazFihNtmySWtM4@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
 <20260720091614.544968-3-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720091614.544968-3-jorge.ramirez@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=E5/9Y6dl c=1 sm=1 tr=0 ts=6a86b319 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=kuURLP+TZHqixYhcqKuzcw==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=agKarpU_PVP_ObXQrwIA:9 a=CjuIK1q_8ugA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: uAxrsmyFTvgKLZJS5YoFk99qI155nvDC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA1NiBTYWx0ZWRfX28164CBn8+Lf
 +/bCDqtyJwhdMuOy/+GAWJL5EtqhNyqGngnEj+VjPtk0HrfYeX+Q0+YElbm8jsihotFFKGFHGKy
 82Coj1QY385VuJXHnCk0i7vBtbJuE3nuOkubajQaH+W2W4gPpXaIZWUmeysKZTawXVaRvFV42sv
 7pa3brCacPUjeJDPQLzf8Q22Iy0OynbXKSGd8Ln6p3b90dhzxuNQQE5cWXuSMhcP8S5MbK88oHS
 jxYfiuhMdeQYLx9ncqSIY1j/+k+8h6+OD75k+DG7KxjI77RngVvYf05p5gioY2iXOgwvQo3BxcO
 0+mFXDoKIZp/XA7qOpAo5ZziKJPgoWCvw4+iYnQHqWheZJfM1RK4waxZmlTHLioabM07iOl7ZCw
 j126/jIpXxr8Ubd4WNCmAKrtfoCFgTLLnIABBqdhDf0QQXpitlvishlaTBGY4Qy9HhaQj79yVW2
 KB4efziyE/bGvbX0KXg==
X-Proofpoint-ORIG-GUID: uAxrsmyFTvgKLZJS5YoFk99qI155nvDC
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA1NiBTYWx0ZWRfX9WmcFePkYbTz
 2oZbzAaEiTg3IoCr7JiQU4oLOAGT+gJYJi5VOkGaYHrIsoZv4OGaBTgEYK3hoNpFxs97oZ7remw
 XgToX8+kbxbDXHxt91BqSZ1ECTVcomc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200056

On 20/07/26 11:16:11, Jorge Ramirez-Ortiz wrote:
> The RPMB authentication key is derived from the dev_id handed to the
> RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> is the eMMC CID, a fixed 16-byte value, and it derives the key on that
> assumption.
> 
> The UFS RPMB id built here is "<device_id>-R<region>", which is variable
> length and longer than 16 bytes. Passing it verbatim would tie the
> derived key to a length OP-TEE does not expect and diverge from the
> fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
> UFS ids.
> 
> Hash the UFS id into a fixed 16-byte dev_id with blake2b instead. This
> keeps the derived key stable and unique per region while matching the
> eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
> identical and no OP-TEE change is needed. blake2b is used because it is
> already available in bootloaders such as U-Boot that must derive the
> same dev_id, avoiding the need to add a blake2s implementation there.
> 
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
> ---
>  drivers/ufs/Kconfig         |  1 +
>  drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
> index f662e7ce71f1..b62c00e7ff06 100644
> --- a/drivers/ufs/Kconfig
> +++ b/drivers/ufs/Kconfig
> @@ -7,6 +7,7 @@ menuconfig SCSI_UFSHCD
>  	tristate "Universal Flash Storage Controller"
>  	depends on SCSI && SCSI_DMA
>  	depends on RPMB || !RPMB
> +	select CRYPTO_LIB_BLAKE2B if RPMB
>  	select PM_DEVFREQ
>  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>  	select NLS
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index d0c7ea7a36f4..0d8399b6497a 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -10,6 +10,7 @@
>   *	Can Guo <can.guo@oss.qualcomm.com>
>   */
>  
> +#include <crypto/blake2b.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> @@ -21,6 +22,7 @@
>  #include <linux/unaligned.h>
>  #include "ufshcd-priv.h"
>  
> +#define UFS_RPMB_ID_LEN			16	/* Match eMMC CID Length */
>  #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
>  #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
>  
> @@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
>  	struct rpmb_dev *rdev;
> +	char *dev_id = NULL;
>  	char *cid = NULL;
>  	int region;
>  	u32 cap;
> @@ -213,8 +216,17 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  			goto err_out;
>  		}
>  
> -		descr.dev_id = cid;
> -		descr.dev_id_len = strlen(cid);
> +		dev_id = kzalloc(UFS_RPMB_ID_LEN, GFP_KERNEL);
> +		if (!dev_id) {
> +			device_unregister(&ufs_rpmb->dev);
> +			ret = -ENOMEM;
> +			goto err_out;
> +		}
> +
> +		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
> +
> +		descr.dev_id = dev_id;
> +		descr.dev_id_len = UFS_RPMB_ID_LEN;
>  		descr.capacity = cap;
>  
>  		/* Register RPMB device */
> @@ -228,6 +240,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  
>  		kfree(cid);
>  		cid = NULL;
> +		kfree(dev_id);
> +		dev_id = NULL;
>  
>  		ufs_rpmb->rdev = rdev;
>  		ufs_rpmb->region_id = region;
> @@ -240,6 +254,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  	return 0;
>  err_out:
>  	kfree(cid);
> +	kfree(dev_id);
>  	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
>  		list_del(&it->node);
>  		device_unregister(&it->dev);
> -- 
> 2.54.0
> 

hi again Bean, any changes on this change? if so, would you mind updating it please?
