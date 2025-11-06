Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADF41FF7D7
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762453435; cv=fail; b=ru7g74cJ9nNA8GyM5ksuYbXlKqW1LR4A6jz28y3d9luOVBkpQNs2fDekGSLyxZFec02PXolWuSXFRZ1envE/iJ6uLAuOmwJLBtbaDluh8xFWQiCdaLteun5c1xFqg5e/dRP98CMGRSnlWHBdF+EKAg/O+V0XUJLxOLNjY2s0YHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762453435; c=relaxed/simple;
	bh=XVX4wMxwzwfi+psJGK1aG/8YmP0Rsm+8nhPAlSRpVJs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ddnYMqGakA3Vld6/lpjPzq+lTRKiNXjwrqfZRcmhJpvvdcHSyo8Ad8hgVU96Twf6Zn+isE10AO8p/tySfqJdYBH3MsTL+sYDioaniGrjhcWePkiCfr44u658eQA3mxOQltxyiw+XrszqE331uJMrR7Eac7ERBUXuQwEEfEWTLQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gy27meiV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LqxuWMRn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gy27meiV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LqxuWMRn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6H0W9I031262;
	Thu, 6 Nov 2025 18:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LGHAhCWlt8rtT/wr5v
	7UGiD3aQ3t4xiwbgj/d1QeM6U=; b=Gy27meiV3edlKrxUlMs44mLh74GGg4A/ze
	g7v9sZxsCShMvIT9aQw29frfbAP18gJ7uy+0Rn8lKjVsE3JvH+gqa0mXo1Q3F4IR
	Y5CP/UcGAA3uv2QfMrgQsIy1IxxZOpasQZ+4lWtdNd8GvSUSopA0gtI3R0hukinj
	Uy4E+RFV5WsHU3e464WVk8FaRKS/vLqlVABTMsHf0q+X/fr3lEcsCJJfNGl1lQKq
	Wz2JfweGBVs1Lx+bVCqkr7Y1uZaS9+D5M+xyKVzCYOdNN3Kxonqwow4bJlAsAtv6
	EtKlqc11fWBIlzMILGXefFlaA2E1uan44mcygUJDiGjhvZsUy1xw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yprg6wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:23:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HnH8N010770;
	Thu, 6 Nov 2025 18:23:47 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncs77x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/6pYykQjfgQglP1CzMU3w9UE3ZoGlkyXSoTOyPrS6OEpMNoeZO2THaShI0bEioo/svCabCHGqq7WlQTmQP8jWypBhK7+qZSY6gwy8yFDRTfjvQ4unHXXYubb5pP62Olw0GOIWzhvIP1PsRC3iHGd6KaymH0dLTDCIJmWVdmWIfB/hMfOA3rVz7B0Jeng8DKLX4FYQNLxNpz+2EoY9vd8jYOtGflSZtPeRPr/efpTt/99tnE4kSYC2/fEAWBlIYxgkUWFhtSx57RrIqZe/sAU4S1LcMud6yNIsKIg+E4CjODoVMNy7AE2YMrLV8Evl39mq7dnVDxVUunN8oeYcmglg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGHAhCWlt8rtT/wr5v7UGiD3aQ3t4xiwbgj/d1QeM6U=;
 b=XE7pT+uGtzvJW1gvxWmOHelbxC7J/166W1xwov/pqgagevidLmLl9CaJlCEbAMASFplGMjuHlnO4tt7Y9DA4qIDN4P6xOEG3sVZXDEDvgs9iNXG9r7MD/ZWg4lCny2hH59b9lnk18uNkIbixmRC8QfIlyrG1diHoOD8vHNeZg7ruE0ItdQegg0lZOoTAscGqZOC8OqhAz/NSSbwzjIW39/X2rbyrbIQ8thFe38sMD5gEByuDhKtXFNVDD1LP16RXSBjMckYwpX1dJ+x0lelZ1dEf9tor+ulB0TNo7ILFeHF+1BDVW73eAKN0EmHFGAknlNy5kXgLy8lN9joo0paJRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGHAhCWlt8rtT/wr5v7UGiD3aQ3t4xiwbgj/d1QeM6U=;
 b=LqxuWMRnNhHpKD9YnewqkHa3XbEmeNw3T1bp0wRUuMzp1WfvX7iins4AVGmn+rFcB53fzWXMawUHOTBa3aSrXLsdf8qyIdO8OxwXrOtNRJAiiQYhoKR67kcYHurgjR+vfEy52++NuBbchS63OLitcb/ePMuZwmD0FRf4djFVfCw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB8192.namprd10.prod.outlook.com (2603:10b6:208:4fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.10; Thu, 6 Nov
 2025 18:23:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 18:23:42 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v8 00/28] Optimize the hot path in the UFS driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <4bb9995f-0b53-4a17-af0e-bb9649e71029@acm.org> (Bart Van Assche's
	message of "Thu, 6 Nov 2025 09:00:54 -0800")
