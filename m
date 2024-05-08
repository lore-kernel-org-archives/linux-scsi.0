Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AA62E417
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 07:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715154566; cv=fail; b=GLg2a4vXnylb1btyQF0tTobFSf7nqzW+E/4+SRvIxD4yCZgR7zX9/OIKvudqve25aOecQA/ByIQbOzWx2nnW4kjmy34zyByIBst7KHSEGFo0V9BzG+XPedEeC9D1hYFx+4v4mlnepNQBmmTmFUHjj8RD8o+mYxt93w4qL7FkJT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715154566; c=relaxed/simple;
	bh=WitI5I4YPVaeBotYwNSMFZB63oe/LinYV/lAfieYOcg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aLjh/9vLnoEl4aAcNdqsuQXiTfXX8Kouk7+wFFu4VrkPkBf7AlCe8lQxo2BCtEBaYd+B49RnnkfrSyJuJVBTWg6Vn2Ve6uznPDqa/a67+z8VaK8rDmK1Uu6CKs1R/fsXZFwJku/KBVUnaQ0WWpzQC9I4YBRTRPYZl4W8SmmG4xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UvUEkLIA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NkkhuK8o; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UvUEkLIA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NkkhuK8o"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4486h8T4014423;
	Wed, 8 May 2024 07:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=+jBw1TjXKB+QzSVsT7VVPN/1+D9LWBgFlszV5xKCcnk=;
 b=UvUEkLIA87hmYp2z+1oDLE/7Oq6cP14PgHynB4+nXKeuoitJlr2M8WouMt7uU9O/kJ/C
 6hLESWj9hcqVpTUoI7VM0PMYF0p6gDbJLMXLTjkwzBNAZ4bpwY9E6K7WX4xMs/nc9Khf
 zq01TJy+blkdxwvXO/RxS+/J486XKEU/swQAGQsHh50WBi4gfb0mM5dfN2w5eXSluhro
 Ich2La22GYMJGYQyfqz2MYZ/cYEzXqKAixO0+E0TbXL3yTRGAJj/dYE7aXhMepO+tGkK
 g/nmuCYxPU36pOV9KhW6rahAaNRU85Qh+m4hfDTXf/HR03GwE9J2QrtPI49AZmlMVxnT 6w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfv1383-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 07:48:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4486LTot030606;
	Wed, 8 May 2024 07:48:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfkpm90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 07:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKDP5T337ckn2ZgTdqeliS8Vic9FBxvNWWE4OsEGJA10ymmBb8ex+zZJqHQNbVbtxHjhZz3CjpMMFHIbdeYMRC8kYuO46fxo2dtOaQh2MwGN8M0uvLQFrr7++rX2yPocINXcpMoEBW99oEaYdC8HkI06HhYAwPMu5RoYz2HGBzwplIHpFlEuepHVz5FChW+TF8iXaCu4LcLnwBeEFkweSK5WgimUZbHJVS9pZV3fgmeeO97vofJyV0jVMxfR45oHd/f36m3JFxelSBxbTs6m8g5YRR3NeE+2PHq0AYqo0/nURVVPenpCTlS+ahj/V3fKXiBdoU2A5ymfyqs8LR8T+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jBw1TjXKB+QzSVsT7VVPN/1+D9LWBgFlszV5xKCcnk=;
 b=WqXVWRucYAgvxLRqhIOGeBkhkm+TFsqiAh1vm80d97A6H7CAbHc0MeNH8+nrEayKjgc9tEXtZigOb8CeJIlRb5Wp8f2Y5tHJn7gwKQNs6l3iWVil+UdAYTY0a5ash3zdhYPcanlgGQaS91Yd9LH5bPA0tiLB6dG+TXt/kB5n5dwHI2dv4iYBPgk2YMBYk7XtXKs6mU4k/Ol3MITc/U2VPwh1mE1mp+V+lrlcg+VConaD/tjZirEYiYEyrozKBGCPQP9O6TshCA/9fxq24nPCx5DK+Rw6+r7suJ8aBBDMCJU//slFA5Y4CwqRLLty32qIM1sq4HpqmCLyjfi7oPZ2+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jBw1TjXKB+QzSVsT7VVPN/1+D9LWBgFlszV5xKCcnk=;
 b=NkkhuK8o5BnxiXXV10gu5Q37+Zqdxrc0YyaZt/X6yJFu7w8jkpUFWh6az8mzaY4BYp59J8Qax/eq44r7VrC9S+HTm4mo5vIfnV+eQ65wysxXNu7ajefz7l/tdrYOd+a9+iVrzruxOOUHv8x58nxnZkgmncdI37Lo3CPT2B/nmK8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5951.namprd10.prod.outlook.com (2603:10b6:8:84::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 07:48:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 07:48:34 +0000
Message-ID: <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
Date: Wed, 8 May 2024 08:48:29 +0100
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
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU6P191CA0009.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:540::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 00656310-c90f-48fc-648e-08dc6f3342ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?LzJIT2ZFTlByM2kyemJ6ODdJZlNNa0txRWo4Y0hIbWFzamFXeE1NUk93ZGlp?=
 =?utf-8?B?TS8yZkZNdkJOTDQvUFFMTEtYQWVhVk1tSHQ0U29zVXM3cmxIbmlhaDNCWXRs?=
 =?utf-8?B?SWV5TG5DckFaYmUvU3pkb25kb2IweDlyb0VxK2pnemtLckZpaVpOQzF0dzhy?=
 =?utf-8?B?dXF3UFFyRDdRakhEZkE1ZGdDN3U1ajZibWloNXJSNXh0d1RVcU9xcmYvNzhN?=
 =?utf-8?B?TEpqbmtnQXVxWW9kcW9MYjNUd2pQc0c1bXFVMkxJSmxtK1FZYkZFUDZYdTYy?=
 =?utf-8?B?d0pJbkI4cHF4MStHOFM2WGt2ZEs2d1ovV05EeWwzVHVYem16ek9lbFJ1b2tJ?=
 =?utf-8?B?S1BubVZ0L21CRTRoaU45bHdrblFqVGtUWEtvdGtzWEtEMElmUjlMajBjY05K?=
 =?utf-8?B?ek4wWERxcll2ZENnM0VaNUdqNzBmUkpHYVJLUTQ4TzRrVTVzcnliS0hrY2Ez?=
 =?utf-8?B?QVZiZUtvL0ZnK0t5d1VmR2pSNjIzQk5kemtSTElnQUNPVkp6VlArcE9icDBl?=
 =?utf-8?B?UnY4aHRUSVIzREVjUzhFMkxiQ0hrckU0ZkhzdklxVDVsUTc5MmFkK2xiUVRR?=
 =?utf-8?B?c2RBTkFaUjIxY0I3aStRS1hXUFB2a1Jvb0ZMcHhBOWU4amtvcXZPUEQweHFV?=
 =?utf-8?B?cHVQZmtvLy9jM2NNUnRTa2t3M2tVVEk3VG80VEkwZUtRNzc4NFlKeGR4emlz?=
 =?utf-8?B?djR5aUw2VVZuNzE3cnUyQ0cySnFyOXV2aCtBd25XalQ5ZGZsL2dNOXROaStw?=
 =?utf-8?B?a3NwVzlNNmhxclhoOWNwcVRTMzNtb05HcldETHNYb0UrWld0WmpFcy9vMXk3?=
 =?utf-8?B?bjMrbGwyUGZKWHNQaEoxdkF5aiszOEVwNE5FY3VqZ1o0UnQ2SldUbFFid28x?=
 =?utf-8?B?ejRyS015MHBkYlBGenoveUNyQm5qM05hRTJtWXFmU1U5SlZvdCtqTnZyU1Jt?=
 =?utf-8?B?aE91OHVPMlFGK200RGxlTmtESlo3RTdzUWJpVnorVXFHOEZzWnFpZ2FGVFlT?=
 =?utf-8?B?cXpTUXNRR2hmSWs0akhrL3JkVlhYb1Z2elhSck5DMkNKNXdFRk44VEs2YXha?=
 =?utf-8?B?WDZWeURvZGF3ZlIrSUJVVmY1d2tpT2VUMXlMaFFPd3pOSm9JUjBiQnByc0xO?=
 =?utf-8?B?S0xyOHdBc1Z5b2QvZk85d3ZwWnFTRUtDcGc0ckxENGpsYnBndGJ5bWgxZi93?=
 =?utf-8?B?REY4cFRzVjRNam94ZHhLY3NPODBrTlJrK25NcnI1L2U3RzN2NVRGSlNheXpJ?=
 =?utf-8?B?U3R1RnZ6MXcyay9MVWMybGhrREdhWWJwL0haS0JoT3lKOUNYdHJBOElvTlhE?=
 =?utf-8?B?UE9JSXFjZ3RMaXBmdFpmNGt3QW9aRUhUL0hDQTM5WHpvQStqbG1hcjk0eXZt?=
 =?utf-8?B?c0RaOFRBVDd5VXlqWTZkMEZhQmI4NXpoYzJzSHNzODM1N3F6amlyRlBxY29y?=
 =?utf-8?B?N0NMLzZSM0V2dEg4TXhkaUVwVlArSUhteUtYa3ZwTHJ4UEpuSzQ1R0Q0NmRO?=
 =?utf-8?B?UnNSTTFwWTFIdlZRZjY4cHRTekhZc2l0V1dKemI0RnZCb3lud0FKKzRvZFlT?=
 =?utf-8?B?aDZWa2pJU1dpL280UFR5RHE5Y1RVUGxaemdTVmxVZ1lBNUtyd2UreFFTVHVB?=
 =?utf-8?B?UFZSMld2aG9aZXZmMm5PSVFYTGhUd3lVaTI0Nk9kRnozeldaZHRNbkVPNlZr?=
 =?utf-8?B?VVE5ci9nbjNoVlFYY3BNaTF0NW92a3JmdnV1QitFRWNueWpnY242WUx3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RWNoSGxEQnhUa1FKQUFabVpDZ0N1NlNHeVFSZG1jbDNJQlczTlFyMjlaa2tz?=
 =?utf-8?B?TWgrZ1F5by85Nzh1STJ2VU5rS1JlUVB1REpRZ3l4ek9NUTM0em9MbFpqZXQ4?=
 =?utf-8?B?NTUxN0JJZjhVcFpvQmxnQ2R2ZUxCd2RXRXREaXM0U0NzN3VFa0hmdXdXZmJL?=
 =?utf-8?B?RFRYMmlCQTJ5Q1hZdzYvd0xBakU1djFWMXI2MCswLzRPMndnUjhxTFovUHhz?=
 =?utf-8?B?am1OVzF0aGVWMGtPWG9qUHMzMEZMTUlva0pwa0lkM01CWlE5L2RLeFpDR2xj?=
 =?utf-8?B?Q054NUZzeVNqR0NWcjVMNllRY2IwNkpjT1pmcXlqdGlPa3g1L2FiTm5LdXBD?=
 =?utf-8?B?UTVCMURtUThJNkdUQzE4MWNVNW5PN2UxU3RFT0lBWWVFNlRQOFUzSmFFYkQ0?=
 =?utf-8?B?dmdqUmpnZXZ2SlMwS2p2TnNtMXRsb1dqUDRMOUQ3L3JtdnllTElML21xYUV6?=
 =?utf-8?B?aGxIMXVwMm5TZnUxL01TcWxzTzE4U0pkS0dLTU9FaHkzUmNxMWdVNmx5cVlD?=
 =?utf-8?B?NGh6UGNNY0lTM2ZaMkFRSkxQRWpZN0NiQkFZeEdoNVZhOElFUmlJMXFRR0RY?=
 =?utf-8?B?UTQ2cGR0MTVXVnA5NVZvUzhvMXFUSERwU0dGWUFpTlNpSEdpMTJrc0RKdmxq?=
 =?utf-8?B?ZU1QSjc4dFV2OVZmbURSS2dYNzd4c0hTazVOUUlUaFRyOXZFYzdTbTVpSUJl?=
 =?utf-8?B?NXBQWXRtLzY4TjlsRXYzT2MrTUx2NGFYbmszQ1BLZ3pVTnVER0cyNFFnbVhV?=
 =?utf-8?B?bEdQSzlLZTJhdlFaVHJROW81dGk0cWozZTUybS9JM0VmMGRnZEF5UVpyamFw?=
 =?utf-8?B?MDJXUnFiaHRnOTFrK0E0cUdDVGd6cFdSaEhnU2JRV1hBU1VlTDJpcmhPWVh6?=
 =?utf-8?B?SzhJRFJHYWsyUlFYOWxOVFdHM0t5d01CQ0oxR2ZtNTdENWg0RHpiOFNEN0pz?=
 =?utf-8?B?c0NweEkzRmVGc1l1bi9VQU1HRmtZWHk1VEJmcklFMjhsY3NZRGc4RUt3cVA3?=
 =?utf-8?B?eFNMQUk2Q0RDK0pPcmJJSEd5OU1jNm5aNlhlK1FXdUdIdldPakE5a0I1UnZE?=
 =?utf-8?B?MGJUaTJFanRaVW1xU1VwZi9sd0N2QXpIQ0wyRFpXeGsxb2pVYWRacVJUdTUr?=
 =?utf-8?B?TWxPejhOTW52Si9HdHFTYjB1OE1TUUo4bUpFdlI3MTZydnFVS3MvcjFCRER5?=
 =?utf-8?B?UUJrM2NsVml2ZDJtNmVybW5nRjhFeFdTNlpuaGhUWEpheFpjZlF1SDNnL3hM?=
 =?utf-8?B?MXcyVHJHVVcyQWlTUlpxTHowWmFHLzF1d1RsMDNDYm9NM01OWWNmaC9QcW5t?=
 =?utf-8?B?NFlFSkJQWW5iYTRyK0tuazZneFdFZUpTNTBCRFNnQ2IrZXJlOVk4R0xJWlhE?=
 =?utf-8?B?V1VRMk1sRVJyYzFLZnFNV0gzVng4ZlV5d2dqd1FaSHNTajBJbnl1RFNsQ3ZN?=
 =?utf-8?B?YTZSWXRDOVoydy9Gb3cxMC9ZV0VFSnNZWlNlOGJwbUFDQ2N0NXAyNW8rZjFH?=
 =?utf-8?B?UmVoUUV4RDJydXZvQmpvc3pXNEl2aVNBOEdWeUJxTzhZb3Y5K0pSRUxCcER3?=
 =?utf-8?B?WEljU29UMFM2WEZJdTB2MGIvZ1Zadi9LU200enRPRERLVDMzSGRuSWF6aHE4?=
 =?utf-8?B?QXlVTlVrM2NsRUQ2aUpqcW1FVDl6c20wUzBROGxEQ1ZxL09JNnB6Y3AreENI?=
 =?utf-8?B?ZmtQTlpSV0J5RXJXSmtuZHB2cFd6QXcwR2RFdXIrQWhudUN6dndhMHVVSk5v?=
 =?utf-8?B?SWswNDR0eUxQTFo0NWNEbmJWVUl4cVA4b0U2Yzl0T3ZxRnRYR3NIb1Q5UktG?=
 =?utf-8?B?T3NvODRrc2tlMGhNTkc0WnoxVS9jUkM4VnhVVjU3VUtibTNSdGJiQnRZTkxx?=
 =?utf-8?B?Nm9paytNNXd4ajl3cGFKd1VRYXdUQk5LdnF3L2tlVG9vZ0pWcURzbFNKWFU1?=
 =?utf-8?B?Ukw0L1FYWnU3czNvVlZVeUlZWTlQV3FBSDYrNUxTOEVuL09XZjhXQ1dWcG1n?=
 =?utf-8?B?a3Bwd0ZIenoxL0xQL2dUZHFZTFVxS3g0cVVVajJxR0VSNkY2NHNWQWNQakVK?=
 =?utf-8?B?TURIS3hQK2V2S0RQK3JBOGRDUllDR2NMMnRrUWNPaTYyZTBkMlg0S0hMWmNo?=
 =?utf-8?B?ZjUzWEs5T2ZMaVNBN21IRDVzdkJUUnp6QWRFczFCdU1MeW9IRFRSK0l0Y2pG?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PaaKszIO11EZ9IKOSAGWXKsFp03vQIyN+BsEjokpbPIEjUR40+pxT1cXrFBKQWywpUs1kz59hE8wRtaNv5jzbXpe1JQvFvj5EqgDyBcRtgBA70Lllt5I0VR10dqGu/zGByQ44oBTLuX2hoaVyB947CIRJC2PYsCsXfzfrQozmYJ+FfXwjoowXrZ8jbI6vERkKfO9aigQeaHCY0GdsXybEaJ57mlgnGWPCrWJ10QIzDaB+XDosIxOKEQAIx9GVQ2xUY0qp+mG5dCCjzSfpeYXu6/JDv6Dz6KWAlFFir50od+/wRxBabgzrw5cZrjOTYp82zCnhoUv+3/YCOTgbfOXKgO0EIWEJ/oMCdHmmB//z//xNM2YfHUlZVojOXS0Jiyt8nR/OwQc9H+BtIFVLW487G/qxll0ETa9XiFjluRXAOCx9I1br32cj0Va8VRGAnwCgA6PunDxhhVfZHbkX5/9D0bzvmisxwfWzWy+uyl7HOtjGr5qjP2ek5lmjefoRoT4Dd7sKmlFsfrk9lqu1dunTjAY+6ns9I3cNC3d+NQmz8RSOj6v6+QQc7HTEWgkvk6yFy5FlXFgajrM07nVZGQcYueEiyhxoOpnAo+sYycJwVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00656310-c90f-48fc-648e-08dc6f3342ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 07:48:34.0000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOGCki8bN/wZWqTV5lHRxe6d52JgtaejGjNG3K1GuTsN6I2z6GPuRt9bS+y9oCdo48eART8BuCkVWMBYK1ovwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5951
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_04,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080057
X-Proofpoint-ORIG-GUID: ueGSlm8W5JNQvkhfRrIuHOmlM-YANRDs
X-Proofpoint-GUID: ueGSlm8W5JNQvkhfRrIuHOmlM-YANRDs

On 08/05/2024 01:59, Li, Eric (Honggang) wrote:
>>> Call to sas_ex_join_wide_port() makes the rest PHYs associated with that existing port
>> (making it become wideport) and set up sysfs between the PHY and port. > Set
>> PHY_STATE_DISCOVERED would make the rest PHYs not being scanned/discovered again
>> (as this wide port is already scanned).
>>
>> If you can just confirm that re-adding the code to set phy_state = DISCOVERED is good
>> enough to see the SAS disks again, then this can be further discussed. >>
> OK. I will work on that and keep you updated.

I expect a flow like this for scanning of the downstream expander:

sas_discover_new(struct domain_device *dev [upstream expander], int 
phy_id_a) -> sas_ex_discover_devices(single = -1) -> 
sas_ex_discover_dev(phy_id_b) for each phy in @dev non-vacant and 
non-discovered -> sas_ex_discover_expander( [downstream expander]) for 
first phy scanned which belongs to downstream expander.

And following that we have continue to scan phys in 
sas_ex_discover_devices(single = -1) -> sas_ex_discover_dev(phy_id_b) -> 
sas_ex_join_wide_port() ->  for each non-vacant and non-discovered phy 
in phy_id_b which matches that downstream expander.

Can you see why this does not actually work/occur?

Thanks,
John

