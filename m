Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6573FC636D0
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbjA2Xp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjA2Xpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6374D1D93C;
        Sun, 29 Jan 2023 15:45:51 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMoE0x012099;
        Sun, 29 Jan 2023 23:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5T0Ai1XuJ0bbkbsZ4/ZjntFAn6cy3kS/uJ9L4YN1Bwo=;
 b=jWp+8M9QlS1y+b1mUyFttXtizVNMHwdTFRCiyJIhmEfrj3F8VATLCYSjleyoFRpZBcI/
 aGEqVTuum2J/KLsPpziwzPu+VoXT3eKPmz9jRz5N75/pPaY+Pby5UJ8TjOlHJIakHq0T
 QQgvn2Gr1F0e5Kt83wxiCA9RAdds/GOTdsJUmQ/v9ta8aYwk1qmQuCyiaf/s8X6Ow33E
 ZfmXz/7N6B06aktiiLiNiC78W/nKuiv0gbm0Y6gnG40VouhXmS5JrUjl1E4AWgVL0Wrt
 YXY7rTVmzLIcJ0lC5LnkcnE/3Z9oN3XE3ZzdjJ0ISWg5uh5ZsAms5Z/o3ybkHC/nS+Fo 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvm11sc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYU000798;
        Sun, 29 Jan 2023 23:45:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53drf2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtivldMTddcgUCbJXmK231QH2oJ/+Z6QcU7dkYSATbGa0TuwXcPkXcDI0vvoyIjYkonmPCIuyrIjpRyOAW3B25DWcnkxHUjKMIo7gv85VXE5RDYh5MublmZszWaUEwjPsMi7ujC4np27NF6rMyOOLe9RHY7BeEJkKDLpul3xy+zsZ9EZxBfNwgDy0XgIPf7jyxdbY10IYDaCKICuFow5kubly931S0RJF6z0sdfk6ABjDywJWaiYvmlB7bA/BYXqOIuSK+7YDRiyBvXLvmLzxHLImt2tyX0pUtgOYNP+rG0wqkIFmcxAaz41Nk7DhbIQeXhMwJ1yaKzZ55qeu+ymgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5T0Ai1XuJ0bbkbsZ4/ZjntFAn6cy3kS/uJ9L4YN1Bwo=;
 b=TsNGNILQXa0bPel4yWkWNiY1JPSSa+wSQm7gtsL6L0rcnCAMinA0CiILEBf6uRXCAJ89bVD1HXV9G1Xyms8z8M7PDGXQdd9bJdyjVhNQpnSUoDJBF0js0yveye/dmg7FQd8gHv9dYRovAjzk+DJguStOBxOjwj6O+MJMIFG5nXZjM2uG/r7vMKm47BhNzYoOV8ddv3SZQ+Kyn7P8eVnTetLfTy6FrwPXcd/VLhLJ4aY5xMZdX7PHqawRKeUpXCjViu6Duhxeg7LTAV9Dzk+UQ+TAjywfcyJXn39itSO9q1UnrgGkdxB1E4nnBkCj6QJ+aPyJbsBZB+7gWra8V32Siw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5T0Ai1XuJ0bbkbsZ4/ZjntFAn6cy3kS/uJ9L4YN1Bwo=;
 b=j0jFGqTbdfIz5CigqsjCZd9jQ5WOKfVOd8jF4vc4BPT0kraliPY+Zo1MfXETS6XnAAuYQNDlsnroZncz6XAyUGXXiTKuIxooplTi1uZo9lLqWrpBTdUcVVZKMav12YTfTwHwUMMYFh+FZy3jdb3CKRifAcRCVaoEiZRSonjq79E=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Forza <forza@tnonline.net>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 14/14] scsi: target: iscsit: free cmds before session free
