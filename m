Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A35A2BD00C
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774246433; cv=none; b=fd7cRl5qPCofQbKs6Qev5hUgOf5TayVAWxb0SqKZ4w01gCE8cZvf+GgNVZRgaaoB8LaXSOPpzkDpVf7n0ogswwdCBMCW2ioWuwKvX29Aa9oj7e9m7nyTnpc78vDhBj/NsNwlAyeSBfPe/hI8E8EQDaVka3/91InVDCDcC+7BBGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774246433; c=relaxed/simple;
	bh=fcoJx4vVdw857WCdwdOq/szh40achlBjNxB2KhevHoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYeGKr2ryLcrYJu0RxzRa6/7nsqNt8HSxrlu0CEV/n0/D4K6YqjmG6WrHjQTQ4v3JfC8NBsqF8t3V5lhtp77fpeJWjKmdUzNU3NVK4aKY+YlSQzPDkO88Ldb2Ryve98eyOJGZzjFwFQJgUd4s0t8zu+13SeJ+a/9+vtJuIJVFFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kPSNwg49; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dm0ummYU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kPSNwg49";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dm0ummYU"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N5m3Yw358710
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fcoJx4vVdw857WCdwdOq/szh40achlBjNxB2KhevHoI=; b=kPSNwg49EI8dW372
	reLiD0xqOxyJjMR0+/8P3iB+nPCULK7wf1mUsXG1U1eFIpXtYi9XVixI4wj+08xH
	V53XK7t6B/oFcH+C3P5DH1CGewmnlFBXB5tTnsYlLyE8CEoOb+m/0+Ms0DP2Ce5b
	zZPZJ3A+RbRrQDPpEU5rGkRkNzhReGyt6G2Dlap/c/ISY67Pdzv3r7j4MYpvZMgt
	YeTVrtNG7MHF4+noLoFdZKCtRU8FiiCe6AKwJ4UV5XTgv1m0SNCryfxEsyj3mNWJ
	UyFEzjIeiqtrMyqcGJ56yTJGZ41dqgSehw1IlqoORcjikV1fHszxQ1FDtZtbkuAS
	fSSZzg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1mghbu6q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 06:13:51 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b059511554so50657035ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2026 23:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774246431; x=1774851231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fcoJx4vVdw857WCdwdOq/szh40achlBjNxB2KhevHoI=;
        b=dm0ummYUwUhZ6bMDt7YyyfYeB+A1jgUSmj+hUbhWCQ2K9X2P6QVtdDka7i737EhakN
         HRXUQ8JbVYekTcjG6VxvA6VsBioySuwAqGMbEhTG/bSJQJvoTtPG7slf+MT+vSXg1WXQ
         bBxUNHNUu+afo7xD9c52iLR668iNBAb2w2HYzk8mZgLwtJo++kTnD0bEvhJgikrn1cBh
         KjVMdwzeI2Bb029XEV9vsfa7Z7SVdU4SUFwKrHUqgZMK20ZYIpJSL+/L+RNMA3bh9fME
         /Sv1uRPXvOSe+VZqOcdkvoZcwWOklu31i06jtZxLkQt2enaDF9aF4enYOJv0aDvnjjoC
         oNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774246431; x=1774851231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcoJx4vVdw857WCdwdOq/szh40achlBjNxB2KhevHoI=;
        b=N01HeIGEz9D/wEsTCs56VZ1c6OeLQQEbqUUqC7sZJqg0DQeM1cEzp/j641DWrvbMaC
         bUEL04qn87PiOS8SNZJ0tpqbj3xGdn/QduDYnoH0ZmLsFPxV1Vs9Y74BkxgTjyCP6zd1
         nyt+8gdhjo/tlEg26c7aERdfYJgiKgumjkP8K59HNDUj7QAKrTirvSL7JkyRV2nva5B9
         skNpxc4t2ZxS7FcvUhBRVMArCiVP/UUUVTRlAVg36TdtPN2Uny0SGrbkSXJ0dTll6aU4
         DGpvCOIpBGG0Zlj+NGPRxSa304ovVfU+QoKX3JSHFnAf/U4Z3R3dIMtp0++JmgqGz4ru
         aIwQ==
X-Gm-Message-State: AOJu0YyCYBzXnIkqT3r1TusoZS0ZPQurJQjUhBMZtYJPu9bnfHHZSiYU
	vLIFfsd08pgJmaiGzJ0+sjFH0m8ttyIXBTtASl7V/XAz8f/IsYSK5hVXaYSkRQ+G987i08Si0qM
	8Dyoy0cuHHRwgKNM47mnicAJRY2/ZcF2prd0PcMJQRz6+gFJ4Udqxs08PRpsCCVDm
X-Gm-Gg: ATEYQzzw/jJ5AppTuzpeMiiojwAUwAJlN16/NhKNjN5B9xw8OCAyDYstIiGgJufFZma
	ZfRLk4tyzdg7M9pwpXlr2qrTNLPtWgAtLYN9ulD6XunhgLYz+JatrrzfAX/Ng8y8+HQYTbfhf+z
	71yMyKWjN0njtgpOEusC8RTE3G/C1cERRbIBeqEdGusNwVSkH4+GOZohdeETCwbbEECFrSgV4rf
	efgewy4SxX84+/i42AZSQh1m2Dmu/arKLWbV+zd3+UoypJYoCSWDlk1kRjOrrOEWo67z5K/SKD6
	xCNp5mlB/UfRWHQDB8UBzQJOf0zTyLHG8ztnZ25ec+svltYWwfbjjy4R7RNOZkIERTb7LD/bx0N
	YRDgukHuBxI+vcpV2Xr92EnsHqtAtpc7AWpMjaqhQ74AmodROzi5P85jpUuCa6DJy5LlKA3NfNh
	KrsK3WnHzqVSY=
