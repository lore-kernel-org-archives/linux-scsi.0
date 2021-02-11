Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA073C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909D964E79
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhBKMcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:32:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40414 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhBKM2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCO13n097781;
        Thu, 11 Feb 2021 12:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=F+aFqwutfhlKA5d+xVW2njaqXGESiPHOWifQWDUFqR4=;
 b=oPf7FcJEcsXizhV30c4lJibjdDl04NJCsI4/Ep/r54DN2n4VBYkFYXFPdbKksllzArtb
 +VzW/t5O4DDiHiiEMI2HtcP4t+sAGXnIOYq1jwfKx5tSsWvI8GiDw49OIebCexS4jXHT
 RMxARhYuqA+n5YTD1GG9tfJWYJ/e1JM1xynCIULiMB6eU2by1tutlKeuP1I8qeBgdKCi
 lM7vGKZV1HzvcGYYAleW/T1gGA39vMLPrgQP2f9Ys/FdcQwRS8GwAUrSdRb+zQw9EMXo
 GV/zGH8+OM7Dtp0X7veL/rpbNCWeLvx0PNPm39WNcJZzOwj6nSXDwzj54uRhVud/pMV7 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgmaqby5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP7qP052228;
        Thu, 11 Feb 2021 12:27:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 36j51yxtx1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/1jDd4KJvPsxa/9tgwH1vKAXSBE7XPwdXSFc9ci0DDhoib4vjAldX3KbuR2zW1tCJSr5NmBu4tNqcgSxkeabJiT7vrJslNiWSkgFeI/PchVHXgCM6UoUhWaK057/Ikw6GQdF3FTSFt9EIoDK2Ek31+5xPlYAhskCPIkpSskPayneJoU83vuuMrCjFHJ+h3U6OQjur/cla2LjueLydW2tRK8UvNu3FXi+DQfdOthyWxMYNlkzQG421mej+UJs1gBF2L13KbWwZWsFdtntxhwKrI+fURm9iOkNI4ljD+ko1mtiUJSH+2ARAUaQRMasuiU2UJXg6+TAQXwOrt6+Y8RGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+aFqwutfhlKA5d+xVW2njaqXGESiPHOWifQWDUFqR4=;
 b=hR13FIxeCmzFBcA3kPsaB9bIlw99ooy2billsp9fRJE04045ckmi1ZSwnGp7ZCG00QfPcRap9Nk1IlQ5/14kszP/InBqDt+13RMKxq7w828cYto4uuzaUATFtuG34i/ThFoVv+bby4Hg1jEsJ5lfFPtE8CW9LWf5FeET2An3mugUNnTNSRTsqtfZ4MLDcmXueu6LXG9VX3R7uzjXe1Z8DVKmcMmey0euPb7m0JuhMGRsf0dzqphWt0A2d/1jpteK/t9esp/QfJ4Qr5Yo5dsWuhY3ATfG6Y/dof3SZM3Z2BA5eH4/YIzeBj5rI+MpT8qPKyPws2OCcDfU1LKJvKItIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+aFqwutfhlKA5d+xVW2njaqXGESiPHOWifQWDUFqR4=;
 b=zjgJjeUxT+T7ips/sAT3Ba2+Xdit5e26Evq1N1g8pt+sBmWjCJEFcdo0MF2z9HyDDCsie+NjbeaAqE+190e0AMF7KAIPd5oCdmwCSI7C7XsCc0YPiyn3XwHMIV/HiFPWlPKLxd76t6t3WR1Bfn2a9QLQIyptNQDEBilXakNiQeo=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>
