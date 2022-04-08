Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8BDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiDHAPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiDHAPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CD7108BC0
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237K03I4006381;
        Fri, 8 Apr 2022 00:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=QYrbjuf/7dCkfyxH7xxQe1KsJ3diLh/uD6YvZV96w/U=;
 b=y25lwYzgdXG+hocpGPFHQF7id/+QBhmPM2rdC9MLhbaGBgu1rNZEcj4gb9eriJwTWB+Z
 GZXilDhKuycQuxjS4eFnOtQy68SUNSqfip4sF2jeyJ6lYLjMaC4mJ4EcSZ2l/gH9eTXI
 3HTS8djqq7e4vm94UqCC3b8Jyjhz7Q/4/jD2N5YubNeDsYzNMq/WZDcpT5FKJZm3L08B
 J0QO/at4Yz8qOeskQiePjNsJEaY+vCcDRRX7XoBV3Oirvdf0V9uZKPU2CmWr3jh/+99X
 YhDbEvozL7cPzFagryP71grsP1EQZrlxAXcR3oN99Oyjj5BLTT4AIiS5lwqHE/MjCGfZ dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31nh88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE1013838;
        Fri, 8 Apr 2022 00:13:26 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2ZfbJNthVWcgC3Z18Jl2KVdk0aAS5xAA83BImN0iDNZkzQxIdFDu0mnx1OVQcn+OORveL7Iqmw9PQ6C8j5Zd87kpfniQMyzGRYjjLSraRho9zqEG5UfAhoqrhM3d0su0g21NueDwlqsuJW+wIky+Kc+4OFthG5cW7nMk8zjX2rimYeDW3kcdkytBWZ27v2LRFoQ4RbRY7MWEU0/HxfNi8STt+sCzAoAAcsF7vHBrKKWvgxAfhm21pBFbH4X1JxE4tNo/MdxZvuADVSFgcVW0yQucqQF/8kHJKQQHFmsSmHfogvOAEULcqBKw3Oni3hFAeMMAqF8kY4br3xKOdjPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYrbjuf/7dCkfyxH7xxQe1KsJ3diLh/uD6YvZV96w/U=;
 b=iK6SR1I5YhZvNRRpEddPHT95qrNbCCWwQcIaL42b0VWRm2/Rs6gPFCvii0o4YJT/vysqtzhv+YWAww1u439LYRS1hKgLbI1UE4ST7ncXDh3n2mO4dOD9g8wpNlS13iAEwSglrIboaHA9MBpFC6kaEu4t81+HQMloWIHH+HfdTPiFoOKfvpt+IcybVyBBAO5rmIB3eSikrOAWjo72DnixukrggG6H14CM8i4NWgF2oGiHPsbi/zJO+N3q4bQFzD73ARbVzB9pPw1lM/X+mzCSht8SAgcOh2BUD03MsMujEcvitOYGVlXdviNbUh7Hte0Ja2YILk3IdFCjtHAjk1w1hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYrbjuf/7dCkfyxH7xxQe1KsJ3diLh/uD6YvZV96w/U=;
 b=hT5fUMrXJQsf+HMoi7CENn/fE9XrZb+45q077zArYKJk4ZjCABOsIRtcQ1eMaZ+65ocX2haQ3bhi/01TJ0m4aDSf5k87fAo8v6yleAf1miChF2mcah3XiCKro3yqHyYzKXPRGCIY6XGvKCl6/0MJwqctKkj7E/KaBKrEol/eCsA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/10] scsi: iscsi: Fix offload conn cleanup when iscsid restarts
