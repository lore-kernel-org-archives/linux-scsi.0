Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF377C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Feb 2022 23:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiBZXFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Feb 2022 18:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiBZXFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2022 18:05:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D221815DB0C
        for <linux-scsi@vger.kernel.org>; Sat, 26 Feb 2022 15:04:59 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21QHuqjS026177;
        Sat, 26 Feb 2022 23:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HZQNF9m1cdzLDsIH2rCN+/mnizBfexNnMob8OyzYExw=;
 b=lW+PVV6ryb0Am6FI81plCt+rV9GCawv8l/Cvk0St3SbmtBdMv9jaiB5ce//hUiksgC8O
 DgAsUvmNChKakRrx4Qk52ZfhooAH3Qhvw9VJiKUMuXrBNfRb+LSV9eG/TnwIP2cUj/Kh
 sYsYfIGB64WIi5e3sV3ei60C6vod1NQnqOnoy7stI8dU+lYeDdvz84ulP9bp7gKeT5j6
 irMtBeYEacjRKD729JvYDWtmUX00uvgoTz1zM8/hsk0w0sA2qgETaiD6rocn1LHGt5hj
 tgu15XZ0C1iLyWzuJsjRBeeiKJ/8gkPMxUcNGFZnf3F0nydOW9I8Mlx7uxosKZfb/T0Y Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efc3a9938-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21QMtm5K027402;
        Sat, 26 Feb 2022 23:04:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 3ef9at5krx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 23:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvBRKCbjnDAUYdvSTDmd563+dcIPwsneGyejAInjqyIIjCw9cs7rPCF3JDtxiIsOc2k3VGZAsFXhZNobNSE/9lKkwNr4A9lId+ObYFSe83pn/PaXZC5/7TlgvPbDsxGfQhS6FPbJR4mhdtwjWMVbeQbcacmp5DU8sXuS8tVEiaoDyjLPMc4wexrwelFTjNlat5zlyEwgvclocZ+JnNfk8o/7Iu8ePo+FkZGNoxCZkoThhFfH+NkqfLWGUNWqc5VmIdo4jc5BtVQyitLpa/AjXh4gsmr745GOkqxjiQjzsDHwlQKn+QdPulfX4+545eJ5vl2tu2cPwWFnnksc52dSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZQNF9m1cdzLDsIH2rCN+/mnizBfexNnMob8OyzYExw=;
 b=C0pSz2znQNxzwkQUMy8UKCKK1Pocr2oZ6QNc8g7FvHyjW+nZBqrGCsGPZ+FKe4mhzB9F3MMgEDPygAddNZ0xXh+2QvORmct1THQiI+GGSzNJmFAfjUhCdbXitPr19qSHrhYClgsqGJ896hBzWTSEEPKGhe/Sp8ogoSwHqV8iEvEN9FVx2ZpsczeCroWkP/dCSHQjwlyhj/Sq3QjbefkwzZbSdkfxcTslpfnHHOCHgyJja1CT76j228uyhK0Sq9ZMP44eu2Gt6icARBapsjgZxN+P6CYRKBOIUZQ4iQPW7lasA9zYhZFsdbEzj80PSCpewahhS5IHnAbervSnLGJP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZQNF9m1cdzLDsIH2rCN+/mnizBfexNnMob8OyzYExw=;
 b=a7WRkgxQmrOXv/eNxeNhDBZ8m+iQqtcy0AXL35o0QlnL6z6LcIeoHUmMDEJZS5j/HfgnAQdeJ2iTnN3Ahhgb11JuhLWY2jeAHOKi6SeZG9ANSvzjNh+/DnP27bwWmuD9Irb92s8+Nu6DgZJfWWGqGnwfApOy+B2b60ooRyXUNPw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5750.namprd10.prod.outlook.com (2603:10b6:303:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Sat, 26 Feb
 2022 23:04:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Sat, 26 Feb 2022
 23:04:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/6] scsi: iscsi: Use the session workqueue for recovery.
