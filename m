Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713C32E1C4E
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 20:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780950338; cv=fail; b=r6XAQ1En2gxypN4N6eHhS87Rrdm3sFF3R/wCnpamTgugE/TtiXlJzPqqj+2Ytdfg0FHAe94YZvSTvTF1UcCP/1ODuwtmHN0Eb5TIDKxb0xHtDR6vJ88I6JBU11oAYlYj7O1TQaV8iiP176oxHPga8s7cpxSk77NjKxEugBRXgtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780950338; c=relaxed/simple;
	bh=so8fhq3ayLn9fqb9RUC7BSC5Cd7Yvng6QJkDrHP2zI0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=EQ4+WrTjirbMtBm6F7DEtLJ9dcvN+Ol+hsk8br6cro/KSdS4p1XJpQ9Uf0WtBZfUElDI5MbT2+hO1o+6i1HlMfP3vbeY3jAWirEqcEN9xVRmndhJo/lghR/XWIM08E/tC+hEayaE2f6CBzWJRHlK3TSSKTt9+e/1wFVIuRUAZTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ISFjw94d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=puqRTnAv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ISFjw94d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="puqRTnAv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSeJG3586894;
	Mon, 8 Jun 2026 20:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QrEH1tvx+Xvu9EMctk
	iELea3vKGD/kBOsGZMPn78iYo=; b=ISFjw94dJRsDJkTPMu/rXkMaEpsz7NdxQ6
	1lWrHr3QIBl97PABMQeK5HZurRoqwVk645HARW+8eDqxpAaM3Autw8EQKqCcKiDF
	zHkdOuoMnnRrOYbJYL2qE1NuDac2iuL63ZWq4fWE+zW5SSaAK9tYHv8eCUrYcf53
	rk+pHcE2fharIGKy3Aocs446k7g4nMntgj0702jQagffXuco5r3nGsYhZLBDh2Gu
	gthAdONplgNq8tL/oymg9y22EKJRt9BBUth1ByrnccCdUHLGdjXbEKVKB0hPb9ow
	PHJqBsiA92K3pX/4gyAT0Rcpa3iGR23fW5YTMV3/3YJihCzGOYXA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ema4y3624-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 20:25:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658KN7Wi037787;
	Mon, 8 Jun 2026 20:25:25 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010058.outbound.protection.outlook.com [52.101.85.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0e0fxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 20:25:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mrWjn7meD5stqjM66J/rZAW0+dkKIQkl696jpxBfsGnsGzSJiBXjOUTcQEjgJUuFWCSEjo7WXlDEZoCA62MUuh5tN2ubcxznEGB5uq6qLTZ4IDW1DqUq5l8Ha4QgmXIlrNo8QObGL9ByrgoF3DUr3+9buxNzgq1H7yJiDA2yJjR7DGHfRFAZUhMYrBvsAxCdDsWspkuVxQ94826fZ+Q5crO75AkYKc1/xj7kwBZ+q1nJHuFJTL9q1wnV+aa58I1Ww25dUwcGf1IH/UnP5iuX2F1sQXyPaj7Jk3HpSA12Bdyq4nIba56AJgTjBkunZ0DzyTVj0FbhxXYnflq9+nVLtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrEH1tvx+Xvu9EMctkiELea3vKGD/kBOsGZMPn78iYo=;
 b=CU9sUs1lP3omwwpqDvlPWJpB7u1ESj3gJcUcNb6E1wvQcDbWdCARgLGzymNChVAonmy69Dy5Ob/b6EN0mrQicWiivN/9gNW/ap+t3lv+qiHLj5YilE+lTi0V5jsuAvlaUom0KYcSR1ceygNTQSxtcubeUWEFuCuyblvjowkmaNFCO+FvVsBFIOGW7BrtaouMYKUMFs26/yAPjDe0zIfyqNz8NOyd4SE1q2zl1YDABsmDuHv7vPbsfAvpGpZbXasIuqiI+3VMV88B9vFkHQHr+zbb78TsxJrLmqVPpZXj7/omwYi0eBXLDYQ56rde+0G/9f5lb4Qnat/LYqmYWh1HjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrEH1tvx+Xvu9EMctkiELea3vKGD/kBOsGZMPn78iYo=;
 b=puqRTnAvKcbMG6IXBcVUFQ26f/movKxr/2Fl/mN7CP1AG/COTCG8Vi0J/ZjFJ1QNSbeHDsdgkBHb5inZHmIeKpjKSxbG80FvigwYjjbWGuFYP59DF89V1ejaKlccmL+Fp+Xy4zWltmFEr04EMo1aoxUy8gxAAC91bmWbxBvaLdA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7960.namprd10.prod.outlook.com (2603:10b6:610:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 20:25:15 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 20:25:15 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@sandisk.com>,
        Avri
 Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] mailmap: Update Avri Altman's email address
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
	(Bart Van Assche's message of "Tue, 2 Jun 2026 10:51:25 -0700")
Organization: Oracle
Message-ID: <yq1wlw84w6a.fsf@ca-mkp.ca.oracle.com>
References: <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
Date: Mon, 08 Jun 2026 16:25:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0256.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f198a3-453b-4bee-6550-08dec59c0cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0GSjHn6nN45A/ws31X/qyi8xG6S+GPzynCab99naDZoBpfe5SnzTxTQXk9VCTsxL+pAUFq8Z2fcpSdQIxmqGFqUIGjZCJTsI64QvqPPtnCleMtgLk1n9BdP4/sSSwFzbENhMRnPstJkboMhvdgPIioMuaZ2YgExddz9QxgBg2s3e0b6udmhZssZ9sbEY6H4mBxdJLErpY7vIZ8WlU3t2RoFd5L737crOK6E/c66Irys1/g7WVnacjXvYmgZ2B+66ucZM9+lw2zo6szPW8slIfG9tG5hzpuOzCCp+TPu3tHMKyjzTFIYvEXUmFx9uumoP5tQfMsYUCZg16YzUZaljtRcHBBKLvihCPNAWzh3hcJZ9bFqJOsXvEv10Ss4Z/0Df1tpKq49qGIw1OEoQejWtk5FdsyXV6dnWJ2XvwqlV/Ugs3s95ZluOzZEeLxFbClYv2nycT9IuaFBIDPpfa9ZTYPLokc9oWVyQEBmn6CkRh9UlcboYsM07PLu7icc9ehhf1u/ChsL3YzRODKFj8Nus3llUVMAn9ndvBtBBfuM9SnDgmrSZQXZFmF6tpi5UY4oGjqb2OG6LZIN9N5izlAXWf/pcnw47cSaRW45NUYrbUVspwUYZgtTHxWcpOT3AdfpyH/qtAe1582zzr7fwK2K4Lxc9g6EJNZoF9NrlW86O21ENWiPzT4r1fFN0LsAzBN1Z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pHsGUUSwIMUxcJwcW/xBZ20Og83DCTlnTSp5EnKVzt7IKpvQqA+AYm0DlSmk?=
 =?us-ascii?Q?NA3LwDJUWRFmG6lfj/PMiFGDSdkwSCTG0TEt0e7Q142Q4Cy1Bx4RkAbyTcFk?=
 =?us-ascii?Q?cok4FsQMxBAThKgP9LPI1Iuz5536DNCS2k7dP0/dxIlAdP6f/FK2tZeRy0XO?=
 =?us-ascii?Q?pL4Z994lCYCpGRSZ9SH+gKx4nFemJHZ16I3wKTYWUPUoV2YheXQN9vM3kdfJ?=
 =?us-ascii?Q?KbJhGzMu7i6T0ClfX5TrMTMe+FOT+bDMouT9GD2LJxBZ3FumJfi93E9Voyxi?=
 =?us-ascii?Q?ECQoz1Bw8afeg65mkudv2fbiMxbAUZk4/BzRZ3VzQMrFfnSMzLFXDJPUc3UM?=
 =?us-ascii?Q?mDuLFzOttY00ILVDdT3wRu5o4LphWCCyqTnAT39jdlUEJHdTdzj3WaBGgAlV?=
 =?us-ascii?Q?XZpO8WDPGJRXjrS630rluupi0xDZuqZOTD3OYNWvdQObuh0gL+lD/ciy7jHC?=
 =?us-ascii?Q?DqHrkyRDJiqPdBC2nfb4iiSrXkYQhhYFu9+nx//0IEipkzcbmabjnQw5b4bQ?=
 =?us-ascii?Q?1JrNZXIkbf5+wIoN2alYrYrh+7C2w+nZu8mX5sBXN+cmvaPk90l38Vd3Zo/Q?=
 =?us-ascii?Q?iSnO6UyuOInahW2jbkM4AfXy5TYZg76ni23XrWuMUy61umPe17JxlLbCTLqg?=
 =?us-ascii?Q?LFfp5FZlyZFK8MM08hHvM2GGeY9SRYqr82AN7NRANF7yh9OoBsF8Dd6i7rO5?=
 =?us-ascii?Q?3ZF/OVqkaRclsXj5e5bMHbo4/TFiMovzkJ6jBypaxwHJU0yGg2vwt9sjiXJx?=
 =?us-ascii?Q?tFQeH6+I6yqSjzk/mw6U/wvf/N9/1HvKtbHGDtBdJeQO4If8gV/vch5eXDbq?=
 =?us-ascii?Q?dWqcXxPXx34ZSOcX6QfjmXVsXBc42uzT/RN9aExN0sn5IkuYxe8VFTwFs6JN?=
 =?us-ascii?Q?ah7GIG3LdenI8bkys3GNpVVfnPA5CsuhZi7ccODPUVwH3xS63EaTAfUakOV/?=
 =?us-ascii?Q?2XXOGrVKC6YHEX9ACqf43xmy46orUiVZeuAErATrZxGVpccJQEMW3eHg+/xS?=
 =?us-ascii?Q?ni+mXhCNZCKGbe9t6zwIv1IqfJ8rwnlu624cIuYW/rG2hc2q0x7am1YJhrOL?=
 =?us-ascii?Q?fMnAizPlc6wvko89Y86XA0l8hsPudBkz7MmQ5wlWiZGiuhPyFxRQiSXP9jdw?=
 =?us-ascii?Q?m9VpQrP06oA1HUIqDJvqaJS1oiNHJjFoXcip4Ri5DuBn5efvppQfhAAVy21Q?=
 =?us-ascii?Q?eRa83yO5gu1pijkoITJx70qg2s5OQhjP+GlC0+/b8gZsdGNcm/5mp0V934tS?=
 =?us-ascii?Q?0Y19NiYhGpWfMi0aEf/TfVesRLrtyLPWBuAda3iTvcuqb2E70hV/9jM/UYRx?=
 =?us-ascii?Q?K0HaGJyx93GR8Flqim2Ec7loDDxaLBBWXhWimvqm+58lgG9QvjSmHrh6XD9F?=
 =?us-ascii?Q?ig1fKR1Mr6XXE0MBGUmtCPXXKRuRBR8Y0A6VMO2wQ/uWTgUsChPrY9jEQ9uU?=
 =?us-ascii?Q?6M4tBLOV+HgIuLS057I2zJ3r6YNJsYmthlkCHatSuuLbapBBkmdRWrgdVLrX?=
 =?us-ascii?Q?T4rvz6A/0r6xpWb6qWmFqjvOYlEEB04XJTLL1RSJUXBNCGDu3y7/t5G0Mtu2?=
 =?us-ascii?Q?TXIjEm1VwG0dH3dC61sTHqgbSv2Ge37oi7sB63olgL1hreMeV2jr/BHNond5?=
 =?us-ascii?Q?fdcZg3NCub0CD0eb49iwLl3ln2TnHGZtWmaqPCCWFMZXls1TXPL3WrsAswKv?=
 =?us-ascii?Q?secCvxkZvuKTSTXBsUbup1f3T3pMGv8UrxLS4F4kSd7fpCP6j/aWr5Bjx09G?=
 =?us-ascii?Q?8im9f58iJSVOb2K7bKnHcp3dVThaln8=3D?=
X-Exchange-RoutingPolicyChecked:
	kiIXYkxEx/z6x9lCjLBqXJ8VvQrOb0VFWjUnf595Vq3umcqJnzhRFw+CLo5TvLvFbkPM5vjOy1BCOnMNZokC1oANaaxwt5Ax9K1nA8DfCs+PMx8RWyYaiCnP8WFgXz7+I3nMGPU7LvOg4+mBlwDAyLHorx3XTe60wduiFnEu1wKWd7H76MfX/9fNkMckiz2ANKHQiYdjNmWOvxWROnqBd/k/n3nBdpa8reCmqO20kUd2P41U3+s1/wLi6fUBbpmpQ1DYZoHrNd49F5YkZLkFAqbJhiU6Gty8yiRh+RWUvia+roIcCEdxlA8KISFvHv/kJ1WSX6R/EBpK90eJMPvSkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ur6q0L8Z9fbW9PwNcILJh/hTaDlhtrxDKvWwRfanHQzdrS6jKJiMcHAeYglcHCaYrRNcccBmIg9SenGRzYZ2AAFTKecWrC5QG1bXxxdYIGqd7mT0qr+cvG/rFR9YptpgPyw8QQP9WADk+q3n8Takg8dQrpGnoO0IMJesDsTPQ/EyNYcjs5d+4c6oBg3yz7MHeeDQ/+fTq18K8sU0O93e5YBHb5wezflxBXrKelApws9QXoNAYolgkwBMYdM6b7t0IZvNOR/sr1UgdvvuDuAj3ZXEiLbyxGe8KZRhFXtsUt40ZmhZ3HeG87sZKv0hbX/j2KjhoGRNJiAxxr7tXZ+w8zvSvC5PVdOc/hrOMKR/gj3s/6noyHcY/WS300+QRA5mnrEEhbceOvy7DqG6pXyS7P6AjVlgvrcuvh/uRwE1wtHFVby8R+s4UXm/myn9CuzjioRwlqfS9A0GJ780Gst0lhfe+6nu5tM0wO3rcLI1FzFyUb2bjyXfdvrzz/j2u7FBkXhmTCLB9jrjPNzx1d1fIzyTtb2TvZswBNasVcpDvyWHCfxSZpwZtIT/Jt0nprasXnDZFRLdSRmFOdjjsciVo3VeUmCWCj1M/eD6mq5ZNyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f198a3-453b-4bee-6550-08dec59c0cab
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:25:15.2712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ljLUz4ZrBf005al7S68mSCu8HYvG95fEotTu4tQzl1WUa0e1lxCtzzyhTJmSM3YOVt8bGAe6wmxZ1mup5AA+SvPRubjXLeHABChsaRKRBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxlogscore=829 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080185
X-Authority-Analysis: v=2.4 cv=ZMvnX37b c=1 sm=1 tr=0 ts=6a272536 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=JF9118EUAAAA:8 a=InJrZTXqAAAA:8
 a=cXXqVfydNUKYWxbBfhMA:9 a=xVlTc564ipvMDusKsbsT:22 a=WwJ7OKCui7YMbFU4sWpb:22
X-Proofpoint-ORIG-GUID: ZHWAZgxggq06QPfIsFhiPoo1oL9VmALV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE4NSBTYWx0ZWRfX1ipPYtoSnIV1
 3hwuOhgmaqmNy0eB1d60F2UJN+KllVoTohymAvn5ulLs0HTb1Qvriaxpo9Yt/Nq4JduVC5+BLbL
 4mJitshuyp2MVEsig2CaYTbmqbqNhmNH9aLuXN65+jt/VKAfJzQGe9fXIjMQLYBCKobcUXy06T3
 VD/l8S3WhbmhDpGAT371RYSY3wZO5p8cKgHe6m2+Lnb33smFPgo0sO7Fdqy0NGbgepZBbPyM/nT
 uF9nvydepulrbPTw69qU9qUNiCI9O4Qwkk0l3p7OWTzsPMhsCJwHQBodvp+fKOUAgLHn49hCm1U
 +7BFM/oEXmthG1MHc04UoY6mUUbTJg9A1VtiAZvOmW2I5L8N9yBc1TTr1zeiXHyNdBfcLCEsYBA
 45+6ZClH+sRlF0kcnNkTK59i1Fs7VdAG933va/lgfO3/eKot+yL/KgdIZugC3392/iZ10hWRhbf
 W8nuAxCfZtWTjz5/86Q==
X-Proofpoint-GUID: ZHWAZgxggq06QPfIsFhiPoo1oL9VmALV


Bart,

> Avri Altman's email address changed from @wdc.com into @sandisk.com.
> Add this information in the .mailmap file such that
> scripts/get_maintainer.pl produces the correct email address for UFS
> kernel patches.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
