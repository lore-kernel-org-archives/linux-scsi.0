Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06BF19AD8B
	for <linux-scsi@vger.kernel.org>; Sat,  7 Mar 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772900646; cv=fail; b=vEe0eOEmg7RmjETb/EmP1ksJEONGYyDTS3bSqwRGDr8BSe5oi22oCDXmTx4zR5N/9pfOPxRLmGmvri2TiREOOH+4LFtWHHy9tPOgLMtX4WALa8W3cwVZbp0qnvIy6V8sty4WGIOcFkvAUe85wDzb41xQ4AzIzXGGUGQooT4laxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772900646; c=relaxed/simple;
	bh=I457dNzLACG/ZBMKbXXuTOKOgQY+gB6AehcStwsMaTE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HUuaAVGdSrAiq2hDyPRNISgWpLJmnPCvGPczxZK/XXaD811RMqMj0L278VYX+w5lI8GhkSWQu/rvfeftm94Sy+AyFNZRveVLxlT4wfrUFoDSDrOQ23u2i0laxs5EKcxQ0Q45GKyf5uf1NRW7IfRtURM5B7HyQilbudVTBz1tfFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cjAsQ6S+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mCGH4tPY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjAsQ6S+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mCGH4tPY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627GIHxs3644759;
	Sat, 7 Mar 2026 16:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AONqq+l9twJsuLwrGM
	AyrlzjwkL0n9pzhu6a34O7Fs4=; b=cjAsQ6S+44jMeMYEDFQ6fU9WHosBkeNzhE
	HdFQ2vqmlsRAT5BnlCRIXMMpeTpjZrOW4YjCWd2inJUa+PH8eFN7/uriTJNuJ4rW
	yuRlX993ikcRsvZZXG6vZ/Jm1fJmqnusOBRPqUjDn1FmrrEpZhLs/chmlFUhfhwR
	3bUSW13SgZDBS/8I+Q7B4rH/Al6fOgc6DTrAU2qsQKGZbSYYkjyJltR6bB6SO1Cb
	dmyhXx5demmXfaQQB4v5BhElRLTLgRDZKsyPBqhcBsL++5vdqeMrRSuXNlMDGDA1
	TkUExlBoGyiPI89PyA5PTTBMB23YBC5FyasASUyB7tei3JubpYfw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crqdw0021-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:24:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627ERkAB012926;
	Sat, 7 Mar 2026 16:24:01 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbqav4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:24:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NP1mreeMziY25P1fdfPwxWTAL/GDXzMZsI93YvxqRFjwkUB0/QNSmBe8vNlsDudUfaMTkhvYOxtKXGNQu3aMAFCFH8+gMuPXkBs5FWleKFnoGwQvyJ6PR4CWaL/IYXmHF93KTrIEi+UK15TDtbPwkpnK8/BIzy6aTUhwxohtxGyjaxVmgVmNFifadG23iVCLScpBNH96nFpTWZ1yOVI5WFYFcaZyKz02vBSion078pTS2teptWmXhZkK+uD1mxtvCaAdq2Jvf4jPQQb0ivqBBDyDjy4wLXcDkiNZZT0pVO0kCyBpyXqlK2wQJTIbKwzw3zVfE1EsTV2WK14T2muTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AONqq+l9twJsuLwrGMAyrlzjwkL0n9pzhu6a34O7Fs4=;
 b=nLbbnITdoi7LBvDVB+JSDI5IglGKVU4fNdNSaJw/GiKhVG817OBP1mL9hdcPAQc1NtT2gufZ0AnqRLGWg7xAFAUi1Kz/nCmIEyVFc6PsujZBecskqKANPkjmV3ZwDVspODuvoCxXMGFTDdIbI6hktMDOUGsbA1Azy82jDjldhyhgcNfx9FqQO8XgS/MrePKzzXTNvgmmLUDi7PVyE9x0MPNov85Rrqz9bq+OktYpiCaSp1puAGJIgOhRGxkN+6kCB+vsT0QLanVz6FIlQpKL74iYX9hwX3kDP8k4CdLaxS3WbIIt5G/FqwE89VAAMhi6XRSLth/SC365gdZ4uX2HDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AONqq+l9twJsuLwrGMAyrlzjwkL0n9pzhu6a34O7Fs4=;
 b=mCGH4tPYAGrpx9BIrig4g4DwfAvQMMBYs4UpQsrCe14qw+/2jVbp+wKyTjnCxZn5LeDCQebEhhI8sadCk5khTwnFn5ESUwRM/IWEWXRCTEwmbKbFGV3AxtLKfoY7/Xdnqv9WPb1EPEeN8GLf6RU0QHrTZoQNAzr5vDHc16H+N38=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Sat, 7 Mar
 2026 16:23:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 16:23:57 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: Re: [PATCH] qla2xxx: Add support to report MPI FW state
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260305093337.2007205-1-njavali@marvell.com> (Nilesh Javali's
	message of "Thu, 5 Mar 2026 15:03:37 +0530")
