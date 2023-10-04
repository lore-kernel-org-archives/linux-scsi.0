Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0239E936E6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjJDVAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbjJDVAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:00:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF783BF
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:00:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIumn014794;
        Wed, 4 Oct 2023 21:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fa3WxPQAbP5K94E5p+sk9eGKtVDRuxfIpoYNxUXqWzg=;
 b=Lyod6ArGnUiETevQp3yXN1iqC3FvJIH7dX+Vx54RPMMO1ro5NJ7DPEpd1vGDkwki7C67
 8rFvc0xhd3mLzmPXKGHw2BgbC7BupgLNq+3S7wZsnAuCuKbwK/LoTVn0ow68d9OxeeSS
 ZYaV+0Lot+JCkCOOBRsWhpemtzo3Ns1FYOUCYPi6r85guqM3pojg5QH1tLJbifmGcAm1
 Eu82S4pIbNKOXByDaISbfkmkvRaVA76igTeQoPRoaOi3Biu0tR8jHHtiqmP+rRpvUSgK
 f6JEq5iJJTC915Z8n/yCd7ORCKhnD9waAWq/QQeSvqCoJjgUe8Wp8xGWkja7q/7SYvrR TA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vg0bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394K0uLn008694;
        Wed, 4 Oct 2023 21:00:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea48p3gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk89igw7/MH7puiQHIaIRKWHFfcd6w47H6MTHFioChHS71hav31I/SVyNfGp3hZr6WkE0YFir4NYdBYBtlLeRWMpPBL6xBLiuzDJZm6Y3omVELtGh5um4thcAD/SSsiIX/tmZ88h614csg+mjpNjlZ7KhL0YjkGebQBIMDDrhJVS1iwP/ouZtf81m4I9WSVBL6phpn9S+PWCbM4ln9N4HK0kdgTXpMJU7WVijwUuziN0DS3vNRP/SKobnVvpUIxx43mqjbavmnp/wrvloEEp1eJ0/0cMsZ0p/3EozFUmu/uYhfuAW6dOX7PqFJLSxSbGrJDIA5XOPQx/7kfNv2YFJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fa3WxPQAbP5K94E5p+sk9eGKtVDRuxfIpoYNxUXqWzg=;
 b=Wl/J4ywXyoZVNN9PM3f3ENRUkL9vsrZisq/lX41Caqv/TZiXSvFn/7nam5+9mBGdgSWkhXskd5rE52YI3ohBgG7mHqbiNhApeoTjVME5vZmQuWZxXz9TfF1AQ/y+U27HIxLNaQcRWamwDjh8Jn9e4RjDumffFvk1pPdpi5u0Dgcllr0Mh6QjJd7tsg4nIelaLjXDawCIJHbXBfqu2tqJiFFtk7llP1/KTPjgbso6RhG9M8UIymXFzf0I3yGc++jliz+M8Dqo5BavCFZZk2dhz2CEE+IKWtzl884g7bmvaZZENLljbLin7y3NaOR7GKbRzhbABJ4rN13x0Z1swXGQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa3WxPQAbP5K94E5p+sk9eGKtVDRuxfIpoYNxUXqWzg=;
 b=tjqx9L2eJAhRbxT2M4JOxbCYeNa2BIK51C+oLAlLzi+TsibKL/xkZyXik50rCyzabbvzpAvXawJZAa/1IynGaUna4z47Bh7KZeL5Ydn7P7BH+awCHnNcTu0w/jZUri0JDBKtF/kewPnCUjnFGyFezlInNjphsFvdj+xJOXFuq8o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:20 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 02/12] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Wed,  4 Oct 2023 16:00:03 -0500
