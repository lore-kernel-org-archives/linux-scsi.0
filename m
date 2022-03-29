Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8C0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240409AbiC2SHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiC2SHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B871B1896
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsnGO013411;
        Tue, 29 Mar 2022 18:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=bAEErtzoJOJAVH4e9aK2fZDKQWh6MPwFOuK/BSiaNDs=;
 b=eM64eVIr8kN8JS+2A6syu2m0mWXnzfBiQ7/gwrs0f8mvqaGVNUeJgeZUBfSVly3Vp5es
 JTEb9BPKkkYJSIWh+gnQWsk76Czea/GhQcxXCLFYL4eb8OdgFcEmWWUjUSSUX/GWBjts
 HHZBLYfd8JIq2Pc70qEyc66kmoi61aSfMxVmo/ioO7DV6v3IXci5HmOSjKwg3bV2NY9e
 w1O9bEvwIFVih8BuU5efmDipDnuP8kWgYc35+3OPoUsfLd3BTxWl0Et2LXddIVRZUKeI
 PY6wQ80NaZUwLmPZvM3R6B6dpGr7tM4I1ml/mgxYMxn1SHz9Zw1XbRnXtcfrgoTMXUhK 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1uctqf6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJF048570;
        Tue, 29 Mar 2022 18:03:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS+9iJP4rL38+HuZzvu8qNa/QtVdYoL1PrdcXEes5a6IqK+CUjKGUCrOV1p1C2AUcGeBLgTr+IJMC93/ZlGwLe0LLqDdVTL7eyIIzMR11NMTFIMY3c5VSqTtgBdcVrNm7XEi+R7Cu451xf5WkYSbiEdRfouLp/4WFrJkJw1HYPdbjVMUxAD8QTcaP4pTKNl3NLkRxCq67Pr3rzb/RMV6AJzHD26bsQAKqKPP82ZMk7Ki+kUTj/p1bkWCis5581EWz9ovLkxHLkCDvhwHnNSC18a4gBKTTeOiu4JKYvRkLEHZ37JMtmSaXW3S7PvlRigtyjOnyQsklS4PZKraYQ1c9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAEErtzoJOJAVH4e9aK2fZDKQWh6MPwFOuK/BSiaNDs=;
 b=PuGhbsf2GD4t3MD5yWP8DQvcz/lewlzMPaI459TFD58e3rmk7YWBRiM8CrqaadK4vWwGm9MgSMzsTNFgPzj23GlDKOi0JiCZA3AttgqT/E/6dfjqcnG8IxE+hMxelDaVJA2vf/weBa+AVd/yfC/mB+EDATsv1j5u4YQJBtQajgasEFw419jSPtoq+zLk5aWQti1dfZdq4uOigVGoRRmc+O3EB8mw3JuMo7YiVaCJpXWY34R/C4nAkZhNdxbzjtUd8pfAVkM+Nn1ZkveoW/0Q85Tf94RZ41MhXjOgBka9Ix6rjvxhQ8kMTHyzGrvzebksnERYr9UuQkXyepY5iq696Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAEErtzoJOJAVH4e9aK2fZDKQWh6MPwFOuK/BSiaNDs=;
 b=kEpQITbI8VtFpVcdZzh+yrZBhqNj8vbmLMQN/f3wa7SX48Jv3sycOaMMghkHgwANd+r9O8JOAfjHAetWP2vLf4Nd8Z5tOvfKgpn//he6Bgs1wBnHeGPcmHzlQKp+MpcevcCwW1mcoahHDNBpKWF2yz4/vyQ+nQuEbYF/I7EACts=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 02/15] scsi: iscsi: Fix offload conn cleanup when iscsid restarts
