Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC9B40DFC6;
	Tue, 21 Apr 2026 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753443; cv=fail; b=jl1qho6yRHop/V/fX09zQr16tL66O30fU1QfDjWri4uARaP4LURo2p3UH5vMeFejRemeNEkYNXhEypZuwY/MEkUWgFs+o6z7b3uBhx+JixXOwkSN6sKk8gyFunHI1LLmtJpo0vzI6hGsRqVCx9iTQfj67ZzpaDVbA8dMMfGq2kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753443; c=relaxed/simple;
	bh=dqvJpIZ5ERDmdeOmzJ6FWoRW/zBcru3pZ/TZgJgIv2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lzrOSV9daqJ5OjpgEEGhciSYFvEUxx7LAnaob3oqz02DHFcgYrdZYTO2tVTbcxsLwklr/bvRPYJEiCU1ktjIWWQucLvNkElVDBWlDWuVZEbIIlwzRQI7U6HRIawDWZfBULPNmC+mCsbkr8OBgaNUxD5t/L1oy9Yt/JNFO93+Kt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Lhl8EdSb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VLUzXQn3; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Lhl8EdSb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VLUzXQn3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1776753442; x=1808289442;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dqvJpIZ5ERDmdeOmzJ6FWoRW/zBcru3pZ/TZgJgIv2Y=;
  b=Lhl8EdSb8NW0pdPYn2Ox2jyifqTkLCjUr/93zIo0HOObphgC5fR2UmDu
   6UR5nBMSfPt4opaGoFeXj0bOVChP3CgdfuKWVhOALznZvXrSbO1Tvw82f
   BOPULcclxLHVENfQ37Rdvlc5BfwYQ6Otu2WUK2s3H7rV0jNpYtxkZQ4FY
   LLXOqR+nwp1B2vgHH3TCfgQB96ddLaUMkgjw6/BC+0fPffucgcFNRKNk8
   cx9Y/9AQz01zbxs4ENJEnf9nhDWcla0Wu7oXNKW8PFdYnDb9DldyDcXqh
   g3sGdWsHE/8sMvfiH1UHaHWEP2bv1MUTp5VMUnHU9IQpwkrptuD2M79b1
   Q==;
X-CSE-ConnectionGUID: wYk2TSPrRNeTHlv8UL/ooQ==
X-CSE-MsgGUID: FiJTI4stQLqw4KEBg6eMGw==
X-IronPort-AV: E=Sophos;i="6.23,191,1770566400"; 
   d="scan'208";a="141149431"
