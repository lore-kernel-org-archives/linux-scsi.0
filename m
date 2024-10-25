Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA02A1865FC
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729884670; cv=fail; b=BsZnv5ivlZMCKWQ5T2MXWnLK9OBxsArf5ZClyhI6PTpU/NoY4/0DCUv479ree1w8are1N5H/CaKERWizbor1ThWpVbtDEEOJ0qcdE4oBtPyYIZhJdJ81aHF+5NQ2cnLOBOPVfG0Ve6VhrZx6VDDV9HLdWXiEuW4czXts2lcfQLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729884670; c=relaxed/simple;
	bh=KQysnEv6g1gS7/kworEZ25XEvZG/o7OWIHoED+hxqvI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WgvAlsA3/4U05CzVvGWTDUGiD9dPR/QJdMphPmYbkB9/zdFMhjjCOvKfGVr8ezSY6OtlXfcccgzSp8ZaQDLbnITsZpfJH+l8l9+tv4AUY7gEXS0e9bngZE5ZPROLE57hoR1E8gBmUYva5NebjplPB+l9IBif6lzFHtlSPu+ffEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bi4ENJOb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=np573wN9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bi4ENJOb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="np573wN9"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0Xte032000;
	Fri, 25 Oct 2024 19:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=CYrGBo4GiuRA1GBU1j
	r3/TwVEYnY5wJKQ1VfkB1kStg=; b=bi4ENJObQxegbPAPO5U/aY9sagOOSTbXfQ
	oTLmkrOdbW+CEN0jEPyzF5+jL6SPbuYAEmTpSvL784QuHVIDuGaT5uXsQFHmIB9e
	GqODEkQ3a+rQ/mWlOCE9Yi6oTts41HRavFQdSpYdfu0htrbJao+x2TsdSyqXK+Qy
	xjw/0Ggzli2SlaETX5FsglkGtOyfI1novRfwVDdZWdKCcBn1UEaf9dpZXWoyVqex
	wjSSCI8NmgQCGaNbHzqqM6nsVJ3LCgmapDK4ggmVGv24TO3GNNzohLnEGnKCzWjI
	1HtOUrRjW8pj5M+kNMsKhRsTMqjuNn1f++MjVu7U1/1SrHV2nTAw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v5rv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:30:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHwsOV015738;
	Fri, 25 Oct 2024 19:30:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emhcpd2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:30:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1ZR4UBBiFgwaDQSw65f//pDzSnjW2L/e8HJnrwSrsjZhHGjDUL9uEmP6UeztaoEhpRZUWGaiR8bNeHHEWNiAE3kokPxcC2K0S5EqP1Yb3sGvFKUYvWSgGahYScX2hiG9V9aWZAPqS3quh0JXZdc6EAvewNnOaGgHzYKwGwQ72CCgEeXPpqGZEfL0MlvhgVMCdg+Pfi+abvXoUB6ch1kvbgQaSjJKvs7omD+Gh+Bjn0njy3DKMqpHitk1MwQ38w9m871i8ku2AEiP4Qy4fSnX5LxZ7eoThZxqE+rKFRwhbl8XPk8d5KieZL3Mg2zBPnk3t/6qS0NIWo582zVudiPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYrGBo4GiuRA1GBU1jr3/TwVEYnY5wJKQ1VfkB1kStg=;
 b=iXeuylSHs6lbqpBRd10sVquxOt1WuGxbWo+7kMgowCLsPDR/5fjPxF/5Dy0xVrk5uAdhgjwYbq+YkFcr1m8P+U90jtVqvzUaohwzat4tmqqHJ7bjRETQgE4plnqMIwYRS6E3GbidTTbA19tuo76aOPVE4BEi9ZTDGp6ZMtHwi3rrT9pxSQXJyBhnhfXSOd8QKXsfCtAuICrDaP79X7/1QaZzDC4xDvfEva3nSgAFruIexhVMu6gTOA8YIzBBRq91DyujU/dQbuVWGcVBXGTh8Fy2d+FElTjw9r/U34ui12VXH1eFPHAZPSR6ONl5nT5/UJjLuKPv720o4ozF+rMSIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYrGBo4GiuRA1GBU1jr3/TwVEYnY5wJKQ1VfkB1kStg=;
 b=np573wN9AepkiopHKh5bCSsiwCm4UCqBvWiQEh7bEqVnDU5JT33O8H5XvuMV7eeQB8bSl5th6Bka/c6hKzAOZMXyISsE16ChbICd6XqarDgRz+6WIWuAm1c2ZYfPYt8sImnkSjpP5mZAFekpwlJ/+8KN9zKE09W8FOQiFLRHuS8=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CH3PR10MB7563.namprd10.prod.outlook.com (2603:10b6:610:180::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 25 Oct
 2024 19:30:47 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 19:30:47 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Combine the two UFS driver scsi_add_host() calls
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 16 Oct 2024 13:11:56 -0700")
Organization: Oracle Corporation
Message-ID: <yq1bjz8dlpl.fsf@ca-mkp.ca.oracle.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
Date: Fri, 25 Oct 2024 15:30:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0304.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::21) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CH3PR10MB7563:EE_
X-MS-Office365-Filtering-Correlation-Id: e45e8800-285b-45a7-427a-08dcf52b86c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JebD2ifUfTndUQJ/ivhgPWAAwU4bg2lzE7l/M8XGk8UZNQBQd2PKKIjJusFR?=
 =?us-ascii?Q?iIeWScMijPVjDzrxZwMKNtkNuDO9KnofjQjrYGBaHjMhCO+PrENk87/iNpd1?=
 =?us-ascii?Q?1k+i+aR6ahF5P+wnt/Efxe9/3MuACmOJ0OhYp99WU2L+CkF0LsHR37lDEkKQ?=
 =?us-ascii?Q?Q9PB9eyo5QDB7J2jlkdz/HLvXXvpkJxADuSyOTLDwa4i+aFQvrHdmz6Gfv9U?=
 =?us-ascii?Q?SzpsPBe2NrsiWwlB6/iCzNzmM6wZKTpn9PEECZQMqAkBcDG/XNo0iSsN0k1R?=
 =?us-ascii?Q?tM8JyU4hlC289XhLNVd4mIgoLp2Fbo3hLzKcvMw0ovzSjushIQz6La2fH8rd?=
 =?us-ascii?Q?t96cRSVg1VR1RC8RMQfboSDfwrcD32+nNfOIqsqoNI1ulBilyrNspDMzr4GW?=
 =?us-ascii?Q?Lz5LK+FB3aY7rF9t9+cY7KA9bsDlj2vI84rfe1fGem2LpnNvENhdJUeGC4hF?=
 =?us-ascii?Q?9wXGuzh0RyYh5ZxTrgJb3O+Q5o2uACyAtS6vIDJI/ewN+XaxXps5FQfUoaQD?=
 =?us-ascii?Q?hNrRP/BXLZy8zE0HVHEs2OY/MAGLffAh+gbPtpz0NkoTeoZJGamgtZ/1E14T?=
 =?us-ascii?Q?vCfwKS/rN7GxZqrIJjvFTwdDIv0hB0zrLSJiKjwDlNUuXkc5CjPc68KvYYLI?=
 =?us-ascii?Q?E5kiz4NHeyOZdUjKiorLLdIU8pmnKkwup2wxB6AImoa7EK860Nh8hz6fcMT4?=
 =?us-ascii?Q?Jfnac1DNmMUCKDWPqUYHZ+wXgULLIpQHg+2ZLvphy6fMPZv5FyKE6h0xmCW+?=
 =?us-ascii?Q?8zfF3MUg78gjTY4lA4iFg/SGEtYmJsCRTVactdrjvQToacYqNO++VpeU3HXd?=
 =?us-ascii?Q?YRuP5O9BTUyjBXclN46/jWkxqYYAzqe+ASlUSSFewyvjcpTLRfcCwgV2LZHF?=
 =?us-ascii?Q?jJIaAmHLUDNfXsv4GKMqTXgy2L+J3g17I4XXRZYDtHHp9e+N5htzGEMuqWvz?=
 =?us-ascii?Q?iSEtlnIA163r6vtRP+2hAtSWDyOhGHpuaokMTgxJL94O8pQ3j6K/l5n8f8Z1?=
 =?us-ascii?Q?OCbT/CWsCqEAO+gss5eletq+bgFMiHjSGsIyfqH1OhexGBl2MkxEltCX4F4i?=
 =?us-ascii?Q?NqzQKP29hFZ7tJYH5N048swUhET/JH8q5MFE7IV+Qlyvz5HXE7oDRNra75wk?=
 =?us-ascii?Q?9Ikzee7HSGaUZg9pkwNm7mAB1JDxnCkgEGABOq9FiN2kat+yR98gLt186t9K?=
 =?us-ascii?Q?ymzYSuLbHekd+LrY82zQNfjodLv564se2fMkQgPvy6fHQu/kUWiaTa2OUtgE?=
 =?us-ascii?Q?30j1MxVexJNx3e+DTpiEM7xi9NuctIW65zDHjVkZWIoenT3kqEJyd7QsicPM?=
 =?us-ascii?Q?nozfbOp8mpICq77bNnQ66M0O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ti6uNQul1NwBnBWOKWph3+mT8BSbaJnG6WbyeqgfH/pw46krSqdYgPH6yiMP?=
 =?us-ascii?Q?VHyMu3JRkmcw8/vC93leZVKcXiBPedDKyi06NJlG6yxF4WHKF9N8FflBRIGu?=
 =?us-ascii?Q?6BZDiop2caEkBsBQQKmS6uI2JZkNHHThkgoYXBJrbsGPDiIXlX1TFYopOeby?=
 =?us-ascii?Q?u6oOzjAvv+dX6tF0togGFZdej5UeYXIOF5Z2pqYFbgKk25qpbEx4oxD1nEVK?=
 =?us-ascii?Q?AM0wXSBk57u4asy0rr08ZrPkIUKHPKofr8jsQlfI00PkorG0fN8D3rMX7I5J?=
 =?us-ascii?Q?u7DWgjAqOE0slLHkqIBqJelHfFz65qwh0KRNbHDc4cCrtB51QcjKuQiAx0Hm?=
 =?us-ascii?Q?qq39Z5xTTn8LczRt0Dpfwp/4c3Rtev5pgsWHF9Dr7bnzijVbSxxzUcwimc0r?=
 =?us-ascii?Q?PLrzAHoo9S9EhynLfO2b/yk1rAxoiK0IGmjmDnY/4B8nAxoZAMIo0ys519gh?=
 =?us-ascii?Q?WVnFCf8n/UajQKtJpB0mnsqKrex71KfeVLMsrcZj0DhURnERK7tJhya2ZjnM?=
 =?us-ascii?Q?x5OEwsZoYyBvDAJ9o8mZhl/wpywCWL7LsJZ0dCROi4LiBwQ5xGUikSziZBMi?=
 =?us-ascii?Q?gehiABsUmaT5UW0HBMQtq7FDQYzlvTeNAoIRaMGToeXx961/8pI3sGBA6Ay7?=
 =?us-ascii?Q?+ZBxq3afWlmu0OjLGY0u30UlRi5kl2Qv/n0Royb8NN6Ejijq2L+jevDpjg9t?=
 =?us-ascii?Q?C1FcSmWbP2d/997AvXkzpEQJRu28WhNT+greokkig17TG4HYzlIxuLUNXEXT?=
 =?us-ascii?Q?Qrs7Usyzxp/tm8c8nClgMwR4poisvEyw1W0BgDAT8DebdLEmf9bzdyY1NaN2?=
 =?us-ascii?Q?Y5ev4no9EDm720Foc5hchyRhRGWTVPC1Zi0v9OC7ty/OsMTbWlYk3qDAvEPD?=
 =?us-ascii?Q?PONH8530GDFp2lZU0OQghW7L91iTxeToLfWagA9HcIo4qgWni7vlLbFOIEZv?=
 =?us-ascii?Q?FVA7nwyxCfZAg0YqE0ev01YPp3PjRJKYK4vhswXRORhGFAcnaQwx/EjxOWxh?=
 =?us-ascii?Q?OrGal1s8qwHpwSyns4+iY5dckTK4CiwGghLMaFJQqaoVUpRH+9d/2RL49vU1?=
 =?us-ascii?Q?3rw15KMVLLYMHaus+2AROFA+m8tqofah2fhXJTHEbOHrplC8ctTzyrXGpPbs?=
 =?us-ascii?Q?92ubv4fyn7Fdbea0cm2Ap/cHTH6NIxxtjF5Fg730SKd7DgR8dGlgo//WRf4q?=
 =?us-ascii?Q?coaFiiVQWGBptcgDI40eBWxnn/KE1QehjRKBvwdtGhs/3NAuaLyhc4/E12qn?=
 =?us-ascii?Q?XfPlOe2cSr5WsXJ3DFOsF5hbLViuo6bzX6Idfb2z8fSN9wqGNeoiR68KSzX2?=
 =?us-ascii?Q?tMQn8KKN+hSSvE5pxQnnd+wrdZscbglA08+apEs5NwzfrGqxOsk26iYZTh6n?=
 =?us-ascii?Q?pzaASBpT599MtAUiC43pdYzNsO3HEAlDhZnhHskoy14CWTRoS1gC1B1rsI8u?=
 =?us-ascii?Q?jaoMojAZb/oX8AczXleACqXKjs6J86BUDc4UgWx4lIOx59wVnlfXb4r/MxOr?=
 =?us-ascii?Q?VJatzQp1smAjXOWbVoalIQ/TTzylIlZVjy+lkOqCvAGlWBrAFW1ykQPqzdGI?=
 =?us-ascii?Q?5oshuPWrqHYXcrqag+YmQFrThqbAzgg8K5wNJy2TIaXtF88uIa6YgPAktIXa?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/xCvrZB6EDzatQXq9pngKm0DwmihXdFFDvCcPOTmWnSBazKzRgEKHdV5tsYczZjCHcpsnGwNFmgZvAmXmcvEAFdeMzT9wRpKZ1uZ/dWlleThkHkmHPOqSWQmmB8oLig/S65j4Tl5m1ELUKaO2epbOVYIg451J7qXEjkm98p5WVL1TYXUoHVFVRWghnBt1TS7PtyDSi3xh9WnJrrgAvms88ecs0a3oA5JF+9udF/TmJ4dH8xP8ecZrOcvE6M0kQcfdlmvmaVQIEAk1WySxeMtaoSeXXILefhtWEicqrFHIidrcaiUma5QFrr4rlI420jPFyWbx4hU1UO08IKvrzkFC6a7Cfl9A295OS1EPHH3qEIgnYEU69Oz2s3tuKJSVdiqt+8bwFWAcTzdI70UV4HZRvPXr8iAw+11DEOkoTcdIBgwDBYjsNAJl8zjo51YANL2N3t2+rAcE3D341cLHgJ4kykK4K6RmNEWLOBbW2cfg7qq5J35J39W8NEI7f7mkoiWp3gxG2LquJptCKMIwb+Cxd7Czqa1+I5QJtXtcZje8ONbuYweCUDBXHQ9323kUzfPxgB2Bznz+da5xdZFz9YEakNo9XIRcDSvj5f4gTvZWhg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45e8800-285b-45a7-427a-08dcf52b86c8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 19:30:47.5066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plaw/n+UuQimG05wVLLp9myJ4eP4VljYtvn4EOg8phujSNLB3GGIyq0krlUy3Cys6GVJJwScQqZgD4yJLL7HEBzOefqyGhwikEV4DZJMBTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=869 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250149
X-Proofpoint-GUID: zrr0HMUJ2dpMZ34_VikucLxOYgJMOO41
X-Proofpoint-ORIG-GUID: zrr0HMUJ2dpMZ34_VikucLxOYgJMOO41


Bart,

> In the UFS driver the legacy and MCQ scsi_add_host() calls occur in
> different functions. This patch series reduces the number of
> scsi_add_host() calls from two to one and hence makes the UFS driver
> easier to maintain.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
