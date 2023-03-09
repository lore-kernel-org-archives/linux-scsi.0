Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC398C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCIWdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjCIWdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF9B7D9F;
        Thu,  9 Mar 2023 14:33:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LxOND007024;
        Thu, 9 Mar 2023 22:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1LK8xLuUsUctIph6VpQLPS4P3rEq5fOSKGhU+2oH3c8=;
 b=g10YNZbrT1+NvxZ/CchzgM05yIkA8truaey4fHXow+1ub5DlBLOmbAQvACLatVvrauJH
 H9EJy2RAfMu23bsWWw9D5jhb30La3lM14y+DeTTD85fmWXoyR2w72z5w10AjABi+Oyld
 Frcqet3vFaqUUEVRVAb4uNPBQyyE1lw6Qcr7HM0/Hix13JlkDqUh/wH889jp8cgtJAS8
 AuI5i2pjsulF8w3FK/bcbzqnADyKd3X3x+1sZtvtzz+W7SiilV73opi/P8cYhxPk84Ek
 xChhZWiYCodPPW1GPYMy+H/SsaCIHCn5XqJsQ2T1nedQAssu+MwEGr56CbKJLgUZWFOI 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41623wtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86G007359;
        Thu, 9 Mar 2023 22:33:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWTN+VmpE2MJFAjDP+55BU8MQPZk5XvKkkO/yzdWM1DGrsn8u94O+DodWYyXSvzJeR3jGAu4SvIpFRUWf1dquPd4OPPmAPK3o6fkN718t1FPYyO4bAiKISF58pQ9EmZpQg9SxCm6lfujPLU89DddqkVaVPC4BsYn+zwPCbRthehuYh8rzbt7eG4uFMeaQzpjIKZMRXvwrSFQSxD4lw4jazhAQU8v+GHtywunFPyOhqTxjXxxAd3sZ/tPaEQcvjQ/UoSEyFQgCsVH49tyP21WjXVmABll/1TkoFBPfE1OCmsZO9PX8me8NhErsjLtuEndsfwMGEqJ/Uehup7uBbpW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LK8xLuUsUctIph6VpQLPS4P3rEq5fOSKGhU+2oH3c8=;
 b=WKrMex6AYHlBoJmpqNomrypiUgI6Cd7XS0WgwLV76fefyZwezWsSjoMwU8kKoCW0cMM9/WJvkC4mmhhG1dGrQLXKNkyHAgVazuLPVU+TPegEDMOk7djk9FETrJoJnBMFQ+nKhL0XbfRtMt1LLqXu54sUzsW8/jEcMRj39fMON6L2slesBYKsHYbyGuxTTXpJcyVxX8qH5oypfEpzNE1LcMO7Hzn6MXGLADZCPRpsab6yPfGAY3sJ2NybPKdUZSNC9QrOs3+z04ugREcm3QsnZRaHJXFjXSZi832ZAS+bP6Quu6mJ+K57ETRqupfndJJPW1ISMHaVTt1xO5UFDuJbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LK8xLuUsUctIph6VpQLPS4P3rEq5fOSKGhU+2oH3c8=;
 b=MaynjHCH3wJz054uD05lbMtliObAhheVOt1YgBOv7J0TE/n/+nAaikt0IeWfIIeJbeDclXoTur+lzMu+XSbppOd+k9QvDD5ur7mwWRCvjAPHnBksz2cLwg/UBi/t+uh4IR2yT0MeQTH6nCE6kvvJbSpczivL9LRdyFn5YGvPPkM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/18] scsi: target: iscsit: stop/wait on cmds during conn close
