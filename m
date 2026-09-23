Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D64718E1
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157263; cv=fail; b=uKHOt/NAW105BHCcVt3TMYy4ls3C/pCyvQ3g167+QZzR3jhIPYC+gMFJ0/0vYXoif5e/PR5655tQ2/sOmrQBB1HXK1Bkw/tfwVUQsROBMCNu2c39ZYvKZeGmkXu1pZ+Ndu27Tq68fLycw6u5M3GMU+S2jrdE6PIdLpnxdeQ92qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157263; c=relaxed/simple;
	bh=pOQDadlDI9QMXTE5v0PbHTIzG0QdIHg0C7NCFT2jHFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OgAinxxmjvqiUCW0zWd4YHFn6hrJH3Ccccnp+vkUjNQxfTLnBh0CQuzByOK9qITZYYQj7jHlj4PL+IrsSe77fcX2Mejuot9/LENrtzHWc1q8x49mXjC7KZFZXl5gsKXEwigmtbjY3eevb8bIHq8WkF3V1wgVJ2W1vOE1R44ZqTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fo6yeoy3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vwwx7GSL; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fo6yeoy3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vwwx7GSL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1790157261; x=1821693261;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pOQDadlDI9QMXTE5v0PbHTIzG0QdIHg0C7NCFT2jHFs=;
  b=fo6yeoy3zj4mUpozYAkLzjd/J5v2lnhU9mRZuS0c4JEBHRlRnP+gcXsb
   KceqIAYu8PpBhNC3l+J2mXxwK6QU+pxj5ATSY3RDfl3b2qeUjPZrhAqsr
   FTFClofW9AxWly7oH3SwryRnC29Ko7W804EDUaUKwcxbJ2NfOkSjci8iS
   SyX+l+nzHaHl7XEDpoDu1g7kjwvMA6y9Q77SuBmnWEEpdefinNQqt9b2d
   KTFv5PG/RWps76ZIX5jSbzehy+vES2sBa8skVIGf1Wd/NTS2n1xiAB+Yx
   VyTqtHJokh0+FWai6bFTWraaa4MADtoiVjWGXDBTL1AEFus4CvPRx3hxv
   Q==;
X-CSE-ConnectionGUID: 5uszAB/lThuG8/KwVa35RA==
X-CSE-MsgGUID: beggc1WDQKWW3NAE+ycNSg==
X-IronPort-AV: E=Sophos;i="6.27,118,1786982400"; 
   d="scan'208";a="154754578"
Received: from mail-westus3azon11011016.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.16])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Sep 2026 17:54:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4XnUlMeweFy8rwyQMJkg+9sydy3PpUn0HkZWjJbzc/HG9RmJ12eq6yQAvp2FQI7XPYz22CyNwf8sq+DRR9kHyu3dzc4VPt0YAXTX9XuG+plrbDopCie9crg6tfowonvmOS12OcYyBFEEcdTeB0Nrv6+Cwhz8YjJWPhFxbaOOtf0RznGF+EjVqpnKNKDMxyXrt5Ei0WbGCr4TPUZIRm0QuTWudVhFlqMbIiPKVZsp0JO3GxYul7bRj9BCbCRGcdJ7lFJbv+uDA6yGpxuPItDQLHPUR62A+JsRm2ci7f8Jv0RF+sg04d1glWaEK/OgzvOjSA/+jsL7dMKlWI8Kx/SsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3V83RJZULNQgsJihYAjmkp1ufhiAtuCToedXv5fJb0=;
 b=FBRo/qvHZkpfGNw/ndLVNgT0TC37yM4cHHVp+Zydbk4raSejJjAPVunqv6vHvUKyOyOHyS2wBGpQ04O5Ag6tUkEhiVeHXQF4JggGV2IGN3n17fsMLtspCHx1j69x67PIC2lRj9nXVGqH5SD/nBl6avereFF0etOugwW71LPUW19QUFEFWFO8NI0/gF4uB8NGd0Wdxra4q/nI47GOH/r/WQqKy396F36FVuhx5rhAOv4UjOcicyb8jpZLkca6Fbqi0LO7yRp4hXmx+xmAcf1j+ixFaKzWafNyvY3bQqhfvntjJCwXz2Aq0J1upOX9S2/ECLKAL7bm3t1I1rhEt7KuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3V83RJZULNQgsJihYAjmkp1ufhiAtuCToedXv5fJb0=;
 b=vwwx7GSLFKSBBz7m1UG0v/ScgJza2lPNF0AiopcE3HK7fe2Az9/8SVE3W6vjRnffSeH7DXcHnaKTOY+rZzSDuUU2fyoCl+dgUaf6UEvSwM3LWBYa9SeYAEkwdfW8JhV6l/XSVziUtJ6VWqTdENHTzoa/8fy2xw5u+vJkVm1F13I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by PH8PR04MB8685.namprd04.prod.outlook.com (2603:10b6:510:252::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Wed, 23 Sep
 2026 09:54:19 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 09:54:19 +0000
Date: Wed, 23 Sep 2026 11:54:10 +0200
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>, 
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v5 04/10] scsi: scsi_debug: Evaluate scsi_debug_lbp()
 only once
