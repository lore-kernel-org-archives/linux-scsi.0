Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F0818FC86
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758871978; cv=fail; b=JiasNJRRkvHcohB+g62hHDxmU3PWmiL60vknS9MWOEtdFIzmbT7+MhkfqjFNwYDrOfw2iV0SfR89fbKKS1TOjuyofBfYHkWCmVtUhI6YNXp2f30PVUxAB9PI5W8mKe6jdv9PotSZLmWtVXyibPSYZVTnkA88n8Ehn01BkNlLtXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758871978; c=relaxed/simple;
	bh=rY7FOcbVZMt7YKmlDL1PoCzE74cnOx9ZLd7UD9iZeBQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OhSE0ZfKRo1lXAGRXFt1BO+q4qgZ6gL7WxPflgIeai1/aFw2JrsnBj9bHjAg8pS4sND1eWTBkZw0fXOF33fiqaunTr7aIuwvIbelDRzsKkdaqIVEV3OGtf4t0PhdqGvwEvZ7WE5ujenDSsYDj5PzDNbs6iN/+p+LafzfVEoVBX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fHqAVblh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0OkCWpaF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fHqAVblh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0OkCWpaF"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q74i87021439;
	Fri, 26 Sep 2025 07:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ga5SEOUVMiMXFunqU33p0enrqXnNzvscmlI2Msr0nec=; b=
	fHqAVblhF9Cf6D3E2dCnfcdYRUE0ATAP5TQ9kLIo+9nXvrCaztm35+bNllu8KnXF
	SI8wlaHL7CcyXPdSCS2xEnuyr7/JfHWbNLxZmBrqn7S2ESPCML6F5iUf7Orgzd3Z
	EHvn1uZtQEBFOyNbv8Zioxap4bmb9oQAEqB1SXb0GMf6umlD1HxCxSkvcvS08DuJ
	MH3xIVAfpxirWwGVZ8f3opJXmvs2WDdxDOK5nn+tWuNQ6/ujN9++uxkHXEZ0pEz6
	S22R4QwisX28P610oDLpTv45VEvFdjtWEw08SuJbUmRRhGf6HoJIpjH0apVVzf6N
	+9WGkcYbic3MgLeMfiUngg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49dp4bg1ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:32:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q6fPve035741;
	Fri, 26 Sep 2025 07:32:49 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49dd827rn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 07:32:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oOGWtls68LElaoqgCkwjYKbla66rU0TQ+f9pBei9HcFlD8X1m0eiKdERrtzxmPq4gSQ5yEsTzfRXzIUhey7WmB1bm6+4E+M2ld+dOqU3xnjoWJTJ+h/o5IvhkT2ANEDHvE+KpguTg9y65EidOPuoS90XgjRyg5YWrdtxTcfvF4RQCR6s4Kcvhh/CGl8MLNn4VLmPNHrrRUNqq2Fui4xTKwj+BbMNXTnNBXFdOu7wDHjnQ2PO9VTWZkWYbmU1hJGZsv3jsmTccD0AcvhyAY5ahs+ld3LYRoXYIH1WhMEhsPd99eEo+6jpUgwIQpCljxWEZ9v418TRF82hrHFLAw4cQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ga5SEOUVMiMXFunqU33p0enrqXnNzvscmlI2Msr0nec=;
 b=HbnURYKEzl0tEm2jdjSFG6Oig3xj0IjOb5x9yGnA5me9dqGhoTWMqeMYvfA0RxPHAOagJ0H0oEszpoYRN4syKtlpkw5pUMX09KADbvwVcZ18m3zbfmSFNQ+pwhFQtPyWJI4GEFjiUAsj9+OLQNX/dIuWvvnTOv6T/sOaAcvWZkOm86a4D0H8W+8Exrj8NPNP5Dgky5TjrO1dEXKBVjbJ3sw1jzeleqEXdLxrX6bpX1rrNQOK0TMK+5qKH/zZXLREMCDpSr17kGOYefQzvoY+5I+rauW49CQER1zMOjDtb5GbLu5usqXfP/ZH0MQOKo/9woZ6exSEuA2FsIcffHT5KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ga5SEOUVMiMXFunqU33p0enrqXnNzvscmlI2Msr0nec=;
 b=0OkCWpaFxy0SkGuiVfQOQ+kgkiusVP5rgEs9tKK7OCqWV3nvHR9liMwPkjpTqfzFUBKhJlqf6Huu2Q0Tg6ARPnAgrCa2ekpK/53wi+FcTmrxVYNerz9MDRc2ydZutJxXlRPLhoVWuCmRtdDLgdvNJ9GzD1H7t6sv8JNwn85F2dA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BLAPR10MB5154.namprd10.prod.outlook.com (2603:10b6:208:328::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 07:32:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 26 Sep 2025
 07:32:46 +0000
Message-ID: <aea7f72a-7d65-4ab6-98c3-34abf112f6e1@oracle.com>
Date: Fri, 26 Sep 2025 08:32:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] scsi_debug: Abort SCSI commands via
 .queue_reserved_command()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-8-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250924203142.4073403-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BLAPR10MB5154:EE_
