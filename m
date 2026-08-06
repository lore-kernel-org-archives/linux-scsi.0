Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5465E31E845
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007012; cv=fail; b=LSUyqWqs7bvOxTOjsdzviSF88f76K9HMjqzVmqmAOqPL2/l0layqVFCXQPxLO0JHO/sxle0ulP6X+oVXnuOY4dtJ4r2ogn4MvRvzl500g/MM8cL6kbEbRc15eVkCmX00xAN+POM3RLh9hDQTMzoMvlDqLFcHd9EQfDMgN+90wJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007012; c=relaxed/simple;
	bh=7Lp4l7Ow7bSqKLrxLHFYOC8SArTRB9ysZJ3hfVCF5oI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=USyKK/En+kg+y/36UxEDreuKcIAtASBa4/9Pw12Fm88Vp0LT6G3qzILSE6IrUyj/YHb1CjTUZO/ONPtLH1SFyz4u8Hy09kIpKGC03fWuWpyqO4NXQ56NAsOpMShoPKydZkO5li9gxQ/mrXgCCKc4l9dFZi/dR3E+JQQvpScHrQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IZ4wXLpq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SwK2QAkt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZ4wXLpq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SwK2QAkt"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6768B9fe603831;
	Thu, 6 Aug 2026 09:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZrrgVjQBE6lS8wEj9mv+OjZOZ6GgyODOOzLLTo0YG8I=; b=
	IZ4wXLpqvqnuJcnzfq4XLXR8THDtvAjOQeqgwYLBJEYQlkPeMXi/PN/OBIHyE5QK
	IqADCrhN3pgnp59t+Fn1arDZw8PWxu1MfCTDwdIbhs2rKJrfAIe+ty9Coki1QSL2
	oWjuS6gsAtWLU9eT4adjiv15aj6x8uOe0JXVxkjlGLA3Hkj0ypaNVaJYZLTTsTdH
	iq2368Nuz6UFfgn7IJ24US08mi4Pjf5aQBdso8vgriJfxqk1MtUQvf6Kd9p2Mgze
	0dXNfXahfQz5JgaZXIEudvDBlpGlGpsg4hIm/7cvTpUkyNOjR0NggC/jQjT+btfC
	5PltqqzdF0xz1FyEcbrvsQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7k3mp50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 09:03:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6768tmOe011590;
	Thu, 6 Aug 2026 09:03:23 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78vgnae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 09:03:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlKTrcoY/XZ1Pj/8QiOXejoJaDoUlo9Eutkto/jHmB/m4CYnduYmO7ICiwZgrlcMfeJ9g8rhV0PcBjZklEVCD9AS2s77Tj5InCduzzV7m2uSa0pXR0fDX33Zg6R3oG5uvsXksYo0GCNnBvP0vJwY+T7O4IQ25ddMvSfPirI5nnszrA1Pvk2SPYgquL9ECAKeloNvKhizG4vxWd+lavY5m7Au9NBRvvfJxS15Vtah1+iTh4cG7WQhXY6HAm7zhWjFZ/wWJPbWvUPlOZVG/8vnsmAzmFdsOS/Yf4QUPSPcWnuNacimaIGSgvdcQh9M5bvX9gaNnlXdeO6wZat59TZdEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrrgVjQBE6lS8wEj9mv+OjZOZ6GgyODOOzLLTo0YG8I=;
 b=gb/uCBcQBcqmbbqpQG9SisIQZsudArM4iAsdC9AjV5V8XHuKwVop4IeWSSKq0CMiRSWWOWId1/cp/6OzELrQZQEjQwBU0hPCVXJfa010BSWSNjcI006/5u9+d/l0g3KyhXmc/7tZ5NhsU/2JpBNn6n7aMalWmymw+73N6B/KDL+YH9GEm3UjdJKahS1n9xRaedp83IJmGKgimvCdHItIGUjdQTLQ6iwkisvJWasDWqHxHVGg9jCWPH1yL7vxiqCmvEhSGHCNZufpOtEXYIVVAGARLdiSCHW9I1TudBfgHX7+PhjRrii0hrHNn5sS+ZImgtVKw97/Kha0nDdHOGh9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrrgVjQBE6lS8wEj9mv+OjZOZ6GgyODOOzLLTo0YG8I=;
 b=SwK2QAktdEguMwn8RsfJUGAZjSmdVYHcUvwxhXsU1Wkl9vDppoiGJHfj9zF46wpafmuzUJSRztjAWSqosxp2as8JscZ2hq4nC5tNBfesJryAG5f1129fGueEH0hnTwkhoTqEPkrSMh5+hn1fgoxhdfZOq5Csvr/TaHrxXYmmfZE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Thu, 6 Aug
 2026 09:03:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:03:17 +0000
