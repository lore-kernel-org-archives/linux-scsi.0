Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0708433DF
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 07:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533255; cv=fail; b=qmGd7fmkXi9NTIglzONezwgRkMmW5ypiBAa82deVrIQhGOcFb9X4Vl2DBEzDcrEVxJ6fHkqSNfOuS65oJgDnlOO5QDMONY5bAr1FMYpVVei1HA1FIGRt6S21GR6evfeOzSVLSmWbIOw5W69UipWUjBbEREyXhOY2cTBDCoLG1W4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533255; c=relaxed/simple;
	bh=pyCBUnEIcOYXr2oC8jyrv1vFxbnciunjfivRjdp3RKs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RdypQ0wK8xbGUn88Rlz1XqJwjipf4xp4MM/VKurqXAj+iupyKyazASXQlhTNCuoHYVvQ5WFder9rC9rKWAJ7zSSu/ZtpDmxLBaJjZYKYPHjTITUKkUw+gEs3dA/vrKXfKAk4kV29HhCeQrn4IuvKt5Iv2Hisc21is0ypiUKKKlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kl6tec6W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HFPzqbMc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kl6tec6W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HFPzqbMc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7NDN015170;
	Tue, 13 Aug 2024 07:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=f1oY7sYNqDgPyPw0OZbmw/NUYSV+tWMotxtiZXfpP3Y=; b=
	Kl6tec6W1nOjH3vaVPHdBFSqw8ymyI4ygZeRw/veXR7/oQJGPlZsgKZf1wrQ68RS
	159po2tzXaNGUQgwCgcCL2GCFWMmGRnfgQFR5xNgDqgi9UdWP7td2YmAOcm8Bvhr
	EQTG4eWzD83kvndeV9gsPEL4jtlRZq8w+KJYql3V9nBNHQODoHunOMcxBn8pZDIH
	GM613rmiZLeWeWn9HGXZNltmJHpeXaEhUew6ROrDbFuF6q5tRb0rXeFVbli7eW33
	v19Q40cgINxu/ZlfkbUAhLUVQKi/s+fjy/8TDliB2sKc7PjEhHL+n99gKCpA77up
	GmL2N985FMLcRy/jD9Yvww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtn974-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 07:13:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D5DVqS017800;
	Tue, 13 Aug 2024 07:13:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn9182k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 07:13:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+0fuiskO2X4aHbqhP2CrK6RTddzZI+ZgEQ75KB8omqv35sKvJk2PohcdJW8L2EYlqiPhJDmhOPsitE+47JChXkx3DMQon1ZA/RHsnl1x4gtiVDc49xdpsRmqJOD35V5ZPBHz9w+IvlqXA9bgg9z2LrMX0PwgTlAP+9zn6H8E19pbTb9ZpC3+KmJr9AfmK6Jigc1/XQMM/jw9YhO5MX60Dh2d7j9OLNsD4LdQoF7NzxsyYozyhhQiKZ/4VihotwZBgqkR9+ZKaC1o4nAzF1H8XLrVaH31bgr4s8ehS3yLt9iy6V75PYanA36XWV4T5FqRgQr4zmb/y3W6BYE+GXRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1oY7sYNqDgPyPw0OZbmw/NUYSV+tWMotxtiZXfpP3Y=;
 b=TVuTKMYsG74aW3V0eZGoLEUHv4F/jAg37BbVfQlvn2N1STX698W8sGbFT1JtN6haj8nVU882p7NTucBBcpYrWx7V1c9Lki2Iiva6GvVXOsWm5Vm73/U8U+Mrvl4oC9IpmK0ngwKLIVy4YAX1Q8ZwzxJ2eMn1ZqCWwakUl1vKrCe9nbw6ikTRAE6lrzJcUipgzxs0uqC/K3QaOq2EZdQRO32IPJpR+aGoxUZfwc+2J/aIHFyQZphVGwX5Uamk27UyIRbh4t2nX6aiX9vTeHt4cCGtJ6OCBfyNt1Z6PpYf6O67yT2l3qrn0Xk2H75nCbdW4q8eaX0w6Feg+Tv5Qz+UvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1oY7sYNqDgPyPw0OZbmw/NUYSV+tWMotxtiZXfpP3Y=;
 b=HFPzqbMcqb0Jh8SRZ3jYjaiE1xMienBUhmIdbHDU6M+ZoCftr+G4ssvRUThFutEkWWSvfVVTH46qv13rRrS28vN9M1fgdCGEV+JfBwXzVIIqQkp243umjh+LoBn2Qd15unETr6JBNvdGRiOsf1JG+oPrgs28bexNWj4ATqr7D6c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.15; Tue, 13 Aug 2024 07:13:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 07:13:55 +0000
