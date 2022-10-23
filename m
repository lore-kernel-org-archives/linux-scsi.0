Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A86DC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJWDGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJWDG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7115D6386B
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2sexp010909;
        Sun, 23 Oct 2022 03:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=1wqGTAzbmiMK5Mnv3BoVUxXiJ6zNkSBtclaBzxbV/hoGVn9ifFOOzLhFYI/s16L9JbL9
 s7nTmMXNnmRjdDkwkC5LAq/mgqr/uaV9pYXZNnDyR6cRgcv2wMEOZeNrTWO+fS1VAFF2
 97AA5n0d8XubxOcz5t6jPNECRoASNyS/wIxrp0TCdkrQXLDuUO43O8qhE+2Q6aAeYgcQ
 FG8hWR03QVgGLLyUqQR3GOGa/RiJTuRfR5aciXYa47BGFwLIpo80Ff1NbJ3gbkb9Vcf8
 H7eFx5H5Jxmb1a0iCyNuxlJ2+b7A9lbDl0fXUaR+c19iuBMOVBbxr4uDdPP1BGXDzTUO jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29ML0GQJ016347;
        Sun, 23 Oct 2022 03:04:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90n9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ6dq+PnL7+e4HxcnADNr5r09orQCIbqE+KVW6mgz+tOkonVKkC9KACkMENtwYUv+wI997GiYXom0xu7SHyCAPc34rtkpJhDX7pW3FWLjrXn6lyP1AyeeiPY5INl+oIBxb02YH37QABXMd2UFWy34gL0xq60JKtnvx1hVyN+laKcltk9m6CRQfjd4nLI6VhQbL/LlPId3ZdWMaYKFykLS6wAczeQJaOqh+4Yh+7KtKLslIUHoeDesiO7jJefMcBQMgWVW3ey8WJoHM1boIRpG23/3epK3iBvXbLtR1mZ+j0lC45X1fu1/eNnb9zQbiI7D/9mDfd52fUq8HKDlqO1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=Sot2U70mzbi/tFWI/OR5rL5wmRJcN0XsUJrsjcVoxP7CRJRctgFSX0noNxHBGJmMWhwkF+kip+perAyM4aNPnEp/CmjnlXfJkInBVe+zCVW0ZkoMdKozAS9M0IBAbQkdoXW/2pkOF2cYOo4xxpV2vQCE4UijYmi+pRivxIaQc8J0cHWr4dRz4CvqKUNbBq4LrbnNFLfr13kGS2j3N/2dYX9cYnEgltblrXrsIRdfF1WiJ5REYzQVqnmoE1jagCTyepRwNw+d5k0UlyGPpn2u59ooHZrneLIgKnte7CzMkJNGp3CMTqSZv7xCQy99hR18nZWDAsQ0mvWENFGGQiIsrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=NO8762vAfUx1ryoHkwkCxvrS+NULaYMG29PsVk+34K2buo8yEDdKEtQHA6MxokSTDiCFleqS3QCV11f1HzTMTPAFdLYrIQqKLrjs8qRRNyutHIlHa/L6CFqhJXKDjEmkGUReT5QjcT+kMNyxVAinelayiiWnHol85WcoiPypfLU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 05/35] scsi: libata: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:33 -0500