Message-ID: <arOhUIcsod1ivn24@mayhem.fritz.box>
References: <20260921154015.2971990-12-cassel@kernel.org>
 <20260921154015.2971990-16-cassel@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921154015.2971990-16-cassel@kernel.org>
X-ClientProxiedBy: FR2P281CA0134.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::13) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|PH8PR04MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 91dc32c6-61b8-462b-c01e-08df1958a30f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|19092799006|23010399003|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PQCNeu190vDWF3kCmew1+fDYc0ulXuIbunO/vlMN5bWKFObIndi9xqBn8Fsu7Sq71Af68RiXFhZJ2LfZuFpuLjYWgcJNzm2Lnhez13H1pXnm5jbthkfdpMcGh2O44WFsHM/c2jCdWcAJHK2qoOk9xIfsIjrt2ffDIfLwgPBMYcWvQNJAhBIiigaeMrej5cYWaqbRqrKMvD5ftrVOI3035eL384l8eZf5CbMDN2O0u74KVNrlPKWLIhj+cQza2i8PJX4o+HJZvvu5NgdzBTXoVQRFh5inQssQR8bVCbM1teJvDO9H12Nrz4Xn7Xw6F9caV12Q7x21GbR1vTXlbcIYpt/9jcb4pIpa0TEyXL3AcquuJ7PoFZERBR/CRHg0S0d6JjHtYcgVQiyTdU1bM8EZ59/+7y9WQuahHLxnt8ePy9PX710RuaOrJM4nkTTzUd+PFOp/4zR1VRO7Yl4a5daApBlSMN8PtVn+lLqKjtpyKQhYbv3p1cxY8Ud3vbV8EbElM0BcTo+ZS/IPlLSRvZBs8h24S2N+u9h5xz2DL1o0zZXQCcZCrvuDubKsON91315+H2LvDjQLzl/jRvkpvzCB1vwjyXtIy6Zkc2koKkP13Of8TX+ZnNqSlWGmmm8jcrdaPMNWFqPmiNwjOBlp4En/7fVkYw6S/fW91r+L0Mf2Fjc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(19092799006)(23010399003)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qmuxHDMWiu+eZJCqOGXSJDRT/pHLPd3yUtTmqmdJ5zOVO1cL+R+zxkTSbNST?=
 =?us-ascii?Q?ybNQXQrnYNKn0MQzSA1X4NnEt6uB8SjyU98IMWduXH2JSTQ6U/y/qZJm1zKz?=
 =?us-ascii?Q?pFkELgo9sDY/oHYLg0Ad3BUGcYxAupzBXacn2RuzGzqiAfKScAr+7OIyTdXj?=
 =?us-ascii?Q?alTSqMXFP0ztTko8Z4fhvTXzHcGDHDmB0czJOq7ITcH8KEbj8DoSGVhIP7ll?=
 =?us-ascii?Q?YrBH92BvgkzKGqE5a9ZPk1ky0xsflr/OE9woZNcy000TD76inKIbbL35WWKw?=
 =?us-ascii?Q?I/D+VmLLXQFBnZYFRpNvfWugXub0yZxo5xIUJaBEbyd0xakyngVOjBMQIRA6?=
 =?us-ascii?Q?f9m9zJpptXRpvrV+c24hQUKWyfYgEiPj6s/+OZ5qDIKtyDW+T3h8DjnwucwT?=
 =?us-ascii?Q?e7TXWWpqPn6Sly3MYFaFLfJciTFMCt1Uh3GUUJ8oe48Q312IQabwFDKbZNAS?=
 =?us-ascii?Q?rrY0i8HrR4AFJzn3hqt5sNexYzR5KgTnun1TeUbhXc6/AP8OD6c6XDRhdiNL?=
 =?us-ascii?Q?gaxvdim4sjtbSFIzPWukpZpn3OjWdIWUt1sZ2n5gs1dWsKGQGaQ+Hb5IskoV?=
 =?us-ascii?Q?9bi2+OkzdiCvd3e+/66wgBMiISsa/XK/HRgXo1P7y4JpEOH4FHwnGOJz/6YV?=
 =?us-ascii?Q?X05tdDZ2k+BTuuAFNVKlwbgNRamdv1UF8QjSsDUxorIfo5jNNYNBA07zFFQ3?=
 =?us-ascii?Q?Vk7oLGK33+73frh2XIfT6TUcIyqv11K3ASeLPy9taYuziA9GNwEWH9P4nSYk?=
 =?us-ascii?Q?dVCBoA4b26H4zsILMJceCA7FcEpkfcxikOpI4uFwrhisInjMfFF8XZDqMgP1?=
 =?us-ascii?Q?bXdfXHh10uWz3M0fWCdGT/76MPkCrvnYG4SIcfzbeqhmmoyWpgnHWvF7h1Ac?=
 =?us-ascii?Q?9Ty+hFqOuszLiSa3aYf127Xth7iefuVqaqvowzgzip9EYzIrs6E/6/804UyH?=
 =?us-ascii?Q?erMYbbyFjKAxKovdwZ8jBe/VHAl6XEryWEfgXeE46M3R2wvygPhElHw0Ho6v?=
 =?us-ascii?Q?h3XDO7lo7iRzJDg1Fitn+GajU386+/oZynkkCQQ8+iOOcQAOpJZJaWTzCGEq?=
 =?us-ascii?Q?3r1PpRZEB2HCHb2uiLM8L5ctYroRhZx/cb6InaObZHXEu6zJHvBZkZ/tSTtD?=
 =?us-ascii?Q?bFUEXK85H5XcGk13+IQ2EDq51yOFfPmB8e/nR19q5jDq2ELeBxrdUICWcjSK?=
 =?us-ascii?Q?qHrL5Aq7uOq6AFxTpPQkXRfMxpayZfmYMG+xAuWOqLkHvCqKk6/AneE+2xwE?=
 =?us-ascii?Q?RYR7UO0TGAa/ClzAWucXKrD7bVo0fXcFVT7ldhpenejGPxCJnaDrfnpA3MRS?=
 =?us-ascii?Q?vqqQ12sUarZxAsGveVO72+n7a6+fA7F9pZxvWLn/b17nE2WZMe+H13potCWE?=
 =?us-ascii?Q?lP8aN+1V7ADxlUm9jVzt2qTiE2l2OOgopzMf47lGDnhlGvavWBNaMchhYaLJ?=
 =?us-ascii?Q?lIp7ypHBQ7fliMnTLx+qEqW3emhsjzKBDWkcluFMnHUKvSN/pC91LF6c9MTG?=
 =?us-ascii?Q?FiFmZQZM9MWA+JtmLJeB0ZSDWdDDO1V3ZrULt/RIrouL/eFWueE/Uib0/q5l?=
 =?us-ascii?Q?hM1hkNQjz4pGwQQJyHwwXOzyuXBfOgmNVuq8z7AX0gJdNirHRqhssb6FVw1I?=
 =?us-ascii?Q?0dT7IdwV1ic+ElpSuqIONoa+sQhtZdl5ec5oBV+5Vi3KqF49yWgXJMcFgxRY?=
 =?us-ascii?Q?8ci3yNOsokElria0vX/KUqxyN5n2lZpq3hKJb0kwbmTIY9lGN9g5t3imxImE?=
 =?us-ascii?Q?1yBSODNOghWmeXIm8IXB2CsNazy+KtT4/UapgFbmhCmcNSESqivMz80CraOF?=
