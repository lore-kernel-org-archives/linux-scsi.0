Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B184F1C6FF0
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 10:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743761757; cv=fail; b=RRAYpq0xdq/P6u33I8fwLqnXknysnCU651UhXy2ud9FovfvevrLJ11mwQ4pEIowCv2WYQ+Y4jSHRsYU8ISfQVOGf7MAoNj93b1aeP3q35gf3TH5mhZNFLTFwdTco2BoipGx87Ofh1IB6UmuflWRPUypw7LCpcNLLDeejUX6/rxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743761757; c=relaxed/simple;
	bh=sfmQsVWNrW5iVNiNR8ZXqQNdisXIDBMTyWL8kk0bC/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N+WI1AfyAELAtJAp39M3scYvEBAJS9Xzg3p0+Agc1s2wgdZXdDCFOcdFtVTW09urzwykArV05w/5tluj/Cq3QDo43wZkPvynFRM11OiaLQZdhYj+Vj8vm2fI0M831WoJl48bZtoUgzHltNKayDHr0jn8x9BtkHcwVvCvLHo4PL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bR2McSSu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FZypQkFm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bR2McSSu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FZypQkFm"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5348N6AR024704;
	Fri, 4 Apr 2025 10:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Kppq//BV4XwDzw7rDMBSfnBYURfkFgnricxnRxnqC8s=; b=
	bR2McSSu/eggXqbBrFPlf/6llbgUuUd4IqrbbtrYFKsgpav+U6s+ZIY6IuAaXd8p
	ljpUf+xlOZxo5Bn/97mU6sJzrp95HycTPagS5D7AXgOJKH6G6fF4ymFSncVupBuz
	/Go17UVSL+Eb/YlXAcUy6PoQVvbHnn7uo0Biy2m7mdyOxUmQCogCnh6K7Pd/rytC
	zty416ozS2yw26zFSq+e9QRz1cj2mOoyDgqjM5JA6rdDd5NxL6KEoJbOve+YcRv+
	be1fnY8OX/s4D6X6r/nmF+OQPdvAtoR1PYrNM0V2sZF7YF9L0b5o6zd2L1wethv2
	7wzX6T1Bh7Qbl9I8taIq+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8fsf4f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:15:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5347vnjg020775;
	Fri, 4 Apr 2025 10:15:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45t31wtwjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:15:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLNuDn2fH1fzO7YklG29pnOvvnvAvWtZcWEtUunZZHUyj1ONMncahbLD9OIQwKFVouWUaCiFIksaspxg8Pl+F3Xni8GB+ViOUGnSpr2cFICoAkOnBorltaR9HDWDR5yYP2QLPUc1MvxZwwLpotNcZrByXKApeRyqKjhvciHwZ+hJLG+HH0q0u2gkGMbKhKB1T+Agp3522RdMRpWJouqEKCpVwP7ZwNvWnZVV50OQyMPpYe61yOtRQsL+d+/tbyF5idp5wEGXX8w7nL9PTpHetkBFbO3qeGXcViWTiWYwIwRYJvWUZaE5/WITGaHKbB+YvURA3LyvdGGu+bxqzWLy9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kppq//BV4XwDzw7rDMBSfnBYURfkFgnricxnRxnqC8s=;
 b=v1y56n4zb6/D1csg/jAfvOui+4fTTToqnUiezT/KCcCIEeqyHCOAmlt/NxdfqhzoJ2dfJZlKLA5TTMY3R1lovT/GGyxkmtoPpb1ioHooe1CwwIzf9zm78hOwAA8+mrl7flCfXjHAAE510DJV+Aq73XMe6MiCcUc4QOCU0arrsi6jkd65W5twxh4ruBDpvVZxD8JrW+xv3JnYVEjahTbZhSSp37EtnbawIXHv1BvS10rszCrcq8UnZCfcnpSd+QCyOng8Ohu4LAqxid8WCSv8pPYtOoKICUAFa3klreBPvVt9Skwg+uLIBZnS864ySyPcWeJxqDrxFQt07NBT1ASKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kppq//BV4XwDzw7rDMBSfnBYURfkFgnricxnRxnqC8s=;
 b=FZypQkFmELCbpVjODc/5ucGx17WfHWCvesvQ5tmwDrlwv1b45rakzj9gSBHC0BISTgnvlW6UEPONAaLX+T+ztMK77nbkq1a0iFTeD+No0ADUmYmkKCEJDWZOKDK+Or81QpCPg9c7z/lcJ1JlvUdIeSWOWsWIqyeuPvzjiDK/3u4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7982.namprd10.prod.outlook.com (2603:10b6:408:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Fri, 4 Apr
 2025 10:15:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 10:15:36 +0000
Message-ID: <bcc48e7a-8d83-46dd-ad71-d7587d2b0434@oracle.com>
Date: Fri, 4 Apr 2025 11:15:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/24] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250403211937.2225615-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0115.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8170c5-dbb7-43e4-a974-08dd7361a496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bTV3ZjJ6Y09QMXkwaGJhOW5xbllrcFIxVEkxWkhEMmplYjZYUk50ZlVBakFU?=
 =?utf-8?B?TnJpMTNWcHlHLzhZT21kb1NCS3M3TkhCRzdWdkN3UjVrMFg0MnhQeXZFQWR1?=
 =?utf-8?B?VUxMZGhHWTN2b0wxUXQvN1h3dko3anU4cnZHU3ViV0lSVGdyUUFXSGxOUFNq?=
 =?utf-8?B?Rjc3SHdEUTJrVVVpRGo2NmdIQ0VtejQ0R1JjNE9JTUVkS2JrbkpncTN2V1Ro?=
 =?utf-8?B?L2JuaTlBNmxyVTA3dzZGNGEvaW9iVEFtU3JnS1A5TFpuWER4cE82OUY3Q3lp?=
 =?utf-8?B?KzZzQU0yR0Y0dGt1MzArSlRQVUpIQXNhc0E4eGovWVZZaUx4Nlc2MFBpQ3Rz?=
 =?utf-8?B?Ulh6blV6bzRVYmErWHlreWgwZnBHMkVub3FTMG5FQ1pVTGNlM2tRck5xektE?=
 =?utf-8?B?bEgzOTFzTXBvRTRHVVEzZno2OU9NY0UxeE1JdTRVQ2I0dVNhdWVGS1ozV3pB?=
 =?utf-8?B?dWxhb1hGVHYrT0ppakJ3NHoxMldvb1JLVFdocWRJUFJBNVpPNFJOMmE3V2lP?=
 =?utf-8?B?Z09JVW5mcUtXVVNaaUk2OFh4VmswRVZyVFZ1TlU4Sm1TZjRJL1VYaUYreU9p?=
 =?utf-8?B?QmgwZUtlemt6ZHB0bFFyenVvMTI2OE1rN2lESWZUMzluNUYrYXU4N1FycHdH?=
 =?utf-8?B?WUZNc1JYeTBwZ1NzWENqbzludjgrZEpURlZpODBQRnU1VGI0bE94b05wOU1X?=
 =?utf-8?B?SFllZkIrSlNwckRnTzNZZGtONU4zZkQwV1hWcldhUDFiOXd1cXczdFlPMmlW?=
 =?utf-8?B?VzZwaWZsVThoTm1HbEN5Vld2bUVJYithbFhqZGVTbGIzbnJUamF2RjEySGxu?=
 =?utf-8?B?VzhKaEUzYVNVOE0yYzZpUVJNc3RZYWcydmdqZkZjM2FLTkdablFqcjNRUzY3?=
 =?utf-8?B?b01uY2JtTDBhSHBEMk9ER090YlpWR0RrQWN1M0JxYm0wSVNUTTlkdlFNZHFr?=
 =?utf-8?B?dzl3UDBpek9RSllYZWhKck9mdEFyQlRwbVdmSnQ0cU8xUE5zTzM4blFXbE81?=
 =?utf-8?B?N2ZYd3hYdWVyTW1vVjlycXJLWStvUVo4OG1EamF6ZkJES0g5b0xqd0FzYm1S?=
 =?utf-8?B?T3VtMUg3WWV2TEFWdGRaNE9hUVZwR1lKWlQ5ajZ6WnZkSmtjcklFVVkrbEJl?=
 =?utf-8?B?LzFOYmEwMHUxWHNuV0wwR2cxSmkxS0JXWGo0cVFQejZyRktmaElTZzVsYTFw?=
 =?utf-8?B?Q2VTRFNIWWlxZi9DMExyODQzeXpPY1ZSVVhYYkJMVjlJd08xais4dlRqVkR4?=
 =?utf-8?B?cUV4SmFNQ01DK2J2TTFrWndYdXZGN3orVGFZWHVzbXgzV3ljRzVKYjZ6bjk2?=
 =?utf-8?B?SVJvYklVeUVrbEZEdnBnY0YwRXdiRlE1RVR3RkdadklYTkROcjZIQnJPYitM?=
 =?utf-8?B?VHd4Y3pDYzdkaG5ta01wUjdNdk8zbVNvTFl4Z29DN0UxamZFOTduWmcxQTYv?=
 =?utf-8?B?b0pDbi9MRUllTndDcmpENWt0VFgxbFNMbWVvd1VjVDZHcjlGSld5N21ydFlM?=
 =?utf-8?B?cWZkOTBLRGRlQkdtS2VjQjBrQXJ4OGVKOGkvNXIwekZ6dUlSeHFuRHBIcGhr?=
 =?utf-8?B?bDF1K25sOGJ0SkJONFR2cGVMNWdiaEQ4dmFIQUpsMW1GcGtNeDl5ZXloODdF?=
 =?utf-8?B?bWhMVEMzcS9VeGFVeGc0WjVrbnFzdXFKcWNSVlB5QWtOeE0wQUIzcklYczN1?=
 =?utf-8?B?VEZhOFI5L1Z1SzF6cUJoOXA3eVlJSGcxbUpKNXh5Y1VsQlVNRUc3V0l6ZW85?=
 =?utf-8?B?TWFCL3pnTEd5RjNZMWJSZkNnZ2VIdVVOZTErUFdjbGtOamZDMHFnTWEydWJz?=
 =?utf-8?B?akVmaktXZmdaUDZlUUs4bk44MlFzaHFteXBIdkd2WEFPQzQ5QVRrZlZFQUhR?=
 =?utf-8?Q?koTIbKwm0SrZI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkdtTmFqZ3FXVWduY0d4R2pQQ2Myc1pjSVhrd2lYRG9Sc2ZoN3FwSEJrbS8x?=
 =?utf-8?B?MGRmSGh0ZDJ0UkFSYzJmVFVwRk5taklBc3M2N2JTeUJTN1NMKzVsK3duWFc1?=
 =?utf-8?B?SGZ1eEVlT1VBMzdaMXhweFRoZnV2SXgySkp3OXgydUtjTldES0pDN0h2eHhq?=
 =?utf-8?B?VXBVUU5tQXZpOXdlbmFMOWd3NjJvcDB1Si9tc2gzakUvb3l3dXJEQ0hhUCs2?=
 =?utf-8?B?bHgzRDdJd3BlbUVzRm51NU1XWUZVdjdueVJ0bmVNbDM3cEUvUmFobUNvOWxS?=
 =?utf-8?B?L3pzZmQyMmc2SUoreTU3QVFSQU81Z3FLNVppN2h6SHQ1RnFDdHgydURUNVR5?=
 =?utf-8?B?K0FzRTR6VWVVaUk2WXNFRkZxc1BpRzdYd09IVGtkajhMYnVZajh0UUJKUkVB?=
 =?utf-8?B?d09ZYkZFMkp2U1BiWnJZTmc3Y0xQL1hEUVZjK3ZPeU9ka3U4V3NTZVUzMzhQ?=
 =?utf-8?B?WXRLeTlyL3NaTTRCTDlMZHp6dWZVTkdrMnQ4UWY4Y3VVL1NtcGxDWWROOGlM?=
 =?utf-8?B?dHhyUWl1cXVvVklabXprVXBJTVdFRG85Rk56Rm1HcHVkZS9ZYjM5Sk1lQ1U3?=
 =?utf-8?B?cWdHeDJHbi84K1FKS3NFTTFITGpCSExRbXRYQVNrcFYrcGVLRWk1cmI2NkdI?=
 =?utf-8?B?bDZIVkdQYU9zMm1ia0hKRzExZ0t5M0RnNThnc0J2Z1dNblRlN2JLUWc5YnRM?=
 =?utf-8?B?cEdKRGxXUlJ1emZZMmYrbktwWlgxYStaL1p4VWNRVGI4UzFGOUR1UUJaQXp4?=
 =?utf-8?B?Ni84cFp2M2ZLVjBKaUZtZVNXdSs1NGtYUnZiekRCMmZVMVpyeTlQN2haQ3Q4?=
 =?utf-8?B?bWNzajJXWThIQmVJL0xoMjh2bVFBL3J2enl6bzZmTWNWbWRSRHpEOHdMNHBn?=
 =?utf-8?B?MWtCS0Z6dFNQV09vSU50SEliVHUwcVRDWmlRTTJyTU1BNGowbkFrSXVSVEsy?=
 =?utf-8?B?ODlJVnkxWXVjMytWR25vWkYrY29rVmRzWHJydUlDM1JnK0FJd3UrOWtrWVFq?=
 =?utf-8?B?aXdvc0hTUjhaQU1NWi82ZC9iMTR6S3p3Uks5MXh2ZUZVOVFwWGxUNHdDZjda?=
 =?utf-8?B?VnplUklTOGVrTDlHTEtYZjFRN2QrWHNvWG9jcytSaU4yUW9wM1dqNVk5ZDZp?=
 =?utf-8?B?RzFlL1hmSEF4UEtlZUtUOUxVQ3hJU3RkWVRsbjhKUnY0b3NJVE5NWTVhMzg5?=
 =?utf-8?B?TUFqT2pjektYVzMyd3lRaDg4aXFKK1gwME02NFNUSmtOZ0FpK0VPTnRoTTUz?=
 =?utf-8?B?bGNKN3J0eFNseXovSzFnSlIxQ3VQTTRGN3ExRFd6MjE4SWRTK3drMFc0Nnlm?=
 =?utf-8?B?dEpRZzdQbFhOWFNDbms4cHo3RjVqV3VKdi8rRDd2NTN6cjc2NTg2L2l0NEw5?=
 =?utf-8?B?SlBGeHVRT0UvaDdYbzlrUG5ZdEpIWGRqSzBLWnBaOHJMWlRNTlZwd0FNeDlP?=
 =?utf-8?B?MERKeWF1M1E4Y0MvTmVvRGJLTFRZYkt4WUROdmRjVXo0bzNwVzVhVngzNmk2?=
 =?utf-8?B?b1ljZlZ0U1NyTWZIOUVrb2tZYktNVEQ4YUtYMWRicitoNU41cHR6am5RKzFq?=
 =?utf-8?B?UlcvK3JVb0x2L3p0TGNIMXJOdS9pWGhsaXRZd1lwbnRMR3U4UTArclhwWmF5?=
 =?utf-8?B?UUZibUl3K2RBTHpZaE5LMkVqTElaWHpsZW9nOWQ1MmVDRi9wWHNqSHhHTHhI?=
 =?utf-8?B?MnpvOUVPdzRXbUE1K1hKaDBGT2J0QW9BMEUrUDE4aGwzMjVQTER4V3krNTNX?=
 =?utf-8?B?TTZWZjNxaUdTU3U0TFFXWEpGM2tiYTVaZEhUQlB1ZVFNcXhxYXh4Q2IzeE8w?=
 =?utf-8?B?Y1p1aHNHY3ZheFFXdDd0K0V1ZktVMG1KYmJHaXJLc0VLVHVSYkdycEgvSEsy?=
 =?utf-8?B?ZFhnRWx4VE9UQ2NuTkVCa2JKYmtOL1QzT2UrYTZ6Q3kvNnhESHhQWHovM1J6?=
 =?utf-8?B?d1dVbkM3UmJsWUhnYkFqUFhRdEwwaDgwTkpJTUFrSkNoNzlHRUwwd09MUE8v?=
 =?utf-8?B?QWxnT3EwTjNESzhSWmR4UmFjbjkyUytpenNFaWxqTnVicHZDZWg0L1NDaHFo?=
 =?utf-8?B?aFFqYVVGOVQrZkNtbVc3Y0MvRzNzcFRFOXlTTm9KbU1wS1pRVVN0b0svRkpN?=
 =?utf-8?Q?4Dxb2RpBvxO5A+nPBAqFhaU2C?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jglWUkER4hZepi3KpJ50B0x1wFPwJ3KQTCkVDcZJCfi9WiKAMr3/hER7+n3Kwn22SqLJN/ez4bcc8GtlVQOrKNA9ZxUpYOZyDC4bpUFmdOXoaDQALh/pbh8m0hNG9NgzOB+FFMe5WX4FE1+Z+/S2EKxfT0q0ueh9bxgeAH3uc+ooJyvhbwQypFI30VOdTwMppAQNDPZ0GgEITh0T+/8A5XFM6QF1jgd5DWj5aECk5NL35/0hpNnyiXpeivxxyKZhdyvTeThSuUGK2+XGmawstyAMQwy74CxT/pPdpfS6Euj7ApXyeXr8PG/F4gEgcxsuNRGNi+MUEKOxAmwzgqE6o3Oca15WWmMeZ6sQhA2/HxD62j7PrLJQpg/2jz6AaZOMtqMEdfw2F5tJUFockfeJHwBVYzWjYh07RHx6lgxi7jt7tF8kmZYpluzRsvQ26dKksGj1m5imT6h+rZ9M7FoRSAmguHsE1TAytyvpt2mSpBuja1rVkgja2gdYzD7BLukebe/V9q/00F1VBEzzQ0VC1bbRfZKUr4yLVTtspoJAuwQB4cdz1LcdupahGwXQlOWjjuJdn7I5r9KnYtQIBs+dnCiNRHCVw0kKmGNOQBOaTzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8170c5-dbb7-43e4-a974-08dd7361a496
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 10:15:36.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMB23VlL2731EgrSiTZiHi42cdREvwqLP2olp3igjQrarlnss4XifgdvJG5t+o1yUVkwg4kKfTFGzLxMravxkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7982
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504040069
X-Proofpoint-ORIG-GUID: VuFM6_Ou3Whpf-HOt6wpceJn6etBE8ut
X-Proofpoint-GUID: VuFM6_Ou3Whpf-HOt6wpceJn6etBE8ut

