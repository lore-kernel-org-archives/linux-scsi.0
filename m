Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0F3C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiHLBAx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiHLBAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD977FE5F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:45 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5hAS019416;
        Fri, 12 Aug 2022 01:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=S5XtHvE4FGk0qeEmstVIi5UIXEmvMgsDAjLUqQmTHUo=;
 b=quO4xDw4Vvp5Nsd7pVHoSXKCwbTfQg+9XF/9gEX9XNwLKCcNnAfeJRrhD8n+MxLJud33
 XKwzLSBkVAx6eiXMu71hoop8Ytp9qsCECQXWxPgT/Mh8yNbeJwtTB4HgV0aCrMrA5Lzw
 5j8CWa9rgwE7E3Wg4OpYDN3dAPAj1RQramPpvVfYjQriEKY1wrMR423969WP0jXaJ3e3
 Fc013xhuJDDntuA/PyYZP2EtzZl4nv1SI+AR/j+emyx+Qy6BYpF6CzxGbEKT++CWDq51
 6iQlW+eNubXnzUrWTxWoxhobiAWSgkvBBA8A+6h5rR3RjQbh2rOFn83aVI4sUQ2R7WHo +Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9p2vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0L3aY004961;
        Fri, 12 Aug 2022 01:00:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk6c68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFY6Ib7WXL7ZNXM2Jq2pakTF92a6KYiasfhzFALm2/feZST+ZT8ZSCg/izjujLEIpG5GTbqGUQnZ0gi81D+xnn+XK47Tu4DMqiRhWB9Jc9T3jY6FXE83XRWt8vijB+khJKWCEcFAVACVgVgeFRgXCHx3fGaerJTNzfvUZHu51jUi99SDPmf/wrvsnIg9CeZtZqdi6Yy10CzdG7j2jtbvZDKiLZe2QrpUtHTWp6BHjHQPnBX2oYMHr4tCHtj/QPrUqCbQlRPxeVWcPzeBaPeTq7JZvAvzwghERxQXnwpe5778b6IVe1pAVwinHon+C+6Xo0+KKK5FsoQqNeKiml7ElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5XtHvE4FGk0qeEmstVIi5UIXEmvMgsDAjLUqQmTHUo=;
 b=fLclhJZCCaR1CHh6xQWyxQzkFcdQlT4G5mwiQW+jvEM0XWG5rvVHK47YS4sr0qcswIcF8o2qT3T99KZodonpU1vCSHvOjdB4lZaVY7Cw9CAp6w6sDjA7scuit9tHdCfSi1gyBwQujoNp+HP2bS2WVK7Sbnv2SPNOACskbxzDVS5GJR4IH629+9lLurQTm0dE/Ktp67l+PI8zHa1jW2i2F+NGtGcLeQPdeH82LhXS4PtyTD4QkAg2ugToT8c1MXduugRC4g4R8S2gNT9P1r9WTRBr8Z+2ePIt2Bea1jm/swipchLfBQ4JHV6agkdJBAvNnw8E7eXOUueP5HMzu/7Rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5XtHvE4FGk0qeEmstVIi5UIXEmvMgsDAjLUqQmTHUo=;
 b=sbba5Vayotud9ILCSwnpJpNGAPvHFDxY0h08oppPgPPA9eES9Z3kk1hND3EWyREh1zHCHGl0InBgKC3PSbIvBNoYbLouPi7537ZFWZAUANC4jnlllV8nnQnr0K4y/cYOpx/czG3F2TOX/dZFSO9KkNAJBC9YnMS5w3pD1aJlEmE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/10] scsi: virtio_scsi: Drop DID_TARGET_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:21 -0500
