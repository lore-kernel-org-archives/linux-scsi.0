Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0131350EE
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969359; cv=fail; b=UUsqPhJLj2UqA5s5cJ+R443nk/bcGEJ3cABuYKp+GXibCXEZi6eo5yTMT+76KXqc21up5wGoDCtWXqYRSACz/p03FcFjRpJC1APcG+yo1cjWihRbwf3jefQdV4mcEzlee2+q6TlKgV5XsW1IQpKjPf5OH+1/bNUTGF2pnztnxAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969359; c=relaxed/simple;
	bh=GDSV7gIHPwzsk/XcjEpt2JdM6Ulz9/VDrelPMpb/Tac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kQyZyR8U3OWas7gdtqBJBh7Tty+kB57SFmBzkmUFzA2HmgY43PtSwlaC89jmL0/EHtD/4LJ1AJJ9+iQEP/xHODSwpGKeZJ+ahgbZn8oxMqoWiGbvPXCddDBWBB1qeKDqQANU4wXxxS/fB4sIPiaOv5XuuIkHuKXAHfPXLv9r3MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gVlqF23W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JM5IXfA4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gVlqF23W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JM5IXfA4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMokhf004020;
	Tue, 23 Jan 2024 00:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=8umrS4UN1BNOIZF22PBTSTJ8etYSQ/9CVKnGMV52/og=;
 b=gVlqF23WSP1TqAoPYVU3aRQMVaI6ecFGAJYPMvea6JY4D8GFYHuWdW1cZb4DGVbJ4FmE
 /QjfxitDNzN9FMuJyONxGQyYftj47X7JSW1bheT7xd0lEKFR9tONmwOwHPKZWrR5Nui3
 FTwk0Yw9C1mN8t6BLFsKEV2nJUsC1ERRiqZ0WlBF3kJn4Ljve5t9x7SQtej26Zo9fpis
 DrsmQBfR3L9CWpR6xluPsSV+U/DE3MvUFWV2ZmB0/JUj17C6c/OT423rOrAYiIJmDksU
 bo6WZ3HXu2xvAglGlcH0Kk3LXR7suFzM432+zomsIGcE0+1gn5xBoKDJUVJV6YiNBirC lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cxvw4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMluSt025289;
	Tue, 23 Jan 2024 00:22:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34k6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcO2aDklnVyPLR04IVsCWI7DnWe8QDQJm5+6wsKXJHUgsBvAqNl2a9qkOITJPyxk+SvTSlPJE6ocqYBGuUXx5SV5dRbrrQk9nlPrG7oSB36nyh/ofIB3J6bZeUu25UALCBRHRc8gdFB0+029Zuz1dU3m5G3YYfqOZ7fSdRqV3k5NEzrtZg/B5QPHjzFf4ptdlHErhZD+bqZ4aowPCwvNYnqU7cKCyw7dQR1Y5i2qBtKVCh6pH/YfMCXhxkJYKnUO0MqAxPz4NIGXDOHy0ce9SN906LHpinX8dbzoK6gGGQeK8PGWGeD2HKGTICbOQ6B7ZFtcyBzRmtZUKNJ5Ybqqgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8umrS4UN1BNOIZF22PBTSTJ8etYSQ/9CVKnGMV52/og=;
 b=Sar/Rzi0b5Yc+HOuMfgkhTAGyoiWXGrpCu0oClWX1tztvCRphiMYDlDQVTNhLbcSqtMJ4Lg5j3I2eezQB2srw4C6FJybGQ9ZOWO4WrJsCacC7WZSQUWbsWlHOKUFAN/+SQzJLnehIKvp8loQwaUeYuytmN3qlapUHdfwqD26hiCGqaol1/rJPRAoQSKvhZcqmknat1+9MDeVxCQ/g8Avz1Ra+x4okthe5aj2DHmV8CJRuG0arC62uGAbeVe+xa2Q7G/PotTVLBckgCUEXpRYr2jzS7KL0tdBWEcCl6zA8wz/9E3YLsL2u5Jl3jSOL/tH/i/0gg/bePF2vzpRvL0kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8umrS4UN1BNOIZF22PBTSTJ8etYSQ/9CVKnGMV52/og=;
 b=JM5IXfA4qNHkgNFLuQ8/JKfF2rGzhLViFAgFPBMbebT8sPA5nb+430n5jdWUyGraIZUwG08lSv+KAXn6u1rkZH/XKBQqF1A8OCZpQeSP6evEWAD5m1Co3y8TNHLG9UpMVn2RdQlp9u5DQf2YMGTtZblClM5y0k8PHlxbogXAoSs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 23 Jan
 2024 00:22:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:26 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 02/19] scsi: Have scsi-ml retry scsi_probe_lun errors
