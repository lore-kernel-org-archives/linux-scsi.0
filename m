Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770F282F27
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776951067; cv=none; b=DYDipJi7xT7uelEbVoLo9W9OhvBT/AH2CSVxr+oFbkrVmxOBDVG4t0gpVXpBgJET4BWidhz1aFG19fHKqhm10knqrU3pgjGCS+Bqbd+tKelCmrLBTaatjO3mARXl/qjp5YKar55Q7TlscqzG4o/y0wiGk7COLZU8DMLTAU3kxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776951067; c=relaxed/simple;
	bh=NxyTznSOVHDs+31Eml1fvnVenk68OjaS9nMMo6W2nbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/uivfoefzHxyYou+mEGnpAfY0iPDPEsU8IhLD1IBHfM8v/QCAfUR9CLLKB+zLCtiEdAuLpzPhh7R9PGPvrcVg45GBevX47N0ZYi+krzKW2HE59lH4TVtUcJLkj/yYCwBMR42UvnPgFGRXhfVdxiRmudkuJTPWHqUeuiM5Xw0uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BR50L+kk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K9JqfEn1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BR50L+kk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K9JqfEn1"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8uNsH1565720
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B2IrW4zJMm2y1QlRpdD4guuu/pN7EnUqJhKoxq7TncE=; b=BR50L+kkjLO0IEy/
	VkbWsD6ZsB9CBu1l7/M9Iira0e7JdLvJBB5WNOXs8DvsIoey4/29xLzCAlE9TKPx
	hTNoJBP2v/Qj+z/O12BU+tEXY+XID7VXfj7KGSa5CIeCSEW2TkLQktswvNWhSyvh
	HT6XILpn/BU2CIgZROC+qfv6JVlw90mjU000YbbGTrn2XgdZwaHraHIveapRxByS
	QSiCdNaT2ARKJyzOq0rWFStWHuBzccnNRzvlzQreGNSrtJxvi2nb1h98Z2dUBgIc
	LZjMk5rAmCfPmiLGUIonEBCyilw98bSuhYZJ/Yt2uZosHdvzXr22yQy9bEtp3zKj
	dxpm6A==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq16wv7hm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:31:05 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f0e12d375so4000962b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 06:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776951064; x=1777555864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B2IrW4zJMm2y1QlRpdD4guuu/pN7EnUqJhKoxq7TncE=;
        b=K9JqfEn1mraVWNOjUBAmcBtaHfcAQs8OaqhOXdvFblTXTv1mViEuTL0TVEK7hEOhf4
         Sn8JUpI5RQkqJZAehyMujHu5xD6mS5JxsyLwzQ3KaiUyXVW8ORpT034PsUxkKpMZV1EL
         g9NoC9qPG3ph3XuZZdSYt4Qtsd+eYOpZIVWnB7uxvpXB61ZOuOjQcyW2FJsS41yhrBi5
         XVNcfcXg2ZiWpgoGE5tFvYhqaMNVqWn8O8q+IIY7xuIzie4g1AB5T7aKyiL2cYy3zd0C
         Ep57zHG84ylUjtnNmyoZ99ghP+YCTs4gPwIn5kih/OYPtrsjKdIsXDUEG5icY6u5ppNY
         3RgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776951064; x=1777555864;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2IrW4zJMm2y1QlRpdD4guuu/pN7EnUqJhKoxq7TncE=;
        b=QtBx0yTfB9k4KQWFwQTOeOgc7tMjHyhWL9BNpN5xSbSDArlXoAeMoNDgtp78hZio4B
         6P2O81NtKwbpaSfQBG9kCfEbBFAxkFHMl6IxD0uENxPvZ1UmzaZ8OyIC4Z2/HCsyMUKZ
         IsMn8kEvF0boG/AXYZdFH0R9hJiYk8TCH4ox95wDm1AWC4wTJ2k208z1p+BUtU1u2PE7
         AD0S/mFoJ5V92p+2I32LkNAcfr1CuQgFGWK9RuvLZS/hfoMF/M+LApJh0z429U4VuaZy
         TSiREz88ZMROvNw6tJh0YkAeX/QXIXk5vmafADy7kaAOXwbQ1cxTJPg0q8NnAJKBseN5
         x2vQ==
X-Gm-Message-State: AOJu0Yz/TV4uDe6Ma8sEtx2EeUXiSWSbxSewaiOn89FwfDc8tE9au1s0
	RuwbMjOcN4m/Ciphw+7QDJSIFd1ALeDcVBzuHjeiNtiBXWZ14Hqbh7JhZP7BhRy5JJdiMNBcKpc
	7tWKY0Pr5gryL5uPOhRc7DeUu61SUsYqmSQhI7CtLGvYElX2Gv8nLkc7NZpYLn4Gl
