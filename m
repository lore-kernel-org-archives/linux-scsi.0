Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B618C150989
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969366; cv=fail; b=QR/abbtnanzY2ecd/r4hh0PwYZV6eRtgFc3w1PdS7d+8vntjDktFxDz5jxPqS6+b+sjHzvlXb/mFYuMlsBDtjfGRNQVnggxe2ECOyZXopdcCL/jsM6/FM4+ousJJ3lZUQyZNrULiT+7VodDf/wbYmDfnCsDgemYzK2VIS84cLmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969366; c=relaxed/simple;
	bh=uusAQ/qQaNuG2ylItBbTUBKRUY6+5C0ld3rN8R8SJs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jp91I8cMM9jeBWvuBCyvesJl/SD4DGpiC8KA3UzHcUFLcXczgRADzit4KAmkalQEixS65U4NxpmCoKlCQ2AkUMiBNO1Llrzz3EYuZsylamH7BNLhvs6zzFRRnk7N2naGfT4rved0Bljzkg7CzOv5Fm9+bnoEcf/2LWz88eXEy9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qw2HcvlC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DsA87+Qw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qw2HcvlC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DsA87+Qw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMofRt022150;
	Tue, 23 Jan 2024 00:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=wIYqDJpqcPj0MRbLkrPZjcUDcW6acWq6+1asmTAHlRo=;
 b=Qw2HcvlCkYXrE8VXJNjR2EoTaWAzjvHcSnDByqbrYd2164gHh4ye+It0KwAJWncLqSpI
 ihKNNlqi9N4dUU0Eri3TWlzPtlxfU+Pm7cwsLqOaeqAsowoJWp0QBXkkpovh5YandwgK
 6/6+vSQfYAV8s6zr4k5aeIuK2u+UbcHpj/POv0ICy0VUBFdiW8ACJ5uaQNKjPpoBznfv
 YIL56wvMjWlK67vEM+bJmoaUGXASvcIFhl+E/mSTx6IeOsoCW+NKJDeKlAmsCTisRcOb
 aqlpMgUPMP2V/XVfE2RhJ1avPN6hTeaVUWrXeRkFapkU3CRnhT5hhnuYnsDs459WF+TG yQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7n7vysq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMqMgY013112;
	Tue, 23 Jan 2024 00:22:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3700jkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGviFP6vKrihzxT/BPzZSbjgBW0g6eqgE3INpx2vlj/FeVLJr4laDg8F4yvyd8pp2E/s2AcjQtCW2VxpAaN8evj4IzeluqXBW+btyQPKropDFz7fliM/fTDyD33PB3V4AZ5TZB0h9tILV5zfu0bwO/6LSiWyXn71FWW7bmB17dM1Ts6ej4HJVXjmgXZz0qrpkjnno2z3EfOHDxMqqmH2KwqCDWCsbMTbz+7jq7sUUMS4s1gZqsWRE86/Te7IBGu/ksTR5kzu6zhEfDQql+OLL/eusfMO7n+Z+s39EeNerMQ2iiaTBls6qfIKoIvDwZTSGRVMBR1q1qtyOOBqxbMDKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIYqDJpqcPj0MRbLkrPZjcUDcW6acWq6+1asmTAHlRo=;
 b=br0mACuo7GgeOoaYc3Qzv0TgGWIFlhDyXeA2mFU/vnLJYuBsk+FKk+avhKS5ohzJdBFEbthWDQVFOmrNqFGvTvGcOK7bs/ypPSsu2ueMeklG8Udwi47soeBoxEaI6OObdK1Af1tEljnva4HePBUuQBatMrk+ys281WnbVLmVf6+aUNSG1eq40CUrR6pD9NTpO6BXk91iZhNc4llT4HxpKxvJdpYqgbG/Sek6o5Nif/3TUJQ4i7F79Aw73QbRa047Q0+IXqYzA3O+PEYbc15khX+jBQopWDV2TPhxAy6oRHqjmtTzdf00Tn+Oo3ClxD7kbr+RtGDHPsVLhRHKuRJchw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIYqDJpqcPj0MRbLkrPZjcUDcW6acWq6+1asmTAHlRo=;
 b=DsA87+Qwi9aj0+dVtpgUCmqpqk7JrVqnOv2GRX5oZTVbn5jz8irWulYEaIKl97qrtMKUt/IiA7UBpcQLi5b9JHsNjJMa6W85nC8hy7+Gf7DLc423zob5lpbdQsi8QffR1/RAkJycAliXOewsOYEhb2UtepsHxp+pBKPKeOMxiRE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:31 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 05/19] scsi: Have scsi-ml retry sd_spinup_disk errors