Message-Id: <20231004210013.5601-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:4:60::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 711f0046-19bc-47c0-5ce6-08dbc51ceb61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSEsIg6jipD4xMy9xC9Xf8w1JXLCsVeft8yKtoy+GhLxUqvKwRc2IdqRH+DFaXdFyrscsPojUORdIkhOCW2RAokXaNwmEn3HZl2RbF6ZD9sgyesnKeKYjE762hYr8p9MGOm6UspClGfh/jXGEe4rTGsgkMN8K7dWYtzaEYMyBRKutI6/7b0KLKZAcAonxCIbBATL2UX7c/EhZCOJv1sc29fLBcs+IDWeyWOl2SbrXxF52v+RNY96mBnhwBDew8ju5AUJ9JyHSpu+2gvRIynbtVFjPvfc9IEvlU/j5yGbnpjkg8eyAmEbYkpNvDquGS0JS54xgJmlMOXTgH6V2zmMNHS4MTzrVNbm19ktqN1rVYQExUV9+m1mLhiCijuJJiwIsEGzBZ5fA8HwnTygNmXIQz6Lp1Gz3KfKZl0LHsK+dNDiaAo9zwVo3rzm7luATnWHeaZ38mI1Yo2C4EZcQ+Sg8AsNkrVr1jKUyW6VsOV4hyDCRc9GEHyM/YBwEW1YhpMZHgOmKmKLnS3rSM7VJfnQZxyjIQdabMiVxbqSxUFhkeOXpCwQdzd2iDFZN3EPNYGk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WX2VN1UPZqspt2m6KxSAJr6JIPRVTx9o1IdK8iuRJ5h6K4aAoL84PFT5J0iP?=
 =?us-ascii?Q?hBd7INHnmuFE3EFphQyXkvD9/b/JeJcDsp8ddHlrNf6Y0ExYQu1/kviiH9EY?=
 =?us-ascii?Q?h0BvIEq9j9eC7t/yOduvW/ldS1KRsSZJ3kaF0b5JbBAS9bDVnff8dc1IGqkf?=
 =?us-ascii?Q?vYQnDgZuyBq4qUcDoqFCvg/nwe5t+oVYU3TnWKX1YV1TYw6pSprTCa9Hc8x2?=
 =?us-ascii?Q?5zrJ1VGJ8XOUddg05RxDZfbHC30JFVaGHJBzZW5v3GR2qOENNX0k22M71ZQb?=
 =?us-ascii?Q?nTg8wcEWE1GEf9RMimYRtn6+tU889Nv1ygqWE1gpR3lhOMHhkJi8pydotZuN?=
 =?us-ascii?Q?ITFCP/nmxs+2P8F8bUtpwJTxQILDLxtJUmZSeToXv1iH0oxZ2ega8IBnJ3pG?=
 =?us-ascii?Q?rgJrBce6s925EAQnzArtAW0H88tuiJAxTDNbSiD7FCxyFCXsHvhVUQXEBQei?=
 =?us-ascii?Q?LDVmHg+igfDBJ9zgG8o2zXjQm10iGbW77eHQjE7fQCFShnWoHvWGgy2sr9Wk?=
 =?us-ascii?Q?rCwYtWuiL/AZthesXRKDPcpNkvn1aRLaft8jIzWaJYYB1BpASZbL77VhFQry?=
 =?us-ascii?Q?I/xLsYU/rs0Sf2jv4bFxz988ng+0GM7kGf7jdf5kvOpxx6UnBHCNuvm+gyYm?=
 =?us-ascii?Q?+NENSUqXjqRql7ltrV32gKBmH0Q3pTWBP6ljyo2uKN1jdiwWsRaC8OHizz3V?=
 =?us-ascii?Q?n8AHSav3PIHNffqoXfqAi2eQMsWkionrxGgfg3VxUCRvCNBfvwaSZNjdybPH?=
 =?us-ascii?Q?f2Q0Hm/UczFu9evgxBxYbxlJOo+q7mbTcq2/vE9gVJXWMhvlaUZddxtNMhw+?=
 =?us-ascii?Q?NFLU6MKnH9FXrVoy2r/wROAZitB1hKeelnrPLeVGFQ8XW80VJWJ8TAcJIU4t?=
 =?us-ascii?Q?LKiJczGJKwVSuqlkfwIxojgJoYP+MfLYR6Qo4h7+DF1DuIvcYgO5wxzqsN8a?=
 =?us-ascii?Q?nbNMBAjlRBCDHhx2XUO1GWHDdJ+OYcS7v44khPD3J6PzOf8zeYL1pDmEcFYC?=
 =?us-ascii?Q?TWynAw1mH5lBWzvghGmjGg5aDab2PKg5kjRnKlNIWkd7Qptns+iUXQJLG4Yn?=
 =?us-ascii?Q?Tfa495cKxLNKfaPG5JqFDiII3ce12HBn5i+sUiJ5C0CffTNIFGTJDGidh/95?=
 =?us-ascii?Q?AbI0QKmUBCrFxku6mEnFKjiz3KBtdfvtFv5aNGd4rdT8IPEb/tjTXA86+bKL?=
 =?us-ascii?Q?mdY0xpcw6K7bQyH4KWE9igIKdRAnpurnOzr/pb+IHoUC3rRDMd46/LsNEC28?=
 =?us-ascii?Q?3kU7mT93213KOC7XgVJxwXl7o0sGTLNI/QNODWFx8wjwiGI0qYgYnab7O81e?=
 =?us-ascii?Q?SdSY4yowoZwQqgQsYNXs+lrlAyAXTtBLACoe33c6Df0J4A37D01PfEefFw07?=
 =?us-ascii?Q?LC8WwHoeL4ugMr2s4+feTRGkChXabt1KR5JwRB17vitq3bQXpPBNVrMxK1Jf?=
 =?us-ascii?Q?H0BIr4luMElfoun1b1J8ZoogDV36h2g3Y1pPu7NUYA1NKMcxhjT6NzOL/8j7?=
 =?us-ascii?Q?QhK9NQWHtDIDpgtCXDBA2kILpF5yYdIeqfzkq970S0zA2EcetOVIhfU5PzSA?=
 =?us-ascii?Q?2QetRHdsiEIhj7QQ4ivLqff5Hi3BohiRQEwfS6fAdm3r64+Y0S5lzd4cAwvS?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1mhzzUY9fsSFLEsv7sVbTgrnLQUBprFImrA6ofnowpzokHt42iXUJDSOBWXqLehrIIIH9poxe8p64eat8o5z2MIs0iANzvKGNggWz0bZs5EoES3a62ua5l04f3cBnR5zE7ci1u++Jq5HzJg5U77TCkXU+nwGVLz0fQra9uFW0vnkWsCSixyQJQpfZ1c/FP3EpcOMFPyLDjpEiylSdbn4XUgmSvWS3HktdbQF5Go/TmwBsnLj+M2OMeM/cC/kVHai2PWCriAM9S4ZKzDR07BlJZ0T8BKNGP8gNPbX7hN1uwmH7nDhZQMugQ8E2Od2ZqgAT/HmlzK4aZeKTfQFAieM5uKLet9tHdoKInWvbHejALw7zKygZuRXKPpQFhuNJ//07BIDHSOwuhxBxg0XclJH3n09uvGJEIN+zqFi5V51+ydcQU/eNtnXtsdzmdbuzK8se7LpwCUSSGcJyf3gTVR0/fn0FTYy+JG0VA1oDA7mnTXkJoNVXMgpg19azFVlseRSgsLT+3upKneaSxJjh3nso1v6bPX4Am7TkwxfQOHpZ9l8x3f1cT/00jylpwJUtg+ZlYVOV/w22PdaPI2Ul9QKL/3I3z9WEAZEwStHpi9kTKHvv8634A5xWbvxv4Nia7oU2rULMPI7spUW9M0OOUAj67/xPOXzd6mWFG4CquPpFCfpwlgLfTQxMlGIO9YbRn3t11uEHgZELprEmtBaLtljL0nDIiO9UXpQ8ea+dsqCp9fbJYkSPOvVd4M4ktHOSDmVQB/+KSETF5eP/Q+OhWRum/b7XIV/Nu/eXzgLD7YgovM+N9r4TB6Q3QjPMyzt+li+ju1sz9czAKWbYSPu2k8tJkoLbCg8p7ingdVXjuDNy4AE3QcPKjVL6xR+UOlR/VF2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 711f0046-19bc-47c0-5ce6-08dbc51ceb61
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:20.2687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zr45nYGDN48lxQb0o4T05B2C8XgCzI7oFPT2ML8fbHLvzGBKYjAGyHOMyCucCZ/17yXJK58SQEZBy2oDBNmT44U1eEcYq5q+2cBCrvIIyo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-ORIG-GUID: HTaegyL7yDrVPhg5qYRtyG0cfjWW0VYt
X-Proofpoint-GUID: HTaegyL7yDrVPhg5qYRtyG0cfjWW0VYt
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0754949c9f55..6e306fe8cb5a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2227,19 +2227,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						      sdkp->max_retries,
 						      &exec_args);
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+			if (the_result > 0) {
+				/*
+				 * If the drive has indicated to us that it
+				 * doesn't have any media in it, don't bother
+				 * with any more polling.
+				 */
+				if (media_not_present(sdkp, &sshdr)) {
+					if (media_was_present)
+						sd_printk(KERN_NOTICE, sdkp,
+							  "Media removed, stopped polling\n");
+					return;
+				}
 
-			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
+			}
 			retries++;
 		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-- 
2.34.1

