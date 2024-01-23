Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14E1350D6
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969355; cv=fail; b=WhF/o5NZx6i6BB+eOER3NNE7uSQmF9RBgsoYgGFI6LhRRpf6Un04F/tAL4WGvH6r6MGb2JRFzpBIcjJWUfO6hmsAdpORfhbFknP37tHJ6vUwH0OS8amzEYADzJrdKJJzMx5xFztldglswLrlNPtTLB0NyygIXWLGa/WgfAeBwFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969355; c=relaxed/simple;
	bh=p3V7Q0dtwSQshgU+d4DgMc7NWrrAjz/1LSLOkpETCiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qzLobhCFNIif0nSUh/U6HQTXTfXZ/btcY8Fe8X8sPZswn4lKmDCPQuPsF1XB4QLt89Vg8JO4vt1DQkxYH83ocNYC3AK46JyS7EZUfemDfVVk4OJzW4s6oK/Si8HtFRDlnzuThj6HQmHnpd7osdIKcT7iXfn6b8FlHdl8zKoJTYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cyOoGNSI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YtWCkwGk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cyOoGNSI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YtWCkwGk"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMp4td004497;
	Tue, 23 Jan 2024 00:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=mR0yiQD4MCn0rx6HdYDg7mcon75rwJ6bqV65OukiEgY=;
 b=cyOoGNSI1DJ7gqDA7alRW02NPV0mbA1y+8D1NS78+X5aiCikxJDh8bcbR1/Q2dPQ8Xup
 IiEUTxG093KeyhEXdXVHaT87+R3hVKU0tQy9PyFfGf8Gu1csRvcq5xGzcfyBnpo+dOqg
 a8p4z5KTvXuBjog6sgW4bH416KQdHy1AO9kmP3H7Gi9d3owjbOPq3IrbBZPm+Z8pCoyU
 mAOeSLtmhBikJffhowPm1zbERlF/+4E4dzRZgh/9RWQL4b3Yya2AvAGb+bHx0Pcw5sno
 fdMJZMmYEtSZoPgahVul+uOUpHJpGf3JyaeVEsULv601ajATZDV3BAuZUYXMrRjTornC Mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cxvw4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoP94013174;
	Tue, 23 Jan 2024 00:22:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3700jge-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTPV8o4UO6NWOg9GtSZgM+l2lRQKdgTfoNkFAAKK+OtfCXtnoxKd/MmdhJ3+y6abHQTYYQWlLaAJazhxWxRWFfdD+Ms7bc1nbM0yqCpYlxLtE+el2MjI8d263xC16aQ5q6jcGJ23EKjUaGg3UCvJEucZXJrsEEOdj7vJltIX2Vr4gn9FHbVW87eMsaqma4CUuWiUTakpHKXbaLW4L9AYuQdsmocCPVuA1yKEr+uH/Q56PLiJO8OtmAPDJNnDPGoP5hTNybsMmTGz+v1BCMkjZW1rte15caq8ngATKFDTfRp0yTSLBAPpc11b8U0jfATicEbI0EvEQZ0onx3gelTCOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mR0yiQD4MCn0rx6HdYDg7mcon75rwJ6bqV65OukiEgY=;
 b=amifnug1MIGjfXm28Eajgc7UZzoF169nnV0vsnhqhiV/pf44UJ0hZhkC7eWPigqqvTmdO9jN/Iw/FYEq3egYxRNX2qY4XL+0lCFkI3CUBo97bGYoQdAvx8zlHe7GkOcfDFWLxjxbxkPMoK8PizCxoFJdtNdOd3oL6gqOtea71tgJArKuMEWh8GdojcHh026QXo1oe0dN/lJ8LGeZMaXKyMffzXdImswtuo0o3gE+X8BdddBY10FpIdiZYf3D/eVZ+p2g07cv4CGjFrY2XAkJoLuyvyJlNHZkxdk0b/M2tPp22BwmncWiiHQ5rI88HP+dPZHugupZsPdCZOsk4z2FOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mR0yiQD4MCn0rx6HdYDg7mcon75rwJ6bqV65OukiEgY=;
 b=YtWCkwGkb412bNvT92dgOARcrq9vlHRHzf4JHK56vVX//BA2SYQYlO0nkefSHHCs+w3Q0i+0fK1CNcsEnUWMgYiI/OlX18kYOXw8tIKRFxW4hAGs/5GD8DGAgQOoaCwJXQe+FnA7Z7K7MH71FsgxmAXPMdM6cK45FvXJUqpOplU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 23 Jan
 2024 00:22:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:25 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 01/19] scsi: Allow passthrough to request scsi-ml retries
