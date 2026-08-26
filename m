Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479C13B47F9
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 08:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733225; cv=none; b=qV4vWZ3nOOMjnCj7NOd59t/UZNeCAlsYU8FQYRON96esShkcg2uGuGsDsgscgXuWnKjaWuhNn/bGzHRkGB0pVt/E7sZNT8+idpBds4CuPUq1eAFLP7OChuolrjENmdfieVk0l+J3Lw6q1L69iH1Y2jmtrmBxDu4G9S3fYXni1bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733225; c=relaxed/simple;
	bh=1s/hnNv+eRVrW4DraPfnP/EbvoEBWNKlBOd+VCDdCgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bub5jeJ9rggY4HBNlHM9c2LOuT2dOmzoppMJnuzC6ilTSqBJvW5kA/MA0N6+zwnzAWz3OkVd4jG2nCgHkLFEbmMu3hqmAluVk+M3uwEi4FQVZiplOqivQpzqw7j5Ap6gB4DUtPM4zlf3EIrc+pMXxkkXdLOE8GWyKFe95g//P7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B+cb9x4q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DuiO6CW2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B+cb9x4q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DuiO6CW2"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67Q6RlnQ683486
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 08:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=wdVDYVTOKVyqdmsS645/m3lW
	H1189Fxw062p4r2LpzY=; b=B+cb9x4qVZZ3M8weYRaqFSqAgYni99kPEq8cWKPT
	duxup21M4vBphheDu9hyljfR04R874132mghT18Hcq/VyVmBuLyY2LCM7G8X0sNb
	Isez2txqIpS2Om7fNxEQONGCv2+/epWKZGvAteplqCC3kvhXvvLfrvmpjlxYy9Cv
	XA3TKIHxY5kOBiqOkYQwSTOgqqewkWO2dI0cUBCzsLroQSCqjcQerFt5xhh9fOu6
	Ei+/1OqR7YNvx8w3pS37fNuACgxxyguWePioRU/FncRpWcqG4bmnTb2Z1FJH0UeW
	V4ayxCON9mH0GSG89oQUNTZJSmRKDMHF1tsphXvc3csGQg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g9fgxjye5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 08:33:43 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so2235471a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 01:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787733223; x=1788338023; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wdVDYVTOKVyqdmsS645/m3lWH1189Fxw062p4r2LpzY=;
        b=DuiO6CW2m+dt8AZhEdWwJHpWiRapKRXY63AaHXzoHFX3v+LMKn6+fWOL9y3WzBbeRq
         4v/deEsf9ExN9vD4Yjjd8xg+E4trVLQqi2eYGpVW1maU+QznBLTheAnrbzvB1Hlu8Bgf
         5nX4NtODrkmx/OPCMqEO+fe0i1RQJMkrcguwI7Z66JgHyJxZ0pdC8geBvXPO2fZMtTji
         TG0T+cGS2i17Se9hSApPLBJSc0YyIIHhLTXy3SVsh/lUSFmobCWS58M6HbqIdSoRlyKy
         1tdOtpJYtzDo649crisa4EYEvM5Fk6lf5ZBKqBdLe5i7FX68deQQnikCdLRgzLgD73GE
         y8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787733223; x=1788338023;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wdVDYVTOKVyqdmsS645/m3lWH1189Fxw062p4r2LpzY=;
        b=BqPjaT5KC8sa4BQ+iEhSONPz3DCQjPWYHUc1YTfeo7ab9/NmbCAtLEEr0XXZsGI96c
         BRYlNmTD+AuAFBdoqCQon5md1IIfHa+7fMzFbMbbpl7WH+IJi3B96+k5vvqOK05sxm4Z
         Ut/mbvfedvm8gu1tuUI3Ujsqf9azkqPPMB/8G3CcmNO/W94qcQ62FKs3LYxctE0dK0DC
         +XdTT9ZVSik91tVjfumEyv4xoT4WkfnAi6CzwM8Ee7DLBrLpMJqgGVjKdNipmh2tZSX4
         2Tan5kRAYAyWZVefrp0yh1GP6MZyiNNmLERwUxuaJX/LA9VM3ar5AiKeERkApkBU5T68
         hlUg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5gyPkWKk583mdnLMki8gEuif23c94qu+l3wjWDs0J2bGZazor241TlepJ2/ZMD2hqtF0ySH+SamNO@vger.kernel.org
X-Gm-Message-State: AFuF++ldsQ4ltrYlslzNNN1YL09b+srSXj+ww/SL80S0lWfpPDXKvKDO
	NDtKJTPrPHJZJMNguyLHyXIPahuIu/Q7VnpqqLcCUMXJqPddwm894MV8fFLVee085VAVnyUHof/
	hJXG9LQpeMQdysHLi2JJyUVhiOdKz3bfBAnR6p6CVaMc+/oWRXatwBLbz6pYEVKWF