Organization: Oracle Corporation
Message-ID: <yq1a4wjwqul.fsf@ca-mkp.ca.oracle.com>
References: <20260305093337.2007205-1-njavali@marvell.com>
Date: Sat, 07 Mar 2026 11:23:55 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fbb8379-50a9-46da-a21e-08de7c65eef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	Vn/aHBBd2c+vbG+06Z0MV1LDhh2u9lpw2Z2aZ7Fj5AdgdmIVx5NvspR6bneskQVPAxu9fqRzlDICZjhIQELDyRMNu6Vt22KS+3mIVVvPGbGSN9ItqKvL9iCe+aocH9/9aCCJu2WaS3xoMcFqyehRrUsTaFvSCrPL3kaBV98UBLcvQ/RVRAtRNJb9pKqP5LGfj8oPgCrrns3pZPveSMCXuvQC9tjQWSLx/jBySyXnbsfMqponevNEOI6x+/SC+aa1LnXmQimCXINuFuMDMfnsxQA9+Bd+YHdHD2UTOpPznHIxuzvbMRgPTvoF8LJWhtGUWA9MZg8b6AwQj6yePZqOabM2oURqebrN4studwitoR1Wc4qVeKceOTnfvqF6iTGKOq6TL4UZzKXrX3Zyycde7yjoaznvEWt0mIsJObLhnqsEoFH6riL+aZbYeP2bcT90QbXXV8o5OGYcpurUVetQJbcgDOjWESIlM/jpirSTGbI0MJgQV/ZOU92i0H3r1OijZjlZoY83qjmWfNel1RABTg2GXe1deck1TW59H16CV4LxaWyJwu2/pTn2x1fvutLHzjRE2mUxboyl949LHPlQWgHWPqQXeBVnFTO8QlklWjlHz0nxsFilT2f9c81a1JL8v2ewOsiTJq/eqTLbtfEzuMrYHP9+Srn4okFQezEOv4jKtjHxPToXA8m/bbb5+rGuBozrBK2MG79mWee4+gtEJnPuE1v06BNs16KjyvWn+HE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7zUJ0GcXmUlhVY7nvq9ydf77pDvy1T96VbAqGI2KNZ2XMS8vw7VjP/wRhmoC?=
 =?us-ascii?Q?gvC1ppOM6mYFwdBzVnSPHgjqTlnvbNmg5Z+b8Xbg5hU7DV6bcXVTszMEBAM7?=
 =?us-ascii?Q?WkVP/llTnSWP1RvB0PgVw4HA4Uk4m08pm8Q6RuBWKtFB4b1kelBv7doxzZzU?=
 =?us-ascii?Q?49ZX1XUNj39sG/R1K46I/KgFJVRSUJshNB1hElx3j4FdQIKRhN7vV9q12Mop?=
 =?us-ascii?Q?jJXTVywKCG+NoeJ4YLzlOCE+ovc6vKhwU96CfCoHkdGDK7Ya6CRtwTuz3/kr?=
 =?us-ascii?Q?iJf3simIkAORUA8YKn7AbX5mXuP6w/vZO8XK1D4CTueawPOXL6E0ayhQ7E6K?=
 =?us-ascii?Q?TNsqHyTiQqHcw3+TD/NsXsqpy5xPgg16m1LNbE5uWuRVJXgTLPHtR91Powxf?=
 =?us-ascii?Q?KROY43Zsiuii5iS77wybsZGTdIH/dZfXdV6UFsWnjqJ9gGmsl2GXwOT1mLfX?=
 =?us-ascii?Q?OkFPqfjqDWEPvIcgzf26U1KhaIzeCITVIXQjb6tuGv8ImhY0JIXT0hTvHKhY?=
 =?us-ascii?Q?Wo0L1wTmBoTlHAym6H2z7WxhhSaUZVHbufGDUR9FF13z6N9g8zOtsZ7Z7c0T?=
 =?us-ascii?Q?+cqe3hmYuUbzzdAFpSSTm5+lpGXAhWLQg2r542deeI8EJSVCjj8QobhaTUvh?=
 =?us-ascii?Q?jO2o4XG5fy0XtnGh1PkAfUBoWrXP4qmoHWApsiIk1Ph7bYKKdQsGTBhXi4r5?=
 =?us-ascii?Q?7+RwiZSLHjoy/elyNElfPD4UfZ03NPozkQN5/FPYxHfQYldtkuSdpqro+EPp?=
 =?us-ascii?Q?sj5jKLXIpAMFNy044pAITjtkbHBAa96E/yxxcWyAyRYnPqa/byE63yFWj+Xn?=
 =?us-ascii?Q?O8289WJUhEkDmKEvYPNzpDAWCYNt7AJKdMk9R1Vg6fpdOsAGuK+vafsm8HMg?=
 =?us-ascii?Q?cc37VIKaAfQfebqrbwzElnY40HVsXSVJFb/Rv8laJ+SMYNndEcstpMZZtp82?=
 =?us-ascii?Q?YJ3W8gZ0Wpy+cwobMSkM++FZDN/wITyIUL3BBJm/JFR8dRworsd4pKmZjlVI?=
 =?us-ascii?Q?yV19kGoR18FLhZPiAHUo7+isR5EGeb8qPiS21xtp/8g5cDHJ3DDrvKoEFRI0?=
 =?us-ascii?Q?3tb99vgIVAg1WolKvXnkOGF+KFhNR54e6fVGSbA8qejo3KhHjxrgqldgAcZd?=
 =?us-ascii?Q?WzKoYqlNkI1l7JcmTQksT2nAhwbTLZ4spp+auPXpySMWPMkjH9BhBuaUB5ZY?=
 =?us-ascii?Q?ERVbL+clCWftF7jhhSsZawyHGZU4AN3dOU7wkXXq46D8nyUPB5KFrJpagPOV?=
 =?us-ascii?Q?WjLvrkBmXZvsx/DaSHps776HjVu0hA1o8tsFCBwVGjQ8gU0uOPlkIQR/FE3C?=
 =?us-ascii?Q?ynYedWJRiqXJlgB/0oz1Og97frKC2+RPMGkNCKavIZMNF1m/N0sEbnQQvLIo?=
 =?us-ascii?Q?A4DysWcgahkqGfR3NvNi7PcJ/rPJbjkT3JbVoUH+GBeEgTALr712D3W4wxm8?=
 =?us-ascii?Q?zoNNq36cdaDEXzseLLs7IRI2jRGwzjQkM69Be6XSYB/rHqj3XoGjWndtyN6t?=
 =?us-ascii?Q?fowplG03bJl19TF0kpGO/niZdnHtdxV++Wz1+c1ZyfcDdBhk27pxoojvYTQU?=
 =?us-ascii?Q?wgnXvGsiGnRl0ebPmpOn2shmfdkF7+FzFNkzO5l1nEf5CFqjNkKMqmZ9fqzu?=
 =?us-ascii?Q?R8T5YINl38EGbzb6qjUDLw+mV3CjHEYxEMy5KLRsGYql+7zGl/WQSWWFqlO6?=
 =?us-ascii?Q?7q6ihcz9OvUWZHyF6q3/F/h9XEOXMw1gPU+0gAwU88ZITHr2gWl4xWh/oiQt?=
 =?us-ascii?Q?lsbLZ/bxDBRuXMuVlG647JUaJvKC3mM=3D?=
