Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622E346FC3
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007817; cv=fail; b=oJ2EUg3DNNU4GQBT0n+15pB3EDVzqym5/evxjkUqO+gKF3ismV4PLzNg5jG16ub/RIude1Mc5Tq6ZIkmlLxjYvJVXQwTWIa5SWbJiyAgWJ/Xa6FjgHIf1MWg9JeYFHKYnBvtNGr1Bt2O7eQ6/mrVDT8/AnxobLNLrSoVwirRW4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007817; c=relaxed/simple;
	bh=WgF2Vx31uAoudNaohGIsyihs5SIrVdrqkAeyVym1vy4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qTjGW9IZbEv2a6Z4iRye6V0GTwywEaAQxFdb8bwGx8z6M0UsNfxqIaEzO9OP3dq1vlAjHaWDWo+BTBY4ypwU2XggFLVqADUGY4ds1MzshkdewjOhroqto4qv/Y0ZTZ2x6dy0i9Yf6FccTqECrj5Fv+e7bVvJiIIp1BE/t2fnW6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lx4JesXB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jl5jI7d9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lx4JesXB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jl5jI7d9"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6768CbSY602531;
	Thu, 6 Aug 2026 09:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9RuCzqBsuL8Rbjn/Rksc2ndqN2dBh9SvyFgWiQ7PYl8=; b=
	Lx4JesXB/aV9FNAoroeaPUZhTZ3n05SxyPXBlNVwSSWTwcMJOgbtdLLNEDjwG8kY
	OavKG531NktSNJgWdhxLal8gip9sV5cJ5/vLpix6UCRBjtPBkJ1JQrgrRL2lp+Wk
	EX8nla24htfxyWOq1dQj7+illw4m0nPGFxcPejU8QLVpNp4e+SJmBHgJLTaUmwyD
	3DIL43brP+QYw/j+4ZwkARUWg1PcsE3E/zf2tC/2ja2HBYFeBo2ZpDh+qo7stqZi
	xHFA+0MQPnTwD5vJMWex13iJ79PrnBPxVoXtPyBjYPGgeb+v4j0vgFDsAeZobxwU
	McyrgunSn/Ew1eT9wfmpjg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e54qut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 09:16:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6769AX2c015609;
	Thu, 6 Aug 2026 09:16:48 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w97k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 09:16:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rEp0mnEkfkpGDKw4f8RjTzgyPK953SMA8IHATyN68uHARMzUg3bFp/Y+wGr+EswfDWgjis2x4GXL2r7wk62ilr99xGotBSKCZWqIklijm8GnCrTTzcURwljMu5zhGNZPkM4J5C5yypbFq1kjvSJ5rJFv9Zlpyj9Ui/KBgQTqKy5RpeXAzkCTZCPBIhKrJVRAU2YzHqvlGcyXDIR+ePA9rZ51/TJaIc1JonIIoT6uEBbd/JWX3OteEb0fXZHt30KDQ2tNsAG0bQxZubIG1hpJBogmFswn6PnTgZjEGEPpOjjCWm6M+rbKf/dQ53JED8TIyrq0TNNxyYRH70Q8Nf2f+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RuCzqBsuL8Rbjn/Rksc2ndqN2dBh9SvyFgWiQ7PYl8=;
 b=OqBM5tEAD2LB5717i9YngD079B+7kAbT5Vw1NkqEFez7rI2noWo/w94w46WcJd71vx9+n1LrgeVNSGZw9Jq3n330Xzo67L68ifvKG8kLuDG+pjbo5KbBDK0RwocWwGdI9pvzYDnNY+fqNdf+ImdDxjAgmzVsj/qvENKLrkM4kWLK9yWxuidAjYL6cqoFYPIC+O86nJweN6xlRbLBFYg1Rqhc1RRUtJciZXe1mmz/MNiDh7ghWlTicqosijcHPVOs50uCWnA/DlebY+y9cDBTIF9c0YCNhsiTl/MAj9TjaGf8AEwtpdJuHrhtGKV38eH5J9llAshtolRGIuXTlAjz6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RuCzqBsuL8Rbjn/Rksc2ndqN2dBh9SvyFgWiQ7PYl8=;
 b=jl5jI7d9vsgSM3JHikKOxYyxSaCWcWj3OxGOhQIWkGIYJ6mjF9M6D/xXp20w0An3cWF7FrNxIZiAW56PWKJdxoqsRP7t0bnQ0Uz+S/sMAC8YX3QqQPilqf8Pn0pBVrSLkX/Oj8bqnaWOya6TaA6Q1kTNO+RAJiFVuJpAj6RKj0c=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY5PR10MB5963.namprd10.prod.outlook.com (2603:10b6:930:2c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Thu, 6 Aug 2026 09:16:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:16:43 +0000
Message-ID: <11c74ca7-f952-47ca-8dc7-24b688efb7cf@oracle.com>
Date: Thu, 6 Aug 2026 10:16:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] scsi: core: Enable lock context analysis
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1785965531.git.bvanassche@acm.org>
 <9b8e6e601725f0a6b8ac1b9609426734f4ed502d.1785965531.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9b8e6e601725f0a6b8ac1b9609426734f4ed502d.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0012.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY5PR10MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf14e4b-1aae-44c3-d969-08def39b6ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	j64VTYzi+UupQ88b0nRGQIhKl9x837VBz/XXDa6f4oay1kfK9LEcvLl4bS5MdXCtqNLPI5JzA3tsEOAXVJw5I+tkCpt2x/6HR8VVGPTP2JRAwRYRkI/lxS8wprxhS9Xj1x4RK8evoEIDx9o3FeHgMIzU540FLypkDTo4SdsaMw7NhM6Z3lh8oYreHvFWMx0VPTEPBA6D0EGPtdCJRr7rnZyBbOpXk6utHWVNFoRIHb6Z44YgdYDXeOKA5uQ6H5jgf517G0Ntw1xw/CrhUCvDFXYnXO8s+8cPYEucoev7CbqO9zMj4htUfVq1SCyQivKvD5dFS52EoyBIyHKCJN4lA4SPY/1716UApAhpOv2sgXza6fo0WZ9euw00H/JPTRSH4cgJmxKw2UOvrmt+O38Li2jkFWROR2yTFBDuU+KgrCgD6rroSEnrLyL088vKDkKbe4ritgVblxS1/oNjUyoVMjXK+/sRPhUUw4RtBlt+UAln7bg8/ZLvj+3Y01FTKSgAsz5I/zLuBIorzM+lQo4+uOw/hC+fsQCz9YGYgy6QVmsRzROp3MRDOK7cdmlPrzy8aooVogyHllLnQUyWiF68fyVV8ZYR0y1CLda4tlZsC5K/tdLKs3zLrpK5Xd0r2SWkmgv6EQkP+Wp1+bQEvVrS2FDlS1Z5asPrHqCSkQTW3nQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFpZRlNYbXpXdWNWRXhRck1FdllCOUp0M0ozMDZNTGp2NVFxTXFlRmh2N29K?=
 =?utf-8?B?cHJTTUh0NVM2VTVMS0ZLRmdRWExOZVd0d0RHTyttaVdwdXBEdE5Vc0dPRjVX?=
 =?utf-8?B?dkJUVStBVndDR0JjNFNDdWNZRHJiUEZTZ1BEYXRrdEUydWUxMzYzUHdpa0lR?=
 =?utf-8?B?RE5BN0E4MlQ5SzRlNWVsb1YyRmlzYkk5c3c0RlZNM1p0U2xhMXBUK0E3ZjBv?=
 =?utf-8?B?S3p5VGlNSlBBeWVoUmdNNE9haDV3MElXRFFSNitIalRWb2g5UFBWOThDeTFD?=
 =?utf-8?B?NkptK0xRUnpwT1R2Y29ka3V4VG5HanZwUTNxTENUSnhGRElBam1Ja2lNeXlZ?=
 =?utf-8?B?YnF1QU9VR2RDVnFHYUdjSk1GMTdxdzF5L0ZUb3kxa2xING8yM0s0K2wxL3Vj?=
 =?utf-8?B?a3Q0RlpBNHdER1hOZmJaVFlzTmVPMmk2M2NYYnplYUg2OURZNWdCSjNyeloy?=
 =?utf-8?B?blkwRjN4SGZEUS85YWZjc0kwR1dJRmpPM2habFE3eUR6QUwwdEtYQVJYb3gv?=
 =?utf-8?B?STZWUC9VVUFBdHNLVXlNS1lzL3diWFVQczdCeTJmV2g1dHdNeG1TRi8yVUJp?=
 =?utf-8?B?WlkvZEd1cWExZkdIWENOMXBhaUQ3cW9yMXN6M3YzTGpIR2dQRkNyNnhiWDAy?=
 =?utf-8?B?cUVhK2xnMHZaaWQ5RW1WUXAwSUtoZVlFWXVWSUpvSVNaOHhTVUdCalhCLzZm?=
 =?utf-8?B?bVJFNk9VUlJaK1kwQmcwS1BMeDE3amcwaVZFVWhmY3pubGNaSmcxblBiSE5F?=
 =?utf-8?B?Q0NlOE9yeEhQZVNFRVNEN0RIb1RCYXVNZmQvaUpDeVlEWVZqeitnbW1hVSs4?=
 =?utf-8?B?ZlVNSmhROTJZOWFGZGI5RkRmaUNadkFaZlgrSDY2RXhwZXYwZFcybWdXZGlT?=
 =?utf-8?B?YVloQ0ozUGpSZllpc2ZNbmE2ZjJFTk50SDRKaHg5ZG1BSEwxcDlmY3l4REln?=
 =?utf-8?B?SG9FYkVmWWxaa1F2eTdPZFpGMzBDd01ob3NtUDJhTmF5T3h4a1RKcnZaWk1s?=
 =?utf-8?B?dUlJMmVWeHdaa08zZ0YvY0FKZzZjbVc4OGJRTlN6a0NCdzRSTmdqM25PNElR?=
 =?utf-8?B?WWg5RVowMFZ2ZFAvMkdkNVRBN25FWWdhRkVkcTdvc2ltVDZwcThUWmRrZGtM?=
 =?utf-8?B?UUlqb2w5R0VRTlhDS3lPcXhlWjZ2SE85bi9YaEF1am0yNDFheU1CckcvREs1?=
 =?utf-8?B?OWQ0U2VrOEhUN1pSUnVzZTVqTHdrTWJoYlN4SHUzeHJCNWVvUVMvVzRZTFF1?=
 =?utf-8?B?UFZkaGNEK1A3NVNXQnZwY0VCMEVGbHNCOEsvNlVRMzRJc3kwSjVXL2hsMHFD?=
 =?utf-8?B?bDlEOWVZekxSVDhlVG43WEQxOEIyaHNxTGVrcVdBcjROdHZ4aldYMjJqVHVB?=
 =?utf-8?B?bTFwK2Rnc3dXU1FHUEp1ajZpT0tEUk95Nlg1R0ppbW02OU1KaVNuN2E3dlJh?=
 =?utf-8?B?R3czVU82bUZKaG5Ld1RxczA5T3JHZnFna3JaRHhYdUx5bGN6ek41RkJ4Q1J1?=
 =?utf-8?B?R1dUb2phb1RpaElLU2V1WHM0QWhnQzB2ejV4WUNrNEdZaTEvYUFqQm5jRHRH?=
 =?utf-8?B?d0o0VUk4ZWhkOG9RNHY4SW92Zkp1blJJRklqME9rTnRSMmJUckZUNC9EeHBG?=
 =?utf-8?B?cStJUFpRSnVMdjk5WVZOeWxrK3lMVzNPUDlrdHFyZ1YvczhPTXdCQ09qY0FV?=
 =?utf-8?B?am03NVlEbmpEdmMycXBqVU9mR1BBRFRRNE5XUFRyTzdlWGVIU0szSjZBbzg1?=
 =?utf-8?B?Qk54dktiTzhzOGRQVHd6WjhneERzQWl0by81RjlaTjBsZml0OEJjdkpmbGRu?=
 =?utf-8?B?M3ZrS3QzbGM1RE1yeUs0NjVrOTV1V3U5bzd1OEdaZ0hTaUhna3BwSFl0V21C?=
 =?utf-8?B?dnBqSlZFT1k0MjZnRHdqZ2FFbU1sMHYwRkxmSFpMdlBYTHdSUmFpdVNtWTho?=
 =?utf-8?B?a211REN2N0I5eGdpZHJOWlV3SUp0Y1F4eW5uZDZkK3h3M2oyMGVNQmxDdGhS?=
 =?utf-8?B?aUtYU0xheERiOGh5a3hXM3NwbGpSTm05Z2FZdjVFQ0hwaWtuK0tlWHZIQUU3?=
 =?utf-8?B?cXorWkxQalJwMWZzMnVjMXFMREFmYWpXVVhKdGl1b2RaT2dMU0RjNkJpTzd2?=
 =?utf-8?B?czFLejE5dDU4WG9xcnBEZzRzWjU2K0xGb0pscWx4eGl3d3hQNXJ0a1NEd1pa?=
 =?utf-8?B?SmxMRW9GTW9Ma01kbUdkL1NSeW5uRlRDbUQ5TjlsQWRtQWVFYy9aeDN5d1Ri?=
 =?utf-8?B?Q1F0bG1HQVBZYjRpYW9kNFk0TjgwUWIwK1NzTmw0YU84TnNYT2l6QnQwamxL?=
 =?utf-8?B?QW1IckFNYVp4WlRLUzRGNzU5L2p1SkI1MGtGdStzalE2dGRQOU9VTlA1N1pj?=
 =?utf-8?Q?PxFOfMFRDIm04KPw=3D?=
