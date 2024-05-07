Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E7314D70C
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 09:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073458; cv=fail; b=I4qYhWbEtrgUzDj5lcEmEEME+dvjAVOp/fo92MgcQmBHXpP4JhDSsRSEQZ96gL1SeOqopkKZmL24BvlRUcVzIw+ZkxRCQAcC6JN8vDNbM5nMYl1DDA38NI7mxwxN8AyZtTBT7lFUYaWZFLKjYBlOw4T2JbXyfvGHN/3wsQA/+u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073458; c=relaxed/simple;
	bh=pxxlG66NEh8TXnzIQ05E5liG/CIBnA9EHpVM7nD4vUU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RRjEL7eO0bc7g0weqjX03M4ylU0EGm7rnKQO9iWuSGpuOIq5yOLTneXOIUQdzVVOVUmsTlAI9lue20nUUGla4pT+tcm0ObBkOCqI1jC+AuOq64IHMOoeHSJq+VCSPWg2XD9t0XIthA4UKhYC3u7VoPdAfv6OE5649E2DCg9c2eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UWyHgDc5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=muSJ3TCg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UWyHgDc5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="muSJ3TCg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447943sA011040;
	Tue, 7 May 2024 09:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=i6Jc8a6Gl25ETBmhYkcw9JMAEU1u8MabYVetPWikS1M=;
 b=UWyHgDc5UaDf7aMS3gHCiIdKHLjwiaSQ8qtQ4C8rTsCdkAoWE3dbcklMYbk0S7cjJy3E
 cxX0EFcA90qp5O/aahp0shsEWypN4n0+yx++aopWCVXuO1jNueCjolThw2mw6cfJq7SE
 XvFsA0NMhikhR1WC3fHJkkB8QDhGntcJRTG+VL+YvJI6qiHDyKeOE4EczoiihudDX5Ks
 kpUl/iIHc/sRegwfyVkraiWy+pdRQmJ4B9m2tMERTJVpoaxCfn1+wfAKk1fB21EhE/7/
 x+HSX1iYA7nCHBV/9vIC6Qxc6piqrT+luzbWnpJPqZFKN8ljz+ALoZ3nuba1JV0r0K/M GQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwd2dvh37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 09:17:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4477tqkJ006997;
	Tue, 7 May 2024 09:17:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7rq45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 09:17:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgtTcYQ/k7J29xDSZ+WkV39ldyNBJxD0MYeAESc5YQuMbom+BYPM1yXKKeuRMoUs4vLdlnqcPqJbV8v4MWc92wVF6dl0mfGBDM5engPL6FuBxC146GAaGIl7POcbaQLFRcyRUxOCoFm0w8VCnBmu1z3gnYJDKDUAVeSL1Q5Xp0hXVj1fpdhCbvY1ATFopZFPrpViz0LwZNTHrrx9ddOI/n6oWgLZEJJjjAlHtojEkcPFPERvnRh3B8DjIn1NC1ZM8jnRLnjxu1OLy8s5SMLTnHnzH7kPW0IMgXAhlRomiLV/XtYhhPLFp3Ts2rYEDsK5cliw8hjSh8fw7iiIbUHFSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6Jc8a6Gl25ETBmhYkcw9JMAEU1u8MabYVetPWikS1M=;
 b=EvrmnoGxJaCH9ixfsYnWnfsIz6D7lJ2Hf9NFGzdLEJb3+wAzUJC3lAOpmYXHXzWFov9k4p+X2WxIkFA7PtSBtk0JdpIRjXbqLvZpx0DIzUCBgforPg8/qosoOBPWSblNMRL81IuB+ULoH7QkaFlA2v9s9CVxWUVYROwSPa0nS3cNAzwoJu8xP1t1xyovO294G/mWUY+cU83Vf6TBL29RlGdTHSLOYpNtHNYHcr/rH57MVF7D6lsHqtlWF3qJDRjEsi5WBZ3wRUSzv+vGUbeRUynFv7rLMWnox6z/3H1qdAHeJ4YOBMf9Y3toDIPNMolV8sQAgd/CHLKx65qLALseOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6Jc8a6Gl25ETBmhYkcw9JMAEU1u8MabYVetPWikS1M=;
 b=muSJ3TCg7/Qgk04cpTijsW7bw6IF3ZOR5oeSa//Q1YiJa1yeJzgEouuZ/nZIfehrto9QnpcuVVht5cSmcJYLidbLRnJ+1LY5lG/DLGkzGkXkotgcDFESOXwDzn+m2HVtQwD6jgn8WsGNDXjfJhvHh7YCZxByDEOgTsiSGi5M+20=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7567.namprd10.prod.outlook.com (2603:10b6:930:be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 09:17:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 09:17:26 +0000