X-Received: by 2002:a17:903:41cf:b0:2b0:5cee:c405 with SMTP id d9443c01a7336-2b0827ffd1cmr106310835ad.52.1774246430749;
        Sun, 22 Mar 2026 23:13:50 -0700 (PDT)
X-Received: by 2002:a17:903:41cf:b0:2b0:5cee:c405 with SMTP id d9443c01a7336-2b0827ffd1cmr106310685ad.52.1774246430218;
        Sun, 22 Mar 2026 23:13:50 -0700 (PDT)
Received: from [10.133.33.145] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0835551c3sm94475405ad.35.2026.03.22.23.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:13:49 -0700 (PDT)
Message-ID: <7747227e-0667-445c-a2e9-c92b273ea8de@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:13:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
 <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
 <7ef32c7c4f9c2220b04e9d0ce55d45a7e3373da8.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <7ef32c7c4f9c2220b04e9d0ce55d45a7e3373da8.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=HI7O14tv c=1 sm=1 tr=0 ts=69c0da1f cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=bKwXrFjDkgFuHGtu7sEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: vLS7mZKFb45j-tgslmufgJgVLfkb8vA9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA0NSBTYWx0ZWRfX6pytKF5MzFDW
 bomrBklgkvhSyoxprI/sL8+mj82901VXO5QMwiBiBwQHKhoy0ymgjC/2Ei1fq8bJFz0HC9m6aZ9
 Jv/o2S3HRMZa6RjNi4QfG5kUHwnPEaHrH6BJ9GqeQwa+RdQ2HEbji6fKAqExKZRjcYQ8tr/AnQZ
 YTmNUjZkYpDDcilyQxB0u8jNlcKEaszyFxoqmxTvOsDgQlU903KdqpIU7/be3pBZ0FMXmxdZ9lj
 xUHiJkakWduUxTUhpej/KPpEl/P1gwTWm6kV8SBAxR0wJWYpr48bwK7ssW88rz9KM0pJyyEr5G+
 v5Hn4XfLdzqVbgErm2XfVemr6/PB6zJoYo5qL17TxOE+fe4qN6DEE397V2fcyZWNI7SpveV6l7A
 +UsT2gqJDddSBPcapuSK8OckOtohpvXsX27nShfRdU0bxlzBdrBbXrc+8E2osCI1MbtP4wZyUKx
 0HFPuauuZHzAYy+nD9A==
X-Proofpoint-GUID: vLS7mZKFb45j-tgslmufgJgVLfkb8vA9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230045



On 3/22/2026 9:36 PM, Bean Huo wrote:
> On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
>> +/**
>> + * ufshcd_retrain_tx_eq - Retrain TX Equalization and apply new settings
>> + * @hba: per-adapter instance
>> + * @gear: target High-Speed (HS) gear for retraining
>> + *
>> + * This function initiates a refresh of the TX Equalization settings for a
>> + * specific HS gear. It scales the clocks to maximum frequency, negotiates
>> the
>> + * power mode with the device, retrains TX EQ and applies new TX EQ settings
>> + * by conducting a Power Mode change.
>> + *
>> + * Returns 0 on success, non-zero error code otherwise
>> + */
>> +int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
>> +{
>> +       struct ufs_pa_layer_attr new_pwr_info, final_params = {};
>> +       int ret;
>> +
>> +       if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
>> +               return -EOPNOTSUPP;
>> +
>> +       if (gear < adaptive_txeq_gear)
>> +               return -ERANGE;
>> +
>> +       ufshcd_hold(hba);
>> +
>> +       ret = ufshcd_pause_command_processing(hba, 1 * USEC_PER_SEC);
>> +       if (ret) {
>> +               ufshcd_release(hba);
>> +               return ret;
>> +       }
>> +
>> +       /* scale up clocks to max frequency before TX EQTR */
>> +       if (ufshcd_is_clkscaling_supported(hba))
>> +               ufshcd_scale_clks(hba, ULONG_MAX, true);
>> +
>> +       new_pwr_info = hba->pwr_info;
>> +       new_pwr_info.gear_tx = gear;
>> +       new_pwr_info.gear_rx = gear;
>> +
>> +       ret = ufshcd_vops_negotiate_pwr_mode(hba, &new_pwr_info,
>> &final_params);
>> +       if (ret)
>> +               memcpy(&final_params, &new_pwr_info, sizeof(final_params));
>> +
>> +       if (final_params.gear_tx != gear) {
>> +               dev_err(hba->dev, "Negotiated Gear (%u) does not match target
>> Gear (%u)\n",
>> +                       final_params.gear_tx, gear);\
> might be ret = -EINVAL; before goto?
You are right, let me add it in next version.

Thanks,
Can Guo.
>
>
>> +               goto out;
>> +       }

