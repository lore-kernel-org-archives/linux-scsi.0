Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214293446C2
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858993; cv=none; b=hDme9bxpEtu5t7Ux8GGGXxF0/8FBkJu71eZ0J0GLZMdRGOufxbCl+b279RaEw1jNuaCiKXNjoWZoQQutyNUwoA6WSJ7L9KRi3QFOVU3iwBoPZO+cxP4HtlFgdEm7e4rR7WI07FaX1dxu5D1bKVp7o0N7FRyjLLBlrR0CNk7k3Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858993; c=relaxed/simple;
	bh=/3TPMkNrCAsb2NNL0PdjKWgoA+/f4Rg34WUMaRd59U0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ff0VHB2bohVJySzxzXiW+2KlAE+tEz+cIr+Kg3Xh8NErXEIX9CmSf+c1od7nM3BA05imFAll96DVZsOe/Ckom122XDqYdHZ8A5emscTENSSSj+b9eOG8vdVHHJq/JOkcv9DYJ5aZfLXR6PIkhxudPwvAQXIka6ZCmtzppNaf12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y/77wAya; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PlKlVuvM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y/77wAya";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PlKlVuvM"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B4C9j7Y909333
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2025 14:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	08v/PQiGVWiSFAxh3iH9qlHFYjuyXmd8DsmOXzb/8r0=; b=Y/77wAyath1EAxZA
	gOLCzMpdEu1KNB8sQyB6CAc/EAdPtoKXdeneLTGbTl7c1aK6YI1OYVUtlkKkRCqT
	QEXjCBzEwpbvCbVciWC6HrsAkvfaNn0/cUk6QfwZIAAZcLH3z+r9HD0p7Tl9zR5q
	xZG8Dc2iZfJitkVwTDOWn8OrFMp8NjC/i4cu4hwvVrPNu8373KWjs9svq48U9on9
	dqR1RgAC0GlgBMiee8SJrsRiOpYOdKbElmHgabzPkiOS1xsDd21YrxpuVKghkVxp
	DrRzOEawjNctQWKb/SoNOvHnyT0uf8Pj+STDhRcEqS48KQv47lrYcG5VDntYreYd
	u9uxkw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aua2erbxv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2025 14:36:26 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7ae3e3e0d06so919362b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2025 06:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764858986; x=1765463786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=08v/PQiGVWiSFAxh3iH9qlHFYjuyXmd8DsmOXzb/8r0=;
        b=PlKlVuvMvC4EALZ+B6ly3lrFjZ6hU4z3dPAiByplR4YQI6lM2JuXx5clOWeo+iXG8E
         UQ1STTe+gC56OgdMV5v2dQ3E+g+wd+rb3m6U/p5Jck0kkb4fwx7F5mbNR9WWQPsaznKQ
         aaQoq5ic7s0dEs5AUSNsZZLxGKCdLq2Yaz2Xr20DEb3dFAgjO/5gBqaJV7eEV1OFrliZ
         sbViJmY5Kw5FeuI5ZZ+KexPHiQm7ceNmSSggj1qsGQxlvRreWbhaiz3PBjeiHAXRXVp6
         NJeRvNk0EE/g+YCHeWqfW62ts0rP193lrDYly/8OZuj3i1MwmleglL+oss8sCztahgSC
         gtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764858986; x=1765463786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=08v/PQiGVWiSFAxh3iH9qlHFYjuyXmd8DsmOXzb/8r0=;
        b=ryRPvJm1ND5HFfxVmHs3qFBKULihxdnORJJV+uuQHeWWGQ+HGzsWRbZ0QxxlohJAGm
         /jlGaS9nooY4Lt6Pzntor5DqgBqej7weIykqlcZM6qEdzHD1vqlEOx6tv2LvlCT0NnZt
         VKIRaiv7HL+hG0dwKHdIXpVMnVsOd5TPgUpId/tYuzCV1WWrT7EXiG80Rrcalclqoqtr
         U/QM/r4hLYsEsCgh7F5B9BFcEirDHwiafST9333aslxsITs4Jc6K7KiVFgwMaEykvOuY
         TD3PHYYdM0/rjt3qRMlesxfmMWRgg48giJBtkKMLrj7UcBkXyNB76FdZb3Uidd0GYGO1
         mYKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJZPmJoBw/RrVtgMOVR/z3B1eLQk1TvtVXhMOAit/cUAwhsEHQ/lg8ujJpqtKWtKA+7echtIriZGO1@vger.kernel.org
X-Gm-Message-State: AOJu0YxzoSNNAv0SCCxg9jY/gEpj/wuI/R3nIXS4FuMqnobz5ep3NipR
	t9kiQVJpjVhB6uNVQFl0AGAIVq4PyKn5yIwwgbcXUNacamCgO35Zx/cTM8EUaMD5n4JSUq0TS5i
	lPHZri4+OMLTmjSiz6yE8ZuJEZFx/R1RgJPN5avh1UPrNz8Eno+/AXPC0uKOiN9gU
