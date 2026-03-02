Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B71A3542E1
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 05:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772430375; cv=none; b=oNi61YppTtYQ5lzFidTCAQ3r0baiHbp+FXmTGt+yDKNk0QRMK3UajocVOhyqZ7rCInOxy5BieHBeNXTo8m+NSawNZJECjjUtXrYZ5gBklAz6QyTfvUr+uuV+Vj08F7PlOHzlh6bjnhHhyUyqy+eGy0aj/wu/9CEMq0NUXcvNsUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772430375; c=relaxed/simple;
	bh=KaqISgrwu2MKxADy/Rr0sxdzUpKhO4Cq7F7VZa4FLr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xf61jM8+UaPtwQ3rvmwEnJH7eoTL5awJAarBWV5YqkCaNoXWjPf6Eo1mutV1MznbkLL8V46GAZFOnqC+y0qp40kqaOdq417zMmtT7KO8C0dmlZGZhok5NBheMbaI7xVEDoWE/G22wHZ3HrXxa8PPy3jxW9/VHMMAVdRz5ZjdBC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z+hZzoN8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a4T8Cma4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z+hZzoN8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a4T8Cma4"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621MFxLa3623399
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 05:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DusOGrOv7n6Wk8Fc5KUX/o+ALeHBDXbnbHPx/a24gZc=; b=Z+hZzoN89/5xp1ql
	8ypwSqhqyYP6H+stuk7GIjJPskaUWff9t+TYIhhLVMAK8SceYvz7tulQZW9XdeOC
	jUR0sKHUa/94DeToMxIFLKBC6RYARmpqS/lYB7ipG5m8DCzDEY8rv1PEjYGWECdX
	C8S3CAPOD1GGAh2Xb5XUMOWbmIzgFq57gZGCbRgf7zJbBsoJ3GZtBfurLms30BB/
	1FcAHzJRAlaLXMTIpmXRms6r/xzerRHSJGElg4vP558uCvqdusKlf+zoftpSUB6n
	16eQmkBQuA1Z8WhVW/ZNPbARZO9iKJzELCyJjuFtZrA1cxHOeFqqmqSW6PBQX01x
	/icWFg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ckshcm6xe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 05:46:11 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b6097ca315bso21195544a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 21:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772430371; x=1773035171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DusOGrOv7n6Wk8Fc5KUX/o+ALeHBDXbnbHPx/a24gZc=;
        b=a4T8Cma498P5e5K8lTGQb5shvkYUU05WwlNKKFiTqJWAVFZagDQpTHXlfwNCfb7oC2
         BGZSc9n/9RdGKnGbzTBRVe2drNYs0Z+WLbYx7a9TmwOz+/XUmqU2VolyXWvn+y3DYZY1
         x0AVGARGLSCfwVCAl7WgkBs9BwoLCXOEslCUWKX7eMpny4BgOkkpCi2hQtyznWblqaKd
         2kGJ+lbTwl6eTu4t45O5C2f5n/i2hYNMGBJtPlrEnmDzj33Z23e7n24cPj083RD2TPWQ
         RRrt7II66mcEV8Ks6j2yel+fPg5MXupQqJeexhKrItVN1kCVtq7bz7bPdodoTp9Og/xf
         me0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772430371; x=1773035171;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DusOGrOv7n6Wk8Fc5KUX/o+ALeHBDXbnbHPx/a24gZc=;
        b=MlyE73atLo8FrWWGgWTVyLuw+lnc2+078+zL709fraLryWaYZp/aT0o4n4mjOZylBs
         bUGvD59NRepnthf8IAcgBZHVgZNrwSTEARb4kL21Md7z9grbDIIX2SKZqaXv+0gaI83K
         xGvVN0p4h/u69Fin5iA0t9LQ2N0Xfu3JHRPWKegQQglNb3rPXBXkKie+GkNCME78QOuw
         yU46dnSw+9iomlige2GyTEps2Jm7ygRZG9/j3dDLRkNYVuT68ykCQjbdTr0MJDw8wq4j
         saOcNdOlnCEsXMkP6G5c90iZ0XQFp68NYp9rquGHj57Vx3JGDH5mw+FS8R26vX0tybnR
         aXMw==
X-Gm-Message-State: AOJu0Ywfndwcxrpyc8pPXPcvv0l531lj6xExDOj0wo0fhG+8yxX7YTWJ
	4hWyx+TjLQE0rMjokFL/lmOtYV2uBwZlsxPIXKPpWztQsng4WKKRYiJcr+qYrxN69U7Bq56War4
	5PfWVpELTim+RRrocqE4ls0dtpEvWC1v5kOa7Xna9UxmlZh0LZGaZbWYNDcVU8OSLAG3VJ3Vj
