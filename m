Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4291E3783B0
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776938578; cv=fail; b=mV9H3OKf9xqSua5omi0L6JmEnMBl2U8UhIy2HI/SuhlaFnaBO9Wv2g6bb9CXcNp0YOcN1qIjlEKYc5Ix1/D2DphANZJILNLcFKwTmOs14Y+p7a2fPtvYaIamNqe3HMiqhJQipIomIln2jZCvis6pqxKlp0KBxQIAx6VZ9GR8SGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776938578; c=relaxed/simple;
	bh=uHsabg96e8v21FYs21kSBgJya4IrtwKb4RLRuKRa9cM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pQ8nYm1Fl7upJiuTv0Iyykn833Ynzkgznq0K6EcvE/E8OVNjsEZ8dcH4VAdDRJ7IWN8VtRABZuhj36wIQEsbbutuKbHIUSZe6H0Sv8W4uTUpLFhSFuylkgJtgShgTPxEa4xZAkfKmfW5gUPwH0iIJ3uKmS/WMCYn4oBKbItbq+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OkIChEKR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QFw/Ihvy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OkIChEKR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QFw/Ihvy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N2I0N03517411;
	Thu, 23 Apr 2026 10:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LfVsRFM8fIdmvD3i5a9rfpvrAKYTMgYLtkGF9ii4rNU=; b=
	OkIChEKRWBV4lBC6RrZRdKc2Vix0d7FFQNMKVoGfhHebDCbEJw+UGdeHxwNfS5mC
	ary3goSMrOGESEUGHPsDcYa+cUD5YMC1Ml7/s1nWabdQQVeTetyLIyJY46TPz9gD
	oc2kleeRvWFvb3s+6SmmRPImFCWTqhohIf69V+SNuPqloT0bO4oTULJDNPrLQ/m3
	i7viiAQXkYhg2AYjyMxyoUiRPkrrwIi5jv4+m4ix0KO2cFVgFYrK7x9s9C+1zo71
	2zo3BlyPI6RFP/GJg2vMjPZOpufGpOgzc/DOHTlRHyEtKpnu85e3wHdcufAuKMkI
	xPMahYiwP5pp10jR5kJBIg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenrk685-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:02:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63NA1IH0035897;
	Thu, 23 Apr 2026 10:02:46 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjrebnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:02:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhXmQMVLuFB50bsj3wiPyK9ySu70HJSJgH4fm27vitbZXvmyY3HuI70cROixo7x3rZ78kycY5opy9fA6M+lZ2qap+QHio99UUAMMszEm5bgFdt1vvtwRI5fw8sH1N/f7YOwEijMVnMDi5QCpNYvQKUPKXgRmb7VEQav3f21I7hATO2gFNpuIk6bSC/oquEuCMV25075YZjScJNwIIhamtF5/Nw1AZyGflzhr8YjAPZiRh2r1Jctl/utB3cNJ2XjStq35aI9u51w6+nhFOfavvCNZEO0gfsXvBRxASN8w49IJEdLBIgI135CcsrlsCLDY71qCfqrnYtUEl47AQUlc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfVsRFM8fIdmvD3i5a9rfpvrAKYTMgYLtkGF9ii4rNU=;
 b=BTKzQOe2W2j+TuaIb+D8BcRRE1qkI3BlRMj2gg9jK+jusKfxKMTZ2ICbwROxBaHQF2bsbx66q9oMo8S7E2+lgNqGC6UQ85hSOTjggHb7Gz8vGXWHWYRGo9U3qmE5IUDdGFT3Yc1LHhiTJBgUhtwSmOcAUCwnbh7ZiN2KgPE4f6ZzXNKha3XV7g58NAkPe1SxjhmRStGnM5zkI+EC+TACLix+VEvQcfPy+Y92YUBzq7J4AzgexpH1OxN6/HdrrunoZHkxmJ+4ZwxwOF/fL0ccn1vuLzRuwukhAqC+wZqpxGfSR/gwAemI56HqXTBnHaSc0ysC5gjtkcpCi/QtZmaZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfVsRFM8fIdmvD3i5a9rfpvrAKYTMgYLtkGF9ii4rNU=;
 b=QFw/Ihvy34cESGwU/PCQhS9ahlSgp0Y0yTOSzurk4Z6rLXy4rJ/YcQfz0qx/ee1TKlX+nfY663mHgc5WCaA566BqhmycWYR3ouvXRuwBZ4YTSZJPBQsYc+dWL8AGKmlzhsKs7gUUupSVmfcFqXxUV7HmzUtPNMMAs7a/SVYvhP0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF94A902B17.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Thu, 23 Apr
 2026 10:02:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 10:02:43 +0000