Date:   Sat, 26 Feb 2022 17:04:34 -0600
Message-Id: <20220226230435.38733-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6476693b-6031-47da-14cf-08d9f97c6197
X-MS-TrafficTypeDiagnostic: MW4PR10MB5750:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5750556EFFF56A60582740CCF13F9@MW4PR10MB5750.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7l0Svt6qYk55y5mmhT4xWfKgQ/XUP3LTFTbPQf2Yfo3jCPEHAvMIjE4yYLVCwemni1Y424el8Jn47MimQil8GIzoTsKaSeWzSqHVn4VFSL4UxWAzzAsRDmrs968LOAwKQO3fxgK9VwQmHacUP2eXUi7/NIFlUiShsF/1PZ68ufLxicyqAL9KUkgsPvt21yUNuF088Pepi19WNpm1yalT6US/JACiwkGdEFk6nmaiJe+T86bMzGFSXOc+ZC6hVLI5GC2M8mmSyzYiHXEGyMdje+7BHUxwpX7dF08Trn9DpTaIQRh5tYUjnggvWa6sRCOsP1SOayYhF9rWU+OJ0QGrBqNUKoxjLEb+hIHy4075z94qkT6h/9FlzpK3hVDpnpBZwD+/PSN3KEFbKfOEPoXracjrD5EoQd+vHKT1FGJ/LXq9xJihrEnhkNqd5RZ1If4D+eX1NfREQQ4It13IYP15CgIu7KXODkRY9qp+96SGpu2VnXa2AvGeiqduJeiEKe/mxx55q+v7qCORkcqqhpF0IQdejtGjnogGhqUlyYnHMV/6mVQf+n1JUIQBqtApbSoByECcbxkpdQmyumRBRSNZ0x9vwIBpX5mVwOV/cZ36sWITT8/DKJjqZvpSxY4l5MTdxo+Ix1zgoYdRLb9t21wLwoUwid0fUmNgHynWXc1GJGzi+w+3/sjC6Ea9hZHED4pvlDLFLJaA4duDXMaxkF4Tdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(1076003)(107886003)(2906002)(5660300002)(66946007)(4326008)(8676002)(36756003)(186003)(26005)(38350700002)(38100700002)(2616005)(66556008)(66476007)(6666004)(8936002)(6512007)(6486002)(52116002)(6506007)(83380400001)(86362001)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N5w8w5//VlzvZrqFyK+xQwQlTbjj7IBYgGO4yF7a7BWEb36zv/BJwEtZU8zf?=
 =?us-ascii?Q?T2rkwjLTBzrh56y6tTeuJSyhY86/RiObteKRcSzGsNCvk8q95PII/5z3S5ps?=
 =?us-ascii?Q?jlytqUV52XrHCpc269fD1VKW7imwsGYm/Mho1AMxPnypAu31csu7tmpZCiGd?=
 =?us-ascii?Q?2QCzlwiFBa1lpFjmz0u8OevZgQ9MeXWUqVcwqhIUmFduFJVmvGx5S8WuMOCO?=
 =?us-ascii?Q?5TkOpfrPQGHZvN+zeiZ5ek0SotqMkQWRY/wmXtcZh8jgreIvHuv9Ekc1TTr8?=
 =?us-ascii?Q?vSFcTApIxQXL0cgZrFDLrxaHY0T21Dv5DLbxp1Ad2z4X2xbsvfMf19XM9dJo?=
 =?us-ascii?Q?V5d4mnZ6A9//JE99dOMxY9YlSVRE2qMvsVqmLscZtpGFpqcr3tIXoa0jWElO?=
 =?us-ascii?Q?3O/Krlrzo4KrR62FhnmcePx+LrgFDrw6TDnEbNGqi+QYvIlUtdGKfTB+Qemx?=
 =?us-ascii?Q?DPZc4Rb9pmdaqZJZ9XQelMnHA8DE7MXvYspMfyS5b7IwnTuCBgDgQaisCJyE?=
 =?us-ascii?Q?NzG80MLB2bayyR77alLi1vCEM24hmSj7gy3Xl+VhzNpOIqjepYYiKjhaW/ra?=
 =?us-ascii?Q?GV8vV8LMeNdU2Vy+v17VDnzEZX3OhbUmRqnRirIv2JfpGuF1Kcc2YpBrARUp?=
 =?us-ascii?Q?W86hmhB5zZT+u1wW9Pbe3WLgQ05A5d+4L14C9tSaupU9RUHZm1JmShpVgCon?=
 =?us-ascii?Q?dBSfACUf/EgWZLEJM9RE6Ich7tb/r/xJDJI+t/Hf6Lw227biqVy8MSYONsAl?=
 =?us-ascii?Q?HrcvPxjM7E5aUOy7S2UjAZLRwG56dYZDwP2r+wNPhHi/EuxitVpCWVxdcaT5?=
 =?us-ascii?Q?tX2C03nijFTY0Q1lXKQGYXgjlo6yi05z45rMIrOwKlNCs78HYhpOWb0oXVU6?=
 =?us-ascii?Q?3Zpdzhk3LNVAhWdrHxVrrHzpTebs2F2aE3yNih4jE8Hd/MEWv0XgGX/Lg2M3?=
 =?us-ascii?Q?A/RSLb5OKsn1guJV3ka1RQeA5crQtc75eD7gdftAUP4IOFr+60LIahY3CtLI?=
 =?us-ascii?Q?+IPy8IiYyxDhV5akysnjhe1wFRhRVM+rU28A8DvpQH0aiCy4YbIsd23V2l9s?=
 =?us-ascii?Q?QO3EtDUt5s8TWyggfsldvQwBt0SmF1yJToz4YQcSCeufHPYHKFnRgZqPOx9I?=
 =?us-ascii?Q?tEi2hkzpGkatx4Bbv9VOg7hsjmIMbW4wLA/DTzdLjj4BPbfmbtkqngtf7hhk?=
 =?us-ascii?Q?NdvXTPVg4RzSZ7L2MoNuwTLpXQWRsi180/+Vn42rZh7YhDaObaX3Gw54Ta0I?=
 =?us-ascii?Q?vSz6jvN1cAYFHLhZsHEgZywPt7VYw3zCLSwKczzCMg1UROdISk2ZS6TrCeFF?=
 =?us-ascii?Q?ESgdAPfktkS+MsxNpMP3qtd3hLIlH8yMHjZWtzQj/kjLwfXdg/ODVDzD3Pgp?=
 =?us-ascii?Q?24pqfGv2aEzZrli4oWfwCtoHwAoct+HKGRQBZ+xJO+ur7VRYxvKAWW2QTNHs?=
 =?us-ascii?Q?gLx+wvhO71OyDNdkPEYKBX+wut1eWUxqHJuGUTzijO6AhAL0yZsHQRrpX7VD?=
 =?us-ascii?Q?R/P3Yr6Xybzbz6qkTfW3ZLafW0f25ORXwLQlJuteEPYLgV2mjAADtuvGbmIX?=
 =?us-ascii?Q?oS4PbIRmJ1L/+MN9g+uuX4ygFDJkJGzoK+V4RqTRlTKka0Hs6ujeA5AEAjLR?=
 =?us-ascii?Q?DpkVFUuJRBnVvdOCt4JV2NCHQMHM1Z/e6qukCXGW1wYreoXTazEP2lKyzIVu?=
 =?us-ascii?Q?Y5rjEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6476693b-6031-47da-14cf-08d9f97c6197
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 23:04:45.9437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vthgRkBAVZmT2DYp4Ku5tQc4GvCqPPuqxi/nBeIsv5t0QIGPG5lKfXAsy3UkCerNQZY9VthuSPGnSGcZ1F6MnwFFO97y97bJ1MGn68/uFC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5750
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10270 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202260163
X-Proofpoint-GUID: 8pN_aMXIvVQOlB2izDAyWVxxdELyp6Bm
X-Proofpoint-ORIG-GUID: 8pN_aMXIvVQOlB2izDAyWVxxdELyp6Bm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the session workqueue for recovery and unbinding. If there are delays
during device blocking/cleanup then it will no longer affect other
sessions.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ecb592a70e03..754277bec63a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -87,7 +87,6 @@ struct iscsi_internal {
 };
 
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
-static struct workqueue_struct *iscsi_eh_timer_workq;
 
 static struct workqueue_struct *iscsi_conn_cleanup_workq;
 
