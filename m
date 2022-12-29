Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B7BC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiL2TEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiL2TE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A7213FAF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:27 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIwxBm006161;
        Thu, 29 Dec 2022 19:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=E0+ZLdzLDnIMyB34ni+Cm6XYTUN4BJ0uEmbcA5F+G/7JjiA3iJegqeDcMP6FsXA2yEyE
 Lb5+MdMSoltks5ewh726VQsravy5ElTK7YxLvazSUejKDpFZIn0GWpobkxC9kkxGBmOk
 Le6SjlgHz9mthWZX8mIHrkGookOOuDUbrlH3ONO0Tk1uRoCE2HpD3Oq8Rl0VTjYPHvQK
 eLvfWtGxvFIfRYDWmkI/e8ikgRHbv7aY4+Srr/n73XCic9Q1RRXqZUa9WjSEyIB3Mo2W
 eoGcnT13R+mhoyhiFmwwKP3rAhsdoTgZKOi25HhpbuHH7ZNIXixSpCrsoDhGRoeDuSZz Vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnqudf8mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTFkewG034148;
        Thu, 29 Dec 2022 19:02:10 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv6s0k1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhHdmuy41C4eL6uP3Wm1nQtGNj+82wZgtqix7/hJHPpPZ1dZUxkU9K55r1aLN+riLSjlK1Hu5ihy00H3y8EUPezJMFHi8J1TaiCT2LmlhVeOA1myq9v4MYlj/FcyBX8CCzZB3f7bEJtEBHn+Rb2/FGucaVoCjnd1atKx/mYJDnv0PLh8TdwL7nXFFC0IeNJpjuq1mk58bz4QCUlvQwaE8sUG6g83Wv9A1rISjm5Isyn/F9IV9lNpFA7BZ+rARiXgzQbMHQG0z954Nr1ETRMYXRIQefO2KaATvG+82OSG5xHWM/dGx63NgVKR4zSkd3hl+Sx3OzflepxM53luudsxPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=kb4YNlI2D6RJSAKQzrMMtKyxgudd62DFvZFiTlqeQyLEARaf/R6mM0xpj52VISFQpccvTazuEomkaW4jNd5YFMtPFH2SE0lZTGla3wnq/KkkNT9baIjNNiBRO4em8q5YHkWQjfe7S16wtUlDbNzyCBiii7bMW5y28A5ti31of+M+S1Xl1PRqRa8we1Q9g3Y07unBEoeMrCvD7cHbscGPj9204Go8p4rIy3IqmeZXm7nqHJA1u/6kF2vik1OGDWkrGBv+YAD1R1s7EQb6+7fxSspnstVZXLGuKkYOA9wnICEHuYt+mXFtTtWF/PKf+UqzsyuCm48ZurKtQPbpFAUhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=RQPse2DU7VGDn1Q8mTKTjUBlRrbJFWYRhSm38eaqC+BhVOVrw+G7KNiBpnE2hHlVftC7DODWmQi7mLXuWG083HvYQWer8vGhdTlgNLSgKSsSv1OgQZJYBa0LeWXSnygdYZu540RNC7nfwkEwSMzy0xiH8+rsl+8jE/7R/zFVziQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 07/15] scsi: spi: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:46 -0600
