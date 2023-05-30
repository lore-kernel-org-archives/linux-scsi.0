Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D0CC77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 05:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjE3FYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 01:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjE3FYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 01:24:30 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104B3AD
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 22:24:28 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U4l0id021445;
        Tue, 30 May 2023 05:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=WFyfiyP148MYf55b9OHBRE4mI1uTMbcbZAP1cjZsELo=;
 b=gqcQFES1gguCekkOMQL2RAnQN/esNFVx8728uiVze7VSq4sMRmFX6TRrepKhiSCiTIjO
 xbqfkFiaVxg8dZ2zcYh4PnQuhk29S48JkoMmEXQOVlEWc6/VkpNdJp7bW38BCYi2V/dD
 Oppqtmyewo0EJ/Lj3G1TbAz93TNKJNHG5AcST72nwxQzVJjUZdOvnaytiTRJzeKFHwxi
 p8BmmZpKoB4amxrngXUYWiIRk9PEz/WvAb3UViJa97CPYiPLhUs1W6VOy2yGV47vsrXB
 ZC4pZi2vF+l/MV0jXJGny90NSu0jDK2uY5ffPhpAaqFLnovdMUB8y3UciXIMRUIbpy5j bA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qvwm4s414-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 05:24:04 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34U5O24u003952
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 05:24:03 GMT
Received: from [10.253.33.217] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Mon, 29 May
 2023 22:24:00 -0700
Message-ID: <32628a40-d2bf-76bb-3043-708c813e38b3@quicinc.com>
Date:   Tue, 30 May 2023 13:23:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 0/7] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        <quic_asutoshd@quicinc.com>, <bvanassche@acm.org>,
        <mani@kernel.org>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <beanhuo@micron.com>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <cover.1685396241.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From:   Can Guo <quic_cang@quicinc.com>
In-Reply-To: <cover.1685396241.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: o26Tyys5n6KshaoX2N0AnHbIW8blmmBi
X-Proofpoint-GUID: o26Tyys5n6KshaoX2N0AnHbIW8blmmBi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_02,2023-05-29_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=713
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305300043
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bao,

On 5/30/2023 6:12 AM, Bao D. Nguyen wrote:
> This patch series enable support for ufshcd_abort() and error handler in MCQ mode.
>
> Bao D. Nguyen (7):
>    ufs: core: Combine 32-bit command_desc_base_addr_lo/hi
>    ufs: core: Update the ufshcd_clear_cmds() functionality
>    ufs: mcq: Add supporting functions for mcq abort
>    ufs: mcq: Add support for clean up mcq resources
>    ufs: mcq: Added ufshcd_mcq_abort()
>    ufs: mcq: Use ufshcd_mcq_poll_cqe_lock() in mcq mode
>    ufs: core: Add error handling for MCQ mode
>
>   drivers/ufs/core/ufs-mcq.c     | 259 ++++++++++++++++++++++++++++++++++++++++-
>   drivers/ufs/core/ufshcd-priv.h |  18 ++-
>   drivers/ufs/core/ufshcd.c      | 256 ++++++++++++++++++++++++++++++++--------
>   drivers/ufs/host/ufs-qcom.c    |   2 +-
>   include/ufs/ufshcd.h           |   5 +-
>   include/ufs/ufshci.h           |  23 +++-
>   6 files changed, 501 insertions(+), 62 deletions(-)
> ---
> Changes compared to v6:
> patch #7: Added a new argument force_compl to function ufshcd_mcq_compl_pending_transfer().
>            Added a new function ufshcd_mcq_compl_all_cqes_lock().
> 	  This change is to handle the case where the ufs host controller has been reset by
> 	  the ufshcd_hba_stop() in ufshcd_host_reset_and_restore() prior to calling
> 	  ufshcd_complete_requests(). The new logic is added to correctly complete all the
> 	  commands that have been completed in the Completion Queue, or inform the scsi layer
> 	  about those commands that are still stuck/pending in the hardware.
> ---

Feel free to my Reviewed-by tag to this series,

Reviewed-by: Can Guo<quic_cang@quicinc.com>


Thanks.
Regards,
Can Guo.

