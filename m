Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF32571B4
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398156; cv=fail; b=chHHotSPvHMFjh+XbrGz48D99NEWY/0HkpOv9s25EOCIZUUsZILzEXi++Kojmk2BIfItCo72g3ZW0tUcs/YfO7f9fkmZeRdawmWPk4gCQi6NGjM9MSQ95lHJLBOz+eQPMYHETqzkOTY/sGZjqlezbKU/9e4kgB4kuyxkWkrtIQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398156; c=relaxed/simple;
	bh=RKhhQfabzipcijve6P75vPzRvRFdrasUceMYhe3aKYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lAzHzJU4yG8ONI0Fv9X4kqioMptuioyZeuAD1m7l8oVRPjlfJ0eUypFSYX8ty5mtX3dViOhxUxnm/mRnZyBumH2Ohln3I0nQvVSxUfTdjolhFEnCxuKYA1wc1ihTuIKIDbXLT3PYljWuaKZBmYmqNGxIh3Or0m0XeJ0VGYKqw/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VSWcnaGo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RVNWq6eQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VSWcnaGo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RVNWq6eQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMaFo012846;
	Mon, 24 Feb 2025 11:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LLzd461u8ojAP8OXiBNI1LZwig0K/vjU6c95FFIbJfs=; b=
	VSWcnaGo5iOM9EvIt987QrMvsKnFnoIEzuJ7F//5/q8zLsGLBpfVbYgGjAEIvnEk
	TWT6O0U0GzxJdWCZHu0YCDZGXKBmAzBOvVWyJHUncdoMU5iev8ROy3OFqVEoL44G
	2nOzx+a79V48Gi0KvDJnOFrSMRJFe6PUNBg6PSswIasYfudD10y3Vo5EDBOcSB+x
	0WP5/OWqFJ7gk1wHIEyhtAF/ReBhIpS64eELVOzX0U3ZQ/Yat9c7CT8oA1kpAFPb
	N/RRfA/6kCdLYlqR0SgbOFJDIVHvfsJtMfQ2oRlFYtLpYoWF3+EuxIJYpNiJ0YAW
	Vn/j+jeP19KwEliaIM+K/w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y50bjdd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OAESsD025436;
	Mon, 24 Feb 2025 11:55:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51e29xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJtZg7QvA4MXyDjo8FnAcjtP9e8GakLV8GvugLaeQ4ZilLgbnxsQtMZJNVKmVEuYR59Wkwng0ij0fdlkwIRxqhMsADy+4iJ4awDwj171r5RUOGQn6MIMy2GbhNo37tn+qTO6TcLMuTN/f2oUp87+vTbJSe9ZpfCLmOTRjo8irvWPdGXKwwjFmkwtDBOLFpSth3KYIBKu3tEyGXzxD48pZmWQIC6z+33TiICfYGBIZGmN7tduaD/UPpZSRU47CvEY2pgjWokM+XAGnak0MiIqv3QdUKjvaoxasVgpIe+Pq0L+US2AfLwHgYDk8eeCuj91AQt9VHbHFPyihJQf6xVM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLzd461u8ojAP8OXiBNI1LZwig0K/vjU6c95FFIbJfs=;
 b=Cd4gkszH1na3/un2MbA51Sd7u7AFrtLi78FVznZGpcBPTZqqHDKelckIcfjcZqcKaDBaE5HHOhSlBSCBUGlbvMjSLJzTbU+F7HMvf+DrhJEMtU/b/rAri2ST6m2nRw8ihvkQeae5tlEvtgSOyE9o9WQX5aLIuJIWVOX942/FN2lwhdcDN3SAdeBOZFI465hJ1so/IunkLGAzVMaGFltY1ktpw6XlX8RvHJg8/zrqYAV5KvYLFGXthePhQc+mKRfj3xDt82pkR8N4zCo9ar6G1NzbTmqTSKYwctizzwizuX0Rov1kl399NxXdVLJdCF3MCgvUlHma9cdWMNaWa52SAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLzd461u8ojAP8OXiBNI1LZwig0K/vjU6c95FFIbJfs=;
 b=RVNWq6eQpaSzehk6SspOAH7Muz8/xlTDaYtT6jFXwN1QIlcijVVTHfCCqrq8cEB2JhJ0FdRaibOdYVESZP133iYsjqWqhDZueaQh+wYpHPkWQ+695blbkD0YeMGTyvvEeiSrZ4qDyoNTXcgdngmO/LlMEj9EtY4OzeDrbIwa1Zc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7218.namprd10.prod.outlook.com (2603:10b6:930:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:55:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 11:55:28 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/4] scsi: scsi_debug: Remove a reference to in_use_bm
