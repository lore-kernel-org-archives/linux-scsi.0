Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312E31DE8BE
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781010932; cv=fail; b=SnU2/1yGr6c7fQwzh856fQtd+7Ecl23L3IGz0+8xvUk3nFQwIQKbBs+v09uhV+8WJYQ1MKe9LifmdkamiMMMb66PWEVXErTJpTUeM/QxiwVmft2fhnZPHfFzyEIXVofhOvi3Kf2rKYg+ABRa93lEQ4E+EO8DgOh80X+n544MDlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781010932; c=relaxed/simple;
	bh=cgbfjCcjawlYJqN/HwrqwlAky8Og+8tTNO53Cd53D5c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GkLHjQ8EGS5anFaZ8MdxuTaCkH7E8UF79XF0PY1oAvsjm/IeBkq+jTGhRXDt3XbyTtscbR7RFl6o9jJ47w3mW8bJVeI1K8827ObAE/+z0rzCxHeYNDbEnET4rOn22lVnPDFPNGcUh4SxKPDCQQKrjDk9+IkkcXfzGufq0ijt2Qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RYohb7++; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W9IwBHDw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RYohb7++";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W9IwBHDw"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6598P6Mj429098;
	Tue, 9 Jun 2026 13:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jS+tuRxn9hZBJbze2GOSzrJSgEvDah8s1jq5fhRRiMw=; b=
	RYohb7++l6h/zgiTpk23wRgfhYHqJ5wCb/YHKPyPKygXmnmaAR9yePJUbA5PvHWp
	9Ui3Rxne3LQ84VC1H7rVbDxwWl8Sf3JmU3MFxkiBDN3MvD99TCood9/IZYJ4VjQ6
	ArKOnNQ8Nqe7QPHC4Zgh7aIJJdQtpeDBYtYjLRotfP57ZOluIU8iauUF22iPfOgX
	RaaQcKq/skpc9JeuHkS8BCHefceODRgw+Xa4UJHkuzS/ErptCuh+B+pXR3hoLPDX
	KX6get39pCbW+7tul87M4C8WgJ0yqhSce9I2PgKaydEUfxn4B2DVmkufHkI5t31q
	ouwYwGQoPfSW4nH97pLmtg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embe7m8x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 13:15:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 659DDFkt020835;
	Tue, 9 Jun 2026 13:15:23 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012034.outbound.protection.outlook.com [40.93.195.34])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0eq110-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 13:15:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZO0/FtRh/iiP5FJ9FsZoTNAyHpUt7sBfU8duyZkSTQf2P2+WtDFmdkl3L4l/sdZPU48neujbl4fR2v7AlyUCBMpSKgv3e3IuXQ9MwWEl81YMWo8rOnEJBQ4bYcUFhRXtJZ3fO9sNxX/RTDddP1wb5tDe26qXwXNvOHa/LiuwpIMVhBfpQpAG5zRRh7UFbocF2HoSrAqlTwYnsIZN8szWUrKmaRIWTJM29KHwMk9WF4vKmRnEEmFNR5rN0H2BlmO+7kOS0tiVcTRxiQMZeBtPkI/gX8KAsjSuW0NaXvJxX9XAljhbJfDEgZAmGoYWPQL/pGLUFhx3mD46yeDHcVs5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jS+tuRxn9hZBJbze2GOSzrJSgEvDah8s1jq5fhRRiMw=;
 b=f+4ZLIc7g6epQAAlELN30sju1GxK4GDCNBDSAKkpZ10JX7SSlHOhyPxXtIF8EVvysmJijSyixoAxKyYZzz9bgR66EEuDCSH/nbir4MXmpxf6Rp82TOfnrFcrGIjnbk29wbOUy1KY2VcsquD8kO9yvzwdn8GnWZbiYJy1cojukgFe92aZPqmqqp+nN3U88n1zdl9Qk3MIRrEKkK8LJsSWd3LehMJlOfS21CWBhM44iaZR1tIdWDh0ii/yRnQbPltYLlcLaMrOXwi5RoY0b4T73FMpbxHgDXPUFfvLsw9ZfnXRrnLNyjDt8aB2F3nKB+7IYaBIG74rsVJlAJVbMgIIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS+tuRxn9hZBJbze2GOSzrJSgEvDah8s1jq5fhRRiMw=;
 b=W9IwBHDwigNIR8PEZ/Hq49v4v1c9JYyLGmBUQYgu+ffJTKff/9DMULDPQkck9dWR+gUkBwAPP7a1YXWM7FGZIKI7eHBbOe+mLwmIXs5kfhkyH11LaaYq2FDdCjtLNhkt7jxMS2H0TxD28Xh22TjOW53ilMb1qa8C7Mu6lIx/PnU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6825.namprd10.prod.outlook.com
 (2603:10b6:930:9c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 13:15:18 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 13:15:18 +0000
Message-ID: <ef99d13c-426b-4c12-99ec-ac2b1bacc295@oracle.com>
Date: Tue, 9 Jun 2026 14:15:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] scsi: use percpu counters for iostat counters in
 struct scsi_device
