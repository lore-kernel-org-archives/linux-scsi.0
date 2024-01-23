Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1861EEE8
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969523; cv=fail; b=DWuVLFHgaKzAF8Z3FMwvHbxrqLt2zDv4zu9LkGfVtCpU0YdwnWuGp/v3rkmN7ny7ZO8MlRLlbmwumZniTcWMWf71Xi83njuYcY6kTI9f9fCpix/DkCHnX5o+BnVa2n8Oh8dc0JEdLXDeqDgxyKPTbgu8RirXIYXDmB5po5CjMmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969523; c=relaxed/simple;
	bh=2btri3V9OBOHYVcNtf+t+lNx/mBCeMVjp1R1DgyQ+QI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pQGhsqRJTKl1TX2+grcn4OaVkGR0XzrQ8Uq+QsPUcthRpTgSrKRQ1ynBLOOjnZrM9xq9QQ6p5vLR5FcIx1UNLRBum8xdF53iYLyLLcmD5T+K3sx5DoAlcndLKTz9SQ5/orEB0jHIR5QxkH2UNONNXaI+3rCMSk+y/T0S0a+7Dfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iCGbjnCi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VU/SGR2n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iCGbjnCi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VU/SGR2n"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMp2wo008297;
	Tue, 23 Jan 2024 00:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=iCGbjnCiJQSC6dgWkCTE+iVB8zhOrUw/EiFXVaRM9dFIrNRZlDs1uAJzF8zwGvICw3km
 MoEuGCDg6FX6OraqROwdFthHv7jJZY/bXOMQOqX+PZnAXvLZARp+gMkM5bnRpzZrwmH9
 4Hv08BQzj/qcwuZpKCEBpTlEqgyACwCacjn5M2RAWX+8SX82PtrQAsnMj697cPNrsImb
 8cmPZ5YpTZlFxJhr3iGurJY4MhfxqM5/TawZRJcD1QMTH+/RPHkZM1/PQwDeEN+kh/fB
 +XRUJKLzrF329MH7GhNj8mgam6Qp0T3Due6RVJv5o/X0dtPIhAULiUqskVquyooXGXsd PQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79nd2e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40N0DTlx025310;
	Tue, 23 Jan 2024 00:23:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9TVrSklByRSAnJyo96zy6Acz74cTu36wzJWC9Bo6JTFDk8BnQi2PJ34co76T398A0Uqw49iyKs4oN3fS39ZIMZADafNX+YKFkmXbLXVFvjyLqwrc3eAgSibgHu1BQ5En4Oc0QHsmJCtVX/fsPs0paKPC6oOAjG726UMz9uB0KVx7YBhR5EyzrN+2qejWAN4PQvbgftuNI68vsdcJXdrZUF487j7JaryiEp54R+AP48jYuWHOtMkomKrZ15J/uF9M+UzWBAT9DGOfh2kMHxuknxXjec4xhIRY9JhuQZJGUdXYwszG/hXOe7dA1qcK8aHJGEpZKRYJw6TbPIElSnkiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=iX3B9vzxZyVGhPkeqVkv7AyckodUPT8hj/Dx6yyW6Tg13CwU1TUudT0RD3vSXkvtwdDpGVyGZjYXot7JNvAY6Dno5fMNS19DG5jFfi1F3JGX1mx5dGOojcoBbE88csViJbgTbrWJjTco8W9XfHwNqM5yCP3hXB6GhKgPiDQw3LjlSGNj0jjtvmJItqexMJucAkOkI+sk4//QECKxcRIPCD7y6RLzwErwHopIANNmdMiTzo4+la9FbF7Szj4Nwk8/9+QFQ5XrciWYyfvomMELBhIngnTy61tAMiliaDGWNPPI0rEE7q4J1tGh2fv51xARIS3OMDGZ2iEtEq717VUcTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWLT3G49/rrR9aRboYfHvH2bMlYuyLiAHg5BiTX9x2g=;
 b=VU/SGR2nzTDBdGumd6nyarSdTubfrrzGAEw9i8tJohn2tAG6CJ0G1SivnX1GbSZABtNYfyzRWdDSnVu45ep+gz6msQ/yb5kPcqM8sVcRWkrTN0TyxudgbAb9zDiRTQdQ56J2E6eJMTJZ58DrQLf/obn6MHIiaZj4JttMnM7j3J0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:46 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:46 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 16/19] scsi: ses: Have scsi-ml retry scsi_execute_cmd errors
