Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAA9C77B7E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 10:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjFAK2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjFAK21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 06:28:27 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4B51738;
        Thu,  1 Jun 2023 03:27:43 -0700 (PDT)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351AN8eF020217;
        Thu, 1 Jun 2023 10:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=/uEoDe0BdlTJWH5TzZPVetiG1tUaWPoBMaxRoL8Qq0k=;
 b=RdHL7c+U4yCmqqI9JNh/jelydsI4BUHktbRg9iOKQ0yuaebmFIg6qnhjK8fAd6EyxlmM
 BFi5xZtleU8s5FtmX1S+eTVVVNIVi5HW+Z8T0nxE3l+lQIzrihHho1hAr/mvfG94obl+
 Orq7OqBXmV1CDoQ1a4iDWXlCMLhVXhh6FwNFszJlVWduoGrnC6uPqygJXNzs/utI5Aer
 XZqdTHkyVfIkbQH1jO+PWJNiU3PlMwaS3uHOBjqAAMUVZIQTfopePfCa0TO6aacBwlUw
 mr3Wuwo0JyMveT+sEKxHXgtte5FoiX3YpYygcY/foQRxXtE7MIfCIQFJB1RE2WC260dm Uw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qxpt70drq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 10:27:21 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 351ARK0E003031
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 1 Jun 2023 10:27:20 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 1 Jun 2023
 03:27:19 -0700
Message-ID: <962ae163-ffc1-6e4b-35b9-dd893a49d038@quicinc.com>
Date:   Thu, 1 Jun 2023 03:27:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: Fix ufshcd_inc_sq_tail function
 bug
Content-Language: en-US
To:     Zhang Hui <masonzhang.xiaomi@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        zhanghui <zhanghui31@xiaomi.com>, Bean Huo <beanhuo@micron.com>,
        <peng.zhou@mediatek.com>, <yudongbin@xiaomi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230601091357.1365-1-zhanghui31@xiaomi.com>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230601091357.1365-1-zhanghui31@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: uQSpTuZAm2DljchH2-OEguR08OjgkORI
X-Proofpoint-GUID: uQSpTuZAm2DljchH2-OEguR08OjgkORI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_06,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1011
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/1/2023 2:13 AM, Zhang Hui wrote:
> From: zhanghui <zhanghui31@xiaomi.com>
> 
> If q->max_entries is not multiple of 32, mask not every bit is 1.
> So q->sq_tail_slot some bit will be cleared by use this way.
Hi Zhang,
Maybe reword the commit message a little bit? Otherwise, it is a good patch.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
