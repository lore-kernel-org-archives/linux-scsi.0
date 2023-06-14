Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9239EEB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbjFNHXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbjFNHWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897771BF0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jtwc012000;
        Wed, 14 Jun 2023 07:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=9kxRL/3L5818INNUukGlChZwr4J2ylT0aO7E7lH0wDY=;
 b=EALrADZazRIC4WhgxD367+8d9JHvQeTS2EyZqvYkz3u2LOZawN1bRLzWXXgbjfhN0XId
 2r5XF0yefs/hGVCuEH7O0n3TZwNpcjPa0JTC/WcXPKWjDa/jswQe/vIlVhjs8ZAMZcPD
 Qdxz/fUIbTyHpqc/r7p4OJD8PGuojJGsVy4gqY79rHlBsF5DD2734Ta2C/ereLjzdLFF
 NMb136qybynqPSpgEVtJg241KBTAYd6mDcUnDGnCmFBgGlE9eU3UXIcPNO+wr+nIVZ8Z
 tkcWBQm8AgPNNhf3YQWRFat9lW26iGMjt9L4EAiiAc14uJ2HmeIZEO9U16AulSNQusvI 1Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs1xxww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXS021593;
        Wed, 14 Jun 2023 07:18:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKa2r9OTU1Gaf4LM/agA4xtrgYDKcR43RC+pP9dtpi9tlRudOVFgJNeJ2xZ0SQYwoe99NPN2AdugeZeOOfppyj41zk6j3BAw50TgaUBaqw+LHdhUYAT4O3cM+/j6LQ8esdrXdr14A36gTwWfgfKXnGvFZasUEsRNYR84Bwmgu5zqSmdLAJt6qI3tsv/JLzKyDU6fUVc++8cjE/eTKYPJ06LHkuknpPCsABg0/BBlM5CsW2ce/uOMNPNCagTrybyQHZ33ep+KP470Xv2bLO/z8Gw/p4KJhk+cOBGTsSAhOISDiclooK2htedAQR2nvtnapMWremcO3keYDFVBVUQy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kxRL/3L5818INNUukGlChZwr4J2ylT0aO7E7lH0wDY=;
 b=TWF1TLjSk8j58AeN89K755Hrt6Zc6/8hna97Xwp3GdtGMtrgWCNEhGfenZK+/lnopFulSMMwNMq6Ws7IJDdiyisXFiBm6G1Ew/iFAFYdy2pDzI7J4qSSasSB2JNUFZUyOpE9on4CUS6mUEALLO8jj8jJEPxWfkosecCOoqQSToJpbeuO+qHYEPb0gVrap5JWKRIpVO2S88G1rVTAS4PrsQ4ARvEOIzFs7DGnI1xhTZHsJzscFIetXUmhuL8S6h8FvI50DmlDrtIo1A2DThRDcycKA3tCV5LrpoRxlPhP8hVYXuJfbNRNs0D3ylV5jHTUPVuNG9rvpXVi3bMTAwLwzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kxRL/3L5818INNUukGlChZwr4J2ylT0aO7E7lH0wDY=;
 b=CdsP8RExJMRaYGhaCly3PwVHHBCwASzVj4tjEmkcBYcz8EcujZBKdRtSSdkV7231FzbeXnLPfq9kBR+5pyJ2SBZdvPuvP4DcVcmc9iaVkoE18Pt2lxfi/Tda9si1J6t5CitH+S+f8/09cPcvIhlGkRFmYd3LmkIrpTH/8j6+A7s=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 27/33] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Wed, 14 Jun 2023 02:17:13 -0500
