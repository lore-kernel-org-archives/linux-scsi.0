Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D3CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJCR6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJCR5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7440E1C
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOIZJ014336;
        Mon, 3 Oct 2022 17:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=YNkwTK4NEshF+einOA1K1SFpnNXA36NrA/jpOrOm3CnP1j+krOzVwEQaVQ1KZoGgTe6A
 zMLkVHc3D8b9pUN8osR4zwNdSHjPfd5q5YoPj28h69DY/UFYHVVQWyIf+khAXc0fxEts
 uhLKygrxV0EIo36NRbldtMnsn2x4Y9thop9+rR5Saxr4lNoWwOeHKbk6KDRYnNU4NlU4
 bTDzSi0M/XD3vDeectutJ5F1H1NCbROaAWPiO/vjWUdixrAOK/K9tKyTAxpNCHNdzRS9
 Pc45cn3OKYF/1xva3bHpG5OdEv3A6rYSESeYhx1AM17bOScJnPwEjyAEdLtadwIl9QxA /A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HbDSG015544;
        Mon, 3 Oct 2022 17:54:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g432-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ3EruopR3JeEmFqmmAfCLwFmXzst3EuMO7f4/fm0WHPAWAiJSgBlNNBhn/iCjTgeA/unmcZdMJRX2YIVMgJUs/BVS+16NIz6tOTLE1sCsifvJr2pU+5j+SXd7E1fyofMlEHgH6GSn+x66lvG5Uow31iqXHTF8M/bW0pdVLl5KKXhf4T1o1G8H6B/czrgiEHWCBCOK71RKVOUie0qjVLFkSkMebg7/I8KK+y0CFh7Khf7osIYV5fp8W7+1nZVMWD7oLvCfpgDk8qC2WM8AtMWhbAnCYcilqXKF2b+aZ+UrHrvst6cr65IotjynEk0UlD0s51wnuyX+Cj0QLd4szZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=oYwbAtlEl5fhJpiw9trpvpWjozFFGVmoWcg9n2c9H1PYaWg8P1ANOSWEqOmgQPDNldf12KWlFRMiocfRKxv0jqQtocQfLg9ytuDZ1LdEz5W//7g0fwk0vzO8fKB3DnkC6raJbpmZxWMmsqHobhhWpuZGyZiNSTWpUdkL+TPNQnPuNDPFu2ZZlBDkUwQewyPPEg6tni+k1o+/4OmkBLMypuFTLVB8+ZowFR1GBvNK6ixvz8zzc5V8ubpN8KLhQoUIHcV2tMKT43lL66RFKk3ShezF+1uz2ijBYe8qhpZH5KhbPW0FwYCGftmh+CA4UfL8qXwduuZ2lP4EeQiJQAxJlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=APR9YRfCXDs08YbeV+aMu5rfINgQEfqD86zf/V3eZc5M+znoXgQa07oSu7hH95QTNJUXCmINN0Y2DeuN/RsXaIdn72fNSTkEicfp7/DoUkrL4W0tf1vIIHQ3BlzXroRA6Q1o1m0/dajGjBawyqf8aP2yL8cnPLn9newrMaz4MdY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 33/35] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Mon,  3 Oct 2022 12:53:19 -0500
