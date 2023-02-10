Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61250C636D4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 20:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjBJUKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 15:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjBJUKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 15:10:00 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4333079B3C
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:09:58 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AJH31w013183;
        Fri, 10 Feb 2023 20:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=iV/jlAKCej1UUgxtdI1nDk7MKKWy7g7Wd7plO/dOsao=;
 b=m1hbJX3//Ya8OhDI2gB0codQeQuFZeCBhCGjwvYPHsAeUanL6y6sTv8clWgf2jNTq9fK
 yeE2ooJUuzumSx5CeZxJiX1qmMjDG3N6oV5RG3uRtDXPL/HDwWWEUlZeMkiKSt+X27Ky
 08c+romcTmwskRhBNPRERWVJK6vm1aIPyliyg428mVIpm8wUAT4Tr5fTch+gBD/mk+1r
 rZVV78oWehGgpUxHEduJy1Y1FdDprvyj9BQHVCPyOCTeR2IzYUveDd6iTGuh3X9Ygpv1
 Shr6JJtet1C3/KeHyEhGUQ4UHZ6cM7hrgmCbNK/PWuK8nhfgXJbvNTdYPTlmXNKbrjF8 gg== 
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nndu5a3sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 20:09:43 +0000
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31AK9ghu022542
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 20:09:42 GMT
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 10 Feb 2023 12:09:40 -0800
Date:   Fri, 10 Feb 2023 12:09:40 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH v3 3/3] scsi: ufs: Simplify ufshcd_execute_start_stop()
Message-ID: <20230210200940.GB28076@asutoshd-linux1.qualcomm.com>
References: <20230210193258.4004923-1-bvanassche@acm.org>
 <20230210193258.4004923-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20230210193258.4004923-4-bvanassche@acm.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: wJneotuuZEwp6cva3YxA7srXRQxMArd-
X-Proofpoint-GUID: wJneotuuZEwp6cva3YxA7srXRQxMArd-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1011 malwarescore=0 suspectscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100171
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 10 2023 at 11:33 -0800, Bart Van Assche wrote:
>Use scsi_execute_cmd() instead of open-coding it.
>
>Cc: Mike Christie <michael.christie@oracle.com>
>Cc: John Garry <john.g.garry@oracle.com>

Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>

>Reviewed-by: John Garry <john.g.garry@oracle.com>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---
> drivers/ufs/core/ufshcd.c | 35 ++++++++---------------------------
> 1 file changed, 8 insertions(+), 27 deletions(-)
>
>diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>index 293933806ffa..cb59f6b55cfd 100644
>--- a/drivers/ufs/core/ufshcd.c
>+++ b/drivers/ufs/core/ufshcd.c
>@@ -9125,34 +9125,15 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
> 				     enum ufs_dev_pwr_mode pwr_mode,
> 				     struct scsi_sense_hdr *sshdr)
> {
>-	unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
>-	struct request *req;
>-	struct scsi_cmnd *scmd;
>-	int ret;
>-
>-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>-				 BLK_MQ_REQ_PM);
>-	if (IS_ERR(req))
>-		return PTR_ERR(req);
>-
>-	scmd = blk_mq_rq_to_pdu(req);
>-	scmd->cmd_len = COMMAND_SIZE(cdb[0]);
>-	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
>-	scmd->allowed = 0/*retries*/;
>-	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
>-	req->timeout = 1 * HZ;
>-	req->rq_flags |= RQF_QUIET;
>-
>-	blk_execute_rq(req, /*at_head=*/true);
>-
>-	if (sshdr)
>-		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
>-				     sshdr);
>-	ret = scmd->result;
>-
>-	blk_mq_free_request(req);
>+	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
>+	const struct scsi_exec_args args = {
>+		.sshdr = sshdr,
>+		.req_flags = BLK_MQ_REQ_PM,
>+		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
>+	};
>
>-	return ret;
>+	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
>+			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
> }
>
> /**