Message-Id: <20221229190154.7467-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:610:b3::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 37861403-3bdd-40ea-099a-08dae9cf2f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+WKNQ83ETonvekLI3FgpvqMRIGZdyz3mf4RIAdRFN0aAko9k537x8oX/4ntX1oR2bznzY047udv7Ioht4icUYQ4GjiOieEny9zpKE7n82ETCBVmu2r928xghR2AbFqlh7IZzrCs0KmekIC+p46iQjHVxUmWfm5GpJKubmtlBHghVV3v0/F8vt6oMoh23CIrFe4TOS09yvpEstI4qxJAdrI5GraeMOHM4bXMu1JwLwvE2FprE7pWMpp3RWROl739HLKHwEkATKbkHthGNUIXEA/sbUL9ZTsG74qwm1NJ7KPCs/HX/2yNLAYU6bZZ6EmIgbXkqdx7DXWo2vU4qTBIMX7AQTi2hSUJ059cUqYWXBabPrQ8u+8u6e3zjdsuSsU+69SaA1lDITvP11zV83sVvN+vA7VEtlkQqT+vXMQ2IllFmYhF69hRzk24SuWmMaymJRp22Mdrmoym6lYX9/Uusf9mj+voMtRyFzBhuYW4U3mJjAZb4NN4QxV8Vpz4TfO0seXb6VspsyYan3FS48HsYNZozjuEoU3TouzT9fySTNOF6RGFgFJyCpSurXfy7zyTyRJLGUkOVS8ICc/KKyMdzGxYobC/CmzNv5YJF+w2o2D546CFdG5qM9Kx2XAl0J8ODFnL79dOu4L4Y8EplcEGuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NLdwFKWbEQmZddB2BbondPZI5g8DmsPTFxNb6f6nzuduHlqk8FewvT9za4+R?=
 =?us-ascii?Q?M9DJlluwT9J9wH0ndp3ewEGrPRCthUUxe/p96QYAs1ir9I+eMvBgopSuI6NA?=
 =?us-ascii?Q?iWW3yMIlmpsTOhZKZn66OxFjV3rHBd9vI9K1YNxiAhjhwGf78xZo+YTfOBhJ?=
 =?us-ascii?Q?NGPWoAG5Skb7fnVPgB3lCiLTCozUVdgwUZ/vRO8Yh6rRZPPluNmaTRMP4QHy?=
 =?us-ascii?Q?vCZEJ9DcLBDkj4nwKlSXMIGX+ZS0Vb2D0vvhJGm1u/w8jtTL9h7Q31CMRelq?=
 =?us-ascii?Q?cijxJDTgKyIJW808BN0gfmcTdSzTVgm+w71iickBbx856iHLigY0B5wKey3Z?=
 =?us-ascii?Q?6eQ0fqyS6K4/9/4b8q0urH0c12X+7S1YhhE402lXDlJnLxk7Pn591MP7hpuy?=
 =?us-ascii?Q?n5ayNMlXg7Q2/u1Spkcg6ZIzMcRsEjWsrUddAm+2X7mAxhdUZKXIhyySw+xj?=
 =?us-ascii?Q?V8fSNNRggMyfC3hfwZzAzWoTNq4AVHcxmSvMTbY9QcXIElWorWplUunKaU6H?=
 =?us-ascii?Q?Ccrlm3mvvEUZ0Su78tk7GDudpqKYPsB99HAUKlXX6xshCCJdT5fpDQjyPSI7?=
 =?us-ascii?Q?JruoJKauNafCmrVl5rMIWJUKI2iz4wRb28n/npMbNhtQRofgGPBVSASCFOcy?=
 =?us-ascii?Q?QK4DtAbz+SRiGuFnKLdBlK2mbAUvMwQgSlqZkD4z5E1xB6j2XjRQO+epq0/z?=
 =?us-ascii?Q?bUDhtxBApTW+gax3pxV2aEQb6lBGrsmWzs0xRdWkb7foX+3YbmpffwoGFqi0?=
 =?us-ascii?Q?XbfC+3hiLN24Z2GUCHgXAJSkVDNBtC/1Ze4ZzxVwkKJdPbNayhPddZIsXFxy?=
 =?us-ascii?Q?Cp+zTS27+BLfkOk27rzWkJK2KSkj4qpZlkDQmYs2pguZXsRcWoGqFlRuYinI?=
 =?us-ascii?Q?1mgnymnLHcxQyfzwzrjkku2me074nW/D26LHEsaRVmRK5x51J200Xz/uVInN?=
 =?us-ascii?Q?ZkblUJhFcTthl+Sem7hUgnqgrkRNwtDOr/coVnyFpPlLF+rCSt1NpqLcYJJx?=
 =?us-ascii?Q?mQ+mjaqHLWDPXk18W5Ib9zn3LqfBAhn6BqjiFgqpeW3K/vSLFsoYkAWNjK9O?=
 =?us-ascii?Q?phDBBrJ5mJhMGjgzFRrzQrpNaBr4k4VTslZ7QfOnrikiEWTRNSdvQRR9Uw/f?=
 =?us-ascii?Q?KVgi2xX6VWReFKfl2U9S4DIlW6gA+eol9no5I5xsfKZsikmUuHDjx8rsmmU2?=
 =?us-ascii?Q?kRAsXx0azPv9FTbZ06nRsMcjW0kYgAEzR+3IHTkgwauDfn4CoyK1nR0hMUy9?=
 =?us-ascii?Q?szUV6GFMuyDIntU2p1+FFt3vWCE86Uxg3uihN6FO+KnugCMEttb9slJGIini?=
 =?us-ascii?Q?wJOyngiQajkzHSRbi8DRo4odGEDWhlKqc4zbHM9SvY1HzU4SnfCbP98pdtCn?=
 =?us-ascii?Q?yokYzNfcE3gCfOHgGAYBvBEEscoIHZgpAFrnORE/rIsXeYtp413D0NaUp58f?=
 =?us-ascii?Q?qapB9Iq9AH6RRF+5SLD8Bt/vaZ5waws+zLdU3U65sDGCcD3VXEqFTso/9sbA?=
 =?us-ascii?Q?hF2bsDcpZxZP1lk3yThoZtVDpKjJzbp+DrFXgwXOzxOaHROUp9uyju+pkN3L?=
 =?us-ascii?Q?aMSxaxc/eNyX9aDDP/UmOohy8DaHbfPKEfFTfCrNu//9FLBtwwkHTVDA4WOv?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37861403-3bdd-40ea-099a-08dae9cf2f70
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:09.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsBilfn90IV7qCeJzwjY+oSy6WnwNH4REmuxzGSiPJOojg3CVMg+KyfTTt52lUN+6Dse3yr53DrilX0+5jWBpS8harpwikUAoa2gPoj88Jk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-ORIG-GUID: qrTNhGjdeMwkuuppfsk4MtAUTWeHYPfQ
X-Proofpoint-GUID: qrTNhGjdeMwkuuppfsk4MtAUTWeHYPfQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert to the SPI class to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..2442d4d2e3f3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -105,28 +105,27 @@ static int sprint_frac(char *dest, int value, int denom)
 }
 
 static int spi_execute(struct scsi_device *sdev, const void *cmd,
-		       enum dma_data_direction dir,
-		       void *buffer, unsigned bufflen,
+		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
 	int i, result;
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+		.sshdr = sshdr ? : &sshdr_tmp,
+	};
 
