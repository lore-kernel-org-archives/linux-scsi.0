Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28356C6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiIVKIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiIVKII (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65453D58AF
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3qYG017964;
        Thu, 22 Sep 2022 10:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=urWUAl/QzsAsOi/LkSvKLqSFMiAzbOeQe7iX9npVJgU=;
 b=Ulz00zaU4Df2P6lvLeEeQiPGXealgfpCF2LH++7dRc1QVFliNOzKuTbunHIOgJa+JGbq
 9HPXSCGsP7adj6eQOxVymMdl6RFo+YCKX6MepK7SD++eoB2TNBcCjUKPOzqtFUNaJZL8
 JjyYzVhftteeHVUtalI80HYDP1DiOLMDaxgLhb7rUtjh/I7IDcXhwUCjOz8MaELDj4Dm
 UhV6+QBBsPWGDmH/nnIOH8hgf6TF6iqj/Qlut2wKUH6DimP9k+B1GoY3cbnD3OGJ31H4
 h7vajiyEkziHQTynSW9geM+nM/Q5oL8ZBeg3Td7CnlK4QILepwk2sXN+6+eClOJkpp41 cA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3sR028140;
        Thu, 22 Sep 2022 10:07:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cqdy43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuME4/annVkJNpE+oL1Sd6RllvNWmjGJ6CcmSPYccyz7oJLndTNXAKjebH2CaKrO3+LMeVK+yFVsuKUN/OD0LFEMTuGoBwLLUPc9oK6tPv2gIKri45aUfxe6Y6iLgrn0+YPvyDe1k38A04I5CKT/xqT4piWHuNgjUY0JP3g9AT/5iALggp6ssPbfw0mMdkH0y2NMr0u1C9UDpzWeBYmAJFa1lhUwDf4RYqkafGnxnq8iiAVu33hctSCYRIJ3QLuXgqOwKj9PAOfEBvxZJHarQs9W+wO8mDLytcNBGG+VgbCTezTvHBghWPlFLv/891DfFCr9/1R0wAneu6LlVPVMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urWUAl/QzsAsOi/LkSvKLqSFMiAzbOeQe7iX9npVJgU=;
 b=mU3Yistl0iQlckEjWUEhvaqmx8TzqPSVvc4jd2B9NRf+lgarOf8l4DN0dXIpObMx4Fc7fUmwcp86HXlNZ76Dihm6n0m2KHsnefQ/tLATqT4c+xK6mCQoXaYrD2Pa1AeZEiNDIrTXJGemwNLv3MZlasWoRQwBMHwMwhd6xJZv9dpvGKmy7A9xWv0vc4mUj0IEsTJs0fRfZq7sZMOBnCxdLx5uwM/9okKm6dhl+fH9LSwJRI62tE9bLadRLy4eDf+6CsB5kz6UeCfq7AKzvABMWxNIYhhwrlePRZbKQ7NCDhn81FOIJSK07MnPVrL+UL5eKoUvYse2lyTnrv1qBU7dQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urWUAl/QzsAsOi/LkSvKLqSFMiAzbOeQe7iX9npVJgU=;
 b=odFyLo9ef9rFNp2NF+whX/byD3EcvU2kzSp3NyL0XeBq8ivZZLtueFu1r6tuci98/cvGpeEb0pVSOYgmaR4sNknmVmbhwUY4LlnrbWaicEBvDq58nD8HcyU697Ivk/WReq9c0g4eOkm71sRVfmvvZ05yzYE2Y/L+HlOQ/5hzgVs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 22/22] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Thu, 22 Sep 2022 05:07:04 -0500
