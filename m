Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4285E82CC3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjI0TeY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjI0TeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:34:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8012311F;
        Wed, 27 Sep 2023 12:34:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIxSG3000430;
        Wed, 27 Sep 2023 19:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=qp6r0KNYKhfIwjAFfVtUJ/2UXzflhI/nqAVx7WLm4nw=;
 b=SxM7IIyft6cyHtKls31YMyNgiLz5V4tY6OSu2kB1Q64cShS8OLLQqQwK9JwhCcR3P/oh
 HliG65eflfgPsVfRXEmys6I9FA3gbPPktgllf7eR6/serEduwjyq/22b/jnvHIUpbogn
 LjD98CMa5XBH+5jcEVa7AARXelE77POyX4KMig9DS77iYEJLv8ZTkKQOBMfOkYM8ccfX
 8dwknJopQNpqn79cld7InqJWE3L0XG6DlHbGkB8Je1xDSNr4Vvz4RFF3yXkDmUeaSrVs
 XlCejvPmLcfS9W9I0hygl9tmivhRcBHsKpGW/nG+bmsId0Rq4ORNuhg4x6zniAf6uxoA Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qwbjcsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RJM30C030588;
        Wed, 27 Sep 2023 19:34:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8cug7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:10 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38RJY90n008431;
        Wed, 27 Sep 2023 19:34:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t9pf8cub4-2;
        Wed, 27 Sep 2023 19:34:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Junxiao Bi <junxiao.bi@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        mchristi@redhat.com, bvanassche@acm.org
Subject: Re: [PATCH] scsi: target: fix deadlock by recursive locking
Date:   Wed, 27 Sep 2023 15:34:01 -0400
Message-Id: <169584315400.1272983.7452264401068350715.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230918225848.66463-1-junxiao.bi@oracle.com>
References: <20230918225848.66463-1-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270166
X-Proofpoint-GUID: 31DywKMYrOz6_REPEwNVkIbREluvmZfF
X-Proofpoint-ORIG-GUID: 31DywKMYrOz6_REPEwNVkIbREluvmZfF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Sep 2023 15:58:48 -0700, Junxiao Bi wrote:

> The following call trace shown a deadlock issue due to recursive locking
> of mutex "device_mutex" , first lock acquire in target_for_each_device()
> and second in target_free_device().
> 
>  PID: 148266   TASK: ffff8be21ffb5d00  CPU: 10   COMMAND: "iscsi_ttx"
>   #0 [ffffa2bfc9ec3b18] __schedule at ffffffffa8060e7f
>   #1 [ffffa2bfc9ec3ba0] schedule at ffffffffa8061224
>   #2 [ffffa2bfc9ec3bb8] schedule_preempt_disabled at ffffffffa80615ee
>   #3 [ffffa2bfc9ec3bc8] __mutex_lock at ffffffffa8062fd7
>   #4 [ffffa2bfc9ec3c40] __mutex_lock_slowpath at ffffffffa80631d3
>   #5 [ffffa2bfc9ec3c50] mutex_lock at ffffffffa806320c
>   #6 [ffffa2bfc9ec3c68] target_free_device at ffffffffc0935998 [target_core_mod]
>   #7 [ffffa2bfc9ec3c90] target_core_dev_release at ffffffffc092f975 [target_core_mod]
>   #8 [ffffa2bfc9ec3ca0] config_item_put at ffffffffa79d250f
>   #9 [ffffa2bfc9ec3cd0] config_item_put at ffffffffa79d2583
>  #10 [ffffa2bfc9ec3ce0] target_devices_idr_iter at ffffffffc0933f3a [target_core_mod]
>  #11 [ffffa2bfc9ec3d00] idr_for_each at ffffffffa803f6fc
>  #12 [ffffa2bfc9ec3d60] target_for_each_device at ffffffffc0935670 [target_core_mod]
>  #13 [ffffa2bfc9ec3d98] transport_deregister_session at ffffffffc0946408 [target_core_mod]
>  #14 [ffffa2bfc9ec3dc8] iscsit_close_session at ffffffffc09a44a6 [iscsi_target_mod]
>  #15 [ffffa2bfc9ec3df0] iscsit_close_connection at ffffffffc09a4a88 [iscsi_target_mod]
>  #16 [ffffa2bfc9ec3df8] finish_task_switch at ffffffffa76e5d07
>  #17 [ffffa2bfc9ec3e78] iscsit_take_action_for_connection_exit at ffffffffc0991c23 [iscsi_target_mod]
>  #18 [ffffa2bfc9ec3ea0] iscsi_target_tx_thread at ffffffffc09a403b [iscsi_target_mod]
>  #19 [ffffa2bfc9ec3f08] kthread at ffffffffa76d8080
>  #20 [ffffa2bfc9ec3f50] ret_from_fork at ffffffffa8200364
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: target: fix deadlock by recursive locking
      https://git.kernel.org/mkp/scsi/c/a154f5f643c6

-- 
Martin K. Petersen	Oracle Linux Engineering
