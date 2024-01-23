Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9BA144614
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969541; cv=fail; b=VFA4xENuS4kduXYWn7mc6FqCcxoRPmcP7rUpXQqBxySem+3FdRbZEkw56ccCZXjxNVaZqC4vNTK3YX1crVFYRD0qFk4maF1iP1cAxdV8DHthXzuvuxrPoA+mon+plo90yWEO73OtGUy6Dt7SyOt2SYKHNALoZ1tbU03Jzr3dO0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969541; c=relaxed/simple;
	bh=108IOLqCmoOnnCEn2MsaAoepwgW5OO46TNl/0H0SiVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iiygqQtpNa3drp75sWtW0F87b7IoD8xPLkqP0clEVipZMvJKqunL14Op0T3lDGfUG7OLbE7XrQ+m+j0TJyaXfnUs6PbtN9BUxpGB4kEML4IgGZsLzZXudgniPrgRR04jCZHunvjMBVSAjQM7EezPXDYkRhju19yW2D+76loIG7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=POnWBltR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=swAia7Ph; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POnWBltR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="swAia7Ph"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMovBq008245;
	Tue, 23 Jan 2024 00:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=POnWBltRB9eDNKH/4ij7VfrinGTMyZbmA5OKorceSbr24rB2VLt0hTPvqhsxdnVFewjy
 mexxohwKFJ4RMAhK+nvE8wk/zEYhXF8qxqeDt7GtNea0CSDiYI2KtsaXh7KD8LN3w3pH
 QHaDuL/4czWiOikg2d6FIvAuNm29hNeDQeTJQ8zT3Bo1ZsFrLIIQVc0h8fyJfOdO8sD5
 50E4Er/g4B++x+lpWArs07SFGWfCFmIvriCaVB0mr73kh7iygNY3Em3PhcyX7EbTAeYT
 uTPLL7BtVCD8HEhGLj2Dsdb5mSkdJujWxJeNFct1UWm5VvlDGUfbNhvGLvYwHhNMnk9d Mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79nd2e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40N0DTm0025310;
	Tue, 23 Jan 2024 00:23:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34s1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ1+UdX3mL6FiF+TpwCBmtw/YpiyxHj6uqXIjeGZDQgM65sUa9GQHZo4AwnxR1lq7UOg6mFv0FvnTMrc/Wm5Sw0zDVC9wGh86DkdbukvgzkKZdd//IcOOa7+ElBwEo+19VeoFunq0zhpfd8fTPaA/WOmOTWyXG0fu09VRag6BX/lXvQbCl97VzKzJQ4Msyq9yIXKqi//mnkWlr2wFnNgQkBxUQ2GBn2+o4BlcHy4Ilwk+NOOWpJ942kt0eK+eWj5lyyc8rb6rgjejFTOP9gDYSfptXCTzdrW2dy4Y8yQm0zRl9rj72hJC/RStNWG1p6/+EXIHrojMCkLL3diP3VXdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=O6bYT41dNa/TDKb91cXc7IhB7jyaYT3zSkOPk0Eg6YL+HWL0JCCWlDpw6NcIomZVpVZ5ZsuZVQvZF9r190AhugwIMmVWqoDuwyrAY5lrBq8lXwit4ZpjPT8bnjq29VqFSDGergoJkb/lsczbcywXqP/W1wuqhCWhVsFYjXBdf9/IVyN7skvO8ybBp0bySxKWMg0cVjKZKFDhQVlpvECy/uJY5Qd1I9EmYC8XTLofQL2Z5TWhetK974clrLjK0GUNh3/iH8icVLYC09XnGalA9yl4k8bzlea/sGCelDfPkQ5SG+wuwEN/m+JG+1l8kc2hWdn4bgeh2rpA1V9weUj1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=swAia7PhC3A/pb5CcNbohfPxsGM2JTIFj03Z4/zCFcvswT9xxb940duOXGK2IX3+6LGsbzQy+c1TRjQedWWHtOjjrG7hDaLhw6EKms4jGEP0/jMOKrl0SS/jRBo4wqCRIAFrGcflG3hHN1tc7ECFNBiiYk3ZXv+NvOAV2yQvleY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:47 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 17/19] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date: Mon, 22 Jan 2024 18:22:18 -0600