Message-ID: <0bafa16a-c616-404d-a6f8-2d2e99f0cbad@oracle.com>
Date: Thu, 6 Aug 2026 10:03:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/6] scsi: core: Add lock context annotations
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1785965531.git.bvanassche@acm.org>
 <da0d5e522eb10312076580371ee41e1d28f7ac18.1785965531.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <da0d5e522eb10312076580371ee41e1d28f7ac18.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0638.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf39bd7-9832-47a3-1b7f-08def3998e24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	356wcSd89BYlXuARESjnzPQ6SCzAxvuvSFQERmyXqsczietxFc+BaLkrris/c3E+Hat62zpxqsHvkK6jcSW4906qnqU6qsgk+MKFAqE8FMH3rD8/itx8hEKCkwjPIgx09oritcjKJ2sz/o7n+/WjEgYvjJG9Fn6FATbtmt2FUxJUa6Of5O+JTU0PnDKQocikUrExQEao8I/R6+CHZm5MtkNAQOaMwwptTREdfOB1GgWJZ0otypmePBRiwRCf/J3T1z/ZpPMKFTCd7R2/Cai727llR5R1ay4p6NKXMj2pMO9MwDR3bKSyi7MFpHOenL+cKB3bSfM3NNsWlxmHp6jD/G+CtSGpdw92YQCF0CKC9jVRz3PS6Q5kuD1HGGavhPv3UPQk5AonQGGwlTlEvqIATDH124QiS16kczvgMGc1k13JRJQSufGI71BsxmlJEBh6DxT8bxbfFkmdLrt0QtROWCDu2LfitpaFz8UZx7fwm2seFkRAOJFwxZXEGZ+NjbisrO7hwiPxoL6W9mVbvRKTjfI5PffHbysgwbS10JSzeoHzae3K2kkzT/oo/4Pw4sq1nAOdwa3Fk++2p8FdkTSEAX0SvrNTY6kml0C0cMMr41EdCNnrL6zZDcxfBZ4i02miuq0+/3haX8IwvXWU2druBGqbNHLhZi1duvCIUwlRPU4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnVtR21Qbyt0YXJhbko3ZG8xeC9uZ2tlcUdaR1VadWVoNHJzT09mdWh0cGdI?=
 =?utf-8?B?S0xsZ0FNWGlWUm9zQ21kcFlaemtvcEl4NlczTDBZNmVCeTlkRlpKYm9hYVpB?=
 =?utf-8?B?SVQ1dS9jTDNaT0JFUm9RYUZ6cEd6aStpMzFOU2dVWEZtV3VBbk1PcHRRL0Zh?=
 =?utf-8?B?bmpFMW1qK1MwQlNRekNoeGNuc3BYTDRSVWpOQmQwMURSRWJYZWY0Y1JHTVlL?=
 =?utf-8?B?Snc0dmppcnJBK2hWdVRYNDVHcUFJZFBtVXZZSk96eS83K21vaDRtZFIyUlp2?=
 =?utf-8?B?Y0M1TEg1akQvcU5vRWlKTG0zaHZySDlUT3hJOG5aZ2wvQVFFKzRhY0ZVMDcz?=
 =?utf-8?B?VzQyNDVsQlkrOTVkWVdiYURkOGc0UGNpWVhDNUNIbEJPVnRia0RaazlYaVlm?=
 =?utf-8?B?UVlmRzJ4d2xHMlZPS1VRWTVheFBxaHd6aFpsaTZ4VStWT0o0UUlzTENnNlBO?=
 =?utf-8?B?U3VkOTJwaDIrNXBEOWRNRFpVSWJrbEVZTG12OC8yS2gyRGtsdGdUUE54cW5t?=
 =?utf-8?B?Y3NOaXFNRW9zYnp0MlgvY3lqMEVFREJ1enExejNjNDBTTzJxdGNGdENPWW1s?=
 =?utf-8?B?M3QxRUxkYUdDRDVrL0ZTK0t2RW51RTV1cHhGNEJyejZaekdkY0lJYlVyTVd2?=
 =?utf-8?B?QTlxR0E3RUtySXAzQTcwMHc2RERiTDhIWTRTb3dDWE1qOVlERkNwakdrbkMz?=
 =?utf-8?B?UW5sRFpoU29iQXlwQUJEZ1lhazZEak1JTU5DWm04Q3JEblp3UzQ3YVZBeWYw?=
 =?utf-8?B?QUZKdzMxdTZBcjJnMFo5cGh4SzVGSWk3ck42bm5nUktJUHJGaCtIY0p5QlFl?=
 =?utf-8?B?Q29KcnZTMk5FUGVjUXJqVUhLb1dNWndSNzJqNHF0bDVGTnlCcjlJRHRUOFJT?=
 =?utf-8?B?QTFoc1JqcFZsRFA0WEhZVEdhQWk3NjFDUlA5M1hEczA2ODM1cE9jYlVsSXNL?=
 =?utf-8?B?NmlrQ2V5ZzVJeWs1aHlxUHRsRlY1dkRGdER6UzlVZ051M3BweEtKclM0VzNJ?=
 =?utf-8?B?UWZ6NDJOTGZyQm1CUDljOVJYQjRiUVN5U1JmcFBsdUU1Znl5dE80bGVGcFJK?=
 =?utf-8?B?U3JRQ2Eva1FpTzI0WHhDbnhNUlFaazAyL0EzekNLdWlIVmZIbnFPMmNiajFZ?=
 =?utf-8?B?SFVFZkZjWWlMYlFreVNPYUhGY2c5WC96RWZQdFdic2hCOFFxZks4blUyQURh?=
 =?utf-8?B?bU0zVEpZdGMyMTFPTjZuOWtyYjBXRXBTRE9wWTlSNk14ZitmZ1NHQlJ2aTg4?=
 =?utf-8?B?eGx2ODdMZW9sSjc4KzN0Z3BrdC9uZ25teEVCWnlBSy9TbEUrNlg0OWNpbHh3?=
 =?utf-8?B?eEZOclBRYngrM2ZVYTFVV0xGOWpEbDBWOTRIcG9tRm03V3prZ3dVTE9vY1c0?=
 =?utf-8?B?VDJkZEgvaTAyQXVXNDBXM3BKYXdoZFpiTmZTUXFZK2oycmZaS29mT2FleEhZ?=
 =?utf-8?B?M0MrU2h1dFVqcHkwUkYyemx5dUprOEFWNWlOTDFqOEtiTGlIZGN6WUFDNnox?=
 =?utf-8?B?T2NUOTFnRVVKRXUydFNGY1pNeThUNHJnTjUxUXdyQXU3ZG4valRxL0dIMVd1?=
 =?utf-8?B?bUYrTFhYc0V6cWVCQVQ5MlpTam15Rm91Y0Q2U0xSYUIwbWRab05uMjdMTmNi?=
 =?utf-8?B?a3Y4WDhZSW1YNk5JQURSOEhNQlY4d1B4UHZaMWxlK1BtR1NTaFcxR1F5djJo?=
 =?utf-8?B?aEZsVS9ySkp6YkRIMU9lVWtRM3NZSVJIWGV1M3oxWmZZR0FvRHVFUVAxUHgx?=
 =?utf-8?B?VWd5aXk2V09zTmc0K1U3TSsxaHZCSEwyY3RXM21aSjVNRmN2bEI1amNWdUJB?=
 =?utf-8?B?bG54U3czZlpiRGg1MzJiTmhpVHRxL2ttY0drZzdYd0J6cmFFelgydThndDZ6?=
 =?utf-8?B?RlZqSk5vOEpkTGdyV3FuN1NxU3JaVE42WFZGM2pFTzBFVE9hU2ZVeU5KZjNF?=
 =?utf-8?B?dUxXQ3pKU2RQZEN5UnQxRHhJZmYrTHJSdk00SURwaUZMZk5uem41TTdySUxo?=
 =?utf-8?B?T2Z2dGNBR202NUt0eXNGUUppSXo1S0t4ZHBEeDVEejNJeDdkekNQYWtkMnhQ?=
 =?utf-8?B?T0RiZUl5czVXL2ZLMkpCVHU1WndGeWtOWHBmYVhwY25adlNqQzhKVzU2OTVp?=
 =?utf-8?B?ZnFYQzZFL0cyL25JeTlleUx2b2hIQ0dkVy92dlNkVnVURW42VThBY09WbmJY?=
 =?utf-8?B?VFl4ZFVuSDcycnl1QnlnTWxFdWNIL09aZ1FPL2RITnhOWm1VQTZZVGpPWkFk?=
 =?utf-8?B?NW5yRG9CVEZ1dzhCMlZ6MGY3aHB3UFVwYS9jc0VyQXdlUkpCZEVqZ1BXdnU0?=
 =?utf-8?B?bkxBTTdEM05wek1taElpOWVSdXFCaU91eERqMnYxWkZGWGhjY3FiREJQS2RT?=
 =?utf-8?Q?Qug4+QjlBnJCoj4Y=3D?=
