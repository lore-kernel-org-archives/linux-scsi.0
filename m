Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CD5EE4997
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 21:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbjHRVSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbjHRVSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 17:18:00 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627CD4214;
        Fri, 18 Aug 2023 14:17:59 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IKZW2t015164;
        Fri, 18 Aug 2023 21:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=Yk8XN1D3Dq2dSUJdwB2KQJuurU9nV1Av1HWmqnUlK+k=;
 b=C4zXjqUSX8mKdO4Mqc00cPqX406rTrXxsQ6KlXJUQlB1uH4GQRODBYMKBFZZjytE7Ibr
 C0OeKUCvQwxdocLV552Q/uP1C5bW7k6P7wHEl2vvy94fi5KmCUdBRWSWtFlsz8yAq+00
 Y8IZLY+/BMs6UNONP8XRqAvlrbXlR8rrpzZ7MyqaFAuaebU1w+9HBwXfnT7n2V9UVeQr
 l09Va59FY79bSUij8LhID8iIM0ksSm1SyDu4PkF0no61z7mvLfnoxgRS0yEPukDsI0xA
 N1qd8Psf1PZtMYhxuG5FxAao4eKtZlDAtSYoQ6Z88+kabq3t8j82j5zdvuvxBCQxjYbf 2g== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sht44ag3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:17:47 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37ILHkRd019264
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:17:46 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Fri, 18 Aug
 2023 14:17:45 -0700
Message-ID: <faf5229c-a18c-a7a1-d791-77852274dfba@quicinc.com>
Date:   Fri, 18 Aug 2023 14:17:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v10 17/18] scsi: ufs: Forbid auto-hibernation without I/O
 scheduler
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
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Arthur Simchaev" <Arthur.Simchaev@wdc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-18-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230818193546.2014874-18-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: tIfVXLDKEppnkMesdZjwkqwMNLUfhTlM
X-Proofpoint-ORIG-GUID: tIfVXLDKEppnkMesdZjwkqwMNLUfhTlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_26,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 mlxlogscore=509 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180194
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2023 12:34 PM, Bart Van Assche wrote:
> UFSHCI 3.0 controllers do not preserve the write order if auto-hibernation
> is enabled. If the write order is not preserved, an I/O scheduler is
> required to serialize zoned writes. Hence do not allow auto-hibernation
> to be enabled without I/O scheduler if a zoned logical unit is present
> and if the controller is operating in legacy mode. This patch has been
> tested with the following shell script:
> 

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
