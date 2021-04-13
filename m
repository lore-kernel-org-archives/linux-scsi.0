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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107A2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB4B761246
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348754AbhDMXHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348749AbhDMXHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DN0OcX033816;
        Tue, 13 Apr 2021 23:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=K/B5rRNmYVJNN2J4KA737HZkJVg5xY4jizf6H3gDQq4=;
 b=E5cPMYtuj6vw0O9fYok/2Wphwwvws1rhr7ImU6KWgAc60Lo4hmY5xoE4w7wMDvU7GCrS
 a5if2poqoe5Sx2VNIwKo3ruML8EO1Ei8YGeWpp71J7OffyD8in2wNfu5pNKi0DYyUNGM
 R+j2rochqhPPP0xzKZDc7ggNGKDbhq0Sq9Ib3QfaCpm9jNzp+2b9pue2TbpGF6qkW9m7
 s0wwGpvJK9pk/VMbV2VkEoply19+9NLA9L8zzT7lMq69Uoun5hGAwrYz8XuP0YMCknQD
 5OHDHoZ1ecKbEYH3EqwKNXIYpWlx0zvKqYuIp9hTXnikqz2PA12kNNBXVGwEtwe0lMIe zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3ergpf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjgkw142878;
        Tue, 13 Apr 2021 23:07:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 37unx0e1jj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw6C5BnCBHoVu3NIhnUI3QGcFo6rF+ZYYR5/lHpzuQi78jxiZIIOgRJS9x4EODelYcqV0sytnNEJjmiaFCw9t7Rp0v4Snm3WnNofEynd0pnJH9N9IgIN97If3h3M6+aOYpkBuc2om+eXRjI5ACF9UZtNma0vjOC7BpwnwUzT8SfEyZ/SXV62iydwiqMgOLR1UMn0IBTGn8p9cfRUMesNE91PWatWhBftRvn8xkFXFEdE0qYbnyfQPa3F07ocEC+TawUcnDv3qSkJrXogd/ORVe/Oyoio44feHwBGQAqwV1WtNELvLVOAE5wxT6Op1viJJSnOh0x7T8fVzAcLJ87t9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/B5rRNmYVJNN2J4KA737HZkJVg5xY4jizf6H3gDQq4=;
 b=CP3ljELaHcxGTzr9tsWOLixUlObLlTC0o8t52hwALEPuxs8O0mA0t2iPjG0JKEzQR8DJS3DZVjqsEb1iCnfYlDbuSIojOfcVotnnJuA78ogauK1M1B/OSCa6JxaT508S5bBf0H+soRF0fv3easftIuMx7ZtwZEiacslkLAuSZAGhXFSxLNZD0mO66p5/YpCrrUYcXxNFz5pSBHlY05iqEn9Lnow5cqODGrbqIez4a1QnxKi03jVE1wFbPVdh3rnZBPZKZIqr2kz2Zzxh5Ud512/+/0yijSA7CYgV8oIOixGUGaTugOUm5+73Pq79qmPF0dkTNNKEnXQa2zfrckgCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/B5rRNmYVJNN2J4KA737HZkJVg5xY4jizf6H3gDQq4=;
 b=y1wnNieCjU4B1eqCcLqYkkzvLkMm5Rf5P61X0qcSBRyM0qqWpbuG7tmqCDWjxLFkcN3n+3HruASijzR/jWt9eDXqFBSodjtwfoKgzABOpnoGHHfUTmy2r8EUTR01epkdvjVQreV+Fosv/oQy7lBUFztEBvP/DQxA31lDfsep+xA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/13] scsi: qedi: fix session block/unblock abuse during tmf handling