Message-Id: <20220922100704.753666-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0030.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: fcfeaabb-d182-47c3-6309-08da9c824992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0penWBO0mMW3xQ17DG/QjTsp4bcP4X0Ay1brCuySJS1NbZ4VRUGqbLxqpgQ3fxx5GkZv+t1sA3mNtj29At1RanjE6FxjlWF5/W6LoZ7Nh3ZvRHarZL0ghQI2Wd9mk+y16ildOpohUiLwJxF4SzBupWnJwn3A2w7hwI2ixi7nJtZVy81qBUWNDGPmmEZ0GyYj0/mEQKhTV422qWi1dG2YP4g6ppJlhjF2SJ/8N/PoK0078ayn/oLLKZUFiImJsAkiwqO9VPmsDP5rrLYAp+tNTsUm2MEHhhWj18E8/EdQcc/mdWl7uWbfSqEydr8S8bQuq8Rz/rYeuoXbfbp03oZaZ0ii86yFlVDK71E8tatCB3o+vkHTYrV/TljFD3i4MqkvGnRbR1aM7FeRkFMMt8myK/oNVU5KlHn4jrquBNmekPglW/nw7qST8XKcRqeKuW3jY762gMqdzLwo5YTGs8h112FJuqgHoqwKmkgGYPBzkaRiN9enxGxygiEB2UReOlkqffClSvhhpLdKF2/AldNyXxzE6QPe2De6zeaLhyF115OULNUZ/vivmirIBTv/xJKkJwWdrNQzFpuh6BhLq3dh9/9+uKfZspCDe7Y9lui/SCE5Rowx9APo7tCaLXEU+4DcnZ1V40zKa3uhrwX1BLvyG0zfnVFDFlBzry2dkn8vwtS0i2xWIPxDb6+h0L5EF2J3CJWiSDe34HqZFrobfvT45g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kxkJdxfmcNTlJjofC+YkE7PPKKyVXrmGIK4wdI0StoGthrIiCZ5CzgiS81+h?=
 =?us-ascii?Q?9G+LBixEYy/z9j2P4vbVJTkUE8WdKSLHkEXn86w0ntRA8CIvFmYB2xrWHPhn?=
 =?us-ascii?Q?Cm+ldYmUTC6d+6b4fzyUf6wr65C2LjB2J7tcLMyHEx+CQjlrI8S2cGzXweTZ?=
 =?us-ascii?Q?jvDPM2ntrfkz6LPjvtOKZ1t/dz/bgLPSjldAe4YsL5f+UShhjtuAIUTg5zmR?=
 =?us-ascii?Q?etX14EyYgsAT4IBztgnkvqtw3Z77OGRL27G/oRn48ZIn5caKgd3bUloXhMK5?=
 =?us-ascii?Q?y+11/yBV1NAxMHgS50/OHFWQa6nHSnkt5YUHgyS+JLM1T1I6qV/i3baWq70j?=
 =?us-ascii?Q?fpibsg54Cs4aF0RMSdwxGDNATR1bprD+mU3DgPS3cvCPfYiukXkjh1DD2Y3R?=
 =?us-ascii?Q?pwsyplxJ/NqKfylB1LDYz+b3n87hP5LITqRaRS7D992b47dvmun5XhLpeVs1?=
 =?us-ascii?Q?FJ8iQ2vRTkJtGt4uzXnpDlqykAsNYUZ3TG7iRiIfbME2dp3UxAu4/oBD7nqO?=
 =?us-ascii?Q?2lZp4zJGQsaPsKmbBajIsYWtdtBvyJfrvODNAWkNkTqTaaI/ifWs9bM9jXtb?=
 =?us-ascii?Q?K0Gk/D2GC4qVNbWe/FplNBBj6w3FOi0F6XtZugvbOrqafjj6scyp8l8g82jM?=
 =?us-ascii?Q?p4pjTxzUpYr5ZlmyD//lxAVgDbCWVzBz2TNNPEkpbNEj708yBNbWICeVUr2z?=
 =?us-ascii?Q?9FOrdcy+Rh5B5jMFN5hGr3PCRhDbhfYgyo2eq0XH0wPwoCcbNqdB2x9rbNwj?=
 =?us-ascii?Q?TzcX0n8LfTMK9GBcOz4q40b7yVwvEabKoLrKSBNQuKhgsa9W6EvyDQ27qx1I?=
 =?us-ascii?Q?0YJtzvu7TnCOPGD9Qfi8FLJRiAt16G1g1t7zjOyvW0esrD0pKHK1Yx4wqI+T?=
 =?us-ascii?Q?MS+PNd+Uxe5h32o7qjCYi8h0zMzWAbBUrWibSHYEtW7wpNpCSGnZTB4MRYuC?=
 =?us-ascii?Q?4fxpK6ljUDQea44g0XDhMcGmg1KVslRDx/fZornC0oK7PMZ4QKseWC2/CwiS?=
 =?us-ascii?Q?aCuYfc3XklFUfsTQZW5Z4vgn24HUacpO8sWKP2+O5zvXdabMzNuY5OuRDhwP?=
 =?us-ascii?Q?NrRz3fSeMWdVes0namxZgZxFuTKPFrcpI/Qh5u5C9VZ+H/fNUHQh1N/hsEOV?=
 =?us-ascii?Q?ZPuaEkALrxOV3oeewJASfR2WIM1t7ATlxk7jSTh42Lp92OvwP0/DDyj/JV6/?=
 =?us-ascii?Q?VKX7EfPgsqZqyutSHMidlI/+c0aYy+eS2A/DvWIZG+bmQAhbNahiPop1FTxX?=
 =?us-ascii?Q?wdaW3JGGToA7XDYtRJ4tcQGeHOfiLCdjE+26WpXqilTbBtIhebIupfuUogb/?=
 =?us-ascii?Q?1AmXSwmZVI8oZMzGcMPoVo4uKdN/VY9Lb3fGgFHfhphiI1qrHylkQzgp1llt?=
 =?us-ascii?Q?UDOMMd2cFndlexldIAGxKR6bhpp8ASEUEENmnL4a87M1K6voDKzA3zefwpjy?=
 =?us-ascii?Q?fsQ+HaKNB/2bRR/1Jqpk/fWmIAHEZ0sSTeT3g7XqC8L+kNnYJ11n8jJytIcv?=
 =?us-ascii?Q?/hn7BULGTPipK8Z/yWMW0vcvaF1n/4Tb0ovRTYMb+vbmCafeL+fyiEQG2rud?=
 =?us-ascii?Q?pDrJI7XcmkG69+YguT7rP+x5HzmFXSF5ktLjprwkd5kANRxKdwK9lLnHH/Gw?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfeaabb-d182-47c3-6309-08da9c824992
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:42.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgf81ksX9zX9IqeHbV1PaghuzfAyYvU+aksHBFqtoplzZ4pee6k0G9GilTi+ayKzm+Uz0Z+DqmwbkwfQaVIqgXIUi6JZwew/UinM6/ZY6Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: -q8SbVzPudPgFdIbrZ7vScBH7rDMqQCb
X-Proofpoint-GUID: -q8SbVzPudPgFdIbrZ7vScBH7rDMqQCb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8b28a8a28b45..cf1f498671f0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -720,26 +720,25 @@ static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
 	unsigned char buffer[8];
-	int the_result, retries = 3;
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL,
-					      NULL);
-
-		retries--;
-
-	} while (the_result && retries);
-
+	cmd[0] = READ_CAPACITY;
+	memset((void *) &cmd[1], 0, 9);
+	memset(buffer, 0, sizeof(buffer));
 
+	/* Do the command and wait.. */
+	the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
+				      buffer, sizeof(buffer), NULL,
+				      SR_TIMEOUT, MAX_RETRIES, NULL, failures);
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

