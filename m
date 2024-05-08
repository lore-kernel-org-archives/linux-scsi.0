Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7411A2C05
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715183368; cv=fail; b=bJXAYVlCKfYN28BQhaYTa9OUhYuypU3NYmZzD5YNrVnl11cYZgONjzRQNQ3o4s+c2F2i34bhsgGZbpBwqk/z6wS8eAk8IKiyzHJpJQA/Mj0GfRW2MuFIHL8JeLK4iq7xLMrynfO0J+ASPE0dra4074/MFq44k1b5VBt7iayERIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715183368; c=relaxed/simple;
	bh=5DkPqGYUM1WzBZ7Ouvn0NWxDWkiuHjoLDJmvIKA+klI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PgftiHW2avG5V9kkcS9GtCwl03CpVfvn3umAMlUmzCkXDmL2Yv8bax+h6lzVx7tvcBz0+Q2vpRqI1ab/ibdIDDWo1LmoLJxaXz8tFpHykZgJFHWAQHWovtDasDLUqcvv3CfDcJPa3HZxE6fltPZ8EXyqhRNl5Rzm4UZXs/UuV4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dy753Xdx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0NI3IeI3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dy753Xdx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0NI3IeI3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 448CPIih007803;
	Wed, 8 May 2024 15:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=hIraQcUl0G8N7fbiE+09bJFpiW2s8oxBfW8BF+XL+6A=;
 b=dy753XdxQy8kL4NcaoL4neGUCk5lzlDYgn2Ui6EbpBmpqL1z92m/NBLPoupcRnLVCMp+
 woZueMcp6zGrhxua4WIksdnH2rtFGAJMQaMIDizzsOneVDl1bowf8utCdWbpEiRb+QBn
 MC7051aFoaiAMjXgP02U0MMxdIhjgtb5t9eJlsTN9bygoiRQ8b84qQnjmc2fkuZJvbyd
 fWooqHpCFkzogGwVjrY8TQVZWu4g11+IrKdw/jyBYlQKW4B3LFM+TDCE33uOsm8aB6Xn
 5bFz3hJA301UL7epyq0tx5BMUcrAXvHMcS/XWggy24XP+UMj+iBgZ2+FR9T+HaCW2Cgr BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfya4k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 15:48:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448FbKIp024576;
	Wed, 8 May 2024 15:48:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfng7ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 15:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUlXWXTomN+TOLOxVELhCVpoyL5ccM08PSdDRRbmqIS2bKnKbsQBaw5ERur9chLV3hLCF+w0GVfWn6j5Bwl2voJVKCe2W/nIqFV9x57AwMBDpxXzZoTVt1ZPz0PbAju996n7/7seLBFvKO5LaFdT++ekJ8XUmb9HPSdaPFk2Bt1giZgaO5sWm8O4ez038B16s010sjiw0VlM195kI7k0kVlKx7ivH208Yhiqi+cvIQMQei5xUiqBY4dQzRlhl7OpvQtV522hlSFRKhrE7sOCsulIksUoHLPq6MEp/c04tc9f8NDVgj2E/XYOCxWyrL4t1tsFJhVQ5t3xdTWeLOn9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hIraQcUl0G8N7fbiE+09bJFpiW2s8oxBfW8BF+XL+6A=;
 b=oLJPvmLI+CFhE5ke7zgf9ovM+3TwGY+xQeq+b7Kn1ro5c/xxWueHupAs1vucVABodLaIOdCWcO7x9Z6tWXZ8rY5rzDga8ZA1rpeWFjZ4GrKhzhr1t5CPyAg9JT3A4JXlTlZEOfM8/DLmX0XJt5N7O5PJPg4az527+efItTD7OKIaZkswx4naeZwhAevvXpQJC3l5rhXta0o/v+wItinU5yHaprybDJ441SaAmIPIlRomBR7oEMD50FbEBVCiMJb0FaZVUWZJl56kFraTVBqxWiWgWPPJQGcH6+qaBlLo95fNowGKWO9BTOpa8SsdDmtlXLHC883sVgTeStzE6taykA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIraQcUl0G8N7fbiE+09bJFpiW2s8oxBfW8BF+XL+6A=;
 b=0NI3IeI3VxJ7gy1QD9szP+y6PFRflbO0VH55hqW85H/zvbXSRTOvl//wEkRI2D19PgyJ9cDNygJkaDot/zj+ldoOlmJZc4TIAOSnRQBYp35v/rKFHHNTgrD/F3o/sOv4Bc2KHBKvrETECktpYeDK/6F0oaVssOdmomkzulXnSng=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB7498.namprd10.prod.outlook.com (2603:10b6:610:18e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 15:48:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 15:48:51 +0000
