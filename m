Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A2EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbjFNHS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbjFNHSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156E02103
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:17:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kbTk015745;
        Wed, 14 Jun 2023 07:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=82JYNbjhTXGOWZXs8q2uASu8useWzmKPizhDmvXGKHE=;
 b=FM/DyBtRMmH16wlu0mPqMOQFoGow3bBRqGDlvRXJgu9jJufvTozFiHB7JE3kuf2qo/Xn
 6KXyINAtW/DR0EJ5mdmrc9wgJxBJQKtjwhV7J1t00eCjwkf3vZc7zJDKixetMezKbq6p
 4mpTUcEHN343zgkatg5D7Bs+FMeXmqvpKTZsv6cjKOSwQtvOpZuuALKaH3lnn4/Onk89
 qmhGt5JIR6u6EQfMQXSfGWd+ZLHxY6EwLmHroRORRz8yVd9uQR7d5IXxwIs15haERojf
 wq50PITT9GAKvfym1ji6oPsvI2YH1kmzk3CHU5Qh8FGvrwqnYrNAQZTmnHmyzkxlexL9 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2apust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E60Oh5008939;
        Wed, 14 Jun 2023 07:17:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5es48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AU4Z3l8NhlZx3EMvfoBWBKzovY4RzjcETyscRyT5Z5nHyuw7rbBE7he6waDOLg/If6Rq+pS1trUM7lsZVuHYLVwNkC8PMHxfxMtFZoDcDIwLvswN+oi0U/uJg1vZUR4HqXgHpisfgWQS+5jzzuEFb3MEmbSGRfI0VuJl6v+zU0oKuLaTnnz24Sg4N9FEgYhaZL0seKlM3cZUMzpO8LWkg8GUV+qn78lHqwTbWojy6UsisTPFID4GOSBfX+lP0WD6iISKG9rreN3kkS8tflfUGTzeEU44R+hHTQ+QmwYnpsIc9uMffQQRr0UKjt1CHvrmqYBm/7x9Ih3WXDxjMeYe7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82JYNbjhTXGOWZXs8q2uASu8useWzmKPizhDmvXGKHE=;
 b=ZyAaYNGL0aL/nDGZzTVlPkyrCzedW3TIj/CIz0DPDcn1jrrRvuDmmhMG11HYGoitsdYOmwSxEY+yJN/3QpgaJIqJBh+3mRbbMJawC/aHYAT3a+uZ3npAZu7hcs1B1u6wsxNEL75jx8ryGCLM6FEl2TTMJuzFyIiOm61k3YXrbPcdeSSwLy5Wf7+1YBfBaY1bGZjqO7WVIqLxd8ZgaAUoZF0O5LxnClYgQKKQ5VQXV4Tizv8lNMCQpkg1YsH+B1/B3zCENM7wwm68eDo3STKsR6od3zNWjE306hRAY2+7o+2Pe/edgGWeWX2gSr32NgpjJyrIhpqu4lLcoVR5aiX0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82JYNbjhTXGOWZXs8q2uASu8useWzmKPizhDmvXGKHE=;
 b=JfUmt0ZhYSdT/Ep1bNH4DmMHuGrZBm1GatMgDiNh2D/eWGkiFmcUORAMTcCvRgA/Oo97fTRINPOrFbVkiVjPIpKva7d6qfh2nEdKLqJkp8YANenalfvDDD5PfnKY8YE6KPVerSwDmzl85giX5Oot0lvi1EdsJiwLqFhqhfHPl4w=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 01/33] scsi: Add helper to prep sense during error handling
