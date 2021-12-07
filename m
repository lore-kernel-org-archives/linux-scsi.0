Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FF6C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhLGCzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:55:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230500AbhLGCzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:55:03 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5GGY004565;
        Tue, 7 Dec 2021 02:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MwZRw6oDUAORsomxtWes8Zatl7shBgHayG0LrD3NZiY=;
 b=CfToDDpv+ZjnXKHxUplNodAl7JyGXvdEqcNBPUdm7F7QFgi49RZ045+y0zJLokAlft/J
 XTHNPvPL7kS9vtx4DEF5DbNDybdiXM1Kj2gFac+UK35hT7DWhT30TmYsUH6gKCDIW3+s
 XFSa0Bc/MfUk8P6BaRZb6AQMQKMOwcyI/s9FVwW4IYLnr6tCL9LYIovgmyu8OVpg03gx
 KP9Xlkb0ueyvA7Ayj8i84jPCu7InFB6pTm1sYR32drSkeMY0gbQs7eKl6pvbEqNa+hGY
 jFqouKZqe+mUJj09ANH2JwvorQlKLEXx9fgKldz5T+3cGKpt7UDvns8I35WVcqcANnkO zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjbwyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B72kglb153019;
        Tue, 7 Dec 2021 02:51:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3cr1sn5w2j-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViwFcRD7sHhcc54LlkmWZUZ38uveKrzvEpyDoSnjuYUaMTHDgq5LCGZvotiw2jd4wXHT3bn6uxOLbjoA6HAKhygq98I/ycdg3+dz3CpwpZBz7wqWDv8OiUBqebRU/tco2l6XObfI0sz4s8cS+onYwfxpU9HbuzhwXl4idhpwcRTyvmMHKyzquwDezmkYc8OEew1YpHNbucb+Ncwn/2U8+GA5gjP96Gf+YGGySGqQckwGZsZhl1nPjgCsmkVdlUqPRwcmKW8o+kywJVYfp5Ns3rbmHHGZzfjJD60JF4SRroQsJbQGxHq0u0Tvua5EZZNPc/XpOE7lfwWfQBWmx38Gjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwZRw6oDUAORsomxtWes8Zatl7shBgHayG0LrD3NZiY=;
 b=MflkoU8f0Nicq6gWxoS5OjEOJIrlJLyGWC8VytyyZgJppLOYwDW8gmTV79AhfyNl9f+1152AEPBjjdigRuxXFSeEgw0eNbLOIbNAjOTJ6N/lhe5yCB/NmbANntMVPhuqalKkiYqWLM4I3/MseKiLDW3/6aU1pwFfa68qgUrzeoDc+oJZbRGMwUVSa0ZGOWSDsGnATvIEWvg2eebF8YYNxQ6wZtL4bOLy4VQnlSp0ISHqlMZ8Ng7NRTxQE/WfMNGUJemOphM8HIBr6rGZf/70uLUhiSaOgPkKCpPUhcQlNH710m2yqWtOiyttwx5BzK+6qx+MsfszZFHJXnNZZkDbzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwZRw6oDUAORsomxtWes8Zatl7shBgHayG0LrD3NZiY=;
 b=nU+PPJNpvuKhUDDCqQg8kNI3MdYFMMtEZ50mlwONQsa8ibQnAEcHVscIYR9dKeQq5k4ZFGgeqBKQvA3GNDA/cG7LksfVJ0Asri1RsF8jFtSbJknaVF2mgj/k+HerwXV/nyBCJLNszZCB+QfG3odTep9kZfgxR5op685bo0uc4Qc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 02:51:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:51:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V5 06/12] vhost-sock: convert to vhost_vq_work_queue
