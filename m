Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4D1EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjGNVfB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjGNVe7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:34:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965E43586
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:34:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4UYa005192;
        Fri, 14 Jul 2023 21:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=YtB+DpuHEP1lKVSRTskFyZHtppHDePHbZdA/cDNlYt12woDCfKNSZGITqQHTeuD3y2vz
 1F5E98t5cjxt0iLzQOXck3YXWWM7M6wDRKxm01qlWHBsXd9ID26FwyXWDxDos1QCIlIo
 Jcn9DeDKjnYCEAShvvWBG7kYcFo+YrOyU2/850Xc9AE1gR8/lonfLIwwi32WdvAS/Eal
 WH4G4F4zq4ex5pKO9M3TCxIQrAGDXeAlbCEdLAmGMLBxap5fKYKQC3mbS5suRLbN+X51
 YswtuPYAXFjNHKpLQ2FevftCaft71T+oQ/pj4FcBnSbbQbczRN01QExnhIS6xJktuQVA Fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptn2d0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK6HF1027202;
        Fri, 14 Jul 2023 21:34:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvyh6t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lv/tAnxx3v9dTfK8ouBsCZsBePBcrRtBwlZEgocL/2PGFnsf3/5GLtF9O3bWQ4a1qb7ojOn3GctUHMuzH8BMDFrCshRuNMa+vnqi54ALq4H3KYDueKi70obXM6SeUcnkvmcX25/BhQs7XmQoJw2woPsW1DHyOw06mxBVzn/o4Acqvv3KXK+6i/7rvsMuskUNESkihEUPS06IzsGxSUh7kR/LjIN0h7zDkjtFCpguZMaZChgrkdLU9LoSFkMUJ5p4h6rTcxCuvlUXKrIcGWgtmyJcS06ANos++3RwI18xMhuga632Y6syfzJHFFBYLnUTHW1ogzlwiyyczAxhW0QwWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=P+N2mJpsblsevlTtJIyXj0tJCY6P/ItulaKXSuFdhJwudOZTHp8q/1iA2vEKSboPByuQJ1Kmx540+odvBfsnINvLw80w8/BTxjMifxQ1D2+vaiX5VRXRqCTmhvYi4MFWf5RtYrRJEPSQxkEUkPcvScXSaaQNEI2DmU2PUjJfnlJl368IRY0PXgN2LEXTY9h+YfV596G/9N1n9kFhA3SvautGttVQtFm96/KM4SlnQSidNSZ+B1KpNfIKwg2rHN+xMuL/yh6A6N0Q96htLSqdIbIAYfOolsW07O2bLIq3aZFEd/9kW+YahSUdEmjRHFuU+La2qownFv7Bka4jbesXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGDOzxotRQrQtlmfpOl5xsft5tbEQR0IyjIeqYnTkzg=;
 b=l228RO9OR2Qx0fIDcxIT/vlgR1eM4225f9cEk9m/JqGnDu8jV7ck3Jsj/B522Nk/GQKpNK/FzAnlbDOWqWLTgCr1s9e674Ki5zBAmGf3739rFI9gR0CR3Xbeqtjlumwx0jO7fEfo4maicG7b2hvLhGOZUZ6RlDkILnnFsMJVDpQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