X-Exchange-RoutingPolicyChecked:
	HRPyjtLfLu61qGDoZC7s48gi4yG1jJq4qsWhXLt0DGbW2ldbi0AiqkyYGRT1xOyjnvwhZ7IZw+9dUi40jshe/gw4hXLO2RCr9Ys2XBUke0iG2CZHCR2zIbBErkt/o03T0SI/g4rIoBCyEkJAsBnJ7E7l9wDAQOKA5Y56uNk4XupWOU5gh8RzoZAa18DkNldctc4PJCqd3JUCA+w8KhcP99+0mo+yer9i7NZsNI06j2Rc0Y1s+SprDU4rWryEFHrW0G4e/jZXJz+FmLPvzQm4fToLDt2X7eOcvYTYePkb/+MlqOMC5r+xpqRpq9DE7TKiGnqp6rAbFZhdh4Aa7zDqZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oAMjI6DLj0jZkggDA/saX8KQ1xoh0LCb5RtuNIRt3pQjS+1OrXVeyOGC7zsGgvkPIhpHP23/vnYWFqrVjslvxhSvjUKijNeZtzchWGq30MCpdNiIsO+5kjU41ceMbfPcABI9gp48RJynTabFA5NzgxKsZQsJJewea7dg0qz0QptwRKXGlN/fUeYA+zw7s6hGumcsrlecCrfTmTSwmBaYijnwDBow+2+xV7qe+EsEVbAJuEK+AGPL4hGSPRu0uXe9tEQy1QxjkOGMII+/io4R5G1JfXucdJmNN4Qe4LLbXDgTHGhGjPgDXtMW1etLpPob6hDFcfqY1nYnUKu9/P9BDmFsQ6qBL9miP4Df6tCn1PIka5ih/vJCQif37DIK6jXR3HcWQU7djMRifAjNmzYHhX8zGNyMVuk66hQMMtOHwgPnBS2G5nN/4J9wdpWbjPsfOTEH+fzok57pteqzngOSLsUOJZ1Ik3iMhEZo7DY86/KskYext0zSCxXqfY4H+bB5ERs2L5qVUrABm8qHhz7xUYjgWKWLX8aLs1EAmj+VUxFo237kYgBdADMrounPmNe2CYj0Ef4nxBQwqZiUvQJ0PAAL6gVP3cpgC/KjBk+W2uE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf14e4b-1aae-44c3-d969-08def39b6ea2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:16:43.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1hq5sRm/sgzlc0NrsHrZpP+Hmmjtq/m4YIF3MfbucC8Go1uMYp5MryjA1BIc6woem7N0xS79nxF+j3VAwJTGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060071
