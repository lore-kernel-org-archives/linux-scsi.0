Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74071E936E8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243986AbjJDVCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243999AbjJDVCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F0AF1
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:39 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ9vQ016140;
        Wed, 4 Oct 2023 21:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=OvZyQY9iYt9c0aeH6KuUpSX7Qfnv8Z5DJb4b6SYXIFnJdZcoadK53Xjtrgo2mc3MsluR
 d3I4EqOhR6RGyFdneNfZzI290dNmuoYD48UAXsv7j2j3TETPX3NNBCIuHDwqvda8C0dC
 UUCqCfXfa/avtK1qzQ9leudChKtGYeBrfivAjlpKX6EKO3RZUjpVwjfMlHY3g0GiYxEQ
 9qfP4gCCJ8HU92xEBqIi5b88F8fLcnaFDSbrK0iVnrr4G+kPxKO0FI90yTPRk1JC31oR
 FRiCkd9mVxrZjGJnZdLMQg4C7HFsgB3PhPJccR1qFotT3xYyEs90aFW79r4YIk8do00Q qA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcg4r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394K2gw2005824;
        Wed, 4 Oct 2023 21:00:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4869j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ7MFkyUiV1XEP0p3XuKRy6kHLv1rjgPGUDx1Xv6cjuepCaaMxXGi23pa6A8k/EJW+wHedIM17dI48wizz7dNo+kEnccf7SLXiyx06y5lr3NN13tsrNoQ5ua0uUYXQ9ErUBgzYM/6K2fiksgdce5iTOtx7xPZgl6ieayQ8fJ/1qlhmU3fF5QJOZsV4/Y16Uq1DzcafYz0oKyoxzFXIrIqoK6BcBnk80H6+CKo1RkGjHiRu5ejuyO8jjWQfodtQDCgxBN8seEKY5qtaTmlk/hCZArt2JcD9UqySTmXS9/ZM77bEPg83CbgPLQ7913W7lOYO/6lFeR1zJpIoD2Vl1r9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=GmfbZKaDbEHv7NCy8cwnQSN9jY2MQr9RTzbAwUvyKHosvGNpzA68A3Qw9HR3I2BVqNEIHnZJYuYq9UbIz+rvyBVl7HBzAxQl6+EXOvwLRMVbxld7glKFxW+/uYutRDHZ72ZoUSlz1i38SpcocC3zid4R66RqDwdipvahV0px1x5NyU97UZMS+mtjCqWLYeaXeHKrcW/5YxNnHHFZfisDLu1mnCpHHSrolteVGXL5JAXcyXBPZkcb+fqD+sHfj5QoSsE4Giye7LunQ7sFOg4wm34BAcQlX95cJyDXr8DuZRasiU6CENRPhOWTAZiX2fpICLV5nruL73jRiXjaX+TzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOev7xyoovK8ktsV58b4Le1y2SkZuIC477t/WP9J80Y=;
 b=RET8VPgYjgKWpmifeWPgu9u1y0LN1DsP0oQ/30oM/upHqAcSM5pOacw747+RPVXLv8eoipkjbmo+Uaq0s+mIXsUc4a03h0FWK3o1M74/XTBuFF99QFh40I9R6NV0ZKeAGG2muAW9E4SKvh7ILKF/TMdJ8Mybh00dr2OkIyP4os0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/12] scsi: hp_sw: Fix sshdr use
