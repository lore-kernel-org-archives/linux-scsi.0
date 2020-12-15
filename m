Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA590C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 21:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997C022A99
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 21:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgLOVyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:54:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731252AbgLOVyo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 16:54:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFLoIEr113148;
        Tue, 15 Dec 2020 21:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Uq1qPkzs9ZAZqFms4dn1z4pI2VbMZRUG1BvjyIGWjIE=;
 b=cEDtfNoesqe+A02G71Hu+J4PGlDUoq8HRCWYvdxlxzBDDP5Z97vMYnG3O3QDB5MBeuHs
 htWcWuUUGE+T8ZzqWXi2I0XfA+RrDuzzbbcKtix9QWpM9ZhHkqAbrCJw6ZDyiVg10/uy
 F61i2BLhSLsjK9hXXYNECqFSVCL3dSA9kgXgwEJDpeBm9ekE0PkdPrnR4nJZhnCdVrrQ
 1ulO66fgLUvVuEnbUG8/WBdqL7I66cAyMQAdNuLTUK70L/9/4NGT0x4mxwZ/0gNoQCeF
 rOmKDchyAUsuPYpDZOlxmdYg73zUloRznkj5Vg6J5b7HPX0zhYoGnARqn+QW66ZEKntg ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9rd065-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 21:53:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFLjAP0169132;
        Tue, 15 Dec 2020 21:53:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35e6jrrvk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 21:53:38 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BFLra6t020380;
        Tue, 15 Dec 2020 21:53:36 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 13:53:36 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/3] iscsi cmd lifetime fixups/cleanups
Date:   Tue, 15 Dec 2020 15:53:27 -0600
Message-Id: <1608069210-5755-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=483 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=508
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. Martin's staging
branches were missing fe0a8a95e7134d0b44cd407bc0085b9ba8d8fe31.

The patches are mix of cleanups and fixups. The first patch is
just a fix that was in the same code path as the second.

The second patch was originally mode to drop the taskqueuelock use, but
it also moved the running cmd cleanup code to the failure functions.

The 3rd patch then takes a ref to the cmd in the EH and timer paths
and utilizes the running cmd cleanup from the 2nd patch to handle
an issue in bnx2i where it wants to sleep in the cleanup_task callout
and needs to know what locks are held.