X-MS-Exchange-AntiSpam-MessageData-1: W/DrdXE5DxWUF6kngsSZ7D5AkpIwYQYfeEQ=
X-Exchange-RoutingPolicyChecked:
	C2eXlu5X64d8OT7L20GMSAyPqBt1KpYMCo42Oz2jKhyaQQOloGh5Ifgv4ZPD9BOor9OZAyP3qDXJhDF2XBYaPuTxTl4jHRLVT89n7Rr18/5qjfVWyi3gldXKXMy3nDV7D1AaGV06giEmUAv4CSNEV+jHT0Gw8hyrQgbjvbXZLwsC+XCn1wZ8jo6/uz2hLTzL3Znf5OrRneGBz/SxKg2Bhpmt0wteX02tMtUV7VKbxKPVlWouKsamAE4TKSwp7xCRfcoR36OBKqbzRC1yBlhf/3HI7t5Tdk1evFLDNqd6nHNvAX0DN3wI+46Ia6i6VtW50RxF2peOS3dUPp+q2sZ6Rg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DabMltKrwvrKTVpexsvE3zgP50PA7wHZIbaBGkfZahxeOV3GBMLNXHQOKWEaOHPwOHIsHuKQ3u2RbVtauD4g3MHIGV9yWOejE41Wei0sXi03iw9xGVu+q0faAsr+1911SHgNFbkscdvDAUW2ROAgEB0AHbjj0Mva4XvZFKjVPbfGIs+1LEuPkJCXDCGhGxEsBeFgusz5QAdZfjTpJ1wumKQ3PMYUw4cgvxoTtzHAVobtQuK4LrlTWpatKmwQK07qG1wD0cnZgWzrMio2Aq1TwIa0bDmXwQjtnopNiBAb8ICiV3rpQ2GQ4nrojZjP28VECKQD2ZV/FrHybpjFqHEVWe3dmHr1fo5SQiz+9105pvqA9aYIkQafYkRyqXYyQnCB3ngW5Jj9CIsU439w/fCRJHTy34/R0CISCZJRvCNQdwI2wc+k2STN46GM+KfYnNTZ6WOQD8G3H1zuzAm+ZZW1NRIsaInpgMKzbZGfUb4hRTwLFxgfGYR4CXaBdnpGI8z2qetmDw+IfzpJYqx98DkwtX0aIl1KVNvgUiOY1V/5KboRl8h6R3C3WoaTCULhGYroG5Je2Kd3ZbepSkALxSVG3aaGZ2OQJC8qAkQF6tKvUVgGSFK4bBbbtkj2k1bCJCk4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91dc32c6-61b8-462b-c01e-08df1958a30f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 09:54:19.4188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iZabrue63I8whdRGcRHt/w/Gpl5+tcRrRMxmvtGKPcqNMo2+kKjhN0xJQYRQre2u4DROUqCoBfeyg1h2/R0lH/Q4rHsKYSBFMZ0B1LmIPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8685

