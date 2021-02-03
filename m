Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CB2C433E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1277164F67
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBCBfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:35:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhBCBfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:35:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131YEMP193247;
        Wed, 3 Feb 2021 01:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=sf+scpE1vm8734qyfHXXFbtGcpIlAAq+LBwVkgO+Q1yvMd4hOds5jd3k3G7SS+WTIDnZ
 LRViTSMNNWbfaY7R/mTutEOEysGilHxfKtQy6aGINyYYTpfp0qhW8LROUjxO8YgRqtvw
 ITqGxAc5lyFP43+PXy6vimbNZ7G7F23I+XgKu9utrPufcbVNFw1rL5AraK0gstKn1X4I
 ub7FVBx8eMcHOnIM3/p7zFTOTsTMXf71I9D2u1DxZxt3ICA/OieK4DkXe4+1sWVQR/oI
 bdR8+qpl3IpyayON8L0GvLgYuZ3uXPqxGPVv7EKeFWtMoIhx53TRE2AT5pI73UOQ+6Sj Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36cvyawtyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QD2N045065;
        Wed, 3 Feb 2021 01:34:13 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2056.outbound.protection.outlook.com [104.47.44.56])
        by userp3020.oracle.com with ESMTP id 36dh7sfwqv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUeGP+egw+bQ7qou+HRfjolQWKSr3KIo/UDbm89CrAhMoGZkYwipbJ9UGho2kR2dVd+4SeqrusUeon/SRNhez7ypbISDccML74yW2cN+QNmCYzSrP+ovilT5z8nHWJuDrF92UlJMXfhSvaxFoA3qxZXSMHhrlaMhBOBBtO9uHJnnWghF4WjIkdRJquRsFPe4jqWgCr6Fmenf3TwoFdxhZwxtFtD93V4uutWBfqx0kVeck3797PsbN3tlxnYXUPCxntQTGC1KU4uJKtpKP42w90VR+lo6jSIdgneLV2jRHqCCt2tF0AqmEfnEDo5sQS2DgnF8rlRPD6GwP2reDuhjoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=fFhhPvsb3f1h82JSve0Vm2DVZrg4BHlSNtBj1phWkCCQS8XJ9t+HDLwPOO1asRfb9fUmha3ewuYL2quwl+fylvR8VGxUhofyRTVOMNBQCRGO4T7CJd8D4rS9n6q+fwHRbG5GVzFyrdxmo60vMGCdP02/fQisx8mAfHcFqHiiz2ktAhib4XNNDGplteRJPPbdInel7T1kf1KQ21x4flZhK8rejUDrH3PtKg+FEJbSR7+AeeNVvVYrYbRWdC9d6TUewb1AVlLi3VspeI29+yDvyMYGogV6eC6ZEi67zh8lII3bacPQHPAyPMxIc3+jaHnJ8sVdWDGRUpxK85VqrcZ4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/2UGkixiZtBVS3dPLVmX3uuS/lusXXb171MjXJHbCQ=;
 b=tvBHGVOBH2dVxY9GK0NCldUAFBNiTsbrB8BKgCggr46bYG+dxykR5MWQz/6/Xw9pkRA5+T1ETzBBpDC2siZUJA3sbJTpymDAwSdcx25yg8AmDtSP1FPQKOJnJp6fJSLYweA9lvr9nWoCOChIrhTPU8Eg+EIeSWJJ/jyTsONcmRo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:11 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/9] iscsi_tcp: fix shost can_queue initialization
