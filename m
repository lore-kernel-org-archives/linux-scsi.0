Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D7BC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 17:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjE3RpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 13:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjE3RpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 13:45:05 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FA8C5
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 10:45:03 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCjoI0005505;
        Tue, 30 May 2023 17:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=++9igwt/DTcR7UvYeVf0VvLoF7rk3HCWFMP6R7AfnzQ=;
 b=WQTaVHzp+ZY37RH9jbs5hSY3TajznPzGA+f6HYzpLC8yTogq7tNDHnlo82kWrHiTt7ku
 pKxdFyG0Q6I3O9+oqXbU7VTxFbMBoi67Exj99A39ZPA9MQWIh/nYed8uuwfw5Ts+sZ6o
 iKq0/8cVmAAS2sLbE6oOvEJIXNTVgNbdNMrBFgizjKy+qNWPZqPsrNFFp2PF10w4U4HF
 gsp8i8GBg6YXRzYdd0GcC0fqjgw51+6Cdi2yAASER5aA6Z2NfuC+t0K8OBF4brjLPm81
 34NP7sESOLAKuGGa8i26hD9WRdDhsrJA2PY1bl2VtqXJoOObpVGv2R3sVM93BGqgkYtz Sw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qw03q2bmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 17:39:38 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34UHdbel005985
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 17:39:37 GMT
Received: from [192.168.143.77] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Tue, 30 May
 2023 10:39:36 -0700
Message-ID: <01139a52-3105-1fe7-b077-89a215e5fcd8@quicinc.com>
Date:   Tue, 30 May 2023 10:39:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 5/5] scsi: ufs: Ungate the clock synchronously
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Ziqi Chen" <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20230529202640.11883-1-bvanassche@acm.org>
 <20230529202640.11883-6-bvanassche@acm.org>
From:   "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
In-Reply-To: <20230529202640.11883-6-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ltXuxnPkNjFU-y3IvSSCxj8KfpNQsnxE
X-Proofpoint-ORIG-GUID: ltXuxnPkNjFU-y3IvSSCxj8KfpNQsnxE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_13,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=1011 mlxlogscore=990 adultscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/2023 1:26 PM, Bart Van Assche wrote:
> Ungating the clock asynchronously causes ufshcd_queuecommand() to return
> SCSI_MLQUEUE_HOST_BUSY and hence causes commands to be requeued.  This is
> suboptimal. Allow ufshcd_queuecommand() to sleep such that clock ungating
> does not trigger command requeuing. Remove the ufshcd_scsi_block_requests()
> and ufshcd_scsi_unblock_requests() calls because these are no longer
> needed. The flush_work(&hba->clk_gating.ungate_work) call is sufficient to
> make the SCSI core wait for clock ungating to complete.
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>