Message-ID: <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
Date: Tue, 7 May 2024 10:17:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>,
        Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0297.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7567:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e09fcbb-2229-4934-ba20-08dc6e768318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?azJzTXFDZ3h2QWRBNS9oSVN1YU1GbzVIU1hCUnY1NnR2bC8zZEtQSDNtc3VW?=
 =?utf-8?B?ZCtTWTVXSjVKWDI1QWZWNGNhdkcxWUhwZ3h3eFJ3ckhqbHlEMnpyTGdUUXZX?=
 =?utf-8?B?bmx1NkJyY3czY0J4VDlhalhxaFU2NzZ2OGx5UWNVdWUyd1BMd2JIV1BrcXY2?=
 =?utf-8?B?bThCMEpPUjRRcnhwdUxsSEZTRnBzM0RuemhKdTZRMGExYmNFVllwTjJSTnlF?=
 =?utf-8?B?djNFejZTYnNzNDdzc0xldE8rb2VXRzNvM1BUQVpFdzlZNjNPMDNYaUxBcjJi?=
 =?utf-8?B?V3lYMWtuYlBlQmRyTE5PZm1qenl3UTZxUzJMU0s3VHhJVm40ZXZ1MEthVFFX?=
 =?utf-8?B?UThUaE9PcTAybUp2RlJYMVcrNHVoNDVZcC9FN292SmV5TVV3RmpSN0wxUEhH?=
 =?utf-8?B?RTlia01xTHdpNU5BZitFR2NuemFQMXh2OUgvWWFZcjc0WHdZc2R2bk1Balhj?=
 =?utf-8?B?ZGc2TVdiUnUxY0xWSUFRbzFidmpNY1lwN0xOQ05XTnJaKzJIOHh1VzVwb29Y?=
 =?utf-8?B?a0dtNEJJNG93ZTlMVTNrSjZBSEdwQm12RXptMWdHb2duWEpoN1o1WWgxZCtr?=
 =?utf-8?B?TXdiR2NmOWk3K0NvY2d5QUlQbjdwYkhwa3dzRW9XRzZyODNQQzFVMnJPbU9I?=
 =?utf-8?B?emdMd3duMVpQYWdvN0ZpK1VCajBQVm1iR2phUGpJR1JIZEZTU0pIY3RaUHh5?=
 =?utf-8?B?RzVuMTJJTC9tSFRURzc4d21aVEIrZ1Vza3hDazBIbURUYmdTUTJFZ2F0OGEz?=
 =?utf-8?B?ZUhncE55VjFybzl2d0FMcVdKOWxjQVh3RStnaS93eXdENjdMYmdrRDhQRWxX?=
 =?utf-8?B?UHV5UGpRMWNoR3ZmYjYxb2s2THdwQ3BkV0orbVd5L1BMQ0t5Q0VHKy8xOGdU?=
 =?utf-8?B?bHF4RG5iYmpqaVFoVDhyK1U0Uk1kQkljVkdaeWNiU2doc29iQjUzZGNiVW5u?=
 =?utf-8?B?NEdnaXpjY09reWJkVDNGMkVoeTFWd3picEt4VEN6NTRqMnhoNGVFYlprMTZE?=
 =?utf-8?B?c3dRQUFrTDBBL1ZUVEpseExDcUYvdGswVzZtZ0hnQmk0V21uUnBFcWJINk96?=
 =?utf-8?B?dHZKeHpmR0pFVSs4dWNvMFgwaFFUQUduWFRSUlRsVUNtT050MFlzZGxlYnJj?=
 =?utf-8?B?SnAyZDk2dWtFbHcwMk9LZzY1WmtmVkRueHZnbzVNNkUzT2lVM1VQQzl0eisx?=
 =?utf-8?B?N0JpMkJqRmEyMVkydDFCRCtyeDI0VmFyL09XMzVNNldNME1UNEczSkJYNXo2?=
 =?utf-8?B?TDVqSEdSOVc1S1BMTk10bzZJeUF3cjNEdU5DTHd4aDRSdUJsd0dRVlpnc0J2?=
 =?utf-8?B?eDhzbFNkY1J5dFVLUjVSUmUraDZSbGR2bWQ2OXluRGhrTGlza2ZJUjREQlhr?=
 =?utf-8?B?M2ZRYjBuRjdMdGRaSUFqRDFFMy93VjNya1RONk1XTWk2c2IyK2hPenFhaTZq?=
 =?utf-8?B?SG9jOGZxc1UvWFhUUWwrcDk1NE9LYVBiQ2ZDOU8weXczTXBIbUFCaDhrSGV2?=
 =?utf-8?B?a1BBbkJ6eUFnN2VzcUJkRjBmUmgrc0FROHFhMnduNlFIYi8rM0FiWkRncUc4?=
 =?utf-8?B?Y1czZFY0bTc2T3ErcEo0SUFCbjJKNHZ0bDNjYTFjQzVDNVQwVGR2K216UHFj?=
 =?utf-8?B?dGZEU2xLcWJNeDZwUTZiQkcyOEdNNVBvTnpWa0tveFFwUFhteHNreXlMSzVp?=
 =?utf-8?B?Um9IZHlDVVdTZjhVS0swZ0NLOE02ek05RFRSWTlHOTloWjZwc0ZxQjlRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TDQybjhiMUFyV0hWRnBTZ0tBcDgxVWJ0MjJWRE85bHFsV1lEU0s5Y0RSQ1R4?=
 =?utf-8?B?Z1cySU5YY1MvanlnR012d1NKL2NRZlZwa1ZzU2lDcFJ0YjNYOXRwZnp2Rjk0?=
 =?utf-8?B?ZTZ3dDhmbFpYUmlEL1RQQU0rSW5VZ1pFZTMvUXpZcnp0YnV5TU9YOVFlTjkr?=
 =?utf-8?B?TGFiMStDMEo1RzZMWkZ0eWZIVkQ1VEFvMzVqc0t3U2xvVUR2Vis5SE5pTVBU?=
 =?utf-8?B?Yzlhd3ErYVBwTXgyRTY2VWJlaUVHZFZVREtCaHRtZENXczlHVzNlSHpWMFVq?=
 =?utf-8?B?NU0xUk50S0RTTFVoN3dLMzV4TWZmVlQwc2RvTXVDT0V1SUdpR2VRdmFoSG4r?=
 =?utf-8?B?b01LMmNTVFRXTUk5RmZIMmFjNmJWWFdrcFdZMHF2S1lNNGltMmpUM2pPREw0?=
 =?utf-8?B?WGw3RGpFbTBtRzZ2TGQ3Z3hhYVV1ZjR2MFgrclhJb0RsVFhFQm55M1h3K2do?=
 =?utf-8?B?VGNqMlU5L1JNZ3RRNkJrT3VmcU1oREs2amR3N2VDTWVqWGtRdk9sRGRYRUg2?=
 =?utf-8?B?ckthUGdESk03SDZxcE95M1p1NitJQjU2cmtMMHJyWG9lQVBXblliMDdYUmpW?=
 =?utf-8?B?a2dFbWdDVXVsbExaZWJSU0lSK1dIbmFMRlYxOEwzMTlQTnRrWkh3NDJibkNp?=
 =?utf-8?B?YkZrYm1VV1pLLzRvcmNnTXh4UDVRUWpEdkU2dUMxdHdxZG1NbkxZVGxHcktj?=
 =?utf-8?B?MEJGbHZkeW0vcVZQQVVvQ1JUWU4rQ3h0bjhhcVNPNFV3UWdjYnhJZE9Sckpz?=
 =?utf-8?B?MS9jd3RBdUxVeUZKTCtwa2NkR2VNNmU5d0RxbmpqUTErSTNDN1dobTJSMzFT?=
 =?utf-8?B?MmtieWFFMzhkRnBMWkFUbTVtS3YwUFdMNXlMREZXb2tESjI2M05PMEg1S3Zn?=
 =?utf-8?B?Yk9KSzc5QUxTOUZVYnRHWmJWRmkrcnpEeWpxRVZFNXkrN1hxS1BRMW0rc21M?=
 =?utf-8?B?YzhFZ0htR0kxWWo3VUJKY2g3bEJjL3RxakVCZFFWOGlpUDVyRzZzd01UellQ?=
 =?utf-8?B?ckQwVUQ3QmIxTExuZEZCQ1FaYmhaYjRycGYySEJEMzFKWDBlYStzN2VYRW54?=
 =?utf-8?B?S2JheVRZUkM1UEw0ODBxbFU1MHJLdFpLeXI0bFFOaEtGTGpXMDZ1cStsMk9r?=
 =?utf-8?B?RktkRmZhRVFmc0dYNzJhL0xReHErQmJaeDhOam82N2hsa3ZJQUpNYlZEdFZS?=
 =?utf-8?B?MExVcDFMMlJwSDBhQTV1U1ZGY3lRVUZTNktidFc1cjhTb1dzU2pCajNHdS9U?=
 =?utf-8?B?VjNjZFI1NE5MTm1SYk9Jb0JSNlNvNmZndk1TWTBSb0R0MGoxY1J1L2VOUVlN?=
 =?utf-8?B?aExJU1VqQnc5bnc1Z00vdHo1V0FqbzJwN3BsaDlhYVh5eE5LUkFIcmpXU0Vk?=
 =?utf-8?B?Z21iZWVVRG5jZWV0V09wN05UT2R2NGt2cWVXVnlzczNqVDFDc1dGKys3RVJy?=
 =?utf-8?B?cFhRMmhoMEZaRkE4bUtCMWxkRFBqNmJkbzV1WDVqTkxZeHRMWFpmRWNCQ2pm?=
 =?utf-8?B?aFRSb0ZDeVdNN2NSQXdUTlZUY0Q5RmVIbi9nNnhWdzZ0cXd0SVpQQXJvUWRx?=
 =?utf-8?B?blFCQ0VQM3hWUUEweGZjSE9jS0VuRi9jTUpNMElNWXU3YWlhb3A3L1lPK0Zn?=
 =?utf-8?B?alkycDgrc0ZBaEtwN3ZCaS9sZldHdzcrUXNJa3ZEemlpOFMwcmVMSU00eXQ4?=
 =?utf-8?B?M1kvckZhWHd5bkpNcGVCK0JFZSt0S0tTZ3Z3TzRwYi9uMmJOQVJ5MTN6TUFY?=
 =?utf-8?B?VU53Nit3NEdYQ1llK1RiZ3pOWityZ0Uvb3BoTVRHTmRuTzJTdUdnK2M1YStW?=
 =?utf-8?B?UW11cGlsKzh1cUFYbjl1ZTFHUENSc0JST0FiNXZvQVFhMENxTHErR3VuT3Fi?=
 =?utf-8?B?R1B6eEo2OVdvYXdJMFhDQXR6R3Iya2ZtLzlxODd2RUxrZmZIRjlpWmFYWElp?=
 =?utf-8?B?Q3pXVlBKbG1sWlhEeHZHR1BwUkNGT0xiK2p1LzhDeXNka1RBNzV1ZXNqdG5C?=
 =?utf-8?B?a1Z5SS9oOFUxWDhoRVhlclcvRjUybzhtTTBVakU4ZGlodkdveG84cE9mVERE?=
 =?utf-8?B?SWlranVUbHBJcXBwQWEwZFl5b0c5enJCTnU2Q2c5S1BPNUhtUVEzWUdHc0t5?=
 =?utf-8?B?MnpxUTc3S0k1TkczOWRCM3M4RVhSY3ZoaTRSSnZ2L2ZNZ0x0Y2hubmEvVndE?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iJybgj9ezLrcXirSSsgcBExPA9WCILrjQMgqFOZQUDxj7+9u4AiKlcuFrXqZJeEoA035z/33fLbVfaN+uEwqkKDHB8kKJ4v3WQAeJk7wl1iM9V5Wc+NFsvSSchWvBuvzRd34sBygLMrhborBv84vhgx1vtJQtUzydhhhJYadMyNueV3UM+e6nnmwH05gAOrUqu9Z1+/QOt74vp1wzzZbtYX2XRpwSbzGqqfRw04kJVc7EDW5YlskGK+4EAxH/WGP54pwF4EdBvdcsudAY7qVXtINq09CpmJqAeGUZAQivHKcHdWIyvsFafNYpUvP7K9EbLAZB3gL584ptPo021mS3CsN9SbMC0WKvE10U/z1jaqItPfeZrUbspZmkFEtrzEns2Ol+HYArm4OYZq2mgHancsMoWXIwEaArANQGbP7tXHSg0wrZ02FAs4jiHjLyNX4uBpkz0eysqY4Sjm3yY+u9T93lVvEQKFZUtCloQcPACR5sSXwLJhOdTooiggiPLiOcinDb5SZO+7Jzwea2sxxUz66DrB/KYb3BBTnACVVKWqW1dodZCpTfm2dO4lX/A4KaUngG31Xon5XoKk6qEunoMmQR3v3u+Nrya2HFXNOlTM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e09fcbb-2229-4934-ba20-08dc6e768318
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 09:17:26.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1dZlgygjMdOnOKqL1rM1PQK42IT6hhS3Q89AL4k/mrfRyPp3dPpR4ZHRevDtCovP5wcVViD4mpWggAGA0XIYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_03,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070063
X-Proofpoint-GUID: yl-bZhu7ryKBpnsO-dabGQ_erMsc_Whd
X-Proofpoint-ORIG-GUID: yl-bZhu7ryKBpnsO-dabGQ_erMsc_Whd