X-Gm-Gg: ASbGncviMCr7+bhKc+ZeHe16o7rbGUDawlV940puVgBkvJoFQOKTXJIzqNznSDD72cr
	Kkhtg1tnVdn2hIe2UowwLUZIozQXGdWf3Haazonfc3ALsgCdoRPlfr1V5ibPRTxxvQkDuot47X7
	qEpzUz/Dqcayrx2VhwmH1GzKzw9R1styT7o8+wh5R9N0lpPoo6e/ZEt3l1HlZJT0zCtWX9pDqGv
	fNs+4M7IHkXRCVzGDGbGEGvH5cLfmgLbBC4DcbEWC0gbbTSMFF4WJEy+dBMRt+Mu2/n5fLacYBr
	jrHbccDjMWVkBYoK3YZzvc8Pcx94nYZ0YUaas/ewx08wsZ7M46pCWWHaXeM87sNEbQGU7uRzurl
	MorEzk57Z3lC0o4aLu+Nm8Zkg+MQb0Y+uFfdT
X-Received: by 2002:a05:6a00:140e:b0:7aa:64a5:3821 with SMTP id d2e1a72fcca58-7e00ad73c07mr6897617b3a.9.1764858985814;
        Thu, 04 Dec 2025 06:36:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7NZbkweap1b11ixDmKeOyCfyL/YK0FXljodiyFFvqs3ZoVz5HURx+kUNQFyjP7TL9l1tU/A==
X-Received: by 2002:a05:6a00:140e:b0:7aa:64a5:3821 with SMTP id d2e1a72fcca58-7e00ad73c07mr6897589b3a.9.1764858985332;
        Thu, 04 Dec 2025 06:36:25 -0800 (PST)
Received: from [10.218.7.247] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e29f2ecf6fsm2434669b3a.11.2025.12.04.06.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 06:36:24 -0800 (PST)
Message-ID: <aa40a658-f036-45ad-8d7c-e133b3003748@oss.qualcomm.com>
Date: Thu, 4 Dec 2025 20:06:20 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Bart Van Assche <bvanassche@acm.org>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
 <3bcc40b9-5085-471b-85a9-259ec25c5c0b@acm.org>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <3bcc40b9-5085-471b-85a9-259ec25c5c0b@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hLH7IrBBDeymRGcEz2lzu2rNtr9nYU-e
X-Authority-Analysis: v=2.4 cv=Rv/I7SmK c=1 sm=1 tr=0 ts=69319c6a cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=yNKNLwmGnS4NaX8w8x0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: hLH7IrBBDeymRGcEz2lzu2rNtr9nYU-e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDExOSBTYWx0ZWRfX5GKeybQ6nMz6
 /W2l5LnccJbrVE8dnthN4mt+NqH0eg0daTc9c7mDUy2D2xRctfVbPT+Nh9aWmzoEEUoiK0z2RW3
 qI8pHqPoBd70r1PjgMeYMYGu7vKj5vpsXb7L1/n1GNlwyL1A8EBi9sba/TeglJSVvMRV5zmsYUP
 luHOuUVxQz6qCO5Kj10E4cTiVSmfFX4weizYsBD8jgA9/aVvKqNgs102kxZSvnO5ZA9CWMOJPWU
 oqztFsHudUz1Et0fY91vVbfKoloRYoaUx/TVYw1gYz0tKBX/8WaUw6ePJsNxVwwWwJ7UeOzarBz
 gk9GMkWKzSYkJFiN5yr/0xNwZjfK/UwAT8Q8s4LCWDS914SeHG0VisSMrsUuyk9BHdvN8QCiuhL
 KrJ01vptJvl6ltoBlORmpf9h5XwRVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512040119



