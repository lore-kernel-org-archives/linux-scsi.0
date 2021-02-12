Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52480C4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C0064E57
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBLH1s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:27:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhBLH1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OeOD016620;
        Fri, 12 Feb 2021 07:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=OPcT//Kq3cYrLapZOgfJNb3G5rpW402u5X2h4TMCZm0=;
 b=af5yYbgGLisEhkNWvovDuiTLsa1jpTtlXAC5YrExN1+/f1Ju5QzIje2ycCxlLqKl3xne
 e3GRTHpEsMcmntFaJ+FyLag15pUnVLYXh9T0WcYvB8dvQ4oHaGCQwIjDDdR1xMfpO4TO
 rO3IabOSwY1mTlPgRvCCVr1wuRWKJZGdEqt5CudxviONyo+mDlgBBIldj5i1bEF5/EH+
 y6x4IvYSB1LuqLBEdR8pudbKFW6ZWVQqSn2FcsOPfeDrMZuU5YMNXmD4mVte1slI8DgX
 yYe/W4DbsTOXuQdoTx8wjenAmGS2m1IlNtsZF1kruj1iueTFsh++clKuWF9fCCD6Lqyx ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36mv9dvcu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdO022757;
        Fri, 12 Feb 2021 07:26:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 36j5155a2x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEMBVrYn7sGLOpDzY2Vy/2o3qYFziug4d/w5CJeTfOzqAcXc4hcd2TyLkfknOeY0goaRkSGiXjoFsl0linoBO47NK/m9klONFnQvoYgQEHVsOGrPtW8R1Fx8OEmIlC2Bj3fdZ8aNd+82eXfwwTOMiD+rfL8twsFvgy6CE3iGzPKBNkJNCRJ7Kf7VVvdtk88RMbfZ8FJYYbBk3GiR5RveUDp8X1ApIX/XGqrKG2pJLi931jN0w4xNVrT1AE3y4nVYlZooiIWC3qT+aoN9I0WwBo2K/l2lxG5WhHBHiBIXVVwf78CgmNfLhZxXX1y/d2vrWTPynD8rsA24wmfPbFis6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPcT//Kq3cYrLapZOgfJNb3G5rpW402u5X2h4TMCZm0=;
 b=cfcjwo7uDWjUBb2CEIwQ1Zui/ntPV3AIjyF974Dt/wbmNWypuDN4BfKvTWh5aSV5pWmezb+XcRXgg/mEfIK4jNQj0Hm5hlsTo03IwLxZ29vxrLLrBxDUV6bKWgn5LrDCfjfEzJc7bwuyEyBvy1cnzJj+Kcul+sqaezzoA405u5ixANf5ZCKlLMAZi9qxcEuLXdSEumNmV7bFVUNhrGUl1+kCFOwFUQbHqTrPMwyH1jkuhYhKbOmLpUiaLEbCKR2/Jz9nwahIdMdRhIMiRvvVF25Q9lkLJhKOw4tvpwpy/xzmNx5SwttWB17AcuyxrLyL+kAWSeb2jNnozmgdqQEJPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPcT//Kq3cYrLapZOgfJNb3G5rpW402u5X2h4TMCZm0=;
 b=MxQXUAQRbRfP/dzT8j7ftnRmyJJh+OFYE0gg9pJbh1t4HL5h3YOC+oyg+O6D7GzvaRqoxuNtXDx9OKZJOed6wHnMpyKGO88S/Pg/K3YrG4S2+akZ1Ve1k0utFUQyDo6uYt9KuLSBz9BJgieocUFeTFcHMpV14lGHdu3hEpEQQrg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5256.namprd10.prod.outlook.com (2603:10b6:408:12f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 07:26:54 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/25] target: drop kref_get_unless_zero in target_get_sess_cmd
