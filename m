Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ED1C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BF760F24
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhJJQVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:21:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52888 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhJJQVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 12:21:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19AFgqYN023821;
        Sun, 10 Oct 2021 16:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bKoRIkWvgd+Y7T3nIS494lzJeoGDf7/drwHxIweUN6U=;
 b=cIiQQz1yL/M97SWF7EhasqcAfxY6djCTW/MJLJ5PWyVTQFOYuFoPj0Kt0DW1bO9tFIIm
 /2rEVUA2dZlU+XpIg/sCJLDkq3LAq8m2xUwSHXt/sLP89xUU2BkF6QuZ1Q0uXz49KWud
 P5UyDmyRPtF5gXyofJUFdsRj79kLkDMWf6w0e+mHpZ9UnZyV/Leq0JymB6LGCz52Z0Cq
 e1nkN6T3C4efph/UJ74YzAZKGUchYtFJWAzSGR9xcZigWWN5T9Kn94qrbuzwR7lmQVfb
 R/iFRlzE5d42Dq1Lb3OisXv8gVVwjESHfJ/y7pWyxnn638d/lNriLUXIL0FAFgQqKK2q 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bkwyughqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Oct 2021 16:19:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19AGEx66068966;
        Sun, 10 Oct 2021 16:19:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3bkyv75b5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Oct 2021 16:19:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuZjL5x5fGIN9x1T9FX8naA2K1TghJnYXkbCk+iKE0I59UKxj7UCafAG1tPr74C7A/BMkFU7UcVtJnbFOoi8s0xDlznGHmzGFIeMxlbzWmh3EzfKBzwvjc+cwG86j57NwQps95Zc4dTLlk0/Fti4csq0ki/Chf1wXvImtE4rd2s/2texxQJu1wr8F0rJrpK1g8v5alIBrk6FniwskCnhbE9Hapt+UaTC7Csw2TeMSdU9l6pADOB4NEx2z+JmOz5rml9wThjHkyzVtdlu9tPgYDpWzxSUuuXFWfOStfz8hCSkiyfMoOTlF/Lc7m+p0aTdaH3NpwjOHV8FeMWojxWDPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKoRIkWvgd+Y7T3nIS494lzJeoGDf7/drwHxIweUN6U=;
 b=GOLNBGr+NmVz7g+TUkgckLzG3VWAJyTVVoGUvMpdzlkcuazi2+gVbdKad6Amrc5W4B7Qd6utsQt7W8vvZSWI/yUKDmWsauIOYUWFFRxhhlYuyQJQIZ9a/Gtgm0fIWfb+FHTs9HnEQrAn/W8VKugLiSnnSp6G250PQ4BjnhZo7sOh3rjSgqKKmIbxLkdVoRuzr0gHn0gX3OHDCPiOa2T1D/sXFMZ61/fydlHrU5l2JlUNi7zKppreRgfJkkDLsenfOAVkpihEB9drdYcnKwpZnQVAGS9yvQl4kn1DSf9hrvLaDrv9QwRVf3gTVhHHDvxhVcu4rrl5UfsCwQHnHJmJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKoRIkWvgd+Y7T3nIS494lzJeoGDf7/drwHxIweUN6U=;
 b=P8spUw+dw9PSf0wBbFzv/O5gNCIwnoFlxW9srleGHtBC6wm7Cauy5fKLm6gBMxKH0XEj2dYGuWHDH1Z78k6Jp5U03/9WTwuWjcGRuQxX2Uh2TeJjOmUJsHtSA2ZflUzH+m6nEYQmWorzeEvlhdNplDdPHQADbLYlQO8HHu50FcI=
