Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842BBEE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 07:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjHUHQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 03:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbjHUHQa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 03:16:30 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC2A8;
        Mon, 21 Aug 2023 00:16:28 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L6Q99d019291;
        Mon, 21 Aug 2023 07:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=p1ID9vHjHJkgPdiTth8jissRZySUFtBmae3dlNXtZrU=;
 b=FitH5LY88QfHIUd7gDGqxj0/PBd4P7f7aCF1rdWrq2Tl/XztwMV/3RmvT8yp/31hteeX
 IWAng8km4+5VulvQnU+PbnBtlstoUMf9HnUpD8BGbW9RGzhQaCswfLb1teo3omPz3GBd
 zHBWrcntrgMLpDddLxCwpFMi/0Xa2vrij9LpIeQkmkjUIjEZQaSNaJczA5eaSIHOBh+m
 1Ukt6ve+bYiTkjT4Rlz63IQakp82xgmDadsk6rXLOCiL08IHtokdrzBBSCGnDlQh8vs2
 g98RV+74ykS+cG7fz+QiRTm4RYNZOJ1MZ6uUMjJV/N+Vm3AXceaNiTx7mRD1W3rdyNHy fA== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sjnb72ujv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 07:15:55 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37L7FsYB014426
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Aug 2023 07:15:54 GMT
Received: from [10.253.34.146] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.36; Mon, 21 Aug
 2023 00:15:51 -0700
Message-ID: <70d8ba74-0a6c-3ebd-ed85-3e8e14626385@quicinc.com>
Date:   Mon, 21 Aug 2023 15:15:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v10 18/18] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-19-bvanassche@acm.org>
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <20230818193546.2014874-19-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 99G9uu87UlX4wpi6l-ioEv7E46vRY11w
X-Proofpoint-GUID: 99G9uu87UlX4wpi6l-ioEv7E46vRY11w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/19/2023 3:34 AM, Bart Van Assche wrote:
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
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <quic_cang@quicinc.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
Reviewed-by: Can Guo <quic_cang@quicinc.com>
