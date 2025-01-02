Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F601DDC1
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 22:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858313; cv=fail; b=UeTX986TAf9NV1QoR5w10xpd77zu8DjQn28+oVEo3AjUDjm7o5JX4DORzi4FUOJdGawLior1rbwXstkCpqonyBKomUG/MhSnBzF0fM41Nd771TrT5JXfISmvZsv/NEvtAsvLnCrc2pE9WUSoaMxBka/q/HMkL6Z/o0CImoVWxdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858313; c=relaxed/simple;
	bh=b+ErKCKHsz2yfj2u3o2S/rgQEnGOL87B2/ziFG1v9T0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fUMdQlYe+rGc+5ahYnBBnCvtd+i4Cr6p+BSVfBFWpw9oHgjWo1qk7VSsO8Nylo90KhE6zeIY5kvvpSsZiiTaXUOhir/PFeqA5PBsZBfipSufp2bxrJCuPpjAZb312RauUOD+aD11ESfWDhFFfqA2/iHOA5H1u3v/mrXUxfx1tZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hl1QY+Hx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HXc60n9b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hl1QY+Hx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HXc60n9b"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KfrCL011698;
	Thu, 2 Jan 2025 22:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6J4YBOsimCvN2WC3+jwU+kTaqqnHlsJoAyht/Ng2TwI=; b=
	hl1QY+Hxd0Q6ufeWnQwFgE+jpLhJk5obql9Ntr0i4h7aMbbO5v31zYytW5DdiEfF
	BGKtvvUMazvC1n1kJVuZ/vCn5LmnCQs93CGWKUiS5cyxN0fKTSeWe61WZCSDHenX
	zFanK1KmlRRaAR3Qi0EcLJ4DiOTlL+MO87IUDutX+ZXxQ5Y7XOaU9IFwtmghEwL8
	anobiQFWj/WP9vimDy/qizVLS7vipSdW8R9XcnBi/lYYYbB0Xw+JOOh9viGbEL+G
	uPTn+1geM5f70yAQVe7pNfuTAWrgObKtTVU2L7I/pfePQugW1In0G6yb/PtEpzAC
	KrXvPRECTuTFxzO326uCMA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t841ycgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:51:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502LJUjc027845;
	Thu, 2 Jan 2025 22:51:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry25vra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:51:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doHEaIWmKEnjCkbK8f5WzdYX7jLsvOdTZ1LzV2AZOC78w4lWHtgaTao+pNeGIMAKQHxX5ikrQIl24LOE1eKkRX6OkPJIz3xkZH+/6qJuTXqH607PuMAgM5RMK/qw8NVnqxvEY6bPrevtsqNnIaaYY/PhGgQPrqcpTL7RaEghjkJN3tWSFkEBpH/pnE5ReI9I1GUBdh6ylwSRE16UxdwIqw5UFY6h8Xdi0wNNHDOPHCUDZHeqSfCdJUsTH8qefxbaSzDem7m8EXyeFv88mL5VMVLGMNtEeE7FAl/PNXk2qncyeCLjIzxucQ/KKu3XQMkZUpoG7fUB+OFrpA90Ij9JeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6J4YBOsimCvN2WC3+jwU+kTaqqnHlsJoAyht/Ng2TwI=;
 b=LSoGWaVJYo1/sslm847DPoUDrrTgMH431Kv71RYuVY/Pqr37Hh2vUlvL46R69IIYZyc4TNRoa9eH4tewz9fJQ6DYi7iUdiyAXk9NLndF9Dr75cqBdac5LrOwc47C2X/dfYAJ47/cT3kTcyX6dlqxLIm313VZITPDvvZem4zYgQB1Xu+Oy9GfCGbLgGBn/J70Om+kM/ti45wZn5MOrmeGGQxBU3NgxQ9zFFwecf2tBFrW/IrVQXfhN8TU7a0CcBFccmiVrjFrIBKfFgEfAGNbxzzVC1W9UQ8bdsAuFcUszXFZMpEd8q1joKdI+57gsZE6xNtaJgKrC7WuqZ9BdT8kYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6J4YBOsimCvN2WC3+jwU+kTaqqnHlsJoAyht/Ng2TwI=;
 b=HXc60n9bjosU0lBDKK2PTWQRYRrfixaR3CL7SkwBNSNMJJ8BM5hpggK8TWKMmgFXRhY9dZHQLf3C9Y55qpTQAA1tgXkouFSzghBs2TkgWvlNjveUCc6yFgOJ5DFBBnM4f72JGJQ3hIDB/Z76bXPCfZEEk/MBqo0vW+NnEO31kjM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB7404.namprd10.prod.outlook.com (2603:10b6:8:180::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.18; Thu, 2 Jan
 2025 22:51:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 22:51:37 +0000
To: "Ariel Otilibili-Anieli" <Ariel.Otilibili-Anieli@eurecom.fr>
Cc: Martin K. Petersen <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Hannes Reinecke" <hare@kernel.org>,
        James
 E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] drivers/scsi: remove dead code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <2f7a87-67770480-d1b1-141f3260@133486995> (Ariel
	Otilibili-Anieli's message of "Thu, 02 Jan 2025 22:25:58 +0100")
Organization: Oracle Corporation
Message-ID: <yq1jzbcde3v.fsf@ca-mkp.ca.oracle.com>
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
	<20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
	<yq1ed1lf3z1.fsf@ca-mkp.ca.oracle.com>
	<2f7a87-67770480-d1b1-141f3260@133486995>
Date: Thu, 02 Jan 2025 17:51:33 -0500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0158.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB7404:EE_
X-MS-Office365-Filtering-Correlation-Id: ee0567a0-6643-479e-4b53-08dd2b80035e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjJpQnFQVy9wTmp4NnM1UVQ0azBIa2FxYjREeDVwYlBzQVhzcDMxMExJdmZC?=
 =?utf-8?B?WXpoZmMvZUlaNmpTNHJLTWlyYWh1M1hWazFzQlFGQmE5VzdVNU5UMFdtbDFQ?=
 =?utf-8?B?VnNNdGJqeDJBTWJBL2llMm1nRlRlMEtTYklOQmVxeXBHWmpHKy9mSG84aWli?=
 =?utf-8?B?WDN5NGZaUXovdkl4OGlpY0lJKy9PN2hCVXhSNUVPZlY1ZmFnNzZESXZuaXZ6?=
 =?utf-8?B?SEtFR2ViaVl4T3ZwOHZ3OWpFSVphUTVNaDNCc1lJNjRGSDh6YTZGblBhSjQr?=
 =?utf-8?B?OTJoaGRpTHdZZUpRaHptampZVUl5YU5ydGxKTXB4SlByazhYTy9xYVp2d1NX?=
 =?utf-8?B?YmZheTR1Nm9jK3BDN282ZDlraW91R0dEMHhXR3RkOFFxRld0Ty9ZRG1YY1Fy?=
 =?utf-8?B?dGNCSG0wUEdOWjVkdTZuSW9mbFdKTUEvcTZpbEJuUnppMVZiS0hPOURvM0I5?=
 =?utf-8?B?MUhQRndiamFhaDRTaFdDaHIyekVmbjBBMDJ5M3JHNmhHaDBTbW1uM1o2YjRR?=
 =?utf-8?B?NVZFSldQZS83QXVCNVZIRjBycmRsZ0ZGZGFHNzNPSnhvZ21FY2lFUlhsU0hI?=
 =?utf-8?B?SHA2UTFJRDZsdDBURlVKNDZJbDhYMXhIWTRkdjJrTk5xeTgxOU5xelVKRmt0?=
 =?utf-8?B?dWxYNkRvZHd2TEcxTWRaOTd4eUU4OWJpNEdoZW8vNXBGK2xpUk9jdmR4TGxk?=
 =?utf-8?B?Qmx6NkxUYTBJN0ZQVnlBVHArZ09WUk0xcXdXTjlDNE9keUNNRDVtUnVnREQ5?=
 =?utf-8?B?RHNHQ3hwWHRWcTRRandGNkZtR3F2M1NOKzg0d2lJRU92bHBqdzJIVnFqUUdM?=
 =?utf-8?B?RXl2WnBJNGx2OFQyM1U1YmpHQ2FjVWsxWjR4OSsxMzQ5ODFXbkx5dGRocE1t?=
 =?utf-8?B?VHVvTnJDZlNzYzF0Qm9kSXdTN2VtRHVwNzlhYVRvbWxrQ1N5L0xiTi96b2pM?=
 =?utf-8?B?dlI0dlNYbTdzVk5IT0pYeXcyN3RzZWFjcHRIcTZjNlNFL0dEZVVKbUIwRlZP?=
 =?utf-8?B?dDRMVmhNRkNWNTY3Y0NQMUh1Uk9QdVBucTVBZ3hId3BoQ216NVdEZEUwTVFL?=
 =?utf-8?B?L2dadFIrWktXaWExbkpMZFJaYklZV3dyZXE3QWI4aG1id2pOMW5WaUVFa21G?=
 =?utf-8?B?YnlhWmVMRzdqKzN0cjVwU05jWTZiVTZpY3QvOTBnSWFWazNMUnhPTHk5VWNS?=
 =?utf-8?B?UHpYVVRycDJYR1ZQWWxkc2JKM09zQnVGd2VpNmlzR2xjUGYyUlh2a0ZvMmln?=
 =?utf-8?B?WWdoWUVxNjhtNC9ORDBDWVRDbDI1Q2VEMjZLc2xuU1Z4YkM1cTdWK3F1bmtj?=
 =?utf-8?B?TlBsL1c4ZC9XRVJrVkliVm54T3oxb1NvNDlSZlg0cTR6K0Y5djNFcDNCaFVB?=
 =?utf-8?B?MFdGZGRWNGdKMyt1MG9MN0ZGc25INXR1emxFc0hVQWxLNjM4Ykk0YWUzejkx?=
 =?utf-8?B?aXRoUGJzelNQQXpTajY3cndydy8zczNNQkFoUHZEMzB0NnliZFpQd1E0ckVX?=
 =?utf-8?B?VXdtUTVnSkhjaHdyNFMrY0xrL0lIdmtwc0RZdml1aENRNmFxeVVmNnFteDk4?=
 =?utf-8?B?ZWtFZDJ1UVQzZTVKR1dTQWF1YUwvUWp0ejExakZEMEFyamxyaXhZTWszc2V6?=
 =?utf-8?B?Snc3a1Z4Rms2TGs3NnlIWnZKMm5kbWZwMkpJY2lJUUFYY1d6d2J2WGlTZFZS?=
 =?utf-8?B?MlVuSzl1Q1d6U2w2VnFjdi9BbkVBRFMwNDAzOVdlcDFibUh0UnhFTHpLTkZx?=
 =?utf-8?B?UzNJQXlncEx2L1pkTTlpbkRjSFNISzNKbktLQzhXR3kvaFY0QTN0MkY0WWVH?=
 =?utf-8?B?T1NnVGplWlp4NkJ1alVwdFZGRjhyYWxOQ1d5SzBaWXQ2RDl1d2ljY0ViSWRP?=
 =?utf-8?Q?mJ7SNtjKQeSc2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVQxNytSQUpvb3kxRE4zZTdLdU9sU0pxcGg3V3l2TTJieU1EM1NhdC9vMEJD?=
 =?utf-8?B?Wi81NkFOT2RVTkdrYXc5dnhZSS9sejhwRkVlSy93R3RDckJKNDB3RWRPSTFI?=
 =?utf-8?B?d09rZlQza3hRKzU0UFYzSUhsOTV6eGQ1Q0pWaGkzNG4rTEluZktCOERkV0VZ?=
 =?utf-8?B?M1JTTlg4RDBGYkFnQmFtaUpEbXBxQW9qam1vYUloTzFhLzkyMXFrQTRhQlM4?=
 =?utf-8?B?RUdpeVNwaTZMY1FMWjRlNm5VOTFqYXZIN0VEQkFCeENOUXlmYTB4NHg5RVRW?=
 =?utf-8?B?YkZEa0dEdUg1ZzZpWWtQTEhjMlN6Wno3bTlQMU9oVXVGN2pvMzYwakVscXlu?=
 =?utf-8?B?L2s5d2JFSHJrZXZRRDlBcHlLYVQ2QUpad1NxMWd2TGdYZFQ1YlVOdEcxSXh4?=
 =?utf-8?B?NmpmTDVPWEtBWWxyaE9iZUxWZDBYdittWnEwa1ZobVJZTmRIdlFkLzRpR0FH?=
 =?utf-8?B?ZTVuT0c3VDhkS05vWmlPQWF3aG9IaEdVcExTb2RsSFZqZkdEcGNYU1AxdHhW?=
 =?utf-8?B?YUJ6cGV1MXVGK0w5a2MyOTcwbTBVMUlQWEhrMEV1SUNwRzE2cmN4eGRqUTIv?=
 =?utf-8?B?Wko1NnBzdDZwUU5XamlmOFlBQXRlMFFONGQ5S1JQenNCRGtHVDZxYjhUcDJL?=
 =?utf-8?B?L1QzS1pDMVVxcmR5UUErbXdpMnAwSnJWa0xKblU3Q2lVcFNiUUxMS2ZzKzg4?=
 =?utf-8?B?WUtLWFdPUDh3aFlpeGxWbG13YVhicXh0MmF3M1BDcHoxL2xPM2UzaFhFOTNy?=
 =?utf-8?B?MTRrdURCL3VjSHBIUmhiZmxzalAyd0lBbXF0R3YvZHhGUEJOTGhCd01XNWdq?=
 =?utf-8?B?QTJYbmlLMm9QUGdSMkJMMzBwN2x6YWxCQjBHb2dlelRVSlZOUE9NY3Z6RHhE?=
 =?utf-8?B?Y3hzTWlhVGpRd0d0OVVRRGRnek5iSG9tbzZGMHY1dFNxdG02Y2hEc2h3ckph?=
 =?utf-8?B?NkF2NXZLWEV2M3FKWlJLeGRHdjlycTdqMEl6bHJncmp5YmUrVldwYmRGTnBH?=
 =?utf-8?B?dlJ5UzgxSzRkMFM5NFhySGN4bzhyRW9lcnkrNzZVT1B1R1dwdWpXZVF3Q1hz?=
 =?utf-8?B?cklHa1U1UlVtS0FJeExIZ2htTlU0WSsrYmhKR0xuOGlFUWNrQTRLd3NQcm5T?=
 =?utf-8?B?N210NWU4VmZOcWRDV3Jvalc3Z29kRWpER1F0bzN5UDlNQlNwL3B5UUpnelZU?=
 =?utf-8?B?SDk5Z09hZTV1b1M2UmMzU1N1c3Z6VlFXTCt3L1NIRTZVOWZVS1M0cXpLV2Zv?=
 =?utf-8?B?bmdpVVE2U3NZd1p4N1Jpa242RlB6aGFOb1RKNHc2TWo3a2pmVzZSTmsySTBI?=
 =?utf-8?B?ODNzMGtueDVuaFR3c2hYM0NpVTlnUGdhMEg2ZE5wa3RySVNCcjZHVDV4Ukla?=
 =?utf-8?B?bXhwS3ZwUnBheEtEd3NUdUtiSzBIOVhxeDArTnM0QWsxSlVCeDlPQnBGSjZt?=
 =?utf-8?B?RktxTVR2UjhQY1hYNGt1RWJ3ejZCK3o1NUJ3WkxEQXVlRXBGcW9hT0dnTFJ2?=
 =?utf-8?B?YlBXeUY5bGdmQ3FEbXlYWnVzVE8yQUdWVVhhWWdKL0ZXNnVpaGVNMlFJbFB2?=
 =?utf-8?B?T1pnVXdvbngvcnYwRUhUb3VvcFVlNEo1V2V5THUrVjl1UTRTUWZWUXhBR0NH?=
 =?utf-8?B?eGp3elEwRytIMkljT2Z3M2YvU1VwYlRhWm9waHVHbEtnQzhROEF5RGMyVWw3?=
 =?utf-8?B?NFEvdUdxbTZCTFdhQ3V6dkdoNzg2aUo1ZFNhOVkyb1JaNFpVSTlTTVhCS284?=
 =?utf-8?B?M2dGOUN3NGcwSXpvSmpPaGdJNUoxZFQwdHA5VWN3bnFqZHhVQnBLUW42bHY5?=
 =?utf-8?B?aGdpWk5laWI3aFhiWXNMZ0Q0VFBVcDhuREUzQUJwV01wVWx6ZE8xZ1NhS0Q5?=
 =?utf-8?B?QTZJVUpqK2htdlR0enJUa2dIVFVweDE4U2tLMk5hY0l3Z2xrTUhsbUlCVjkx?=
 =?utf-8?B?bHdyZThiOGxTY3JwZXM4ODFRRmhSTnY4ZDl6elJxbVRHbnhwaUt4Y3hBZlRU?=
 =?utf-8?B?UzMyN0hkYkorcmRNZ3V1ZHdRY1dKNnUwUExiMzBRZ0RjaFFyUUNSWUlkZjAr?=
 =?utf-8?B?dWljQWVsaHJWUnlVaXIrNC9ySlQvamlDRkw0Z3pDL3pNWERBQnB5L2JualJs?=
 =?utf-8?B?ZUJvYXRmZFhoUC9EOFl6ZHNhdGlBUUk2bnFKY25iVGhnSWJNelRKUkNYa1px?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tAekjm547I8dDwfvZE/k+exZozFF36z2xkU3PbtBQZCHkiMo40yqvKFS6wghOgISEFFCmvevBmHlb4VpFa9DEuFCcga5TCOce7ZDpEY+HwD+T3ruR192QTOMsaiFb/Om3ChP4yTIIwInvVI2mph32Gk1FHwMyQHKhWkhX/CHl6XQyayjmA/Z9yaAlVPRsmaoXCKChGt18UA3oaYTmeWEg4a1/uqE52S87/IWBs1Wjuhj6mIDWKFTppJwpulRGBdOKMKu3zJD37j3SIsdGbBWDJOwoi5DQNYqZ0D11V6/zhVLxU5rUY1oY1gQF+xvLObl5S8xz3UDOSCgko0Q5Y02XvQOm0Y4lxezZpohIZf2dtCwvUoaF/oQperphzIkZcoYkJiGS/hQTQj8GW2qcGMPadkwcY0b+iN3pepj1pmCP78nOSB7dtptepuo64GFPOYvxS/Z/nIfFIpVhRjtX6Of2+e8jshnaytmfOgFcR0mO4onjyRJZ18LFDMUav+c7omm1chd/ZyI9BJbqlPtQ8mq4aUzzgZpkc/M1nacG/WclS35T5gjuQrl1MHmcfaRHS6HMgKAx0Tq3Yj8hoUqjeJ/Ysj7cLGZwdKespfRSRzDmsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0567a0-6643-479e-4b53-08dd2b80035e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 22:51:36.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/Rf9YXAeOkAPQrFH3InpJQFXnIWYZYjbxQYY2noNeck8xCoN3YQqcOwmgjJeR9gbuHkuIP5cNYfhsTnh834v9kcrfwn/Zp1QAPi1HDW5z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7404
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=847 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020200
X-Proofpoint-ORIG-GUID: 8whqqSqPxF0zJddBpvaJzZ4ghRIJOkoF
X-Proofpoint-GUID: 8whqqSqPxF0zJddBpvaJzZ4ghRIJOkoF


Ariel,

> Were you referring to this tree? The commit hasn=E2=80=99t appeared yet.

It's there now.

--=20
Martin K. Petersen	Oracle Linux Engineering
