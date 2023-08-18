Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A337FEE4999
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 21:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbjHRVJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbjHRVJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 17:09:27 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3211421B;
        Fri, 18 Aug 2023 14:09:25 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IKreLW032544;
        Fri, 18 Aug 2023 21:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=VZklrhTjP8moCmJNJDKNGm1beCXeIkmhiBFUSKrE8xw=;
 b=c6/M8EM1Rf7Fn28u1cqOBNMjFSBOwlWBTSZuU8fSeBeAwUQUZgmTo8+TrDpp60FSC9La
 YJXI8Y6bpcG4gIm9qy+lUUM2c987jNFC6aa+jCUvA/tzonuSkm6IqNJaIT4LAhKhA+Cp
 tzEoFkVRaoHEVCdE1HqY/3/uA0sTJFP/a7k/5e+IpCkCFyaDjA1V927UMpi+4DF3A/9t
 FF7DvhKtcQM9hV6h5SrfQUK/ztCRPsCz1Pam/pPJydGP/KyLCNn07AjVUy48atW1AIgR
 jb27DVcn1ggHqxZpsL6YBNNcrn5wv0U8g5Za6t/mOCwyWSPtzaeWbWaV4wU09TBBwnqi XA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sj63219tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:09:11 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37IL9AoC026045
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:09:10 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Fri, 18 Aug
 2023 14:09:09 -0700
Message-ID: <ba6e198f-48a3-4a88-6513-fffc2fd8d346@quicinc.com>
Date:   Fri, 18 Aug 2023 14:09:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v10 12/18] scsi: ufs: hisi: Rework the code that disables
 auto-hibernation
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo" <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-13-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230818193546.2014874-13-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: m-s50vrVFUEEez8YSDl3htl15ateJrt4
X-Proofpoint-ORIG-GUID: m-s50vrVFUEEez8YSDl3htl15ateJrt4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_26,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 clxscore=1011 mlxscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180193
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2023 12:34 PM, Bart Van Assche wrote:
> The host driver link startup callback is called indirectly by
> ufshcd_probe_hba(). That function applies the auto-hibernation
> settings by writing hba->ahit into the auto-hibernation control
> register. Simplify the code for disabling auto-hibernation by
> setting hba->ahit instead of writing into the auto-hibernation
> control register. This patch is part of an effort to move all
> auto-hibernation register changes into the UFSHCI driver core.
...
>   	/* disable auto H8 */
> -	reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
> -	reg = reg & (~UFS_AHIT_AH8ITV_MASK);
> -	ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +	hba->ahit = 0;
The original code only clears the timer value, not the scale.
However, I think it is safe to assume that it meant to clear both.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