Date:   Fri, 12 Feb 2021 01:26:19 -0600
Message-Id: <20210212072642.17520-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd50580b-32ab-4d28-c100-08d8cf2791d6
X-MS-TrafficTypeDiagnostic: BN0PR10MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5256E3DF9063158C3DE3154EF18B9@BN0PR10MB5256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: en7kcFhbcfJKk09hNOj7A54jaVv9gd8e4nZYc33ArA8lLdsmsZiHMO9ajAbamWBVe/ObamCRTjkYScLc8jjM9ayK/mIypTq23X/iAYl2ucSKSLZdl+YyGYA4NbCiwkwbq3ALi7gkhRZp01gFAc++shTxiDeEtZqx//8cZGxVbhCopWACoeETOGljDhzOiS4DVBvNQlLQG7W4Mk7XFCYZiRHqlk6Awt3jv26AcZnVnvEh706mCMYf2iRh1k9QmTEUvEXJ6bUK81lVeU7AxnGEejjebxKzq4VEnQQ+XWuRHbzBfCVuYTf4brVObVwPUdH+nHHPCX6hEuTDxucaBmQu1gFG36RSyJL0+zIUG27+H6J/Vwiw32eKqu1tETvUGcw0P5T99nGABhJ+0WhMLXKv4lCPPCl8eg+8WlumM07LulajBzWTWGS5z/d8R4//zJMFFLoIPzRkFiJkMU9fSx8gBNbnQwwlpeEdPVVB6Ab/q8RV/nSV9k/8WQH9ATMuRyXgtXIToJa7taEuuFgs5nKAtbOLhqB3Hlmv7eGTIaO4C2xk593RNNt+E+wNw7ir8TDjxWsW7/pYIU67rCtTVNYSHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(478600001)(1076003)(107886003)(6512007)(83380400001)(8676002)(66556008)(5660300002)(316002)(66476007)(6666004)(8936002)(69590400011)(4326008)(36756003)(86362001)(6506007)(16526019)(2906002)(186003)(2616005)(956004)(6486002)(52116002)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hZhvFHtSNcYgnukz9aRhCpTmmOvlVYYZ7gYpyO6RFv7+K1YyGyOovEgOoIvy?=
 =?us-ascii?Q?YO2hHJ2wC+o0MXnW0L04F05v6c4bIUtDyp6LfUCckc5YqTRkcMbtcDbiqxV2?=
 =?us-ascii?Q?dqmeOUEN8JCXImw0mERZE3l9wuHB+l9MgE9+EeKSMtSXYKbFctyd0bL0PTxP?=
 =?us-ascii?Q?ORzUWexBy6SZ1liD7UYFJowslMMs9MYcGS4dH5eM4WQQAelMuOgcmqesENEc?=
 =?us-ascii?Q?7kdV+sgLXbdyvlmYyzs5Cd23nEPeyDr6lUDle+a7bYSm6DmI1OecQc1Q6Fmy?=
 =?us-ascii?Q?7zaIyxgGbHX1BkZ6QZhrK5tcjk7ENXVzDrNDmmhUvrb8jhCsYAwjJqhGnjpk?=
 =?us-ascii?Q?4Cp0ec+sFNkp2oEU01nAk29exPwGDVj2bk87jJFCEqoup/NeoRL1g6M83QQK?=
 =?us-ascii?Q?zPJTJ/X8SVijnYedxXi6UUghoLqBd/jSkRiRRBRmlg1q5McarQRtk05C4bl6?=
 =?us-ascii?Q?rkrSHEoriDihustk79ScPPxWb6F+WQ3tP6eoVEY1yfIXkR5droIFm9FnOoAB?=
 =?us-ascii?Q?Z0kQ2DquSk0f9aM2b2fNvhsw6HwCOjdB0WISa3NXjIN56k+xc4pewW0muNll?=
 =?us-ascii?Q?jcbQq5KlD/l0i8OVBO5WNi5U/QR2V638brYByhKz6b6KPwfLlx+prkSzrztg?=
 =?us-ascii?Q?Pu6FbZMccyLYjkd26j5tGR/ILsHslL36KL/NOeHP9oC2VvNrmqE4Yh+4weAm?=
 =?us-ascii?Q?dm//k128IfwNbS67yTWhPg8r0G+kkxQmHv1bkkpMwPNRa+gCP1tR7zrnUgAE?=
 =?us-ascii?Q?YuHCj414WMyKlE6peleAkribJXzQRxlr0FsZZZRcv+1Bfc8F0AF/DJXzDdTC?=
 =?us-ascii?Q?sPO9fksQRFoXiyCEWBK4Zx/rEcqfZO4uTquvZ6KgRihOolHx3i6bKrQRWF47?=
 =?us-ascii?Q?rey9W0UMxL1yJlnDCg1p/xXcyAf+yL2/2ldsRfNczA0SRHrr96zpYT1HBoeu?=
 =?us-ascii?Q?tN5aiS3JHwzA5gm2dq1yPfqswlLr2UhzQK4oiIBdcltKxSPfY2iMwDPc9pKj?=
 =?us-ascii?Q?/PNgu3jFXvxMYfcS06kOpqEC9Gp3H/nxKpIyHJ0C+qZkzui7L1FPmkmwRXvB?=
 =?us-ascii?Q?uzlh4tCxiPVKGjAp4zQeCFRBCCWpfqFR+gfDsLNXFKXRMWcKjwCRYkLk4fqT?=
 =?us-ascii?Q?cBSLuRWOoh3kjwblqENpmKq+cr7RlywCOfRxzTVAEPzNn3N6jqAYt6CZhsNg?=
 =?us-ascii?Q?4Ucz7jksi+xZD3J+kYeh65fOPlpwidQrpYN/grrPz0rVk/q/5xEmhLZNRTIZ?=
 =?us-ascii?Q?t5aYdSATYccPnsNYlPVgifTSFktkEggge6liHGISlccFcal729ASaxCbJOkd?=
 =?us-ascii?Q?suu+Ch/IxSt6rNilpXBD8M1K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd50580b-32ab-4d28-c100-08d8cf2791d6
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:53.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Q7l7Vl9sj+TzXYbttKFtU1EmLsTQ9UksdIH/tEhBrfmZR1sX2C/tMbKJSdxHKmidNYEQmtsc6cC5ONRK5BxZEHArhCS7eMDgcyDGjX3Lx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5256
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The kref_get_unless_zero use in target_get_sess_cmd was added
in:

commit 1b4c59b7a1d0 ("target: fix potential race window in
target_sess_cmd_list_waiting()")'

but it does not seem to do anything.

I think the original patch might have thought we could have added the
cmd to the sess_wait_list and then target_wait_for_sess_cmds could
do a put before target_get_sess_cmd did it's get. That wouldn't
happen because we do the get first then grab the sess lock and put
it on the list.

It's also not needed now, because the sess_cmd_list does not exist
anymore and we instead wait on the session cmd_count.

The other problem with the patch is that several
target_submit_cmd_map_sgls/ target_submit_cmd callers do not handle the
error case properly if it were to ever happen. These drivers think
they have their normal refcount on the cmd and in many cases do a
transport_generic_free_cmd plus target_put_sess_cmd so they would
have fired off the refcount WARN/BUGs.

So this patch just changes the kref_get_unless_zero to kref_get.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5c4adde96d5e..b5427e26187b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2775,9 +2775,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * invocations before se_cmd descriptor release.
 	 */
 	if (ack_kref) {
-		if (!kref_get_unless_zero(&se_cmd->cmd_kref))
-			return -EINVAL;
-
+		kref_get(&se_cmd->cmd_kref);
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-- 
2.25.1