Date:   Wed,  4 Oct 2023 16:00:04 -0500
Message-Id: <20231004210013.5601-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0153.namprd02.prod.outlook.com
 (2603:10b6:5:332::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f54e56f-70df-4e9d-e2fa-08dbc51cec43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKOltC/2kt6PQpIaPEs2sgW0qSo6kjrqYMLx4U60kXlWDRk/4cbWN1os0DkXLRsi3YwckBU6CK4QU3PYP8xqG/IykT7KZBFI4GuysiLOsak2yf+13U1oEOIc9r3je9pI0fYOPf7NES9QkYrAIl8m3jlzwEhAPtlYFrxxmUhzdKdMglHFOoU4t7Kl12zEX0y4jFuulapHochslB241Q06gec6aooPhyhMWGb5XD5pREs/hgO/vgzKFPVT4s8HkjE7zrTi4OjLQfme0/gRWjM8vaiGfGDByOvg1LdZEd14JS4P80425Zm2NBkNZocop5nzk2NhbqPv8WkQV1HG4d1unCySVbschTWVfWXtQgB2b1qCiCgJxteuIpDLUohsnPTNCFepdSfVfs41UoumT7/4EGnsqDLh4+TD2VAlkCibrEZwRvkvBdMaeopgXod5SRSFje9SyZlsdJUPcEU3zDWn2us3yP8ikNA9xmFsjtuB4tuGSNJrStwXUtcH+KlcTznVYD8wwl7SqRdswSz4q5OOt4t3t6uW4hXafuChuxSU88Cw50nFx9H0U68eUZpPeOyw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dV/OCx5XKXKNaB6OT6G7O5MBnKCkjSEJzA1IezIA0tQvm8YnfQCkcoQoLuWA?=
 =?us-ascii?Q?Vv2yIObwv8rF+K0cwRD0TEBlIE04BYvuQf75zOhz+7Vii6E2ShIaPd2ZBZoN?=
 =?us-ascii?Q?5sNgs24FIaDEuP//FO/b0kScjmYfBcdoRrPRGq61Pe0Hve+X+P6yR29P9c/a?=
 =?us-ascii?Q?ZhYp2Ctnq8Hc0ehSHttD3UMMGnmlZZgn0+X0Dp6TurGFCxWaFATzHI8u3EWi?=
 =?us-ascii?Q?aIRsvj+t7xRFklThdepi7Z7T92nQIEyD6WcRz4cz0RVjEVVG1nPFuIS8uCY3?=
 =?us-ascii?Q?gsvtQ8PEMdHPjCt14TKnhyGL8bdt++tryeXWd1Jsa/nHQCKl4AAXw8YvL1jK?=
 =?us-ascii?Q?KU7iVaA52hj5imD2NZ90FLYXTKrKUNhrZY/vpHBZog/GeezkP9szxVC3iSu5?=
 =?us-ascii?Q?pEgUF7prTdvJuQPA4RQUdWzhUCnyvRL/r2ayAMQFzq69BgBzgMiK8rlEo8uh?=
 =?us-ascii?Q?Pc17ZWiTdk7lSxDX/zw5bfHFrjpps8GyxxpTVDBL3IKPTqRWPGr41nhpe2fv?=
 =?us-ascii?Q?Sb8ay7RCoAVSM6lxE33c9auVSMOMvmIbT5o8IYDytw9cBus/OBz3Ls/5nEIM?=
 =?us-ascii?Q?kgaDBBDBTmcqIRHO91HrWPRA1dpSjxzEDtkHOcjZhqB7Cc8d6Hr9ZXRzHKCg?=
 =?us-ascii?Q?8RgFLDW0qaISQkygZ9mihncZO9EL84mUnhZb9dUnU9JdwKo8pyE797+Wt/HP?=
 =?us-ascii?Q?WYiqJTH683jjhoz4OSLnf1Ztc+BFgIi23pmIlkwOZ/a0YdmAi3jdS9lhosOl?=
 =?us-ascii?Q?oTbF2xHi0lCz99zn9u8p0ZQ7R4rcxWYLZYUz6mTvH7wvQK8fzHhAEcOyKr7z?=
 =?us-ascii?Q?plJJzXamRT99UXn7ABJyRTrRme1IFs9Giiw78LGSMLQKO+VSxexNf2mvaG8i?=
 =?us-ascii?Q?qZi3aGU3Bb974bFftJP6DBZZTMOqrM2a8Z/v4lt6dOKzA/QWmCjjVroQIP+K?=
 =?us-ascii?Q?luBJKwZnb1tPUgxIYYCddwPaDd5VPg9HuUFDl+JVkFdvBx/HhQCUnl7mLe6H?=
 =?us-ascii?Q?qLqeiK9WxgnqsryMYrg66cCmcI0GPAYpdq6lGq5GxcpJfxYJyRB4rilLdNKP?=
 =?us-ascii?Q?+NDWtWeJQzDVrJTb5V/3U1UybZL6NZiNYG2/ddmcrQPsRj7v96S6xNR/rckI?=
 =?us-ascii?Q?LivOCdOwWrtxlSvl4YmqUbGZhDDNZRAHPvd043wBpIcDx4F3folJ36HRAbgB?=
 =?us-ascii?Q?ap3eOOV0iDOkNIYhe0NetwBV9MLvJ6xtJRg/PkyFVfHSvIt8PuSJXqzAYVIG?=
 =?us-ascii?Q?Ob9VQMmIE7AgWiIM0OKwTjHjF8FcyC/pSZQRYNsGFE+oxabLX/cY2evhKLO0?=
 =?us-ascii?Q?TZUWUKvEPc66h4DcyQBdUrgndhS4+sWViQlHQ7+cqsJStNC4yPOY+Ai484sV?=
 =?us-ascii?Q?cBbNHNkVRTnJgwWKAqSoCuV/3eqzcHXdtGzrB90wb025tPoDP4liWR5GCsgx?=
 =?us-ascii?Q?LC7uY1lrV9n7W4pS5rhVV7ZBsv6axnh7cVtqtWkKcNSMqgw/MDyHtb9O0tAL?=
 =?us-ascii?Q?k4TA9qfcnL+3+Qx9PWkgK3RufeFquZ+G7YbgNerFimJT4mNmW3H8Rm7Gt1yW?=
 =?us-ascii?Q?9Z5fluMq4EMsLq8k44Mviepu8qj6Qb6dOww1DkfLlUrSGgG+F6dqcnvK50RR?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: S+hLC5GvxO5EoRWm+2JNfT/bs5EhMb7SxwI9rsUrbsBgpE6kULksTlXh0nZl1enhFVhZZ0KEZoPHza+U/FwEaFwe3TEyUxcQoKiLv/QsNfMRGVZwhWMW39n6V7KRH9daHbZeSnSsM4FAfaXxn4uwlxqhEnXVv2zxAqIXMImftWyBUQKoO/leiSzxb47tYNunkztRGppzxFmAcLg5q5Q99EuMx/9QOpy0FSrXQwygFCXkB1aRSE8f96r1sCgQGCHx8d7Sv1Qqeie3Ibz5h130I6ti5zmGsIVztpLQ6FTsUOOVBT9Fc5/NZyGsIDcMmBzmH506e+F0Kqw/brDuLb9TwEAAWZF+L30RHVUsaH5EgZO9kurAcDqrdU0w/9rsoh3uMu2Y6hZlmg6xR7B96Be0s8ZiyVfVM4F+KlP62hQPkkwqqTHrgc7MkyQ/7y7gOa54qdLMRkr5Eck5d6gU/lrM0JRblMXxCPnOcvPX3rCTFhlgtQraxTKV1j2HKN+qZLS9cUaw++pAMpKlFSoXPfGooIkz/7CdkX/O6RTvv/m2HUPgClfFMdIFr+XfI/1PEYvUJsSkn/Wva2PFbAXEXIxagcKRfDgWfcAoiUQMFp5xv3/io5dlMMeQz7vR0mxllcVfIs8lua5hwx08aUdj1/Q9J4+UYKruSF78rqPD/dUXlzIs6DJACgo+Ib3oRsGIyY6qVYgnO3TdHJMVQBAdHpTZOONPOHRzq6Kz2MJxum+ZKiyDsoxVXPDMHzlGnYIx6o+Hvvl3HEBxZtFFkCNtuz7ZWKGj43snY3bpHVaL3XgUOvSxU1ZpOneUmtVHatsrNMa9of75aXgyLa46+BkYSudC+GUhiDONGqhOjzhRnK1H1SF+g5fUY3xwaROEHB6/HNUv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f54e56f-70df-4e9d-e2fa-08dbc51cec43
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:21.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCqVWWs2gJK0HKu1M6smRxO7sNA78HCR30zFWDr3OpyQg23fiuH0RNNRSTRDB1Q2fy1UAewB+/96DRdTFQRKdeTYPz6oCxJxuKGNowg71xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: wVP3qcjCUUq7ocB0wMmfJ1-kBDAJ3_HC
X-Proofpoint-ORIG-GUID: wVP3qcjCUUq7ocB0wMmfJ1-kBDAJ3_HC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 79 +++++++++++----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..944ea4e0cc45 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -82,7 +82,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
-	int ret = SCSI_DH_OK, res;
+	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	const struct scsi_exec_args exec_args = {
@@ -92,19 +92,18 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (scsi_sense_valid(&sshdr))
-			ret = tur_done(sdev, h, &sshdr);
-		else {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending tur failed with %x\n",
-				    HP_SW_NAME, res);
-			ret = SCSI_DH_IO;
-		}
-	} else {
+	if (res > 0 && scsi_sense_valid(&sshdr)) {
+		ret = tur_done(sdev, h, &sshdr);
+	} else if (res == 0) {
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
+	} else {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending tur failed with %x\n",
+			    HP_SW_NAME, res);
+		ret = SCSI_DH_IO;
 	}
