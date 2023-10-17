Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC061CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbjJQBMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbjJQBMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4119A2;
        Mon, 16 Oct 2023 18:12:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKONsQ014525;
        Tue, 17 Oct 2023 01:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=4nn6arpeOCkk/odUBoEXAIkPUKRARCOeDck0QnPjgc4=;
 b=3YxR4jsgme/wHDJs9TXB7pUFfbnIVgQD4S2v8Id2zWOavVO3I9qlIJSFsJQj1SE6lKKl
 dzuqUeJxTH1j9reYuHSCbBsYujnec+/mhELTXdPO5fQabUt2um82PAxv4dkDv79yINQs
 qw5lvAZ+Q768LtaJsn0gwBjmFK+wC05IkDNokzIQdp042gPvgFAM26VbEGgF4nEena/A
 zuUvVecw2cptdZUH0VE14nHwK8WYwMhWKPiLUXzCfADcfmpS/N2nA8SxRi6UElXygGmP
 9U97QJrX2T8kKIfNY65QT9oDGBuQEm46aJ4y/KyIY/f0Hr4w+OjPX2tPYhuacMXqoApZ Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu41s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMeXsi027313;
        Tue, 17 Oct 2023 01:12:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:09 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3ss039761;
        Tue, 17 Oct 2023 01:12:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-7;
        Tue, 17 Oct 2023 01:12:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/8] scsi: target: Allow userspace to config cmd submission
Date:   Mon, 16 Oct 2023 21:11:54 -0400
Message-Id: <169750286921.2183937.2967082048198278582.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <1b1f7a5c-0988-45f9-b103-dfed2c0405b1@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com> <1b1f7a5c-0988-45f9-b103-dfed2c0405b1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: YWM5iijyPk4zfPbnM24VCQdnRcXBFI7u
X-Proofpoint-ORIG-GUID: YWM5iijyPk4zfPbnM24VCQdnRcXBFI7u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 Sep 2023 21:31:32 -0500, Mike Christie wrote:

> The following patches were made over Linus's tree but apply over Martin's
> branches. They allow userspace to configure how fabric drivers submit cmds
> to backend drivers.
> 
> Right now loop and vhost use a worker thread, and the other drivers submit
> from the contexts they receive/process the cmd from. For multiple LUN
> cases where the target can queue more cmds than the backend can handle
> then deferring to a worker thread is safest because the backend driver can
> block when doing things like waiting for a free request/tag. Deferring also
> helps when the target has to handle transport level requests from the
> recv context.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/8] scsi: target: Make write_pending_must_be_called a bit field
      https://git.kernel.org/mkp/scsi/c/40ddd6df93a3
[2/8] scsi: target: Have drivers report if they support direct submissions
      https://git.kernel.org/mkp/scsi/c/194605d45dcb
[3/8] target: Move core_alua_check_nonop_delay call
      https://git.kernel.org/mkp/scsi/c/ee48345e1cca
[4/8] target: Move buffer clearing hack
      https://git.kernel.org/mkp/scsi/c/5c48a4ea3280
[5/8] target: Kill transport_handle_cdb_direct
      https://git.kernel.org/mkp/scsi/c/428926796e7f
[6/8] scsi: target: Allow userspace to request direct submissions
      https://git.kernel.org/mkp/scsi/c/e2f4ea40138e
[7/8] scsi: target: Unexport target_queue_submission
      https://git.kernel.org/mkp/scsi/c/e344c00e7ccd
[8/8] scsi: target: Export fabric driver direct submit settings
      https://git.kernel.org/mkp/scsi/c/6dbc829d101d

-- 
Martin K. Petersen	Oracle Linux Engineering
