Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A92C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E93DB2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VtGMQjR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgETCc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:32:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39346 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgETCc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:32:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2W8sA126263;
        Wed, 20 May 2020 02:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/gwoAY/oY6fT+lJAj4PizAHEKa9k8e15AIIfY08kP30=;
 b=VtGMQjR6U6l8ThR2tZ6M8emjejXbH1kzfQThKr7udQ+TBjcapjygJuJDl9rvMehS3zFG
 3q4D3xZb51fj5F+5wqxNfr5wmTG9pcw5Ceogr6uZCLsLYq4cfy9JQXiKiXniMAit/yYg
 o+PV0NnYeHxPGLHiXs6HL+aKjiWrt+5nkAcWNgw5ASktOn8YE5DrbEjs7lehQ1FooHJO
 9IdxR3Is4UMTD9bWfRhwv/zVIyPdAFjpXVbaTgS28HadhwfHR/FYRc5TGwqYNL5B0zyg
 HzFirHPC79UJyQCy+CmPmRN0bqw9kr9fAQ6czOOJJqWTNgxBmVyRMdjGT5wii5DMw2oF 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tngj1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:32:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2T3Id052073;
        Wed, 20 May 2020 02:30:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3629pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K2UEmO027836;
        Wed, 20 May 2020 02:30:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:14 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 00/15] Fix qla2xxx endianness annotations
Date:   Tue, 19 May 2020 22:30:03 -0400
Message-Id: <158994171818.20861.11581994731205196049.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 May 2020 14:16:57 -0700, Bart Van Assche wrote:

> This patch series fixes the endianness annotations in the qla2xxx driver.
> Please consider this patch series for the v5.8 kernel.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[01/15] scsi: qla2xxx: Fix spelling of a variable name
        https://git.kernel.org/mkp/scsi/c/246ee22583ed
[02/15] scsi: qla2xxx: Suppress two recently introduced compiler warnings
        https://git.kernel.org/mkp/scsi/c/fbbc95a49d5b
[03/15] scsi: qla2xxx: Simplify the functions for dumping firmware
        https://git.kernel.org/mkp/scsi/c/8ae178760b23
[04/15] scsi: qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
        https://git.kernel.org/mkp/scsi/c/59d23cf3f2e4
[05/15] scsi: qla2xxx: Add more BUILD_BUG_ON() statements
        https://git.kernel.org/mkp/scsi/c/8a73a0e002b3
[06/15] scsi: qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
        https://git.kernel.org/mkp/scsi/c/66f863677715
[07/15] scsi: qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
        https://git.kernel.org/mkp/scsi/c/d9ab5f1f05fc
[08/15] scsi: qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
        https://git.kernel.org/mkp/scsi/c/e544b720ef31
[09/15] scsi: qla2xxx: Use register names instead of register offsets
        https://git.kernel.org/mkp/scsi/c/c38884162218
[10/15] scsi: qla2xxx: Fix the code that reads from mailbox registers
        https://git.kernel.org/mkp/scsi/c/37139da1b097
[11/15] scsi: qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into lower case
        https://git.kernel.org/mkp/scsi/c/04474d3a1c96
[12/15] scsi: qla2xxx: Cast explicitly to uint16_t / uint32_t
        https://git.kernel.org/mkp/scsi/c/ab053c09ee20
[13/15] scsi: qla2xxx: Use make_handle() instead of open-coding it
        https://git.kernel.org/mkp/scsi/c/2a4b684ab0aa
[14/15] scsi: qla2xxx: Fix endianness annotations in header files
        https://git.kernel.org/mkp/scsi/c/21038b0900d1
[15/15] scsi: qla2xxx: Fix endianness annotations in source files
        https://git.kernel.org/mkp/scsi/c/7ffa5b939751

-- 
Martin K. Petersen	Oracle Linux Engineering