X-Gm-Gg: AeBDieuJvmvXv3l1c+699BISNZQU/hZSpj0MnlVUppiNImSJq7oUTDPjSYZbkPb1pCk
	G3ugSaAfAVCjcuX6y3BsdMLqTtLXBqNJXvxkAEkDZamZYhbaDLideWfVgubv/XQjAVwjfRSXKgp
	KMmWzZPnqU8POweE0qKBwgPnuGRzn4Ch0ox01UlcCWzxSGyf7k4VWGOca6y1aA+pXhu6D7sHbMw
	giUdOT/Xofy1bhtFbUnl67e1hnHFL4xf2dFNCHjqqhxDEp6S59Ncv0et6e1SVPzejVteI+m61YI
	ihWvXMhMPVZFCAIPaclOoNHuMGC0x/YGsQreCA0efVwot88bZIEaq6iamDZWX0Nl7d1IOQQZjfd
	ElUyw4E6fjuNHQkMqJS/+C4LMThAK4153zuoQ/l4X9QcQRJjflm+T/iarIH/Quup8IwkeE0eiY7
	y7biEZ/vL6/1koNrEe73a2
X-Received: by 2002:a05:6a00:8714:b0:82f:be7d:5fc0 with SMTP id d2e1a72fcca58-82fbe7d61c8mr12499514b3a.39.1776951064335;
        Thu, 23 Apr 2026 06:31:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:8714:b0:82f:be7d:5fc0 with SMTP id d2e1a72fcca58-82fbe7d61c8mr12499448b3a.39.1776951063667;
        Thu, 23 Apr 2026 06:31:03 -0700 (PDT)
Received: from [10.133.33.37] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9fcea9sm25531703b3a.23.2026.04.23.06.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 06:31:03 -0700 (PDT)
Message-ID: <a7e2d542-0453-4c14-afbd-c073a6565d02@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 21:30:56 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniel Lee <chullee@google.com>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Huan Tang <tanghuan@vivo.com>, Liu Song <liu.song13@zte.com.cn>,
        vamshi gajjela <vamshigajjela@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-2-can.guo@oss.qualcomm.com>
 <dab22e8ea2b47207e8e4a9264f0421f959891fca.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <dab22e8ea2b47207e8e4a9264f0421f959891fca.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEzNCBTYWx0ZWRfX5vshq3Oh01VK
 M5I8tyPIsRdtbiwCkaPo5Q/Ba1YN9EYhX6PD0ooe0IaBVp08jBdkem/Fc+fDHJyjylcibwVH3HC
 9wNHf9OVF2eJxgpcAYOiyZ2HRgAuzhEDvWkGvVJ8Tt5o4ZKYGiCpe/RZdbeMVOjmraRRa2clZbB
 bgIia5XDQqPcmN5sZavkMGeAkcwmyJwH0X/ztqFp/Xr5UH694igjWBOMnd3wq6LAefmGNa17X5G
 CvkP8/iJtCzCQstVsuDA9iWAkGyu+WP88P1hqNOZApgUCs8H2nhwdT7/Tt01zmlrPptDfRKSqLp
 P8YcTF+M3Nm3QpYMGpdhhzRzY2QfvUnHvg5GYsXEDev0Jc0TCk1iTSxD/Ilo3EvoMJ/c5nbf5rg
 +gCt5jung/Du5PZitrc1soWCBc09Uba/Ei8Acdf049HCuHFP3Xsl+uXxILiVKF7qBTJMKesJ1w3
 kvaNGZSuO5htqr/F04Q==
X-Authority-Analysis: v=2.4 cv=dL+WXuZb c=1 sm=1 tr=0 ts=69ea1f19 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=1dNXFKBvIBPViYih24wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: B8LUQex9fW93KF_oxZYOHjFwb2UcPgpZ
X-Proofpoint-ORIG-GUID: B8LUQex9fW93KF_oxZYOHjFwb2UcPgpZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230134



