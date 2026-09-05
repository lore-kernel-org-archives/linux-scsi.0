Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBC136A022;
	Sat,  5 Sep 2026 06:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788590718; cv=fail; b=MO36gxaNQyMRsU2cEGns9a2GXg4F3/M4h+3Nebydg5Gu5bSYzP2X9nrEQk8olDf0A4WT5dMqPJJY83MHqDCe/EWEBOAUi+dpqB0f/C/JAPwjTzSFIWVzqwaa5uwar9GESu/DMhEBXe3mddr2gftBtONTXT0Z0rRwrb52BB4jr00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788590718; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U4qx36DbZ83jlGLbvzibmp5OoLsztcAnWgUFsbQcv7dTzsERN/2X8a2bUXMS5qLzbn7tvmZUJYb8TWc3u6SaCGfMzix12u/V0Eh8Q0GhVCPvufs6CAdxeGmVRcWbvP5xKpu+pa3JDqopgcTWe7LIBrh/zYkeMWAeZdoLl2p/Lk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oBhAmdtl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pkxaFZQJ; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oBhAmdtl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pkxaFZQJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788590716; x=1820126716;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
  b=oBhAmdtlI2hpiOGnXUynIclDM1xQIbzeXSPLgCXKIjJHT4tMCwEsRkR3
   zS/vRqgqQnQUOIBS2FZmDZqmEtRkqg7LpfFlH4S6aRf30eSoi+HYFvDqX
   dXOMM6qRE0SAzkAKpRaJp57MMj+hcBpO5bqDktV6yOhX9m7OumPu9xxDC
   yqnZFa2CeavRCRVeDJyfMwzKeMGImqmD6cpBDSEwypPQyGJilBvn+iFn/
   9PVwAWHBDoX+eC8M8L9fWLIoy8Vza0D5CdK7/fwk8MMh9hW11wCfpXiRr
   m+1D8iGdMsqQa45+UxBvCWPx7XQIFHP1Qfp5aAzmgBX8FJKvk9ggbaXcx
   Q==;
X-CSE-ConnectionGUID: if3LveuITJKj8VzII8TWLg==
X-CSE-MsgGUID: xmKy/m+NRJO5K8b1iriQCg==
X-IronPort-AV: E=Sophos;i="6.25,263,1779120000"; 
   d="scan'208";a="155927659"