X-MS-Office365-Filtering-Correlation-Id: 3783a36d-ec51-40ec-4106-08ddfccee363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3VlWjhubjB3QnFzK1RoakVOei9WWU9ha2tEN0NCNEEvdkdyay8wWmptKzZt?=
 =?utf-8?B?eTIzckxHZVd1TXd6d3UvM29XeE4xVHdCeWFtenVncEdScHRHcDE0RE1SU29T?=
 =?utf-8?B?cU84K001R1JFNFJXNFd4N3JhazlwZzNaak9kQitvM2hRVmRhVE9DSVE2R0RT?=
 =?utf-8?B?Nlh5UFZtUE44c2QxZU5HVUt2SnY1Z2ZNODNzd0FsaTZ1MnhHV1VQTkg4S1Zo?=
 =?utf-8?B?RndtWXBGcDJPYjlKelQ5bWQ5OEJBMWlMR3llQkl1MjR3WWVjOFB6YmF4UTNF?=
 =?utf-8?B?UlJhUXVNZDEvOU9PTlFyRUVYaXNmb1FOTFlyemJUUGZrNUhhQVJ6M1NyZjIr?=
 =?utf-8?B?RnFtZmhmWEswNkx6N05RNFR2NkpTcTUrYmpXam8xbUJBTGRkZ2oyTUpGNkJE?=
 =?utf-8?B?VVU1bzBNbUJwVHBnZG1BaDFlU3Bob2dNaEE0Z3EyKzBQdFB6T0hkVVVIZW5G?=
 =?utf-8?B?WG93a1V2S2VOTHdZRitMVzNmTWZIZG5NbEZqaWd0TjA5ejVaZjZ1a3pmRnV1?=
 =?utf-8?B?YlF5aG9VeHJFRDFBRGlPU2dORUlySjMwYzBtSXZ6eXNsalM3NmEzMjEvYk90?=
 =?utf-8?B?aXZ4UGRhUUxBRUdTbDUwMlQ4S2FyVmFlZmdGdmxmRG1nbnBjeTFJN0orTHZ2?=
 =?utf-8?B?ZHU2MXFPMjBNRmlTZVIzMUp3ek0zZHoxR1ZsMjJVeGsyS01SV0NwbjFqZWJL?=
 =?utf-8?B?ZFJBeEhqeDdaUnU3aG9kbFVNNHhsL01OL2RyY2E1SlllMEkzMEZtZDdjbjgw?=
 =?utf-8?B?djh6WEljREdiVjY2ZnJCTURnZlZkRGNaQ0NyK3Q1K01hUi9mSTBZRDVTeFAy?=
 =?utf-8?B?ZFNhRW9YelFWcW5ES29NeUVLclE4a3NHSWNrcHZGRXFraWM2NmZKR25ldXZQ?=
 =?utf-8?B?aG1rQzRkR2diMFl3VVZRcXBVeFJZdkRQakhTMGxaQVdNLzhpNVA0VXhsTnpw?=
 =?utf-8?B?aUlTSGw5N0lTa2I4UDBveElSSzhzK3lXRlFIbU5IV1l3bzR1UmVsb0hFbDQ0?=
 =?utf-8?B?RUdqVTBBcUNRNi9NWTVNRE82dkpBcTZXbzNqenNpSEpHcjhML1FZaVRuOUxU?=
 =?utf-8?B?WGtmdnh1ZndUQ0l1My83eWxpT2RHd0JwTlhQem5xT2xTTjNWUnBMbytLR3Jv?=
 =?utf-8?B?QTczNXpKaUdzWlJQM0pYRU1MaHJjcFVtRHY5WU91ZCtwSGtMMXFWWUk0MHdQ?=
 =?utf-8?B?d09Wb1JNa2NUNy8xcUFYSjlHOXdaQlA2WXVCb254SVl0dXBVUzFkcG9BaUlU?=
 =?utf-8?B?b2oxMyt2OGFyNlcxdnJWLzhaSGJROEZqNkNDUmtUOWI0dHVmK1dsNWY3OFly?=
 =?utf-8?B?dmtLZFVWU2l4eTNmamwxTk1rY09rU0k2MjRxVFM5M0l6MWlLeDlDSGNFQllT?=
 =?utf-8?B?MEJEOUlVVDlxZ3JLb1V5RE9nelo3a0ZCd21KQlY0QS9zdjNSSEJJRlJTWUdz?=
 =?utf-8?B?U3k2T0FyakowN3M1VEVtUWJOT0Rkbmx2UHpyOWtyNFByZlhBdVZzNzRyWW5a?=
 =?utf-8?B?TWJwR1RxV0tHVXNGaEhxdU1RSEdqSEN4SmJ4VUtBSjdDR3JrUm5VQUVwMzh4?=
 =?utf-8?B?YlFDQlY4d2V0TVduUFFIVnYwSEpZM2VVTlNuZTNYVGhlV05xQnNLemh2RXJ6?=
 =?utf-8?B?MVFJbG9sRllXQVExN2Y5c2pyUTZPMnlIT2pYNHdaUWIvdk4wOVFMM0xUc0Zw?=
 =?utf-8?B?d3BrUnpTb2hlT1lJQTlPcXlWNkhRNmJlaW9JZ0paSU9XRStwamw4aXBOTHZE?=
 =?utf-8?B?dEZPOUVaQTBpYUZuL3NxMUw2QlA1VlZLTENZTjk5VTRjU01uWjJBc1RKdHBH?=
 =?utf-8?B?MHVsVWdCMkpBRFJtWWtnUVArdGNFcUc4ajdIRXo5NnZrcEp0NU5jN1dJaXhE?=
 =?utf-8?B?d1lLOFNIU25aK3pMWitxOXhsQU51ZHNUWUlrcTUzRVR5Ly9Gd05Ib2kyQzVk?=
 =?utf-8?Q?nDvsgiZO1sVDJR6fLGoeS9tz7HXqY+y+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWRSbThKYXV1VFV5bWE2RGdkbTZDVDMxMjBZZTRJeHM1VDZiblBteHBMMjdz?=
 =?utf-8?B?NFUvTWR5WmZhNkpORVpJbE42d2ZXVDdjcE5ZNGNYeTdtNmR1YlZsUFl4YVMy?=
 =?utf-8?B?QkpXQW9Xa1dyaXdwOG5SN1VSWm9IcU1yWDBvSzZmQkxVa1hJcXcvZmlkaWhG?=
 =?utf-8?B?bWFPVjUxVkNsV2N1NFJYUTJmb2FPVklNN0VFUlYzNFNOUkZsSWJydzR6dGxx?=
 =?utf-8?B?U3JqUUVyMzc1eUN5bzJOSVlnRnUyZlA1dGI3cGdUQ1VTS2FkcWV0THNyMVBC?=
 =?utf-8?B?UmErc0JSdEtCdG4yTUNPK0t0UFY4Rnk4ajVBREZucHdjeCt0VE12LzQxS0hC?=
 =?utf-8?B?UGFlV0tUT2V6d0lKV0xIYjEzYkMrcWJVN005ekFKUER3MEg4Rmd5Znpob2Fv?=
 =?utf-8?B?Ungrc3JGVDJHeS9ONDBJUmVCT04zZ0RmT0lVYmVoQVJmaVB5OXBEZ3dIcDIv?=
 =?utf-8?B?T1NWSGlHUUpMOGl6YmF4MzNYSXc4NnNzWVppblRjNVNrc0Nna2cyZm56aVVp?=
 =?utf-8?B?N2VqVTFBajRYa1Y5YnFsNCtnL1gycHRYNzBqMXpoRFZOazVFQlBZcDZoOVZM?=
 =?utf-8?B?bS9pNkFJWTNmZVIzS1J1RDRWY2tHV3lIV3pvNlBQaXdLZStpeTlhRktvUzhE?=
 =?utf-8?B?L28xQXBpOFNEUWlYWE5STnVNTW16Y2txT1BUbUtYYnhqODRrMk53ekVuMVN5?=
 =?utf-8?B?bkUxMUN5NVAxNEYyVFdJWFZyVjQzVytWdDg4bjU4T0RIaHM4di93TXhVK083?=
 =?utf-8?B?MlZhYzJheGMvbzh4aHFuN05hWjNNbDRkWXhoTEJPUnc1WHdhQnBCNFZtUDFW?=
 =?utf-8?B?YjdRdUk0Wk85M1A3N3A2VXZYREZEUnRyTXpTeGJzN0hSVjlocGpaMGtzamFl?=
 =?utf-8?B?SUVPTHNwbDQxak5UWkozMkFIUWZaWVdobUp6WG5QNm5DcmovMTFmSnE5Yk9z?=
 =?utf-8?B?YzhsZU9qcUdScThPWWU1Q1lSWkF5VVk3QUhBMVBUa2hnM2JITzZORlIwaTF0?=
 =?utf-8?B?cHgrd0JrcXhXMThuZmtWNjNhbmVORjhGa3VrbzhQM1c4SW9sN3RWeWV6L2hJ?=
 =?utf-8?B?USt6emxuMkU5a05hb3k5UTdzUEtnZ1VEMzM1L0E2V2t4UDdhSkVETnl2dG43?=
 =?utf-8?B?aUhZN3dEellqTkVlRXJUTjN5NC9xZUppMFMyQzlNRnJEVUtvdGpNS0V3TjRs?=
 =?utf-8?B?dFBzVG1KWTRQM2RIRGdDZFlCZXIxWW1QcGZrNkIxelpHVzAzY3RxaVUwNDdt?=
 =?utf-8?B?SFZKUWJTYzRjVVBHV3BxMFRXZHpqNGVXKzJiVFNNTno1emhYK1Jsd1N5U2R2?=
 =?utf-8?B?c1ovU0ZmdDJBNHJyZTJrcHI2NDk2V2RBbWZqdityV0xvTDZIeUtKRUg4SFlv?=
 =?utf-8?B?YlFwcGNvM2RvQ3pxYURoSmtWUmF1VTR4eHlyV3NoR0Y1VVpRbWJEbW8vUnNV?=
 =?utf-8?B?VUpoc1FaaHgzWGk3NWR1cUV5WHkyaTNLbnlKWmdjbld6c2E3N242L2JEMlNH?=
 =?utf-8?B?QjBJV1IzVGgrTXdLeVJhZWtzZk53Uzc5ZC96U1EyOGs1MjRSbXcyRTR1dG9a?=
 =?utf-8?B?UWdKbFloSkNxa1h1VUQzU2NGRTNRcDZHRnRFYjkrS1pmdUFmdTdkVGJCcFdu?=
 =?utf-8?B?N2ljYWhaRUNsRGNCU3lBaFdGSXBlL2ZuU0g2ZTE0bHlrNDJETlFxeUlTUTMv?=
 =?utf-8?B?bGpJR0pFZmZtZGpyazVQc3l0ODB1UytOZ0t0b1NjQTdkWGtFSmtxM2ZUMHVJ?=
 =?utf-8?B?QkhXOGl4YVR2M3MzbjdZWDJTUHNpd2R2QWtVTlJzRm9KK1NWSmtiME1mWk93?=
 =?utf-8?B?Y2ExZ05XejBKbTgrY2F5dURiVHhkcldmcTVpN01NMTZsL1owOGY4SkNUaGw0?=
 =?utf-8?B?RHpxNEJOT2ZTa0hKUm0xbm41S0U1RmVxdkUwbVNiYVkyOXBzRjBFWHdVZlBI?=
 =?utf-8?B?TVBUWDNpL1N6aXd1KzgzVVFXOWllcmJVSlJkV3F1bTNycis4TlRDYlRaeGFM?=
 =?utf-8?B?S1VoWkIwU3hRUkNraUlqbWZyYnRiRSt2MWVUOTZ2VVk5M2ZPK1R2UkI0TFJR?=
 =?utf-8?B?bTZReXY4VmpNM3d6c0Z5aVM4YnFoNkpMUGlEZjZmbHp2NFpad3Q3SGJPRUJQ?=
 =?utf-8?Q?fePPKzwba336bZ+2B5R2Ej6Q3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JkpasbKuO2o5jYrTKCyMSVscMNjYidNmWbl/wVm7GcBQ+OALFy4MYELrt1EW5c0s5/FjWYa68SZb55vzyzor3OK8KRccQce4rW9HACoA3I7qhWy7HszqYu83MQ8jcDVBbGGMhbMWYoodJvbGHZ/cGPP7cyoXH9f+RhunRnbpoPBUJLdvLTbF2WjHXarDYnwe+rVQrImJzTe5Xo9WVxdkqfcfxMp6iWpOuwuOqrgep8MSqg/T69EIjiNsiri5frMPv42No7XtYUZy+ZhE5zg6O0Wi/uY9bmbfLUpSwjgapwZFzs1b6WgSHms5o8yVPLmRC782O0vDx9p6pxyzYA0g6iFwZLlXnpDG4sTEbUVo/RLStncpdVKymiDzJ16+9wf0mfBiWNOPT6f/BOO8yri7uX+eRsM0veK0tf0bgX/ZBp81ggS7IiEMCx8BnLKaolAa9EwnxVtsfMuLRgpno3o8AegXAGEGtRFa1lIEH8XC4bJV82Vmobf1zjCYpan6pmIQ80AetVIhmqFa1MZT+gUfbZyNztH5GBMUhHdn4gPVABHureS3FlEoviM1VrO4wdN82YFjA4bzCmDQomcnSXvaQW5MiigalEYBGyWlRBgh9Xg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3783a36d-ec51-40ec-4106-08ddfccee363
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 07:32:46.6712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cI6I0RBAlD3+0ufyVzDWQp6qtjJLbvUJPUe9rqodMMj4eAVY2JHcqHrr2EkU7S+IHuSkeXTariMqY6FyxYRXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5154
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_02,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2509260068
X-Proofpoint-GUID: rVvJCUZHXBL44UF8hu2H60ORbT8KJ3y1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDA2NSBTYWx0ZWRfX5zTxgOylZ+jf
 c/GOCqOoQvQOQstuxWtjFdC6UR/eEFZluwAYboP9i5cY4x6KfSjN3KM76FKnMuf7EhBsRwcB8k5
 bwQWryrdRUDtSkInKltiB+/aHLkisqZwWYZi21Hj/99bjINfMUh2g2dgEAqHSumT3T1axJZys+B
 oTuU+wenQg1NikniAHz2/wWMiEWuPfT2f0NmBzU9Nc1qsYz12gwz1bB/NlxlxLEmXm6FGO3Af1S
 Nln+COkHpg6fZ5dTMMvP45p3OZcbq6un9WUb0pZWjJqXuP3I+qkA30LGLQ/9AvXhd/5XPBN4NVM
 t6ssbfNKBFcOoCiQH1CHkDPtlEkXJuzMAM2NCvbRP/Cv2tZwJMA6P3XI9DNGNsGpsPITszi/NlE
 c4O6dVWh6S0FxOwWWQUDPjV6rx/LvA==
