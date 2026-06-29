Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F71A6838
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782730011; cv=fail; b=PwC/isKhN7ffl/8AwySX3xHtkANpA2mo3h8ptuQ7mdOuoykKim0V2H7lvWde/qam97PQk5wLWi94KQrxA+tmeC/xei5M1h5PmwB8jns1rCuZJe8i7hEZfRbl4TtvLCdoOqhVvC1k4hmYRqm3U0GJsa7DsUgWn0w1a8g1m0mnh6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782730011; c=relaxed/simple;
	bh=EATUbPx+7uruT8y0/o7UlF98Uf4eVwowOJk61ylrYlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eswgGl5wuz1oJ2JY8VaGmjbE+WvBL3qn9aa7DDnYpAUD9BjzP8rH9rV0AdNTB2izpRRxO9i6in9fNujwrnbbVS29bbipu0jxMAPgM8H4Zc7J1ZbUumoioeqFiQ4MrYNto5MxzH85ScB8uZjz0kVBTONl6dMv4JovBJ6VjiZIXZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qAm9geha; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dsr8f3XO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qAm9geha";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dsr8f3XO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65SNhjAp554346;
	Mon, 29 Jun 2026 10:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cV3ShPmthg6zcifXVm9x/5QzMLkBUZuU8juXxT33iKQ=; b=
	qAm9gehaJ/psS2pZxPoluLW/Qv1Ys4RfoDK6mm22M96M2faJw5wbSt0tUuGxDcrs
	ZpCVD0i1OJkKn0mu2yQVHQJxOCcdUqBWGNDzWEqUnnGkLWMOtx4JUpr01Lnes8he
	qA8RrlT0mzshrM61VymaCgAP4ZjdD59IcQgfftKxHQrUQ7QTGIyCke2dQ23L0M+Y
	ouUOyuUIQTnc+HE6+GRy63fT8TSgvimMNcqzwF3H7iDonS31B3glHkHAmrUA4tCg
	MO1NdNOYAqzLwno619bBUl05BRkTONcdGEoqzcNvDihmHzwcvkj22LsMYiRgKM+o
	q98C0BdYLJ8tcznfw7tfAA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p41xq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 10:46:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65TAhYCt012552;
	Mon, 29 Jun 2026 10:46:35 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yp7sdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 10:46:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=itShiftrkVqdrv002FsrPb+YnzZWAWO37nJPdQKzAWoH+xZph2a03o7LcUPgDCvMf8SGbdHXREvN4UXFH3KOKV/OkKEHLk4i8kd6GaXs3ydwXGr7SRDuGswY5qmGfowTr4M1PKn2gZSedVAG0PKkFX+zWw17N47kyNbjAQSdbuLeMETeByaSTUDawLSI7Nkk68sHCh5DypFAE3lZBdlb8SGjn/tg78etxL/Ry9Qrehqn3Ylm13wiNpRee09BK/WL8OfKbvL2ZZnAL/FJum52W58cC6fDBZHJvXBc1iUYaUsjHwDAf/X1CXsecjKd9YCDwd6iDoIaECtu13UBcuQUSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cV3ShPmthg6zcifXVm9x/5QzMLkBUZuU8juXxT33iKQ=;
 b=VMHmXhTeabTRAm26w+VUzLOamYOLUSWQkszKj0ZbVI++P+uSngL0FR/29M4NZM486e7sVsYFqDht1cdlgD+Y9lqgpGK39oZV4z03wvpEr4RXMSv+jHR/6UZBnnSNuoXfTLaJCR1rYrYr3wQChZXKQvfSLluuL/IPU4kH6csB+XcDIJzvka7doRfa94gZLyS/eISD21U1l7q2yXaMjsybhNJC8mjdZhm0qI5WiVMQdKW4t72AEwl6eHCcn4c00FXaQ3biQ3Dq5/C7/n9bA0SDGSBTIBK4xVuI/IXyNFYjgNzQA1VAr171qdCk2b1jJ8uz+5YOKk5hM3lkNL5dYf87Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cV3ShPmthg6zcifXVm9x/5QzMLkBUZuU8juXxT33iKQ=;
 b=Dsr8f3XOm/5txaZ19BfKZkLGJwlQ/dTH5idsp4y0lYW1Hhlu9C7CjRs2yv5jMNrkVoM4WTgB78z3+kujLuk0bOd7WvcJWzCntEwkkJHbMiGnFv4Lrzu2Vf2YkGv2Ep1hWMMPsv5II7gtwBz3W1mCmf2jOf/dBGUC+6f7l6PWsgw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB997604.namprd10.prod.outlook.com (2603:10b6:806:4b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 10:46:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 10:46:33 +0000
Message-ID: <d82926fe-4557-401d-ae58-4302fef5657c@oracle.com>
Date: Mon, 29 Jun 2026 11:46:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0 for
 no DMA capability
To: Robin Murphy <robin.murphy@arm.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
        ionut.nechita@windriver.com
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
 <20260629085310.2298552-2-john.g.garry@oracle.com>
 <53d07679-b1bb-469c-acc2-981e75c071c9@arm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <53d07679-b1bb-469c-acc2-981e75c071c9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0413.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB997604:EE_
X-MS-Office365-Filtering-Correlation-Id: ee383a8f-d1ec-44cf-7527-08ded5cbaf38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|22082099003|18002099003|4143699003|5023799004|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	mKenmBSFJ9j+fBCe9ydSSkalUS9zNCcKBivcoupFja7pc4Xbh06Kb/lhUr5WKgdMawA8xne6p1g0uDy0erOifONDDtQeplC0Py8nISipcQYtbFXCl4NHcTEwBTleFA85UpyjF7A8EABDt97tYqD3yT5Prwt47IP62Dyy9KCAUmzn4VtI1pPataUJ3q7dj/5Hbk3SBY0oD+vUsxOui9qldvdlSpidM57zzsyeagcjj0uxtlENePBnNTg31Q0HFab1kdvEd+DoFaGziv6MZPEEYCY6nz+/CEINNSogBOULjusGBD+w7h4ZeOGeBtFFJN9ps1y9XkDyiwiRzm4efpkz+8KLmHQlHnbwmqmm1ruDJx6umlq7Qc8zsEleasI64YWfZ9BOf652j0FEjvex+u1E2Sc8gwRBZVAnKSLN0tLyRypS50+LtGDDU1w8BjKHD/GSbyC/mMjKp6rj9LnftM5UPai7Dn7yurE3vrkx+6swWhsD5r7oHYM0xIyzMwThuBvtnnQE8GtKW1QN8IETUHaH75QmZ3MXLWkFFxNH/x1aXql7G5jkqaoAuVgc8sabNXqvpOOg9hPe/xs6UbrAYg9cFI6RV+Tcad6Hlneb1CeNs5EEeqcEYGTvIusEfVZDYX4vHBKx59RbqZIJItlPyodRnIsezf7IVJLaH5OC0xRjbDY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(4143699003)(5023799004)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0xtWm1XQ0t4OTFRSEJqRkdqU2ZNbVRaNisxVXJIRFg1enh0YU1Td1RFMk54?=
 =?utf-8?B?dUlXY1ovSUVGdUxZSXNPaTU0bzhqSWJEdzhCZDdCUWw0RGhwNnQzZHFyMWQ3?=
 =?utf-8?B?TW1FVDdJYWtXNTRDdTk1eHM4Vys2ak02dU9Na1lXWWlwZ0FmdVM3TmZFeVVY?=
 =?utf-8?B?UURBSVB1VjdxcFF5WVVaSEprMWxGUjJDaGtuMjlXZmsyeVVDdjZaZ3FTMFZ4?=
 =?utf-8?B?ZFpDK29MTVM5V2VLNFdZaExwVkJTWGVzZGg1R3BtSmttcmlZUnF0UEJGV29k?=
 =?utf-8?B?ZGZrRTlUU25iQk5sU3J0bStRRzZnNHE2Wit4ZEoxcWNsVFhJZGd0TWwyWWRB?=
 =?utf-8?B?TGgvRjBjSHBFbE1GV3U5OHNXOUYrdy9EdFRCNENMZHdCbzVqWTZkc3JhMlE3?=
 =?utf-8?B?SDNxcXBEK01TNVVpUUVpbFdSQWFwNlF5NmV2OEhseUhpVGIyYXpVdjN6TjEw?=
 =?utf-8?B?dFFvbmhXMjVoNU0rRVJHaktsbnJjakJqU2d0dGpycm43TlF6QkZXU3NQUEVu?=
 =?utf-8?B?QkZObVhBOS8zVjlvWmFkTjAwVVFkSytsdjl4ZW9UOUtZb2Y2WEpwc01wVnFB?=
 =?utf-8?B?c1hhem9BcTZFUXdVTG9kQ2llSUU3bHBIUm9mY0k3SlV0aVY4QlRZL3pvZ0xM?=
 =?utf-8?B?b3UwbE01YkxBMnNCZlpSWXpRUVZ4WkhKQWEwR2wvdVl2ei9PczBvTUdUZURJ?=
 =?utf-8?B?WkRSUHJZSExTWDNLSURjT0pCWEJmVFIzaVBZVnluZlBCdWlwb1pMelpPbG9D?=
 =?utf-8?B?Qld4aDF5QTFNSVZmUHBwMDhLTXIwNVJ1WVFjSjBpbmwxK1BJUVJSQTRQVHdk?=
 =?utf-8?B?TlhLZWZzZm5SZS9xUHJyckYvTUFhb25NVDhQZ3Bna1dqcHJtOVlCenhDUTI2?=
 =?utf-8?B?UkRKSEFsb3dwb3B5NENpTGlLYWdJOVVOUHRWZXRnbVU1VEpxbkIrenhicVQ4?=
 =?utf-8?B?RHU2RWJZZnQ4aW40RWxLaGU2ZXVhdDJzTmtxSXFyQ20rQTRObzBEL1hDaUpq?=
 =?utf-8?B?VTR4Y3Y2RjBRMFZ5TmZOMjNVampUU2VXVjR1UDlZenBzbDhyaWdBaXNiR3gr?=
 =?utf-8?B?dy92TGpGb3lEZmYzTVU3Sm8waGJvQjFySTBlY2d0NDFGTk1NLzFZQWpvS0Vx?=
 =?utf-8?B?b3ZYRGJTWjh4U3BBSGZubzZEZXlFUVV5K3lubVVraldMRkFLaDE0Z004dW1J?=
 =?utf-8?B?aDU5eE1LdEhiOTFkNUhEd3FjSURsbTRTTGRLZ1FUODhHZnVHZzFrL1lMSFgr?=
 =?utf-8?B?c0NKVmZNRGJxSnpyVVZ0cUhrT2VFaTB6M1pKZGZkZWtrOU8rSUZFN1JuMlFL?=
 =?utf-8?B?UDh2d2FvQ1VrSUZ4aEtiNXIrV2xhVG9NaHduekdabzUveGN3TWdDUmNuNTZh?=
 =?utf-8?B?ZXRkN2ZadTc4aU1vVnNSWHlPZXVZeWxVQVVDOEtHeG9MOE9hWkFNVVd6ODU4?=
 =?utf-8?B?aUJrN09pY0lCU0V3Z2RZNStXcnlENmZmd2FTbXl1S2VzOTVrYnVBQ0ZHL1ZH?=
 =?utf-8?B?YzloTkw1aUowYURqY2RieTEzWE1nZ3pGVkwwUGl4bllkcnJVQXBhOUtnYTI1?=
 =?utf-8?B?VDZObG5XWTIwWVU5ZzFHZUxnamlraGtlbVM1L0VFMWtNbFFRdW5XaFA0a0Yw?=
 =?utf-8?B?MWN2U2tZWTNxV3FEMERVTlphb1l3SlVLTWh0TnZFYmp5ZG91UlJmZjRKT2lj?=
 =?utf-8?B?eHNXc3VJZDd5NXhER2w0clVhaW1wS3d2clhTbEJOMkQva2orYzVDeUVocXJr?=
 =?utf-8?B?RHlmWGhVMW5PdHJkWHFEbHNZZUxnTldIQWViMHRLVlIyTkRKV3d5c1JXYXVo?=
 =?utf-8?B?NlFTTjRIQTB1ejVzV0s3cTVCOTA1ai9IbGxWcWprNklvbnF5TFZ1bU1od29Z?=
 =?utf-8?B?UmdXei9CQnpGL0h1YkxBM3NuUHJuaFJwaGkxZXJya0hVTEVKZWNoTndkNWRW?=
 =?utf-8?B?Nk5WajlrLzR3bndyWVh3ZGdIT0lyOVJnOVgxK0pQZXk0VFBPVm4ybXBSVmxF?=
 =?utf-8?B?Vml4bGZMNE1EaFVOOWpkWTQzY1plZ3VnbHB5YU9XeENQT3VMRHlKR08yWlhG?=
 =?utf-8?B?SS9pREpNRVpBZGxKSHMxMFRkVUpPTVBsMGlhNDR3dlNOV1NHcjhUYWVVVkV1?=
 =?utf-8?B?L2Z3dk9DOGU5RVpwYnhGMUY2eWFhSGFOeDFlQnpUcE9yZC9Vb0ZNK1E2T0Z3?=
 =?utf-8?B?S1BjWWV1OS9MU0pYTnYyMDRDNDdpZ05hNERsbXVBYjR6WklYVm83STlVKzg4?=
 =?utf-8?B?SUFLQk5INWQyaHluMkJGWTFSTXU1Y2dkNG5GS1V4V09kV3g4ZVVyeC9QSzgx?=
 =?utf-8?B?RGdRVEpncndBS21xOEh6c1hsUmdFeUE5cXFtRGxKckNLK285UzFKc2N6NDVE?=
 =?utf-8?Q?Y0Hv1JEtzKHaMwos=3D?=
X-Exchange-RoutingPolicyChecked:
	YA/N9P02YIF8wNq2uxkXIADLhvPUfln0xuk2rYEgkaYDcGXydKKDDaOLJkNCefzZvME+9DIWC1QA3+YIJrqB9DupAdhwcxB821NRDz4vLJuucYRCeLO7sLg4xjxccuFqTsC4EzfaEmF1i4Sdq4+IPzi9eoJZ/6b6zKucu2JmECFtRHfHzAeoqQoi7i2lkW4WE3Iae3TifShQFroDi67i+mg96rxk/i3alUN8SUJCFN6yw2UZqg9dLIC1KwYDn+Z+WAweKDL9r4S1AVJrHJ+ni5jUsYs3pjxlVHcoQAo0yFMNU4JJOJpvG5Mhcyn4Y3a3qBEK28kvTzToXEGSA1AokQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b+6/7HIYIr9WcqZT8ejFkfFgNaXgB8OWPhB9WYfNnzsEqxIdPMOuzAK34wjb1ek+o04NxGvjPPa56YUSk7sBBX5VJDDXTc33UMAKQZW0l4V+sf14P+u9vBx0RgKmyuHvQj5/HMJEmIb8a5QCQ7KnGsjOluwr23lquOVdRoLaBk30MAQRERkc8hQTiEtLd8DDbLodR16039zJB1457wVf7LIxbsb2U2q2J5SBDDs+TfKqmc+bnFBqO+qEjKe7NCw54YxZ+50L+F+G6hsNFKP/lHmCCw4Pg5nVqMkZdhKWCodSyaCP+ARjHy0/R5vbGWOISIa/WCrFcUmvrEOnPCnr8PcQaIqeboe+t/8KKrIkQpav3zObnhuBlHA6Oe6AB+L32604q4rF+00BMHCfxJ/D49nVb/ilPIJRZOwzlHlmmtLh0Oh/5iXAadP0y14/D6bYZ/ALNDt8E24PnmaSn7nhsGwUCalgK+223D/o3qqSOWDxmOwtfESKBlrZQB7UH9JhRxK0w3N0LC+/ppu+Fnl66rdX5hgTOXLD+nnWTXPbNgB/JKMr2SXkQf/7xtXPGMKaf5M97hAKC/KQYmJkZsj3eZRvJKMvwBVOHgaOMA464rI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee383a8f-d1ec-44cf-7527-08ded5cbaf38
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 10:46:33.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgeU3GS60QnW1Rbxp0+7C1Mj8JNMApzeHUj7ObJ8rcXmGDISTpft765ruDGZHsE5IwGa9iCX+lbDhED62WW8AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606290087
X-Proofpoint-ORIG-GUID: ARxDVR_UOtudk9OWEsKO-aMHd3Ar77L0
X-Proofpoint-GUID: ARxDVR_UOtudk9OWEsKO-aMHd3Ar77L0
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a424d0c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=7CQSdrXTAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=fK1WjxYyLWqF990s5I4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4NyBTYWx0ZWRfX4VD692RWcdMR
 c4SGHIq3x0EN/9AXqyvJX3ajSmRYVThgl81u6w8HoQHKP4x/BYN57YgquTyDfJmhD5DpW0eWoDt
 LSpNgYEfM7Qnz/TO08YMFb4xFYF75chxG9O/apeObVOWnH0o5mfwWjSp/LcoMM5eI+9N6yqo3KO
 4SdqQIS+N+EtNZmjMFkxgFKdFO2JkrcW8AbxcboZXIHGuiIjZAEF4F7T7nIumQP1T1S+jcwNMCq
 CJoFrj72Nb5ljd6Abnru1cPXeGeRAh/6yTGcWgtwShFMucNzwYh0iKuD99Z+m5zrIb8ynGYfTPX
 Osh8rRlArPbQoL/lLJ394xMa+bwlT4jU4NBuTomFccdWEyTyBGSlSmvo0LmDA6uuyzN957xIkb0
 l9UzZ1IvsC/xdd0Jz6hoAp1KPzH+64Qwd6alvZKl6W9QOfiq3AG8re1K90ZZfRoUtesEAb4CipJ
 Hn646VPSrVOu9SdoSat1NKzV94HgKEHWOHfu38LE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4NyBTYWx0ZWRfX7tt9FkOeWc3v
 U1PiRVIe7MyzVCazJjx7Cui9LSjLfvqy7PXH49dp/yyRelL7VAc4NbNPJ8mrNj2KB892yNsdzN2
 Yq6KmYBI7Jmo8Fdk6AIpROplcMnwqYoRDqIKsOo3Dc8q+ZuWSiEH

On 29/06/2026 11:11, Robin Murphy wrote:
> On 29/06/2026 9:53 am, John Garry wrote:
>> For when a device is not DMA capable, the max mapping size would be 0, so
>> make dma_max_mapping_size() reflect that.
> 
> Seems logical.
> 
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>

Thanks, but sashiko has been reviewing this and has a few things to say.

I don't know how it chooses recipients.

On 29/06/2026 10:10, sashiko-bot@kernel.org wrote:
 >>
 >> +	if (!dev->dma_mask)
 >> +		return 0;
 > [Severity: High]
 > Could this new return value of 0 cause a division by zero in callers that
 > expect a strictly positive maximum mapping size?
 >
 > For instance, in drivers/accel/amdxdna/amdxdna_cbuf.c:amdxdna_cbuf_map(),
 > the returned size is used directly as a divisor:
 >
 >          max_seg = min_t(size_t, UINT_MAX, dma_max_mapping_size(dev));
 >          n_entries = (cbuf->node.size + max_seg - 1) / max_seg;

Later in amdxdna_cbuf_map() we call dma_map_resource() (-> 
dma_map_phys()) and this would fail and WARN for !dev->dma_mask. Indeed 
amdxdna_cbuf_map() is used as a callback for .map_dma_buf, so highly 
unrealistic to have !dev->dma_mask ever.

 >
 > If a device lacking a dma_mask maps the attachment, max_seg becomes 0,
 > which would result in an immediate kernel panic.
 >
 > Additionally, could this cause invalid zero-sized block layer queue 
limits
 > in MMC drivers? In drivers/mmc/host/bcm2835.c:bcm2835_add_host(), the
 > return value clamps max_req_size:
 >
 >          mmc->max_req_size = min_t(size_t, 524288, 
dma_max_mapping_size(dev));

bcm2835.c is a platform device driver, and platform devices have their 
dev->dma_mask set in setup_pdev_dma_masks()

Indeed, that driver does have a non-DMA mode of operation, but that 
looks to be selected independent of whether dev->dma_mask is set.

 >
 > If the device lacks DMA support, max_req_size becomes 0, which propagates
 > to the block layer and can trigger panics when processing requests.

All other users of dma_max_mapping_size() are drivers for real/virtio 
HW, so should be no issues.

> 
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   kernel/dma/mapping.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
>> index 4fe04669e5e66..7e576e5c6b8be 100644
>> --- a/kernel/dma/mapping.c
>> +++ b/kernel/dma/mapping.c
>> @@ -979,6 +979,9 @@ size_t dma_max_mapping_size(struct device *dev)
>>       const struct dma_map_ops *ops = get_dma_ops(dev);
>>       size_t size = SIZE_MAX;
>> +    if (!dev->dma_mask)
>> +        return 0;
>> +
>>       if (dma_map_direct(dev, ops))
>>           size = dma_direct_max_mapping_size(dev);
>>       else if (use_dma_iommu(dev))
> 

