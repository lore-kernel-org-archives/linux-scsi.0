Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A0B26B2D2
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726294; cv=none; b=KpX8DXG4jZ+Bw/DG0RS3k+ELbuWz4hyPE6ay8JhExRPhPAi1zTnDTDyP0GSe+dC1enVITubK59pKL1YE8QaET0sg74gevTWAlnikldkxsSJIugZZEz1cL3Ykxo12JIW7PdSUME41L2QxzzT5vMKgP8HQQ/HxSwX5uiSPae33NfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726294; c=relaxed/simple;
	bh=BcXvvFdLu116b/wVINcwmFhC/dSknQh5qpNOb2/ByR4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEkBAKoPjilBZsmRolr6eKNJwVVbIoqsbe5UEWKnMOq31FQYyTrOS0fNYhH/04eebQmpXlCajFnFRLldkUQgXyzZt8z8Zw50Gdw0UNu4lG8Cdnn1tvvsaKFutxDeJrxVyvMlDo4mOf8ui1KDlhggD2dVm2yb8H4j3gwfJZEswss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MZisFG4G; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=egqtkeAa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MZisFG4G";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="egqtkeAa"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67Q6Rkm4683466
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 06:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=XtNntw48dBLPq+zL2C2VWvB0
	j9j6z3ilCpDtZPb8jQQ=; b=MZisFG4GSAijkSRPFA04LQS4mwUQAWddHj8GXVlM
	V+2SLb3ppJp2Y+jWpD5HTsplsoW1dhHfpTx4O0BsqEMo4clKH7ALla/bofXbjeO7
	jtyn+Cq7s9HSrE0/Zf4KRo3l9iYuuRqNqf9Z8foy0mNIobEuOUzm+LFX5TILVdgO
	BfoLt4OZRRRv4/HRVvk+8TSpDqpgTVYsWKxtUuw2gkRK8ih75mZ0uj0AgmvxAtc3
	eeSWtYluHuSolgpjPhMhhnZQUge3NbR9ZgKtD97lY99Pd+qdvN9UM1s9yLqnUNls
	6CepC+Sl1eSZWz1cT8Ehi/eZo+RoYNeNnDc/ZkSQFqW5uA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g9fgxje9a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 06:38:11 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e695a3b28so159556585a.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 23:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787726291; x=1788331091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XtNntw48dBLPq+zL2C2VWvB0j9j6z3ilCpDtZPb8jQQ=;
        b=egqtkeAa5oufrSFUwOFNmuPb/uH256Pt5ckByBRrFXQyCWhIpfeAw047mCnnYKAwzI
         OEq/EL4M4I0GnAy3RyWBZagKGlGma3hABKnnG66Sq19klgyIdmXH/60PZ6Jd4HdWcBUn
         +B5fImQqMkfjka5GWfe7uCvF7H1pBN2Poubj5FqqKSWHEN8K6HUro/J+VaRUW2ke2Jva
         iYy9Lnr8JJVqAfD+upgnk+0+gyBZ3yzQXvmN4Ng9UHKL+bsddIeFoqnN+5ysLTTwcSaC
         Js07wiZogO+ZFJKQdd2UfNN1OyC2J7XgV9wJHaFDCJueU50qcGV584CEnfFpdyUebnio
         nBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787726291; x=1788331091;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XtNntw48dBLPq+zL2C2VWvB0j9j6z3ilCpDtZPb8jQQ=;
        b=g4WUwOPt8UHWlKhCB9s3h+FPKkwfzr2qHKqabMVcUta+O1ZvQuRW8qwNXC8HCmyTzN
         i1UcOi/R45Y5LXzyGRQZb5DjLxRYNM45ePhuernWDrNPaDgOrn0bnj90YpI5yuLbTa3l
         DfjR733+fRIhVZtzCin03MxBSZnOa+McCNVEG47S2c7VBt/2z7eMRKg236Jnhiq9ZBUH
         ZKlnZEkaffkR1kfFp4ScB1i8k2oAZBhRUL84BKv/pdpeBEal45TFjwmQOSlSLjziaVqP
         wSzdAfZ3JI46wZl09wc312QR64OXbfFWvz5Utsp3K213zdXYUE+hBfnYUIcHunbftKt6
         iyTA==
X-Forwarded-Encrypted: i=1; AHgh+RoQmpyRBWUL/yiZQj/j56THnR7yTVP4xLcqcvt7rFmpzQU341n/si/Vmg3IHS9CK6vc/EmWDnQ3sgLM@vger.kernel.org
X-Gm-Message-State: AFuF++ndN9v67ogxlXzWoL3+1aOTWs8RLgl1DztOhr+HvqxSoNK9cq+6
	pguQgSpe1afymMsXdpcPkoY8I/oA3fLe1Is9dXXzTwCuLMuZTjYUS6Zpd6IfVkfwXPT8JriOty4
	THa9XeYFOaOpz9QEIYaySM2XD95+AqNxNpeyyXE66waO7cKqXrSJCcHbEi4yRtv3Q