Organization: Oracle Corporation
Message-ID: <yq1346rm371.fsf@ca-mkp.ca.oracle.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
	<4bb9995f-0b53-4a17-af0e-bb9649e71029@acm.org>
Date: Thu, 06 Nov 2025 13:23:40 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d4b64e3-1823-47dc-1cac-08de1d619d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DYWYrDGL6LISWCPREe8yq328i+6y6dd1HOnM5+LDyYxBAoYICw0dDLfSSsjj?=
 =?us-ascii?Q?i3eAw11ZFTkGmh3XiEIUW2mDmyjVgpJIu5lvIMjuHGTgo4WzkzCPZRppdwWk?=
 =?us-ascii?Q?+EJxTn8vxMQAl45H/lAvv1cjDoJw2TCoYFWHIrnCRYPnpU3axg0glEQFarG8?=
 =?us-ascii?Q?2yff7OVEqAUqJTt8d/zkYrj6jL4jvAApHdn1p3lOlo1FPrIIT/XR6ld2pbWh?=
 =?us-ascii?Q?DYTcnZGILNx18JrFbZGZghx8BOypY+B11hdRJvGa/dxmRuxty5IQpss7NVa6?=
 =?us-ascii?Q?mcxCzzixUD8ZBq4DITuPYzVZyHCBp2n3JI+6f6oD52KqNGEBfdhzjO32DZ2Z?=
 =?us-ascii?Q?D1VoOn830TxrDttu6OAUJbzqNrqjr7Z+gLLB+/SqGB+spDCkBKPVLQCHVPWn?=
 =?us-ascii?Q?isQzV8g6yzCEEN6qcMpYI7YIwLM5IakTzPLY58Z0idv3i1wIZhwLHhj76l+n?=
 =?us-ascii?Q?Ca8uo1rZ2aJ4+aWZZpu4sj/dTbwZZraLvzIe90oUKCGFNwSXtnznShzmO/xc?=
 =?us-ascii?Q?aSPOb3tCgJDyirzDCIyWfwtHlZ0f93I8ypZdPzoJpeSdR3aJpsfQqSjmc2+V?=
 =?us-ascii?Q?H4hfXC7f2XMfYOeXuqiIEn79/5fSfp/riqdADiWAHuooygqROhTShos8DlVk?=
 =?us-ascii?Q?OoggSJfpmy6HsC7ShJvOvFLxWQwxaInQYWyQ1Tmu5UkpkVlspq5cnPhhIYkj?=
 =?us-ascii?Q?u5C/PwTZC+gJ9GIKp3jJ+6/BlcUJmLn8DPFUn14E/lL9u5vGTcRtw5PdMK2D?=
 =?us-ascii?Q?ImaVmFwMRZAYe0eGgkE72LfU/2TjSdMWnHEWI1RHhHHcLIgrU0D+Tb5GMDda?=
 =?us-ascii?Q?HeQas4xA8l5GGg/IhSkPcbZ4Kxi4Zwq7h4LhwHT29j6KULTEi0qkBmstSNUP?=
 =?us-ascii?Q?2JZgQH8jW8seIVsdZ0AYySgHVhJ5ehGof2OKJLXAQ59GjtbJ8LEvm1eiW7xB?=
 =?us-ascii?Q?hx9WpVjIvoUGEvH3yzk54fOh2F3GNcAQVkZZVdtOcZ1zyKAoTZfs9WmgGSbf?=
 =?us-ascii?Q?MaELI8yBYzdvsTroDWm1iP1jEAl+t5PO2N9SMeVKT1RwOPWGPMsRA6hE48uq?=
 =?us-ascii?Q?plTaIfJ6DCIwfUpBdNaYv6T7d+h4KKwABEOOs1/0kNhgPV8nQATql60YPoOF?=
 =?us-ascii?Q?+pOordbE9X9QTbPIduSBfsMt0uRHcUvNVl9fDT4612ZHDeLa+KfSFQ4Ge/RN?=
 =?us-ascii?Q?t70HH385EMm06M7WafTL0BVpwV0bH008QBq9GhuIxtsq4m5o5oIUe4CBKzKP?=
 =?us-ascii?Q?ty5U6QahX0PvREoZ3qoB11B/SQFdy04mELwpLeFr7cg8UlElt3eM/9l51LD/?=
 =?us-ascii?Q?M+iVP3egF1lbD0eHAOXoFemgi/fZ2ZCwBSRr1yHmnika8mKnA8hoahgeUHo9?=
 =?us-ascii?Q?ydaMYwSAuFN6pS6VU6tDf/60yb78Q6s8rh5H+CYHcy8t1a6f7AAFTrpjvlEL?=
 =?us-ascii?Q?d33II9LFA3Cm/EnHisHnm9IbVdXX941H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jm9bMiNH7K+oIuTHC0d3POLySzlkKIfO47tBbi/1f+a3gmzf9ODA/ScDQR9h?=
 =?us-ascii?Q?icmWF7DFwG68l8XPjUm0kX0kGSt4aErYloLWFKnV4DsfvXUmgwhiJLky1jWw?=
 =?us-ascii?Q?k+L5wx7AqnAvJoDXQ9aBjYtP/t0DhHdVJqwhQ3rxO8/q28Tan4JuPUQEVTt/?=
 =?us-ascii?Q?TuRh2KRbtEwEA3UWps8bDBlhjyTm7jq/1WTc6nuA86/B+K8YSFPg90smmLcO?=
 =?us-ascii?Q?mT9exKPrlPmGbmWXVTPwzhtLtxrQD2LwHCqZthJkPg/bHaAzqw7wvoT+2Hai?=
 =?us-ascii?Q?urMlJ3ZCEyX/f+L0tBX5UWSAJi1JupOxYiHNSVV3tMUFEDwCDnmHjwMER450?=
 =?us-ascii?Q?zYLr6D3xVrN1GAP2+ry6bpgT4dQpyyXwLKUyFE4A16kFgdFWYZbwgpHTTAe5?=
 =?us-ascii?Q?u832HNOlONzYNeRjhk2/dEUPGgT0+nGPJLxOVgD+w3BCMBkhJOjdMl/5/ceQ?=
 =?us-ascii?Q?2nPPpMjOUFnxaMrE3MqWR5E+aCtMjse6CgNqpcAkBRHgk+sYDIw1H1QggCuu?=
 =?us-ascii?Q?39qiohp4z8h8h7UFkz6vASGVbofbAgRiD0VF2wP+nN/WEK/+2IogPmJRFye1?=
 =?us-ascii?Q?EdGeAlCDnHeuPOvtzSMhr/xeHLRnfIAoxp77lxNiBVp1uURrD7ee9+/JI9fG?=
 =?us-ascii?Q?uCrapu2YAhTRiKlml4uG+MwcqpvbvtZ75Ty8P1G6sZAJYO4U18mbOC7f5i0d?=
 =?us-ascii?Q?1e0wWtN/dghQtq3A+ZdWUy5bFCGWg9TJS0VUUtZgK2UlszvBz1J/26uPzKK/?=
 =?us-ascii?Q?rJiH9AlWiG1h9SgeA/v0HDIGU5rhkwq93057Io5SgObb/aZVDFVqADnMpalt?=
 =?us-ascii?Q?uAoZhdEc5qOrUYabAqfQ4n4V4nUtBeuf18wotNAM5+e0l7Mnh60x+nyGIXMR?=
 =?us-ascii?Q?42p7xSzElH1gW1IMiuMSK6J9hRcQ0J57CPMNLpbxbMMF4cRBLV3SLghAVuNi?=
 =?us-ascii?Q?MatEQ2eo0uWO7U5putkmxD4niIV+pXWDwAHo/qgtz4Dngd9cqeA0WJpCWKkk?=
 =?us-ascii?Q?13U+lv6va3MFPi3wS2jJOCId6s4A/p3plPWaJLx3EzYHbjS2D70oFqEgmeSq?=
 =?us-ascii?Q?y5ELYGykRgOBkEmtB2+qULrJRY5GOiSpSinzD1KCy0HiX0fvGdPWCgGBEV2n?=
 =?us-ascii?Q?CDdhBNh41WAao9ze1Tw6WR6hkzcPe8NmYz5OC133FJkLjGQD+cZuiaJXRngJ?=
 =?us-ascii?Q?rEV1Kuqmjjlkja6EIqHOIQGTxw85un35uPWBHHVbfWFXLLUtdQPmKh+Glnu7?=
 =?us-ascii?Q?HjouqBx+Om8SCRGH/Vy0fjwN8Mg8UJiDF5vtmwV+F9MN5+C5ztGGMEOpWzaT?=
 =?us-ascii?Q?f3YSklXjJVlz/VLdBsbhJx9ZRVAgFAxAwcteD0MtgAf/8yPT3mZEW+KcmRgm?=
 =?us-ascii?Q?wO6fvHoFY1EHFpfJN0OyLR+764pDgM33vbQGc/+rLIiVPERVEQK5JwKv2VwE?=
 =?us-ascii?Q?jrEtoli/IWi9Woj1JvjhLEdPU6BDDhyBJha3ZxvhicADe4gMc2JiytlHo9yy?=
 =?us-ascii?Q?nvjfulZmupca7dqhHty2NAfRWPA9m2xyp6LjLjDUPnUoGN4kRGkybJyQHoaq?=
 =?us-ascii?Q?+2EXjCI2ibeceRaOeZw2JuiI0vBJNgvqDZ7qMLJ67FFrIFe/PGYMicjDvS1m?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FCWssx60mDi2WiDddr4A24EEtlOPm2x7tVkrfxhomcYUK7jiHyjsuX5soQ5pED3nQp1NZcwpbvWl+bFTg+7q0x8wQEmRmdgBRwEoluc7sy6GJitOERfN1Rj+W35rXa5qNNp0I8DreCvoHN5Gxwqfco5ozw3hBzExa4dwBjtGvfdGMJ78TZ7leV4q4z2QYvoCTFi1DT05YGFy/kdSZ91TXSrMCBuyRihxTFrwWIrObLedNjZvcKZLLeba7pxEQdQgHCrHt3PV9jpcItgof9dFMAaNFTiMnYroUzwxr4UROdb2ZutWC5nLpVPKkFADPwzvWenczv/5qeht7YF61+PW7W8ShnGagvBrmALl8OzcVLGE/wu8MTE41sAP+kJrRobpgAOrXIaKP/6hM55puuNWSsXcH2rm2DA5fBFr7CiXIQhyQ0Ylv1zmNN9LY3SU/3YuGi0Lffnc8BicYDDU/OpRS0gALpYibxfG4UGawXrSy7n7v9Rmpb2H6sltWobLud9c7suzsjWWP4fN3v62ysZszxj0IXttvQ9cjjJk8144mdER/zzofh0OU3T3U+u1Czt2hVlF9cqPepbIm8qARSVk3YDdkWs7+dyhbSDSl/MNMAg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4b64e3-1823-47dc-1cac-08de1d619d9d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 18:23:42.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Jy0UmY7QtPh/Uk3Nilwq2sslMhhRNLVwFxgVj9fVPFQgPeE9rGnTPLy7fwBMkXfDly+cxTlOgMCBfZmH+0Leg51EDoS84sFRC3FgRx8qFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=502
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060148
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=690ce7b4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=LJCvBnimRNqJ-7R_qe0A:9
X-Proofpoint-ORIG-GUID: 6JJwQ6QOZLpqA20uTfdyJIVqrk8XWzYz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNCBTYWx0ZWRfX0n3T/b7GO5SR
 jZXLTAlHh0sGi+Pgcx/E397FLyUsiaIj3tbLlKDdS7YYWegx/Io8VpW5CfnmAVBrHmVP2OajeYX
 CQOtR9yxSNlDkfNH8lUh8ktHDBYzFW9E9nC7rnjBjpe5hHqQVlq9FcvKzjxXGLgcAwf4FRKqa/N
 2HKCF3IvcxYawDDhfNjSF6G+tGjQCxyWQUqckeuQgDwQm7Ve15I4xqSpIwsDIj8cwl6VkPB9+3Q
 UzgXmsyj7wtz82gDnitc7c7EfMB3m3PAEKAoVdjimdgZ08My+tZLVLfAOh40eFQNXmnZQOpS1/d
 ivNOgUf1g87nQjo4uEJb/z5KImIklS8/ScI02Lh876LNndE2s9g9J1ucqseE7l1NsQz6C16Qq4L
 AF9PM4nu9qz7+tn3QZETGPDIl6qgVA==
X-Proofpoint-GUID: 6JJwQ6QOZLpqA20uTfdyJIVqrk8XWzYz


Bart,

> Is there agreement that everyone who wanted to comment has had the
> chance to comment on this patch series and also that this patch series
> is ready to be merged?

This series is on my list of things to review this week.

-- 
Martin K. Petersen
