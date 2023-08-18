Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343F0EE4997
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 21:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbjHRVPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbjHRVPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 17:15:39 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93125421A;
        Fri, 18 Aug 2023 14:15:38 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IKlweS023986;
        Fri, 18 Aug 2023 21:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=5zVwarqAiujGpLsyOCbr4rdvhkuiFge41TwdoJexVSA=;
 b=oiRvPjQAlZ0fSolkh6ck6KAG/RQS4p0vczNswopPG5Rygghkp6OEJaHqYOgmPJC0gcCD
 8atowOp/6Dyn53PBnMYJWYoR6KjuYQaq3S/i33QZolg1jzS1OJnEWuIN1/k/UWnN5n5X
 kxZa4ezz9W7GXr3jUd/gSVyTZllpheEdrF+7tEejyLcfod/0lHPpcw/1WCkgQuCZPOt1
 rGMOVojYpe09Y9I/ErdAnBALTqAaLA2zEwRGsC216fGLrNpjQHw8aCIf7w4gH+6aBH87
 JFNWiK3v0cXV4OXYPVlVE0637aMypUhgLFJqTj24kfAjwcrtyG5Hi2N7S3/axk/d5z1e 0g== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sj1xdhr46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:14:22 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37ILELu8015111
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:14:21 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Fri, 18 Aug
 2023 14:14:20 -0700
Message-ID: <9aaf4e3b-97f8-a95a-904c-a7cec488d9f0@quicinc.com>
Date:   Fri, 18 Aug 2023 14:14:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v10 14/18] scsi: ufs: sprd: Rework the code for disabling
 auto-hibernation
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        "Baolin Wang" <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Zhe Wang <zhe.wang1@unisoc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-15-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230818193546.2014874-15-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: _G6jVSgqUqejhZLDQEP1ZnqUYAOCv4Ot
X-Proofpoint-ORIG-GUID: _G6jVSgqUqejhZLDQEP1ZnqUYAOCv4Ot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_26,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 spamscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxlogscore=724
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180193
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2023 12:34 PM, Bart Van Assche wrote:
> Call ufshcd_auto_hibern8_update() instead of writing directly into the
> auto-hibernation control register. This patch is part of an effort to
> move all auto-hibernation register changes into the UFSHCI driver core.
> 

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>