X-Proofpoint-ORIG-GUID: opdEgncFnWAg3mkw0R17R0xjr0f8aWWg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3MSBTYWx0ZWRfX7sMO1JWDNibB
 /9TGM1SMgGA8ep8tY7VKuIH7Pm1VCTtNXhciVCIUh6O9NutM5lx+9QJbh5XWXJ4RNUKD+wCRaZR
 eRVAB7i1/LgpJpzTRzC6DgNZ87Ki/y8yTEcENgnMYKzLiu2h6KwK
X-Proofpoint-GUID: opdEgncFnWAg3mkw0R17R0xjr0f8aWWg
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a745100 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=N54-gffFAAAA:8
 a=MiuWotLisLCjUXvyyBcA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3MSBTYWx0ZWRfX2kxpqf5jGP7V
 VF0Z5P5c/NvMHSBJoe4zTvdi7oT0GnaCr4+lS57ovlk7OoP+xwxVG+TALZGXlZlGm0OxHcHQLWq
 qD5f+49apzfStWLBJlTHof4paBxg+m8f7KCkUDvqvJ5r+54TdaK+GWkTj/FSDtFI0fJnTPhkInI
 FKXjnM8gYxcwRpm9yBE0Qlj+mogPc7f3o5rCVIA1yZMA776CIOQhzHsiT0cJ+yLwEcxEbzPTtNx
 PKbAgsQGl9gOd18rM/qvN7fuQrnkUIfjBeuFlUQzOQT48VBi6Ei87Wa0RK/EJsAS5r0IqlvVOiu
 6fZTPtoTqaheQfmOAF2cndasAaeZfiGefrFw8ySPGASW7ScUZyt5rE9u7ieR+I9s8iH8earZW0g
 29Ig060Uy4JE4OKzvCg7cBQFjJyfonc0yPgjPUroAm00PToAZmIwOgLzXYAU3HLQg/80XiFdaJc
 XJ1hB7b78N0c3W4aXl6BOcszg13JMstZC6v6Md6c=