To: Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-5-sumit.saxena@broadcom.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260609121806.2121755-5-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ade350e-9ea0-4481-2083-08dec62926c4
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 L6X8Ixlyh9bhlPy6EhdN1oFUHeuPOSMh5yL7qeqBUK7D7tRfKzkW1Mif2mToUSfnLwdNeFfGaYnPN4VlhhIf9OQlr2IK/ikGMxIabRH4toThMC0Vk4VY5He4QEQyUdv18VAMYkQJ2tK/HJV7gN/jjionBTyOcvWvGfAZVlSSTNcx+KSTOsLD+rzWVqVFnX2p8dUJ3gmTUTDsA1zfwfhRhdfRlvY2KwjVTGUChC1C0IegMntny7u8OWp8LXcsp0ViOlopNONFOydbDHKHkFc5fuLOlgFQGjmKldPea+bZtvGa7/DKx/Npt7ENXlmmWMqOPZc70jE6apXfJKgmpdw8+7d3VKLinDgLImMuRtNwTm8NNJ9hDoSSBGNn0LrYGvfyr+MIiKj4ZvMrEH/L2Y2WGNl13/Y5thnNCZSte3L9Chca6ZQ4QKUWoR9jgwuy8inFNwgJVSI4zoEPSk8z5mzOP/QJ/J7j87xon6mMac7NHG/yWauZnZjwrDIe6J7cxVfFRMCY4OrFDyxFgJcXQn0zuEyC/Uf9CWpDTYGc+/ltx+Tk0GmhiLc08tqBCF8MLmRIXKXgwAkeuNXPFMZ8eP3DmDS4EUtiCCYW/jTwG1DdTQihJ8qL+qpB46wmDAvBCV4bSo/ckzMTk2g1hm1lfXmixlm60C50BsFNIMh3H0eNsFDN7jdrkaFomSUX8LJEd2TM9oE1WiQqJ5YKthZkpaP0Vw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RGFCV000N2Z2MURLM09SOWErKy90dXFUYnhZYmJqRnFXQU9WRHFrV0tuQWtD?=
 =?utf-8?B?N1plZDN3YzNwOXZkZVF4T2ZrU3VOYmg3NjdoMGpTbktaMDVzZmYrcXFQbU9V?=
 =?utf-8?B?SmJac0RVYXZWQ2xwSzVYMTJGZXdmaHJhc0NLdTRyYmdTemhIUnhYd0RHQWZP?=
 =?utf-8?B?M0prbFFMM29ZTFlZN05iQVR0ZWlSOVExQ3lkeDI0ZEVZdjlHcEJ0cW54NThp?=
 =?utf-8?B?UU5MQU1FUE1uZU5EdFhTL3NGNUZaOVBVSXVBcDBybHNKL3hUMG9ENHl3SHNv?=
 =?utf-8?B?UEE3c0pjY2pPZEhZVzI0KzRRUzR3Q2VMOWFZa3lxZXB5eXFzWUQrZ3I4clJ6?=
 =?utf-8?B?anNrOE0vdVhaSFlTVW80dEtsT1daR0c0R3NGNVFpQ052YURuaDkwUHRTUThx?=
 =?utf-8?B?OTlQbFdXVWI1SXZXanZJS1dvU05NYmtIVlRmOWtiNU9nYk12NlJTOGhoNFFO?=
 =?utf-8?B?Rml0Ny81U2hEK1BnMFpSMWxkelNXd2NVWmMrWWJrQnc5YVcwRWZ3VmJZcVpG?=
 =?utf-8?B?NERLdnlqcHBLR0hXelhaUW1mSk1jVDZwVEJWK0FNQ0ovcXJDMnBmSFo5bzFI?=
 =?utf-8?B?OTIyVFo4SXJTbERjN2RwcVZqK1hEdW9yVlZ1OHFUTEtlbWkzT1prSnRXS2JT?=
 =?utf-8?B?dkt6ZGZmTFFIYXlOM2l5WVE1STJQODFIaDkwQWhGU3EyVDh6RFNGRTNQMEZk?=
 =?utf-8?B?eWlwVzJrYVpoOVpPMnNKb1N4aG9LVmt6cjNNNzJlS2swMjFyTGc5VW52cmR5?=
 =?utf-8?B?am54cHREc1JBRzJTNnU2azFnL0xjRTl3QVE1a0p1bldtWWpEOGlTWE5WME9T?=
 =?utf-8?B?ajVNR0xIUUJaZzVER0R5SU80Sk1UZm1Fb0tidENMR283UDVIOTVzMmJIaFFk?=
 =?utf-8?B?Nm4vSTRUVVNPRFlwOE0zTDBHTTNid1ptL09xZ2gzV2x1dzZ1cE9nZVlvNitQ?=
 =?utf-8?B?ZitzVkpPZUZmMDBVOC8rYzVHT2pmTlNQbGpVNm1rTkNOTzBaWERTaHF0R2c3?=
 =?utf-8?B?bU5xcjAwMFZhc0tyUHdKS3doWm9PUmN1TCtROWRCNUIvRFlUT1RoVnpMRDQ1?=
 =?utf-8?B?V0svZGtDNFlEQ3g3MWVYYUVRYjJWK3Y1Ny8zRnZpa0xzUDMxSklNcGIybFpE?=
 =?utf-8?B?QVZRZ3FqL2hlV1QxNVFXMGpKRU1DS2ZFOFhOekNkKzh5Znc5aXhIcUltckpZ?=
 =?utf-8?B?cGJBaE4zTnRiVFVsSWM3RWxLL2VxZGxkR21iQnVka2JoNzRuR3ZNUjgyK3Vx?=
 =?utf-8?B?YlNmTFNMSk9zZ3oyRDlsb29IemxkRk56dzZJQndGTXZFUW5rc0t4eFAzNmVw?=
 =?utf-8?B?cWVRaHFzdWZOTjBCcWRzTUtPZGpUWjhINXFhVVJ2KzB6V2wvKzBTVHhxYldm?=
 =?utf-8?B?UVBjeTZnSStWTW9IOWt3NTdWeGo2MnFCTmVIaCtZQVpHUnAxMjFCeVNIdm1n?=
 =?utf-8?B?ZzJEeDNZWjljYUJRY2FJTFBGbFk0blNnT0E1ZjR2aGFScXdVR1lranJiV3U0?=
 =?utf-8?B?TVRFV3NtOENERlhqb25rMVlMWXpMOFNWdXRZM2JOSk9vM2QrM2tRbkVFVkxV?=
 =?utf-8?B?YXNncFVlN1V5THl4RzJHaGZrUVBEdFhEcncyVnlQVWoxNjRIaEQ1ellhVW9U?=
 =?utf-8?B?RHdaOUtlenJkZmZmOVBnZ3JSWnNTb1dqYzU4Sld3MFRqVU1KcGZDNmZ4WEF6?=
 =?utf-8?B?T3N0MWRQRG1DVmpqUmhWNmdVb2JZVnR5WThFZXovTldhM0JRTTN0UngyUlRt?=
 =?utf-8?B?RUI2MXpLQTYxdDZCenl2bkhmaWovU25XblF0ZDNwQXVpOFdmWGVEY051TXpF?=
 =?utf-8?B?clRWeVlyOW1ONFlvRXFaSkpFZjFLK2RvbWR6bnRhTlBFeWpBWVlYWUN6b0hO?=
 =?utf-8?B?THFDS09qREJ0RjFSeW1DS0RmbDUwS3U5R09pR05nQ3ErcFJYSEl6elVKTUlP?=
 =?utf-8?B?NERJaTdUSS9hZDJjdmhaQjJYazQ1Q2s0R3ZTY2V3V01LZFlJclF2c3FmeHpp?=
 =?utf-8?B?TVJ6WDhtNjBoNU8xcGg5OXNaV1pLZXl1cnRUUXdNWVgzM01mOCtiM3pRdyt1?=
 =?utf-8?B?ZEZlMUFSa0F3dHZlQ2VQMm1vUC9BSE1hV0c2WFpBYmpDU00xSU92MkdDV3FK?=
 =?utf-8?B?LzlqY1N2L1NsTEkySzRoZWZxbysyOFJLeENKdGloY2hUcVdLcjFZNXhnZWNW?=
 =?utf-8?B?VXZ3RmRvOWRNNExrc3JidURRNzdzVmdMQmpUWm5ZWlVnRjl5S01VQSswWE1r?=
 =?utf-8?B?QkNmeTdTYnNBZXVtUGR5RjdnQm4zbzZhWlBqTWFNemJ4eGF3RC9Dc2gvQnYz?=
 =?utf-8?B?dUFvVUhSRDlKVE5ybS9RcUJROER1clo1Qk9SNHlnSGh2bzdsYTNOZz09?=
