Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8323CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554F964E85
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhB0RPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:15:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhB0REH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:04:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGx0ou175562;
        Sat, 27 Feb 2021 17:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=CI5uXppb8PQQYR1g9Hwn6tGNXuJVBFATIND5Qjf8sHh7vKHGIugSSJMKUXNN3uay4/pb
 PGo8Ez3N+rgdxebkMw9J+Y3cSmIjlsikQggPRFTgYQT5B95nYrR4l1caIhnJoe7WZX9w
 PkyKeSE7XwlcHuZJ8iPamTRq+Jf/LUsaJnTWmpoIeodn34G39JuJ5rsyF+LW1iyyn/jD
 SoAjywXKplcLK+EPGkqG3XOQff+yzz5fB1F0XZb73DDUx67jHTklBXB3OYEcIdq3cNE9
 F5oNiuMLzIEerPpv0oAmDohIan4yAJEnk+R5zTn35aLuxwF5GZp/bKAy5R78Q852sXMc LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36yeqmrpt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmh115709;
        Sat, 27 Feb 2021 17:00:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xd8VJ/5Nb9YsRyQkj+g4JiBqA93O/ofB4l8k5MEQjAoJFaduEF0DY7i5aCCRhJRr4gBrlM2zqz9/soHJ7jgoPp0ZpCq2FD73ChIQOfM7dMOtzruuW5exXRZeooRzoxzLHk/ggvZAO1V0befRT+twe4l3fYUuICWybnFkQNq9/d1zCnkb8G+e2d5T+TylfgSD+u6k+/EwKXIXsCWdSe52U6qbdQbaY4baUx9lNQadhz+4SOoBLtQ0crsrnHKyki7jzdfQURq7muirXGV5BGZgHaWnQAa+7VhdYiXZvfHwI72rmrKrJLZ85Bw3wjLvDjWZBZmV2XGylM7FNcVmhk4Mgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=NPMmYE43Kjgctu0IQdIFMdXooy98/yj85gQRz3voxI6/FVEiftx88EGLpYHDEF2PmFd/moMub82YfmL8+j+bV3eqi+TprxUhPLNafOcNYPxXPQUJiQnfLRa9VPJlT2nBbA9Xh53nVB7fiOy0BmVS0IezoN9MX1G28vJJVAYcmKM/O2D8hblDqMcKvF7692fWycZU1Wv4GiJ/6QM8C3MkhTsLq2CwhWBUdKWePAOJsAbLFcz9feGSOSrPrsum3ewTIiP8EA25qQJxbDN57pLrWKqZn5kIexLt54wMFxBy5Rou5soS7LG0L1+UTjJlQWRtVQj9ODXOGPjV6xbbbewgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=wBF5Y5t6fHCyq1GJyjV6XUyFXGCG5aQ3WjcUJpQvtVBpCVuo2GDM8SgkCXnd8c4IrDmiDU+fT1+x/GS26Lg38LG9aYY2b6Slk8aboEf8tPeyJnaSNM22sihFoXtx8HgZMOPv/MFZCk54wI3vc4pwIhiGhdjlrAtnWoQh9TH9cwA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:25 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/25] vhost-scsi: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:52 -0600