-	if (!sshdr)
-		sshdr = &sshdr_tmp;
+	sshdr = exec_args.sshdr;
 
 	for(i = 0; i < DV_RETRIES; i++) {
 		/*
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
+					  DV_TIMEOUT, 1, &exec_args);
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -675,7 +674,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	}
 
 	for (r = 0; r < retries; r++) {
-		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
 		if(result || !scsi_device_online(sdev)) {
 
@@ -697,7 +696,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		}
 
 		memset(ptr, 0, len);
-		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
+		spi_execute(sdev, spi_read_buffer, REQ_OP_DRV_IN,
 			    ptr, len, NULL);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
@@ -722,7 +721,7 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		memset(ptr, 0, len);
 
-		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
+		result = spi_execute(sdev, spi_inquiry, REQ_OP_DRV_IN,
 				     ptr, len, NULL);
 		
 		if(result || !scsi_device_online(sdev)) {
@@ -828,7 +827,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
+		result = spi_execute(sdev, spi_test_unit_ready, REQ_OP_DRV_IN,
 				     NULL, 0, NULL);
 
 		if(result) {
@@ -841,7 +840,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	}
 
 	result = spi_execute(sdev, spi_read_buffer_descriptor, 
-			     DMA_FROM_DEVICE, buffer, 4, NULL);
+			     REQ_OP_DRV_IN, buffer, 4, NULL);
 
 	if (result)
 		/* Device has no echo buffer */
-- 
2.25.1

