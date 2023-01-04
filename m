Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EC7C4708D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 05:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjADFUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 00:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADFUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 00:20:39 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B9315FC9
        for <linux-scsi@vger.kernel.org>; Tue,  3 Jan 2023 21:20:39 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3041AavH007844;
        Wed, 4 Jan 2023 05:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=4A1gVEGnm8x/28DVipYHmS7EzLXLgc7XtM1L+lbivlE=;
 b=DaNG0Hu5BIOeiDaR3p9477yLEhWYfL2ldnFMo4cBtJPvx1EvIJCjFyyWk3FnizOsRtkR
 JASMMuZRZcsSgnkuoYsO4MOUQufwyjCk3cWohwMvF40RXsctwWF+FTUaCY6RNBaHHY+H
 jk2H8jq9shBBRfty8WKfQ/hcNXUvuCeTbddce3VGuz2FIaVbL99MLVrCedPBj2S10JHm
 WSYp0mhYCu2SP4iH45OeOLmm8C10D3giU/aqu2WvQtOw+vInfnOBuBWR86fj5nWE+Znj
 ID9LuVQB6l1uAFVhc7SsaBrPaZrM3dx+srznPD9Acg2TWy4D1kJ+X+qQe1iJdafVMu58 FA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mvsvxs1sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 05:20:25 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3045KORF002377
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 4 Jan 2023 05:20:24 GMT
Received: from [10.253.73.183] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 3 Jan 2023
 21:20:22 -0800
Message-ID: <0282bb4e-9b7b-7454-4c90-c7cfd1cf21c7@quicinc.com>
Date:   Wed, 4 Jan 2023 13:20:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH v3 0/3] Add support for UFS Event Specific Interrupt
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <quic_asutoshd@quicinc.com>, <bvanassche@acm.org>,
        <mani@kernel.org>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <beanhuo@micron.com>,
        <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
        <linux-scsi@vger.kernel.org>
References: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
 <yq1h6xc4jgh.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <yq1h6xc4jgh.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: yhQqtPbs1DI2D7opECXuug8zOhjWtRwF
X-Proofpoint-GUID: yhQqtPbs1DI2D7opECXuug8zOhjWtRwF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_02,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=726 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040043
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 12/31/2022 6:26 AM, Martin K. Petersen wrote:
> Can,
>
>> UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series
>> is to enable Event Specific Interrupt (ESI), which can used in MCQ
>> mode.
>>
>> Please note that this series is developed and tested based on the
>> latest MCQ driver (v11) pushed by Asutosh Das.
> Please rebase once Asutosh posts v12. Thanks!

You can pick up this series as it is after Asutosh posts v12, it should 
apply cleanly.

If not, please let me know.


Thanks.

Regards,

Can Guo.

