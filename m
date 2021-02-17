Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22119C4321A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F208964E6F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhBQUdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:33:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbhBQUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKO95T146933;
        Wed, 17 Feb 2021 20:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=ekfMav46ci47+v0bxCYwyQ8IQASZl1Ar9lY2P9kO5TQ78OqzVDsOioq0GaQz52EOQzkA
 11ZdWi7YmAvm0x/GCCaOXc5lw6m/mmbBpFiSKzbSc3s1Li+uha8GRQ9LG9tnX7lvfq2q
 4/9aeWLOD1ueAZIQfcl5clmxYLcphb+fxTxIBz4HN9Coq/Bjur3FAI/oePVyugSrDG+i
 Q56EWYCQa8tYuEIxtZZZ6J5uMaRXzHTwd3PcGPraHvOyaoYfCflTClJt2vq4sAb5WY7Y
 mBhxS4IE49ztwoPjrqRe77nBV/h4dzSAdfS2VFDG8rObqLfPlTyY2qQvnSBLH7Ma161T pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36p7dnkpk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKPbkg113375;
        Wed, 17 Feb 2021 20:28:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 36prhtb5tg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGkavj1XJdDGi+mgoTNBV+BYIgbZ52G76KoO7ZnG13tzwwl1gLzNvTxMfDckY+w4wNZhseZMjVuBGe3Aobl+VWYeko5aBXUyPYRAxaiXGENkP/fVuCrda8b7WGedvpe2fzIJvOZQNZWnEJZFb3y26KSEUW/FqR56+YqQVCpvrTfJuEr1w3vLt5UFk3SRxPyiKfxa1CjUE2fHQgP3GMr0Gd1peyMlpxJogwc8+jZJLR44F/o9rVkAmzP/3U/bcO8rkWZYBcHsOAZ5vUs5GSWDDAn9pSFCH4duW3Wvyf880WuxiMn2dJU+DPgSKS1L1puaIrI3jgm9Fxc2Zphxg9PgcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=aipDSqUB2jr7Hugf91KYMprO/z8Phr1MCV/q+wnXSCUa31/wMgdy3ngK7YPOFrdNWCC7IzzJgWrF5JT5/uaJcOQ4rZXfxlKElLi+LjKg4+Xcr19JE01bS+TZx3DVgKmUUGnG65uvX5s1+8QvyMPJNJjj6lECv7lPZzDkGFakx5STrax0svaC7GMec2mYLD/JUT0Lv8Hm9PuTkRmywCNwz+nzV6aMGhYsPvyQkgcp4nXcnl14YTj5DGwJMMli/wm+o4lM/v9Xh44c9THFC4qnjpyz7jcLcAdJaZtc24X//a/vEdCvPyInN5FbdmDZRDXC4/fgdJQ7DEIMZWF2yfICHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itSJG6yjR1UHZhPl78ExO6tKSVBINoJd8hEnckxtsAo=;
 b=nlGdMwNaIewxoR7X8lXILdL0qXEfdIpkEVq4R6zHKGoO2G5cFxird5o/HxCZ4jEIB637BPA6Iio7LIlkkxyT8CkEtRIDXR+BQFNbpYCW9yqmn8sl7tgMLbW81IxSQElT6/J+6ziJcylcX91Bt3XkjJ/9NilF3q7hcdinRdDjPnI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 17/25] vhost scsi: use lio wq cmd submission helper
