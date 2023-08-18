Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CF2EE4999
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 21:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbjHRVGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbjHRVGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 17:06:14 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DA44214;
        Fri, 18 Aug 2023 14:06:13 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IKgH0k030329;
        Fri, 18 Aug 2023 21:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=dKug2rspLP9ozJB6khd+VSG2uY3kPoHYW02E0VLxC8w=;
 b=X+26jvrT0NGiofyDTEanDTUnbdxNNIbmEUNpBc3bL+RP4qqalt8qcULPQkTPHtl4+CPg
 5GOFE8bzzIO82F/pyCBB3t2uiX2NW6rtQN6NY9QuOdpd/vRAWfkj5Qu1AoG2PUI5kaPh
 0Bi4PnqZs7ttY9OomHq8561zttnaWQdAdGIo4yWtYgdvKFaFzlIrbVxN5XzHax2/njaE
 jYShNWIKDNPOw40V4XgRyVX1SdYXm6OQuRnb9HT18UOkkpGD3Q9kpgaCSiUKkRP++p8S
 nAFnPgGDtWS3LEwsoQV6Z55GzQ0ccqS9fyK0pPvLE53ROvY3SSZpC8+b5jICjZMW+OVY xQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sj5t49b5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:05:44 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37IL5hnl016064
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:05:43 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Fri, 18 Aug
 2023 14:05:42 -0700
Message-ID: <81030155-6df7-a7b0-a4ee-584aca6908e6@quicinc.com>
Date:   Fri, 18 Aug 2023 14:05:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v10 11/18] scsi: ufs: Change the return type of
 ufshcd_auto_hibern8_update()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Can Guo" <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Asutosh Das" <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        "Eric Biggers" <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-12-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230818193546.2014874-12-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: f7ang_Zw2e79v08ygADikeOXe9FLOGAG
X-Proofpoint-ORIG-GUID: f7ang_Zw2e79v08ygADikeOXe9FLOGAG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_26,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=760 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180193
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2023 12:34 PM, Bart Van Assche wrote:
> A later patch will introduce an error path in ufshcd_auto_hibern8_update().
> Change the return type of that function before introducing calls to that
> function in the host drivers such that the host drivers only have to be
> modified once.
> 

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
