Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F419C540
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750605384; cv=none; b=SGUSbPJpV+4fz2T4PH6Yseq3+4ZgaRfJvRIN1CwOlF/LjGS0es6dtlatUmEjD9yTwb4UGm5Iba8aSU9WZPqKwpLfOKmyeX1HVfftFoSyUrOcAz+IoKUFiOkMhOgglooFdqQmF7Uq63tILMYfFy/fPn8MLD4Z2YZaDyeaNBVE3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750605384; c=relaxed/simple;
	bh=8uAt+R9QKABn3nX6nZT/Y7rKM1grPj/9mjul5urxgwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mb6ORYIEGOa3H2KJes6gsCqDWznTfZvBiaAs2oCpd96jN5tFBy4OGqiNEcwsl2iHoA/7+VMVRllkE1sJQCn3rHNtAIhXQ/Alr8IwgjaEMcbfPGHD4AU5mmPvgKU/9fQRPrL9XDWxlhMryoCmD3tf7EOSxaTnGzJZNAxzjgVJ3/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DNhlYn8S; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DNhlYn8S"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55MCoPm1005557
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 15:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=w44qBsK+6lDTVdeGCkoj9uoc
	0+WdT0uN8/42Vd0SJ0c=; b=DNhlYn8S/pc51pN0200rO+7nsW9ztT91FFjy9kk/
	eVuBGx5ZrTu8HtRve7rLFgc/0Gvhs2DvIM1EutuZjcOo5RC8iZ9roJPMWhh2Qcde
	YxF5vUWgMGPUAc+rcWJnMGPBSDRc87jAwhy+Rz5oL0I3fVXSWHwaqY19nTy5ogkU
	RksgKmgVTQCf7sDLJtQXNsY17+8PBbnnSOVPRok/CX0YveI5Uxmc129V2W7zfxAQ
	0hy1O0E/L5jLqA4VNiZ+ra6wPVgcluSQ18cTrgxK9n9snIq/lZWm7qM5PETHg/4i
	dSuoKAcyxVUi9Rd6f9YkJwwdIT3so05HktHbLE1V9IWq2w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47e3xgh13f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 15:16:22 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso2828786a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 08:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750605381; x=1751210181;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w44qBsK+6lDTVdeGCkoj9uoc0+WdT0uN8/42Vd0SJ0c=;
        b=vE29rHBY6MCaHsvu7autps0drR5vthfFkKUaqAkCpz5p4xnatNi0knMRQu9TiTqwSo
         6HKGWPWQNp03mnzZaI6N2U2acF3iL35XlhfNSx0MyYh5ZLNaCRV0KM/cQGqS7PhEdrq6
         4PhJ9TRCv9cK6+ISYa5Jf/mDLkF/zrNCrdUCM/z5WrwqGi9Qj/mXDDg6DslLBIheyaEI
         7mZpMsHQxW4pqypk8pchLLEFJfm4xNvkxBSziBwjIaR/rs77Bew9MNc5S71xvLNv8uFX
         ByhonE5eMiD1K/eLsoPNmo6gOfmfEzHR7ky4zv/cjAmel80PfDaZESg63oXmLmaLb1Rg
         TKmA==
X-Forwarded-Encrypted: i=1; AJvYcCVfPbNVP+hIm9upSlrzOdLIH3AACo9YKxcrC+NIiGDDHAVQff+VnkROcJSY5XPkDKASyprKYdJ5jD3P@vger.kernel.org
X-Gm-Message-State: AOJu0YxFWO4fNK7cGEtXM9gI/doWZuZtOOseYnaeswyOqlK2dtfORUuu
	P9l8QHAQPBv+CNSwC+8Wc4rJRWyTiTv1zsEvZRUFd812cY8eXIKrW5Nw4ex40lCZxEkicvnbY/m
	naPlEBwBcpoa7nVM3+i3RxlsZVnIXzGWdcOVm51tpsyphPivBD2MYx6ayiZW3B99Iz5XyZviecx
	0mBesnihUWD7yXAyaahBKRnhRco30xxs7Lo9eRbDc=
X-Gm-Gg: ASbGncvmBgmEvhg0MpIG0E4wCcKCrQ0eS4eeT8dM5UltXGLn+bKv/+SjokpDSTa/e25
	rcHCW2PXrcLULwz43UW7u/uBW2cPIYYxzeZedLJr0nb0pRqVUtmDUhr2gOfxPD6VzjvZ1hbAAIc
	KTJg==
X-Received: by 2002:a17:90b:538d:b0:312:39c1:c9cf with SMTP id 98e67ed59e1d1-3159d62b22cmr15786181a91.7.1750605380959;
        Sun, 22 Jun 2025 08:16:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiwVZwDGbFUpSLYFGCsHNtl3tE4hRSKWPLVVMlFvnXrZYfO89S0fwQKG1OCoJMnXdixhjlo6XBKZbBKl9aewg=
X-Received: by 2002:a17:90b:538d:b0:312:39c1:c9cf with SMTP id
 98e67ed59e1d1-3159d62b22cmr15786133a91.7.1750605380412; Sun, 22 Jun 2025
 08:16:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250622104531.19567-1-quic_nitirawa@quicinc.com>