Message-Id: <20240123002220.129141-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0116.namprd07.prod.outlook.com
 (2603:10b6:5:330::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: b347a3b2-8b33-47ef-6fe0-08dc1ba96d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4xv9GrNMXPyxnMpmci0IWKJdTpQPSOnpNnQCnAGYX9jcBOHegsWT/VyRyYzCiXPlhyN+7V4KOMa6w/i428U2iKQdEbGA8XjPZ4T+VafrAwgzpwyIuMKxbQcmITiYqlZpytMkUCAlxow0Cxyjli+NPs8vEDg29waOMP7iblJwCSUyWf0hqFlKX9JMV4M8zsNxcuBIml/Xp4hFgOESmILa9jHULwWBefw6cvb75YbpZH4zHE6jL1cYE/bLP3AbpvME0Ds2A70AMoeS9BAa7bVZjd86X3AW+0DiTNQ4bMg+PzHSAA+EeKST+pexlqIpBzXWllbIPfKiYU+u+hGFtts+uE65LFJNeBhZc6WwCxGp1JAmM3GieOJuqgZvPrBZEtGlZg85AJS5DpveN6DzpbB4BZZHVprbtTFjjxyTrcZLtnRThkPva8ncSbFTy18SVOM+tE+qy/xen3rGKds9HoIJWjLD9hozgkAf3Nd+F9PzHYMMxTPr0bBJ/DvI1C2RDvhcMhN8O2KQ8Gvre0QgcZhBVbby2LjV76qQY1UZMC1lA0lAhTXzyYLu9nEYqbUbU41b
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?SQ+AU59OHE+AHg5yZBl0cTSPzFhpypBzJDJ9VOcJaP6zkSsUHV5FP/MMwSca?=
 =?us-ascii?Q?2uxH59IC6vaAkFSQbvj89kirkUOQ23e008X8C0XY9WX++ZooaOmPK+HN+gyh?=
 =?us-ascii?Q?H+ICkPT7we6az32xzgdribqWFEMLc17hptDdm+8TGlATMWN0ycSIbqN062BD?=
 =?us-ascii?Q?VZZqP9LvGYPyFUvQbHWQ5/r22xTiG/XSo+TzOieiBDFeg5sDeWLqGTA3kpgf?=
 =?us-ascii?Q?JNRz1uy7QreaxLHSnqmFZHiTrkzBZAsOw0VejsPQCTE0AICWrRV9/Lpn6pG1?=
 =?us-ascii?Q?R94BhlWcl0mUXpaR1pY/W75dGW13ndx2EBWGm6bqUirJqnL+NtYHYQHvG1no?=
 =?us-ascii?Q?nzQ6/1+xV42N9mvy4UQotrvJZr9WGq18O2ndbgsLwcw9wvIkkapL8/GCdCJG?=
 =?us-ascii?Q?Mjj6/n2dNC9XsBB/Phb8Sjqsx000uhW3YLbgbxqVI45iHphoD5PDV2qkHbJU?=
 =?us-ascii?Q?SYXOiPvwO7/lVANSRYI0MPRUpChyxRktAevenDAStMEu9OrnfQ/25a2aJppJ?=
 =?us-ascii?Q?AulzDcIwEMHvrLnOd5LXR67KPP6OL3hZbg6O2FWVd6nTF3Mp31Hlcyg48iy1?=
 =?us-ascii?Q?OyX7Or1pL1yt3N7HzF4apcENZx/0OUDOB3DPYBQkDmST4825aqCoQiRxvimA?=
 =?us-ascii?Q?208XEpB9c9lW0BqHZOHAf+Ch+wRnbkrouz03o1ecv+EDl3NQPcKVlbjGw00l?=
 =?us-ascii?Q?qvw+vNOtpS3z2rEY3tP4ptUgfxBTM3yLqBsyMR/nAl1qZNG+7iAZ7nuDsMy0?=
 =?us-ascii?Q?by3QRsE0PNtQ2yBOe2rbksqlPp8Qqlc4qSeKGGjbLMgoOey3vQPYTPjCYyNh?=
 =?us-ascii?Q?7QgpNYA/IAFF1F46dwqxlmR1BGY2iDFPSJjONxXDwN6drQesE1l9qgyVTwYs?=
 =?us-ascii?Q?ncSVcy9XsSUPlbhjH/0JdqXTq6Ei0aNZMR6CGCXo2Kv54PLh4DfmlLSWCPXB?=
 =?us-ascii?Q?v+Z9cT8vN7C8iYu73yMnCvMpNehTCTEiuq6XYbwJhBZ7RgQR92eXuD3lFy0K?=
 =?us-ascii?Q?NBrj/yAYej2Bzzuj9NzMidZypBU1NDGccCSf8X7eKRA7+2BuNE0j3/tK/U3p?=
 =?us-ascii?Q?AbZNVfiZAuliH5RkQN/pD87Ls+D5w60jXlB9ruCvghaH37goMAIxFJ9sfQka?=
 =?us-ascii?Q?DNkv++y6EU2+Owod23o8tofmbySYerMU/ePYdfFh31DaurDDrRLdsokQIvpX?=
 =?us-ascii?Q?jtGRLXQVBx5DKAmLexpHAH5jCFE8hd2T8atgyMdH5w4W1hO8d6UOZlvU28js?=
 =?us-ascii?Q?Fzn7FSn75G87es8gxR7iG60NbKBch3Og76IaqWuV04g56o/lJT9tLm3VLXya?=
 =?us-ascii?Q?A3hedKF1mLC6LTbbz4MkfMhhE1BxEtARO27unfhkztZoIljgd5quqYeZlEow?=
 =?us-ascii?Q?VChpR1Nmsdg1Qkl8x6oix+aJPcBRZcpDUal6I4zlRacBpuqi5lIOWvsMxY4m?=
 =?us-ascii?Q?fsY9kgmQ6GpBfrbUco8cHdqNIUqm2JhCzpQNkU/1bdMn9C+xN0ZmgEKIK8m4?=
 =?us-ascii?Q?f6haRf06onfXeHnMkKdeC8Hg69ek/Huv6bmoXFpzlLurPYyzIgGW96XTl7Jc?=
 =?us-ascii?Q?HGUA4hL8KoI75zPbMvBVKXbl1mySnIpL0+wO8lJfGXvvyhzgNF0ECnIhylmR?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sgqmlu3HGYkyYP41auNvZxGjSeyXi5FR4yi/dQc8OBuYiGK/qMMjvq/3RfC5MDD5akh/zeAqNshNldXXxe/E7KH/x5i6sl6ZG1fYVh96oIhqtlhTNdwJ9cPWSPh+tcpBCRYlfdJCywpZxb5kQSMdUy9rN3wM1+pw/KRyo5pg7x7AI/Bm+WVVhmBFg4x+QUjgW+DKbYTqeOD+oKT0DH2vv1eJkCGi5cRfrt4JBK1XB9PoE9Q6ZxR8FCDkvKBYxcMnWMmswXzU/WBgFf+DcgqkzTlyb/RUI/3cJ8dsXPILEW6bGMsstf7LpCatWrJP2iwmIIL57T/5dT3C5xu7BJIKEnR+RwgAllXP6O1MLJ8HmHa4aoD/vTQcPIDDaOpwXiGeHupmt5O+fvfnePxNmF3KzMeZcxzAEhYtWmimCYv7EzrbEmiwniZyxNf5xySFY3XewFUr2+8x8Y9YyzMxCNCJ6yggZa54zz0WnWk4HzQYlpwA1IFeo7s7C+aUNlTyAH1qUSyRyaJMSyWJaL22tHcukGdg+j941ClsmvpyzqlKLog657LYI0WU4BvUJg82ZYUcqrpp95mII9MABNlBid0RKvCvcNStuZY/GVYZPRHC07g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b347a3b2-8b33-47ef-6fe0-08dc1ba96d29
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:47.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dULU+yuA4kNzKjy07ou/402ipfWyqT+fRON9O4Dtj0LeF9y38IJnhRfknjDawgsUZwpXhS4mh2h75YKJlcA72WP4HV0Mf2eTjhMonJPexQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230002
X-Proofpoint-GUID: GABDCECPwAAHRrdKp3H6oKfdyUcjE5Cb
X-Proofpoint-ORIG-GUID: GABDCECPwAAHRrdKp3H6oKfdyUcjE5Cb

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
 drivers/scsi/sr.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d093dd187b2f..268b3a40891e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -717,27 +717,29 @@ static int sr_probe(struct device *dev)
 
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
+	struct scsi_failure failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = &failures,
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
2.34.1

