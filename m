Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00DDECAAD8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 03:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiISDLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Sep 2022 23:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiISDLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Sep 2022 23:11:20 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637AC1A3A1
        for <linux-scsi@vger.kernel.org>; Sun, 18 Sep 2022 20:11:19 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J2DalT028420;
        Mon, 19 Sep 2022 03:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=kqnzwp1D/1DzbKpruunJbUtoJV9ec0H8mimC+UaSD+o=;
 b=n/TNNmnAwSkjBSm6eW003roWynqqLHV02IdWpxC1k2a7UWpEAEw9W/qHZ4Eggz/LtvaT
 okF2VyGyRpdQX4r5Ye3I0P2TP6Qyjsr9fipJ4e/3bXWFXY50Ug7CI7Ti7Ib9JrNvHeQR
 vzpW2j/tADP40U5GZH5bwj3YkPNs/7LxgsGJLhMqMXEBegLOWsykLlHvHzmA+RkvFu1/
 ZCxOpCqgHOBCXA6+Eg+CMnF7V43Pn+wIwRHviyztcR6FckQSgjIecCvwXeXxLD2HUSsI
 9bIrTSG+k49X+DaTCMfszRy/AymZiIFfs0AyIZ1zLQxUPwGYqeuJdh8aZVlaQ4rUWlp1 0A== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jn6dh2re3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 03:10:29 +0000
Received: from nasanex01a.na.qualcomm.com (corens_vlan604_snip.qualcomm.com [10.53.140.1])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 28J3ASJt017162
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 03:10:28 GMT
Received: from [10.110.53.36] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 18 Sep
 2022 20:10:27 -0700
Message-ID: <2be5b57f-f367-2e28-c317-e0daedcfb3a4@quicinc.com>
Date:   Sun, 18 Sep 2022 20:10:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] scsi: ufs: Fix deadlocks between power management and
 error handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <dh0421.hwang@samsung.com>, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220916184220.867535-1-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <quic_asutoshd@quicinc.com>
In-Reply-To: <20220916184220.867535-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: UoEshqGsnWJsbg2Y_SP4q7tZ9z3kjs9O
X-Proofpoint-ORIG-GUID: UoEshqGsnWJsbg2Y_SP4q7tZ9z3kjs9O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_01,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=924 spamscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209190020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On 9/16/2022 11:42 AM, Bart Van Assche wrote:
> The following deadlocks have been observed on multiple test setups:
> 
> * ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>    holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>    latter function tries to obtain host_sem.
> This is a deadlock because blk_execute_rq() can't execute SCSI commands
> while the host is in the SHOST_RECOVERY state and because the error
> handler cannot make progress either.
> 
> * ufshcd_wl_runtime_resume() is waiting for blk_execute_rq() to finish
>    while it holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>    latter function calls pm_runtime_resume().
> This is a deadlock because of the same reason as the previous scenario.
> 
> Fix both deadlocks by not obtaining host_sem from the power management
> code paths. Removing the host_sem locking from the power management code
> is safe because the ufshcd_err_handler() is already serialized against
> SCSI command execution.
> 

Say, there's a PWR_FATAL error in ufshcd_wl_suspend().
Wouldn't there be a scenario in which the suspend and error handler may 
run simultaneously?
Do you see issues when that happens? How about when shutdown runs 
simulataneously with error handler?

-asd