Message-Id: <20210227170006.5077-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3067e887-35f9-4dbf-faae-08d8db412d3f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB34995274C8604A49F8F668A7F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuI8Fv48aZv/WzxC+bIuBUfRbwPLErxvlcjXYSV1wKUAle5FRNqU8MivKEg+7FiUjP0jNYTSXlBJcLq13GMWUDubp0f0dIkfEvsxvpYKSwYj+gKkcdRKBCrgclnTF6SHxpWwzOKXv65ZKWycUdR2mcH0TOQtNvtaUFd3RGuXMebXSH7mGKFjUy/vg5ehgFkcK/OSD0LX3g+5uDLsTP+RUifZr9154K+YRhG075EkkOgE4blj8IAZR+3MJ5uQctcFMzs4q2xBaUUd36Adq8riXlMPXSwplJ0WSc+LYizP80tIF8gAA7wKQ478F9No11yC/gmm7+lQ8rplvS2vfdC60C0xh8N8xudbs3uhObMrCd8L+6OO5z6Crio3AoFwtopwnVtrBBeamBoNJQUky6kznQiil03NdeGJPVQMa5Qof2PEtxJyFd+YLqAvYdFLLuGmTNuXkA5Su8IQ4egpTWOVdvfuq6r9fs7Iub7jH53n/OpgweIRvXwI4Y7ZtxtRQdMJrSSoM3m6hhTRpNL6qELp7cHT0POVGq38LiI+6Q/EEuQ7AKmYL58KIaJKDM4zqw+U+ttyBZ7CZGBzvXruAGLu6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ttQ8Wtnm3whpMHOg10fCUSTDttbPVtqW178zuxsYfPlVexI0FKV0SL46DYnd?=
 =?us-ascii?Q?CYLrTzvrf+E71z+2zkc31h+vzr3jBABA1URTQP7uZrwLBzsmMydNaMoXRGZS?=
 =?us-ascii?Q?VjQPEWvcWM0pMXDzrHdFmPRBG1yY0lUBYJYRGCSgLb9aqW/A04yvnBHJyJOK?=
 =?us-ascii?Q?/PtcurK6nPii3i5rvvuMeKeUKjljbQJriNiY1YfQJfcGDrvCxyCzGB/XY/8Z?=
 =?us-ascii?Q?1RHM6tGYTtdeHMJ9giSC44lHpJhfmgLD8iQ7bbDRZtdsh1WaP2/aNe92fre8?=
 =?us-ascii?Q?8ru6v3q+TOK5fUTI+CHoRiYw7v91ti0unHGJJX5a6SN4vZtyISSAyIWhKG7O?=
 =?us-ascii?Q?HLkfAzbQtGdqtC7+LPB/muNSaq8qwcriKCWrAiFANPk1ruEh/pQxu/74pbA7?=
 =?us-ascii?Q?9paI61zcbyRN8fzgBSssz23YqDWG7ANUhHQjDhj+ThL7vJy0oOOP7p67MDYi?=
 =?us-ascii?Q?+HoaOVIDC+mEFp28MZrtmJ/5TyB7+xxoXKiGn/L6HTMLGgopgLNj1roKnP6x?=
 =?us-ascii?Q?6pqaHP4+yVcV777wgig+5VX8FvuCmj7A8kBzcG1R45yQoME+zxJOvjGgcjcO?=
 =?us-ascii?Q?LZNjj6tn9ZxZZqjPOx+xyFXJ1RP6GHD3AEgmo71oQmM0kNrl1ER6trzifxj9?=
 =?us-ascii?Q?qme5mTJVsFVrjHclpVgoe/M4EyKc0ggx12Sqs/WzL/m9zau5jUlR5Ws/h4y3?=
 =?us-ascii?Q?OCLdAhgzkxmD3hvBwyLsYIWRDCvWbGhHlKUy1nh7PPFsLcEF9taJ0Xn75m2E?=
 =?us-ascii?Q?SsMUdYbsGGmSmMAZm3Bk1tUH1tABFuTdGV/aoVLXYxoxH/zFrnS8OAbN1VAy?=
 =?us-ascii?Q?zWqhFy8gL+jkVosuGXjvMY4ZLnQ18aiynUnsL8avSeyvAu/1I2Tq373AkVTa?=
 =?us-ascii?Q?JbQYSEqy7EJCa2kjvTBbRCL/0gC7Q/RWNUSJKTlT9g50sZx1/hXZeemHoH6+?=
 =?us-ascii?Q?9i8Lpudah9klvEP0ja+dWX13zHjt6Mvg4tu+9L81fP+kNYHmsSV4V89Y52Ep?=
 =?us-ascii?Q?vCmTVJ6uvWQOQW60SJ8BfcV3XRCjzYpbA13evWNgO5nVwCI9+HZgSY1OFt+r?=
 =?us-ascii?Q?wgPN8zYxiljTmjyhw0Wzjs/iIBNySYWRd2b077CdLnCcz4DKNPG7W4tmT7Pj?=
 =?us-ascii?Q?re6+Z+4bJgayTEMiuIxAtp8CcMX7607BA9brNacamkstLqq5+sZonvJdaE/G?=
 =?us-ascii?Q?LdGPbl+0vz/iLQMBcb7LN98Wl+6HOsLktO5Zz6ss6zUKqRTuWyhzk4q8hGFm?=
 =?us-ascii?Q?nH8pDE3adWKL4RGK/Rl71HKSf7UJCidEmaY5j88nDGvtz2cEI9UkJRiAZLra?=
 =?us-ascii?Q?n95S+atIk89rCV6sfYDkzfC5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3067e887-35f9-4dbf-faae-08d8db412d3f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:25.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNSF34T7aSwWubWlVgg+XVShjPxiNWaavRTC6QKP1uINTZwJ+MYJqb2UiPEIhw5Dx8l+c2HozjF0YtzZpvNaBumWOwu+OzrRb+kn53qrECM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert vhost-scsi
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep,
and in the next patches we will do the target_submit step from
the lio workqueue.

Note: vhost-scsi never calls target_stop_session so
target_submit_cmd_map_sgls never failed (in the new API
target_init_cmd handles target_stop_session being called when cmds
are being submitted). If it were to have used target_stop_session
and got an error, we would have hit a refcount bug like xen and usb,
because it does:

if (rc < 0) {
	transport_send_check_condition_and_sense(se_cmd,
			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
	transport_generic_free_cmd(se_cmd, 0);
}

transport_send_check_condition_and_sense calls queue_status which
does transport_generic_free_cmd, and then we do an extra
transport_generic_free_cmd call above which would have dropped
the refcount to -1 and the refcount code would spit out errors.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vhost/scsi.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4ce9f00ae10e..76508d408bb3 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -789,7 +789,6 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
-	int rc;
 
 	/* FIXME: BIDI operation */
 	if (cmd->tvc_sgl_count) {
@@ -805,18 +804,17 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 	tv_nexus = cmd->tvc_nexus;
 
 	se_cmd->tag = 0;
-	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
+	target_init_cmd(se_cmd, tv_nexus->tvn_se_sess, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
 			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
-			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
-			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
-			cmd->tvc_prot_sgl_count);
-	if (rc < 0) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-	}
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF);
+
+	if (target_submit_prep(se_cmd, cmd->tvc_cdb, sg_ptr,
+			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
+			       cmd->tvc_prot_sgl_count))
+		return;
+
+	target_submit(se_cmd);
 }
 
 static void
-- 
2.25.1