X-Exchange-RoutingPolicyChecked:
	WAtpkHyLaJbyjgMNWFT3WFgeO/uoZ4UnC6KRxYZcPKiGTAIAZJxZ1IaYTAqsmE/G6cg7fcnQASaX43OLJPsC152tyvvDH8hPM4DfgFoC7Qab5DmBxyXqQouvh4r1M71uI2aTMoiElYJLeyCW0hvItsBOtNFn3TLWsCUtEKZ6N1Sib+0GcafsrNcs0maGT9NQ7Q8lzrrKAzoeAbftyclgRoCfItex9UBfogK8BklGEuNAHTiiJU2TRt7vwkYlC0a/fz9VM4nMxDwozRyB6EHUrfyc4BVlxvtv3rL4TDLL/UfIoTOZZqqvbjSp/mhfkWsXgBLhgysUdXQEP/S5eNCrvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yvBZgPppU+zPjxVDjvoridSOMBOpXiurOO51toexuAMi4pD4VgZjuW2orW70QHBqRPN7LXS4Z1lAyXUAp0Lo6ELhSAz2Yx5eqztQgVK/Q7egRCUqb+JclZ7tQocXE02A4f4900SKEOWl6+8DjT6l7i3UyWzA65xNR2dVIZaNapQgMxFWBf+pGBk3X/9FMRlzi9w+vn8yqekqV+Uc1UwQLdSCCNdEr9ElUju2gI63fsNTzpGwtfgV4pQiV5B4KM20IYCzajON7vMkqpNg+gYphsSDrFp2Sc7ryDKFvoHklUB2fb4qJrwPnTt4PknoXKlIL8SOlBEIw1FNvL/KbpsLQtr72IV4OBKUi//qzYmxA/AdObnY8NdBMsaiWlAZF0DIL+XOThCHciyeNuLudiGr9ztP4N6L9AGm5LtOVi+XnRp6zNSn390fp6/em0YXt0V//4XcazMJBQlQO3Zp/yTlCQWEZEQMb8oiOzg1CKCdrlePPJhPhL976BFxvz9Z3PI1gY8DpwaAvKdYtRbYsSLnmgrOxFWdVkb+Omd52TmS1EiP25tHkXQOmbNpeSrTuZyd/XnMGuHuD3kC4oKDizbBmIm5jizYpwEKbcuqxrED9GE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ade350e-9ea0-4481-2083-08dec62926c4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 13:15:18.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t5BMzvh14J6nnyua9jTncPxNcEBHV4ANcJqd2OWadj5hF6xoetrGpfUtEF0bvk7KwSRLxosKI2ikbeiXQKjsQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6825
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606090126
X-Proofpoint-ORIG-GUID: 2dGKNrXYm7ve1cZhSZmQJlnW02zehiWd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDEyNiBTYWx0ZWRfX8G5SDoUXWlhg
 I/SDaM+TWO0pjR3jDYjjlZ0ahAa+/1+hYHXIG1osl/g94ryRviXNSML7xQtzVllyhKPCicUsTvK
 MGpbHaoaANKG3kawVHCeFKYs57tUsRWtAujeiU+33ysRq6Y3rxhvcqwQ/g2p0N3TznseIJMLzvD
 m/CcYYElNnD0Q92q1cmrR6XODn8dAvJD8LOKQbh0Tb9IRP11ek92v+htTzGqDTMnAnH29bzb4T4
 aEeheMNDTHQEWasXjMkGUQk1Eqa4DhWXiyNWVRN8RNjiTOukQoDrpIrTiTxw0xB+LpkFWuEz0G1
 q+d+z80sacHBkExDxrOALD6IbKq3UT3+QOyPEoESyrKg7xOJ6IDj+/C08Imfw33UhelfB+KvJSv
 AmWgmWRCTbksl9dSPsyCbscXlpU5wYVm2nxbm6wD2qnb9i9tVFdlRcNsNP3ues4I7KoWDhJuUO1
 jsZNpEvpppf5DpKRTUw==
X-Proofpoint-GUID: 2dGKNrXYm7ve1cZhSZmQJlnW02zehiWd
X-Authority-Analysis: v=2.4 cv=AufeGu9P c=1 sm=1 tr=0 ts=6a2811ec cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=Q-fNiiVtAAAA:8 a=yPCof4ZbAAAA:8 a=iEennAgJ9uWy6-xvmSIA:9 a=QEXdDO2ut3YA:10

-- huge trim

On 09/06/2026 13:18, Sumit Saxena wrote:
 > iorequest_cnt and iodone_cnt are updated on every command dispatch and
> completion, often from different CPUs on high queue depth workloads.
> Using adjacent atomic_t fields causes cache line contention between the
> submission and completion paths.
> 
> Extend the same treatment to ioerr_cnt and iotmo_cnt so all four iostat
> counters in struct scsi_device use struct percpu_counter.
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

I think that Bart originally suggested this idea, not me.

https://lore.kernel.org/linux-scsi/20260420113846.1401374-4-sumit.saxena@broadcom.com/

I just queried if we could use percpu_counter_init_many() with an array 
of counters, which you said you would check.

Thanks,
John