Date: Mon, 22 Jan 2024 18:22:03 -0600
Message-Id: <20240123002220.129141-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:5:100::45) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 97b26a56-2480-4972-0006-08dc1ba9608b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zj6KOmKWp0i1NuxEBnTaE2T5a8hBKrgOWwTTaQg3VXApP8l0ULyOvGE4RAgkXvTd68nXKOGjKqaneNlnoIVQY1m08qXWSA0uGmLDB5nG9fP7tVmiSv0umaAv7q6aYfkECjmoqUXGamaGPf4Ist0wFQ+w0i1+bAK/2QVhUQfR2zR8JSkRXMObI/GJINndFJAUmIXxNhFIAJepJ2x96VxvKkArEoHcAsLJe57qNhvn3i/gB1R/ouyaEuLazaHHyT+yjOuEcprWOXYUHqBuVNUYbCO1t1edYfASmpOadYMJZv0vGjR4X9EXclAL18aiP9epugbvGFooxADq2iwaQLoHP0Ea5a6FAXH/IpNRD74qvcrzJhbFM+cTBCyDjb7StD2Flv/gwWPY1mAn0srhZjFuZWTyrG3ZgTZsyTkKvb5EsYLl6k0MoOiLSlZcwKKt1upBRgtrWdsCJDrlp+sylb4A/qqtit0IsRHL87bFKWw96ojp8RikIAXyLvFUBCYaqZ8CweFIEBGxVIj9QwQqBljz6UzAt9a5VkTBhqwn1tkGCRjtxYIsI8H+zSNbJJs+mMHc
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(36756003)(86362001)(83380400001)(1076003)(26005)(107886003)(2616005)(316002)(8676002)(66946007)(66556008)(6666004)(8936002)(66476007)(6486002)(6512007)(6506007)(478600001)(5660300002)(2906002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?1YlHFnxD6JzqSl4oDZxTHBhnLDB9Sy53WhQ6KoG9aGImoam7zyO4TTXBKpEE?=
 =?us-ascii?Q?nmL0GOeRc00181GOqXhp0Q00QZ1lhkP3b2D8ETcWX3btO5NIOOa7eGgcy2Ws?=
 =?us-ascii?Q?qlwWkUWUJ2kwYlQ8adPJ1k85GsYvH+SVr/kgsg51bgN4a03gvoY67HP+tOpK?=
 =?us-ascii?Q?cX90SSeKPh3iCxz3Bydgu6MiU6uNsywhVdXV65+iFrwFa5m6YJhpoE7lV7cc?=
 =?us-ascii?Q?hoX1tMyOGhqT+mZb4IUvv/UBC7LUjc/XCma3rKZbeOGcVdF4EV7Oy+3L0nDd?=
 =?us-ascii?Q?HqOEx+NmLjQO1GoJvz4XyctfsbOR+dWnI/y+NYq6CPgbirjc2puzPLZ/b9gA?=
 =?us-ascii?Q?q/TqBW1vCk+RiCroYKMQSenYY7E7//cgz9c3+YIFa/NqWOsIQc/gOuGETjqe?=
 =?us-ascii?Q?euwMsQDCCiGqe14NKj2gvz9Z8JDI4ZaZHYI11fBBSeJTrdgakqT/RovDi7a4?=
 =?us-ascii?Q?8YaaBiBNkAxwVRYM1OJ22FFIi1MhPXDHWqt9Ou4ApEISUTjOoxXkC6qOUNto?=
 =?us-ascii?Q?pB1E66YJe1iWeEYfflyCvSVyWVltEIwZXWpN8PT6pxhByPhi122HL5b96Rep?=
 =?us-ascii?Q?ADXREs7v5z4OABuSohtRI1spO0VZ1aPX0Ye9Qw3g5a6IgRwn4k7CRQ2ePsFe?=
 =?us-ascii?Q?N1Qb+E3HRHG1BNsKbSv08qISYIm7Xnf5bn93BdtxkcuzZeml/8EGVk+oGHIS?=
 =?us-ascii?Q?JxIoqDp2e+akaNAJW4yoCZig6qZ7G8J9dKQjRy+EEKZzTnIfgMIWY4Ae/gqj?=
 =?us-ascii?Q?Xw3fTQLOK+1nl2cGOB0qIyu1QbG66xE689F/EcrlMVSiZVpjH9Pe8zpwOf1/?=
 =?us-ascii?Q?zLC9vpsqCVC45jGK3ljG2B+Sxgz6M9Ael8xkeKFb/NPJN0e+2JMp+pJ5uAZl?=
 =?us-ascii?Q?XHYG8MvKNOOE58cl9gXw8dtIzTxK309oYzMbg63XYi96mDbBdCJek4iNlkzL?=
 =?us-ascii?Q?aYSdWeyUp7Q/BuaAKXzJPwI+iiMWsi+5o60+4RBw/fQ6iS92iVH7CT00AUH/?=
 =?us-ascii?Q?5E5BukdyFrGw8qibU+EOIs5VYknKPjIJEspIbckKhde1w7fipzDtzEjdkOzA?=
 =?us-ascii?Q?Gxzz3jpESjBA/33PHgw3QJuwJhZk2i0SmGtu8zokU1tU6/6/VDChzs5Z6uKZ?=
 =?us-ascii?Q?ivaAl8Olz/2RfTj9X5rRdYupjTyZjIbuU52twNb4U36qC3PFMn4uZtKOv4WE?=
 =?us-ascii?Q?LZPgrcNeG+SB3KVP2MEBDiKVtakFE/c/Q9sMb+gkymAasYTWNfrOmbV7bq4s?=
 =?us-ascii?Q?0burNu8RvwmWkyiXEmdPzym4hG0pLgapRH02+05vfCs+oxgf/jCadbcbfYRH?=
 =?us-ascii?Q?tgymUap/QbaYf9SHbNgOuAuFsjeBGlU900j9u9XFHd27pV7LtRM12mJeJQVh?=
 =?us-ascii?Q?ciabh7UiOn25tDxEipVxZYyIZ2wKxaTkmW/95YCD46KNduiHjnIjmc0Dgf9E?=
 =?us-ascii?Q?H05akvW/edfDK26gDn6uf7JeKf3IJBr8QAVatnAqBgTVSFz92qyqv+UAE+Q8?=
 =?us-ascii?Q?nH8BolYiPtC3cMJE3zAtMre8KbE6+CSNM0JUYCHvvAF8z3d5HfkkIdshl7Ml?=
 =?us-ascii?Q?i2wDgN85qsPrLYia4KmW2spI6WVQc6kzEudCfdGSyukFmEwH4OIgppKXG8WT?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/OLmj50SDAMAXKTquFPabvDfd/LqkRVFPIDtycnXmmyVoaIVHKEU7Vn/g1D8miPTpgkcnzkrYwooW6OFL6W1pbrc1nJDjjGVkDammEx/TR374xXnfXHPfNk41fr7l2BYfbBu7m03Lz2eOlfRPOkMF9CHJi2Nqe9H1fVkttQZo28uY8Q1ZzVlGAPR8phD1r4+Nhdo1yzBw0TL4N1ZfIhdi3KIVQnvFf3Ze7EJWN/xUj2CclQ0kdynyRW27RE85VjRvY973kNckAHuL/B3yk1UplmVNpq9YRCIWCbwM9l0IHguuc6OFlhYdR9OsBcPX7VwRtIkVAq3KHcO158m9fpibURMiX1riA3RKOHnUbbnfh+pbD2eG7ItgZcFU94BydtAiH8+gce8H2ZtQBtzMho01rtqqpPZ7HUDJecxZYzHvm6+pNrcIB19OlYWNJYuhuW1O7pmxKSxIzQ8btVQGB5bUCV9BNx9sKaxed7bfgK+Z+hh/fLadJkkvmt1DCOsFmfz1ZSs8dczTRwPSvwV0aG/AhtG66Ka+qQapMR252LpRqLwjOjwjzkqX0SrZBM1YrfZ8DabXd8EkM/TMLblZfxQEZb+gk8ARi2yZTF2POrWvDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b26a56-2480-4972-0006-08dc1ba9608b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:26.4249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikQ63xYasfMZ1LEScpQxPo58Fy+iX8iw1hrsEhw91eJZkWl0DUyIyzTKukdYPZN9dM/fQafrM5oDSrz/DEqgmJbDTFyJEk2qa1CPNqNP8rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: WeaekpOE2urMqa_6jUKqyI9qp1IAi2cK
X-Proofpoint-GUID: WeaekpOE2urMqa_6jUKqyI9qp1IAi2cK

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44680f65ea14..a2bed0dbf996 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -626,6 +626,7 @@ void scsi_sanitize_inquiry_string(unsigned char *s, int len)
 }
 EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
 
+
 /**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sdev:	scsi_device to probe
@@ -647,10 +648,32 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/*
+		 * not-ready to ready transition [asc/ascq=0x28/0x0] or
+		 * power-on, reset [asc/ascq=0x29/0x0], continue. INQUIRY
+		 * should not yield UNIT_ATTENTION but many buggy devices do
+		 * so anyway.
+		 */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = 3,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = &failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +691,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_failures_reset_retries(&failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +709,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.34.1

