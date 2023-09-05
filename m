Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E025FCCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbjIEXRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbjIEXRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBDE199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnVxF009289;
        Tue, 5 Sep 2023 23:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zeaxAonKaiQqN+p3SwlkicF8o+JQW42uspkAmXUybac=;
 b=oNCZXuMzwY7ktudraoRwia4D4jbz1/BjFujOGGtm4wXJAGbYuUw5XIqajYVUjjJYvTJU
 MONKHwx+mZ1UEMt1swemjnr8/y5ZSR5pd6exPBLyhkfnYDx9kISPyRTQh0QNC0NkCn1a
 M7idjFa+ez+NikvhAbNUFw7XvqrItlz55DhNgcTpdkX0aLw4a/bF8Y9wm4NQbU6iA+kv
 wQ3Kzwtyd4abMCVqtOgPvUkid2Og0jM4zRgb80YAlnqh7Z8y7QPKTM6AswcbthrAa2mQ
 ADISQ8hiemNLCBMdIbC1zF34Sm+bnWrIBMINRXAJK/wDEFmeDt54wlwa5pLdkPdXTjOM 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq3894h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwVYh028173;
        Tue, 5 Sep 2023 23:17:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e4hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhrY2PhtU9EZ6uBSSJpAsARE3/7qfDk6dJ0SqQpm/wCl9QBV1vUP1zkZ7/Y9z4RnaWgTOKAk1CEr6lvHKQTwY3+HEYwth71781IyiLUiQ8nITZdTDgVlLgSYNaVJ6Ao3MemS+e1k+/BFsTyaZFYgEe+j5OcDESMssHVhSLVVcST0uhZWa6Dj5EausidK5V13LaNxKtGb5lQlpGoMWV98t96e3tmwUlo766+r2Oqbd1RCudZKDsa1tBHoX7v5ZBCOSOHIRL/woKALD77W3jFGxkNdM3P7+LWzAdHN5CzX3+orrbsf8u+18NC8kfMEkGK2A7F0c7puMlOtX1Vc2IMjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeaxAonKaiQqN+p3SwlkicF8o+JQW42uspkAmXUybac=;
 b=G1hAdYmRxNygUq50IksifycYxDPAF7iJkY37qPu19TlA5y6gGhWlao4JgQZVNB1jHgqPT+3Ks/U074YJ/TzsD+DbPVMr80tLv9893GO2L+eXhVnNaVbgR2Lf4w8rdzEIm4Xf67rfDKVSU5BdXKksjJij7kgpTyPM9bcSclGapnP0p3JDtV1777tFT47CZUB044YC/HQPBEl1AEO9s/lPYgXU3msFZPSLn9HlNjoX6RlAVAei9Tmr5bjPfF619B7k9djenkhSbiMiaXsk8N2E/ge45vP/fbIz9pMUcFBPytycWY8lMjiiXplDaGV8/VTDdxWiuAzTOwgWyq3fJNPv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeaxAonKaiQqN+p3SwlkicF8o+JQW42uspkAmXUybac=;
 b=PBKR6x3rLaBu1vBKVGR6ab6lX498jsALmMhh2HMbyh1hRPcTBJs81xsBJC4hZt4vtOoxqqMO9wxsIEVuLPClgph0CfImioahnguzmzsyqNPayhJVfaaHlOCnZueraVcrEb/qZ6p75EGZpDAFCmZKNp7PT0jVJZ2SIP+BRLHUUPA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5748.namprd10.prod.outlook.com (2603:10b6:510:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:17:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:17:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 30/34] scsi: Fix sshdr use in scsi_test_unit_ready