@@ -1913,7 +1912,7 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
 	if (!cancel_work_sync(&session->block_work))
 		cancel_delayed_work_sync(&session->recovery_work);
 
-	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
+	queue_work(session->workq, &session->unblock_work);
 	/*
 	 * Blocking the session can be done from any context so we only
 	 * queue the block work. Make sure the unblock work has completed
@@ -1937,14 +1936,14 @@ static void __iscsi_block_session(struct work_struct *work)
 	scsi_target_block(&session->dev);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
 	if (session->recovery_tmo >= 0)
-		queue_delayed_work(iscsi_eh_timer_workq,
+		queue_delayed_work(session->workq,
 				   &session->recovery_work,
 				   session->recovery_tmo * HZ);
 }
 
 void iscsi_block_session(struct iscsi_cls_session *session)
 {
-	queue_work(iscsi_eh_timer_workq, &session->block_work);
+	queue_work(session->workq, &session->block_work);
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
@@ -4851,26 +4850,16 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_eh");
-	if (!iscsi_eh_timer_workq) {
-		err = -ENOMEM;
-		goto release_nls;
-	}
-
 	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
 			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
 			"iscsi_conn_cleanup");
 	if (!iscsi_conn_cleanup_workq) {
 		err = -ENOMEM;
-		goto destroy_wq;
+		goto release_nls;
 	}
 
 	return 0;
 
-destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4893,7 +4882,6 @@ static __init int iscsi_transport_init(void)
 static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
-	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
-- 
2.25.1

