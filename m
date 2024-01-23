Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6D915145D
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969367; cv=fail; b=agdhwurhb6V4vIqIS2oKrhq3lDig9zfRSYY7dP/v+YTgKgss0iB6h3P26XBY9F2BvILEy5IMtnREPvkDjTP/jI7EzGOcbTbus2h/Le1oDHIUya+lpNWx0c35x0g/an4UCx77jJc27/uyJM+6moEkW8sYbBrBbqQ7eDIutWlJLgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969367; c=relaxed/simple;
	bh=8CJgwSIO5PoO7ybAweyyIMcfvLQVZLmTF3Qa0nzkyY8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Th/j2cF2QLNyl1XJsO/Nh28EBlqk/pwuEadWB3OKBWUJH1tiYqN8/yaUO42jkh3IgldY7wZvp9YICa/HAPlKBvyRd87X/g4U/MpIYuQIgr4N+n8XpCtAFRuToPlDz5Bp6KcgwTJs4oBV+UOu1CzsHxNeF1WL3oiLaTbTKsK6wsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J7JJNcbi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m5c9IDag; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J7JJNcbi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m5c9IDag"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMpgMp027295;
	Tue, 23 Jan 2024 00:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=dqxpXIyI4r1BiHnVa6Lzrbr1F3giMSEwLBoYjzrQ3MY=;
 b=J7JJNcbiVH0fmxdHxg2byWWS6l8W/NsQS6pnxEG+xUDXN4nxyKVn3L7n5kAXf4Xf3Gyj
 6iznmCr27lOtDywO8VlgpEdTA8ellWXsAGzDRH5LQhtAQEpjaN4OAWn1UG67/MrCpUah
 VgSIQRFsYadJ71A8axbuvSZjIvZQCfKw26ToQ/nBTi3YyPBByCc0haZfO4ouxDbGXWcC
 rRCtfCM3IUlm+A59UodKFYxtc/UHQUFRO3YGA/p+tZXn44uvd3s7E3gPRhLf5xBhPdKK
 1qMijyYUVhlzgNQR23zmcTsfkdUvaCgk+zrHjJpGPAWjQ8swrgxU6edfihx2b2ygK6qG Xg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cwcyjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMpnhC016243;
	Tue, 23 Jan 2024 00:22:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32q0qyp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdY7vlgVGecltqv8MGI9HgD38/DO6W1UIgxHsni9QjNdLTyE3WOUt70q5qh5OvLaLynb1PC2mF/2nABoVW0T+KHWgWsJlSRKiJd1X2uFTIYnIqArvLJJjE3qUd5yxz+i6NH+NitKvzZ347CogFY89e+vp5s9N824bS9+uMncZI6M5mvp5W/Ubuk4b0SWY9LXhSwzf7DECtTDlAL9poxtGzQ6VhNtb7FLS1I4q3b137IX0TbDX3HIplyqhit5R2s3ohf7LOK2uu9YW9sdM9E+dussssHo8tRMGrfKGDggEw6i1FbiXFu1kpkjopUF5g8WWsE5r50a8h6EP8NvN1V5yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqxpXIyI4r1BiHnVa6Lzrbr1F3giMSEwLBoYjzrQ3MY=;
 b=U7nGAJjzJ+8hatK8NjuFt1qrUJjBkzw+zkCzhVVnPQ6tgrpC3w00g0CTR6D1qcydmw7Upe1r6VS+8sDl40RHwj4AUj2La8NB2BjInbUaAEbMaUkaOeaK0e/wW0jZSRt5lRZBZlwHNY8rj1uDqssmsQrUs3ejO7c6ZHs4wiumpzlPmtUOKWYBYtaZBSndCTMhNn5O4Igas8G03OQTIPzy5uFNXT/FmWZ8C1ZCqlnVjm6gTtZNecNs3qdxdUJw0JWl7BkdRAg4DpBaTM9qcm5S/OEa9+7BTSAvcNwfl4ct4fGJfNdj3/ajbs7Hw19T4LRvNSKN845QPtpSNmFu//iq7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqxpXIyI4r1BiHnVa6Lzrbr1F3giMSEwLBoYjzrQ3MY=;
 b=m5c9IDagdF4ngoVGbGzJsrwz0T0jvTEX2XLDvbW9tNs7nzv1PXqcJ4j+YGjhw3UaKQ+bc3bQPNBOZcymRE2sj+uPSnCrikKvGRxY0cHCXNd3nOcUdXaOj7OCa22JuFeOxDw7dtjxDP2fqRegbmDALVWOOPl1bXPUtWSgsrkcjyw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:37 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 10/19] scsi: ch: Remove unit_attention