Date:   Wed, 14 Jun 2023 02:16:47 -0500
Message-Id: <20230614071719.6372-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:5:177::44) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ffe6bdf-7ec1-4ec3-4e9f-08db6ca766dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kj6qhXNN4Td6iDryb11P9Ri3Eze6e/6pN7Lu1pV+v8frvlsXmcxUxIP+mCEG0xgPTXB0M0qQrrX09qg+Zfl/67QL9rt7klA6K7exog6f4h6z7HkjtpU6ysGdFzpiQnFqK/AeS8GMKSglKVOtuWRc98qAlg0EnHYini+HR0kzRbY0LqDCOnmE2pO7tTvUa2G9lziouC93H3ng4uA6W9A+FiIXIoIbnjvJ535XPOSgY5TFN6FqBpJxV5Hd61wnfUL8pBcyvPl9Xx9xXctnu/hA3XSFbpPSKgdBEW5L/u9qj07sLTslWiWb0WTX8ZIctgrbaf2/VqGxlg05cVxOjX0isOr6ayNqzJPPfsswEANamw+Bn7E5eK5YSdLHkfWpWc0nHYKdVWG5Y+DHjCSuK3LyrITBHjB4WHhBynV8oqyzSjKC/+/mP7KxbIDSD68XrfT5HsC010Bvpn1NyWhgOYVytreZwlfbcJnukNXWHLb89oPm3PO2T3uAIoCi9y7DleQpEEx82NtMJZXRH6IPl382S1VzLso5at9xxMcpx1q2ymjbEq3/P/ecDCzpmeLYWXSh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gMTax3PQqCWhLdaUQj0K8MhEv/18qpTH4lk8C2yXIMFNGcztfYbJUkaT02oR?=
 =?us-ascii?Q?VgpaWwIlMbTH/DOscwvGr0m7LAcp+vMpAg5LRx7abCPs84XmcDy2cuhzX3+7?=
 =?us-ascii?Q?XDrdyGI/NcVdsFjDUhpOC1Wxh5xxGWKeN7F4dJFlgjvk67/UMHRn9hRTwZEk?=
 =?us-ascii?Q?D240H+qLtC7hSepKOWAXHLdoPAwV1CHgBwAdFDcGHykYa0jmBRRGezJPYSas?=
 =?us-ascii?Q?iqjdSAt+EmaJFh0bxpwNyHapZyFSs9Ex+r+IjiiBBEdrq7g+uyxBWE40ewDE?=
 =?us-ascii?Q?Uowwa7dW42L2p61JyRO/wyJsnMPj9/+yjxzFPy5UhzpzxeS9Zr07qP6b81Em?=
 =?us-ascii?Q?BsHAAnap6UrnsrcqM77Rvw5QsytEqw0Vj1wZ03T2IcU68q9iRj5WuMjz77PR?=
 =?us-ascii?Q?345AAn9r6CbYuRO4CU4HHrwXObD9mhvEc+VzmDgSVVB5nxPlVVOM18Ohk3l/?=
 =?us-ascii?Q?tGQlPa6W3++S575IeDeD/Qg5ZbxuIHZu5+VIfwwOXmS/2q8yF6TqE2jSm+w2?=
 =?us-ascii?Q?CMDx4iUK65fT+yIoi/9uBDKDkAlG1Qx0XPeJGyRR+Z75oh70V3895R8VQ2B0?=
 =?us-ascii?Q?tUpZp+EJd8EtrMXE7iEnPd0nw05qGlU0/ILCyBKvXj1lV/r1t+uA1leF8YP7?=
 =?us-ascii?Q?jzY+YK5kEKKxwXv41x/A9bl3rThffk3GaJV57aA+79vfYGddN1jw04Ync8O5?=
 =?us-ascii?Q?xbDB9bj+qYPmi2l62agffURCsHXjWZcuQUm8RwzRnN+lBOc6+wX2rsSftDdF?=
 =?us-ascii?Q?McX0BYqdmFTtyuefCuYb7Ttpf8HOSLsJZ32Hc+JAzQSnqXF9rtqFDs2twtSe?=
 =?us-ascii?Q?enBCOmdLRA412odbtLBHmSKbp2YwVVwAkfsHWZfOyTnLr85wpAJ/nXWzryNS?=
 =?us-ascii?Q?MpI6NQQAITtAexKnrRkW4weEx8kXgQCVXt8NnxP9naZgLvPs6mw0lN92Ucji?=
 =?us-ascii?Q?Ep7o+JUu9+hMPPs7Ys2FKgF1ei63ECb5Kqoey1EGtjKlJ+Uhun9JmoDVH+5P?=
 =?us-ascii?Q?XPlldLIndiwjrMFxXhGyNhZWh7BvNI/OheuVfKcmhjRuF1UT4eEEIGMNeJPW?=
 =?us-ascii?Q?mTAgEgpNUGt22hfuknuWl+zt8BG7j3VhyYC4XmxSetnWy45WXP9BObKJdZ1z?=
 =?us-ascii?Q?oHVITYV3pxBCilbRdfviPJexhZpq4pICsnZ1VN1Z5L0wRcafI0zz2xBrmwhx?=
 =?us-ascii?Q?ec6iazhYknPIEqC6NtyrYA6WPbmnu2GhuENvuQXjjy3lYhyXnXEbMB0xzBSe?=
 =?us-ascii?Q?IWUF2EaOgluaIYbLB9eNICr3H4wWvjoRAZz9WwMD/C9M+Svkd19NWrrY4tFs?=
 =?us-ascii?Q?L4jxLMG9VYPfdpYBPIaPmPjQJwqfAiqlkTkI4wskgBMbn09O/+rMYtuDomMF?=
 =?us-ascii?Q?/asADXK1EHJYoajDDVG7iUJwwdkPc44+lKqa6F6Kxjh/DeBtCkxPV2MxHkUG?=
 =?us-ascii?Q?dAZP1JYwmeZK8pzOw/woscbq/RDLOI/YymcQI7Xjy1vGFlVNk2ZY0zI4cml7?=
 =?us-ascii?Q?eH1i0TRVuaLsBmvAodZDBdbDUrZghK8p6QXV3u0YdL1aQb7RRAiQ6ilhvVzM?=
 =?us-ascii?Q?90LoP7ihMbnn9QuCPuiWSurEMymPlC7zMoHs35pysiM3Lk5/3fOQdSdVhSt+?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tCtrzWhw0dw9b3C1RWtMQH2CGbP9tj1f/4H30iavQaG4ZLz5rM/GOSt/zGz8BU/p8Y5a+boyd/42aJzi0rLDuHx1PcbRpBSC5e40vxrF33E2Uow1nJY7+MunRPy5LArVmi2VZKE4ff1G335f/FuNFgqXaqRMfKkF4e4CWpziDnF0B0IkSN+DI6GB/MtimVtp4nOubq0VNK8GsVkbGgAE8EYtI6kSmtHxx84o2pnfLCYGnHhVYGah285OwhbBoPpBNgSkGg5JbLWPp4l0M3fVISbxbTXqsjIwlm39q7PNTVGqogxBg0DBoaFmXJAU0gBf601AL9bqkzDA/cEB2ZCJUCiLy0yKzuUrjhcdBUzTyTu2qa79AtAzKNyxkmoX9Bz+ejkCuXcMjSQ8dRMxgNVFh8G3L/ual736+mFqfVLNJEBOUcClD2KtNOZ2ET4YGh8sjHNqzz5nEaQHAVG6IoPSrUBh5SOlL2z4eK3qO0uy9mcEIcPaL8faFVWgPYPQtquy3rcC4k+h4zCK62TFdTukwESLAL0tPZsNY4gMJpZpIrF1H3ebl9R6J+Fg5D7yTryCYRG4Dv08TLIoww1kN1wZPyuGco9mod/6IcR+/X/BJS34FJTbuWwXAODuWMpGQJZHCPt4csXfGPmI+FqenC7O3G+JqW0fJdUK7WayGRzDa7zoV/gfUwQ1h2HXT34RkYx7oWfoX1kf9T6tkaN14wU3GbGJEQ82yjx7LeeWkaTU5d7HD0fUiZ47qLqslibThJHScBBUUCKlL+sCs08fzkxh5QB3XX7s4iGiI6CWwgBOmEd3C8UoIqwEi5Q3IhmzFuN41RY0x52MSthhvwDBBQQ/E097uQZ3IZ4Qw6I4/l+XnIHa4q/MmAFzzNVEUJpcapPd
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffe6bdf-7ec1-4ec3-4e9f-08db6ca766dd
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:24.5334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txM4RwbNoIPXmYBhOtCswlSdm9vxI7YOWkeRqZQroqx6G/rzIxFd1RQgo5TVvOXpxORfFk9+CVjkI/VmkvY2BxpKaWpWXd8Knq89DIkxHl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: 3hvt_r6ngzipfv0CTRIMciHWSc4391gp
X-Proofpoint-GUID: 3hvt_r6ngzipfv0CTRIMciHWSc4391gp
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
2.25.1