X-Gm-Gg: AR+sD13J9NFx2CWu+X/zkElGOGrivEu1Hez0ziB8kTbMhyrjinmqxh5Km+V4JO1wym3
	UfseKTNQ/ivOTYP7SRVrXAyhgoSoFjo2CW/nGK2Il0TBah005nN2eEqB4BZRhNSIb4BdqYWmOBo
	p4heERoZBX0uJhHapA8A/wJhVnBWp66Mtdzo68sZaHaidMyMNn/V1hsCIa4RPEZxsk13H57oWF4
	nH0cVV00IYJ0QdURNvh2uR24Dkg7iXsmKYzX/k4OIroq8dkIxsqD5svdj1aunJAq7TJ0vQqmGHU
	sv+Rngu4qTaVJcDkkOlQHhsShJ/u0mSYEnY4OKbJPZeHV8+uSa3h5yXGYcku2Nw6EZpQ4gNh+eV
	PiguGCqyOER3x2vAdDm5U7gDl3tu29evZew==
X-Received: by 2002:a05:622a:4118:b0:527:69ad:fceb with SMTP id d75a77b69052e-52e418f4777mr47129221cf.0.1787726290822;
        Tue, 25 Aug 2026 23:38:10 -0700 (PDT)
X-Received: by 2002:a05:622a:4118:b0:527:69ad:fceb with SMTP id d75a77b69052e-52e418f4777mr47129001cf.0.1787726290378;
        Tue, 25 Aug 2026 23:38:10 -0700 (PDT)
Received: from trux (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dc9b82cdsm16544305e9.13.2026.08.25.23.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 23:38:09 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Wed, 26 Aug 2026 08:38:06 +0200
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, beanhuo@iokpp.de, can.guo@oss.qualcomm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v3 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Message-ID: <ao6Jzn75ju1d5pfV@trux>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
 <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=MqZiLWae c=1 sm=1 tr=0 ts=6a8e89d3 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=xHNurQw6US8NauEldhQA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: x8w8y-KPv5iADOGDSCAWgmzgNWPLLnMn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDA1MyBTYWx0ZWRfXxpd7MvQct+Tl
 1RLfum1CivwHH3PV4rmrscEpF20ucTtTKWJLeCTMzq7jp2kiDUvi+7xWUNelm/r+HVVdXiAsrsO
 36pOjvxXKcsMCMLUjGdIh5W/9qUS58WQ1xPQjKjfRo6waeMbTxBbGHaQwBmEbOB/h8wNhvr7Ieh
 G46beBe/7eSeE32abheF7xshpF8f0UAe3zAzzZATCTI7iTTaHpGnAA2X96QThE5TdlH1ny5Ph6f
 UseHx0mC468CDI39A550UtrcmWSjrn2Lo/MoV5VIUUHaG0+FpSeKEu8vXI/JPIK3SEobyaqEHO7
 vh/cgA+IGsH91d4fq7PeAuPRiVhZ7KzYiC8UJQ6jFvwHUcLJJ4JzjS2XdkP5R4uNS6af9cHwTig
 xVg3W+WLyduzWRevG/YFZ4s9y7DtR5YYu9hd+9ZkQ3JW4xUvbgJU/OTZdUKjrmk/paVsN2CCFI+
 P5tQGO/zK2AK9l6/suw==
X-Proofpoint-GUID: x8w8y-KPv5iADOGDSCAWgmzgNWPLLnMn
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDA1MyBTYWx0ZWRfX+yYbNvvzHSa2
 /4F+QAo5u6z30w9LXWWUqArgCrZiXZObvjkSU6BdQQjlNrvUVpMadyUsyibqweJtXuFDgQH0ORk
 aigtDN25yq92fvUoHThP7kAw5+UeXZM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_02,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260053

On 21/08/26 17:06:08, Jorge Ramirez-Ortiz wrote:
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
>  drivers/ufs/Kconfig         | 1 +
>  drivers/ufs/core/ufs-rpmb.c | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
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
> index d0c7ea7a36f4..a1e169ad3096 100644
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
> @@ -153,6 +155,7 @@ static void ufs_rpmb_device_release(struct device *dev)
>  int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> +	u8 dev_id[UFS_RPMB_ID_LEN];
>  	struct rpmb_dev *rdev;
>  	char *cid = NULL;
>  	int region;
> @@ -213,8 +216,10 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  			goto err_out;
>  		}
>
> -		descr.dev_id = cid;
> -		descr.dev_id_len = strlen(cid);
> +		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
> +
> +		descr.dev_id = dev_id;
> +		descr.dev_id_len = UFS_RPMB_ID_LEN;
>  		descr.capacity = cap;
>
>  		/* Register RPMB device */
> --
> 2.54.0
>

just a keep alive, any issues to merge these?

TIA
