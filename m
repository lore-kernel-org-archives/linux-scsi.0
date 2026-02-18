Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3793F1FF7C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 02:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771381631; cv=fail; b=Mx9ZZlNgMOYG44nOKo+3DshScGDiJ2iqyKiNHqHZzU3QV4jdM6enZ436s3ciI9FHgcUBiwcMSV/E6FwEq/VpMgD3wbJFXyxka49SUQtytQEBOfsNROvt3p0FvuAOZK1BoZDkGx40CgZDNQ/EMMCy7wJyUz9XQTdDhQDxbnTk5i4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771381631; c=relaxed/simple;
	bh=aAzn0OPb3MzU4AjqwTr0BX6J7ORrIbkPdFJV7xiM7HU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=l+9e/1Qh1JFWYEWkzBaDYNe7Y4UMH6B5vgd0nA2yFjt/6Fj7kyFw9OumwvuWkuAjtLsd4iulc4f2YU2LjPnDDwoKXKzHO+Nkq+/s8cCAtVj7hn4kveMUFXCwipFlWhjhMU/bK9JPIt3ewI56QDk8TZEpUrx18I8tEOe5gewCATQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JFwejKE9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fw4h8gjf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JFwejKE9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fw4h8gjf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNUYT495460;
	Wed, 18 Feb 2026 02:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/XzFfIyAh7oE5lBmHa
	IPYgEcCDbAG3ZOpWZMIVq+c2w=; b=JFwejKE9nfHaW433juEVpwi3/w08o03A3H
	4sJgz/iFLzKIH17xA2GWJFQmovqEAZdUvV3FwZ77esKtYZPRB3tLidm6Vtfn+5jk
	Ek/sFTO8Lww5sBF3TpKG8jCEq/Wra6Ld0+ELkbKTezPdMMnv2hYJcR5UD9tBp0gI
	9VerAiWhVW4KZawzoDJkOE/gEv8vr+iWHvRaPbqtfEXUisZsCu6iZFSwWTxf1gAS
	RthWSGSk0IDmjeBIUOTzoaFn/mRiv2h1tGa/pBC/KUwW1FWSc8HEMZHeJnrotg/8
	K8ZlM5T2id3FeXRAgQegEomFfmIg8riljU3uXlJmvOZpBtDdFeUw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6mcr27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:27:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61I2AEGl037247;
	Wed, 18 Feb 2026 02:27:07 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb281ahe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 02:27:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYnMUMCHraaEmGABT8/U8Kh9vgojG5PH1rgfU33TYuGQ7KYMu9sewoi+/jTnOqj2KqZsB+lncTbJGi1UyvD6lj7XXtFvFpFRYv9QFxp6BUiyj30n8a1R5SyhOgkF7DEiMrsCPVuRn1wK/VKAR2JSoWTloWTvYcU3JbZX6lyPfZmndwGRk9cNAZlAr0DoSgQnxPpVcDXe/vajycj6SgGFhIS3L/KSIcbFH/gJjCDWjyUgFOm87cGU69mXNR/+dJMOdjvt1qQXdqC9bY/2pbTJl7sX9mGeD+GEskFDpg39wCf9XfG/Qr7+8ThHupSAGB9J60yrQ99kydwI+O41F6w13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XzFfIyAh7oE5lBmHaIPYgEcCDbAG3ZOpWZMIVq+c2w=;
 b=h4rmxLa0usIWsuXPgeNs2iXhZOk+nXoJ7zq3s259gBhnzi6RtU4iayt1N7XrHZ6CsamgxRAYdFiWKZTf3yP2i7k81/uZ2WHHjDtH1msEPIup0BtZ0gjQd8EqHCmCB/irD+bAY/gjs2X9NYDehy51QMN9+Xw1hXs/rzfzosXtjfpeuM4dm4qd+EcsYu+mvNFxyWduarK8A9wlq8Fi0D0MxLROY4gNOi3Bw5abQKMIRXV7RZLga8KZ9jt76nwXOIPooYhU57ReFzWf3ifkoHSDz08ofgem5wPXrxq8vlodcGuMGy62X4a+wHNHApQnpodfKCY2oXrkYBSc9p6SSXBD2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XzFfIyAh7oE5lBmHaIPYgEcCDbAG3ZOpWZMIVq+c2w=;
 b=fw4h8gjfk5OBk7fP3DKRLrUUw2vLnV8XeY9+EiuY1y2qdRpThAFV0r4CRDDWB/cwmRx/pyyXM4keIDYtvw6JdsLrL/QCbVM0ARoyv4C+8m+0H7IJ60lZG0mHF7JrgwVQjonHSjaM+M4QUud3SKqX98t4DxMPdUipzk9Q+auHkNU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6286.namprd10.prod.outlook.com (2603:10b6:806:26e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Wed, 18 Feb
 2026 02:27:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 02:27:03 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, djeffery@redhat.com
Subject: Re: [PATCH] scsi: ses: fix devices attaching to different hosts
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260210191850.36784-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Tue, 10 Feb 2026 20:18:50 +0100")
Organization: Oracle Corporation
Message-ID: <yq1qzqieqhh.fsf@ca-mkp.ca.oracle.com>
References: <20260210191850.36784-1-thenzl@redhat.com>
Date: Tue, 17 Feb 2026 21:27:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6286:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd9e470-d7a7-489a-8001-08de6e953380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XLDcKcfVKrcllJ7KQGLQuF89hzblxlGxBSnj2oBR5LDRei0BIeMacEFcnG0j?=
 =?us-ascii?Q?w1LZBK9q12tALW5/zno5EwkX3pfNBnu1/SE+U/nWn9vHdTLzMdIKYDuxkje/?=
 =?us-ascii?Q?WQu8UbYLZ1UJg1JOMymsBkEpECQacWl4kbWUvH+pWJ1ydbypEQ/dIVxO5vGB?=
 =?us-ascii?Q?n//ReoHrYgDCcdGz4GPeMgwddRjAQCR7Q0u5EehvT7SLGGCV39ol1DtfbbA+?=
 =?us-ascii?Q?aGuHIeqLvtdQDThvxtjnd4+aAuGzjegya8bm8jZuG+t0JhvR0YfUG+ZsyWCU?=
 =?us-ascii?Q?w+/6uG+tlVfVzq1g1fXJKsG0m9Y+fpsu44KHwxJ9xEivfV5bTbUunpGTcns1?=
 =?us-ascii?Q?k057+EQYL5YIvhS5LlNMRn44JqT6B3rfrj0huGIN4seyEA1JsHMVU9BgPeEG?=
 =?us-ascii?Q?8yVwPtC0jyjECf7lGXhgkdu61owG3bcBcXyuknSTbBwMUc28vn4PsRNEresk?=
 =?us-ascii?Q?YiR637z5cO0dC0aMX3k2Nrl5t+k8aJ2u32egsQydpSx38l8uoTzdozLEBetU?=
 =?us-ascii?Q?dIj0lt+WApbv59vDnP8iGe6+4+tkG1/aPAesY1UnJFSZS8ydGgy8Sbuu0ecM?=
 =?us-ascii?Q?7FBDCcX91cSkcdBG4+T8yig5Rp7+/90pxuVYXX5qgcW32YLUtcfW8Bw+8AAR?=
 =?us-ascii?Q?fE8HfM1exnuXKnSDxN8yppRyB/IyvPvTMUMr3dyBdLp/ObY5vqlWnHJZ3TPK?=
 =?us-ascii?Q?3Xv8csHRCl8VqQeO3QR6uMDFv7Jz0u9aPjT6WKc7qVOUhDZ1KVf6z+B4MsC1?=
 =?us-ascii?Q?ug4m2BstOxPvw+H+FEXsW9Q2+9f1FA58M1KTsqEvC3sYeobZTOOI45Kag51R?=
 =?us-ascii?Q?BELIQcz74gWltYGY4ojFiyIG+Dq1W9DaR4Jxxmmi4u0e/zoLeHC+mhULJCBF?=
 =?us-ascii?Q?u67AIKtjXW3dOAShR1sDFeV99LYn+CVfp8T3cc74i/O5dgEfgYGnJ453xdvy?=
 =?us-ascii?Q?WrNjBzXmDspKOe2RgQ3ogMRKAM4VklgjbQv/B3UHPbKsjF49FIXrdecPxSdX?=
 =?us-ascii?Q?hhPrT8lVFcsO5EkNJHBZXgONLHBaq++IUKTOOC70FLAMfPRC03P3T4Hu4dNi?=
 =?us-ascii?Q?ZLMzvv3QOGwlCKYipmBHSIbSHkdeC558MrEmJ0otApZmY9skihzo6vlKHF/m?=
 =?us-ascii?Q?EsQaMUzEQBHLktKiitDDvWsMfafVQJzRh4ufoYQMTjHGk5lkSd8dYbjMmoPf?=
 =?us-ascii?Q?3K60pSj+2J31EhOF2DtNBxjWMpuTquM2hoKH2Y84/+AjPkmG/FbeTHK5MMxN?=
 =?us-ascii?Q?8hC3n0J86tYqBNGrUQJXxX8/qeg7rKOi3QscRv7yPQ6RAYHNNr0XU9M4GYws?=
 =?us-ascii?Q?WdPNN6+ml/gstJLvbb76BzmzTCY/9L6f7KFChA1xIVz3mjdkfuVQaned3LHM?=
 =?us-ascii?Q?FhI2t85gU5V0bdsJz2Ghv4t3cm5J5P5w3FU7C+yP61AU5G5ndFtx1xyQhPOx?=
 =?us-ascii?Q?735cFess/6MU2zhkKw5jApXk2QVnPWQ6/46c1o3AxS8Nkm3hhJ4Xrs5Maqvu?=
 =?us-ascii?Q?MwuOf1E+wak4sCebObMNkDegIQfgWWytzcPkvP+x/i+JkAgte4KISSig3eUL?=
 =?us-ascii?Q?TIx/V9lSgokennuB+bg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pthg2BLEGQQtv30ilzdX+rc3+Vg8YXJU1NgS1frkZ2Bf8SEzbtomhdY18FYk?=
 =?us-ascii?Q?/PWdnFLd7Cwa1/oeLQMyH8oy2IelRu28/PwkF83SWJtwI5bQv9Bg/jf8I16p?=
 =?us-ascii?Q?oI4iPORxQBFcjrYeJNJ0LPiEF7UQK/CI3HBodmvun9joozkKS4ZQ09zBqcEt?=
 =?us-ascii?Q?o3A7NkL7TW6eFr3L7UamM3rzsiUKSvJlF9b5z2YP0rM9gaJoi346tDjuG67/?=
 =?us-ascii?Q?oQ15qCb8zRBXsw/OiMybrAO9/kcRcrMw5UBKgfla58YlxUPulDuCOthG3RJD?=
 =?us-ascii?Q?aUanq7HcJy40AVx1n1dXhvK9j+VLUMtDEqb+hImV+jgzQAJSdmSjTMcKgQI7?=
 =?us-ascii?Q?2HD1/yLMhJmq0bo+4r1UEbzZBLSZ3umdtdOZNkvuTFuWVFRuinjqSy+adAzI?=
 =?us-ascii?Q?FqY3YcluYN8R87j/C2Eqy+PCbjhSMpzv4dXU/0vTl+N2vIM/ursh7lYqhuZs?=
 =?us-ascii?Q?UGBSFcgGBdJG4hMn+b5V58LitW+eSW3my91lD/VyHwst5O/Cv5ixWUsWiHFy?=
 =?us-ascii?Q?28daokuJFkQ3CSl6YAtrlTzH1E2xLrds7CpYIYqU3fgX+LvhBOghC73e2U0e?=
 =?us-ascii?Q?qgfRZfZ/Qf6YPBffb/etJcT8Zrpp6vJrQouMkumw7CLbV6w+BZI2tfumiMHr?=
 =?us-ascii?Q?LA6ofXonJSbJWztCEB7JRg8IAkwl+qCC7NkQSibZ6EdbbnwAkP2sxIakdGFw?=
 =?us-ascii?Q?Wbu+6FFZFOYsnEmhw+i6frzwov55QZZ3C6bqIpV0BTerqJ8kp4In0TZE2gye?=
 =?us-ascii?Q?ACXPe+NG7T3y0L2b0uX4TkXYfhJ04I7spwzEPjJIvZhN/pFGEuhHiG8TMamU?=
 =?us-ascii?Q?aIBqJO4thJSn3jmvUA28P6iYOwpaD63otY7DvPTkkDt58NgSVna8/8Cl//Dl?=
 =?us-ascii?Q?tF9uvM/aZRV1NH7tY4VT9fjIEL5Zs1gv3qrmURfxgSBosXZJNBaOLSjacVYG?=
 =?us-ascii?Q?v9Gv9wOQa8IAWH3bgBtaj/z29VJupWVM8uZi8vdv96n45TK2R5Z7Af+jGYCc?=
 =?us-ascii?Q?vFO63USgbyNgYfdect6c5zHx9t+Ksw1iIW641z2jgnPelvWRQn+Mrlkceic/?=
 =?us-ascii?Q?lnCb5DLeLOv+1RvoPwQaxOTfDVmDgj9vhUNYexMqJZVlsEowzVFUuDX+nQSO?=
 =?us-ascii?Q?Ihbf4Md4RURgMMmH/enyLkYveKqkhPb+ULXQ8+E7Jn0uKIx7zVq0fmZu4XiK?=
 =?us-ascii?Q?5n31CJmF2PKkpsRmpaJVUIVA2waRRNslvKV40AEXvpT9vbC7HSzKfHWMF0sP?=
 =?us-ascii?Q?/G1kqYxdeYE0vzCSpCQiq94GGQfxIhzxQSasmZ7F0UPwFRaC+mwKLl5eQdkq?=
 =?us-ascii?Q?tMEKyhBLhoIZ4vJxuJP8C/mvRh7p58sZEYLDMEcUOKs+Vk9Nmv7tVIJRVgoA?=
 =?us-ascii?Q?dLmj16g5+fsahC6F4GqjwMoWcrplkQ0ASDRgqe+DLTpuuU4mA395IcLcNMNy?=
 =?us-ascii?Q?Ygc/9mdy6HZuqds26qhhvz+LSrOSF8Q/WDceJmDguMA91ILNX8PEEEgCHrXz?=
 =?us-ascii?Q?1dxc8XPIsAZ+4X7B70S5iL0TW0KzQHHx7x37QxDLekK07GZS9Y+h1YkU7Bo6?=
 =?us-ascii?Q?nUdMG30hrs33Q3h6w+TVKWAsStPCBU6qYlMdywcA6l2oo23R8lMm/IZP+jh4?=
 =?us-ascii?Q?ZKA0NmLeHC57LtRX7vXCUqkHzb8XkOw5eJfdWMjkLwzjCqoUpl/ShgiZP7o6?=
 =?us-ascii?Q?M+5HL9pyz5E6oJ8g9i7BaXAwMFupQzPkiEg8rA5MGAWa86Sb1O8vORgdfMEn?=
 =?us-ascii?Q?sphPOk5rmVmMaY5oI1bjjtTFf4XjxIY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TbKhlM09DMTKpwhuGqRJyjibnSVIDK04l7AeQNknEp6BkfDQafLHy0DxYCOPlIwUkukNpGmow/M5qT3v0nbf2fKgRLGBcxwQ7HiwIYeUw+8Lu1Z3qQggN1lghGhS8opA+89+5pLrZuRlBhNQIxwhayDOaIs0x5loj9fM/XMuiSmvk/4ATLsncpulL4uKNpfXV6ihvmUzgnqg1ZzgRgJnCi8SqJQ9jhFnIAAkQ0LDz6hAuKtfQOWDIUQd2JleyBGPBWLRxA3UBN1pRgcbsaKLhmgw758WalN2XzrQUvBkbqzAEmNLDM4sJjtOA91mTzvxbmW8E3chQzO9QlS8fJcrl3LMKIxB29WPVzQn77Xsfv64cFVQbRZXWIa4Dgy/J/N/JWXqOX9AV8WXjfctSTlTJJiY4lhbGjaYXQ4um6LsMGUJdBYr7wgWPc0LiTqSxkkuBQEyhJSfMoyysUVLBKz4ggQlqnsCmpV9ve7PG1kwmotcGmCdXbtvcugW5adv0CDEFM3GvTMKN1FtwBaIcKAPaMhe0lfbxV0ZL77OzxlpqAEUio00D2mLhqhtDPV/AR72vNYU8ap8LPWks2NoDtyMYRuJHKEjUDLHsEo2CXlLoxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd9e470-d7a7-489a-8001-08de6e953380
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 02:27:02.9237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DO8H6O74ImSujCIzv81mVAJbG2w/WLhItQ67V96ABtyigAeuInAcp9DuCVMA90dJpD6HmjteuQpZzjUWMVS+LdZ+0vnH1E5UzTC+ZxOwCSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=736 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180019
X-Proofpoint-GUID: PNg7dBtyUcgJF1-RTzZK9m3sVNPayFd8
X-Proofpoint-ORIG-GUID: PNg7dBtyUcgJF1-RTzZK9m3sVNPayFd8
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=6995237b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=EPAAsEYDAsF4OvMgnhIA:9 cc=ntf awl=host:12253
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDAxOSBTYWx0ZWRfX8Obu3ZXr/lWD
 hnLN8vyIjNYL7RP+ap855mPKXA8bsM93AsJa3dDPX0mFTDd8JUhjZoYgXDrtQ3H50YDR1Sqal0M
 62lLYN6SdYmVIHJ1m+VAiU6R+Q+j0oEOn5NqLPY6RcTvhOkUQj2xIXfcz6UGoxuvjkYvUqepotR
 eCCBrA95eR0s8SwrxyhdUwvArtw7QclwjHaTFuCCN3kkVGu+rCmBGrVFWdYqPH1NN7PP/s1sx9h
 0G/udBlWHiduHs/b9XjH7QKGz35xsNjVJqmaprwY1lQJVe471c4l3T+BSb4W/t0rXRQC5CKBT6Q
 Ab0BLCOWN1FGHtwhbbiTR7a5pGqHd4aJzffXqsRcoozsqI8pxt+H0SaFTwjBFHZwBooJ0JBZ9DD
 SZTtBtNiMTZDp0wqLws72yeASPcGArilDOYiXkdrSiFDcnSuPhbZZKv6wTc3T3KrgPA4pYE9G3p
 aysSD6qo0IKXeAepWbWZ/7NoIhucshhRDtiTrJBQ=


Tomas,

> On a multipath SAS scsi system some devices don't end up with
> enclosure symlinks from a scsi device to its enclosure. Scsi devices
> which have enclosures linked to them are linked to enclosures on
> different scsi hosts.

Applied to 7.0/scsi-staging, thanks!

-- 
Martin K. Petersen
