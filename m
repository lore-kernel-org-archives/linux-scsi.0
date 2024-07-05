Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD1F367
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720147921; cv=fail; b=HYeCEbJkEWX0iA+7yXM1ppEP9Ki99bMdWiSe3oOp78nWezQ4pnGchgscGis07kobJHCz1TFyh9kqCJJYfUWneDPREBgunAYpjS3b7iONt6KuASRWL9KKDXFmPHxQZC0fukgobTwPPQDEJWoed3iROpAU/7ypqyHIbuJGUsdbwJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720147921; c=relaxed/simple;
	bh=LgJjr18FacxAfhfcZtJMGPCHQuzgnxnbm8XemmpOi5I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=shQytzxur1hHe03yBgsOu1gTSs5+EZElpl34hPSJ4cIVyVE/YQ8J3bSScw/givlr0osQGUt0F+PZLo7p6QQXrSmZaFZpWPs4c4gY05ChB037+agevwkGFKkaZ/rL6qqnGD+jtDQW84QqBpAr4ysrU33P5dlfvXFLd7MzP6GqMrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dfam5PVE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G5NNoeuU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dfam5PVE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G5NNoeuU"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464EAlwQ032216;
	Fri, 5 Jul 2024 02:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=B86ziS/nFByYzc
	A7wXK4YzrMRbj3AbK0DyRYaOFOkvc=; b=Dfam5PVEIQxO8wuJAkwZzbSNGUgbzJ
	ZewnDdqIq1L/iY99bt6yyDQURBqkb0IB7Q4FBKpGjVqxRq309+S5oeazU6oxG6t7
	TYg9zHLIgR+25nvCTRzHoB4gwoPFnGi1M2mKD3OTO47rtmLjuLqRN8eF/dh0+9dd
	gomg7BbBZsiJ84M0UjePlq64/wBG+lYDZ51ftfpE+6QoTuVFv5OtinWXgBnALxKa
	bhAIyD2fm5qGYyzA24NFDqhWSxmAklCN4knJ9MFT44MG4WdZ/nNwgx4RvZQaQSmS
	PRPSlhGmWv5/ghSY2QT8x6POclnfQLa3Y7ulqN7tpXRmjwT5ni80qH4g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402a59as8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:51:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4651WfgQ010887;
	Fri, 5 Jul 2024 02:51:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028qawtwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:51:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0t5opfZuwiCJmPuLzd3ZJUk+F0Gzh4u4+WKEsEE0NAoiHjdzcZIzuTem2ERZYr7UNxzafRywwTpqoR4YTiahkLpnteMLVb5Ybbe+WWLCYb9o/J90QLKVy/GYSuN4Flj50oY/HFqSMsrhLRtGG9RuzYBhzUhcRwoDJxzKBbMdgnECbHgOyoIKLHjmdReP1Pqb2RIL/uXnIhRbuiYVXj9ftp0BZqxSmIOnIsgcg5A6RH31MX4PzBLd8Wl0aer1ZLGg7yBTcJCiGMhtWCJKsvW/hY7/9gv55a6yOxwJKxNC5YLSfUGfhFvYcPqBj4qCdpwpmtpY9df46TyxQZkOuFisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B86ziS/nFByYzcA7wXK4YzrMRbj3AbK0DyRYaOFOkvc=;
 b=SrBcO7rovBqq3fqDv2MJj1mL7vDIf+nmbcR+NHle/9i1f4VDdgUXiKdiLRNaO4KqggPMiJQqa7Tcolj6Tdgz6LBTS4e9xOs0KHpXYMcxcsrLiswIUk9mLdnwzvo2EpV0wvJOmNkxaLATABGyR6hMrXCeaxFPDW9dT1yXBOlK7MF9WKhOE6nHGE+Vbr4LbHKG5qqw7mQyO/bmbk6O3Zxylx8Tavx/rTBhaTexhW5DLpRadHwgUsifpQ7JoRznMk0lWXzsdNqtnqUKFRlc4cXahxmc7A1IUlqF2KqWHlNL0NqRFLcOCdlRgZORJiBWicqUXq+OhbeEcIm7wg1mLp6Hxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B86ziS/nFByYzcA7wXK4YzrMRbj3AbK0DyRYaOFOkvc=;
 b=G5NNoeuU+BfaVsnIdM/iJA3vfD/BmuetuCP3ALs2ucR3zLrX5PZAncBcAgiaxGY1LNGvB8OId/kl6JNjiD75+INVTfFnvcUHeCeS6u5nLIuh/OWMlTjIgCMVTThAH2nvDKWDPDzDe42JCUBzFWovwWejD0BhxXNI6yu3aUm8O30=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB8106.namprd10.prod.outlook.com (2603:10b6:408:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 02:51:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 02:51:52 +0000
To: =?utf-8?B?6rmA6rK966Wg?= <k831.kim@samsung.com>
Cc: "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,
        =?utf-8?B?7J6E66+87Jqw?=
 <minwoo.im@samsung.com>
Subject: Re: [PATCH] ufs: core: Remove scsi host only if added
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
	(=?utf-8?B?Iuq5gOqyveuloCIncw==?= message of "Thu, 27 Jun 2024 17:51:04
 +0900")
Organization: Oracle Corporation
Message-ID: <yq134ooblfr.fsf@ca-mkp.ca.oracle.com>
References: <CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
	<20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
Date: Thu, 04 Jul 2024 22:51:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0438.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: ff489785-1b1a-481b-4781-08dc9c9d6cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?SVMBjo+6UPeqWtu4H3i7xNJH1W7SDCDHFZZTqPNv7BnaJ+xOn/Fspwz8UIee?=
 =?us-ascii?Q?s24mR5HMDjwW+M3HMQdYC9uEtneFQj/zcujERaKurlK8XXyMGysnMTdvW66O?=
 =?us-ascii?Q?21f1Djw82LIQpGZBJVBw++BTEYFyvAh+SOIpd+rhodiJTNxwMNUM9/QLZeIU?=
 =?us-ascii?Q?FsBK62+s4j6cBRnqe+Mqfos7KWTsqQ1roY/i8IzDmzx0efFd0HQnc1yDJN/3?=
 =?us-ascii?Q?bYT+2+W/H6kLaoHzcu0fMzD2IR5682xMK/a7bG9iezqGoUKvPHdzZpXTg9zu?=
 =?us-ascii?Q?CorXFINDssNnkZV5z1SB/qcVgIOWxoPnjPTdANfGK2qSPd10BI9hMcKWPv0O?=
 =?us-ascii?Q?4Ef4pPM3HHgB7nVh53Qo8ZE8FJ6Qw0qCO9HecwoAxn7vIwb35OxsgwHD58sX?=
 =?us-ascii?Q?YYi15QPXZGiKtIJCtusT9ggUO056AJrBdbGRvzd73nlkZLi34u10cazTE9Ci?=
 =?us-ascii?Q?EaBLVl4wOK12DAWj0V3pNyi4SwqVG6F8zcCDvYYNGRf92jUI0eKOxzHd32nM?=
 =?us-ascii?Q?B4FCO7iHFZtmPArj5jpwFkktFbEmvkn0QUgkq8gGrktA6/TI6J9l+TVa7W3L?=
 =?us-ascii?Q?ToaNYD70Uw8taFWYaaRWuYFGi6tjiF4X+ytzdW/eJ9teqRAmsimUCW9oepqU?=
 =?us-ascii?Q?pqVs4U8k2e4Z3wV0w90n0fN4AnbuFzHQx66VqfpyAblQsvoYML4GbitQbx2Z?=
 =?us-ascii?Q?x+zXf2vBtm6voydEvwhmP74nsZ55ETaRJvA+HmG2r4/LOUjvDEYi4KlF765Y?=
 =?us-ascii?Q?+Xsy1FSTB5m/4xzKZ3VbRzY7/+27YvBZTYMfTl5mP9LBNzUl/9A69DUnXvxW?=
 =?us-ascii?Q?p8Qi2LvBYnQW13R522u5lVEtNRHaLJ1Lnz5CT+iBmVUT3JHRk9sAWhEwYRi0?=
 =?us-ascii?Q?WPMS+7JSY/3X3xXc5TQLouGaKD6ObQ065BWEnDEyTci62ir4ZLkA0b6PWWPo?=
 =?us-ascii?Q?MVeeLRjPavCCPeeS6F1oFyxOE0LeFihldea5hVATocbVQ/oJcMXQDHZ6Dhwg?=
 =?us-ascii?Q?1LMlUkqDiktxQeITMMonyCuUJDnRl4YvAn5si/bWFmomCM0QRlLkS3xC0B6A?=
 =?us-ascii?Q?Xbfk6h4RysQw+Tk0Ui0m8dRiJyznz+XfDrUrL33m1115i68/ke7u70QAR7GE?=
 =?us-ascii?Q?IIYbSIvYA8JWvJ0uKYHB9zky8bqPUsd8Frp7o8mhBqAg5U6TWb3Dy/MEaYUk?=
 =?us-ascii?Q?/9w7ByQ3g5B33zUFOUdYF4ZxUO6PLPS5p88hDjF2K4jU5DRma9PkJ+HC2nEz?=
 =?us-ascii?Q?Isq0U21tdWcJr58s2qU4VlvY4N9qFxtmLU79YEbzSxR6vue08OKRpUEKsvt9?=
 =?us-ascii?Q?G8K00Hnrg63OPXwi/k5nacmGHz5/8MrTqXJKVoxBkeHgJA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hTBq27KBbfKo8m7Zul71aOnI3VXF9rImq1BcLVZPM0ATVSX6RJRo5/AqOHTe?=
 =?us-ascii?Q?O7r2nEhxSAdeWnWHhQ3vcvtWHwx9PV0Ak3AulbJxm5uvAba2brySatYw0NCK?=
 =?us-ascii?Q?toH/xSWnOOTScEEdw4mGhKBX6sLAXFvtHiyjlDGTvU/kXd/5IPpvlAq4SfVn?=
 =?us-ascii?Q?R41rwtIjvdNDc8pN8ZFcxqK/0HKDO1/pq2celToqFoQ98iPm/DVRoyl3oV0X?=
 =?us-ascii?Q?wWYQeMPsj13NP/1b9MsooWhsSMLmTL/n28lXE3rsJG+Yb8RKXOqCLhd8/dxz?=
 =?us-ascii?Q?S3fGHyF1LUpVq9ZEN/Q8eXeKrGQQNwvVp7blXrgedEenX9K+QIL92rF5ZbB+?=
 =?us-ascii?Q?ZuQUL+sD1AYP882yqScwBUHyQgKicpLR5rXmZLdBmUmeYPeVVKSrIl+bqDHv?=
 =?us-ascii?Q?VRpTMJdxM1A16/7MydhM5mcr13J9icXrsqQlxYWmUVwd3nOzzliKce/rzI5k?=
 =?us-ascii?Q?9ZuE5lkzIbCECwVIMCg+jcGbmqHLS1vJmV095/tSYWD4YJQVawY4ik839J+6?=
 =?us-ascii?Q?vcJqWp0mdlPCHc1EQeEaehcIwAo17K6+VG6UTzk9bKP+NzQ4/tgDS8j+G0BV?=
 =?us-ascii?Q?ShAxohH1qsQ7WNEoe6+I/96Ixrnp3UGxrlugCGy936FbrF9Xg4Wr8h3KdMBx?=
 =?us-ascii?Q?4pLANEAQrzQuwzDz3tuzYfaD0BgBHvRxjBN4pBRhe1PEFk9jUag5Qvln51AN?=
 =?us-ascii?Q?Pc2LbIK4YGG1BPL/oBSIJAyQINbthcXIKKmv6lMOIVu6wcY5GSv/glksE4sO?=
 =?us-ascii?Q?1rSwOVTSOstUgMEqqv64GoQxaG6RZ5rp6d4PDikC+AFcYoA3KgeCLfnS1KI/?=
 =?us-ascii?Q?fgJWtpxSg4DcT6Y4qffx/Z/OywjDzbOMqqlP76i5mP/cLz9ehRhYZXw/LBzC?=
 =?us-ascii?Q?3s61brhiB3PWYB3vkMLc6n2llNkkfOPXpraiq02cf+ZZkqBrRARuzmWrgSeG?=
 =?us-ascii?Q?ImA4/jwsPhwAYOYx7q3zuPPtnBbdnAYnP6Rvbghy0gEtPjaES1pey3pXkph1?=
 =?us-ascii?Q?mdpjdTeXLFq9WpWbizZe+jLVhylCaSsWKSN/8EZmTIRxye5u+FAHdhJ/Sk5Z?=
 =?us-ascii?Q?z96D3NfH4mrVh8q4JVh3tbpiduPl8MAHXSTmRlaJKj4eMc0IQiwcqxIthcX3?=
 =?us-ascii?Q?AT6r02S1yZWLwMNk4EPJf3tVPK3IG0zgvglJ8GB6gHWoQGWFLYIs9RYc4BaV?=
 =?us-ascii?Q?K6CbqwJ6lKr3aK8JI19qc3SjnoEf8jeKBIe1RjSrMQJgAWgoSn7cTSmcFtm8?=
 =?us-ascii?Q?J/RHSjGt830zCGwn42ZduoLKIIU/Q87ycWnq52ByLNIZ9PU0rLy4TJs6xFud?=
 =?us-ascii?Q?vntu6d5ZifmvGxroh3UdS+eUbxGJ3/RfHg0ep4DgLegU3NCYLj2oqF1ApdpS?=
 =?us-ascii?Q?940SOVGb/G78z/EAeLiM9nLgxZWryHyrZBF9mAwTy79DK7nkLNPnWOt5WU4B?=
 =?us-ascii?Q?6ONIdjxAHQ8osN5Rm52b6dIkjQlQnIFiwx2Aj3gfhJ8vdloaV8LJJgg1OMbS?=
 =?us-ascii?Q?aGdhKGqhWw58ywBXpJw1+imVMJ8YnT3UF34RxNuJqwIoEySEH6ANSqcUwSX/?=
 =?us-ascii?Q?s958skQiiCczsOP0gOk8UPFLNypQfOFKcG+X88YjUBNQwWXGYPLJwBtRmhES?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jUGutT7ric6+EiM+IrYTUNRD82RceGU1rkbgTjthcZX5hZnJDcLGFCBeUBoZ3sgSZR+AgnygSTLhqUJJbzjXtquy45t+Chy3BEFEvmgJ/OLNdTjwup/EijDskyN9QznjEhhKyNzZPIDhqL7A8r8EfVdmcQkmeff8xEaJYhpvEERbX1OayW76tMrhJtCtQCv016h85CkFjyzh1M6KaMW+4CXIjza7EDnhxpQXeIpPL8Ece2iy6fp7XsEqboRtudUuNvLDEvja29LGYG6BdfRsJQRsmime/EqpC5nyN546EB6TeEMyTU5H81jqi0XhFNWDohGWGwBG1+5t2wbzAaFJRC1ekO3ZbNSmNprG9Hg0wkDNXiXw/5uZch2D0rJfrxqlyb9LjkQWU8Wmex1SM2A2LPal1q0Sf8HVabAOhbgfYRJTiGQV7I8+V4Z7tXH/g8E2YdaRS4rnEq3HfxMl/3x1D0sydD4rQUJb/HmGyUEg60pKPWqFyji7QWX2FBtIivcogg1M5WtdDaAK47OwtK1fyZ/G+9enViObPTfbi/x0zAaED4JWEun10YGTvHCUhkNcJfWLoYwa3r2t7VTG+Q5IArUhJDTZypX+r2Gsji+SYY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff489785-1b1a-481b-4781-08dc9c9d6cb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 02:51:52.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gn2Ea8bVTJfad/HHxdTkxbF0LpcJvkzbny8Cr2OzUIrkA/cB9FmRqorMBUGQzT3gM+Ufb6Zum7dCic51c5/vGZ4tO+IHhtlqMDx/Jyfqzm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050019
X-Proofpoint-GUID: -P10lOVp77kgyAfiMjPVR2hIWE-9wvg1
X-Proofpoint-ORIG-GUID: -P10lOVp77kgyAfiMjPVR2hIWE-9wvg1


> If host tries to remove ufshcd driver from a ufs device, it would
> cause a kernel panic if ufshcd_async_scan fails during
> ufshcd_probe_hba before adding a scsi host with scsi_add_host and MCQ
> is enabled since scsi host has been defered after MCQ configuration
> introduced by Commit 0cab4023ec7b ("scsi: ufs: core: Defer adding host
> to SCSI if MCQ is supported").
>
> To guarantee that scsi host is removed only if it's been added, set
> the scsi_host_added flag to true after adding a scsi host and check
> whether it's set or not before removing the scsi host.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