Date: Mon, 22 Jan 2024 18:22:02 -0600
Message-Id: <20240123002220.129141-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: ca79062c-c4ca-4ee9-91ba-08dc1ba95fb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	805bbuIKmKmJQBuKXAt2UZbW6uyVb5JYZnNdaIuv1lLeeyoHLxzLY5FVl5Zog8LOxbpWkejyEiZNgMnp2HS3F8wR7kVUnmi3HzCJ5xQDzDtmfKGoK+g0D8RE4N6DdT1quoAr1qYEbjlMHzLra/VZtzqvuTQ8x7mCeAFlPgk80iC0/ls1Vr8dUqTtYkm8wihmJJopfeerX+co91NWIdABBCllY1n2qyLQMWcBLT8TRXEAl4PhC9jhJ9QFmNU896tN9uk7KuhlJVUuBIhqngtfPetFKQZ7R3VNknffvu2SuRDI79hRu/xehb6Wn+1cfhlpe63/06VdK1ITPjV1xnhNyfDQDZ1hoWbkOn7xRT7hbBuKxzPySFVZduz1RySaRnaHiGQKPZYOXdpdCVB9Ctn8hBvASvQLbR31G8ffQyzX6AP+sZbs00iV9OZgNWCs5Z/GUb0amXHptmyqx+0AeV8AbcOI4va1vOckkIMEx9cAnbiMDoqSBz9ONvjBQe9KttMg9+wS3Zr4cP7eSyX0ZLj4HGqDtYaasSK65d08KdlfRmcxrj0ktkpwe227/xhvTHbJ
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(36756003)(86362001)(83380400001)(1076003)(26005)(107886003)(2616005)(316002)(8676002)(66946007)(66556008)(6666004)(8936002)(66476007)(6486002)(6512007)(6506007)(478600001)(5660300002)(2906002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?A2Ij6c1rAIoge9UrHa0Vd/cJ7f0ghh5U0LOTfGjMi2DlqB8sSehx+AiN/CWo?=
 =?us-ascii?Q?5X366M2WdOtH7FgM/By2mwQtoLts+u0ZAT5qiueprSNPv79kQsyFurCHKDur?=
 =?us-ascii?Q?/mSUeE3RZy0mPGKVFz5hHpbxx2j7dolERzZL0Aj7B+ygkRX5CjRHaujXDi/n?=
 =?us-ascii?Q?TdBwMjExjkmElxdlzAelTeyuVUcdHZ5xZ1DTiRZWo3fEY9JeUqLaDbCgqPaj?=
 =?us-ascii?Q?OuelCnUMDBEmHFDfakoteroMWB+se3hJBi06l+/urUSNedIaY9r07CwJZDQV?=
 =?us-ascii?Q?u27aeSy2arCNT/vjSamxxiau3cllP52ixYKxOQJIdIc2yHGYhodcaKAOg9aW?=
 =?us-ascii?Q?C2kdhqfR1BUNCMIy0UVf0/rZ3WTSmdQvPDjjI0t998Q4/dPithAGoAI1zEAN?=
 =?us-ascii?Q?O4tB2ywKYD3wBcLEtfSlvYASGukgm6q6svouykIEJoeZkxdYfTADsgY0y8ok?=
 =?us-ascii?Q?Hzn/H/YTudL1VbsJgeMoKTkVBnDQb7jnaEaVG0ngbYhsGKra+AI960tX9Rj8?=
 =?us-ascii?Q?UR4v/wPWx/Nj1OmTAevP1jMHnkqgx7MPRraaYrPwx5QImpaXAvU+Snh92JiO?=
 =?us-ascii?Q?59XpInAC3ZVi9vnRacKAPqiE2cMP5JBoU/daTRZe4TDZx7NQdqs2DqA9gBcy?=
 =?us-ascii?Q?0oCxn56Ym/1fxh7AkcSNW93Eb/+78fWkj4pcKzhyvCsxmSPD+F97dgfBSqvB?=
 =?us-ascii?Q?pWQOXCIpPXYXIxTcyuMzHvaMncOxGtt9OEAgs20pDI/K2mI8VWT8uugJupgT?=
 =?us-ascii?Q?g59o9chU2HZczxYYId56B+cGkxn3gT5MiVYHfq21RC2HrlGE/zPZbzKGth8G?=
 =?us-ascii?Q?t4JdCgmLo4DooxxwblUIyTaJOVW2Zro2kc2a1JetboEF5S8njGwXh4Gjp/bR?=
 =?us-ascii?Q?lU8otmiXzypw4kwHkcJaiWMV479JkgivjmEnZZbz4tsMgIfCaCgbRARlpd9X?=
 =?us-ascii?Q?7gZnkHzhJ38H6CbczbW1zLYP7Vnf6SiHCAcJwtTllG6wyaVawVtBi+IyNUh8?=
 =?us-ascii?Q?ieoSO71beJjc/pRcKIpcTbkhTW7e1Os179qYziBO9uAww/lpNiwQwMiCm3qw?=
 =?us-ascii?Q?mz4e3uig7ia0zmbSkL4tNnjUGsk1mUsGLc53gBOCSDIRJgSstFWYQH4EdoGz?=
 =?us-ascii?Q?KdmwncdrkeJUsFt98ZODEnQukQDBRKgNxiMMoFtb9V9BWgcO0SSjPwj/PEzt?=
 =?us-ascii?Q?ZsaThzQ6gDmKSXbqYdc93dKyYyeLgQWrQ/HoTsxZyh11QaoOgiiCdbBu4nhs?=
 =?us-ascii?Q?EFbW5COzKbm5d2RS+C8jFkGwh1Ck8IMbHf+nNDKgGgL+Ev11p10SHhmOIgAJ?=
 =?us-ascii?Q?oTulBx7UD13nB1fNzZNZguM3Z8t3KJsIEFu38kHommJ/RoZ63+s7mg99bJby?=
 =?us-ascii?Q?cNdtVKrpLUHhHoPC9VZjtHL8mm3defC72Yh9vQ+jZ4Nw5Bm39ZpxewdlZy15?=
 =?us-ascii?Q?SI1/T1J1cter+AAKMd8yZGTbCdLQLlaMTY8JGY0FuI3Mu0KQVKf1JA3xFipT?=
 =?us-ascii?Q?FHw4Htgd0uZ6bRU5zkMWokH2TSu5G7DSW1YLUm+sszRHokDTWKCIgrUGUNRh?=
 =?us-ascii?Q?B8M5+H5u1ZEqyQNyoST/7hut0sCNpR1Kml0H1ZtMuCUpoZ4PQT7ZJhj8N836?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tRE0BwgSJmIVOiUlpXNyGR2LfHlEI1QgAXydoVpWRYjVv+K9FB+/rGlDpsf2ps5FDAevjT0XhNDvpJT99eQJ/+zqo1fTy3N/BaEJ+O5LrnimEOTG0Y4H66BkRQEn6pHA5gwnHiYoVBiIGKGgv2PuxkG11T86Y1GNBkoJzCwxZhwnUo0VXUO5bbWb5UpnlpBtlScSmC1OSWIjj+NE0m9gs80ZHpiPPxdyMO001bU/oVqVnoNrOHkhliQUT8w3Kr9X5Eoiwn1cjzO6CbpfzrTCcciXxTJgURe5i6qjxFgG7zNz6dA7AX1uv/Oy5VeUVC69su6dYiubAjX4CnKFx5M6QCoUNdQgVBz7oK8Snfi11+S2mwfwE1RTs9gZvvr0AMZhOX3iEkrijW6oYD+6AH39Y04Xrzw0FWe+AY7FTQBdJh9J7gCOQot3P+RQBfd6ocSXL6QAgs6FJaZkBzEN6VbVUiV3O02smueukCnc4a3kc5aHch32IEqI7z2dZ1fw4euwpg2n9aUub6db/4gpEkE2F1IHD6Ii0qrKhVEA3qvLdpbH/CFXNDqj+rrrNmr8ZWKgWZ1gcz3ysqw3fCvoIJmDybh604lhqpF1n3wWBmS/asc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca79062c-c4ca-4ee9-91ba-08dc1ba95fb4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:25.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANgpC8RGGWWTPLj/IDg22CDnis6s9sxQ8s8+trwRQh3hlrVBPaEsuQU+tydzA57DL9f0C0YVV7REEzB9EknoF52BuWhQf065ZEdmnXc1z4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: RRDwgnQuHpvOGStdFDOMHvRWA-ZBOqeD
X-Proofpoint-GUID: RRDwgnQuHpvOGStdFDOMHvRWA-ZBOqeD

For passthrough we don't retry any error which we get a check condition
for. This results in a lot of callers driving their own retries for all
UAs, specific UAs, NOT_READY, specific sense values or any type of
failure.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
a lot of their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 98 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h | 48 +++++++++++++++++++
 2 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..868f23517d33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,92 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_failures_reset_retries(struct scsi_failures *failures)
+{
+	struct scsi_failure *failure;
+
+	failures->total_retries = 0;
+
+	for (failure = failures->failure_definitions; failure->result;
+	     failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_failures_reset_retries);
+
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ * @failures: scsi_failures struct that lists failures to check for.
+ *
+ * Returns -EAGAIN if the caller should retry else 0.
+ */
+static int scsi_check_passthrough(struct scsi_cmnd *scmd,
+				  struct scsi_failures *failures)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum sam_status status;
+
+	if (!failures)
+		return 0;
+
+	for (failure = failures->failure_definitions; failure->result;
+	     failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		if (!scsi_command_normalize_sense(scmd, &sshdr))
+			return 0;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return 0;
+
+maybe_retry:
+	if (failure->allowed) {
+		if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+		    ++failure->retries <= failure->allowed)
+			return -EAGAIN;
+	} else {
+		if (failures->total_allowed == SCMD_FAILURE_NO_LIMIT ||
+		    ++failures->total_retries <= failures->total_allowed)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -192,7 +278,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @buffer:	data buffer
  * @bufflen:	len of buffer
  * @timeout:	request timeout in HZ
- * @retries:	number of times to retry request
+ * @ml_retries:	number of times scsi-ml will retry request
  * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
@@ -200,7 +286,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  */
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     blk_opf_t opf, void *buffer, unsigned int bufflen,
-		     int timeout, int retries,
+		     int timeout, int ml_retries,
 		     const struct scsi_exec_args *args)
 {
 	static const struct scsi_exec_args default_args;
@@ -214,6 +300,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
 		return -EINVAL;
 
+retry:
 	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -227,7 +314,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd = blk_mq_rq_to_pdu(req);
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
-	scmd->allowed = retries;
+	scmd->allowed = ml_retries;
 	scmd->flags |= args->scmd_flags;
 	req->timeout = timeout;
 	req->rq_flags |= RQF_QUIET;
@@ -237,6 +324,11 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	 */
 	blk_execute_rq(req, true);
 
+	if (scsi_check_passthrough(scmd, args->failures) == -EAGAIN) {
+		blk_mq_free_request(req);
+		goto retry;
+	}
+
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
 	 * garbage data together with a residue indicating that the data
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5ec1e71a09de..4dceabb9dbe1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -489,6 +489,52 @@ extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
 
+/*
+ * scsi_execute_cmd users can set scsi_failure.result to have
+ * scsi_check_passthrough fail/retry a command. scsi_failure.result can be a
+ * specific host byte or message code, or SCMD_FAILURE_RESULT_ANY can be used
+ * to match any host or message code.
+ */
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+/*
+ * Set scsi_failure.result to SCMD_FAILURE_STAT_ANY to fail/retry any failure
+ * scsi_status_is_good returns false for.
+ */
+#define SCMD_FAILURE_STAT_ANY	0xff
+/*
+ * The following can be set to the scsi_failure sense, asc and ascq fields to
+ * match on any sense, ASC, or ASCQ value.
+ */
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+/* Always retry a matching failure. */
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+	/*
+	 * Number of times scsi_execute_cmd will retry the failure. It does
+	 * not count for the total_allowed.
+	 */
+	s8 allowed;
+	/* Number of times the failure has been retried. */
+	s8 retries;
+};
+
+struct scsi_failures {
+	/*
+	 * If a scsi_failure does not have a retry limit setup this limit will
+	 * be used.
+	 */
+	int total_allowed;
+	int total_retries;
+	struct scsi_failure *failure_definitions;
+};
+
 /* Optional arguments to scsi_execute_cmd */
 struct scsi_exec_args {
 	unsigned char *sense;		/* sense buffer */
@@ -497,12 +543,14 @@ struct scsi_exec_args {
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
 	int scmd_flags;			/* SCMD flags */
 	int *resid;			/* residual length */
+	struct scsi_failures *failures;	/* failures to retry */
 };
 
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     blk_opf_t opf, void *buffer, unsigned int bufflen,
 		     int timeout, int retries,
 		     const struct scsi_exec_args *args);
+void scsi_failures_reset_retries(struct scsi_failures *failures);
 
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.34.1

