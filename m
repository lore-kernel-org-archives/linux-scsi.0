Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34229EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjGKVqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjGKVqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252FF10C7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:37 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BICxp7019634;
        Tue, 11 Jul 2023 21:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=ZCwDR5X+L6CQcOCoVNSYiVhh4cuvofd8Wou0WHcwQhSmPUHfbtlJLiPTO3x7btxdBGJi
 en6iiwY2Vm0frb0WYD8t3w+M1iuzN7jVRg68qifFqQW9Jrwvc5iCJZYkD/GSWxwrXn11
 XNMQ5XaXRdRPAeIqAzi38ZmH9Aox/8DiDCPAX053YQp83sCe9qKrq76n0ozRn/AhLwPn
 ZoPDFX8C7Ps+8kCDDOvBXKYj6qDapu/26Al5vVox95afulz29qSJNciM/X6zLtX6AKeo
 XeY6uT0753Gp5u5w7brrl0KnLnI3UeYk4Od/k2a6WMzD1IGcpMxHpjUgOrIrGl4Ch/sQ NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7usmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJvGQN007159;
        Tue, 11 Jul 2023 21:46:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h0pm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enuYYisVNW/Kz5bVBziskIlj3lNHOU7Zqdg3Tuw3M+dz0vcowwxs+npNhToGFIx0sRmd1NEs+qHS48s2mQ+tx7NDk8tAlgJnPngJMTTvcM+x/paiRXVGmahv2O87UEDB1sO260eW2XkkYm+2gAp8swJdCkGJ5/87/CVOeBTDY6XJl22MTAcrvaQROs7pWnCgB06JWCAE2GkryB0H8bMZlCVnl6pYveKb++vPZQnDeA92cEDb0ldFIIPo5Hu9ikSFgODv8tAV9laCB0Blp5vds7A0T2zkjiE9zS4tVFU2YQe+4BwjNbqzVELL4Ng1zaIht8ESnIS4oFVnDZVucfqzSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=PVDa5AT5VvlfxdtdbZbluEZMbcGeSBI72mRGt7H+tO4BN9Crndmf1PrvOgxmuY5gunvqFrBEQDIhj7I0+IdqAuZGYg336nBfoe99n1embqzwWUoiL7T0Vi793Yqv3O/eQf5WI34pfWPl+4mDt3suAIFuOMK8ttdaEKq9IwOziun8w2wROKRbLQpqYQuCC8PPllV0qvjppoobBjYnte9cHS3NUof15twFSUQOPgRv4t2Zg6RKlTcVhLdfQksLMurlI28DlSlykt7HbtQ2P3KTG0S7TbmVBsjMYSladjYQuxM3u2zEjyICo68ZFQznMgSzuGdrsTY5udtNKqBZ6xwOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Xk6AFBtZb4v86xDSnKHhUr3SXxNU59+woQv9SSypJ0=;
 b=MywjKwjLpu84x73V3/ZOc+rAgatvmNw4dvRspos5FcfYa273PXvMsof28Tm2iZk7gBTG91Q7Xd6U3Syy80KLeCuZ7TEr4gpgVIuQ+n6JBRYCgVljqKmaOjq2eV59CIQ3jDU8UqUx7RcHlr+5571055Tel4DQaG99tbQ2K+8T9Co=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 01/33] scsi: Add helper to prep sense during error handling