Date:   Tue, 13 Apr 2021 18:06:44 -0500
Message-Id: <20210413230648.5593-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:07:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff3d1b20-3d36-4f02-572b-08d8fed0db4e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2469AD3D7FBDC10C6BD3BB22F14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrtwOkejg9fW51h4+MOa32OQGqMGe3PcMVcfCNi2G0HUkFAtqrWcxrx2fpLzsk+msTmRGReIr/IWp5ALDVf/1DG5gy8gs1eDa7V1xEUge1PWBEDbgWq9cwp3amDEq2cYfCZ7f1jIf7/WzKIwUsO7gszIKZ7UvTl00Vq+3TFQG8J50ui8wdX65U5URRYSqNhsapPXJoB+tg1rboaejE9IWAXxa0UtrzBRjS5/by0+zTmQrdz+j0FzYnf/fPugzgJoSm4eUVBiqvW3Q7jmDYiuwTlDdgB3UDcSxgM0o/qJCCxZ8qfGEqMPe4cmaJPxqeTS3y1sc13btWE/iGZNdDLHXmhiYu+MepUtPr9QZ8Jgqs3w4pImf6S7AjshGxjn5m08fI34kL4+ugUK33F5J5cMlyKT1x/bySrXz/gM9GAQALzsj+OcBBsJku2/CTp+3g87onC6r3xALS6wH3oh2gIAKKlBXokxDgLRszSPPdq4yqeoyJNmw3NwEdUeTbhJTRVi2Fk7C8NmYe2tCQLJLLC4jA4Fx2K3eW9RCVLuNia1DoDlzfBjiNZxsOgwIC5/3lwKD8Q7NBigt0DANH/ZYU8A2SrqbcIX3tPw/CoIwvGVdTNIVIrezxhjcPMyoSSB0SW3wE6rLH/NpN8RHYFFQVvheThuzP4we6zfHmzNZw5ylMdSAWCccoYU0/yx5KaDP9mY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qClIymrSKvrc3reDh3ULfXm8dUrn7qsBGZoLWgt71b5aJFb8wcKDYJLPq2Bz?=
 =?us-ascii?Q?mbjVUw8GQbWRf0JzoAGkoZFRzCDXmlL6orI/lj00tB2rH7XQE4S13u9IfzX0?=
 =?us-ascii?Q?mmCNULOh9lW0jwx2ShncjaJhc33wXtcegnqK+I9jr5iOdAGzmeesCgpMEL0p?=
 =?us-ascii?Q?pMrDcFrLLVJW+wY9pFQG3HYOBmDWhWi3FxYl5tzY3ynDfSVzb1VVVDJvVMYq?=
 =?us-ascii?Q?NMMWko/1ovWVwMmkyDzRXOYPO8NMFn1diitoHtoRX5FngAB2+eX/KB24zseX?=
 =?us-ascii?Q?2erA9U1/fHGu5m/GSgLCIpGD0tYud0eEBcp4HTIeW0mCf5rBvm9oDPuY8tBp?=
 =?us-ascii?Q?EwTPsmtOw/vGDzy29/F5CY38HSmoolR5pBu6nauqK8dt/3qrqkzR0vj+00U+?=
 =?us-ascii?Q?rHimzEHMr1MA72LXESbnehSKgfYurYGyWlGDV5M5JZOhmOGBKM7ysyTXk4rg?=
 =?us-ascii?Q?JiFD2vdWMkWUPUQdG2AEjxGfoDucNY6GjTjEw6fkMFbcMV602J1IEendb/Mb?=
 =?us-ascii?Q?nRzY+YXpj4NxrQHE3jMJ/fLNz260IJ6JmmPgZc/IFA58NEFHGzN6Qw0yC1iw?=
 =?us-ascii?Q?3TgDBISqGx1gTcgte1Sch0toNkg7K/gZAGWKOexSdslo+z1TPpzI/62vxUZc?=
 =?us-ascii?Q?Vx5s5gw+haRo0z31d1b3cfpB7vKSzlf8BQa84C68go4AM1ARJIT8B8cVZrgs?=
 =?us-ascii?Q?WL8NVpEvPfCS8UIrTGtevwN1UTq7uGjtvN4aa7s+brFN3J2yptIdZ/xKJyfb?=
 =?us-ascii?Q?97hsGEEmfxnfbyva6tcTBcNeVedxqlfGMjSwYZyzlmv+oYUQs8KhkAbarVlD?=
 =?us-ascii?Q?wsa3Msf4a3dIN3ZTa+f67kdotdkA8D3vG2crpsWMnWtRfnCEph6d/DkF0AsQ?=
 =?us-ascii?Q?Z3iRsR1cOV17m9wvUCkD78yx88IcnQrF5uU70OBsj8sl6NhRpDvPmQtShhUp?=
 =?us-ascii?Q?O5x08hlQwu/3H2Q1Q/+4AvJqoCXa+veCVOtq7ho4JJtvjS95mGAfEGY2Uutk?=
 =?us-ascii?Q?/1y3BdUJ5HxcL4xxlObTCMFAXCz7FGgBlNltJw3M1cv1n8Pe5kS4wmxLtB8/?=
 =?us-ascii?Q?ifGcCqGbZr+BSmkYMshXSBHS4NWSu5qErNYqW6EVjm+QdC1d3GfjhXqTBZp4?=
 =?us-ascii?Q?xvXiUl2eXd5wV8WOBX14iy69nwlVF4rnYD9tTehJq+a2ksjoJGJWYDrFQOnO?=
 =?us-ascii?Q?/wj5LGTWt0xG/DRpN97zdtnRQOpOQ3N/JXgbR4h1j1rH6kLCVSAj6oY5uhMQ?=
 =?us-ascii?Q?vo06oZCXRminqUIXCQXJ6E15zsBVLZgt/yMujGJtj7U6gTfY34JgJy/n4MMk?=
 =?us-ascii?Q?/mFM5dysQsIwgqkNkoBKweXb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3d1b20-3d36-4f02-572b-08d8fed0db4e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:06.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wg3O1IUbAZhyNPNvedECVkmUeimpH1BHH5XqiR/unlsgWBcV1yOydfp8JclY8DjwyJlJP543TUq78Azqc9hKRoBhNMNjRZXzs2pBDz675f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: oQ7_TLqCLzCWI9z98Vetbuwm_zw05a1P
X-Proofpoint-GUID: oQ7_TLqCLzCWI9z98Vetbuwm_zw05a1P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi.
We now block the session for the drivers during tmf processing, so we can
remove these calls.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 84402e827d42..f13f8af6d931 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

