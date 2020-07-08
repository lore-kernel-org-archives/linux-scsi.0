Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BE7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 655C120786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFfxFaa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgGHGGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:06:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGHGGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:06:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06866XN4097283;
        Wed, 8 Jul 2020 06:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EQRDZSxH3P9AXrstlP0o/sGFYpCTTmrBI102enLn3Ww=;
 b=NFfxFaa8+YkZw+vqsNUULz6lpWkysHCZKnOSHB1ltwr5oKgiLLJmDMYOiz57podTOvIh
 LILa2YKoekPd9gcnpxRUnNEC+spoxe8wLcE+oMOan2i07ZWMU5gby7AgalzOtr4rBTJg
 8HOK+oenByzj0eQUuhAgrEzS4LBTWc1o10U6BSd1fbJoaNLPQUzh27Rf7lq+4s990/qO
 KgzqdXBbO/eDccForxBgYRAhmdClNuOeIB9fbOmT8EVj2Nyjza8P6lUTbgs+5XBr4ed/
 ZgvC4sMCFdP7VDajX5rnSTOgJK6K7PXTn1eXDTyYuELr5V7fTjI/1B/j2Lw5WDAT/NkY 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 323sxxvqft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:06:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685wGfd051251;
        Wed, 8 Jul 2020 06:04:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3233pycrwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:04:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06864UCT015537;
        Wed, 8 Jul 2020 06:04:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:04:29 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Schremmer, Steven" <Steve.Schremmer@netapp.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: add new device to devinfo and dh lists
Date:   Wed,  8 Jul 2020 02:04:29 -0400
Message-Id: <159418825072.5062.7085948150044772877.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <DM6PR06MB5276CCA765336BD312C4282E8C660@DM6PR06MB5276.namprd06.prod.outlook.com>
References: <DM6PR06MB5276CCA765336BD312C4282E8C660@DM6PR06MB5276.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Jul 2020 17:07:22 +0000, Schremmer, Steven wrote:

> Add FUJITSU ETERNUS_AHB

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: dh: Add Fujitsu device to devinfo and dh lists
      https://git.kernel.org/mkp/scsi/c/e094fd346021

-- 
Martin K. Petersen	Oracle Linux Engineering