Message-ID: <65e78d0c-23a5-4702-9946-60b83532a61b@oracle.com>
Date: Thu, 23 Apr 2026 11:02:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide
 limit
To: Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-4-michael.christie@oracle.com>
 <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0340.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF94A902B17:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e0a0f9f-29ee-4556-a299-08dea11f7551
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0+xxsKvzYE7bV9i0YlB+S2nWAjT6kGgKNXXQpMUrAI4l4H2DCtXlz4Sg+pO/GAmOLkcJDySO1gTII3cZXyLA8cwZhwMX+vXvu9P+/oKVxMWdzt8eOP+c4lSyVEVKPSbnih7sU9Ni54k5EhnsnabeZZbDRcBhFxqG1Eulpr5FPN0HZfQZqN7hvuJ+aVPg2JOxpLfVY2iatODYo0Ggl1Gw/rd+x4+siC9DzpFlpiGYEJigJ9q7ADp/kwKAEoFa5BUnzvoS1IFnaYIaZI4j3y9kK3xAdYrI5oH+D1z55nC8vz5jBhSWTI8gqrn/0VpbkEFyaFzf26je87EoKzBSBzJ4sUoe5MbzGj0vJfn+1mZo7E47PoLI+ka+X3GDBnGryoK/kRTDVTAj25VOcSmpN90g1GJmpcjCqQqqw8S6t4/UWdEDb6fcqh/qn4e5k+Vbyh4g3d1mGTu/u5dpaTM4JCMcyqkrBvPhXVWhFmmXYrqkzUNb828vCOm6DaQG4d60XHhhdMK7Ge4Zj0e6MOq4i7qtkxTXbF07EwchQ1hLRMiuoarLpWZtykVfcOnh1Dz/HTC+1Pz4FNboa3+gQmOzZus3gJ6vFOZb8Yu6979f69qy2Az8goux1HS3xb9uEHHHM3b0DiIxQAKr4M78XiLGeTt3LHA6dkLymb13PX/sTj8PMme5ywWK7rtNkLztq7vFhOGv75txT8P9PZuUZCi/pYxwI0HXFiP9kbszWCAuIH0z71ETEU3X3pi9n2W9xgKPUuDJwRuSlCfcn3f+ybWjAbRJ1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0FUY2Z5a3FvUElOQUREdCs4SGdkdHFrYm9BQy9VNy9Td1FNeFFRd0NVMVo4?=
 =?utf-8?B?alVRaGhiR25Pa3MzQ1RQMWw2M0FvWTMvaENEL2IwWDVPOVpMYlY1NjVtV0dR?=
 =?utf-8?B?R0xQUUx3Y1A3QjgyV3ZUblVpQ1R5eUEvZU9VS1ltYlFWOEpzbGZEU0NFdm9O?=
 =?utf-8?B?WkEvYzgvT05wNThrMmp3dnBCeWcwKzhnL3BwL1FlRVM4ZXoxK2xic2VGdmFF?=
 =?utf-8?B?N1d1Rjl4Wll3VWVQZWxtNldqUDd2RWxZYnZmYXJlM0JVTjBXTWVIOUFTY0NP?=
 =?utf-8?B?ZWpBU05TU1hlNjhXUzlSakpzR2h0Q2ZPcXRHRWsxelJIVVF0VHJiS05tckJm?=
 =?utf-8?B?SE5yK1lPWWtyeDJKQzV2aXhaK2lqMHRHOEZSMXBXQVZ3L1J0eitrVGIzTlVK?=
 =?utf-8?B?MjZCbUttZlJqRWN5YmF3eERxcXVISS9tMkU0dlBGclJTbnpSUHVzWHNRN2lw?=
 =?utf-8?B?dEpZVm4vRE41U1hrVGplYUlDMHpUbndUb0lyaDVqVForMU1mZUhPcTdoOWZq?=
 =?utf-8?B?dDIwUmo4c1dkYldqaGVjc1FRZzg2SzlYT3l2TU1qazJwWTh4aGs1YlpQblRD?=
 =?utf-8?B?Umc0UzZ5Z2Y1c1NLN25uQ0F1b1FIMTVVa0tLaXhBQVpDNnhMSzVlb1YzblJM?=
 =?utf-8?B?Vml1NTZnSzE0cEhnT0o1dlBOaVoyTnQ0N2doaVJqNkxSWFc1Wk85eTZKVk1t?=
 =?utf-8?B?Z09QMXhqN25zSlJmL1dWYW12K2cyM0tpQ2g3MERoa2tZc1ZFbTVOak5mTVNs?=
 =?utf-8?B?YXNzazRwTlFFSDZGWkFPRHgxRTdDdE9lNXNjZzA1dEdkQTByVzhHS09qcXI5?=
 =?utf-8?B?LzdlREZiTkpWZzFta1hNMFA0Ri9JQlVJaWNNMG1aU095WFhON3B4QTNkQ2g4?=
 =?utf-8?B?eVp0c21qdlJ5TUVRaW5yUnhmN3MvSGJXcHlPTk5QK3p3a1h5U2R3eFpPTU45?=
 =?utf-8?B?UWhBUWJSMVI1MWxTK2NVaDRVMDc3WWo5V2s0NFRtUkUvd1dlWHI3RkozUDdT?=
 =?utf-8?B?RlArYVBOd1JPM3FpRTJHdkh1QmhLSDRnSU1PQnJSSHFZNS9MRnVXZUkwZkgy?=
 =?utf-8?B?NnZXNXdmclVpVXl4MzdsOCtVTTRtaEM2Vnh4VG5RU1B3ZUYyR3ZLRFRFUXRJ?=
 =?utf-8?B?bTlBNTM4c0pnWEh0SFdoVWpLdFF6bkMvK2ltL3g3R1FOMlU0YTRNa3FKck5C?=
 =?utf-8?B?NFBPRFN3aDRYRzhIeWlDNU1SSDhvYzIwMS8xTFJib3ROc2lhbkZHcDJ1OFpl?=
 =?utf-8?B?U2RFL3k5NFprODNieFJ3V0FHTWRIS1AzbzI2RHkySWk2TmRlcUd2elNyU1hk?=
 =?utf-8?B?MDdZaHNaVmxGbDM0dmV2YXhUeE9HQkUvMWIzaEZTNHowZVp5TzJnRG1HaCtF?=
 =?utf-8?B?amVGdHdWUzJ0eEtON2FoVXVSMkw1UzdvYXU5Z21temlJSUs4Y2lQZUNwUHZu?=
 =?utf-8?B?d3VjY0FKb1Z6WEdGcVVlNGR1RTlPTG1leEdGNk15MDV0QVE4ZXY4WlNxaUlr?=
 =?utf-8?B?Q3RXL3RMK0RpUThoOEpmaDU3Q0RVQ2ZMSCtEbExGUVFhRGNGNldSQlVnakIr?=
 =?utf-8?B?WHZVeXVPUGl0amJsVlN5Z2xFL0N0ZDJ2TE8wSW0zd3k5TEF6c21BOEs4bGM5?=
 =?utf-8?B?ODAzWVZRK2NoeVlKTW96WDNuTm9LWVE2RlVQZ0FDSzNsczZYSk1xalJRRlZx?=
 =?utf-8?B?QzJxQmdsRktsUkMvUGdoOWw2UHR1UTVmeVRuWDdhOTQyRVN2ZDhCR1J2dk1i?=
 =?utf-8?B?Q1FKcGZacTY0UEwvTi91Y1kwRzBYYnNxdlNKRDQvOWNlSkEreERyMHg2dFBL?=
 =?utf-8?B?YnozYkZDQXkrYW82bWNPUHlCM1VBdyt3a0tubmpRakUzNXlQci9WQ3BNM0RD?=
 =?utf-8?B?NjRDWjVmYzN0Q0lYN3paakxMazRhTnN4blFhQnV5RTAyRi9XK0hDaUt4TFFU?=
 =?utf-8?B?ZnlaZWhaUlpGWWFUa2czdnlGUGp5aVpndEhtbFdNV0ZRck9kOXZ1bytPdXFG?=
 =?utf-8?B?Z1dnYnZTem5GSDlTWU9zY3hRaSt1azhkTUtkbFZCUVhFbjd6SjA2OFZjWmk2?=
 =?utf-8?B?RFgxc3duZ1lhOEQ0Zm1tbWpyYnJvd29mUUgycTRVNEo2SnRCUEZFQnY5MzZF?=
 =?utf-8?B?WmZ4Nk5VSDNDUVE3MkJ4NWlTWUtuOWZrYlo0VmhPNjhqRDhuT25yWVdDbm9N?=
 =?utf-8?B?Tjg5VzRIVUtlLzJpbHBpQ3FDS0pjcUh5OElKMHR1Z1VJaTZYcTFhL2JtT0RT?=
 =?utf-8?B?OXR4QXQ3amsxaUJndXg5bDBQb1llVDdYVW91NVVJdUJYdlg1NWUyME16Y2lH?=
 =?utf-8?B?d3YvZmhuaktmM2d0RE5MRGZsMXYzU3dFMXRzbHEyQUxlM3hqM0cxZz09?=
