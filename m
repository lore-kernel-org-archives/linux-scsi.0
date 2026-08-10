Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CA83F9A15
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786372048; cv=fail; b=EvMjWcgo4mchkb7CbgXUhwZhMAXDHBA6i4ZVr7Q7Cys+FYuB5Q+1uv+bWv6izag0ECCNxnPiAfHQTvo6vGkVVjHyE6EsmPN5d1Y3HSt7VwhYSAXKMrNKNYinp9IVVaJGh61JmoL19Vd+dOTU47klJ792teUQgT0DdFwIJd0HTcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786372048; c=relaxed/simple;
	bh=a+dZuCPN1sSWRSIxiNdBRvN8qRGFniPYib4hLmc9Pps=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tv/U8gyEasjaQP+u+DW+BK3WwcRNGvSgWyCyGhgl8GNxDi3jONXbOC66ZZ7NCG0rpx131Rl7QynhHIHShH3WWLbIV25ZFAxLjw+aY/G5iXhzb/k2yYNCSBZqFJbsr//q8RVkntcc/HTjzy9j6uJFemeQww3S8kr1Z7gEB1Jv9sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UFX72i/8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gWYW5EqN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UFX72i/8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gWYW5EqN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A015Cs2748471;
	Mon, 10 Aug 2026 14:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XUO98ga2bOewdEdIIgoNdGozrjWkFky1q0S8IvAovZI=; b=
	UFX72i/8tXudan8fMG6rlQ5LXcGsuJSDV3k0Z9kIWL2c8bkIdydrRqYL4156Mvfq
	lytTcM+kjpyGHt86MPik+BPTrjZOhK2ULnMSNeChlCcnjNbad7kgVgPsJQQq3+F1
	hqK8FMSCy/Us1DUhRi1hhcK/B4bLsFNc5dZQXQXQM5OaVcx6pEKyP1crQH07YGb3
	sLKqcPKFNJA8vtLhj2lKQRtcN2wAxpvgdOvHv/JVc+j0NulaxrO7LS3igZYduqVb
	2yUANUouITVxyfD5hlbs0Yw+84jTYVu77rYsoujEZDnqdB/QXpEKiq8KWnqq7iV2
	O/mf/4923+u1g+aW3xp4Gw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvfxtp92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Aug 2026 14:27:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67AEPXER005489;
	Mon, 10 Aug 2026 14:27:17 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwqa4f5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 14:27:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/zLgs4nVPSjebFsp6wegnxcXYyKHYfGHTCeBFVs0a+hdoEReqAmV7dMH/MhGJjgV82SSg6yT1XHAGFgKFCBKUkMONExmT+ozZjoTrc+kbpkIblBekbpTYQk8cn5N7koUqDHhJPhRVlFeacNlvFqTpWLFyLfOX7thbl+plSrFVjkzbseY5kBwOD/RbG+NWpCUxfBbNuRfCt8AKGlYdCDi2ghLW1Kl6PF1jji2UIhPq8a6ZJ3X7jp2CtpSNMNNWKMXMeamL54f/IpW1LRwPFlg4wQBFPmpbAZijQXeiY5XrnG0lh3QKK46754567NBxMk56neSGXOtf2/2y3RVUvq7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUO98ga2bOewdEdIIgoNdGozrjWkFky1q0S8IvAovZI=;
 b=rIQJRj7269bSPoTxEizzk+NIxzF8gVrIgszlaKwTy7pnVqTB/oQrYQ1/fLbncfMOZW0KvoYaI1i1tn90SFdCfzJkLwY/UCT/NJG8I1fD7DKfLpzwcSOzlYgKfP4/9wFPiyFd1uxgDQhEi+0Sz4udPtsIEeaMRp/5nHfsuh0mIk4eGwFjaMa/4PQOGYNB2APeQGhb9i6K94ecw1S1Jl1wFw00C5QPqHrOVecwyMhBhqLAiZOEs7QY7XJm8htweeoiDgulkbdzHArftw8mZ8igJhFTSred7ubMna8OSMvihuXy8+IH+Gz/qQzrv1caP5zH0WBDHHDZvHJDmzVavhGLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUO98ga2bOewdEdIIgoNdGozrjWkFky1q0S8IvAovZI=;
 b=gWYW5EqNYxY55J2LjMzVPbbvGhgwzfd7G3ukPDbPn1Ze9n8N+VE4OATCOcoN2w6Gvejnw0BVmRr9C11Tqff30d3H4YK/WtSe8VWLMlvRI60LxPEEbpFi39S/BcgWN0g5RTDPa7e04eEUPAJILht7bF/wtm0pYF4m/idYxkdE08E=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB6352.namprd10.prod.outlook.com (2603:10b6:a03:47a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 14:27:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 14:27:05 +0000
Message-ID: <c324172a-a754-4194-a841-ec1d813dfde5@oracle.com>
Date: Mon, 10 Aug 2026 15:27:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/56] scsi: qla2xxx: Add FC operational firmware load
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com,
        hare@suse.com
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-6-njavali@marvell.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723050413.3897522-6-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0095.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: 05ed7339-e8b9-4996-480c-08def6eb73a7
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 D7TIPOhLuYe6SVl/zuqJY+tH3Whnf1Tyia+AG+jTsbG1nUz2EZnYzz7B6pKqumLNQhHqd9aGE4RyBzZXwMaQOYASqMpa67YVz2lN3gflnzqpQ85Rol+hbhEddX0+SHBdJC/zKPIZjO57jo7Yqg422qXV9xbv+cDJGyzsgZTEFWHy9WDVqPeJ4bunEWWLbUkYIc0XeC5dXW8ahG/PS+JyC/Jw4tgWvymuBTSdOFYaagRRTq9W+9neXK7zpJjdZnGpxTD8VxybMFc+jkG/JOZOiy2s67uDmeZkcnXJN820dY5gVtxBZZxgEeb5/qsYUfgmNc8YsfIjUDmF2lGASnjKZgfH/BwPyhPwsvw4SD8B0yY5CXJzpFjcHtOVQddThvLp52xWdIMDQVXd6HhP8zzyoNkV+REqVly024gDqoJQm/2SpD9rSlgr3i/zKK1q3yixAFZ+TvyhDfEwZDG6vXgIy5BOPw1a2n7J8nRfBTxqjFHLVrn7HQro4pISo5rZrFOmwFpSuMysw283U+BErq62vsaQ2O5TJuzPHj/HDTjTENVYahFhETBJkblpqgoNVs7mXVjUpOqn/Nngk8sIyX8D7bA9j6cGqbIK3QgRZDdIn7T3WSGwExpk7LC+x/R39+OyY+EvEfCJuykOmg44+G5RFJ8QJsKFGeJfdm4RSe8QbmE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QVR0V01LTHJmYThKTXd0NTF4MXV0STNxVlRoamtSVVoyN3dkdXRBeVMzVHow?=
 =?utf-8?B?ak16Q3pQVFU4cUVrMk9KeEhKc05sVk9kZG9jR2xqQkVMMHFiSGt3YkFEOFdE?=
 =?utf-8?B?VWVZWHVSbmF5ZUoyeUEvVkczYVlRSVVXOGkrbG02NFl0UmllQ1pIbUxuN1Bk?=
 =?utf-8?B?bXdsc0crTVZkcVg2U0J5WDRxTGNQcjRmZTE1TUJsMTRiRVRQWkdiZ3MvSU01?=
 =?utf-8?B?bHNQMld0NVNaV0cvU2VCOHAvenM1SjQwYjdhbzNQOEpJNitpUlFNelFCZU5C?=
 =?utf-8?B?VEs0czJHSDBiMHV3TXZnOG10aUVVR0lsd0l6cCtkMkFRY21RMzdYRzIwdHpm?=
 =?utf-8?B?aDdYd3dlR2xBcGZxWlpHRHUrMFlTRjcyYU04TWVKcUZ3ckVtdkVwcldwN2lI?=
 =?utf-8?B?WjVrZXV3WTFkd3FNTGZRTmx0WkIzaVNPWTBIZ1VKNVF1UC9uWUtTS2F1Y1dK?=
 =?utf-8?B?alA0Q3BXTk5XQ0pLY0NVNjRnYXppYkIwOFZiNVBXOTZ5bTV4ak5rL3E1aFVz?=
 =?utf-8?B?bkt1WHFjekM4QlRvczBiRXNHcFBpa2lmV2lxbS9zU2N2RERHcjNhWlYxVnkr?=
 =?utf-8?B?a1I3WGxybUorUUZMN2ZGUXlpNnUvM3ZyaE5NSUlrSGlRU2J5WWpBQ0JCVGoy?=
 =?utf-8?B?NXFjTjNlcXQyaXloNTN6eHZ5TWc4ekpPMnFaaWNHV0VGYi9SMElab2hOYXlx?=
 =?utf-8?B?RHFRVU9NSVBFd3hCeXhtd1dOdjM1VERwSXd3elVvckhyNHhRaEVHZkVwcWNI?=
 =?utf-8?B?VHUyOFMxcy9vLzlmbnltZUhzTXVjUHV5bis5dEFjMlhEb1ExY3Q4Mk80R2hv?=
 =?utf-8?B?UkZrZld4UzRWOVU3K1ZreFdON1ZXQVVyU3JmNE1BZy9HZ3gva3NiSUVLaHY4?=
 =?utf-8?B?RHY4SElkbHpVOE1ZR2dJTkJkSzk3NDNob2EybmRtRVBVZVQrRmNPd0xHTlhu?=
 =?utf-8?B?QnBxaEs5OGh0bWZGRnVWVE5lRG40OVFwMFp3V2hCYUxlNXdaUlRPWWhpeFp0?=
 =?utf-8?B?TGhlRERxR0NwczRzNFQ2ZE1Pd2NNS0JzUXEvcnhCYkFyNWtGRXBzSzlTNElw?=
 =?utf-8?B?Y2x4YWJqQkdCQitJdVVFZndYbSs2MlkrenhiV0txeTYraHJDNURFeCtJS0hC?=
 =?utf-8?B?TjVSOTF2R1ZkK01QL2ZLdEwxWDRkM21IdVVkTlB4ckx6dXJpOGNxQkRSZUJE?=
 =?utf-8?B?NXYzeVBHOUpNYzlSTXBkREFMdG5wTmhVQVk2RGRZUFk3cW1Wdm9BTFRjQ0t2?=
 =?utf-8?B?dmxQKzNXQ3VzTHpabDRQWGFvbDRId2MwMGlrNGp1S3czaTJNbkt1UEpTTWhk?=
 =?utf-8?B?STJZQWIyQldYMzdycktDamRHQUl2eUhROE84QndtSERIaEpLaXcyWDlDbFpx?=
 =?utf-8?B?NW1oWm10Nk1sWmFneXlSRWs3QnRROHdWbXJKdHVUUzRRU1JHZnA2eGpnM1Bq?=
 =?utf-8?B?aE1TS0U0U1hqOVpQVC84ek5oN3JFdzVWOURGMnluS3FSK2NhR1lGQXVIMXJk?=
 =?utf-8?B?N09uTE15QmUzL0kvZnZsandaVVFnM2FLRndtSXNJK1RtclNZOEc3eko5RnRO?=
 =?utf-8?B?WVMzdTByVzR4MmZlNUJnMkptV2k3bDBvZWtaMWozbjVHZXhJTFMwZXIyZEJL?=
 =?utf-8?B?M01kQ1B0QS9qZDNNcXdhR1g3dG8vbWVuTmVJam8wZ0pkcjIyalFOVVlQa21J?=
 =?utf-8?B?RlE0Yk1zR2xCN0E1SmU4SHQyUjM4MW9JWS9POTJiL1N5RWdYV0VBVHdlZlRa?=
 =?utf-8?B?SWZsWGxEdnJnbkE5Q2h6eFJ2MVp4eE13MVp4eGFzODdXak50YnFNSW1mQS9E?=
 =?utf-8?B?ak1oZ010ZzRpN2REM2Z3Z09ucXVsa256Z1pIWWhuZmdKdi9NTDRKYXhUOXFh?=
 =?utf-8?B?MUlZQXNad1dkUG1IdlQ1akdjMFFxdkhRRXhpTXI4R0dTM20zT3pYZlo2SU9L?=
 =?utf-8?B?MTBSV3NWUTFHR2hxaXczV3hsZlkzTS9GSEVBTmc1eW80L2ZUWWtRZGRGQThm?=
 =?utf-8?B?OWhBSGJoYlFNVEdCWjVIY2Z5c2NlVjFSWWh4a0NBVURxMlFKeGl5bHc1ZlFk?=
 =?utf-8?B?aDgrTjJENG5VaTRITHNiT2hVbWFpa3JpbG1pa1MvMVk5S21BK29EVzR2VUZq?=
 =?utf-8?B?MUQwSitrenNpRHZZOW41MmdRM1dyd3BqOHJUWlVXcDFQQ2lUY1o4UTRnZW80?=
 =?utf-8?B?MkR4YXk2YVcxVmNpQUl6TUFJZmVOTk95QTU1RWNPbU5xMXJFbnRYUTIxZ1k5?=
 =?utf-8?B?bFNad0xKaFljU09uZFFsM0NPNS9CUzl1WVdkczhDQWM3Y0tFa2docDlNZmhh?=
 =?utf-8?B?ZTBXRjlYZ1l0VElCSmdlQXF4UE96WldpUyttZXJxbktRU3dSQ2hlZz09?=
