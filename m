Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82DEC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 03:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJRDwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRDwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 23:52:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D81D2;
        Mon, 17 Oct 2022 20:52:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HNYXqk019050;
        Tue, 18 Oct 2022 03:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=dXbOF6y7Fymm6S7gnJoAODCMCuVVw69/y7GC1AGShNs=;
 b=IYHe1LFE5b8KxNjMafWDYPrD+PxPezpPKUE11CFb/orXIfrn6pJlL98DVGNpi1hRiOPv
 UTtzSp0wpgFwY4u+Ejhy7oxFBFc9OkixdeR4HYnZBPoYh7Q2dnahVzmf5NSr6IyUKNL7
 98Vr/a30JG9u1iBLW/x2r2Fnrqj14NdmZ6MbEVlqIm5YlBh1H3CcZaotxKAhKJQ5hWDQ
 iw4GGgYjytGZrD3P8u7yWXasT95VOyDE1U8WUaZFpzGOyKJp8hcnjJ1nV1L6rsL8cS88
 AA5TrtfhiTlbbM+eiVHHgIi9uHlDv/ESLY4vHn+3W9/DhSXdoI1rSxux1960xQuq6UnI sw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtds2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:52:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29I3msCr036409;
        Tue, 18 Oct 2022 03:52:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htff2b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:52:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29I3q8fc029581;
        Tue, 18 Oct 2022 03:52:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htff2b0-1;
        Tue, 18 Oct 2022 03:52:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <jsmart2021@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix memory leak in lpfc_create_port()
Date:   Mon, 17 Oct 2022 23:52:06 -0400
Message-Id: <166606442644.2366633.17731582434457392560.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220916035908.712799-1-rafaelmendsr@gmail.com>
References: <20220916035908.712799-1-rafaelmendsr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180020
X-Proofpoint-ORIG-GUID: aJ2bWeYo6InoIuBytI8D5GRzxwEhAC-D
X-Proofpoint-GUID: aJ2bWeYo6InoIuBytI8D5GRzxwEhAC-D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Sep 2022 00:59:07 -0300, Rafael Mendonca wrote:

> Commit 5e633302ace1 ("scsi: lpfc: vmid: Add support for VMID in mailbox
> command") introduced allocations for the VMID resources in
> lpfc_create_port() after the call to scsi_host_alloc(). Upon failure on the
> VMID allocations, the new code would branch to the 'out' label, which
> returns NULL without unwinding anything, thus skipping the call to
> scsi_host_put().
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix memory leak in lpfc_create_port()
      https://git.kernel.org/mkp/scsi/c/dc8e483f684a

-- 
Martin K. Petersen	Oracle Linux Engineering
