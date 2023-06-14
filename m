Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D41EB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243212AbjFNHTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243345AbjFNHSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C7C2107
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:17:54 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kPMJ026804;
        Wed, 14 Jun 2023 07:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=wcYpK/EInLCIcOLs4MNjrjBYaFmp594/YK76NH0V3IE=;
 b=uanwtwjrijCIisnCVJI1U0jfsrnA7ZrIt+fGxq8UT7h+NlC9/V8Wi/+N5pbMlq+N/9Fb
 /3om8aA7AiA8YXW9RpnQowyPL1071H9jFRVhzS36Oj+FNcRTJv0mznehHY+iLExPH8Ca
 I6Tb3r4kZmBgz/62tnXh3TrG6284ipN2Oljb8rbJAR+yAINJ+Z7Ixt/vKUNmKEGgx72e
 IO5nNnTcqejTiBPaa6optFw9amd8OZmCjoQQJrpWxxx6c4iS9SFYbTjzL3lSxjZGOJvl
 fTAn5GmB0M+qXFpVTymgvmweov0Zh+R5NuZ9sO2i4iFHHLNaVzLCMwxwih9jsQfkNh2X cA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5LQ1F008933;
        Wed, 14 Jun 2023 07:17:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5es57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq1kr4Ip5eNFx7GR8CGKtEvXNmlAWXpirw0bZ7ejw4L0bvdDvo5s/jkpKmMzuKT4OZS117OFmL/flTXAq2QX1IB0KGVTBqZP6UgWCTfYyJ6DymWCOR53WVxeb6N8EpmNJFST6SX8Lyt+Gue7O4/FImIANBl05TupG4S39mDJ4CAzM+/Z+N5OgSGrlyjT6/toOPjHXhkgulDAviiefn46d00jhCRpbi/rqFAbW1hx/lL6L/IgTC9nQTbQMSFivToUFyGrDZXZQkyVmiVgh5j3wSRFralelezQxyXM73gwFJimp0nSpwbgi8aqOO8jI+ZysvcRvQeGj/MxlRY+ue0GKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcYpK/EInLCIcOLs4MNjrjBYaFmp594/YK76NH0V3IE=;
 b=iJ8Rk9H/4pSfxFmBQKQSm+10ZOeh97R386NfwI4Pq+hRQXKzrUr96vQ2sWqwYgskmO9XQzcaFMmz8WDuLIjNdFk+AEN3GaVzbbMJaaEOAr+i/T1zVjjeZU01N7xvf2nbu0wlUfscDbTewyg4ru59a/ZCb6bJyG7bblwl7ano8rzbqgG0Xvm0qcN64LniOHm8jBhM2w9Do5ar4lNwm6hh1Kvw5jdngEVNAM1RAz4MePjHQw+/61nzwRveTzVHPhyTSOu9fLUEdgO5QT+dae4q1UIuqA+i9Y/xwyOSEvo3NcJVGFxWdb1yax9Ia2j6ItCP5PoDoNs+eFv7XmOlvyafqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcYpK/EInLCIcOLs4MNjrjBYaFmp594/YK76NH0V3IE=;
 b=WANXwZJ9OfBP2QrV9FkL8PDDZl6durZeRQGAGmOH5L2vYEohMnQhhBtK1YgogJocPOkhGKiv7TVTF61cveLVUq9P9lEyKMbmhBBys6Twa7ein9tcGBIFHT06+tyRZ7hmKNflx4n+k5UJlIU1UFzfMNiQxrRP+jjR2V425Sh5Thc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 02/33] scsi: Allow passthrough to override what errors to retry
