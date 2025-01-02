Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63961B6D18
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735848775; cv=fail; b=E/Yiog51CreEQ4UqrXs/DU8A6Aa+vI+6XlfD7ylnYargR+F1kEKgGgpF3cVNmtDJarHHxoLoHIjIzugO6ZwWUWStFpxk6YAaOtjcYaJm7/TWuyLGEzPhWtt3JvKo1tcffBGE83KKO4LyVnaelOwvkyAfkRHK2W2kC0aMKcFHzs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735848775; c=relaxed/simple;
	bh=/3drFGvlESQj7F2mhuWMOcLb0m6ryo2KDwPBKGiCmnY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Req4s4oIToqttCacjkH1XUQzsxcARHcra7sPJD2as1DHiFkmU4irs5uN8N3nsEZ0bNmN/wafI46D3v7UA3QhvoieEnk3NpJ1R7QR4JI7xSwHjh2JvhL5n0dn7S5lVSxW3W3f6lr4uH4H8PMwMFRM/jlqa61yd0EB3oRiN41+UMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mz3WsYcq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GNjWA4tm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mz3WsYcq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GNjWA4tm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502JXjYu027351;
	Thu, 2 Jan 2025 20:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7SrcyXeSENrmXBompa
	O25uR7sruAu6pG/V+xNVQ44Zk=; b=mz3WsYcqlMyGwTurKxfCQo3OcRSvgfgFFG
	9TSnb3W22FdG0rrcGMa7CPuozzllp7HPumeo0moxbjhq3VAckqeiPwcbDJ2/VU4H
	stUxEFYKionIpjEfSacmQCOjAh/p8wJoGdzy38kaci5jLL4v9MbukWUevr9i5pzG
	CqZ9Ypm8WcRCoGUXzxo2uXHe4AmkXl98isEGLDMDzQRyBaAW6NM6DlThQlH/a86l
	hBtWbAFB1oVw1Esq4A0Vu5ZQkwCq+nehoOVqq+1PVJXW6nspkwKcTIAq6vSRqixR
	KxTYTTJvz0whp+vxPeLc5NzoK+7k9AhBLofHXNEI/331qbVeAOJQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t7rby5j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 20:12:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502InNHj012922;
	Thu, 2 Jan 2025 20:12:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s907hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 20:12:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K0MbSqxmQ6eiIoqG4utVYToZhYCjb5koWBy0VEnfgZR5De0bHHrTSIu3Ssh7k7osAjYXEbK82SZTnpfapwjYyTRVZKjW5D05/AxtxVLSk08dAyQbEi+9NCu9ALMZII/moiZh3SDO/XS0wT5F0u51P7hkNy+m/EJfYW/x0QYpmeiymjovu67q9CMXiTFigF/1aBbxrET5ZOJIAQSvpOwSG4rPWMjFME+xtSnsm29x6Ex62yX5s+919Iayt8FjALIysX88LN8h5fQTjevGsqJ1y+5V0mvMplxQ4EoOSgQtSsae6a/ZHBEcSk65zAMZWPWhZpu7/7BulRQt7WGlroTZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SrcyXeSENrmXBompaO25uR7sruAu6pG/V+xNVQ44Zk=;
 b=toXgSzBqG3zOXu3Vb6zSRvMBdZ6DTle2OpL77JVhCspvd+4nllP3dPna28DIMGw9FomiWl5DGFXEkFjYdPxZXi+19jwYRcjWE7X+YG0HJ3CeKN1oRJsRInMa1juUBdr4bEFAzYevXD2M3EydoLD77sp/L28h03KDhXY591y+rcw61qoYyjhIDYfCU5k62gtGTlvhgGau7Z0WMqPvrpDXaSIYZ8hFs7HzgTEqGA88IcP/leK8QE5Rn/nFolX7JcVjVEYYgDhopPow+0abOhdnXg+iqhyCBLwADmlddrtz99dnh/cDuLmyJu0hA3CBKtOXx5ZIWkfr8diMoDIsl/NRmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SrcyXeSENrmXBompaO25uR7sruAu6pG/V+xNVQ44Zk=;
 b=GNjWA4tmcMEbd31m0f1hFl2lIYGsm3L3Xprv0+jQBFGiIWhWt1pY9P06v14HBz6k9CXf4O+aErGiD6HqP1R5PecH9iuJqXkKE8ogkRxQlOuwhwU0Bzd7wCSxYks/XZ+pXRUCwc7VGmovqHBT7ofI+J5ip7U5YqkGbOf4AvKyjxY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BL3PR10MB6139.namprd10.prod.outlook.com (2603:10b6:208:3ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 20:12:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 20:12:31 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: scsi_debug: Skip host/bus reset settle delay
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241216184852.2626339-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 16 Dec 2024 10:48:52 -0800")
Organization: Oracle Corporation
Message-ID: <yq1wmfddlg8.fsf@ca-mkp.ca.oracle.com>
References: <20241216184852.2626339-1-bvanassche@acm.org>
Date: Thu, 02 Jan 2025 15:12:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0027.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BL3PR10MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 32af624a-9b16-470f-93bd-08dd2b69c9b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZvAPdrQ4KTYbJzsaiyDxENNk3sfgc5FGxaBCk3/6UEIkwQ3vzBT6xCP36OIK?=
 =?us-ascii?Q?FnzBuq9lgkTq+uuDEoM/iBnCoQjsaV1yzfzXHNY1I0mVK7yuNar1C7xswQm7?=
 =?us-ascii?Q?SY694Ms/xEY8hOh093tdALA+okwiwIjppjrRoqkWUgmuPglB1ySGddnG4BJ7?=
 =?us-ascii?Q?CxScZmbj7HGYyLavrVmTBVvyw0ioe5sQrTRBMnKsB2QCacF9kLe09ynQ/Gpy?=
 =?us-ascii?Q?ihWI8CggIQLh/Rl7P0TEjfZBylIUHaFLDcmMNB3kEyZRLYeuYZz95QmvK5TO?=
 =?us-ascii?Q?bm6FgXR0OhyFCyvdamQYL7yk0nUAGX0mjCJ6FvDVrjV5ORDZCjFbksg4YSHR?=
 =?us-ascii?Q?NWITre00JB5MMCm7+N5yOTo8mJyJpauwcqzkS58tIBYkBJSlMb/FlOpJhQ03?=
 =?us-ascii?Q?vdTbQFnbmNpGQYyeRQk0firU7Qk4QPxIWlG4ED/GA0sfEhcugSOMZgdhgm/O?=
 =?us-ascii?Q?14TzLAA3C6sBt9wutJ1lCqXXrRzVTfL5yaUSHglHJbT4DXYlfsJHt+i0XiHa?=
 =?us-ascii?Q?3EBbXMKWp0XgvW8TJItu3ghhgCPAwxDzWGzPB8whFe1GljJRBRENvWvDfl75?=
 =?us-ascii?Q?LxLTVMkV6StbfxWxJEzIpmjkVNqougkkzaxL5hT4ZiY1hjvkCpjy8IZymubI?=
 =?us-ascii?Q?+SQJPW5Tfnv/wzIEh0zTxGKmXq69SwKwbJ2AZ3KElb7nqOOU+u1XTUpqBF9t?=
 =?us-ascii?Q?2GnkYdgq4XeL2c9RTjfS2OeQXDScO5woSlogmWHURenwUUT2tjhOmSaRBDsx?=
 =?us-ascii?Q?+r/HXlRm7LBhCdz/0ISg+JUMhZtGo0c+I71N2myvxUDtp1EbywBI/iGkTYMn?=
 =?us-ascii?Q?gwtW6j//B4+dmuQkVM/IQer9+MMFD2o7uLU4OcLTgFeYIDoz/Vs7y1G6w3J7?=
 =?us-ascii?Q?8ZIuoOgYWFARGcPlxPr9smHSYTk1xjhsjI+lKQ5V1t7bnBapeTuGmxYW0Opp?=
 =?us-ascii?Q?6ptJBDbgENT0xi6aKSFfSsYYewMJBToJTE6YPSdHKCc/7mKzay7AScbqLXVP?=
 =?us-ascii?Q?0OFjOyal8eys5UwWKdlnHwl/lfNLGTTL+vipoIASNZSYaDLoHPBTxUJ66btA?=
 =?us-ascii?Q?CD/MZmJZ8gICQOyLYHwPPnQ+QukZQn6DvgZnSZllFogS/iYYCsclVHoCftki?=
 =?us-ascii?Q?MBDXwXImg+mCZ0gCUIjycDgj1Fm6fqFsOxLuJpkiaARpVJb1enxLDfRL04f2?=
 =?us-ascii?Q?DTn3CZcduJFXBNbdOwO0ROTJa2/XWfr1azvc5Hrb//CTIkhNSct/CXH/aFkF?=
 =?us-ascii?Q?Mau69l5p8V6evklMyM2d7f5BXil+LqobH4r8gtj9pH6U1lIYnQxLLd1q6mtG?=
 =?us-ascii?Q?VwZ/gGjgr+k62esnIBakO7kKa3FQAxjhfsFaXHS/0MGe2O+MygOQVdojrJOD?=
 =?us-ascii?Q?PHJBJki24JGi6zNwdBnVz0gvXP17?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AfV32P0k/bqDmQjiQD/ePdMWs31kjE+vIvSP4lUQTeFq9oS8v0ZTnIczgN8F?=
 =?us-ascii?Q?Bk0eyegi95JL4DRTWTjpbeOUJ5NpCt3/Xn9//PeRpZu5d/bf5GgJyHki7kGN?=
 =?us-ascii?Q?pnpvE0WL68y0i61qgPuU/V7uJ4HYgjwgdYciI3PMVH+Kk2y//KW/vwHUtPTd?=
 =?us-ascii?Q?Nk7+ZWi/QntwVQFPpLGh/dg01nPPNoc6WWCg5+dqia3B6x08ZEcfD5fYry1/?=
 =?us-ascii?Q?IYY55GI5Q+kGoQT/l2As1sbmtdZbJTso3sRh7FczPR1gIh6+uAt3EPekBtVJ?=
 =?us-ascii?Q?sqb0Q0RohOQCXD6aSGkC+aBbPdiCcPVXFHSQsR5FiVEEoi4mHhMzEM+axfh2?=
 =?us-ascii?Q?g+4L7ijqcvHz/x2H3OWnG93DfTxaWGmIAAIUp3M6dH6nedz5KxR+B9jOPsUi?=
 =?us-ascii?Q?Hn4P5Km1oSbEgPrWF5qd/JpCpbYBgEzrtmRPPvhTU0tl6bcbPnISq3cDsvs+?=
 =?us-ascii?Q?g0BKnA5wNwucy9gZD37bNhSiVo67ihmZc2K2iXCmsMDJU/X0Hfh9DvltTOD6?=
 =?us-ascii?Q?anju6W8R2SZd9cf6V6rs93SQini+dK+QcrESzbd4boUZnqC754XW1UnUpYQB?=
 =?us-ascii?Q?Ws2e3Li3reJzS9nVTC5jaBZXo0x9t1K8+UKH4vfYl56DcWtwdqyte3Y9ly0G?=
 =?us-ascii?Q?JL1blsRKnL8W4wO2vaz9icuD/cx79064KEkMIZqSmiMFAfCHmq40evQncsef?=
 =?us-ascii?Q?1c/BLQv5iLmWlKgXJs+cfxTn3WMDA23xAIUr3S6FeNAwkfyiK9RBQeFPCi/T?=
 =?us-ascii?Q?JiyNFRPCh6ceyF9wPNHhq78roGrPvfGS/IPsUUXWs3+4tJUJqYYoAAeyaroQ?=
 =?us-ascii?Q?47BJSxPY4xZnWBHtqcEGDwa60OGscldSm43LovQkIhH4ZItGKQYIY/ZHYJtA?=
 =?us-ascii?Q?KOBGgzFd6AQX/kRp0k45ei2pYSbKfxZIRPftBlf6VlwLMYjVfitPifF1mx/M?=
 =?us-ascii?Q?E00CMwuRa47+y5cLl8Nf1TUC6J/aDCWT8cnA37Y9ssAYzrFQDEX4ZOCS/pwy?=
 =?us-ascii?Q?qxx/BHXRx7b4arGwmwcTSsAh8Ei9gq6sud7/mkqRcDvmDmOMYt5guq/emCBY?=
 =?us-ascii?Q?gIYPO7Bffq1n464cm3N0wHw48+nVkByQbMYRiWcj3JG806ycpJwOx/QZGIkC?=
 =?us-ascii?Q?UH8E2hbv0EQTGJ94pFdVxiSV0z++60XTKfhqzKfCOnGNkt00m1WsN23Qhjbu?=
 =?us-ascii?Q?PPMT1pwJfprLEiVftWAR/jLLRgBcG8Khy6I+syAnHSCIbBn9WFitkQGkLkC5?=
 =?us-ascii?Q?StmyIwPRBsIlDqHMrDuuHjzG9bAEFhiXmnZ+ZYKfnJFZnANDqEtj+0ZzU7N2?=
 =?us-ascii?Q?OotDqiaB+qiyF5R0eL/SZT6CLcgU/nX1sygZVXWdNgMK1gRS8rD5HOWy5cOT?=
 =?us-ascii?Q?COg/SCA/0h4XREQFJDEEMBYZK6WQB3FR6A0Z5uZkbpy2Vxse6MGTmi0cbedB?=
 =?us-ascii?Q?MrsIPc7ve9dYRIZPNkB5vUNnjmFGLvrftgfTDI+KNMAjEFSACowG2cONiJjH?=
 =?us-ascii?Q?P4rS3UQQISPOiT67rJrZG8dzaA7p7cBISK3o4aTxNrF2aXIOIa8j0bcf9Y48?=
 =?us-ascii?Q?w5OX0fUbFoUiAcpVRw1QOJcqqP56FjNXwdi4Y2knxsM+CGGzwbeUZRS/kx6I?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZluRXfKdQN4HlTD64Id0me39N8X0jOF3HeSQhmXCwZWg/zx0SUeiJMAVThRMJx4Tj7659oKvyOdFT930MCzbHQLPqn4/UAcNj4fAbZbVvVOZ7tLU/qVmj4BhPZjjHKdwntKw1k8TU1xFCpLebKUASSYbAdZBFujDYRtY2yRNDgMfGSPUadR8BhenOqSP28rO3nTyeOFm6nrlDfwKPb9rnpnv/SpMz2SJON0Jyx0d3sVJZpHZiXusSWG3S0C0M/A5eaDP04QGLNBFPPOHeB+971YC+qx4YTyp/6sisfypJhnOzOQ/MY4u/ZqD4/JMKVTPcX86jyFqCZrTN5inNCy9lxVRU6kgxIddHwextNzSK/cPc6K31+61A47M/6lDnPqGnKh/1k3KZipfC48iiyGy9psfGzsjgAkAyORLeYbiJAwTSxMBMD5gpF86QoWrchWKUsaTFRdz/rtT4GQ3HdAeNuM1okY//UKf3uPSdV73YOI9wrA4W6cJd/iDg49G/zEidzaYEzTQVRNUEkFpDwcBPxM8aJdi3xJUDFSlpX2UuaMuYVpYxxQSCLaC6BIsC0nnKJE3eKx+7Zck83ZLNGXok0coWuqlG/xpESceWVc2iHc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32af624a-9b16-470f-93bd-08dd2b69c9b3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 20:12:31.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSGx4oKmhlDS/rCG6K+7imNufI/YfAZMGtrlCLAxuHCXBEBkIiHxFm14pzojWYd+QjoehEEonSOlyteU4s+6+bht9rpBpFTZMqEzXjKUs4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=940 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020175
X-Proofpoint-ORIG-GUID: Gt_n70XQE94w_zbBHwrEGLjfTpI70Ct6
X-Proofpoint-GUID: Gt_n70XQE94w_zbBHwrEGLjfTpI70Ct6


Bart,

> Skip the reset settle delay during error handling since the scsi_debug
> driver doesn't need this delay.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