On Mon, Sep 21, 2026 at 05:40:20PM +0200, Niklas Cassel wrote:
>  	if (sdebug_dev_is_zoned(devip) ||
>  	    sdebug_dix ||
> -	    scsi_debug_lbp())  {
> +	    lbp)  {

Nit, lbp would now perfectly fit on the previous line.

>  		sdeb_meta_write_lock(sip);
>  		meta_data_locked = true;
>  	}
> @@ -4975,7 +4976,7 @@ static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>  		goto out_unlock;
>  	}
>  
> -	if (scsi_debug_lbp() &&
> +	if (lbp &&
>  	    (!map_state(sip, lba, &num_mapped) || num > num_mapped)) {

Same

>  		pr_err("can't modify unmapped logical blocks: %llu:%u",
>  			lba, num);
> @@ -5035,6 +5036,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  	struct sdeb_store_info *sip = devip2sip(devip, true);
>  	u8 *cmd = scp->cmnd;
>  	bool meta_data_locked = false;
> +	bool lbp = scsi_debug_lbp();
>  
>  	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
>  		     atomic_read(&sdeb_inject_pending))) {
> @@ -5102,7 +5104,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  
>  	if (sdebug_dev_is_zoned(devip) ||
>  	    (sdebug_dix && scsi_prot_sg_count(scp)) ||
> -	    scsi_debug_lbp())  {
> +	    lbp)  {
>  		sdeb_meta_write_lock(sip);
>  		meta_data_locked = true;
>  	}

And here as well
