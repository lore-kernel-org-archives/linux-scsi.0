Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE4BCCF9E4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjIEXYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjIEXYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:24:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EAE9E
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:24:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtYoC023760;
        Tue, 5 Sep 2023 23:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=3sItpe9tMgXHLHTtVj7AIKCj7FEZrKMfHsvU7ofWqxs=;
 b=vmurvnikF3JvlNu4N+5pyWZOy0aEjS654RjWS55Mvue5tIzppxMOrfTg2T0PpTViHvFe
 f8ks6usf7jC370A1TmW0YgQRkbubqLL7tuNmV6/EUa2mEUlq8MPi5TqQU/OMV1iubroO
 fpPvONVrP3TjtKoF8QnUxtJxP78C7THmOY9+hAsspHYGOGo+D054ykwnAiITdIfoATdM
 o0QO1viAKHTLVQxbJhJlCmUiHNj+ZY2ayNt5AYfMWgbpMdFWOTRqr2KiqRpOByBi6B9u
 LMvKyG6vpyLmSVt3uo7/zVVOjlP4N5l2GTmPhYsL0Mek/79Exj4aC3zdPb1SfJ7PelxX 8Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg81jq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MRBCx010380;
        Tue, 5 Sep 2023 23:16:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbp2us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBlV/I7CPZM+iyYzEyi3vNFtNg8XBr4itLpTnajkbP80jjobaN/CJuWfnzejHIJOk0paFAG1TA53zfGlpEh5wwO3GiT4kR6cwmKsTIO/arfbsC5uNs+sM2exFj2RhGbT71pkRhYWMBV1omTb4EdNIYdRuWXLY+Mqopkr8yJ9Aw5COhRKR9T0zt88kdTBetsnxgmJ1Q25u1B8/rlcFkKSGleArFd3WtiTFnfRaN7sw4INJ1cSrqttB7XjtyolprQwEfcIBJ1+nk1/LGlVAXc2zWm5xxP9nKqBV9xDnEN+jiPmcoYAmIR3T/LKBud1c7uMzc1f37H9iAvdvUHKwYwe9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sItpe9tMgXHLHTtVj7AIKCj7FEZrKMfHsvU7ofWqxs=;
 b=mn2Igpc0U+lgP5ntZgAe8VCGI0pPXVC4UZ+bgpQ3P3mTxF2hrAOnFzo3zUb9c0Zr6twG2ytlSf675M2yAXKy2q7Avgb0XMqjZ0La83W2JgsZlq/m7rw71mf4ygeZ6pr2drtSC0FcCMYLC+XFFnsGikYCLCK92HDEPRLHrqceJOd97a8rShMInmqiW3vqvAF1B6zK821/MRhdBjtHPZlOyeGY+pxY3wceCSZ9JOBwlP0XfC0IhGemYnDEEF2P+YTO6/SoEfP8CgRAfDusClPLCa7FkwLUFdAIiuAwhrzAgbK0nFdQuaCqm3hh+ZSGjXNpjY1zBR5MI0C0Ze6QmFiH6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sItpe9tMgXHLHTtVj7AIKCj7FEZrKMfHsvU7ofWqxs=;
 b=BRzeQC5rODqHhpGljcZLHJkKjyHkZ2ZxE9ryg7Xb/uga6NacCA9MHcHJgxC//DJImfCJTWKFzFXBS5HkftWgESwGRpn8Z61TAchrY0yklY5ElNOHEKB1ew0rkfc8Iv8JZrdoR5oOdhPZHKwV2GBzglWnZYiMS4eGzJBUquEwpBA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:13 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 15/34] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Tue,  5 Sep 2023 18:15:28 -0500