Date:   Tue,  2 Feb 2021 19:33:53 -0600
Message-Id: <20210203013356.11177-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e18ea15-1139-4aac-a19a-08d8c7e3ce9d
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5320BD3629AD58DF45C614C7F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyhU58MxMXqKlarPBy5jt59Cpq3S3ky3tzuAg/TX7vEMM9EidhbNfnv1JkmQuMuNncZMimioSuVkv54wH9piXk+PD6fSveDOUEXAMUCXJzOUowUc1/94m1D9b+cq9ZB+ec06ZcvbelaYUN43OrX2ang3I+VrARepJTNt6G0hYh/bqrOXmOgmsruANieJ75Qp6sVTEosZ4Q45X5KyhKa5majU2zYJDQ/J70hBS94hz64v9xduPsXZMOb6D+SJDsA8cZpW6peByndvYK+tfbYlguiQM+1qzOEx4vhAF2GaBl2xjUMlyFg4RECZzRoeoXz3O1OFU8AAj9lIdoJS7yAaoYyurXMZgCtYpKaeI72GomGK+TZccvyOTUJWwFXuh1qjo2VOp32OS07HTsmlMhDwzqPQ71kyXq6VTNmsCAtJC1SB7flnTU5KtPFYZhMqN/yM7ZOJs3B3QjY8Ak+9fv01SR0MnKJEk70i0qPkCLHbubV7RxWYBAlASHVjSK5doKO3NOvqtyfTv5dAPNzeR+5NK+V7B0SoYtwT0+KWRzcEF8e1R0JQKjF1mNlfjm2oVKTkvv8DfORKQiek7XhdrM9Plw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wyEZH7B5wJdxkrcBWSuzXKPTqMyam7Y4cPagVNvXxfFH8sYg0ZQw3ACGyQWm?=
 =?us-ascii?Q?CDjH4NJtoAQBe1ebrtsHxJXaTjlHW0irsK9QIU8S9Lf11nFMQD4B0m2UCIDf?=
 =?us-ascii?Q?dICiF7eq0VkCBPwB2eXy3IwMnIEBD0BVDARuHds+q/8cqBeA8SZW7LL0htFq?=
 =?us-ascii?Q?fxMdCNeoNes2u0PfA/5Pu+dKkof4dCiaPvmNN4Jx2usR17AmMpNwdmAkOyhX?=
 =?us-ascii?Q?ZycLemTQP1uJRKhueWWNc+EaOVQdldDnXBflId3k/UBiIn41r5xhmItQUJdq?=
 =?us-ascii?Q?+6ezcSaJ+v+d9vWNfDYvUvUiCC0QF+WL+K7qWwQdvtOuzcAuGqI9L7TKliFG?=
 =?us-ascii?Q?MgL5dchYPLWP1mrJSbRcMxObgA7fb66IaotFDuJLdyMHd+k5JCoqa4NabJJf?=
 =?us-ascii?Q?2+Zsy9qWhx+wSgIMfUpvVw17GfqVa7iVN30Bzh6uduDzZq/zhj+tJlMtTefu?=
 =?us-ascii?Q?wJzQBrMclstOpgKobFbdcYouuviE4Wil5nU1jCWN9dC5jMVxpuJJuP+4DbiW?=
 =?us-ascii?Q?YCZTCjVXHyk7E/Kur+7dxW6FTV0vE5nFXpKlWHhNK4pO3j85d+Ugje7sSlSz?=
 =?us-ascii?Q?tFdTCSiFWIZiZEC7afEbeTVbGtlDXkHya9fV84viXOkgs8IQuq+QokVgfChM?=
 =?us-ascii?Q?tZKlN35BZ1NthWEmieL1aikYknf/aTKPdGEaPNyRp/PSBHDFK7veHsForlCc?=
 =?us-ascii?Q?rIO0K667OIt9z2TTigr0/2I5aMR1RFtBs1qjqnXPLxT6unHADtLq3gnCLrKQ?=
 =?us-ascii?Q?fRpBcl6X00UJ/vZHyimrpaO686ov+kijPe5bIw+16YlSD/pfSvM3ualMYWYF?=
 =?us-ascii?Q?h9sIe98F8JFo3+0a4abhewEdkvDkSkWey/IkS1ecRldoIhgleuuX6FPV1zv6?=
 =?us-ascii?Q?hmquQ92wBZe1m1Z6UkOc4CFJhrWj9yfNBobm/3+fCmA3US3EyofmPP/YBb49?=
 =?us-ascii?Q?ZQQ/Mi3hcQ5VY/6uDhP5Mp0441EkR661TjY1aIpWONrHg8v+cLqyVp+2BjHg?=
 =?us-ascii?Q?iek4YwQxgmrFtAN7oiSS33CwvBeB9pYGUv369u+mXlQNz9WaT0IwD/RpucgE?=
 =?us-ascii?Q?Iz28EfDJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e18ea15-1139-4aac-a19a-08d8c7e3ce9d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:11.2685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHOZFW3gXnJIzEeDfJ3YRUeXOClgpa9yRWGSCwBAaEPJmBBppF88kd+mmcR09hkmIy01FQcJu7sXDoWMRRSjq1sbtHdUyWpaIrMIV2vaF2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are setting the shost's can_queue after we add the host which is
too late, because scsi-ml will have allocated the tag set based on
the can_queue value at that time. This patch has us use the
iscsi_host_get_max_scsi_cmds helper to figure out the number of
scsi cmds.

It also fixes up the template can_queue so it reflects the max scsi
cmds we can support like how other drivers work.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a9ce6298b935..dd33ce0e3737 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -847,6 +847,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	struct iscsi_session *session;
 	struct iscsi_sw_tcp_host *tcp_sw_host;
 	struct Scsi_Host *shost;
+	int rc;
 
 	if (ep) {
 		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
@@ -864,6 +865,11 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
+	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (rc < 0)
+		goto free_host;
+	shost->can_queue = rc;
+
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 
@@ -878,7 +884,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 
-	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
 	return cls_session;
@@ -981,7 +986,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
+	.can_queue		= ISCSI_TOTAL_CMDS_MAX,
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
-- 
2.25.1