On 03/04/2025 22:17, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series increases IOPS by 1% and reduces CPU per I/O by 10% on my
> UFS 4.0 test setup. Please consider this patch series for the next merge
> window.

That cover letter is a bit thin for something which now implements SCSI 
reserved command handling (in addition to any UFS optimisation).

> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (23):
>    scsi: core: Make scsi_cmd_to_rq() accept const arguments
>    scsi: core: Make scsi_cmd_priv() accept const arguments
>    scsi: core: Use scsi_cmd_priv() instead of open-coding it
>    scsi: core: Introduce scsi_host_update_can_queue()
>    scsi: ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace()
>      argument
>    scsi: ufs: core: Only call ufshcd_add_command_trace() for SCSI
>      commands
>    scsi: ufs: core: Change the type of one ufshcd_add_command_trace()
>      argument
>    scsi: ufs: core: Change the type of one ufshcd_send_command() argument
>    scsi: ufs: core: Only call ufshcd_should_inform_monitor() for SCSI
>      commands
>    scsi: ufs: core: Change the monitor function argument types
>    scsi: ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
>    scsi: ufs: core: Rework ufshcd_eh_device_reset_handler()
>    scsi: ufs: core: Cache the DMA buffer sizes
>    scsi: ufs: core: Add an argument to ufshcd_mcq_decide_queue_depth()
>    scsi: ufs: core: Add an argument to ufshcd_alloc_mcq()
>    scsi: ufs: core: Call ufshcd_mcq_init() once
>    scsi: ufs: core: Allocate the SCSI host earlier
>    scsi: ufs: core: Call ufshcd_init_lrb() later
>    scsi: ufs: core: Use hba->reserved_slot
>    scsi: ufs: core: Allocate the reserved slot as a reserved request
>    scsi: ufs: core: Do not clear driver-private command data
>    scsi: ufs: core: Optimize the hot path
>    scsi: ufs: core: Remove the ufshcd_lrb task_tag member
> 
> Hannes Reinecke (1):
>    scsi: core: Implement reserved command handling
> 
>   drivers/scsi/hosts.c             |   3 +
>   drivers/scsi/scsi.c              |  26 ++
>   drivers/scsi/scsi_lib.c          |   6 +-
>   drivers/scsi/scsi_logging.c      |  10 +-
>   drivers/ufs/core/ufs-mcq.c       |  31 +-
>   drivers/ufs/core/ufshcd-crypto.h |  18 +-
>   drivers/ufs/core/ufshcd-priv.h   |  27 +-
>   drivers/ufs/core/ufshcd.c        | 660 +++++++++++++++++--------------
>   include/scsi/scsi_cmnd.h         |  17 +-
>   include/scsi/scsi_host.h         |  24 +-
>   include/ufs/ufshcd.h             |  11 +-
>   11 files changed, 487 insertions(+), 346 deletions(-)
> 
> 

