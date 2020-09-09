Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032E3C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3274216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MOb4NoVg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIICT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:19:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729767AbgIICTz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:19:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892JFin151344;
        Wed, 9 Sep 2020 02:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=8z0P0AS/f2LF+BEt4qDLPU1NT1ZkRDsA+a8DIPIst2c=;
 b=MOb4NoVgOSU+X4ZKh6VxypqNT79ZKf9gOgwD7TuxmrgkslCsnewqucSJiwaTTIanVenl
 td7wG7okrcJ+6uqcPHPfi+9Be0e2yRkcjqDafip+KK8yOXAM0kXCPIrGBYNe09QH5TT8
 WVIeaogXcs2Zdla5cfLEPucBQZbbyaHFnBCY87BRhnaUZ6oX/OTHipJyhDS7ZLn/geyG
 E5HHHCyUeJTKQMWriewcxuXdNih5CSXSQ3qdJMAx4htMjWfkxwpsV2Q8r3B0B9JZTVLL
 a9QrSY+F+YrFM4mX4uDxs3mRCualRDpnrRJGIS2IBZY5UFa7lRWaUFSciqiJF/UBETz1 BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23qy121-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:19:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892GKC5025846;
        Wed, 9 Sep 2020 02:17:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmkwwtnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892HXsL009559;
        Wed, 9 Sep 2020 02:17:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:32 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Neukum <oliver@neukum.org>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: dc395x: use %*ph to print small buffer
Date:   Tue,  8 Sep 2020 22:17:21 -0400
Message-Id: <159961781205.6233.5848582078618226004.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730153535.39691-1-andriy.shevchenko@linux.intel.com>
References: <20200730153535.39691-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=948 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=981 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Jul 2020 18:35:35 +0300, Andy Shevchenko wrote:

> Use %*ph format to print small buffer as hex string.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: dc395x: Use %*ph to print small buffer
      https://git.kernel.org/mkp/scsi/c/ca358af1d1bb

-- 
Martin K. Petersen	Oracle Linux Engineering
