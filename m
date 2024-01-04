Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0297B1A70F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jan 2024 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+ONNQgd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C98qTccF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4042qoS6031010;
	Thu, 4 Jan 2024 04:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=w52D8UP5LXfTntRbSu7PVwQyJYo0mxxSigifUz3pl/s=;
 b=V+ONNQgdK5iKbuyugnIjEIa+g8JBEoEvMIJ9cuFnIYZhW60Dmtf96O8woJWNeexHruld
 lBHLRe0d+VhScKBULWHL+O2Con6VF4kiWZqy4l36VfVnA//zpHE3m/lEr9JKaRaswhN3
 PLK1KRpE/MafY/hZ/S+H57KuPfUXwThfIc9Ktyi6T86+0NgGSFoP11P5z2VmjF/MK5Z9
 LXRMNuc2JByvOBZj+QrMK4wPTPEjv3exWPBe00qqwxgauXZe7yMcW+NpYutNcUvmvIkx
 vJV15GLoO1IzlexzuN4d7f4/9lrH2t93jQRBYx1t8CUole2ijtyGqBarJYLK4KsyTiaa nw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vab3ax9tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jan 2024 04:04:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4043v9fr029932;
	Thu, 4 Jan 2024 04:04:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vdn7k0eu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Jan 2024 04:04:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPmuQB+qy8pABba0iTPc36NytMEDrNCGLD1r1ZCmiCTv8vv0BfCk7+LckYOo73/y8LA661Nd4bf51GfKHhFJI0iS6CMrOvyFyj7h42hHKpiPbN2N61KkD5tORW5wbygIcenUyi/g1cTOYCaZ8PI5Hlgh46WjValwy5YZlYZ/VfgHai1DpLzsVnxiQW7ifcgggtMj5KqnWr4ZvPAGuJKCGl4jf840UCBof/QDO2xYiVyLZtLJnkt3OLOHHWs5FrRv/cj5cdESVmzhe6fmfEZ8gTK7k1w8PbwFPS3eN/myOl8t6M4wbVHXpT9VGWpz186Zju1Vq7w89+UK+YOnxc0CZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w52D8UP5LXfTntRbSu7PVwQyJYo0mxxSigifUz3pl/s=;
 b=YfkMvzC+DVPwnXaaGdYvCAQDRp+Xf6lRTAQ7FrTcThSwpOv4UiqVJjxIFGzbiWCZC5LZBPRUJ5zYquvZRsAP6v1v7snyxc6+EHIzeobtLQBhcPUxSzt5p4ehJm6Rwe4gjEj87JLZBqSeQtNsFk7JHU36jBlAK9hzxkO/k9EZYS/BHG3aleDhnuElDzRKK/W7evwGWFbwhyiVLxJ85StzeYqhh64JZkxJaiZghs2pjWoN4p0ZDCMbY2cTbihw+ykT/g4ceft58Siz+E18Gn//G28S91m+upQlx4eb6q+jQ3/4wFPKUJ0g8adSzeE7F3yemMH8N9TlPEkYgDwxzCsEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w52D8UP5LXfTntRbSu7PVwQyJYo0mxxSigifUz3pl/s=;
 b=C98qTccFuTgyNxFYPIJxW0/j2EGEMHq03/fxxYlhVBpLM/DbkxyR0R22bP7Mskk/eMvYjIXOw1N3KT7WEvnKF1j4KtiOP+LWhpCB7D5JAIuwborwIjGfqWJZTq+K8ttluWdHiuQXy1ecRg1FPb+/Xuc9rGSzVO8xSl/LFz202aY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 04:04:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 04:04:00 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix the error path in ufshcd_async_scan()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1jzopagoi.fsf@ca-mkp.ca.oracle.com>
