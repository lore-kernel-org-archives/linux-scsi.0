Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73E6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E32E64E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhBQUcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:32:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhBQU3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOM89147359;
        Wed, 17 Feb 2021 20:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=jL27tC1oTcOoIZgbqToBJenwoXwLyxE+kbNLlByyDDfaTWZfiRAE7Xl8Lqr1ASbjiSOP
 dj5OBhfDW1azrrUpMOvm66a0/D5QA+Hvm711qgfZdXE2YrFv1pEN42lW+rKKhTzyKeQi
 dAxwvRH+MhlCShPirjcnL3pO31XICC1c+d6WBXw9y6nESb4foC/zQ8SK1cUePTlxDavP
 JcYmg77WcMF4Gm73FR1xuqIqtCxYyjQNom0BAa23agx5sjf9CaiP72wGM6/jQoQWq7FQ
 nwXFJsp4zAkBbswS98VSyVIr4QwswgaGf+iKp/qv7zIGVd4beJAbsJJvc/Um4LEGc217 CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnkpju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQ6rn111938;
        Wed, 17 Feb 2021 20:28:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 36prpykfaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxWeuKJ2ObVqV1oQC5g8JZOXEc5qURqEnhnkT3nkNIpfVoJuRgUxJBZrMmBXmZBKFSy6XmV2JTBIfYDlK/BoHfOsGNfKjnxTkcrx4rxs8k/oKcWh1bZqxC1B4gm4rHTfzO+JwATcqYnXy6fuqqErTMR6Q1z5O8TI/F8xvVixoMRFGBOhh+esD0aEj994k2QvY5IN9dnCdnZcsjWRy9y4W6ZtTCd5iGi2J/z0h2GPI0OG09ODK+gGInTG4wtpcq3oiykcB60jfR0DT0OPpXr1GTVhunCJR1sEUawSUG016iddroZnVNtgEP4Bs7Pp90uv1+qosZPOk4B4qaYaUS2t1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=fYQO+N0dW7WGeG6E9iRZXRCZGV/fxuCOELtrFAeycITFbkJeHlc3WD77mfvZeZ6JB3NrCHVGlgbJlSpHLdEHijjQouWxwOk4ALw+5uA+fyCSmnH7N89XF3Qfl+mKillD/lfIGa+a1SyO68ccSXCYg6XwGkfSDm12fP0OFb5zdxg8qet403YSfbJvGY4NEJZQU73aLPr2weaigIC6Q+p+vh9G5vUPO17SBDICBrd0gHD1hiwIAH8eKzGn4VxVVUgVcrad6mlvOYjiIlBnHM65f9ECDrPn+x9x7owvvJTM64Vxx0xASXWEfNE0dkF1d9EkeLSZCTACvlRbafTn/i4F8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUNK9kzWw5Lp9c3MgYqKzYs3IW3QY94cy1GUfTpPk78=;
 b=z2Y8jZ3uNE1AOEAR3idMXGtOlWDIiUxYikkrmjci/A9GDLC0aSvbFVPR6zFNmNHVNWtI2gr/nzY99X41gGj0sYZUDaLgrN/z3cqMgGZ1hcsBt0mtGrQxvdeQ4jU5h2hoAUbd8yxAit2KBCdeNPLH/+vRbefzNWYOfYbKmrilr6U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:43 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/25] vhost-scsi: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:57 -0600