Date:   Wed, 17 Feb 2021 14:28:03 -0600
Message-Id: <20210217202811.5575-18-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efb3bd4a-fff1-4c05-3a5e-08d8d382a4af
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB39407A86B9FD2F872FEA39DEF1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ayGV09OmA/3bDyxzzjBMXsTjl08rHoSoEYbHur6a9cd1QIpkbVO3qB3hNCOw3KEOx41r9gLbXVRYEbCCY9SjgeUDAHNtF25EHAjJZ2adcX43UwRe1mqg+eIOATslT2celUBybf3FDOoB6mAUbUdMwJ5M9Rksk5atPV4hPmr5WXjWIGEV1UpULelx6pO/gaXkJGDJXChKwoyoe9ysgOpnRdmL5exV5M/mYqJ9Ra42SmBS1KAGPAzxgTd1bdBPIU8+F6deqwZDW2um85M+ekGtxt2knkgnPiQgqF3jng+a9carkY+KHdjLHjtmPtcpF8J4qNUSn5rva5THzRrwQhZQWN/CBnBC82UmUDM2t9geQjUV+dcENOwJ0Fa7TG1FebNGKVi1e23b3InTkwqL84TGvD6qAmDesoQHiwKtlEAA8BmmfF23cLkUXFcCMEKjahCCbNKjToetCJK51CnQtdMUHuaBUIdiASlILhPmwyIWWfHDOuHhH30UIah8Zmi3bmqp6awupWUkvglfJS9YaUT8svBDUQBClirStg8ZFSi7d93wfquaranV2RRm+lttpzKCbX0EKig/BIF/xofHjM+tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S67Ep8WT6bkJxYZ6WMO84SM1mxZNaqYsFLUMLaXDPWHs4EWF6q/2nVMHNAL2?=
 =?us-ascii?Q?o7qcLcKWpdi5gjcMaCfyRKTtn5LD7nHuXCwRv/tS7aXRVz6ZRmphBXB5cGgu?=
 =?us-ascii?Q?WKIyN8NwRhgLZNZIaogbIg0PEp3VBcBRDCcJvCIqef0E1QcxvrE5SdzchuBL?=
 =?us-ascii?Q?AhNLjjrf5Qu8tpq7cX4wGhvWEOloSCrz5ojjvuy3158noL70MX0beWf1hp8j?=
 =?us-ascii?Q?8R+OY/855SegpfW8TJwQhue7p6p639g9+9maeKYZvDGnxyMa11H+veLMVEQR?=
 =?us-ascii?Q?rAn283AU4WQqmyPs+F+MZ6PpSoIIG7bwSlgAjydWQuFvZiNBTN2oL+hD54fM?=
 =?us-ascii?Q?4L7QJIEgxB385v1CbJ3K04iacm8zH41QxF/+V5sMmYRyGIZead9yVdxEfklA?=
 =?us-ascii?Q?mOW3nFFsgAE7qjNrxLwdZlk38aO6nuL64oI96fNJu7hxI5pBzz3T+mqvayFl?=
 =?us-ascii?Q?6/psvgqhwkegrk7SGN2BFFwNQynHdHBjYGKABtTngM9yhaBFzWuHdhO5tzy+?=
 =?us-ascii?Q?ic3692xnp4GkrSgyZyrtW3wtqw9+41AskLG8Jnn+/AfYAbfpjTUPrWU+Mb7w?=
 =?us-ascii?Q?hhSMbuHPu90VWE820vEMRM/TohhwpcQvRk7bdanaU5v47BTg2kb7KIP5Ug4v?=
 =?us-ascii?Q?c//poUuvE3CwzZq4HtXborhkVQ8paYuwjL9j6pFDnekOF7SdEx/QiRD11ppm?=
 =?us-ascii?Q?Uhp3TDBqg+1LmN2vT/ZWJnItTiB00zimm5AI7jtDjZsmrdF9dGXRiI/sA3WB?=
 =?us-ascii?Q?EstdZrPJ26Ehsie89Q0Dc0dt7qWBRH9Az6N8k3okGN8+uv4g9jddSIaj6udx?=
 =?us-ascii?Q?aWC8SsgZPO5EJ3qXoO94Y+qhK7MJbiFTNL31OACbApos7JwNzp/COj3XUh/Z?=
 =?us-ascii?Q?SIngSZ7l9+yp9x3yfub390gLtQFs05/hN0ZSujak1dhrEhjSL4JETF+zReIt?=
 =?us-ascii?Q?GyC36e2NXvPZeipySTT0ShswZib1BhUOgKbPpAJhaQirLuWTBQTw7jaai54l?=
 =?us-ascii?Q?87WxI3ofJgbDH2qNd0/4HCpfmeDuAblzuXmdW+18oq5W9q91ug/NRbtl8QYS?=
 =?us-ascii?Q?ztS83Icx9pGe1dgw3Smz99uKF1jFvMwiHs44VoCtPcjrS+zv5V5JdyuBXF1i?=
 =?us-ascii?Q?7wU2uF0nWSau3cx8k6QEqS1N9250D1WzlltpoFU+GX8WrN61Up9KwAz3rYyy?=
 =?us-ascii?Q?HzDLaxtnNqbJFt5INlkmEhYLjwlquJQRVzRDPdWq8aTyH6zb3fzJkkr8rRv+?=
 =?us-ascii?Q?LwvNH1EpnvjRhOAiHA95JLMJ5VOUQlER5InGzaq7+tijlxcgRnU8mG+uCUK5?=
 =?us-ascii?Q?bkM95wKwQJj8Vf/ORg6jtDQo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb3bd4a-fff1-4c05-3a5e-08d8d382a4af
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:53.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHEWCNbZ2wb3e8PPX87O9+UOlHuXJtksub+ISCMSTh4rnt+kYWJTEOmsoo3R1CInTKdwvocs9wDr5aXDdYr6aE8AzAiYIA6qBmcZOL+s/qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert vhost-scsi to use the lio wq cmd submission helper.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 93f5631b469c..f3448e542965 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -85,7 +85,7 @@ struct vhost_scsi_cmd {
 	/* The number of scatterlists associated with this cmd */
 	u32 tvc_sgl_count;
 	u32 tvc_prot_sgl_count;
-	/* Saved unpacked SCSI LUN for vhost_scsi_submission_work() */
+	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
 	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
@@ -101,8 +101,6 @@ struct vhost_scsi_cmd {
 	struct vhost_scsi_nexus *tvc_nexus;
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tvc_se_cmd;
-	/* work item used for cmwq dispatch to vhost_scsi_submission_work() */
-	struct work_struct work;
 	/* Copy of the incoming SCSI command descriptor block (CDB) */
 	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
 	/* Sense buffer that will be mapped into outgoing status */
@@ -240,8 +238,6 @@ struct vhost_scsi_ctx {
 	struct iov_iter out_iter;
 };
 
-static struct workqueue_struct *vhost_scsi_workqueue;
-
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
 static DEFINE_MUTEX(vhost_scsi_mutex);
 static LIST_HEAD(vhost_scsi_list);
@@ -782,12 +778,10 @@ static int vhost_scsi_to_tcm_attr(int attr)
 	return TCM_SIMPLE_TAG;
 }
 
-static void vhost_scsi_submission_work(struct work_struct *work)
+static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 {
-	struct vhost_scsi_cmd *cmd =
-		container_of(work, struct vhost_scsi_cmd, work);
-	struct vhost_scsi_nexus *tv_nexus;
 	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
+	struct vhost_scsi_nexus *tv_nexus;
 	struct scatterlist *sg_ptr, *sg_prot_ptr = NULL;
 
 	/* FIXME: BIDI operation */
@@ -814,7 +808,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
 
-	target_submit(se_cmd);
+	target_queue_submission(se_cmd);
 }
 
 static void
@@ -1130,14 +1124,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
 		 */
 		cmd->tvc_vq_desc = vc.head;
-		/*
-		 * Dispatch cmd descriptor for cmwq execution in process
-		 * context provided by vhost_scsi_workqueue.  This also ensures
-		 * cmd is executed on the same kworker CPU as this vhost
-		 * thread to gain positive L2 cache locality effects.
-		 */
-		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
-		queue_work(vhost_scsi_workqueue, &cmd->work);
+		vhost_scsi_target_queue_cmd(cmd);
 		ret = 0;
 err:
 		/*
@@ -2487,17 +2474,9 @@ static int __init vhost_scsi_init(void)
 		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 
-	/*
-	 * Use our own dedicated workqueue for submitting I/O into
-	 * target core to avoid contention within system_wq.
-	 */
-	vhost_scsi_workqueue = alloc_workqueue("vhost_scsi", 0, 0);
-	if (!vhost_scsi_workqueue)
-		goto out;
-
 	ret = vhost_scsi_register();
 	if (ret < 0)
-		goto out_destroy_workqueue;
+		goto out;
 
 	ret = target_register_template(&vhost_scsi_ops);
 	if (ret < 0)
@@ -2507,8 +2486,6 @@ static int __init vhost_scsi_init(void)
 
 out_vhost_scsi_deregister:
 	vhost_scsi_deregister();
-out_destroy_workqueue:
-	destroy_workqueue(vhost_scsi_workqueue);
 out:
 	return ret;
 };
@@ -2517,7 +2494,6 @@ static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-	destroy_workqueue(vhost_scsi_workqueue);
 };
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
-- 
2.25.1

