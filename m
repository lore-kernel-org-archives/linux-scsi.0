Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF5C28C2BD
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156149; cv=fail; b=HEGTvg+mCwQd80Is2LKv8hQt7GP/rFmbULbqqmVFxJkbZIOaHcPtah0QscJUF6eLM9KGX91E6sdosAQNpqucMtWpaxw74fcUo9SVGDgFUW4HARv/CjywN+ii9GNCjeYFwJQVAzXBIH9h+FzEUOPO8ZxwPrblhlaGlbkXQjYigWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156149; c=relaxed/simple;
	bh=fh6yVbwShe2N4J0QqZRcwLmEcAFza4KD+auj/fCBbO8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QHfQ1zSnq4ZoWEwd/fj0YG+viBdqcafubVdeR7+8r2Xa3bOvPVJBoiXTT1WsL3juB9PbHvTXf8GXgg3GIf4ioB6LtdNilc3JDoF041kW5hBBNQOwgjUsforaUeKD2LYZPRbCU0Kq1tLA201qaDhc9rb3lOGo/BR9Nf2w9r93eAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XPc2tptl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ngXOhi2f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XPc2tptl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ngXOhi2f"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BvxE030214;
	Tue, 22 Jul 2025 03:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6gfK+vGwTzpEBU9kuD
	SOSwDOA8QaMk+CRe4P+J1ZbWE=; b=XPc2tptlN6KH0ifi5y4nrQ7uZhNzkBXmt5
	PmBPlFWovP44qs1YWJdFXYO2ZWtNiRhtz07ryWCcrHwcQUMONFYJJwAV8cZ6OrZX
	0wWbjonkj8TnAca3DDDF87olSjLuUjAHLRrRZHsPIIlJaFbW+1uJVTFGxhRMgx2U
	kJPaaCEcEjXaj5sEQwBWOyRSE7NvZpX28B+suMn+/L+6G//Ekje3Ria2THUR9uVP
	/8vLWf9IPh7Z/K+UeH3GkR490UdW4N3RTOCQjjvdn5hPZfFGjwLy+UI2Ewm5M32b
	LMQAiDIOtFaQoi1ISBF06RiFta2EwJOR3JOmArH6U9nouFni7E9Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056ec9eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:48:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M13MkH011336;
	Tue, 22 Jul 2025 03:48:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2073.outbound.protection.outlook.com [40.107.96.73])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8sh4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:48:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UgmS9R93qiaPWgFlwvK2w+ayoiulFUaSxEegtoHGejsdh8+wR+8J7BwUNkNShEi10v57XkgJxNjWDnCJnDrgMfMdA3BB6wZ/HNV7mwlHgEMuiTqkL/u5tHKyFIJnBcAhsMVTptT3ex55axZYRst18D4h6SnnBRHuVyt0ozfrldYeqyJMXLsZwXoXoufIQ0X1wZY26pSfms1munCtg7x4ANnqLXU1BU0hfVIVX5QRYeNNe1De3E0AgBV9zcEBfjJiqUGkcjUIPhOMdzIo3f7cl7vDiQVh5qRXL+jcCU7UFKL7Ww7D3veUgIiNy9w43AYjtpn3w+svNbS9Ww4Hi2uF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gfK+vGwTzpEBU9kuDSOSwDOA8QaMk+CRe4P+J1ZbWE=;
 b=TiAaYnLEo0DFtRu6h6y6vO1gLVqjOXBHF3u+XIC8BTI1MZoFGkxm6v3f1CZW1KIsMygYP7zRGw7otyvDNbQEHdsDIq8tVTSwf257SReHJ8pGAF+eS7b9w7YzmdRwvdiNHpI1mOfTAg/pq++mwAOLPgO6vatIBsoE2APEBtJcv3ypnzMLoJmVcQtUoxt/ci4JWXn6MaL8uTBVyvdbQS9pFBY0yxUe0VDXQl1/BWrKll/HBPdKeFQEpk885eqNL/gU7yoLMpi9Ww7Ss+f+ZFMqHwFsgW2EaZUjCyaPKZU5KPy0ukP7bl6Y3aIylWHOJWURkcC7HsJnlJfZOge8kwHQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gfK+vGwTzpEBU9kuDSOSwDOA8QaMk+CRe4P+J1ZbWE=;
 b=ngXOhi2f5/4j1eOn1ONw9AibO3GHdJL9hVtkJjYjeqhVj+IeQ5BlNiWEab+kESwJBr2xUTUh7tSfalsHOnmcKDeMiMcXbIMetkSBcMZdysf4G3GyoKY1MbQJXJ3c81yW6tcNNmS+IKX3AeOLa3I5vNA8c4PwfUAA8iwaZxg0590=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB5676.namprd10.prod.outlook.com (2603:10b6:510:130::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 22 Jul
 2025 03:48:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8943.028; Tue, 22 Jul 2025
 03:48:55 +0000
To: Showrya M N <showrya@chelsio.com>
Cc: <lduncan@suse.com>, <michael.christie@oracle.com>,
        <martin.petersen@oracle.com>, <cleech@redhat.com>,
        <linux-scsi@vger.kernel.org>, <bharat@chelsio.com>
Subject: Re: [PATCH for-rc] scsi: libiscsi: initialize iscsi_conn->dd_data
 only if memory is allocated
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627112329.19763-1-showrya@chelsio.com> (Showrya M. N.'s
	message of "Fri, 27 Jun 2025 16:53:29 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ldogx4va.fsf@ca-mkp.ca.oracle.com>
References: <20250627112329.19763-1-showrya@chelsio.com>
Date: Mon, 21 Jul 2025 23:48:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:a03:338::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 607745aa-ab0b-4b61-6d59-08ddc8d2aeb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VuTAT1lh2TTO2AFsik1fwA4WH0PoHcCmLSc0/9VS8RD7L6+bONKZsVjYDLLN?=
 =?us-ascii?Q?ZNzFC/9ervsJUZvrK7INvlQ1HTwK/EJSoqD5IekpxuEnj9218EpU2K6LeHjW?=
 =?us-ascii?Q?oUY8q8M+YuUVShPDYskN31EZ894OCDHFT1C8fj86mVwKbGT6cGEoqRzdi3St?=
 =?us-ascii?Q?MvHMI/+AQhFFjcXNnmuvdBHRr4RlPBDvH+coqMr53xU7s7/gss/3GIvhFfix?=
 =?us-ascii?Q?GQWeWdGIlxcLrVBZ6FrMnNSh2+xU5LBlg1xv/FDX5YRr7jp1HL2whtgN4p3u?=
 =?us-ascii?Q?vyRLXJYZ9bbafWtBLonwJo8pCaHuOLxXnP/mrXCJFrTEXaZcQUKMLOobKnhN?=
 =?us-ascii?Q?NkylXDRp7x7NblYzH0qOETYE1HWos2yzD+PwiQLlv48D0CTmGRU6h99ZHgzg?=
 =?us-ascii?Q?iVAW9TH/TPp/nguPRfxfBoxNTQBdCiS67gG10NUiF0lSTfoov1aOHYVBot14?=
 =?us-ascii?Q?jjYEgAkvE/nyuaEJPjRb2lOTwLno3SDS2Q3pcxYsjiWkXFkypHY2dcKWbn9l?=
 =?us-ascii?Q?cn1tvNMPIbMiPaj6q9Qv3nKxbdpVJFueuZPfGRMoIgUlGW48mUvzz07s8ehf?=
 =?us-ascii?Q?Y9GvRcOzvK1/kYq73JcuJf2eLpZ/SUXGyIYZ2x7ubL0Bd9Ku8QN6jH/Lfc9j?=
 =?us-ascii?Q?A7gpkDNc7t/VDuJ6u0+R41jOqCqmto1xN5NSjANK3JPFfc1csDMFNw+ZJHWg?=
 =?us-ascii?Q?YYraL9hcoefW8YjNEkImSbfU+7q6HBSf659sDrbX2yIXgL4x5oqrp2e9wc8R?=
 =?us-ascii?Q?kgNOFxs80R2h4zBAs7wGaGPmiEDxkjsBilGcq4LJr3+i+ke26oadw0ofeoJY?=
 =?us-ascii?Q?teITlIv8PwjCC6GizpKhPzui7byZkR3s4zpK505CRsgT0QcLBNKPwDkfkceW?=
 =?us-ascii?Q?RoGgzwmmMkjCRSuCsS+kNPXq/q++btiJd2+hX7ucN+29y8l1Absg62ng+yPb?=
 =?us-ascii?Q?NhI9UADjwlH424LCqiVsIh9Ssj/h5sSMnqfxvFDRORIA++hJOPaZu8NrFFse?=
 =?us-ascii?Q?W62nVgo+rIt2rK5oiA/YR6kIGAOIZwiaZZPpjk2SONrlCzuIOrJxFXGhAUbW?=
 =?us-ascii?Q?Zqol1zNj00FD3LW/5IFsXn/XXlhPRXmOW1PQC5HBFPuTAWHAdIpw8EOT+6M+?=
 =?us-ascii?Q?jKZOGEDjGV4N6rlbPTG7d5ptr6cs2EyPaPkfct5G9zsVra0yExnwEibtEkQ/?=
 =?us-ascii?Q?xsJNINY2hnRXasUXs0m1XL9UpgzB2C6xEPDxu6JhPfAtb8GCSkJEixWZAGuh?=
 =?us-ascii?Q?qra+0izWml7PeUfqoRE/fHnkjwSznmYRoNm+RnXPBTPPHrEkeTUKFtVcgwgu?=
 =?us-ascii?Q?/v9YFxrgbuQ2/vjUCysVX1EmSVD3HepiUnCeUAunU/yUjEeDBTz2W/EjRldN?=
 =?us-ascii?Q?pmSv5Cmf7GppUenuyHziiMHKR+AsyjyfPumyefzox0AjQkqGc6bDdrLhVqzO?=
 =?us-ascii?Q?iNy43xz1TJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?liUSZZLmbSMXS+uHGziZo56QBZ/C1KjKr/QOZwlhLldYd/GPERQ73YnOySjQ?=
 =?us-ascii?Q?Xtv+xIB2S0+3iT6Dl3Yo/UgOf2UwSEC5GO+bBpbSNgfPAXUV/R6rULvOWIDC?=
 =?us-ascii?Q?lRcxhnLL2rMkf7eY6xnFKfZh/aUyiLwesqXgwzCIIZNn35hZONn9zNQO+91E?=
 =?us-ascii?Q?ctQE3t7HmiJgYbUCdVkE3B0PToXHDbhK3LpW5Hjz+Yp2x3+kWwhbJQSytpd8?=
 =?us-ascii?Q?/hgh5mhKhYYl+O00+I14Dj9o9HESzrpgT8nf1hETSV+sjku7Yw2uln9AAZJ3?=
 =?us-ascii?Q?HA3UGrdqUSYQBbYOatCJZge+Rhqi1ZB9t7nXrq7S5unZtjOVsZfgEvwsgOas?=
 =?us-ascii?Q?7HxwI3QVW6xt7GL5MjU2vON/2Df3SwFbNnmxBT+rI7fb4+1BMuFHxDggxscG?=
 =?us-ascii?Q?Nvclp9BeK64yUs6+X7iALogHVw1Wss6ISTG1vZoQQFR89ZqjT3CJGMn4XJQ6?=
 =?us-ascii?Q?k+UE3xynJzWN3+Z4iZyDUViUCu2zLQKtiV1WGSCDDrM6hbyu4s4GYFitD1of?=
 =?us-ascii?Q?Mlkn+9RbdFUsGAoRtcbolQkFsNkNDup/Bn99nXjESNYZEHrs3+gTX9WtAehU?=
 =?us-ascii?Q?afvb852Ot9H/t2XWgXDD6wmokHUElDrvq0MNIp8EI/0/jagrWdIyTV1yxTma?=
 =?us-ascii?Q?DEp45JRLfceEkuFuTeQhqWcHulG1fSdpjV1Kf8sw66XmIG22e+9OoML9RxGF?=
 =?us-ascii?Q?A2qB0l1EFECmEPOAMlX7R2Wic0qVwp0DmjQwe1zZ2XF8GMUbPIuUYpRYJ5iy?=
 =?us-ascii?Q?eXK2juhd4kM6bPq1Tkd0lvBq4ZGRSP5O0ZC8r1ozTkP+TxxwywCwmCXcI1LA?=
 =?us-ascii?Q?QmTTgRQjv/eDji+Y/Tqzgj078LFZvQBIZf7G/UB13LsbVi2+bsGK6PjZTcIx?=
 =?us-ascii?Q?oDj31Q5GlO+qHaIT6wmoE++n2iBJyO7iJmYhb+gqhpxvPpflmlL8R0p+NVab?=
 =?us-ascii?Q?pJjIWSsyy0Izb63d0vFQG1mCHliHncMw9NPst+FDPPns/g9z2DM5ufGqJmx2?=
 =?us-ascii?Q?z74+M1S9XDQ2qufy4vWq5UEODNApyniCJ+BjKf/81qUrFhX0u/RI+weo/nd7?=
 =?us-ascii?Q?GhhClWJLHymrhf4QdaKcGDpZVXiFyDF3l4yQBdgneKm+yn4+/8BGXcHraQiR?=
 =?us-ascii?Q?mYAaQ2aoWsQudYubhOxM1EYeKhPzsNlAGnkP4wUNrl+xC5QUnFvXNfikqOHw?=
 =?us-ascii?Q?U63IvUDp5JMwcb3JAa8/IRbACwwLpIQhRHDlkZveoDAWuDOc+kSCpNsn3gF4?=
 =?us-ascii?Q?KdxFJVS78pR1f65NgHcns6cb4IF2gWz0ggo587UrMbroZDUA/vX4W3x2cD8g?=
 =?us-ascii?Q?UG42x6Gj7FckTimlNZCK6lAT83Gfhl0GilXAnk0UC5gsb/3uIPw9XjMFONmC?=
 =?us-ascii?Q?9x18/ph6bGoNkIIfQNossLWARH9LoURi32R08oVePxa5YtUZ9mS+VuFrO+6y?=
 =?us-ascii?Q?i4S6csNGJOV0bPhbWl4Dc/kesZsgFHjt7Whzz0fSgB2+6X02rWwFrmAicCck?=
 =?us-ascii?Q?s0jJR4geP+UkSJuIieyDynHsIu1AcH/AgXiNlfhoHkxyWCuCzDOhp9dE5sLn?=
 =?us-ascii?Q?UdcK2K1ZsqZrjvlYJL+0Lp5DMrQOe29ijLEXPR5cPMTb2KA1eoSPWW5tjNnC?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9C6G6fdWObG5BlISQTv1ISKWz79+WJENvv8hmW9nwkzop6xYJ87jJpGaPxW7hquf1q5uMsuVBYaISaIOOIhVKdQFj8126yeu/M7KfExdAV4FeF+0YHH1SJ8x4p1dKwYQMrCjhHlUMvG0C79cnxomk61zLBDCWRU2vAYHf/1W9V9yf7CwaGUz2rdF9VoZoWtAj+xaz+Td4Frz7u9H/LFWrDODFVlh1hk3eMizhGELsFY8HcOo6gpXu4QhcSlRBCCwekEJaZqCIMKF49PcVbMRDUBwLgImfUz6ExYrz3A1XQDVL/ShodNGulxZ15PHh3wCVX2CGSdeMMYxTbxhj24nsgg/58Vgn9qoU1vwbqYQQOcpF58lz5e+dysxK18QyVzqJtWBwfA3wV1oar9GgpQi/1CkajZ5gvC2Rq66LB33bPVlX+igrH7+pr1Gttp1emZ+Tj9Nv/zICs5xwOnfsj4vp8CilsbXRXfs7JW4tFfFz6VgjivrJ/DMlRnohJip3/hn6vd7h1jcI0+7Hitb9tz//pNN8tb6zfEaYGV0cFIoa2TcR7GF5PvI4qJeMNz3huSjUJWuwyGE+M99+rh8rkkRWynZAZPz70x8GjWFldr4qKU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607745aa-ab0b-4b61-6d59-08ddc8d2aeb6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 03:48:55.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DC5pu6um5K3jMHaQVXQjCspNRpoYVhF5Tu506u+Ckoxt7n354Z++/g29aG8QwWcAyyYO0mLqzTI8XtbUZNZ7m4YV0S78R1nmkDIU2EV5VTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=747 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220028
X-Proofpoint-ORIG-GUID: ohEFik7J2jtdl04syDG0PoUMTgKVwPM7
X-Proofpoint-GUID: ohEFik7J2jtdl04syDG0PoUMTgKVwPM7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX6zJk3wBGVnTO
 XaorRxdrXDVErC5FpxFZTO+YzJvh+cK2aPIXo8PKUJTEfaMPMB8uklzHCweysZtst48LuBN6NzA
 uVfnC93wN6KEVop8hM3EcLgdWZ9XeugXSofXKdL/jX9XDYH0+ykwKIOBdVWi+T5AMjIQ4elJvid
 KbXbQ9tNnBooiedBy92pQrqpCghgeMEayRJtDJdVPQRu7P0G/mUe1iqagUTZc0SPV8v1TvxkJT4
 LK5KLkkQEGZCUuLSPom+ELdqg0LUtVaPsgzUXjWJgwAkKXhv3bVxwubW7kEJ6OfRB9J7ozQmJTp
 2YsLYDzLG0O4h04t1aBkh3fizOBnWniP6AOt1YW+LHnMM2ye0Rojb/friQO3GcvozA8CyKaVC51
 1NWQo19rzQ9Y1C3EvpA+Xx5RmzSuOcL+/U2iUSNgrMFQjSrINgGs+cYPAE7nSX6xAMEe8ide
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=687f0a2b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=HxzEu8wnMlhPzKx3g5IA:9


Showrya,

> In case of an ib_fast_reg_mr allocation failure during iSER setup, the
> machine hits a panic because iscsi_conn->dd_data is initialized
> unconditionally, even when no memory is allocated (dd_size == 0). This
> leads invalid pointer dereference during connection teardown.
>
> Fix by setting iscsi_conn->dd_data only if memory is actually
> allocated.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