Message-Id: <20210217202811.5575-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0cdc0eb-beea-4c41-78b0-08d8d3829e9c
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101D66E0B73C6F3E7C21324F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqcW78AZ7qHa6y7DMUHD05t3VdfZMPL17FFUsJnleVE/tj1wKGG/Qy4thcW4dBqK3wLcV/oOboR5Lez3G9TNoGf//zc2TW8J5NubgMqA892VXEGY56VK6SyeBOPboCJDw3yaQVQjc9ToeDU0DyPb4JuXrJW3fIYu5pxWcdB+6qU/GHHfBnV/tIJXyW5XbtGZDeD8k5mfL5ljpGAj55xogES7Jlyf7jO82qoZmHejpHwED8q/9pGvm/mFnNQmZhC0eSzcaAFCarwQL6Q1qxXDARgLdSsylfYiujX1C1/toZd6JYYjCzHxOpzdEngHKXxe8IdozGG8r+ge16FepqIV8gZSDuW8MLiBHm0G1DygIJ52hLfv00SoxtBBBXZ7VVAz8eQqwinAtAZf4d9BSM662z49MMET6hoSK3KvpL9PcBiVwvUGlTve0FmLqQkRyS9jW+DsPwSGS8ryzCLM8l52V+15WuPucFivb3cgVjwy7/LdqwIMywRFYF1qdnPXw4XN0zeuUD/CI9Hvt7tvTydWRUHnjeVsgsQow4stOg+oTz2xlybMIPIepA+B4/HMrY3Nu6iuEXjfxWws0kXfb0iw3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xBfx3F8zAGLHjDoOMH8SFVQchjbBMZZY9ssO3+s9LUiS/QCH6Q+9dgKCskIW?=
 =?us-ascii?Q?y9atOUcs6Fp5czvTcMO2l94N/RfKbTIsbVyxa0Q+znskNQy7vJNZPZAh/gjn?=
 =?us-ascii?Q?OftGGWbdbq2YINidEO6RketD03jjSyZan/I+i7UxogES+x/gv7VoXrlmMb6N?=
 =?us-ascii?Q?NhMxpqCl9TO6tUsaIATSnx/H9gobc6e13T2E5F1VkthpGr/5HDVIQBq5kV2K?=
 =?us-ascii?Q?mW3Oo+AEqQBrKhas6npXJhg/Lm+qT7A4mH+fkBAe3qYochcWwLb3QSi2mxjU?=
 =?us-ascii?Q?lzLXuQWYW6nvj7e0fp42oCUy0YE77znlL/SSwkzwXRL620znfGrTYAj5bRfS?=
 =?us-ascii?Q?iXschIIiOVIhZMm7Wc44jYcAwU3r+uWPb01KYo3Qw4+EsnkGQQzYYDLk4EHv?=
 =?us-ascii?Q?4K8y5wyxvOpTK2qgONzq+JMvagMMnir0CmQnikyd+xyqD3YeNv+Fua9W7GMC?=
 =?us-ascii?Q?72Yg8FqFZG6CsmKV9/6kJ0c+OMRfrnwHqW7kuqUg7XMAOBGOK0MPG912qyYr?=
 =?us-ascii?Q?LhzvTGo6zJtOJmvtex0y4CENPvCPyDXqmp9jlO5D8WyY2zLmdTjKKeo0fo4A?=
 =?us-ascii?Q?DseuyfUJjDGr46o03fG5DGiO+Do3HvLQ+H1q0GXx6jWYVj61kqXOy01QTDbm?=
 =?us-ascii?Q?m3jR0poEqcP232pptL3fohCjnC5ANQ1lntzybh6xxlRNN/we0CABN49TPp8e?=
 =?us-ascii?Q?7eGzJdEDpGk8/nTKpJ5fHdtjPS6JyEcWRpDVB29vMoMi6ewIruV4zgvrv2Rq?=
 =?us-ascii?Q?XvdnBkSslWCmp56hhjWiyjbhSJFprXuY5b4aEgxVpU9cemjEcb3QHfNZ5d+c?=
 =?us-ascii?Q?qMBBxtvBoDR9VbKrHsK9YTgRvBkQdc0CkNhlXxavB1IMXXJ2SZG8+MfzKuwv?=
 =?us-ascii?Q?htQUC70lIy8DNZK/BIpmAG8Pw2SCjI8x/ffkZA2yPHY+wg3v0g7Xdm3YHGJS?=
 =?us-ascii?Q?LU/DYVDvHOszBCMBR5DGlglIvg0yzfBls9x/ATQbArmIt0xWbQrFheFIi96R?=
 =?us-ascii?Q?caF6UuvMSGY8LteEH3lUf3U/a14dEoVoz5ACUa9bNbycAGDUa1+gY+28iPE1?=
 =?us-ascii?Q?k8qhnsBd43Rk3dq/+WYwMUv2a3Acj1H72xlRcd3OB/m+67M+91//Wii4NdfT?=
 =?us-ascii?Q?earV4tdKhluRKhvuT8/c3J8cMG27ORqzvfEdP1PcYTrueSbxzNj+IR6FT0r9?=
 =?us-ascii?Q?dGNmIA9z6V3pHX7QnBXpWHH9U1GqL+xDdLRziQgyw+BKeaC0wCd0bkto/sg6?=
 =?us-ascii?Q?0iW4QbtrlMziZYdPP1JKjF8VNk71aCBEvCf6Ek6s31ffs4TjHkUsfWuu+ygI?=
 =?us-ascii?Q?aRswK//emT6dcBENkoq7zqlX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cdc0eb-beea-4c41-78b0-08d8d3829e9c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:43.7176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3O0GmS/QDoBGOeX6d78eCqG8tHBFHGmCXi7Va8jcD9Ta/263AgAfIDjy3DAmGLfzipbmaUpRlIugbiNr9eP/1YauBeAhNSL++puR67psvZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
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

