Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63213CCF9E4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjIEXZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjIEXZW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:25:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901EBB2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:25:18 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NLEma030783;
        Tue, 5 Sep 2023 23:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AuWYlHZve5noSws6GJ6JdOTq9eIJjpSRYCnVg/PN/Aw=;
 b=KBEUZTCMZlfav8RzRmuncF3i8oSZegDT3f5dTpkbgcScPBYgFLXm449dg4D9qB4sTFe4
 qWyohs04lgE4UtYHkSkA0BDWmXdmUoIetYkWM4/f2rkvngYhcUMn3tV5SNvJmT+cAzyZ
 ssvjLBJ+pLxAzETlmgXrWXK33mz8lpQSOz+mVs81+jgFGN6oo8Jt3JD022AWOO5Up0dD
 uWJh4E036gn/ZiIsMfzyzRIC/EBaxySAFz2+4O0bMWxRT4wifznxgFd7358ateATt7OV
 5ft8GbFzJp7fKDAqGhRZsfG8UMBOtQmepfa1RRg7dczmCG3NVWhQSCeP1EyL7ZiWDVNA ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdwu801y-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:23:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M0SBj010376;
        Tue, 5 Sep 2023 23:16:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbp34s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CW7l4PvHdBa/6y+Fg7RceJKStCVlqcVRWd75hlv3BsRcGFAiNr+pai8TTtf4BifdJ3RIrDFPAZm92+nWF5VbyOBVIQCmem9oVpkVhjMblcIx0TzHLJs3vBCvLl72Pr3j6vD2P9YTM8QR+J8Cnj8x1PwdjNg7aYbfmb+AFt7WWtwupqeQBEWE9iItWxLqwPeBGDIh6B2oS8495Y8ijNuaPhXYMypqLK19i/jvNnLI8ymmHmrITT0tzAIvCXIXQAvPY/L9ozk7EkFXlUBGMsScL2I3e/CH/TV1MKtHg2Nh9zyopdZztKEU0na/eN7JkG60zG3ktNRKfLF0EQxsnNsQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuWYlHZve5noSws6GJ6JdOTq9eIJjpSRYCnVg/PN/Aw=;
 b=j8hS2ekoQYmM2apzv7ZbIi0koBxxNFvOeAs2BtHUkia1E8p0Ic7vjoGZ1eUKXf9Eyea1bLw7xSxI4YhmJmm8eUmIEDgMt/mcqyBc94r6ljCRnh0LJfZBQlQxy2/JZlGraHw4eaOJyuArTR5RgPEmpPWrmiwGGbVfC9cpcA7K9jMR5pWdn2kN/floUpn6XM8JHcjZHudqOxY39Ob12g9AGlIODleG2M1HiLRL6WN56JUH3m0miQH02GegNGucg/el4mcMQUGzc67o+fO3j5fvHuBHfhi5IjOd2kvO2LD63j7XoQTjFswJVZGomomFbPkvPrAZaLwXlp1AhkcuGGuwOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuWYlHZve5noSws6GJ6JdOTq9eIJjpSRYCnVg/PN/Aw=;
 b=Hcjtou4fnxmsMzBszl2x4yJsVP0m57Co3zSHX2/7oq9EXUp2VWIoB1LYNatNQ4GGX2ezsoUngp9jMDRKruuo5NS5DAhsSbd8unDcmtmHrek63lNFpxzPqi4mmUOl1hbvLx9fM4W+g7k2alBrpDZeg6f3C9y0dc4zEKO3Q7TAyIU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:28 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 21/34] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Tue,  5 Sep 2023 18:15:34 -0500
