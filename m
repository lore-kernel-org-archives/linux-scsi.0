Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B750B14FCED
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969365; cv=fail; b=RPwCWutSnrxqKBW9t52jpKy9qADdCwQxz19tA/uFLXh9iWjSubK8a19w70o+MpLSHJbUlNzOVlTTkbg0QG+yDUq54lAd6V8+CjvLmXt+lof94kxK4Ptokjn6CkmQlX9QySG64MW/kSQ/yFT55BC+/Bp3uHxL1OkDlIFP9WWuurc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969365; c=relaxed/simple;
	bh=zIKcvgfSbyx+WmF817+LnBLC11W8Scl/rlVlA2Nw6jU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dEHE/e9pUJw9M/MwZ8RloOlOy/nw6++sunOdFSqHjrGV7BOr7aaUU0bMZlxaGLf3EJ8tXY3U3vf+2ZA+au43ZDymkIVSFvwAiY69xZ0JPeEvzSTK5PIxaIdL3E9/VtKmj2WjGF5RDmQTGiWZ1kzxnNd/dpdRNNieMOaWQ0VBZU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hR2G80Nq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JStgJBg1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hR2G80Nq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JStgJBg1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMofFX022177;
	Tue, 23 Jan 2024 00:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=hR2G80Nqgj2OCDuLSms0sPC0UTVqUTFZcr19ntKlNqLliprcLda2QbrUKy7Isa4Q9eE6
 64zg4fVXZgzf/J30HARbyR1touOTVHSbLBqPJAZu30Yd3nr4y0Jod29T40MuB4JQTzvH
 +QDLD10T4Tw/Aldmi0XSC6acT2bWq9I9KcyLXoPGK/wubs0r96AnS447hemzPoPcBHsv
 UsBEj9ZZygsS7hOoV4mQgOe0ZiYTteqZD5rOR78aIZXf3ObRIHghGFQwHc8vBcqtIFZM
 s1zHN6X7LMZDoryEFsCPCCj4KtiLYog+C67TyrvDAcTU6Ji9nArhQtK2zaZekBfgtBjC VQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7n7vyss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMex6q025344;
	Tue, 23 Jan 2024 00:22:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8+7VrBS+loT8kQE1oEIhj8Hbg4LvHCdMTxtDVRk0FUnOyBb1NA+u+4jJRDoZbB+JJCr1AmgTV3zpcbr5WCLCECVM0meHSxyo+ao53bVHz8xldu+felOBHyc//dWiLjq2NhpqUIPxYH7ZJwtVFEchWnZBIx/y0KQ55dyFHpY+p33PRwuCptNXImYfzHPvgJQY6rd2CisDX6akQZZE3dDOuSx24u690bt5Lz2kAG1EdJFkt8qRw5AkOwsyXAsLYXSkp1l/ANnni7+HPw5sOJ5fwf2ThYhm7TZ8FNtBCd/0dibOK5qGVq3pw0nsFcWn2yc3LE4Gkdl1fLwuVvYVxptBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=fzDik4Zavu7ySCTJo1JSVuwtZqLT9hI/M/cX7JXvPXA34nViBkok8sX+fgD5fXhfzV1AOWT6tZ9nfxn8VSD0K4eNm/TIPvEd31S6N9sr8zr85rpeaQFwtoDMWjOwdR4t6WfST9wwIrdF7u+hsxBXVmiGtfvJbcTe8PH/yJAgQvdIWNpJCCCkAp//TSQ4OmydEMH8WLPAcMDbT2WIJ5d/BeUmYmbIpw3ty8wkrAYYJAZxhjr84woQWd2MORY51ZHQC8t1tNFvNpkzfz10ZRg9YWBVxuAHwwddlIJcPmiIvxmDnQ2+SY7Ja4JF3PL5Jyq919smHCLOHcdLnfTuqWe8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i39wCHhIzVAo4OQbG8mHVVOsp8SrqraJXQtkBId8LIs=;
 b=JStgJBg1wdsqhtuc7f8qdKAlYj7caOPxwt50YU2qShywcl9kUByDAVLX5cyHw4Onxtd/OMXDgFm+MlSyVIFo6TCplhzWORghrmbBcVGJuyt0/nuk2TSAAGyBHiDj7tEniiZtkIV9jyCxwmY2Y99rYoZAMi/uwqXhHuv9Wo1FsVM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:35 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 08/19] scsi: spi: Have scsi-ml retry spi_execute UAs