On 07/05/2024 09:44, Li, Eric (Honggang) wrote:
> Resend this email.
> 
>> -----Original Message-----
>> From: Li, Eric (Honggang)
>> Sent: Monday, May 6, 2024 9:50 AM
>> To: John Garry <john.g.garry@oracle.com>; Jason Yan <yanaijie@huawei.com>;
>> james.bottomley@hansenpartnership.com; Martin K . Petersen <martin.petersen@oracle.com>
>> Cc: linux-scsi@vger.kernel.org
>> Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS expanders in a domain
>>
>>> -----Original Message-----
>>> From: John Garry <john.g.garry@oracle.com>
>>> Sent: Friday, May 3, 2024 4:33 PM
>>> To: Li, Eric (Honggang) <Eric.H.Li@Dell.com>; Jason Yan
>>> <yanaijie@huawei.com>; james.bottomley@hansenpartnership.com; Martin K
>>> . Petersen <martin.petersen@oracle.com>
>>> Cc: linux-scsi@vger.kernel.org
>>> Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
>>> expanders in a domain
>>>
>>>
>>> [EXTERNAL EMAIL]
>>>
>>> On 03/05/2024 04:15, Li, Eric (Honggang) wrote:
>>>> John,
>>>>
>>>> I agree that the call to sas_ex_join_wide_port() is not mandatory.
>>>> In fact, some logic here is similar to that function. We don't need
>>>> to do it again.
>>>> But just updating the phy_state may not be enough. I suppose you
>>>> still need to add that PHY into the corresponding wide port by
>>>> calling
>>>> sas_port_add_phy() and update phy->port.
>>>> Just updating the phy_state may avoid the port disabled in this
>>>> issue, but other missing piece of work may cause other issues.
>>>>
>>>
>>> If you check the commit in which that call to sas_ex_join_wide_port()
>>> was originally added - 19252de - it was added together with the
>>> comment "Due to races, the phy might not get added to the wide port,
>>> so we add the phy to the wide port here". However the code to set phy_state =
>> PHY_STATE_DISCOVERED already existed before that commit.
>>>
>>> When all that code was removed in a1b6fb947f923, I am just wondering
>>> if we have kept the phy_state = PHY_STATE_DISCOVERED code.
>>>
>>> Anyway, would we really join a wideport with the downstream expander?
>>> I would just assume that we would be creating a new wideport, and a
>>> subsequent scanned phy would be added to it.
>>
>> [Eric: ] I don't think the code removed in a1b6fb947f923 is the right way to fix this issue.
>> It just happened avoiding this issue occurring.

