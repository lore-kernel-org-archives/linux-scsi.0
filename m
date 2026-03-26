Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411883BC67F
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516030; cv=fail; b=f4Sqh1Cm3XCPc9vbcesMf9yBVFCbEYvdnsc/d6qXx850Jaug7BOYxoGEqI1X85WRRAXx82RPcIcE9z9ok1GdNFTSlp4ncX90XPR0bLwlbEav0BpJUeb9seQV39NK0CyzjsNUvaRPBa7zk1CvPqPgg+LDo9DpoSsV6LKlACRLiMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516030; c=relaxed/simple;
	bh=M+RmIsx4sylewGt05LcWUkLsQJvF4dD6s9qjHIKFYow=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=upJxr7WOV9fViTdvMfuO+umDsoPAEZYh/hsK1YpjzE4rB5NQDhlzLNuRmqEZ9kjLA0JBf6hfe+7UN8/oTW3MtoB/2Y0WQCZUJoGU8ksXLAoHQUyuK061iTeAgmnRugzJ/aaGFQyTV4m/nl3QKG/ULRlhfzm8FgxMpEPcuNRvaPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lzn5jQ6z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nv0dzaW2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lzn5jQ6z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nv0dzaW2"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q7JtHJ2664748;
	Thu, 26 Mar 2026 09:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vJtNZmsGfaAw+sWE9ySo6Z6Tmle80ru8s9z7UghGaVo=; b=
	lzn5jQ6zltd8CQrMqF9SRZw6dBgXsNYVWtsZnBC1pqUKInWLFpN9WtL/+AsoMbdv
	43GKer9D5ePa/J7oZ6tmh+sZ/i1ILGH1ZQLp2V6gU0uK2olnWPKJqO8V11ThbWwa
	3yCO08RP3iAfSljxSS9bxfqCRjEzeagVDWaUJRM3mF9pZPajGIze2U3G9JLJL1Gy
	UGD0GsQl7FXOw3u2D1rEj3g25X3EpWQXU3F2OYJOBIBnxQjOTHhZhT0Xv8OLRSVD
	e2p5ax7xmBaMe8t1uOoYCQSmYyPOmpAXESn8M/rKVL9kHBGPDVJhNWH5q0oA8teo
	UZZqijmr05lG7iG0rIW/Og==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kj2fvwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 09:07:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62Q862Vr000741;
	Thu, 26 Mar 2026 09:07:01 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010041.outbound.protection.outlook.com [52.101.61.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hscncpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 09:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hL/1p8GwaCfnmOgZfWBQZjAZYSteBm+UZxKBZkkfedjT5C3bCcUEpLuAWx+mALRsnbRYBdb8zXzvOU+7TZGkmHhuUmQQkQhJWq3UwL/qH3KbveC0hcFqATwhSpJvZ5SX1zTHPZlKdczqJnTkdrRrRLytotM3K/Xmf7QzSVxoz0yP5wSj3OToqo7idGdUP60wFdYoVT76G89vIr+Ig49qF4wC9AuFNcLQBpUnQefzPTcPM4FMWH18JfFNMBqHduNa+z7Kf+KRjteuasyCpW85YfyMxt/RROC7GZJnES/XH6wYvj9Mtj+z8utKZBqplO6mNrK7FjxQbIEVP/k5yHXk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJtNZmsGfaAw+sWE9ySo6Z6Tmle80ru8s9z7UghGaVo=;
 b=oaHSyLfyb0VZj3yJVPbOq/I4kLfeiYF77h3RCTPDBMN7mNQuphwoqGXo0L29z02gfaQHdjF1I9ddumcOWPb2jIDiS+6pdd/dkMzkpWMdRDFHqZK6ThUwsfy2AoWEOqQhX92j+bWe3Vocb+9KHeaZy6dk7tvnPFIN9OSOj3jgm45K8EHA48rPT593Q0d9yWS2hiwOcU+yuD8d6eFwOXegg3E2KidTdri7qYRnwIP4xjOlnO9isvcz0vN6AasZ5opKLnjWJPen0hi//Py8etRvd59f9lM2rRgOvJQXgBmSa2+WNAES6aN6XuIjOfMfO8rkOzUacRJyHpPFgki9BNvg9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJtNZmsGfaAw+sWE9ySo6Z6Tmle80ru8s9z7UghGaVo=;
 b=nv0dzaW2kEG3XJLzKI3NvrcNdRLR93+XKnGLSZjAg1JnomLeRF2PzWiWTghzDtFJBvTefvnoy1323DZGsjMPOcB1C+Xr41YSOSCtvXHJS8PEWp35Xk8s3OLv+ZyayX/fintaSYXmbVAO1WoJAiwNeikpx+5qVcaJV8OfP2UypRs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ2PR10MB7669.namprd10.prod.outlook.com
 (2603:10b6:a03:542::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Thu, 26 Mar
 2026 09:06:56 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 09:06:56 +0000
Message-ID: <35279593-2db3-42e0-b57c-5ed6e37db2c2@oracle.com>
Date: Thu, 26 Mar 2026 09:06:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Support configuring the maximum segment
 size
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260325212717.2846862-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260325212717.2846862-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0331.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ2PR10MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: fe7c7464-fa13-4fe8-dbd5-08de8b17078b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	PFLpkTlKDotoGe43N24J78qXKM3kRxlqcn2L9i6LB514nyjS8p3R01H9sNzv9bey/oYp7olKRth7NL7Q5VbJD8ZsyFzcdYgqinhFV0wRPXci77N0rfImf/5CqtgYVKJNO1+woVV2Xhnvo83K5QgrPVTd+FwU67oFyAWPnJ16118OPml4NYhGSA6OhxWgxDHzE9OxLLOg8/CV4aVjt9hiBETJjFB175HMNOqecwbHM2vXu1cuzW+AIf6YFTLehBWxbJmHUTebmT5B3FRwI26t/zpA9PSKFBzogHHpE43wvL7nyg3cyDolkyc9ZsKeCkqu4uzWUpoYF8ZQVxv/VpX+gYhDaJoxxf/qr2iuGerLZbULwqe0cplfkqfHyfs/T+uyQrXpunr6CGj31B7t6kgOPAJ/6w9tQExdrFdmFSVWWNA7TAbk+oC7yTpkfoh77bMc1eSYOlx1sV43VKGL9mvzIHsPZN4KgtQ3S4IhiCq4+ilUx43J8DJTpYUW55BKoZxli/SRq0HzGf8kzZy+GSFbxLE5m1oU2fmItIFd9bekihn+yWTmbei3TJg6IoEtnvphtl0ov7K7HrykvymQQYCzBs17FuUytKla7CbpP6e5KfqVmlk2qJn6UvvMaX3u+QxQNLdaFc2Ff+x7D4r4D7QKNn6xT2OSwMHTJw7+m6yligOcFHSLHw6s3JXmv/VrYZ2OfsBqrb6bheXboypGDAVthmxN5NhcOU7gGBdQaVd7054=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDNjclJEcFdTbjVmdllhVlp2SkpNd3FjVjEwelU4V3dvYUkyTGpKL25Qcnc3?=
 =?utf-8?B?M3NCVDMxUVlXVkJ3N2hjNVRJTDliUWhMbVRBc0pMZzdMK2o1SDRLWVI1dlBF?=
 =?utf-8?B?RUVVTk1IMWJ3eFh5bmhoM1Q3L3BWVGlSaFdNWWRrTDE2dnV2aTlHWnIvVkFF?=
 =?utf-8?B?Tm5EVHBSTDhBaDJGcVVkdjMvaWpHeGdjL1dSQ1RpT1prY0hOT2ZQb0hTQXN6?=
 =?utf-8?B?WEN2QS9VY2M0WDZaQVl6bDBTWm50cGlEemdOZmpmRms4RERrZk5udnRIMkIv?=
 =?utf-8?B?Z2FCRHN1dXhNUEdCZWhqWHhPSkxrLzJ5bmgvNlR5RXRCK1NwYW9ENVIyUFhZ?=
 =?utf-8?B?MjkvWkJzc2J6WEpSV2lIbTY1QjU0SmhaL2pjT0kxVjNKbTltQkx6UEYwc2Fp?=
 =?utf-8?B?OHJua0pjRjBPeUJsUEpwS0o4b3pybTNqK05PNnUxUmxTRE1uL1FNRkcrUm9N?=
 =?utf-8?B?dlp0T3pHVjV4NnVWT2p2bFRQSW1iYW56VlhTaVdmMnEvZG9HaWFLT1kwYUZz?=
 =?utf-8?B?RndkTTlITUQrQ1l4QUJ1MjArMTZDUG5yYjJGK00wOStHMHlSUm1jNG1ZNHJi?=
 =?utf-8?B?KzVJd2dXSkNYNWltOXFPN3FzbXg5Q1R1UHlQUTRaVFBwMk5HU0l1K2krbmdl?=
 =?utf-8?B?bzZmOU5JRXVLanVOYktGZFJYd0hJSFp5Z3ExcmhRYmVDN3lhSFM4am9GNCtT?=
 =?utf-8?B?WHdPTzVJYmhWM2V3Qk9UVVNQelArajFscC9nRjRJYWlheDd5ODFTcWFTeENK?=
 =?utf-8?B?YlEyWFVDTG9ZMytyb2M1N09rOWVwcEd3OTBTVEN6TVR1WHBxWGlWbFl1T2Rw?=
 =?utf-8?B?MTZHZlJBWnRmbnE0UURxWkRnUHVyYXl5T01hQkxWOFVlQ1Z3SmxqVm1kUEpt?=
 =?utf-8?B?eTUvSGRudTV1ZmNXbjJVOWZTbnIrMi9pcTJNWXhtQXJFN0hLYlR0NHZmMnRJ?=
 =?utf-8?B?d1dWYldRaXdkOS85aWxlaUYyb2IvdWU3bHlFNDV3SHNJWXFVWS9HamIzYVlP?=
 =?utf-8?B?MTJXRlNvNVIzWFBsdktNcHp0am1qQnh1U1N5UUhKRHluNVlkWVgxWUp0cXFY?=
 =?utf-8?B?TUJvWTJsc0pDa2NJWEVxN1V1aUlxS1RqOC9kODIwcFhIMnlPaHhoZVlzSm1L?=
 =?utf-8?B?TDEyTHZXTE4vb2NOcXo4ZHk2clJ2SXg2UXVTaUVFcjAvUWhsR244U3VQcjNX?=
 =?utf-8?B?NnhhYVZWNlczOXQ1Njkwc21YWVJxL0pZcnU1ZzQ0L1FmL3dCeXk0cHpMSnlJ?=
 =?utf-8?B?ekRRNWtJYzhLNnVualFXdmY1R00yR0UvR29rZG5qczNoV1NiRGs5bUk0MlRt?=
 =?utf-8?B?V0hyb1Q5Nnh2L09HSDVRSkxqUFVldHNzOGlVYXVNWm94ZU00Q3UxZUlaSUY1?=
 =?utf-8?B?TnNSTFZtcG03UVU2QkdOcUpRS2dBN1JIRFJaVVNUZyt1aHFyRkZibHNxbVFr?=
 =?utf-8?B?UlMrMkZVOGxGb1JicCtVenBaQmdJTzcvd0U1R3VHL0tjVk80Zzl3aU9kOFdw?=
 =?utf-8?B?bElqZnVTVlhmT25OMnhYSEx0RTFUN1RUT0R4N2hKdzN1c1ErQ0Q5SjJmTU9x?=
 =?utf-8?B?ME5aVEFhM01iNXJ4WHBGT2tKdTRxTGpMcFRoRjYzOFZxcXY0MHRLeTRoLzlZ?=
 =?utf-8?B?S0l0N0sxOU90UHpxWFV2MUtIR29MeTZUaWsrZm5oYWM3WTFsZityZlZVWlB3?=
 =?utf-8?B?ZDhZWTJnVXErNlZpbnZXWEJMUlI2K2V2OFo3emJ5LzFXeENwOWxZdit0NUp6?=
 =?utf-8?B?QWVSZFlIQmc3TFVyZFlwN0I2TmM1RnMyMEVIUy9GQ2FDcVp2SVN0a2podGls?=
 =?utf-8?B?dmw0MGVzVU10V2Ztc1dka1I4UFBlZHpJTDN5T3UyaXUzNERZTEN1OU1MYTl0?=
 =?utf-8?B?d0hTV2g2TGlTanNMTld2VzJRMFZSazYzUHhDV21OdzlyWjUvcGZSNU9RQjZ3?=
 =?utf-8?B?Qmtob3hISjNCM3d0Z0lid1o1UkY4Q0orZDZJbnF0MjdUVTJyUS94R3QzN1JX?=
 =?utf-8?B?L3poZWI0Y1ZkcFNKNDRtbFI4TjdFSGVoUkkwbnYrNE1NUzBLeXJJZmN0TStH?=
 =?utf-8?B?RDJkWnpaRHVLc3lQVG1pS0E3OFNPTXQzTFd6bDFFNnBzOHRCeEYrYzNIeWVi?=
 =?utf-8?B?cWRUZVhBcHA4em1zelR1SXlUTW9nTVZPQXQ3YVBRcStnUHBxbDdvRTMxTjdt?=
 =?utf-8?B?MnVZOXc0SGdpZTREUnd4TWFRZzA1N01Fa3lKaUt0ZmwyWGZVVy91SVFWc0l5?=
 =?utf-8?B?Nk5vbGt2UUF6d0tTZDMyWm5KRUJUQ3RnSHNPU3NpT25ZVG5tUzE2WnRqYkEx?=
 =?utf-8?B?dUs0dXNRUkdINitOeGdEN09jNEpnVWtNYnhicU9laTZQcmFqT1A0Zz09?=
X-Exchange-RoutingPolicyChecked:
	K9E8TwzuESw56Man8RwpOz6LgymxtTaLgjnZlBDJ/+uHHb4H/JVxBcYJwK+p1nZM86/Foyoz2MzBuxUZ0kEbC/hfohn+5Vqkzt9LpPbikAL1PpxOO4DHN6Z15ZG6rvK0UEYVM6qdV/ayDKNkdpg6QBl9C7C2Q5gsS8M47cOMVfJ+d0vRAXuFAlv95T2BWxKo1z4rZzgjwmyjIMIrI0b+oEwSCsgJSuwfPdlGlNx2iEFUx0o3swfgcuUQIEWUT3gHxughMLcQN8AX5EA1f1Asf2rsspJi2r/33BIzzKAuDbCFiAzDmVeR2BNKuGIWOsTjOXDM3nt7CIsOuuzWeos1iw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tL7Kf0KOBkdXUUot1NiT0auNRFkTI3yYvDN8ktYJ5fHogyVqRMkWQIPLNAzLswDZU/FnVBe7v7ht4mN0QoQBdcLMLgYnD+B9MYyFhRCjKiOb5BsITvlT+J2jFpuwUG8YdU7gybrFjaaVgXZkUzx6uwwThQbCBBuIBf9pmLGocbr6gYqRKbul36E8kcoKghijM1scXZL1qm6aYbeyfk4+4aVUkDvMXZDCW0S+xwJFL66rkWmFvhFT/ACES5do8Q7UIrhGxaHtfvWcuWe5HZfk7rGIuJe5rWZLKtq8bq9WzT5bf8SC2hYIGkKX95QakfYqSvq5Y573cCCiyVDklEc6kXEwxUCOMMalt2iFAwaSNZ7VZI24rOwQ8h4+H5fZDxsHrRAw7aceXBcIQS9d+dsQRmpBjVK87Frgf+eZFgESpGbIMjGA8m8xwSFj0sspW10BWl8ltNW9PHRbel5aFDm/r7/URUfX2wRilXUS+OFqJDyZ+XSSrrKgfgxIsOsPv1Jq0aFJWRVIaSsXYGyz3vUtGgT1F79xXDwpPZHrWWaSGQvsRqfUvkTGA66QDsPoS/h2OJuu3ztZDWSj0JPho4RGikLfDv/6Gf4LPqUM2xtIEW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7c7464-fa13-4fe8-dbd5-08de8b17078b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 09:06:56.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ep0cFUAP2xFyMaaGK/7V6SRlqAdS24W9YZlB8SwAJgdTXa1WbWIgHyVGsQLeLTZ8usmsumL01vYdC4G9grWbZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603260065
X-Proofpoint-ORIG-GUID: Hrg0hYFj_csxNaL4YYSp4UdY2wEKMH24
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2NSBTYWx0ZWRfXx5YLHSqtEK5W
 5MFCV+YVVR5cgpcZImJpZkcwjBtNL/fbndn5hSroqXRMGzLsFtnpRsrZLnGhbm2s2CgOshXIvoL
 WQC9LELinx409pKH3dfSUXDNE5WQuC+Eo5yA2D4boJ1FlPvzXlOmegiU9IziyNmPizTXByNbXk5
 mZjZrN2x2W8ngGZpcsvaHCjr/KsbkTpJf1Np+fxcWnA9XsFihHyDdmBeRKwyxCfeYPX6QX7556w
 YNs/h+EmumSq50FqiPvRYN9pfbOyc+EPmVPK9oPgLNf8A4ES9RznYVSnbGnzO9vcXZRqSpuoDCH
 FJ86LuUVWFZ1jz8D9YEtkxFpIQH2DHE9PuF+1N6ejdv5UPYQ3Zw6BWgqGsY62Stka68R3mjDHiM
 VG3130aixwyvTNvXVaIhdAfqOXF+nDyK4HlLafQrofYiWQsLzCN+pBq9npn6OR4md63jJW2ZwXX
 2ZVw81CKdsVzD5GYjfQ==
X-Proofpoint-GUID: Hrg0hYFj_csxNaL4YYSp4UdY2wEKMH24
X-Authority-Analysis: v=2.4 cv=KtJAGGWN c=1 sm=1 tr=0 ts=69c4f735 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=NCkSHYsgAAAA:8 a=2XSAYwtp3nYhtOmKvVAA:9 a=QEXdDO2ut3YA:10
 a=AnMw66Xr5OuzjdxB04dI:22

On 25/03/2026 21:27, Bart Van Assche wrote:
> Add a kernel module parameter for configuring the maximum segment size.
> Note: blk_validate_limits() considers zero as the default and changes it
> into a valid value. Values between 1 and BLK_MIN_SEGMENT_SIZE are rejected
> by blk_validate_limits().

I thought that scsi_host_alloc() will change 0 -> BLK_MAX_SEGMENT_SIZE, 
right?

And I would suggest to reject non-zero max_segment_size modparam < 
BLK_MIN_SEGMENT_SIZE

> 
> This patch enables testing SCSI support for segments smaller than the
> page size.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> 
> Changes compared to v1:
>   - Removed sdebug_driver_template.max_segment_size.
>   - Changed the default max_segment_size value from BLK_MAX_SEGMENT_SIZE into
>     UINT_MAX (this is the same as the current limit, -1U).
>   - Explained in the patch description that blk_validate_limits() rejects
>     values between 1 and BLK_MIN_SEGMENT_SIZE.
> 
>   drivers/scsi/scsi_debug.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1515495fd9ea..44309a16eb68 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -915,6 +915,7 @@ static int sdebug_host_max_queue;	/* per host */
>   static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
>   static int sdebug_max_luns = DEF_MAX_LUNS;
>   static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
> +static unsigned int sdebug_max_segment_size = UINT_MAX;
>   static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
>   static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
>   static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
> @@ -7366,6 +7367,7 @@ module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
>   module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
>   module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
>   module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IRUGO);
>   module_param_named(medium_error_count, sdebug_medium_error_count, int,
>   		   S_IRUGO | S_IWUSR);
>   module_param_named(medium_error_start, sdebug_medium_error_start, int,
> @@ -7449,6 +7451,7 @@ MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>   MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
>   MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>   MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
> +MODULE_PARM_DESC(max_segment_size, "max bytes in a single segment");
>   MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
>   MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
>   MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
> @@ -9539,7 +9542,6 @@ static const struct scsi_host_template sdebug_driver_template = {
>   	.sg_tablesize =		SG_MAX_SEGMENTS,
>   	.cmd_per_lun =		DEF_CMD_PER_LUN,
>   	.max_sectors =		-1U,
> -	.max_segment_size =	-1U,
>   	.module =		THIS_MODULE,
>   	.skip_settle_delay =	1,
>   	.track_queue_depth =	1,
> @@ -9566,6 +9568,7 @@ static int sdebug_driver_probe(struct device *dev)
>   	}
>   	hpnt->can_queue = sdebug_max_queue;
>   	hpnt->cmd_per_lun = sdebug_max_queue;
> +	hpnt->max_segment_size = sdebug_max_segment_size;
>   	if (!sdebug_clustering)
>   		hpnt->dma_boundary = PAGE_SIZE - 1;
>   

