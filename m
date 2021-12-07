Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C544C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhLGDti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:49:38 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51294 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234400AbhLGDth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:49:37 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5QxS007515;
        Tue, 7 Dec 2021 03:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=6wwSwNUgVj2Ev5beMseNXyDbXFQuvT5af1nOuNidQx0=;
 b=aJK5UioZCGL3rivHekH6M/kiPz/pC1+ZCdChL05ujV4l6UqBsJg7qzuJFdaYexmeQIdz
 Jz3HfB0fIdhiBajXm5Vn77K7i6uj+cNlzk/CqgEMG6c9dVVhpK+EGuQlEOJWeyd/VpVz
 0cuq/C4IfGyV75TZJQyLWxxcbMTX5jY+0EKlGsiclVHLoSE7bOLfYWHtD8Ls5S/D8Ezq
 0EXqj7gg2ZgoS+Bo2ZJgH3jNfbtBkEhzQdAaySobU92TX4SkNCQd6WlEq6ZcxGXXM8Ao
 jskcf9P1gyfGlX3CWluT5b9lY7/ubkLMz3oCxd5wmty81JTK5dsDLasuchxd6aPF9XWe 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csd2ybx86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73f8dw174083;
        Tue, 7 Dec 2021 03:46:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cqwex0gkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:01 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B73jxGD183597;
        Tue, 7 Dec 2021 03:46:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cqwex0ghy-3;
        Tue, 07 Dec 2021 03:46:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Date:   Mon,  6 Dec 2021 22:45:58 -0500
Message-Id: <163884867622.17909.1946233652743457156.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207010638.124280-1-shinichiro.kawasaki@wdc.com>
References: <20211207010638.124280-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ZJJat91wN445n3NKDcuUKlx4Ldp7r4on
X-Proofpoint-ORIG-GUID: ZJJat91wN445n3NKDcuUKlx4Ldp7r4on
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Dec 2021 10:06:38 +0900, Shin'ichiro Kawasaki wrote:

> According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
> field of REPORT ZONES command is byte. However, current scsi_debug
> implementation handles it as number of zones to calculate buffer size to
> report zones. When the ALLOCATION LENGTH has a large number, this
> results in too large buffer size and causes memory allocation failure.
> Fix the failure by handling ALLOCATION LENGTH as byte unit.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
      https://git.kernel.org/mkp/scsi/c/7db0e0c8190a

-- 
Martin K. Petersen	Oracle Linux Engineering