On 4/21/2026 6:04 AM, Bean Huo wrote:
> Can,
>
>
> On Sun, 2026-04-19 at 06:52 -0700, Can Guo wrote:
>>   static int wb_read_resize_attrs(struct ufs_hba *hba,
>>                          enum attr_idn idn, u32 *attr_val)
>>   {
>> @@ -1736,6 +1747,7 @@ static ssize_t _name##_show(struct device
>> *dev,                           \
>>          struct device_attribute *attr, char *buf)                       \
>>   {                                                                      \
>>          struct ufs_hba *hba = dev_get_drvdata(dev);                     \
>> +       u64
>> qword_value;                                                        \
> u64 qword_value __maybe_unused;
>
>
>>          u32 value;                                                      \
>>          int ret;                                                        \
>>          u8 index = 0;                                                   \
>> @@ -1748,14 +1760,24 @@ static ssize_t _name##_show(struct device
>> *dev,                         \
>>          if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))                 \
>>                  index = ufshcd_wb_get_query_index(hba);                 \
>>          ufshcd_rpm_get_sync(hba);                                       \
>> -       ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,       \
>> -               QUERY_ATTR_IDN##_uname, index, 0, &value);              \
>> +       if (ufshcd_is_qword_attrs(QUERY_ATTR_IDN##_uname))              \
>> +               ret = ufshcd_query_attr_qword(hba,                      \
>> +                       UPIU_QUERY_OPCODE_READ_ATTR,                    \
>> +                       QUERY_ATTR_IDN##_uname,                         \
>> +                       index, 0,
>> &qword_value);                                \
>> +       else                                                            \
>> +               ret = ufshcd_query_attr(hba,                            \
>> +                       UPIU_QUERY_OPCODE_READ_ATTR,                    \
>> +                       QUERY_ATTR_IDN##_uname, index, 0, &value);      \
>>          ufshcd_rpm_put_sync(hba);                                       \
>>          if (ret) {                                                      \
>>                  ret = -EINVAL;                                          \
>>                  goto out;                                               \
>>          }                                                               \
>> -       ret = sysfs_emit(buf, "0x%08X\n", value);                       \
>> +       if (ufshcd_is_qword_attrs(QUERY_ATTR_IDN##_uname))               \
>> +               ret = sysfs_emit(buf, "0x%016llX\n",
>> qword_value);              \
>> +       else                                                            \
>> +               ret = sysfs_emit(buf, "0x%08X\n", value);               \
>>   out:                                                                   \
>>          up(&hba->host_sem);                                             \
>>          return ret;                                                     \
>>
> ...
>
>
>>   
>> +/**
>> + * ufshcd_query_attr_qword - API function of sending query requests for quad-
>> word attributes
>> + * @hba: per-adapter instance
>> + * @opcode: attribute opcode
>> + * @idn: attribute idn to access
>> + * @index: index field
>> + * @sel: selector field
>> + * @attr_val: the attribute value after the query request completes
>> + *
>> + * Return: 0 for success, non-zero in case of failure.
>> + */
>> +int ufshcd_query_attr_qword(struct ufs_hba *hba, enum query_opcode opcode,
>> +                           enum attr_idn idn, u8 index, u8 sel, u64
>> *attr_val)
>> +{
>> +       struct utp_upiu_query_v4_0 *upiu_req;
>> +       struct utp_upiu_query_v4_0 *upiu_resp;
>> +       struct ufs_query_req *request = NULL;
>> +       struct ufs_query_res *response = NULL;
>> +       int err;
>> +
>> +       if (!attr_val) {
>> +               dev_err(hba->dev, "%s: attribute value required for opcode
>> 0x%x\n",
>> +                       __func__, opcode);
>> +               return -EINVAL;
>> +       }
>> +
>> +       ufshcd_dev_man_lock(hba);
>> +
>> +       ufshcd_init_query(hba, &request, &response, opcode, idn, index, sel);
>> +
>> +       switch (opcode) {
>> +       case UPIU_QUERY_OPCODE_WRITE_ATTR:
>> +               request->query_func = UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST;
>> +               upiu_req = (struct utp_upiu_query_v4_0 *)&request->upiu_req;
>> +               put_unaligned_be64(*attr_val, &upiu_req->osf3);
>> +               break;
>> +       case UPIU_QUERY_OPCODE_READ_ATTR:
>> +               request->query_func = UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
>> +               break;
>> +       default:
>> +               dev_err(hba->dev, "%s: Expected query attr opcode but got =
>> 0x%.2x\n",
>> +                       __func__, opcode);
>> +               err = -EINVAL;
>> +               goto out_unlock;
>> +       }
>> +
>> +       err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
>> +       if (err) {
>> +               dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index
>> %d, selector %d, err = %d\n",
>> +                       __func__, opcode, idn, index, sel, err);
>> +               goto out_unlock;
>> +       }
>> +
>> +       upiu_resp = (struct utp_upiu_query_v4_0 *)response;
>> +       *attr_val = get_unaligned_be64(&upiu_resp->osf3);
>> +
>> +out_unlock:
>> +       ufshcd_dev_man_unlock(hba);
>> +       return err;
>> +}
>> +
> this needs a wrapper for retry?  In ufshcd_extract_tx_eq_settings_attrs(), the
> 32-bit dTxEQGnSettingsExt read uses ufshcd_query_attr_retry(), but the 64-bit
> qTxEQGnSettings read uses bare ufshcd_query_attr_qword() with no retries.
I will use the non-retry version in ufs_txeq.c to be symmetrical, 
because I don't really need
retry - retry never helped in real cases.

Thanks,
Can Guo.
>
> Kind regards,
> Bean