References: <20231218225229.2542156-1-bvanassche@acm.org>
Date: Wed, 03 Jan 2024 23:03:58 -0500
In-Reply-To: <20231218225229.2542156-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 18 Dec 2023 14:52:13 -0800")
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 3635b472-1995-40d2-68f9-08dc0cda2e3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xv2x1K6tHYDxoLwlCgKbZlW0efOJBhf6qe37IoLtOKURtAYGL9y6EOWbMCaTwaTxDxpKa/oyvjBBDyRSl6sCI6XgJasUVWP5mJZf3vEiL8KBE7TZh3qLAeGjfxrmFzkqUkynaiIPhLgBEF3CWWCPsaol/4b26+pXOvmUuQ/s6eHioPu+gA1SYoOPnql+DsEpXeqdhF915IIT2QQOIDEfhUImdfW64drmAnA6jyy17Gnpi0MK8TdB+bkZ9DjJlI4b1kWqNNv0hPCsnES8Z17yCL8bR+Hm0SMQLtrc6mJ3QFpg0PEngbDrdv43h1cBOoyl0IXJ3CaOSgoTfkhTmh0Eebhk/a3XJh1vp3KEx3+4+ZcpvvWfzn+4gJ87r+oB5ryA1D+uk6Xu8Lmg0rVVtCwegdu/kqDBYqeWIHIE1BY9IuIrWeHUKdIFaiH07B2aP9wG/NZH8W5qYq9h0gyQv7orgZ43EbdY9cIBa+9PQNq5MMTI+ByjapZfDzbb3El2uZqUQBNxCIk/9vSnrsw/V4mrXEKiCdR3icUk6F3sZ0Sh7ccuG9jKdfA5fNXaAZSHMTzq
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(478600001)(316002)(8936002)(8676002)(4326008)(6486002)(66946007)(6916009)(66476007)(66556008)(6512007)(6506007)(36916002)(26005)(2906002)(5660300002)(41300700001)(558084003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3VDgOIxGafzr61Cb6DCX3F2TfPS3GHsrkoFwPXRFZ/ubslECx8NwLmQCu3az?=
 =?us-ascii?Q?clEaRqFa61dCfr1z2nNlMRbr4ohKirYzZMt+oo/8A7j3D/G5EeeXKdX12Oml?=
 =?us-ascii?Q?HFCwZ4p/eu+aYlTkMMdgs1JX0G7Ju4B79ndimjnttUfC/DLCPHGyY97sUiA4?=
 =?us-ascii?Q?Lol/0hp560zkb76yru5WF1+ECpUaXkk9krHYfH/NNl/SRkMcFyeg4nog74xx?=
 =?us-ascii?Q?qqi/TNaVTop2ECHCOR++lCLdDXUqTQcYJIeE8MGoqVYPS1LX4MtYU8z9W4E6?=
 =?us-ascii?Q?6m2TxoODl7Gwv3/nPLmeJ13vykazoDv4p50bES+8eF6yRWhnIgXilaK3Zkar?=
 =?us-ascii?Q?3dOURaddGnQK+ThhR+QuSzw9uS3mSsCI0/bu0VoCgnt0J+LCY5e7XomAVP8d?=
 =?us-ascii?Q?S3PPjNaK54ZKYrBtUN96JDiM2+/qZEp975mQPTUDS84eq3fNMNW+4aMHKce4?=
 =?us-ascii?Q?VAHOsW55Byra1Cq6irNsdzgg9nvEy6yKP+2ilyyvlIUZ4KQH5IJ7TqEPumoY?=
 =?us-ascii?Q?QuCZo01RWlKx410NBPTe8JW+RGoYxK2JcDN/3zDMVEpoPLJR4mp+d7Zu7yLn?=
 =?us-ascii?Q?7tonYtL5KX3RpWzavBhXYzNOL1LEhlKXzruVIy2Sm+WQsRpQblal/HOqtZdS?=
 =?us-ascii?Q?FA3rcScCWCyxwHDBmmU+sGuDgBJdZHEK/pWNqPzVrCb64sOv+hlJbiJolFWC?=
 =?us-ascii?Q?XgLJJgpn2bRX5NyPj8c+nOaPrWwrIVLrxf5BtBhNbogJnFlx/aCfbkzd8t6B?=
 =?us-ascii?Q?2XUUVR2S13QxrICAKwcDA0iLLQkM9p9fmM187gT4tYHtqnwcaskoa5+qIj+J?=
 =?us-ascii?Q?GzEVSdrnRf4XERkBmhcir4f9AYMgS3dDg5qhG6EpCXHn1mkRPPAZoAGxhs9w?=
 =?us-ascii?Q?Sx/cZGPTlU3GSUM97EccmYAk/vOXcuDyWdBJYjBJ/As7YDJfojxKqAV1WFNT?=
 =?us-ascii?Q?nxg2L5XW9R4lFFE0u3Hiecgqej6Yb5V0nXBHD76XSNQe3wPi+36f42NOSQ/U?=
 =?us-ascii?Q?IPCNk5uPHEoZE6KkYgIrYjyqR6yDjrIfK5Mu8ZcrUjH3vX4wgJhXB0HfboV7?=
 =?us-ascii?Q?Ky/fphtChIMguI59g7JMLdLBpsnML+SWwiMmKiFGPjBMak72bn1XubxTdAy7?=
 =?us-ascii?Q?wZRdemjAK1HJrKYzjzDWLnm0ggs+YoaOpU/6mlvCdUFtscUg3gB0oCuB4VNe?=
 =?us-ascii?Q?k7MCrWLBWa60lm5JzwnE/EQRFHHlH8qgJ3QyMkcGZfMs0GvUIRFZ9Kehur+F?=
 =?us-ascii?Q?BQ0GlIYOCMPPYuREBEPZjZztJdlHMJmzBAP6OxGgJoK+gm3V6oHjiT9XwxAd?=
 =?us-ascii?Q?ZIvkmOn+2RsZOs41i6enxx3ycPqIoYmxWoYJdnE6UoQZUsc5fGlYQPk3x1b/?=
 =?us-ascii?Q?hqLDCPi1MmvrYL1vzb/16AfM4gj5jea6HEBRsHHiHKVo9qVlStopwkwLhwEf?=
 =?us-ascii?Q?ME0uLMo0RzTEK9mNQgSYjkaXarnW7BJaQAEAWlE2DRbNhtv6gm2CkUmZxkpj?=
 =?us-ascii?Q?/IXX/xWF7D22MiDk2GwipB6pq8dJlWCOazNEvtp8UmwCzZYrWs4zoK6BHLNv?=
 =?us-ascii?Q?fqYH9O/ooRNNyWD4xy/6OuFsec/Dv2BoyYh3lx2EKx/l7CebwYwZQu1oMrdd?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	M6ySvXPvnewGVpVPeM8z9Y+cKXuusqb3p1rWWVmmbJ/RemtWA77c7VQ08s9PEz4d5s3FZ/vv4hpvNqjARs14A0kKqaHoEdvfQNIo5HBG7dQVj9FvnyR3ykcqSB7UxvmwoCXlNbD2H5tPdXMb27H78zuRn2gs3AAyLEODjy/luF8VLb1hqFZ1F63hfNKJRLBoXQdFmd2XLto64sk27Pf5Lh14Ne9wde4vMyeo6G6g81PmE9D1e/MXB2FPCCL6JiGnWaCRI6/RjOY1SRdCxABryDQDQsEsFcnzw/oenOFTu5YzQgAsOMueanbAnH1UAbLnEfQSJ9Zoxb+kep5lVWt8vvs5whch+H3JZzL0vD4tzAxU7IvRfCiqigk4FO88KJ0PgrGs96+ZeVUzrYJadx+lbsqc0s0rm1Taib1AmiJ6rVEE4ervGZ/F5BYvVNT5As7ly843VxtCfhq5DPXvu8EJA5ZRNroh1mBjZlzRxKeWenTnmmaeL1PLVl769NhQuZx9Dihh4gYGDENG7DkXpnqix9V/0aDKuSZ/RbRJOw+CZhXKIlBByrh/sHdcHNUYEZBehAiTznA1+Z19QGcGf5SSfHAFSrXZ7OdZ/Af6S8f0EmM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3635b472-1995-40d2-68f9-08dc0cda2e3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 04:03:59.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0TUgnbS17EYsKAdZqyHW3w4o2arNLKF1VPSY84LBGLj9iRugKroG+qtZhna/FqKX9eyQj+8siHerhsmRYhDOoPEMNqpviy1+8SwRmIZ4Hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-03_10,2024-01-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=757
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401040024
X-Proofpoint-GUID: xNH-WHHWpeQYTDGUx6m-0kIoINbVBEIc
X-Proofpoint-ORIG-GUID: xNH-WHHWpeQYTDGUx6m-0kIoINbVBEIc


Bart,

> This patch series fixes a kernel crash triggered by the error path of
> ufshcd_async_scan(). Please consider this patch series for the next
> merge window.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
