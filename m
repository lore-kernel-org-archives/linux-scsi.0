Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62625FA13
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760959580; cv=fail; b=sd7kOqLlfwVxv2+jziYd3x1Re+dMhmXtETcGnasUzbVvtMySoGEw7073U0rR6cQlJ1Y7ClCcGkXBEBDIRh5JjTWebk+GFgyD5vk2JNwIpWyAgXugmYvAipUrycYEgqa3yQ0dyYDSX4jSpgNfzLzPA4fWrdSiTVELhtcR8Mz+/Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760959580; c=relaxed/simple;
	bh=ZWSrAfMGKJ0UYtSXpyRIo3JcJTHEGNlIFMuXqSuKkyk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CsZ/Y6hX+2KI9j/0KxGb43T5lQkBLJ034JaaUXndJ9aDBWplFjqdZ8OtW/+Ymkh4Cee0kIRZihpVaZ7xIbnxZEmMu3TL/YGw8CkcSUDfEjddwNMoDOj5LRKAa3rg1H2Bh31RvVunqiTMd+EsQ/rR7y4h6Kz5S1cJetZ5xY9Tg78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q1E7PxdS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GFQcPscW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1E7PxdS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GFQcPscW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SQkD025951;
	Mon, 20 Oct 2025 11:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wK38Wu/0zQ4TaZTAvkQzfVetWDHJB47QVp+gWGRkvxw=; b=
	Q1E7PxdS90E8GY6aQ+kTTzoGV0a3b2a71rCk1r1UItuSFAaHMtlN3/RVPTl56btQ
	0SWFo263MEU0ZJRBY5g8ZQfwZo3VWykWS8tScFedutZf3PhVJKY/O/x8JYNxc6Pz
	QUNRlm90YeInTO39/zFatRpBf/o28n2XbJEOa+vMejSlToJYl41iOqmh1EgMQzAQ
	pwgsHQAOzt+e9Br9cbpqfXgApVpCsuoQ00qcoIRLp8jGHz1+QWULb0Fli8z7RMV9
	4KwFyDcsCtNeKM2OZymtVtzuU5pIx1d0JaAqRvufLN1zMnwceqbFpc6WGGmB/kVf
	mYwRepGjLF9Pz/XTFAa7nw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3esj1nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:26:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KBGol0007224;
	Mon, 20 Oct 2025 11:26:11 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011029.outbound.protection.outlook.com [52.101.57.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bau42r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W2govVl9Z8yO26Ga+7JnuhgfjpiYC6alqAeOQYjklcMl846v8uJe9tOYUcM9N8pIKGVnp9KmkZKxR2AFFNSS9qHRWSeU2C1iwLtBunsrz6GtxEuNMQGr68zjlsWXOkuwaOBKPq8n6z9Hz3doO+bwwWK18Cba39R6kjcjXhh2Vs1b+zTM3yp0IdZiKpEZKvAQRiwyKqGIw31uxcmprBw00nOdp4jogqMkABRMag4Nt6gmUhelVhK+9ivjmO0rPh2W124B0K72Eg5u9l/Tm/2Yu0ADfpCkv66VwTe0ki76Tao8+jtWYmRasna5/MWtz2DIUuPtiF9sypPpRMLNAWhmLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wK38Wu/0zQ4TaZTAvkQzfVetWDHJB47QVp+gWGRkvxw=;
 b=r4aVy/Fz9fhniIL+9SjKFyRX+Kwg3dbxNL3/WtMKjwApRzJre8St187vWp/dDCO3ItBYoTeosDnCqN1Zd27Ywdh786574IK4mmr3j2+yMtaQsb/VzucJ42wMX6X2cid4eCmKDdc2XPy99LzisaVFIsELAbl+WrcUZTlBDczxdgEgmT66NsMxBthDMknBBlqvMfWCID0iAv5Qc/gK/a2T01Zp8nVGaLh77ar55/XqMaikqCd/IxRDUqf2jZbswaYXpAIpd+3v4O/IZiah4xs1d1lQ1Y7zCGuygwA2CRNajNwddgadIf/vvKz+Fu0fX3UeywIrSR738BdBk50oJvQBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK38Wu/0zQ4TaZTAvkQzfVetWDHJB47QVp+gWGRkvxw=;
 b=GFQcPscWv5H8mSiDN7nRC0f8OnaWslqhvmsOZ89qvcbbtH9CLTdhoa4tso4xkVDZtZAe4paiGY2U0fRcSRjeVYdH5djk75FgupiKa9NDm6/l6VtQfaJd26ZcWqQrkgPwG2LoZWzJhjbgInDkY3PwL1wuWSh9rIiWilHABvcd18A=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH4PR10MB8225.namprd10.prod.outlook.com (2603:10b6:610:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 11:26:07 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 11:26:07 +0000
Message-ID: <c3703b46-fbe8-415c-85d9-1e035d2ac467@oracle.com>
Date: Mon, 20 Oct 2025 12:26:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] aacraid: Fail commands that are not submitted
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Gilbert Wu <gilbert.wu@microchip.com>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014220323.3689699-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251014220323.3689699-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0134.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH4PR10MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: 97215ac9-0dd3-4e65-fb70-08de0fcb763d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VmVvc0JPRzZRdVNsa2JrekhtWXNrelBha0dBNU9uWXVFM25KaXNJcWUwcnNS?=
 =?utf-8?B?MzNSVlFGR29QR0ZmTlRZTG9SejN5TXdEeUpQaHVsWDMwK044U3ZQTEMvNVZn?=
 =?utf-8?B?ejdiQTBob21QbGpQbGN0MXN6b2cvU2YzNjZIeTFQY3U5akNvMDVITURTTkZQ?=
 =?utf-8?B?YkEwb3VQbXBxdUNwUkhia040VmFxQWxoVFVNaHZ4TEpIQTUzbERjOFhCUkJV?=
 =?utf-8?B?R0lpTXlaSVJwaXdJM1JQZTkvME41TStmSnpBSDVBa0UrWlIxN1d2b3Zvb2Jw?=
 =?utf-8?B?cTVGNUdFMnRTTDJ1TWlKc2dKenB4YldJTkY5cldwQnNQT2JYdmx5d3ZldklN?=
 =?utf-8?B?UUhFMCtCZklCck5ISkRFWjN1V3diaHBlb0lEVXg2Um5sUkxJalN3UmQ2NHda?=
 =?utf-8?B?VHY2Mk13bGRueDlYbnpQNEtoWHF0LzI4OW1XeUZQTTBWZ2tGRVkvaVA5c3o5?=
 =?utf-8?B?Z1ZPWnJmVTFoVW9yNTlJQlV4RWt3YnJNREwzTEV0SGRkSzdreGxUSyt5TUV1?=
 =?utf-8?B?VjU2bFowdDduOTNVUHRVYVdDK0ZnQ1NHUVB2aFROK0ZSaTR6M3BlSlVhNS9Y?=
 =?utf-8?B?b2VhcXdRaWl1R0V6ZVJZZllNOGRtalg1Z2xCWVI0eVZVVEFydi9OV1NGUHVQ?=
 =?utf-8?B?enhDdWF3VDFTRkZHcWI0aVROdko1UjFsbEVtcVp2YmNNRTFCbVVTSGI2RWhk?=
 =?utf-8?B?YlBLdEd3aUp0cWYvSlpZRmR6S1EyNkk3YmlydnFmSVpZTnRCU3BOdHlMQ3B5?=
 =?utf-8?B?cldkeWNqWXlHZzI1SjJybkR0anBNVUQrSHhJV1UwdWxUdWNOZEZmOWtsenJx?=
 =?utf-8?B?Q2ZMVThpZkFkQ2hJUllPQitjMGsxSXVhLytjc1pHclRMaDlncjdwRS9SMmdj?=
 =?utf-8?B?cVFQSmNvZTJjZXVZVXlaa1Qxb2JNOWdXQXVpU25NTTlTRGwrNk1lZTVjcTFR?=
 =?utf-8?B?cHYyazhxWExrR0MwRXBXYXg1T3d6RzZvNUNRMFlQSWg2YjlZYXN6eGxqLzNN?=
 =?utf-8?B?NU9ZVzhLUDNqQ0FEK09mUWk2NUZ2aTRneVF3V3pXN3lFOWhmVTZhbGVjTnV3?=
 =?utf-8?B?L1dHNGtOKzZMM3dRamZ2WHpkUGxWY2JubUJVeGNnQlNUSE95bHpKZkRiRHRQ?=
 =?utf-8?B?OVNOWEVqN21scUJhOVZIK1ExSGt4YURiVHJuaVZTV1lKLzFUMVdrMFdaUHMy?=
 =?utf-8?B?SXRXcitBMktyaHd0bEQzaTZVaGVGSVREMm5Od0pwUTRnVWdyK0xCa1lUanF5?=
 =?utf-8?B?RHQrb0xmcW1JemwzemowalBTVHZZbG5YY083NjcrYytSTnZybXNUKzMwY0No?=
 =?utf-8?B?bVRIUms0ZU1xdjg3SVFYdzNnVWpOUWtEVUZOZ08xMjd5cFltaDJjVkV1c2VL?=
 =?utf-8?B?TTZ6MXBpbzZGb3pJd2FOZmdvRlhFZ0ZTMGVCcmpPb2FQNU5zbTRLUVpVYjhq?=
 =?utf-8?B?WG5Qc01CQ2JyaGwyUkVXNEJ5Wkx0WWhRMStYQXY4T29jRnRodkNUbWRVRXNY?=
 =?utf-8?B?T2hLQWtpZHR6aWwyT2F0dVFabklPWk5BN2srZklyQm5TQ3lMMis2MXR6MVFU?=
 =?utf-8?B?NTl6aWdJdlZmK205VWJwMXhBRWk5OGthYmNKTFZoN1c4QjRrN3ZQenQvZzN4?=
 =?utf-8?B?QkR5dTBMSlJ6SzNaYjIyS1FUOU1UYTU0OUN6dzNUbDY5SUVVSVM4aGxXcWRx?=
 =?utf-8?B?TlZYUFJPbUpmVU8wVUpTRkJ3RncrU2RLak5rcFlucko5VnVJaTFSZUlXbE9R?=
 =?utf-8?B?N1NDRjJvSlhGU1hKeUtnY3QyZFExN3FnRGhYeHpTTWxGQ25SRHgwdm9aN3JV?=
 =?utf-8?B?SWltUC9VaThtN1NRM3ZWVE9IVHV4ejh5Uml0ajR5Y2VyejBqd0c5TFROZ1pS?=
 =?utf-8?B?ZnF3RS83TmMyMDlxL1l2Wk9veXBUcmViblBtWEV2dmMyRE56VWNVQmpkMVNs?=
 =?utf-8?Q?l5QEoeyS5ij9tEZPpu1GqJ+aFlZMn98T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWVLd1VwcHhqamxoSHdUNFpYTGhkYWNaaUlsUXNBT3dIRXg1MmFaelgyZll4?=
 =?utf-8?B?OHhmNW54SCsvbUZYaEw0YU1Ma0QydDZGOU9zV3gwSDQyaWN4VGFWQ0ZpTnVX?=
 =?utf-8?B?Q1BlcVBIa1ExeDNWSy93dCthazlINzk1U1VuTFdxM2pFM0VMYk53SjlYbWE2?=
 =?utf-8?B?ZElqT0VSd0pqcTlRUklVbTBjNld5Vi82MVhhMjI5cENyb081M0doQmNkc2Vy?=
 =?utf-8?B?dU5tRXNGTy9PVS8rK1d2RWMzdjVDcDFvQjhvelZqYldFSFRtS0hsU2QyYU9C?=
 =?utf-8?B?Y3pOZjNNUFNVaExsNS9HK2ZXa0FPdUZ1dUtZZFIzeEt0eUgzYkVUZ2Y4QndN?=
 =?utf-8?B?Wk5YMjRpMFExb3RrMVNsOXdja1BmeGdyTVhZRlRsQ0tMb0JnUjMrVGx4K0Vs?=
 =?utf-8?B?NEowTlFoSDUrbFdvdzVOWmI4OXI1VS9xejhGVGd1eFhKT1lEeXhPVS93MU95?=
 =?utf-8?B?SHF2SmhiYzgxOU8xK05SRXU0dkZOeE5UZERsWjlKSlZ2RFpra01wQ3UzcG1C?=
 =?utf-8?B?aVk5ZlNpS25YajI4N0dGcTdrcWg2TEk4UVNidFF4N0VkOHZtR0xrK0V1R1NS?=
 =?utf-8?B?WFBydlVDL1Jwa1NDc0o0QzVURnJDbWN1RUZKQXNKaXQ3NERId2F5NDgxVk03?=
 =?utf-8?B?NXRsejI0bGRTc1VSRWNhQ3c3MFprU3NVSkhXdVRjQzlQazdzSjMxQ3d1UWpr?=
 =?utf-8?B?a0xrM3FqYnUwcWJPNVpHeTU5ZVJmdXNzQWk3ZDZ5RmJWTGkrOGtaTW1vZE1G?=
 =?utf-8?B?S0w3VlQrRmN0bUpjbW42d1dDcW1vamc4cnBIVTFTalB2STlQWUl2T0RwcWY4?=
 =?utf-8?B?RkwzQmVBMHJuOFVGdnh0OXI3aTRTMFBTODMyUnBZRURBTjlPd3l4c0ptbjhr?=
 =?utf-8?B?ZWMvVHZIVFRxTk85dFpUNGMwL1loRHowU0NWNWVKVXpUNmNFdmZDL3dMVExD?=
 =?utf-8?B?MDZPRUVndkpTTThqZTdiK2JQYTdUdjNvZ1hpVGp3emRzdTgzQzc1Tzl3NjQ1?=
 =?utf-8?B?SjV4eGF0MDlhUmd0aWNqaGZWaVFsNzBjOE5abXdZenRYYUZhOTNmbWpHMVln?=
 =?utf-8?B?L2dnQWU1a1Z1RzBSNFlSQ01sR2tWUDc4cG9aUUZJRmtURWdYYklIUU5BUmhS?=
 =?utf-8?B?dzFPNXdrWjd3QzMvaEU3d1VJZ2E2NG5Tc0RxZnVvK0VnZnY1M1l4c2psekJY?=
 =?utf-8?B?UnowOUdzWEN5U1IyUExVSEJmUndRNUViZDlLUUxCcktWNlJ6SXpGWFBHN1Fw?=
 =?utf-8?B?MzVIN25jMXdOM0M1T3RvendUbWYrbjFQSHF6SzZURFNhTncwVW5mMlROTXZY?=
 =?utf-8?B?STdqTU50Rmd3SUVUVFpIeTh3b0NacFpGSGEwUXozb2p0Ri9YQjVRZDhMaW1O?=
 =?utf-8?B?T092eXdVa0dYVW9pN2R3QzhMRVpPVjVKTEZNb0NHN2JBKzdCMmdPNGVBbEdB?=
 =?utf-8?B?WGZEOUttaWh4YXpHMlJnNDU3cEV6NUQ2WkJ3Y09tcGZBVGJ0UDl1SzB1Yjh1?=
 =?utf-8?B?Mm5GYTJLY0w1UWIvUTZ5V3lITk91Ykh4bDBwQmVsTk1XQjVwR2FETDhjUDkv?=
 =?utf-8?B?N09LeTE4NUxRVHlLbEo5NE9WV1BUSi9meXJVd2VHQVNqdzdLaEtIYTBqSVF2?=
 =?utf-8?B?VzB5bC9uRFZvU0xlZ0hJdjJQeW9aL25PV3hIdnpRTkpDWEdsNnl0MjZVUlNE?=
 =?utf-8?B?OE5IYUVZRGxFdXVrdHpzTkt4ajdUTkxXdGtUZU42a0xFbjYwSWJ3dzh3VUxR?=
 =?utf-8?B?dDYwd3MrMSt6QnlRelVsUlNUTm9JVXlhY1pKMnBxbGwvWWV0cUR1V2ZRYnJQ?=
 =?utf-8?B?RUVJQmJFdWRzamJFZjNkSFhrSTUxTklXejd1bndweThSRzRFWGxuSTNNNzRX?=
 =?utf-8?B?VzhKN1lsbThqTnJBYk9SMVJqSW54TmNDdGUxYjVHSlVXdnJFTWhSdk1KbWlF?=
 =?utf-8?B?emlPTXpzeEJrUjdodS9YSkJwenMxRlFjam1mKytoOEcxT2VrMkl5aVEyYVEv?=
 =?utf-8?B?Z2tMQzlRaXJGWVZDcGtMWEdlSU9sZWJrRVVjc2FGT09WVjhqQUluMzFqUDBH?=
 =?utf-8?B?UDNVN2pMdENEVVhJVGlZVnFJN0xMbUZ2MU5nTU9oTXIzWEpScHdYN1hPRVh4?=
 =?utf-8?B?ZnpUakhNSHBJYm1rNEZHdE1YK0NJaFBhbHBHUXVFMzJ0NEp1U0VyK002QVRM?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DtIw13cZUsy32wcrT4QjwsC0U9Du5jGe9mRfXlZ+jdbB05JxvGjZbe69vpKbfrpP4wWVQxze64EfCtFWzUr1BS1BWeq2oYEsgJyETcKSqRLBT0n9hGtLpd4Off8opI355bBsTSb0FP1NU+xAi84j3eaK0RD7T0gvTW7g/ieq1QOXB21CSZmGxIK4+YXdyDljytU7x5o1ISJ/mPvUL3gDBPNrUXwnN4aZqozw5+mDBThpeutfnVc6R99h3d04pe8BeN6JQzNUoYsDef6gp7uqbZV25U7zKCfR6s4fadR33TCNssgrUT6JzCGh02tX4evHbv9j2tlsPxIyyKWlk5jBRBtUfOJPZisuU+CwBrUGyIxIn+0LybZ8lrWd3+ilyRWKDEuAR02HV9P9CsrPYW1lJhUnFxHBUBlugRzESc/OODL9gcJUnbg/m2YEKCjDHth+R/cROCmGhAxMRqnlqTtJ/hPgEnAxM9zu6/ttgPuhPmt06GwhhIVGpLxgswmY2FXn+FXj0pFd2W0/K1o4IqUdg2RLUV/2YV/JEUbBSqiAx8vFbYhL/8Rx+sDNFNdsPk+5hKDijcGz4ENSzJBWuzFBNO37mYpMaUEGdGmVoD/MN5Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97215ac9-0dd3-4e65-fb70-08de0fcb763d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 11:26:07.4599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fBj78byE/T+AdDw8FdML9AQ+k/ShUAQ5DosS2PGyZ6iEL5137mQM2zbkz94ve19W1T1mKT/32SjIcfqqPMIXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200093
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f61c54 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=XYAwZIGsAAAA:8 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=UysnF26r4dJj0lyhrRkA:9
 a=QEXdDO2ut3YA:10 a=E8ToXWR_bxluHZ7gmE-Z:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: JrieIL2bs5Isb7HjN61tu3gcHYNlXRYa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfXxwD7XHevTssM
 Tqx3r7iAhPGpODFTflnOIZuxppv/oYUwIPGlcnkEnixMaGPNfEyTFTs3uh+5s7968C+pnJeAIKF
 V/yTNlqNVwuOE76KVVUmNVJYwQRWl8PgJ7YstHCBLofWcTLcRKxcTMOv1cSSGxEszAYIsv+bl9J
 uc/riuYseueWUXM9Zitzc/QtQXZSPmVj4e6SAs3MKxjSfjzUwDXCm+bG2la9SuoxZ5P12ndTUJ+
 vBDf9UHF+YpoAtlnsDZz0IpkBuTwXxYF4OMWmnXSZK7Fd9NI9U5MI4XvaNjWHHNudiLKYlJyrSp
 aq9cgt8tG2XWJwWBfFcYJZQV9NwU60Nix1hakbqglOhOcJR+O3cgjiQb+LGWzo3XFYccJ2a6xBY
 6OFb5o3pcBQdStPgRe0isIBozHyEPw==
X-Proofpoint-GUID: JrieIL2bs5Isb7HjN61tu3gcHYNlXRYa

On 14/10/2025 23:03, Bart Van Assche wrote:
> aac_queuecommand() is a scsi_host_template.queuecommand() implementation
> and hence must return one of the following values:
> * 0
> * SCSI_MLQUEUE_HOST_BUSY
> * SCSI_MLQUEUE_DEVICE_BUSY
> * SCSI_MLQUEUE_EH_RETRY
> * SCSI_MLQUEUE_TARGET_BUSY

Doesn't scsi_dispatch_cmd() translate anything non-zero and not 
SCSI_MLQUEUE_DEVICE_BUSY or SCSI_MLQUEUE_TARGET_BUSY to 
SCSI_MLQUEUE_HOST_BUSY?

There are many dev->in_reset checks which return -1  and then FAILED is 
passed to scsi midlayer. Hence previously we would get 
SCSI_MLQUEUE_HOST_BUSY - are you sure that you still don't want this?

I am not sure what is being fixed here. Things are just being made 
compliant, but with possible side effects.

> 
> Hence, instead of returning FAILED, set cmd->result, call scsi_done()
> and return 0.
> 
> Cc: Gilbert Wu <gilbert.wu@microchip.com>
> Cc: Sagar Biradar <Sagar.Biradar@microchip.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Fixes: 03f295368bcd ("[PATCH] aacraid driver for 2.5")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/aacraid/linit.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index ea66196ef7c7..01156d1a1d06 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -242,7 +242,11 @@ static int aac_queuecommand(struct Scsi_Host *shost,
>   {
>   	aac_priv(cmd)->owner = AAC_OWNER_LOWLEVEL;
>   
> -	return aac_scsi_cmd(cmd) ? FAILED : 0;
> +	if (WARN_ON_ONCE(aac_scsi_cmd(cmd))) {

why WARN for this?

> +		cmd->result = DID_ERROR << 16;
> +		scsi_done(cmd);
> +	}
> +	return 0;
>   }
>   
>   /**

