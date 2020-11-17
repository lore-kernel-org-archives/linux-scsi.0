Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D01C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E3B2468D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IOgPwRQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKQGIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 01:08:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQGIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 01:08:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH63ZVo195590;
        Tue, 17 Nov 2020 06:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8qGtTXxRyWI1xvsctCA6sELceOZDYlsMJQCIXV3suGA=;
 b=IOgPwRQUPmHCXbXIoXhiMSS3TWK00o+ZpeWUdKa09UoPlr61bhuEkwdVFtOgd+QiWeCl
 01+oxf/yGR5v//XYyItbxmbikKurlhs87PYKYaDywx5FMBGFnJePUkwC0oH+a91AcXIi
 csW8dYPfxqdiC17LDGZZ0WCVa3kJXnFuHfg/HHD+aSa/sjTx2GGLR2DBXBFSfkLGDdo3
 NT/puWkPO0vFMlGjFe/SGN58hVKEfDkKBdyWnme3frsrxelUGD16bxw0rRvkvrHNPOJp
 uoPd4EjK4tvrWSWy1MCT1xuJJEmknvGMTF/eqtHQZqmDkrlsMpHTbaMHAXkOVELWQC+D rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vn0nyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 06:08:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH65Fri161787;
        Tue, 17 Nov 2020 06:06:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34umcxr8cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 06:06:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH66daa011379;
        Tue, 17 Nov 2020 06:06:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 22:06:38 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Lee Duncan <leeman.duncan@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, Lee Duncan <lduncan@suse.com>,
        open-iscsi@googlegroups.com
Subject: Re: [PATCH v2] SCSI: libiscsi: fix NOP race condition
Date:   Tue, 17 Nov 2020 01:06:37 -0500
Message-Id: <160559316816.969.2361617121962261448.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106193317.16993-1-leeman.duncan@gmail.com>
References: <20201106193317.16993-1-leeman.duncan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=899 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=911 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170044
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 Nov 2020 11:33:17 -0800, Lee Duncan wrote:

> iSCSI NOPs are sometimes "lost", mistakenly sent to the
> user-land iscsid daemon instead of handled in the kernel,
> as they should be, resulting in a message from the daemon like:
> 
> > iscsid: Got nop in, but kernel supports nop handling.
> 
> This can occur because of the new forward- and back-locks,
> and the fact that an iSCSI NOP response can occur before
> processing of the NOP send is complete. This can result
> in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
> when the pointer is actually in the process of being set.
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: libiscsi: Fix NOP race condition
      https://git.kernel.org/mkp/scsi/c/fe0a8a95e713

-- 
Martin K. Petersen	Oracle Linux Engineering
