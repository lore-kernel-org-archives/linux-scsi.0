Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0170C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 889BF206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:11:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IKID3jas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRDLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:11:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgHRDLW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:11:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38Cd8134845;
        Tue, 18 Aug 2020 03:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=I0EZScj58NFxB2rOZIsCaKplUPsEex+PGqpJ94KUQoE=;
 b=IKID3jas0hbhdUhRWv+fIdsVg70Qcol+y8WkCR+BDM50RnJyx5/VgZul3ijyoGTF/e0Q
 R8Kl8LO6dmjyVLd3N4aOpy3KfUo/VNNZ2Fl1osBeR3hSdJZZqaGucuvPX+9N6lL56fDa
 JrWahQ49G+U26eyOtz1GoKU0iB9/AImvJsmSpoLQhg6NYWT1pw/hRMswoGXnwYO2qr4f
 MLl2b3jAUL5Py1Zv5hwEef80c8QvskXnThLLz7tFdZ/52Nem7/FdcXBRiarV175SzEn2
 Z4ecd3DrGFsbkkyWOrVzspX2RO44/JkjdDsKoMsO/LyQG5eOkD5YU1+p5o27xm4/9fG0 sQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r2790-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:11:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I38tls134387;
        Tue, 18 Aug 2020 03:11:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsmwp4wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:11:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3BG1c029250;
        Tue, 18 Aug 2020 03:11:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:11:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, nguyenb@codeaurora.org,
        linux-scsi@vger.kernel.org, hongwus@codeaurora.org,
        salyzyn@google.com, asutoshd@codeaurora.org,
        Can Guo <cang@codeaurora.org>, rnayak@codeaurora.org,
        saravanak@google.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 0/9] Fix up and simplify error recovery mechanism
Date:   Mon, 17 Aug 2020 23:11:10 -0400
Message-Id: <159772022967.19349.17899032606045774294.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
References: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=661 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=648
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 9 Aug 2020 05:15:46 -0700, Can Guo wrote:

> The changes have been tested with error injections of multiple error types (and
> all kinds of mixture of them) during runtime, e.g. hibern8 enter/ exit error,
> power mode change error and fatal/non-fatal error from IRQ context. During the
> test, error injections happen randomly across all contexts, e.g. clk scaling,
> clk gate/ungate, runtime suspend/resume and IRQ.
> 
> There are a few more fixes to resolve other minor problems based on the main
> change, such as LINERESET handling and racing btw error handler and system
> suspend/resume/shutdown, but they will be pushed after this series is taken,
> due to there are already too many lines in these changes.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/9] scsi: ufs: Add checks before setting clk-gating states
      https://git.kernel.org/mkp/scsi/c/2dec9475a402
[2/9] scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
      https://git.kernel.org/mkp/scsi/c/89dd87acd40a
[3/9] scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
      https://git.kernel.org/mkp/scsi/c/423cc66b5152
[4/9] scsi: ufs: Add some debug information to ufshcd_print_host_state()
      https://git.kernel.org/mkp/scsi/c/3f8af6044713
[5/9] scsi: ufs: Fix concurrency of error handler and other error recovery paths
      https://git.kernel.org/mkp/scsi/c/4db7a2360597
[6/9] scsi: ufs: Recover HBA runtime PM error in error handler
      https://git.kernel.org/mkp/scsi/c/c72e79c0ad2b
[7/9] scsi: ufs: Move dumps in IRQ handler to error handler
      https://git.kernel.org/mkp/scsi/c/c3be8d1ee1bf
[8/9] scsi: ufs: Fix a race condition between error handler and runtime PM ops
      https://git.kernel.org/mkp/scsi/c/5586dd8ea250
[9/9] scsi: ufs: Properly release resources if a task is aborted successfully
      https://git.kernel.org/mkp/scsi/c/35afe60929ab

-- 
Martin K. Petersen	Oracle Linux Engineering
