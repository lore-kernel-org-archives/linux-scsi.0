Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08C1A2550;
	Tue, 10 Dec 2024 02:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799068; cv=fail; b=drOK2Fkaq7xUnCXi4MbIpbpREq5h/h0mWoPS+opdTYUxTR241VXAqY/ykMRx5VapQPUH79sEEf0R4qhxpUls1YAAKYMOEnygm6sNOJxarS5+3iO59ulbTAME+qO5gwV7p0Y78RPKoV1W9mRF3HdDfU3cLUlWY7l9XuffnDPfXM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799068; c=relaxed/simple;
	bh=/y63dY0+z+2TJVKVlqRQeWCPtszlVFqxauxgcFLSgxU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GAHOknQSJrYYbkHa3gz6MxyzG8UHYDRwVM8B3G4fbcjdHua5naq39rwP+oGAo0OGnGjAscppLlhg4Nw2wCxK8dNzP2vLDJkFbG2KC31ZiPs4Ne2j6UFjUtrmoZ2cnS1yfjQrU256ZR/kTQOK9aVf/jQFLD0WI71AmoRggR9EuV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cNQBtsTK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GAOtSzKV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cNQBtsTK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GAOtSzKV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BvfP005038;
	Tue, 10 Dec 2024 02:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=oj3H2dJ7icZBs4FimP
	wR//tbnyLtFH9jO/iouOSmSss=; b=cNQBtsTKrqnD/YgxySHLCcfRdcibcy6BLA
	vcdaOGnPER7dfa4P9VkqKQTe0ur0/I7b05wamGTfMbva8dV1tT1ac8tFMWs20DL+
	/hcQhTrv7pj8RLby9xqn/DiF0b3muu9BRRRKDP4rZQOhsmgDaNLJyymtn4Wnb/1h
	juHUUgVNzmsIaeIg1STEGb21NkuS3pt4Q8JL0ZCPQiQJBzO7+0Xi1d1Zl3F+1NQh
	T6ynE2roA1ClVUP37KoBFF4Nx5OxtMCUutNSowD98kxTkogyTONh0fj7na7Bht/o
	QZOxZVk60Sm96lpBJmvrbISVglmz3qIDTCv0w6OsbLKB28pedfAA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cdysvpd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:50:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA2ECTW019283;
	Tue, 10 Dec 2024 02:50:58 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cct82jdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzZKQCjfywMrHTh4NQwrgUmcL+eyH6LhYQKvDFayUfhbcp0T5ivZlIMy57PnIjIrjk2veppu9mSg7QR7QSeutxWKSvtTQ1TxTOf1+LtzA1TSrqYfZcKSP7MehCTujJQxOql+tSLWRAyyzNe9ANKIwLD0EqLzvMzlttrJ2acAykPAHVEzCuTY/Q+vjP9sxphlW5GYOsbEWQBWPnLo1AXZOfotbRvwyplz43JmFN88h1qzaB4lgMCqibK5mCknKMGMTfLtOcyser7FxyOzmRyXuUewHh0tAkOKboHuYYAh0M53+oL3WHkKKrdiqm6zAlQtT18wDstbGVIZSwjCyfFjsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oj3H2dJ7icZBs4FimPwR//tbnyLtFH9jO/iouOSmSss=;
 b=rg2XGwVvSUrENwpFLeXrj1PQch9FZ4tgTtGV33/rjXXAFX1no52dh8xvwFbXaZO+A8WQpOo3JGlHgLqx9yngAKTCwzr1Shmq325ewIJ9PNgd3WYMBN3tS9uAmHCLnlLd2tTg1LTyM+OtLEY/4gbXqJiD59OAH+sYGR8Ud7QV88tpULVcxybyn3uor5xdeRH1v4UiOTO5+N/K7EFhhxeTdku4Q2MT88j3ThHz+TjnesCf+OGMtSUF9hxguIiqpTMiu7Lz9gXlRbI4UCv6bzLGk3O+qrul+XrLTfxvyu0nz7HYFzE8x1qR/sXVY7npQ/nt1AcEytOyjmdrrJr0g5RvsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oj3H2dJ7icZBs4FimPwR//tbnyLtFH9jO/iouOSmSss=;
 b=GAOtSzKVihNoeFwuPjLAca5RmNzbk8PcfJpKlQqYWhOLeF1uc/5hzJ6iIg90RM7RGg4VFxl+rGcXBhYh7Omg1agVYwIrl6btXBvs9es81HC7xYAiOxw6fFDhNuZopsKj5iI0GXyk4Ua2VDEvatIiw7dgRNOOQW8VlMcms0DrGnk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5787.namprd10.prod.outlook.com (2603:10b6:a03:3dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 02:50:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 02:50:55 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Jonathan Corbet
 <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: Docs: remove init_this_scsi_driver()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241205031307.130441-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Wed, 4 Dec 2024 19:13:07 -0800")
Organization: Oracle Corporation
Message-ID: <yq1msh4jlo9.fsf@ca-mkp.ca.oracle.com>
References: <20241205031307.130441-1-rdunlap@infradead.org>
Date: Mon, 09 Dec 2024 21:50:53 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: 0560c762-26f9-4670-9f0c-08dd18c57776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vs+aQlnaCnnLIcqWcrYQui2Ntum62bDzBte7vO7409OiTtDFm2MmtnRgOCbE?=
 =?us-ascii?Q?V/5KHzwBJ9pcjNc0bpbKum55nSJfW7Rsb/nva13h/QM2xCXlh9SepB3hFrSv?=
 =?us-ascii?Q?JQBOolbhQl28p9MUJBHHIKPKvO181A7RZtwJ6Qh+R0K4LIOMOu6tAK/o7TST?=
 =?us-ascii?Q?RLC/6mXh3ZR9b9GMb6qhUOXG9P52DAnb1BvRL408xkD5UT63V8tnvcXGxsOb?=
 =?us-ascii?Q?DFOoEO1gOWJIQqPDNIUQrqwJmSyRYqebQaJvMgEJCFIMXeeByVHD14o4hAJd?=
 =?us-ascii?Q?8waLGKqvhLqKb5ZceuoAc+v9f4N4d8sOcwP56034mWAUsCnUZlrlRQTAPKPf?=
 =?us-ascii?Q?cU5ucptnQcRpZbEk9XzoCD3EmcAforqwIFyerjbIEDp+7x4SY5dZZKrUexKm?=
 =?us-ascii?Q?JPxgTFHApOhkV9f4mRgz3ClX3cjkxgAcy97x+fjP6w+nxeRbR/UBwBZtuErd?=
 =?us-ascii?Q?S1QdCFVugyZlnWaO7myw7A/biRcz24uauBhAkgjyMRJ3MRPoaZFgtmo/iL4d?=
 =?us-ascii?Q?MJsbFvdjLLVQg/RVDdaCOJ3E1QBko0K0k6cDY9OXACD3di5IqwWzJQm3otUk?=
 =?us-ascii?Q?JRfzOqjjuC2mEDhDof3hW0BlqInEyUytFv3xeN7byBXDrCoA7FDk+g4EC5c3?=
 =?us-ascii?Q?MOj7kjBsxKnCAMxGYOvip+wBEwR7crV47Kx8A8y1mmhlEBIyDhZ430/cprYb?=
 =?us-ascii?Q?nlsj0I6CP6MDtLxWBydiZ2stNgi3gX+L1oOQb52rc0b2KRnNZ/Ydp6zISZbE?=
 =?us-ascii?Q?A+ZbqmfIMra1+Fo1AayTjpm18AiX4TAGr3SG3NYUC4jQJ9hzdCdRTEVwHixn?=
 =?us-ascii?Q?eUwvIh5fAL1sT20ZZPEUzhI+QVwcCV4b+TWu0ovw7upqOwVEPZ00wSMCczJR?=
 =?us-ascii?Q?2AcuqMaWqDtijfv2IL8jcy7Iiq2nIgiM52hVeXFUmkOeeSoTRoltr2UY7ZtU?=
 =?us-ascii?Q?SS2Bpvg3+4HLEWBvr9D5m06xjuQgyl4vrElED9BgjGGMR4WBHjvZ4cGJ78ZV?=
 =?us-ascii?Q?FuuFLtY0ArWooPaenuu/gJ/epOL0GaquKYAFXopx4qEcLKJX+waJ1SM4BKQT?=
 =?us-ascii?Q?VByIej5V+MANZyTXtiPABaE8fVX+3XeiLj0DchmueYwqsOiD4WkKSk7552C2?=
 =?us-ascii?Q?Aa7WT4QTKyLYX78HOYMQgLpgCwXANrPws1sTLbt5JGbL9AcR5wIf4r57b21x?=
 =?us-ascii?Q?RWVn/fxVsE29HBOa671ahLeScypkfYrOHwmIwnhBibM4age3bRURSxBKFRkw?=
 =?us-ascii?Q?LXw82N5mymBKTFrMUOct6rD+ngA8JyFIUJUAbpeCeY6/GiJp+ANJWU2rAS4h?=
 =?us-ascii?Q?Xo60UY2XWj8SOWqBCFcs9bJS6k7i9bxUBtlcwYk5IJjeOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/hPTYUaGGNpI4bGdlqqsZw/ejiwdgebrikRM53VpgxJgjcY2qarreMYonKhY?=
 =?us-ascii?Q?WJSQCjaASzFGxQGUcOoSs89iD8n1LDU5qaiJ34RHP3f42a2KQqKtgTR88qEi?=
 =?us-ascii?Q?nvu4hXg21qlTgc0vo2TRjDvr/vT4h8ev9TYvH2QttG5YfkRkurDCIIT3ieMS?=
 =?us-ascii?Q?RXUqgLPZ8/02XrlyFEg2Nee0+rY4XNPex6yfYoVfIsgqJBYVJykrwpW/ccTO?=
 =?us-ascii?Q?q04pc9O7n6G2qwb/xvbz5L8agMjwiYuOZ1SS1Z7Wbo8kr98K+Y+MNxCVphc9?=
 =?us-ascii?Q?nJsqlclOc1V+pfot2WHrLidzVAqXmzjeas//HlGyqv3xztFR4hLR5L0046bI?=
 =?us-ascii?Q?kG+acr7LzVkI0LsHB+wYj7rJBcXOiRDy2Jz9rsY8RtujPxrB+7rz66Uv8emm?=
 =?us-ascii?Q?i/kEj5qZV6Uuls7aJ6PutHTJriNKc+cq9ehnHzx077zQTbTEb8MOov9/VShQ?=
 =?us-ascii?Q?RfwpW/wjDbDnhaKg6jcUpXZCuy2bAsAyrUx8Bt7XwI5s+ZvHE/oRFpfoOWD/?=
 =?us-ascii?Q?DNajh2vlefKcJZaNpK63SDyqDQext0dD3HJaG6gccvfwCX8jVTHhDXLZuIVl?=
 =?us-ascii?Q?CDF+EN1tvwUqcSSU41MJa0rq79YWqdlwOhXUF5RF2QryBC/T1I5EBxqL7r6R?=
 =?us-ascii?Q?iI/PggqLbFFzI0AO5mWMsYif2GpyCDtljdLsfrTpV+JSwBQ3L+cucCTfY8au?=
 =?us-ascii?Q?4Zc8MnRHY5q4NdG2IvbEQAmim7m2FtcVYvSWEfBONt8o13pbGy/RaYYp9c43?=
 =?us-ascii?Q?DXf1ScoiGtn8/HhXBMmeXqIpVjl/Ozm8+jUj46JAPczGfl4jjEVqnJDQ6pX/?=
 =?us-ascii?Q?V4gfiH6FvONLGoBo6qs7O8noZSjWWalWPNeX4DqdlVj55UKANRUMtD+ukJ0I?=
 =?us-ascii?Q?gafLf3zYfODn0KawDSgeEUgdAUORbPQRLVth6JCQ2eyONh2+hoIk+vmLFZiZ?=
 =?us-ascii?Q?mF7D4NI8U4rdhhqPYgJPAO35KX9WVgoiz66e1gcuZo1sWvdI+1LhxWv1sK2e?=
 =?us-ascii?Q?RQfvqqOaD8kic+FfLvehmn7mxNpXynC8mJt64aakZWEiqQ7wSShXSvsPbteP?=
 =?us-ascii?Q?dYuuSpI6TGVbyqO7GvMFPeow0ZGsu4wFP2U6QRzNhSziJ9gFeC88vii6TqFn?=
 =?us-ascii?Q?Gg1VCpUJvvmr9KydJm6y5ts4rm5SuEXys/oGMWCE5NMeoLwa5u7RR1cJfr7h?=
 =?us-ascii?Q?hKBsAepdmB8IB0YWPrNIDMxpsJmwWaYVcsvz4hFXkefXBVb2Q+y9Pjv3hb+h?=
 =?us-ascii?Q?craUDVbxr9BTr5rK4iJCQbHNW0ituCx2Z0b12VC3izFLp1xrZzKswZJpa28p?=
 =?us-ascii?Q?lD3U+mmoTsDyR+i+PFz3OtZ+dOe35Qe0O8tJBGvO6/W6C2sJKN+IZsBQhrZY?=
 =?us-ascii?Q?bULaWG5vZOY5aybGM5CXrXuz5pfM5rWVsLPet+fiCLV/OD6R1vMZrWaKZt2/?=
 =?us-ascii?Q?4Tqe3XwKwtDacF+R4VBZLZyESSH/3WLhfxgUEyO2uIwLhynSPUL644jxk1GW?=
 =?us-ascii?Q?4w322rzG3XGmimanjmWQNs9FklRf7bFEx4nHN+HmyWaXxlbspdjuvuqmDsNg?=
 =?us-ascii?Q?taHIYubxWGO9NRz6GvwqEwKfrk08wn8F0omPhMtMQ4nl0TITkOUM6Hi9OpSp?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M4IX07WjXp/Wnhfj7fL1posGXov8etVd2PuO4jzHOvd1eAP8kiNjeYuNBjK5RnffB2a4lE+2Wug719nd9Hcac/JEqRV7B4YuBc/ke+bYf2FJxfyZOSgkpXCPm/uSR5r6eRo3znIvqYP0iFDlrVqOfEru0qFT8e0JOb+DbPG0lkXWMbK6Ls/TRkXOMSFSyJgairujjzLyaCvuHd+Y5eVfrcWnpcP380S2AQ071V/62z/wEggbU2m6Y7YwUAB35MCguzzMIONhQZE/IKKgruyLu9AhuADhvbrlkGsIiz+khwxLTvL8KaTkBFzoJL+WxrXO0iaF2zP1/TE+ca4BdNbRaMLzXlt5VPi7DKvFuybxWiaqVlE6gxv7OanEN46c7Ruzbtom/fQ9L9h8ivxQYmmUDiF+UrDzTQevkG+aS8eQYonMsp4WcintNr8jfydTJVgzwkdDnwVcVZkLw1SHRxh1z7qVBUbsPI4a9pHtg1PTTboPNQr1mxMCdtSIB06a7FWxczkTUAOtd6imEcDa/MqKZojpSw8ztBca7V647SN+9R1qoCXQGtZXBctHFyeco/IeFItrBKtnNdk2FTgBrl4PhVTetBRhWa5CMyd0sxaaLZ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0560c762-26f9-4670-9f0c-08dd18c57776
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 02:50:55.0034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvJtjDRBO3eCedQMZkYOgFYOyLSu6iEMnxauNFiKZ4omOkk4XTkTq+VCmxe6IOMLVAur0Svg0ZGagQA8Wa8RVHmrv7xqKogKR+fqwpD00OQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=940 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100019
X-Proofpoint-ORIG-GUID: Ej7jI3e6TLDvQDJ5v2sLWFm_UqjRG6JM
X-Proofpoint-GUID: Ej7jI3e6TLDvQDJ5v2sLWFm_UqjRG6JM


Randy,

> Finish removing mention of init_this_scsi_driver() that was removed
> ages ago.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