Message-ID: <0e54f37f-d0a6-4296-b9eb-fb3a3713f52f@oracle.com>
Date: Tue, 13 Aug 2024 08:13:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] Driver core: platform: Add
 devm_platform_get_irqs_affinity()
To: Bart Van Assche <bvanassche@acm.org>, lenb@kernel.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, tglx@linutronix.de, maz@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <1606905417-183214-1-git-send-email-john.garry@huawei.com>
 <1606905417-183214-5-git-send-email-john.garry@huawei.com>
 <1d8d8bcc-e70e-45d1-b722-4931d2a65ae0@acm.org>
 <2839fb1b-0547-42e2-9f85-8acf43a2545d@oracle.com>
 <43d83d78-9ae3-4dbe-98f5-9e9736442782@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <43d83d78-9ae3-4dbe-98f5-9e9736442782@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4be16b-3e53-4f5d-bb28-08dcbb677e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWlhdEhodUIxaEZWVlRPZUtnN01sN0dIQmNMb1VYc2ptSmRJK1lUUkJCUzND?=
 =?utf-8?B?SElIV2Y5bm83bTB3anRCWTZMTTY0bVpIaHM1ODJHV3g5dGRDVzFNcFdlWWl0?=
 =?utf-8?B?UmN2YWJGYWZlZUFXMHVJcklGTWZjejMyNkhWSUM1bWZIU1g0eTNpQlhlV2Fv?=
 =?utf-8?B?WEpPM2JUK0dUMXhrVXNyQkpvekUrZTI2S2JldmV4T0xjTlhHc1U0KzcwV2FG?=
 =?utf-8?B?YmNwWUNHOHJhYmZEY0d1bjFITm9tTFJyaGFrUnd4ekhUOUlrVzJDRFVWTUpy?=
 =?utf-8?B?L3ZPSTR2eVZZTEpDQkdROE16NzZEMzZPTFFiS0YzS25LL3F1c0llT05FZ2p4?=
 =?utf-8?B?SjhJUTQ3cFJrWEpZM3dEakllejMwV1dmU0dhbXNyN2p5dmdGY25zeEN3ZG9k?=
 =?utf-8?B?Zi9HSlNPZ0JKN3dlOUJlclhJYk5OV1phVkZoOUdGa1lqVS9IZ3Fla21uRlNX?=
 =?utf-8?B?dkRhdDJXRm01YmVOb2t1Y3BJM1Q2V2k4REdtM2xaK1RMc1lRVmhoWWxzZ081?=
 =?utf-8?B?VG9vWnBMamZsS0pncnNDU0s3eFZpMDhsaG9RRlBXVTkrZHZQRGpobTJuQmt0?=
 =?utf-8?B?WHFzVG5MWW4zWnlONGZWcFBCK1VtdXBkRUtBWHk3Rjd5UC9kcFg3SVhLU1Bx?=
 =?utf-8?B?NGdEUjloLzd3eDczN0hBQkpaM1kzUjAzVlRCVU03eWxoODN3RFlXckpQV29u?=
 =?utf-8?B?bm1vK3k3N0hielB6L2dnSkNONksyNndRbG15YW0xZC9adDN3eW13ODlTbno2?=
 =?utf-8?B?Wi9BRG5sU1ZQS3ZXWHJrUGxoV2drYUcyb08vTzFoY29ONVQyQzBoSlVIa1lI?=
 =?utf-8?B?eW84WlhmTWJZT1ZORHNlSlRHc3lMdjlqZS9QSUxZTWt6RktRT3hUb3RzaG0x?=
 =?utf-8?B?UFBQd1VqQmVKcU4waDBvWmdKWmhXNzhTVStuL1lkNUR6aURXY0tqRC9pNGhk?=
 =?utf-8?B?RWJydEhBTjZ3MDJJT1RKTlE0Zk9PVCtHM2N1UHc5ajJ3SldGeXgzdnJLeDY0?=
 =?utf-8?B?cEJaUnhmek5qM1RjZW1HR3lmMkJhYkpneGRBWGdQS2pvdzhqckV2SmJpeWww?=
 =?utf-8?B?UnJTeVdMSGVZQ1lBWFdxbnlnUENiNEMrOUlpVVAwc1NPdVFheEdaWGYrdkV1?=
 =?utf-8?B?VXRnRHIvNjR2WWVTV1phSVpmYlB3N2l3ZWNsSlFuais0SkJkeFkyL3dPczIw?=
 =?utf-8?B?UFhyOXB1angzNnRHeFRzUWpCS3RlQ09kNzVJQjNkQ3BLT3Y2L2tFenVmSWZp?=
 =?utf-8?B?UkU1WG15YlNnTGgySC9OK1hNZGErbVVzTDloRGFaOGs0bWVTYXk2VzJQTjZp?=
 =?utf-8?B?bmR0QlFocVh6SUFkRG90SEM4RURsVFNYU3ZrWFFTOXBNSllrMHRMR1cyTi9R?=
 =?utf-8?B?NGpaRHczU1Q1U2JCS1d1S1NHYkNCdTlnTGo5dm4rTm9RTWpkUDNPa3B0blQv?=
 =?utf-8?B?YXdsUXdjbFZGSit4cGJud0ttMDFHZzdiOTFsaEc2d0pKOFJrT04ybTlQOVQy?=
 =?utf-8?B?dkNBUXVCMlBDYy9sbXpjNjQ0MXhtU0NGbGUrOFk2UTVWaCt6RXBPcGRLSmQ3?=
 =?utf-8?B?ME9DUlVtTkdkb3AxUGNHbDkvUzNVdmdVcHJBOThCZzZFV2ZYTkdQTEp2N0pj?=
 =?utf-8?B?L0FkS2tNdVkvc1BsUlVmeU5xNm1Va0RXYnMxd1RqZ1pSSnVFREd3VWJaenpD?=
 =?utf-8?B?b0ZpMTRtYWxUOWtUMWVsVTBlY2RYUWxjRnVSSEs5RDF0d0lGZDI2amFmOU11?=
 =?utf-8?B?MVpoekJTMXNoVlhEcFVsVjhVR3Irazd0aG5kQVQrSUZPNnpwcWYxNmJEV2dG?=
 =?utf-8?B?eHpsK1UxUE1LcEx4Zkg4Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y29aL3hCSVBYa0JQc2lUdVlzbkQwSnAzNWFVOWhwN1dGOWJRN2s0N2thQ2U4?=
 =?utf-8?B?ZGhsL211cWVEay83dk9XeWZsbzJxZzJjN2g3TXJBa1dNYitIYWlDVVlJamtk?=
 =?utf-8?B?S3FlazdQNFJPSWd6MEdnRmRHQXo4M2lSQTA4UFZKN2hlYlI3cElBNVUvckFo?=
 =?utf-8?B?dTBTMkZaQ2VSb1EvNVlZdTI5bndjTnNXZ08weUQzaCs2OHJjcytFT2E0NnJ0?=
 =?utf-8?B?TkMwQ2RkZ2FoOE9qNXBCelBPekZrMnhEcTdpM2tFQU4zVXZDZjNzZzU0dnh1?=
 =?utf-8?B?czNTMGsvQ29vMnk4R3QwUWVkZHNZVlVzQ2NyM1loUkZLVWI3dC8xaFBZRXQr?=
 =?utf-8?B?UUFWbS9qcXg5a2p5SzdlUisxYlNreUw5bVJGVktrbTZsZzFqeC9VSDFQNjJk?=
 =?utf-8?B?QXdBMFdwNDBGNExyVTZhR3JESEJ0dTJkTUZMb0x2RUF5b0xjRzdiS2dZUFJ0?=
 =?utf-8?B?SzJPekVWVnZVaTRmQmZ3c2RkYm9EZE1OeFlyUkQvdFB2cnU2aC9jVXQ1RlJG?=
 =?utf-8?B?akJ5TEZoVElYSlYxOWVKNm1nWjlMdkVkdzhUcUpnOVVHelhwaDdhYTNBNTBv?=
 =?utf-8?B?dlNReEVHSnBPZTI2ZnNQcG1jYlNxZ0lIeSsranFHd3Q4SktYaGR5ZDNONUND?=
 =?utf-8?B?K2dHZDduK1lrMzZZTUxwd0dsTE80aWxXQUJLOU13SlpPU2R4VG5Vem1YQk83?=
 =?utf-8?B?MUx2UEpabXFydFI1UWk1cElZWURLNnRWR01EYU9GUUZxTmMyUUZWVUZUSmYv?=
 =?utf-8?B?MWhnSGszV2dHOHF1aksyc3Vjdm1nS01nUm1zTmZqL2VOY0dnbFEvK2Y1dUZO?=
 =?utf-8?B?c2JSbXY0eVpRWFVYTTRRTG9lcUF1clpTeGo0SlVKSWNqdWJ5dHZCU0t1Ymo4?=
 =?utf-8?B?QlBUSkJwY2o2Q0ZlNUZMWGNQL1RVNDYyK0ZpWlVVK09qZlRDckVLTTg3aERa?=
 =?utf-8?B?NzVyc3JEUjNUZ2JJTHVtOHJOdDIyZEtDUEV3cmJiNmoycTBXcm94eGhWZW5I?=
 =?utf-8?B?OEgrWmppRklrd1FKanF2eFdOT1lCaGR6SHRic3Q5czBjWFBNekVMcmN4VUtP?=
 =?utf-8?B?WDFnem9wYUV0MHdSMUNFYktleFJKeGQxSVJMaDlTVlV2OFpwVkwxbnoramE3?=
 =?utf-8?B?YjhlUUdJRUhjM3BWbi9JWFgxVjZ5ajd2YW16dm4rb0JVNnI1SjZjWFliei9B?=
 =?utf-8?B?eHVlSTRoN1NaRktOa3NZMGJiSkZqYklvdkRneGRDVXhtYzB0dFczMDFRbnlY?=
 =?utf-8?B?WjJtMm16ZmJPRUtKRUI4SUlUakFFamRTcUMrWmorbUdtSnpxSjNyVkx0U3hJ?=
 =?utf-8?B?YUlvVTVJUHNrL21Fcys5Q2RzSVAwYUVweXNpbDlHQU9JQWZMbnlFbGw5NFB4?=
 =?utf-8?B?UWNhTkRnaDFOL1Rvb3VRd2tsb05tNlByV0lWZnhsNnU3alJGTDRVR2V0UU9x?=
 =?utf-8?B?S2hPZWdra1JzVVBPNWNiVmRrdUJjeWYxV1JRL3BtK1k0eXluSFo4UklVVXcv?=
 =?utf-8?B?bkRaU05pcDZ5dEFQSWNIZmtydDBKRkJIQzNTUlNxNy9rVVhaZ1BUV0hMbk5I?=
 =?utf-8?B?RHU0eXpPWlBId21LN1l4MTBuWmhMR2FuZW5TdUZldHhMWkZ5QTlVRFc0bFBq?=
 =?utf-8?B?TndkVHBBSEtlbUlqTW5UdjdKa21RdDVTdWV3Tit5Q0dGeDVIaUpSWUxQTGFl?=
 =?utf-8?B?WVFpeHNCV3l1UFI2U0gyelpKRjdMOHR3Q2xyMUxSbUZEWGt5NHZ5dlJPeWow?=
 =?utf-8?B?bjJ4VkFJaGphQmc1UUVlOEJCRkdmK0N6RmE4ek0wNHo4bFFNSlgzR1o4WXVi?=
 =?utf-8?B?NWlpYXl4S1pCOCsxVGtaREZRSmdNbUs1Y2dGaUl1b2MwMG9sK1hTNEdiOE5j?=
 =?utf-8?B?a2IxaFRxUlR4MVY2MWg1eFRQS1lBV1hVMHBlQzNCVTlUZXJWK3RQWlBvWE1J?=
 =?utf-8?B?aGQwYllWVWtTdnYzeVJSS1FvS0owTXNkb2JHSFd3YVdoQUlLa0JVbkpULzZo?=
 =?utf-8?B?WnVxSHE5a1REeE1Eb2wxcHpuK2RZcXprd2pzSFd1UlFEOC90UjZ1dFpHNnNP?=
 =?utf-8?B?RkF0aDJsMWVOTkxwZ1J3WTMrMDlCcGlrdk1WT3cvOVY1Y3N0bGZYY2J4RWFi?=
 =?utf-8?Q?hyUzVT2o1QFkpjS60XSLaoTar?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DXe+0xrqPZdGGFawHKefxlMIWUZMLqWg5jmuFWyvZiVYhibo4aAK/4bvzDbRopRmAmt9qF6E5ja5DKFHtFjW1K9Z5J3rBFSoGJ/WZ6wDYhXdlv7VnmkEAlLZqk9JNoM8LDiPgL1Litujh45Jki/UWJSHOiAX68Vv8mEVyBVbZmyDCQZT7ifKg4MS3tfjRnaCrLy3oW488lHWm3IIKkmLQJl8kv88HCszwF1ptm2YPnER2/KF8zdp/Ehx5AxTz3wvC1kb59LefJyCxARXp0274/8HS94j1ltpRtAiaKkKe0a6g0NTzcwwAGIDau2yD7eTGnjgNASj5dV+vc5q4cQ4hHks25t4Utr1v/Vt/8t25eoWNBYprP9wRudTqKis59pBLsXNWAJAVU3erRtksQp5bOGKoIOGQj1v5U/2YdLj59XOGoIx8NaQsoT+w/Y1SgbXEg4UIVrXidCksLIpCCY8pcyCholSXFtF/wf9WQC+Fmckh32kSf8ePljiCXL7jCDGyesSQKzIcP0WNsECOfzgt4tVlu7mcd0hJk+RsMteSgj2Qhcj7LdKS5NaqTxFoPEN/Vb9pZql42LerodPonRksxQFQ4ExpSi70nUftkmJyeo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4be16b-3e53-4f5d-bb28-08dcbb677e04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 07:13:55.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYS08/p1c1rZ16f4Eb9GkEWZZiA7gqg/VqEFYeCJYAyMpu9WV8Xbrmodh2h4FKg3mbM1bJGPU8UIfrKfO6Zd+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7364
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-13_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130050
X-Proofpoint-ORIG-GUID: s13HucBPWbS0gilOdN0O10sBQiLHkMWi
X-Proofpoint-GUID: s13HucBPWbS0gilOdN0O10sBQiLHkMWi