Date:   Thu,  7 Apr 2022 19:13:06 -0500
Message-Id: <20220408001314.5014-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 373573a9-deba-4708-cbdb-08da18f49860
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5550FD5C42DA3D72F6EC19CAF1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lICW56pDPEvqhL3vN0zx5UTVAWocWlZeJ+VnDZmKFgPfVNqn2WCOnAbg+H5pOA8N1bwJ6E1TZqk0NpoGhi8kN5N1EWTHIHXfAbJWFHEfXJ0p1yi09lPnMMne6ChbgvgYygc44wj1fUXZ1zf6Dn/VYgJU/fy85kC9lm74eAVQfvXOMGuDwscs/QJhOzUIJvz+dpMBUFiR+5Ac2sgdX7PP7wAtFse1H0p2VO252TAvi6upsPGwxnmmdwx7rjqMknsEK4pq6Vm8+cQQDcmcXvmBIJaVNX1iByBk5dZvsS5OFhPuqTDbEkrCAWjH85dfL5QdlOuLyC1J2ycN6pLRGPConGiqhmrYlbG9SxVy7LjwAqoH2lMceEl+423j26+pxcgFAKA0jVamJnU5VEswLkCStqVzMkftEgtJz4ooDQmDg0BxCoVJvZvL9NcrTXSdIMKcT/yxwmfDi8rMbxZCU9j8I5TeuiumpBeiFGTUgflkuLV1TF+o7Sf4tq/+XG1ASQ1EbL8Lyg9No9GC4xlEQ4TfR72PlgAIC2Sv/m56TJbJngu9MgoswdjUE9GpCwwi9q+4cKa/1s9M3WbWyLjWpcT54eZXGVjXO1fW0WOwhTDiNLll82IiKfOYx7GTcQyga0Vu4CsLGXfKUULIryOt8cPnVFp7DSyCr45uzonpEJ5orKRtI0J/r2ZI8QIdypRiU48OApDzeBVoPFc3Pd/O0Gt56w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+H+SuKY6S6ve/ZdWlmZdTcDMRE2Dl/117Cc4jH+dPOSi5/YOxprHrq+ID3A?=
 =?us-ascii?Q?ySUEY7PHU0AAtZZNsDHsTsmaTKV7ixsn+1Pcd/KI6Xf0tJbsRIEIfK5dDYbv?=
 =?us-ascii?Q?IdiD+qvJfxpJFv3LCpxa0hgJAh+w5if+5MgHij1E0rQvxCLR+9dXQBiosU0A?=
 =?us-ascii?Q?FZBGjrWAo6myRyheDHnezrOAiiae6+f+vhcSUhnkUjCiMylpSuQoTee3z7M1?=
 =?us-ascii?Q?lHAuSwQq6tnFzNtaatswmJ39FSrjHOsl7odEZQvFXMFdIXzfBNuy783cVOvg?=
 =?us-ascii?Q?Bcd3+K4d9Lo2rZZC2andZbtFOLL6P3HKDQSvVOZgp8xs2In6ksuWCaJyxjqd?=
 =?us-ascii?Q?2oNHB4hlEBKbQpD7lFWaNz14BoPBjpB7mVA+4Ne4StX+kFLBh9/anq50hdB2?=
 =?us-ascii?Q?j3/hYDhBWLD5XWtrlQpre3/aoGqmx22XEZ659ZefP2uDkBnpYyc8u+5S+TBt?=
 =?us-ascii?Q?rAHWULm20fTlLHINPb0OZG1AgkPKgjloTQPr1is28SbhEq/F0+QhkIomGhwy?=
 =?us-ascii?Q?41OCeNwmemjsIpUj2p8K+gJsl1gL/bvENvUeftR8KshJQ6i3GnigII+0CtP9?=
 =?us-ascii?Q?I0c+0JqN40oTGEYhwHMh5e66GdgthSRNbxGtGV2fz4XDbP8YIoTn5YwK5lHg?=
 =?us-ascii?Q?+fJtBPjnm6te0hhO3e5HB/oOfqO/EkkyTxKTB8Q29MnoxV9EqskWAqCoy4ts?=
 =?us-ascii?Q?8Yz1CQhXTrtoRlASKgLzm5jPtQITYgg7D1/f8oxP/rcd46172gL5oNwh6gBZ?=
 =?us-ascii?Q?5DqwctIfvxIqlC9Hgtw1wkbArkRK3hLrhH1fOJP9S9F7fGuhtTUDsbz/R1eX?=
 =?us-ascii?Q?wLcVG4yzhOMhstiEbhY0Lk+WK743qgn+GqvFDKUznJf6R5DpJRaklf6xxdsr?=
 =?us-ascii?Q?QM3GFuS0mGM9ZB8En8wAwOvS/QeDpjXrkY4RltE+sw/tbcPnuYWWqL9Z0aAe?=
 =?us-ascii?Q?SuXOOMIs/ncQI/pDZK7zEjD0wfM7u5Zf+bqGd+Hhb+/kOBjAhQWO8kOpjL4S?=
 =?us-ascii?Q?wPw+pSOCDbbHW2SNsEQzqCgAGrL0PLeKwP3Dk/TbpX7XdawxqRGBeb/KV++I?=
 =?us-ascii?Q?cHH4Ldpkv3ueS83YavpZP+KR4qmBPiALKhekuSlah7m1Bm/wWVxkrMHyAwUi?=
 =?us-ascii?Q?kJHrRcYM+fYYYZbcODqjEgLlr6Zj3q2r0u8/ARNo6/0kjcMGMQSxnj1X7YE/?=
 =?us-ascii?Q?3zkBmUwJtJfZZzl5+0blF8k3S0qWk9FV4Ohqt167BdbOyE2ySftrkJJkA/bD?=
 =?us-ascii?Q?jK8fET7IxoFQuveWfw8DM97UjjwolXyfKgRdmZvXy7PqhJe5UGj5qLI34tm7?=
 =?us-ascii?Q?kRANM22td/qUN4NQ3bX8bRHq66O0ifRiULBF/n7J+K7wZhpDjSeKcg596SEN?=
 =?us-ascii?Q?ReISrXVzcJHCNNH3jxVvQJZna46Jw0k89qFs84LWVVJ81J8bsL3hbgbjeChd?=
 =?us-ascii?Q?Y4/y3ovaLdYkbHFrEUXPiP4UttN2rM1CUATjsUl7t99BCGW11SKAWCnEl6zO?=
 =?us-ascii?Q?bZ+NqhWO0HFTpWgGhQroLimDWLbF350AebL/6+9uvpzZXJqMngADGYmg2ucJ?=
 =?us-ascii?Q?IJWlldmUQ8WN3mFCwhJc2/NNHTv67/GyVmkzSoFMHOw+G5GNuLkxLrEHlyH1?=
 =?us-ascii?Q?cF41MMg54zPZotMg9l4yhj091ZueeYk9at/02UEz1M1BdD/myNfgBxxTBmxi?=
 =?us-ascii?Q?MNUASnAKX23cigSe3JODDEnMlquCxmLghsFR6q/gQuQwlPCSSlae8Uo0th93?=
 =?us-ascii?Q?+LBsOv0Wfe9rBw94wU0WhghaucHmluI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373573a9-deba-4708-cbdb-08da18f49860
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:23.5476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXtyF6CojhVFDsJd9jsJWr+iz5RjAwet3S9j2pmksa6I30g7B4kLJYKrJC5kYLVwN2mjr/K3aR8Wvkg/fT4zHrZax0MeMKoWJsG9pFks4BU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-GUID: JcgFccuT-FE9kyE6_1xl2t_FJi5YWkj9
X-Proofpoint-ORIG-GUID: JcgFccuT-FE9kyE6_1xl2t_FJi5YWkj9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When userspace restarts during boot or upgrades it won't know about the
offload driver's endpoint and connection mappings. iscsid will start by
cleaning up the old session by doing a stop_conn call. Later if we are
able to create a new connection, we cleanup the old endpoint during the
binding stage. The problem is that if we do stop_conn before doing the
ep_disconnect call offload drivers can still be executing IO. We then
might free tasks from the under the card/driver.

