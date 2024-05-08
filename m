Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C970F31A89
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715156957; cv=fail; b=BTOVBhuUi0t6X9WXwaiTtZQ3FBKoqDELWKXSga1UI8YXTqYdBbuuPfL/btICftuHGW73p3+S+eb0ztzm5f7hrqoUuELQK5QgzOR8oRB0gq22J6VE6fxIGZrfZbgin17/+NbcuwZ8y6eYvof8JYhLyZuldXD2c/CztHoxbWaAbWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715156957; c=relaxed/simple;
	bh=SSucqDHTlP5KT+PmMel+FXXtbmlE8AY9OzOrgtRDyRs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GSFQmQPW/SLKr91q33L/B00fG4KblD98rXPQWxuY4+WmkXx4mjqAe5zbN30yxzsN0al1w0T0KT8ye+6w2XmOnA3ZO9GOJ0aAIHVJH56zchVSbordQqTp0a8MEnCbTxZqOsIeOtIE8o1sARFI4H9U5BHjADaecfr522+JBf34dS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=pPdwwTs3; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="pPdwwTs3"
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4482rK5Z017359;
	Wed, 8 May 2024 04:29:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=SSucqDHTlP5KT+PmMel+FXXtbmlE8AY9OzOrgtRDyRs=;
 b=pPdwwTs3yP5YBdXmZB/PjpPPpPpiF5V3XSvXryYnjZcTgavMHq+JKeM7d4Khu4Ro3FgE
 kAdbDAxHuP0N8pSDgLF99G4t3GjxPRkR/EyEJzN5JyQdsTiJ6IwGEbPjBUi+AqMgk6Gw
 /wP38/FLVxsfvFtbFHgVzVD/CdmimX1O+LLu1zDQBURGvOswgR7sLIaIAqwPilglWnK+
 FBQfZxLRqnaGIL2XBsOaQqtw9kKAXJmUrTysLGC7CrRwUkCg5oP51f5bedQaWrs1gmYf
 4Q1RCznKR8S40lduyQd0dzInuiLo6nIU9tlt4vEobGc+iWO8ycdFbTrE3zfS78djKn5B pw== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 3xyswsatr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 May 2024 04:29:11 -0400
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4486XVj9010094;
	Wed, 8 May 2024 04:29:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3y00x7uwn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 04:29:11 -0400