Received: from mail-centralusazon11011036.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.36])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Sep 2026 14:45:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lreLkn+idEQog/EEJXRicb82c4Kw/K+B+2aSs73mIoJwW+YY0u3w52KI0LiY4hHMlh1ia9MMdjanbNJ7H50PGMKlFhxX/Z2EBfNdhOfWJ3OKoA/ZQIYjjaZtZrjjjXl1ZWtDpUeM/NxjdlnEemfZz+4aU4YMjVLH4Hwz+GrF2KWLHXJml35gBCpXE68mNy4F6f7p9ibjvawbAcHTWFBQnfUVP2psBcUEapnSfqHqN6G6tSWEu9V/9DFW43baxDQWQzBs6lJVppdMUc4rK/3adbBIhU3dz78lVrwufgMU6Kcx9YfsD1ymSPXkS5nHG/6zQWjb0gkOUSy4yZWVAQxfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=PKHnP9/tVv8t29a/rTAY/yjA16F2s5AWXhw5wVdMEIXhtSj1tBhWbMLl/Ifpd681RTnJyGSKSXcOqLsJRzQ4GxppsbpsTf+gHj4Iq6m5QwOI47L3ElTxJDBSF7g5mA9mocVj7TfYqYJ3GQeltCkvB4mYR89J17z1tXOMsoSXc/cfXNjuzOCIIrauCFZSgn9302DuV2dwIrn7xHB8vILeTBhweuQ/3S8HNWaSnaD1iuHUiDmYTu261uaQZ9Sl6zgj2Cm6Gwy7OsU4Um4GyhLX5N11gf6n/AuKJh5Nw0ZRnmjMNq9SHWOcDwSMcyxid4VhLHxER5aYBy2e7DVbarHzoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
 b=pkxaFZQJ8NglIPtXhrKOp+YPCA2v5+ZyYMQ5tiEmgWHQ2AVOa4/6XGd6AU8+ZsGBMcMH6wS3ACu5M1OYIHJ3I+DnYeLCSkPGeQLPCh0bHjdMlgowKXefO7XSUol6T/+pmbGMsx9NaB8yfg61eDwz5yc505EmnVS+5MaFEUFh7gk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DSVPR04MB9964.namprd04.prod.outlook.com (2603:10b6:8:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Sat, 5 Sep 2026
 06:45:11 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 06:45:11 +0000
Date: Sat, 5 Sep 2026 08:45:05 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v4 12/40] scsi: st: use 16-bits defined sense codes
Message-ID: <apu6WaXS2ZgaS39I@mayhem.fritz.box>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905032224.509860-13-dlemoal@kernel.org>
X-ClientProxiedBy: FR4P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DSVPR04MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a6f318-544c-4724-7c01-08df0b193bd6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|19092799006|1800799024|376014|7416014|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ru17yshqsf1uCog93ZtBzsshgCULvtatZmf5cun9zaB010B0De3/gJImARx5YWdJHdgcS0NGMPd6kupePBnTgu9DZb9B/S8bzIaZ9ibaLXGZcv83lBwR3I6N82urc155c56uzflwQmLVNfp20UUff/A5wt8luFTkK+tiY1FTE3EtCUtSf/zPuaYRXSX12lrvC0YNqkyKUUGDBKIuaqCTtTMluLZIG1MA7k1th3fhbIpP3fI0XFi4ZKR46Y/ILRQvyrh7zwab0DXk0M00sDMl/fjL5bRPyiKFdeC3W0CDxkip+Goz/9f+Ej1VeqrjqQJN1TkLwsxeyWID4+T1p8dJwnFLLW1KSopuO05S605z2rVVFMpvjjZwRb53dkiEM39nQj4LWom1Btgg2AZpv6B8tbpbtNFK7IevQvnnnOldrIjq998F+DY+e4h7TSBIHJyWQk06nzl5n6u18rCIxQGCrRPRzujPzaG9DzboMRwg7Ko7aYfO/xvqWrlPHbfkWrdCNozCzlUD8CXZxJe8YBOmr5kWwQUs81axhFTQJXuLdsmveZv57HdvXmYtRWf6XlyFb1G+QpugJSK9JtOUzsYhNXHvpqlhUBy7Ma7JT+1VSP/mEIo4SvhefnHH6iXWDedh9UOu7JqsBDwkx9nAieHeqobxyyAvHF6LwrxzA5HbtJM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(19092799006)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vlG5u36iOjFNaGE0Vb9/+XKPYaDYZcMoNaw+TQUnf0jpl1K0feFhctce3lZG?=
 =?us-ascii?Q?Ip40tOzvnsSAqYipkOf/BPvt0OVtmVeBNGt2AIyNAhxUac1OnoY2M7YzWHvt?=
 =?us-ascii?Q?RroysfWql/OjvQgVdzHow93goEgYObNoIiQ7QDVUZskylUe/NQxJ3rzhRClk?=
 =?us-ascii?Q?9MsORlQKBhf8019KTdJBvOc95PlNm6aM+p3ttXbGhoss3Sqyefigbd6xQL9l?=
 =?us-ascii?Q?kUm+VA7qG43yTwiqBCZzXUmIAg26FUaO3tjCLtbhBxuVVAmUt0kllsql9VMh?=
 =?us-ascii?Q?VbSbuxFsDkR3240zsfBkKRQoznwn4ShupJcTSZaNhR4odcTMkWq4C8dfIjbm?=
 =?us-ascii?Q?IkKihsRtaDwxt+4CN9RQXIsFyrHW+7pKWCjpLPlv/0tw3TpiklzTouX1FS4u?=
 =?us-ascii?Q?JH/bHZIFvhbICw5pXLRuOfwOyQe5fWuSpRBckYanowW7zKI4NHyUKHLCWhmM?=
 =?us-ascii?Q?3oVismX6Q2wNNkAp15Ses5NHApDzb57dL9uVPcPSCnKlJIKVT+Nk28yD33aC?=
 =?us-ascii?Q?j2SrZYoyqnQQU3DJ/CHtFp1kWN9LPnvZgAKDj5f/l1nap0Z7YdRpnGPJ5ZLB?=
 =?us-ascii?Q?i7E1EMhw/35ZkhnVy8xFsdtr/2V+tMudFdIkuW1MG3xQ23S1ATi34gvtt7Xy?=
 =?us-ascii?Q?n3TDdtc7avYsC7Nmkoprx5auaFcYK3m71xWMxIfLhfw6SI3N7OY7/af+FzLw?=
 =?us-ascii?Q?uMOQvYmst1Zs5H+W7kR7BCYSDyDfqxhDqG0lxSKYZXdV6/E7fkc87+6vcCAF?=
 =?us-ascii?Q?EY6hShhoawHkJwGYZWeYB4+3w64sNIFvQxNwnZljEMQnjatjiD98/jLUzznn?=
 =?us-ascii?Q?j6zAs0Hu69JmcW2DgEeK+MDLlD1rL6qmve7n+YTofUlhWaiEBQmyrkoZ1e4F?=
 =?us-ascii?Q?X4Xhq4aQ+xPqtAIw5Iym/DNBJ/jQCBJ6eZu/f03DZ/0+GK2WJ1sB2hDszNLq?=
 =?us-ascii?Q?rnDMPHsTAEUTv0gStJaXaEDxBk7wxzMhoQKryAxKSoP61qK6Sp0VybKDSMcL?=
 =?us-ascii?Q?YjxwtL9RvWaKI3gZdXY72sbLkj8xVeMPIwa5ZtNuJJ/xW7z7b3oxC4BT8CRQ?=
 =?us-ascii?Q?R7REXm4++hZAtCOMN0yc3BcflohhkpE+EJgs7E6Pa3yO6KT1T1PwKp/oOqPr?=
 =?us-ascii?Q?q1aXYmU8dRzOf+Px4lRHOkmXPpPepuILOQnPDBZPWkNjHSjWexm3OIr7Km07?=
 =?us-ascii?Q?YXSid4Mah+HxlstUdRJ9VGW6/sX9vn2/4L90c1/xT6FPnpk9YC5zcQm8UPn3?=
 =?us-ascii?Q?ASYr/n9LJqT/ftFl0AqNDSL9xOKf2pWao5vbbXCRh4eihZe1LIN3MmD4Rogm?=
 =?us-ascii?Q?hCvsLmhBejaEThzaKUId7vKfDS7vQS97bw4o4RrOk5Kd3jAJnQCkKlCeTcLX?=
 =?us-ascii?Q?zPzeoJotdSZ4x6loehiw3nWR2Y9rdH8iQFKfPwSk8O55TmCqSWMv13K71Sgw?=
 =?us-ascii?Q?9p0FoUafvsAd1ZFBFG8czobeUIDmfAEQxmK08mihQfXAR3+jHnMcGU5H9hGe?=
 =?us-ascii?Q?jrmPq90900dhBnZFF/PMmqDGIDDvg/bvegiTHFqzNYTyNF9Dhc+ZXEKCuAq6?=
 =?us-ascii?Q?JmpwFki1XPe+q1p61SLfrIcf0Xz/EE+T2LyLLgiqb9KHhKW3qd9Q+gxOqpxC?=
 =?us-ascii?Q?B/U6snJM2e9eHzjkWnvuoWNYS331pSi+doR5kM0sbtEigzgk95eeCPF+kQKZ?=
 =?us-ascii?Q?EHQVxofBZuTWTzGqDrXXSlnC+UyookuB38G2O3WRcFo2cvekWgnBeSPB7Ol2?=
 =?us-ascii?Q?YwTx/7BNXvy/UMMynxB9T0bV6AsqgG1khq3VuVqaEH2fuOfSf2NCGjpjZAdC?=