Date:   Tue, 29 Mar 2022 13:03:13 -0500
Message-Id: <20220329180326.5586-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d82f8d25-e4b0-44d2-3d37-08da11ae71be
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584CB5DC0CF0BEE15BBB8B0F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OU1oxbXxqI/LQ19C+dSTM7Yp0C82PvBg9KBJCVApJaNgTHeDK2v6iw6ZtMvrPExe91WCLjilLhg3fNBEdbvruiYptKwfVw7m6/qUr3OBx2T01gs5n3zqZYa+RbskObBmOSS64BwxtCq6J7dU2b7RV5G+VQlexBInnThAb99i+dmhPrey3tnxvchDxpXLQhFDVd9M3GH4HAbJny3/QcxJ3AfTRQqQAHIo/k5MVe14JyuPBeUvHrOi3V1LqHPjis/oZFpfKGF2mDB8JQTmOei7iqCT/CEkMyqc/eGKs2SGF47XszmnbYTZ1RD9xceFEMmRv2gm9TlQ67gAaOoFhUOu2lhLXfDgUTAtBFe6U+xdaJWFUVCmoOhyHRtwlX2GqS9kpcdMarUSZ9FhocAMAjU01iaT3IWQOGaorYt3mwOpU87HqDElDt7hgpQQ5GB6pBH7aLtXHUAdNLBOJw51XTx51GQsoC6zmrtZQtPBwl039X0rzXtkHBAfo8VPuZUrrnTiPEgaFpf8TrFyVxcxTTgVQkQHRreRhvoDGJb0idNPZfj4BuWM0fc1yk4EvKKJ3cJIL1snjA6rCyPw2p4dGR7evlPkE/rtT+kFhMNgTJ7L9FJOfRD8CQS+asXw2SY/pg2TzKSImPwIHiZtvUMZXSWPQhkoBJu+FKwGswlpMBYC8kDnEZPshOw1QsTOVSFh5c+CZASaIkC5WdpRnHfHQV9CIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2ErCpwnZYSerq20DL1RBu7S4gKHWHeyvm15we9g6WzdjO30XwRiTJBGUAKT?=
 =?us-ascii?Q?IE8028PUKeIowSJb1UkXt4fi/JOnxwPyfLE9b4d30qoHUvggGuU2EslfJy3S?=
 =?us-ascii?Q?MF+47dvzzCqw8FE9acxYEFuWlmAcf/fHGo5bP9LpTBfFAlvqRL0pMfTbac/Z?=
 =?us-ascii?Q?C0/SbUhI2BG2/v8mRdRXj/xlrZrEr3MlWjfVGNDtSJT4onPw2c9jtKHoDa0o?=
 =?us-ascii?Q?ZmrWdx1p0FIpg1WLivyHPC2Tz4KPJ5+i9J5AWKbR04LVmy9OU1LP0xkKzZeL?=
 =?us-ascii?Q?9Cdo5qQq/E7+OyqGcuq4gIlbAF3H/geWEHnUOZcEYdf/8BRMWFmylXN2OQYy?=
 =?us-ascii?Q?3GzWftEewnFWUWY4cWBVbw0biybagY5FT31iN6owdHRa/scq6NZ5Et8YgOC7?=
 =?us-ascii?Q?3b86IH7LSPlltByLmsvBvw1lJXhD+KmxyJ7QkqxnPZrBocdyBGFm6YI93P/E?=
 =?us-ascii?Q?uH1/JT71TRfGA5Oe36/zxtXJdWVsmfuhA3TshGYyXk8k3fRbTATwFyu0nPpA?=
 =?us-ascii?Q?6k4M5SO5rxzuxJjCy2RNljSHhT+a5kdv6xunaXAAsquO/p80bvTVGNf/vdbS?=
 =?us-ascii?Q?Nzxfk+AapwPghITAVbkicJsG+q1Dp5X1Qt1vB5egyveKyvlOmlL0aJN3fCM6?=
 =?us-ascii?Q?6I2JQrd3sYkExizFHaHN6rSXmr23qOYv/rTr7kpTnA1Ka4mjwwYvepYwuT4E?=
 =?us-ascii?Q?dZuDRjcsViZPUw1w6OqPsT89YVgwAo1pUR/dNDjfLOsvZusmn6ddmqolRpbu?=
 =?us-ascii?Q?M0lAYOY3vAnkWvatpM4UZQ3cdneBym+Tpk3d3wd+NF9Xr/GT2UkKqI0uqBBc?=
 =?us-ascii?Q?I0qt1gQmjgPWWwiKMZuEnKdJtTJt+kiK5htQLrNgTzyTDJfkU7ZdD42pMKmo?=
 =?us-ascii?Q?QtMOKs12auoZBQTTm4mrlle6iwwIT7EfUMJunr5G0xhe8cynLXJQPAKTJCpn?=
 =?us-ascii?Q?BkwSJKf1JEtCycCqAk+9ldNszrhZozx+wdXwC76q8mItuABKkkLqZOACVUQ4?=
 =?us-ascii?Q?V4SrezX/pyr/CqJHYEAcfQ7Wo/wpLmHIHXv5o4E5Ek8QRg4LP1RwH13aRybp?=
 =?us-ascii?Q?qNdls/eL5lMln/gkpnNPLOKs+ilIyyo14iJRb8jPEtQl9EaQQYKxCEsWqyar?=
 =?us-ascii?Q?Drgn3VK7ptFDI5vFP5XbG+O4lqEzNqv9D2UioCJss57TfN0mGKAJuGsrHwYj?=
 =?us-ascii?Q?zZC8jUdqj6ZHZ0+j5pcpIzI1nugYSRxhQdvs4va0eD/Rb8mPgmPn+mo17kO5?=
 =?us-ascii?Q?ykyd68IOu8Q0Ov9+6pLwzW2cM5s7JY44ty5hXBtfm6ZkJKuSbn4aaOqFPh9U?=
 =?us-ascii?Q?pg1PtXvo2JbWKxey1GuoWlDhQGvVm+0hlf9+hobzsZZ44VRET1rP/mFHEuBB?=
 =?us-ascii?Q?fVl+7boPoFdSSIjduAUewg72LaS0e3y7cY+TGyKjUmDjkwdIvOaSiwOetczQ?=
 =?us-ascii?Q?VYLOYK057GxJ5NzGAolMa8fj+ociH4R+OZUHwVognx4lm5pIRJcP//XE3v1H?=
 =?us-ascii?Q?+2RHRiW5EVzt5wFR3ptZTchaNi/kFtEMq5am/jR4zpGFpO9rwWOoaH8t9yd5?=
 =?us-ascii?Q?B6uNEA4bQag9SUT0wZGupLe8Ht61NP6ozrf4ubg/SAJZz8py6CHMUq0qPt5R?=
 =?us-ascii?Q?nQIDbdiVpAjsSH5vQsLAlpNQbGYNPzEbhIEyVW2xNfphHUs/Fc1mXEfkTK6m?=
 =?us-ascii?Q?Z1f0ed/J6Lq9eysSJlTGDhUwFHWIqsVo4F23mj7yg64ScwbZVYqASBZdt+oB?=
 =?us-ascii?Q?ggXD90jZSH3afdyG0kvtbpO196INNtQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82f8d25-e4b0-44d2-3d37-08da11ae71be
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:35.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqYTgTrdfJLBf62UOr0uS411dzNL+dEuA6KugJUuUirF5c3avMbWXofXsUA+PfC6QWuPIpJVqHZSC3uozawN/f9dhW0b+/bPML8y2qTzxsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: UR4jTJO9-q7UTyZKOdpkLf4-zaHWh9fK
X-Proofpoint-GUID: UR4jTJO9-q7UTyZKOdpkLf4-zaHWh9fK
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
 drivers/scsi/scsi_transport_iscsi.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4e10457e3ab9..4aee0441e624 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2260,6 +2260,15 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
 		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			if (conn->ep) {
+				/*
+				 * For offload, when iscsid is restarted it
+				 * won't know about existing endpoints. We
+				 * clean it up here for userspace.
+				 */
+				iscsi_ep_disconnect(conn, true);
+			}
+
 			iscsi_stop_conn(conn, flag);
 		} else {
 			ISCSI_DBG_TRANS_CONN(conn,
@@ -3704,16 +3713,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 
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