Subject: [PATCH 06/14] ibmvscsi_tgt: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:20 -0600
Message-Id: <20210211122728.31721-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59699fee-181f-4603-c95c-08d8ce886f5a
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43393C428B39BD42B0EF5FCFF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqA8wYa64d7QDJBUu8eSYCI5qJNhvAdgwZTChHO/f6qYbDNF8f5ceMlPYfuFUuUINJihPQd0CxXy/fwsBrNgJPS9IULz9bPGfRWRG5uRlUb4lCFYgA3UfPera3YHD4hyjsEk3f4vSKOyJMfe6DsWpGGUmm2J08JMmFA2iKZakNbA0CcLgFVBOth/PMGQxTa59XnLUJhwxA+kXPm0jjawMFGp70t7HmSRovOCan/6qAcMaXOH+1v0GAOdtE6jjE+rVComyaobtpQHaN6pJF9Ug4Y0ffP9tvOJ34dPZzpbgF0D/z5BrC/DtrD1w8YYD08ff+6XEdCAxYgU6LRdAwpYuKV9SJIBum4aFYSk/grROg+5uhzEcqIKgB+0FdYTwmocn+eb7zg3/VPNdNnxzjz8d63jSqRbCo/eLx7SAh3+3Dpw3ZeBi46h9zMi2WydVliAWwSIro4SKx9qJLAbnSRQ9OssMMCA5DQAZCFMti/3h/pOvvp4NzWrTADaad/CyqUX2kuOonRZpSK07tA/JIlGMoAAMkjjk48pUE+KLHbR9w9pHsxF0oFeE19qQgpenfZygSLcxC9MEaKLo5YNUmchZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TOZnqHPszNxJb5O5AVnOTC2ZSfChqQV4uj/O8JgJXvEWOGrYgXhefPEA/trU?=
 =?us-ascii?Q?8zRhvUdTzsB1tu0u8kcGPY925WqHn3Z0R48OABYZp1HbfhBQQfNMHYznikFq?=
 =?us-ascii?Q?ZNCKSba0X4aSwFswy+R5Gu9mcUty7QRB15mP0tzaIcYzDYCC/M/kJ7rrQJYZ?=
 =?us-ascii?Q?RahvwLMZvySGjuJhqPmQBW7aNCv4EA6s4MIJP+2Cuhf659XoL9RmyBtXRg80?=
 =?us-ascii?Q?8ooevfrb6qaGpNlA+gIGd2V1ijKQGUnL2TILpNK0TTvnyaqbMVL7br0Z15RZ?=
 =?us-ascii?Q?O50m7mVJNYhczPfj3AViIBv2m9KJvARPJsvbNza9ZoJ6cB5npFxtMFdVWPiE?=
 =?us-ascii?Q?TflG9jprYDnv7w/VXiTFXJ1Kzux7ASkQuINxqMVvG5uhGDJ3Wkhdb27s8LDy?=
 =?us-ascii?Q?ali4UWR2wXHEDbZQabvYVamlpRv1E3fqxJKBKEljaPAP2t19DNWqXLzui47O?=
 =?us-ascii?Q?iAMMm+ap4Xj2eQoy5EXN2yC6jsWZjmC1UO+whtnJJB1HVjYUEifRKWW059Wr?=
 =?us-ascii?Q?WEcXX9hC8IO+tWpk0BosEwSmncIacXsL1G0GmesD9AII66lmjTiWxRlKHIC0?=
 =?us-ascii?Q?GPhFl2uLf6aESpIs7TUETG5y9s7VJcIa1Qu4x4mkqbZ7yXU5HhgsgqfyY7M2?=
 =?us-ascii?Q?ME6zEvn58omup00yDCFKQjMqqeBtOzKgmjIyS6a+WYmsgalRA1q75YdD3kg4?=
 =?us-ascii?Q?oTGLvEOUuYehqilMlOmExHLmpKmUlM30ZGXJVAyeN6tl6gGmVZjyBOay1lVb?=
 =?us-ascii?Q?FQ+622/uvmNb+EIL4/uG5LuyqxdqQdQebjXJz/itCjV88O1tvr9Iab8Xp52L?=
 =?us-ascii?Q?nCxKqRKIyPfpqVGIU0Smt4QEwBCZOnCmmBzUYWq35GJIRdFW3gGQjpn9wihf?=
 =?us-ascii?Q?NCsBI1gkmgAJ30JpSfHXHNUlpI/aHFzn9yv9T7c1qRipb/Oo3JKTBAzACNDC?=
 =?us-ascii?Q?JZSfFBOSViasN3p7DNx+LprmkC7ypvyFQ3wYd7NJ7WK5gSiM9WRmPBAFApN8?=
 =?us-ascii?Q?/eb/exCxssSt4c/a4my+xv8XIUW/5civJkoRAVK2v4nXhRCGoNcUr5rN7Zbc?=
 =?us-ascii?Q?MDkk+jRlMmFwFnjJ+ov0V/C+oub3JrYMTLotzocq1sPXZeyxN9+i6qcuAP7Y?=
 =?us-ascii?Q?e9XAogdGI7nwPtCY/5yx70nwZpWjNuiWp3VklsHjnJXRgnMhD8Ep5VgqSyah?=
 =?us-ascii?Q?ytn5ktib8QnSF+4RXLoOVj7O5s/O8/+WqK80xJCRtVh+rzYu6rs6d86vi0oF?=
 =?us-ascii?Q?k9VLxuHZLQsstKivoYmvsf4vv5wEPgglVBme4mj1bUISRVhx5+GFjyg76yYV?=
 =?us-ascii?Q?PbOZmTWiB6hLtAuYYtRdHx0e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59699fee-181f-4603-c95c-08d8ce886f5a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:45.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MweyURyEpKjjiACuX/JBmSUFGdlVjmZ9AEIEoyHL7Le8t1CqAOdE+UNRE3o0ywVLrmczf0lFREzD89Ped2JgBGSLYACsAZyIg5dOGFUlkeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Michael Cyr <mikecyr@linux.ibm.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc3908c2d2f9..cfc54532402c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2670,7 +2670,6 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 	u64 data_len = 0;
 	enum dma_data_direction dir;
 	int attr = 0;
-	int rc = 0;
 
 	nexus = vscsi->tport.ibmv_nexus;
 	/*
@@ -2725,17 +2724,9 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 
 	srp->lun.scsi_lun[0] &= 0x3f;
 
-	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
-			       cmd->sense_buf, scsilun_to_int(&srp->lun),
-			       data_len, attr, dir, 0);
-	if (rc) {
-		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
-		spin_lock_bh(&vscsi->intr_lock);
-		list_del(&cmd->list);
-		ibmvscsis_free_cmd_resources(vscsi, cmd);
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto fail;
-	}
+	target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			  cmd->sense_buf, scsilun_to_int(&srp->lun),
+			  data_len, attr, dir, 0);
 	return;
 
 fail:
-- 
2.25.1

