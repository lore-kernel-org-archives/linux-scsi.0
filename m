Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B93C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 04:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EF564E4D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 04:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhBCEYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 23:24:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBCEW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 23:22:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131YGX6176450;
        Wed, 3 Feb 2021 01:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=lhuarnQvidk8P0thXAco8oAVqVUCy1ANRL1lDcoJIFMU7R6qwerLtA9QXdBaIEUmXYeQ
 w0ym1jt4W/ZHnGLGJcKtpC0rOTtOYCHETOH8qdLuGwHo9YSL0fdOYy5RSG9qhpI/RV/o
 ePJvKU2rHE3DuO4iBITzMzJ3NWz/WxnuCdfQBpiI/Izncv3nI1Co7Bww+IgWnjpViQ4D
 8ph4RDV1Jl86cA1lw9KRdlfZBREktvShuw4DHMdelE6jz7Hqi5Ey+PJr3wxG48IwXWVd
 B92DXyM+a5QKc3HeQ2bB+4ehQFhsTYcKjwQPyUljP5QCfhAsQxEltThpRwPbn0Azx4U6 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36dn4wkgge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131P0tD139770;
        Wed, 3 Feb 2021 01:34:15 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by aserp3020.oracle.com with ESMTP id 36dhc05qhs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwKS4TA7SMAplN9IHVyIketGeK5O84r8e1XsmeiGsc4uh1rMyM9AsD17wb42ryQxUh1ujnV05jw8uZ6NMCEsy+nOKieHEV5p8MWUplNHD+CvZOgN7dxXdOxohoOVjt9R4YzG+qaVN474/Soqlw/FwxFqh0JEjXMyo4dT/fcSGLuFQk+mtwLA3cqEu8H3DIfCUTaV+D5vkUdc11KDNyOzDPPMugtxc6CGUen1ja9zIGXrCVFwaDBksBnvDyGiLoYmkNlvMo9sXaIr0gnD+DmPSk8MnRLcniVZKkOdUxTr46S4s4fPPiyj1wo74M+jniVJfDlh+oMjiYl0Ep/KG2rCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=kfELyhTYbvTBrDI0QtkVrYFAtpusN+LxY1kFYTio5r/u0GTaYlyqRNb/8ULPExdLkl/1CdD2fQUukiWd8aJjKwwYlOi/6n0iDcE+PPUBPPo08VAr6QDVdaIgfzCSSfm1ZjN8RYzVWrazjnzi4+mrp1rfh+pxnJImSXNN1ux9v0+c+x+6OtRr85NdOx9Rupw640jd18tAb+6fjuCT7mE/IEL7F4d9zKKEbojs0fEryAJLYSHX0J/6YYFwzc2e25XjQ6IDAN8sLh6Meypr9vzaXEFpwdKMBInO9FRmtNzGcacocFgRgsuX1L/8rlVXIzmQdFbviQzgvERNMecEv9sDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXpkNI9ZCemkBtXM+CZByGVCLY9xVWUkdF5WhWUe7o=;
 b=jsITV2qewtKw6NBFfAOQXgCmmof8QClHSvio8PRmwzAFTAASRRPoJdRzy4cUJsWGnXF+fUORw3LnZmSYq8QGXAH2M5IWESD0qLsg6M60HCvPremBGapSXhYy/m387uwh+U0mdi8IXA1Qqocxed8/7VUdHwun31FLx1rgEyArdkg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:14 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 9/9] iscsi class: drop session lock in iscsi_session_chkready
