Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE772634
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 05:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765790; cv=fail; b=uM+ndUGN4h3oyenda392X5XtpJXsy8I5BfbflZD+oMM7DsRgldthOx+xp61N3xX1/Hi4YqUkYa+P6nSmUGvMERAhe2+v+ABlBhm674GgS+zzr0M+iUFWYFhzVQzZuzFHrcoUTC3GuyWy+bhRn5AoVCRLfNNVOrC7GHVMrku1V64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765790; c=relaxed/simple;
	bh=XSnHByFAM2rUytNmkx/t3/EFc4aNwOPL5TveiqRsmJA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HD9U96DoI90GsLtEQ4y47FfdHlnqTAfSVqdsWQ3VeuSDaCthUsrtrIajincou+rH1gDzn2wfaf+90bpY+1Mhl7phl6YZCTpoeiFRxMPAUHPpXLZw3baWWz7abh9EDSGlIWjAKgnGgehlDTgM85FuiWUusGU62L+ZwyLH1+UU+xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GsADhEsv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MvjilFkp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GsADhEsv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MvjilFkp"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfsX4011847;
	Tue, 29 Jul 2025 05:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EyMG0Ko73dRQ6ZyVSK
	oVFaGJ9DR03WG0qlSvNrBiyvg=; b=GsADhEsvlO/GXKCBmtm7tw60a4u6Prj7EA
	1Hbl9yykG2iWYM5QjZQfgK0ETi4gRMC7sdxxjhFrtt+J82q/F3oTwPcirj+QsBLf
	A5EgqpDGwSkWuJlHzgfyPj+z6QtrquBJQB3KylXZXviEa9qYgSHkmsTuGOdABNVU
	fy+33sGt02ghzHu7FxJMt7StBaRAQxdeUR0eDfm6hSkc7Fm64S4MgV1OL33oxwdO
	EaEsXdwP9RJqit5kNRYUGedh2NHwtohQe3HmrCK88dEMR4qYaeeB5HSBvii7+7sv
	w1hjcJioe6jejpFy8A1qzhlNVAoZYqQHqujZeWjieYQcJ0Pyr4gQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e6xg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:09:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4Hc7b011302;
	Tue, 29 Jul 2025 05:09:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nf988tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xE9fecwpLKbe+kUIW2emTZZmR/Wcq4RSbqLh/K6U5voX3vY8F1rJp3t1+3c9JRaADufyXYyTgO9we2Q65OuyYx2zjUwELJEEFCldHhiSlqyrjx5EMS4wtGyClCw0IzJHCK5Auyn9Twpspc7guFjWf6vxl3oRI9GEL9MPVpXUDddePt19QbU79kPZKKPB4mqEoEvCDRJA8C5agk/+ObGPoAhQoSUHAtwzMVR8w/j5ZdnzsU9t+/H+ZD6yV4IBm1Mr2aiKfzu/3Y3zTwf313RTlOfCf+oBXPRHg12uw8rKMCDjts2LciwmgMr1k19NFOOYz0hifSHRJlgIcUKyUgfF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyMG0Ko73dRQ6ZyVSKoVFaGJ9DR03WG0qlSvNrBiyvg=;
 b=UlH3IBQG6SHchE01ExEch4fp6nCyu7vL+PgTJGKaI3OvTIcfH11i+Rhe+U1vqdLjJ6kTfLmPt58cCoSKo87gDqfkdRgrNqNGV7rklXta44wjPw0kXK9rWgV/CXpC4huryIOjh5/GgKDGcQK8LFqIB/T7wr4lH+BlrVnFJswuzWnOG231wUbiC93fmpHBEkGC2GlRW9WCt35+m3TL1PS5sHeby2XH/ovcRFImmLaQ7/R9YC/oEqSv6Dp1Hs1kjz0TRnxCcj69l1ASnS6tw1M8nvAQMGMVsyXniZ+778C7fVGipRG0mhdaMVuZ33uyOW9jlw8oMOthT9xzQGhQtuTiVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyMG0Ko73dRQ6ZyVSKoVFaGJ9DR03WG0qlSvNrBiyvg=;
 b=MvjilFkpyA/oy8AVBMUFVCigpwT/b3S5CKrPuiOR9TdC6GMgS+FfLVuBKdJhyd/kL4sGbIARaD+B17drlHuxS632QrFgnEeourbB28AoCOQMeo36QzAbAWtQoILyrnj938IhRx5wr74dAi5YVz7LhafirLz8NW+LWCtEkiGykPo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6460.namprd10.prod.outlook.com (2603:10b6:510:1ef::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Tue, 29 Jul
 2025 05:09:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 05:09:31 +0000
To: Kurt Garloff <kurt@garloff.de>
Cc: linux-scsi@vger.kernel.org
Subject: Re: Patch [0/3] Support eager_unmap for non ldpme sd devs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de> (Kurt Garloff's
	message of "Sun, 27 Jul 2025 20:06:38 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
Date: Tue, 29 Jul 2025 01:09:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:510:e::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: 5108662c-0dc4-4d32-cf92-08ddce5e19f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cZ/bNojydaSP0XPeGysMXI73hfeAri+8SpJDtypb863pyY4hJB1f0oNXZjil?=
 =?us-ascii?Q?KUHeX0/AeboOw4duPJQnImGr2UXJg2bPnv7pplp+rlT6fsjdSo5j+yMuupBS?=
 =?us-ascii?Q?VUF8Qd0MbH7Hs/3ne8JYBkHJGMKXtoC8XxxyxDmnJHbBK1KrPiCvncHquyjb?=
 =?us-ascii?Q?aKWwS4mK1Mw575G/8IGL0cm2IGf9wFrhKrI+HvLDDFmXV92EF7EwuZDEO9Dj?=
 =?us-ascii?Q?p7acYlg90pK/HhYOj+hQppthu6PjBF/g5sOuyhhs2wmTJMheTGsLtjfLyCZH?=
 =?us-ascii?Q?2TaD/BmCM5OPY7KsgFoVfd5CEaNnsKZ4G9CLHUMNatxnsv31jTZE3vcNdjM0?=
 =?us-ascii?Q?FtSjBaz7EQVjaveDlZlE6sgK0aOyN/21jp0feZI8y9NuzOG4yJSbKsaHNpmB?=
 =?us-ascii?Q?EY5i2sh3BAHKNoIw6yzItYWxQYz7EaW1mYU8EQlPx/u+fBjt5GVi5SgrGcah?=
 =?us-ascii?Q?XQPxblWhcr7+kh30u6QWQRaFnX/D6Bebz5EGlJaKYP1S97HYlLZMquyfTKfy?=
 =?us-ascii?Q?qTuVkwf96kN5hDOaD1E4v9Qw5P7rwx9s9fxrGsqoiKzDmDtTcuqrEfuM/K+b?=
 =?us-ascii?Q?NZcW5DAlKrp5CjWzXGAG3eMpiG2sCH/cnxRtfpm7ph/7dGfCEA3pwh/pE47q?=
 =?us-ascii?Q?WhLJ13rDSPjNpLkVnSqPw8hqTibArjc5ApA3+a17HigZIoC5nllai7nBZABS?=
 =?us-ascii?Q?HyXlHNUlHDNWwhsfIRdnaiy0vqAEvKo8UV6D8a434mXKbaJqRWC+fxTx1shN?=
 =?us-ascii?Q?KPcNnu/fKmBGYm0IdMr9lXBbahME2p76L47e923hau7lkPlGU7WKfv12FnQ3?=
 =?us-ascii?Q?2gBIuideOByi4eBRUUlOC2YKVk7qVdRVtLQrHAu4LqeVLGxijaXvopNpjToU?=
 =?us-ascii?Q?FJ1g2G3q4bEvaLKHtkwm46uF82uL2jr5S2oWMeBe7ATZ0YkOQ14qtzuNXgRV?=
 =?us-ascii?Q?t2X/sqMD0RIG2Cm85Zl95UsNU+sEU3SQii9Kem2W3mtPQrDJ6HUE8T43vcEP?=
 =?us-ascii?Q?d89m0eGti/rpk/Lgrw1zh44wEqJjKpRNVo5Qujrh0c4Lo2SXTbiA5Gyjts6P?=
 =?us-ascii?Q?UYrH5r+p/zcMThyGeM9G05nQ0cgUT48Ozpjo8j2B4aLEd7ZTl8pG3mdDsbjx?=
 =?us-ascii?Q?Rofms+xdc+ENOwlG1Rwy703EQcarDfS2iIYAxj9hafV5SYWxt+VzUAv20eeN?=
 =?us-ascii?Q?cxQH2UmMTPdzOT0gKNuzYWXO4VhFd82In8iaPLQNWbSyCNBVedLy0naYZPCU?=
 =?us-ascii?Q?bg0HxcyaT+TFXBcbp8BzbbQ65MlL09CdQtYYCJ/lwGa+o7e/jKLqtR5P5WMT?=
 =?us-ascii?Q?wuKlDRj3UkpTWaTlErl0EyuaJ/xU11ZYdmrUgUim8BetyQ+Pg/IK/M5H+p5+?=
 =?us-ascii?Q?xrDK+JHeD/8AM9tSWrhlhaFAXemT8J0KAJCGI5ykv5qvfFBQg3wNSVni5ZSP?=
 =?us-ascii?Q?fx2vmI0BtTk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCZ2F81JXuQF4IUcfhIKUmF/20rOJCLc8v7GH9ifu2stmC668Eg13mMLU7Hb?=
 =?us-ascii?Q?vdWWSwAFY0tAoduT4cbqCAxzQa5AZnSUxxQIpAGFv/PjqTMnxQMfrF/+Q2iK?=
 =?us-ascii?Q?+br5RfqqeMvBZ4Fs16639Ou0GxCxX15Q6GZSn3aPz068mgJyQffBh4mE8QRm?=
 =?us-ascii?Q?/t2Y3ILKBkja1jvvk/qKHNVl6FOe5x5DisEDzyaWnDdRwd6rk/c1qtt+6BEO?=
 =?us-ascii?Q?6PQn6CWzcUayUwpMC4c7/1Jp/xW+GNvsqh8VvVh1ULPaZb3AKlaUTgz1P3Zn?=
 =?us-ascii?Q?jSjaYD1f4jvoLobgTjtXK5ZhX2FRsdJG58JhxsMKep/pNpQwO4Ivtn5JtJcZ?=
 =?us-ascii?Q?f8Vp+/KpxcvZsx/joCSzUuM32/Og91rgJ72mO1uwJOlfsd3wUtdN6n4gWmJz?=
 =?us-ascii?Q?bKGmB1znsns+Ahu21WamuxCjE2Wdf2ejSQeYLfUWx+cQHTGzPSUFZuUUig7R?=
 =?us-ascii?Q?lILrCQ9MnmjzzVOcHu2zaZBO976nQRg7Uw/CceBr4BZL6JJdc2REvHaFrs8V?=
 =?us-ascii?Q?7WU/xCYrm9vd/DOQpd+tRlxcqYPRDDujwTHau5ohwypN/iRQ2clHFUL00rzC?=
 =?us-ascii?Q?RnJt+oetbv+L/nz0XY4zi1d4SQAiAPXpbxE8oeH36UjmZYFH4X4bFvwhRjEu?=
 =?us-ascii?Q?DAMug8hPBD+DgChQVtmbDQn8l7O4W6aZKGAvlSveOVZkFstAGzVHZdd5Rs0U?=
 =?us-ascii?Q?vMsw3wBpEM+T2ilbz3GHT1sLwJwacnoEAAEIA+pNxCqOGE2F8Yb24yhmkMJe?=
 =?us-ascii?Q?nBZ9/h0uGP+VRKFI/XUWWZknpTWZqgxNn+QJomhiGAxSlcN7jyAdsY0X+MYT?=
 =?us-ascii?Q?y1KcpNGv7iFHgKy66MN3cNvQ/vX61ms91CtOv94xnFACaJf2hGuqbIflIugn?=
 =?us-ascii?Q?vdy6NiwrVwXyCIG1rcQ7OQuseUjjUDev06SlZIh4T5yCpl7mXniXoUE4De+F?=
 =?us-ascii?Q?FhzhLzk+kgVPV0rKaOWboktL6WYzlLAgtCGPpBoTP44ynilBUQJpx2Qq4yIs?=
 =?us-ascii?Q?2AEqZ8Dh0C3kSAcRVQ5d6bZYD8+iKoOvXahwLDSWHmzArH/AKPnNt0n3vwz+?=
 =?us-ascii?Q?lVFbQCcpCS19JWm/9+D0b2uEbP6uJyWayhXY/QTZ65bENVVqN81y1Arbl87w?=
 =?us-ascii?Q?AbxW33JL5F5u119K/4ZX8KeP0uVVutpy3+MyWPy4uSMkmUKfixL6qrPs2FmT?=
 =?us-ascii?Q?30N9piGA2ZVDUVLUpN7Bfm3tRaZusLE2lWX7oqoz7ttvisFZPJCJN8sd+EOi?=
 =?us-ascii?Q?1xwLh8XLeTiGB8GjZ7EmlNAEo2LRSWVMxGNhnYcpoj5cckIK5WPN+2oJoyXI?=
 =?us-ascii?Q?SeF1A2jau96P/yclMr0Z8WBEG2uidgX9IqiozVsKcfWkhXNKEu6YlDzn+JLl?=
 =?us-ascii?Q?Tnwu43AdBJkQcKGQuxqtYQGDLDMhzw3Qwn4DUGphr61CdLRPaCOftwyH4XKr?=
 =?us-ascii?Q?58mYioPtRys6OyDm16FPsmXLRmmdcrUg5fosHV45E/07jpfI3chnpPU3No18?=
 =?us-ascii?Q?wYYAqKXa16i3I/hBbZabtYyBxcuPKWI6KNDTzUNIHRpAHBmHVfO1ukTC2GHB?=
 =?us-ascii?Q?l0S9zURPQE35Goz3xtg9UfBShsekggDTPF3gYxQtkOaDL+rjjWuBTSSLa98w?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VaXEOBaE7KX99pMl4+6+F2QM8q+L0R8S1OkUQb4Dl/wOcQoeCI1+XOVqwck6P+OOzcD1T6qMs7N0p73jVjLRbn7uZ7vABbFW2aCdZMrUCnMkFLhg5rteyvtYdIW1HfeGiEaF6IQ8mpIEPmcIvPpyQAfop4Pvo8CrEMc7sp7YaeFKrp58LbYtMubBsXhVloCQCIGBcskAoHvFzKa8ct8IL+yhKMDv2vDRDdqiLfteyS8J3JnrX+Sue30WlyvsIK0Z3kKme71AK6C2DWvWnj0EAQb1hgOH+H6lmTIA7jc95zcZ2FvKxTX+C2o/uSyt3goHD002ZVpWIV6pX4J4BSkWHUMBxTWjnqW4Yx917dAGkRczP0nhe9JUYDDN40smShLoiD9mrCMtIrTTEwehQh13GMojeaEAdNvbyhlWnUJd6BCWIIV2NDWKyohShgLpbylY+N9D/y95h4Bzph2kkksPrCO4VRmJDiTxAGiO0snXHggaODE8QmeEgAqsSPRhtiy9iCte8qailvnuUpEFlov/QFYLaGJ4YW9Q879ZqQtFCOh4aWlOglo94+/WRqW4+mz+lrJf43BCIyjtnFzwRG2AlGLbFDlPh0RtbK1OGyfPEnI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5108662c-0dc4-4d32-cf92-08ddce5e19f7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 05:09:31.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkSrFBXO5v2AdsYJAYEMKiFFxArch/WsvvqbVb88zBTOjnpu8wZmvAkS2smDg+pYmsDdZbv4niZqk3Zo3o0yNGdoxI5lVynkEkQQfC9PD4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6460
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290036
X-Proofpoint-ORIG-GUID: 4GuB37Mh1Ev1_ee413tuDmQAtT8PuTRT
X-Proofpoint-GUID: 4GuB37Mh1Ev1_ee413tuDmQAtT8PuTRT
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=68885793 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=V92dLS6141j04T72YdUA:9 cc=ntf awl=host:13604
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzNiBTYWx0ZWRfX4xSnSniUfPX/
 0APgQbfnyKeColWLRwlCnmpzUJNljNqqiQjR08ikZQw80Gu6oaA+tVbPEVx7m/OEYuf8MFein/5
 gaEZxs3Ap5V8vudJclGYhJ/Ggdsc2kh1G7DFCc7g5IreKU80NfAVC0LDarZmfJSG97B3yjeZuye
 fQuc0u8yY95IB5+hQF+Vyp4ZoX4wxuwgsCIhZR/y5loMuJzEoZBNtl3Mi2YNAFKg9GL0kYqqYid
 HSkhBgi+pvVNv0hFgS+AkjauFmwEq25oWBNN1/3FuvI4gTdzA0Po4tvqVNQU3tPnfyuGr98tXvf
 pX/YroMEMrM2ZTTW2kmmBHBi9blb/agHn7Eu/mk0jd6p1ckb8uxgTVKUoxCRk0/65zKobIbNDUr
 fOowPK0xh6qkkmP4ek5IaTAMH2LhEmzB1OzDhyhcZGEPNyjc+sh2irD7q1Agemk0lJBrSTHt


Hi Kurt!

> The SCSI disk driver (sd_mod) would just claim that discard is not
> supported. It's not true. The NVMes support it as do the enclosures.

For some definition of support at least. If they can't figure out how to
set a single bit flag to enable the feature, then maybe their "support"
is not entirely trustworthy. But great that it works...

What are your devices actually reporting in:

  # sg_readcap -l /dev/sdN

  # sg_vpd -p bl /dev/sdN

  # sg_vpd -p lbpv /dev/sdN

?

> I have a few, though all have variants of RTL9210 chips.
>
> But sd was too conservative to let me do it.

Why not just have a udev rule which does:

  echo unmap > /sys/class/scsi_disk/H:C:T:L/provisioning_mode

?

Substitute "writesame_10" or "writesame_16" depending on what is
actually implemented.

-- 
Martin K. Petersen
