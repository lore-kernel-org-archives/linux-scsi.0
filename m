Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61039C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbiCHAlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiCHAlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:41:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A79F3C736
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:40:19 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LJDms009309;
        Tue, 8 Mar 2022 00:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MGiJam2DnM6U9MaBab+hw6LnBnRa1R54D8W29l/uEDA=;
 b=XW620OLOnT0sMyYaV1nP9dQofwLc6nnDRN9JPzSk6PmRbGxA6ZXrmxtjcKgy3l0nw3Oo
 zQHpmADJz8udmtdEnXL8+n/FpMGxybBAQVW6y3O/LWjcJo4PROPEjiaNfqzTgmQ3KN0/
 F/Hxi9+jWc5lup3RLV2MiFvuEDQ8iUb2zcpUOHT0W3dHC4GssZXABJV7f5xFfuUuoN1F
 j6L4lzPuAS5eoM0bCXIvtx2hYRtHBcSZmYb/NeuMSvsuizyQUcwvNVpTvabRVcgJ7TjU
 GvGBNuYkoN3ZRan09s8pW0uQfdbS/3jj0TBfiwnV09uC5AIPWaNqNLdhDjIQBMz6Dwjd vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdft0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280alEB119127;
        Tue, 8 Mar 2022 00:40:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3em1ajmyke-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXl1QrmLgl+9+UbcxmtadWmOaROCEDRYaOxCBKVLJS0/9zoJCNe0M9nHTnRSgXWAMc7f/W1w0gL2JBcChIhLaqs2ua4wCD4Oxmmrl+4kQVfJhLUmdqIkKhrcKbH9gNVVNUhgMMv9iTBD8e8WEVzcVvMRVNlfAx0yw93YxbXupwFXQITtqce15kxg8RHmA9IYpXVm6709sp8cTurInX/+RzatVv1I0xELAFCSBUwBSok3z1V0SGb0UgmQlGuen+HYzVgEqp7qwyw6WYk2RauHKW9toFU5D88Asb0D3oIylVMRRq2TSoDCh9iJISwWw/SQIJNwbeRl87mCF/GdSl3miA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGiJam2DnM6U9MaBab+hw6LnBnRa1R54D8W29l/uEDA=;
 b=nnJVicTy/zBiBEAO4dYDZTnWkPngdQWmUDhoUNLInPu9HUfM5Tiv5c48fvvDGkzfMfdWZGLzbM6xx+r4Z/TfG+QyYf1ZeR3OrI740YXTmjVUZ+NgnR0BL+F0w/gUem+orVByfYtNy4lmtKKJW9z0kFv57479BvtX/la9WFR3gn9VmuvrQvYg3UlDNrD+0q2WvpdkQsbdT8xJDq8/jueD5eZLbAQCAOwU9sTRDx/Q1YtTejhlVTk6qJTCLd8FzvuXveDUOkEFfcBjx3iKyCez2dezFn+fX0SVA+B4Do8EWUsQ8qx0SjDHG8q40owPMZFcAWL1qe0//KeYKsVI5kNKOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGiJam2DnM6U9MaBab+hw6LnBnRa1R54D8W29l/uEDA=;
 b=Wg3dDXWB1Nf5nR4E1Wqlva36e9DolQr4aYvDpFfWItrhk+4hMCG1PYC4FiypHvbLc9mxzsYdaKkcL3SSEcGyvkj7butACTXc437YNAu16oXqDukOjTlxC9kWBEo/PtojgrrClCv4dj+AcxXYySWtxXA0o1PrCnaYYMfdVMoS6Do=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 MN2PR10MB3680.namprd10.prod.outlook.com (20.179.98.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:40:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:40:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Date:   Mon,  7 Mar 2022 18:39:54 -0600
Message-Id: <20220308003957.123312-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308003957.123312-1-michael.christie@oracle.com>
References: <20220308003957.123312-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:40::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f47aafe5-c2a0-4566-8a5d-08da009c3079
X-MS-TrafficTypeDiagnostic: MN2PR10MB3680:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB36809B935493B703B853D5F6F1099@MN2PR10MB3680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/GuVeVeDraG0jQh8Emfn4ndyR5LGfx1cKdvmtrmlkt9h2oZgh9Pmd2IEkz5h+DGE5yctUXgn9XTXetBnik6mVKcO7DGuBy64AkxZAZ+4KxurbneM4VYu76aHRs+pgh/KR20XL8EsOR1+V1Ic9T2Fh3ZG7W7u8zNriYyVbMPbruL7RqoMwyoOF33YNkokMy7GKhexCdkS7X5N3Eu8ndSxqPPBgJ4i38yrgtA7fhoeuoeSPP1EqmPW8wway5vv88n4QsQTSUcn0HJlJ7uSSSiglZmdKhRtsXjfvyd9VtyH7cQObF7W70ah+9SJPq/slB9vtfThagsgBgGmYieAsIIHhsYJ2ngaY/REfjAQEtlyjwcnPAtd2+TNDRhMgOoFYtBdDI1V+B9k5VSnNNbWwcOMoHev5dbC1eaJ1fTFjH2GtKTZs+pVsjFlhhIVbiow2QmHZ4G0GsaatPHCbqM2HVfU/vzI4mY8ehz7XzIBmQMMkv45f9eWpTYBtwlpArwOI+V8RiMz63p9/6tIzkr8W0NtBnIVXp4rLiyfPll4Nr8BiUrKYq8aSplxH3yPtdzK/WvsY8TQEluAvlD/mNgyRPx+AAzCPpWkUTZzz0fmvb8MvuCMf9cMlRJeMRrMOzQoPkKkeXjWvS0Kq1IM2ennmT30A+VDRqq+EM/IR2RLiG3tY2g0vdJxG0d1pkYBOA7w/egrOk8A1CX0PwiopyEVc5AHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(6506007)(52116002)(86362001)(8936002)(66556008)(6666004)(8676002)(66946007)(6486002)(6512007)(107886003)(1076003)(2906002)(26005)(186003)(4326008)(66476007)(38100700002)(38350700002)(316002)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rQ/sPnGiZT9AbxxRxMCv+znG2Y5GIBwE2nr5fzY+4LtaqqJOmyH9QoaUIiM5?=
 =?us-ascii?Q?oodyQ+mHKMC7EOEZ4lQ3q4BV74sJtNxN79Pe8vwjAw3Q2jlnK3gAOr6WqLcV?=
 =?us-ascii?Q?taw+DR/PSiIDUo02TgAROoZjBBKK7F/pFr2XZCE1XtRtqLHwJ8rSQ4vy2xzT?=
 =?us-ascii?Q?cb6F2zUR3jYy9cGIWO2P+/7uFoD3uIqVkA6k89eoWnIqNxRUb43hGBnJVPMI?=
 =?us-ascii?Q?4J65cHJxei4a2mRzPXiLKfOmK8lNwX0aeQTSVqnxr6DFlNVDFjGCr1IlUzZp?=
 =?us-ascii?Q?Yh6lLgjRFj8AaGUA2FmnBxQ1KW8Rn2lMaKFHmUaOYeQF1aeeywATVWubGPgL?=
 =?us-ascii?Q?7Eq/J4Mgnhl2xNT2rGgroADgANQAWEi0lxUMHbveOMNVRX376uDi2nTSf2WM?=
 =?us-ascii?Q?rTCVBzU/Br6Y5WvRtDwU3ceWFoKnQ7MzL9sMc2+YpAljijEAES+KCwmSghO/?=
 =?us-ascii?Q?R4GPdPIl1qgQU1de8nezxj7pgQUJuunsj8QADrpi7wxUAkfTcDrhEUwoXU3V?=
 =?us-ascii?Q?YINDCKM2vmKZNK9N3iZrvy6aIjOuRkQqypuVmvmSmwrAcq7abSMxlgbkvV12?=
 =?us-ascii?Q?Xk43jiG3C8UEgn4zwZHnrtL5vwj7UKj2xfNDup6hn5bRmiIc2Uq8ODOVrdPI?=
 =?us-ascii?Q?ovc5+fU2ii46qWUFPjFgBDmM1T3DmQ7bapg/avllBcETS39nnnWYOXdlIs2C?=
 =?us-ascii?Q?v/6u2PXLfTDggK78Ah9OLrj6zkc7j4TvzXFcUmnlxgMBRGplKuFgJCTuxvMc?=
 =?us-ascii?Q?s7ADEaCQ6fsLrV/1jX6W/akTrurSJdh6+PZG3dNGzQ5TzYiq1HN0OyTBtnKD?=
 =?us-ascii?Q?IcFmeU2IuiL47mooX2hehTelsX5SpP/edi4+6nusR6jafzmCZei2Kj9IJz3k?=
 =?us-ascii?Q?YpeIBA8imYCmrybr7WTXwS39lGfSdudYGH++p0r4OVl/vUWNIlIiWuJ5+Zz9?=
 =?us-ascii?Q?jJO6a0qsoKVTciKNrK6IWgK8kogp/7mYbCaYNHzigWobkgg1GGjdcHliOmzr?=
 =?us-ascii?Q?7U36i3K7CsulGfuGt8fPQzl0q4LjSch0T8XYi1ypI8pVveGscVzexzkl53dt?=
 =?us-ascii?Q?sCgOi78C7g7koWlhrJ9LqlFpdw901qyEAJRiIRYuXquellW9NSa33l/cPm6N?=
 =?us-ascii?Q?G9N0s+/Ws/7l8vIxwuQ4s2/uwUb+r31Di+p71+Q5YnxPt9zIlBKUhKKjLmn7?=
 =?us-ascii?Q?jJWu113XqcKTDD+vi4kRm/0t0wZfc++2BkjnTkF3fYFjs344kNrv/nF5uEt9?=
 =?us-ascii?Q?ozot9v358Uw51ReCg5nGth2N3P7U5+nzk61KTGHgLFFF/yETohUsivugPww1?=
 =?us-ascii?Q?iGu+RLEauzeHjBpOeSKuMslfU1fbyO5q8aTSVh1ytfyG92+O2SdzM82ho/vw?=
 =?us-ascii?Q?f6pWWbDPzGYxVtZ7gB1Ab96JoH5TD61X1NnMBqqbkqO2R2ewbeVLtf+89ZGE?=
 =?us-ascii?Q?GvSDpKCF1bKAGlgAT6uoqmaKtTf0LqjYyyxu8ytAFFx+ISljnvCqUXzUkvU0?=
 =?us-ascii?Q?C6BNgl+N5gmBvRz6cN0UAYEIf5LB3kDi61Yxwknbjg1SVpcFZTO/9rKWWOqn?=
 =?us-ascii?Q?5BDWVm6CUrdVVShjAaJDDkEzSKCRs/Y4Ytyv2L900w6JWkTWMytHnkRGwgP3?=
 =?us-ascii?Q?Grw//YD9VfN51xKsdwEoE5sUmllDiGXSYjR1hTWm3g8Wn3AWpj+8CMrrGkS8?=
 =?us-ascii?Q?OmKzow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47aafe5-c2a0-4566-8a5d-08da009c3079
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:40:05.6391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 98EiPT/ZNCTGZYpwtetL7PyRNYbMn7V2eFMkYwAtdn4J3a/mrVaHu8pOSGuCpAEUTYJlLakVNkK8sCxaWzVemZEQfECC/HVbospXPe/khRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=942 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080000
X-Proofpoint-ORIG-GUID: zgEMjOsFanlL6E9TVDMWT44DtCNSq2aR
X-Proofpoint-GUID: zgEMjOsFanlL6E9TVDMWT44DtCNSq2aR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The software iscsi driver's queuecommand can block and taking the extra
hop from kblockd to its workqueue results in a performance hit. Allowing
it to set BLK_MQ_F_BLOCKING and transmit from that context directly
results in a 20-30% improvement in IOPs for workloads like:

fio --filename=/dev/sdb --direct=1 --rw=randrw --bs=4k --ioengine=libaio
--iodepth=128  --numjobs=1

and for all write workloads.

when using the none scheduler and the app and iscsi bound to the same
CPUs. Throughput tests show similar gains.

This patch adds a new scsi_host_template field so drivers can tell scsi-ml
that they can block so scsi-ml can setup the tag set with the
BLK_MQ_F_BLOCKING flag.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c  | 6 ++++--
 include/scsi/scsi_host.h | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a70aa763a96..a5dbeb9994ae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1989,6 +1989,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->driver_data = shost;
 	if (shost->host_tagset)
 		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
+	if (shost->hostt->queuecommand_blocks)
+		tag_set->flags |= BLK_MQ_F_BLOCKING;
 
 	return blk_mq_alloc_tag_set(tag_set);
 }
@@ -2952,8 +2954,8 @@ scsi_host_block(struct Scsi_Host *shost)
 	}
 
 	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
+	 * Drivers that use this helper enable blk-mq's BLK_MQ_F_BLOCKING flag
+	 * so calling synchronize_rcu() once is enough.
 	 */
 	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 72e1a347baa6..0d106dc9309d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -75,6 +75,10 @@ struct scsi_host_template {
 	 */
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
 
+	/*
+	 * Set To true if the queuecommand function can block.
+	 */
+	bool queuecommand_blocks;
 	/*
 	 * The commit_rqs function is used to trigger a hardware
 	 * doorbell after some requests have been queued with
-- 
2.25.1