Sure, I don't particularly like it as a fix either. But first I would 
like to get your setup working again to verify that only this needs 
fixing. Indeed something else may be broken since a1b6fb947f923. In 
addition, if we need to backport a fix, I would only like to backport a 
fix for real known broken topologies, and not theoretical issues not 
experienced.

But what exact setup do you have? I am confused, as you seem to be 
talking about your setup being broken, but then other setup may also 
being broken, but you don't have access to another setup. What is the 
other setup?



>> I think the root cause of this issue is the order of function calls to
>> sas_dev_present_in_domain() and sas_ex_join_wide_port().
>> My concern here is whether or not we still need to configure routing on the parent SAS
>> expander before calling sas_ex_join_wide_port().
>> This part of logic is not present previously and I don't have environment to test this.
>>
>> Back to your question, I believe we do need to join a wideport to downstream expander.
>> Changing the phy_state to PHY_STATE_DISCOVERED will skip scanning those PHYs,

I would have thought that re-adding the code removed in a1b6fb947f923 to 
set PHY_STATE_DISCOVERED would only affect the first phy scanned in that 
wideport. Other phys scanned would have it set through calls to 
sas_ex_join_wide_port()

> by
>> not calling the function sas_ex_discover_dev() to subsequential PHYs within this port (so
>> this issue wouldn’t hit). But those PHYs are not associated with a SAS port. This may trigger
>> other issues (for example, any change count changed on that PHY, or SAS topology in sysfs,
>> etc.)
>>ok, this can be considered more when I understand exactly what you have 
and what else you think may be broken.

Thanks,
John



