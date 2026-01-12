Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC522FFFB6
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 03:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187076; cv=fail; b=a58bbJUo4XIpp99XWoD5O21DIi8qFLIDnXY2PykgG0UchkXxOLxjvxWVUOh2nXgcZ1WkV/rZySiFuclbSOW6WOBEZebd4vguO/CuzH7GetmHun9fofBXdz5ugnPQgy+jKzpHV3xtuRYoNbNnbhlPtL1XMou0jOaGU7qMSmrVD3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187076; c=relaxed/simple;
	bh=9S7MQ0Qt0cTIIHyQwWG5FRdfSIR7qDvRMD1gJqqcXd4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=mM/rOfNsTyfwcaLINY9ekfTDQbj5dtcxm4Qro4R+/zKwFASadd0RWLqdEcMtDR2mw2fNVgQ2JM3DA7cP/0RAINKqUArjwgjHh+DRANaYuQEN3lAfyIbA823cN5HAni2nh4pXScMaLBj22oIm+qkIGOQxN6HeDb2R0EWAvuX3D1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lWXlFfp5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ywP197gl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWXlFfp5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ywP197gl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C0pdCb230417;
	Mon, 12 Jan 2026 03:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TUZGZ/ZPWJ/lvcN//t
	gg66SvLtwxedprSIVFVKbZB6M=; b=lWXlFfp5zJ8fMkf6KuRjdzoIb25yEEUCFe
	y4wDZbYzoClcW978mWhgN69zwUkG/i79J9HzRl7ikYnMXSEank7BNlOuwuRn1CKO
	YKhYG8qynGHLCJpl+K2uuXigQ8JGjwvBsGAX4ugiBmhb2Jl0/FoYChTU+jDbjcTg
	wwLNZZN8bgPZ7Lr4IRTOvGuiKJ3zD2qUxf9d8YHXA9/bqcI7Z4AAMXMLBZLrZm5c
	h/G/ws0PO4+TG3JN5EQaSvvaVrSrCa62uOJep2F2tfiURSbNzUBFjEscJqEC13Fn
	GKuz84e1VcS/bU22LNxdo0fopwAH0wmPXTuzenBlBWWxWWGOlN8Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrgnryeb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:04:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BNYeoE029408;
	Mon, 12 Jan 2026 03:04:27 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7gnj58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YS/kRxD+41OsceyIFy2ci+HBcPGY3WBbdWTkX81EsWTUkgTa1G04Xlo8k0ec1UyzpekwEbwnRo2MQ9NlOvcONCvSLLNzu/WatzS/pyMp49uhaH/d1t9ow0/dYuReO/pMwsm1p2t0DnTLO3jsKGthY6cOi6DJzqY95nCHomRZOhfAyPHaAhFHfjfdX4NdJAIurZTym/mVHC+OZ+etUO8KLNuRdJBoJJlG95qMWpCSPtDIop0RtFPQ7k/lF49NIatzfW7X95tWcdLITUZIScBV13HajW2p8pMN7OawAISut4NU3dg1mgvAILfzGAHAW0UEv/ovb/w0HJ7/KMl+GtwSuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUZGZ/ZPWJ/lvcN//tgg66SvLtwxedprSIVFVKbZB6M=;
 b=k8MKssA60O2di+A4NWT3YqtLS8yBIN1IGUodTFgsMfJrEUSWiO4R//uFuXGVeiELTbm/jPFWn/TfrVIMVv5oOky2HeykHMzbZwis32dkNePCAewDyK7Hip2NLeifg6B7aHjaRXDQIdULrWIii73YdMV2Riko32sD8fqRg81ocXT4urOZZQwmrX1QrtTLup2RNFjOKTY1mlkc+EdukKntfSpJE9RssU5VjKA+qYc2OIMsccOTrpUp66f7ih1EtB/afiiv4o9NXCOEchkF9RBWrAjtJIRFGH7ESr9MSzeoc5k8NWgQvN7nAuxla1GFRpwvEizzumNInExNjPAiAHgHvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUZGZ/ZPWJ/lvcN//tgg66SvLtwxedprSIVFVKbZB6M=;
 b=ywP197glI6FHjAf5/kTd/qzs/mQQOj5iVqzT8ywqVMTEs0pGhgKVK2IGlBkDDODzPEwra3ELFiOhdnD7iyLp+qPjTl5WdjBHtfhL5SLZUINj6HNWWjgFgcJeqBHdwPLrYwA9yBJYVMh3YnPAkfGoPq2p5FEIU4gL37YvqTEPARc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5558.namprd10.prod.outlook.com (2603:10b6:806:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:04:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:04:25 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Improve the documentation of UFS data frames
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260106190017.2527978-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 6 Jan 2026 12:00:17 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ms2j4jm9.fsf@ca-mkp.ca.oracle.com>
References: <20260106190017.2527978-1-bvanassche@acm.org>
Date: Sun, 11 Jan 2026 22:04:23 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0190.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5558:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba8956d-8368-4259-1e4e-08de51874aa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B1z/e+W7LcHj0t+pE4iqWWbx871CQbS0D91TxCNedWQ1QkUxHu/fTXf8YC3E?=
 =?us-ascii?Q?F5wvJrz670EoEuBMP8A66KyQXPPcZb5B1ebmiEKi9xlVOs4Kte54cMhMI4CF?=
 =?us-ascii?Q?f1C4VTGgO88u/K1CMNswDAfQpro+tUWa9PCIUUKSfYoscUMuqGpmlmPTU64i?=
 =?us-ascii?Q?mge3j7nIhTmxuKd/sI6kTTTbGy+SdjjFhUuKNq8+rPEpbX1o5a9aB+XdD14Q?=
 =?us-ascii?Q?P4LuAnjZQxVja09w2tp836rYBgIB2dHXBpGMyHTm6zN5dSD8D1Zqe/gUZef4?=
 =?us-ascii?Q?ghPG7YbaeLEST2yJIR7if+s9B6itVSyosXoA99DC+TQzAPnuUC3BCymFMMGv?=
 =?us-ascii?Q?KL0rIFa3j5vhNvF3Owzhn4JmOOLGHbTp/f+rwZfRTlaSIhmKiedOSiMkagSU?=
 =?us-ascii?Q?hbtCRVq7U1Zu3OK2yfvQQE2e7bWTz9txdPOAESgPJipTdqvmcs2NwWrG0e/G?=
 =?us-ascii?Q?UWoy4TISLxaaRnVkO1OPLKkB4GYoFo9iKT1brIfpawB0gUugu5WiT2vKIQEO?=
 =?us-ascii?Q?U1+/edOsprBIT7uhiu34h5a08jDyKkDfhEfRnu9818nANabczCMWL2YR+uiZ?=
 =?us-ascii?Q?LDUS3MoVGvj3mETuJpapWFH0LJ9G8zp7D+EuMOiv0Jyb9KgWW9BR5S8E6sD9?=
 =?us-ascii?Q?zio6Xh0nTInK+9WLeoT8uxAUHGCPcNGmMfxR4cDHxJXOLwz63TBkxATpNn4H?=
 =?us-ascii?Q?9tNjD1rCLenx7mueGTLw6FRQU2ImI8Al/7vq/CvXqAWTQLilMJGmUbyIm3TG?=
 =?us-ascii?Q?ujsXFs0e0O1c/CIQnl8KMaH5FZFICqTC3rcslvjiW/AtVBEEkpDU8/KB4FuR?=
 =?us-ascii?Q?qCfrC2z1v55eyM0lqfLL7h7AQ3PJNNprK+6fPXmjLOxMTq+6QuNeYbg/EIAm?=
 =?us-ascii?Q?H7E76qk6iiDJ+b5aLz6ffabjH0COFqXs4kUBp7+b5DoCULuLVzGc5GGTNeJl?=
 =?us-ascii?Q?pUje+bsakvjX1ZUO7zEcJ3bpncTLOsLQSgZEn5lIfRXGczaxPscw5Xbe08km?=
 =?us-ascii?Q?9JNYOZfXfhkoaEvH6LS0lJZUpSAHrckZz3M1PRJYC0ju1UlLnQ5galHXc/zI?=
 =?us-ascii?Q?oDvwBrN3TKZtLvnwL0sBlcx6TtehAIclL2UDzvnkfCpQ4KFQJ3tynSDD17mJ?=
 =?us-ascii?Q?/zR8sAF+xoxW+3BlBg1JBe632NaudkI/o/K7gb79r0iLpVijd5M6/VFPUwwh?=
 =?us-ascii?Q?PPE8tzM+Unhz3n+7s/36ERZGw3m2NKQdbbfXZ8QDE3DZbYuNosAKwluBhu7l?=
 =?us-ascii?Q?pxdwYlX4Sezuo0N/B9DmtjgQWd7Tht+SB+OJ55XV11hKgRF6fP0s+h8+KGty?=
 =?us-ascii?Q?sa1BRiwVLX0Bgdl2TmyANHt6xEySzK8LpA9YXIGzKsascfhlcITjs3od3cZZ?=
 =?us-ascii?Q?LoWF8daJROChPtWDJw+f2b/DJWphKcfOuLYCg7V6nUleTh9mx4287jsYUQFs?=
 =?us-ascii?Q?y4dWBD0GdMKslGk4YNDp8hhw+2xrN/T4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A4gklOkhz19cUMMsBysjHADpdjVf21aYz3FMSa7uyu0O5fogw84UMbCPcnbu?=
 =?us-ascii?Q?D4r0ES5MDOWEsm3L5wOhtWEWwjGel/ZBaisU9R9/ZsmJ7IEdbol0wM0RAAqz?=
 =?us-ascii?Q?YoeqWiH8iCUraLCyB8MlVV25nEvXcUXDYk4IYBEXszurGAVIwOP8SoFahG5T?=
 =?us-ascii?Q?dViHJljPaUoquN7PBK2mBt+93mcvlnx1w5ePGSWKV+ZFcsbjq0EadXr5714h?=
 =?us-ascii?Q?2Musbqi0/IAQhiKBBsQvQL5Z1FCcOM54LI7jnv5ZigkLw5BjK2Nf3zB5t/AR?=
 =?us-ascii?Q?4zS3JDv8phbAVf+dqJfxtUct7MLffn0wqwnedhgX3mMFKv0dGkOzbIGrE1NN?=
 =?us-ascii?Q?/1M39RKRD8b+QEIH+fjpWxWlQQszdJDSCoytMTRNGzrJ4o1j+yT1JQv2bMO1?=
 =?us-ascii?Q?esrqPLFuVHQ9uYIKPPZz3+/HqLAGO4YuJzxeUosey0wR4Xk4swHG2SejiVD5?=
 =?us-ascii?Q?XChxndlAdxq+Y9dllVlIlcKe+ytZcJt3PLshgysS2ZV4zIzcoAQDK9f1OSD7?=
 =?us-ascii?Q?Z6zj60L5fJL/h7g1HczEx4zNJIZvYaCzR4WrOsPaQlIaefILQeh/pBc3r9CJ?=
 =?us-ascii?Q?fP2mjp5BRrG+pAommzeRTKr88RqrYPj92M6gvKxrM5n0sysW+0wROz3rvTMN?=
 =?us-ascii?Q?emA+sxGuP4X03UYcDCVK+2Fv9uHrq4pc6Z9g5FchJJFukUGIG1NXi7N4PV2i?=
 =?us-ascii?Q?WTFGVq212jqO6nrJnznBWXZPiVdXTKfOhTLqjqU7dcdshIIfgzhQBCWem7s/?=
 =?us-ascii?Q?T/r44R2VMlz3IJznwCMgbjESwIgmXnuzZgKU5hHEfOfILLNmRVKGyckZt0pd?=
 =?us-ascii?Q?sZUN6ee3UxofdGiMaUbMwZLrftITkSjLZWpwidJL2sK2ztA+3XxEBDyGjtwL?=
 =?us-ascii?Q?z1b5Y0LIc6k9PodUcyVLiIZ9eP27AWrwN+D0QWy2A1jGydwWMjCbL0H0EG54?=
 =?us-ascii?Q?nt2Fj9ef+L2kheMxb8P4WVU1Nr2BT/HEFRnVyst2LRMPDekbqnklxrhaNz6d?=
 =?us-ascii?Q?HpWYsPwAv78VSyG7Vm2UmEB+b5nPmntmZeYlM002sxGsaoENUTqpHtWqPXAj?=
 =?us-ascii?Q?LXop0xe7e+qjBdLbNkM9E+ei2kMZ71n3wuYKFBb0jLRmzFPqpRTBCLdw0zOk?=
 =?us-ascii?Q?1QDa6f9JXPrg+MNWLairEuejM3fqnJ7XDI0XDqUJ1a/BZydF2ploB+5nX9IE?=
 =?us-ascii?Q?Lwc6gmrdh4acMifHzEwb4xYUeow3qmEzoNhDPD7yZVg42atxC+MOORLC/3qC?=
 =?us-ascii?Q?rDVt/Y8gps/O+uokBvamMRk5VzYW93Q0XOxWdmM/sywHQRKNoFNZLOZfmHF6?=
 =?us-ascii?Q?jAbUTMOUPXffZYEULnLZX2nbEPi+OqrMzp/RICnlFqfAFY4jDXw2Uo7wcDo4?=
 =?us-ascii?Q?sqhdBEXt0/5k+36NGNpPjgboRuwEb4WLX/l2M0GSOvIR5XhbLfJMSiNCi/fN?=
 =?us-ascii?Q?3ls/uZ8mZtQg1WwoDO1+/bIkBA2FT4rgOjSrTYzrnBkg2N1K+Wapm461q6Eu?=
 =?us-ascii?Q?TZgzmz7Q1F5DBMrtcAgWyRRGkWkupZGVVfO+onJ+CTl3UlLajLlz2m9cD3dr?=
 =?us-ascii?Q?3hpQ8h7gsTpJUrQ24fda6rgmz3womNN9SznnTR6xvb97YAqiGorx23FbwZzw?=
 =?us-ascii?Q?jbiwn3Ia/Bi+SklSxXY+i1Q6hj4Sr31/E7kPSv5G3gxr4UuMdeAmJvDtOW1g?=
 =?us-ascii?Q?qtAWIAUax/Mpz3TpKf7opRDBiVogAudDLY49PrCPSL0qdg7Y90jnnX+u2vLS?=
 =?us-ascii?Q?GQhHEkyWAVlSSkyVe9BVu8YD7Le9OQo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IwQglRKBv8wmoOkoYp60UQALs5H8uE2BBUH7e52nk15OHmHY+TyCA2gHs6R0NjlXPuUzfoPDl/8y1UByby+uLA1kD0N7jSDQHd/ttWxOC5t4lcS/UCMqoJY8ZarQYg6IwgOR2vCGK6nh1my6aZItvKG/DbVq3bwwFn6b0F5S5K6NSbyc9ZCXDNJELTxhcpJez+u5gsxgiM5gjmwE+5i+4dwHJ+pAzsXHyHrQszpjwYago7iW4+f3FTdzYLx5kHOGHqunDCI/Qbx0UoZmQ2/7AbvrpHSdY/Fxgbbo3pGZpOmwGSWQclxnI3UO8SfGPyEw9DpaYr66xbn99LKPTBCPO19DApBZoFu0ZSiiCZ3cUSgsqdXQAa2KsW0BVSIcw250gk7MKEe0l6EoRlt9szW3Bjodt1LX9L5MXEc8YMHu+Q9Nm3nZV/Ae+XcA3drAviLxYUiSmmF0kEO8Vx6TEZueAY8QXbQE94N/52KeJ1h1o3m3l5TupN4S22JSf7kOPuvSKvU8XInOvnFCySB7npqHSUHicPbEflbHqwAjRwCun2l8V6nMON6q/B8RCzFfJBLLTk2O9SMfBCDQ1EB2HIM4BJnJLb1VQydWBeXyvg5y8VQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba8956d-8368-4259-1e4e-08de51874aa2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 03:04:24.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXFUCw80lysTVP7VPFTR1XS8LKGQ/xXsI6U4fi+x/NrO5N/FHP9AkaO1a9QrTdn+Q6+mc9BXixpC1Xv2U1btyn8rmENkQ4p3GeZAbC02qbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=908 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601120024
X-Authority-Analysis: v=2.4 cv=B/G0EetM c=1 sm=1 tr=0 ts=696464bc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12109
X-Proofpoint-GUID: H5vOMP4xvE2GeTHK0t7lwyhsFi_yFGKd
X-Proofpoint-ORIG-GUID: H5vOMP4xvE2GeTHK0t7lwyhsFi_yFGKd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNCBTYWx0ZWRfX/dXnty2e2ABu
 nAtEDRK0hrPp4/7C6ttAnEq967xfZYoOXj9nSa4KncdZd8KhfWhd6wh5BMWwDSCKaMog1oGMT3i
 5q1SamFNaZ8DC3UT/8oSOSHQWoY1MQMp1qCUmzaqAADYKb1b3YjecHVR8Due+wn6He/L8iTojqN
 ZN7ogitigav43wAxIRjtw3p0UQMLwvj/WWif/1kj57/39C4EMzLZVnKfXqjfaCw5+OFYN9NgrxF
 RSqGSeXJd0+MU/EFWdVVGYJKyXYBosqRXu9O9MTfTI193uTZ4GNnChPIVPEAx4MXybo7lUJ2a6m
 27vsFrtEq9qZ3Nl/y/XEpDi6DHjQU6TSapY3p9xf9lLx229l0fDjocibJVzSxH6oLs2KCZL8A7s
 dcJ93jJndbNEyPxMbG/RMOirU6FquU+U9G5Y3M3q3GuNFjLVEwSs4HLFXv2NM8AhnJZMqFB8AiQ
 MrwWyfP214IFueB/chMfTKMzhcmVn1fHqATSW1N8=


Bart,

> In source code comments, use terminology that comes from the JEDEC UFS
> standard. This makes it easier to compare the UFS driver code with the
> JEDEC UFS standard. Add static_assert() statements that verify the
> size of data structures defined in the UFS standard.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
