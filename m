Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3B62E738D
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780042345; cv=none; b=WHwwBeunbH9oqKvk0gPiM3Z6Zl/tHD2JzlVfDs4fln6G2t6pGin/Tv9MPLv6Y65Ajm7J4ndGJLEl9pGMvX/3FNdEFnzV/iuAmu1kH6+L0SUvIi2S6x/ZnG2nQr250IoVf+874iQUq0dhKsBHEmPgZTjidLcsl1of4Uvr+4qU4NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780042345; c=relaxed/simple;
	bh=XElrbiQUdwj4pZFjtysK26sBhblu/x3G8k33spqRseg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVCp/sUqyOuSA+DINQCkj13GGvaJAcVFhMEe24lbqV5gJD9DucQIWGhpCdZ8UWs4rM4A6eZG9XxpvUP1Lwd0UCVYuz+tHr+YtNVqfcC9FL3d8OK49G08SUQr3sCdZp1o/vQ4Ggm0XcpMf7v0TQGsHCpD4xUpfTSkR/WDyad4dwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FFHCU60r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Df0jhLF2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FFHCU60r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Df0jhLF2"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T5uQGo562794
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hAypR65SkldtCp3ZxSwdiMM9Tr9WzF98KULp93k4+bI=; b=FFHCU60r+ZGYR/PD
	2QKf4tQigeceL/1W8GRvHmlPBV89yf8uKlBtYD98KjRVuToROqCFBz7uA8A9T2Qs
	Sd42s3uh4W6H09LAxLBzyIm9Yrrw2xiP9dv/dKCHETEEzEJzflkYABpZMi8p1hGz
	s/JU76Xa3s4yQ+998/ntO361iIXZi7ptPqqb7o33zrFjOV9FVDeitJvY/UAgO2eI
	7A8iGr8T4xgM0RlJOKwb3d5RifonG0z4vkfDrouzRmcywBc/Fw3uR7b7q4E15qqd
	SYivx3R0jJncDxNfBS0/Q0fPtPpIsUUjfzZAJdmzfZiAVt/at49oQyYZvoEMjkPc
	yX2iXA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eevug2gjq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 08:12:23 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ba718173d1so101565545ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780042343; x=1780647143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hAypR65SkldtCp3ZxSwdiMM9Tr9WzF98KULp93k4+bI=;
        b=Df0jhLF28SOszv6Jk58KtMohOAJUA5XUDy1H57gd2f8EGUCrDX93bOwqpOIW19wGhP
         yTNGCcZN1mqx1PygpE128Zl9ihjag88CbZKppOpC92IhVH8th12G/RhmCDUbtm95y1nm
         kAiIfXy/y/+zxmU45zDIwAQ6rlBdR/bmcIz123K8n4SqEGdrUeL22Mg5EG3wPyYcCLiV
         9AbKOjBE+Ks13UgBqieMCsGeID6gmJXH0rJHDPnWJOUamguo070/exdoGx6Hke4JayHY
         iHEAHlTa/LUZxWtuQ1UbCeqXBu+oa3brt4P/8m4/MdR+jVzUV0nuLi3cjnDP/qdywHPX
         HWMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780042343; x=1780647143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAypR65SkldtCp3ZxSwdiMM9Tr9WzF98KULp93k4+bI=;
        b=XTvUc5A1LWPWphdKG9yoVeaChih3c5kObEMPlo6Tbx1r4RlLd8FJimmVzoks+QfXpK
         /P+Ot/3lMGrOgmilBhm9ZchL7MfO2LeclDeFTPNE5jKwjWQncTBl0MEbbV1fA96iG44a
         Uqcqk/2yZ2YMy70HZc7PgMhuI060oVWGkzRn6fMpWWZ2gYyjrt54KMYJDGjNTGwIK+vK
         v5trQ2kf3OuDaW07ZAkeFktrjWZacA5Uf7PA1hWCyUX1CMjGt53ZYG5V95H/azNy5/of
         GPhICK1JubrLv0Um/fPd1F+Z3koS3hzX3s3veKoGfh3vvpc2ckgvOzwooEatg9l9ITw4
         DAgw==
X-Gm-Message-State: AOJu0YyM9hX1enhhZhO8oEcViSqrE6H480dNQddEFzbnp1YCuugeGtuD
	Oapw5EepbdWtRthsZ9y3WNit+j9W6tbl8Nblj63goZLgFwHBkDmH8hDM6TOuN0pWJtG5Hb/g7JT
	YcAF7Ug4biJKg7cVeSD9/2VFW+2U3i7UaZyC/o6xkXpsGkpUu2n0zIWSnqFz6jpfKfH9HvULT
