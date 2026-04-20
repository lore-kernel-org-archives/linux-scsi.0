Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854E346777
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776710905; cv=fail; b=RWE8uVVbZRrgRTBw3PW2qfIK0aI+VME9vKKDYX6vgImM4F10Zfvz2jNbBXuft4T79AeRcr03np0p3/hTMeLeN7IzQXfgLP58m3LLCRZnZWhrRVFJsRCB6zBHRfiGDBfbNiaQslw0W6EKt80UHLDRDU7prIjfjNmz+b9Jsr9JvAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776710905; c=relaxed/simple;
	bh=Lh6RAeclYfiG49WTZlpjsyX9zG4wEJtlegmZsCpzO5k=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SmV/57DKYag/0MbCn5k2vEHKwux2m+pjm79pbFzJ6OrwUzqqWbi6iX+1MxqSpyA69HMbZEJ+vFcZ2Rc12Bw/jZ674+XivcjzIeI8kd6M3vXFxHL0rRl/HSF/oQnTo10Pkp+YtiHEksKTNZ7fse/kc7SKzVJ6rK00pRMpGLhAOoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kd9n4iCo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UX6R2c85; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kd9n4iCo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UX6R2c85"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KIMUSV950420;
	Mon, 20 Apr 2026 18:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0gdazZGmLA1u02VxyeogVKP/Gz7oqCJdjQsb2ryx93c=; b=
	kd9n4iCovDmKre4rPlG8WHcL2XkHGVkLCCbCOG1C10e8oOIEcFgNjrwjbgufB0rr
	kLnEwnE6lm20C+5Qk5zBkNrwJTzmZg6PTuYPXb6EgkgqZRLCX6rY/KmJU2nmYktB
	sSrYMmZahsHNEKEvdV98WBR8s5jAj9cU9wMmpBPOh0C20SheQRuOkKT3LIJd2MRU
	NBsqn18EVflVj0vG+ITCoArlgOQ4DOC7T8xI9Qmi+iCbYhShwBR+mMhLW2XGE1YB
	K10VuIO/77HB32BSPUtu63ZzUkSJWlHnhegrCqLS1TozN3E9vkOM7RmiWpK+YQx5
	u/gTX7GXsImn2JZ+m4HoFA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm27vuukx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 18:48:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63KIkDs7035445;
	Mon, 20 Apr 2026 18:48:14 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012000.outbound.protection.outlook.com [52.101.48.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn187jgtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 18:48:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S0Ta/7gctqQ2rCooaJarg34q8niGbpMcb2RfA0yBA5ePhsglYMvjmLVciUFChq2k8QMDKla5pyJ/Nx8lfoZF30AetWlE8Ee3jon278YRaHjAozO8wV5vmB6oxFz4wHBRRrDVH3q/HIdCFmgx8kKqF0Av6xYeWu/jfR6FtiVJAYK153D/UlQa50LQRUY3lu4byOQip8TNldMO3Mx4tDzbONUaKUl2EQigoPb9rEnjoITHTpX9v/7lsdblQctVmvoHgBnbbwPMcaV7zLtL7mr0DCQIp7oyEkE4HsKCu4t5CkwyIC8NHebOPCPUPXt93XyATdCcW+tj4bVTmHM/4mISRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gdazZGmLA1u02VxyeogVKP/Gz7oqCJdjQsb2ryx93c=;
 b=nDec/NMl6MVFiIHNmWBKv1CNRk126yOiTuVFnwjEJ2lKWBoKFoTuWyly+bKN5NVyhbby39EPkgVaLpA52bdQPonKpJf2gAo9oHGIeC5PHxC+iEnRvkDlK4cMQrXh/CVA4upiH8Lm4hFYrPRIcP4rnm2ayy+kFMv2Oq9/RCXxPPPxnvDlnCZ7LfPuFNm7EgF0KrhZ5hrI/JACUuKi/aPwiiQIIRN0Ky7xuVMjhoSDFsqhaDyeoPkHSpN0tioQwTCj36sRTvdnrI4DgaZmfsjU3cATr/kigrQj8ivgr9Lf8lo13yUHht6p+jEM9lfJBwQhy6LcWo0mjEG4Ectn90S7Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gdazZGmLA1u02VxyeogVKP/Gz7oqCJdjQsb2ryx93c=;
 b=UX6R2c85xEi59RYURGjs8xZ9J486QpO7ru8NywFNbP0wwJBrha75aB2phy7cenYzpYQeYDSuradI40vjet/15nq45YCiD67/le1p0b/6OSn9Ex99Y/5jIwTreKZWhk2qiPd5SxBnCP5Gpbfxe1LjOqkXOKyiARL2cRKBlv1VABU=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DS0PR10MB8101.namprd10.prod.outlook.com
 (2603:10b6:8:203::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Mon, 20 Apr
 2026 18:48:08 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%8]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 18:48:08 +0000
Message-ID: <853bd0b8-bb9d-44db-b871-62b314273d18@oracle.com>
Date: Mon, 20 Apr 2026 13:48:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: qedi: Fix command overqueueing
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-3-michael.christie@oracle.com>
 <197fd58e-2cc7-4ed8-a662-52120f39c5e2@acm.org>
 <b3234b38-7eba-4628-a7df-24cd7460df14@oracle.com>
 <b59beef1-ed3a-4eb4-a1bf-c45e5be2764b@acm.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b59beef1-ed3a-4eb4-a1bf-c45e5be2764b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR07CA0114.namprd07.prod.outlook.com
 (2603:10b6:4:ae::43) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DS0PR10MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 28c99a1b-0be7-4aad-33dd-08de9f0d5d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+wSK33GH9ydhlx+zglsWPJRy9hl6PgkpnLfb+oEBaPHNlrRN3q+BrQ9fmy/BZhjaMdr/x2tMoPo/YCvCNB7cg9LBjQ9AI7rZYKJ4izLIaTmLbXx2O2Wrqb6TI3KpSGB/s4Nm/OwdF+YBCL7rFNKKpBWlhETXy6YZIYDs5qBG199kPeg7QhsuXIVMnVr+eLGCok9bYSHsj0icmDw3AnIaaKJPJy9SPKVRPL+JiF5O+dnAp63h0gPd8Nf51yIc3skqr/boS++RGo67+qTCtE0hAvdnn5O94f6g0e8iaWPin9CbCAVZeaq6YpRakUZleMMoK2hlKPecKMgrJ49dw21683O+LXhD2pTKLTIEvEm9UmqYy9T5mdsyoCKDWIeg4K8HNddTx3Y93ojyGX8LSEzNxQxKkFJyA4Fzezj6NewWp5PIgpe0fvgeCMpraAEnmM+f0TPCGxkMzRMceoz8zoLhKgDC9jiDcBOx25Ajxjr5ZlizOjLUwkafEdppwWzRZiAwZIT8oPHiB7t7aSGcGnK/0VdEjbqhYeruO1IjSh+MRyLMN96Y4qUJdJF9avPZ3Rbav/GVDQBOzGSGTjErVAzFJ3vnpv3OpmYcgOEHsh4nuhTR7IU8w6XOkvY/6pyeMuHNm/s3AYxno2RGf8rFir2KWM1HFB2Y00oqPi4Ndd+8zNJQrYMltZBvvdY8lefCcJWrAuK5bVYp8hJP747D/CPdze2llepw8anqXsUMDO3x1h0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEV6Y25LQndtckF3cnBnMG1GTDI0UzgycXA0MWw1MFNZTTJWQUdzQnJ4c1I0?=
 =?utf-8?B?b0l1YmNDMm9Bek9IT0lvdStzQVRiRVI4em1DRSs1alR1all1YXFuQytnMGkz?=
 =?utf-8?B?TlZsZWMvM2hWZ0tYRk0vcE4rd1c1SExTU3hVai9tU3VHeURabWgvMzFKNVEy?=
 =?utf-8?B?d04wWE5JVFVsYnZRbS8zMjA4bDJFWGc0Z2RNY011U1NlQVBZcHpxL2dtSWUv?=
 =?utf-8?B?SXphbkZNakY1TzJHWkNaZ0l6SDMrcndoYjZrTEM0TXEwU0tPakVkNGtISlJN?=
 =?utf-8?B?dlVrdThybGY0STBEK1d4Q1p2VWZHKy84MDd0dVM4bHpIcDArcjA2Zm05em9P?=
 =?utf-8?B?bHVkR3krdktFZE1qSmFZSWFLNjNjNjlHR3dzWWJrQ1pDNmc2MFduS1YrcEo3?=
 =?utf-8?B?VHRvMFdZeU5uVjZ2dVNWdzhGSEhRK21kMEFqOWUvVEVDSTFvbng1d01EOURN?=
 =?utf-8?B?bEhyUE96T1hUZnhib0hybEFBelVXWE1yL1Zsd1dFa0JMU2pwbkFzVkVvK1V5?=
 =?utf-8?B?NEc0Ynh2ODAvcG50SlBuSGN1WDlOZEp6RE1EbVA5MWJQaU1FbmJoNzVFSng1?=
 =?utf-8?B?MTVQRVM5Q3RDcXZjOW50eUFCcWZyMFNCYnRnSzdrSzBqMFNXR0pwUDQxN0pT?=
 =?utf-8?B?eHlEaUZlR2hRVk9adS9mdElIT0FUT3dWZ1JWWXNtc1ZzdFJGNEUzWW8yaDNw?=
 =?utf-8?B?RGhvQ1N0U2d6RXI0V1dEYkFPL0FWTHg4OFJrc01saktVckZvZ1pEYXNFMCtN?=
 =?utf-8?B?bVZQMzRpelpJR29yL0tzNjRwKzFBb3Y1K28yOWpYT0J5d09UaHNTWWwzZHcv?=
 =?utf-8?B?dVBydHUya0ZPOEFaTXIxY0pycitERjJRdHBWQ05ESkhmNUs5SkxWYjZUdW1R?=
 =?utf-8?B?UVBDR2dJK0ZpWkNrUm1wYTZ4cU1VQWExdkV0c1NHaTFTNDN4dnhJN1hYcFUy?=
 =?utf-8?B?TU5sUk9nWVVLOHhpaDBlSFduZXh2S0h5WkVxNFY3M2VpMTFwWkNCMDZLejNs?=
 =?utf-8?B?aHFDNHJLTEFIQWs4NG41NVoyNWVGOTlDck5Yay8vaU8va3hIYUFzRTFWMXR3?=
 =?utf-8?B?UzVXTndsd1NqNWRrenNpdnJkRXp4ME01bXpBT0pEMHpsZXdoVlhvUUFIaGVT?=
 =?utf-8?B?RDZ1aWpsT3o5SXN3ZE0xZStNNWs1dzllY2dNVDN3YXBhdEVtTi85d0plR3NN?=
 =?utf-8?B?U2ZIeS9JOTVzK05tNnNrSERxVTVLcGZ6QkNLd1lZclZOL1R0SlAzcis4Q3Rh?=
 =?utf-8?B?WUFaczNibTlaSmZQSUt0V0hGcTRrQm1HeHpnNFo2UUEvNG9sTllWNVk2Nzgw?=
 =?utf-8?B?dGFWUWlOTWdZVzhvRlhQbGpwSHR0RjdycEcrdUdOOUZPWlRWVTNQbFdoTCtu?=
 =?utf-8?B?NUhCUTNZZWlndXVRUVlybC9YSDR6NHd2Y3pCdUM3Y09HSFYzR3BnVC93K1dH?=
 =?utf-8?B?UDZVRzF5bHdtcm8zcjlqWVd4YUo3MjMxYWgvN0phUWtReVRBamxNc2N0QW1L?=
 =?utf-8?B?QjlmWFVnemZpWjc5T1RpeWFnOXJ6cElpNEJsbGFzL2NBOUI4VnRNaEpTUm01?=
 =?utf-8?B?V29pbHB0OGpzVFQzOFpKcVpKTUJmc1JWRTNNV3lIUVQwaVNlYng4cE9KT2FW?=
 =?utf-8?B?L0hrTjZFVWF5VkF2ZjY5NzZVUGZ4QnJJOHJTZFM2S0ZWRjhRQVBtUlByZGRs?=
 =?utf-8?B?bmR0cTNqQ2hGZFFZcXljeDRQc0s0U3loMnZ3R1dCSVpzYWNwWWlBWUJuSm8v?=
 =?utf-8?B?U0U4bUlYVHlhamZFeXlFUEZCN2NLcVN0YjRpUGZwUnpIWHZ0T1Q1M3Y0WXJJ?=
 =?utf-8?B?b1dtYWZsSk5jNDJaNlQrLzNURlFCTTBrWko2UkdxMWFPVjVCV3NieUlmanBK?=
 =?utf-8?B?M3RYYU93enE2NTZnL2szUFpDWDc0QTd5bUJML3dVTGcrZStLZUxLbHZuVkxJ?=
 =?utf-8?B?eUNyOG9tK0g5YlpmQ2tBVDBqT2xRRmFVUnZHVmtoOHMvYjN3ZmRpV3FiN2lF?=
 =?utf-8?B?TVlJMmNLNnIzeXRJZEpWS1pBTmRuVnlsSTdHUlBPcTNjb1I2aURHTkJnaVdE?=
 =?utf-8?B?UnFpNHNwd1lBOVBTODgrZTBmRW81bDQyQU9HYVY1b1JRRktjVDk4ejlqOHl1?=
 =?utf-8?B?SmorRGoweVdIYmUxRDltUFU1SVZMbHMyUjE2YWxlTEM1VW5Udm05WkR5UHNF?=
 =?utf-8?B?Q0VFOHlpRk13YmtYbDBsNGN5bWl2L3kzeDg1WGUveEFzRWZTRENCSUpDcmtW?=
 =?utf-8?B?QytyR0YzRXl1Mjh6dGNCR2lOVVJHNEQ2ekN0UHVQTlp5MUEzTG5WZEtpR0U3?=
 =?utf-8?B?RnVsd3lCUEVDdkRnT2Npc3pyVDFUV3V1U2psd1NRNWdWdEVNSlJ0R1RweHBI?=
 =?utf-8?Q?hQ7/rGAMa+Fg7XEg=3D?=
X-Exchange-RoutingPolicyChecked:
	F/CTA+EYcZuD/5uMm+ILBIiMg1MGHDtDRlWqqxMOFiR2g+H3dp9VsnQits2EU9vwRhOKmZJC7aiVPv2rUNs99W0bT8/yd9RwfbHAZT8Tpsr5uO1Ay6KYQMTVWpwmpTtMMPSpNdlFYBMXCkAom3CcHeg42O+kNfDRA840/5wH6GqcKy+zBzJ3FlbG+LWO4s14CtMSvQsMmykNQgRpjJ3EUq9JqvYsalvbdomFAuIJ82JZFOwAYwhpEjqFxK1UU3Tf7Gv/ijptG6A7zNGLPOhbciLuoHJ7d5k+wgqtlW7FFQfYUGfxFE0SwF4m9hgZHd/woWf75njZYSG4ot8xQR/YFg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q8kN0WMWW3C9Iq2c0hPoSVNDyOeaUBapPkNu07iRjAwT9WGe71LGAYMSeWJw+Km5dUvaDX5obv4UmE7HQGph8gItvpbBkoPTDLftZeOy9cwAMmAhJ0smDT7NXnfiM1IVVY55386qHDxCNuzpSTFNccl+Kc/ypnPBAM7zigxH23ErOcqobXk9iLZxJJe1AnuSGyYkIbcqdk+leXxpo83RttzSKswoVv3pydwFkOMV+2hRJR1qd5IAZSeQbTMIpG9iS2+w3KCuaKcUvXfnXMK+PiQPoCZDj9Dj1hDqQ3g1rk3FuwnPO/owKILmCEAgbsOhZWNIzKwcgNLeTPGWzyhgKfJSnUFqGou4DsW4NTg+KkPXfUVma87TU8+QB3JU+4mFSJfVWBaW1szI/AA6BVFBw7JAsAG25LzRctLBVZ6/dr0j0NRTMAdp51Uy5SfO04VXriJr8BMllFOgpbT/aUHnYYnwkDOiVgHwi5VY7HQpnwzoUYc/W4VdRtCCDiOZ+PN2U5J8fJbfk21H2TzZa5JuoyFQVfxLPW5+oy7agDsfryv0Pofl2Fby7JjvhBJdech6p2ufJv4eHt3kwaYY9ftgKGEiXpqJtMLegXhB5g2wvXY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c99a1b-0be7-4aad-33dd-08de9f0d5d35
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 18:48:08.2712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3m23gsTdmBqErq039/OzRJlPENykF5Yx04KI9bLjHguUtV3Rn4u0tq4Zgu3oEuI/nY6APsK57F9iGZ5hu0AI8gmpPelD4tQmol0W2BYpFRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_03,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604200182
X-Authority-Analysis: v=2.4 cv=JYCMa0KV c=1 sm=1 tr=0 ts=69e674ee cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=We95sTJ7cGreDm45cHMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IaLdEcKk6NDPFIzvuX1t1Mtx5oe4HmxJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDE4MiBTYWx0ZWRfX37HgAxvHTDAs
 SstwKVbcV99iPfztWlA6qc6ZNcISwTu86v/1+xc/ib5xF+aASswCQqxfgxxwlV3kli8Xj8pHXH5
 Cvsi3XW9tP4V4OwtaXdyXB8ZSbetiuQ6m0pCPRKU6n6JRg/DRFaQ7G8tUM8c8eD8GrQ7lklQpTQ
 glWPVUplR6ERVMJJLTAGXIsax18TIuiEv2ixs/u0MmfFo5EhDzJeJ81S61ZIuuN3/CF1kfhT4k8
 lC6IUbUlc2VZNpfeaWfNiARqkGQqfS9QM7YPZDmhs1DPYnjLfEQnPnHhsXC4iTIzVwterRtOrxN
 q/sMZKimJWyA8Ijtd6fG+v8YoTNZfi1ziDI/jnhE+Q45jXe8rMyF95/uXpbRDQortzphyzB32wr
 Wi6D7TT34ufIaGVo3rEJyEF+FufmH5XQKOXifyLjZWCsJsC6pO/nlXHPuAXJZ0t9bDbvN0QQWzD
 Go0eh0MnomCDSurkuWQ==
X-Proofpoint-GUID: IaLdEcKk6NDPFIzvuX1t1Mtx5oe4HmxJ

On 4/20/26 1:02 PM, Bart Van Assche wrote:
> On 4/20/26 10:47 AM, Mike Christie wrote:
>> On 4/20/26 11:45 AM, Bart Van Assche wrote:
>>> On 4/17/26 3:57 PM, Mike Christie wrote:
>>>> qedi supports a total of can_queue commands over all queues so set
>>>> host_tagset when multiple queues are used.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>   drivers/scsi/qedi/qedi_main.c | 2 ++
>>>>   1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/ qedi_main.c
>>>> index 227ff7bd1bdc..0be0a9f30ee2 100644
>>>> --- a/drivers/scsi/qedi/qedi_main.c
>>>> +++ b/drivers/scsi/qedi/qedi_main.c
>>>> @@ -657,6 +657,8 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
>>>>       qedi->max_sqes = QEDI_SQ_SIZE;
>>>>       shost->nr_hw_queues = MIN_NUM_CPUS_MSIX(qedi);
>>>> +    if (shost->nr_hw_queues > 1)
>>>> +        shost->host_tagset = 1;
>>>>       pci_set_drvdata(pdev, qedi);
>>>
>>> Why "if (shost->nr_hw_queues > 1)"? It is safe to set host_tagset even
>>> if shost->nr_hw_queues == 1. See e.g. "[PATCH] ufs: core: Use a host-
>>> wide tagset in SDB mode" (https://lore.kernel.org/linux- scsi/20260116180800.3085233-1-bvanassche@acm.org/).
>>>
>> But you can't do batching with host_tagset right?
> 
> Batching? Does this refer to struct io_comp_batch or perhaps to another
> batching feature?
> 
I was talking about when we unplug a queue we try to allocate
the tags/requests in a batch. But, ignore my comment. I mixed up
BLK_MQ_F_TAG_QUEUE_SHARED and BLK_MQ_F_TAG_HCTX_SHARED.

I'll fix my patch.