X-Gm-Gg: AR+sD11di210OBiJYKq1X3LAjQT0AVPCROGv69I5qPbrcOqOIQTQuDOMOjP+6VhN9yR
	quqewTs8xhelkvWkZXa4UP2bB4UnZMs2LyWbiglNyOITjLJluSbWVF77dReD8PgRzClmfv9/YHH
	hi1y88U6ZBazCp+NCkEc8DzdS+49aKy+bbq5FYlAv54M76zb7UyGKwSNU0YC5QTnXp0FWuxOu4f
	rS6iMdHtGyWw48y/Z5z0O5dmXf4g76B5GruMBwQ+BWKhXbgtIqjgVaFMaKb7TaoLbdQKqDt+X57
	JoC9hUuvlhq1zke3GFQ/r6WsLUEOiBNSRINfkNhoWl8roJG1JDlGatdhXiA1xUmCapLN2a6iMo+
	tM8GccJkc8jjxLwX86nfXCSU0PYk=
X-Received: by 2002:a17:90b:1e4f:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-3966d5f8eaamr10259366a91.10.1787733222765;
        Wed, 26 Aug 2026 01:33:42 -0700 (PDT)
X-Received: by 2002:a17:90b:1e4f:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-3966d5f8eaamr10259271a91.10.1787733222268;
        Wed, 26 Aug 2026 01:33:42 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d8c4e56sm6032015eec.22.2026.08.26.01.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 01:33:27 -0700 (PDT)
Date: Wed, 26 Aug 2026 14:03:12 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, konrad.dybcio@oss.qualcomm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2 1/2] ufs: ufs-qcom: Restore HS/LS link startup mode
 for Qualcomm UFS controller v6.2+
Message-ID: <20260826083312.uprfo2tgwp77vkkb@hu-mojha-hyd.qualcomm.com>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
 <20260825145203.265579-2-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825145203.265579-2-nitin.rawat@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=MqZiLWae c=1 sm=1 tr=0 ts=6a8ea4e7 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=mD9iP5WZsj5b6qphjP4A:9 a=CjuIK1q_8ugA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: -BeA0swGsXz6YZTDFMiW6nsiuFTeAwGH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDA3MCBTYWx0ZWRfXymUUK+gB8V4c
 NK3D5iTr/VPl0UT3+oOARRrSqDiV4X1INOkCEncLFRufRObtGpi9msDMcT2V0xs013ncXDWZygN
 pYBOI1QNN/vqdVxdAKQEiqVC+qIWZtnO4gAJAmQyhoUNE6gV0ekTc/g3O7/x66LZ44wHf826/+1
 kIwoRw13ZIAw0mfWsFrwmUHCV5vd8JVnOZUC8TGIO/AklTPgBDOHOJrjW9ebAkWkLbNtPD/f1z6
 eZYhdLY1qB9PD9x5xHWNy/Pm9EpFlPKAMPgSMZ+uJarVsL1DO/q3Au5kkynjYdrsUQrksKTeEho
 Cbx0F3I/HINNOqZVeNaumzLLD9KyFeNgSbZvinJmufweSkt+4WOwjTuTKaPlOgQ+u6G1MTFe+9e
 80IZpzdaB4toiWcLHYCmPBzo/gSt7SGIDs/bhuXD1u7sD/iehw5BQod8S5DHeO4GC1aI+GO+lgm
 zQ6HMDbW484WgKtk2jg==
X-Proofpoint-GUID: -BeA0swGsXz6YZTDFMiW6nsiuFTeAwGH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDA3MCBTYWx0ZWRfXwVWVntGWooak
 RCYDmh+JQcoTkwRrYLb+vG8oo/5SMOe3bw27tH/WCoRz5Xbh0P/boRup35LL8mQtNTsee5XI2h+
 gaoDIB/Po57umDmt76Vid7GOUi7DqIA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_02,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260070

On Tue, Aug 25, 2026 at 08:22:02PM +0530, Nitin Rawat wrote:
> The link startup mode (HS LSS - high-speed link startup, or LS LSS -
> low-speed link startup) is decided in the boot stage based on the
> bootconfig GPIO. This selection is carried forward through the secondary
> stage bootloaders and finally to HLOS via the spare configuration
> register (REG_UFS_DEBUG_SPARE_CFG).
> 
> On Qualcomm UFS controller v6.2 and later, bit 31 in the spare
> configuration register indicates the high-speed link startup mode
> selection, as per the Hardware Programming Guide (HPG).
> 
> The spare register value is read during host driver initialization but
> gets cleared after UFS reset. Preserve the spare register value during
> initialization and restore it during link startup to maintain the
> bootloader-configured link startup mode.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>


Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

-Mukesh
