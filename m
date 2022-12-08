Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83091C4708D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLHDKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLHDKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884DF7614E;
        Wed,  7 Dec 2022 19:10:21 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NO0vB016777;
        Thu, 8 Dec 2022 03:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7SaYBMj7V8zOW3nMVU5O00zRbPOiXi9StkVhNbMd7sc=;
 b=PYRQU8a7hKYppICQ7p4ClhRppjmgKHD7h/ARdYstzE0gz62mqNu+s/RTnIaI8tduW7Mz
 XFqKRsNvY1z8Tw5ZkOzQMQ3q8LDgUDiHwiiGt76xTtvAJzAYhUc8aU2EgZXTlu3DlLv8
 JQ5X7L2curbk/U6SYalojRizbYJGwaCCUANaWJeknvGL01r+xc79bS6hqZVh2kpWwQ9z
 vpyGK3cDtX2HHXu1eW6d7Hm7KvirfD5Pk4nxUmU0Fmnq6ZwcSRpJr+2ayjljGIFn+fyB
 0K5R9FoiOWyzEUgGC0XxcM3YOO7BRNDBO51ZIFk8dAkI2h+bvurhZWF2tnW0NZcO0Dkv Gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkht41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81cZUN001925;
        Thu, 8 Dec 2022 03:10:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7daqke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITubdce8BIsUdU5y8TO6IpdIVceJiNyHghK9kjvZeD/cwZOvvmk1mzTbq8A3KsBpOQ9RdmgSl9F00x2Fg7WeKpLJRzE6L25TStwRX/dlNyb3NoPHrxiAkncD7ExXHkaiaKQGhJlaY8rxeKsAAk9PqRDreN8fY6jK6h8ZQYKviHMODq4g3PIK5a0fufzs9FmUsLo06K5Jmt3bIQk2T8SD7DGo66vzKvyWTS2uNfRPIrd9FDiTdCk4+2N5q/oekywlwXEH4jJRkGHGPdkv9v43dFn41AnRlEIA2wpfAHrq4IvOvZXTwp0ClHDy0++sSV2YQuNSqP4wNJI2gl6wJWbLAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SaYBMj7V8zOW3nMVU5O00zRbPOiXi9StkVhNbMd7sc=;
 b=oViCIL1TSFMpkG3tZTjI+1FpGFe5VUxYt3ZP7OFmgBO5tzxUeB4JKk8pOFiE44CZVHiYDIeYBspuMCIvMgQk7zwHJ3nXCbcbLdk1q3pJO2q7joDm4Q1grO3eKEe4o3sF5aTVWmPqRCVg4B6UTuF25I+oKbSO94Cxnf4DkUG/+X/x1jFBCA8qc8HuNxUVi9Htp06t9uHEEyFCgVWbzHD0gj7Ss3/VPfcSceKbVqnJCFqM+IJ5FLdE7m5f0BxgjiD2vhbdmpA5Xm1LB2V6Psa2dNwxtSIo7bU6UXc3IwbMyYsTW3iOOdGfR7JbbQuOEc01FcQAzdHrlB3RUc7+H+V/kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SaYBMj7V8zOW3nMVU5O00zRbPOiXi9StkVhNbMd7sc=;
 b=P9WkS7CD+EhXOXHKCv9dcZDZf8VTgIFYUAXBHX6FWu0srB092xt98sEdfVl1/pNsEELRxeHO4M03OTstFNuBn9YZU3iw6NoX7ra5hNYeQNCuzUu78P7agR1mZk/MyhfZhDnhsVFz+zKv11Fax2Sgr96FlhDhpHV1xXNGAaQtgfg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/7] scsi: target: Fix multiple LUN_RESET handling