X-Gm-Gg: ATEYQzyqjHv3vMbKrJY/4HRbxD8EHFAYN8LhHT5G7DiIaei0PUK5BnJ6CxygNGzpBpD
	GQ9D9tPksv61LKv4MNBVgjdGlx53LicRtUiFtTrmqWt9NZq8C/eP1OHZPlVDhQH6kwlCjgN3vcb
	BfhyZcliZWqtdB9nQJmSOQqds3c5ya4zD8wAzUeWUIVym3IhAudoVKqSdsy8ymAMlBMnJ+DV31w
	42Nj5SvtycBmWJZ+Ytmes4toZ/CLK6a+LQ/1iX1PG2SzRktPZfdTLDHu2nGGIhXiWmWs17CY2Oa
	WqcJMbK0SHYTzFTILSl6vUvzRkY2MiN5zqnQPfqdyfISL0EWJSUjpZMBRXxrHDcJnCChAyuZwr2
	txGNLNlAxx8Mr2bga37a8czLps9jBzT+SHHIMQsHNrTVy/hQ=
X-Received: by 2002:a05:6a00:17a5:b0:7e8:4433:8fb9 with SMTP id d2e1a72fcca58-8274da7a6c0mr8934779b3a.65.1772430370679;
        Sun, 01 Mar 2026 21:46:10 -0800 (PST)
X-Received: by 2002:a05:6a00:17a5:b0:7e8:4433:8fb9 with SMTP id d2e1a72fcca58-8274da7a6c0mr8934760b3a.65.1772430370176;
        Sun, 01 Mar 2026 21:46:10 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739db4955sm12361703b3a.29.2026.03.01.21.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 21:46:09 -0800 (PST)
Message-ID: <b6bfc38f-4698-48b2-83db-c88f30c04339@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 13:46:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] scsi: ufs: core: Add debugfs entries for TX
 Equalization params
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-6-can.guo@oss.qualcomm.com>
 <3d5a65c9-c5ae-4547-a55c-f7554df62553@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <3d5a65c9-c5ae-4547-a55c-f7554df62553@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FgsCvAJnP0jLblWQF841gCxNb6Imaabe
X-Proofpoint-GUID: FgsCvAJnP0jLblWQF841gCxNb6Imaabe
X-Authority-Analysis: v=2.4 cv=SO9PlevH c=1 sm=1 tr=0 ts=69a52423 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=nnAcbMzM97FTqBoIYUsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA0OCBTYWx0ZWRfX0OPt38S1Dh6e
 XaSX+6GXDGDFtiaFY7ZeUBg6qSvZWuAppDyDD3NgwZ8CpWQ5vIhHwgSyDNhqm75WJi5gJch4uhi
 vdFA2CPLEASZeHdWXsAhK+GOaGmLYDnPEDlNohIGr/lMWLdRIcY4iqcTWl0Rd2W0GXm7MFjZPlh
 taAnJ268QWOYHlUES/lTQsbnN5myJEMnCrRowUjUrjJ0lk4WR9qGTYZCJ6BiFN39wLCkv1H8+15
 PtYLlG6niHXTHwPkSN9xXO5zUSZCsBzYgCSoBk5p9XaTAadQupTFb5nepyGgp57NnlifLSlXZ7c
 TEesV+PEooBLYQ8hebBAsQg6K2DTR7rdjy6x8QMRpwWOcy3YKYdxeqQfdXtq98h7oBS1j5fPWm9
 2gw+9hBeFRpYzH8F09F71FeTa+Fhh2KEAaR7Y10p9ZCiVeQRA+LHaMdhLKlDP65N9BzYB2Nx3ew
 tjLBU0iY7TKVX5xJ5kg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020048

Hi Bart,

On 2/28/2026 5:49 AM, Bart Van Assche wrote:
> On 2/27/26 8:08 AM, Can Guo wrote:
>> @@ -230,6 +427,15 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
>>                   hba, &ee_usr_mask_fops);
>>       debugfs_create_u32("exception_event_rate_limit_ms", 0600, 
>> hba->debugfs_root,
>>                  &hba->debugfs_ee_rate_limit_ms);
>> +
>> +    if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
>> +        return;
>> +    hba->debugfs_tx_eq_gear = UFS_HS_GEAR_MAX - 1;
>> +    debugfs_create_file("tx_eq_gear_sel", 0600, hba->debugfs_root, hba,
>> +                &tx_eq_gear_fops);
>> +    for (attr = ufs_tx_eq_attrs; attr->name; attr++)
>> +        debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
>> +                    attr->fops);
>>   }
>
> So the 'tx_eq_gear_sel` is an attribute that controls what output is 
> shown in the other debugfs attributes? I don't think that is acceptable.
> Please make sure that there is one set of debugfs attributes for every
> valid 'gear' value, e.g. by creating one directory per gear.
Will create the debugfs entries on a per-gear basis in next version.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

