Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F41B21BD
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759377262; cv=fail; b=eevPS3j5vxPJRblKXRlvmSk6oTq94qN2RpPejSA+V8LyjlDWAc4iWVegrdwWTqYCUFrDkCGSPnWpeKDZxoBq5B8TWE7a4SAN9Mx0BZtuKi2RVMp22DDyZta/3CEwDSwEQWiKTy/1SgpFn+fw87vDGudlxIZTdwWrJlr6sodRXsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759377262; c=relaxed/simple;
	bh=y9a2GyUUe9Uw/fiLb+U5LL+83jNdqyxlarQ1akBAB2c=;
	h=From:To:Subject:Date:Message-ID:References:Content-Type:
	 MIME-Version; b=r/F2xa8i1qarjkFaf8i8qGxZ9dxrjgGNXns3cziTiw7chj9IiyjKOPvkzd7B7BfZBV9W6ZYxYYxVwFOIc1EIs+I3O0x8lEKnP11blBj95Tiylc193/HYW94bqVtkBhqYeBLJwoKupMhW/jx17T4arqj93ZO/xxcefhZEjXXA55A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dblHJo3D; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dblHJo3D"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5921HIlS015274
	for <linux-scsi@vger.kernel.org>; Thu, 2 Oct 2025 03:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:references:subject:to; s=pp1; bh=y9a2Gy
	UUe9Uw/fiLb+U5LL+83jNdqyxlarQ1akBAB2c=; b=dblHJo3Dhe1ZkvC/StO8+f
	aFlCRpgoFmk8kWUFT4kEo2c9pduwjh8acZ0yQtuV8R/7Eq81oTEVfQmDjpUSh/DO
	qJkrEzAN2eSkO3rijzbtLCIn76kpKjUKedLlNomHJWD9RLfQGIsDHnQz7YjH8Vnf
	iEcgK2ffHRI/b+pZsDTWWWn147qr/lWUP/DyBVyxA4EO8FYUbd2LYYQZ1T7Gp+zv
	acX8CBGsXFiDmArxNwqCKsXGNyvCHvlXqCyD2B3On3OXgYHBeqGis7BEsTNn5jFO
	xIvXlBl7boHSKqp2qDltfi7QSMUrXTUPfM3FVkWGEAg/kuaaPIqy4cvhfQLILGDg
	==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7kukcuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 02 Oct 2025 03:54:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQLCa5+njipmxmc23urBaRLxGTBPUMJ1L7Gzq34QRtSHd31SqZGhlLCQPBLPngNmIMO2vSxbu181Xfb7O2Htw8rklOX7TCkb3HNkaMCV4gYUGQe3ZfuV6Xau5R22U4sRW05YtBtLQZuBG5Dj+Als13v0HS8TlTYmbcn467bF1mIuHVIcG66vrsg0HIKc4jy5Dce2geV4WqMAY3lXhAEQjJqax9CHQyiB3M1hp8wF1YD8qDoqzzBNPmnOxtUsJcKelcJTlUsHNvTHX+MFNss569KckFrlsKkzcYLcuZCZUxkzDIA3LCoJB61GiOUJE5HclhFFN2n57WTPJ7C7bXZ3jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9a2GyUUe9Uw/fiLb+U5LL+83jNdqyxlarQ1akBAB2c=;
 b=pdp+wmsWQEbPkzzpTwwmrKGfX6s4TDL8/9KBCYC8FB7rVEAV7oEiolrSmiHBj04VzWczREFrOJ4K+PsDN87ML/i2PSy72knpmKE4+iGABSr1B+5ckTnkMesctr/Iev3n0MMZhrx1WjPSDYhx4DIsZrshA5K1jSRu2RU73iEnwhkVNZHNZVpcfTlRqGrYpNHxVVGtpWJifFcYuAQwOny2eI6vu78FwANt0X8iCMVaOh5RW54VVoirUtTn1qr89u4zBpzmvDoosHkLafjlZ1KVHoS5l1ZDYsJZP0Hs2h3QE3xjkO1eccuVZsz1lfpHQtvkopWAwUOpwPCj8kc3rSFULg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from PH0PR15MB4559.namprd15.prod.outlook.com (2603:10b6:510:89::21)
 by MW3PR15MB3867.namprd15.prod.outlook.com (2603:10b6:303:45::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 2 Oct
 2025 03:54:12 +0000
Received: from PH0PR15MB4559.namprd15.prod.outlook.com
 ([fe80::671a:d7ef:aaf4:7bf2]) by PH0PR15MB4559.namprd15.prod.outlook.com
 ([fe80::671a:d7ef:aaf4:7bf2%7]) with mapi id 15.20.9160.014; Thu, 2 Oct 2025
 03:54:12 +0000
From: Mauricio de Jesus Cardenas Hernandez <mcardenas@ibm.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: SG driver duplicating requests
Thread-Topic: SG driver duplicating requests
Thread-Index: AQHcM00lSz6L/uL9skSo21+oNEU1Mw==
Date: Thu, 2 Oct 2025 03:54:12 +0000
Message-ID: <B5CCED31-E0A4-4F2A-B317-E8EE56F7430C@ibm.com>
References: <E7947463-9D29-494A-9044-460DD40CEA90@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB4559:EE_|MW3PR15MB3867:EE_
x-ms-office365-filtering-correlation-id: 676ab0cd-5bab-4ac4-47e6-08de01675919
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|42112799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bXNPWUZ2R2FSZ3NsSVVSTWdPTGZweWdWQkJ6ejJML0ZFR0NENnpVQS9LQUZM?=
 =?utf-8?B?L2dhVkt6OUM5cWZjSEtvbFNKVSs2Y25TRTJ2U3k3S2ZTSjRlejVFYUJGUm8y?=
 =?utf-8?B?Q1Y2YUxaWEp3d2g2YlFhVW9aWno4bk5TQXlrbDRPK2JTc2gwV2daQ0djZm4y?=
 =?utf-8?B?NVBMWndjT2FEekplNk9pMHZUbXhlcHF0UktsVjErUUxTbWZiQXZBK01XcXly?=
 =?utf-8?B?WURoZjAwMXNsSTB2NmIyOFZNVlF4TGpPRC9jcFVsQXdXTkFGdGU0NklDb3Y0?=
 =?utf-8?B?VFJDUi8vQ0FYb2E3b1NWQlBEN21MbjJrMEZxRHN6eTM0VWV6SmIxWkI0TFAw?=
 =?utf-8?B?QXZpQkV6L20xYllzU2QzZXlBWDRXK0JVWDdJNUl2VUErUUgzZ0FrQ3B4bGlH?=
 =?utf-8?B?UlNGb2Mvbmw3NlpyWEcyYVZaS3lTU1pxTU01UXJ5aFZMeHJibjFxYVJ4L2F6?=
 =?utf-8?B?amNIMjJ3bTVhVVI0UzRQaW9keThnR000ekREdzlwYi9zNzJVdW1NOUsxblFR?=
 =?utf-8?B?a2JOOVVzOUhvODB3d1dTQkg2T25LUnJKVE5DclBoZE0reG4zd2RQNjZaaFNw?=
 =?utf-8?B?SEM0Q1hxeERLZ0lLKzMwVGZROU1QeUkweFZ2L282ZkRjTUpJenhQbFBHMkcx?=
 =?utf-8?B?Y1pFME1GRk5rKzNPbFkvVzE2akVCMksxS3MwalcyQjV4OENSaDBhOEhINmth?=
 =?utf-8?B?WDVySEE4Z2VSUWUyaFBCUzViQ3NBNzRnWkh5dVZoMW93Y2ZxemduSVFySDEx?=
 =?utf-8?B?YWJYaUFjQjFMbjNkd0NiWWYwMk40S3JoM2hXTzcvRG1DdGJNMjYxaXNWcTJJ?=
 =?utf-8?B?SjdtcGFiZTZYUDFiNGNyb3MzejROcGFKSzRaTjRRdURLQ2NRaGdiQlc0dHZJ?=
 =?utf-8?B?UDVCVkl3Z0hzOWJxR0l3Rm9wTWlkeXNKeFV3cENwbnIxQUR1U2c5MmVHejQ0?=
 =?utf-8?B?akxza1RCdzVZY0FNc2U4WmE2andOWXU3Y1hCbGVKNWkvb3hDdHdFU1ZENEVi?=
 =?utf-8?B?dG1jRWl4TGR3OXQ5T3huOHErdVpKQm5PYlhrVGEzWGliR1p0aWlxTWFrdDF0?=
 =?utf-8?B?VHBNTCtuZ3EyMG00VDlVMy9jY0F5dU5ZV2Z3VW0vTUJYdjkwVG5vajRkeEpE?=
 =?utf-8?B?Q0lxYUw0cFpwcVpxT3NyUGFPZXNxRWpCellhejJIUkVLZjVKb0pabFN2Mkpt?=
 =?utf-8?B?aTM5WGlFcTlTZmUrU0ZKUDU0TlVOamFjR2g1eXFrd2xTTlI5aVZxWEJZWk9V?=
 =?utf-8?B?SXVJajA1ekNHdmI0c3lFcVUwRUk3S3U0bDg3eXVXQ2psa0piTjZkRVFpTGRX?=
 =?utf-8?B?ZE45ejcxZGZVWmwzRUY1Yk1LYUJnWmNQNFFRSXZ6WGdSL2tUQmVUT1Nybm5R?=
 =?utf-8?B?aDlFd2lzZnQzcXB0YWpHbzFheUw0L1JiNHNrcGhRb2ZIY0R5TjllZ20xMldy?=
 =?utf-8?B?djhrUHo3ODZJZ2s5Ukg0U0ZDR0VMNmpyd3oyWnNiL21OZzRXTG82eWtiYlF2?=
 =?utf-8?B?ZzNZblRMUTdINE42WXI3ZEdDa29wQ0ppdkNwcWk1dFNvWjEyRFdaejZ6bFFv?=
 =?utf-8?B?SGFKYjIzOERSMVlZcDlYSU5kYTJDRVpnb1FlQXFOV2h3NzhNUDQyM3BRR0hw?=
 =?utf-8?B?Vk9yTnQ1ZStkSXhidjIvdU8wR0tZcUFUWDk5bEI4Ump3eUJZNTNtWXpxbjRx?=
 =?utf-8?B?TEVLUUYwaWJxMi9rYnlGbEovRENUOWwvaEl1R0tlMnF0cnprTzVqdWVRaEFN?=
 =?utf-8?B?QVNEZkNQVVdFUlE5V0huUk9lUTBsZ3ZOSUtHVEM1a2FiM2VxWWlSZUpYOXJv?=
 =?utf-8?B?YjEvUHdVRzVnelBhbVprODlJRkQ2elAySjJQYmd1c1MyYWI3dEloZmlQZWZt?=
 =?utf-8?B?dzMwUjYxRHpaL0FBcDRsUXhBN1g2Y2lQb282V0J6d3hBNmhwM3IxdWJIMzNO?=
 =?utf-8?B?dThyWTljVDJKcTZndXN0VzVMTHpYUjUyVGVPNVZEYTQ3aHM4YUQvenBRYnRC?=
 =?utf-8?B?ODZROFh0L2pSaUoyRHpWVzlmVFZmbm92S3lkWm54TUdhNk9PWTN1aDFJazJS?=
 =?utf-8?Q?HVJPMV?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4559.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(42112799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aXFJRWRIRlR3K1U3QXZhZEN0QjFETUhDbldYdW1nUUxxa1JkRW0zcFU1dVpF?=
 =?utf-8?B?b3M4NGM0djBQVHRPKzNRUjVYeDZhUktLVXdQNXR0MnV3Z0Eyb2JjaS9PSFNR?=
 =?utf-8?B?V3dDVHJaOXMxUTFSM0ZvQjhPTXNSTmdHNlNLNWJSaytYWFdGNDhSTzJMRVg2?=
 =?utf-8?B?b0drcnhFaFRYZmV6UzdocmU1S2RMRWk1UTBXQVpqZDVhcllXQkNzSkRCZ0Ev?=
 =?utf-8?B?RVg0MitqMDRvRDZlZ0ZsQUZTZEtjOHdOWFB4MmtDYi8vYjRtdTgrRktvbGc1?=
 =?utf-8?B?T0lPOU5TSVZUb0pib2ZnTEVrK1diZ2hkMjZUSUJzckJJdzV3WFc4b3M1eTYx?=
 =?utf-8?B?UkpEak40ZUxmL2xTUFVpUE5CTFlnYUVQWmhuTlFiTmU1QU53aUk0dEN5Uk5j?=
 =?utf-8?B?Q01yTmM2bWlOWEpNMkl3VWxZOVRyaFNnNlpOZHl3RzVLTnBIWVQyc1JLZVpY?=
 =?utf-8?B?RVJpbURPMVlicXhwLzJuQVN6aDBaSTBlTTZSb0FTMjlUd3FJOEVTci94MWd1?=
 =?utf-8?B?cnZYWlc0dG8xQWVOUllWNkMxb2NWcysvQXo5ckJZaEtIMlgwMGgvY3JJenRq?=
 =?utf-8?B?cWVhOGtvMlRqSzg0OGRsaExpSzJhNUxWOC9Pd2JGMVIxbmdOK2hEdktiVEFQ?=
 =?utf-8?B?dFJiSHhiSVVMYzZUTjN3M1I3cEJDU1ZvYUJsam5QMFAzR2UvL0w0MWROREgz?=
 =?utf-8?B?OUtTNUsxUkJuK3lFaVRpejdDVmdDTG5SQ3NRQmxjemtDT1NTalVRQkdTekR4?=
 =?utf-8?B?YzhBbUFKN3Q4R0t2MmdiL1VQay9RMmRFdE1DcnVTbFYxNHJZbmFNTmwvVEsz?=
 =?utf-8?B?UnRkYVNBZDBBRlhIemhkQ2xxREppSnVVTnVERFJLZEh2a1BDSDAxOEdzMGNT?=
 =?utf-8?B?V2JsL0NQcEJDZmo5d0hTc2hRSFloY1Q3YUcrT1hQWDRNbVUrWXdQY2NsWFA4?=
 =?utf-8?B?dVhRMjBTOFZINW1NV3V6cVJUWUdjdG9wS0V4SkJDbVdWSzZZZXMrd2t4TVRw?=
 =?utf-8?B?MUM2N2VDTytyYk0vak1iZG1YS1J3YnRrUU5seisrNGVWWmhkU0xkbFRrVSt1?=
 =?utf-8?B?NkpDVnpaeWpyMFcveVNvZkN4NmU2ZmJIYzJ0N2kzUTdrZHNVdExlS1FVSGVj?=
 =?utf-8?B?emxNOGpwVjNHTVBSdjJNTlRpbmlRWUw5NnY5a1JTaGJnRW0xQXkzbVJuMkNC?=
 =?utf-8?B?akFsZHpPUnVVWlVNVUFZdWlBbktiMVM3ZWVGbjlBV2F5dXpxVzdWV09PRVNr?=
 =?utf-8?B?aFUyUVlxVkdaUlBYWG1EY1VWQVVrMnk2RlhuZFp1MTV3cTZJYkZ6OXloVEFy?=
 =?utf-8?B?eE9nblhPNVdoaDJueXFsS3RleDA1eFRScjBhdkxpWHg4bFJvUzAycld2QWdN?=
 =?utf-8?B?c052VGNmdjVDS2hKMGxOVm9YL0s1dDdqVjEzcHhFZFZuSzdtTmhITjRQZnl1?=
 =?utf-8?B?THliZzkzQWMvTU4ySlZOdWE5TG9aMitkamlseFl1Zk1GdnZKQzBVbEF2Y3hD?=
 =?utf-8?B?bXZZMWlYSGpzY2QwblRDcmVYWUZKVXBBNEZVdFl4c0dwdHlrelJNc0pocXlN?=
 =?utf-8?B?K29LS0FnU2tZY0pWS0VYajNaM012TXJEKzg5d3FyQ3N3azRSNExaWVJ5T2FS?=
 =?utf-8?B?R1RLV2Mva01PdVFvSnRRQ09KTDU5UCtQZDhFS3NPZHhqOStnbnIzdkFvRlNC?=
 =?utf-8?B?ZFVLMjZ0TUdIaC9rMU0vS1BqcnBpY0d2NFZmK0F2WWpsMXkxYmE5aTJIT0tU?=
 =?utf-8?B?Vkc3TDhmbnpWNitJdkZhUk5SbmFlSUJmOTBQYXIvWFdGZm5LZ2l1dmxONHEr?=
 =?utf-8?B?WmtoQkNxRVhKME1qKzZnM1BObDIvSkZleXBXTTdkNnNCNGhYZG02ZWs1NXc3?=
 =?utf-8?B?dkR2amI5ai9nS3NnNFMzYWYzTTY1bnBqQjFxbjNxTUJ1RlFkakxQZWZmSkpD?=
 =?utf-8?B?WWZmQ01FS2lvNFNTSCtEbWtNeUl3dFhlcHp2T1l2alo3MzN3S3R2ai8vTGpn?=
 =?utf-8?B?TG1MNzB1SnoxdFR4QzM3Zy9xYTBJYkZCOVp5TFVYc2VBYzBaMklhckFueko4?=
 =?utf-8?B?blZKWU81c2RZUU1qeW4xUHVlWmJZMVlaYjgzeEcvRXd6aktRT2kxQ0t6eFB2?=
 =?utf-8?B?K3Nlb0ZTT1l0cjVFZ3M3U1ZtSDBMMll4RUpSZ2tybkVWdyttRFMydmI0aHM2?=
 =?utf-8?Q?TrAP1sYiNUmsLpaH6oLWNpqdruUeC3TFHLBQJHW76EnP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2FEAF65E5D66845A05F6EC80B476066@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4559.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676ab0cd-5bab-4ac4-47e6-08de01675919
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 03:54:12.1079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxEa6I5vK7WuPR4ED7xL0SbaE1FO/bkMnMD08VhxYHTd5WQigUEBQsrjJZ1LVNU9iWZj6wh77aoZli0dVXkTgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3867
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68ddf76b cx=c_pps
 a=YvmT30J82QCmV9938MlLOg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=T9qOBtu3aiRP-2UO80sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: IekRYPrnXCYzQIqLXgPE5diuqueXdbIv
X-Proofpoint-ORIG-GUID: IekRYPrnXCYzQIqLXgPE5diuqueXdbIv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfXxHuLYoz+1omg
 1edRZGd5lzS+cveWdAe1ycZP+st+irKiTdn2oD5H6+wtUnSpOO4FqHuBe2vGCz9rQER8GcBDJbi
 My58SvOnj4IK758pKXjD3rLe0g7bY7lx3crsWK6drvZs1UM1yn/azPd8zwo5Fg1pBTLK2fuHspa
 qjeA1TNeNjZBMkPATrH/LhDmNFjIfuGE6hKzPJVvzVTSY5bRsL8ScxM+rMeM6gGMRVb15IfYYEk
 ja+jwBgOzpF57aYhQPTNTMgtyRsvS7qnnV23OtptOV9DMSD8ZotV0kR6V5rFmCgvjNOhxwL0J88
 2HeuIg92XwFBQpHR6h0ilo9FgUqM7y90gTaoW3pbabae7ULyFNvvU6rans8Bzr0LsxYNgRbXRUG
 45lTWFPjwjAjq9jziKRTFcqYoQ4Kkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_02,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

SGVsbG8gZXZlcnlvbmUuIA0KSeKAmW0gc29ycnkgaWYgdGhpcyBpcyBub3QgdGhlIHdheSB0byB0
YWxrIGFib3V0IHRoZXNlIGlzc3VlcyBidXQgSeKAmW0gbmV3IHRvIGFsbCBvZiB0aGlzLg0KDQpX
aGVuIHNlbmRpbmcgYSB3cml0ZSByZXF1ZXN0IGludG8gYSBzZyBkZXZpY2UgaXQgc2VlbXMgdGhh
dCBhIHJlcXVlc3QgaXMgZHVwbGljYXRlZC4gU3BlY2lmaWNhbGx5IHN0b3BwaW5nIHRoZSBwcm9n
cmFtIG9uIHdyaXRlIGFuZCB0aGVuIGNvbnRpbnVpbmcuIEluIGEgcmVhbCBjYXNlIHNjZW5hcmlv
IHRoaXMgaXMgaGFwcGVuaW5nIHdpdGggc3lzdGVtLXRhcC4gSSBoYXZlbid0IHJlcGxpY2F0ZWQg
dGhpcyBwcm9ibGVtIHVzaW5nIHN5c3RlbS10YXAgYnV0IGl0IHNlZW1zIHRoYXQgaXQgc2VuZHMg
YSBTSUdTVE9QIHNpZ25hbCB0byB0aGUgcHJvY2VzcyBhbmQgdGhlbiBpdCBjb250aW51ZXMuDQoN
CkluZGVwZW5kZW50bHkgb2Ygc3lzdGVtLXRhcCwgSSBtYWRlIHRoaXMgY29kZSB0aGF0IGFsc28g
c2hvd3MgdGhpcyBiZWhhdmlvcjoNCg0KaW50IHRhcGVfd3JpdGUoc2l6ZV90IGNvdW50LCB1aW50
OF90KiBkYXRhKSB7DQogIHNnX2lvX2hkcl90IHJlcXVlc3QgPSB7MH07DQogIHVpbnQ4X3Qgc2Jb
MzJdID0gezB9Ow0KICB1aW50OF90IGNkYls2XSA9IHswfTsNCiAgY2RiWzBdID0gMHgwYTsgIC8v
IFdyaXRlDQogIGNkYlsyXSA9IChjb3VudCA+PiAxNikgJiAweGZmOw0KICBjZGJbM10gPSAoY291
bnQgPj4gOCkgJiAweGZmOw0KICBjZGJbNF0gPSBjb3VudCAmIDB4ZmY7DQoNCiAgbWVtc2V0KCZy
ZXF1ZXN0LCAwLCBzaXplb2YocmVxdWVzdCkpOw0KICByZXF1ZXN0LmR4ZmVyX2RpcmVjdGlvbiA9
IFNHX0RYRkVSX1RPX0RFVjsNCiAgcmVxdWVzdC5jbWRwID0gY2RiOw0KICByZXF1ZXN0LmNtZF9s
ZW4gPSBzaXplb2YoY2RiKTsNCiAgcmVxdWVzdC5pbnRlcmZhY2VfaWQgPSAnUyc7DQogIHJlcXVl
c3QubXhfc2JfbGVuID0gc2l6ZW9mKHNiKTsNCiAgcmVxdWVzdC5zYnAgPSBzYjsNCiAgcmVxdWVz
dC5keGZlcnAgPSBkYXRhOw0KICByZXF1ZXN0LmR4ZmVyX2xlbiA9IGNvdW50Ow0KDQogIGlmIChp
b2N0bChmZCwgU0dfSU8sICZyZXF1ZXN0KSA8IDApIHsNCiAgICByZXR1cm4gZXJybm87DQogIH0N
Cg0KICBpZiAocmVxdWVzdC5tYXNrZWRfc3RhdHVzICE9IDApIHsNCiAgICAvLyBwcmludF9zZW5z
ZV9idWZmZXIoc2IpOw0KICAgIHJldHVybiAxOw0KICB9DQoNCiAgcmV0dXJuIDA7DQp9DQoNCuKA
pg0KDQovLyBUaGlzIGlzIHJ1bm5pbmcgb24gbWFpbiBhZnRlciB1bml0IGlzIHJlYWR5IGFuZCBz
ZXQgdGhlIHBvc2l0aW9uIHRvIDANCmZvciAoaW50IGkgPSAwOyBpIDwgMTAwMDA7IGkrKykgew0K
ICBjaGFyIGMgPSAoaSAlIDI2KSArIDY1Ow0KICBpZiAodGFwZV93cml0ZSgxLCAodWludDhfdCop
JmMpICE9IDApIHsNCiAgICBwcmludGYoIkZhaWxlZCB0byB3cml0ZSB0byB0YXBlIGRyaXZlXG4i
KTsNCiAgICByZXR1cm4gMTsNCiAgfQ0KfQ0KDQoNCklmIEkgcmFuIHRoaXMgYW5kIFNJR1NUT1Ag
aXQgdXNpbmcgdGhpcyBmb2xsb3dpbmcgc2NyaXB0Og0KDQouL3Byb2dyYW0gJg0KUElEPSQhDQpz
bGVlcCAwLjQNCmtpbGwgLVNJR1NUT1AgJFBJRA0Kc2xlZXAgMQ0Ka2lsbCAtU0lHQ09OVCAkUElE
DQp3YWl0IA0KDQpJdCB3aWxsIHJhbiBzdWNjZXNzZnVsbHkgYnV0IGEgYmxvY2sgb24gdGFwZSB3
aWxsIGJlIHJlcGxpY2F0ZWQ6DQoNCkRhdGEgb24gdGFwZToNCkFCQ0RFRkdISUpLTE1OT1BRUlNU
VVZXWFla4oCmDQpBQkNERUVGR0hJSktMTU5PUFFSU1RVVldYWVoNCuKApkFCQ0RFRkdISUpLTE1O
T1BRUlNUVVZXWFlaLi4uDQoNCkFzIHlvdSBjYW4gc2VlIHRoZSBibG9jayB0aGF0IGNvbnRhaW5z
IHRoZSBFIGlzIGR1cGxpY2F0ZWQuDQpJIGRvbuKAmXQga25vdyBpZiB0aGlzIGlzIGFuIGlzc3Vl
IHJlZ2FyZGluZyB0aGUgc2cgZHJpdmVyIG9yIHRoZSBrZXJuZWwuDQpDYW4gc29tZWJvZHkgcG9p
bnQgdG8gbWUgd2hhdCBpcyBnb2luZyBvbiBoZXJlPyBJdCBzZWVtcyB0aGF0IGlzIGhhcHBlbmlu
ZyBhIGxvdCBvbiBhIElCTeKAmXMgcHJvZHVjdCB0aGF0IGl04oCZcyB1c2luZyB0aGlzIGRyaXZl
ci4gDQoNClRoYW5rcyBmb3IgeW91ciB0aW1lLiANCkJlc3QgcmVnYXJkcy4NCk1hdXJpY2lvIENh
cmRlbmFzDQoNCiANCg0K