Date:   Wed, 14 Jun 2023 02:16:48 -0500
Message-Id: <20230614071719.6372-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:5:177::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: d3867c94-5565-42ed-9aca-08db6ca767e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHS9zc3/gghEIQNRvvKPSbZeaYp8D7uPoxJ9IIFVejTOC98p3Bpi+LPb0pIrqH9jdR8TY6ZFrcMqIt9toeueZK9zPn57vsVCJ4gL2sQVvJ3yfstxFaCYvX8jEP7eJOLu5OdaGeCtj1Q98nMoC3ppppZU+gciRlUdOlrgcC24CRSh0QepTp8i2L1nd9p0Tz+DdGBZC1Vxgj1NtLwLf8YNg1UljAat8OYBPJl0VOLOneq42le/3GlA7d0WptoIIIZ5+zKGRFGRysZ/V6ibCTITqL6JdreyMU9EowYKK5rJiy0UYZajxnsTv9ctedWWWwJ41OodvLySEw6J03GnS4uoy/r2cq8kV8U0ixXm2fm1L2KgX2iJ4tN7rY65K+n6VMQcGOZ1Cg3h9xrd3xPKG6L0GdlDEapi54Okmn0uHQCtp29wFoiZIc2lCU6E1W3Xkaxaq5Fz2YtJoXl1Vvhw6jsapvW3R2AObkFnsWmdLrspxGkxrrtyG9ZswWx1uyrhRw4sY6OwX5I3BjE4NtV3G41Gcu6hHIN8mYDSLuqS5fNCIpUHobwVDkedSn2z18sDQjqq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XRtKt8XK9oayOAjSscy62VR2u9WSdIYkLpM6BcWyKaI5xRV8NGEdi86ziWy?=
 =?us-ascii?Q?NkkRNgo/dNwOaEzHIRAmLavo0XTWYR6AhgguEeJ3zn9i/hIKFS53u7fiHl/m?=
 =?us-ascii?Q?Txjgzl7Phy+k53BcB3rryaO+RZ16dckFotnSa9K8ehap5rPVTHkThJLU53sy?=
 =?us-ascii?Q?mqDZL+Ml8wY+1Vhx8l7AYxt15oQl7irBJ16Vbe6Kj7GbVGeYnATMSaXAOlTc?=
 =?us-ascii?Q?5saCuHVMfbNTvMTai6FnhT0Xebbcr3ur9bJYL5nX8Y//1PMI6zsxN470ztMB?=
 =?us-ascii?Q?nOxMDogTirf1TwlwvrXZC5MvgJmyWTIiB4+eT78Vdewd8cJgZqPqVhDu3+c9?=
 =?us-ascii?Q?ioMlF7MvF0g0AaUz21zroBVrVxAVBRvI6n0/cct0JG0RBSRo2/XbG6T4P589?=
 =?us-ascii?Q?mfEifT4Ev1vV5mREaW7jIoSoIqKpj/7PIJAtd+tfALH7ab8P96SJtzAPYDu1?=
 =?us-ascii?Q?6aAqcFg+0jgXQTZRUaX0/h37JRWIiW6C/JM8eb/FA2+cjuDo3brLdrblSNGn?=
 =?us-ascii?Q?rBJqneepJqj/v0aEGbjWshxt/+8uQ9o4B68ve33unfxZo1eDVwZmkGlAJQ3i?=
 =?us-ascii?Q?pSeAF9r9X78tjXOd64975pmjlT3Cx9+KyspUHLFyu8sjijRDJVpv/5tyZU41?=
 =?us-ascii?Q?EXrQANpfD1me4WlzJV3ou8Sjw9dCcArt2r9kRzHAw7eAvigObv1mA39uOYgb?=
 =?us-ascii?Q?e85uoTcKRVOs0TaxklaxWft1bTfDPeh9hI8RhR3xKqr7fhYhhY6VY9uHFC4H?=
 =?us-ascii?Q?CG87rnwM9h+QeCzq2GvNuFNhPUZY7oxo7XqxmO/8ORbov0eTw5008rRaQsxm?=
 =?us-ascii?Q?Yc4TmBMYXHFshL6RwOrBn7YlWmab47L2rG0Np4m+vnn3A9NwMmxSqcI1pfCG?=
 =?us-ascii?Q?8+He2s5dJmM6HJjVIPx6tq7Mz0ogIl2h56U8QtMUTktldLUr8HuGbBX1QDQ0?=
 =?us-ascii?Q?iAuExtXmz3brzt2xWQ0+i7bi9msYBiVywLqpoM8soDJ2bhs+QX85DNv0BJ+x?=
 =?us-ascii?Q?H+e1FOEygNmtjYE0m2oG7StsSwy4u2fkUKLzXP9u92FfYSRGNU3wBxolLLQO?=
 =?us-ascii?Q?dIvrBq7/B3LcMEFmQKzkzMAiSfDbFG7RY252bz+hZN1Y7QcLlC2Yotu1faG0?=
 =?us-ascii?Q?1txyWMfUbCUkykhHPgStXhq9pW56ijV6O7HJvqGbL3VoKuiaT3PzFHpMag5Q?=
 =?us-ascii?Q?i1hBm5qxAFs5+VydBNlXEIW2cy0e4P56Bid9FenChKmqXX948G+5TmfYyyoi?=
 =?us-ascii?Q?5darnk0FaAIZmaRUxbL+/0R1DAdu61wThMHRjygLjnZHW5HMfv4JO56UN/C5?=
 =?us-ascii?Q?2d1tkAP5H8/ugpvqTrrkcI2URWZSAPo/XflR/d0zgDIGYNP5sHXdvC7sB3KO?=
 =?us-ascii?Q?PYTG+8jiOOyAkfH9rNJfo4YH7n9S6/S+Q+II5eaW2XRULkA6zF5gVI3Gh0Hg?=
 =?us-ascii?Q?TtHp2SoYkx9kCPs9qx3sfucBSq60f3GgRSAkeJV2YV1OZb4d6n6nFcBS9/Vc?=
 =?us-ascii?Q?VJAvoUYNFtJ4gFbPjhtU9g4uFNVIKWOniZHKw6zMywo4o+be/W2wHrh1dKdK?=
 =?us-ascii?Q?a6iNxkEhr9QWuO1wTjSsnhtRPBuwI4oDNiQmhWyfkJmIcMwqJDUv3BOgz1SM?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wR0iLz4fvFFdcQFpq7jIl/J+k22C4QNx1q3w2Dd/AAceyzIBK12hILm0eJICOH5uMOaTA/WGo2WrxxZy1aEvuYSHQXxIDvRKq1Ni+Ka3WkwUmTCv9P28hw/WiyWiVmg3CCCwYLprTXuy6c2DrAyEhnL/O4NGKmzvp4YdVomAuwipIHbBW54aRN+X7JHcOrdBBsnWrAPzAaHhJzwsSNRl5LIx03l49Lmg1VPbuYtvB4bfiSa7V6T6mqN1luxaHL8tkQpwVG32BZOBBieN+qS9WBoMcMIjXE+evDeMOzq52dx5zyUNcdaUFFfqaRJ3krOuAtKkEOlA/ETPsfjO11EjhgdZ4PStsApmLSVFLgSxoKnRNT0zsrT7BOldZLRs2hfe5NwGoUUGxki69U+JnkOzPLY3HEKV6zGAUAX0aJeLvigRRUwTKgWYG0RV3zDHWzIKxFcWjIc4GtiSOWypxr4O+l+/EE6Xup2iVErGNJkVoLi5JzzUJm+26FoqadNtPfxyaSdIuAsfoWbt1O5rZroXonomj9TIIL6EqL6B9u08MJOLn7tCgbiDL3BtnTC5/jH2TE/6PD5sU0dXFwTzeQYxhIuvN8uYE9PqlW3+3Y83zKlSvgclnBtahqXe/zHnCt/zmyJnV++ExX/MTiOY9TBVZq8M5eMvQaOjbvE/DT00okfyJ4GXT9kBUv+FNjnvkfyAH7A0Klb1azU65Yl6s0j/HISIR/lUXUrHr/h+d6LmSylTUYXivsWkRecBljWVbeCqEnDJarAU6uq8N73wU4o2EdQS/U+OyFDJ7pMNMZq6Ki8oAEhmcNdlgCaOqxwqr1qsGObMBQp6ln88xMPad70FPoGG2+o/k/mmriDT8mWnjFGWBrhcSZcgs1jew+szg7lU
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3867c94-5565-42ed-9aca-08db6ca767e3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:26.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZ6SnXtzPVxiiNvXaDUJ7anmXbU8BuQcgSnNE13wpMrfriune2DrZRNqG652tkbanTW/zyDQW3814YSJ+ITbuVKa0Ba7CnEzVk016XilM6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: L8IshMHOhd4xp3Qyy4s_rLdFxjSrrzH5
X-Proofpoint-GUID: L8IshMHOhd4xp3Qyy4s_rLdFxjSrrzH5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough, we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for those types
of errors and retrying all errors, and there has been a request to retry
specific host byte errors.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   | 10 +++++
 include/scsi/scsi_cmnd.h  | 20 ++++++++++
 3 files changed, 110 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c3eccbdd39f..d2fb28212880 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1872,6 +1872,80 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should examine the command
+ *	status because the passthrough user wanted the default error processing.
+ *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
+ *	command should be completed, go through the error handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+
+	if (!scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (failure = scmd->failures; failure->result; failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		ret = scsi_start_sense_processing(scmd, &sshdr);
+		if (ret == NEEDS_RETRY)
+			goto maybe_retry;
+		else if (ret != SUCCESS)
+			return ret;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1900,6 +1974,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (scmd->result && blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d32f1014465f..53cb649b2f28 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,15 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failure *failures)
+{
+	struct scsi_failure *failure;
+
+	for (failure = failures; failure->result; failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -1129,6 +1138,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 526def14e7fb..9a3908614dc9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,6 +71,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+#define SCMD_FAILURE_STAT_ANY	0xff
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	s8 allowed;
+	s8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -91,6 +108,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -394,5 +413,6 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
+void scsi_reset_failures(struct scsi_failure *failures);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.25.1

