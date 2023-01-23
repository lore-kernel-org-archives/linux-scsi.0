Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77148C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjAWWPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbjAWWOn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CBA392B0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:14:05 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi2FA022478;
        Mon, 23 Jan 2023 22:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=RwXppX8pb+G51XPAbPzFU86sUL4Ih00edQ16NAZDhAk=;
 b=seZHqNHlGLHVueI5FCZKS5ePfb4L1EoxdKRZqkzVy4P1mrAaM7fcgk5a6KiSilFq2TQP
 swLxHErYH+871FawylCclOfUB5KTclYv/sGbfGlClNh/HP2QrDLENKns1IEMh0WVa8jP
 slDCJAuUT5LAeW60barcynaDvJdnDI5IeSNdCXZGTgPcZNNQyexKvNub+fx3JytZc37D
 hPxgSVkbZ7dXYlz/MSF/c2dkHRRRH7CYH9HDcMSsAqXA5wtjqqqTncm3yeJzaer8DHZB
 aOBqLIiTDLH2U7CmvRmX0BbYAb2DyA1IEiAh998ULoXOas97FvklqSmV1do8NcWW1gYK /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa41a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLXtNr011704;
        Mon, 23 Jan 2023 22:11:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3ndqs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2g7bdfEki8yyX+JPWnuNg9blzQybx+nsoSN93RsFd8cdXd0o6zN0l8uAxBhT9xrtZmXh3yZePInZENIqSdMm0g7PVyZkev4efViZvqUbAcwT+3K21O3cXGNhsgxqoxM0UnjaPNlvvgRVgw9PJDsa7fB7n56e4DeMkizNu8+gHMdnBP9u9L3L6DGlJwy5MHMlvsNIbmvdA7/JtimYrWs3yOswkZMqpvLbv1KX+HKIu8Kfvb8bqD09/WD2kcem6ybkpnVZI8SGDR+r4QMbZkjG7EDofsHJZwHhH6c3pz32OoOVdsm1x8UHJSQ1IEtzmZK7/Gw0YDJZsgpSFNjaU3oXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwXppX8pb+G51XPAbPzFU86sUL4Ih00edQ16NAZDhAk=;
 b=L2G76pjCy1fPN5MTYVzb/uoSMljk4teA5v/vsHkvjgA/vEnRYO7GLkWCn72cM+EhHkMQ4tjQYwksZrqK1wckQrbEa5S6zwmgaDCzcpTqY1S8kSFe7aZaEyRJfXfqYT33vSF9HTjUP40KbnBCCMztzSpV68qvrtGq+3KpupFXFRvsxQcYL+KngNYTbNoAaHbjqErch4D/mNDTfuzwKUG/GrwZQDFe3wUvj/nkhkDzUnaJFwpJi1j1CItoo7QrAT9awJSP+vaolXD91zCGuxTUntiGymFb8aqWfwvR6WYRDcdzQ1r/tqv3qmUkF+NaC2wqxC9oqojunRzBtf4pEc7lJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwXppX8pb+G51XPAbPzFU86sUL4Ih00edQ16NAZDhAk=;
 b=aou0WHiqk/NvP8YpKZ6bsfasgRThR51DsU84IGw51pUYz1e0Nae7spJqm3ZnogVDXcMmD9XpfV385VNQ+zYwar8bjJKucA5WUz6VjO/wQbMAVipoAZjJ8xNNlNiF67FH851Fym7R1S4ybDxDxKXTb9yq5gTA7RwAORCFxfqqaac=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 22/22] scsi: Add kunit tests for scsi_check_passthrough