Date: Mon, 22 Jan 2024 18:22:11 -0600
Message-Id: <20240123002220.129141-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:4:ad::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: cf7a3741-2cf2-45e8-544b-08dc1ba96719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dDFXiOcNBOEDTDyx88VZ8xdXg32udJ3hrzoMN4TOckV7oVLF2ySmCuFL2sXkOywJBtUVdy7x64vvjNI+Ck+Qx6FtNFzburqmVcta/0P9R2p4IJrDX+0ktqDHtVGaGtweZDP8pceMZU7MMFmHVHs3fL3lK1Xv2YhmQj0ESGcEpd6PhtSe9UZm9+44ne1cRXD5HnPnm11U6YLVTujEo6NJcYxh1tfOyvgIF18X8NaX1rRR9MdmcnZ8DF00TfCtilet1dkX+2MewLsWIB/PSFiLs/8uAyupCgNiuhcxZZsfiEB8utJ4Cr6fampKTRAX5Njm01bDrRc5PlN1ZiQS/xUo+8o5eYOZQJpSd4XFtLjG+11XX/7H0imFPzx1699l5TGGYCkALjzvyDAP1L+ZbaXAUPOqlX8DRjm9tNPUiiEWUvfKiJtd3zcfKelWlqmBnlKnXXAa0apxuRIJNF3hKl93Mn8aPQaVCP7IcXLqSA6OlzMSsk0OAZgts/B9MEHynpqIxXKNrTUZjtw5edqAPv6x9AT3bAlqTEjOPxOEPaUumPJ2hpWTqbcm9y1iGzdBL6Bh2tggqsNMLGtY/G6n/RP1Zhg/J7gDjcpUtKrc/pWMba2fHyf2BkZxgJAU1T1VrgIY
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(4744005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?H1Zf3wPwlJx+Ze1D6ELYWfsHf7fqJGwodCBHOAGzo7s0xNjS0QCADGpsdqJj?=
 =?us-ascii?Q?9q4AjHzQb4qSjC2bGSTjRH/LyrQaz4o7j4VevoXFlpROXMBUzO8go5t1OpZ0?=
 =?us-ascii?Q?fDctPjzxltLAKvS5J5JgSdOwtyS+0gE4UNCyfU7cmMKcl2eCWwmL7poJUxtt?=
 =?us-ascii?Q?G0DNEnJsmc9BBYpfaf4bOGp1FR+ak/LMiuycsLHYw2cJvgTX8ZE02NwghIJs?=
 =?us-ascii?Q?Oj0wCeMGeOg32XG/4aBVSHJpef45mV4hYV2f+aj8Iw66kn6L5A9WL2v+vJ42?=
 =?us-ascii?Q?BWaS/0oc8YcW5Z+oN/mHK4IzWctryo6USV0ahiR4WXiJGoOewj5/XkdqZrUg?=
 =?us-ascii?Q?jkwKEYC704xFry06d7ydydzkXS8RKg8EIiUd+iXqpg3w5WkalbXdSP+7bcpv?=
 =?us-ascii?Q?5aL3VMS6urp1Nul5BbZieyolwkoJqmK0hWeec/exLgyqHlv53fq8xIrOFkNL?=
 =?us-ascii?Q?GxHKp7uJMz2yBiMwj1JHpBPRdDNQ1cIJBIoz3pO5XtV6bDPK2+DzoegtUOFU?=
 =?us-ascii?Q?qrJveu5hRxW4DlRhpSUnut+MMun+MidmG7jJz7msTyJJvX346AvF/PYV5kX/?=
 =?us-ascii?Q?/J1enwVIqaSyGiM0bXRuJvBeGWr2Tf+glNjm98wsmrJFNVUlQXALCQ45swgy?=
 =?us-ascii?Q?diZkMvclWqSidjLhvamUsu1KhwpdhSTlZ8Wf82ek124UrUkoLCy59GChEXSk?=
 =?us-ascii?Q?eXI0ATQePob2Vc4zjMQgtxvOdGZWOmwLG37JYfcwDeWx2gWK2nTDVAOxYipP?=
 =?us-ascii?Q?d+6aAFZtnupKoKiFV7Uv+qd4kDhB/pa4VX5CLSV6H6FKqWwwOdd78c8dU5fK?=
 =?us-ascii?Q?X6akbYO5UbySrIOvJ8Wa4+Tp4o/NsXBbsDvANNGVuxHZ05mSFODkpO9WANli?=
 =?us-ascii?Q?OuySlrYXHbzGAalNWPrXcJxk16zbEu2Cm3fF0uhoUGsjK9eu7JuFzQqW65tm?=
 =?us-ascii?Q?k9tD3b7+DV6hrGE1CMASawzjt2ZJDtTFRIIQoWX3JhEsYQp9VJegIw/Rp1OY?=
 =?us-ascii?Q?bTHwKfzOAePaHSLcc9Q2GTye+VrxE2umyf31g9Xrgz6564UDoWcDAtEgBfUK?=
 =?us-ascii?Q?WEMR7XosCigy75veHzFtrLnECv/X9tTDCPMGtuhwzW8RCMDwF58Bnw5uMiPn?=
 =?us-ascii?Q?PucSgjDYFpMETRb47mM/vcolgzKDERZs9y1Or3OxH6qDzvG6QiZlU7HYn/Mu?=
 =?us-ascii?Q?fUcnoK0iSKoJhFcWoxISdu1CftzAiSy2KeMSWxg3JWSalIGlOsrLIkShFhFt?=
 =?us-ascii?Q?UzaJ3EvCGhHFbqO/34uaq7GF1gBPGtpuYO1Zevs2mezLDxn9yU5RoigW6KW9?=
 =?us-ascii?Q?ec5+zG1aFJy8ZFL9twD0z+1gq8SdwOpLwR3RZJuEjhlqWK5iaivKr5qDEg3e?=
 =?us-ascii?Q?ULFitx4gwheXU2smo3CF1wnh9atTNRR5QO9q5nVD3pHtaxEntlTjkgbFHJ6G?=
 =?us-ascii?Q?iLoC1hngVZ+/7F6gpV+e4whEt9Fsfo1okG1T3SL48p9Vwd5/No91Hm9KzK4B?=
 =?us-ascii?Q?jQwcIUaTEcTqzFS8kjPpE5YFfJaCiGqYDwfoack8ImTSbrrnpTKhMuDTdUmT?=
 =?us-ascii?Q?XqQZZOtTgLXmgBSj02cw4ifE8eLYPZsP1/GoHYzLQxV0C7fIlSYbMbk7YtBs?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LGS2+H5u+PQoeCQTSnJD3CJNaYV6McEqAN32BJjoc/kQsyiifV03llwnJdxmJcVH5/IHIN6LendmW5zNIsjbAbKKdFlIWoS7W5+1eKL5dv6/BfqkJXtwV1/IEyKQfFr1X0ZXkcCC085Y7g1bS+Kvtsy1qq7N1MyxcqIKUrdTNsc37ySU8FwCdLmM40nhWMgNcfszz4AvM0aYpRYTHTW9oG4xEaoRMxmadhIFUGp/gfe9LteSfkhpgDAJnMtMWjyf4h0UkZ2i7kT5A1c9lt6Uam/ILMZesqZxCQgJMgb+1Yi0jIb4pCkp1Pu7Ap6SGmoH16QtAl/AIsQU5nkVK5jrO7nWUMWGev9R/u5ZL3xhsXW78vqno7YjrBZtoq3vteo4GOIC455c9hAOvPS/ajgtZdcqk9Ew926UZGZCz/E9r6PW/AtntiHFADzlDIeZxi51tfa6S3gxBf40aTQWXfMI7buhNKKFfFcBFiMdVXUjRJyKjaYL56zT5yYHNS0he5AbBL79T1QDmRHqpoN+jxcNOuEgf3l685EfZSmkKi4wCuTSoej6gx+6qhIp9FZy0gk8U4JMrt9p4QNaXElmQTxQKn4vW8H6AlEZ9Cq9sgzDh5k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7a3741-2cf2-45e8-544b-08dc1ba96719
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:37.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XC3rQYAAa2dsEOWAWZf75WXNW5zaObTMH8UgIQ1OSyWMDbE5jiq/Txctuuy3HIg2YncoT3E6WBhrduXoa9BxJMrdCSu/F8yI8TY5QXKkz84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: t2HQgz2Z1iVsGBoyMh4oGgut_TvBc38D
X-Proofpoint-GUID: t2HQgz2Z1iVsGBoyMh4oGgut_TvBc38D

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2b864061e073..9d7fa097ae9e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.34.1