X-Gm-Gg: Acq92OEsfdWCwMTtZn+YL/0uOXW1o3G1BZbCi2JhqKXIyHLJMAY9SP8uJsR5NFPcziZ
	dj6oqRGy8XOdZR3xw3YNJKtOfVeQ/zXBo05t4TK0iXetXgGbxCc8SOYIJtPL3wUtm5eyZosiogT
	tiPom2vsrZLDFkxcln125ypbUYfAAdTKc2oWYUiyioPFT2sTyxnOtUVKclZQb81PzFCHI1yLZ+L
	kqGDgxEx06PL8S4w6b7fGtZ+uahaY69GnUZRmrNiYwQvgdNpZLrrFkg/IaZYpUgFGGeRxhNaFZ8
	vO2uU/ae8W5ZOLr4UkTfgdFww4zP02Ead0OQT6xXcdSSBWXA4/60OWqgxZLeII5lcGPCOmyR2A1
	vIBcJ8jKxxPwnGuQSQiE15vG53GJXDz4023NwUNKG+T/9QoZSQTcGaXD34VPx3Ce9sgVAO4BBKd
	CYcqg8nRun2/vq/wv2sRPjOQ==
X-Received: by 2002:a17:903:1aec:b0:2bf:82c:6322 with SMTP id d9443c01a7336-2bf2050b8dbmr28918095ad.3.1780042342836;
        Fri, 29 May 2026 01:12:22 -0700 (PDT)
X-Received: by 2002:a17:903:1aec:b0:2bf:82c:6322 with SMTP id d9443c01a7336-2bf2050b8dbmr28917735ad.3.1780042342408;
        Fri, 29 May 2026 01:12:22 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23a0fd4csm11498835ad.30.2026.05.29.01.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 01:12:21 -0700 (PDT)
Message-ID: <7f2f9a0a-03e9-4a0e-ae57-2b0c557e029f@oss.qualcomm.com>
Date: Fri, 29 May 2026 16:12:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
 <20260529011421.462046-3-can.guo@oss.qualcomm.com>
 <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDA3OSBTYWx0ZWRfX0rhgc8JdjZlP
 guTIPqFmJZRJ1bB/PRolzlZ/EZFBlP641C4CCIczK6QklO6L7nNoDPXTV5N02dsg+O3RkeCBDSQ
 nng35zYm/vyVqDJtV0cFBxkT63s4WMuK9ZO7H4Qq+hv3ns4rbS3ePoXgbmPxeXDq7a2TASbr97N
 ALIESobcTep9/0mC2kDw0kbTxx/BdLbRwnpCAMjekkhFIrUlCMSXWWzHmpkOxc2/K/MbINUOlBP
 eXeYT6RMhkgccOAQS3jrg7aNClzSMx/WL++3qb6w8mY4NZqBLdBGJ+plLMqp+urnLbAnrq+SKYq
 KUjGnDZzLrHcC8ypTAvOjlukqmPhsOwS1yfUxf2Q+xR3Vmw248z5QzvKYdCdvtYnd7qdMx93Ckp
 s9ieXxSKHJGbWKeHHfhofCkZL1HySJAjlchk2cK1lKKw7Nil7O9I+Zm7Du9o6NdVlV65Q7Bn3X0
 w0OyhVHW0nhtmoQtXUA==
X-Authority-Analysis: v=2.4 cv=SNBykuvH c=1 sm=1 tr=0 ts=6a194a67 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=R3sHXq4109Ddd7yNOpYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: 8RLTt7T21Zh6LI_CKKAYlPS56n1eA8or
X-Proofpoint-GUID: 8RLTt7T21Zh6LI_CKKAYlPS56n1eA8or
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290079



On 5/29/2026 4:04 PM, Peter Wang (王信友) wrote:
>
> On Thu, 2026-05-28 at 18:14 -0700, Can Guo wrote:
> > +       for (i = 0; i < count; i++) {
> > +               if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
> > 
> > 
> > +       for (i = 0; i < count; i++) {
> > +               if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
> > 
> > +                       for (i = 0; i < count; i++) {
> > +                               if (precode_en[i] > 1) {
> > 
>
> Hi Can,
>
> I suggest using
> for (i = 0; i < num_elems; i++) { ... }
> instead of
> for (i = 0; i < count; i++) { ... }
> as it is more clear.
Thanks for the review. Let me change to num_elems.
> > 
> > +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
> > +{
> > +       const u32 lpd = hba->lanes_per_direction;
> > +       const u32 num_elems = lpd * 2;
> > +       int gear;
> > +
> > +       if (!lpd) {
> > +               return;
> > +       } else if (lpd > UFS_MAX_LANES) {
>
> Unnecessary else if after return.
You mean removing 'else if (lpd > UFS_MAX_LANES)' and the dev_warn()?

Thanks,
Can Guo.
>
> The others look good to me.
>
> Thanks.
> Peter
>
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