Message-Id: <20221023030403.33845-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0017.namprd15.prod.outlook.com
 (2603:10b6:610:51::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f48f67a-5367-42fb-091e-08dab4a34402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMNSw4Vtem9vnOa/2NySBvdOE2kBbrNHQYwCrhY5RPaRyQtOZEG5XqPzENeofIJutJ7+9l4nFYoe65Xs5EEAS5/AdPqk9VDuP+5hT02ZKij+SGczmjsw4ZWzyDNbveTc8gs6PZpTPSYbi3A8CjYZqFN9lmrWGrPuxW2cn+w7secZLC9j/bNkxlvx9CygQuCVZ78zwJXnKGoYlII5nIdoKchW9Rf8N862/5wJivAc9xrFohyFGMkB30hpzvHhrarDL0Jsjc95aSEPfEXzOL/P+GtuVgeOcbgyZsxaEdgjKcg0BZekQyV23y92wqq8r9/pIc6SkB2ZnDrS1XGyqMDnpWOEe8AYSpIMU3xHQJIBQm3a5sjwqLxuk7iPcpKw38kEzBNe8o89Wo/8e4mKfO9Zd3OE+IvTN3GL8fNHyBJLdNHboKanowm8zyEfAHMBIZhWSHjtame8p8vTAOCJKghj4OdceImkZcA/e8T881nabtnNNYHduUPGqWRrETWnNRjQPthY3db/AA/4I+kXKNqYLQ6SNNLQV7HifhvnwtPxB7thRbO0w/b2n3gyJWtCkLYQm4vHYxwwVZjLyVdoAjsRPROyzCucwK0d3TShKnmlJmHYDesUcmqMe84XKgZEQxSObaIZdt2Y1JUHXv7pkfC7c8VV8Sn5kBftv7AHrAxuMA/f5WftDega04hI85DErV/Lnad2C6B6VmnXFMK6ffSqBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9mzQ93nerBJmndVcrIX87yUt2Nb+H2JttKR+0k4XP6uQfmR4PyUTMphOray?=
 =?us-ascii?Q?MJJIq63Js6HWO4FU/UrihP8b/U+yhyVh8mZh8K79Pgji6R0+F0uIvusbD25F?=
 =?us-ascii?Q?PJMTZGaB/9pSFodBoneZHaM43WPrJqsbetCpHJoTsxnTSW2f/dtLjNeUMbUw?=
 =?us-ascii?Q?1ulbL7DwEIGjIt3zDxfw35hKacyoK5WhOgTUq2xnPBLk9fRnkvXhKK4tQEIA?=
 =?us-ascii?Q?vwi6kW375dFj3dk72C9zTXVu2aDdCJhMYwrtbFi1sabLYCpn2W6P11W0W6lP?=
 =?us-ascii?Q?Iu7zMFYuvlhxymuBSMWZ1Me7QAHCJ5CgxXLEelPvvb8ttKlExdWXp94YERk3?=
 =?us-ascii?Q?Pm1KsAM5vq9k1Gi7apIgmXCb2FjUihSunhmNJBjNTxbvyap0F1MpgmjeffiU?=
 =?us-ascii?Q?IshqS7WdOwMRzN9vroymgovgRN8iirvSAF5uKXm3i2r52VZEhTLJJtENuVNT?=
 =?us-ascii?Q?6vCrlwa1xj54+onVdCUSu8M8rebyUBdp3Klt7ouhxy76sOHW/iHDmrc7hijv?=
 =?us-ascii?Q?BSKs5R1yLqT2phN/c9I8/4N5R1d7v4U4haY1VPC/o+bzIOacl9/DdcPYB5bN?=
 =?us-ascii?Q?pN51et2oE4rcvzhBFvoZys+X6QePTN9p+62irw6UF1KWapKg5uhljOGLHEjj?=
 =?us-ascii?Q?y5ZVOJS2LliwoZtq6XQsugbXf9BHSXsAkYLcRxqHU9dcylU7nnFGfIRqlmDK?=
 =?us-ascii?Q?Ccf0P+CJZNEA2TnWb8uiD4wbrisTV7E+oSMrikjVhfrnf8SEvWCX5AR/RArQ?=
 =?us-ascii?Q?IqwtfrSJGHtPjyeL3Q9HRQHB+OgnPBR0hxtJSFWeXQSDcsaBnEZPcouFzRDW?=
 =?us-ascii?Q?iUcrKE9gC7JQGVZhBLZclKNzzPTEy5CuutQTttn/Wktb/sJPYnmAiCrAo1K1?=
 =?us-ascii?Q?nDKZRF6iZnY0+ub+v/A+DVOspOj1utRQxK1+gEHJ/mL/Rc++bgD+dxglk9Bg?=
 =?us-ascii?Q?sOiKgJLg66/mmHsCLbC6Ut/D0BKVkAvKfAt0xq0i9VJl5DI0ZXhy97YQW48R?=
 =?us-ascii?Q?Zk22OAkBiMzDA3ayC9cRXb4CJexFGNfYlnHexxmHGF0u6vCHqHR0ruEQxq75?=
 =?us-ascii?Q?DwwKyeuBcAfw6CTvMuGJL5PZR8cKclFqzAvk8I7UIvqmis6+FOF7qIF/nnWv?=
 =?us-ascii?Q?CkYNzhIxXPXeB4VpjUjSR6PSQ53oWoeEAoFH8fKbnyfL6/MojQwyZLcwLocL?=
 =?us-ascii?Q?pkXr4m9LIWtkMQTA14O4Qk0mOFwjp2WDcLRMFZiDewZbTQ6mxhWKY8kMZoz8?=
 =?us-ascii?Q?p4HGnJKdU57K+MoDqKUvQghrk9vqHTP1EmD2QOoHV50QjgSwzNEt2/YhVr64?=
 =?us-ascii?Q?cqxbmH2MTSJuFJv7PBjnhHXQlZZ78Dm+IcSKW+27ScRYveoYtZwfAZablbpP?=
 =?us-ascii?Q?q+bfMkmvl96uKAHzn7PhpGoIxfp5UDk84ZrQ2V+VveU/k9TqJO/W8DwUZoYL?=
 =?us-ascii?Q?BFb/AiynHAvIkZ7QyIyrGme57E/w0FaXUecJCrLJk+AIImwjTUdJfsBQ2BTg?=
 =?us-ascii?Q?uGKqfhEyvEXx2oornNgBXs45hZlI1lFnLiMtaQhOVl34cUFuyM5Qjc1GH6f1?=
 =?us-ascii?Q?fRPkiN1biB9MbGnaUmER16zrIzUw7TKX9Mmiopz4FgWckg2a4Ie/llIoGMiN?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f48f67a-5367-42fb-091e-08dab4a34402
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:14.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MBriOVNPpIiYSCnLu7k+DSaiONRd96ChSOw9Z6PHlMkK0Mw0mI/XdWfodZpSG6SHlLnI6Pfk7Q9/3G9DeesF6s2wNbapfgZg/A1OFekis4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: OOZ3ETRhtBPlIcxVob7JR_WvX4rvssPd
X-Proofpoint-GUID: OOZ3ETRhtBPlIcxVob7JR_WvX4rvssPd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e2ebb0b065e2..3057f703982d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -413,9 +413,17 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = argbuf,
+					.buf_len = argsize,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -497,9 +505,15 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_NONE,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