Received: from m0142699.ppops.net (m0142699.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4488P4G3011087;
	Wed, 8 May 2024 04:29:10 -0400
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3y00x7uwms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 04:29:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJu0XvVQKcQy773o2AKOrQUcx+K8nOC0VN3CMTy5+S0YHVSNpiqTWsL+w2nZNNIMCLKMfI6jg7SSumtJY/7dvlbxt6/CJoygfgJkzS8oPVDvhajudKx+ce3dOMlhEt4v8hIaRsXJ2P31rtsk4yfo95UQ9ORjmdyvvbxRM7NFaBVrLCb6uG44/GrXC0ZZSZBopTEjdXk+HLg5zS3vG0Q8gYfFQM+r1AKVBeTlqVYunBmuEtEUDqXE7SsVuM5OvNMECHGwYS9X3Jpi5ISjVnJ9INdkOalDZkJyfLjoo75Hw+8lqBDMrMTMZTzIbkJDVo0ZXPyBT1ba1dOMf2QUGgIAtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSucqDHTlP5KT+PmMel+FXXtbmlE8AY9OzOrgtRDyRs=;
 b=Xs3gWMCHGmdxekhBx4Rcbn0kMSuHfGuShEcuPzVMjzDyD8LKNHJz7sGaxuwGq4LXZXpupwHZkAkvHgXo0yq2nn1DQfYxAEz7PkDKkGIBIPZG6uIIkA7wS0fU6JiJDtAFpco/+Ra95uRFJsK/M+nTowPwdn5DVqFxW2p5MmYFxy0G7lG77VZwbjvHo8cqpiYaOOSiQ6McLMdDoOpXJB38KA8hhD9q8nOK/98VekWo/pgBRYeA/gHiAGJxbqWvhPRKNJ2pu/LcZ9y7KbmB/JNUHepuyPrsqVjQcGY4Iaw3JJ0IEVnZr5prcgfM+h+n/vCCXLifmZtlxkT2pqc2iDzE+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by SN7PR19MB7843.namprd19.prod.outlook.com (2603:10b6:806:2ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Wed, 8 May
 2024 08:29:05 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 08:29:05 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEAAB4+wAAANgfMAACRv3gAAUU6tAAA5fz4AAALb0kA==
Date: Wed, 8 May 2024 08:29:05 +0000
Message-ID: 
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
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
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
In-Reply-To: <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=121ca097-d58b-4048-892b-a94ce6719be2;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2024-05-08T08:09:03Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|SN7PR19MB7843:EE_
x-ms-office365-filtering-correlation-id: 8971c95c-40e5-4529-f18c-08dc6f38ec5e
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TDF3NVhGVzREVnd5UUhrVGRKcks2MGkzbCtRSWVkdmlVbVVOVVd1Z1hTdlVh?=
 =?utf-8?B?UjlzaVExSGZpcEVycXJHcTl3TTZveTJKdGV4WGpNNmlqTWx6MDdaLzgvQ3dE?=
 =?utf-8?B?bk4vblhjTnVKZkhGOGNVREJkY1p6ZGExZEhvZVJmRFhPM0lLT0RoSnZIZGJQ?=
 =?utf-8?B?UGJuTGtZS29jeWJ4cjNMUWtiYThUK2t6dGpsbWY5M28rRzM2ejVMNjViOFcy?=
 =?utf-8?B?Qm4xZ2MxTGxmUVJ1d2hXZXhFYm1DWVlHQU9JeEt1ME5BN1V0MG1PcW14eUdx?=
 =?utf-8?B?UnpEQnFBU0lkZmlWUmRvclR6MGI1eDU4ZGZVNmxSWkx0c0lyR3JKL2FqWVZn?=
 =?utf-8?B?bHl4NU9IQVUxN1pWL1NsUm1tbFowWFRiZW9NQ1FkZEo2QWhpNU9XTEJhMmJs?=
 =?utf-8?B?WEhOaFdYc0M0Z0R3NHN4OTdYNzRtMmZsenlhdklLa0ZueEJqamlQTVZ5MXpC?=
 =?utf-8?B?KzR1N0w1Vm50WGVhZmRLQ3lpOUt4VEVKTXVGU2tzZUErMGlCdTJDSFlFOGk2?=
 =?utf-8?B?OGJDZUZvTnk4SDZibElheDA3d0JWL2RISGNsMjRpanBQUGJ4bUY0Wi9zU2Vi?=
 =?utf-8?B?eVJGMG1yZTcrdm5qRWVCZ3R5UmphaTh6aWM1SjNOWCtLYU00UkZwbzBVeWpG?=
 =?utf-8?B?ZU9lRy9wUktER0FPOWd3WDlORVozRURyeUQrVjlFRVZOYTMxUWlIMy9MMFJG?=
 =?utf-8?B?UmhXazRISWlFeTFFRWE1bXNBYlcyYXNJVkU0dGxKWE9iS3RpYm1xQWVyeWlY?=
 =?utf-8?B?ekJtNFJWSEtQakJMQ2RSOGJtOHJtSUhuWXFyZ2x3NDBPdDVtclZGQmdHNmo2?=
 =?utf-8?B?TU9XZmIvQzkwYXR1Y2xqR0FlaUhLajdjTkpmMnljdFVDZXI1WlJvUlFuM2R2?=
 =?utf-8?B?bkFUUURKQUhBOGZONXcwVEswL0wybkIzVXZiSi81TnFBK1VsWWxPVVhEYXlF?=
 =?utf-8?B?aXNRTWxaWGtISVhRcGFXeW5PMEFjbXFCVXJhb2pmekxNL3RvbERxV3BSU3JY?=
 =?utf-8?B?MEFORDFJbXQxT1NSMjBBVGE5TU9JRXVTeWdiZExCWGJtd29XVk1WazBXc1Yr?=
 =?utf-8?B?Y2NrOWJJTDViQUt1c3JxWkZOQTA4N2RkRXJzU2h5eU5WUWQ1ZEc3cmU1V2Jv?=
 =?utf-8?B?QXlBQXkwQnVjbEhjVSthajJFL1liWEl1WjZiNzdVVmp4MW55NTZiTFVyTzNh?=
 =?utf-8?B?Q283b0dvNDA4T2s0L2R0RlVlL1ZDS2psVWo3S3JXY0EwMGllYW9nSm1RWWJo?=
 =?utf-8?B?anBVbGZvMzRpNzFCdnNMZGpGWUpiWU9mMkRGL28vb0pPNk9DY2ZjNVdkblRo?=
 =?utf-8?B?K2kxMGtMS3NvMi81S2ovdEtQdisxMk01MzVqaURYQm1TS1FRczU1ZG9yVWQy?=
 =?utf-8?B?OGNCaTRpZ2QxeS9YRlFhN3U5c0MvdFpXSEljbVlmYjZ2am94WVlwMmpjSFhZ?=
 =?utf-8?B?aThRZnZtRnJ6dVZqem5BOXFHeXMzOWxvemhzcUYwUXpVbDJkSXYxQVpJM0Ra?=
 =?utf-8?B?UUw0bnd0KzJCR0pqK200MWFIMDRDWGowcHd5Szl5LzV0NmM3Mm9qTUhsc1Rl?=
 =?utf-8?B?T29tNE10QlpUamxMZEJyV1AySC96Q2NNUFlpRXI5ZDhEZkNwS1NpODlqRFI5?=
 =?utf-8?B?aStuZGRoUXFTUGhUK2lmMHpXelBxT3h1YzJjY0FpQkFRTUFVbmNwS2pTQlVW?=
 =?utf-8?B?SVFuQ3BDVzF5cStNeUMvUFd6KzRtMERnQnpYazBrN3ZVKzJobnIzOEg2YTRJ?=
 =?utf-8?B?Z0FnRE5hV3k5L05oOWtZekpUdkVtNFA2VVdRMkV1L3A2b21ac3V3WkFnNTcr?=
 =?utf-8?B?c3ArYjg3VW16d09KeTYxdz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?M01UZXNGY09ocFlWL29RbHlORlhISHNoSE9URFdUL01NcDUwa2ZYMzFCcVlD?=
 =?utf-8?B?NG5GeEkyUVlIcDVRRkNIUkFpYk8va2F6SEpYYzh0dkxuWGJyY0pGQXFMZ3dC?=
 =?utf-8?B?NkFrMUF1RTBPMVlkdksyZFh1dTdEWjJSVXBHVnAvVDFWME9WdDdOS05JOGZR?=
 =?utf-8?B?N1JPaWxBdjEvbnZzaGFackVPa1NvQVo3bGtDRDRIT3FsbHo3WTBrUnpuZHQx?=
 =?utf-8?B?MXpybUQ2T0UyUXJzL3VFblZnK3RuRGVYMVIrd0orT1MwZGttbkIwNDhlcFRP?=
 =?utf-8?B?ZEJ6QWhkWFMwVkV6T1lINlk3TUpZRUNrUXAvWVZUdXJGSVg5NTBpMjRocEJt?=
 =?utf-8?B?bGJoczdCOEZoMm9XM0RhVkpaaGYyM3gyS0NtcHJBcnNnWUlUSHlnRzU0NEJG?=
 =?utf-8?B?STBmNENqa3h1a2UrQjFHNWs1dElTekF5dVMwQ3VTbGJqSUtXczFqSjdkMHJT?=
 =?utf-8?B?N0xRYjlrS1l6ZDdoTDB2ejZlR0RxK01LQXdka1p6a3RVdWRpcm41RmlDdTU0?=
 =?utf-8?B?MmJBQUNYN3FkNkFqY1BlMFl4dDZMNHhBWHlhRlZSN2RmYjEzZWNHRnhvcEtx?=
 =?utf-8?B?Vnd5OUw0WXFQN0NBMXVXUnQ2N0tQbGYxWEZkZk9sZlJLNlkreWNVaUpFTW1J?=
 =?utf-8?B?ZkdsWnZhUXFNVlVQdzlnNHNRajV2R1BzYlMvU2JTcEozeW5TbHR0Q1dQTWhr?=
 =?utf-8?B?d1IxS3gvTTVUdXM5UDV6UktPWmJpelVoeVhPSGxRWmxDRmFzSHh3K0htU2pz?=
 =?utf-8?B?cHdBRi82NUZwVTFPRExMK3BNYXdpay9XSnNPMHJrYW9WSHMwNmhOaWQzYWwx?=
 =?utf-8?B?cUp6RXdpTEk3RGdZKy9KUWhqU1JxaWMveFp5VWt4emNhaDJ5bHBrNkNQeU90?=
 =?utf-8?B?ZHM2QTZSSjRESHJrYml5MXpjSE55a1RGdG5yZFlKRmtocWQ2QkMvM25IVm96?=
 =?utf-8?B?TytJRlhZanZmMUFsSFRvR1lGTDlOVG8zZVBLYmt2QWtJdFRWWEV5dmdlZ0VN?=
 =?utf-8?B?ZGJtNWV5a0VPdDcra2dHdlVpZkZsWXUwbFNOQ0NhaVEvWWYreUgreGxwSjVO?=
 =?utf-8?B?MVgrcm9wTnNYendGSW5VbFo0aEs2RlEzQy9UV3dLNDVERHFraTAyUnpCTmlL?=
 =?utf-8?B?UXR3NFhmc1pYY3gzcG9KZ3ZVeGVCNTNzd09rTmh6Sk5qSllUSERFdDk2eVgv?=
 =?utf-8?B?eUVVNm5Ncnhjd09YN2FkSFpHbURwV0lhZmkyclFBUEp3RkxJTmFxZEpVa3RX?=
 =?utf-8?B?Qjl3dzUybXBiRU9XYUlFamNvbnUraXc3cjFkSE8yRk5EL0F3RlBGY05WMmJY?=
 =?utf-8?B?QmdRV2JYbUxsVXJFTVpJbE01YjBsMlJKTmxjL2NsaE1SNmYvbFExcUdqLzUv?=
 =?utf-8?B?ZGlqZk9sekpUV3JZekppenJka3BTc2oyQ2N4YnlCbExrUDYwaXN2dW5iS2xO?=
 =?utf-8?B?YjM0bzJGZExQQzZOSVAvOVQ4ZTBNdjNvR1Uwb2p0U3FmR2c1YVBpSGV6UDMr?=
 =?utf-8?B?SWFrZEcrbjlyUncveWVwR0NYTXpGUGdEK2ZuM0k1R0VtSlIwenAyeHZNZzlz?=
 =?utf-8?B?VURJU0dvdDhnMDdjNlg1U1FZeVJ0UC9TUmh4UHBFN2cxV2Y2V0ZSeSttTU5k?=
 =?utf-8?B?ZWZrVGJFV2l4VDg0WTdrbUNOSVRJQWdyV0dKL2pKalNESUt4UHFKQVIzTjIx?=
 =?utf-8?B?a3ozc0M1K2t6UU8yVW4xYjlqblltejZ6RnJVd3VmNnZTVHlLUUE2MW52SVZw?=
 =?utf-8?B?d3ZkOEs1eG9WalRNQjRIMUE4eGdjQTRpa2Q5T0x0MWZBaTRRNkdxSEdBUUc3?=
 =?utf-8?B?djlwanFob1Q2M3cvb0RRSVhyNGxxZ25CcnZnalZIWTlSYklwQldBNkxkbDNk?=
 =?utf-8?B?bTQxSURIT0YzaVhlTU9KTmRKNU5FQUNwUnRYS2NWRC9pYWtsOGdMM3h5VFYv?=
 =?utf-8?B?VUk3UHlyQmRqM2xNbFlSWkVic05aUHcwZ1pRdXZhb0hxTXRkcC9wNUZVK2xM?=
 =?utf-8?B?dXczTk5oLy9IZ3lNNHE0eHA0T1cvMlg3dUlsNUh3OGZKbFpTcWl5SWJmenJx?=
 =?utf-8?B?Rit3VFBLRVlHRXdaZEFJc21JZDBmVnNYM2w2M2RTTVp2V0JZTENoaTJ6ZDRV?=
 =?utf-8?Q?trmE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB5415.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8971c95c-40e5-4529-f18c-08dc6f38ec5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2024 08:29:05.3829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qofa8j8TM0/71SOR+v8hevZGKwqz3dkJQKkPAPcspzERm4zga5WGrbRqRfy/flCXrbnqcugd9Q3BER8dncALjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_04,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080059
X-Proofpoint-GUID: 9935re8DU-uQQKL_pqrxpegvtVBWN4Dr
X-Proofpoint-ORIG-GUID: 9935re8DU-uQQKL_pqrxpegvtVBWN4Dr
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080059

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgOCwgMjAyNCAzOjQ4IFBN
DQo+IFRvOiBMaSwgRXJpYyAoSG9uZ2dhbmcpIDxFcmljLkguTGlARGVsbC5jb20+OyBKYXNvbiBZ
YW4gPHlhbmFpamllQGh1YXdlaS5jb20+Ow0KPiBqYW1lcy5ib3R0b21sZXlAaGFuc2VucGFydG5l
cnNoaXAuY29tOyBNYXJ0aW4gSyAuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNv
bT4NCj4gQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBJc3N1
ZSBpbiBzYXNfZXhfZGlzY292ZXJfZGV2KCkgZm9yIG11bHRpcGxlIGxldmVsIG9mIFNBUyBleHBh
bmRlcnMgaW4gYSBkb21haW4NCj4gDQo+IA0KPiBbRVhURVJOQUwgRU1BSUxdDQo+IA0KPiBPbiAw
OC8wNS8yMDI0IDAxOjU5LCBMaSwgRXJpYyAoSG9uZ2dhbmcpIHdyb3RlOg0KPiA+Pj4gQ2FsbCB0
byBzYXNfZXhfam9pbl93aWRlX3BvcnQoKSBtYWtlcyB0aGUgcmVzdCBQSFlzIGFzc29jaWF0ZWQg
d2l0aA0KPiA+Pj4gdGhhdCBleGlzdGluZyBwb3J0DQo+ID4+IChtYWtpbmcgaXQgYmVjb21lIHdp
ZGVwb3J0KSBhbmQgc2V0IHVwIHN5c2ZzIGJldHdlZW4gdGhlIFBIWSBhbmQNCj4gPj4gcG9ydC4g
PiBTZXQgUEhZX1NUQVRFX0RJU0NPVkVSRUQgd291bGQgbWFrZSB0aGUgcmVzdCBQSFlzIG5vdCBi
ZWluZw0KPiA+PiBzY2FubmVkL2Rpc2NvdmVyZWQgYWdhaW4gKGFzIHRoaXMgd2lkZSBwb3J0IGlz
IGFscmVhZHkgc2Nhbm5lZCkuDQo+ID4+DQo+ID4+IElmIHlvdSBjYW4ganVzdCBjb25maXJtIHRo
YXQgcmUtYWRkaW5nIHRoZSBjb2RlIHRvIHNldCBwaHlfc3RhdGUgPQ0KPiA+PiBESVNDT1ZFUkVE
IGlzIGdvb2QgZW5vdWdoIHRvIHNlZSB0aGUgU0FTIGRpc2tzIGFnYWluLCB0aGVuIHRoaXMgY2Fu
DQo+ID4+IGJlIGZ1cnRoZXIgZGlzY3Vzc2VkLiA+Pg0KPiA+IE9LLiBJIHdpbGwgd29yayBvbiB0
aGF0IGFuZCBrZWVwIHlvdSB1cGRhdGVkLg0KPiANCj4gSSBleHBlY3QgYSBmbG93IGxpa2UgdGhp
cyBmb3Igc2Nhbm5pbmcgb2YgdGhlIGRvd25zdHJlYW0gZXhwYW5kZXI6DQo+IA0KPiBzYXNfZGlz
Y292ZXJfbmV3KHN0cnVjdCBkb21haW5fZGV2aWNlICpkZXYgW3Vwc3RyZWFtIGV4cGFuZGVyXSwg
aW50DQo+IHBoeV9pZF9hKSAtPiBzYXNfZXhfZGlzY292ZXJfZGV2aWNlcyhzaW5nbGUgPSAtMSkg
LT4NCj4gc2FzX2V4X2Rpc2NvdmVyX2RldihwaHlfaWRfYikgZm9yIGVhY2ggcGh5IGluIEBkZXYg
bm9uLXZhY2FudCBhbmQgbm9uLWRpc2NvdmVyZWQgLT4NCj4gc2FzX2V4X2Rpc2NvdmVyX2V4cGFu
ZGVyKCBbZG93bnN0cmVhbSBleHBhbmRlcl0pIGZvciBmaXJzdCBwaHkgc2Nhbm5lZCB3aGljaCBi
ZWxvbmdzIHRvDQo+IGRvd25zdHJlYW0gZXhwYW5kZXIuDQo+IA0KPiBBbmQgZm9sbG93aW5nIHRo
YXQgd2UgaGF2ZSBjb250aW51ZSB0byBzY2FuIHBoeXMgaW4gc2FzX2V4X2Rpc2NvdmVyX2Rldmlj
ZXMoc2luZ2xlID0gLTEpIC0+DQo+IHNhc19leF9kaXNjb3Zlcl9kZXYocGh5X2lkX2IpIC0+DQo+
IHNhc19leF9qb2luX3dpZGVfcG9ydCgpIC0+ICBmb3IgZWFjaCBub24tdmFjYW50IGFuZCBub24t
ZGlzY292ZXJlZCBwaHkgaW4gcGh5X2lkX2Igd2hpY2gNCj4gbWF0Y2hlcyB0aGF0IGRvd25zdHJl
YW0gZXhwYW5kZXIuDQo+IA0KPiBDYW4geW91IHNlZSB3aHkgdGhpcyBkb2VzIG5vdCBhY3R1YWxs
eSB3b3JrL29jY3VyPw0KPiANCg0KYmVmb3JlIGNhbGxpbmcgc2FzX2V4X2pvaW5fd2lkZV9wb3J0
KCksIHNhc19kZXZfcHJlc2VudF9pbl9kb21haW4oKSBmaW5kcyB0aGUgYXR0YWNoZWRfc2FzX2Fk
ZHJlc3Mgb2YgUEhZIChwaHlfaWRfYikgaXMgYWxyZWFkeSBpbiB0aGUgZG9tYWluIG9mIHRoYXQg
cm9vdCBwb3J0LCBhbmQgdGhlbiBkaXNhYmxlIGFsbCBQSFlzIHRvIHRoYXQgZG93bnN0cmVhbSBl
eHBhbmRlciAoaW4gc2FzX2V4X2Rpc2FibGVfcG9ydChkZXYsIGF0dGFjaGVkX3Nhc19hZGRyKSkN
ClRoZXJlZm9yZSwgSSB0aGluayB3ZSBuZWVkIHRvIHN3aXRjaCB0aGUgb3JkZXIgb2YgZnVuY3Rp
b24gY2FsbCB0byBzYXNfZXhfam9pbl93aWRlX3BvcnQoKSBhbmQgc2FzX2Rldl9wcmVzZW50X2lu
X2RvbWFpbigpLg0KDQo=