Date:   Tue, 11 Jul 2023 16:45:48 -0500
Message-Id: <20230711214620.87232-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:5:bc::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d9895a-9f73-4e3f-ee5d-08db8258469b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjvYEwTzDYredrH4a8OZ4sJJq1CcedukkuiTy85mimD+85YAa5DtpY4MnoXQoa60Qgz0XVvFAtTeEv7wZctroDEI7SQdwK0Wt7uFtyBLrWo5MlxvuEVVcMnAEB71o4ZI1uOV7yaOI6BWCJAZ89XCjIwgKXQPahTMfTdlBdSU8sJaML50Pqoa1g/C/FzRh38LSyM6XxQaxcYGOjKRUEraJtfkKprq0M17PS62TmXcKemu4FCjzTR7ima7KlLm6jf4xQniWPRhQuYQ9dl3fBz9E0u0OgHjQvouXeFs9YFN5PS3G21d0Q6ynvtnHJjSywc/qprUpwfe4srCcHTOCpFuMkTuazGDsVY+tH57JQZoSZdg+qBunsd7F6bROMNNiOQDBRNKdCx4PyEES2gBg9Pv7WjZ0NF0uJWnZOmB1+Iq3zd3MAaePhS1+d+m2NPyq6tUcM+rIlrIkERrZrKla3GWUtZcD273ZX5NNcVKh/YztSP7srQGzx3LV3/Ez2dzUsQAHW3RoOooJY93JvWjpsoRPVMuzLxLfDPUx5uhJg4Y42RHglA7p3hev9/kVFavFO1P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DlESjEd9DYPjMkztSjPnYNXjXYM9XygzIiJ+2qGZwmqSK4sSwyADY0lNwt1?=
 =?us-ascii?Q?g9Hk7Vkp1t1xlouNlDqrZOwuOynJBGhwgLzl08RyWUzFJ4E7yqRSGx1Kfacq?=
 =?us-ascii?Q?niZyBU0hchHetCXbMm6+hId86m9UVkO8XwYJ0vnz/x9KXO91Vw1fCi0RabAH?=
 =?us-ascii?Q?iszVTMnoQa2cbI8RyJ9HK7RPDEWH6Lf0JMnVK+qO719eX5CAJQOej6Ojq1xF?=
 =?us-ascii?Q?6ZjEkufPYzi2BalNRtov6FGxqmDsNZHQYp9yn4hw3QVCpz7MhcSlI+FrK1Ot?=
 =?us-ascii?Q?8a3qdyhgm6hZE/DV50EiQLqQOuqZFk/hFCJVZvF76QzZG44P/yCCC0i9n2Jf?=
 =?us-ascii?Q?5pWoeln9iP5Y8ke4nySLgTMcwdRaZb0cDGHX3S8ThORbIG1Jpa8BR8finS/7?=
 =?us-ascii?Q?e48QikN4NrmljVLUioaCH7+RkJA15CNrJXCvxt0MJfSOAj9twoi8s7WOS5Tv?=
 =?us-ascii?Q?oh6xIZSgX/dzDpeLv8975KnZc9485o7Om4zXit7w1eIgVhn/6Uw2/qWiDjmx?=
 =?us-ascii?Q?P2WwRn8lFyvTRjVyTp+G47o5v8rvnv46PCFLOaixix52o3YwrhO1PccLvj8A?=
 =?us-ascii?Q?rQQvmpN1JZTbvK/bmXUCmONJwiUJBFATIlX7SSu8w2rjZonSKQbXnuMMvv4z?=
 =?us-ascii?Q?m5dbcaDWHOXhcvbI+t4qXUFd6vt6O/+zCBZnttTmJ8+8oTyGXzDTqX8Xhpp6?=
 =?us-ascii?Q?FUBNMG80V7BgJFPYNj56QtzTTvY4nVoSYnzrxaJ07PQ4wQ1huYH1byO5G0N6?=
 =?us-ascii?Q?3lM76wGx6+y4/ueL1X9gyG6lOQBxPNKGZ2Nm71TPp8qc6yQ62NTLQA3kzxSE?=
 =?us-ascii?Q?UF0DvJ98C8+BlfrhnojJCaA0enmEmVFYSWwd9jeIiORgBQcZrayQSr3cG9G3?=
 =?us-ascii?Q?C4MgUNQNqd7aOZKUXdp3bJfEIODI2XUP0p70aFxbU+IZ9st6aZYoDbPVnYQR?=
 =?us-ascii?Q?HfSYWayGoL3sGIwux+HA2BanPY2Z9bxChxsVq9UiKVm5IcwVWPcsMcbEJzPf?=
 =?us-ascii?Q?PsMrRdLC8uQbOZD5Z2soeh1WTUQTo+45lmw5VGQdgqaOFgDKdbUAeEBR/b+6?=
 =?us-ascii?Q?86iFmEVTVTaHH43x3KlDuN91KBi9yQYEWDqlVbtdBLXGD3pmwqezDmLaOCR/?=
 =?us-ascii?Q?GFdW7AjKScTWqP2lmkinZEmRDDiqo0hRcR5hl3m+Z7m4lGz+jC/aIETm73KF?=
 =?us-ascii?Q?iymiPENHFzUlCGOkHY4YYHBcIv97HeVMK7vkK81cUp+NlXEinxQdvclQqOt3?=
 =?us-ascii?Q?BLyvNJTlkscFBhNCcmRHu7qVv7GUTEs2aL0FauejoZqbU+1BiG+O7CMzlVZ3?=
 =?us-ascii?Q?//gR6ZD1lL1kM7dwRfU4sn+3MtMYGJJqviMbobXGppCYXIAIQxjsG93OjSML?=
 =?us-ascii?Q?YpOnK8t/UzK0EhjelOsYVhC1rXx51Zao6nxt1GMLEzQuQeZgT7ZIoh99nk0E?=
 =?us-ascii?Q?eHlkDlSmMPNevQ3/daY195YOc+zB+wBEqWB+EL/s95MmKPabOljLuTi2T3sn?=
 =?us-ascii?Q?JEzLgsMl6pyxoJuX3riJWQDmphRqG9HT0DwB2h0jil7siuqCq/5jBUAVuzJE?=
 =?us-ascii?Q?2dO8tYFw+/VJ7B/I9C9qPrB5vZwKeFluTmcXqAnE+OB6zYQot/PgGj8kPEsY?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KBIMQ9Vy5N6QwdVsbCTJjoomflePv1YrmOmYpCKbJ+vYO8++9bTO6jWMG1HqkT7znQB8xIf9hchdMm4FfyswbWfhFSK2vIKRf45IHtaFFLETjDG278PpJ02tvnnGXgxI//MVBfAWbZOvTIXQOuwo1OWB4dSC/TcKr6InxfZatRcLECXkW+R1JBw6pXz2YUyOpUACswWo7KLJfqP5bLiI8tbUebj6PVsTHgKIzz3d+R6fk0zPWy/L2XpD81PHRr6C0tXrF28PQRvuRZH1/6QxR8dE4G5+N4cl+Cph8yAJi/t8U01dEapGjf5p+fll94I/PhUnCfRHhPfJvSU0nItoR4/ayxYZ0nYBS+YaVpiltGNt0USKtir9/nbdFJ4X7VOrmyGtWDTR2kgOaXGndQKMOiurn5ye0PA6dj7I7mKchAw/NKC1svYBzsV8UNw2V61yrSFiYNZV9iSAW1I7F+wR2psbfowH1uftW4Lqk6wDJnzFo/Z+qFnR/wTOUx7A1HuCXZWkvnWoGTn57b7lX8gxB65lLHVZbQ+dMiVYQ0nM+IGcbfFWZpA6EA1+4w/MxksrDbS9vv2a9FdGCp7OBB79gxr7TKCIIIMjCt6bWobDmVu7VhmUaAtyZGUdZ1DSWBvsOiE5Ig7T/n+WaRPFJjAhMOTejd5vkElzjlFXyoJoo0gdeu7LiYCd+SwNK9vmeV3ss+DzCpQv6oFVhLuv5T1vlZ+l4jGicH33quQnzL8KszqSvkuEGEJY9WKrQkOkDG1keo1ibLf+MS4vEUPWLJWeMFXeQlG/vBXkvmRNn2EMsWpsqxiiEu2iaps2AEsXpIZS9Dv7yJZaL6ryn9wuBZFhgcnSi9qMFSvZA2gL6y4eOdzc2+pz6paPzyujeBnOpuju
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d9895a-9f73-4e3f-ee5d-08db8258469b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:25.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GkKw3puE955Y1mLEzQX3Ow2lf/kcpgUDSiF9YFKbHddP9eiarj2/wQ/bhvVtj4j1jm0G2tPVvSk608Nt9raOeDaUZETqlFI2Rv28+k32Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: s7FutIZZb0Qo1gpZS37rmcSpYWbr_UZ9
X-Proofpoint-GUID: s7FutIZZb0Qo1gpZS37rmcSpYWbr_UZ9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..7c3eccbdd39f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -523,6 +523,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -539,14 +556,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	struct request *req = scsi_cmd_to_rq(scmd);
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.34.1

