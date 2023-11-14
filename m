Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECEFC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjKNBk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjKNBk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:40:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E40E1AB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:40:21 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsedC016960;
        Tue, 14 Nov 2023 01:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=nfn+ek1xQwH9YWUKf3f7SpAOY2Y9Pp2jwQLU+p0OKkY=;
 b=NXnKW1v+0r8dGkX8zER/fFe3Rljvy9EC/H7o413FnZqc3TBKXC4CikakbqBY7x3yDPv/
 jfuP8PucbMAun+syORdnA2FqiJmWYMaJRc6RuZ2IeUPYPdQFQpilwU1wSu+wzazOn01Y
 icPxHd8U/T01h0MqsNRDwWDDGMN6Ejvmg6GzrSAzMaWcUoifq8qaNO+fI6e5SWYH8KAr
 XRMMF7/LGdIPCxyP2o+OFO8e9k4HE08QXVw0Oo2vPRrGCdKZ00IzKZN0qBO6krW+kg2E
 zC8lE9fhSogLJGVzChsh74zMpZSMvaxOeQW+qnKWDyRw+NwhYs4TPpDa/6FRZzoSwC7/ Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2c4gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE10WDG015009;
        Tue, 14 Nov 2023 01:38:12 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpv9d8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7Vd0uaS3Hzt7l0RI6ISn3ird0h3zouT9ik+SP/nUE9yKHWh2IEeNTyhtqss+LQ6mtCgKMdSF+7lXF8HuuHa9hqPKGMWawPN57Ko9ssswmrDkL7RRr2Jis1w8C+0HhK33XyN/tY3DPFI5NqbJWMVfvWHz8R3vVu3QFT7pdWYSQNRA6BrFQo1wOzBIOaYKqbk14SfnTE9dfKr0iZxb6kl3zqjtZh85mp9LZN7Fsh7MpgLrXqRir+4tkS7IY9KzifU7Z+lT0BLVLHkittnoodZ46bbXsjyDB+/iYS/mX940RqmClCTNp6Qjo4f6OdPk3mPQx/+y+bubEfwifP1D96UVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfn+ek1xQwH9YWUKf3f7SpAOY2Y9Pp2jwQLU+p0OKkY=;
 b=DWyF/91BH/PQ9u5tXJyZRDpFoKyOdaSkFEiAwqdZBmE5cTDATTqdVtfhG7y2TWmpso8nX8hqfaH9gbvUvotBBSlfTv2oPboEP1dUxXwffsj4pYgDhGmlH4Indx5pOtitMkDCXSThLMsXIXW92HUgLSsRliAVkt4jNVZaEYUY2xdXD+pS0v8ityqyV3muwA1dZ7MtrAZtdInhv5DjaIk0AdJ2PJsBujBDtlYT81zzW7SxXRxJpme2LghkToQk0PLShKFjxBs8h/PN/cJbm/TRj3n1j1EhBgdLI9HAFP3624gNx/T+TR1GJ2+Gr18Dp06hp9nllmWbzvO4HR3U8LvVZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfn+ek1xQwH9YWUKf3f7SpAOY2Y9Pp2jwQLU+p0OKkY=;
 b=GbAd+udjAjtNqBmPsgRvJQxJzRrNEp1tfDIUbtuGn5gIpeDt3kG7t/8fgfLpyobKwD/mssZtgITNCadA7REZ93bVhq2MrQXyMjeyHoQhNh6qjNkNsnA2L10QCVQbjny8jIC1KP4hn6i033AXNju+3OilrvOLzqphDl0A749WFpA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 14/20] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Mon, 13 Nov 2023 19:37:44 -0600