Message-Id: <20221003175321.8040-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:610:20::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 08327590-b7de-4f5a-f0d8-08daa5684821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgM0RtuV+pKpRaxGCoLqy78r7qRQCTkmN8XH5V4Hd4V3baQaUMB5Z3P2n+aSc/8ftaTu3CeB5HG4ousPDqRlx3pgT7hz7vI11lZW5fPO8iDbmCWQVSg+fwQ2+GPjIOCXccDdp7/TeSViQz849K13R0A0kCIes/9k+74UBR4aUnkI/pimNiUjK5tVx5xWq+qICVzFLyKJvAmsbrQQO4kEy1CIDbhx6Cq7xx00vOR2oBGLrOnHvdDRw7fZN4Wo+AqOBBJruI8ujmUIZgK+uF5HlsjoQOuvbSATUjZCZZB+YV1r9F0aDnz9cPY7Ng+3rQqo3dYbfkEb3TmOGBbpA69vY0K71/l7wvyfYWRxQDpI4Pk2cuEnYw18VRUksFjZqMIDizWGAXTa+u4ALBz9ofPdqQaqkGqMlnu5Z6w7E7a08R/PawohkyeNjQ76J2DGlghacDAJ5p40oZdxiKiWcVjPO4IpTto2/W1Ha16XHag1QJwrblYo+hOJPRBMh0qpG4UMaL9zuwDZKTymR212vH3Ff/zm1C6ZCMWSHjRZ1fl0iehI5RsmtSqsbgh8CpbdjneGUxly+4KYf1zsUP+OSqx/ubPF1STlAySWrgqOIuvxDumpi7T0I9WgyABrFYcgzAI+fRz+H+TiaoKTAL6btc6p7f0SX7f41tfryGQ5W8iVa+q525s7+s8RoeBOS7saElQrrbMqBk4+QhIhgf9sjEGaHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C5T5M8AJavovpLsyurd/mD6XS6fD5Y8WnH1UKWKD2meT+7L7GdKMase3qCvB?=
 =?us-ascii?Q?xs6MWPnTb4uZ4gFPbbsvxRE3qTAnGXobxldH/QehM1b58lVY0OB3iWmBJLZQ?=
 =?us-ascii?Q?jzU4iTiOThzlJdqkTsBH26EkD9rdzUmLkwwcn/GVMnmlzANKQNNdnjcp3JFP?=
 =?us-ascii?Q?U8G6WxrSzopZATp123aUUKb5iijoVwxWgXY8Fly0TtmkS9cngVqhLQyHX8AC?=
 =?us-ascii?Q?BMdV4ZnDv6iuihlqYr8AuOE2DBTDwacrvmDmLyLgD7OHA1lxEuPJfWox3Tnh?=
 =?us-ascii?Q?C9NvfHLT6XF3uDGOJrtLJ7SHzTp1n4/+Uhqg/em/Yrd8nh0C7acPjlu1bB2z?=
 =?us-ascii?Q?m8qs8vsh8tP50CCzTIRt64IbBFpDqa/7CzQgQoio5kQbSmDOGVwn0erAd2TI?=
 =?us-ascii?Q?ilI1D4dn++4OOnjUcEc7KVWlzIq750f9XnD6TqsVvGColmttDtGOYo3Vn5qa?=
 =?us-ascii?Q?FJN1FmGZBOErbDeounQoCZHl8Wzy1Tv+6yumk38NQxFHvg4rOE/F/ZtIrSUe?=
 =?us-ascii?Q?REe8GS9OR6W0WXGQpp5EbkuX5ei3euZ+kUexVLMI9Ia9orUAt8ZMUmyXyabQ?=
 =?us-ascii?Q?kx8j9bVNtq51vGDzei4cuO6mNtcze3sPffyxWaV2OBQOCo+q6WQ8ZyA98+cV?=
 =?us-ascii?Q?IP35TxGKonKY8Zpkpj2kADYUk3Fa02h5yIg97fdZlKuGFzrT9U4j6YLuaoWe?=
 =?us-ascii?Q?NCjUIGN1T7kIuidtkCxQCPHp4QzpaWZTfRsWj0gVJl0139xnj25/mYmgnOdc?=
 =?us-ascii?Q?6Be+Rvm2rRPpnT2jV1IZAiDkZvv+EccEIMUMJXJsjLthAp2Kb32TYlB/UsuR?=
 =?us-ascii?Q?zNcBPZJhkGSokndDLcVTLupeDxmeaKXwydQLShL3qXuElqEqrnI96Vyr8Zbv?=
 =?us-ascii?Q?pGPOk5ea3nWs+MtlzTpOE/BQS3HJxoKTjfNg4qAkFNDBmSDc+O06VLtrpcNA?=
 =?us-ascii?Q?SW12CM1P6VeB1ksBowILUw7wVMW3DIOY10BS/bOwhFfPG+Ycgdef740p6bjP?=
 =?us-ascii?Q?HdXnmyuyvp/1dnsYddQOGjzIhmU0bYuXP25abLoL4gMiSiQGrr+MER68EKY5?=
 =?us-ascii?Q?MafGDHnOnCNvXDY85mMp1N8bBY6AFhQtqZznhrOBIPAMG5ApaW4aLjHUDiak?=
 =?us-ascii?Q?UPSbcowkuWOsMNWhjDi5O7yuyfv0sGrrVYPi395V70WRvkF2nolTwZCew5Mi?=
 =?us-ascii?Q?+u5ZkKyY2Npkac1CimBuc4wgR9TCpFaY7eXYHlNY19d6CvsFGS7Gdl5Qgcpm?=
 =?us-ascii?Q?XmDfJ9JH6Pb/GY3qUQJTMve9C8q8GrM3Farfo3TlVvfBDbZJ617Hlogn8UNt?=
 =?us-ascii?Q?SpfvC+xlDhsZwbHtzFeAhf+RSyIj/4iK0X1O9d6T3z9sqqd3efLyFQ7kQRve?=
 =?us-ascii?Q?6lE8FIPd5P/lwOAHWEDROtvQ0rzhF07cJfPQbRToxZl+kFQgUSkDjiw6Hgmg?=
 =?us-ascii?Q?HFrN4p93+PvRiYGzRr/XTH3gRexMeEAhOytYSpXuNHf83eDeox0jOkkxvmet?=
 =?us-ascii?Q?xbsh3jNtHLft6nQ7PLZgXudCh2BxNQzrd8MzJ4kWQeNMFsiqMzETxmPAEAAM?=
 =?us-ascii?Q?bswpm8XunASKfV6OSwain7w0Mtgxahm98qMNVMXPl2TobQeKAQ68tuvT0lLO?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08327590-b7de-4f5a-f0d8-08daa5684821
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:13.2649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFJmSduifzKNg1pqIpq0sFPlBeeiZHU++DktGLg6u/Hdj3Fs/F/hiyVQWG8cGukE4YJ5YDkkhqWe09mKjqisKBkW2seNGBBvuqveMvGVRkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 6S0gRV_VSuiHAXB9dF9Gi6pZlWXRM9G9
X-Proofpoint-ORIG-GUID: 6S0gRV_VSuiHAXB9dF9Gi6pZlWXRM9G9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ses.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c90722aa552c..d8b31c0b0125 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,23 +87,33 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
-
-	do {
-		ret = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = DMA_FROM_DEVICE,
-					.buf = buf,
-					.buf_len = bufflen,
-					.sshdr = &sshdr,
-					.timeout = SES_TIMEOUT,
-					.retries = 1 }));
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = bufflen,
+				.timeout = SES_TIMEOUT,
+				.retries = 1,
+				.failures = failures }));
 	if (unlikely(ret))
 		return ret;
 
@@ -135,23 +145,33 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = DMA_TO_DEVICE,
-						.buf = buf,
-						.buf_len = bufflen,
-						.sshdr = &sshdr,
-						.timeout = SES_TIMEOUT,
-						.retries = 1 }));
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.timeout = SES_TIMEOUT,
+					.retries = 1,
+					.failures = failures }));
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