X-Exchange-RoutingPolicyChecked:
	L1I8Y66ASsrwedFbeV9eza5DM2gLY3BVQkek49NtcBDM101QQyCQKw+WNxDA9sfftQaJ9EwNUUW+MQulKaTPBJvv/87LNlNMVvx09H9dcnF679RnNO/EBJ+fvu1JRGUkAIgD3GeXMGQxrRZVXhodJlSJjvPMYY4WmPfBoe+0CVMFbvM2YSkOR1+UkR5Ti8nGJFSUV9qilQAeW7dKCQT6n5OFEPPxsd+HT6N/2/V73ORSlNDdJ5V07SXg+acCbvbApBnNeLhLLkCwQDUSeeyz5+C1Tre75KB8dTfdFGoawA9lRL+fYQOTyTnwFuWa7/aRulQsy4wtWXK3YaweKCSYyw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zhbe10jgRP4cK5IXvrGlEhgIuHvJg4fTg1okpBkoDLWElR4S4Q6ekC3BbkUJMn4vMEMZRpxkMehcAnuCHnEMqLwhdyO0EZWsD/Qy3p0oQkYJ5gxgOB7rkcLOoRHlFoXyXvATgBixh6yo99cSEiv2ROTlJz5R64tlwqvNpV79Cx19dOZ9ONOFL2Ai4yB912njSH3QPmvJkn8eVk0H9Tzq2PqDWlP/v+0LVLhz8lXAtZFy3Mgul8ceCfUrv6ZSX9lsCjpiGHz19Y9q3HX5d2KGSe1ySGswUH7qtYsLgWUSKoUpWNPr2Fx0EXau3bzm23r5RERJ6x35LCGTb286I/zHovRd6Z3qK1a98jQodgIC/lFXq1X9HTKZ5a3E3KVUcSOacc7QBo+jMNFsyfyu4xwp/Smvc+RYhq9Xj2UmyQzizyNG32tyfxAn7xoOQaJQuVEvAYJnqvyCKZHbHyYI51lmsgM3UCqoABs6df/3kIoQb84DH864H2D3Ra2g/GhKdH5LmqmSpm0967OS738aqGDUrJgSalcMMJS6ZFz0OOhYAv9PARtO5zk73E7mmFSVFdFHR2acX7hLN2974H24vw2zVROINbiFjy12oeJftuT1gAg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ed7339-e8b9-4996-480c-08def6eb73a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 14:27:05.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHNavvbmDupGw8pCYUf0QA19FaQMH1zb//NJbPMoH7Zv/06YXNIaI0bWA6fERxpJotx+MCH8ujKyoxRJ4ReP9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=948 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608100124