Message-Id: <20230905231547.83945-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:8:191::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cfb5f71-9fd3-4e5b-0553-08dbae6618c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUGDJiFLe9htsChBoaVhsAmIOmaGN1SHk+bC86FwKXkmg1ePDED/6h3YssJDPsALb8/dlX9n6dVq1I17ZvMQXJ2MEa0drhN1V4DMHuVn1hG3zX/FUtCTUIwMNYbXf+2nDdo/pIZpNCIr1zQ8H27MIMxJCxE+ZDgZ15zOAnxO95UOU1IoeZwaO3cUKtQ8yT5dbAT4rW5O//8Z9Pvtp7wmn6kstxMFVpLMrzzLq8SGOQw7GG3VE3/S+yGjEO67MHUnVUgGdnboDF/fvo5cNXVZmVOMbIWvL6shKVLscDNYmRRWY2EcsK2Nd8wM7I9Kf67OlEZn5kitPC5AEGNP/JcTT0JHLiSXQodYQ9cGyv2lkhO4uwiPgVvYNpW1E4RqQgZP/CvHOlokg4Jk/7sKCTB5pB8B13/rzBaCcslPj2S1MCIk95rKByFAdC4XpIA1aS4tGPgjgT0hzkOpfPJVYq3lpit+icDWluNO+FntkO/CHG50JpZoy1KmTTRvlH5A7Y9HLZhSc23TDsZMFHNOMe0Jpj02caNLNfR4Di7K+U0ZVpnCTbEIn0snu2YbDnu21qA/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MCElSMeXLiyjtV5E4cLswDEwj8xzeT4Q2bInvvj+vrNuOTw4ZbuKB+BBYltv?=
 =?us-ascii?Q?09iVqfAJi+kYxCHyS5/llemcNti5NH3gjj77p1eb/RfoAQ8lZxLxC0bjZPyH?=
 =?us-ascii?Q?sAmBcm2Ml4Um4Fgki+cpm/lMJGBTuZyK+bjq5lRsUywuYpu2AaFtQbZX6I/8?=
 =?us-ascii?Q?boBfuSsBejOPzkxw9iXfTw95ecBN+pcJQvKRnKD9MInE70dqb3H1PI+zIFxh?=
 =?us-ascii?Q?te179HENTTlyVzk7S284IE3XpHUeP8Z3FVNwvqZV69TzzlwoVCgJJzzmo0NK?=
 =?us-ascii?Q?mcMsLZORM6QSf99iSIgMHRdQU29iPdx0Dix7TjAaDBGJT1qWQN/hQtNoYuUA?=
 =?us-ascii?Q?9chOhdDUcepXlJMbNL1E5qAOlY8CTyXwjddN3MhFHayd2hUTFdPodHU+Aadd?=
 =?us-ascii?Q?06qv5a8nygQ3o69LOSkBhjsUhtnXppvJ6ToUJNKfG7ntWv6a5LWP5gQQ2PJn?=
 =?us-ascii?Q?/H3pLlFjD3hqbeyYaJgbkoe/4GC8dQD462NdnDzSScdZRxcvRiBONxy0/GJe?=
 =?us-ascii?Q?SOUD7RRyjfjduP3YM57HQ+L3daqRSkpzGvFmjib/zCBOxHrMBzB1dFGNKTNW?=
 =?us-ascii?Q?9SQJ+8xffmluBNOM/z/p4GMdfwmxcf+BS8/cXA5gGhGduYK09FuDGI79MP1x?=
 =?us-ascii?Q?3nKn89f/wkIVyZzANA35/4X0NUYK3qrcpYgP4w/c5qvANz0su0ypD5jydBME?=
 =?us-ascii?Q?3yWv06kBVASOPfoZFKJG0T2EW2qC4j/mys/QOFYZLQYREBJBV7g8T1wYgEp4?=
 =?us-ascii?Q?BC6MgbuS1EKX2zfmPRYTE8JE4WkrwdXkULabhoVSwbjcsFTpLrcE6rgKsseB?=
 =?us-ascii?Q?Qm6/C2T9HJnDWkfRbBCISrYb0tbDNkT8RZ/rQaKQ0psMf8rbOHF3Tupqnzoj?=
 =?us-ascii?Q?87VCftjSalfgxfQyKecyFuDD9Rl435UdInTIXlMrN1jYyUeozSoEkYWDYtyl?=
 =?us-ascii?Q?9fyd5WkCybBN/BmSc0GrwvK2pq2Vu3jHndD549QjxxbBHEDw9eXUXlZOL0Mk?=
 =?us-ascii?Q?HBhdQ+JtbLyR9Ch/o4Ic2Ta7k4P8HmELgPI/5NO/8i89NciIPjGgWGg6Z2Dh?=
 =?us-ascii?Q?LsO5zakupnPjC63dNTaMYKfGaR/7Jupavs78YcJ7yrhNhNAhZDrzorLPYadU?=
 =?us-ascii?Q?b+2lZr+ryfhP3rsJHhrt025btCYXI1vArMJ3u1r0/ICir9zRVBNAEoDFwsol?=
 =?us-ascii?Q?xFbyuwUWp9aJIeWlM8DAuo153jBPghweXjJq+bLP1glFV9fd4HUxXxEd7+uo?=
 =?us-ascii?Q?6vJElGpQnFHvRBXNqcryeGNhKrv0Ltb5l39ZtK7bP4qpvjBR/ViSrI/Kt2Dg?=
 =?us-ascii?Q?JvvtVl9RqAQearc/HGLenBy07C+2CxkzqDRXXpY1kWG2zij+jiXp7rCLNdC6?=
 =?us-ascii?Q?aJz54pZSGCFqIcnm733Jr33R1SzznzYbHJEz1al0XUS3xvDvM9JCo2XVHQra?=
 =?us-ascii?Q?J+Rbq2AsbEPEv2Ywis40VU4yBXV9HRYtNtD4/FdCwL9pLXsJqDft5YpWmrLm?=
 =?us-ascii?Q?nFwtO1LRQYAdNqGfWqD9gjc0BLEouMWy5ESHXlY43l4JyGnmm1XQrLQT0/5M?=
 =?us-ascii?Q?mqIuqHGmoIXT96she6ecyYvMamT54Hj007S4pwyJk+7vfZC7bXFwZpZeDjZ6?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oHkmm5VRpVZ1fQ5F4a0GVGUoAP8KmaNcKqypfVQp0xg+s9kWxyookZ5/1GODjwSiXqtlS3mwhxHLQ1dZ/l9uPKjP8lXTZRW9vcWC8aklR/b1I3YyCj11LxUyiBbvuAb4PlQdaM2u9QM5m3SEOcV/aEGPklVyZxF6Yy4AuDU/3338yQHSw5EJrDEFpZrWaHPK6UaIRqIWO0c/caAsDmIf8IxlqkLWhTNNYkZVZer72yoEysRwjtkb27bDfcuVgbgQfvwKgq4fXmdZ+FDf2wJK0OvHKVq2laS14RQfxB7e5TxG2ZPihN+owAQ17g2Kb4Gq64iODGSzovGwvQ0Yi8zvQGMb9+1K8zqlsdUFj7mZfIr/lIwHVLFV8YLJdzcgeA+6JHHpi3SVK4AJ0T7uAzuM6RM9ZqpkOeCI0Cm2MDI3hBZ6zK1WOqdiETT9MOwdJshAUnGYpxNXe4gob9nglDwZjGyXSGq1oYrdhyr9tF5DX5mLVCwD9etGRU8iO0HjVOHYGAd6o+l7HyZMtyCdkt9x3HEfokPao2R1BM+xSzleT2Dz208bNJ05NfJVUvuG5dZPQ6imnX9xWJ2TVkgJojRbN/BHkYl2ZxtlmYjL220MyAIauw8u4uzCzS5nlcsySpbPGXnor+I8cAOGyiDWlzX74L2CGsPUbOBgP7EftIufA7YD5hHhK3cfyVqGHvCenoQhChMxBKNHMuMDE8bRz30B5x0sEQmHy9CYfeud6OUJ3yxgMX8aMvwwmstLXd4hdEOd1zt3wcZl9RyzSpU9Vu/w5rw9m1MyK+T3AXf5X5nD2J1tf+dK99Gj6jjxLn6c8nyPb1tiFk19ulmmbMBYSSlMn2JjEmHihd+uZ5VAZORBTvUul++Mk2EU2F1p7EvURuK4
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfb5f71-9fd3-4e5b-0553-08dbae6618c4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:12.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7grWOJ96qxf+y2URS5lWcxZUxj58Bx4ZKOg2kmfkn4M/Ok4lhLuq8WN+g+s6zW8gZ3gYFToqmJs13KNUUpifyoj2KKNYZRUzTUkihmuqvyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: _XDWEO3gONYDz9zJROBj9StadHXVAlOQ
X-Proofpoint-ORIG-GUID: _XDWEO3gONYDz9zJROBj9StadHXVAlOQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

There is one behavior change with this patch. We used to get a total of
5 retries for errors mode_select_handle_sense returned SCSI_DH_RETRY. We
now get 5 retries for each failure.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 87 ++++++++++++----------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1ac2ae17e8be..771108a332cb 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,52 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	spin_lock(&ctlr->ms_lock);
@@ -548,15 +566,12 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, queueingMODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
@@ -570,10 +585,6 @@ static void send_mode_select(struct work_struct *work)
 		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
 	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
-- 
2.34.1