X-Exchange-RoutingPolicyChecked:
	J6b0GsNPRi0PwJERk6U4Fwek3Ka21gL3kkuxw+T0ynNdL2UX83JH0aeB9bqT+F+f+XXfoyrzlR8c13yiwWv5fK2JeHvXhmMuU4rPgnHLnX/yIXdXiaJNe7o4GdMuswujn+D+QRukhjF3ccjFbAaN1VBU85O0uGFkuVU1tMW6S3/cwfOOwn9Zz2prTtEdV4ViUSbJ4X1MvyPmaDZ3ENMm8lMEM+J6tVkPhmGAQ2gBaD/amUKVv5KTUwqrab4u//iN4jxATx3kcrSwVbnbAwA1sDOPRoO4CvwDw4nbmBmxWpTfR9n5CeDuOzssZVFO+RKitsiY6koXmOLZGRMGTPxOTA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r6fUatCSja7OHeI41FksAE8eGCSCcoQx1iCb36c4G2OmjJUcGj2hD3Dt8V7UvD1FTaH90GPTWPvOnF2P/v/jgRwK8AIVJj91poGm4p5e8kFsxI7oGmOcQ9Jgl3PlNGlJ3d8ev0Jhe2Fgx+nzYfpgtJEuPzumd7uHhMlbGtJ/5o/1JDtqwULtAMZs1oXQ9tarZKwaFgM+MWRODtAj3Ln35ea9ERL77Zfmrg/EsMBkl3fwsJ4g+SqHyQlIPSt8LpUwXZlgBF4hSl3fTg7AUKUxPMr40/gRTpwVum2vcNAuuDMAvuFPTMh08CDuSwFl5F1nOQEH2Tzkm5opwBi50bpgjk+FF1tCLip97OMVREKciZtiusRyss2vbU+G1dcgFPQ6MtlpM3htwmgRZTZKcOJNkDfODA3m8sPYe+UD/wDkB81WyQ51z1Pz8sQtJU7dONVnWsMlPyETUm3akfsEIfkTBIU1YaJ/wVsFVic8PbzQrWnv/cAAnZDBi38MH1A9zsfcejfGLYzQmNiDNktYXbYf+8MFMGoJNcdD1UxaszwZO/TewwF6uEfRyK5sABhzSHGfXl1nMnxZ6frImIggYT4R95JqZkL23mb9NLJlLfNcGQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0a0f9f-29ee-4556-a299-08dea11f7551
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 10:02:43.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enef3HAHzEka1ANPLCp0sTP9Q16jwuxxGer7q434nbVLYeL3VC9KbimlGKIRmUCYQ4EbFtvb4hrXbQxfPP6Odw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF94A902B17
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604230098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA5OCBTYWx0ZWRfX6O5xne+eDdCH
 zZhzeL00hVUlRQRud+xAUQz8+HYp3x6FM92Hqd8lQhmCZykJ6keeDxPgQJts5VHkzeoXfvMjnOL
 CJBescTyMfN/agvVNdfAegM3+u0VuvDr6z4biOh5fFXEul6s8MSffzbAq9Q0CQ+Nt8lzleBIuT+
 B884lrXAMRUC1AGiDDiLlZAEDjnlsxYnSoR1Ep65q3bUmwGnpdaAuMcGyk174bF09eJr8NkGiUP
 UNb0XzKdypWUbXK9d60v47vHQPj1pInbQ3ll/OjNZ7ntaROf/uotnUolvvKZlyInT1m38bt0cFl
 1KopeVfRwatB0ko0PDYIuEmiJ6+oJteaWg2lGfNMCBg7wU7u3PxZd731YOT78rfJ7AaesDboaCL
 9EZ0AbZ9bfvuZFCKdYBSE737yHC3A4Zy3aqpOJRRVWeBb0Q74q4TSVz4JCgJLPSh/ABHtOgD03O
 a/Gvk/95PNrcRIKffpE5akDU8QGSQoQbGeO0h/2A=
