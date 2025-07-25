Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04FF192D97
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 08:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753431875; cv=fail; b=nK9pxdXR8qX3jtiSH5EU0/TcI4Gd9UhA5tf4uusGcSOel7skMkCJmWq9a0prRvi4PehPkWiz4v8+WK5TlNQKP8m2jaGkNVa5Yy8w4sd4QjIBvCShW5fUYvQjTzaMU9g2zG8b288mZrUf3jIKVLuqEaQud5FyR9aBv5mYLUmcfuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753431875; c=relaxed/simple;
	bh=z0qQuVZ/YtIFynjZBVp87zDGy1SD6RHE5RQJwZgmwOE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QX8ueYkC/LvnRKYNndZi4XMZ1Q4mSJrFcLuF42ezEdFTLNVzvTbDDhGDejmFa6/e+FiVG0XP7a5Q7t5kgbEvUwLGW/2qnSKUEc9F0EVo3+WOmdww0ieAgN3+MWLzPDYU7jp16I54NBiEduZpsSFay1Irdrtlew4WTYam1W8c83M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pB/1P1/+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C20ssxqs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pB/1P1/+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C20ssxqs"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7fv9S024930;
	Fri, 25 Jul 2025 08:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QUFQS9TSZj0iEe6b67+G6j7eKaflK116k5xOZYkeHt8=; b=
	pB/1P1/+860gCEmXFM/o+r90gHPG8p11huzOW2g1SFMW2xdpJGsJhpsm9SmsEyy/
	tsmWxjRHuiMrI5iQJLuMDJyTs5G5uw678UyIuGU8Z2aUthgQXLH7JuuDJRDpZNsO
	YXH5rYylOUg13LeU2mWxkdUkFC9FabqpJLlf7aYdMVTpIYqU9LDvP7SLcNmPeGpo
	CV51OmsmSnHpolSUtHQhkcG0cO6j+OSXYRZZ8reH1nISKf0Qe/qWg9aHHPvQb4d1
	JOT7OrE5NuDud/b/1NFdEMTPbcK4RReqUZXqTvKuXlQwBs7EiYhqWyyVjMrtsRMw
	zMUJXbqsTnmQOUEPvELwyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1jgkpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:24:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P6d952031412;
	Fri, 25 Jul 2025 08:24:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tk5j66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oFGLp5ZEFjXw0rxMX7ddkDimhleZnO8FQii7rJS4tbr1aD2aWRm+bEwnJHXYYuhQdEHnS0VDxnBaLUF1VkXiFovaowIVZa7RjKkN10ndRpKSFzJy3JKKp2luflpPiPxEtfMo/auuzn/ZHvGwy7gQSyYgGRt8cD6f7QXqsBB8Xt79KYlBV2YiRrH6ixF0xwHzLJ+h+vnsIipPra755wTcYPFEykOBnhFvOeniCg23AGw0p33jgsuNWx4QCagiqyQxUupTNCiewKkCEiesO47A/QciONJYxN+H35CPpE579yikNCgPK/RF1NXyn0Shv9SairW7VV2D83iKwh/JE5n77g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUFQS9TSZj0iEe6b67+G6j7eKaflK116k5xOZYkeHt8=;
 b=rQP/hLanrBhPBX67gW2s/pFVu546c4146P5j/skJMKbr9Cohqfdrl0n+mK6F25TBHLq4890QRhGo2HRIiqhWqNelM4Qyj+t2HLLim85ledRDoB0D1ef1mA894JyBirDml3oPwh+D6pEAFfd+efwldvaYvcey/8QnZgbJPyKLWUyA1OS0f+izXX2rwt+OlIkGTd4dPFeMqnWJxK8A8mXVxHcUo/RR+1lUXTXEVoe2FPjiI6msuIQV4iHgyJNAEuAe0qedpz56PYCPfXnmMBGEVuFaAVHujMknQM+8l8nni7XLwB/QfqrDJORNhNALmX212yW7HGHRmKx6YYeEvppqqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUFQS9TSZj0iEe6b67+G6j7eKaflK116k5xOZYkeHt8=;
 b=C20ssxqsrisfxX5PHzq58xYrLdBxReujVoOa7wDpO5FtRweif7aDfYuWTjaqF18zGgpsAiLHucfKSM5iItz/4lGDCCOTz+COYG3iKb13oyE3Oa4CAFZxwZAQ4CWsvLOWEI4HTP5cVItAaCeqErIBFnBxbIzBr9K0TBB+M8E3kq0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB6279.namprd10.prod.outlook.com (2603:10b6:8:ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:24:16 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 08:24:16 +0000
Message-ID: <59fc58fd-a899-4ef3-806e-e87203d15a46@oracle.com>
Date: Fri, 25 Jul 2025 09:24:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
To: John Meneghini <jmeneghi@redhat.com>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, sagar.biradar@microchip.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, ming.lei@redhat.com,
        Marco Patalano <mpatalan@redhat.com>
References: <20250715111535.499853-1-john.g.garry@oracle.com>
 <de2459a3-ba8a-4f43-bbf9-8a11420bff26@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <de2459a3-ba8a-4f43-bbf9-8a11420bff26@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28)
 To MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c8abed-5fc1-498d-eff2-08ddcb54a4d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TURzWUY3ZmUxU1YwL2NvWlhDZkszcFhCM0E5ZytMdW9XeVoyTDB5NDc4dkEy?=
 =?utf-8?B?Z282MHhLVGxyTjhNd2xEU21FR2lwT2ZVclBSSWd4SjVkZzk4SUhrWVMxVjBk?=
 =?utf-8?B?VUZQL21vQlpuK1pneDQyckNuNHo2S3lYZGJJM1NXMTBsMW9zRG1DcFg0UzdK?=
 =?utf-8?B?MHBkVk81M0YzYzFXK2l3ZnpGTVFvcTByZ3hVMTB3aHhqKzRuWjYyN2J4alVl?=
 =?utf-8?B?bnhNOXdFRHlZTTRpaGswbnAyVFEzeXlEWHRlN1dUYThBRXB4S3NkTE45eGEw?=
 =?utf-8?B?bExQdXdsaEQweXhqOGV5dG9ESjhkZHhFYWU5K2pscEgyVnFoQ3BtaTFudFVq?=
 =?utf-8?B?MXV2N2dBeUZQV0wwM2hod1p4MWRXYStBQWRkOS83LzkyMTVJUHB5cldsTG53?=
 =?utf-8?B?NGphT0F3a2x6WFRHS0xHS0h6NTdseE5SS2VwTDN0VlA4RklIYThzUWZuM0RY?=
 =?utf-8?B?N0RGVDZ5Qm5rUFVPek5FcXNKOTRpTnRKelRpdnZ1MHlLdEF0UmxYMW9PekFW?=
 =?utf-8?B?ZFZFcVorTjhWVDNtS2NpWGlNV2wyK0pNS1QydHNuRGNxYXhGWW5nYmk0V3pn?=
 =?utf-8?B?T0RaTjdOU1QwL3Vsc0h4N3NVOGJtQVkvNkVYZlo1SDdDb3Y2UUZoTDVPTlFE?=
 =?utf-8?B?c0RJWmxSUE9UdmVIalRLNzdqN3Bqci82VmtsRW42Rkt1aWYya0FYV29BL1gz?=
 =?utf-8?B?T1dBc3NrNGR1cFR6SktXb2xaNmFvWG5Od2xEL1pweFFCKzROcnM2RXMrTE8z?=
 =?utf-8?B?dmo4bzQwcUR5MXlkSWVKSXd0cWxtNlBPNUhjV3paZVpTdmgwUGg1VVo2UnA5?=
 =?utf-8?B?MXhUWS83NVU0ZXY1QkZuZ1U0c3pwallPbm9ob3JMNndrNlQrUnNJYkhrQmNC?=
 =?utf-8?B?bjNrdTdrN2dvcGZKcG1YbVJIc2w3Q0wyTWRXQUJrY1dYcHRhS2lVRDhRTUtR?=
 =?utf-8?B?QitIYk50UHNJa2JhQklJaEFzVWVXYm4rTU9teEl5KzZXN1hJdnRBU2tNN3A0?=
 =?utf-8?B?QzFKNmpiS2IyNmJhVHU1U2ZLeU1nQWJNd2VON1pPWlNoWitxcDZGYzdLSUdO?=
 =?utf-8?B?S1lJN1RGZFo0WlhoN1Bid3BKVHhNc0orcGZYd0UxS041NHBzZ01hR1hKaU5m?=
 =?utf-8?B?RlkwSWlvanZQNDBQV2ZTS295d2dUUzQ4RWVTUHV0b0FnVDByVC9zWitXZDBJ?=
 =?utf-8?B?Y0dRVDlKdTI3enV2UnJZMUVDb2E2d1M5WlIxUzdZVFRKTWYrNXpOdEw0YW1Z?=
 =?utf-8?B?Z0I2MTBHZ2VDK3lMRG5TQ0svbTBqeHJiWERYK2VzN2FKN1dEVytJTVg4b1d5?=
 =?utf-8?B?dVdrcFRWV2hFZDBjT0dua0RXblFHMXNjd003d0xkNjR1eHg1UUtkemFJWDZP?=
 =?utf-8?B?QVJNSWtRUXcrejhWdVdHcmx1RnIxQWpETGtFdTN1c3k2RWxYeS9kTzExVmxO?=
 =?utf-8?B?bkdaUm1FTklOcWtORXZGTU1VM01vcENCTTV0RTBTRzFhNHk3TTcwSXBHcDJJ?=
 =?utf-8?B?VWN2UkJOWFo4bkh4YUhRazVsM3ZMNXQzRTRSVEJFcFc5QWEyZ01qNFRpdnh0?=
 =?utf-8?B?akxSa3FRYUF0WlBucWEvZytKaDlMaG5aTjhwMkE1bWpMS0FuMXlCRjBCOXJr?=
 =?utf-8?B?ckpKWENzaU8zK3puRFdsaXJxRTd4YlVydDMxSWZpYkEyNm5USzJQNld3Ylk2?=
 =?utf-8?B?d3BiQit0MjVSSU9XZGRPYlcvYituQjhOWHBmTHF0L3I5VWRUdUNUU2lYUzRD?=
 =?utf-8?B?WEFVVHRIaU5QaG92N1BYbzgvWGNMZGRiaUIvSTQ5SktiSEM2OFJIbVpGNlRX?=
 =?utf-8?B?V2tjNTlGdTNBWkhBdjlwNGZXS3JHemNwSUxGa0k3R2Z5WHVudlNvcDc1Vnk5?=
 =?utf-8?B?QkYwdWd3VXNMMTBLYnA0RmY4cWU2bzRzd0t1bG5lVXltbCtBMFhEUEJGYmxs?=
 =?utf-8?Q?5hdqBnN4wTY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUdKVFloY245UHlnWW84dTFaQzNabi9vaDBUM244NlhhOTR1cWN5VUsyVmcw?=
 =?utf-8?B?UEs0cS9QOEl3aDNacmhBLytsVThHYThPNFdTdTNrRHVmRUQ3bitNT1UydnNX?=
 =?utf-8?B?RXg1Y0Vlc2tWb05UVTJqdjZzL255ZXdxL0swZEJGbmNZckt3NUFLWXRxTlVa?=
 =?utf-8?B?blVhZVR2TEdVNEw1c0hXa0hPSTNYOFRVdFdTdkJhaG92czRBeHV2OWhtSlZu?=
 =?utf-8?B?RmtuYlhVN1FVNUhWQzEwWFFzTi9va2tWRDNrWUhGM0Vrb1pkU3FXN29WeDRD?=
 =?utf-8?B?M0ZmaW8rNUFRbEZDZzBwUkVIdFluZjhuUlRORXZKSnczVlVOYUdNVTRlWDBn?=
 =?utf-8?B?VVpwZVB1WUhyTlhxY0pkRnFiYTMvTUxjNFBrcjVjU25PT1JCTUJZZUhqZnJo?=
 =?utf-8?B?aHZxMWxLR2ZjclBLa09vd1dVbnhaK3U3VXBYODE2cVBhMSszQStxeDFaa0J2?=
 =?utf-8?B?Q09lbFl0T3BCY0E3eE5WVUxKNmNJQ1hWckxocm1ZNTN0bU1ER1Y5VjlBUDAz?=
 =?utf-8?B?QlRidHRUYU1HQ0FTdlZJelRIc081dVlQVnZzRlNnaHNuWWhRbGxGSzlSdnNC?=
 =?utf-8?B?cktMTndpaVM0V3hiRFhucmhPR2pMQ05laG90UFUwalhySFF3dndVTmZIMC9Q?=
 =?utf-8?B?MThiTlgxNms4YUFpVkdBcDU3WmUvSE1HSk1EL2lBQWoyem9BSm1hZHNkTk5N?=
 =?utf-8?B?TUN3UEVpeW9nbmFkVjZsT05kMk9WSWUvTEcvMFlCd1dnTnAzakxkZlU5ZjBD?=
 =?utf-8?B?RjVCTjduT3FGR0p6RWpKc1dRaEkrQ05aNG01dHdTUllZSnB2SzZpQXhJRm52?=
 =?utf-8?B?d2h4YnJCc1dWaUpmOFlRNWFGU2FNc3Boc2FhMW5tMk5OSm1OaFBWZ2J5TEE0?=
 =?utf-8?B?TlNUaUZrbVFMMzhSUmdSVjJUVldVWXhaRCtiUUZheDVaem5HWkZxVC9NWXFt?=
 =?utf-8?B?UVMraWR2VVhEclA0eUNTcGtSaXhnTHJ0MEtaQjJyVjM0MndGbXR1bnlmM25E?=
 =?utf-8?B?NzRoK051Mm9nSFlTVEZJOHpsYlhXTWpjN1E1MEpxbkF4Ti9jeHd5YUkwa2JI?=
 =?utf-8?B?ODFycmFSaHlMRzJxUlBmODNTamd4RzVRVzVRbWp5WGV0REZXYnZLNUplM3F4?=
 =?utf-8?B?Z3JqOTQ4bnN5M0VXekIvNW1DNkFUT3RBRGExczhONGYzNStBZStOT1pIZHhW?=
 =?utf-8?B?OS9NdEovbjUwakpuaHF3eTNsQWNtZllaSWhmeDlFdk5tQW5DZnVoaDl3SGl4?=
 =?utf-8?B?MDNtNnJMZERFM05VbnpPa2xnb01XRExBT2hTRVpZZktXK3ZtYTFwckZscDFM?=
 =?utf-8?B?TEFsYlhkUitWZUZrellYOWpNUVB3SjMxV1l3eENhRWJiSXJ5ZTZ6WjZPNkZw?=
 =?utf-8?B?NFJ2aEpsM0FuRWdlalhDSkNKaWRjdVNLNUZkaXRqbXJmL0JvRmtGNUFLVlRi?=
 =?utf-8?B?Z0kzTEowNVIvUWc4c0NUUkNEOXc0cm80K3BQdGRqQzVIWURIRlM1Y2lQcUJN?=
 =?utf-8?B?NUhGNEIzQjh5R3hialA1cGdNalAxazNRSlhsUGpuL09JRmdua3h1VHZjS3I3?=
 =?utf-8?B?S29lNVpnNU52WnBmUFVlWXRmem9NU25LcVE0MHlTa2ttZ2ZuWExyalVMbEJt?=
 =?utf-8?B?RjFoVnY0U0hBdVBDVWxPRzZiaGxlSHFKYzVZZUxTMnpUdnVjL1J3K0NlQWdi?=
 =?utf-8?B?NGI0ZjFpZEhaeC83djJBZzJaRXExSm9rWDFPYnB1S1dFMkVCamdBR1BYUzdU?=
 =?utf-8?B?cWNuQmVoMHMvaW51VS94aVA0ZmZaY3o2Q2VXVnZnSjFoMWI3a2dZd29PY3ZB?=
 =?utf-8?B?S1A2Tys5UC9uS09iTWZOUWkyanZtdTBaTE9tTUE3V28yVys0MytHdUh6ckV0?=
 =?utf-8?B?YVBkcmN0Mm9Vd0o3STl5UXB6RFlGczNNRnA2WDl5NHhYUEkwTTFJYnI2bjZa?=
 =?utf-8?B?c0VsbkVDb011cFM2dXMwa1JlWTVvWXJyWVlMbElZZ0NBQ29jNEFZK1Z6Mk5I?=
 =?utf-8?B?UTBaYnhPS2ZOd0ZHZXgwVERXVm9EUWN6S0tqSk9YUlV3cmNhdWtmWjR4RnFa?=
 =?utf-8?B?M0NUeFZmMk5yWnlic1BNRzNoRkUrdEplM0JvdmlqK2FlRndQUDk1WnY3WlpS?=
 =?utf-8?Q?adH1+T0s/ZOT9ztpT64z5lIsF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	htPAlJdubCrcD3h/BPWKbfwecaoEG6QLTudrC4qXadSPSU6Vi2jTtDJ9R7QhYpHO6ojxFIG7Ej2HCyfNUWZyHnKAGIMSPEnKmP4iWIJ1AJwhf2Hc9RUBSKLwa/eFDuW6c4xSn773lBsOPm3MwGCXzQdmaDJDqRObtNYMXkTyz/nJPrdqa0I2xnNcgAMoTF4M4iwLWdk5/NC2nNtBRCdrR1NPdjKG3KfrldZCJJbaXZH/CF82urOx1yRYDAxuiI+1MO+Up9HEj7usCUH4zJb+t2EBMnngHch0Cif9nkPBZc0ZpptbcLIlZ01ZoSLQwmgui4LhLP6Q+ubigVEfdbf9pRnjE5CbFJVyBmiO9u95Yow2Plb0K8gUvj4dMEjnoWBuj56oXwoe2hEDf9ZChP3XG4dbC/ufAM2md3EodxxjI4BezmKAETw8McF7hLKjjJi+uuczs+9wMow1JhHYkc24lCuKhYNTt41EL/Ol8usslW7+oF5BU1SkgmlaeweuFDPBfiO/GFngUFNcWSsIV+0wPv16DgJh++BRpbgv43lSGpWKOwBNuUKL05B9Rdq9gx06ApFj5NADDwB+vcQLbLuWm848BFtQvq5U5hJ34Zhrg5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c8abed-5fc1-498d-eff2-08ddcb54a4d3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:24:16.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGFTn8mJbb2j3TvgbIh1S2h5hXoKiwHC6GPNMzw1Xdmi5mG/zGsoMubg6tdMfNVFi2nn1nQKmKmTjk+W/uD0XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA2OSBTYWx0ZWRfX2XD7I8UWnv4E
 y80BIi05R7SjziHwi2OYV4k86iOUa03V6rgsFhjwGB+dPlGe+jGkG7X7dAixd58ak3lE8/6BwGW
 wkrPyVY87ZIQfP9DycIjTPq6DPy/ekEZTQrcebi+sgCs+HJIlfEraW8shysLnjrd20Cdvd9D1Y2
 Y4fFo8PbRbnCTOPvAv00HdAXKP88qZIqasYDIIhM5pVHQmsnzxoWwv0WuW2xdvZYUO379uopn11
 thltta3MOZuseKftWkmXTxqBHXoeCeaHWBUPE/lTfJlgmRakGimD0ROcrdB/bTFo2s0YPr5whUe
 akUJ+5WCDD27cE9mkI14db+F/AQR80pZEWGl78tr1xa+WBF/nFmpILTU81Xo7Cs3KiDY7xFSRpE
 wiQofju+m4STEmCpDyK2Ra6YNwCboZsT/rWlJSJyDvDvKvvqaJg+/JMi9/4hmfyTKsLLbMWM
X-Authority-Analysis: v=2.4 cv=W+s4VQWk c=1 sm=1 tr=0 ts=68833f33 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=ErKccbtFFbnFD4NpzMcA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10 cc=ntf
 awl=host:13600
X-Proofpoint-ORIG-GUID: 7XOEFkNkWpFzoLwU22--WYOK9KN5Tnm5
X-Proofpoint-GUID: 7XOEFkNkWpFzoLwU22--WYOK9KN5Tnm5

On 24/07/2025 18:23, John Meneghini wrote:
> Sorry it has taken so long to get this patch tested.
> 
> The good news is: this patch fixes the offline CPU problem.

thanks for testing.

If you check /proc/irq/<IRQ NUMBER>/smp_affinity_list for the relevant 
IRQs, you should notice that it now covers all CPUs.

Hopefully we can restore using PCI_IRQ_AFFINITY and setting .host_tagset 
in future, but that would be if someone figures out the problem using 
using .host_tagset for this driver.

