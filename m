Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5452C861
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710154037; cv=fail; b=RtPC6JAuQF/RW6RxpfePJyWQVbRJXO1lCafnhSuxr1KMSpCBbNck0/J/pe3s5EVhPAV610S9yOqlUu1gaa/I2MnaQBU7O8DO+Btnfj945v9QFjpZA14A56/Raio1kRCjDY18/xfzhOoM7hHsEfSEE5exk6UgJn9gWNReBidZuQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710154037; c=relaxed/simple;
	bh=eb6zgaHKdGLv7HvFGfJ+zCnjwv1kq5YyHgO2vt/2wq0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nPSLcBnFyzGM6VF7DvReiCMWfdkZF7m+Ao5LAa8GnyhnIsN8//npfUJSCxXM/RHrY0P5d9W6LdfWEGDRPCsThsh7MlBxbCogUcqxNNWSjwWPnJ469VI5/fHkaGtqfpkpJzxIpT2CRFPoiUA4XEgL1wjvu5Ra75UIyTz2Yb5uv4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c+D3qbmh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kyq4fCE7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c+D3qbmh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kyq4fCE7"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42B8EwUx026069;
	Mon, 11 Mar 2024 10:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=fEWkDPekICQQAKrNyDyshQd+7+PiDVGooUiaO1J7wxk=;
 b=c+D3qbmhYvgr7f7e1l9nV90b/EvwZaE876tJ1uevfCoyFecTHK0XkInPvQo8VRMZiBim
 MovxeiS0+FvvDeuKReq6omzJNr4JxsvmWmIwd5SnpU4ohxFDKbS0YgAZCgpL2hKQDrxD
 +ixRoMM4eIo88V37xEyN7V+VJf0pH9vC64mJvBcyUvJGRcsPiXu3nXcd14YzV6FgaFz0
 H7q2Z4gtZZ2fSq0Q8qeUJdbLPKkt36f8WGqn4WbsXPYrSptPveQ1ZZZpYnuu8Blv3vlv
 i71uRNx8vrzVNrHa2uG3+i97bv/54IMvZy6rEs4ejt5D6/5+qAUm2C/a/C1XcPS42y9P yQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfnbjunr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 10:47:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42BASkTe037858;
	Mon, 11 Mar 2024 10:47:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre75axgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 10:47:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXHaz35OIMpfrfFrJzn38DvTLqvzkkKASX6G4tePDGxMK+g1v/tsp9FzrZ9P85M9SYCVovn0HmndaC+oqTCT3TWybL0TnBGQwCxw4xHtmNK0rwXB3yhoKOmi2GaT8DO6VbVXtvIPgW80JgOQFuJebAjLwYAfO60YT5bVGi9aM4RdaE/a1CrlN0AjZpKrf88Bbv3zDIEQ3VzQz1c6sUhQuHzFkRqQnA3qe3FbG+wP8pJ3NOMkvN5nUMLj4pDzPCnv/lslxJQrU36WqitmZNyO0YU5DCzdKliLBfGKwebJ8EDGEaQwpxDFK8ZvTRQK+qgHZMdzTUWmksgRRtxrURmgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEWkDPekICQQAKrNyDyshQd+7+PiDVGooUiaO1J7wxk=;
 b=A7IK1aRv0ybZZ9QiNDi5vXYTu1fgZYb66HfJ4FkUbM9n4w205UkFAoVvpxPWkR3nXMdyy/5W/vbiluJSd1rye2xMbvVQY03xb7ywJOfluFThplSiC5qHkFdSqjifqOrtvQ767HGiPt5VTbFD5UDWvLFqg23+4Hphrvzd/fSi1zbp6rnr0v/zxjeJ3Z4clwySLVDi4Kmbpu0b4ISm4aCPyPKJb9g2d8qJQ0msqA5O+1IsrvFWNwQrHHLhGtrcoA3WFTxCLbPXnJouQtKPe1xXyQq3wTumaKqNmvUhm9IBnAr9OqBkF5retsPuvnhGZSTfF8iZEV52mgOpmCXtQZcl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEWkDPekICQQAKrNyDyshQd+7+PiDVGooUiaO1J7wxk=;
 b=kyq4fCE7wxDtCGoD2plk/oXuiQ+4Q9oZbY+ew3aSZc2htDelrfj/FIs4yyXUqW20OvJKBA5BKiIPNTXD86yRC2oiNnnwfK6ACQ3kizZH8Mf0EkujqPNu/OV6Enp4PHsyaZScx4p4CO1udUT7JgPEiy5O+qxMe816UeUmMsPoRvY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5674.namprd10.prod.outlook.com (2603:10b6:510:126::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27; Mon, 11 Mar
 2024 10:46:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.035; Mon, 11 Mar 2024
 10:46:59 +0000
Message-ID: <abef4b9f-a53d-45ba-a97c-ec2ff5885240@oracle.com>
Date: Mon, 11 Mar 2024 10:46:48 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/11] scsi: sd: Translate data lifetime information
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240222214508.1630719-1-bvanassche@acm.org>
 <20240222214508.1630719-4-bvanassche@acm.org>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240222214508.1630719-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a97166-409a-44d5-3165-08dc41b893ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uP9uhyyO1AIkI0iQX0Iwh6JzVv1qp45ctwKP/ObCiOEVjxNXV/dJBp5EjdyDKQvlQXdLLlxdn7GNhpXvO9PYy5p2QGT2xlQLf32TZGcAvZBCoPY2ANZtpOY8cK71rw0LrAx3GI2VULKiSl9fJZK3lbW5jcEb8FdyPBp59KQ+oopG9Ru32J5JBsdNRuJ1SxD8RKFt9Q+ZU4nZjOoICX4o2rDhkjdo3AF5NYh8+6NETgC5yiL6ELNd+ui5KJTe+mJtmSSbVoLURosNq3nLc/Vs6mwBKJsaR+paY/YPklt1UogdUm6ADkuWwuRJJ6F6Arn+F+x3MIX0sCjayb5o6LffQwK+3e68YVJ8AEik0XDHZXbq28Spv5/FWrelP32hhrU8lG1sXtFye7N9GtRBy525N+R5u1bAh+y3B5E8w8LkHNkuCzYe9LTMtxs54o7DCS2saOQY6yJBxRYjUDVI4ORo026t1hOZ5F4QF2NAINZvgsPLzB//bCuEvqMC0xf69DkLwqJ7GkGF/0ojfQgM/sLlimaK6np2I01q7bzpyS2fTchxRsbsjMmU358Gz1zhM3xU3+RZTUNOtMFliJT9pzEyLJb/pRdl2Gyk8PNKk9ijmVN5KniQX3Wnzt8f6W747O6Wy++ivaDULxWd8Kn3kMeTQDfIsjerHi174jzjWJSsaLM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bXNSdERXUThZMG9PVTR0TjFDVjV2cTcranJjT3FGcDBnMkVBSTRNYXlXbGd2?=
 =?utf-8?B?S29OVzJsOXIrdUFXb2MrVVgxdHZmdjJZOGtCNUZCOVcwNzZXaWJzL1hIbzJl?=
 =?utf-8?B?a3o2WFYxamhDMkdVdHo4ZjlBY3RRb1ZvOHlJOGUxdE55WGtTclplRm82TFk3?=
 =?utf-8?B?OVVUM3ptcVJGSWVPL1RubmtNTFRIbUt5SHlSTGJyblh4TVFTeWR0dGYvOXpH?=
 =?utf-8?B?TGJkYTllWWs5dDd4OGlRN0J2MldMcmVTRFRtNTdVOFFyRk1TMzBHN0JVcFdV?=
 =?utf-8?B?UzBQZmpHSEdHb21yM0N4RWRYUHZ2RGpqSHRsNW5Vc1hOOVo4T25xSEVLMFRi?=
 =?utf-8?B?aU1UQnk4Z3UxRko4akFKNVdVN2x0UXFGWXlVVEFYSVRWdlNrV2psK3NBOVIy?=
 =?utf-8?B?OTZLMnB2YmI4MHNYZmdLQytVNURPSUFOYUZPcmFDczNsZUdCYnFhTk1oTDJ1?=
 =?utf-8?B?RzNkK05uWEgrNXNJMFNxbWdCbmgvVElmSE0xelQvTUl4cDk5YU5mZFA1eG1n?=
 =?utf-8?B?YmJ6d3pNRjdIajBJSWpvbUlYUzZqc2RPOTc3a2RCK25EWHRjOHNGVDMyNVhu?=
 =?utf-8?B?SVFmYXZLR1pCMk85eXlKZlhQd2FWdDU3bmxDN1NaVHJHNy9xeUxTZ09uVDNM?=
 =?utf-8?B?RGlIaGdCYWNGS1ByenNPN0NpN2x6ODA2UVdTc0MrVkJaRG5ERm9yVStaRTY5?=
 =?utf-8?B?ZVV6V0JpdjkwbURua2w0U2ZnS2toeExFOXVBUUZsWm9BQktIeXdLTE1qUHc2?=
 =?utf-8?B?ekpTNklaMWY5c0pYVUFOL0lRcDM5V2JWQkVnaUlzQXl0NkRWRytXSGtHVDVF?=
 =?utf-8?B?Y2JXRC95TUhqZEY3K0VrYk42WkZlSDZKUmFQcHlONkJyODJtUCsxUG85OEJl?=
 =?utf-8?B?SUdrR29pY1R3M0FYY2cwZFovc3ZqbmEwR04yaVJMQ04zSzM0TFBEbEtmTUx1?=
 =?utf-8?B?NHpScy96eFVsVXRXclUwalJIdVhhM2N0TUpCd0tJWGwxYnVMVjdUa0QyWGl1?=
 =?utf-8?B?bGlzYUlpR0t3Q3JkS1l5cE5hQkQ2b2U5MlFYTkhDTC94bk1WN0JWdTRzUi9O?=
 =?utf-8?B?Ni9jajBQL2dGa29pSkNsMkZTRER6aDJqUy8zbHR2RmowcE4xbGU1S2xZenhv?=
 =?utf-8?B?RFRDMjZoWlJ1WkJGclJTaktINjdhdUh4YkszT0dycC9WVysxWmxuSm5saTFD?=
 =?utf-8?B?cjVKdWYreUwwYndUUnYzMDBWblpqdC8yNkYzaTdVcWJtTXRRWER4NndBSEZr?=
 =?utf-8?B?MGVPQ2did2tEckc1REdrRXJoQWRkTDJ5aXZ4ZTFTZXBTWWl2Q3F3V2xSSlJZ?=
 =?utf-8?B?eWl0RllIUGdsR09XV0JIVE5FT3h2YVVJL1dvKzhiMTFGekR1c2ZQb2dvWEYw?=
 =?utf-8?B?a0dmSkw3Yi9Hb2JwS0tUWDA2NjVBQ2s2UU0rdDNBR09iQjFVQnBsL2E1TCtU?=
 =?utf-8?B?Mkd3alR3eGNFazMrL2xPMG1uMmlqSGVIM0MvTUVUeXVQK0FyKytqNGZ6RVhh?=
 =?utf-8?B?azgrbmxTYnZnV3hPNjdNUWpSRTRlS1lFYjhhWFJpcWdGd3MyRFhTK1lBSUVz?=
 =?utf-8?B?Vm5UVzNMZUlnWVNibjlFbjdRZ01zd1dTbGZJRmNXVjVSSXRZZkRsbXlKNVNa?=
 =?utf-8?B?SFRJUUo2MnlKTGJZekNQZW1WZW1OVmgzdFQrWE4xY0p6ZDloNU4xQ0tZMm5F?=
 =?utf-8?B?M2xscno2RGZjOGo3eVRweHpYZVZjbzl6TlQ3YVJsbjhWazZ6SndpZXpQczFE?=
 =?utf-8?B?cG5IakNIcUwxZG9JdFEzUytTeHlseGhGM3FaVUMyYjRSVGdZQWphK3YvMVUr?=
 =?utf-8?B?bkJ5dTdXc216UWN0K05vN25aSzI2RUYzaFVMS2NFSW1iYUE3T3VrN0Rka0s0?=
 =?utf-8?B?bE55TzIvb1BJL0hRdW9qekdUcjArNWtCNUFHVWtRY3JUZEZ2Z0dxYzhvRDJO?=
 =?utf-8?B?TGw5S0w4bmpnbXFsREJNV1hvcDVhNmpPQ2FGYW9RcDBxdUtRYnVYblV1bThF?=
 =?utf-8?B?bnBaN294YzRKemI0MEZ5eTA1eWlTMzh6aWRWdHpSVkJXREpHNjd5M1NZeUhu?=
 =?utf-8?B?YThQN2FOa1VJN0ttMkk3NDFjTDZIazhUbE9aVmV5cDhBb1JQYkRLUzFZLzRY?=
 =?utf-8?Q?QzrZhgWRXHJ/UcCnZVIT80+IN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CUOjpAmzipEUG32SJiOph8Pc9sIpin7AvRo37j1vxw8lUUAgQ9P0JIRA8zaPeWmtQAX5n9jlC2FikOF9hUweOHJv3okBrg3CrZS0iEHt+WPnbXr6G/uQlHsrNkYUukMmpgMTYhUOS1SkHrA9egCt4zARQJ/sMNV8skYFXFGA+Me76khLJX0onghlk2GCG8EHqUmAzs1ICyQV2qMDUzh7AwRehu7S0qYeoRuCZlHKdTmKYUt8Nh16Q3SsqWzAsrO43OyTnJ4oroG3rbRXumj0s9x5Cf8MZ4bvHa9rFKccGEtVrLR+SDaooCSa0pi1iPa+Y72xrGE/V3+nraRER4BdemSyHqge/zFcTXUnZWKd8fDf6AT75JAp8ZEpsW78KwHuk4outK/qZG93RBVrAZhzdF5B2xawMoKkYPrA0K+3mAvP70P5Ms6+ESUBkxVwHOz/weoHzY5aUk017vvFmAfSGCbEInYgiXcOEkQydgnQ83ONQr7SKFS3PU+aG4MQHFu5OnS64a2xyL7DnaGVjl3G7s/I0sDpEI/M4Gt9Zv/xQFTcETnJj0VqQvi5sd31vqa1sS9IChwUHuI6Zc9hWmYNgSnL1qMM0MVbR3cKFj8nrOw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a97166-409a-44d5-3165-08dc41b893ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 10:46:59.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PX8hb+Tce44q+t+G1OZbEjbpoQ2bZjarm5r3Uj0PQOTWAdfB+B2h70a2GSZqO6RfA0ztVekF0B/ogBIOedKygA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5674
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403110080
X-Proofpoint-GUID: 1VP7EtKWoDDohLDM6NMr9FC0ynAkLaMI
X-Proofpoint-ORIG-GUID: 1VP7EtKWoDDohLDM6NMr9FC0ynAkLaMI

On 22/02/2024 21:44, Bart Van Assche wrote:
> +	sdkp->permanent_stream_count = desc - start;
> +	if (sdkp->permanent_stream_count < 2) {
> +		sd_printk(KERN_INFO, sdkp,
> +			  "Unexpected: RSCS has been set and the permanent stream count is %u\n",
> +			  sdkp->permanent_stream_count);
> +		return;
> +	}
> +
> +	sd_printk(KERN_INFO, sdkp, "permanent stream count = %d\n",
> +		  sdkp->permanent_stream_count);

I have been testing a recent linux-next (which includes this change), 
and I now see this following kernel log just for writing to the bdev 
file, like:

# mnt/test-pwritev2 -d -l 512 -p 512 /dev/sda
wrote 512 bytes at pos 512 write_size=512
# [   22.339526] sd 0:0:0:0: [sda] permanent stream count = 5

Is that log really required, especially at info level?

That is a scsi_debug disk - I assume that the relevant io hint feature 
is now default enabled there.

Thanks,
John