X-Exchange-RoutingPolicyChecked:
	XzR7OZHph5zc7ygKrYbLFmW7uo50YrE2FR7x/8coIqdCasWbRSMm3hfLLZ3zSXe+j79JCHUKAOWudDRi/B5xsrRQjUu/Gx7VRdfYdj3LverYfnz+MkRhhUPcvMUsxPwXfHRA+rj6cLEH4FhjEfLTo4YY/auAPGu1uXEiej983bNI/sLvG3Wf0lCvy76y5CbRNos8Rxbm3Tbf4WlMzSXuITYRku0palEB6K3fPjFpJVPIRts+6NzrXE5qZ845ZZYw6qGiQ3GT6YvEUbHoD4yaf0FMrUmGs7xHNNJFHVq+PsKMhhQpc0FEsvSpEZ1uYg5WvFZRWbnMNkFKro6uZBYi7w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PcETjEchMPmXAswBHcZCMZomH1ndO5tfFiL4DgOgIC4OxciOSUxox/f4sar6RjmAuRxlOuYKAcl9YEu5EyEE/ZB0ZYYZUXvQlxZblpuGDBwrIVK5+YYLgmZrh1WmYv7HGoJRnLqdXjP5qj4y8z4SMblBWYZjDcNqvNfi099V+CsHChzjXb3/SD/h/y58REx3uEA2ZtV3H9Ri1MSFfcdKLodZtncJtTX7bO/kVwyZ8uJXYoOrSix0joNVrmRiO7OPrmazrE2HwXtmM8ydTTZFu2QuJkQ/4QEIsAuQ3F4Rdt42yXVUb0Gkxr+xCyHH0pEsJmmkVVdE1iKMXOan+K0RjWjnKgsM5L/dhA2kN0kfVpMheMt192Lux35A25rDKKIMIwOFa5Pa0Hgpf5p/eKQ5XR3jDgGEdCttJtBaNfKrp0VR61eKr9IZRjziStPDYGiqPM8UY4e2VWO3dOf9qVcTn2HGoVNNpEZG9PnJYQgQldUxxILlBoqpfjB4zFjamRBv1pM+EcJQZrOK4fVoeP6ibzlxM7p4X24DPurRVHkxiQFHy9Z+ZoLs0yt038z4J91DmhVOr5KGmfAk24i+GrIeFdznm2/nNcHw5/3CQKqkB6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf39bd7-9832-47a3-1b7f-08def3998e24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:03:17.6942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cibzG5MfJSgqjAJL+8KfbOiOEkhjzSIik5Y9BdC+825qtvL+k0HzcKhMxoWpiJP+yM2Q/vCNCHtaWLci5vX5wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060069
