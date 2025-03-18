Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28561C2C8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 01:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261343; cv=fail; b=mpDC7vzV6G8FNQKCEe5zwkRpLkLWv2o4Rw37J3Y0uDBLj5SusDMjN8tx/0WoUBgtpSP/jQiDyVr/5l72+qCXEf1EDs7yJXMgkqjcpY0XKdjbtK+wBMsLqjO6fxvpIG31o9YtpXEBzuFo8rW0Q6mcD7tKYPy/XOLAxev3vr/Jrwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261343; c=relaxed/simple;
	bh=j7jiM93QtjhwtEWtPdCmpHTKCL4QH182+LmQKTU2wEY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JtJ+rPtOLhxpF6aGz46DIZ4EIbDypDlB2RcEm+TlQTEBTmp4q8IkNzg+qVQ0guldHa+239rdcXwe8jkR7dHr8KYqHzgUrtGrEA2EETz28+BsA6lNMNs8ITlpgBQ/z067YjdZejwieLUcVBA5DYvQq2iQTiVw5b8B48bo9WaBRxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kV4keMeB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zpYgKsdn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kV4keMeB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zpYgKsdn"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtrb5005410;
	Tue, 18 Mar 2025 01:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ZXuPNTf1hdHtoTfY/l
	Y32zCMkXmudxgxu/D+zscgOpY=; b=kV4keMeBCRHIbZFFywmCo9oI8USn0zdWp9
	jwMAdkHPUAt19DuS6ciGvofLmmfVjOufE0iqjMKbXLDZQRGyCiLvKjo0Fi86SJhp
	Y3c1TSlpHm8essJAIAVnAr6UpNoHeIQnFzzOpOCgFK66ZvTpNsuK35q3PwQloS90
	djL1GOE1U9QtU9EDQ8HJbHax9kuZImUiGzqHn/kXNMwcgFIXxOowt+VdraSGb+6o
	rAV7fHOiDkA/69V56gvXrID2Kgat75eGbDGmhq4lLTh9NaCrO/aFiy8YOFT//u0X
	0motlt1a1gEiKH8M6sLkxqKRrmzyYHAg+ukmPYkhfmD7NOxj9d+Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1kb488g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:28:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52I0O4VN009582;
	Tue, 18 Mar 2025 01:28:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxkxxerr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 01:28:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KEUqMPzOjNjhOc0GJY2nAfTPrm4VdA8hjpAhO+BeSSOh2dqpqxfdx4cipBV3Sq2KOK7xaGyk7YCD2lkl9et1lU36xa0n6yDnrvw0lngIF+iKg+XqlhQa/742BgZqBKNfT+Tz7fxgC9T7bGVNN4P3udawD7kOzhRLknJGkcy3xp2c5f92mu77hZ/6Dj6QVL+B0yTHMM7SUC5jTp9Xt2R10nY7xGfycVogho5dWmZN0Qt47KleZLRhoRP/luEvzSSCvdP32T08gv4BoLPTsA2KSMCqAeb8McVqlyXBXsa/txtSeBRVgNzfFBbci/Ywtbqj620W7/EipQSBQgVlxqQkbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXuPNTf1hdHtoTfY/lY32zCMkXmudxgxu/D+zscgOpY=;
 b=M6kUAWVt4Qeogi7EoDRLzJbOhjiXwEIabk9fZDYvXwN3DUQQ62sZ1yB3qJUAErb6wwmVFW2nqgpmmN+rG9EL29PiFG7zGTeMrVb79Et5FnoUBataW+X5HBs/o7VSYUpGzwvMfqMvaCbjv6w4vSy2fLNo8EBa8nVWD9hmBVV4LpO+LtMFwRLVLGX9hY+Xl6m5q13bhb0WFOBMjqaPXTzq8c27bF+gzzEQdeTUsZFJHh89ERHJMUjRYee5OoSUr59LMzZ52+lrhxbe+Jy/3p4CXa1ofUL4yvjZ0sszF+G6hgMz8BWMtgJLhobBlr3JWuIffRUBx0/fN2IOVVe0L2Y6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXuPNTf1hdHtoTfY/lY32zCMkXmudxgxu/D+zscgOpY=;
 b=zpYgKsdnRc3ROsQs4JyAB/41DfeELmlI+RvXLfPbjSm82C6DJVROMe7PhJ88nU7boXCV9QaREMR2eRNemUczMtD+ZlYO9HXTvZCruWIqw1sM4Sh8n3j+LYreCqDUmdKuJCSLI48SrBXp2nb/jBWlqEML3J9+6t1NXRMOlqINhkU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7831.namprd10.prod.outlook.com (2603:10b6:806:3b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:28:42 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:28:42 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Fixed failure to issue vendor specific
 commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <d56071d0-44b8-9572-753f-6db23709cf20@huawei.com> (Yihang Li's
	message of "Thu, 13 Mar 2025 09:08:44 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jz8ndt50.fsf@ca-mkp.ca.oracle.com>
References: <20250220090011.313848-1-liyihang9@huawei.com>
	<d56071d0-44b8-9572-753f-6db23709cf20@huawei.com>
Date: Mon, 17 Mar 2025 21:28:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a87ec67-0fb0-4d5b-2451-08dd65bc3823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?errabV1SvEQeHXdji5mM8bQbNwbxq3xFEF+oixKyAoDExVkQ+zW+VRqW4iaZ?=
 =?us-ascii?Q?Ssn49q1sh6KPOaUrWBFG2x+EWAOlvpvMvHjbKRvzOVtKwKauGlyrsRF6JyTr?=
 =?us-ascii?Q?/wpECuYX/STSyQvS2Twr98DSNp0sR8AsKBinboCWW+eocSH3rmw1+gOWPb9h?=
 =?us-ascii?Q?5tDX2ApdFZIqOa0dP3aHkOptk9/IB2FMa83jaEVZyrD3uLjCKIlDkRPZa2Zm?=
 =?us-ascii?Q?fUQGFN1Y14dtjK3+hxlBl0QZQ3qrJI2hQ9QMrJ62k6R/5nHjOsSu2+or2BFv?=
 =?us-ascii?Q?dQ52GFObN5VvFfbFenH1D53zslOSPCOQIHEpWkIJnr/g4nemkZ3G4/3UEVsA?=
 =?us-ascii?Q?ZwvKgjdPiMlgNoDA3scdyXREj3vQiau3GYCA8YV7qii6tv1Tr3ydotL49CmL?=
 =?us-ascii?Q?x4/hB1gKf1wKdcO2RZhEDLiGwhYrqlnb5Tn3BvnvLHcXwOyoPwgxWeo2SwWb?=
 =?us-ascii?Q?BfvK0wLTJEsqA7Gmypv6NzEs7a6jySJdrVoG/i/vYCw4AIW9t5sf8J7DAB/Z?=
 =?us-ascii?Q?vvnTLi4lx9zeWFvCbtXwNxZPWEJNkWPAoLqSo2YIGC1Up9cbCfbO9OKedrC8?=
 =?us-ascii?Q?bx9Xx3njhm0n1oKN8QS3A8bGQfIoU4mMiGUQ+l+Iuwk4D/0rAuGHkbLnBcpX?=
 =?us-ascii?Q?5dFefc7ebfEol/kwOvr60/GlbkrlSQyElsEx/sd4GvO+H9+q21QnqajVT0n2?=
 =?us-ascii?Q?QYI+srRfEZHYfDnYzPJpla8H7m99zFh0Y9q13Jl6lxpwu90sTWcGBEIGOgxa?=
 =?us-ascii?Q?XJxRDh3WQGg06ReAa0O/kHdQZOhJC1p7K1GybZVhT+PO1fPzfVnGSXlzn/rx?=
 =?us-ascii?Q?8NqEUXHGSLEwuW9jIm4KhjfY+Gxg6UqCo3zRYUMp3hGCJJNt08r/gWRUVVQT?=
 =?us-ascii?Q?Ip/nVdoeFx5pqyXV+8DQ5Tx5rqwn2cYZNhf+fpWoXsV1zv5l7f7H9umAhOW5?=
 =?us-ascii?Q?czBLBsdny4FFHyHMgCpwweUcHn0++TSH1/Rm6z4pGYim+aS0lRgIBFjIO4jL?=
 =?us-ascii?Q?qRlHfhWa05A4nu+gvWMUOR9a+AXCRiamspvgvGlubXSbCSWTlUIx4rJFUW5N?=
 =?us-ascii?Q?O2OYAidh3ogl9p61CZLwmDPNTMCxl2med6sJSVDWy0356bvUXlNPTVerpUM3?=
 =?us-ascii?Q?/NQuEhdAA4d5Y0jyDBsAT6RPRym1IJPnej5qXCHoqfTWgOYKLg1wQ2MyHMIL?=
 =?us-ascii?Q?IhmIeJCiX9OyOp+LLYztitNsMnmmkq0Sn8PZBvsjYIIhbROdIUUsumYGrzuE?=
 =?us-ascii?Q?pS7EXfbBamdnCSm9uGvDigmIV6zZlvduq5I45Z7Oq0OkJ99XVtRfUvIm7SNY?=
 =?us-ascii?Q?hJ4ihLWSWm2Qnl0NYbjuLs2xPbAOv1H9v16rMC1InvJUy447CVObe0GSz0UK?=
 =?us-ascii?Q?I/N3uyYvBK0ny9kwKbaLweHR6IAB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?csplzS+gVU2lgN/HOV74eY1VWxpYkmV6dpDlSxO9LeKYJ0pe6vxqOMBkIx7D?=
 =?us-ascii?Q?GScypWgtAIMEOiz99nX3gL9ujw//G1deWZFCECgujXY6pSgBagTyYF/jt593?=
 =?us-ascii?Q?eeO78WYkYspQX5MJwHB88+/gl80vwvKcHGTRs1yeKhwlA4FqF0iIx0D0eaAB?=
 =?us-ascii?Q?eyPCBbIE3rDq54j3KfNZnxb4obamWpbIbCmbzY/0+xG9F8AWO0bxfu495r9h?=
 =?us-ascii?Q?tdSAuEjYA/acWX7w1t6L4ciCrqY2zhu6gjSx75jB19EOf6QKM9l7m9MQ6U7X?=
 =?us-ascii?Q?iqXEnki+C9PJXU/xK72fr3UkyCMpErR0j0c9PU218yC+TbqzywUDe767VAqq?=
 =?us-ascii?Q?UMpmKygpKRq4tjQW3UCwOWdSGElAdgMO9uwkKm2j2XvO14aHUkZw4FtBvXxL?=
 =?us-ascii?Q?8pgkw53Sn24XSiILulhVjKnP47tIAnKvbMDaVvOx654DDduffudSYGqYwYeF?=
 =?us-ascii?Q?bhdqxWS8Qj/c71uTjrLd+CmMbVudpix8DvBtu0qvxU45FJ+jgrXEZFKWVEzR?=
 =?us-ascii?Q?znoY9jcK5OEHyKwR7lW9tHwP7DGM53mp0xhJTnORP4cpQ0A5jhkCp/vQ/5vk?=
 =?us-ascii?Q?d93qpzWLaYusfBg+ESB1P/MGy0c3cwBPkI5xaxYi3abAzZJU6YAJgDiVqpFu?=
 =?us-ascii?Q?hm61IAV8jx3svHRWVvqOUiy2xG2UH7Etnk09ufgNr/RJUBXPd/c68p94aDqZ?=
 =?us-ascii?Q?SfU+6omKymybccBXC1CxL57/Qe5/nSGoGmRDUMjmv8o2iD9eHpFTZlNUUi9V?=
 =?us-ascii?Q?0oHUHzZYZLQnfjjYXeQqVXByH8khEuLnEvBc1sPanZPAgqk79Qny/4owMuc3?=
 =?us-ascii?Q?lnFcVL4utB8Q1sB66Y34mLQqDaVLvOCLgEsm0dWmHxvCMIgkzZwIVLMvzTzE?=
 =?us-ascii?Q?CMTcWYRoGIKvxraBpP7EF50J0+TRyNPTylyQptQzZS1jPSt7dW7JZ6curBTi?=
 =?us-ascii?Q?qKqv+TMj/O3n5M2byhbrkmL4ttJ2BA4tS0sPKAZTRMnCKlsOq7qGK7SdWB2t?=
 =?us-ascii?Q?HD+DIJ3uq6Jd4Q7LC4Pdhy3ObKWAoGFSQyhkkE8TwqE/LrN8bch7Nu+eOZ0x?=
 =?us-ascii?Q?G+tWU7+ZzXVjEu6TnwHeHYg0zkbcutLzj/+rb8LAYpMj4uoPzYrUqfBsMM1f?=
 =?us-ascii?Q?IuMUdFYEJQsYT9s5y7J5orZRjm1EFU85U4iCDV6jwri4zWsYqzJ0jBQaX7yz?=
 =?us-ascii?Q?G+2IhjWK6C47AlBSgO5kyOQ9Km0VQjEonNDPXRyhU76Ml5AJycmPFi24GqTk?=
 =?us-ascii?Q?QbYlaId2GGEZO+CRD9khPGEcLv0tcO2yF/q6z57uK8RsV5Gcg+IEdONmCan0?=
 =?us-ascii?Q?+mzqanFiiDatNQ/8xEcLQIlOAci6pmwh6H4ulNktOlfWMuTQeBtJzNbfZPoI?=
 =?us-ascii?Q?t5w+K2zXHb1sCISlhDBcs9XvvsCPpKwUTKtr/qS8HpVeZxCBzbR41ikX5Ffi?=
 =?us-ascii?Q?lC0M9x6l+jO+sYjoy4sM6glNyBms5VO96T0s3Tvie277TI0Bn022qRTAmFcH?=
 =?us-ascii?Q?kJdpzqJtIeDPVn5VTD7LVKmS2BEDPyR8nI/oNkq+5m5pVd0GoYqySMt7JX+Q?=
 =?us-ascii?Q?lzlFyE/OiX857yXHNz+G4whdWrwhqz+ik4er8kEji5UTTYceCgt4SwGR871L?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	An5GB2MRs4H4fp/a6amdlXfbeFWgfe03Y8FQe1S6hdutwc28lyRMUmlWacsnWX2WMZ8Y4Q8egZD90n54M6bQUvSnWASuBEgMo4f4eL+YWEcIm4L9znYvxArgzo4vjw2oy/VwDmlBUSeaw2gv3ep0xjadFCfEwHipDjQriv6h8tmk22yTxFY/7kpz/wxv3jUdw7VXowLw4F9/X9zE2Ak+oS4yFVZ+W1mSaLpyeavjP3s64igNQqa69AdZc8a0kmVMT1ioSLxlKqYKQJimm3JSGVnyc/TCfZScyc7jMTkNBnKYZeXa6fW+CxMzkD99eLM1Jr8fh6kUYCgARjgLwBnmXlCmZ+bvyY/qhrZg8g2qA4ZPvu62EPuky8t2ZFhUTn4GTzEGh6KRvM7WvZX/EH3klyY0e2c5OUC//h3f3mrymDNHgaV/5Yuxks0LZKZNOzf94NpqC0Se1Djmb7vnLHoqzg0H1uaqsmdhH5mLYybvBUdaXt3j2Dtk0Po6JOshe+N599yQDLfOThia9h9ra2cLVAqPouUSrG8BRXtR8Wx6xRCT8CFjz0z+UvwpvmBaynnVRqT8GfAhWH+rVM+WLyDTLxQWaMYKg+fbf7bnqkfEzTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a87ec67-0fb0-4d5b-2451-08dd65bc3823
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:28:42.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /OWKwjIr0ZEN1hCUndBnhvOmgMrAbDc/CRIc01WyTXVpi95BnACPKQ1R3PsjXg0zfCVQHwwO0eqzkFLmlUwEhTU2ItkBFZ06icRGEfDFijg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7831
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_01,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=868
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503180009
X-Proofpoint-GUID: DZt20ILBn3oDzjGSWKFW-75C-18C3mJx
X-Proofpoint-ORIG-GUID: DZt20ILBn3oDzjGSWKFW-75C-18C3mJx


Yihang,

>> At present, we determine the protocol through the cmd type, but other
>> cmd types, such as vendor-specific commands, default to the pio
>> protocol. This strategy often causes the execution of different
>> vendor-specific commands to fail. In fact, for these commands, a
>> better way is to use the protocol configured by the command's tf to
>> determine its protocol.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