In-Reply-To: <20250622104531.19567-1-quic_nitirawa@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Date: Sun, 22 Jun 2025 18:16:09 +0300
X-Gm-Features: Ac12FXwyH-cIk5yRdWwy9i0E5tkcXIM9jcGCRkf5RmrHI1lbknvM47tnpdZ-3sM
Message-ID: <CAO9ioeXtLk5k3c-jg1CTt4SKYu6QKjqTM_WOEx3BM3Uwpe+7EQ@mail.gmail.com>
Subject: Re: [PATCH V1] scsi: ufs: qcom : Fix NULL pointer dereference in ufs_qcom_setup_clocks
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: mani@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, bvanassche@acm.org, andersson@kernel.org,
        neil.armstrong@linaro.org, konrad.dybcio@oss.qualcomm.com,
        quic_cang@quicinc.com, vkoul@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Aishwarya <aishwarya.tcv@arm.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIyMDA5NiBTYWx0ZWRfX+DLuBjSpB/iS
 ZPgZ4Z+ChYaAgfpxz5MWSJc32FLXVCHiKD1mMYO3pqC+lHvsE6RzNK3KMUJD9Y9Mu1nu4KQgOgY
 tLm2r8G6Is5p5ISalbqPYQ+yxo24in9GHR4Ze0c91TwpIAcQo3pGCXviXGSyz0hnM2s3DxI+sKu
 /L02DfPaqFeLzVygmkszrX9QsKO2yB0KU6zf5vs4fdpOyLIy+7sQUtHvKHgWD8mE9OBo9N7253P
 07Je0eeo7v+SqzKv5NGkJ8hTrec7T9+p4HrkjFfmFKUjdVjlNOsrPsUnPlBhn6wgrzFHMFl5iTR
 MrBthQEZsRkmmSe1hqIUlN21qvPf/Qw8rWVFt2jP6qNikePx/cLCPizRQwsOkGScex+QyFQxZDy
 LVTtQhdu6hc8eeyyF+jkXHT2DrDM88D2PRrKOzJqpcHkRYsyP1J/ffbMd+Jn0wvqNg42BmbX
X-Authority-Analysis: v=2.4 cv=e8UGSbp/ c=1 sm=1 tr=0 ts=68581e46 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=pGLkceISAAAA:8 a=COk6AnOGAAAA:8
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=BtV6YcfmfsbFzQIroTEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=TjNXssC_j7lpFel5tvFf:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: Mee5xCsWmROUCrDaVjXj3q-wOCjJ8UzF
X-Proofpoint-GUID: Mee5xCsWmROUCrDaVjXj3q-wOCjJ8UzF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-22_05,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0
 mlxlogscore=934 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506220096

On Sun, 22 Jun 2025 at 13:45, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>
> Fix a NULL pointer dereference in ufs_qcom_setup_clocks due to an
> uninitialized 'host' variable. The variable 'phy' is now assigned
> after confirming 'host' is not NULL.
>
> Call Stack:
>
> [    6.448070] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000000
> [    6.448449] ufs_qcom_setup_clocks+0x28/0x148 ufs_qcom (P)
> [    6.448466] ufshcd_setup_clocks (drivers/ufs/core/ufshcd-priv.h:142)
> [    6.448477] ufshcd_init (drivers/ufs/core/ufshcd.c:9468)
> [    6.448485] ufshcd_pltfrm_init (drivers/ufs/host/ufshcd-pltfrm.c:504)
> [    6.448495] ufs_qcom_probe+0x28/0x68 ufs_qcom
> [    6.448508] platform_probe (drivers/base/platform.c:1404)
> [    6.448519] really_probe (drivers/base/dd.c:579 drivers/base/dd.c:657)
> [    6.448526] __driver_probe_device (drivers/base/dd.c:799)
> [    6.448532] driver_probe_device (drivers/base/dd.c:829)
> [    6.448539] __driver_attach (drivers/base/dd.c:1216)
> [    6.448545] bus_for_each_dev (drivers/base/bus.c:370)
> [    6.448556] driver_attach (drivers/base/dd.c:1234)
> [    6.448567] bus_add_driver (drivers/base/bus.c:678)
> [    6.448577] driver_register (drivers/base/driver.c:249)
> [    6.448584] __platform_driver_register (drivers/base/platform.c:868)
> [    6.448592] ufs_qcom_pltform_init+0x28/0xff8 ufs_qcom
> [    6.448605] do_one_initcall (init/main.c:1274)
> [    6.448615] do_init_module (kernel/module/main.c:3041)
> [    6.448626] load_module (kernel/module/main.c:3511)
> [    6.448635] init_module_from_file (kernel/module/main.c:3704)
> [    6.448644] __arm64_sys_finit_module (kernel/module/main.c:3715.
>
> Fixes: 77d2fa54a945 ("scsi: ufs: qcom : Refactor phy_power_on/off calls")
>
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

No empty lines between tags, please.

> Reported-by: Aishwarya <aishwarya.tcv@arm.com>
> Closes: https://lore.kernel.org/lkml/20250620214408.11028-1-aishwarya.tcv@arm.com/
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Closes: https://lore.kernel.org/linux-scsi/CA+G9fYuFQ2dBvYm1iB6rbwT=4b1c8e4NJ3yxqFPGZGUKH3GmMA@mail.gmail.com/T/#t
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Tested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com> # sc8180x-primus

-- 
With best wishes
Dmitry