Date:   Mon, 23 Jan 2023 16:10:46 -0600
Message-Id: <20230123221046.125483-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:5:333::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: e55bee44-3741-405f-d85b-08dafd8ec368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORTblCqP64oayOzkUhQ9/HhgG5HO8avdzVHCAUvQVOI62KQSt9Mu3NY1ZVRQQoc8N6dvvK3WdYsJSxFafG/R3Sne1f2p5vnVE8WWt0Vf100S1hDj0R9YR5a/RyTHmai43AoRKAcXZoukiqo33p6nR/bCHVZ6qJZCdmm3gSM+MyTbGGbCZ4R4G2zPH2GP6yP7addYFQqhAkgRzTmNZCARk7JL5jRHZoAHnW9NC3q/KbH9YkuYSAexKdPc+F7Yn1xsJZGu88x6/F9CN1Ghh1HnfQhlHlDe6yia+95c/U5G2utcO+OBO1zGWQa8kSUT8dXB61uM9PllnrR2C3Ajdfm39jTimA7O5Xt6xfhhvDgvhJyRCDuG7SA7W8qENdBOqE3HmBA3HOoFY34X5qiWsZTQHCrKYx0yftT46DSR570vtLBRulDwjzfg/+bTLgyLDBHUExVnUR1RYc8WS7RcDPF0cwkHb1VWIxeKe2X/ZHTHQtWLUlTSDRnLAG0Ciz69ADiESQKBW6EP+oQ10GAGIWt8JC5wdYbkUqEU65I8EEDwSLxvPbwO8Qav7G0Y107nhwfieC+VD39dpT3sezE/V4sjxfdAQcBaelrBjhIcuGFOt1XYCf8jLvQ1++QJI9wZTDrh3rgHPSKp2CfZwzQbKV/hzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7YHIRUV+SfsLbWFNlkCJMl4yMY4C2lfE21+NyWC5/u/omQanLUMI6QgfrRri?=
 =?us-ascii?Q?AOvWh81wZjEdM+lRgbW9JjZ1A14UrxVz3LRt95aviWsdL+ngxXhgfswNK6Mq?=
 =?us-ascii?Q?7YX9yC1mb9AEvF/KwcwdVB+QOdvVQQKNZr7Qro2VF97UCIF8UVcfyfbCcfls?=
 =?us-ascii?Q?QLqB2E5F1HlzBgwWnGKpfPIY0kbNPg7KrG7PN+M/TJ/2i81goyI0P1jnjIde?=
 =?us-ascii?Q?r5uSB1Y5cau5lW8ADfVC40tLv0zf5GWDiH4Dyzgm0KZPlFbpjumfwp8fNIJZ?=
 =?us-ascii?Q?CfO2+Cs3zZU3ewzsgZ854ZX1wf2ctnVlRsN0TSmOVxH8fnmmOL0cXF98K8YQ?=
 =?us-ascii?Q?oGZ+MDelHLxzGTFaxPiUhPtdy/+EkiUjtNSkXDmVBfOcTyHcLUDi0Ixv1iJ/?=
 =?us-ascii?Q?Vdv4odEMEDaXtykwutwyKOVPMsmb03kx65jcGBeszqAXQ+bBIGni5UqF+4fS?=
 =?us-ascii?Q?8cmpVbouTSpvJDZsR6fTr8YvHCzOwx/auazHwHzXiay8RjcpFWVRcimEx14p?=
 =?us-ascii?Q?tLUEQqeIbddjnM62KIMo/4zFAEY6HKuC/O/gJDYTkdtsStFqrtlDOyZiBNal?=
 =?us-ascii?Q?5Ts0zZy/QNb084mDybxbEZ01NNMKrWuPyD8qglA2DitN2XbAmqbbqaAnEnNG?=
 =?us-ascii?Q?2JHpVBTiTDo8bga9fNBzqZSvNiM5EBobV5PLm2efj2r/cOCjFEBe+/S9GDxh?=
 =?us-ascii?Q?Tl0s53t5/XXYu1u2kR1sTgb3/xwU8FBoFzckKE/EqGR+p7kGc/5br0nyEDXj?=
 =?us-ascii?Q?zoEQ07Nvn9PPLJsRHRxHbIv9MRGPvwxSdllDmn5B0bt4RLcqaK9pR0xWvVMQ?=
 =?us-ascii?Q?3UJlZXFXlDQcV1nytbWFmKDnFkL7QliNgV50AMS82xkSH2i/OugrLLIpoKB1?=
 =?us-ascii?Q?9rP/8HQ5n4lVCwBQXRf1H2of6sC+SghXgWIV7PD1pNbXn/5CplhI65ApKMVO?=
 =?us-ascii?Q?OHSnJIA8j4/vtvRx+U3/3lIYQFbnOQYhU5dDNzagcq9e+dPFwpM0nrTMfDVM?=
 =?us-ascii?Q?IM4FmsIrZFkKS66ckVu5FJ1KSd4emEt7GkBI4m/CzmNfTIfRLKl6lAClPC3L?=
 =?us-ascii?Q?v36O0CvBN2AekWuEU/AJS4uKrkiuinYs9CnIg0VmkryyPYa5kqX1OzL6TPEc?=
 =?us-ascii?Q?YPA6kmYe6gzsxgUm7KRoKkfwQb8NX2dzPp4aZL6IZsa5cH89sTTxp2joe+KA?=
 =?us-ascii?Q?t++DzvwGGNEs8ojdGahkFswyZEA9G194ml9/hF9zSmxXttoq8vRY4wm10wQz?=
 =?us-ascii?Q?SQwb52NEwb7qlSWavWBW58y00HnVwdEA6Xb0r86S/CKhGht8ZPwCg8misTOz?=
 =?us-ascii?Q?t0mNMpMnGEkQcSFINDh+GcZVSTcDyKBCEqd1wTm0xJFIIWpqW8uZXBpkzWeB?=
 =?us-ascii?Q?b1q/2fkxtOdKPYoh6t0Ivh4VnWT4zOwfABf7PSMpt2JCxoiGLbxZ+ITxwvNG?=
 =?us-ascii?Q?wie/yJBy/cTViMdxT4wycEyE27UvIFouRgfXplFSt97vJHu//9kx5oaAdgFb?=
 =?us-ascii?Q?CQMpsumxGF+t40HkEu1s7LcduntMEiui4ZFzWxwLKYffmVwuewi/YpeOw40g?=
 =?us-ascii?Q?wOYaKxot1ZEBc+DgoqmpZflX1YnDraFHwu0wuvFdrJ5awsz7bvsHDSHz+ayk?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oWr7GyNe7t2jhDkN8fgX6ltgJXTubwSF2onW2gq6XxAXqqWULdbk5zfGJrk/aYvcARCjiXrTJv/nNq9bOVvLnrtmUaFuCdx1fNYQkdMOMyxpkUcoUb5SfYEhpqcAAKI1whwsnp5+GjZI/7VyOxPreRIgZ2QlotvekSrpiz6Ry9U5hxiFRK8TGS7dNix6SgHTrb1wWhQlJOeKGItZ6MSbjLihkZIXWr2WmohWkQ1rmfycf5t2j87SkYWVgiD4+TSSloREOixcfLry2cTtZlpu2P5IRbQx0LrM/RHCIGjJgb8mtiKaz0oNe7YfWt7Ye/KV47iRy8Yxb0WozDMY1lfHKiq068zUlA/clKrLqe1DfwfZVOx9ZtIOuhWEKFzLW09YzIKxpzK8ciL98kuUy7Kih4REj2HL9K15pT5ibsDQwD/VyH09ichm91ATicEwvtdQY3G8lEg4af6V/eVCbHzcj8FP4eEa9Ezs0eZczoEknOCtoI34isRZa0S1ZFUkzkxqkMNrRhPX98VOxqzHyvUd02dA2m8LNIvNQUY4yQtcOy5eCEePjLBmZ5aioxY8/oONIMdUlTOMYPU9WJPagK0mKKZwrNEXk/CnENjRX+9ssVhB4ITwE5LLWLRu3LgEJclZ50vfYCsuAl4oPzXh7k3b3XF1N/V7GRhAxpHYzCPYDhwv83MnCyVcPDthviQvGx8HvuOp96sxDzrv+u1+160uiRI4IJ5TEK3aKm0S8Te8PjbzRNuz7/IhuBLH8r8X/636ZN5K38dgQAAnczLeqrPQedWGMPtwjxGhjp/SHyG4A3a+eNhRm2aJSk5tbKV7jKQahOvyKG9ToYfo3KDgWZMz4kFOKbpEhjvy6smPFmbIPFhCpkVRw357MQQ+s9yOdf6x
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55bee44-3741-405f-d85b-08dafd8ec368
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:23.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rizWk7mc2LoBXF7/gRstFAVSqT0ytqFdJ1hM7HpuHW8IEvVYcVLu/9P/6lP+oDhSe4q0GYJLqEfOzkGBjN3FICzA/jOXFzllzoBIHcsKFdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: MFKioB9dWbgmdGz4HMx80bDxjRrkmhXU
X-Proofpoint-ORIG-GUID: MFKioB9dWbgmdGz4HMx80bDxjRrkmhXU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig           |   9 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 170 +++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 03e71e3d5e5b..52147a848824 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 544bd97bbf3f..b8c3a236c524 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2612,3 +2612,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#if defined(CONFIG_SCSI_KUNIT_TEST)
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..951fec0fdeb8
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_error.c.
+ *
+ * Copyright (C) 2022, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SCSI_TEST_ERROR_MAX_ALLOWED 3
+
+static void scsi_test_error_check_passthough(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failures[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	struct scsi_failure retryable_host_failures[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+		.failures = multiple_sense_failures,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* reset retries so we can retest */
+	scsi_reset_failures(multiple_sense_failures);
+
+	/* Test no retries allowed */
+	sc.failures = multiple_sense_failures;
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* No matching host byte entry */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any status handling */
+	sc.failures = any_status_failures;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+}
+
+static struct kunit_case scsi_test_error_cases[] = {
+	KUNIT_CASE(scsi_test_error_check_passthough),
+	{},
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.25.1

