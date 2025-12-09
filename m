Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D983429A33E
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 02:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249183; cv=fail; b=I5B/zKpSx/svwM2UsxsYvSzx82HvFuvrh2em+U0uKePM9J+1ffqYVzAhf1d+Cqhb/Ngb0a0gVRBknJiJoxuaFf7RvDTPbxO3og430nJj3+Bs8VMJa96apaRGW0ETzU2D1pEBo87JVwYDJhE/bX8qeZIdBBkaNhLfInxNDf7Rt0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249183; c=relaxed/simple;
	bh=05Pju1Y5N5itr5RYw6Mo2bCZsygiq2fTe+7eI5U7RUE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=T1A4FxVM4lbFzKPh9NPywM4mMMi9tf8MzMpEEjrKy1ktnv5o4JtDqU9XJmuY8QBZqnG8M+x/gGAPnai6EbqsE5iIxEaoPq2yohB6AbJPw7Iexu1RJw/EqLR4O5pe5PYrIh0kg530dy+fbtGGCODvG9xW2y8ksdqQAiFwjiyqSkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d5HWumK8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QOd9sVMx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d5HWumK8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QOd9sVMx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92pWeT3910855;
	Tue, 9 Dec 2025 02:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oIlJNjjLcQnhT+rIlV
	PnKIGKLLfe/MZ8qeV6FRJCkwc=; b=d5HWumK89QGHHrQeduqYFIrkTWRd4Hlwf9
	2fxm8CyiyzQHRK9BBHsegW7MmT+LcJ9XlCms0HdLnJ+9SVlo2zhUjOPmAOLtEgor
	7xVP08KFSGL2VD2dz9hy2vZ/5eV9PocCKff45UfBqBQj/luhtTMIsXK3xjytePk6
	mKxDzBicqLEpq3nJif4OybgwVx20w0vecoOHDDQKYXhvPYXskVOO9KTXZJ8O8EsU
	41P3BszN201Y1TmZe3oRO9OD0V0yMCjzMSSqJ9XK+/ZLv6zzRZjw01jRU4gydx71
	bLYZkF0iLi6uX638/2jYJDd0IeOX5CT5kjNck1YZrRi4opyGP//w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbbu804r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:59:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91BD9M020810;
	Tue, 9 Dec 2025 02:59:19 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8hk9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:59:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4TsiSp2FQq/52dZ97F9jZXK8zp5S1FTyUr5+nyqaKxtw5xLusrgO1v+SgKw0GJPy6ywKRX3A1FDHhuVpKLdb7VWjzJ5rDITxpj448pcPawMSjK6/QzSllQtmAdGYIB8/LW5qK79STLn0wuHVt2AyKCsfte4eNYasYnX4Mh9PS1wddgA5XcEtF1tlNVX+47pJoVxz9cUVF9YF2hx8TNdF/i5o0TNnw5n4YfOCWnnItrdajr2KUZR9N0c0608FEaKXI5ectO3dZCeK+OI5AaeV6KJ6knG/hxJbr+wGbPfvh9+H4YVorl7gtCD5pJYj0RROUuJh2NIMhVFWWa3geU5Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIlJNjjLcQnhT+rIlVPnKIGKLLfe/MZ8qeV6FRJCkwc=;
 b=MLRC6WzfMLoq56AS/SJ5VIsPblEURyi2naqoFG0Q2EJWz7L1pksgg/8xZUflhh8cgm4hdI6xKpzI/ritqZVxTIxD7JtGk88JCFhjsXurJRODVXZ+kIPMv3QokTePiE7BMi1+rUy/zM+Jtjm5VZUklYHb8KvsQn9UdiciE5MeYZ4E3oUBQDpucb37zQGcsajS5C/Frl9sF+O1EVhvVpnPMkl62/Ux+kGl33HVQFB6EqCRlcGcNZ1im8TyIoPjpMflC8fxP1KlDYCtOS76wZTubP7dY2bQhtYau2+L/npz5gexgZCoVtOaa43Izs15KpmB+ahti5vpY/AacXU9IKrjlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIlJNjjLcQnhT+rIlVPnKIGKLLfe/MZ8qeV6FRJCkwc=;
 b=QOd9sVMxUd6a/YkUF38eZoMub5sP2cls2R9a1SBnrYyVuLs7QYygbIPEdctVnztRvJf7Rm+CeyecmaiCRGMWTvce8h0fVDRJW0olqNtbieEL9UiOrrUS46YZEIIxRLFfM9wvQdXip4gFMEbHcNQfiur9kz7tniQs8atNOnLEEy0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8517.namprd10.prod.outlook.com (2603:10b6:208:56e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Tue, 9 Dec
 2025 02:59:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 02:59:17 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
        Roger Shimizu <rosh@debian.org>,
        Nitin Rawat
 <nitin.rawat@oss.qualcomm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean
 Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251204181548.1006696-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 4 Dec 2025 08:15:43 -1000")
Organization: Oracle Corporation
Message-ID: <yq1cy4opdhi.fsf@ca-mkp.ca.oracle.com>
References: <20251204181548.1006696-1-bvanassche@acm.org>
Date: Mon, 08 Dec 2025 21:59:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0048.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d1ad765-3f56-4393-e379-08de36cef14f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mc95harBambguy0XOGraq2fjf1zsnSuBvm5xjATR0Q7QORa1fNQfeqocWxtH?=
 =?us-ascii?Q?iE0kx1kJnIyg7p7cHMiFOJzEYIalMVI/almmUminWI2gI9sY96ArM4D6UMGn?=
 =?us-ascii?Q?/FikaxRC+Q+DU6jwziKBvxAvX4y8Vz706IcNXBcHEYETkNIrI1DkrtRWUdzm?=
 =?us-ascii?Q?ri7vk9yJtJds+wM+474TG60Ltvog4MOmVi+CYlap1HLAd5dcj30/CxEoODKH?=
 =?us-ascii?Q?/tQVTX8jQ72ID6YwRWugvN8rnSPo+oqforIScrVc7nd7r7wE0GjQtQszY2ZD?=
 =?us-ascii?Q?BlJaDJgfht9dW2UO+a4ItJGdN3h/xQ8je1T7QiJPSUi9Vbe9jJRnrJtvHM9l?=
 =?us-ascii?Q?8M3mOxFmk3+cHLTSiUCX1Y14lUiOldih/ju+4sYvPxazxAp1QeOvxFhZ/a8n?=
 =?us-ascii?Q?bWZv9bvqb78iNMirrc7G3mSPB0JDzHVXmhCrzD2jIJzOamTCl9BAZcC2yDfd?=
 =?us-ascii?Q?CQb3b7oeAkwDxCdWkrKPshPzMdyzctKYK+euvhs7Z9QCMzYLsBF2jIQs56Me?=
 =?us-ascii?Q?4M1YApR3M/C7tlbF3m1STMD3HrypdO3erkxfORG64xRtQcblk0sab8RTuvIO?=
 =?us-ascii?Q?IPAqVp/WJpwG38h7HEyqt0KiHhhJkT8Njvkn6a4FLxAMizVzHuaJ0EXfIkCW?=
 =?us-ascii?Q?WXNYKr1kW6FUR+1TVSXdWysVmk9JqdNrY7zZnvppbHx13jL+UPTPbGoDCW5H?=
 =?us-ascii?Q?DAGITLQcT72r7bpTs3bpQEve80/kWjot2ThkE92M+0R41IUDVbI9hRGIiL0o?=
 =?us-ascii?Q?xTB67EnEn4cTZyg+UKMhY+1I3OnA+UmwS8lEYioJHRBi5VjQcLQaaDbYeO5Q?=
 =?us-ascii?Q?ZMZzepJPGCDifXtJTSulhVhPxkNxtdvOn9kFpee/Po2YeowtfRPbBxHJhuEn?=
 =?us-ascii?Q?aoXZSHLYDlm5KmEWUIpVGF+xrORRCvCFtRkXuwM3bUKZmxcO0wwEZQF+q14s?=
 =?us-ascii?Q?UMj64A6OEVKcKzdoRV3YUv6s/QJkVcth1V9M8eryyIvUEV/Msytq+JFasfi7?=
 =?us-ascii?Q?O0+wiLeNkKvzgmMstdXfmaUpNpKfcyNQgA/Jg7ItPE636n5G+R6AauyiGne5?=
 =?us-ascii?Q?uRgPruSsBua5DyD5GDyiEhZKbwWQu33RnV6JX9QvORKHAO2rA1AsRWdIgc/C?=
 =?us-ascii?Q?krqpkuvJQ1ZQ8tjCbWhx9A5uKmrfLnut1UecD2Lz6UMOlqwvNEravFUaT/vV?=
 =?us-ascii?Q?qoTMkPN0MOrUcFPNqgahyVbTzB8A8sgrkrPPnBtIfc0DMwIdnegBqrsJqceJ?=
 =?us-ascii?Q?MWHW7WrxqfWQzyHDDmo5X8DUs/4kNSYWrWIuZb/OEY5oXqs7voANKNIjeAOV?=
 =?us-ascii?Q?VDYk3XE4azGwS9NOBVLYLfZ16QUCL8lIvbZ2wr9z8wzz+/5GTT5itXQs5jAN?=
 =?us-ascii?Q?yXfdKFzJZT7vrrUewxOwrBphDYTID7L9WVrAfQF/T6UzfZSjI/OnXebHpRHk?=
 =?us-ascii?Q?Y2IjJViUjqKCSa4lxvcZHfEhO/1DgK5E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gKX4vHYtehI1t6hE0gHK7mQqkWBadC7kXYjZSJBDWAsFt4qJH4hIWAuRSXBG?=
 =?us-ascii?Q?isq+MrqBdDMVRkUroYlviL0tjgSnfKfhFr9IZnON82z7V7F8ztxkPCHLVqWe?=
 =?us-ascii?Q?kAjIA83INuPQdUZ3o6r1knwL9THrMZ5eXRg3eK5qMYzbGEMFV8i5uIxpaRFu?=
 =?us-ascii?Q?YbLFr/KtM02lVLHi/xzHv+gE76PN/ljXkxu8i8X+xShqQWuGOvrckqgy3/at?=
 =?us-ascii?Q?f4A1UZW+QWjzkHx3uYHHptLOcCEmReVHUR0j+lzXCpssIB9+yhaxkhpPYQzW?=
 =?us-ascii?Q?N3btVL5ehbRxrbNQQ3uIljm9pOihyIF+JxYmr6/YoAGGLcPIcAHCPfYD+4UX?=
 =?us-ascii?Q?S6V/wWJzXUDotx0BcJGppjBaC2poO+juNk/fBQNS1MPhvPiynIBVnNGvAPzm?=
 =?us-ascii?Q?eQsj4IysQROuYhEoCw0s8cjgGDXzNCmzRimd5TGuymxSdBvt145We7Bhlf94?=
 =?us-ascii?Q?Nbosr0nq59WatUd0N/6Q8cyzivFBhjGflYcCbyjJ1Vkn2Iww1nq3yT2yzJHD?=
 =?us-ascii?Q?byiju6/nklHmimUkKgU6uX6e6vUyUpeKOfHOVi9L5T+mmKuRMbOKsYozaApB?=
 =?us-ascii?Q?JjE2vRuazwB498/aqQufccKcRPzkreqLl8pb0E7ZrDqXCvyPSRaHuYjaACb1?=
 =?us-ascii?Q?l2ZRHJXfAj7GdVChw3226vaMvDEOvG/IE/GqNkPIZS7s41xiSXdL1Bhj8yuC?=
 =?us-ascii?Q?L0gMgd62OBvyyOODnRe3KgQCP6cyP0UHVpAQbfJ2okCILNbS5Plk52Oe4FbY?=
 =?us-ascii?Q?Szi/xr/oZ1ACgKcsPyYriNUDxD4EZuY4aKY0/hikExSnHaJWqtIvC+nQBkk8?=
 =?us-ascii?Q?2yd6ZzwEDvYEPMX6WZXub+sKmt2Ftqhzj0gmg9rNFwToEoD4YeERn5kWXvIt?=
 =?us-ascii?Q?En6mPDWnSVT8VrUIor2gdO52OICtGbUanYbw5XUDOVPdeKbMU+vzpWQfwQvE?=
 =?us-ascii?Q?goOCz6EKOZGUu4VtvEWCp4oIiGvZSXvSSNSbENSSII13EIJayAQeTbvp9k9Q?=
 =?us-ascii?Q?sAX66Ssmkkx0QmN7/x5lwVsT8fUb1K8QagmaDSlCEVtfTm8scwGJNC+esXOM?=
 =?us-ascii?Q?JqoQKGaZEaxD6LM6K8aGkiH18OzjjAaHndRO7F38oPufX/RzQkutD3kg/t05?=
 =?us-ascii?Q?NFctiAb1t4jFxJAcCg4O/bWYf6Mi7noJ9G1caOY7wzL0O1W6FzQD0WZ5uIz4?=
 =?us-ascii?Q?gbFbgn49E68nlIln+i3wypdz55gP7tndltRYrpnKDNBI/vxQdhKsj5dRpY9P?=
 =?us-ascii?Q?kEA0asGpVweUv+BM0BWHZOB/hvvn1Ut1e3FqvE49f1X6iQz2o64VlNvwy9j9?=
 =?us-ascii?Q?Ry0X2O25UGtllWiTKh/xlncXe2b251ug5438/yQZwSxWYufMJWCFycMzR04D?=
 =?us-ascii?Q?0mqf8aGXgby45KI9N9d82JmiS+wktiYetfW4h0JskKPIcAP7o6VODZXXrQvD?=
 =?us-ascii?Q?0PzIs4dqGbpm86sfAiPPBgQ7HHT8h/iXBXyP48Y8HfGDW5dk338QX/bxkhtg?=
 =?us-ascii?Q?5OQypSQoi8Vf9y5yezbqIOlLrT4csixpjk2tAGc00TzEyxKqDTajdNMYnKuY?=
 =?us-ascii?Q?GOV7Pfm3suZxtwKJ/WT95ordcFwLmfoK9prH6/utN4k6q+kwpx8RcyJQysYv?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R/WmX0wi/1UZ/4OUXIQKd5XMpwzJ9VMVyexVeWAD+kLnC4472aJ5PLig4UTs2q+yljOzHfr8UItIlrnLy4zBbsHIMiMheJINAI2ZmI7ClXWJTMYIuIXSJj2D8GQK5SszMuHkTz8RefdTkt+LllSIe+i0l+yilsxc98kVfmxFaEH5ihEmMolKB5Fj7httRt3qIIRelOqfzXL+UrSinBt1LjeU1VHUyLN39MAEgoZ4L6LIst2hX5Agnsp+bhtXtH0OzRuQwc7bcr2XZVC4Nf3BT+FLLEW5zWtpBeReh5eJOb7QlZTcYLJx4VqIqAgme0TpO6sSK3VJ7E6bXd3Lao6/LzltGVw1bfMBLdH8u0ax87Lun5yNUimAVpmtRYvV9LQ8t4X1lZQA+KSLnDHi1GcmDk9K4hRFPGe4OEVAlhHdrBbzKEaGvLoK41d5IYysbcHdiWnP7zmw/ByQXWHRX9vLiAmbgHbGLowWZjUb7AIsixyE0YMuKA2FjsGcwlAsEWqJUfnvqPg31GN5UYcig6gyxSOoUbEWpbCglWAvMARMhIhU5UWitE3sOUyYWwFXXT7FW4kJn2y17ZekL/7V2Lt3n0QzWgdG3LKw1wG0WTUgKRk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1ad765-3f56-4393-e379-08de36cef14f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 02:59:17.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hy1FG6JXtet9qMDZ5jqAkabcgmYn5IWarKsmsYghUbG4Pk8eJNn4N3TWuWxaL3YBfdlErAH0HX1pHgGKdOp/UkGnaBA5BLbrNt+FOH1gg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090021
X-Proofpoint-ORIG-GUID: rkJtPmpxt3VDjvZE2TNn7UOYQEH0gN_M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMCBTYWx0ZWRfX3B87qLul8OYI
 RMxPtC27RcNwFU1OkeUoPIEeEddoRW6nwwL1yENGmXvvNJxmQix11Z0fPVywk5+M0y32N2SeVE+
 BTAOjHLHO3rEA22K2t7K6iu/JTtvQx0kwAQIUjN90TAKoch2rDuyOLrm8gE97RtwdnWqE1YMrf8
 sMQ2at/BDoMFrqlSQHi0YKJKUwDqLHCTuS3K0Nyz97disGdBcBzEksrI6etdn8oDCfrHH9k7pJj
 Z0jVdb90F/WrouOcVIpknZyNGHmKVUizWsoFCBkYiUXm8bOZ7rHltbvP/J2d1ypNJEGTo6q1Foo
 /F/YuucFDqSi6lgdjN9294RCey0ZiuBCAa+nUcxOhGceKLPAPOenrI6FZzZKASKudkgTTxVYbkA
 u3x4KZuv09LVft+AR3CKTQuzuGCnnQ==
X-Authority-Analysis: v=2.4 cv=TvPrRTXh c=1 sm=1 tr=0 ts=69379088 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=sMDEUU3oSzSlzYwmmHIA:9
 a=UzISIztuOb4A:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: rkJtPmpxt3VDjvZE2TNn7UOYQEH0gN_M


Bart,

> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()") accidentally introduced a deadlock in the
> frequency scaling code. ufshcd_clock_scaling_unprepare() may submit a
> device management command while SCSI command processing is blocked.
> The deadlock was introduced by using the SCSI core for submitting
> device management commands (scsi_get_internal_cmd() +
> blk_execute_rq()). Fix this deadlock by calling
> blk_mq_unquiesce_tagset() before any device management commands are
> submitted by ufshcd_clock_scaling_unprepare().

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
