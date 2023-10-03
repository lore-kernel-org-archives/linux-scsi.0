Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CADE8FDB3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbjJCUxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241109AbjJCUxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114BAD
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4onC014413;
        Tue, 3 Oct 2023 20:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=kePzO9t7pBK8gowx9FmvoLfiDKVPkkasdwlP7cAnw9nJktRbbDAY2sOpUOM6bH2RjGHK
 o4DiV/B172EAGb3mLDxo645ke1vTQMsxWJuYDqf3cUsdNnQ5eIJRoA1ZWBsucL1wfaTH
 vM3wYOkQGXhG6nf6V9n+UgGXoJRjPWw1M2n6RxVQ/3FE+0q4AuJW1fZCTjkuA6O48VMb
 //KILBiVFM7bvAe9Uy3qXSDOHT85s1586k9IPc7zzhWTNJCmn1TzJeqw4iU+8LEgqN/I
 XnrxTRimRKtG3ccVU3O6tlIhm+bbxBUyNriTK7njawrEG9MhqZV2hDd0a9y/i1aNhi/w PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea925ryh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K75f6000467;
        Tue, 3 Oct 2023 20:51:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46j5fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8cOD8aaqZr3ts80DZuOLivlrAbKgUaU1Mv7hr2UuJ5z5/aBucMbVuTgyp9s2LiY9oTwA0Cy+l4sxGli/p6ASSQa3pldtzY+WmCPj4t2QULhls924GqloLR2VAiYdVR6rtQ8J3nmXiAsyC2OnjzfifDuSZpjmEo1SySc1LeaPRfHim90cdkK56TzLpVAnP/NpKFk7UziVqIzr6OjhY1b0zKvNB5jeO2DgoafieajFgHO32PVi+SY1O559LrfazdCh3d11eQpctUxbcpmLopgxG0I/wPyAmwLOcRLhWiVIMviu83RC7j42MYOl109xZBA72hcSNHtwOKJ7PLu0aajKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=oUHQWBJQrqetpD04QotOjD7iaOmo76tmGiYDBMs7gLvPP901+XqcRsYFzyFQc96p0FeqargOftH15QLLxbWcYw2nAhSn5zjXdrF6BZLF08Zdcl0fQtCOwJbUVSLRCf/2CI99G+2BY1ps49Y21sjraFxH7YBK540B4WnTnPffgkFx2iCPhC/HCjJ1BXqw3DTFrGrjPsCOxYYjwMB1dWSEl4Ow454ZVpR9O/y0dJ7aYD5F16Fz0dmr9Hrg5wAiUrXzWGY/rgEw5xBDW3cFRI/suzz7vXqgnFiQaxHzBsRXWfF0iLGjoHKiggU2aeZz2GWOOdwTnyHn6PSdr3Ycnx87ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=NkW5r1uw0ntlE2BNLU4tAlU+8TSY8fX9VgYC7cEZ17Kkgf2yp7bXuMMt4O9JG2XNnQUe+NCHTcwiBJfQoUDlVTbJTrd0wsLxC3P7GVOu2ZmGweWnI6zClDRBaltAVZe8fNL53Ghtf+e0jQcXKz6mkApIYyJ8RydZX4lTuwti/0s=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/12] scsi: rdac: Fix send_mode_select retry handling