X-Proofpoint-GUID: boFiXUJ8IXNOStO43S0lNicmEjc7aox-
X-Proofpoint-ORIG-GUID: boFiXUJ8IXNOStO43S0lNicmEjc7aox-
X-Authority-Analysis: v=2.4 cv=JeKMa0KV c=1 sm=1 tr=0 ts=69e9ee47 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=63_byiqFLi9FIXkBUN0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291

On 22/04/2026 14:15, Hannes Reinecke wrote:
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -352,18 +352,20 @@ static struct scsi_device 
>> *scsi_alloc_sdev(struct scsi_target *starget,
>>       if (scsi_device_is_pseudo_dev(sdev))
>>           return sdev;
>> -    depth = sdev->host->cmd_per_lun ?: 1;
>> +    if (sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN) {
>> +        depth = sdev->host->cmd_per_lun ?: 1;
> Why don't we use a simple flag in the host (or host template) to
> indicate that cmd_per_lun should be ignored?
> I'm not in favour of using magic values for a setting which
> otherwise is a limit.
> Look to dev_loss_tmo as a bad example ...

I think it's better to not have a flag and also keep cmd_per_lun, as 
then we need to sanitize one vs the other. As mentioned in the cover 
letter response, cmd_per_lun could be got rid off / reworked.

Personally I also dislike how the scsi budget code checks for a budget 
map being non-NULL (which is for reserved scsi devices, which doesn't 
need a per-sdev budget map).