Date:   Thu,  9 Mar 2023 16:32:59 -0600
Message-Id: <20230309223312.94595-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 171d8a04-47ec-4dd8-d434-08db20ee4a3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3vZDAonJf+bSUBpsN5a1UIxsURrMmqhwL7Ai0yUqLsVTcca21kXmVCFjSghzvzmRAkzzW+wePYKSxpl4gC25Lou2SpDPNotkBzJRRbQ3scLwcHmd8viK/tC5n/VenbyhfBbt7VPDVrqpGpV+6u7chB8Sn8nI2TJh/mhbwf0ed2Tucb4OzmnFz1sYDT2GKQ9tFZggIA/PQFgSXaRtZDSMwRraN44RN+RRLPihjkg7ko8gQfyw7U5PxXn2EiOYrI6Eb0fSvkswfS9QglUIjGCi0GhC4RQ9komWI3xSMBXvGgJHeHtXOEfKqJv1WmXLgjNABPV2/kl8E9k5ESZq2u7nz+EdjRHrP2CTGyps6As/NMb3cJXKTwQFQnTNAn4SuJMCPG2FJh+8xUnF/DfSmlgyhcffyzBR4ha+iWwXHehTfZRlFqsZ0Wqe7h9apONc9o3kUCLQ/ShQJYbmHyDRklhw5rIfZ/A049C0cFgCBDQJyMK2Y26N7ZeADKhbebMex629Rk2Tx/w7zcTCGaPiapEbIcuEzIQAlklLwQWkuTF0FMne1vJ/N2PZgwoIus2CVXdgZfbcy2zWuxLnnBGGU7ekw5xpcsMG6l2YLXy11NDv72rw/bMVy4Suh1IaPOC4ZuM++mWL6HDkT+g2eMUvQOC3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4kAooDQPocAJbHk6M7OFvraw+5PGAqDCRcIN0zRnUJWHUsRYb1wk8yVA4Hvs?=
 =?us-ascii?Q?VT20iVnPUJMtCO95MDdAwhn1e2i0EfqpnSHkbUrnSpcPpJKc+vCSap733+YD?=
 =?us-ascii?Q?LZkAVYIMV40y1hMhH1axMY4vLLu2LBnzCdKOd9B0Xi+Udqmf/w8MuiQg52sF?=
 =?us-ascii?Q?PrpOL8UvCBmDOVt5W9+NML0Jpt18vsUJRwK9C7ReG2AuozjstOwxpMwDOmwE?=
 =?us-ascii?Q?bweT4WzaUFnCb5C+jP3qfJovsukUI3EOtrAhwEzxZYzxX3oIBwQSf4WL393f?=
 =?us-ascii?Q?yDZyHJSZzpMR2KMxEJdxI4ffPbgTCCsL7hMLVDDF4T+8KUP3RUX3R5lEF+IK?=
 =?us-ascii?Q?K/762LXqYnhHoi5zuYS9efNwAh6NP63NLhQ7wBT+sxAJkLT9Wxc0E79t2H/q?=
 =?us-ascii?Q?6SXSCvTCSAyrjneJ7gC1KXIZOqOKFkO06edzFrHhkuBcMec2U742VooXijhn?=
 =?us-ascii?Q?6e9nYabr4YPQBaUpZjnHZCeIr1QRGgu7shU1vg8TytZalMeNV5YqrsitqFoQ?=
 =?us-ascii?Q?5D9PnXDG0tCEVYfILC2HZAvcCTMk52JTHqgsiuTWSppze7iPd3vi18WjK7pA?=
 =?us-ascii?Q?xSjWvnAo9Vw/RfYODX6h6ILCi9pWgbtfXoCm8vRnYXFY6eAXLHwPw9rK+U8B?=
 =?us-ascii?Q?jsbvJsOUfcNqNjCTR3MyOTAXLCDgeiBtJp6VS8NSAGAMz8YKdoGA0Xtqd7Af?=
 =?us-ascii?Q?IVkeAjrsCshQQQmiYMX0uZDgJ+lc6or8OCrJZRICtnyBoCM2Rn+rQZqejvlV?=
 =?us-ascii?Q?Xhkv8j+/XKCAhNwuM+EHbwZVytGKiCSpW1qxxE+eLlwBFc6+7ifQILN9ckv2?=
 =?us-ascii?Q?DiL7H070zuqWRtHuYe6UcukSs2g491qIVumnDuQ85J7gJPXGgC1a5MQ9vGaY?=
 =?us-ascii?Q?ySX9n4z1VNY96dgj2EBWgWr1VJB3saVBbki8ff9m/rA/Be6/FRr0gjaN6cSp?=
 =?us-ascii?Q?40w/X7SFJQI4yeagzV4qXlO68VK0CnBnFdA8f+tO4lGbPqhBhR4Wm4heHwDk?=
 =?us-ascii?Q?97hJDP/eDK4jcw57k4N/fk21lOE8o8HTMOUMpSa6EGU8TuTEv/tNgAJPOrVu?=
 =?us-ascii?Q?xivXxjNG7MKKVsTyjZMhLIm9FIB/pkKQUlYfSxRiE4IKE/L/mdIy1pVT+4F3?=
 =?us-ascii?Q?1N6YygQVjVTrfR2fSqXlCmaIAHlV5/AyiHD+q6TZs1YRGpae+bseHxgs5XNQ?=
 =?us-ascii?Q?YgdJR/eoRNhpqWgmxzZUZmt5JoknldkVpLxUVwwnqNMAZY1Ib2BGjrsXfIu0?=
 =?us-ascii?Q?+ZOPNXzuqKNmvd9UPxUZc1QkyLyxWRebBNdZGny6zFzLxK3OTWwxxS6qJHxF?=
 =?us-ascii?Q?CKbrA2mUKw6/T3VQeZclDnpm/vkjd0u4L0rLmyJpVFjCew9VfkCMJMB59aJj?=
 =?us-ascii?Q?jIeZhTxBLjkLKmZswc+6ZppqPgZtEMSUytsmgOUSi4AZ7qEOoysTjbKsAtuj?=
 =?us-ascii?Q?D6WGyY8CpfBaovKOIjgo7GTFGYMYwemfcfU7F69c68gVANTjJOaLyDPspFiM?=
 =?us-ascii?Q?zCoXr4yOkgd6t065YWPuHatvD8i4EsRsHtJLOwSXF4u/pV7jLVBKVIMp4/wq?=
 =?us-ascii?Q?IAgq4kTaexTlSOfm77hVDsVkmXS3rTHQocYRZDKFcLnFnLgmHkpbX1RR5K0I?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9qhU1LoI+tbvhkZ3L3N5cbEu+dfboF3GUugNaVP7iuFjJAgMHrmfG9gXvQVPvoye+TtH+687GtM3vGw8NVJGpr77eeUJn45dFIB7fgSk4sJV3dQIcJ7esczx0iDuJlgvXRBMYc18CIsLrT3DtVCQsEf5c+i/DMn5UX/i4hLDhkl7X09SsERuBPuHotnxrXxdgpdkCp+ZNIQrpMFzoeIe6xFqVda4F+iqy+CQfA8qfsi4PWTe1GTwcE9KQERRBbtJ9FUKOSWjNC3iC9DmyLjez5xKwraMLc3djTCQ/zwltXfSRIR7Bv0gj3BrehJHm35UcQ7N8eyyiJaimsXop2Iksgiy1c08T9JNfkCYSqG5ceQOZly011BPEkmQpoW3PwwMQXu7aYqJRt6yV8DraMYbFUxgfSub1DBBixO2FL5NwERptiVY+ml2uELMWZzRhgTraaZJYkylFxqglX+ci9zXvK0g7kmSzcD+pZB78LPPipX/Eoxyn3/yp7ldXJEkhqajvSE2mD6BaPYX6hMsrDINZEsRT03V7VmltpE4A9lOOUTn21rabGUa1pk0fBUb/c08acPrOa6HJOLDHX8sF4co/j0AB9qyXrq7NM+CK+I/LzeCi8Scj0/Ptc7YNRdA7OY2rzXjCN3Bpi69Yao3LNYfKB+dydL+d9JGGLmG4a+CozcNCHmKojzNSc5CHgUmpcF8YdZeAUWcsLvfiN6oidhU7cd6BHx4h+iZlciEViUQMjyG2gZ0UqbtfFf0hS9ERGo15t/myu3jRIod9DIzncgQjXrTgzXY+YNfX09EgD1l3g2diZNwbfCIGstuB0tVesH3Kfqee9A+UOY0YoHsq6Qm7z7VCb+1jdB1XAR5b6QJLnKOPuKXmJ2hTRMAkvk5oQdu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171d8a04-47ec-4dd8-d434-08db20ee4a3e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:22.4556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOnYli1NIk20n59JCBmTuyZrVn/4Njk86aUVSD3T3+SaABVrd8ztVzsP28LnnPReGD3kDGg68eW+gNqhHWSVAKOvFpRGANHnngwn1m+V18k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: HGixoQrZ7lsY8ZEhQkBsmvmY8e1pLfpp