This moves the ep_disconnect call to before we do the stop_conn call for
this case. It will then work and look like a normal recovery/cleanup
procedure from the driver's point of view.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 48 +++++++++++++++++------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4e10457e3ab9..bf39fb5569b6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2236,6 +2236,23 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
 	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
 }
 
+static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
+					 struct iscsi_endpoint *ep,
+					 bool is_active)
+{
+	/* Check if this was a conn error and the kernel took ownership */
+	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		iscsi_ep_disconnect(conn, is_active);
+	} else {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
+		mutex_unlock(&conn->ep_mutex);
+
+		flush_work(&conn->cleanup_work);
+
+		mutex_lock(&conn->ep_mutex);
+	}
+}
+
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2256,6 +2273,16 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		cancel_work_sync(&conn->cleanup_work);
 		iscsi_stop_conn(conn, flag);
 	} else {
+		/*
+		 * For offload, when iscsid is restarted it won't know about
+		 * existing endpoints so it can't do a ep_disconnect. We clean
+		 * it up here for userspace.
+		 */
+		mutex_lock(&conn->ep_mutex);
+		if (conn->ep)
+			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
+		mutex_unlock(&conn->ep_mutex);
+
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
@@ -2984,16 +3011,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	mutex_lock(&conn->ep_mutex);
-	/* Check if this was a conn error and the kernel took ownership */
-	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
-		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
-		mutex_unlock(&conn->ep_mutex);
-
-		flush_work(&conn->cleanup_work);
-		goto put_ep;
-	}
-
-	iscsi_ep_disconnect(conn, false);
+	iscsi_if_disconnect_bound_ep(conn, ep, false);
 	mutex_unlock(&conn->ep_mutex);
 put_ep:
 	iscsi_put_endpoint(ep);
@@ -3704,16 +3722,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_BIND_CONN:
-		if (conn->ep) {
-			/*
-			 * For offload boot support where iscsid is restarted
-			 * during the pivot root stage, the ep will be intact
-			 * here when the new iscsid instance starts up and
-			 * reconnects.
-			 */
-			iscsi_ep_disconnect(conn, true);
-		}
-
 		session = iscsi_session_lookup(ev->u.b_conn.sid);
 		if (!session) {
 			err = -EINVAL;
-- 
2.25.1