X-Proofpoint-GUID: q_hnufati8ElIy1mBTXuQpWb6HL6sKE3
X-Proofpoint-ORIG-GUID: q_hnufati8ElIy1mBTXuQpWb6HL6sKE3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OSBTYWx0ZWRfX7Jpc2NpLl2Ze
 csZYaGEhr6UJxrlkgPb3CLQxL/iI5M2EN33fDZUWs3Ve+o0LSYb/1xnLp7Es1u9QhX67b9PGnEh
 jqJg8dbXAil55oYRWI9VFkng5vAbmeSbzTAJpD/XdWb0BC60g7iG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OSBTYWx0ZWRfX+NSlXm61KHts
 XPJ0lck2vA6TINftvfXuFYsTN8L6PcfIMcUCugJc6YSpUQYxj4tWHY0/lxQ0xzaGZ5Grc/sShEi
 0s1aIbK27C/Lkgk92KzZVLL7laQUoSfbzR6PTowB9VXxSXQ+R5u0RcnADo+tQLflESdeqodrhJY
 9Mi8r8rIkAw1w8QAgCqWbEKG+kcGieL6xPlMx2X/euUavbwE/e485CS7+0ooPqjs5P9q2EBgmbT
 IzKDSPWM7QY+whl1Z2hCM3k4ModRXOcn0Kml/KBGn232nDK3IRkFJRJppaNtzinh8L/v9CUcA6y
 HF1fNvpMQreueL33ffsrJj5pOWiPFbIxR1VUoAPgZTHJHjB2FXHdBAkyJdENfxE50PW82Bs/RTG
 0XG33FkINXYBm/nEREtWaoJxlBCbic/QeMVCSJM4Ur1HZ8cCv7NzgtwsgVxO6B/P3f0z1AwwWm9
 yrIVKrl5GJWhRvM3xv9OZdN7a6RKtzT6ZZYdMBiU=
X-Authority-Analysis: v=2.4 cv=Iqcutr/g c=1 sm=1 tr=0 ts=6a744ddc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=MQXSNtxyMgXodV7nAgAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101

On 05/08/2026 22:36, Bart Van Assche wrote:
> Document which functions expect that shost->scan_mutex is held. Signed-off-by:
> Bart Van Assche<bvanassche@ acm. org> --- drivers/scsi/scsi_scan. c | 5 +++++ 1
> file changed, 5 insertions(+) diff --git a/drivers/scsi/scsi_scan. c b/drivers/
> scsi/scsi_scan. c
>
> Document which functions expect that shost->scan_mutex is held.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