X-Proofpoint-ORIG-GUID: rVvJCUZHXBL44UF8hu2H60ORbT8KJ3y1
X-Authority-Analysis: v=2.4 cv=dI2rWeZb c=1 sm=1 tr=0 ts=68d641a2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=N54-gffFAAAA:8 a=iXEPVmGqfNMvAMFnll0A:9
 a=QEXdDO2ut3YA:10

On 24/09/2025 21:30, Bart Van Assche wrote:
> Add a .queue_reserved_command() implementation and call it from the code
> path that aborts SCSI commands. This ensures that the code for
> allocating a pseudo SCSI device and also the code for processing
> reserved commands gets triggered while running blktests.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

At least Suggested-by would be good, if you don't mind

> ---
>   drivers/scsi/scsi_debug.c | 106 ++++++++++++++++++++++++++++++++++----
>   1 file changed, 97 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2a8638937d23..b376331c4cce 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -451,6 +451,23 @@ struct sdeb_store_info {
>   #define shost_to_sdebug_host(shost)	\
>   	dev_to_sdebug_host(shost->dma_dev)
>   
> +struct scsi_debug_abort_cmd {
> +	u16 tag;
> +	u16 hwq;
> +};
> +
> +enum scsi_debug_internal_cmd_type {
> +	SCSI_DEBUG_ABORT_CMD,
> +};
> +
> +struct scsi_debug_internal_cmd {
> +	enum scsi_debug_internal_cmd_type type;
> +
> +	union {
> +		struct scsi_debug_abort_cmd abort_cmd;
> +	};
> +};
> +
>   enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
>   		      SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
>   
> @@ -466,6 +483,8 @@ struct sdebug_defer {
>   struct sdebug_scsi_cmd {
>   	spinlock_t   lock;
>   	struct sdebug_defer sd_dp;
> +
> +	struct scsi_debug_internal_cmd internal_cmd;

you could prob make this a union with sd_dp - I mean, could they ever 
both be simultaneously used?

>   };
>   
>   static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
> @@ -6729,20 +6748,48 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
>   	return false;
>   }
>   
> +static int scsi_debug_setup_abort_cmd(struct scsi_cmnd *cmd,

nobody checks the return value

> +			const struct scsi_debug_internal_cmd *internal_cmd)
> +{
> +	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmd);
> +
> +	sdsc->internal_cmd = *internal_cmd;
> +
> +	return 0;
> +}
> +
>   /*
> - * Called from scsi_debug_abort() only, which is for timed-out cmd.
> + * Abort a pending SCSI command. Only called from scsi_debug_abort(). Although
> + * it would be possible to call scsi_debug_stop_cmnd() directly, an internal
> + * command is allocated and submitted to use the reserved command
> + * infrastructure.
>    */
>   static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
>   {
> -	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
> -	unsigned long flags;
> -	bool res;
> -
> -	spin_lock_irqsave(&sdsc->lock, flags);
> -	res = scsi_debug_stop_cmnd(cmnd);
> -	spin_unlock_irqrestore(&sdsc->lock, flags);
> +	struct request *rq = scsi_cmd_to_rq(cmnd);
> +	u32 unique_tag = blk_mq_unique_tag(rq);
> +	u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
> +	u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
> +	struct scsi_device *sdev = cmnd->device;
> +	struct Scsi_Host *shost = sdev->host;
> +	const struct scsi_debug_internal_cmd ic = {
> +		.type = SCSI_DEBUG_ABORT_CMD,
> +		.abort_cmd = {
> +			.tag = tag,
> +			.hwq = hwq,
> +		},
> +	};
> +	struct scsi_cmnd *abort_cmd;
> +	struct request *abort_rq;
>   
> -	return res;
> +	abort_cmd = scsi_get_internal_cmd(shost->pseudo_sdev, DMA_TO_DEVICE,

DMA_NONE?

> +					  BLK_MQ_REQ_RESERVED);
> +	if (WARN_ON_ONCE(!abort_cmd))
> +		return false;

I don't really think that this deserves a WARN_ON_ONCE

> +	scsi_debug_setup_abort_cmd(abort_cmd, &ic);
> +	abort_rq = scsi_cmd_to_rq(abort_cmd);
> +	abort_rq->timeout = secs_to_jiffies(3);
> +	return blk_execute_rq(abort_rq, true) == BLK_STS_OK;
>   }
>   
>   /*
> @@ -9197,6 +9244,45 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd, int *retval,
>   	return ret;
>   }
>   
> +static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cmnd *scp)
> +{
> +	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(scp);
> +	struct scsi_debug_abort_cmd *abort_cmd =
> +		&sdsc->internal_cmd.abort_cmd;
> +	struct blk_mq_tag_set *tag_set = &shost->tag_set;
> +	unsigned int tag = abort_cmd->tag;
> +	unsigned int hwq = abort_cmd->hwq;
> +	struct blk_mq_tags *tags = tag_set->tags[hwq];
> +	struct request *abort_rq = blk_mq_tag_to_rq(tags, tag);
> +	struct scsi_cmnd *abort_scmd = blk_mq_rq_to_pdu(abort_rq);
> +	struct sdebug_scsi_cmd *abort_sdsc = scsi_cmd_priv(abort_scmd);
> +	bool res;
> +
> +	scoped_guard(spinlock_irqsave, &abort_sdsc->lock)
> +		res = scsi_debug_stop_cmnd(abort_scmd);
> +
> +	scp->result = (res ? DID_OK : DID_ERROR) << 16;

personally I think that if-else is nicer, but that's just me

And please consider using set_host_byte()

> +}
> +
> +static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
> +					     struct scsi_cmnd *scp)
> +{
> +	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(scp);
> +
> +	switch (sdsc->internal_cmd.type) {
> +	case SCSI_DEBUG_ABORT_CMD:
> +		scsi_debug_abort_cmd(shost, scp);
> +		break;
> +	default:
> +		WARN_ON_ONCE(true);
> +		scp->result = DID_ERROR << 16;
> +		break;
> +	}
> +
> +	scsi_done(scp);
> +	return 0;
> +}
> +
>   static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   				   struct scsi_cmnd *scp)
>   {
> @@ -9416,6 +9502,7 @@ static const struct scsi_host_template sdebug_driver_template = {
>   	.sdev_destroy =		scsi_debug_sdev_destroy,
>   	.ioctl =		scsi_debug_ioctl,
>   	.queuecommand =		scsi_debug_queuecommand,
> +	.queue_reserved_command = scsi_debug_queue_reserved_command,
>   	.change_queue_depth =	sdebug_change_qdepth,
>   	.map_queues =		sdebug_map_queues,
>   	.mq_poll =		sdebug_blk_mq_poll,
> @@ -9425,6 +9512,7 @@ static const struct scsi_host_template sdebug_driver_template = {
>   	.eh_bus_reset_handler = scsi_debug_bus_reset,
>   	.eh_host_reset_handler = scsi_debug_host_reset,
>   	.can_queue =		SDEBUG_CANQUEUE,
> +	.nr_reserved_cmds =	1,
>   	.this_id =		7,
>   	.sg_tablesize =		SG_MAX_SEGMENTS,
>   	.cmd_per_lun =		DEF_CMD_PER_LUN,
> 