Message-Id: <20230905231547.83945-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0108.namprd07.prod.outlook.com
 (2603:10b6:4:ae::37) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b5e13e-3d18-436c-7c77-08dbae662233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9vRqTANYLB57msjlzUKQvU+VY5iDvQQMHfSt0jzPEF3oXIYLKnmYfhwSHFypRL0XQm1qd8FOCpRwnq0Xshz2GwP+jhtq7rwKu+Ne0A3GQdRASoGhU3OOWfuQNPt7nZxLSDjc0XsiG4NzmzcxoJCDdiexs58cTADifczS+YOae0EXf2T4AlsiMlqMbrFQuo/gH2wAa68L8K6tYd+AQUXJgnWnr+97Xcta4ZgxwySaapCau8hH/mhJ6J3HfsCH6Sq5nBIa+uisBYdtfxQnByA6waR7AWhJE1DkL+NRkR/ILJZlzmGha/73BoiXYJjFGPjuLTd3lXD7ViR7wi2hjtALafIaXGWyuHw7d78zViIseA9/fQm/s1ffVAX5dQhdPTjRhfkdETXR8nZLEjD1AqPNFL+5KmAulG837Tu4GAaJxwGo8FstQgRpNL2cIEy3AgoRTO1uyqHxMi5tO25yg3Wh9JieIJZh6pL9sGzINfGv0Fxit4V6NI5Z+5KcnLs4R7n/TFTkG1atmLLWSuiZxDdPiFGN60YzkPWwA4ld3MNTfGlvug7gci0V+yAly8sqABJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uew2dLvvdOE01oRdLhh7hnUAKF3FrXp3JwI4waYCID288SPTLz3+uF2czPva?=
 =?us-ascii?Q?4Al25okA18zdEzqmPM23AhbTHp4G+UnO4voUJ2u8Mgn6490/KFkkdVSVG4dD?=
 =?us-ascii?Q?b78rojfYRiQoLBfGm9ERl4z6WeQseAZiYsMSY7Bv3dZ7v9n05xUslZ0nZkPd?=
 =?us-ascii?Q?55YvUcwyMMOvIaKWWiQNQdc7vFWpKlK3ZBZbBd1xxxOuuvgM9hOdrVxGy7z4?=
 =?us-ascii?Q?qKRuHpQWKzn7+ln5ORB1u/hkQYtX9LaznH4o0UXyuGqsoPDj5vF2Gqq8IL+w?=
 =?us-ascii?Q?RlTKss1GrAceQDZvMZiVlNSiiikG6D4pPIjXubyGO3i66wr9ASNmEp+JMa0X?=
 =?us-ascii?Q?E9lymtPKuM2Hz2aiyl7HnWJezW3R9qQazGCEDXUQKZe/05Z+yhOBDn1SwCzs?=
 =?us-ascii?Q?6zqCYMIhijcvYuOHo+ylzRW0u9+QMTbe3RmKFx2CW5vsxvKNJ+n0GiL/U9Sw?=
 =?us-ascii?Q?11cBasmZksYbcFk+4L6WMGx29Eo+8sleS1yYC3iLEHukgHNq6BQ06owi5DS7?=
 =?us-ascii?Q?tQecP1moRXz0ROJwreL1EVA6yyKl3t8XzddWkWj0rRf5tzM67lRIRssCtx6S?=
 =?us-ascii?Q?FZuag/Am/tt/JPnjvWZLM6OD9mNxLhtJECIVoGsY1S7XH7sEFJSuftxVzKEF?=
 =?us-ascii?Q?qb8zv59ScAKchXS0QwCuK2G709PFsx3xbUqLpIddURizBMU2KGxmsKNpLeaq?=
 =?us-ascii?Q?ZLcrPbKuEjpMSyA0M7kfm5mU5TQlkzJa0ppqYpvfHY0XAuHrpvsBzQgrE+MX?=
 =?us-ascii?Q?i8PSE4itBWPIT8+XSDatoWQdHJmP8kFI7205HnSRXJF1iMkcfJXh4uUIMway?=
 =?us-ascii?Q?EfFKaY7t2CryujA26wdPu696wpssULhJ+wI0DmEdLiCklfHnXULrP1dRW+62?=
 =?us-ascii?Q?kanERs6SR0jR8wNfTfcJP0nptGtbIp9ESWaVg0eHDUU9BoMAL5Rgm7vsso9c?=
 =?us-ascii?Q?tPdzc7Ke1rIPmOaP3gHGICkPZUZBA88OU+ahWYVxngQ3VpHuCY3g7rYvf3bK?=
 =?us-ascii?Q?NknHGtTvwBTcep36+M4t49YweJsymqka1Df238BrDq2pAgGfU2oeEt83ASW7?=
 =?us-ascii?Q?bEM+gWIHmUixPKiEJ7NRWwIiBZ3dWHDqktKYmQcpNZGE9seXwIp5mJN1yQlO?=
 =?us-ascii?Q?T76WngDsFxfcOMOlPClxKjKrCDQymQ5KIDy5yaPysNV/u/pgoXnrTGyRIVBl?=
 =?us-ascii?Q?gUXmAoO4/AYZ2O0i9rfvS7D+ql2lTW9SAU0leA7QD3RdG8xBVYCsi3EygtLY?=
 =?us-ascii?Q?gMDe8nxTDcYEpUpRRifb777ufaui5yZNcQfu4oQb5DpiaimBBATwUDSRPjNh?=
 =?us-ascii?Q?/m/BssU1pvHQ6LUzil76BtuwyjOTE5Gj67U/KHNM+Q3wOPFRr7vSMmkoct4K?=
 =?us-ascii?Q?+KM6mgYRZpUS4Lr7gOVtzS8FaY/gzTeacw4PO2Y+wtqUFGbF93eAreW9APz5?=
 =?us-ascii?Q?BTGb3gHAb9n0ONCryZYo78f5KJdub6HcR/G9IWGue2jJO7+73dz5d7bGdKfO?=
 =?us-ascii?Q?4mSQ29SzFl7NAc953v0UfGe0f/kWpHNJ9adwpm0N5hUK2JJfYhUVByylAw+T?=
 =?us-ascii?Q?NPcyV1AzC3GO42qdcWgd6sMeD2yKEylwArFo7z8t/XEik0xqjvd0/sQG9Sre?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LlssVi+6N1uzUQDNo17LF+kGLp33fSjTvRSLWUNFrWN+W9bTaLF/MsZleIat/WIfQkL7EZbpLWlGiq1ghfnK1X9+AVMm3vIdz3YDxlui5lX/zzpMgcxtToC3mylVHTwGVmq8pxgS7GHPZVP4l5CXGCxblb2iGordiGJq2tJz9eSyVAhaf1pP8vV7wFdoJYAObhrLHi3hlRUHnozb3zQQzucp7LiGxx/iuaMBALWwQ6VEJ/6VHNnSabON3L6H0MilsqDJwPuB56eGxOl6+nS7pIo1UYF3W8UaR4pb8LYHMGe0iSM90nnOi/hY21ejEQkO2JRI3LvfgK1HLPLucWHDaPIaZ9Ky079KyJIm19aQN6iIR6xya/L7L42N+l2TiNg9nuDlzsJCF48fVCDgjctOrDnwoQhY48IDARDL4hxtE3VPiDdMeq6UyVbiJ78Iojrhd3f0s35xmlU7Z1pGLbiManH+3M8SCzqrpDx7OVh5/pRGvfJskNWrhl7JQPzzGJUBGN+rVlYupgSgAlndawHUHFovjhP5GazTgChMLdqGPtlsHftOW+h4xZfoi5MpsKcIPG6MfLtSRViw5Us9yIQKUZx49gBlVDL4hvW9OULQeggF5ONKlT70+NoM94fxs4D8sUcCm3SigwqiYKciGMWMLbwi8NfzFRGhgT5OU8EPj1D51OPmPNz+wSwNtMPH+34DAAVQETrET1alJSJ+0Tu42jJ1wf/4n7yG9/DMm7G4prtBmeohjyBZco0YifO6njAtGuL1A84eKFgG1kIvDcP8355R4hHOAxPkGEyAZ/29oTCHuLRyvPqky4wEIhzOqj4suSnjUVzmrsqfzuE6xMZ4qKNamQaz0rSftrrO8tM9jSy+FYmfs4yEYwSUAdFLcWei
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b5e13e-3d18-436c-7c77-08dbae662233
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:28.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLQD4SWfv4zyIaMigiSAWhBa5LDIVCeqU8yajnRI4i3hJc8KbNuyqzlUAXtxCCHhoDX2+THzbg35XSq0wpL2a6ErXyA5XHzE4g55buSGMcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-ORIG-GUID: FuGrtygPdt6NrrW_TvTjlQh-UlyzNx8j
X-Proofpoint-GUID: FuGrtygPdt6NrrW_TvTjlQh-UlyzNx8j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/ch.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 1a998e45978e..4412562a3df8 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,17 +185,26 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
-	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
 	if (result < 0)
@@ -204,13 +213,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.34.1