Date:   Fri, 14 Jul 2023 16:33:59 -0500
Message-Id: <20230714213419.95492-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:5:80::47) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: f6cbf681-d008-447a-95e4-08db84b223fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZ6evMETkANPK8Az9iuFvZi99qDFrHAbHrhCDYzPHCvHm7u/HylOCHVE7vDZopLfrzCQsvHXzCU+YpfEyTneZ0sN3u9CX1e98gHwRzxrowjGOwuBxKe12aca+/xHojyxpGMKYLFMlmD6/03XDHDxSyOgZe3QhBiZIsABQdVud30DtyMVbzwXHTKyHBmjKEKBqzZBi3Ir57J1jin++iiMp48R4qA3NW0jL6SJ7n3wk0Stl7U7lUCZ48rX5wUiGtEojuVkD9WGSplFoTcnswW/DP6bzcrKhHL8gAuAZZiG2ZwqhqL6+ksLfbq9Q0KqgRSnCRrNAKKPOB2yA0ZjW2zK0YSVzG/0xo71DTXXzqJz1jzRmnSLDDIBKIHbMHNNya0uIghsi7Fcjic6+GCsyMuWms0Iko9Vb1ILv+GkzM8O98+DLFxuGmGuKehiGcbmSuTuWA/LIY2wJoUnWZE+hX8IERAaR9BgHHjX3C+Ek5kfqKIHt4d6XAZEbVziD1UVIOkCJIwUfcRzjsfhXVccz/fm9Fs48GByd16MHHuWD3Xwkb3TYooRwyFMWPKom+K1nq3E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O5UvarQadRwv7gdMbFWyf7B4vChvXbHlPeJXGvYSscfK/lnXEkh2mLDie+kC?=
 =?us-ascii?Q?zx6W4AwL9cqvhHkoqJqV+wmCXZCVjSoOt5uyyz6Zrxishm06JRdnOv+N8SWH?=
 =?us-ascii?Q?1ehJICnIH2W8vJYGwxmC579DmucjUFbiHqFNv92nyD3e1XNe6zxbrx/stTL1?=
 =?us-ascii?Q?TIiLzHJtL/N1A3AZ4EvmDQ6BAo9oJ/XO7b29IZWzPxeLeCGdEX+ycBerSPkj?=
 =?us-ascii?Q?adcBU/PKnvAiH5tzjqTUuiiVIRnWxf4b1Rhjwg8YHWV3G7c101LfSL4dtIgg?=
 =?us-ascii?Q?FF2vuc/hR17FGuXb2f+0dUGK4F/d8A2zWB/M9Qt3syz+sdbhlDk9raY+m+5q?=
 =?us-ascii?Q?/Hk1tnTChY9Cfk/9unEqLY6Gc8IaGSewKKvOsbL3oE0yxKrYt0/Ves69RyQJ?=
 =?us-ascii?Q?AEY4wY7ZN3n4T/HYxlrkriBCnRF/QCZybgDAfOl364JOeHs7ba5k2zkhgiuv?=
 =?us-ascii?Q?UHIsYslg6U3VP+1lD/rut7hizXrNddfR1ACplELY2iO49GU+36XiTNx0xoNJ?=
 =?us-ascii?Q?nGrzM2PI2zR8auttcIgfDgFMFfZK6yChGp+q5rXWsS3spdzH9DxA/PEcvYa0?=
 =?us-ascii?Q?lxuPorpo28Z/Ab3Tfu2hcpFepGhjRxDEFb6RsT2phifNwPWmizRAnjj7Srvw?=
 =?us-ascii?Q?gA8rqAiGELI1OKdtpMj2sLOVX/zIVKj0Fe85rmrTAnwjIFTmoBTpgfe/JXUS?=
 =?us-ascii?Q?UXHV5dFJAS6uYPwzSIsM+XZh9qJq3IkLIO7mMSdoGT46Ufzu53xcCO3OP8AI?=
 =?us-ascii?Q?LxmWGrJLqlTKbxbCt8Elkg9sh8QwgzdBDILSSi05S+EgdtgUnfiC2wZv6hze?=
 =?us-ascii?Q?3OpLtofmxdjNv9V6jEActLaWGjt7xEUmxRlQ414gzJYICo9JgAV4Q4obkkYg?=
 =?us-ascii?Q?/fr4fZor6youLUHOfCrouGCs6d5e4IixvDZNrcd2gPqUnOMylKZ8J6rB/Y+f?=
 =?us-ascii?Q?1KY907LBvTqpyNBCLvRzRZJjoRczJm4m3bvhFA+MlrTvYVdRXeLR7/5ufjFu?=
 =?us-ascii?Q?gb33XFsMRCBHvHysmzgfmyivXN+5RREKuQvft5GMA+WKn5RqfBtzf7sGRRi5?=
 =?us-ascii?Q?HbtzRrPGLiZC9fNDp/ySRx2eFcZaLrILEAIl6bK/NEsQbvGeMc1LfiD6+KkD?=
 =?us-ascii?Q?qJyt7tsfXfjq27kiDWQmFm3C+PtBKGkmRzjytxTmcz4WX7AQucUAojWbbaFd?=
 =?us-ascii?Q?gWuil3CNXs/E/9DADAuGlFIFwt2wua04oeU+Hop0vxeR0cYe5D5HmbvjYWAV?=
 =?us-ascii?Q?obx0P4uRtKZEUg09NZF/NPd/VE+N2PDY3SliYxaxnI0NcbB4sIx48Q7Nc8fm?=
 =?us-ascii?Q?BTpef9wMbF+IFnZ2fw2V4RU/Ryn2GREtcuxB1QVkQWFNL6gvUntZKWLOWx9C?=
 =?us-ascii?Q?Jkmu+DuCtCBKQSW+svMmpyYzgS1uzSUcSBH/1h8rAuxW1goj8Y8VZaeVCg3i?=
 =?us-ascii?Q?7sm7fE/CLOth/fmfnV96aPF9Sp2DU9mZwW7uXAXgTTnr8BfS5yXJRMjoeax+?=
 =?us-ascii?Q?MC2a58eLwd+IHvQ8v9jTBsrPZFcKAlnc2UcgCqODeTXing2HNEYGubOvPtlf?=
 =?us-ascii?Q?ZtYKg+X2xhZxxivboOC2UufN6PPKO86MnjKO5TNYbnk1ur+f6cbxgp70zEXN?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: t7FCqVrdqkHSZ3wQIvDJviPXZ5pCICBedeF0awsYoaRnAKvNmo+vKcucTCfO4lJf1DoafpRg0rzoZreH27p0160gs3cnRq6+qg4FrjKRaBQaQJtcypmIzwd+6HXaoRx16xwoTPnnAYeTdrqtzjT/fqkLFijX3nVOD7NkvcQt7PihRTT5eu04WxSG5eKdZ9zy+upwgQ8aRWrtjUZm1weCV6VHkaMJMg9st4740GkhJ0zPqHhar+LPvxwjKEvb1JOrePu3CKWINutobPsZGiyms79SB5L0Ed+htY8H3BtLDhC+6rW9m7Zm3Jp+uzN/ODQA+eKrZH+qa6DQTExIRARvp2rbV/PaJclYpEWg3vknQsooxRr1rbFwq57vOH6PnPnMdvw1JDjPjX3Hen7dXh0SMbPdIP+WStN97ynSs02d++vvPcjx2u2Kvurj7sa2RTtPl30kG8isdwZlII9h7aDXh6+W1+KNdS787ko7EeocSkUTIuBqOmz/1a139Mk6IopI1YGXq36vKYUjDHBwvDIkn0+ZqGlr+OFR7UlfuBffeVYWQ+aUsvJYFiIuXDM5fU/x2eoCNOiJAfJTa7tYB9wuJKnm2+qq2DU4fTv8aGpRRgP70rcsGsz7pxYwrExspFSXxjf6UyanjMOGqWlBnXYJz+bwKz1F49NqlR7s8ixQ71wAziR5uhlxhYrwfIYpsQOCmf8oH88AYeekoRdEF1DjwCoyyi1CdKADmVg6xhtzTsvAnkgFJz83f4LrRVpveagyFM39Hn5tPkS9jCVcKqsGzlrVuzi1shE3q44M6prC6Fjb8sfTLRumeLIBTC0JhWimBDRb03FsA2IzVxoXMEvSmOEDHstmIkuy9jMsuVQywVCkICILz4utrGXYQimVZvNa
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cbf681-d008-447a-95e4-08db84b223fa
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:44.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wv6l1wViIMx0f7+Ue+V+yIVRtA4jQxQm1Q06V+g+gQrBGhrPC2/Qjz7yYtMO5BjeBwlsmjyEQZmacDS2xA7jTzz+9LSz8tvW7Eat3k2d7ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: Unoujl9UZxUz-MWLeVVenoGnrUXkye0M
X-Proofpoint-GUID: Unoujl9UZxUz-MWLeVVenoGnrUXkye0M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..cdefaa9f614e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -541,6 +541,7 @@ static void send_mode_select(struct work_struct *work)
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
 	};
+	int rc;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -558,14 +559,18 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (rc < 0) {
+		err = SCSI_DH_IO;
+	} else if (rc > 0) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.34.1