Date:   Tue,  2 Feb 2021 19:33:56 -0600
Message-Id: <20210203013356.11177-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24966eaa-2979-40a9-2567-08d8c7e3d064
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB53209A0E951B4BCD50FC3781F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z48JUHQvVEMAd86RaMG3DvHMSO3TOW6qRih2XYle21nuUJ4tPhIiXPv1ryM86imQ1o0sDC1BT5SwnismOk8szGIMbsVFP5xdqNpqB10tGOFzQSTvRh/IUS+wjx74AOMY6b3frWLpov8GvZECQaURokJT73pKfr6OnkRMnnMjA2g3x4q5EcvqkhLtPQb8iLO67OXREw8fT2RIPQryNi3vAPnK3uEcDGe0NaB97Oa4ailHsbgea8kLODUBkXtR7iYlf7rovd/yplFgu3Nxs8SsHKog9HfbulGpbsGqqN7IgBbjbozYGUno3IHb0C9F0T/eXQllXGrfbzPgoIMr+07LepOAsK7nmydMF096mn8pkVqzbRptJ/DBBXR42dfBDg9ZPyoVEdVW8K4SvridCxNJJnCT6AifTZHaV9moKAem97sXP7ceRLD2ZCeNfvatkEmVl6oCgqAXibCf7qrr/LbMQZkFUv9DrW5skX8kDAguSkJ9R1xxd97RZyUwMYhFg4UVEUDzj3q78s/hX9RDWTk2ysdxgr/J5r+a8Q1+AihWcQTiagbRe3HcjQ7x3TGdnmrA4DEtbhHOkmV1r/eg2F221A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2rxqpXWGA+rTRyKrQEy013CcS0wmc5ils/eyF105/ZvhjM0UMo7lcbumlt7C?=
 =?us-ascii?Q?pitBsRdOkvYo2PQmHWDobn4rxsWcFRb53IXYBNV92rjKYrd42LxkQNxyZE+4?=
 =?us-ascii?Q?xK7O6WZIKgEjqawP/yuoR6s/2Z08hVihIh3pxinosbOXLNNYVXZd5TSbeokv?=
 =?us-ascii?Q?yWlZsfdP9iQV1xuYJ6EDqwYUDxmlmtTRBXwX+H1eBarh8GJHpYnfKIfIJcSJ?=
 =?us-ascii?Q?Fa4FeOVzsv4nPmNc1kgmEDu5PtUCHAYGVzsaYjJsS/z/b+fosFCEdmh7M8RH?=
 =?us-ascii?Q?ghwhQUCnr7V1dCjU5ltyvkO/Z1tyWhapILB9KQWQ0Ip8c7as8WH6wp/Qurez?=
 =?us-ascii?Q?sk0+OiXD/aX724TxDRQWFpfOF+J45pY/KNNl/IRL1dHIl84CGc8pj2RfPbq/?=
 =?us-ascii?Q?R++T7eRkgDRqcJwucic4fuLdMLBGGW5Le2w+biXVQDoo+/KAM/d+43dfkVhe?=
 =?us-ascii?Q?rk4wSUv8FbHdjA3B6wCCCRpZxiBQzd4W1DlXO+EkZkW8jAD2eN9PUfJjh6bj?=
 =?us-ascii?Q?6S+vEfDHGxowKwjYQRJstLchMhcLx6/CGJF+gcu78XVFPgMuK9ajxPWwpfn/?=
 =?us-ascii?Q?AmFY0sg0TkisLtJ3fvIpMbVhXbLNyWyobo6FKr/sv6N8ZO+g1EW1Nh0SpA4w?=
 =?us-ascii?Q?fos+sHtDO0cmU6VgdUdCe3W5tfKQE3sMgxqU9P4IL2ODZdGScuLFRZ5R/6b2?=
 =?us-ascii?Q?coGHEMLTJAEN+y4JY/r9T/WXoJmCryUH7n7cxEImYe/qeNJ+zK4OXkWNxCNq?=
 =?us-ascii?Q?1M+vuUfuBgwePa2g7WdsKmNuBsAm8EjpnlAGx1gUDIl1G174Pg3K2Jm8JJ+h?=
 =?us-ascii?Q?TU1oah+RkDcyANFQRWUas16howNYTFRmh1ARy9efVaigwS9MQ0EUZrthRrbN?=
 =?us-ascii?Q?nAUY0pxVCLo5Bqd4G8LbQIxod4MX28NDHvVMwEQrPHRabFkFukTtjYS6CvIT?=
 =?us-ascii?Q?gcv4iwqXUFdsEpQ9J3A7/HgZUBs2bHhTobnhsvXsz+aoVhmlmXVy2IyFJNMs?=
 =?us-ascii?Q?KSwIsM9YRIUW0aPjpfXqR+/zgkcVtA4lIZ3yCVX1JpKvrfC8gmKntCUixLgn?=
 =?us-ascii?Q?UGs9LfmS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24966eaa-2979-40a9-2567-08d8c7e3d064
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:14.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VozmzEAWYkbXluD+IVLXIUxCmoCam+IiHGNWHP5INTDHhczPboFz2z288PyHNov4OZVRgeeTcspLzrFp5c8nsIBEFTZx705vUHkUCiQBqbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The session lock in iscsi_session_chkready is not needed because when we
transition from logged into to another state we will block and/or
remove the devices under the session, so no new IO will be sent to the
drivers after the block/remove. IO that races with the block/removal is
cleaned up by the drivers when it handles all outstanding IO, so this
just added an extra lock in the main IO path. This patch removes the
lock like other transport classes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2e68c0a87698..969d24d580e2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1701,10 +1701,8 @@ static const char *iscsi_session_state_name(int state)
 
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&session->lock, flags);
 	switch (session->state) {
 	case ISCSI_SESSION_LOGGED_IN:
 		err = 0;
@@ -1719,7 +1717,6 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = DID_NO_CONNECT << 16;
 		break;
 	}
-	spin_unlock_irqrestore(&session->lock, flags);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_chkready);
-- 
2.25.1

