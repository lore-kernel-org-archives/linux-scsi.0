Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D86C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3807F20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ntQrKlKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgEHCzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:55:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgEHCy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482roCP085506;
        Fri, 8 May 2020 02:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=we1RlzBQtXyuKEV30plxNOnqn5UWC94kcqo/kdExbe0=;
 b=ntQrKlKOrssBXoc3M18qAqDFazNT8kqMp/BCOiYuyl0iHKN/T5diyP9WbwwsnJER/pJ2
 jeT4OacigHpB+kbBk5qDhyvN7AJ3MnBTqHhcfpAOqSX3cdoKFUbyeavpD4V/65zOJQQv
 s0dmHAbY97S1pGd4+8/vupZ0EuWUde7c7+TYISsR1gKWWXYBFBFkA5JGWfInISp9JgFk
 c2svvWpejlpymsuTA7zjiDHQ3eMpOZq6ZvoFBIADrRz8CWNfUrt437J1n6HqiJ7OGpZr
 aV+9EWEcxaGwGasnLmC98NYxzB+8VqBPvSWwrm31p4XIDJzmFJlUcbfUP13gYIvU8lAj +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30vtexrrm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482pbL3075925;
        Fri, 8 May 2020 02:54:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30vtdxwpne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:48 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sm7T028869;
        Fri, 8 May 2020 02:54:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:48 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>,
        njavali@marvell.com, himanshu.madhani@oracle.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, aeasi@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: use true,false for need_mpi_reset
Date:   Thu,  7 May 2020 22:54:34 -0400
Message-Id: <158890633244.6466.15678074842768814125.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121751.15232-1-yanaijie@huawei.com>
References: <20200430121751.15232-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:17:51 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_tmpl.c:1031:6-20: WARNING: Assignment of 0/1 to
> bool variable
> drivers/scsi/qla2xxx/qla_tmpl.c:1062:3-17: WARNING: Assignment of 0/1 to
> bool variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Use true, false for need_mpi_reset
      https://git.kernel.org/mkp/scsi/c/bda552a7741a

-- 
Martin K. Petersen	Oracle Linux Engineering
