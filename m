Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2F3EE4992
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 21:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbjHRVUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbjHRVTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 17:19:40 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C72102;
        Fri, 18 Aug 2023 14:19:39 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37IKw4N2010368;
        Fri, 18 Aug 2023 21:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=a6rKvlfuBT5cWWbXTDuJZRXqZ2uXq/SqXooJNvei7E4=;
 b=NTa2YO7dUj4QhMrNPrvkZQ85MA+uM4JCFcoDOB780fy7bJ/O0Pjijkb/a0fH8EuP5T/e
 yXQ6TvdrT/3UWQHTyet+BaD7RGnURFnGQLZm9efO6ph7gEPrbvet3yagiL/d6XtCSeCL
 TePaxBMoamaBtnMpyYk8xSv9XRQoC03IElfb2p3gN1hhMd34BMH/zpnBPFpSh/VZreKU
 QM1o+jHm1wDC3pZCdmuI/Cx0MoXlQDpHdFVVJzf67ckQafXfXpIcs6xtbbAmU2ABFhUv
 LPliPe0qk2qP+WOLk3iYH2bg8KkM9DosnvbJavOf+4WIpOCsdinRQw0EJOtRTVy+SLaN xw== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sj6321a70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:19:27 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37ILJQS2032248
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Aug 2023 21:19:26 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Fri, 18 Aug
 2023 14:19:25 -0700
Message-ID: <571a6b8c-b0bb-6c0e-7cda-b5c59f8fa0da@quicinc.com>
Date:   Fri, 18 Aug 2023 14:19:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v10 18/18] scsi: ufs: Inform the block layer about write
 ordering
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
 <20230818193546.2014874-19-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230818193546.2014874-19-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: W3PdJ69feuc3B1Kn9GvthAKDusVHVWHc
X-Proofpoint-ORIG-GUID: W3PdJ69feuc3B1Kn9GvthAKDusVHVWHc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-18_26,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308180195
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/18/2023 12:34 PM, Bart Van Assche wrote:
>  From the UFSHCI 4.0 specification, about the legacy (single queue) mode:
> "The host controller always process transfer requests in-order according
> to the order submitted to the list. In case of multiple commands with
> single doorbell register ringing (batch mode), The dispatch order for
> these transfer requests by host controller will base on their index in
> the List. A transfer request with lower index value will be executed
> before a transfer request with higher index value."
> 
>  From the UFSHCI 4.0 specification, about the MCQ mode:
> "Command Submission
> 1. Host SW writes an Entry to SQ
> 2. Host SW updates SQ doorbell tail pointer
> 
> Command Processing
> 3. After fetching the Entry, Host Controller updates SQ doorbell head
>     pointer
> 4. Host controller sends COMMAND UPIU to UFS device"
> 
> In other words, for both legacy and MCQ mode, UFS controllers are
> required to forward commands to the UFS device in the order these
> commands have been received from the host.
> 
> Notes:
> - For legacy mode this is only correct if the host submits one
>    command at a time. The UFS driver does this.
> - Also in legacy mode, the command order is not preserved if
>    auto-hibernation is enabled in the UFS controller. Hence, enable
>    zone write locking if auto-hibernation is enabled.
> 
> This patch improves performance as follows on my test setup:
> - With the mq-deadline scheduler: 2.5x more IOPS for small writes.
> - When not using an I/O scheduler compared to using mq-deadline with
>    zone locking: 4x more IOPS for small writes.
> 

Hi Bart,
Thank you for double checking and the detailed explanation.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