Date: Mon, 24 Feb 2025 11:55:15 +0000
Message-Id: <20250224115517.495899-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250224115517.495899-1-john.g.garry@oracle.com>
References: <20250224115517.495899-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0034.namprd07.prod.outlook.com
 (2603:10b6:408:ac::47) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: b26d2e34-9611-491f-8138-08dd54ca21d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DUUdtyPcf6ppVzrV9DdQ13EI7FY6rjc25hNz++vf97RFzj8veDu0t9g2LiOs?=
 =?us-ascii?Q?0yEd16LrP1sbNfhslxGMt5VrWY1HHj+NbbdcrNPks4WWv6TEHcKigTj6Y7bD?=
 =?us-ascii?Q?E0eq097JZCiG9pbqMrpy8y4eWi//WEO7UyXojii6nbjyGWWFA+ZX4UP0EWKc?=
 =?us-ascii?Q?ZKfR+798kaosgfwBruLDFU3Okxj8o/wHg0icknhFrocSA8mIiHTeCWPtfV1L?=
 =?us-ascii?Q?mMWY3vfemM8yFccO/GqWVrt0sKU6PuceUk0V/OOynO2tmTM0ErM7oTfd9f1q?=
 =?us-ascii?Q?x4QRhm5gG4BcBJeaNgyYBRKALs/O5fT3WMGp7AX3W3o2UX03i1AXM0U8li1k?=
 =?us-ascii?Q?ndLQW3HUdqaxtdnS1gwaXHMVhV0YM7X0+b0xBJcToF7I1TA02XV92gqshoKq?=
 =?us-ascii?Q?+vEVO1VhYPxzP3FAIi83y3wcbeuS8QRmoLEivL62RbOy1TTFPiik99jPhfkV?=
 =?us-ascii?Q?EVHJdEJyH/fPmVrdt+PAB6BAmsfZCY3akbKQpSFuPg/cg7sMK0hcahROMCv0?=
 =?us-ascii?Q?0Rrp81PUQ2F0Nl/FAaDGSWhmfV/qwLSRLARgbUabPV9YRCoADTCgOqnCYewp?=
 =?us-ascii?Q?OTI9oJrVEPXKayfqNirogfV2gffOhvQGi88maNARzUBQuqQX9hYbdSYR9Ffr?=
 =?us-ascii?Q?hAd01tzfqK9Skaoi0dFhvdtAenNrsuK7lYR+l7QFLA6S/yHp3ZHzcUoHSlru?=
 =?us-ascii?Q?ynt0QAp5OB6wwxRsPeSgli/mB2iFK5I1nejwITiAhCVOv4eTksVF7xyxR/EH?=
 =?us-ascii?Q?6q/6uaIA7OWNFCWogvLGhPEcQ4BoXJuiV8jSJd/+Pb2jzI7PYsNJ5HYgUXlG?=
 =?us-ascii?Q?8NWP2Qh1Fo+izvM0c8OH6FXp7Y7IysWJQ8pluFiK4m9b1aNBJU660JEfvU1S?=
 =?us-ascii?Q?96OeLHkLj7JW9y7OpJanxGu5cW7Csloi8ENAd3DCxuBk6cISg7Dvz78ZuzQg?=
 =?us-ascii?Q?fSHVEC02J6AK8312xpkHAU50xdVhpYRaSic0zIlk/VaidiOdADHsLVyDZoiV?=
 =?us-ascii?Q?KfdbhKoAlovd66bLsHfHDCOGUok5OVR7sus8EZbqLk7+G+FCw6EzMaUwLvud?=
 =?us-ascii?Q?6hipowCtnydjtbAsGNa9M1SdvQ5ieEeMLapWrWoWXoCk3vKA+LffUTF+yfM8?=
 =?us-ascii?Q?95LnYKIaZfn0dosYygJyphQyX3ZRpfyzaSHzXVRDAAXmeRcBnjKxcQxE57Qn?=
 =?us-ascii?Q?ky3fCrHKJaERy/bh0bNqKQbNJqyT87FEoXC2UmV9sDWoygT4QVEGWpYR+wI4?=
 =?us-ascii?Q?qbBpfNB25yQ1qrMeaTg928id7+/oTwFrSAL3gE+veDFmKMbfNtBoxI9f65pc?=
 =?us-ascii?Q?IADcm7JVg1W0hZ44ZLVAuP4Ek7OQDc3HXtfOCeao3BM9lyBQWniGgw2A5Rxu?=
 =?us-ascii?Q?yLUrwijsmwlP8pUydNahK+fymw0s?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wg0g1+GYDdspHe+wfQB8diTxs6dGeuqX00JV4/8aDrPArsKr6yI8FmCfNeWA?=
 =?us-ascii?Q?ZwiMpeJXtEZ4s8sPQmh2VP07/TMHI5Lh3JTS1Mgd5lXkwOyDFfcSV6BHiMMG?=
 =?us-ascii?Q?CnfNNFVtfRz6U4Ao/YI2/PoIstdCEuPPBjj31J8NUmrGvbRpxcGDNJZzNkDY?=
 =?us-ascii?Q?t/s6UyNOHTsycBqOrp9GgdfwJ/nZ8rv6SeA/VxM5E/tbJNJH6PGJwXQXRTn1?=
 =?us-ascii?Q?lWkYCKXtSFNApEPlgu3Rx/SbMfOpOcZKoN6lF5whmFrQIskMWzcTzVSyb0Cg?=
 =?us-ascii?Q?XulMtDsbXs6FJAcizqNMxatq8hK+eS0IauVxzTxcEbwShiKRL07ki05guB8C?=
 =?us-ascii?Q?Zpk5BiF8EV6JqzrVozLx6wX+KMlqQYAmMEZ0LCsV3XnTV33m/WZ3J6FYJOIC?=
 =?us-ascii?Q?TXYMaqI7V57PvXnRViepFuSsCoXtsZ+kSrRAt2j7QoeiHFGLI7LapztfNcQe?=
 =?us-ascii?Q?oa4tZfvvv9+fWLw6q82dRZu6CsWdCgEhSM619BjhN1BW6XEQ72GR7s7LATa0?=
 =?us-ascii?Q?4SiCNYMiRTDGAtuGgbl7oksgmh/WBQkxjb8YcI0OFbVEbnbFs5uBLzJwLcNs?=
 =?us-ascii?Q?SlKN0vhem6B2k5VlHCX4epLwyfthfwodP9t8c1r96B5QijdeXmmoD5U8EoTA?=
 =?us-ascii?Q?aBmDwJRwsVkSPJZOnumD8epmsYIasJKdFxoXdCsXybxMyIwy0RdGCq9s6hBb?=
 =?us-ascii?Q?Sgf9U9W20It/zmoccGqXFH8PL22rk6ohwvIfOkwtq2r7lQyriNNX8xFFtvft?=
 =?us-ascii?Q?cUgRiBdPxYISaWrv1Ja5xent9246WwzkZO4i8x7yAss0aPL7u1Ts4fMQn88t?=
 =?us-ascii?Q?bXsVqtJSJJXawLAwHUulRvFRItRKrMjC7bqYrE1PT8yIL+QSJIMTVPPshY7v?=
 =?us-ascii?Q?XCNYwthztstA+BPcJ4EAJD0BNLtpupKWI7nxZ2BoAjAUfwmoBwWhvUeZmd2t?=
 =?us-ascii?Q?wfPvmBWHwPAmRqL2b1qN8gWSSUNurqD2VIyZZNTyLau+4UE9zSNrmMdokGnV?=
 =?us-ascii?Q?fG5v4zZMK53Z7WkZHmPtHCbwdq5SJHv/CxbLNOdpUJVT6VVAK1UjqSxB3hnb?=
 =?us-ascii?Q?Haau6yGX6pMs0bTv2lIF6eNRt133hMy5SMZKM2sP+i2kDYwa6FhZiD3OVvfN?=
 =?us-ascii?Q?3bBcMEJVCds2ek3FxoUcQ/GvBs+DewUgDklaWIByAV32dVCEXAVmTaov2QDp?=
 =?us-ascii?Q?n3hVuCftZBHYGk927G/dC6KM8uom1b9A2xUgo6//YE4FIOFVapq5xCLs3pyU?=
 =?us-ascii?Q?iLC6yQPw3tfWy3tAjBlm7SOqLEvrNhgcEhbdevWP2MZxKDzLrXFO1PVIUytc?=
 =?us-ascii?Q?dfF5o1EjaG4lIBPyaDore+2AJ0ZxqvAdluktW2tuy+OQnOLWmtfL+gQ8+tTS?=
 =?us-ascii?Q?0y9rLd7kfBPPle6sc3Kl1+mESfumtR5I4i6iGReN8/HxoQdmKFkuRnsmORMs?=
 =?us-ascii?Q?J8ZRHTSdRzYBFNAdZuUGsxtYzjqIoWXKWeIgmZ1EqE07mjELy+tvM++4NJTp?=
 =?us-ascii?Q?4kmuofJTItvHx9Ywq18JmkmNMTt8495uQloPa0KP48bVUk5il3J7CZM5G0LP?=
 =?us-ascii?Q?vaEvg85DKx8mKWmmsTa1GRX+k9p412Sdgr9qhlsvqwgt44BysBjwIKBlfsmZ?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9FlN0dqOyELddyKIqm7ROq+f0RLyfMBbBY4ceidmvo/JRAnaXWfx9NvZNjwgimzEO9aSwtJU/KxZi7UT9NakTHJrtRVryQp1tTHvCdgydvz8K0ue8gaioh4WlkxsMXjzMoZ57yquekdexYtZEA8YcBn3L9SDGWHOU4hmvPZEAtTKm3fudU+HqXWd7ZxChtY5lOMb0GakKLeCBZO/e06+sRzDDPYjcN8S3x8hBF/f6cu+YdyplOsn1Tv/I0mFiu7/ijy1fGRChU0BcWp/YrauV25f5vxmx8sfEw0j/0uXVdwrW7byRoVl4PPwcRXHMK858RumhyoN99Md8iHoc30tn8EYZ/ZJEEI4yPASx+dKP0GSSgIJT6cdc6Qk9y/Ecw0fgpz2KsDqx38hms8Nt5O9tBTqXNccveHJfFaL2g7wOoZJGpZ0v+Zs6GePQnwQ5oL+ECLDnQWlp1T19uD4N9ZzoE8z+xKib3eTZCLRRsNOMSgzd/2Jwc6uhj3xS77adlLAb6zAO96Ye3kTye9tR8300doBiaymvZCKdEEVCmYe3e1n0w8fQCqa4sN9XJrWQKP1nIWwl9JfHhjjK9kTtNHHYM08K666Qji9N86oYiFNbjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26d2e34-9611-491f-8138-08dd54ca21d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:55:28.5753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcXXy50hsdAjdDuy5TaTHJRp50cXERvvXpfvbnEqs3zS1iM3a5OjhCiwIFNGlDMjPbegng2WUy1yNoTsYNugSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502240087
X-Proofpoint-ORIG-GUID: P9Q5KGdgji75Z3vLFxTeohNdnO90xoZM
X-Proofpoint-GUID: P9Q5KGdgji75Z3vLFxTeohNdnO90xoZM

From: Bart Van Assche <bvanassche@acm.org>

Commit f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue") removed
the 'in_use_bm' struct member. Hence remove a reference to that struct
member from the procfs host info file.

Fixes: f1437cd1e535 ("scsi: scsi_debug: Drop sdebug_queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e3ebb6710d41..7631c2c46594 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7575,7 +7575,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 		blk_mq_tagset_busy_iter(&host->tag_set, sdebug_submit_queue_iter,
 					&data);
 		if (f >= 0) {
-			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
+			seq_printf(m, "    BUSY: %s: %d,%d\n",
 				   "first,last bits", f, l);
 		}
 	}
-- 
2.31.1