X-Exchange-RoutingPolicyChecked:
	o56HyafT16y9TrRaGjR8FG2bgGAhQoAqMZh91nu6m2DpUL2RALXrJK5Ews+e6m9OwOsuPzMMCRO+SpQjzjNcMbMsEnklXY/uEJC7lJN2FtTs06f2j0JLUhI0GsF3F4JII8z4nBA6kEOHhzL0/A4LsO2aoIHFvAfwtF3MkZP6m+lxhg41MMfui+SDUOGMlUZX67mOS0+1M0meMWvCo/IMo6sMjI1Pcczl5vu5NBX4a0c1xXJCn5POScMsHCal4nXuAv5Q1AiOn15oPpTwRCCgRZMxUaYOPDmIg1PUcDzEYmYCtsffONAV3DtA/r+yumcXMfBLq8Chzv6fo0nnTh73Vw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rxWPo0neegFx7KVfHuOrZFY89H4Crp4c+A6JCoxRopiC225NU/8NlB7GgIBti1pz/li90X+IPDn6Zz53r+5RLxBGkKKs57uI17HYatE1HK9ZXcRfn9u6UqbCnG/OBObuqntfpLClDiJeQBpnl9mw5rIYvIO6RiSbf1Bj+HpBgfIfOYvWXzwPXNumIJBt86bNgyFm17/VDfZccdAFI9FhW1mo4b/78yJECCqsmi8BdJt8cbMdRH9R0IYainUyOIhimpz41AhxoQoyv3bITJdZZLema0feObMfKTu63wtMYqUbTrHDdMJ7rjYBofY2b/9qY3CkcojsipLtvCyaGdJb9XRvHXm6S3/FiPkcIyPRyBINj9xkZ8ehPknHCV+9IKuBg3lSP8gURySiPkHSz+roR8s9hjmInge7H5WOBJgOCZEXynb0sIUvyHT9hmqpgKN63M85h+GaFqXmdzC/rCNSII/FhSG/fmYGYRYZ39zRb2Mi6rBJK6y2C6URXE2fajaMbZrL8USdtbeZXxkJ5mK+WkwB7MOoJRbD8HQ69gIR+3omQw0YFha0UMUH++3+tGsQa0l5GfCu/VZBgS/M7TM6oWoc0urop0l/uuBjD2o5l64=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fbb8379-50a9-46da-a21e-08de7c65eef8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 16:23:57.7190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdD4e6j9FJx/tPU8DIkGxd/YIqmBkNVT2+Z5Wr1q/lBhCiuaPBqORmWri0SaSohbBBcY7FU/r4Hsef9b4XeSK/2DkgNmZRZB+axupsXYEIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=695 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1NCBTYWx0ZWRfXxtIIqUrPHnSI
 eZo68RwSarQ+ixTwlYp3YVsE18Xbkr933SO5VtZBJP7mxg/X9D5UxMmKhAxC9/USAmv+3HxBAcZ
 lX2H8MLexYDTciv62O3QAXyhfHqIA9gKkBNnugs8au945mTdaFmIjptc+q8lruoch9WYaxC/ndX
 BOAEQV2WFh6hef3N0lIk5VmMEzImVgFVJCGNzoV3r/m9MXJDnwr5ixUsPAQeNVIA65lHkI0DsCx
 URz7RoYeFFLRKyKjPdI0x8E3Aokhs9xRLTL5hY81pbhcginwrtzB+hpUO9ACRvuWTC4ZbDR24mm
 hiGcpyyXw2/9j1KbYTK/yHCALd/5xuUqJXCKpqCrhd2V367Yn2PAbQ6/Ch/cApK1WUg/vCGL4h3
 1gzXjasN6q9kDWBDcYmGlQSZtZp579cAhumiVQMJwdJM8XI+5LRsTOztzCLtV/55ZRoMebz9L7P
 SytgggYnlGdQo8t5/3BoSEsiVSpj2SG8/XerA2w0=
X-Authority-Analysis: v=2.4 cv=ctqWUl4i c=1 sm=1 tr=0 ts=69ac5122 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=-MMmf-VsBYFSy3H-XEcA:9 cc=ntf awl=host:13812
X-Proofpoint-ORIG-GUID: WQ62YSqZc5w1M2TELZS9g8054QxtWV1U
X-Proofpoint-GUID: WQ62YSqZc5w1M2TELZS9g8054QxtWV1U


Nilesh,

> MPI firmware state was returned as 0. Get MPI FW state to proceed with
> flash image validation.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
