Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585CD2E36E3
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 02:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753411594; cv=fail; b=cuTjwINT5Y8AcPgK62LN6uhntqX02bmsAO8KFt1fYWkEvq9/zPs+Eh/NKHhVaA3TKpXeG0XozoUuU6RWe9u33lLnDzKL/4j33nJChyZ7ICZPcQQYGZzPxMHoaDb7gi8Ugq3ObDWFkbmWtNUBs9fW8mwCL01tvgB8WXNojktfrf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753411594; c=relaxed/simple;
	bh=eliqb+qJzf7GU9YRA2r5DWJLsRDziFLeqoCjz9R6C/k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Y4hR7hiha8obSA5VxI6Ji0586++NpwnWDGkUaPjpOGBxQqMk3ygiHNFd9w2tXeZf8MF9FKDtMebBy6ftFhZnNiQRqBULJh1uYmNu9USM8slMOryaNE0fHQNV8Z1Ov6/ZoKXRclvg6wuLivHgyi7WZMv1rJZV/PBdwxzo/5XhHZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OSvPJscl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uqqNb5jO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OSvPJscl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uqqNb5jO"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLk3UX011892;
	Fri, 25 Jul 2025 02:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/t721U8FVWRpq0o1ON
	UzJindUQcuWO1l1UMsnv0bbIw=; b=OSvPJsclW7PsEAQYRMJ+SHQv5VU6vwSjnz
	1d5wzL14EOuMuXWdqxLr1b4QABkZMSkrtmhjYokJx7yZUv4BsDVAJtQaVLSbKYM6
	XHOO5AjPS/O3jYTxdroOA1RYXBlRWwhNIQzCpbM9NmG+2dMNFhXL8DLBpLYRwXK3
	YmKz2Jbd9edS+Q12Lzl9vwm8EJ/wlMx7BuhFQbG17TrxmVOE/zQHL5UCoMSCuoR3
	qDroH6CYzeY0i58WvUeUtOnwvYZVnlp48FSwRYa5TAqHx2haEzde0l7o0AtZLVVW
	/2nLSNfG895mZtT0tomd2gZLf+Y2Hu8eS2NSSC7uF6ty5IyuE+3g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k880a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:46:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ON8ZMW031433;
	Fri, 25 Jul 2025 02:46:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjwb3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 02:46:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNclUPtW+sMUZbEGMijEF3nXgOwSYxS8FdcMkYdA2xvqt35WTkuJN2NXFtghCvBQRtaGr69ifPaqEMlKkyHcsnz29ZP7sujdSLpQvsflPgR8qyhgStVh0TBQWB9MmpzwAZUfO6twZBoi145GQaDHJQrgtCllryLCIS+LfH7aSYgJkc/yVwXUmIRV0lRqsjmRhrfIXeBcxFb9EdDzrGQRZuPmBZWdtLYvXfz4CSCbyLloZnVe0sP67jHYyCilIWSHGaPzQZ/iYTdlbH0JulAfsFmjWrFArP3xSniiDeXKodt1BaeYpc4DsyYjno3nojIxr+UjKTL5RUnSnx675/9avA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/t721U8FVWRpq0o1ONUzJindUQcuWO1l1UMsnv0bbIw=;
 b=HSFrRfyFR6PNy/6bNcElhtb5iyvr1e7EMxkyvsWKpHxsPsAtXg3O62gIpkgfYyXRuGXZp+PI0MFi0H71zpfAwVxCDkvkdsqTw/Vj5wB9UZpU4KxZX1XzAMJM6bpkK7dTuvrlsP92wf+BpZyedYujB+hAEFatBYv5I+nsW52vBjY6wSWxMh7xtN0hVawkr2fVAkLMEeU5jipS6usuFBtaNjdzeYfM82VnifN/eJ5ZY0ewSRDfIWp7JbSFzTllAyOQf3pkSwzwl3pzkPIQ/WTIiaJpqraz48HvCkZHdq0VX83y5NKiyRoiPwEkD9LwXw6maOexosksqwfSuqYeJuuKVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/t721U8FVWRpq0o1ONUzJindUQcuWO1l1UMsnv0bbIw=;
 b=uqqNb5jOVZRYpCfiHk2DeDKoOSwFCoycSdWaZWwf9dmfTNrxIQquIJAzTtA32Oc7N4TWG7RNRI0EyFQBNhAajYYDU5HMGDXI99PDPKhAyWs36JD93ocpgJFu+uBywUsXoqPjB+dBKgHCnIRIRm5C6Ia3aHZ8vwS+5ncB41Gb/To=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPF54C97C915.namprd10.prod.outlook.com (2603:10b6:518:1::79f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 02:46:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 02:46:16 +0000
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Martin K Petersen <martin.petersen@oracle.com>,
        James EJ Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Avri Altman <avri.altman@sandisk.com>,
        Archana
 Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 0/8] scsi: ufs: ufs-pci: Fix hibernate state
 transition for Intel MTL-like host controllers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250723165856.145750-1-adrian.hunter@intel.com> (Adrian
	Hunter's message of "Wed, 23 Jul 2025 19:58:48 +0300")
Organization: Oracle Corporation
Message-ID: <yq1ecu5q97b.fsf@ca-mkp.ca.oracle.com>
References: <20250723165856.145750-1-adrian.hunter@intel.com>
Date: Thu, 24 Jul 2025 22:46:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPF54C97C915:EE_
X-MS-Office365-Filtering-Correlation-Id: d341dc06-0541-44ad-4ccc-08ddcb256cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b/TrtABXOPEFyobJoeL+9QhMS2XtYIaWg0ojqtKOCGsyK0KRY9bGtpTu4qo3?=
 =?us-ascii?Q?yRUSwRk9lOUYG53mPaKABALwzb8PdUeFxdYcH5/U+ur7YxT1HWDxpMRuGwtK?=
 =?us-ascii?Q?X0Q8fqikAKPA5wJFEOx0FRrLY3feYZy0ma049dkLUw9XtlYxdJZxlLZqdFiT?=
 =?us-ascii?Q?Sw7Wy+Uud2jtvXgEKusx8RjOL/CV6VuvvxITfe2+vVRY9qN78CdLza3G3le4?=
 =?us-ascii?Q?GD2gb1GDDZYAID94cU3LlKqslGWtqIaJDje6ScEyTEDe5C1517axuVg3RFc9?=
 =?us-ascii?Q?zz/VKAnTXd5BL4TlEnUZdtfXdQvJkI1lD4vsLEtd88nvmtusqixfA3+oWmMm?=
 =?us-ascii?Q?YgjXCkSVRyTdW6Sr2NzNrLZsKRL/f1QlV2dx0N2dtD7A0vYlE/JFMUOesHUL?=
 =?us-ascii?Q?iL8zzmYWTk1zK753scTM+qMyM3oJkr+rZl2tSuUx6CYr8WVDC8qBXeook44v?=
 =?us-ascii?Q?rFWDMYn1L+z6lYLKISxZst1ayO5FGy9kIAUnGB7xgKVGo534JgJwAkCiw0pX?=
 =?us-ascii?Q?nqixLWUwyVWlx5H+EI/GNtny6ndSabM9jR+biyJT9nnnMHsIkodzgWEwdGwt?=
 =?us-ascii?Q?V59I9d538P1X6wPMYVn7X/1qZs/grIfBSrPRTy2BrFjr7lFsuJ0z6lbXMgCd?=
 =?us-ascii?Q?7BFibREqj5OCcD3SPTWAGlQbVEFr8FOD4dbG5S5Lk5Nzbd3WpvDGfNzLatk8?=
 =?us-ascii?Q?c+nQrdAjfOyI5tNhPGOeySl9MZZ+X3Evp7hctryax7Q0h/ePHBBp/ZjiQFXP?=
 =?us-ascii?Q?H+GS864U9BNbKAgIHEA/5qyUxwW5+75329jnsvwLfFjTBhztMxQWnCOeNiIH?=
 =?us-ascii?Q?gJxFqqBgwfHOhbE9oB/jhQGGUI9xnSXKUbjypE6tGsfv2CK0rqU//7sdlFba?=
 =?us-ascii?Q?mC8HqhNsjMzXnEglSnJokb0uLmdHJHouwdoLs2uHYFK5wp9ok8jcMqRosYlw?=
 =?us-ascii?Q?NUOLUmVvoh7H6aeAGZhxFJnS8yB+iVcXe5OEnKKQDPVbzK1Y+0SqBUFqkTWr?=
 =?us-ascii?Q?Bzk246Y8EvotTIHcwEMeq13Xh8SHdNyqgy9ZeMCXZCSQT8mA6jJXi2fyu3Tx?=
 =?us-ascii?Q?SvRuT1QuB/qS0cazT5Fr57xM38bk5E3ThVT/KHoCIVJV5QoJ+SaZKsG7tKTx?=
 =?us-ascii?Q?HxDzfn8plMYhfxLw40x4Z7uKl2dZP5tgoJUGhNP7ugm72TTu4ZxgkTpEJ+Dk?=
 =?us-ascii?Q?g+qdw7J8KeH1IzEu20RUw6MFSkwm9O8IGmxaPRNeINMXVJhoIRf5++UnMGx+?=
 =?us-ascii?Q?ja57u6goaTRr1BZ5uOjvjVo36NSqh2yCBEZtWvB6+qNX2smFhuVr5exjrjKV?=
 =?us-ascii?Q?Jw4ZfbZZVAhcLaSspIhWueEbJRynzosnR8yZ9BzrX64OBKLwp55AvHoFcZ75?=
 =?us-ascii?Q?8UfOX3eSYLN8y8QShysVA0Di9Dpig/4KK7vGNlTFOfZ287uJXMTpekTgYrkv?=
 =?us-ascii?Q?nVELV/q7GEQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTpvLWEAyJim6GpTtIUgJQ/NF/d/jIgSN3IliVbK3xwjDlwB8PP+pIv3xge+?=
 =?us-ascii?Q?WhPJZIinvI5MgEdwHiIWca6xVw2GwT4aYHzH52ic8FCRgyyuN24dY7GvophO?=
 =?us-ascii?Q?EQzpqqNKzr6UCnsVL7vEmHCRubse2xKV5b7MbyD5Hta+8/pFgi313gMYSl/i?=
 =?us-ascii?Q?IUCqyippIavGXJFYH/7Wh1HykhA35qg3B/3fobVZoVkIaun3m0PJ6FqS41UA?=
 =?us-ascii?Q?Q+DQ2zJfwOFUZQZaOLW1ogwaKPI8Wh2PUe5ZH5IC/mDlfr7Ou66i/7MF5Cn0?=
 =?us-ascii?Q?AUE/eAlUUJszgkiDD0zKIWtp0Ps8I/+Ls5LeOAYaobo+k7iFD677ZCM5CWXe?=
 =?us-ascii?Q?27RWKY6k6M855i6V7hos6MKn8iM2UKN7QqoUq9gKiRaa+LTs4fXH2h46uKSO?=
 =?us-ascii?Q?AOQ9vwG3fVroh3o6sxHfBoxC8VovQ+xO5s+Q9cu/4ZrWjdGvvyd5mS/1UxrV?=
 =?us-ascii?Q?oe2RqxjGA5OEVMJ7iX+dGLyeA8gyrq/P9WuBxKwNWaXacDCKP10OLZrjxzkT?=
 =?us-ascii?Q?fAlHLiZeOzHlx/YCULBlaBpUpvkGyLqVK4eOEjVtdDRYOw411rVOzxUud5Vv?=
 =?us-ascii?Q?QK+Jd8hh/MrmEQeC5R/dl5PFC07hBj38+ZEB6DmwIzJecoNJWEcdMgBTQQeh?=
 =?us-ascii?Q?qd1iIEtEJcsK4vIJbkpNFRsZy9NtPwlmj6ZHSN4yyq5VG6AOo4w1n+PCkl6z?=
 =?us-ascii?Q?XE0pHyShby+M2+brOmWsuD50pJmjmc0RtloT11zZblhU5Gv+CtT1v0B4xLHc?=
 =?us-ascii?Q?gw48DhrXgKKqjtJ3Kai3j55aLI1dOnt+/ZGJ+L7tdESuWJ7z94C2Klfxa1H0?=
 =?us-ascii?Q?HtwzrnCevuEFW21kLwSH8gHhzLisq09Km60KwRi/rcQ1p/d5Ec055+dj6Vzz?=
 =?us-ascii?Q?NcqrCDXRYEuuu02N3h6oMUI1pqIN9jCXxDKr5eNRsZpOyWnuPAdc7EqRyDAg?=
 =?us-ascii?Q?wRW/A8Mx0nGWTm8lFLpH1EhoonrSjn4pmo4R350nxTwKmk9Xn8m/g889dXwa?=
 =?us-ascii?Q?scLo8PgNZxIiL3am2G/KE9/CJk7LfepT/RguZWkqcTvuDODTT7zuHuljA3qg?=
 =?us-ascii?Q?e7duENslmBoANgvF1zlGJEWlReU37B/8wyj4BVvnvC7RfXDFsMClRh5O0/hk?=
 =?us-ascii?Q?qyJyAK4LFbAwCpiiwWY2kAVck5rddBM1fkv9AK3YMGhLEYjB+ZGYJSaEyPDG?=
 =?us-ascii?Q?sN/O5FD4R95wEcSLyaERbNxWOE28gs2x5PdEOjBf7ZrbckQpnngXyHw1aYG6?=
 =?us-ascii?Q?GwR2exmUWcJsSrBlvhjAURiNgYisySJzIUs00FN9Yxxwc1Z0nYol42SmhBbx?=
 =?us-ascii?Q?s7dwUJyGiohfaH1AHC3lmRur2UnTVabyp37N6KAkoLuleSY+XlCdaynTfs1b?=
 =?us-ascii?Q?XtL1mI8FyUZZUMIII8kLfxJKpd9CSwDHCBsjnGAx5wrMiysCs1bJgVBRr1hB?=
 =?us-ascii?Q?Ywrm+1ycWvYtKYV5fOqPtt9HbIh73X5clTnAkrYEtnZlIi7OtiMiBN1nhNyK?=
 =?us-ascii?Q?miwLW+nC6QU1TjgSf6J42Dn2EcgrdW9IMt1LGaIiwkN9HRFqDgsqGUsu3hba?=
 =?us-ascii?Q?xEKVZQ5sIwy+H856Iw1+MNm/9nycJHovKKc+wkYqkQ92SD+fcER3n6F1F+tl?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	35bfhB5WgiL2JplFhFF86uonLVEGTPamAMQIKSDQygMSLdAVKMhxswD8N8GmvcwyheDnceiENBgYWAJf2ykrR+5G/RFnNt9hFTmx/U84eQqORNsfRzUbgGV+aMOyvfJ4gz6KMgefA7Pw13t7Oz7d6pPDAlLPYz/8Y/dD4xYjab18mvlwH2At1DrHpJddQJ3KPcIRLYGazJo/IQPRGdK2nlPwpIez4qCbhv2JvLe+UEfvT9OzLo8xnVcHxsgfoTn7Yx61s1APzkEAsz6S5ymQFBVkJM3rNeYXjxRx1GhkkgPgU8tysMhpAPXxGQgaY385jdDhoqlIG4Jv7cjenKrFL8cv3CBdaMlXcSDQBVytquPHLJ12TqyxTqtLnbpM1wMn06CyF6UIjdi2at9vfYfO34ifpedfb0z6cF7PjSChujoegN6pbXRa7tjzOUlegHPuqq+7DM6Ai/Q8SWL9RcUGXLHpzJJ2Nm+MZUQWOwPe3yuxKhQiUoSgzWpVnayZHDOX2x1OcIFeCl/rQ7mKFSnivMFaWQd73wT6nBN42V+DWAmMT9171P+bioju2Ll447k+/y8GOYneo2bVf14HtVJ+/7ALGzb90Q/lpHH7jYR0Lvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d341dc06-0541-44ad-4ccc-08ddcb256cfa
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 02:46:16.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9qJZ5bNeRhbLXQYWeejHvHj/EFVjFAt12dQx48xjfibDC0J6Ce/RwqgcKXADLe5KO0Sc78Q7H38nZu5JVkQhjAA/7NKMhERXOw53pHPldg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF54C97C915
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAyMSBTYWx0ZWRfXwbrJZkUOrBQD
 zGxtkZcpMQQHmahTcgeiuMqgOrVbmyAd9chCDWfkWpHjE2KpU8Jg/YiS0JgZyCGkBQLF3dji0d/
 QUGj6XcUx/Zz26Z4i+cVKbwFqEUKDyxCtAVRBQY9Mp+cWM5HTve8kAbyGNw1jChQEEKCvcyx0gp
 raNBpL6k7+hKzFqxEspv13UiIXg6cUvGXWf5abgNAdqpd9DU1LGH2FerDYU42TGLax8lKAXgUCO
 GwbKe/vE/6wKX8KqGfWqJjxlEM8jLEkVpzVrRXPDLKVfwhxg378KKtNjrf0PwhWRnWqiwJj+I4V
 gULf3nCefuQqpkdqIolpERsgK9cZDuLgxP/VEkYi7sOoDtJihwsx/OkgKyEH4RIiacm9F/V53ox
 LbRz0emIreHjbU3bu/FAHWPUROl91i9+uJhFJgJXZ5LWJ7cKEGIciszk7p7SGcyFkARjgET2
X-Proofpoint-ORIG-GUID: q0paclLLJ4jCPu7k2xLAm7rB1LyRmeOP
X-Proofpoint-GUID: q0paclLLJ4jCPu7k2xLAm7rB1LyRmeOP
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=6882f001 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:13600


Adrian,

> Here is V2 of a couple of fixes for Intel MTL-like UFS host
> controllers, related to link Hibernation state.
>
> Following the fixes are some improvements for the enabling and
> disabling of UIC Completion interrupts.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