+
 	if (ret == SCSI_DH_IMM_RETRY)
 		goto retry;
 
@@ -122,7 +121,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { START_STOP, 0, 0, 0, 1, 0 };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
-	int res, rc = SCSI_DH_OK;
+	int res, rc;
 	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
@@ -133,35 +132,37 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
-	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "no sense available\n", HP_SW_NAME);
-			return SCSI_DH_IO;
-		}
-		switch (sshdr.sense_key) {
-		case NOT_READY:
-			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
-				rc = SCSI_DH_RETRY;
-				break;
-			}
-			fallthrough;
-		default:
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed, "
-				    "sense %x/%x/%x\n", HP_SW_NAME,
-				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
-			rc = SCSI_DH_IO;
+	if (!res) {
+		return SCSI_DH_OK;
+	} else if (res < 0 || !scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "no sense available\n", HP_SW_NAME);
+		return SCSI_DH_IO;
+	}
+
+	switch (sshdr.sense_key) {
+	case NOT_READY:
+		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			if (--retry_cnt)
+				goto retry;
+			rc = SCSI_DH_RETRY;
+			break;
 		}
+		fallthrough;
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "sense %x/%x/%x\n", HP_SW_NAME,
+			    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		rc = SCSI_DH_IO;
 	}
+
 	return rc;
 }
 
-- 
2.34.1