On 12/08/2024 21:29, Bart Van Assche wrote:
> On 8/12/24 3:46 AM, John Garry wrote:
>> On 09/08/2024 19:11, Bart Van Assche wrote:
>>> On 12/2/20 2:36 AM, John Garry wrote:
>>>> +    for (i = 0; i < nvec; i++) {
>>>> +        int irq = platform_get_irq(dev, i);
>>>> +        if (irq < 0) {
>>>> +            ret = irq;
>>>> +            goto err_free_devres;
>>>> +        }
>>>> +        ptr->irq[i] = irq;
>>>> +    }
>>>
>>> (replying to an email from four years ago)
>>>
>>> Why does this function call platform_get_irq(dev, i) instead of
>>> platform_get_irq(dev, affd->pre_vectors + i)? Is there perhaps something
>>> about the hisi_sas driver that I'm missing? I'm asking this because this
>>> function would be useful for UFS controller drivers if the
>>> affd->pre_vectors offset would be added when calling platform_get_irq().
>>>
>> int devm_platform_get_irqs_affinity(struct platform_device *dev,
>>                      struct irq_affinity *affd,
>>                      unsigned int minvec,
>>                      unsigned int maxvec,
>>                      int **irqs)
>>
>>
>> Function devm_platform_get_irqs_affinity() gets the irq number for a 
>> total between @minvec and @maxvec interrupts, and fills them into 
>> @irqs arg. It does not just get the interrupts for index @minvec to 
>> @maxvec only.
>>
>> For context, as I remember, hisi_sas v2 hw has 128 interrupts lines. 
>> Interrupts index [96, 112) are completion queue interrupts, which we 
>> want to spread over all CPUs. See interrupt_init_v2_hw() in that 
>> driver for how the control interrupts, like phy up/down, are used.
> 
> Hi John,
> 
> In interrupt_init_v2_hw() and also elsewhere in the hisi_sas_v2_hw.c
> source file I see that the CQ interrupts start at offset 96. However,
> devm_platform_get_irqs_affinity() passes the arguments 0..(num_cqs-1) to