Message-ID: <fd4b5ed6-6e63-4a71-b2a0-f29ad02a2e7a@oracle.com>
Date: Wed, 8 May 2024 10:48:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] I/O errors for ALUA state transitions
To: Martin Wilck <martin.wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal
 <dlemoal@kernel.org>,
        Martin Wilck <mwilck@suse.com>
References: <20240508102426.19358-1-mwilck@suse.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240508102426.19358-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0060.namprd18.prod.outlook.com
 (2603:10b6:610:55::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c7e60c-b1d1-41ed-d9eb-08dc6f765b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?THcxZVVtc3J1cnc0SEcvVjJDMnNuTCtkaTN1ajVvUzg4ajM5VUp4T3VNa3B6?=
 =?utf-8?B?SjhNUktqS2JXYXhqdE9WNDVCWjNOL2tpRnI4RGlsdGxPMngvZUFwZFpudlF6?=
 =?utf-8?B?Ynd2UHAxQXpsVi9sajgvZ0E5U1BrV3hZRkZPRUt6RVhweHdwZnFPY0VRNks5?=
 =?utf-8?B?YXRhYmc4QTJkRi9Wc0VrSTRHbmVRL3FBcFlCMDZCbkZ4YTl3SVZ5MU40Nmwr?=
 =?utf-8?B?SzZJK044NHFZcFBlUkhDSnZIa20waFovekZRQ2l1dTlZckZyUm80bXFUcFlG?=
 =?utf-8?B?MWZJb2RaZTJQMTkzbVRzUktoNE9qNCtLeG83MVEvZGR5NUFrTW81VTRWaHVm?=
 =?utf-8?B?K0Y4dkhuc1Vyc1NXeC8xRlhsS1l3SG1OZmdzR0g5WllZSGZiRTFRZmdLZURQ?=
 =?utf-8?B?KzhhYjJmRmduVFZtNTlXdHNYMzRiSG4wa0E3ZDJKdXoyL0c1RzVZSGFGdVQ4?=
 =?utf-8?B?ZFRVcko1T3hFVDIyTGxIYkVRZmYwYkJqOG93VUJwL3cxQStUandyNldFVjB3?=
 =?utf-8?B?QlQ0OHRnay9KenZ1WnN6VHJURkgzckdodWUyeHFvMjBvbkRGRFlBTFpFR004?=
 =?utf-8?B?bU5tYzBBNkZ0ajR6SW5VSFI4WFYyNndrR1RiUHpFUzBRNTEvMG5tYUQwa3VB?=
 =?utf-8?B?YWZ1WVpoa2tNZGFTcUFYUlEwRFpaUlM1U3krTnBUMll6ZDN6UlNkdkdtcmJC?=
 =?utf-8?B?ay9KYnBtSCtPTFh4N1hjS0xBS0xLdng0clJTMzQ3VjNzaHJIU3JqUStOL1M3?=
 =?utf-8?B?dmxJa0VDK08reVA1NHhPK1FuTkd3ZkUzTEc0RWVBM3dBZFdjbEpSd0NwTzA2?=
 =?utf-8?B?eW95dVVtOUpLb3QzMC80dVF2S1ZSSnQ2MTN1bTVVRkhnOW5zY3lNd3hYTlBu?=
 =?utf-8?B?N2hnZDZYQWlpWEpnN2Y1UWVZNjFSelNiS1JSZ2RmNUJzQXJ2OUk4WXc3SFgr?=
 =?utf-8?B?b0JGTjdnV0ZVR3VwbWJ1WldpWFpFbVVPbHhHcEQweWpLU3VzR0NhZE9jbkRM?=
 =?utf-8?B?VmdPM2pHT1N4VzFNNm90QzUrRUxBd2k2T1luZ2s4T0o0cDJqdlJ2VmRhbE5a?=
 =?utf-8?B?cGhhdUp2VGszQVlXYlpFcHpBOTFrTzk4MERtNWZTM1JKQWg1citmM1FqUVVE?=
 =?utf-8?B?dGlZbTRjc0xTK291STB0L3BPNkRjYnZSUWE0R1YwWVU3aHlvcGNXdUhIOW1J?=
 =?utf-8?B?WVlDSFZDbFZqK1RLNUZnMHpQWGdXMW5wZVJONG15aFR1TjJUUkowZ0NROG9x?=
 =?utf-8?B?QkdtRUdkRlZCN1Q0ZTE4bldPWHFmQ3lIQW42TGR5YXBxZHVxeFAwYlYvRHJD?=
 =?utf-8?B?VDZTOFlmV3FMRjNvR21KWDIvM0xDc3RLQjVPbzV3NjJrVzZOMHQ1RGVGRzlp?=
 =?utf-8?B?RUpvM3RnZHViRzNnVzRPUGNhRXZiV1ordzNUT2NxMllySlhMd09mYjNualJq?=
 =?utf-8?B?d3FjSGs0UEVMWHl6cW80cWcvYk1HMVhVREJVZEpzbk9Nd2xSWEhhcmlSdmNR?=
 =?utf-8?B?dmZpQVUwYWdvYi9NdlpDY2ZuYmtUYklmbHFxem1SWHhpL05zUm5CWERadzA5?=
 =?utf-8?B?bnNlUUxCSUFaMkNOZ0FMSE50Mk8wRHJNU2xoTzRVQndSckpmQ3MraXVPdGli?=
 =?utf-8?Q?Fk4ULGz8j90njFiLGLE7jRxgIFl4HjG+PCGUR485Vh9o=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VFdxTkFCN0dpUXFyelh6akIrMW1EQTRvVGdJdXZaWllVZDM4NmRaV29uRjJk?=
 =?utf-8?B?bFVPOFZPOHo3UFFYSTB5SzdsbTFtOEQxUDBsNktZYXpZSXRhcVkwVWpuMFJz?=
 =?utf-8?B?MHhjK2d1cnZha1dJNk9nalNkYXlDTFFlVjBGR1NuRjVtVWtaKys1YWtkbkdE?=
 =?utf-8?B?ZXMrdHlNNU9semVnekk0bE9OcGY2ajRwMTVsUUdyeTZYdit2NnBMSXptekM0?=
 =?utf-8?B?MEZrRndENU9vK2NMbzR4QnU2eTk3UXFqSFQ2ZEQ3dlpQei82L0hOVWlXNmNX?=
 =?utf-8?B?TXBFN3RUSU0rb2JuZmlQMEpVVks0VjUwOVM0TkJyV1YySno3TENPRlJLK1Rv?=
 =?utf-8?B?YVF4NFBsUUY1WE1rYURuUEQvb1BJWEE5NXhXcXpYTjd5VkVNcDVvUFJaNjdm?=
 =?utf-8?B?aHdBYXZnZUpBNnlVUU5PZXdjQ2x2RXErSXcwV0xpK0lUYm1aREYzeFI1V0s3?=
 =?utf-8?B?R1JXMFl5V0xWMjg2M1ZTRTdpUSttVlNLN0sveityODJubloyNytOMHBQbHNi?=
 =?utf-8?B?bnlBeEVNY2VyOWlRakpIM2JUZGlEa2N0TVc3cmNObHF6cVFVWllaZms1MXEx?=
 =?utf-8?B?dGdYWTlvRVlSYmJZR3BvQWl4R3J6Z3dya3pUK2J5d0RCNlBDZjV5amR1MDQw?=
 =?utf-8?B?blNZV25aU09BbEp0YTM3VHYvWElJVzhUc1VxblZjSlVlK3p4SFlLb0hsMTFW?=
 =?utf-8?B?bzNxMFFacGtyaDExRGYwMkdFaG5jOWIrclloMmljL21IdGJEMm83c3FtaDNK?=
 =?utf-8?B?UURiZEU5TThqYytHdUFlaDM5M0ZyU01nWEJBeVYrNHlkN3k1eEZTemszNkZL?=
 =?utf-8?B?WFVvRXBCeGRLMG42U2hvelNDUEtMWGg1aTRFcU9aRkhJT3F1TGtpSlBlVGE3?=
 =?utf-8?B?WXdKTWpVMGJNdkJpSWl4SXdkODFjMG8ycFpzZDFKZDQycnJPSlA5Y0NqUHVa?=
 =?utf-8?B?OFRhU1E5b1FuR2xUaEZ3cE0yU1pudVNRblYrVmEzUlBrM3ROSmpqNTltbEtJ?=
 =?utf-8?B?NEJ6a1g2eVZ6dndHRjg1UUk0ZjM4R1ZYWWNWUk9pTzVhTE9CbjBIeVdsOFU1?=
 =?utf-8?B?RWplL2owT0wxUWVVT3NuUWo5ZHZ0R1dhQW1KTDB3RlcyL3l3eUxYMC8rUElV?=
 =?utf-8?B?aXNDcm4vcEoydUVUbktpMjJVUUZJNnRhZDNTeHVBVUlKNXlXWmJzRFd0T0lh?=
 =?utf-8?B?MzlucHcrYnVIRGFxdFNpMGtvTHBqa0RGK2hKclVpb1AvZkZDN2QxRjg2Q280?=
 =?utf-8?B?aGxoTXJaTWxkN0dyOWF5MjRVbTBZMXFyYzlkODNhWllpY1c0bEYxc0xidXFi?=
 =?utf-8?B?NFBjNktJNVdiWHEydkVtMkdhUTdkR2VwUzFlY21veG5teTU4QkVXZ3NteTdp?=
 =?utf-8?B?TWh1TEpJVmFvVUV2dEoxRzIvRDc4R3VtRmpycjdVMnpkVnNCNVlrSURGMFo0?=
 =?utf-8?B?N05OUlk1ZFhXaDdiQVh5S0tTMmU4T2dWbkNwK2srcThhUm1wdUVqN3JPYlAx?=
 =?utf-8?B?cStNYk8wQ1VjWmt0WnFPeG5FOFhqTVNRUEpIeTRWODlSNWVGMTBPSWlaMGJM?=
 =?utf-8?B?TXZia2xWbXNuV3hJcTljZitTS2V4c0p6U1ZMcXlqRHhyc0ZJT2RmcEM0Mkor?=
 =?utf-8?B?TDZPK2tZazU5L3gzUTlMTEpuc29Edk1vd2ovRHNYNGN6eXA1RTFTeHAyaFZ4?=
 =?utf-8?B?OXlUL2FqdWpsRkdOTTIyaUV5NngvaHRGR0xsVFdud0NRMGZ2b2FDaGxOTG5Q?=
 =?utf-8?B?bEFmcjloSEdQODdoamtOTnF6L2N2azRCbEplVDl4azE4ZHFGNFVoNHRwSWdV?=
 =?utf-8?B?bzhaR2NHdUNLU1BBMXBPbEdUM1NZZWFRZW9RRWYwa1NveTdacWZ5MzNnTEhw?=
 =?utf-8?B?Q0VFYXUyR1I1TzQwOFk4bGU4MWFaM2F6RDhHTG5UMXJNM3JCMmM1ekMyUDg1?=
 =?utf-8?B?aUpubUNNTE9NeWxNcUNmZWJnYWVLSDJvRzRBVjUzWm5iRFFkNkhWZGlwa1dv?=
 =?utf-8?B?b2hPOC9qbXBZbjYzS0ZJdWMxY1NGNmlyTkEvS1dXM0M2dUZ4MzEyYUdsRkYy?=
 =?utf-8?B?L1ZnVmNXUjB1dnoxSVpPVVQ5NUZYM0syUXkzbURIdzVRUHhnTWRId1dhMmVF?=
 =?utf-8?B?d3U3NTBXVFJvWXh4bDlTSGwzTkR3ZFY5dkZVMWh2cHh4dTA3V1dBNHREYjhN?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HOt+SzCYmilxNwDXw/WoDWH0fJloTxvC4/CsR+9OMBDBbqjGZgEl8JwCRjwBkZnwzkS50mIZJGjzOcW3MtUceRaWaOAT90boWKHDxKMsQ7q/2k3Gwr8ojaM6Q8U4oxhN0yYiQyTMz1WFX9yEHcvUn01BfazWxVFCEFh/F7Z25vP4fBf3BiSFazlnhio1kD0AIfEC9NnSGPF57E/wd9+P8G8xcRvS3bFvxZ3xaPpPBDaOBX/YmFtlGsE13VTcvQvcVnSRIJ65OlKEUPkQKdL46gdlXUzMvg6gzSOnhzNzmWeRZeRXzWK/WP0AWvEQhGN1MYGnmAiXdUnKU5C5PaUUhH4wCXezpP4ldTvllv79S+Z3M52pjRu7kvZ6BVNhWjoGSHLhjFSq0wZhUN0+i2FkMy0o2suytpz2m7FJoWQFlfDxTtH/OpzNKYGmnj17e0ENF18Kvsp2KvUfNFkwjE4ISW6eqlcWVsSGSnwOeue/oNJC4hts3Ccz9lTKLytLE4cOU/6nUEjcNlEKEr+0b/2syiFGGvUKm+A6G9znRZNOodmxVGvW/twlwEeT2d981Qt8SN0B9FDoTFl/HY8jfhDuoGHv7E5BigbzsMScP075Il0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c7e60c-b1d1-41ed-d9eb-08dc6f765b44
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 15:48:51.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smviUA9RSPosWsdoQc5aZwPn/IZnsLLYeBGXpu+hUwDBhiphIKBGQPs/pOQ64JpWqQYRyfisIn59OIsCpmEgM9NFZnTAJd5r2LR2Z7O5p0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_09,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405080113
X-Proofpoint-GUID: vM-zEx_w5_RA2nAS7jyc8altB3Bo-upj
X-Proofpoint-ORIG-GUID: vM-zEx_w5_RA2nAS7jyc8altB3Bo-upj

On 5/8/24 5:24 AM, Martin Wilck wrote:
> From: Rajashekhar M A <rajs@netapp.com>
> 
> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
> 
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> 
> mwilck: Moved this code to alua_check_sense() as suggested by
> Mike Christie [1]. Evan Milne had raised the question whether pg->state
> should be set to transitioning in the UA case [2]. I believe that doing
> this is correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause
> I/O errors. Our handler schedules an RTPG, which will only result in
> an I/O error condition if the transitioning timeout expires.
> 
> [1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
> [2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---


Reviewed-by: Mike Christie <michael.christie@oracle.com>