X-MS-Exchange-AntiSpam-MessageData-1: VKDLlC0yxk4YNA==
X-Exchange-RoutingPolicyChecked:
	C6xviPX1QCiLqBDlLRcHSlvzc+cB9XnlmFke/+vJbKBgU/SSuScnpYarchLoIOuvNwOuDkoPEeEOGz07BAlyShf4pRx8ANB3Dx91yA5PLv9wathnnLYLSStG7ZiE3vCuwGbWnepSwr4MGODrpUxX2KKnQMYNfokd9xawfWBmEPCVxgd8Ff4FDFxKXhND3ZoFBJuzC2yUdEvoGW1Us32Vrm00NWZ/KDmi7OvtZi1t3rQW+TBVkBNmi8BH2v0KG04unQvqrKXoWoShVqwhRxPH4+1zGlcnbc9RorknVBLGqlV6dw4NNIgr751u/B62+9pu/8vGiE/z7yu0w18NmnVP9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fx4Q3l+HkOQAX5Xh6Bcwv4YlJ2/Bc8nkr+5yMfXznFBrlBoqSlnpfPSFCHXAQjtPDnj0yjgSD9Z5EdnOjRafS4F3f/b8dzs27ou/DDLEiv2Fsqe6ZirjDr/U+C/T5NrPnbHfFae/77rs9KYAnmidaTZfiQ+MylJP3ock/QRbq/FeR+K/Dqm1akVBwYf33M/iW7iK83KhaZ5wNjxkrEki5+vtF83GQABaqe+PB6iT7Jl5vIE9vJnDE3IO1SXw/zi3InfvygBNOpTTVuPCc1+yInhO/s2N6JNJpjvxdzudbX91Hurf41ZA1Eu33PfDBjRa+wisGP1RrHEaH10E+W1MRjja64H3Eut682NBLekzHsQxbWl3KxNd4Xdkz8UhambAm0/fxWxOQA2DKVGnc9rtTWa/zp0IH8yiW4+rHzTbnCzRJmkNkAnxLgHy5GqIa6TmiOtxYwYTMKKWo/+QOD1K0rmnsilIt0NNnVqJ+mJwSoO+MLEeHtYOBYXEJDOtzb6UoKHoYi0FOSCK9deSrQcz1616+hrkvXyNp6mMWxeKY4ttHImZJxpVsiFBH7sCrEidVN8deWBZ9kgeRWnlkvfH0/8VrAhqZLGxi7M15lXjU2VBITs1OCNMmjwBECESC2rI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a6f318-544c-4724-7c01-08df0b193bd6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 06:45:11.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4WrPIMbS9heMWjCXOUk1VYK/wFCrauAxy+4cwXmJqYR6Xuk3rfM+7LWB2K9cX74r8XNCYlpOdPQFuV9Ww83THccG4BXnBFFQByOrmZl7d8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB9964

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
