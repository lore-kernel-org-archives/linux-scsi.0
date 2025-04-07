Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43E21ABAA
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744055105; cv=fail; b=UX8m+pmBNoWFsoAOm2cr+gIOJ17Bc6QEXfec0ssheY6p2N1kuw756+BYfGPnW13djcqtVfH012G8pbI2M+DC6QxAteHG/DALWYxvogafR+mrbbEoDvz8HcZjxrEqauoem/bgQcsCW7ZHFg0dis8XCLhaBETRMDiFG5Nor6jKLAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744055105; c=relaxed/simple;
	bh=oZ+/j7cgAKipke9m2ndi2V/lR/zIxenuxPX9SMOZ8gE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AHb0BRqYtDp7dwuuWfTG/nAm8qLQdecjYC2T01wiXfhDk40rAv0aodAf1TuSuxjntrXB5wuUmkgqHVxAXjjFrlEqT44q4g81G1GwNkB2At/Ex+bStU2r2MZsYNjxeE/TmO632zihbrTzWnKIYn4EXYW+AgJuxPadHs3TIkXew4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AzAW48B7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N4TOb8zO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AzAW48B7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N4TOb8zO"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537H0i6H016219;
	Mon, 7 Apr 2025 19:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ORm/btFTJDnSWDoQF/
	gWCMpayAaF1y+uY66Q5HDkgSM=; b=AzAW48B7IAHu66VosScC/wsTSWiTttZmfQ
	7J+ERmWvB7UdrElBHGmmklld1raCHgKjfmpijsaWgb38weAHsRvYLi4W4lY3ZmE2
	fP0dkzVTAZKtAWn2K6DiOuQ8y6kVkKyCOAjm1aHkM8Xr4kBSIW8ntp7FNPVqdPxG
	4atNpDJC2D+tFJe5muz78eTFdRNWdCty2VOpqZiDRy2V73XSGcF4gUGeS8y66ZeW
	nXRLqM7NTCFaaIwh0zmT5iYOzH94axIKtrSCH5XTMuDN23BH15WAya985BDjlcIi
	d7gRzY6rskuqcNO0j55k9nz/macNdrGa9d6M9HVanH1JqyUcOFFA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvjcue10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 19:44:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 537JUPoA023885;
	Mon, 7 Apr 2025 19:44:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyej97r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Apr 2025 19:44:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2rkfiTNdlBsuLcejO8IZW4tfWGewfIZ9URT0j3OOCmLx755fpomIJ25V4iYICbiUfeHSMqVPMG0Po2/HWoHChJQNaoY9k55SmwKwQhxtzg1A5fsWkeub8sZCo+cBfXTl5K7wzor68M6i2tF2A/C6oyvvVaLkDk0699frhR4e6DvzgWr2W3ipxrfwhTHB/p2I06OVMgQKXvtqr6ORc+ASizyIBdbKrx1/ZtzNzPle7SS+q7iPOMXdeUbn9xeRyeSinuFDzaUfgtpOIgkTmIHPIsk4kwoYSbQw5qiA57rEcfgAouECp7WFIiNO3T+C1vcpF+jK1ocaiDxxWpXzMRPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORm/btFTJDnSWDoQF/gWCMpayAaF1y+uY66Q5HDkgSM=;
 b=EznYzmgNFuBhHR6KCxPSX4k+JSFYc2Ggf8xqVXU+01wE2JF0uPf659ezoW1edLKeb8Nuzge0bZbXO9AvRcVRBOVDR1O1YYwCpzkM9F2DdrnlpXbYFHgUp6xUBrZMm56m09EwPKxUOdqjGkpWsAa8aAY28wjYkg5cFqzqBOS8R3fmEQms52+KgRC+2hetF5R84yTiF7uSUMqfBiYLEHXUgtvGOqtRhEAjqc4HRqpceiS+SGKBOYbnlH8ASuii5+e1Nq9M+xzO5IlzuOQlaXuPF1jPYsNicEAhMX6HQ31Uqg6d38pJuam/oG5ZhL+ZkK3LVs9TOtk5M770kGYJQjFZHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORm/btFTJDnSWDoQF/gWCMpayAaF1y+uY66Q5HDkgSM=;
 b=N4TOb8zO4rwPkGP1LRWY7LMx01CmD88uNpLIhH37HF+QdK2zjIQSyvUZcE+VCGVaVJYIdEAVVVI7PrTysTwn42q4n5Uu1faqIEa02/k6U5V6032C5Ooxk8AztCfBzHZLya3o53IyR8uHZLuQ3OR8sP+PNcbfN9pUkxmfHRPZakA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4381.namprd10.prod.outlook.com (2603:10b6:208:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 19:44:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8606.033; Mon, 7 Apr 2025
 19:44:45 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <2eb58df6-0985-4901-9494-9ecbe77a0b8e@acm.org> (Bart Van Assche's
	message of "Mon, 7 Apr 2025 12:18:58 -0700")
Organization: Oracle Corporation
Message-ID: <yq1mscrrcnf.fsf@ca-mkp.ca.oracle.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
	<yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
	<1c08cc57-60dc-4efc-870d-6b9688c85b2d@acm.org>
	<yq1a58rstcs.fsf@ca-mkp.ca.oracle.com>
	<2eb58df6-0985-4901-9494-9ecbe77a0b8e@acm.org>
Date: Mon, 07 Apr 2025 15:44:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4381:EE_
X-MS-Office365-Filtering-Correlation-Id: 4720abd4-7135-4613-3521-08dd760ca5cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?95Eh6qjJYfseBTDdl5eJYj/r+nYcD/wxDZHlshrc8X31RGvE2PQ8c2rkJj4T?=
 =?us-ascii?Q?wVDOet8vL2rUPCjHffNmqVODQfZrFPyd2CPbu7HwyPtiXKplK88Z1c3p1ARs?=
 =?us-ascii?Q?PMPuK5k9bcG4A6oKrNMuUIhxITjwxftf9LAqXNm4p/fslj8Tgv0uaxhgsaZG?=
 =?us-ascii?Q?NX2nTjztsh7Pvnq9yy+FDOAf7AWWEyUvPmYykqVuz9FYaFhXp+T5SlEPADb3?=
 =?us-ascii?Q?VX37UdGOibEak97Z1FiwZ8Ezo6dB42iOOnduvkQVXUG/NkFjicPar6oxP0ye?=
 =?us-ascii?Q?fZkj3C1eBJ4sBrRXYbluE+z1qAmse2SGs3UW6gbFwuIg6b6sp59Ij0SQvZbT?=
 =?us-ascii?Q?TVxbymHAAf5qKPhblgZI5GOmk+YOQtctil3eS4d9POcexLVZumEgx4V+E5eM?=
 =?us-ascii?Q?4JC4/ckWC1d7l7n9uXxpvxVu35m0Wy0LmKnl4V2UIqrbAmSvBhyqRc9MkgAS?=
 =?us-ascii?Q?VD3bJxoxBoI0J15kgKnF37zMXGTxr6Mc4HtZK7Qr7UdnKlwp5W8GQqPQ7D9j?=
 =?us-ascii?Q?T6Lc/+h+hn41ozzA4yo9K49pWnpYk9IU2rmZpDV8zMMkjnEJYOa126LPFBGc?=
 =?us-ascii?Q?S0LJzrNYXjSIQRcQqrXdyBMMILVFEMSuF9ruhoFxxAAmp8ByLKIO3vBbYFpO?=
 =?us-ascii?Q?jjxGheZPYpXTFJ+9E+hc6GrP7UQFCizmrnavM5j8TQSevwSGjRA72D3DlUHG?=
 =?us-ascii?Q?yxo/TGc6h8UOnoOfIF71KJxg/dAiw9dKuqsWEdghgq4p8otGwkPpE8+Qxmlb?=
 =?us-ascii?Q?3e9IcmWDCDpluy0FBJaoXi1u7brKIxsa6W82SFppH+qxPxPfh9da7Svr0aRA?=
 =?us-ascii?Q?cYgy71/vDShL77gfgkn3nyaBJiim3n+sevLvIAq8x3HvFxy2d5a9rIq/uS7b?=
 =?us-ascii?Q?s56GwxNX0c12ajuAyrIMIUNYtTPiye453sn+7iNNbBmT0imTV1hL5Cjd1Qkf?=
 =?us-ascii?Q?1MvbPAi9DrTs/kl9avQZRI+oL95vFu9t4GhG7M4VwlvzYH4PSeARY610Jr9Z?=
 =?us-ascii?Q?f13Y3UX+ZdJEcjPhW8EHFG4g0RKrcDth4o8z3LSHSVVZsRyOrAIbNvwdTWQq?=
 =?us-ascii?Q?OSPXzrShV3N2tsCsnzltNDttV4YeRMn49NSIVe0kBHVmMycHsVlNyl/zUiNc?=
 =?us-ascii?Q?FmuHyoYTxYprRfOtZKZyoEwTq5f0/7/ND/KJWxyj9iCynLSMURb6zwCxbufp?=
 =?us-ascii?Q?xRnPoobZDUv7Rgj1dVq0/foth58hZ3Ze2317p1lPcPa+GIQ/FQODYpNk87GV?=
 =?us-ascii?Q?y1k0SmjsirhyzN2K9yiSEpe0SjnWUmSloNtLzrO+jVOkveoeBDg39RsRtIKS?=
 =?us-ascii?Q?26bKfAtDHXo69/t8JeKBjD3tfrlwS99cGpFYspInLvjwIl5Wiao/4Xam6O57?=
 =?us-ascii?Q?X4QuCbbbG4vVcEyHKvB6P+y0tUHO8Ix4BmEwpFvpKJ2A1rHvk1MtIbbkPy9A?=
 =?us-ascii?Q?/e590d7fU4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bxk8Lw08om7IpNc+tfxnlSyrtQWdAXsn/j/3tzL80yROEioDO/c4mpeb1TwD?=
 =?us-ascii?Q?1p1OaVnKbe51HejbvcbTeikU326gUUlTg7giuBIzh6e8huVBoPxw9FbqZ5Ac?=
 =?us-ascii?Q?fuKuuk3TDAhYN0klHqv2IR+/aX05wwdEvdx7aafuUxqO48loOmIxneXpG9iN?=
 =?us-ascii?Q?/VeIyI87mTDuXHsSmdfQkQkqYXmUl8XJSDkmJDBbyw7nq7FWaVPpSF3Gg0uC?=
 =?us-ascii?Q?06U4GXQ1T+YOa5FnJEJo5zultg09tJ4/iIpRu1rkxbjjsmCGQN09ETeeBeT/?=
 =?us-ascii?Q?cnJviL6+pOcIM3StePp5qgdlcVgWLDhO2HPUdXJd6LBYl1aHYwf+/CVN8R80?=
 =?us-ascii?Q?b20rJs2NLwAY0WymoJH4Uv2IFOeJ0Ov1scRCTYNhytDdrphKGsoSbJZs1J2S?=
 =?us-ascii?Q?+ePtIVbF24pHpWqrZozWqSRc1fXXEo7tH9o/9S9y+lA9b5DiyXLyehEduJiF?=
 =?us-ascii?Q?84UINwZdyhUTg7Mws71zzt7MOOOKMfwUSHmlW9751tJ1b+0qXuEukMinXSuJ?=
 =?us-ascii?Q?vYYZ56oacNSZV1TJiDIsIykyjjh1uTXyfMCrLQC3ygUjYcNuyZkMiDE8A66+?=
 =?us-ascii?Q?SiR9OuRWBF63eMbo8+dh3r3Y7iJBlfyo6sF2q/OGxAXmFsc6yhIeA33zpjMa?=
 =?us-ascii?Q?yXMXEgWqsdOmrWCU4UjuSumAowBOHNzmysnSrIVbBXoVQ30l79P0bcBtsuM3?=
 =?us-ascii?Q?vQkFCVvIhZSRxBWT4YWz//bGi4EgRetj6h3GqvgQy5MtRI6jEjDDIK5HIW1e?=
 =?us-ascii?Q?+PMCR6OM09QAVq8T0uWzHwOt6FoigvqTwJ+Di44HN9CIDEn+U1e9cytyprru?=
 =?us-ascii?Q?HqfJpJXA8ZVK15kSbXVkOK+5pUCbwkNFwdKXGVTgdAWQgfG62uqlwAdqAvCV?=
 =?us-ascii?Q?TF8EJAWT2Z1GKptZnM5JVrvK4b7VavHNtmuo+uGKXRK7XWOoaodB/aD+bK76?=
 =?us-ascii?Q?wk9p+cj/ND8uSVeeUbN7i1M8/5sVtuQ0+6pN9MMzuxPlIKm8kmHpo7l6eW1b?=
 =?us-ascii?Q?bkhhuAyZ12wdoGI2CgPQc8NLH7HL1i184LQmfMG6jgHTqk/UyTe8m9wDAMBA?=
 =?us-ascii?Q?BVXv1m6edd50TL74JurrCxm+XJJbnoFTuBYXqswktRBIJiJcAo1kDcGwc9ju?=
 =?us-ascii?Q?BT3v2+9gr6aOoVbfQY9qHhWnwGhBdc3+1jUfZiCh9TPIdf/JQpvqlVPvqdHX?=
 =?us-ascii?Q?HZoWlxell9rEG+ultHO9eiiA3KUJecRCPaHffNPsvGn3/2b5XfVjBJzSuFyW?=
 =?us-ascii?Q?3wWVEeuhRvfqyqeoyMV4QrkPuChVNphK/vcMVjMqxvdA0cnQAFojFIIYtqIW?=
 =?us-ascii?Q?RpLNCpq7OIQpPUq0X2t9StNYXBzlykiOtghNgHTk7AF3NcPuuQ729zUSLE1u?=
 =?us-ascii?Q?b9lJ0rAkR7X8yARGMSuTfNFxbVdAw5BNePOyVGLuZrWZrTc9+9Gwr/qW/GCE?=
 =?us-ascii?Q?MuVaFxvZLQNmtW1HyPISvxyfRIeSBBnvORAIra60Y52Hm2RYJQtTk6Shw4Gs?=
 =?us-ascii?Q?llDgH9WsxF/sSxrnc6+vyj0j8y+WVzQvkFDtuBt3ii7aiUEik24a1GrQLU35?=
 =?us-ascii?Q?Xz5IRn9wOO1NnjQhyvtZ5UJN5lRsA0SPBvG09M3rH0bYi4sXUrg3PNdlgOI/?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KdZPH2ErCPnal9s29ReDo2Iiem7jDNlKjYbKTYutu8BDSMdaFuVcJSZF4/EdmS3lNbPwCwxitVY4PluibrcOgU5JKo3sR8cXBBnJ642y/n5+4J8/ul8TqdTOmlwxVkGEvNAbOb7Heb065yXQkvSL1S/wem7FzjfrLIX/0vChl7CygTxD23NEGftW6K5Gtv7nH30Tl9kA8SSZp41JZTl5AeKm0FmXuDePod9gytTGSSbErbihMHUzv3Y2Xvr7Yci53ymp9yEkH05Wt1x5+6lyt1syIrL3PleQlj02N7DBsHAYyQfo8TVGNOWeHoKdDxuZ3T+wl9VPmYtS1r7E3bxDE0M6YgX45j5XfeVjnYVDSZSORZcTTp9QhP3O5G555lm/u5LR70oCptrBsl+Ws65xDxsq2uo11IhuyCLLm1oWWn2na2yCjs7bo5D7JLo8hWQH3/RVWvoGfedKfPWHuvEgjNUGBm4nNPhXo1bVqy4vQedPrj6jgdhb4huswsanN3y7qqlVFeI7OLhzEVPovq1stm/bLaw4GyOZAg9aSInSorFHTnpoczj1LhU81t+zbXjuhLWelQJdCzmkCMo8DmRJg99njo0QLEN6xUZqRtWrvZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4720abd4-7135-4613-3521-08dd760ca5cf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 19:44:45.2181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbUDeYox0nBiHS3W8Ti2k+1C4Y6cOi8PY9xQRur6bv4CSsDypD7h0eyzn2IkNtRlRjf5jF20CJbx/0rZN98ZfwH8YfZIzoriPffxpTBrxC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_05,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504070138
X-Proofpoint-ORIG-GUID: VAzL_B3ozu3FWW3LQc6G6AFppaksVxwc
X-Proofpoint-GUID: VAzL_B3ozu3FWW3LQc6G6AFppaksVxwc


Bart,

> That patch is fine as far as I know. My question is about timing. Is
> my understanding correct that all these patches will be merged during
> the 6.16 merge window (three months from now)?

The patches currently merged will be pulled into 6.15/scsi-fixes once I
set up the new trees. There is almost always an outstanding delta at the
beginning of each cycle since I don't stop applying fixes during the
merge window.

-- 
Martin K. Petersen