Message-Id: <20220812010027.8251-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:610::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e969a95f-7e1c-48fa-708e-08da7bfe104b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXr/o9WEv6WEg3My1OaG0aa4n+EM3z2VOcM6aMaWujHA0TA2VnHnl8qa7oo9QKdP/JKDDP1bwbIaUUArpNVbt6gotlzT8yhBmoU3GMJRFgB1m7dOoQfsA0RjV2mKAxDJRzXzmj/W0y4ldkFKVuYnOKjyYooYfiAxuH2SyiJbb14MrRgKPug8Tj/jVgfQnHiYtaDwG8kE79Xsc9mzm6PaY1sl4QrNCVbk1lYXtYNGvVTvug2VrGPb1qCAmhDMBSdLqhyFknE6KLGh5MbjVoNZ+S77GOsj0qrhf+gmiANGfXEzZUvacyxvjxBXneOTllbRfYVdfP3E33jBOf8sigJajvaHt26xiUNT6gtw/fQwqOTO2e+74tb3VvBB1oU5RT/G3ulociS34dtPkwENJFKFSfotyOu5wQ86yb+6+/7VPeC+jgeHQZME4aJ2PDeNj7IADWpS+t0NeZ0bwlVErGO9EXw+gP3Swln4KCO5eGAoui3EnF7O1ffFr1bpb1xvjBXnrsOK8EYCxMZ6LZmnElpyoQycQvCSwgwPircpO/iH3LyzERc8upV6Gm1n9m8wHm+IAhlnOMYBi500X5MS5GXfIDZNCSKHbCR1ZjA25VE/AFC0Sa909/SqaEQ+uPJ8UpLbnN13AOX5AW6XULWsVm+SEaOSJ56qGBzZ2lbK0KFAkYmNyBSKNir0Ahd3Zyh++kNHQexwKmFDl3iFa3lpx+/S7jeG0VV1Q15BKJKAVyiJ8A11zg6vyxIeRFsOsKyh7BIH9E8kLIMjJMeha69gy13lkeB00fgm98e6J/BmZO8uAB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5xZYBGDRjmFiz0Ig2YySJaIdJXcrm41/LxZGWWRTWf4Pde+sm+C87rBuktI4?=
 =?us-ascii?Q?bp+2bWYKko5Fnld9uhS7yg0BhUKYeybMLPHkIL1sfjOj6b3AHGOuNXIhfg4r?=
 =?us-ascii?Q?u1cuzoj7EZqdXGUHav8K+fYllQ/G0zOtepwUGuEDBAfvZ+4vEnnBGN1DVANU?=
 =?us-ascii?Q?Wj1qKqDqi2qhp3i0vv+L1OcnbolnLMh0T/AZAV/EsWcxEe6TMQ2QfMGiApNs?=
 =?us-ascii?Q?2rVZOmTQfVSeM3Z4twqG4jY7/GEgrvMvxe54ZrU8fNZdmmXK2vChcSwnTgdR?=
 =?us-ascii?Q?u0msg19CY4zJi0ilF0z/S5dYwLoTHBLt0v9d9w9EUlj0k7WoBSBIHyyjEtm8?=
 =?us-ascii?Q?qZ0KeyC/dzUGx554D1f97wgj9gkuaX0h2pVCbiHYYPHYdW5wYPHPyL0yGlM8?=
 =?us-ascii?Q?Z7LlYPreHLNDNcbCYOC4JUxR8JnZN7PsKjzHZMrD+wjDVZW4rB0ftsjuptxj?=
 =?us-ascii?Q?XWsoYLL0wH5uwuT9SNiFCKb5f7bu0+TL2G3Q/xP2GtQQFiyq93JIIqi5SNa8?=
 =?us-ascii?Q?SK+nklY6offssuhbuN5mnb6W99RVSytXhkz/UnPZen5wjxu62ppupUwgs/cj?=
 =?us-ascii?Q?Y8f7TyroXu2Ap3lCdUTY1eQo6FXd6kJRrceZHTQ5Kgi8dRX9kT/4EyFqfqXT?=
 =?us-ascii?Q?mZPB2KAy9dS/tUKH456LfBEPD+qhbYEwTTEZOM6diV+CS/JIulwcQZCoxxwY?=
 =?us-ascii?Q?y+sGZ2/gNdkXESZ50aqrI6s5N+KEn4FfT9j35bwrIIIT3xzAInfWIN3Byfqj?=
 =?us-ascii?Q?MyoiVGlJJptQNIcZDfLcyJKU4SPC8iGPxCxsHvmezQsFkINKwUKKM3vDYaPG?=
 =?us-ascii?Q?AX81AZL7kOGF2GFnwHvZE0PLzDTaNlbuj+zQH0BXklQKBV6me3yCOwHhx/eX?=
 =?us-ascii?Q?PSrooW7YpuqmspNS+IdwtWTu7Ghdo+oTmzLZdBEepFRPXsltTJ+xEqQZooTe?=
 =?us-ascii?Q?EBaaxkVYOvXI8C+0BOpLCA0BLeVJrptyhqaxbpueUCxOCEzU5MsBQv+jivEK?=
 =?us-ascii?Q?3L2ZO+VPgbPI2GGYdXUBtNYMgzcTd7/9xwwCb3m+oQqN8sS+IwdA4dzRlWvy?=
 =?us-ascii?Q?JhhnxgqRP/L4sl/PFsUCiqw9bnq/1PR/hOCLQhtucvwaqbDuwwz+BJSL8GvJ?=
 =?us-ascii?Q?L5o4MGaLfv+2c370py4bPoFu2v5V4t5MroEDBmUrqfDKhLtLp62J1RL6+oRW?=
 =?us-ascii?Q?GNbPnZIwnP13taxeC9BMjSZ/xsZpNujOV3OcyMETKq1lBj4+ao9/e/1MsVV6?=
 =?us-ascii?Q?Fhb8XzpVNJjGjNRc0hxLfr1CRr+fqVwfeUdUy9/DPL5PThKTW99cTCEJqK9d?=
 =?us-ascii?Q?3h17GfC+j8o6lXHvHyWoyIoEsGr//SXMUhZZxqOQb2MS3gFuulnfWCFd39dS?=
 =?us-ascii?Q?ndDS9lhj1nOH/4XHsLI05v090OdMrNYiP/Ae0YiqUo95k3TuGmsHFH0pcUzf?=
 =?us-ascii?Q?fJWzjR2TtfBiUOllgKr9jKVE9ILQ5hphgsq18TTcI3O3c/tyJwqhQ5HWld4R?=
 =?us-ascii?Q?GLHAfK3fmmp2FwHh7HzbwNZtMD77NzDZ++ekNy2VwpdiTPTLpGLi5/5sAxUN?=
 =?us-ascii?Q?kJB8pfJNu0ASk4EqPw+EvEpZ3iLW9BBIvBZycoBQh/8IF5kDoyDOsDe57kmM?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e969a95f-7e1c-48fa-708e-08da7bfe104b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:35.2885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SPuVUhagZDpkm01X6JnWVYdTFKSBkHnefPhGC5dwmBd45njJ9YR3IkDj3S3F8q62oYhE7WD7zlMJWmXukyJka2jXjYXkQF+I7FYm6pbtcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-ORIG-GUID: p37s3yyRG0r0JLcKBoSh7mypmj3exgMq
X-Proofpoint-GUID: p37s3yyRG0r0JLcKBoSh7mypmj3exgMq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like virtio_scsi gets this when something like qemu returns
VIRTIO_SCSI_S_TARGET_FAILURE. It looks like qemu returns that error code
if a host OS returns it, but this shouldn't happen for linux since we
never propagate that error to userspace.

This has us use DID_BAD_TARGET in case some other virt layer is returning
it. In that case we will still get a hard error like before and it conveys
something unexpected happened.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 578c4b6d0f7d..112d8c3962b0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -141,7 +141,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
 		break;
 	case VIRTIO_SCSI_S_TARGET_FAILURE:
-		set_host_byte(sc, DID_TARGET_FAILURE);
+		set_host_byte(sc, DID_BAD_TARGET);
 		break;
 	case VIRTIO_SCSI_S_NEXUS_FAILURE:
 		set_host_byte(sc, DID_NEXUS_FAILURE);
-- 
2.18.2

