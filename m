Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B015D512
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jul 2024 01:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388357; cv=fail; b=LbJc+fjBVJHOmMfOPIzeH7kqQJQOZ5JUxqxDp3Hk+0Y/FDObL0WhceqwCex0oLTCaRpG1PbL8LopTyjPJ2Mzbtx/hBxySQsx23s8rfqRgFIPx63cL40ygV5jlpNY/5z7GQcnHBu1X7a0O0fpiRGMZeKQ2Wv5SMix2VLDAcVj9Ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388357; c=relaxed/simple;
	bh=gy7oLFhDMjEb85wYWOa4ir/Ak+g7eYkVO9K9hvP55QM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LL/EMSWVjhjGYsqy8QIaO+SLUE2wsFPxUQh2fCdbKIq83kuBgevQdEyalQCFiqHS9dYiFltnC7eOBNkFz1DceVn7wRXm7R/BVo1QS/TBMtIc+OdyoFSECCFjv/MQdbqi71fHR6PUfWvFp9TEI6BSmEr7mKs6YyEsnj4ckFYmbu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lu1VNTuI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VOuOScEB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lu1VNTuI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VOuOScEB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UFtcsi003938;
	Wed, 31 Jul 2024 01:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=LrEsKhfFeQFNuylL5DtYmy/BcViUltkNBpjcOQnJr2E=; b=
	Lu1VNTuI29wYMFz3h9+0M5MoQc3+6wKZZx6U1/aKWLwVb4NKExwSoff/y3J0Vwgr
	aH/iqrPDjq0ezxb3sABUdTNBuOumhPcGREIIQwNKLZzoq0qQudiC8j/cPvpK4aRc
	8rTO2qcL1txOMgg3/rneUQPphS4jZ1SJ2RzNCcmQ/hReSHMF1kuVyM1cj7NR/Q6p
	cm4uHPKDCooaUFZbt2djp2Uk8AvUYW4fPVUhoD2ebuN3Dez/arMmK+PPgR8hWHgq
	b2xEAddHNUB9XaeHNlLj2M9Cf9E7laubkLJHZt/mEBWF1/kTDkGfJj2DXBpu1as3
	S6VrkvB4naw8gb8zllbNLA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mqp1xbte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 01:12:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46V0M0Al038044;
	Wed, 31 Jul 2024 01:12:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40pm840rwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jul 2024 01:12:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ymg3yIVv6g2aPEGtR8qKzMiyqsycnwIf7CiI0SnNe0uTQi8IZPitDPHrEh9P9thhs0YIEeUzFMFvSOCp90ZKamYxhWAwS13PzmzQbNBWra/wbKFiOtGrVZJw77bmwj9nTJJCw6R25kAowseOGjwXPjzllZiaoK78J7AniNUH6b0AAHqWvRxA6rokolXriqbNaBplBCjFFeXs8wPYj5VWbCJu0KPYa5ncCOjd1Jau3q0dKQml1j2+X62E0QWZ4d8qW4tu4OwLJShS4oEleKJstpx3FFLuULifquVbRAGyi+tkf1WtdRhOHCCnMfDYLmTTk3qWIS3IDTdzmiVmmy69Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrEsKhfFeQFNuylL5DtYmy/BcViUltkNBpjcOQnJr2E=;
 b=IIgztP2UpsaaxOdWDsyphWRnXP2fvAItthB2hKNdc4vANG17TdUVQDjH52E+n0wubQ/+qDeKcfDj4s2WCjyRVt/BElySvTJX70gO+YmK4A4EjtHMKP+fVA+lRQlrlSjEm7T9VSKhajg/4WM1ZZDJgcO1DZKtQl7fngSJ5r05NyJsC8R3ildap/ASD1gQ6I+xVr1043pUPS1LLtSJ6zWMKDXmDBDsWZ24gKYXuG5c0OFreIvQfHHG+WGF8gcILMIZvx1dVKxoiLEIJQvGDyi7nyChXkj5FK0E87xjLysMk+29iCfkPcdl2kbsnWYW0wOWW3RDWzVVCX5rT8NN3L0yQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrEsKhfFeQFNuylL5DtYmy/BcViUltkNBpjcOQnJr2E=;
 b=VOuOScEBDtvx3QKrrNtfRoTDZc/q6pZdJNPvEZLde4nT8ufqECo1SK2JyJrMXhkninx5dEKrNJsZNadnh3kL/5Is2CF/5sa/pbCjKFXeqTt3z+/zb+GgsskjmtkLSdBexhtU8aqBavdFldgyXH4XT+vQNqSyNubSi5C44pnjrzo=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CH2PR10MB4134.namprd10.prod.outlook.com (2603:10b6:610:a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 01:12:18 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7807.009; Wed, 31 Jul 2024
 01:12:17 +0000
Message-ID: <9fa825ad-af67-47ee-8cfd-da67f08fdba9@oracle.com>
Date: Tue, 30 Jul 2024 18:12:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] SCSI disk source code cleanup
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>
References: <20240730210042.266504-1-bvanassche@acm.org>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240730210042.266504-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::16) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CH2PR10MB4134:EE_
X-MS-Office365-Filtering-Correlation-Id: e542c38b-4639-4a2d-a61a-08dcb0fdd1b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTMxS0U2NjJvL0RML3YraUo3YVJhaUU5K0VWTjNPN0lGWGFRZjdEUUVYRnIz?=
 =?utf-8?B?elZDSXZpMFJLWjI2cWFTRTR4QlJOdkdtS3NBV1Y4RllyWnQwTSswdVgvWG1R?=
 =?utf-8?B?YzI0bHRYazgvVWNyYkwxNG1WQWJWRmREZ281TVNHOVIzaDZLTnpYNWlpSnQw?=
 =?utf-8?B?U0RYZlRGWlNPenlwZ0oyNlQ0VSs1K1MvcmZmUFdjVDU1MmNEbUdNejVGekMv?=
 =?utf-8?B?LzFCbTlDL1JOdzVIMm9nWEgxNU1FNGJpNmxoOUoybk82a1ZhZ2x6NklCREF5?=
 =?utf-8?B?RGhHUWVTaDBhWEhJeGQrZzg1OEdkWnN1QklSbStLeElKUTRhM29kQy9mN05r?=
 =?utf-8?B?eHk0NllLVkpSVzNNTTNQMElmcUJQdXR4RnZsNkNzWWRXUjBlMjlGYVhqMDF4?=
 =?utf-8?B?ZnJOK2toeDVtNEViSnZ5cmIvdVZJTFU0dkY0VkhGWWZNVDJ2L0Y2dFdvQUlP?=
 =?utf-8?B?SU9waUtWN21UaUN5amxtSmZtZmdzSjBoc3FSdnltSEpHUkxTTlJPTVBWZDhJ?=
 =?utf-8?B?RytOQmZIK2h6UkM1NXZqK3lTVE42SHU4bEtXcFZwdFMvQ1hMZG9aaUZrd1RC?=
 =?utf-8?B?aVFtSmFxYzZYT1pyTEc5N01EWFo0NGtkOVd6MWp1WUR1bEFCY3JIVGRoTFN4?=
 =?utf-8?B?UXZmb29PWFdFd3JmZ3lxSmJRU3h2cGl5Y0krV2IzU3dWK25NWCtGYzJLZVZ0?=
 =?utf-8?B?aEUzMHBHT1RCbjNJWW1SRVBtQmNhUUQ5bTRHMml3UlBWU0crNTVjaStwVWp4?=
 =?utf-8?B?bVhQUjN2YXpkWmxyMG1kWE1jazB1NjFjOVE5YkFTOGhXRUk5ZnU3NEo3dTFM?=
 =?utf-8?B?ZmplNThDSG9RV2ZvTEtPM1VkaTBUUGE5bDJ3VXpYYWtWMTlXSVVSaFZmY0Yx?=
 =?utf-8?B?ZEFwVnZOa285WVBZR0pPVWFFMWJhUVQ1bnE2SE9IWmdINTA2cG9HY0NHcktD?=
 =?utf-8?B?bFRlOWdRODFnTHpuMkFjaHpUSWNwODNWT0lHUU1CSUoyQ0huZjFyTUlrZEhP?=
 =?utf-8?B?MGI1YUU4Z0Q0ZHhQMXVkakllT0pJbXBmU2JrNkhwNTRIcEFTVVkzUzF1OGpr?=
 =?utf-8?B?U0EvbXVHTkY2T0tyRFI3dVZoVWErTDRuZzlURnhwbjFVNk51YzdoZTR5MXdG?=
 =?utf-8?B?bURZSmxvWWlib3d5VmE3cmdSTmdudnhEQXQxcGRVc2xtUGIwS0VYcjZ0L3RD?=
 =?utf-8?B?akFjOVNoY1paQW40cmg4eWFnTE81dW4rZ2ZPQTFQUlRQWkZMZ01QNlRWZkxn?=
 =?utf-8?B?cGNaYXFDT1l1VW1zRmpuZmUxRSswTW9wdkJidXV5Y0VTTDJIdW1hZW5pT3dT?=
 =?utf-8?B?bVBJV0dwU2FuVnVGcE1uL3drekRqTk1Oa1JyZUVmYys4dkhVK25zUU0ySFlw?=
 =?utf-8?B?aFd6VFh2UEtHUW5vcEtsVFN6M0MwWjU3ZVNIaFFwQWxVVEMrbUR1NFpNTjdu?=
 =?utf-8?B?akM2azBzK1ZzR0RnNm9zQzdCSlBBYXROckF1TENEZk83OW53aVNEb1hDVG9w?=
 =?utf-8?B?Zm9Sa3NCSmFCRnBuL0Z1bGpFWGZVV0hRV1B4STdITmkwMU54WDA5eEQ4TnJK?=
 =?utf-8?B?RzVuQU1TQ09WVEdxRkRtZVgrVWt2aEtNWVdEYmtsNkw2aU10a0N3V2RlQm1l?=
 =?utf-8?B?V1RoNkdTenN1OTRhckpHQjFOeFc1djRURFhwNnpXK1VHY3YyQ2RnZ2pMQUFM?=
 =?utf-8?B?RDZYL0JTb0c0aTJFcGdtR3RWKzVWRENuSUE3VjdRd1c2OGdzNHlBV1VEbFpD?=
 =?utf-8?B?VVF1K280eW5OYXJIMm1EN0RZL0cvdEZ1QWwrdHJkNVh3d1dvbS95VzRaUVNp?=
 =?utf-8?B?ZzRhWmExUWFLeWJkQzhxZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1lMN3p2ZmY2RlRJTCtMaVVlRmFDbC9XVzNLU0srb213ZG15YytjTHhWNldE?=
 =?utf-8?B?TmxGY0hDR1NSdlhERnNwZE5rbndLRWQ0bThaK0NWcC8xZnowS0NCdVE5ZGNH?=
 =?utf-8?B?RFUzTEVqd0JUVGNrRXNOeFpmTld6eEJMSzQvQXV2blN3T0Nra3BoNlp5V1d2?=
 =?utf-8?B?SnNmdDAySFZWdTUzVGRyRlZuanV1b25UWDM5RlZkZ3EyNlBwWWNiVjc3Wmlj?=
 =?utf-8?B?Vm9Fd0xVQzkvaWg4UUdtWEIyQ2JWOGVVajJ2Zk51Uyt6VWZIRFRpZGgyZFBL?=
 =?utf-8?B?cEI2S3BjMHJyOHIrRWpTeUpVdnRocS9jeXpMT2Rtdk56a2dKb3V5c0NMa3hj?=
 =?utf-8?B?M1IwaWRrMlBtOEo3NEZyb2MwQTZDNU85c0Fkd09vSWlvQnRxbjRrZWtiZVEz?=
 =?utf-8?B?aGpsYUVTSkhRcE1Wai85bXBWTHMzWGY5L1psdStySzF1dzZhNUxmTGhhOTBx?=
 =?utf-8?B?b3R2di9IY201aFIyVGR3QXFNa09PNHQyOHRESVYycVl1TFRUSG1LZ2xCR3Fy?=
 =?utf-8?B?NElMei9VbDhmaTlOS05DN1pNZ216SkZzQldONHBoYlA0bENGYXdndVcyWUVx?=
 =?utf-8?B?NTRCRUVITmZzZno3SHdNb0hmbStiNy9UQjNodEtHbjVza1M0TEFSd204Q0FG?=
 =?utf-8?B?aEtaUzNFM3lYa3RqNHYxN3dvd1hpdGd1bHk1SUNUVDI0RUp6OVI1WGlwUVNH?=
 =?utf-8?B?cGFtUktCZXBDenU1VHJlUlllY2cwUUNGcUxUeVJEeEFQSFh0QjZTc0tnSnhY?=
 =?utf-8?B?NmR4SkNhRkhhQ3RvcEJqdVNaaDJnQnZ6NXJTdmQ0UWlMVldhajVyMzBjT2RZ?=
 =?utf-8?B?TTZmZmVEei9zY2J4T2RVbFVRZ1o2ZVJjaEc1Kzc4UW9uL3V3QjBnMm04SEI4?=
 =?utf-8?B?WjJadWNTZG4zOEo3YnN4aFdsS2k5d1lUeGdObDhEb1J1MUNEMjFybFFjbjBW?=
 =?utf-8?B?d3Z3c2dxVitKUG9td0RKZXR1TkF0UUtQT0R6ek5NMTdoMjVMcDZiajJuQlhJ?=
 =?utf-8?B?cnY4a1RsMGxTVUtSdDdLV2JWeDNxNEtjaDIyQWladG1TcnlqZDFRazRvWVVY?=
 =?utf-8?B?NlVaeHhPWmQ3UGpCRGxPa0p4WmVOOEFzNnZnRUs2eGRFNWFlcEZZaVplWXFV?=
 =?utf-8?B?dGFSQTBPVm9qeWlJRms4UHk2VHlDNUtVREhaTUpHcGc2alkyMWhmV2l6aHlu?=
 =?utf-8?B?QW9EVk1QMFQ3VWZLRlpiai9CUEtza2VOOUpQMEFwM0Vwc3FjR3BvNlg2QmtP?=
 =?utf-8?B?UEdzbjB3RFUwOHJlUGlHaC9rNGFGK255YmNVTUd1RUF0NjdlVkFBTThSRlNp?=
 =?utf-8?B?T1RnRG9OTnBwdU0yQUFpdERlbWxsN3h2TTJibWxKWDlHQmRNNjZlY1luUkds?=
 =?utf-8?B?U3g2OXN3NzBwTEs5aC9kWEo5TlpOcGRHYy9LNFZISHVXUDZjSy9WMlpEek1F?=
 =?utf-8?B?M1NFN2xxT3c2WWdDemhSak0rVTY5bEZXc1VjWjNLblh2R0JYcnRzRHU3cGkx?=
 =?utf-8?B?RmVOMmcrdm02bE9VR3pNbkRGYnN1QUsvWUhSMzQwQklXQmRyN0NHeFhWRDc0?=
 =?utf-8?B?Z2pMNldvdmdZYi8vcU42ZEJIdVJtMEJvZ3krekhJWG02b2lEKzFmN3dsVTVQ?=
 =?utf-8?B?VGU2Sk8yWlRsSWdROUhTSjFhRzk4YTJFTDhoVTVyY3lOY01lZTRUQlhqL0VI?=
 =?utf-8?B?Tk9vOC90THh4TmRtZkE1bUNYRkJrQlFuSWoycmR4dGFDMmM5RXVyM2F1UnQ1?=
 =?utf-8?B?elFoSVpPeFlqdDh4ZHM3M2tPSVFKUXJMekwvNFVabUZBaHE4WUt3eTFTNitu?=
 =?utf-8?B?dnNhQS9zdXpRN0Qza0Vsd20wZGF6MlBzMVFWWmxHVmdOZWZBVW5hOW91dnBl?=
 =?utf-8?B?a0lxRUpZaENEYkppUXpUUkw0cWovV1lEL0FKZElNRVN5ZDllY1phajBlUllL?=
 =?utf-8?B?cDRES2xxVUQ0RHFVV3dXbjJVUnVzNUtOVWNOOHg0dkcwNWo5clYrdmpxKzRQ?=
 =?utf-8?B?VnhvcFpteWJmNlpLNVU3QTRMR3duQ1dGOTBiMk5iNlQwSjU2UUlrQUpicDY0?=
 =?utf-8?B?dk1XUU1WdEpQSUNMMkxYYm92RzF1d2IrZWpUSXFKK3J1WGM0ZmpTQmwzY29O?=
 =?utf-8?B?R0tCZzRxL1J6eWRxM1REZHhib3hJbmxxVmxPSDdDVll6bFdsVDFxeC81RU02?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zEYgwS8oThMXOrDzTQoX1TPSf74noFf5rf2k+wVaG9xHzjmJLIy4u3xw9RJx5g2XrhtygRThDNyt3pB1suEgzlUkdgO1BF5EEJPcnf+iC0UTN4RRmRp5yTPjClGXUKXtVylrSyPqtOH3vjm0i2IeOMqjnqIbafCH4Tjyzr0bFV4vQBg97oKHXN5M5cAl555DTSBdBGez2cila0J9I91A6qGMqjZMQ40muhPospQdJiI+9QNl6ILy4cKfumY/Rp9xV1jK6ba9+HTRu+1JbYqPVUsAgcjpStUhk6gQb6k0+pn597MR/uhOLQejZmOSyXEDykpEa5zEB2/aNYJcKllAVS8QUkZOB5+tDC1FgOJb1nbi7vJ6NEsw1YQ0czz4/nOPWVEYr+DcpXJnVTH/ZbfDsehRhheN2BSHbTsTl023gEa4rmr3xdZpa0N4Zz+TUIVz3vm5JeQGfERw2dV+nS1NUHxD4dyx7aTeNzNXsU5E0kH4GTql2983DRu4A+LOGTeE9QP0ENrETIkmTnSc7KxZF9fFDspYIYZ55F400QWvOeZrKzuTHHa/NaLthzh+d/Pef7Qog+s3J2n6lBaQMJxCzYB0N6Xg623aXOi2asozD8o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e542c38b-4639-4a2d-a61a-08dcb0fdd1b2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 01:12:17.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQ7DI8OH+PYh0vE7nmkfYUvihtopGb6V7Bk7C9vdCTKdopdeMGb8df6KPpf5TeA2RXFfDSkfVNduahZDHQoJAb54YGBmdxGFwCLZgi/U7sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4134
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_21,2024-07-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407310006
X-Proofpoint-ORIG-GUID: F7_VBniatPnYY6EQt0nzOIKf2b3DLQRS
X-Proofpoint-GUID: F7_VBniatPnYY6EQt0nzOIKf2b3DLQRS



On 7/30/24 14:00, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series removes multiple forward declarations from the SCSI disk (sd)
> driver and also makes error messages easier to find with grep. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (6):
>    scsi: sd: Move the sd_remove() function definition
>    scsi: sd: Move the sd_config_discard() function definition
>    scsi: sd: Move the sd_config_write_same() function definition
>    scsi: sd: Move the scsi_disk_release() function definition
>    scsi: sd: Move the sd_fops definition
>    scsi: sd: Do not split error messages
> 
>   drivers/scsi/sd.c | 411 ++++++++++++++++++++++------------------------
>   1 file changed, 198 insertions(+), 213 deletions(-)
> 
> 

For the series.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