Received: from mail-southcentralusazon11011023.outbound.protection.outlook.com (HELO SN4PR0501CU005.outbound.protection.outlook.com) ([40.93.194.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Apr 2026 14:37:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SB6EqA2DfNy8pzp0PduTf06L4NZaXgdgbz3Fbs1bsQQeqrkvltG5m4Qr/IauOpPKfY8QXgqTYQRmket1Yt9c0daRM5Vcaf7uCISnhIi3hsCXOSsuv1ssStQJzFVSqU4iJDxMArdUVIX78lj4d9dgPomKuu1KFcseFXPDaVcALxyUdDIXnfq100eEl8+gydJ3jppgTl3r90JgRvX7VVPHtAhy8uwcvlgXVw7NhUCbewA0H4v4X8H0B3wMmzfx3iJmZKa7gyYVdYmTSBw6Wkmczdsmo4vCWmkZ5P2G3Ktm+btwHWx/6SkYE4K91ygFw4hoGiDgGd4YCxsGwDzPKMYNzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jwy0ErYhQwDtkS6lU3uNj5qgfy89MD4OsWQOU7ZwBxM=;
 b=JolbwG26mz9hkRalvbv0JDTlBZaCHpkzLLqRELbSnaFSBucofRitYJSKKLuKUa+Iviel9G6Cdjel0TmIl9lKZzAxB3XXNJa603qx1S8GTBaUGa0Nn0RXEmAUvrjRUZdpegZyhyMqNbCcoXBIFeFw61UloMhXV2oNqtW/ht2yUmWItoN0O9WV4gjHxkWvuTskpd7lMUbFAFI9NBX71BW1WFJuZNzO7yFnfCfhpDQ98N4QIPV+kqOKhqAim/jr33KW62taU+09lFIl/YFoaiydjWSVPHGNWn143XsQrtELkjIXxkKMifX9r67m8qsXkDfW0nNqAj2s7Z0MDufKukhIzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jwy0ErYhQwDtkS6lU3uNj5qgfy89MD4OsWQOU7ZwBxM=;
 b=VLUzXQn3eB80Zf1svA7ZOEmD5jGlIKBIU8lwiDkvFXjWNMQEIm5TeR2RL29CIfT89dC21uxfii83YlzpAS8qhHjQZZxAWSPY6PPkc1oMJXDfa9Ttfe+Bj1AAStg+E1A/vS/iaOrNToM500ZKsFK3RMNvmee/c+gAiUd/8dK86Bk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV8PR04MB9223.namprd04.prod.outlook.com (2603:10b6:408:25f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 06:37:10 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::ce42:7775:2df8:8729%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 06:37:10 +0000
Date: Tue, 21 Apr 2026 15:37:01 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"sagi@grimberg.me" <sagi@grimberg.me>, "tytso@mit.edu" <tytso@mit.edu>, 
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Christian Brauner <brauner@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>, "willy@infradead.org" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, "amir73il@gmail.com" <amir73il@gmail.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
Message-ID: <aecYTEuYcQasRHQu@shinmob>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY77ogf5nATlJUg_@shinmob>
X-ClientProxiedBy: TYCP286CA0110.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::17) To SN7PR04MB8532.namprd04.prod.outlook.com
 (2603:10b6:806:350::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR04MB8532:EE_|LV8PR04MB9223:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f073c1-98da-42e4-a280-08de9f706a21
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Pf6iiOWQpH/kb7FoSugH3hPVXnp2Kn6Nda0t6FYzsV7MR+2w270F2yQXTZbj23w0VFngMuCAaCd2yPd2OvHNPIMh0MmkCS3q5HRCkMn5kLNUQDggpFErwtmega5eFDKRPlLxdYce2mK1knaQgHZwoCoIa6bOXyv5SspPmLQSPi1wMoJbN+bmM1bom0ub7K4XDyF7zET5LvaW5dOrj79p7MTeDbccDGirx8YQci/zN98f5pODNnaapuk+urSQRy4LLHsJpVFUUSZUmIc2F8mscFhXKEWvcn7TjXw+qC5zfi/c9jsppzWmd42aDAUfeWNhFFLu3pSIPu/GS/N9XFT31ot4rxNAy8KS/QuzRO3Olc+zFzd5MACY2A9bwy3r+kfd4zgFJQmdEw4fMbHY/qfBKHDAKt3PPOLUaySOud42xsAgqrIRvnjOs201EJjLxu5X6+mAQFbRy0QqN98oe6D9T/DERdVrzmI8tERWkQ4qCP9eq8xS7dfzzc2JlWtA3rb1H/P1jRLBWrP4M3NGq2GZw8PqcryCW65RsYQkfwOiJrumz43u/Uk3NCS7T6SZisrevOC0/JPQqayclKDmOaTVg2LSb2F6XiWJX1QkBRpw9OjAguJIC12YTi7wITFlS2zZBb2Sa9RhfGOYNPlODAi4+H0hcWOa/rVw/QfkOX6JrkU1YF8C281meuXuz8pAFIlNa74yXxrBf1wMXbj8FBY947bkBTQYqs4nFxGSKj/Q2jhj8NBlgybDblyp3nSivun9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rqH38QM4TWvR3HtVJrH22MPVJc5sft8n3WZthieGV1KiuHzpg8MMVbNi4/su?=
 =?us-ascii?Q?3eT3iPqOx+XQE/JZ9co5vHmF5CGDwZPov6Kj0WtJZXWHAK3Thk/kMEVKy6A7?=
 =?us-ascii?Q?Id2zGcBWEotuezZP7vDp5zdDOqDvZEDVxIV78dy9fQth+CuJ3y1CpEXL49gy?=
 =?us-ascii?Q?ElDRGuiVGD3KSq7og0m8paDgRYFKaVtTgLMlaxA86Bf0UuqhIbTtALlGzfnh?=
 =?us-ascii?Q?Ok5Xplc2K9q8nfpxOTLMSJDNkhgLbuEc7vu6p2ggmvV3fErypN45TqH1dyuc?=
 =?us-ascii?Q?xwCEGAje2TZcq5ZyJbfVT4s2ufBU7KW+kMqBqqrWTmRPcd72HNbu81+dX7oc?=
 =?us-ascii?Q?VRmsnfBP0IJwnMP/RZ4S1ntptwqBKwhGAULo9MKfm/DhTywjEfCPkuNoO2Nl?=
 =?us-ascii?Q?nhwVygpMSmDCo0b/H1ku7Yst66r1hTEf+M8hOT6URMwKbhzh6OxNBoUCyYBb?=
 =?us-ascii?Q?+Kgv9v5JKwwmucZ7iwDLNzjRvtdVM3EFxDtGB+zkemRvBN+No75tsysSVcfM?=
 =?us-ascii?Q?6yCJPvVNZ1CL5c3YjbNPREXKx7SCvRoT+VpKKe3jb5+j4vbxeSyFENiIUhqa?=
 =?us-ascii?Q?e/ScXlN8w6eQeriw1BG+8nHfOMwwzfBn1jlGqPczBnPtBS9+PT9PUmdUUBAi?=
 =?us-ascii?Q?1PQ387xUo3Mzb0nYgMAnU9o06a8KHlfJHjuMYeL1WQJr/rmkGUMLraJ3yQNA?=
 =?us-ascii?Q?xYVDBPlpXy2qlcTdwF6w/X1Jv5c2RxgqN4TjQmGR1xz5u3XbXzmBTLfo55fS?=
 =?us-ascii?Q?UDr4KsjTUCjkRCSRJujzvP2GhmhkuJhd1xTqbjwn6XQnagqhpai2TDS2+w/g?=
 =?us-ascii?Q?KI0DbiUlgHob1+aauOrJ7wN0EQVEYf8+w+/9i28Ogha29rftMJRpyc3M6jiY?=
 =?us-ascii?Q?Fe09w7cY4Bs886IsA4zoFW+0ITLn6kbaWhMAr9z7Am7OqahC0WKjHA8kJ0fk?=
 =?us-ascii?Q?wxL0lUtlET4aeb3Et480D8jn9/0Eb6LBzLgxVSnc8VGtt5BYC+BDpwqECgIx?=
 =?us-ascii?Q?DzCw58mHxBcHOAzyftfQLGAF9SiRieR2Ua5DEf9IKrwpO+BrlfYlt4/zt2YC?=
 =?us-ascii?Q?9Me9UycCKOJ8VKjvVEj/t1ORqVHRhWyCoxwPzEFYqMPbk2UbzW/R05uqoOhf?=
 =?us-ascii?Q?xTd80Yh1dV/eSWimidZFhZvsXG9tiBiCUPBN3WY8D+Qbl4OW2bKaVVxNa3RV?=
 =?us-ascii?Q?GFQUqknzK+G4KyuLN375MjnMjKJkfz4/j4op7HZ+kYwe52pGtIIilW9L/Blg?=
 =?us-ascii?Q?v2TqCWI2p5He+6LYkeZP+IipbJaFanJ37eXrID+yu8TPZdi9cSxV3+tXtJzP?=
 =?us-ascii?Q?JGGe3VsUVlVm4xVJ9q6TrDQO6M/j6Yx2kr+eET1u2EmBtcYyIe9pvCV5iKGL?=
 =?us-ascii?Q?A/h5Sk5sc+R6aRgR6CGdXU41g5tMwcZgg3gnx8NA8RTJovdgikpEQHCFaB58?=
 =?us-ascii?Q?NwugU+feFqY9xTnEjCZ01Ucg2E8mZr9v+lGj+OG/FZw36Tn/2OWs1/K+Chhi?=
 =?us-ascii?Q?G/wvM+cYLPtSaABNukOK2w0pjuxRoEETIDjUaz1axh/y8oAsKQkZDPTxZE8K?=
 =?us-ascii?Q?zi87RDF7YBzeHi8tZnFgHjJwhCLquwjQRwwX2RSqvjNUrMOm7loif9z0RHUD?=
 =?us-ascii?Q?Elxr55Y1WT4qr505rIYWlKA2kIehH/1AaRsId/jln5U4p5uCOPrAAcypif1N?=
 =?us-ascii?Q?rrtDAqA/ttu7STWGOdzSBnV8xGUL87uQOHlj/1jEMZA064gUTd+19RfIwr1X?=
 =?us-ascii?Q?L/ay0fUvj99vICcpHaIaqzyb42uFaDc=3D?=
X-Exchange-RoutingPolicyChecked:
	p+0Fh26hbL6iLo+Pm+3Lt+yjIbx5jyj8E2LeMtZjRn+7v9jVukzeVr4+GTxLucYHsJHQzs7EtyOAVhfl6tFfHHA5Zmr6t8XLmW6M5KoNB+l3MEqdYz1rQS4Fj/H8E4nHPhF2YzRX7TL53317tkHzbXXBCT7FYYk8/mOHfAmBFDKI7APofPMMWWunq/t19XlgawPBCdtrX1rRdem8P7HDTOVtuqTKNe30PswsLVpUR0VGy6nsVVMhmpLDJPCyWfOVfyCw+leyGErVRzwncrtqzQEpqt/YNV2Qi8vBBarhq54ZlxrChtPoHeFiYIDM0pEJhzU/FrqU6/DIalxt7WPsyw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7cbDWpzeGhOIos7CLXS91Z7ucRd1RjVUoQTVzgQyvrsrUZarIQUtNTWfXB7acnlgejAn8/8gBRZKiwebWi35GSMdDl0ZRjR5c/GXGbJ5yySkIu5hLVSz6iGIOWajRBOUeKWhV9s1pETYyAQDjGdH26V7RjaQ00y57w+98znO5GqBxY6Kk+8kjVyCZ3c9sbPM6x61HoICFaOEVxxdCJPY4Yf2ky60GI6LKbkEHj6fBPfUShbq5YYPM6FKze4bwtcaLjxrdR+AjHeDVg48bKp7tIof1Yt+5wslrTcDiPncw1RlJx5lBTTF9HIjPN/DyDdubOgHowCF6Has4pky8/F9xS/GQHqfq10tGjkrkuuZHyzZFbPcKaFB56KUQkCGiHWJCLtJIKG4pAqq9NfXZ19xF4D3WgJZZHfOzCSnbCe4FUhlmCQR0A6th7wPIvfz8w35cpdQdY+Tu115o9r9f3SrrxufQWBKyPgS7Gs0o7lu1s48srCZGVS0tKvcxRIoNywPhrc52cfr88ZnDEBU6WTvcZrz5lTIWsEbJALkrO8FV7AftFAsL/VI9o+7SsnLThIlo1z7VCfxz5qFk9Yl/5d+gqgA64DOyaJVR8BqQqSqNE1kgEIFr3IPqAPfHNi98+8I
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f073c1-98da-42e4-a280-08de9f706a21
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 06:37:10.3091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGMy2QKzU8nBjeOmhB2VTiG6Eu4sLdJDW8/hp/IUUuy+UvOhDCGboCKsku6RcXnvyyQtwZLdxAyx19iU3oCtomfKMhr06oz+uiGGhiHm+uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9223

On Feb 13, 2026 / 11:23, Shinichiro Kawasaki wrote:
[...]
> Here I share the list of improvement
> opportunities from my view point (I already mentioned the first three items).
> 
>  1. We can have more CI infra to make the most of blktests
>  2. We can add config examples to help new users
>  3. We can measure code coverage to identify missing test areas
>  4. Long standing failures make test result reports dirty
>     - I feel lockdep WARNs are tend to be left unfixed rather long period.
>       How can we gather effort to fix them?
>  5. We can refactor and clean up blktests framework for ease of maintainance
>       (e.g. trap handling)
>  6. Some users run blktests with built-in kernel modules, which makes a number
>     of test cases skipped. We can add more built-in kernel modules support to
>     expand test coverage for such use case.

I read through this e-mail thread again, and revised the list of improvement
opportunities. Hope this list helps the discussion at the session.

 1. configuration example, documentation, or tool for ease of new users
 2. blktests framework capabilitly
   - more bug detection capability (such as kmemleak)
     - code coverage measurement per test case
   - VM integration (virtme-ng? valid use case?)
   - parallel execution for shorter run
   - built-in module testing
   - multi device testing
 3. blktests CI
 4. longstanding failures
   - nvme/005 tcp transport, nbd/002
 5. test area coverage expansion (which area do we lack tests?)
   - code coverage information as the guide
   - new category candidates (rnbd?)
 6. blktests framework refactoring
   - trap handling


One thing I added was "multi device testing". Most of the test cases use
single test device for single test run, while md/003 and bcache/001 require
multiple devices for single test run. There was a discussion how to specify
multiple devices in the config file [*].

[*] https://lore.kernel.org/linux-block/aXHbPWCf5SfycpBX@shinmob/