On 05/08/2026 22:36, Bart Van Assche wrote:
> Enable lock context analysis for those SCSI core files that build
> without triggering any compiler warnings.

Do you mean context analysis compiler warnings? If so, are there files 
which do trigger context analysis compiler warnings?

> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> ---
>    drivers/scsi/Makefile                | 22 ++++++++++++++++++++++
>    drivers/scsi/device_handler/Makefile |  3 +++
>    2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 842c254bb226..7677fece9dcd 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -14,6 +14,28 @@
>    # satisfy certain initialization assumptions in the SCSI layer.
>    # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
>    
> +CONTEXT_ANALYSIS_constants.o := y
> +CONTEXT_ANALYSIS_scsi.o := y
> +CONTEXT_ANALYSIS_scsi_common.o := y
> +CONTEXT_ANALYSIS_scsi_devinfo.o := y
> +CONTEXT_ANALYSIS_scsi_dh.o := y
> +CONTEXT_ANALYSIS_scsi_error.o := y
> +CONTEXT_ANALYSIS_scsi_ioctl.o := y
> +CONTEXT_ANALYSIS_scsi_lib.o := y
> +CONTEXT_ANALYSIS_scsi_lib_dma.o := y
> +CONTEXT_ANALYSIS_scsi_logging.o := y
> +CONTEXT_ANALYSIS_scsi_netlink.o := y
> +CONTEXT_ANALYSIS_scsi_pm.o := y
> +CONTEXT_ANALYSIS_scsi_proc.o := y
> +CONTEXT_ANALYSIS_scsi_scan.o := y
> +CONTEXT_ANALYSIS_scsi_sysfs.o := y
> +CONTEXT_ANALYSIS_scsi_trace.o := y
> +CONTEXT_ANALYSIS_scsicam.o := y
> +CONTEXT_ANALYSIS_sd.o := y
> +CONTEXT_ANALYSIS_sd_dif.o := y
> +CONTEXT_ANALYSIS_sd_zbc.o := y
> +CONTEXT_ANALYSIS_sr.o := y
> +CONTEXT_ANALYSIS_sr_ioctl.o := y