Date:   Tue,  3 Oct 2023 15:50:46 -0500
Message-Id: <20231003205054.84507-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::37) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f17ad7c-7996-4f9c-6d30-08dbc4527638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yAyfWWxubyCHE7vNqKqLdN2XEnHTGvh71bfTu01riJHfi8kGFWFnWEPLgUe5gBZo47kf1Gj3qT/NLKG8JDXuyejQ3LPiVzTDQ233BcnVPHmI7a4B7c2vK6md/+jDveualB/kMI02srXgRlTPpfMf3SyX310qIGCxQlwkozZ725jKPZ5J6TbEiS6+00YBbht6Sx5SWPlFOkC4t6GD73iSZORGwZfqtoxo57qe5ZfZkzmZOY1lCbi1a9VW1AatFN23U1+v4SIkCUPYxuCmmmqpP4DOP8L12ew1wAQuhV6uUhEEaAByOSk4fT5V6MkgmRTMhka6s4XrDjJkZtM5VHS03Q9NNCR3ZEVoN6HKxYO8bIKdmoKEd4KvMVneyDYOVQ5WlxvVgaBfovjl16uGhsp+qfGkIsTMD/CrMaDqH5XUcxzx4qAtBd5EO0NbdyUNy/Ggddv3Q+givBx0/DdmSrJA99lfl32xoWdVj+Wrz4JC5PnvgOR+WD2mj9T8eoP/kqaEd0G2WMoxafMoo0PX+YwWDAr0c+2I1DZiwlG81zQthlSlTZP2+I+NA7t5m/3Qza7i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ChWa3yEqSHK/IyoCi2iEteOaVViJQ53BAGkNVpCI4RSmwbfBXqYHFOd7+s84?=
 =?us-ascii?Q?6IlTRzcnQkQMJsztEpb9rE0Ef9AFkvjnjeQTqzVxvQgVciJV4H96nB6on6ZC?=
 =?us-ascii?Q?KjdpeMV0VCT+5yl/HMpZYiur+RhRYgXkzxfTpImZSJItGD7ijF+gzGOyEjOV?=
 =?us-ascii?Q?bnPGp51P3VFW/kVLCrSaLZ7tjpDgs7KIfDTiplKCHUXxRIlz2/iEmAbzJ+iP?=
 =?us-ascii?Q?/1tHsQbys5BtURtly5YofHg1zHLFcagzIwO7rXHuyJEwltGcrxMc7Y2bDbVT?=
 =?us-ascii?Q?c1NezvfHDJiVttscihTdfsyozu7KFGBVlylbKOAo3ZaBfKiWM/V2IgBrzWwQ?=
 =?us-ascii?Q?hki3IKnH7XfPadzcJ36Yl+G9Bf4rwlPPIAw3BOg53pYxf3JFZy9UC8b20U3c?=
 =?us-ascii?Q?jAkGZH11MWk4bGzU2uQxI9QEw/R9lPsZK5MVrj+nN8J0jYQBoy0yHXYT2b7P?=
 =?us-ascii?Q?SbqSfdgKffh33u5plH/hZ7UAlxCC19E5qPhhCdTMLl6S1W7Ys/ZrYZwUJKUA?=
 =?us-ascii?Q?CRKVBuKTBLebnKLt6ph2qTl311PJmHwAazbsXRxPYSvGrz+nGhpKCKJsiJkG?=
 =?us-ascii?Q?u+efnu66q4Xndm5youECxfdxDcPrFCuyB2dZKs3BV0YhsCnbAHK0YwunlmYN?=
 =?us-ascii?Q?up88sI5uZVd3e8dngr80/dlp6+K7cqsNYy62MRBnkesmLz9lU4H804kPHX9K?=
 =?us-ascii?Q?fPwSUCOblEki3B6S+PD1Asi09oX4OEFPf0/7gpCI/DMPs48BpvBZBVZlmYRI?=
 =?us-ascii?Q?xKzv69K2INyZPP7msnXbdK5IKXvgXjoUr6dkeBaTcZZrIQLBJcMss8DXoWc9?=
 =?us-ascii?Q?txkQWNVNaeiluy5kIPBx8cSyPJnBhG66pNhcAuEMhLUUjATMa9aTaZLS5NDF?=
 =?us-ascii?Q?P+sRqtk/3Kiy4BZdpxKnBHVb2rdFDranc4wayZMrqNCBYHO1Apwc+NHcVTQ+?=
 =?us-ascii?Q?OYZ5ZHAHEvSbbfo2gcFDgXz1efF98EPSfEzljb7/2CLcRQJxl2iVLu6jWVaR?=
 =?us-ascii?Q?1Tl+EKLOn47r1YOXWyWD1+6RMy3vGr0LW3Dnk3PzjU0a4vYjtCtGpJRIkGk+?=
 =?us-ascii?Q?Dp2cndEJKEzqYKKd19+1VkXKmXarq2ulZRkUYOPdRmbU32SN/icoi/+SLb7e?=
 =?us-ascii?Q?LRkkzK15FkspAqaXwmkZTpsiOoHHh1XmnyOGRH8M1p1Yg8n34kfMVG3xLKTb?=
 =?us-ascii?Q?3xo5mCauy49q1z2nZmAP6Q+qLTZ9GseSs8Y7w5mCVgte7d9n+ydfPqmryWbG?=
 =?us-ascii?Q?vM7HCW3kKHThQaoN88uqz2P5ZA2+yjGQ4PtIBlmtrLTIB8rN0YuImaa3N9it?=
 =?us-ascii?Q?R7CrFdyiNwJqnbvcXKHi6U1H888Fni5yfLqWWkO7cc4dn07BLT3wVPqlefhe?=
 =?us-ascii?Q?BtciVmXDVuhUGgep7nMuEgbI3MBVt6f3OJYKR5m1sbjbdZmfIdTJ/g5UxZgS?=
 =?us-ascii?Q?cd6RZbPNsA3fHf5R001/priYnR8EbIioc8wcswBJtI8zc37ZBtqNk177uD+6?=
 =?us-ascii?Q?SNQhX1Sbzfyjdo0/fjrWpHVwEkuV9GVARlqJGY1o2Gf3FFsK1Zsaa38sbJ/v?=
 =?us-ascii?Q?j/ytj53IjXuuifgo1ztbyUXtdVC8M/LmSs+Nan2CBbi6Wv1G+JnKVdvz0YkS?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: od9bedM2Vcbf+bS6Fa90BvfWuAc4fzJM1pj5Y7t08sgaBnO+maTFjCNHYWtnMnQ6ELz1mjVr2a+6v9x3fuGo6wNuVSVWklN2ZNCq+QpSuQ3O5ASDoIA27yQozN4bJ6Y6uCHV94eR2xTsCucqhdpbt4zfGCy1ewem/c+QHtNeuhOPCBuqW/1N0301me2fINttbBq+p2oGpM7Y6LgHmKAFIdK3I5ajeO4Oh7taFcqiRwz7nidiZncLXxj0kdurF+DD/jit9m3IagxgZtCDJhhwLF1HG9XHI496P1ixDYnj0tesY7EqewyI5u+mGraJgqID5yVpf2r9olueMSENx3o1X6BUBRlyefIe3krFFTwpdYVfWBgKmZsWOGHrMbwp7MIcjQrm1lM7kv7JluOH3cpoIIDQ/7jVfwGgjf3bscUP7UgVw69U52FY2g0XHxY2Zlmlq8aU0LkLzVfGRMbWoYvDwqJw3RcW4TkOoWR6dwQcwWL6nbc5dIIwnd6ZrzyF8bq1T7BdBmAksrlfjB+T+36O5i9Wn1HmHma6p43zcaMEOYFOkutLdygn6U5u6Z5/bM9XgQIpKi6RX3ArGnOKhXOFmK4K61maVrwSRMRTXsFwY1NgTo/Zre0t75LT/jHcWQOiS6DMFOOh3vqXD2U803Eyu1nqhDwi8ADPRjpZSCn6yFq3BN9uYU9q/DH6D32at6ZhSPYJX9Pnn+6yisB3Vx4373B6/BXDlBQrztU98XaUWOF2BBj1f7UvjkGrWAPcEnWTrK81kQXTPTPc3EcYGGWHcVyBRUsRxnVFpwcAvs8XYdhVuX/a5VItzjG74kYI18ck5RYP6m8ijXLw65ZP8I5I596UMTbgxxthXhr6O1QMuupjUiy5WD3m7SgbtrPvF2W0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f17ad7c-7996-4f9c-6d30-08dbc4527638
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:05.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NYIFohe8ZkoyHa/RbD3OrDuAuSQEADISiSMZkxNmh9SzWu1Sfk1lmVEVymb8PaxjVcYTkFlVtH+c7DqprTdfBS8xQFeZGTuXd5kC+Zgdsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310030158
X-Proofpoint-GUID: 1lObZ7Os3iRzgbiMNWTGr8ruqWlF44qr
X-Proofpoint-ORIG-GUID: 1lObZ7Os3iRzgbiMNWTGr8ruqWlF44qr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If send_mode_select retries scsi_execute_cmd it will leave err set to
SCSI_DH_RETRY/SCSI_DH_IMM_RETRY. If on the retry, the command is
successful, then SCSI_DH_RETRY/SCSI_DH_IMM_RETRY will be returned to
the scsi_dh activation caller. On the retry, we will then detect the
previous MODE SELECT had worked, and so we will return success.

This patch has us return the correct return value, so we can avoid the
extra scsi_dh activation call and to avoid failures if the caller had
hit its activation retry limit and does not end up retrying.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..b65586d6649c 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,20 +558,20 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+		h->state = RDAC_STATE_ACTIVE;
+		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+				"MODE_SELECT completed",
+				(char *) h->ctlr->array_name, h->ctlr->index);
+		err = SCSI_DH_OK;
+	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
-	if (err == SCSI_DH_OK) {
-		h->state = RDAC_STATE_ACTIVE;
-		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-				"MODE_SELECT completed",
-				(char *) h->ctlr->array_name, h->ctlr->index);
-	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
 		list_del(&qdata->entry);
-- 
2.34.1