On 12/4/2025 4:56 AM, Bart Van Assche wrote:
> On 12/3/25 12:40 PM, Nitin Rawat wrote:
>> With the fix shared by you , SDB mode on SM8750 works fine now but MCQ 
>> mode still have below error.
>>
>>
>> [    3.720396] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; 
>> HBA state eh_non_fatal; powered 1; shutting down 0; saved_err = 0x4; 
>> saved_uic_err = 0x40; force_reset = 0
>> [    3.740078] Unable to handle kernel NULL pointer dereference at 
>> virtual address 0000000000000378
>> [    3.740084] Mem abort info:
>> [    3.740086]   ESR = 0x0000000096000006
>> [    3.740089]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [    3.740092]   SET = 0, FnV = 0
>> [    3.740094]   EA = 0, S1PTW = 0
>> [    3.740096]   FSC = 0x06: level 2 translation fault
>> [    3.740099] Data abort info:
>> [    3.740100]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
>> [    3.740103]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>> [    3.740105]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>> [    3.740108] user pgtable: 4k pages, 48-bit VAs, pgdp=000000088f66d000
>> [    3.740111] [0000000000000378] pgd=080000088f66c403, 
>> p4d=080000088f66c403, pud=080000088f66b403, pmd=0000000000000000
>> [    3.740123] Internal error: Oops: 0000000096000006 [#1]  SMP
>>
>> [    3.815406] CPU: 7 UID: 0 PID: 213 Comm: kworker/u32:2 Not tainted 
>> 6.18.0-next-20251203-00001-gc131083d7359 #27 PREEMPT
>> [    3.918160] Hardware name: Qualcomm Technologies, Inc. SM8750 MTP (DT)
>> [    3.918163] Workqueue: ufs_eh_wq_0 ufshcd_err_handler
>> [    3.918171] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS 
>> BTYPE=--)
>> [    3.918176] pc : ufshcd_err_handler+0xac/0x9ec
>> [    3.918181] lr : ufshcd_err_handler+0x9c/0x9ec
>> [    4.023106] Call trace:
>> [    4.025629]  ufshcd_err_handler+0xac/0x9ec (P)
>> [    4.030207]  process_one_work+0x148/0x290
>> [    4.034336]  worker_thread+0x2c8/0x3e4
>> [    4.038192]  kthread+0x12c/0x204
>> [    4.041527]  ret_from_fork+0x10/0x20
>> [    4.045210] Code: f9402760 d503201f 910de000 52800021 (b821001f)
>> [    4.051474] ---[ end trace 0000000000000000 ]---
>> [    4.056981] scsi 0:0:0:49488: Well-known LUN    MICRON 
>> MT512GAYAX4U40   0100 PQ: 0 ANSI: 6
>>
>>
>> [    4.281093] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    4.360921] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    4.746782] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    4.817093] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    4.893131] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    5.013146] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    7.249155] devfreq 1d84000.ufs: dvfs failed with (-16) error
>> [    7.341071] devfreq 1d84000.ufs: dvfs failed with (-16) error
>>
>>
>> However, after switching to previous tag next-20251110 of linux-next, 
>> where this series of changes is not present, the issues is not seen.
> 
> Hi Nitin,
> 
> Does the patch below help? If not, can you please help with translating
> the crash address into a source code line number? Please note that the
> patch below is unrelated to any of my recent UFS driver kernel patches.
> 
> Thanks,
> 
> Bart.

Thanks Bart.

I also applied a similar change as yours, and the NULL pointer 
dereference issue is resolved. The clock scaling error (dvfs failed with 
(-16) error) also no longer appears.

It seems the NULL pointer dereference occurred because the UFS error 
handler (ufshcd_err_handler) was scheduled and executed before the UFS 
device WLUNs (Well-Known Logical Units) were initialized during boot. 
These WLUNs were being accessed in ufshcd_rpm_get_noresume() before 
ufshcd_err_handling_should_stop performed the NULL check.


However, the UIC error persists, causing the error handler to run on 
every boot. The behaviour is same on both SM8650 and SM8750.


[    0.639606] /soc@0/phy@1d80000: Fixed dependency cycle(s) with 
/soc@0/ufs@1d84000
[    0.647298] /soc@0/ufs@1d84000: Fixed dependency cycle(s) with 
/soc@0/phy@1d80000
[    0.681909] /soc@0/phy@1d80000: Fixed dependency cycle(s) with 
/soc@0/ufs@1d84000
[    0.689688] /soc@0/phy@1d80000: Fixed dependency cycle(s) with 
/soc@0/ufs@1d84000
[    0.697392] /soc@0/ufs@1d84000: Fixed dependency cycle(s) with 
/soc@0/phy@1d80000
[    1.228095] platform 1d84000.ufs: Adding to iommu group 4
[    3.440633] ufshcd-qcom 1d84000.ufs: freq-table-hz property not specified
[    3.447622] ufshcd-qcom 1d84000.ufs: ufshcd_populate_vreg: Unable to 
find vdd-hba-supply regulator, assuming enabled
[    3.470491] ufshcd-qcom 1d84000.ufs: ufshcd_populate_vreg: Unable to 
find vccq2-supply regulator, assuming enabled
[    3.516236] ufshcd-qcom 1d84000.ufs: ESI configured
[    3.516272] ufshcd-qcom 1d84000.ufs: MCQ configured, nr_queues=9, 
io_queues=8, read_queue=0, poll_queues=1, queue_depth=64
[    3.516275] scsi host0: ufshcd
[    3.584233] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; HBA 
state eh_non_fatal; powered 1; shutting down 0; saved_err = 0x4; 
saved_uic_err = 0x40; force_reset = 0
[    3.607898] ufshcd-qcom 1d84000.ufs: ufshcd_err_handler started; HBA 
state operational; powered 1; shutting down 0; saved_err = 0x4; 
saved_uic_err = 0x40; force_reset = 0


Regards,
Nitin

> 
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b834b9635062..0f0944ea8b46 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6698,6 +6698,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>            hba->saved_uic_err, hba->force_reset,
>            ufshcd_is_link_broken(hba) ? "; link is broken" : "");
> 
> +    if (hba->ufs_device_wlun) {
>       /*
>        * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
>        * even if an error occurs during runtime suspend or runtime resume.
> @@ -6711,6 +6712,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>           return;
>       }
>       ufshcd_rpm_put(hba);
> +    }
> 
>       down(&hba->host_sem);
>       spin_lock_irqsave(hba->host->host_lock, flags);
> 