X-Proofpoint-GUID: WGSpuJDZ7IL7ZAcmJNiaTCmFrwwhSRYE
X-Authority-Analysis: v=2.4 cv=K/sS2SWI c=1 sm=1 tr=0 ts=6a79dfc6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bmjDePnUWc1ybu4XatMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-ORIG-GUID: WGSpuJDZ7IL7ZAcmJNiaTCmFrwwhSRYE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNCBTYWx0ZWRfXydyDYn08VZae
 Lu83SujuEEibv67tunWDNLv0MyLhzTnYn4i+bCTdN+hzQuX6zt6RXIbGtnn2QCgXVWfA0BFmWmz
 ULOS+Lj8Ox+evwmA3e9qIRiHAfbY79n+hh2FhzbzzUStmwAFjTkAkb8xkdm4042e3B7ozkdJM6I
 TqAKDnaoRQAxbCjPBICfaA8C2oYjzl+2DeZ+txUEsbhqlYeTdWM2VV8JQ8DgJkclYQFVnf1R1M4
 6PgHKPCaiqTnEOTw+1/TEyr+rOVZWN8oEhOucjJzd5Gl9Cun090dkcjFfOHjOwvNX72wg3XA1ZP
 +esmzrQ/MGu7QCRjKeZMt/LDIg59YnLcGu2xf6r/MmIcE/hrWgwr8QKEu1in6I0VtfhAvrrMB+d
 DswmXSF6sVkZCvjW+QIuc6JSxYG9tiTINK8Zh5OdVNWuFi2DI5CG8TUSiwQpQYExfH/IseBktFK
 wmNPzKohTq4+THdTrd/bBhitqNzlOm1ISkYbcfdg=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNCBTYWx0ZWRfX6rCC0JqjhccC
 fOgSMlXhpNOCxMMs43ulMc7A52T6vYRDRnrE5ns6c1j5DBoJhyXZoRLXmDYBqHUhgm2sjmhq1b3
 UubIb4pn45t3Q6QjZ9wNkV527Nz2doYKqHgyhIhwCA1bOPBxy9lZ

On 23/07/2026 06:03, Nilesh Javali wrote:
> +
> +	if (section == TIM) {
> +		if (section_size > req->length * qla_req_entry_size(ha)) {
> +			ql_log(ql_log_fatal, vha, 0x0098,
> +			    "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
> +			    section_size,
> +			    req->length * qla_req_entry_size(ha));
> +			return QLA_FUNCTION_FAILED;
> +		}

Not that this is generating a warning for i386 builds on the mkp-scsi 
7.3 staging branch:

drivers/scsi/qla2xxx/qla_init.c: In function ‘qla29xx_process_rd_image’:
drivers/scsi/qla2xxx/qla_init.c:9272:53: error: format ‘%lx’ expects 
argument of type ‘long unsigned int’, but argument 6 has type ‘size_t’ 
{aka ‘unsigned int’} [-Werror=format=]
  9272 |        "TIM section too large (0x%x bytes, ring 0x%lx bytes).\n",
       |                                                   ~~^
       |                                                     |
       |                                                     long 
unsigned int
       |                                                   %x
  9273 |        section_size,
  9274 |        req->length * qla_req_entry_size(ha));
       |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       |                    |
       |                    size_t {aka unsigned int}
cc1: all warnings being treated as errors