Date:   Mon,  6 Dec 2021 20:51:11 -0600
Message-Id: <20211207025117.23551-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207025117.23551-1-michael.christie@oracle.com>
References: <20211207025117.23551-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DS7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 02:51:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 113ebff9-0986-4c46-d312-08d9b92c7751
X-MS-TrafficTypeDiagnostic: DM6PR10MB4347:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4347EDDFB9FB56EF5BE1D803F16E9@DM6PR10MB4347.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1QaOqRlEMz6dMfXXjoRNc+dAQ7yYnvQA346IN3T7q/MBdZRIZhDloBlF7VZ+aNEqclhu8RVTKpjoPCqQ4IerD9B7uZyNNhaalYgcYnfufHyU2RPPeuFnHytPGWHFbth4/fSKOx9vSGn2KxrNRhnWJpcxeMKti6tOLynKiqezyIF+1nTDINVmiHsEq74RWeR1Hpe0eHFGUTnEdMFcYqV6yPOCFft7zEe2lz4R4KeZXHTe3alt9bNJfjuf2zr35r8FZXa8Bk/i/F4bB1nX/McPOO4+RqOT/sfYIwL/T8G0KiScgVj0m32goukiD/apkZd9Ao81OsX2p5bTqB/RLjhC3qOznttXhyFQPaeuqGA5CC/X7ByuQt6A4c69BFuAAhFZAGQghIWAgj1vP/vgoe5Y6bB66Gxh9xoT/IOZJOluyIiK7Y8ALW1rTR+CeNp90OmXCJakvxuiOE+xRxa7IBwc82oBLfBgnE7gsVdrwuuFevgQJpIRZLL3FUW9JIxbioed9osnu6mHuMB0aV9r5IiJJufwdeQ3BSxooTPPAw3DMKp1gru45UYKI4Mj5mg11FKANu95JHCrxqEL8MEYESkVLkDbATooLThDs8M6fiPpW3xN8UOUMcSDtcjo4z1W/+w6tOB2hPX5PKUT+JYp/8yXRvP6QRro4JCYphbue4wBraUrpeCsN6h+3AHzfKheWXM6rEQlGJbC/0xGNbsRYz/uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(6486002)(956004)(107886003)(83380400001)(4326008)(5660300002)(1076003)(2616005)(508600001)(2906002)(6512007)(86362001)(66946007)(8936002)(6506007)(316002)(36756003)(8676002)(26005)(186003)(66476007)(66556008)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6c48UqYskyQZUXippFYYSCM2yC974sYj65Q9Sl3m982qsIjDM3ABibM4R0zI?=
 =?us-ascii?Q?KY/UnK0xmRKzikxSRXpEaEL/I8fBCeE3NQJMqI+m0UI/oG3aV46izWadOD/a?=
 =?us-ascii?Q?7qIvsermXHdW5KpKS91fDx0/boEG0c+a0NcNFX8n21eX4SMc25OusSxeOvQK?=
 =?us-ascii?Q?xVkQivlBgSuuLyqN2aonbwIOtfcyCP7ReBiwz+p5+GzlDgcL4jNbm86FOw6P?=
 =?us-ascii?Q?tuvPmYQMSI/dTxDBuNmrl7cW8rb1pQfTIsEqvnZ/s3c5XWeoGr+2FIxYybX1?=
 =?us-ascii?Q?hg0jvwbxkA9ypECXScrF2jqH47SKj6+T6mruKBKvtHEAOQbt+ziTnVVfYo+D?=
 =?us-ascii?Q?fAQr0e4NqlPm9m1m0ThLWdZWKYv2QaVeZwZ3tub77Xoi9mrC7zOue06C65gp?=
 =?us-ascii?Q?yHd1uPU7lu8iBV+2CuLi9WrvnJeyDhzGNbJYUfiml/Y+wcGTZiqQY+CdJIrY?=
 =?us-ascii?Q?PW91G0e/pFOsXJI+AosvWIxZUc8caBkLjFAy5zxHoHpmxMbFsrm90THy8143?=
 =?us-ascii?Q?mOaoMndDPvoaWP/mx/HSY3IIhYkO5x5eIi6sHUC11OPwcMr2MeED9yjq6nCs?=
 =?us-ascii?Q?983Vue8kvRNoBslAnuAvhhCrcxvycAMnh7X1ZBeqvCBys20rm7j989CF8bdf?=
 =?us-ascii?Q?3/lgstpP50zVUrLHOpdr6b8HGbb9fVfO7A4lXAUvqVjNNsX2o3xY4cv1s2HO?=
 =?us-ascii?Q?+mP+hW7IFblHHOFAdyGam6NdIZ40escWFnMr3A1plYbFFQNtXx44PxuahwxI?=
 =?us-ascii?Q?Al7x8mZiB6vNH2Std1A+KSXtbjndO08A72o6+eGrxMJGQGRJ6VFqmczBheoR?=
 =?us-ascii?Q?oo5JmeUpd2plI2FiKuWGO/K9eO7ClQ9vvUdVc/Fgfl/lszsSn032nlhlzEfG?=
 =?us-ascii?Q?2wCGfPK9XVV9xEupB1tpUAeeT1y0qQONPEE58xmKu8/FnFmdC6+LAYiQBWX/?=
 =?us-ascii?Q?e0iDVPlrsd+yVSoWSo/ZVMPbsVLvwUquzFmj98oA8QbfPhUI/rCxk01sGrXI?=
 =?us-ascii?Q?bEqTRz6wkH+n7t9U0y6Lsdr7L7L8vuzt1C2LoheDYK7wnlY/QhpgTJjlc2j7?=
 =?us-ascii?Q?FSqaZi0dtkAcHd9lgzrssi45v67Ns6wDom257plvxJpUITwTz1iTOWAjgN9g?=
 =?us-ascii?Q?dkQIgFrER4xmseUq/ZVjt6nAgKHBrCN2FuI5UNoG/8HOe+WDlM9cQ7akuEF0?=
 =?us-ascii?Q?aq+Cjhb1B10E9xSIY+As3chbala5L/7YPQaIv95g8JF1M/437Lqlvr/Np/iQ?=
 =?us-ascii?Q?3mF3dfIwzQn2CEdE5ozvrZGi/p8TH4j8ytFZH9bDRf8hHznaApYIA+2zZbkU?=
 =?us-ascii?Q?1uLpd+8UpjMVicMvTiVOnuZ3wdOxVpijzPUJ0HJqnwWps/0beOjiECAVv8W/?=
 =?us-ascii?Q?Yj2bZGqQFg7nl3al0QrfgW+N4vd+dLOLD7t0w7tHw7UYUDvWZwmsdRQFeysz?=
 =?us-ascii?Q?IkbXcZIglzIVUzsRHdpnciwz9zgI8z19hLxVz9ReP8cgSflJmMraqeUwzKRg?=
 =?us-ascii?Q?B1wnJsXWff/o4cmpYVEo06opIF9elh+f8dP0MHTEAs6qIafFIsgwI8anCM3p?=
 =?us-ascii?Q?AedxKZ9uBQsJXlTI6deGSKwnvx1A9I9wIFKIXlR2ExqJr4poYHJCObcjEgv3?=
 =?us-ascii?Q?B0hoPQaikSb9bA4uVHxMiGqxKwEi+sWkn+GNJOLFT/ByMBkmcck+3MwnynfF?=
 =?us-ascii?Q?F63TTA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113ebff9-0986-4c46-d312-08d9b92c7751
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:51:28.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/Hts8e+PjjVBo37baC0AUgXDe6yqFnxUwEHs7YifCP/Pkj+kcHZ1PFUsxjAQkTA5PHpnVv3r9SPWH9/acugtTJVGh3kdK87A1LN+/Qeobg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070016
X-Proofpoint-GUID: 4vlhbb4SQhC9CTe8Bj7yyVoNnJVicZDs
X-Proofpoint-ORIG-GUID: 4vlhbb4SQhC9CTe8Bj7yyVoNnJVicZDs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert from vhost_work_queue to vhost_vq_work_queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1f38160b249d..068ccdbd3bcd 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -300,7 +300,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	list_add_tail(&pkt->list, &vsock->send_pkt_list);
 	spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_RX], &vsock->send_pkt_work);
 
 	rcu_read_unlock();
 	return len;
@@ -608,7 +608,7 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 	/* Some packets may have been queued before the device was started,
 	 * let's kick the send worker to send them.
 	 */
-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_RX], &vsock->send_pkt_work);
 
 	mutex_unlock(&vsock->dev.mutex);
 	return 0;
-- 
2.25.1