Total interrupt lines are 128.
dec.{pre, post}_vectors = {96, 16}

which gives
resv=96+16=112
minvec=resv+1 = 113
maxvec=128


> platform_get_irq(). Shouldn't that function pass arguments in the range
> 96..(96+num_cqs-1) to platform_get_irq() since that is the CQ interrupt
> range for this storage controller?

The API is trying to be like pci_alloc_irq_vectors_affinity(), where it 
accepts a min and max vectors to allocate.

platform_get_irq() actually does more than just do some lookup for an 
irq number - it also sets up a mapping if it does not already exist.

Furthermore, as I recall, maybe platform msi code or mbigen code or hisi 
chipset had a restriction that platform_get_irq() had to be called in 
order for each and every interrupt line. So having a single point to do 
this made sense. Check interrupt_init_v2_hw() code and comment prior to 
devm_platform_get_irqs_affinity() existing, like a v5.10 kernel - it 
called platform_get_irq() for all 128 interrupt lines.

> My understanding is that the
> devm_platform_get_irqs_affinity() call from hisi_sas_v2_hw.c will affect
> the affinity of the interrupts 0..(num_cqs-1) instead of the interrupts
> in the range 96..(96+num_cqs-1). Isn't that wrong?
> 
devm_platform_get_irqs_affinity() will only touch the affinity mapping 
of the completion queue interrupts, but still call platform_get_irq() 
for all interrupts