Date:   Wed,  7 Dec 2022 21:10:02 -0600
Message-Id: <20221208031002.106700-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:610:5a::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: c3fcc6c5-b34b-4264-0d2b-08dad8c9bb38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jheNutfF1du/UEZl9mz5ATFdaQJXk7oNpTXpUss65gKbpdGE7QqH1INv8ypsnTp9s5oPUCxfU6Oiru3GJCcUmiHuLAAkwGA4RxJo2gAxfp9UMrdK6e76rV5KpVxAJB2Z9zSa6++WsrsbVUnE63w7WnQG1AnfnTMFcU5Ln2K6h+HKQw8tevCZLdh2ibNCrp4gTpDRCI+wfoTB5e3+AisLdAswO8fN/g1X1OULnG41FxRsI0XS4d3pD5jTOxURzo79NkpA3u1z20art+9NEmt9nxkAwOYq3k7shp/oOYhJXQ0F2zqxhk9gYR5Nftp+VAAah8vyX3rEiShxMHPyeG3Pq1ztLILQVfAReRQR8/LiDrA6Vy/gCQavsl+w4V1P8Ednu7YE0itxjJW53gfGCtb5vie2/nOmJ+km3B7Gpv2LGuAZYr8gklLQrPWvC2TTmeQmlvOCtAeWs/79KbGIBVEsQtsd8ZXftq7wXLs9/XBYsChoiIK14YWRkJNPV91i8yqSMNyzsyPCK7TL39jCLx1p7wk/oupokWGgcPk2beqnNk+d7KXGH0uXjjKzuVaeFJpghYsO9bhiQEj9moqwZaOZqus/7Rs3sSUlqX19cQIQ4v8dKbLhQqLw5Fgdgvstt7pba291VBmSnL3P7UNaJYf5Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P9OAYQFNQRapCPaUw/raLAgTsgiXzlrwKxo5JV8JaiZiAiGlZLZrLBbRjqz3?=
 =?us-ascii?Q?yATZ29+qQdbaB7bPkBxz62Ux6BQoCpWAAOZ2Pepi5KQnnFSzSF2JrPKhv/ql?=
 =?us-ascii?Q?AG73Rf7bF9bpPI6PoIMetQk8G0bBgl3baSvnYQrog77fp0iQw9xnvBOq4Oyz?=
 =?us-ascii?Q?XGNETzt6juSpAc20nQOhuEWXRq+3B4hUnzQ33gz3/EJrAIQl92pdQQ4AztRX?=
 =?us-ascii?Q?bEcdC2pvUZ40M+Qjq+2vXPUXsqLQCvr4O1w7odoGa6gNf2DEdgMXLbgIauNZ?=
 =?us-ascii?Q?uN3s6OHbYSozehWJ0X8gjjD/CPlfJMD/oGb/bZgt0E0LAVr2HSEDfZ4+maCx?=
 =?us-ascii?Q?30UKoPddrFyEY05vq77hERjoZ3WnDnBAj8pOKDSe5HK0TpN7GfVJV+DlHxho?=
 =?us-ascii?Q?JLN7tr0x29R3/+oHmrEkt6kyw+tcthTZacq6MQ1RquVLGSv7y5YwCC8VzCud?=
 =?us-ascii?Q?T94k+ZgEflvhrRnPe2d/C+M0xL6veZmTHEDIGAeV1doSO6RlxJ6x1uUESu4i?=
 =?us-ascii?Q?33vXuxy8+hjMptJ2lI6MLm7UJVuirGd1jzZ/Ica6X9JqNc7Ra7Hlgf/44WMt?=
 =?us-ascii?Q?xEiaZK6wUUtBxxo1JFujS95fXaNa3oNPHT+HKbvshGZzH2ReBZptiPZkaIpd?=
 =?us-ascii?Q?rOTnYtFjFxjXDfUsiA+LHzi/zMggJPm4dxAjc/wbMsoZv6JD5v44gE4Dh2e6?=
 =?us-ascii?Q?9YcNvtroyXlC2RTvKVjgAQbNcYLR4paL6u3faPZetwh8YATqCz10319scW2n?=
 =?us-ascii?Q?25c0ajU7eDIK2F6IbA75HQEV6eEjd4nzLiYHUWZqcokgJq6iuWDG8+InAAzE?=
 =?us-ascii?Q?KexNBCwJloajDm5eR46lJhsDsKmYiSQVHa2mIACmA+cq4OpftIm+RqDXvGrJ?=
 =?us-ascii?Q?BhGeh8DTJ94QKIodqbH5aecntvjbJL/nFb2KQdAdvt9+GvG8UQxXdSOSxNYx?=
 =?us-ascii?Q?tyDrsTfJdkCkuwrE8HuuZ5D96RAfLj5u1rQp+VeWgqrQLUQn2s/B91DAJAP6?=
 =?us-ascii?Q?uuachA/zw1UjvQt7qsKMErkPxaE3PKtZ+TehgDwsP+2FKOo0BuRq4MhetqAp?=
 =?us-ascii?Q?fH0Ymi/aABXb8Sj3L/QvPz8Eoyp+Nx2zqDURiJKfMQKpQgDECBKwOP/9vq25?=
 =?us-ascii?Q?LXHRqO/PvkFttnYG00XR3uY8+kuxcmgyBIiDTsWQhxOKIoAD2iV3xfSQgJuA?=
 =?us-ascii?Q?p84o6qh6FxCNqp+2PP8UahejloFqdFFA0rdgY6JfX7M2/Zh90/tIVp61iNue?=
 =?us-ascii?Q?CiaZ9rVv44ReeuVACzaSZ7H1PZNF6zgSgSPnZ9vVvjkrhXMXRXcNOg5sfEBX?=
 =?us-ascii?Q?ETcTDoPp1roqvE+noVRQ1lmXndANKpaDWBf7Z1LLUTZQBLLoysdD/gusR9gE?=
 =?us-ascii?Q?78LIypdMMXWXQo8/imTYOCftc96Ro+zU+x0AqjdC5sfd1XT0csghYnxZ7D3i?=
 =?us-ascii?Q?IT2qrICdQXGGHcEgi7yH6MjH7n+BhVsdAH0wY+avRGsadub4t4J/w0lDS06t?=
 =?us-ascii?Q?UhmK7Az4R5p3dcOql8EGYFY2GeJlIE8NaHBdAb5z/gBsd4Xl7tR+Sc8U1gmN?=
 =?us-ascii?Q?tRS+5KDmkhNvns99C7H1FkhggtVQqTTnwMvtSPsdM+KF+30M1RDs/BLas/Kj?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fcc6c5-b34b-4264-0d2b-08dad8c9bb38
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:16.8635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fe6y7AEVoTp0eM6yIASn99myPFniPGTTWpzRqyJXhE16bJ7bXGpOxI4huTg46h7ZE6+AHEDYv9Xm8uyq00iVET/pEEVEWToinSgzXTWPhlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-ORIG-GUID: KSAcilpD5O1J7chE8-i0l8Er3EH5aWuP
X-Proofpoint-GUID: KSAcilpD5O1J7chE8-i0l8Er3EH5aWuP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug where an initiator thinks a LUN_RESET has cleaned
up running commands when it hasn't. The bug was added in:

commit 51ec502a3266 ("target: Delete tmr from list before processing")

The problem occurs when:

1. We have N IO cmds running in the target layer spread over 2 sessions.
2. The initiator sends a LUN_RESET for each session.
3. session1's LUN_RESET loops over all the running commands from both
sessions and moves them to its local drain_task_list.
4. session2's LUN_RESET does not see the LUN_RESET from session1 because
the commit above has it remove itself. session2 also does not see any
commands since the other reset moved them off the state lists.
5. sessions2's LUN_RESET will then complete with a successful response.
6. sessions2's inititor believes the running commands on its session are
now cleaned up due to the successful response and cleans up the running
commands from its side. It then restarts them.
7. The commands do eventually complete on the backend and the target
starts to return aborted task statuses for them. The initiator will
either throw a invalid ITT error or might accidentally lookup a new task
if the ITT has been reallocated already.

This fixes the bug by reverting the patch.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_tmr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..ba2a2c18dae9 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
 	 * LUN_RESET tmr..
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+		if (tmr_p == tmr)
+			continue;
+
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
-- 
2.25.1