Date:   Tue,  5 Sep 2023 18:15:43 -0500
Message-Id: <20230905231547.83945-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: a4177ebf-dc66-4596-561c-08dbae662ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UqLUsx26ixrHtKekPaQQIo2DVG2tYnJVSShzrIZUNzwiV/AhaklDL0AwLp6HgCvYuDMQRyDuJGoCjHkn/sgzQRcyvIAD71hF8M84KZoGQwaXP6fLuDM9lADpHD0lJaTnBErOOF3MfbVciNfpaTa5eGDvygxbet5n2BhhcGc13DQiw88C8taFiGrF+35+QxE+4Q1sVkNKb5uzGcTGTPUHy29ZP9s03LscnWIuufF4OYoGdsp7Ez3NvrmiZGurhv2zKMe403Xp/fWy7JwstI8AR2I4purDC0nZJDhovB1p1M7La19k5CMpKUhXdSO9TjRWPRh73hgdjIed3y3oUV1+cBeaAcBXwdcEUTn1X8XLckwifJMiJs39qTS2rpjuEHqOoPH/XxNv1qSLCWUkomMlUyx0bmE0P7eYR218vMkDZP3fKY7l3nhzsFVPM5AIOirJDA8Dx0fFxKSDdy4d8o5sk0qvhwh3K5P7WWz3ZymVh8Tfnu0sck2wEA7Gs6gR3On/te29lABdkDXGMy8iz472SIKWSuJlK8a2u0a7y8qtebo2DXVRfVYJFltKOo/aEFqU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(66556008)(316002)(66476007)(4326008)(8676002)(107886003)(66946007)(2616005)(8936002)(1076003)(6666004)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1idkpEI8OaB1Ieu6+OlUAdXQQDWF2oK6wh7LiKl1IZDEwfwikWdh+H1TGVHP?=
 =?us-ascii?Q?t0o5yQWSq/foug5G4xiIYJfExaKCIZcN259witPmONt2ggatBcgWDTwnPzvE?=
 =?us-ascii?Q?IcPxJA/1S3E4LRBybvEnOEyu9qPQIhUOrKy16s5ZHF26hpV/rtCS6qmk+xeb?=
 =?us-ascii?Q?JrZnCL3xkd6Cq4anHe6aq/ukE63lJdpLB1sGx1Wf9NJNwfWMauE7yaSymbTf?=
 =?us-ascii?Q?awtMEe1xcayuLam5fNDJEaAMOBqiQXmRendSKZ7bpj0pqheODxI+NVbQHx4b?=
 =?us-ascii?Q?COA+6RtJrWfCCOars+UpRDYYMW7tEPzkmmOeKQwe65AgOucFOObb+W/HTLzy?=
 =?us-ascii?Q?JcQYrsLc13J2FJFlSgo6ouGFEwpYZZeDXaRK8PS19awjDTbbdO0LQYPOo227?=
 =?us-ascii?Q?tjCNIdTJ6ZTnj1vKjOM/RnbHwFMqjP+3tf2eNPwwQA5EMWKBopYzXzLquN/n?=
 =?us-ascii?Q?wGCylvc+RK8M5dq5pCyKRAe3UJ0Rlc4kxYDoufUQFiKbfL35nJCryTgZOoZc?=
 =?us-ascii?Q?6IuP050bdT9wnrEe3t43XeEJqvEVrCTAf0kbMVg0I96Y0mA3EI55BaUAoPnX?=
 =?us-ascii?Q?WTspNdkDNNIsYH7VnAR1AnbSWxaj48D20M+ZPG0N2EK5IF+d8x2IJRF3vdEr?=
 =?us-ascii?Q?3H8oJKlklqrxmO5gTmY74/xty0Pn1y03e/I1CQPk9CIsDOUFypp/+XxdZoUh?=
 =?us-ascii?Q?rn9rDuV/pp4J7Ddccy2tJ8CXQb2Ll00QbTr4BoIowBw+cMZkq7THmIoz7Jla?=
 =?us-ascii?Q?A36+Rv0v64j62pn6ahdT8IFeu631+Hq1YqQ1UMPSPJjFJJGdN5hFQuX6l0Eo?=
 =?us-ascii?Q?zpe369AWS/mZZ97zuSf9cbQfgBpXpaahLFl9i4jl4CYI1Emq0IFsjSuktmXx?=
 =?us-ascii?Q?ApRQrUmOWLn/T+AWXvqDlPjhu9RvswDQnIN0wWYiG4XGk+BVuJuwtMqezY44?=
 =?us-ascii?Q?NlkY7W48DyXOhcYDhkUdTUrlBh2LUoVKqCVnU15wBUfxS0xQUJyB60WsgJtG?=
 =?us-ascii?Q?NSTYt+e9H6mzrBt2R6EnSRjEkLAHDDaZvA4VYx1OX+PiQMhb/sn1HH84fk7O?=
 =?us-ascii?Q?GF88tjIb7R97eyV8mgvlPCNB1zi7ZERyyk8/vxBxouV6CBye7GcA/PIunv+g?=
 =?us-ascii?Q?3WhYa1E+xOP2BJ9Jc2P7W7uJnRePPO9CFNjFWHk2xsZ6aVlsGTImkKuCLKc+?=
 =?us-ascii?Q?6hp3LRybeemu235X+Z4lckQH3rFisAr/abwvEw2dXrxTUuNYUW+ggFtSyodO?=
 =?us-ascii?Q?BPM8/Ziu4bfmjEQ+LrRwLyWGBitHDn6pHGZRRY3HTXpKp/WtlBOhkpedi/T6?=
 =?us-ascii?Q?muNmT5jBjutEQi4VVfCo8YO2oGaOYGgzn0hGizRcd7QaaNwHRBfI1P3IaQ5a?=
 =?us-ascii?Q?vB3UhZIbLUmsyYwSYnPJ302720HfK5YOsV266ZujLk63QSHc//Fr1Q1iFQVc?=
 =?us-ascii?Q?6wro/1bD1SvwcgYYCSKcauimlgkTqVzQe84FYG+4DRcd8pq6dbqaZKabP5tj?=
 =?us-ascii?Q?6rbaqV65s4d4aTa6kNtFlpMrD3b+kGdr5JyZmRg7NktB4Bq8EXjQI2XU8J3g?=
 =?us-ascii?Q?H1uvUyE3+ytIfAClqnzhEmgeIFA60pKc1+E5eMi8H0uVmOF1CWK4SNE3r/dV?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sWXei7pErI1U+78OoeE/kQpjb+cy09pFR1KOlILps+w8iSstgtNF48bC+QR4louN4NvGNAoL7AOVwBBeQd0pZ4Hsk7VlpkNk0Y079LKgt55AiPDzYWWaFriDNs+WkyNTF8Ikm7qU7PD9tDJ3EGt1DBJWxdoVoF9nnu+Dsy/On7XqiszlbqQ7kAmxW4KiHH/7AFY5RVrvoZnW0YvsNpmlWL+QUI9JCBAWrlgYYMMRHdOuwLTlHP3LpUFTKRqzwz6vKuwaANzeFVIchJzgLVjC5zF3Zs/MF/2SYBJPjzhhiuzLxtx0PcdMs8UA1gpLoG/FGpI3IyK406vPaUBsyGgd0feJgAXq0ECfrbSVaG6Vi8ciGbaV3QfH/Op7DAI2EJllCi1WscypVhkLsUKOanpzc1oro1HSZKkMibKxSC87hyCb+vuookfwFQyWFjU8PmC6vdycaQGADtntxB/AV6NZPThLuM79VXUJUafHrA/i8G2TULOPayby2wrmaZtHCXqunvHoJTNILDcbS+48zv8OA69wsu9UwThi64vNvxKuDcbZeuOIF4QzF0NfTmjaQFiFbYMlbJkRlg5/Omb3/xJTh++XYmB+feAUZOM39bB8BVF20SSKKTb6O6iVtX/P2jUTbQdWAHrJNAjMTQCEB907Es0aN24ghEHmpRMj2bKs5ttTSg4luA9sNMciui47y8+ILjZHOqZX8AqSVL3pQTS9ndPpU5Znx5/+DZEssARg90NsMAjIhN1LObsoBEnevWZ7K6XRUNmidFb82AXUIVREJ1oMVu8xTaecTTsQ1n5j4ZIDlLyBuaI9wvCIa178NmZNUoyohh7oDJN17trg6Ld9u2VyVwzq1mY0Ryl001i0WbHt/DG6bal5ydlAr6jMxJO3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4177ebf-dc66-4596-561c-08dbae662ba5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:44.6336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdS1TY86Vl75nWMddbooxVXVnjrITMVtflVYGL+3NWjjr7aTZNzhttgn42rwDcXg1T1FpaLCe/qWAzEX4JjDuJaeutYAJEhj7fnUDtWv3GU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: jdPHArp9Wnfy4qp7fTOVRVQYVmx5xn6S
X-Proofpoint-ORIG-GUID: jdPHArp9Wnfy4qp7fTOVRVQYVmx5xn6S
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
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 67d74f175c4c..756e13637f15 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2319,10 +2319,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
 					  timeout, 1, &exec_args);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && result > 0 && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (result > 0 && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	return result;
-- 
2.34.1