Date:   Sun, 29 Jan 2023 17:44:41 -0600
Message-Id: <20230129234441.116310-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0102.namprd07.prod.outlook.com
 (2603:10b6:4:ae::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b34456b-0ba6-46d9-1d02-08db0252e913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cTYMckJMED4M3+T1+QhZC73mU0Qlv52iiamnSYLt7N6ETD0ZWVbBXLA0f7YSaAso6kYjBNpu8aijOMIb/pYvq0d8dl93jldGzo1SGO3prSw/fCWGL7OLBDDmwWeyn93HxUS5F8mhI1wIZ/fYuBoWX7J20RnBFpbzMzOprp6aN6DU3Aj2A3ejqCBUnlGqK9IZRJSuLDgw1VfZKAeFrCmQ6xDosW7wuAqunoD55FvPQMDLfF7SNJLJB3FmxmMLTVaa/Sc0mg804q6WNFx2XdEYHE4qARB5XZvPR8v0TN1nNE0odTqaHY6CXoOOeCLBvdnu03mNsv2/rLHy+2PMi33UIXByHhPGo5ZoVkYVig66B4Q0r5WOoGFtJjCvrNosr93MqBFXiKCjexMh5pvOhJH0L9VyJJ2EFxq1xO1OGxICyg4sHJTmnuCQ+gHMCDspu03CvayexCXpnyXaF1qJDRXC/ZDXYz6ZdZISLMKuzi7BgpCSLNfHOshLiRrHErq5prbflsaXccy+Fy9+LsOrYHc6qfaPu/ECgkWvYOvVUHZub6AEI9tFLnk4iTgAhBwp1ouNgJNx6AjQ7EKm7tF4MA5xgxBD3HuMEB4joYdQqfkWwnn5cO/wsM8lJuPEWEW2AjxLWbxBrovpT/HlyI/fBWj7kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(54906003)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bGduL4QGa/pQ0EYhvj+Uj33UKLjToMUhHj206CJ0ttk6RvKBRVcO0oPqN+k8?=
 =?us-ascii?Q?FES5uFmsaq88GutLPp4V+dUZPQwP0d5Zf6Ed8QYeXMut7+fRI+V/ea2Iabox?=
 =?us-ascii?Q?d/s3LXOFNWNqdKnGbFxQWNPEbb/vyx2ofAJtDS7mZdD7R8M/+TyJe+Eo8rb/?=
 =?us-ascii?Q?2tUpY4jvgKLfJyosw7UrxPCZQ0KwaOWhnwPx1EVHlH8LTzRNS+BTtOqba2+h?=
 =?us-ascii?Q?G63hKjM8VbHvFI48KpRkiUOroD0osYWa1dbj1UPrBEjQNNZqk9T7YBq8xi5/?=
 =?us-ascii?Q?D/+5GjN2jV+hbyqAvlTGdj8snmvApCPIfqmXXcgRUaVCKutAwwfLe/iuJYzC?=
 =?us-ascii?Q?Ta4WFDTBbNJSw/+YKq6dYFdF2iKfEUaUcuLZm7HJCaDN1j+M42vaZsgvoSvW?=
 =?us-ascii?Q?yvGRrM97vtszRgALapKQBrpT0n/cFZbHTWRT7dQKSJwYbPNxiNVmEqVZ4VUl?=
 =?us-ascii?Q?D2AajZS4lJDiwQCEJqCpdhbJ+PioYB36e2PFgCsk1O/ObYfNsCGIMyfiUXHw?=
 =?us-ascii?Q?YAj1xFMTyiWYTpL1tGcPKZPuT6aJ8wArDBcSP2HkzIl0zGg3TDnLwIqNHStm?=
 =?us-ascii?Q?EXPLXdTJJFXTlJzbIWt0RIa9qaODit7YUkdq0mjB1U4d0ISiP9rB7q/GVioh?=
 =?us-ascii?Q?V5GCO01gW7/tJuT4WVn78rj82N3NLAgH0KjF49A/RUIyCbjZtzrPMooEmGpd?=
 =?us-ascii?Q?XAd0EPiHRBFK1kfFc+oUJaEodiCkkWvWTJu7qryaPymIJPT3DJPaC19/g1mh?=
 =?us-ascii?Q?Ha9gikSmj67gV/OOVqBOfhzZcb0WZfz13lSsEldL3Y64zbaW8bEqcQY/AErn?=
 =?us-ascii?Q?IjJklmDJCWd63BY7OEuKiKo0cRoD578F6L3ekSi01ZYmDOHaCVHMcOkLsxMH?=
 =?us-ascii?Q?hew2+ANpWPC/hFqmmsgIzlqMu9RnhsTLIbH/JA8AIt765Hd9P/OIAmqxRQ6E?=
 =?us-ascii?Q?ctPehNvNgxwFSM6WIIYy+gsOqYbxPKrlt5PZo/Qi8F/R9QXfK/SNbJBX4FFO?=
 =?us-ascii?Q?DwQ5qo0lCNzxmLX6sLRe4Row/k/UMswB1Sr/xf0H903F2mGDHhj2zSf2PYE+?=
 =?us-ascii?Q?juLe07a3Z6osiD1bcyn7+zoBvVKM4c8r0wq1pjOF65PGNWkW3rselE0lTMSu?=
 =?us-ascii?Q?KoRM4SqcmdE4o0YI6gSWirNOwc6O0iujy2nkkHo3qzNe8vnGgAyzRsedteC+?=
 =?us-ascii?Q?n30yQhpBPR8wQWyUTUmrYcTcePBCfw7ulgGjoE4u2l1zMIBhbMI/M4/H/mj4?=
 =?us-ascii?Q?YCvmhuw2AVwB1AmeO7A5lab9SPtkznFUjIZw9u4dNOCaqpQf19L59xZvc7sp?=
 =?us-ascii?Q?PhC3dPiEx0mtBw6sUqL9HWUqF9sMvVQ99iHT2DefnCocUvq8DZpnxnXH2UH6?=
 =?us-ascii?Q?q9nPYm7lQtQIbv3t99f8NapwDf4WYZtx6d52lwxSxRPMhxg7st3mscwwRJ8Q?=
 =?us-ascii?Q?+EYsm9ifEU0NCO5HrODcimsQm22isVlh+f+FCToA/2wbEED7NVw2cBhFuRfl?=
 =?us-ascii?Q?yJ/IUbx1eGiom31nW4GmiUWMZtfrQy8CNI18njz3sDIDa5T9HNRq0gBDdPD4?=
 =?us-ascii?Q?1JsC5Pxe7x2gt2nyGDqAdlF34il4Wba8i36UgRYX3ewuYcTqZpLRNz0ytax2?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NigwveeuT6jifWQtJBV8+yE6VfOU518DW1rj2hKIXwUmCpfGhAEiY2uT/ScXAES+oxNZ4XTsf3EM0XH9qOLXOAXR/f2ExSKI8r6zpXOO4Ckm3A4hcxNIxwGVHPjCCJS4SFDyGFJY2VYoYXzIQzUelx+pZPJsig1Gel0HcC9g+4o7mDysdf2rG+SnWusPm9wy2RCd82DB0lHP/M3+00WWYnjuuX/oJbdEfggKS9v8QQ+JbW6rtMm/b/rUNU1wqdLX49asAN7ZLbAbJO4//y0qA1KO6q3oc8kPIGyzp7u74NBxox8chRJQRLIdaZ//pp/GWLy3BBggfsVCiAY/aEIIJ0vyLUfxIwrrFxt6mBwpwVreXmcw7CTUy8uAtBvB18i0JC5iRaMfRE9yEh9hxp2LuzJAe7CM8NceQ7uMJD2/+ybUv1hdqz/qBk4HIiOdeMA8zbms9+DUI1IzaA9mk6PvQcUOCGdBpexiJa6NaC/abk8cm43xyI38pA7p+YN5BVp4uM1mPFuN303Ics+b0x6yD1nipAkoVxt78gdDcZ5HTI9gv+yOb8iv3lNaxgA9Pxo9bGQVTV+gFxWebtytujWK1FzOkdi2pl2SHzus/Th42oL3Z8j7hRIpcR1rPp0PpgzQ89LG7JKcLJUzsvLkrB4ucyC+ZwQTQQpqZ87kh0wSrILbUcmB/atn65jjckhosc/DS4SiTBCnGvRgKmXhOzwnuubo3FqGHgRVw4DpCPfOSesh8LfEiqFtub/HR7IAWTfeb3qkeQG+fTdMbe2HO1DOM8YE4qT9uneUgXf+Wr+JbCHFPsd5dCsx77wkYrbluMfspgvIPlYq/vDm7Ajhw9WphrEqToqdghucllqX8AEAvR3+QJ4uSdVIbVwQYDYbjmOdilbvrNVqHoiDYd2OVDEn4+ZVJCFJ0nvXJ6WSwQBxuIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b34456b-0ba6-46d9-1d02-08db0252e913
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:32.5224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBrXsb72AtZCWEnJE1ZYk0ZaFY+PASvjNo5gPerjJ/nhA4Yk3queB1p38nVULLmv6VN5gXnKgpLTYsFySRHaEYRWWYzgIo0ZC5tluIN3PTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-GUID: c91duPt4GBhKH1nd3z3GLlgHVkA6BhD5
X-Proofpoint-ORIG-GUID: c91duPt4GBhKH1nd3z3GLlgHVkA6BhD5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

Commands from recovery entries are freed after its session has been
closed. That leads to use-after-free at command free or NPE with such
call trace:

Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
BUG: kernel NULL pointer dereference, address: 0000000000000140
RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
Call Trace:
 target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
 transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
 iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
 iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
 iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
 iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
 call_timer_fn+0x24/0x140

Move cleanup of recovery enrties to before session freeing.

Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a57527beb340..eac5af87ccd8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4547,6 +4547,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entries(sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4570,9 +4573,6 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	transport_deregister_session(sess->se_sess);
 
-	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-		iscsit_free_connection_recovery_entries(sess);
-
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-- 
2.25.1

