Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FE4C43331
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE5D21835
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GinyV/YK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbfIGTj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 15:39:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfIGTj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2019 15:39:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Jcqfw127778;
        Sat, 7 Sep 2019 19:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=FRotqNuZcLBAApp31AKP4PClMJSgxSOZtHKAbGlbc24=;
 b=GinyV/YK8shE/an9a2eeNsNLPHsUKTswmi4aymxBRt9Rlp8sFy8sE074XXyY4ao5O9ZI
 Lmt0XpVoFgO/tA0tryDozM9Qebs768xQYK1OVVBvc3MIWThV9RfCW6J97CaMz/TADE86
 pEfcy2W63ReLrORPNCWwsshEtlSmsyfYxrz7uPm/Dqi38UIm0OrCLP4jL5SE0VjMR/dZ
 zPMNPNrZV5LRxvMswvA9zaiX1JkQZip3GJgUiMtSbQsRlPpuZe81uZm4eQIGNLQskDxg
 ZrxqN95GM7hskWjYx/shXcanuqsFF1dsxPxtT+n49PS23TyonmSfYBU9mOWfHU6TC1D6 bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uvjqc00gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:39:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Jcp6C195402;
        Sat, 7 Sep 2019 19:39:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uv4d0ejrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:39:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87Jdgrf019289;
        Sat, 7 Sep 2019 19:39:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 12:39:42 -0700
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/6] qla2xxx: Bug fixes for the driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190830222402.23688-1-hmadhani@marvell.com>
Date:   Sat, 07 Sep 2019 15:39:37 -0400
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Fri, 30 Aug 2019 15:23:56 -0700")
Message-ID: <yq1tv9nki9y.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=619
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=687 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070213
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> This series has few bug fixes for the driver.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
