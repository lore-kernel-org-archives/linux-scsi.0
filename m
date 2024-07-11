Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89158DDDF
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 02:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720665986; cv=fail; b=s8nUyw7q4aEheJiODlKiVgEr6crEqeE0juK7kLXcoVmiXxFqv1YI47LUqs+b3YGGelleRHL38cWJtLycKe1m/9dOQm4zKG+K/8ICEEtSDOmVbF26Ek6sR4uR6D2yVJU7b8CmArkEARX4jleMsbAyOCXZkQWzeSihQ++bXoMVAnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720665986; c=relaxed/simple;
	bh=/bMae0VZbUfGDVSJa1HDRB7CzApRRAZmKGoz9KTwLzU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u62uRuusZBsZSgUlGYK+0zoEEIk3oZUse/ly+vtnAW5oBIrIKcoCfZgS0HcCtivy8UWA6DZPCaZb7N1wY+VorA+Gy876K9cgE73oXlGGMbOGMnJaE2bwADuMDSHGSBaXi9oDSnYv4uxx+TvHcu/O6iAqptcPnd2hyeRllmzwtJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Eg/h4V2Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YOX3D6jA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eg/h4V2Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YOX3D6jA"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AG4v6K006146;
	Thu, 11 Jul 2024 02:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=bXL0xjlsH1RoqO
	IgdGF9lv5CmlC50e1JG532ogiykfU=; b=Eg/h4V2ZwBoT3P6/cKp4trNhF6KIRt
	xqwLPKAPt/PB+gs9iUoMGhu54WJbUpJrSA4AVGnNh+1GElIT0qO+aEY6nwTC/i9e
	XYzxVNsOwymhzmCaiX5puY9Wk5N57gZojKG7QBXJVnGh5h9o34nC1FNI+idZitzf
	Bn724oVS6Hq5EGGdIvQSAXsO1cJfi+uCVsbsc6ZiQmu3C2iSR1Vpa9g/RtYeyqrI
	7HTslTRWDdskvZarW0Rh5N2SCmqCDkitagLHfY0Quk0waVdtJXycLkqqSoHjEJPF
	osMnXhSBFsG9WG2M7qXIfweh6ndMcCptZlGJCKa1X/BJ6djhXrlqoMzQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wknrmfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:46:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46B1OPsc029913;
	Thu, 11 Jul 2024 02:46:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvanamu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGXWidiSoG5hDkFdxUiY6DQAtaPVApATeJ4tcNQPebb38h7qLliIiuXC7xjKmlUuSobBF8GrThGru5oamkX/EHY0tLU2jcqghCWNXm59DADHqNW5s/kL4WCEIgsO35F7zXYF/UiTTGc200d94IKRcZd9sFTtj8ms23jWDEl6hmn55c/O3DLsYZEd8z1b8QAZahi8On3pBb5xtxlM8Yf16c96Xt55wtfCychETcIEdyt6C1KvncEmy46HTTKVnPnxlmpzXImjRDUhrEGsYCMReAtEvJw4jfDDhaqE+CXLhzGDvtVje0hiYu0sYKLuE+O9CXedR8l9FXrDd8TD6fQtZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXL0xjlsH1RoqOIgdGF9lv5CmlC50e1JG532ogiykfU=;
 b=OeZr+LJc4F4zfyaICYmOnT7dr9z1EZoPpYGcFBfZlnRPVFreK8vPFE45VagvbYtVwDYCXfnx/lJlocTPjes4/4ngxDdZN3UERb8yQc/QgurxmdiB4TalhEEcTLGcQ4eTG6okaOoLOixLKV7NNMdoV/goAFusRVw2bJyKDFoX08ANskrNuHQpOWEqIefhCmDIER0gupZGBU5X57GpWQQrBImbP8UkgKcQTa5INeQfb/JgLWCBJvELKJfOVNTwQbF7r33uzXsy4FRo7yaEhuz/W257pBIraAPe54m4HdwfdCWkt4zczujORhpAoAeTT9HgKelprjL6ks2TpC1Xnb0M5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXL0xjlsH1RoqOIgdGF9lv5CmlC50e1JG532ogiykfU=;
 b=YOX3D6jALQFYofyW6dw9VAi+8D1h0yUeGhyvwg1jL3h9ml2fyErBZN1QBs/Nfbg3TczqCu6EG9uchHV9+nRRkhM0NWyyAjzcOQdCc9URKpwRFjSj4L510XEE22XvlA/hD9lvF0p4gBm1pw2D107Wfu4C12+tsSohb/DJ2EheJok=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4983.namprd10.prod.outlook.com (2603:10b6:408:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 02:46:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 02:46:17 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <sdeodhar@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: Re: [PATCH v2 00/11] qla2xxx misc. bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com> (Nilesh Javali's
	message of "Wed, 10 Jul 2024 22:40:46 +0530")
Organization: Oracle Corporation
Message-ID: <yq1bk34odf4.fsf@ca-mkp.ca.oracle.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Date: Wed, 10 Jul 2024 22:46:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:208:237::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e5bb232-53de-47be-c459-08dca153a37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6yxqe0/yj2jSegeX3/fvNTv5DDK+RpxhQrk0oCdq9Rk5W2n8OaU9uYPykKSN?=
 =?us-ascii?Q?u6zJv3aeB2Lql5Bye7VMMWJca+Rp/s7YHPduQC1UuMGckTyhXeSIFgtt5UP2?=
 =?us-ascii?Q?+UuEIoQ0l8oB+lVdklSaz4/SNpmAU2dnrcVY0exxy5x7RHv2xclKwRRjTS45?=
 =?us-ascii?Q?kTpZJG3IhpqO1xjIZToCpqJQVC8vj8i2Nsoq3EuJDbQDnkJuUaA+7yQPHJY/?=
 =?us-ascii?Q?9LXcxwRZcM20FPtXSblwZiwXYXc5aBsIjn9haju0xmN9xCWG4AY5amwAH8kJ?=
 =?us-ascii?Q?jgfNX66R5NMXq+YQ+RfRDTU+PGq0MPp6vE7g9qxkJLkxEr8xZ9jCPtiUtruI?=
 =?us-ascii?Q?ZXx4gRa6ETT59BwdGrQ5ArkSd+wA7SOTlYBRIYX9nAvFphgVKBLNnHcHr/iK?=
 =?us-ascii?Q?j7cfpgQ8rF71Yb//FUTSjpciGr64Xob+bl7i0BnGncAF+Xs8ptvql7y5PaWF?=
 =?us-ascii?Q?mPLZ9YaDBDF4WD/5pc9YrRk4mhMnnZh/UYsC/fZ7hiSF9mM4uJEsfDOvR+YD?=
 =?us-ascii?Q?q5p2fRrwTJB9vvb0qDzBbGmHtDo5Je1twWxwwxkfQ0pENp85E1v1Y3xZuK5x?=
 =?us-ascii?Q?5VQi4hXIjc//wm0q4SZF6Q3R/EeM+K0XR8Iq4v17kOvfi95JoHu0OrntanLu?=
 =?us-ascii?Q?/xHAhhIp3swae3IonjFYWUoPKfTqac7qlJeTGVlyvkPz6shp7wAkFj6HOrzf?=
 =?us-ascii?Q?sMZBFmrRFJKrX5pnbmH4IfxFxhmbqVfFBrDNvj3D2KVcYSlB4sK+Ot90gU+7?=
 =?us-ascii?Q?1zNClJ52jdu1UUhaMUPoX86e3uTKvC87Kd10i9UqGtZ7qtbxOJTJ7WmKt9sM?=
 =?us-ascii?Q?OBNL82+6UguHCholoIPTR3aRdnuuvyO3xovDHOfUs3gX9EIKMstDtyk59O53?=
 =?us-ascii?Q?vtbsGuvMTVkkTQvnC1iR2h9/jtCIfZbPqMfbi/dIvoIHHy+55abk7a316k3y?=
 =?us-ascii?Q?CR98ubesUX2+LrAc1P/RvKUA3lzWCEL8f1Z2VrQvzCS6hPTif9s2SWvQ91v3?=
 =?us-ascii?Q?KDTT1vBmOwNls9ujlZrDMWx6+5+arO8KJJ1OY8mkpkosUkUdpPjr1s8XvYa1?=
 =?us-ascii?Q?fx02Y3miuIurJXl29SirLGV7S2sffSCMn7SMfAxR0eOLarfAdzC6LDsyShjl?=
 =?us-ascii?Q?tsnVfoMqIhKCZvwStKLwx0CMgnC5RdvX+5Ovhdb/UyL2YmIgQ5h99iqId740?=
 =?us-ascii?Q?kX3lMvK9bDy1tRloY2tMWx5QCPkD3LTwVuYypi7WD2AZyGD5xlm0SjDU1Y8o?=
 =?us-ascii?Q?Tq090DmtvF95FvwGvM60cHMEBgF6AZyc83N350l3xKO5TuG2WqQRMAY0esgf?=
 =?us-ascii?Q?8r/12nk3DtsyLp/0znvZCraUKKrv7VnXaxk1NgLal7dHgw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0dsQnEzyc9Sgz8dQv7syT/7hWkj+EBqW7h6tQo3AxKF3y3uDXjyXutgMLBj4?=
 =?us-ascii?Q?AsmPKCRuAfijXY7bb5uczv2Hp9d0a2g2pzhpjhmgSv2Z5ROivJdllMgngVsh?=
 =?us-ascii?Q?7i9KdjZcohyqH1+iKqQU6cmVi0fsKVDhDSOvdrNOYHCbp+k6wNzERquuMjIN?=
 =?us-ascii?Q?mShuKLDJ+KuI6CyxYhHa1N6SzOnjZ+VCiIvLXKFO6b7o+kjT1yjS/57PZCo/?=
 =?us-ascii?Q?PR3O8Np5HT85Zk+R3z5kgh8RXZjqvBNJ9hWYFbtvpSH31X0kaRpggniTrojX?=
 =?us-ascii?Q?4F4U7o/4fvRgxRZedqFKsY9HU0bUqXcbIOCS06Vz35ArVbARyMC0DpaHCfOn?=
 =?us-ascii?Q?LHL+DR0rXepFwmwC8Kog5Fuj5CQu2WBLdQ31vwzGo0coVStXq3LAlCU/niQh?=
 =?us-ascii?Q?scuL/9Jqz9tu6Mwal90ZmsvcFOH3j7xftf8WHZApQsAheIrSiMH0RFIjb/ZV?=
 =?us-ascii?Q?Zeb7WJbs8MgYNxgcuBE5ZxNkyhwFzgDRf9UP4kXLDADgGc2VOTw290y38EuW?=
 =?us-ascii?Q?EhJZOyYxmsTcbeiFiucecI9KCk2q8l6gMso0Prn+BhTbaB65VNWprBfwosqV?=
 =?us-ascii?Q?iQs6YQPQu6ojZ+hdMKP7dFMzBcLbJBFBo3UUcmpHL95Ol+Blw3NlD408jFly?=
 =?us-ascii?Q?0RklT3e5uwWwG8BfzAKgx3TJnyi9RVwViqquTMmovBb6Dxh7DJemGhkEXkuS?=
 =?us-ascii?Q?fV3vpJp9iAI8Ez8qbfLhf46ZjifvKP/alT4CG5aDdwo5LVF1DD43lrP+3vDg?=
 =?us-ascii?Q?sIrZJhwVV97k2Va2CRF1IuCTVp1wbmC+L/V/BYmi/+SW97H1KW5QuCNwz/T4?=
 =?us-ascii?Q?Vnc8hRul412Cb7DKi4XWnib3iibwKtcG/il7ypo+fkTCWPlEpZM/tZmI0MJx?=
 =?us-ascii?Q?3wqIyj8A67wfxyzBE+2bUcuvk3HNktXfY3+yQsCDMBgCLJ/2m5g6MaS2vli2?=
 =?us-ascii?Q?C5LMnKsOjWaCaj99s1cMcRH5HwLUaUbcfRhTS6xi11Wu8I4Bp2fUjJVxwmDn?=
 =?us-ascii?Q?2/JF26PkolacJ6cytEaIFJMHkFMhnm3U/l+xiD0Q/nHPnqdzp9XHjyjtZEe4?=
 =?us-ascii?Q?AyRmFOSUny4Df1xDOZlDAzhh6NyMYl/McEDwi69TxVEa9u9b1zjRTutnvUId?=
 =?us-ascii?Q?5AobonpcWLoiILr67RcoFW1QckWtaPEqTSsgL5PloXNyhDIoyZlzak8wIK7I?=
 =?us-ascii?Q?OZQBwaNdwFR2pghraaKWIQ4iwQrO65+bqX3M3Ee43sU3Y2FSa0pxs3W3Swcs?=
 =?us-ascii?Q?7SophsnYDrSBiCWEgYFUcgoqT5jYBc3HK93Jnzntc78u8LJINnj10i1m+zc+?=
 =?us-ascii?Q?0WX28xS6VLM3W1OTZutA3hrEkpsXZ4ex1BIZ8mJxEzdQaAqnMvLrvVsR+Kik?=
 =?us-ascii?Q?1E6m2nj9y28Tpp+qtnNO0/e7y8epk+e1Rss2AIv+rzgEKx9Ay8SlTaaOWT47?=
 =?us-ascii?Q?O/W8HDwr05n3y6IH6ZCJRgeNq7I1d3k608u/Xbttzo5QVpszwn8zFlWywJ4/?=
 =?us-ascii?Q?5TxEJqtMMDFYcn5FtA5wObxPCdzKFszlVYZeEOAEbso5FXpEzyyBSI9vHq+8?=
 =?us-ascii?Q?xs4PUxdLxcPyFJ56diBKljDaW4k6Q4j/BJNL3C4hQM23U4rpqSEJ7Hv+wws2?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UoNJhZekq8OvekhAKBf5ZQd06fgkiKR3lis30USyG5cSO/dB80GiJy2FVHdRZcC9esQvpSZ54VCHsDUfZ83my3El9iluf6ABqV8Uwr62RSflxw66OwkviBuAr1Rx5LEcL91NcdVdv4MjyLvfdZNH/c6Or/X0p91WjYQBWeTSJtSFTnaZiDg2vZGvY+lKzhq1sGIIa0Chx0eBRW6zjdfeKL3xoU3Dx7yDksOwlslBDni+rW9eAdJGacxz1PTBlcFtqCWe9+yXcnLVJmIHCZUhE6V2FaY4eg1+49dfcBD5KrC7g9+ZClYZuE1G64a9SCHPwTPMW2DuawIqWy0S2/Htlv0SZaOiIi/MrV9WaD2GL0F8XnclBZSqhLp8dO/3fB508HeCh0sJfED7ABRTu21H6V+/UaKWFOydfP56WFZfZ4BWAx2NY4up6McXX5lK9RoEZsXZBofYg5yneVcQynNnffmNfd3VhnyLGm9R3hKfVrp4fmvyl0MzoUoczdQHoX9yqtjhbrI6UESFzA8hmQWzNI8mRGvfwWkTBKFZKSjlX4XqRdsfsSsQlneENU2g75W3n7m0DmvVCb1CKhMNWHGeE4/cTbnX0wPCaenZpIJ4bSA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5bb232-53de-47be-c459-08dca153a37f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 02:46:17.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFdhG9lKZL13oaOnFDl8dRJk9QUuHqu83oWmV8+fRBRYl8RsvgzJL2dIMpwYrEs8rrlGH4cA9kmif9m2//csURZpd5KqBXOe6kPjtqykFd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=779 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110016
X-Proofpoint-GUID: iru4gEPoRVZo9N1ZoQYQFGNuw6-Nwysc
X-Proofpoint-ORIG-GUID: iru4gEPoRVZo9N1ZoQYQFGNuw6-Nwysc


Nilesh,

> Please apply the qla2xxx driver miscellaneous bug fixes to the scsi
> tree at your earliest convenience.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
