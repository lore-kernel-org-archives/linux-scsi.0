Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580DB1C27
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 00:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326531; cv=fail; b=Z2hn6DmCVcsQNeJchR9XZ/TzpL945uea0dPCttqQdsotUzad7rIyoTG9pI1dcTbe9WZL3/ENH+D0VVA5LBAPSQJTMFCsJOUgxWUt/ZCqqfGbhWCUIMrBtMQePfzVu1GMgbf/IqpVKvnDzkmHaOs+AwZbeE33r0itY2pkTiw9L/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326531; c=relaxed/simple;
	bh=PK7uTojaof2QceQtMu4V+BYkQH4vpxf7zGscY3UqepI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XaLyTsTJLP4JIZ2nFQn9X8oa/q/XMGj+rjLxwWf4K7zZfvNy7EgMQHfzT5QwkmyQKrT9SlHzCzEjKW/6Eim+WNB4KuIpeqC7ZGNQwOoMPJ8rwcsy2wyPWz+L0tDAYmnpK5Vxqs39lhH/fdYpErNvUj5pHquXFBa1mumMbgYbk4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DRHZe3oz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=skFoRKcp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DRHZe3oz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="skFoRKcp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DEtP9X000838;
	Fri, 14 Jun 2024 00:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=ciuvg80nssII9I
	lAQCkj0VnFmsqDW18nsm3fC8RJ+Kg=; b=DRHZe3oz4cFE81kp4tVom2j3w8qq21
	sqsIX5jju6qnAMOAHvUNircLWLXwhZk7BOKPr0fI35DTOi3EznirxYDIm3yEGSM3
	xnhMcrXmCE1R8SFri0oOhO1YNziK9UKBZtF2mvBtc5OCCf3u7wm5cF4/tYGSBvQL
	EyrZ9LuiN1fBh7jgxrBCKz1DH6FhWwiAvYg3IoLFqb2jNbf76DkbEXJRJiAGKuCE
	A31VuoMRSlU4eRf1ZJpdKJ+qCdzamVSW9oGc5SG+mlY9OY9Qp0DCuMXncPeWPZcT
	xgY+AFPSlL58F8Xjm0nu4U4mxe88y+h364oV8S7UdscttDdMqVdUJV8g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhajarg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 00:55:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DN0krd027048;
	Fri, 14 Jun 2024 00:55:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdx1ndv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 00:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsqHSsI+gRm60phbPztIIWbduYNePMuDTpROGBKJCPPjp95OFrUunHN5sfsaObcGfv5nZF4jpiJswU20izCxZTFbtOaX2+fzC6s9IkHUlnSMr8WOCRy5d0QCx1yJSWOlcJGwrJUwQEAgwCuY4UWMVyHOtBOURXrm1LkbpgUJth84LDnYwzm17CWqCag9+y4jnMIaRDtpnPnW8Xlyp+NY7cfzvGbgc8EPzY1tmpsfK3IwDp53QITtBxsT7L3TspOWlpikE4tpjTpXGuaC2LKy+ZPMTcRAIwxEV6jjiFERq/oqyHSET5dWC8RUycbF8HheVOI6z76YxucmNhBCjLNwbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciuvg80nssII9IlAQCkj0VnFmsqDW18nsm3fC8RJ+Kg=;
 b=fN6g/NC68nhYuruZKCqOwvF+60eCMQ++3a11RymK6M1EqAoCW2UeHsEJoYAtmqrttSDsrjV0RihZunO1psRUk5tR9joSjtvvnzPYuur1/87NQewWlKVWALlL2FhMKY5epVaFqhcXUFywsdqvv0oWw/MRsPex5ojPHuJwwvHeaO1OrtDQ9UzF0Y1MEnG1j4pC8PPO5YfIY6jX4TSdCkrmnWIzwk2UpghBWI7Z4fkWRfH9Zs+EGWIqYWIa/p+4kgHEl5rjruXTxI4HhbdsT5/m2h4dxmzhREVpRNvYQ05YferGnGbUbtYRVoIW4wRPWjXGqFqakfJQXEtlcL70Dg19kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciuvg80nssII9IlAQCkj0VnFmsqDW18nsm3fC8RJ+Kg=;
 b=skFoRKcpYf0X3aUXDt4Hqju46wSHz6ZswP7n/2HvV+B6XQTXC1Er8t5OLqBC3htmCOojJ9cBfP1OIzklg8J6kxuaBYbsjn0zmK5bMIIDUw3ViABXodeYAGi7cPpaLTndFgoISwJLyV6vCSjFhJr1WfhgPnH7Zxb66R9I2M2e+38=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB6095.namprd10.prod.outlook.com (2603:10b6:930:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Fri, 14 Jun
 2024 00:55:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 00:55:03 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Avri
 Altman <Avri.Altman@wdc.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: core: Fix an incorrect comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240612171522.2677600-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 12 Jun 2024 10:15:21 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qz8uyw5.fsf@ca-mkp.ca.oracle.com>
References: <20240612171522.2677600-1-bvanassche@acm.org>
Date: Thu, 13 Jun 2024 20:55:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0023.prod.exchangelabs.com
 (2603:10b6:207:18::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb5e400-d08d-47cd-24f3-08dc8c0c9fcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?9zHuMtkoXBnVWaq4pc8bEkoZnJnAV2SEYLYVO25R19F9AtIXeHb9jYiAOdvq?=
 =?us-ascii?Q?hgv0vKmofQX5OPqBFbsSRDY2T8m3/Lj/aMWTaYhdA8+wR4eKV5gR0e8dzRRU?=
 =?us-ascii?Q?aUwnD4wd8O+8G5g/525ORemwm9WBMthBBr/zV1B0q9e5juAnjI5b/vNCOUmy?=
 =?us-ascii?Q?4JcOSR7kvvJfhNy9ZGft78fAqELFgWq9PJdHMKwsQejpQr/TvWFWWu3LbT2c?=
 =?us-ascii?Q?OKifx0UohrS+1VBY6IYa/lnLK0ydTkoAF3+AW76EuiqyoKht/3W8/T4qqAPk?=
 =?us-ascii?Q?HoBmuiFLlzlHTQzknLL28NiZOvmUyE4IZf/58OEfPUORhNYHEcjG/HlXO5kg?=
 =?us-ascii?Q?ZHANa2/mP8nE+C3l27fP17MiFkQqxAFZJ7461LALYB1kP3LwfmrYVpdgGvDb?=
 =?us-ascii?Q?cgkae4HeFaCnp6jCItGFHvHcUXsEY1TmS4VAAkfXDdlcy2oZgfAOv8O12Qxr?=
 =?us-ascii?Q?aX44TXcgO+4vOtQ+UW/yS4vz4+M3tqwxk21Xp1Ofkk7/LuixUQFCz4QGFeg5?=
 =?us-ascii?Q?OMpcMLbBC1jdGFTsveyt8qnBnFtbmvsgDRZ3/OC6S2ZCaUDipz3n8y5si689?=
 =?us-ascii?Q?Q85ej7J+T+38w+/2iY8dIU3t9ppRTjaMAq5ZYrTzmpyVGtrxfRLmCZ9/dLFs?=
 =?us-ascii?Q?qr3t2YBaBj1iHMw2hPz6S/8X3M+NPBuqh6dZiQCLQfcR0Cve3W7gpihuMPnq?=
 =?us-ascii?Q?fuAqAYc2uUXSCwKE5kmqQz1Um8zXaGsdcCnyl5o5jGs5ZxSKSEkmCLyVa4ud?=
 =?us-ascii?Q?xNlavh7Pa/rM8Fh05uFjqfilPqn33OWYwjrTQHaWvMV07ptUgnyHw5m6kF9h?=
 =?us-ascii?Q?MtQnEbk/6dCk+VaeIt10nUZOT+7lXuUxSZNAMVUjh6rak3eGy/+aKubbGk4T?=
 =?us-ascii?Q?J7KQGzZ8XV83sdcfgOX/aNC/GzGkVQPeDW5fOzeoIvvIG7pWEacqvqsT0i2w?=
 =?us-ascii?Q?fNTdf55VrERGZGuvro98GXd+7hhxYkLWudZilhDMlPjZdJaoKZ2CPCi/WaHV?=
 =?us-ascii?Q?TJ3Bc5EAaTE3uDXE3bWI3aEZDKl1Ib0MtlFd1KNmfCp+R5Fqv26lnnRYDh74?=
 =?us-ascii?Q?XTmgEnA/w1EceN72OAACdZXamQ9qHHwvWuC7L+BdRsBMhENuvphVz6hyf2n8?=
 =?us-ascii?Q?wCRFcprMLQIj6idGRWsPhhX3j0TvlZn6WCpCoiGjZbjYo+LGPjQ5OXoaAEuU?=
 =?us-ascii?Q?0zW9hJTK7bwEPeqyJ9v3hAASvygEs34AgcxslDPH+silPxHu0+1GE0hSJ1gq?=
 =?us-ascii?Q?oB/xh20EGSvOKWHVkR114iaio2OuZfpJatrvLbAsIcdZmRQkg+V7/XNj3JZS?=
 =?us-ascii?Q?cds=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?u7MSS5GT4EgRb2FOhxsUtEXhcuUKfjyvoUbd4VV0UexpY8f8C4DN5aYIGaxF?=
 =?us-ascii?Q?hY3hqUGon9nkYu5pgtGUmbfYb322oMtsL+IId9dDjz2d5lDDMF6qlkVAe3EQ?=
 =?us-ascii?Q?q+6z4QtOmLG2r47DapEcwTWEpFxFjQO09HARhweFYHbSWqvdL2ICKjsjMXOV?=
 =?us-ascii?Q?u3nwPZJXA6OkjYNSPl/VSXogq1/Bt/FmwnV9QPRDnaqsPXNpIy5XoOjrmNmm?=
 =?us-ascii?Q?xL+zm+/o9oytbrP7Yac5p6qy7XxWgVBETzrH3TdrBqKg1VypjXLMhBHjT1Kg?=
 =?us-ascii?Q?MMJxtK47GAEbCsQv1ybT8cok5EBBF8FrQQXNipfoPsOeyVu+E1DWWzpK94ue?=
 =?us-ascii?Q?uUk/Ul+5udvILX2nb4RB3PifU+KrIqxCqYgaLgcMXjHc09j5USXrFsWc83vk?=
 =?us-ascii?Q?bIsrFls/gQZikB8hPwUqHzzefvbEcx0m+I0Z3o2UVkIU/PD2OycXOPsCKK4x?=
 =?us-ascii?Q?YocPzBoigCkLS/fQjWseb7XCrdNX8S8qFgV+WSrdpSlOwDU7RE+XKssBfvoJ?=
 =?us-ascii?Q?sjwA80+C9CYwQbDAP2lEbdvqblCikbwoAjjx4sNudDTfw06df66dBoM6SFYw?=
 =?us-ascii?Q?RrbC74oRJc32rWMVReOptPGt+jBD12o9sKkjKSdrZ/F4Pyq4bsFqwXXIF//D?=
 =?us-ascii?Q?6lVsdYNlymzoafvPviQ47zyRlhg4rDdZV6KZdYdv+j7WNH5CJ7M6aNz5A9DH?=
 =?us-ascii?Q?42ZTvqhqzc2IUSAUDNFr41p5AJNgnykqk7hz85XkDHa7jHMP8ORzB48/tKod?=
 =?us-ascii?Q?YxhNw8vpxLshMBzlqWNj/MfI5toMTzTOu8spDF14mizPWFF5o1IADXCxhTxt?=
 =?us-ascii?Q?uEDOKcV4nX15AL6H+QcbrLqRHKfWorfPJUt8oowTgVFfxYi4MMXMJvjTM0tn?=
 =?us-ascii?Q?ceWyD6cQ6vtAfJyVSj44xme8iYehul6772bUmoLCrkHMsm6xM+Hpn/k1Nm4U?=
 =?us-ascii?Q?V+NVUyzrWlKcBEWtIb9JAN2kk034XHgQBvAIk2A07L8HidD3I549eDjZFOn0?=
 =?us-ascii?Q?ZJZ0G19rZRspd7Zytw/tFWcstuQffhWhAH7dO7ZZ0JwMITnkcymrK5DHn1BK?=
 =?us-ascii?Q?mN2VcfYA1EOwSgnLQrwucLhBNex1tffAfHaif4ZtCePfdlAVwEE/MGuQl5in?=
 =?us-ascii?Q?8rOdVNRja+dMMQZC0aQ0YVUhPdrLc/HhDkqtY6u3ERXYTMCMf1ZdArIAU6AN?=
 =?us-ascii?Q?0N68Fatlagd4J5ObYXVJ1t+zO/VpBqbBLsGP8ZpSjEIMa8XOpJF0RJQ7+GC9?=
 =?us-ascii?Q?ROAO4Ux/IYg+iZzNdLMN/R4iKtCT8pF7JXQpr6ZwUSOeOJ1I0s7zRw6KiGz3?=
 =?us-ascii?Q?gvBeRcnphV0c/vOwM/zneLVNXYhcl9KVQdzPz7gnLJcF6ISNuEuq2SQc0Aof?=
 =?us-ascii?Q?3SNRGwAzPid9xW6sPumkM7gUfUa6BC0dhzyR2Frd5wseGKCwRWyN/GIEj0fH?=
 =?us-ascii?Q?nz7+hCrcsMGmtwOzHtaVDzJoKXgJyDlZmFd9awzfdSUyH1gHdizyca17ZRhD?=
 =?us-ascii?Q?tHhqYU4sI/BykSrvoVegWCYLXTpTXg1WXjTErm5lb1QGDgGWMKOGzAaMnFwd?=
 =?us-ascii?Q?7kOl88T3hpZM4JDyAar8q+1frcDhpur3ngzT4TrJNnQmV7cYKxUZG3WE7KXA?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7Nrv0B1U/Cx31vK1KsGO5yqVhX5jgZ1ctZtEDC9Da3X46sYsSfPh85DgH03qiKiqqqfxRsCvHUkhKQpLbps+HvTe/KkX1RdGzQPNA3tkQ8JV+gvX37FCjqvCSffqDadXuOiMhJyj+ZnrBXgIvpicqSFBFuOdjTNz5zbJBhc0ttxCX/9P8ig7mwTenzkjyPDJslNOXn0opXcZte/67O5wJfxKX8n8/w3XP3+x5dm6puacgIpGfstqjH8LgGH7Ob0D6OjtOYSPvBSNq2wQu854wauDiQ8INqD1bKfIeDGhT+Nkh+NN7BB/yyZOdvYL3/ny+5yNYFG/CT2IczwbcjjGX4ztJ6R8brQaGJoqiLZMHmjxKv2NQFKPwVKeR/sRjhL5yaeFcZBIdnorc/sR/IQsuMQv5NNERqI5Ey1/kK1t7+w8gUSfM6VR3rzSy88upbLqMeETVaI07edvkt5G8MBLDRSnFotYsbMr3RWOzvsU/kKh85URKUW/IxIi5lX3jBHMRGo1eNXdXcAEKkVrIZjKqsuThO1RAQtXng0S/p7/EYuuADrBpvDNVFUX/hQfW/3C0fcMZhy5XE46gZuTsCA6frHTPISfN+K9Pwd70Z/2kPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb5e400-d08d-47cd-24f3-08dc8c0c9fcb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 00:55:02.9117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5vvxnpyURwFEPHxxUbqT2+iBWd3+3UPpIZNwQI+uHGYLNWgqNPrpoCfAqkPwKRdmUefG7EftoaJuIprE3qFbAhiDjzJeEtV/uq/64S/hLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=958 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140002
X-Proofpoint-GUID: G7Td73IPALDfaReqg1k7-Ibh0FnF2r-H
X-Proofpoint-ORIG-GUID: G7Td73IPALDfaReqg1k7-Ibh0FnF2r-H


Bart,

> The comment that scsi_static_device_list would go away was added more
> than 18 years ago. Today, that list is still there and a large number
> of additional entries have been added. This shows that this comment is
> incorrect. Hence fix that comment.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
