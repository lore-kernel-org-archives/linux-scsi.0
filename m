Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6739917333A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729093530; cv=fail; b=gDq/Nu2MiWJIq4UgnlTlOf9O4kxOoOF93ba16no+WPanjGmtn4i0JR3q1QOwV3CQzl8uJvgfsLJ5iBR8f8AYc9YJMHNCia+O8mICmpgd0QOIvRWUw2KRGN/9xM8CkSZ2yZzeQF/fcy4RJe563rrhYbeebxU+5ffvLMgw5bKAChw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729093530; c=relaxed/simple;
	bh=4AOtMfPNhwQ+2ImhcAbetO6yQ5gQ6dW28eMJOlCNiF4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l0jfAru01xRHePNHu8oGOYcv/3XebLRfgEBS46p0UUfE6JJHgYMqNBIwQ7eYT8Xfd0gV5F1ncRlA3KIBIUvIXf5lZjx3cYpuNvV+c819FS3iHbrTsW19YB2RjqvOIbiGteqJNNbUBv94HTltlBazUSyKiwi2A57YvT3W/RL1/vE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RIw5AFsu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tPGDFPWI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIw5AFsu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tPGDFPWI"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFfnmJ022541;
	Wed, 16 Oct 2024 15:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9su6+2I73uEiseB89pYl1j0g55KVM5IRjRUFDqHsULc=; b=
	RIw5AFsuy63+Oq5BcIxx3/JfcmuszWQ8f/+m2vVPomnBqz0E64dXT16N6r+qBmjT
	2BjBRyI8GllZdVEFDVjCXN3ccJS8BOJXw9ptdLd3TUV1LXeLmDzvNToXE1+4UKN/
	r/VD4GYJzniNCmvzx5IPipzMsBNO22iWtLypzmTbMY1JOlMRND7hU2F82hfBwpHC
	nC7qukzvVoYgRpKb09VvQKP+TUKEljbS27R+UdUK7AI/n62otpavDjWuj5yPDEOt
	heZRjAPhLNTqenzwR+NRtHTAhcjxpR+pjv/2qZODvvbYNihkk8hek/T2eGRYjMbM
	rcPeaaejKz0RilKjNU/HIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09km2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 15:44:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49GFKjJC019938;
	Wed, 16 Oct 2024 15:44:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj90qew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 15:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p7Ro4czvZS3036JotP5rhtgUbrnArWz21c8GriKLDrdrCS++yHEVbJaKm48TTo1D/gHV36+XVWe3xVYr7qR+I9saksxmPRZKz/AY4SHm8+2mSa84qNS8xfNJ+stXyUnD1z+Tc0kpQuTqGNfrizzWSkTcwZAg7lMG2waeRikUlzFTyp5HDSq4tF4+jqi70FjUvO28kPBV2mnnsSl9FaQKCWPlA3pTHhsgm+220lX6vAXv65fSuM4++CJ5SEHafQOqlRc9CLBIlcfrXISAAEmAeaS0NRaKuo6oWGLCK1eTpZbF4Fj7Ww+6LLIWzqEaum2eoXsbNJHS6NAH6Z/T5/GgMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9su6+2I73uEiseB89pYl1j0g55KVM5IRjRUFDqHsULc=;
 b=caxd8GiO10P+pWq5pO0ITkkUn+ASm1onooAfgp8r+3w/c5STA++wrMQyBZIoBOCHx+ecTD4lN7HEEATsdySv+EYSO6OT+gAhc+RZSf0X67JaUdvKIhXb+tuvVDus8uOsPppqz7tcJOCsxkZyu+w7UYgK6SAZ7hEct5sDuWNXqKcrcj4uT1dfWPCq9GXHnVibNDeM5v7mv2BGGz7zVnfb/lsnrG3g/3fPQrs9IQJBkNRdAPjsKYvDNqnwSRMos8ublA+thc711ycBlGXYRCQCC3O4pH7bSRpUU2T7SIGO4YiwBIjceM90/D59mt7+SRFyZ93hnxCZHl34kyO1CLS6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9su6+2I73uEiseB89pYl1j0g55KVM5IRjRUFDqHsULc=;
 b=tPGDFPWI4ZekMptgWwitHSSlS8t2/4M6/SDkkakED3/Q1b7DjUA4SbU6dk2KptblHC+Mi+o0RaseBKIsP0xz/wxUIUFotIf6n7gTOietQ5cCLqhGcqo+gmBU5Z30aCyJfJ+KYt5UPOfMMefNyX8A3qfX2h/IhbPv+XVAYSoRkGw=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SJ2PR10MB7620.namprd10.prod.outlook.com (2603:10b6:a03:53f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Wed, 16 Oct
 2024 15:44:12 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 15:44:12 +0000
Message-ID: <f92444d4-3a64-4070-95d7-805eecfcd775@oracle.com>
Date: Wed, 16 Oct 2024 08:44:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Remove unused host error code strings
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20241015183948.86394-1-himanshu.madhani@oracle.com>
 <6a587c9a-b573-4860-86b9-3a27572d39db@acm.org>
 <2001a656-3bfd-4657-b47a-68192894ad18@oracle.com>
 <80cac88a-9eb3-4301-b2b7-ebb5f7fdb7d4@acm.org>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <80cac88a-9eb3-4301-b2b7-ebb5f7fdb7d4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|SJ2PR10MB7620:EE_
X-MS-Office365-Filtering-Correlation-Id: 564fe114-826f-4627-e58e-08dcedf96178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWRWZ2FPRG9BSjRYUWMxU2FzOUhweUlLdDBJaWx4SnAvdnJMeUtoaVdBMGNV?=
 =?utf-8?B?ZTY1eFNPMXpLNkdVWTRaRGpqOVJZVEFQZVVDYVVrd1NZVi8wcVphQmw0Yk9K?=
 =?utf-8?B?ODlldG9wSmdRSWJ1WExNNU9qUzNhbS9TNFM1TWpjRGwxWm1DR2RsbDA0VG9K?=
 =?utf-8?B?MHltRzVjSUl4TlQ0U2VSRnoyckhGNW44Rm5adDBCeHRVQ3JTUy9JYzZ6amo5?=
 =?utf-8?B?VEt2NjNqY1MwWlpac0FyYkFsbVY0TUNIdVp2cXVmZURKc0UwMkpjR0RlZ0VU?=
 =?utf-8?B?MFJSb05lck1IWlhlYVJlVG1YSTJadnZnSHFPSlE5MFdRd25ia1hMMUg4N2RD?=
 =?utf-8?B?RHlrTWNydDQ2bVU0Z1lGeDg1dHB4RWxhTEZYdUhHNzVDMlk3WUZ3MDcrbll0?=
 =?utf-8?B?Nm9INnV3K0FINllyWGtwLzZoUHNjWWg5RWhQdjRYTW8yZWJsdmhIS2RGTTNi?=
 =?utf-8?B?VkE4cUdCeFdVT015SEF3K1FBaXl3TlRtR044WjVmY1VTMjNVbzRueWZFMGw4?=
 =?utf-8?B?UTJqc1hTMUlsTFIyK2VGSzgvRzJ6eE9TMDVHWS9JbHkrVlBrVmhjK2NXbWNk?=
 =?utf-8?B?eUtvbmE4ZHlXTnF4VjNVTTFRdkZvZ00wb25qMTlobTVTOVh2cFg5dk9IdWdS?=
 =?utf-8?B?bG1za0JtS1J2eXJlTEN4L0lobU1LZERNZGt3a0ZkQ0RHMWZtU3JCTHdzY2hi?=
 =?utf-8?B?R0luUENUeE9XTmI1SzJVckdLL0dUQzdJOWdqWXgzM3FVMU8yZFpLMktiWlRa?=
 =?utf-8?B?OGw5VWVUcjZ3RnFEYitIbkdSOVUwZk5lT20rNmhlckxFT00xbXZpSjNmSWFz?=
 =?utf-8?B?QzRuOWJrVGtnUnoyTWFtQnpGQ2pHK0pYdkZyellNandNNGk5ZjBKcnVxendT?=
 =?utf-8?B?YmhRQUJOM0E1b0pxTVdVSXFZVUd5L3lHQ3pnZ2VoSE5RN1FGY3VXa0NKZUdX?=
 =?utf-8?B?OHpmZE1qcUtBYUlic1d5eDh0WGVjd0FDK29kZHZXMk82UXFNT3cwbFVXN1hm?=
 =?utf-8?B?NFM1ckwwTnlxM0NYWXVOWm8vb0FIR0NhL1VYRmhyWEYyTlRyejlqdEtYSHo0?=
 =?utf-8?B?QjUyZVdqYmhodlU3U0NsMEgvanZ1NHVGTXdnQisyRVZWUDFvdWhrQUNPaXly?=
 =?utf-8?B?eThjd0s4b0c3NWdYa2V0TjJvTy9NcDYyTUlBNytmUzBWZmVvaXBYcTd5Zm9U?=
 =?utf-8?B?bzZNQnFHN0VrdE1MMzBwVk9xZFFMUTdzT1hBTDVObHRsNVdhYU13S0lJaW1a?=
 =?utf-8?B?TmQzMDZYUWp3R0NNL01oeXI3cjdiWU5VWjhIcWR2bFFLdHFUdy9FNHdaYmxP?=
 =?utf-8?B?dWpLbDNHc1Q1d2YxalJweTlWNFkzL2xBUlBHdWtJcm5aUVZJSUt5OTJvUDF4?=
 =?utf-8?B?bFg1bng0TXhYb1NzU3UxVkpLTGw1ZFN2ZHlJSEgxbEVBWmFOZ2Z6RFd6dU55?=
 =?utf-8?B?L2hscEYvNWpWRmQ3Y1doTlZjVFYyUWpEOE12alpQaDlNMlJTeUxnbEV0cUFm?=
 =?utf-8?B?Q2N4cW04Mis3SmFBL3NyWWZlMUZCTTh2dG0wNGVCTkM0QXZPakR5MXVJUVVR?=
 =?utf-8?B?bEVlM0FnaDRPMDNZTzd4alowV1RNam44WEpFcnZZZlpMcXBvYUVoeUpJMFlQ?=
 =?utf-8?B?NmkrcXF5bXZOQVg4ZjRHb2grYXVVcDJlZ3U4dU1FdHczSXo5TkZSWlk0RTZB?=
 =?utf-8?B?OGNldzc0cGdoSTZ5dklKM2Y4Ym12Snh4ZnZtaVd1andpMHdHU2NqUkF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUcwak5YUGZFMVdZdEtzM000VWF1d1k2MGhVL3JrUXVFZSs1WFhnMUtuaHgv?=
 =?utf-8?B?aFZhK1VRd2dKVHJGNHViS2hVTXVpQnhUTGpCcEMvdnN2NlcyYW1nem9pYmJq?=
 =?utf-8?B?cXlXeWFINWRXYVA0YU8ya21vV1l4U2tGbXU0N0tyMDJuYkQySzhoQjRRcUQw?=
 =?utf-8?B?VDRpdnhMMmNEZXNwZGd3THVsZzgzb3lqdHZLT2FVaVZxVTEzWVVCNGtYVG1t?=
 =?utf-8?B?VVRacGdLZlE0emVSMEphMy9oVEp5RE5mQXdHczkxL1RwcDJDUGp2TlY3Qy9Z?=
 =?utf-8?B?anZoT3ozSjdLaGgwcG8vU3NHT0VoZ1dRb3djTDMwaG1Ob3lNT1RRRlpETEhx?=
 =?utf-8?B?Ny85UUFLd2cxamgydDBBRVpWYnFIOWhEWTNRQlJYYTE0eWJNbXFLVjFuTWZa?=
 =?utf-8?B?TWtWMHJXL1pGS0JKRng1WkNVNjVWVzRDT3FBUGlqRTdWUWxEQzRaZXUxYUo0?=
 =?utf-8?B?Ty9tQnlrSnJxbThFLzdMTTR1bEZWbGJFNFA5bVZhYlZ0cUdqQTRQM05tbU9P?=
 =?utf-8?B?dXY5aDBYeEVsNHNiNlJLYjkzd2RhZ3VyU2tVcTFuS1FPY3N6WEFXeHRNU0ZG?=
 =?utf-8?B?eU8waFlEdXdyYWEydERGbXo0UUdvT1BkaW5lays4YkpGSjlxZzB1QTl0c2Jp?=
 =?utf-8?B?WCtMWDc5SlpXVWdsZmIxM2tHSkFUR0t3T01VRWNIdzhjbnFidHRNUmg4YTVV?=
 =?utf-8?B?YXlCNS9XZFVIL0VXVC81bFdxNzZhTkRJYkVIU3ZvYkhXTXB4Yk03Ri9JYlo3?=
 =?utf-8?B?Y1E4Rkk2MFBpK1VRMHc1cUNzeWFvdTl0QW9sL1o3S2JVUVZvNDBmanhMenA4?=
 =?utf-8?B?UWFyOGs5Tk5oQmtGQkRRUTdiTDRNOEVXNXVCeThFMFhpUGhMRXBXRy9BbHBa?=
 =?utf-8?B?a1pkM1p1OVRSY3ljQUZxbll0WjhZR0NxUG8rUjdDRTFPVFFKN0dmZnloSjN5?=
 =?utf-8?B?MU5lT2htdjRLSDVFRnJDU0dHMzc3aVVNWm5IR2JvbDNQcDE0MzVrY3grVE5k?=
 =?utf-8?B?U05RVGx6SnJVOHpVT2FzcUhPUTAvcWQ1bmRmVVlhWjJvK0pPaURwQjNsZ2xC?=
 =?utf-8?B?bFV5L1ZWWnF6LzBSWnpPdjVMd1N5aXZyZ0ZlMjh6VTVEd0wyczVWUy9wUkdy?=
 =?utf-8?B?a2tPb1lqL0xOOXNieUZ6WWUzdDArRHdHSlpYYkFLSE5TSWRrQXRsRHhUNTc5?=
 =?utf-8?B?TGsvYmFxcEtYYVphaVk5eHU1UysrV0wwOEtvRlhlbVNURnllOCt3bWhZRld3?=
 =?utf-8?B?TkkwOG1FTUpMbmRxd0xwYUx3dS9tM0NiZVQ4VU1yOFNya1ZXR0s3TjBuV0lT?=
 =?utf-8?B?UnpDZ3JHSGNmRmU5eHlHd01tdCs3MkRxT1M4bzVKZWEwM3VzTlVQRXd4b0NX?=
 =?utf-8?B?R0xxUkhOempmR2xsUXVEbjM4WWNPeElvVmp1V3ZtaW9QM2g0YWRBdnp1MjJR?=
 =?utf-8?B?REhQcXY4VDFNUFB5TWdrcmE2bVB5UG1UOVF3dVRNa2FXV01tTnJKb0t1TnlH?=
 =?utf-8?B?ZjVuK3dLL2orcUN4NHd5ZDZPSy9CTVYwd0dXMHBUL3dXcFVJSkVrMTJlU1BB?=
 =?utf-8?B?eXB0bC9SRWtidE9PWWFNV1N5QTViR29ZaXcvODQ3Tlg2d3Z1Nmo1STRkZXY0?=
 =?utf-8?B?MWg4UEd3OTdQMHRSNllDeEx0b0hJT0QwUEpjdGU3VzZGQXBZNWdDaDJhQjl3?=
 =?utf-8?B?UTJSelJ0NDNzRzlDTmNYcGp6U1dVMFlWbjl2aSsrSkg4c011bE95OUFydWhm?=
 =?utf-8?B?TXNMcTNYYXZjdTZramo1anJNQjdYWk5Uc25ZYytHdm9rb3h6aC9mdGw2L1Zi?=
 =?utf-8?B?eUs3S09GRDVoMmU1Wm5uRHpnU21hS3JSWXMrcCtvOHJaemliaDBKbnp0T1Ni?=
 =?utf-8?B?RDhNcW53R2lCV3hTUlFhd2h5QjlFVmhHU1dveGwxaFdZdERZbG16M2J2TVRL?=
 =?utf-8?B?OVNKS2dvMzRsbVdJd3Z3N1lmZ2VCc1loR2FrbEhUQnprL3FVWVFJRC9ELzhV?=
 =?utf-8?B?TUY2WFluekpMMnAybnd1Y3c4SDNuYUVEYUVoQ2ZlY2x4Vm9ibzdEUUQzUUpo?=
 =?utf-8?B?TWVyL3NjT3g5YlBMcWdEbmJUY0Rod2dqRkRmcU9VU1YvejZLREtsL2lkUEhn?=
 =?utf-8?B?YzYxUnQ5WWZPQUt6MWxHRHRzcEZxb1QvQ3R4NkJwaCtxeFgxOG9Ocm96UW5l?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rIu/m51wMbESl9FcvMlSLF8p4Q3j8J+MGc5LdZvaiXmgoHR+7D+mKzries/ry9u8crgUhnUTHa90o+C8sdcuqsUkKg9HJ2rwwoaQRXAHFl2AwFZCG4qGJ1mMeboJBO6uibNipffQ/k29BN5WwvHNR1InC+VwiqCawAlWwujwLj8GuIxWNpR5gjzvkUKuiOGP0/QHd51PrgS6b1K/ZBN2AjeRZcCLkcVbZ/Jp8xZuAmkm4QCC7ul7OWtEGEbAALdqVIO1fGujheGPOI+v2l8y0UzCeVbyvEG6F+C994fqxlqXDpwildhRBbkqMtqHQqrZIlfwzzOe1ST1LuuTqUh15oiFAwPODwIqzTttJF084ekHXMRTjR+Abne/bLB5dY0Me8DPDZZfX0Jwx8AxBJ9oVGqts7MccS0IPabpwWisnYzXXv6iWiXMkvDz3jxbQyR51ywnadv0X83ErBZrsvJdaLtVBduDmHQYRqd1+1g3vZ6M7susRGGJb1/5xBDyZmfcgYm7FS8xfJ1noQ3vznyp2ZU3Jq6JNDjsntvYrAGtMBHAz3s19zxeLx0y+EZx/AMyDT6UdWwcR/tS7hqGd4qzjz5T+x0yLoUqyDg86IC+sFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564fe114-826f-4627-e58e-08dcedf96178
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 15:44:12.2708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlOydGHQiN1BW4E5f0E/TCeWB60EZ52mbMFsyyCgnTMXAx4ZFAfuGAyOCOUUMSfj7Iby2+c7PXW7swsT8MeSCrpKoD8AXTK8ebVR0VPvkxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7620
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_13,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160099
X-Proofpoint-GUID: GUkhSq5CMAXeh_HT67utO3IkIfbBuQT-
X-Proofpoint-ORIG-GUID: GUkhSq5CMAXeh_HT67utO3IkIfbBuQT-



On 10/15/24 13:38, Bart Van Assche wrote:
> On 10/15/24 12:57 PM, Himanshu Madhani wrote:
>>
>>
>> On 10/15/24 12:15, Bart Van Assche wrote:
>>> On 10/15/24 11:39 AM, himanshu.madhani@oracle.com wrote:
>>>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>>>> index 340785536998..b74c3f505300 100644
>>>> --- a/drivers/scsi/constants.c
>>>> +++ b/drivers/scsi/constants.c
>>>> @@ -403,8 +403,8 @@ static const char * const hostbyte_table[]={
>>>>   "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", 
>>>> "DID_BAD_TARGET",
>>>>   "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
>>>>   "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
>>>> -"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", 
>>>> "DID_TARGET_FAILURE",
>>>> -"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };
>>>> +"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST",
>>>> +"DID_TRANSPORT_MARGINAL" };
>>>
>>> That doesn't look right. "DID_TRANSPORT_MARGINAL" occurs at the wrong
>>> position in the array. Please use designated initializers instead of a
>>> traditional array initialization list.
>>>
>>
>> Can you elaborate? From what I see, enum scsi_host_status{ } maps to 
>> these strings. So, accordingly, "DID_TRANSPORT_MARGINAL" is placed 
>> after "DID_TRANSPORT_FAILFAST" in this array.
>>
>> Am I missing something obvious?
> 
> The above patch places the "DID_TRANSPORT_MARGINAL" string at index 16.
> I think that should be index 20 (0x14) instead. From scsi_status.h:
> 
>      DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
> 

Okay. In that case, I'll drop this patch for now and will figure out 
cleanup in that area for reorganizing this table at a later time.

> Thanks,
> 
> Bart.

-- 
Himanshu Madhani                                Oracle Linux Engineering

