Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF9B78F2F
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776818984; cv=fail; b=T/bxjP3DWVtYXPDl7dkUoclr9Vn1fv/e3eZ4DYGn7WxntJWijlnzuLFTNR5/1BFFNVKa0OrGVq0upLa6cvtmj9P60fDUqE1EqC2C+wc9T5umhRj2wWlzOl/56iFpkdJO/YvK3LLVJdZW35/mAig2x4B5zXpLByehdnPLi7eqXYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776818984; c=relaxed/simple;
	bh=lz8FgTuwRh2lF93l0dHiQrNQtKeLu7W/NIzBhk02Kpk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Cih28mK3+aGMEC5B4N2fHBqa8wHihiG2la4qNnMwqgx5k3GeeMNmA/oLKMIfBfVwPA+DI4+agYVRJIsQlHvMdUoAed8/GrRExBycuee3j1qbiLM5Dm98eUztHXqzb0On9o5uiIeQfWVkAaS63EXiax01+bD2EsYAnihARBzi1nI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AMvCNLU5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YKYfjfoZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AMvCNLU5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YKYfjfoZ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIaD863474760;
	Wed, 22 Apr 2026 00:49:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wm0JaR3b9Qm3rQ4rI/
	srB00d5lTitc+UH63OiRhzBaY=; b=AMvCNLU5vTuJ6KoqSF8Tn14ezaUsyaF2bj
	sjyLZos4Avj7tSm8pKYi4qn32BPd5yi7T2U+mHjal6PpC+G+crN4Jsu47G+zC6xQ
	yHTYmmkAxER09yCOg6C/Dhkos74CUn1lCLoblauiIFF7FY6tMCoU3R8SeOvTGhSL
	noz+TcshKleT4yxIz6UiVrSFbwLvngx02lxQ9LZ4dLhJmcteD+CQ0ENiwHdUMukz
	gfDUt/TRdP+2/NLubrhWhlCNTRI33VnUdtC32n3FemuyKNubOjTfMXCU4tXeW80m
	Js88kALfgPBCZicAC/p6SXE7AsbluKaEe8UDsLG1gj2LKmONhmgg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenm0dvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:49:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M0kOlc003490;
	Wed, 22 Apr 2026 00:49:38 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjnjn4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:49:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBjaxjI0p1aC38q15xwqsau72vagGEPA/JuZs898MliPmhoa/aOR3xauYaAi3fB419CcItMO9dVT24CZ2hF3jfbmzRj6zQF5ayzae+Q9/dRF0/XLAcwwwzubPg76syyjv/DODqWVMJ7Wtk3MWVumf8szt9ZYTrzELkAHMWSsHghzn5OQCXzqKye/ZPCMIU0zhTRFFYGnUFhxzuXpTaxLYsbPRC97CJ03mmhwLEx79IjUUc4kGNknzSAEaz/gbt9L/jbDFJ5knxLN6xdXQfIBmyAhtQxu1HpO75RTE32eejlGtrbYf9T3JrBJBV+CtPzxxiNghXAPVZPLs+NgYyX2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm0JaR3b9Qm3rQ4rI/srB00d5lTitc+UH63OiRhzBaY=;
 b=D2K458meP+EZUDj0CYPwreF2YPshFqRciqtG6XEpg+Eveq3vuxtnki0fLQrjCLzD2QLnpwXyqzpzWeM/yXX0MFkXDmW6AdjX22dZvBMXFZVNfSM4WpyTeI8pHjH8eTwHnRNnU+gvutaTlAo/6h95oPEuNPuBHCIQN+cFtq4tyxzX4IQW9TCTBLtu2vVynpSZxsI8Ai5YkSFNeYyZr9Cvykwq/YvyUXPOIGs0F8MSeryIBfEUTrlrhArrf0V1zmw3KKTVXnfhGtUa4+W5NQo2kEsygdboT0Y4LSCY3Y1huJybuOQmYUPGso2xxyUBLRkiGsdW26uiBcSF7uWhUFi/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm0JaR3b9Qm3rQ4rI/srB00d5lTitc+UH63OiRhzBaY=;
 b=YKYfjfoZVkM1XrLU0ffQ6vymS9TL+BYMtKegYMzTf3Y2ofO2mRAH2peSTRmnBexk5sin73Yu3z8XRllb6oV/xzO5broT0gd2GxkGPw26/qy6MSWAE5wRUrQWuR/4AyKeOgbl00B2JYvHp0M6Xx11XESRBMee4hoJySSs1rciBDQ=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SA1PR10MB7709.namprd10.prod.outlook.com (2603:10b6:806:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 00:49:35 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 00:49:34 +0000
To: Dingisoul <dingiso.kernel@gmail.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [BUG] null-ptr-deref in mptlan_remove()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260420011829.176936-1-dingiso.kernel@gmail.com> (Dingisoul's
	message of "Sun, 19 Apr 2026 21:18:29 -0400")
Organization: Oracle Corporation
Message-ID: <yq1zf2vlt0b.fsf@ca-mkp.ca.oracle.com>
References: <20260420011829.176936-1-dingiso.kernel@gmail.com>
Date: Tue, 21 Apr 2026 20:49:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0411.namprd03.prod.outlook.com
 (2603:10b6:610:11b::27) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SA1PR10MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 85123235-1be1-4f21-6105-08dea00905ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lMAvz3jggAqcyCS3cCvRD/n9aQSqmk+mxytnGC5WlKcpw6DxY/QY3VyTysChrFi+IZotaMcN/+FzOSuzrboAaokB0Nbm3QNM7LNkJJJyPJ45Vlxcp7EPHh4dG4ff/lVloeKJz7zaV6ZQoFJte3MM9ljopVzUOhEThY8Sx8rpDAZ3JSgOPQcDCEpWizp2/BwJZsbKjoGYmqtSXrkMceq4rQWCQt3FZLN9gAM91tmECwjZgCghzQRehph+LTrdNEVYxCAlS+aGJ/0Im48s1eCnkQWtP3hYdOy0n0E/1zI2XR6g+zkSYnJK2YpdJ016yR+LuHNhHOA9X9tX9HZ/wo91uMYPLNz/vkmqR0fVMraxygibApVxcZ0XNHtVs2fKVJYnVl3aL2MK18hsck0nsMFCFK2MObjG4F+fQOrO3tyz52bzSGDl8fyoN60HlC4RmUK5Nje09PyZvclAltZmWmcUx5XrZ3ph60Fjbp6Swq2qBHDxBlVkRdFsVxctXZeXDie/24lgYeACNIqAsFIIjSGkxV0lTHJ4VXdN7wl6F9whOZwBL5pHV7QAWK+54kFPzZ0Ph7F6KD8ohJ8fuwWHpUOjIFW8Dp8oUVK7l9+rf4+UqOs0pyx5KqDWs3VH5BLy4F9CvPpzzCJAbGsTLSiHOP86BdnBHMOhkPk3MozfAQZziLKMECVZkYN4mY5LVtUDNabFpLBV3ImDBXsEolPR1kbA/xTxyql5FBCPn2NObwbTtQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kqo2fR7za8Xs4glC6tciZLhq9FXVDAMvYD/zM8prEutp5F0ZZGqIdvqrMHwY?=
 =?us-ascii?Q?+3U6RvnOMKRLFqpUUkih+CA7Kw7CbUzX1eImFnSoMyHCpHTSh8alOyhctOEH?=
 =?us-ascii?Q?Os84vIgsL0O6EirogR3SNodO8BlyOgtsdaWVEqROyrAlm4vvv3mJa6Ms23VD?=
 =?us-ascii?Q?+0Nn0IN9RjENJ3BHOvRc66g5xYCZelSvJEVGpt5bsXzc8Uvi/2PwuivUcsla?=
 =?us-ascii?Q?U37/ivRHhPQg02DKFnXRi/cGTp5pRFiUCaq3Xkfs3MZjhCeO3Xcsu0knfGPl?=
 =?us-ascii?Q?H0DPGC9tM1n3jWCc7I/xnqPAnZuEYo+P2c09n0hVQEnd9vn1Wyi8e90PpC5b?=
 =?us-ascii?Q?gAAyB7SoTFGxNDacu4zASNwQY6AIHUoF50jTYDEPzj0/J71+CAUk8uYx574h?=
 =?us-ascii?Q?fG8lps+VBAoifTsXlJ39JLU4ajajXjXu3XO1UjKTW/XCgjhH96TOD+uOxmT7?=
 =?us-ascii?Q?b2be2eFDUhRyPo1e/MjtsmebGDXE7/hWCWUa2AqUQT2EwpJ7MIGj0ghdvBMd?=
 =?us-ascii?Q?aAM65uFOxAe7Y0GPydtiJG19VFdt70/uX/d1RXHH6n1pnAS1WKbuvHeCQSKl?=
 =?us-ascii?Q?AFczdvPjT6v+f3XK6ac0jc6By5USe5Nq/7HMFWqUCRsoK1bF9HKatGncUtdo?=
 =?us-ascii?Q?G5GtQVCcp0KNRf7rOkqY1gtWCGf9g6IC8WVdTFId9Uy6iW79vWAoXKv1d6hG?=
 =?us-ascii?Q?ACvk4I2RBUY1MYU9rNLkMIz0NnZH8Zyc6ujY0zV6T20nVqIcUKXTsTcv494N?=
 =?us-ascii?Q?c87/Nsl5AMQO1Kh2j28Sw37Ot/z3AxJxXZdCj2WmsSgUPZzHTUDGFt5ENNz4?=
 =?us-ascii?Q?nAwzIQ9TAHSXdbzjs8dYdVomPO+67HSKovFwlimpTAt7Wp1A2ysoxKMpP1wx?=
 =?us-ascii?Q?H62+hO+UV8FsvL8XG48NeLQqagOjahefPfrvLJyZZbr0dwVbh9FyNURB1an+?=
 =?us-ascii?Q?TeYQjMSzCScqR8NzjmphIcknEISN3t2cl5c2wo9BhkD/VlVi5B5m6kzXjd3c?=
 =?us-ascii?Q?UzCFNopoAhpX36VO6zAYLTm+4zdRMG9LJCI/Fukg/381rB7PjF85fah9WAer?=
 =?us-ascii?Q?ptYuNVOkb9E8hlHtk/QVGFkDVZ69c4GLYBI0ObbX7APQCS8TehCeo+NZgEQM?=
 =?us-ascii?Q?MTxe11iYyCHCn2RRp28J7Z889SECI/21op5p7H130Ek1syfWPZfD+3c5aPNK?=
 =?us-ascii?Q?cNf+pW9/Ty0Fd4veexhZAVefuGrHjFAKJ4riVGyvzrgAKqPqN/iyelRquNlQ?=
 =?us-ascii?Q?swbef6ZBUbDmZA1/FYQQ0L73sxp+fZHxGRQE73rSjvOS3rAlbcVv+s0PzvN3?=
 =?us-ascii?Q?uWVo5oKrKXXkFsalr2P+kTyCrnSYzkwTVLo2rDeYcSyHSPv0WIk2odsW+vHD?=
 =?us-ascii?Q?UvUbhVxSQ02Q1tS70FdH3t68MQZ7ddzhMAH6LnSjjKwPvGPXUsVSakoc4wLf?=
 =?us-ascii?Q?g1PE7GJUmDxVWonNmlGDVlDtnysYi/cwLdeSMn/IFl+qxRApiPWLGeGTQTzf?=
 =?us-ascii?Q?1FTd/ozQ3Fqba+++L1F0snToTF54LSKmgAYw2y/KLcz//RT5UI7dLYUi5znD?=
 =?us-ascii?Q?+gukdYkXIgKuOyGUe418fkXPMDjFgRo1tgdmCXd0PNcLijpqjImZzYprQwSK?=
 =?us-ascii?Q?Lz1EsjUIYzEovNyeyTCrPHCA4Yx62ZO/ckyMo1EtfK+67uX8DkWx5nw18L3i?=
 =?us-ascii?Q?awHhtqGCDBqe/7yaAOM9Yg/xEF7KS5yEJDFKkMcxAPDCKSBtnS3o+9sJkjUY?=
 =?us-ascii?Q?9cD962IkazVX8bA6OS5TzwMf79J0EWo=3D?=
X-Exchange-RoutingPolicyChecked:
	avZxoarKmCeC7/hCxo51/1B4H+W//9DnP6rj+fFfgi58e5AN6q+829kJvxVG5vF084obw4wLDE8/8HqxKSUPl2E3fjkKJZrPMrXxkhJbyQT2rw8cA9L3L7ASrOIEtWWE+JHG5eQadOwoMA1hy0BHXqgjhkS8LKHv8y2rX2xY8qyiN345dXWUIWx5ENtRpc5RUP4WHO1cVzlc/Yn6KslW/K8R8oLPhZwAf1vqVq2NNm7dQIpyCUo9VYwWmbvPDgLuK9+9rl40Ho9DOZbceNYiwsP2lq25McdY6wcj+aC9opJJsbWW4Y+GqGwwSKSzACM/PX3u3+XPjvcOFiOQPAUN5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vGQLih1v6I5PmV3kuy3fORWfVcHDRzQ9VfFE/nVY2Aq0rMPsm9p5YypOJRgdx3FwDY25gdYFAN4NU6KuFBia638KnlmoDP7hLI60gaufzW8bGRTbZ2CsRTUvQx2y2YHQRV6s1Jl7gBjpp1jLH6lHW4R6430+APx50t2XMMfCG6ZRdaTsLoVTlNChjOfjLAmCd/IWFAZH3GQBGK+yxBOQU7hKvOV16MMbbgmjboLJPWYrGvZyudksL2o5ZsLA++t/klXlGmZVrdkDB9NEMEOGhmPTjITeIWPKsKbx3S8Q1ChQr9+rNLJCZWCGmluVhBmVJqZNjJol8KczjKJ5ZHgm0QBvaru/FXNFfCAVfYa2EyXemXJcSp2jz5XBIBIXeFyC0p62H+z7jtmYRqN3G11YM0hzGG08dIojgJcdcL4NoQkg5lWoo4j01DQBdlPx52TCOGAmInUFHh6dE3giRImbAOFo67FwfA13PTeYVkOpfevhZtAYWsEFQxM2ytSQlZ5p8K+MV5S6q5CVHyiGxvO3B+t/5sRb266TPVxZMX4IFBSkI5yVBGWoZypame/imwS0ZpopkAKtr8P/s0O+BgyI87+AvNQIoSNkBqQutTW0nGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85123235-1be1-4f21-6105-08dea00905ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 00:49:34.9312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5h7LTni1++rPXYTiqydv/Q8mAZQ8C54abIGdyi0SOTCvEWM4qTUZhZSsD/DETBKejulQt+vyV9Rth9f6FmBOyvYsTvSv27v815IEEZsCFI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=693 malwarescore=0 phishscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604200000
 definitions=main-2604220006
X-Authority-Analysis: v=2.4 cv=Xbu5Co55 c=1 sm=1 tr=0 ts=69e81b23 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=Re7fr7EQ-3hfjjv4WxsA:9 cc=ntf awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAwNSBTYWx0ZWRfX4rNQC9BbmSVa
 YB25eJkYJXV/gVZ85haWa4gAJ+ZlAGWSAni2G2AL1qA58Il5fn1WnYqI4bsxrJLP14UaP3OiEBF
 nQlLi+mRmcdCTkyz+CzKAvgu49UFeqBUfY8oicmKgyztotpLN3wtiRB8TI1WmiemF1fIIpMhNlN
 E0EHUkbrGwv+kIQn74nSPHWI1NGZUVclPAvj7AeLjKJ2x4uqnjv24trDb/vim7+svYSgp7mLqT2
 HeTnoN3LYAIanMm/MI0LUYMzDOOGKt9uQ6FzWUUdQLPMGIDUAmStiNy3Il73zbTfsi9MnGY6wIx
 T/mt8kUR3KEBmDdlfzRTIGYEMgefhBxo7wfBpahj7CbaUf8CPwE1eQuA/QuLdWhz6zEkHZxIvKm
 Oh167XKi5GTZv6td/rLskFySB0fnBZGMtymeqRdi7Lug3WUUOSCpsn2CIj6XFPjOMdkaaJH0517
 EWJN6W5T/p8CiGFqJYD1dYaf4h9YDog61/Lrt05g=
X-Proofpoint-GUID: MOJJKghaAorDwMH2deF3Hch03Oj60TLZ
X-Proofpoint-ORIG-GUID: MOJJKghaAorDwMH2deF3Hch03Oj60TLZ


Dingisoul,

> In mptlan_remove, dev is assigned from ioc->netdev and calculates
> priv. If dev is uninitialized, priv becomes an invalid pointer,
> causing a crash when used inside cancel_delayed_work_sync().

Let's just remove mptlan. Please submit a patch.

-- 
Martin K. Petersen