Date: Mon, 22 Jan 2024 18:22:06 -0600
Message-Id: <20240123002220.129141-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 37ae22e0-78c1-4678-e2df-08dc1ba96342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dk5Ot/J6ASCGJn0CMDTElBR6vsr4mOg1uz3Dc7Zj3Q43gMIHxZepYae+hY5lUVaQ7LuM+MWij8gHHuQ0f2J9pHKthP7t0ZlVdpEm52UHyEqcBlO6sOLzlcntyJDibpQs0ZqtRZbSdH+RYf/vMxQQYy/Z+KIYF1MHbiQxvH8O0endmBfgIqZDvCaIy7FzMTtt5m//fDmyuMy4/FQnnU+Lr/AwqeMd/VzEXEtvCeSQCIbJj1AHBNpVj49oJEGq5z0Q8qay7ntxsZ3LepvrtNy8Hh+jM4zcKLNJPltDdhAgn7XUM12+GUW9XI1X2VwD9Y4iC08Tw/imx8kcTY9dzfQHOKu4oH+J4YTTljhVpB/ENcU0z7t/ni67yBWs48sPBQYMS7P2jSfzlIx5ekDb7QUDzDHf9zvBJgKCvxzw2z70gKevcUk0srTbL16XV5Z7Azc2v6O+EJldJ7JViMZW8c4x6+dDfuMaCuHG/KCbt2qeZrqd/VExHfhu61Moa/xMSKAhx0pjKrRn/WRJYUcBfPKCqegLDaXIwCg22EczEwtIQidZNFu6PR1LwxUjEsPfsU5j
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?uMGCXM4XUeEbMsVbbTl+jglr8mfHFn6TwPj+qggxo+32wdOmEvjq5LvQU1pt?=
 =?us-ascii?Q?jACAq5pMOdZeawIxe6/4huswdDG5hzZsuVYLbx5lOU93fT6p2ReO5kTL5r2+?=
 =?us-ascii?Q?NtM0Q2n0jlzE0Lf5nOVnh4O7gfQs6SQ93EhD5M13E0470bUisdclFBqX6+ZO?=
 =?us-ascii?Q?nXqIcZqoj9r3JyOJx68uEi1ctvSS0UGzWSAXeA6Em6JfqfMo6bQ/rFPiHMPL?=
 =?us-ascii?Q?1JRp+PcOsxQpoo2Yb2gVqSyuNl7hD2mjdndLX1xl8QzzTuWjJYiJnyj8NOLW?=
 =?us-ascii?Q?JeBpYQhMDkBqoghDtSgjGLnkTBfUKLtUgYzx/hWZjapYIzRJR9EpDBXdrxRV?=
 =?us-ascii?Q?sDKl7EZXiIQY0ahqBFU1rDmkmYE5NOTsui4vSoIdfRdXO/u/t0tIFL9kzFsu?=
 =?us-ascii?Q?E9ifpXPueJWOG7O2Gg64FhgLKEr2QDr4FFAfKS/TKpG63RdAdoBncWvLuqqg?=
 =?us-ascii?Q?2gRTmhyYu1fVnPR0tNAjuc0chZrReDITNedHcxPBmwzpAJHQTf89G9B9FESQ?=
 =?us-ascii?Q?qhijdo09jciCMUsDI16ddAs0WyO3Zm05zbqQa3qSqVzjNydbN5C8KCvSjDYi?=
 =?us-ascii?Q?P1pbA80hawLsak91GdsrTeKArhPqkgJV5sYsM6ERIz/jSqRcwLRM3kHeCb/b?=
 =?us-ascii?Q?LdRX8VslQ22bwCmBdXdVu1GOwLOXXbE04CBOU9xURUVNwdJM0apBcjilsSN2?=
 =?us-ascii?Q?se320dIRF8Lb+tDDsry76Bx2RyW4HIzIkAy5zJW0Kq3JhGwxCY03KkQcYyCK?=
 =?us-ascii?Q?AoiYR4MlHlajf+fwGTtE0XYWWzMkunGn98qSoclYE2XtKL6pEqilEN50Rzg/?=
 =?us-ascii?Q?QHX1mp1UK/e/xfS7AA3F+cZBLoA/xtDcbuGDdxJOBnVEek9IGhvaEoRRWxsb?=
 =?us-ascii?Q?zwfU1lSaLqtqQ6Z74W+mrpme3Z7WvmHTIxMfR0k925qwio/hw5ldfSIR/IYx?=
 =?us-ascii?Q?N6PpCBvPanKFJNr8r1LOatuv5fsgZOBG/s+VZgM10o1LfbjMFSq0IyrtvPh9?=
 =?us-ascii?Q?jH4Qo1r3UGDfKM3RO1Bf8P74xwdEXl0olXIxeJbuy6ayBJzikAb798SBsL7z?=
 =?us-ascii?Q?K3rRkRrX2LYkEWVY8E6MEomqhFg7fzSGg+/8zs6knDt7nF8wfuJ7GQEuO3pY?=
 =?us-ascii?Q?dyTomI0CKxjwWIg39UmoTg96x12HNnyMUcsapH0/HMoouZKAnuojaT7mvUjP?=
 =?us-ascii?Q?MrGJmUU3ldDUmlKHHH0qYSFmqVH7KigtjUKtQW56LxaIZ5fN8nTA/lD6m6sJ?=
 =?us-ascii?Q?dJbFL22lkYphAANGmjxw3uAJgQx8ToSIPDFbPsna/ef25M8tZRpeJEo2dSX+?=
 =?us-ascii?Q?nZLOG4ZFGm6ZIPAnDw8w4F/5OYfvCeuo4g01mJIOy3QKz75x4j8nLQLrzIgu?=
 =?us-ascii?Q?VYibgLBz5Jl0lSm0sHOXnK+26wLbgMLGnMNCWLpelaSV5SZBlRR1EnvqXE1+?=
 =?us-ascii?Q?O3zVl70SDkLq1Az7tyAd3elKJVeQi225Oi3QkJJehkS7MDq6Rn/nydJBRR7l?=
 =?us-ascii?Q?SZD8MbNSkpJNHbK+I+zm1yi4LVl+0ITi4N+WT31IoVpRIbckNgACEVDylfSl?=
 =?us-ascii?Q?hUPplwoKoTg/ALGaVzD8nk3s5C1b0aayztUFNnf2blK/qEw9Azn3WmIT4+UC?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DtBagNPPGKb0h/CDEddTwUehxZfybpnpRpDNMlsrVCmVgzztJqSrcLKch5z5f2EEwp5154lEZ+e+x2irFW9w7V7H2nRuiet70TnqZJRwGXCMVrb9ZDIM0F3J+Jda3l1WFqK0Tg4Fr6OUONORXzaVWdMY8XlsUS0Q2ZyCDmZDIF7N2S9jKvLsCkM59P0q/nIC3sW+YF9l0K010sDwJYcfbRYvVR3IZEfkRcNFYViFFsRoMNDkCIr1XUHDYf7zPxC4bbYqVEH0AtBrj36TI42s2bb3sBp34ooWxbLAOJfERMuvr7OxwEw7d9X6+xCnLgIeNO4HhyPPdhtL0hQEhpQNnEost+MDkcOr1TSfgBOLfiLEpmc0OYXFECD8XpBnJ80sOhpo58nmiD++V619dteX6bCgZXGGJD7eoGBLIynragxQGSD8yq/3RBSzA7F3Yd5ar5beSPKSahgACPviqmU6SFIYPlHLb/iIZFykgeDggYqKKDLR9FJASyS1E+tg07i9xuLQwLf7YikRhPpUBW4BeZ/5g9eu6eaT9KNKOOyn1teDdrJaV42wI27Nrab7mok5GO6SWeVtoqh5EqfSg6+ZwBJgDQ8nwl1Et48aBBD4ZhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ae22e0-78c1-4678-e2df-08dc1ba96342
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:31.0038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BVKXf1gbRJX8Kj2mfM+UKhcFG9Dg7ZhXjcEfToFHKIGPwXHWoEWbXEE+DsCDMIFyd5O4v4s+g72MESS4593jeMfwZesw7szZNUt534cggM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: D1l-g98T2L18DV-ykDU4GTn9l1Ojrce8
X-Proofpoint-ORIG-GUID: D1l-g98T2L18DV-ykDU4GTn9l1Ojrce8

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried every UA except Medium Not Present and also if
scsi_status_is_good returned failed which would happen for all check
conditions. In this patch we use SCMD_FAILURE_STAT_ANY which will trigger
for the same conditions as when scsi_status_is_good returns false and
there is status. This will cover all CCs including UAs so there is no
explicit failures array entry for UAs except for Medium Not Present which
we don't want to retry.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 77 +++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d85913d373c..cb240015bde5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2235,55 +2235,68 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry when scsi_status_is_good would return false 3 times */
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
+		bool media_was_present = sdkp->media_present;
 
-		do {
-			bool media_was_present = sdkp->media_present;
+		scsi_failures_reset_retries(&failures);
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
-
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
 
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.34.1