Message-Id: <20230614071719.6372-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:4:60::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: e2891bbc-92c0-46e1-4186-08db6ca7817c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4BEsudXAe5GbP93uyonLNkThIsKNFhu5p2EeC1afHxEVpbSZzUPH9vr1P56eQnxOnnUXmPYZVaXHd96Z3n7dElMjzN6yJ87RQWNr/BUJ7t7uH+Yk4899IHmmFUN51oU7nXMW5CwdUQJi2B7fu1FApIy8cV0KZ7W4HMzwp2Qq/p119o9CpEzlKfxrey519AYqXoPvXdjR1RKgzh4Ri5dWi9vhrxrBnp6qZ/tL+pQzYJJDqQQY5KW2/EJBZtFZjXDMcxxdUHSOaWXENTs5aXbdcPkWYolQoywfxyXgMUvoY2CU04ix3MAKlQM0sVo3MIMLQ9Z4snxKZZu7ryidnrGTZCnFaX2m2wTkCR6RKD35TIBkQvzXsx048vvlQwtdeXC/d5MeQ+XuZH9bywTi0aGzwNzjRImqJdQ6CojtReCQVR2prKxVGZ+JLCTuXA0ZwT6H+hSIyCsRha5/JTygeGj8UzfDYqgbHpGwHuutQAmwDfVwZhj7un1kr06ZmFknO4gdY3dRKRnHMrPs/nWVeZxey3uSAUd2lDZ4dBAQJbN/tjlWwQ+h0SJ7nktuY0GrFwk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HkpwIIi8Khml1NOOWEpv2sYuCgrh238mMShoAu6huD4J1qzGqYMsdGwK9/sx?=
 =?us-ascii?Q?8kSnx9tP8soWqg4Bfirh5ENsRA4YMw3f+cDXmZ3/QD5VxH5mtoKh+97JZOGZ?=
 =?us-ascii?Q?ywvRWhSIViFRf6Kmulr1morgRb/yuhU5I0CPOYaRcCTbnRlL+lplgyvqWAL4?=
 =?us-ascii?Q?fKmp7+ag8t05SSbSBEdPGeVwKarwyXXhuQGblY8c61FqqNV95CKC0kfB8Q+g?=
 =?us-ascii?Q?1fUTXrf6IdsZc6YzJN6aMqUte4mjlEqSpjPTuG+x8274XAgUcn2QqiK8sCym?=
 =?us-ascii?Q?eEFY4EvHtFcEHcG2Pb94YQ1l4+g8++eHdfKsItrf3k2qnypk8lhyDg23YfEL?=
 =?us-ascii?Q?wYnGTaiVJj0p5R4S2wzIs6Ka6IVT+00IiaVMdEck/Hjr+/3zcd+W5WjRUXjk?=
 =?us-ascii?Q?+s14TV3WTk04aRbW4aXoXnyazTcSrKsGswT5AVOCtelfeVF1mjnEu/7a1rI9?=
 =?us-ascii?Q?KeFZlWeyx156tH1LaXvNybll0aI8Xioyq4pRQKRrB4K4aSne5DpcZaL2tKPF?=
 =?us-ascii?Q?laXZRt0SQNeb5sw5Kls+uKlrUJZQZQ//2dPHgM6qdrFilWYWPs4oBPgl4UEP?=
 =?us-ascii?Q?yGviDCCevEq9qbROoT/GdoxP1knztn0oZXrSYg0DHpnpeFropZ4pcahfkj9e?=
 =?us-ascii?Q?BlGO3+Fzg18OlrFzCR/Yv0jyX++apJh7B1v9ClCMixLK/s7u/QqG7RosIVZ1?=
 =?us-ascii?Q?X3ZGlpjQDEgv7CnAUnKDMCOy6EvMNP7IWeuT19eAtyiM0sMJooeQMxd93li2?=
 =?us-ascii?Q?CGU5ma44ivVkJAatrPPnssshdFhEEJQgJja32z5Uzcd+O/7uwfQQLqALN2Zy?=
 =?us-ascii?Q?oXJgivIxnAtiysAXZBU3iXH1tQr4SJykn3iJbWZm/fPl4yINcQvrDdL2Rhg0?=
 =?us-ascii?Q?twKSAmM28mh0Z/HTNRdXkws2FaR++6ps4SqJxgGj2piatz2bpfyFZBAKJnI5?=
 =?us-ascii?Q?4ZcfXpY2lPumxlix//+JqmXVXR0LImlURrRyc2Dflzww/mIa9Ea1B/8fS/Hx?=
 =?us-ascii?Q?3VDShSEnp5wiL1fY09djHXW1SXSjj33IT87CTVJHEo2wlFmGtW/6cbYwxuZe?=
 =?us-ascii?Q?fmuCPLRnMCFMXIJVXgB0TjHEZvaQVYb3Sr4vmUrhv6CNCdPMsnEHMVhatSvF?=
 =?us-ascii?Q?u0rzPbJ61UDogs9UYijNYn0zEz6qet45fNKzh+qaNZUCj3WqH+qxF+SPsgbl?=
 =?us-ascii?Q?CWRIAyGqyZlzN/S4RZjWvPMZQzWvmHaKzhsU0IvMg0iXj2t8yp0Teq3mJ1Lb?=
 =?us-ascii?Q?dGl0Kq+SGTybuqL/swzu/ZzEvfJF42teDW0YpUVJq+xk4fr7uhEajuACpt3K?=
 =?us-ascii?Q?JAUAcSk3eUgjqJrBebNTGnDTL6lXx4ijFS0m/0vUiZeiJwP48xp3TQ2Qbyd0?=
 =?us-ascii?Q?EpsvlfxzQG8Ev+80qf7jgDDCVe4Qcfsmhbvw5c11taBaSPopEjNzAAIiyHya?=
 =?us-ascii?Q?nPeYPB5jZ3XFfUnq83GsrbDUX39jFdhiqPTyXW0xW3SuTl200qgD4jkCjHU5?=
 =?us-ascii?Q?xAefyDylAuEOqsVdQA8XLL9eY1y5xED+tyBqbllEx4232qdcfW+snn7kSLSo?=
 =?us-ascii?Q?lTBlQqC26cPyO6LSCvl+ecCKthnQsN5q3Gruu/HIF5Q+ghN4buUPK4t/N1eS?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gpPHUbREFl29upJT166rK+25n6xt9zvECLcGHH1j6eMANlLVuNC1v6U2oXmzKdwV39FRvz6Q21wPVexKzb4Py+ejjK0Gn2iK20/LtYPNg9XcRoYPHnFcWOEux5kLSnC24Sde/d0pjLssSAl9b6bjLLas1Z57EQk1VzkRNB0YaJfqeUhmXqCyoMvRZDDx4LMWtqyypdT6V98wdf1867EO76NR/kZrccjLiZgOs41mWBoIRv7IxW8xXAkYr3Edz80igSyygELM27C6seWlpI1BPvNjgwb7EZe3Z28gGN/I0ULqnMRaCFxW4zOuMPzge7yhbSCqjN861WCDH15n+orlnTj+3GTnRY3xQ/Lzt5+BxuSaRgMiOWtc7NFWSVLpCUsoheg50q4wg2DUBQLLCc/RlWL0rx6LsNqpKwEbyTfgksXT490xyZ2i8sRKdvU/B59iFn54Xa2W8Y2+tD4UeyyWdBS8njiOlr9etRE9YwfhVVRelVJeoMSqonL7f0cVr9+DoFYkU1mlBxq2OsaPyjpuQdWu5CT7osdE+0sTzQOb5t1CEpS3PCYtQOZVXXRdKWQ/qZM2Fb4zWimTNoPGBAsXogSrIZn8y6QUrlSw+w3WJSR01HDzHRWFfbcBTw7efcMlFmOf5XMqegQ+ADRCjUwfzWmjMhRaGcaijZTrFvnS2oaP/B0Zvp/xNWdU4vw2aI1PiVQzdRtbHvqJi0Pkv2skNThjCoCNFgCOl72plw21lLW7WHb1L7PCk0Y4+JTHxSRyWEvccaCFVRgkmKRoDgzjNgxfRVLqh5CDpRwaALLHFtvy2Mlnu+WQCYgKc+6lLTi+hi9OTDYXv26C0nMg9HxkmXMcqpEK0/SY7FJN/+hzA+9ffgWs3TBKnU13lyeURMCl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2891bbc-92c0-46e1-4186-08db6ca7817c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:09.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qo6PhXv74AueTAWhSjd1wv8bwSakNUIITwdqPZwccZMqMrLk8WMnjORFIV617TLEwCJZzFzj/eFSjnuthqMWLf/WVcd3MMOLHCB/7EtTkm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-GUID: yi9DdDRI_QxHJtN3aAXWuPtzd8-Lvg8H
X-Proofpoint-ORIG-GUID: yi9DdDRI_QxHJtN3aAXWuPtzd8-Lvg8H
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cd5b08689c1a..e572700e8338 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -716,27 +716,26 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
-	unsigned char buffer[8];
-	int the_result, retries = 3;
+	static const u8 cmd[10] = { READ_CAPACITY };
+	unsigned char buffer[8] = { };
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = failures,
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
-					      buffer, sizeof(buffer),
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
-
-		retries--;
-
-	} while (the_result && retries);
-
-
+	/* Do the command and wait.. */
+	the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
+				      sizeof(buffer), SR_TIMEOUT, MAX_RETRIES,
+				      &exec_args);
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