X-Proofpoint-ORIG-GUID: HGixoQrZ7lsY8ZEhQkBsmvmY8e1pLfpp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug added in:

commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
race")

If we have multiple sessions to the same se_device we can hit a race where
a LUN_RESET on one session cleans up the se_cmds from under another
session which is being closed. This results in the closing session freeing
its conn/session structs while they are still in use.

The bug is:

1. Session1 has IO se_cmd1.
2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
but then gets a LUN_RESET.
3. The LUN_RESET on session2 sees the se_cmds on session1 and during
the drain stages marks them all with CMD_T_ABORTED.
4. session1 is now closed so iscsit_release_commands_from_conn only sees
se_cmds with the CMD_T_ABORTED bit set and returns immediately even
though we have outstanding commands.
5. session1's connection and session are freed.
6. The backend request for se_cmd1 completes and it accesses the freed
connection/session.

This hooks the iscsit layer into the cmd counter code, so we can wait for
all outstanding se_cmds before freeing the connection.

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

---
 drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 11115c207844..83b007141229 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4245,6 +4245,16 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		iscsit_free_cmd(cmd, true);
 
 	}
+
+	/*
+	 * Wait on commands that were cleaned up via the aborted_task path.
+	 * LLDs that implement iscsit_wait_conn will already have waited for
+	 * commands.
+	 */
+	if (!conn->conn_transport->iscsit_wait_conn) {
+		target_stop_cmd_counter(conn->cmd_cnt);
+		target_wait_for_cmds(conn->cmd_cnt);
+	}
 }
 
 static void iscsit_stop_timers_for_cmds(
-- 
2.31.1