Date: Mon, 22 Jan 2024 18:22:17 -0600
Message-Id: <20240123002220.129141-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:5:80::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a95ad0-0fd8-467e-b209-08dc1ba96c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pjIS6cQm0x3iRQtkZ2U7Rw4SQ7NBGsBHYHqnwMttA9W+EFpiX4GKyXPaVa9PKmyamAUMOP1M5FbqZx4rylaZwkZ/h5L6RdmHG6ZVAtmcalASj0qfk74A1M+z/yv2frs2K4rPIdWLvUYP3U9lxmgBW+5VMUsdmnxYYA+b1MpsYJnBq+voCr/5liTS/ODXequp9JHMCfqUrIG+4NAhn3aBKZ1nslWm+JEJLT9HqMG28NVVyWpfxcXP61qAUpYGNZMnsTtZMjHYf7aV4M1XO9ClnOI5ZSqk64inAw1H/eOkH6eh/4GOFKQrbdJGxOqxmCa7eR0pWsxyCXPSEPaMBiS9Je7Nn3Uf2thyQoqpqKme6NK6HVntys2Pc2d1394uUMlHwSsn07UXfM3zfbWcf3D6LBGl5zTAThJUEe0dEV588xWYxcNKy/nRvxHV6K4xOvq8Fr38l2DX+WfRD+T6rul3fc4RMb4bkhxaqXypYK2TeKGPS6o0bwqwM49JVGXMnGQ+Thxuo8epsdnYF8+1AUp5zW3nbhbG+Lt6Sz4Eft2G9g/UFjGoGi5+F6DnORIdyC/g
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?2Y9/L/731ha8PkHjufMO/HFd9D9w8DBvGjB4hQ7rpZ4FhKuxVL+hol/3EZpd?=
 =?us-ascii?Q?YsS2Gs4f74WGt0szsQ+98Plj5rQgUsMojI4MF+hlwCusNLmziLAomhhrUZJV?=
 =?us-ascii?Q?4eVDiTbdzh9Yl0tjreaiKKvXU0uFjBHxlX3CzdZBREMWyFSnuV0d90zDXOYd?=
 =?us-ascii?Q?mWcOyLcGQFAK0A2kV9qOFmcI7YAS/jz8SqdQpWLubryKMmCy3cw+IlG2ZJW/?=
 =?us-ascii?Q?pKqaNBvZMzq5phjRhRO7Nl1QklxEHH1egSYl/goCVAa6VCk4NFxAx1CFevf7?=
 =?us-ascii?Q?Ny+zlET6iCDCu0nMFUvhLOpVReSq0vKeZBkNVf5F8d3aiUVW8h2wb0HIkdIj?=
 =?us-ascii?Q?N9dInNRjsyJe2hoXD/7ulHsal8ea0PU880hF8P3RltlhXf5qUQ8cnGk2gcYF?=
 =?us-ascii?Q?2fEJ13dS0qczqQu7+rJZqcD8ObqfZysO6b6Qk9ZOXewTyqIkqjxJRceCHweH?=
 =?us-ascii?Q?NCtM+wEpIBXf+YCyHpmd9+vNf9bng36kNItP5XPALIuEttr6WI18xiyQt42N?=
 =?us-ascii?Q?uh5cVdNjLhRC/wNi8DYT85KX65tdG3Tk34QVTKV22fH15NtpVTGFSJB31ISF?=
 =?us-ascii?Q?c4FR1rfReV6at+CNf+SKxrSMw6/xYEk88ObU8Ud0jgnekKHVOzhX2VvJcCXu?=
 =?us-ascii?Q?r9RjaIDr13YDm+tPapJyRb/7OEAGsAnYjhmUc1SVGAJdL6YfsVgvhDvJkE+3?=
 =?us-ascii?Q?y2ER/wFFXGf/qfe/9m3Qb9I7aXC2c2tjhOghfJuZ2sdmeHYdVdcviw+U3ZM0?=
 =?us-ascii?Q?abOvAY7GFNEmj0DMBHSDuiYnCBG+Q+TwZKYTEDWD1oa7SIDRG5HyROaF4MVD?=
 =?us-ascii?Q?zW5Uz41y6B4YTdIpi/cOcgKkbXV3x5AvZ2I1HMhyaeftL4V/9I6nqipLvr6Z?=
 =?us-ascii?Q?TIezvP6bZJMyIUJr+7Tc0rLRzZ3ES+RErwb7LfLddq1xIMXR3oqKcGkVLYla?=
 =?us-ascii?Q?/SplWG9r5d/Z81mzVs70NgrXwBI689SBnWhBdB6cbQC1LQKJMf748U+9eR4q?=
 =?us-ascii?Q?hY3ntbrlFUJnMoppux0cQAV/PA537P+u4rmtIEMyNOvyn+kHj6RQjCQ1jtb5?=
 =?us-ascii?Q?w3/22L4CDRoIOWBzrHbUgflat3E7lAHr9FED5Ik9IQUIHudK8g5X5zL0aa/C?=
 =?us-ascii?Q?yU3B04Ff+leCzvh0I209OVYt93X8j9CDs0aZa1gvraY9lqrcC/oxpCwmMQ1K?=
 =?us-ascii?Q?2WJ6wQdm4ZpbmxBULuZv/TUl5wtuDcHmKHFjUxJkHEgyyRYICVw+a4dzrUr/?=
 =?us-ascii?Q?3YrIOWYF8MiBN/xtiWfGHgughEngrr+H5w0nXO4DsJ0lno3DTQzQkekPOSCN?=
 =?us-ascii?Q?j31aVN4C3uehsyFONYXCSID55L26E8sSK3jr+Z9e9YC6HSSrScVO0kHGcuSa?=
 =?us-ascii?Q?zMHMCl6pQ1k/fHAnYJIRk2vS0Jtw6q+qwOldX0DebwC2a9sKBtwuV6EosRx4?=
 =?us-ascii?Q?DIom+JvEOFKqkKi1FIt+JcjbjvuuTyqVmx6DZO6GA6niPki2i3naSKmI6h+I?=
 =?us-ascii?Q?0VrI4f9S/WP8aGsXphXNFmHwl7AcCxUidxjwhSyFhqFKCBvoPR/kTSh+UCOC?=
 =?us-ascii?Q?actL2lIRNBDFQtOzto6L1Ht0aHEoak6VdmnpM+IlsnZGzfqgZKkEIQMmtCR0?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fgMFkT4S9dHoGdHRX7NSwoTpT5Igr+MBWn1axpAcbebqF/6mMZF0anZkHdaIafc4iyKt2MOviJ5WlFUBH4Ex19tcU2Ramwcas7OUlc3Zu8zZ92rZ1eZ1gd/Kn8xbJb/uix3WDjgs7JYTiM2y50JPbXkZylUCoqCA8VWsp8htjggiiFE3hkH1DyiPZ6h2nt0f29jtTvMTo7HaSrBsw2zoEgGKxn6P1im4e2462a5UH8RazjphCHMb5JhdR2P9ZF5zAxQzLEAXuyB0FTi8j8dWZeLLmB3KQVr0lOlfrUA+rbdp33tg5okp8nhG+1JCso+cQou2Jty6KVYSABCq4Fg/bdRW7GXU8wu/9wt0arC15GBMzecPPvierbnS6jw2diZl8kVX9EaUpiX2w/8tEsUeJJmH3CiOa+/KVKwBXL6+BtjmoXN7jzlDCLMbyL79Z2MyJbRpH9gvEBDMPaU6lgJQj1B6JzFFf2hAB/HuTF/+gK+zue9ALBZ5EqielQmHIR5Stlui5kfjsWpld7itJ+TF7VotLLlGdX2YAdR5/h6r2uFzDSoOPzp/y6gPNT6vdd9ybXjmargVVianRiwqLJ7/9jAuvVgD8R6Q+Q8LcEpSNjY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a95ad0-0fd8-467e-b209-08dc1ba96c66
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:46.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4Wd0x6ziouF2HGpqure7JL5MGVKH1+zPgdlvWmVCkFIDBdg5zCmKygFv7vm7DLrqj7CJVmNefpwAE5k/6Xbxndrf/1S9u/GEvZxC0xEtyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230002
X-Proofpoint-GUID: TGVj_LAcQ3SwV9STP9bNgcQcGHSptxsu
X-Proofpoint-ORIG-GUID: TGVj_LAcQ3SwV9STP9bNgcQcGHSptxsu

This has ses have scsi-ml retry scsi_execute_cmd errors instead of
driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 66 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d7d0c35c58b8..0f2c87cc95e6 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,32 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +144,32 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.34.1