Message-Id: <20231114013750.76609-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0097.namprd06.prod.outlook.com
 (2603:10b6:5:336::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: a3418550-49fd-44d6-ce8e-08dbe4b25c2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1k2yIysQpPxvp8Y7+MghcKvyQ2NFEGQrYXQcbWKAJa3G/DMia4APtg9xb+yd2h/tvW77K1k0xDRxtUorcM22EISIz4S2xlYth0qyKiihAjmV/0opOWCbxQRx7RJPdU0PUwZGpdPzvcSuFO6G/p/mQ/YvoieLsvdFHHlf1AxmBLY6/yGu6QIymY+lc58Sx7yhth3KC9nxddx/Uhh0FhVcbZ6abpj9PWv3zILzUL2bEWMApkXmTZthh8WK9G2ox5ORHEP6Qksexe6jrS9yWlB0wm7vIZpXZp6abUNceXo1a+Iw03xwnGkKHzcwK2ueCLvEwz0Jd+MG2/SJ1m3105eZD5z1E+zZ/Ft2MF88wyTJxxpt7N+2VyuhK2b9jObRqJb8W7h7PKQTLtevJHojWOBcYzb5AF1ueBP4obuHM10Ilx2mlQGMv0JZ79gVZBgk7PcyNWqOPi9U+xF8Yol3tLN2nnioCc/ig1b7i8wrIn/hGZzAhjLMhlmJNGua1s9/eZ8cvDWG+2I1AhZ/0ves01259Xmve4qjZyWa4Pf30otR9zxcTALHzBpw2GSx0juidVm6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OQo9dd2WtifDr5mjHAR/LE+qhl1p1AtrUiW1mEkUBtrj8DVV1tzt1Hc/BB20?=
 =?us-ascii?Q?yhV0jrl7Ldf/HhyUe7v3SWPjP8OA05CK5vb0O2p2xpbslb3FKYzvG4XJyRd6?=
 =?us-ascii?Q?p7i7R6ajRjECkNU7sB3HlYjHTTIoypzKKa8ZJ43yxVfGedpTw1Yq+POTnpAV?=
 =?us-ascii?Q?V3MrV5jShc1tlH9PYdhmaiL+HNc6kHTBtlJOQGQzbycbSLI900JPffQDsVrL?=
 =?us-ascii?Q?WiTF7SoeAtPEW0ommc0QMf/W0uVa+UQC234KCJimIahaY7vaEFhIICfhtq/S?=
 =?us-ascii?Q?Tb3Na8I65w4KCsA//5KrJNS9t+9Po3wCMsluK0sXzVihRx7c1+a0w0n4iLP6?=
 =?us-ascii?Q?QCLLRTuGbc32qxq/67o1G/IhstSmLX3bnAYUU7a+jVuCiN/BoDH+PlbODHya?=
 =?us-ascii?Q?9RGoaGQbPsRz2uqPLnbqHf9lCjKuZV7HcPVHd23UQgjWcRPttz1V55B8alwi?=
 =?us-ascii?Q?QeVXSfenfZoU3iKyd4r3tQn5tAbId+2PRBETXAtDmzmo6Hjja4/fL6TSMOCm?=
 =?us-ascii?Q?IGlxFEiTnJQmhLrVipq6ONwjJbhA77if7zmvu66iz8pSgrXhGAIdwNaPHWrX?=
 =?us-ascii?Q?icUOEQZAtLPv/eyUsXoIOHKDWi+PMesuUhodgqMfpiy1XIutsG5a3xfmhfIs?=
 =?us-ascii?Q?rXWY3+uS96czK/prSZWNLreB8uwFuPrTAXS9eVv2zyNVxDTC28Om28cmk6Pz?=
 =?us-ascii?Q?7ZghMEPpy1k2ak6TKN+cXDv7he7OAMk6sUsPrY1fD2wXUTPYxZvVIxDwlKF+?=
 =?us-ascii?Q?Un+4b9m4veZhVR440YNqtBgGMkCjzHn8mEmx03XuZRWURo7fvjhMsmn3m3Ue?=
 =?us-ascii?Q?jeLiv/ohqEkvein+L2Is0oN+KiQN9OXuLH9lSs725aTG9m83ILUPQmWeHREx?=
 =?us-ascii?Q?5qR8IXXErLiz4ENbUzhfFBz4ihlZ7kDMNdFr3NefvhtkPELh78qcjn3yW5Ho?=
 =?us-ascii?Q?A4+6NftyZVArU5b++jJJOCiA1outEHAu7ms5GTjbA/LmMWV55vDrsBXE2/Y1?=
 =?us-ascii?Q?gWoHMpDI+lZMDw3ShyBw1Tix5Zf27Gc/Sc2cJaL6SoHUVitZ6t5YgqcTC8P8?=
 =?us-ascii?Q?ImpKSV1PzRVFtYvQIiARVc1ljNqOTHQ2yPmYwWVqecpJzj4Hy/D1orgNC6Xl?=
 =?us-ascii?Q?SDTHp54f/HCPIfeRFqhnDqTPQu4fyYIWK2D3E4OPu/OhKgj8ulXHF5MbDUcv?=
 =?us-ascii?Q?kQoFAAd+vH3oFZItiZ6v7v583BDifFB2rHkTgeBRROBGFnS4+zJ3XSrbr4nt?=
 =?us-ascii?Q?BePc9QKyLGmURY4RTL+dHTFiElsaxvfoHFAafTsnGAvqIiFwTwmdtwBSufdN?=
 =?us-ascii?Q?rRTCkv1gAKySwlXwvNZRgDoay1uUFtYWe2vHSzi93aFazt6ZVKrvKXA7LPby?=
 =?us-ascii?Q?j7rwXI8fORoR+uHzQA8QH7AvEXUmgqKNIHld9eMBuL3ghe1v8l+cmfoFT4gf?=
 =?us-ascii?Q?jS7ByKHxwUOFHMNRMbz2vEt0NL2VkfIOPUVvUHVL/K+WSW8iqiU/v4P0MviQ?=
 =?us-ascii?Q?jgEbKsu7Q5sU9kHOF0Prbrwj70Cb6TijRQdqS37Ibugn4apfoKo7phbWZTx7?=
 =?us-ascii?Q?aniq/X2MKRSKqFSua3fJlRlhhtqkEaercanNWsO6OQK8OSzDmyV5/Mh4tr/q?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r5jNeALXqczZZtsQoypphvd3Z7fE1za2BerdTzuLX324ouq4k0noQC2gdX81ElcDCXUU7VEYOLZyt0LJHXpps1PPGrT8DYb37svcgRMdD6zkAsnKti3Rt9shwshprXobmt2uYP8CnUArB+NrI4B3BZRc63p2XjEUqq/0b7h4ngZZNwfWDzMyL9JSq8JFSRzsGhXqkjFkPb+SUP/K/RQ2fZIxwGuM+9X5pZeIZ8Z2WngJhIwaJlSvi4Db9c6+HC4qtjz4WqgevL3fH8dVYPkAIeFHBYceS3JIE6TumeCis5EjZ5yEd6DG3YtbnbbcKFssqgkZprk+fB7qdhqW42vXcwPeLc7X5fjYhW8F09US4xECo5+5ebvcEQrXcH9TkG5hfNCCK54fsChCMNVr3JEz6usMh16uGlJ8p3cfBSkX1t5/Vx6jPh0QtVDB+0/pook/hogywcNYBAgfpAZ/uqoYhb6gM/cG9P53WaminzuPNnCprTvqKqZ3nim9r+oh/Q7LQa8JupKYu6QZNnbFeh3g6pmseGEgWwelQfOIgv5pJOcmAbW8JxVgZsbo9QoKvqnPhyx99je7U4GXQxt20KosCMNh5JOUnwT2QFk/wRyfx7Jxv0yMylHP25L/W2wozPJvwXG5vQAhQzUMU3gbzF6NYFkfnOIQbSHA10B4GevZUKDVJtRvsVRac0efU/BD2XKgWj41IvuYKg5sNQUVkCgrPzIOs5gmtnp8K8dpf889GQM4iRsmDmpa4dk5lDHIAKehtZu8z+CzMYGgRcMM4CZzyx+EyxwEZXnOnolQPzUeqrb4kuw8g160a47KapLeKWb3m33VZhlRqKQBXZrwk08VFx/S/NSreGjW6paoAmjk+ANuWKqqORyEkAVwj6x4W3V8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3418550-49fd-44d6-ce8e-08dbe4b25c2c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:10.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDnP8jteYEPYAnKuGkqOV4wQ8F3X2cnBIeTfvyxYa8PC2PJRuh/m1MQRc3QOh3+ywdsp1K/ysOCIhCRQPkst64RkM31gS9vgtzMFRUSdECE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: uAZFEUabMRdss4yRYiCQmtcipjzoN6lF
X-Proofpoint-ORIG-GUID: uAZFEUabMRdss4yRYiCQmtcipjzoN6lF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 57 +++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8da0990b2dde..dce2d75e394a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1416,14 +1416,34 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any other errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = 3,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int ret = 0;
 
@@ -1494,29 +1514,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_reset_failures(&failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.34.1