Date: Mon, 22 Jan 2024 18:22:09 -0600
Message-Id: <20240123002220.129141-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: e1666641-c6bf-473e-a86d-08dc1ba9659b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	muQeXChiomfDjnSJEcCWv4YKiaAJwK514cDDoHMCAnQDR7yrkNIBskQSdZkCa9fFCd0ynhdI57b0nzDMhfwksuQ3XqsLZ6wbqh0D8VcV+C9+H478s/0r5se9Z/ViyU2WzK1ecGIjK259CGnj8pCMLNqPSC8Ax3mWhH4wqg20I40LrbdzIlxhk7KRT0MDPXSW+1qTIfga+b2/zGGqfp57wyUHhxgCWDMKWTaid9jHTEJ8GnftQ3QR+ShLnPJjUI7wsdRIwpQGceK2k1bzYwThcdqCuLLhb84SpETgrpFJknBoenIJT0c/e0kKUtGfzlE7Jz9r7ry6zHt9UuBiHi+ltoEITZ5q7QYco+xUSPcdIXeDpTXfXK6LKRAvAQ9oJq7IUYA69dKFDkSuTRMAA6qPkZLhmJ9m2llVzOYApWlEzaWHNCATB/QPZ8e2Q9GZ8ocBz0FB65nUjPqzqUE1sgbjgpaue2DuxAOLDC0YZH1eiaxlFpz31/xBQBWpsP1sThc4mVYxa+cM43n34zNuHp27xagufMOi28CCffosuNibA6QK+bU7NDYDCXOMwt4mfK9W
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?arJ7PMdB7Q0lVv8NXzZbg44nftzcNhJ18iC8fX2Hd2jMzrrE/d2ekt7pVkYv?=
 =?us-ascii?Q?n2JkrZwM9A65yTBhG6jHIv1AJ56tmYT1BLFvlsBw4W9Efh6NS2dfuz1U+Xrq?=
 =?us-ascii?Q?MVteSs0/TNQuJ5aiWU1QaYcLi6IsFaXp9WlyKzXTdwq0gbxr/BmYrRet7MzJ?=
 =?us-ascii?Q?pBRPyL6LWKdQcsy6al2r0oeIqgDAWrNGJdiYrgKNv5LAeUIBS+76Cl+Sm4xO?=
 =?us-ascii?Q?2ZBuonfguKqkbDQYBckIOMZY1ozdADmR+H3QI7Z6bEyW7lOVfBCQR6IzyGQu?=
 =?us-ascii?Q?YczFhC+Yh0/zdw/67N77rIiQxl/68+fi4pn5I/jCHbraJ1qgasvgHBraVL+h?=
 =?us-ascii?Q?SnXZkmnVMaXxse3ZIS4kxXd/OL0K552uv9Y+bWdD+WjI3ksnnQ6ei6xBSImD?=
 =?us-ascii?Q?6pL5H2iBcclAKX67am2TdZHrJNduKdgDxLbNJ3SwvIhDQ6iGM6/HkcxzaHe3?=
 =?us-ascii?Q?iyy0p8YwlgRYIdhv3kb4NU818j3UQoVlNLCye+HPku+b56sX1IzxlnXqkDjE?=
 =?us-ascii?Q?VknTg7pxf0Vh8v0AYiREKrpLO/bg/7mHlb3TR4nb3yI0f/zlR1OcM2GaT6v9?=
 =?us-ascii?Q?YGKXgRArd0PNPkxIs+l83PMX8dgrytIiv1unwtjoQvE4fHdyScmaOkEC94wm?=
 =?us-ascii?Q?OBWMSqxouXwFK9NafhagoaKGwlHMlzK+vXTx1Yg0/xhqX3cihr1+7fMHIQeE?=
 =?us-ascii?Q?oe9Fv26UeuNKza6mPcD2glZujcL6v9SrRDWZELfrB3dhOf4BfMYXTLAQkhFw?=
 =?us-ascii?Q?VYUc5bIZMfyJ6erHzx1hhpkG9geqg390BLS2f2KbUYudWF9C3dJLTEqOwEgg?=
 =?us-ascii?Q?SfcG4GgdKNHg7vuNrxDkGEQMtLjGxNmj2q51wcLIZxnd5OWR5X5g3ICGdMrL?=
 =?us-ascii?Q?whiSFQFNWSMO5FYfZHTOBAk7nWCDYdGpCeDLjtDwQbl1O4v3IPKI13B/yAzh?=
 =?us-ascii?Q?zY3T0et/hHUgjI+tc/CkqTX92k33f4fHcEMMT77kOAd0qULpbY/ljibEVrCx?=
 =?us-ascii?Q?1h/Bl0bycCTMly9OJJuY6lanypce1DTZHU/QzgZMpVoeU6yWkH8ikUZXQ5AK?=
 =?us-ascii?Q?i67MOvJVPhA+6gBmXGGDdxJptLvMybwU46AzJjBNag1H6dgSAvhBhzFFpgBy?=
 =?us-ascii?Q?mmqAJmv0gU8vpBPy3yp2c6s/Jt1lJpFpMjOf/AYgoYgnStbJVdIazpqmJGsE?=
 =?us-ascii?Q?e3gkjgUYwxzFK9V5JWrUWHnCPWAXTP8l6ap5g/S+/v2qoK777mwRzebC9NBH?=
 =?us-ascii?Q?tjnzEBLcSyz4IxCITwCBv0L00SEbXbJi6DYiv34AIlZATVO4d0c9nWQ5Zex0?=
 =?us-ascii?Q?Ncs6ZG0jyTrKOq/ZVXEQ8p6qxcex2iehH7iuS731r6qVNYcptOvngpwlHlBu?=
 =?us-ascii?Q?Kmw4qXn6FGbJ8PsmnRSSDv0fW//ai5w/604vph8RVfPx7D9qu+3dhi7nmncs?=
 =?us-ascii?Q?vKlZ8w1T4moUtdGAwF3tjn2JOZGSq+fdTsq4zt+mmhuDyD/9F5j4UXxj6UY8?=
 =?us-ascii?Q?F5i2ZZ3eTVFG7jBi0JCDtGTwNX5qvOWhi1JT3dHFDda1Ss6RJ5WvBbLsFCIw?=
 =?us-ascii?Q?PgCK29/qBRcc4gRVYUPRTcGTi961HROl+PdJgb8rwAa+b00PYrmznTfedony?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HRqRxRPuBZC4idJKMnDUr1YchsYkTUDdDpPz+N4SJbMobLv41u3rfxfMZiysCK0nKawhGyudebPCLQHoQLRK5jF3h/aeU+M+lE70UrJHFoco0SuLPfYWHeK+u7zP8t2cjPcZna3cSlCUyJNzbeUKIQOmJYdQ4tbJttppq+8MM3BwF+3JzRi61b2NuuKz160SY35uR2Qk54j/TLSxdQevIPyqBFOHmsqhbNoQGxTb7wbMICUTW50+EBlYZSapntYnKPkduMzbGZLLc+b93PB6UMbfxRhnsc6BQQzXfGCdsfqG+PVAPOaQY0WoNMYgcRa4GmS3O+LSrjnu7vlQkCra6pANR7+HjHZI8wK7HXMACnF3XNb4yiG4zMs88jTTsA65Giv+J8S+ei0Q5ZK4qBCprPvsdcA0dFx/KgkF0ST7uWjpiphX0C3feKKF+PmcV9FFigF4rNTYJpFJ7q3MqjTt1zvZXTOFHStMmYdZVN5ZZvbt/jgWs0Mx3cwPJAS68USH24TC73HTNHGiA0vErQkgZ72RapEGSGKTabOyf02UU2DnyyocfkrnK0eE9JbyXl27H+MOBTdHkLs7mv/kMrTrtrrI9ZWS/hw1UzpjfuTNRiU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1666641-c6bf-473e-a86d-08dc1ba9659b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:34.9542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBGxhOeyr8vb/ohZIaoDPwjThcxIMkUFIshzbCGEQNGQSHsttoCuW7OoGbmUpllSBmMrsMut+mRITQ8FWt2FNNfHbKvm9KW5rCcNfhFBZgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230001
X-Proofpoint-GUID: 0qHuI2ThWxFe43NUuGoGnwwZIbsdAQFp
X-Proofpoint-ORIG-GUID: 0qHuI2ThWxFe43NUuGoGnwwZIbsdAQFp

This has spi_execute have scsi-ml retry UAs instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f668c1c0a98f..64852e6df3e3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
+		/* bypass the SDEV_QUIESCE state with BLK_MQ_REQ_PM */
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = &failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.34.1

