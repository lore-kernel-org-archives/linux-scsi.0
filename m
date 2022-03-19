Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCB5C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiCSD64 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiCSD6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7E6108544;
        Fri, 18 Mar 2022 20:57:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1vAVP027768;
        Sat, 19 Mar 2022 03:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=+Ph4OFt+3SrhMcCGxn1gvPn7gIbM0DtOHSGMh4qOOn0=;
 b=iH49+L2aEEZU6kJBs/+ywaC72hX7R9QgDoIqxpHY9VGs+B8iNKpbomwrXYljbM9Kh/Vo
 Fm+9vy6RUANaj/OPtXsB9/5JsbXZNek6QpZMVg+yqSA+LwWBEs7qx2X0yB/RBi/Ei16k
 zi6jJ63OGmpyarMuvUOis4YG+Y9hktfofty3tebI1qU2rxt7nIsZ7KEqBDTmPqYirpMo
 OcyGXgPf5ZisfHmWQv7Htd7pJVchdPoxBkL1cRI7Ub7gyXdQ1lQ+z2tHIhjkSizivqJh
 crivpJYucy8v8eGm4UzhavTIJQuFmhX5f18/Gt3UadOKgGjnXJpVaso7Ex6M0i/C8Hbf aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1r27k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3utTI007031;
        Sat, 19 Mar 2022 03:57:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qu007126;
        Sat, 19 Mar 2022 03:57:17 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-10;
        Sat, 19 Mar 2022 03:57:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mingzhe.zou@easystack.cn, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zoumingzhe@qq.com
Subject: Re: [PATCH v3] target: add iscsi/cpus_allowed_list in configfs
Date:   Fri, 18 Mar 2022 23:57:00 -0400
Message-Id: <164766213030.31329.5393511645473283160.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301075500.14266-1-mingzhe.zou@easystack.cn>
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn> <20220301075500.14266-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 3c-6AksHe6qvr493Slm86zZRyBwBAjEq
X-Proofpoint-ORIG-GUID: 3c-6AksHe6qvr493Slm86zZRyBwBAjEq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Mar 2022 15:55:00 +0800, mingzhe.zou@easystack.cn wrote:

> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> The RX/TX threads for iSCSI connection can be scheduled to
> any online cpus, and will not be rescheduled.
> 
> If bind other heavy load threads with iSCSI connection
> RX/TX thread to the same cpu, the iSCSI performance will
> be worse.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] target: add iscsi/cpus_allowed_list in configfs
      https://git.kernel.org/mkp/scsi/c/d72d827f2f26

-- 
Martin K. Petersen	Oracle Linux Engineering
