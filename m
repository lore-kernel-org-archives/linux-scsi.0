Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A15290DBC
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 08:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750926908; cv=fail; b=Oymj4TS5PqOQGrGkHXN2Q2ApbWG8WmvejuDpaBK91RI22KtUFe2s4gP6SoQ/Xlm3k+LM45Owg6fdXCenbxX+80zGbtSy9HK13M5iZOHf5wtUwWOwMb+DB+3lrPJGtcJxSnxfZPjxli0ujGg4hoBU7sRio8UyD4q4r+xis9nEKNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750926908; c=relaxed/simple;
	bh=gsapujSdZjHPGJsPOG/LGTKKezA6pqWh5D370brj/Hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LChU7zIrPRK+Ls1bykrp0rqSbPiUh/VXt5aywEML5JkpOXSbaTzhwr7mxuw6bY7vaaQsTkuIpEM8e89lE0ASJCSCz4VWChAFGWULlfskB53wptVRn4H/R6zBKvNJENvPxvoO7XTkbb1tdRe9Ti1D5ikwAclsx77PGsBPL+j+kHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O/CODqjF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fXMEDbcS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/CODqjF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fXMEDbcS"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q7foda030842;
	Thu, 26 Jun 2025 08:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bKDRTgCSu832inww4WmyCmlz0DhKcRjBf+arVRv2ptM=; b=
	O/CODqjFMGA9OUkJZb/xeerNzboj1tjp+252phuHimg2YQMljz2S+6vE8fX9MjFR
	NEgk9fljTBFbRDDEGisdrM0QTKkh1Ldxe6hd3fYSOIgAWqyX8kOAzQPAWlx9Ccw/
	dDkVPtXM0QTORx5F2rUfoSH0v4lhCNXc5tVYCxN5DZPujJ5LqskdjBI6Dn3SBfUf
	BEYameFMgw1KJSYIqYQo5D0To1Clb/4VSwM7pCsQNuaE3Ci4t/7gBG/NNzXfB7Mc
	3Ycy7NLAfMwYHELPhQvxzkLbwO8mI4v50fGbJc8h7NDIA3C+vxMFbrFz4cqbNeDZ
	wd14+4phlykqLBfi3ejZBQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7v1e9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 08:34:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q7dZIC034638;
	Thu, 26 Jun 2025 08:34:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehpspw75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 08:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cW8/fc7ABShRKalTq+bkaBefq2hJewm6XsU/BFRHi7V1vTavxyoU06cd99JVPIynv1fZc7zHBGPNLZFpJ1tfuilrR9jdVGTVs2tZPphllSGC94pFrAKFDAAQOfHoDdtDcoQ4FcZYdxpsZU3Lpt3PfIRhaMWOjkBfFGeuHQPVhKZwguZKd/YmiiubLdILdhb3v99HqRLez01xSZX5KDQY5Ft4V2N9/7thlcPPDCUX+ey/Nqat27SrVVdcjl6kwrzKQCrjf3ZyGdeF4XxURDDunA6C+jna/J0mhWOovukNPgrQ4ZGv7Whfn4T+9x/M6nTziDC2kt6xrgXvXmYnn5xEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKDRTgCSu832inww4WmyCmlz0DhKcRjBf+arVRv2ptM=;
 b=lSYmHwCnDp+nN9WcseNcKFfKbkLX+d2oa+qYwkKMB/8jG/Py5qrUSgr8LoI3EqyouhrHbTX/LbGcxKuEVRdu+TVNGA/1+IlTPm8RnFGMZJtvAjQXZELsrN4WNMyHp2HZq4aWPka3cmoD77W7Dhp7o6LHCRM3yM/pSYaGAZoY3jm9nFn7JZVTGQtfyDNmMtR3JB8arQ6m1Yu0nXgVlvuY1gZrEXiGsVDwtgGnpi5UbthRVm5f9RBMJEBqkBQNKwT78bvPgXFQahq1G0Bj75ro1vGPiNfsrQeVsQ1WVrlQXuGMRs8CCF4XTuBC5piwMhqP7NFhc7nMQw+NiPYQUen2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKDRTgCSu832inww4WmyCmlz0DhKcRjBf+arVRv2ptM=;
 b=fXMEDbcSXTCLzQWCl3e1JQu5MU+IZAxDE7ZdxGNjUNT6lpcXr8EK3QXyfW0cXmwFOp/Mdcb04LOzeuuss69ZCu/yKJhZViWu9AdiTj+k3/ONYEEQMBhaHG9mTs6bQjhl7YT7helMvqo9nGGH2HNpTHd8UfnwxD41ENATsU+8svA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4286.namprd10.prod.outlook.com (2603:10b6:208:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 08:34:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 08:34:38 +0000
Message-ID: <f5d1444d-fa71-4b4a-9c58-031f158df4a4@oracle.com>
Date: Thu, 26 Jun 2025 09:34:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Use scsi_cmd_priv() instead of
 open-coding it
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-4-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624210541.512910-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0156.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4286:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d59c32f-359a-4a74-907e-08ddb48c498a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWc0OXl6TmxzTjRHeGd2WU1BMFJ0QVdYYWV4YkdncmpjOE9qR3lnbVVUcUg4?=
 =?utf-8?B?d216S2huSStzc3dlUUVQR3VlSjh1ZEgrczNjYWQ4NjBRemRSVTJEWm5wSGVF?=
 =?utf-8?B?WXZuaTNEQmU3cm41dWJEZ2tiK0RPL3owMGRaOUJ6REtpd1lyVkV4L1hFeWJ3?=
 =?utf-8?B?d0dYN1RZODFPcEt0T09ZRkhvRzd5U1ZvcjdHSU8wYnRZejhsVm5IbDloWmNC?=
 =?utf-8?B?bCtDREVTVnpjQzVOVzQrbW1yRjRCVDdkcTdNTXUyWlFNZTBMOUJGekRWSWxi?=
 =?utf-8?B?cmhXZTJBZmtqTU4zZkxvRFRWenJIejcyeHJ1aFI5QlFPWnZIQXZxeERVNXBL?=
 =?utf-8?B?eXVXbmRCdUJ0QURlNkRQOFVQbGtRbVNWUnRQVXkrR0s4ZFF5NWQ0bzhEUTNS?=
 =?utf-8?B?M05OZ1lJd1kzUEl3YjhQOGFJQ2ZmK1VvcVEwZjA1Myt0ZG02L0owYThqRmtE?=
 =?utf-8?B?OEJLRi95dFh1NFIyWDJzcGJUOW8rWXA0eVhzR3JkVGxpakV1TnBIVmFCb0R4?=
 =?utf-8?B?Q2JDZTR6MVdFNjR2MG9nalRmTWc3SWpFMTYvdzUyV0ErNnd1Zll5TzFmTTEx?=
 =?utf-8?B?S1ZMeWlNNTQ5VWF1MVBTM3pIdnY2N2MrbmJXZlVkb2Q0WDFNTHBNQVViUXFO?=
 =?utf-8?B?OXZaYWxOcS8rd1dhcVh5NkJkeThiMEFyV3B2ZU9venAwTGVLNXRxYndpVnI1?=
 =?utf-8?B?VVhtNjBKTVlpanZ5eFZ3TWo2VlFvMGI0VmpGM2t6RDZOb09kV3Q0eEZqaVR2?=
 =?utf-8?B?bVBvVVg4MzZrKzJGa2VJdC9DMGdaNkFlODJTRktGYVNhbEZyVUVmRGovdGhG?=
 =?utf-8?B?Nkg4OFpZbVFiTVFkQkowaXZFWTN3ZWlJVHBCK1pRSjdiKzdQZnVwVGZxSmth?=
 =?utf-8?B?SytxT1VwRmd6OTQvSEFhV0x3b3EzenltMitrc2RyVzlDM1RpMHZsMEtMQnM1?=
 =?utf-8?B?d3F5ZzhVd1F1Q0ZsYXRwUG5Jak5USnRlcEdUMVl5WkVrSm1XTG5xM3JCUXV5?=
 =?utf-8?B?aEJWNnRpVWYzNk5COXNkZThiMGxVaEkvbmlya3lVZjFBQU9FdGRoeFJUUkNX?=
 =?utf-8?B?NzFPWmRuZG5VTSs3czFDOTFiTFgwTllLNVFtZlBtRkdCZGhUQ2JJOUJ1SlN4?=
 =?utf-8?B?WWQ5d0k2dEEzbmh6TEo1UDU3L0o4RmlrL29pQnJRN29zTjN1OFd3ODRpLy8z?=
 =?utf-8?B?TThmZEVYUnUwM3I2T3puTHZaMGQzSU1QTDV4aGUyUkg2RGs5cnZwZlljTFk4?=
 =?utf-8?B?ZittR290VzlQMDR1SnRjY0MrT0tEUExyc2FJMFR6cXJZZ1ZoSE5FZ3YxVkdW?=
 =?utf-8?B?ZVNZVkd2ci82RHFEV2lENHVYUFIxMFFtZlVvdDRnUDhVa1BtN2ovUCsrRks1?=
 =?utf-8?B?YllZemFOQmZsUXAydTFsRHZaZXNMRlI5V0VSdXZIb1AyUElMZlhpSjVtazlT?=
 =?utf-8?B?WXNYYzhLdUFwVHJ6NU4vT3pUdHB2a0dYN1hSanFsRkFJVmNjTjRXTnI3TzBz?=
 =?utf-8?B?dmNBbXgyNUdNT3dZR0JUVmVrWS9NZ2g5aHRJczhUT0hsbHFBRWg5VU56WmZz?=
 =?utf-8?B?eDRtSFovZGluQ1J0bFFaQ3lxeXM5bnFmTi9KWTd6YVR1bXFMTDdWcVhNWHR6?=
 =?utf-8?B?OERhbUhlWm1EQklLZTlRb3AyS2psTmVaTnhWYVhRUnAxcFFBSzVka3BwckpW?=
 =?utf-8?B?Y3o4eEFNWTRoZXBLQ0E3WDFtR0JtQU1ROEtaU1hvWGlrcHRFMWZWRlNoWVBM?=
 =?utf-8?B?SENYbFBCWjlhRlYremovUjF4V1gyWVBXdlZoaVFzVlNTSjNJYS9SRHNQOGN4?=
 =?utf-8?B?a1NSTDcvdmVCOVJsMUJjMUpRd2swcTZtUWVHcE4zSlpWQ0tFSnlDaFd2eEZQ?=
 =?utf-8?B?OUhpeFFueEdzcVpHSDkrNGYrUnBvdXlsM2ErenJCc2dRYTl5WUdaTEhqSm96?=
 =?utf-8?Q?DeOpLIQ/LUU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eC91TUZqdEJIRy9HMDVHWkQvNGlMSnFIdFhUYVRPVUlNUlF0cHQvcENoMlRp?=
 =?utf-8?B?MTB1SE51cW0rU1B2ZCtZS25zOVloRTZFWXQzY1JHdnB2SWFTRlVDb1F3dGRi?=
 =?utf-8?B?R1VTQ0pQRnhyOVlobEl0ckZKekZ6d3RGWElMUE9VenBGKy84RGhIeHNTaFJ6?=
 =?utf-8?B?dHY5VnludmJock1NTHNzUG1NektRMmRubkJVdXVFUDNyelo2Vk9xYTRHM2g4?=
 =?utf-8?B?MHdrUDROdVVyd3J0WGhqQTBNTnZDZVNyUDBsamdJdWVsQ1gvUitZeEw1U2pk?=
 =?utf-8?B?SURHVi9idS9TR2I4WGlKT0pPNy9UTStDeFhCdGcrV1RFdnQyQURiMGJuemZC?=
 =?utf-8?B?MFJIQWFjQXdPN2VpQzR3cTZadHdxS3dzZWdRVjBxZmZVR0luY0tkQ1BPVFlT?=
 =?utf-8?B?bjAyMzE5K1RkbzFXb1pnN0pBaXo4eGVJZEVXRnUvN1Q4RUFOSU9vTlBTc1hi?=
 =?utf-8?B?Z0w3S1BZQ1RNSXgzcEwrRFpTZFV1TlJWUGNLcDNvOFlvZTVvMEdpckUxeFpL?=
 =?utf-8?B?MDVOb2ZUVzlrVFFxYU4rMzU0ZEpVTU1ueG0zWDcxblpSNmczRGdGMUJtUDg5?=
 =?utf-8?B?cjVFTk10bU5jb1RlRDBwVk5Ha2MydGRrNGVUMTdYMXBaVjk0SWUzZ3E4dHpH?=
 =?utf-8?B?RGRvejBFOWd1aDVPNnlWQThCTWEwc3hGT3lsbTVTd214V2MrNWYyNFV6VllL?=
 =?utf-8?B?UEZKZktOY0hrZjdKNjRsSjBHWEwzcDNZL054b2dhV2FSb3RYY1lOVTlHNkdr?=
 =?utf-8?B?MzVzNi9PTDRpRmhKeWtrVVhVY2UwWk4weWs3bW9vWEY1bHNDTmdISFN6TlJa?=
 =?utf-8?B?UHArWHZNK2Y0T0VHdFBsRmR2NjFNd29Ld3czLzAvQ1puS1kzTENzNlhnNm9v?=
 =?utf-8?B?RHR3b2xhU2dGQ2pkMkhmUnFmTkxXcTdSSDhSSlUxcmdaN21KMVNqU1NRQmlq?=
 =?utf-8?B?YkQxdnZDcjRJWFl0UGgwS0g0S0hpbGFmMmtXYUZiczJmZmcyTkNXQTB0KytI?=
 =?utf-8?B?eklhQTVhL3d1TEdCWHJVL0lHdE15TkNvYWl3YzdsVTV0UzRJUlB6ZTRCN29r?=
 =?utf-8?B?K3NrSmxvQ083Uld0NWlCZzA3TzBuTDRVWkZwYVdGZVFGbGJ3ZGJvUW9MY1Iz?=
 =?utf-8?B?Y3JNeTIveEVRTW5BL1BoYXZJZ010eXBxaE8xNE1RTk9HajZUMXFJMlNVaHI4?=
 =?utf-8?B?Q1lNdTYzRjBHYVRwNDlkSTRtbmZNNEU5VnM3WVQzRm05NnlTZUZtV1VKNHlm?=
 =?utf-8?B?aG56OGJkWjZoOS9OUnlRYlpSTWZnYWhmbGIwbVcwYzBYWnd5dFg5ZXl2eEth?=
 =?utf-8?B?UWZ0QnZqdHlDWWpRUTg3S2xyZEhsamdTNk9qRm9KSHBBUVk0b0xleUFsb0tH?=
 =?utf-8?B?ZUZKTmF2UkdlTDVPUDZEUkxtVnFJbDk2UEhpMGJqTER1RUY0Y3NBb3cwQ3Ux?=
 =?utf-8?B?K1o5NTFZZXZIc0ZDNFRJYU9KU21ScXJSN0ZtdVdNUGpFQUhqejlzT0tYbmdz?=
 =?utf-8?B?MFJ0TXRydWtOdnppVDhDTlZtREJVWlpRN1ZEb0VDNytvamUvK0xsNDd5aXBh?=
 =?utf-8?B?SUZ1QXltTFFXV0VaT0ZsWCsxYXE5aDRwcEhScFFiVUpDeTJralFxcVVYak9E?=
 =?utf-8?B?KzhaYUh6WVptZzR4eFIrVWg4Y2JZTnp5QzRWTmpFU1JGcnYzM3JoVkNMTTFK?=
 =?utf-8?B?ci85WTFTMGM5Ryt0WVNTN2xzWUcweDNXSGsyOGQ3a2hneUVXSkVSMkQzVE94?=
 =?utf-8?B?eTNlc0lZOEEzVnlFYmd6WGhTTHBLUllwRWdFNldDTWQ0SkROR0JWSzNLVkhJ?=
 =?utf-8?B?azRQSTBiZmh3b0NCTzZWVlMrSUxJblkrRXE4YUFjMGN0VWo2cTVWdFgxV2VH?=
 =?utf-8?B?eWt6MkJHbW1IZ3AyL2oyTzhLVENrMHNscEh5WnJxRmNyYzJtMHNjdU1vS09t?=
 =?utf-8?B?eDlGZ1BqRmtxWEV1dHpINDdFdHhQZSt3N0NSSlpKdEg1RytYM3FLSXJEWW5j?=
 =?utf-8?B?bURITXIzd1dRd09DU01hTU1HQlZ4SHpxQTdoTmVBRTJYTjl5MUI2NVVYdmJ2?=
 =?utf-8?B?YzJJRFgvYlJHQUVxaERzR0NMMnpIeHZaUy9yRkhIWU1sZUJWc0xCTFFjN3NW?=
 =?utf-8?Q?rTbAmuKe3Cnos+xC2y+Rn2b1P?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e4DXPx98GVLnbSijyPYbyNEstzeeMeRPAxI1ICnQpuWTuZatXgQUHvLdl6vFOEmZpxbX56DLJJZdn0JVqLSm2GOOa+1dfNBVzrfn4v6VGz0pa3jczqjHLrHPO2klg1/IgQaU9Jy3CNvkDGK9GT1mXRawzG+H//Zz1WwJ4hcdcGcmTWsWV/bKz17U6YkMsKjoSzDOtzPEERgkRCCx3U00/Ubld1q+VzjlITKjPe2TWmDGzeVs6go7NFPmCeLXtB+qh2Ym+1j2XetPt3UfHZBHUEmEau2/IoIjnyX+zM0iwMZIYdQpHAIYkWR/x1+w8GoOECOA8lWYj00AtMIQpznRFwfLIpZ/8bfKrw0/Dd9bTb1ttRfzu7oACRJJNin2r4kjvn+YFxuWZIn1W996O9yn0ETOoUa3LJoyO+Kwpdlyc2vSLuqBUvCBUurnrYK121fz1i3w5X5Zg6aY0hyZrAZiJ6N7jrbg9FlZ4CNm9e0nQvnVIyLZ0q6u5p71rp7hfcMkWIZVckmJzODkfHSaxxV8l+ZV6CC/lI6Me1r8XwMNH6HBfTrpnQjnewdiZqHYwFBiRqjJXh6850WMC34KwSw9YuS1Ma1h8VusDLvSA6uPCvs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d59c32f-359a-4a74-907e-08ddb48c498a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 08:34:38.1643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lyGmMzs14XN6nGX0N8VP24R3xoNrq62f+dmlxaQW86lalbHRpnwRFdgoTCfUF8YAPq/WHNi7e1nX+RVMXjNDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_04,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506260070
X-Proofpoint-GUID: CUhgez3Bk_e9O0ww6w23UG72o3gs6eg3
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=685d0626 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=lMOn3ahnyLQvr8sw5TkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: CUhgez3Bk_e9O0ww6w23UG72o3gs6eg3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDA3MCBTYWx0ZWRfX4Sdq+VGSwhPE CtVQhvFk1NdY2ulVQYzPnnflTQ2gqrIhx2vKpztiWVIrC6ER9baJTdjq/SKf6/nVk1Iza4GuiJa TtwIYlMTP9YwfXib9a+AgpWthczkF6l0EWfvNikKuzlLtVgbbt/MxO7xsEN0Kf2LKRkx6Y8gsU4
 MMlWh8n97C+XXtJnA/syevP7fUFTAHVwMJ2EA6pP0ZY2/HvGZ8m66TK9oKxNDbu2yuo32F7g40J 8h9pdJfohdMB3dxdrHLImoNSC/iDRABxTMGXpG6vNFxKJ7oivOxyLS1y4dejdAM61kOmBz+DlKp vLxG+jZb3K7wb9FRD59AkJG4FhGgaBhTEY8uyKX+Z4AvDiTexl5Y4ZQI7cUb5wZDrZ1ZQoPhvQu
 b8mYScdQpZ6qPtKOpdGhSJfOko13zX/cUBoctcU80JAAJ5vDkuzOS4eFTEINKdcde3HfJgsJ

On 24/06/2025 22:05, Bart Van Assche wrote:
> Improve code readability without modifying the behavior of the code.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

Do you even need to preceding patch for this change? cmd is not a 
pointer to const in this function AFAICS


> ---
>   drivers/scsi/scsi_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 144c72f0737a..0c65ecfedfbd 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1843,7 +1843,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	 * a function to initialize that data.
>   	 */
>   	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
> -		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +		memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
>   
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
>   		ret = scsi_prepare_cmd(req);