Authentication-Results: smartx.com; dkim=none (message not signed)
 header.d=none;smartx.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5294.namprd10.prod.outlook.com (2603:10b6:5:3b0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Sun, 10 Oct 2021 16:19:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 16:19:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     fengli@smartx.com, gulam.mohamed@oracle.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: iscsi: Fix set_param handling
Date:   Sun, 10 Oct 2021 11:19:04 -0500
Message-Id: <20211010161904.60471-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:3:ae::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0053.namprd15.prod.outlook.com (2603:10b6:3:ae::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Sun, 10 Oct 2021 16:19:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60ebf824-0821-455f-92ba-08d98c09b1c8
X-MS-TrafficTypeDiagnostic: DS7PR10MB5294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB52946B65928000413B82FC38F1B49@DS7PR10MB5294.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:76;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2231QdNi7tlzBoe+3mzyoX0PJ1wR0X7dmwvZzp0yzl40dRWluzcyBpg2JL2T9q/g/krtjDk4CDmCehgBCDGiAQuXqjx3NLAbXtRQSrI9jpR745Sdxd33TMZ0B4iD2qHWk6kdyIkWDqhNc7e2tK3Lctdyq5uOaYk/LuPSSipPylYmbkDjfKSM3phrNMrGVQY1SzuVYRE0a46dtYwfyf41Qql6+jB9xehuAz16gpqqNXaR7vhy/WBIuraoCrmf/t9fPbnSUZW22VOl3x6Jt+TiEsReOgucd6zBl6yfTZi4cIuIT1ZYJXceZr+N5kJfHEb0tNQeZg1p1tl43DerzVTUt1cZti55bWgaYqxBZ3xEbY+mA5iP2KL+MtnY9RuCb85133nA+WZgEgTYHhLoeHHmkJEL3/6VYdoW97CkPmJ3b68yb4il0O3jnL3SWCNqhDh2tCXq3z2w0ohwKDIrBeMBQAywPC9nBP8vbPgc6JAFZaPfKYUG5I/67sFKPTlMHwqh6FSSfGBpxVE4oFCWbuQNDAw3Jfot84G0jcttHhSg8A3e6aT4Oli/uJkbLuNjttQBAf6RemqsfobKMsK3I592RuPrTzzZRxYlL2T32pzzTCrr7BeulDVSQWVB99QZrlZ7x/edhbPkBsC9ifgd+dEmr8p5XNA6Wt+fL8LP/1oYX2FUwCYKqvGSsjWL2X07oNvvLg+8us0WVNuQj3vJif1Gvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(52116002)(4326008)(8936002)(6506007)(107886003)(2906002)(6486002)(66476007)(66556008)(1076003)(5660300002)(6666004)(66946007)(316002)(26005)(6512007)(186003)(86362001)(38100700002)(38350700002)(956004)(2616005)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GGIBHVyT3hk93PG0TXpzow3EgW7ABkfXaBIL5D9zoN0un0CqZA1ovg30Mx8a?=
 =?us-ascii?Q?LC3YYe6jNiAtdqDm/tMxX0kTUPvxVLs15WoHxotHaKAgKE8+mEPD0+9D/W7/?=
 =?us-ascii?Q?/tc9EMw57RYpVOLbe7B+Fum0A4NkUZU1knRIn8ErOc88MQKQwLxZK/h3j5qP?=
 =?us-ascii?Q?+q19XwlfPkjxcmw8WsS9FgvAPowN/vVi3OTx4393QJqck8IzqsmggAc+yA2n?=
 =?us-ascii?Q?1hpYo2FHX2kS/etgQi1xJ5WoEv0wJAFxbKQq+BH52wkecTcY0C6aE/JV2Arl?=
 =?us-ascii?Q?7CRDArwl7qbqneBs2zVtx7pir0haFYJFYihToyocDZoVKFpRf+Eu4LniJfsn?=
 =?us-ascii?Q?KlQOkf3Z7wI1JfQyXbK5tAFAzCGArKaJKsjc9BR3fRqjj1CnEkkfGn3JPf8D?=
 =?us-ascii?Q?Sq8QvCb7f+7QbzFypn5YZ4HlQJmUhhiOGhTRNZS1Zpht38ReFt6gCVy4+r17?=
 =?us-ascii?Q?MjoNdPrr/u1uwpMBDwkM7Ah2yGBUhyFwvBORxy7ZwaS2NAhQwwG62o1C/cKX?=
 =?us-ascii?Q?WWTVpTn/4vQ3EjfK2romL6BwLah1JOKfHv0V7d6OB9DA5DkfOEVgoUyvNQTy?=
 =?us-ascii?Q?bw0pNn8BlUnV/G22OaJeLd2041TpJ9kagJTZSjQUTMPAieONgQ4HjYjlrA5R?=
 =?us-ascii?Q?JcMSHJodyRMFtEDN4xPVdAa8QK92Q0Z0gVcWKnMrcwI0uTQ6i91BFEYOSKzf?=
 =?us-ascii?Q?m2PeOAemk58qTeigJLSTReqEjW5mlblw6UfvfyO4ZjmKTnWg6hAU/OOAxmyv?=
 =?us-ascii?Q?u4KEuCAYI8xekSn7iO4Mzevzbo9+vUNs/1+IccG8d9hegQ7+SywS9jYSFGSD?=
 =?us-ascii?Q?wj5fNWmrAMLNnvp2d57hti2kDyZ3+OlgHUIjRQJNyBgJSeibgONsbmZJO9Fb?=
 =?us-ascii?Q?5T0U8rOjI3m1CWb8+fszqfcDX6mM4VuY//HjI/w/3MFmJyYMCDdCKApqZmzl?=
 =?us-ascii?Q?/aecdsMFqCSxtn/XEPxeELVSMqesr1ToBexFMLm80BpTYew6QE5CYxSZKQTI?=
 =?us-ascii?Q?/MxZ7bnqMklzDet/VY72nZYR+cv3Zyz9lIsFflrtsYw+oKtUBo2Dzptc1G6Z?=
 =?us-ascii?Q?RKdRrEwxFKLsYdf0A1ZnHjZq3Y/rc9B8uSY8ZlaxlVCA3uRimY8RVwyhjpB4?=
 =?us-ascii?Q?IvN3exsUXC+PWdb131Lo1woG6h8pRTyfY5M3H6aZlVrjsiQbUCL5uJ9JRTSY?=
 =?us-ascii?Q?HcJ5Z9mWpsPfFVWFT2/pjTcd1CDp7FtMpqk8y9G3wEb4hu259DtHDbDnxARV?=
 =?us-ascii?Q?FsmZL0gm8A5621FLQ5jeHgbDlwYPPWbg35EjkE1buboIqBRi+dniXmcPJwee?=
 =?us-ascii?Q?KuHdA81ki0pwbJ9CGkqa9Pln?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ebf824-0821-455f-92ba-08d98c09b1c8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2021 16:19:11.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvpnIpN+RVqANeN5xzGXIRj+re6rbJFx0mj+jlSdYT7/KaCdO0Yt78NIcJAZs7XfBmG2JkEMWVvBggFIDn+lrT8lEeuqQtM5UzEI7W98y8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5294
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10133 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110100113
X-Proofpoint-ORIG-GUID: V-M7rnVhU_mdRyjdamwPMHpGfOGkdOy4
X-Proofpoint-GUID: V-M7rnVhU_mdRyjdamwPMHpGfOGkdOy4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In:

commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
sync thread")

we meant to add a check where before we call set_param we make sure the
iscsi_cls_connection is bound. The problem is that between versions 4 and
5 of the patch the deletion of the unchecked set_param call was dropped
so we ended up with 2 calls. As a result we can still hit a crash where
we access the unbound connection on the first call.

This patch removes that first call.

Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
sync thread")

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 922e4c7bd88e..78343d3f9385 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2930,8 +2930,6 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		err = transport->set_param(conn, ev->u.set_param.param,
-					   data, ev->u.set_param.len);
 		if ((conn->state == ISCSI_CONN_BOUND) ||
 			(conn->state == ISCSI_CONN_UP)) {
 			err = transport->set_param(conn, ev->u.set_param.param,
-- 
2.25.1

