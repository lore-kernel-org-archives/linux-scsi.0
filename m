Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00838FA7
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709317117; cv=fail; b=kgvEFzvBX1yNPpT16DFvTQoDuDQWJWb+rz5H9fm2moDXokad6CDCnJ6U7fOLr6rscAS1Xe27YtfFKq065X6sPDjByrUglv75IcfMIYHB0O0AUyRYZb1VlgPagHevYxdBu7ltASEkq9VNeWs5YV7IwFYXD1ArIXKrhQIreQOWDIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709317117; c=relaxed/simple;
	bh=uW+Na7EwBC5fZQsRP+7H9NEGXhZW781wNwWXQ19q/hc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=akbCbplR5EQLfOQ4j98TgGs4vfKZEYWSKfUfDy9mbHb5Dc4Qm+VApRL8oTW8QhtqmxYhjPk9u8zuc+Slv4k3Q/xXwUMBxBhG0naCAUUh6iuilJU0ZOakMAyjXISi+kIYPxH0HGIBkwsy3oRrb3Vz5zosh216f3Kj9IhsNwZQnzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GYgmYpSi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wgoUd4+2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GYgmYpSi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wgoUd4+2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 421GBZqM006274;
	Fri, 1 Mar 2024 18:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=xMDLvz81SS9bqOJud2zkwn6UMAeSGYjSNIkxREiGk1E=;
 b=GYgmYpSiBZ3imrD1DOqAqhaWFUMngU+hdie4vdXTioYdi+uRtiB13tBwD54hgZBLYCwf
 4TAR2qK9p0NUEIAyWZWVi/izuxc/HTTnYTUTV1LWtTgkBWALfdlvaEgXYPwoSWf8PTj1
 fHfaK8ectA/WwY1fK7CtJ8YUsKTC2lbYiyB1BpxJSZxc05s3+KD0jkJQZwDWUwkmPji9
 DFU0Mx1dfgAk9Gr7orpSOWpwyNfExDCc4nM2ODk5SNJMoPiep3+Oe6WTIFrh4Xkbwwjq
 MOnBnGStZwth97QgPHnB5DkW3M3qT2UZjPv6kYhX3qnKY4MSJSlcAzZwtKInRj+SHDRN kQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8gdsu80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 18:18:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 421H5OeD004672;
	Fri, 1 Mar 2024 18:18:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrq86uya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 18:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRFqu0Ve+wOC6qpSAcW9A3gP5Z7JTg5nFzTyEh9qdY1VZ5/18vy8vavZJui0KXv5jSbKJgEftvLm+Ou93nlSmxUKWIw6DTiHGdfnV4hjlrRelu6fNsr5bFYDOmbDQ4cTIHBSWStQIcPc0J6wyllIWx2EDOqbwc8DMElcXWPZprisCQrWR0TWc6udCHr2Q880p3JFyHWv4wjhbuHf84qDIpaRyZi2lwVGRup+AkIsdkFUtyi/6rrijy7K7L+R2OisfAQliZ+fQQUHKwnS4LDwjsyheJ/XGaXgaEz7MFSt/i7IelgSuCxjoVLTnBT9Aby9muYpi7M3QaWhbTB6C/quPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMDLvz81SS9bqOJud2zkwn6UMAeSGYjSNIkxREiGk1E=;
 b=Jcs0KrEx+g9wqpl1j2v4A6gORZzJ5P8fH1cM94QF4EZNsg1yV4SX6vNTxGER4AjKqKZKZ7fL/iVPQcL67u7B5VWQZ67dBrs41EhmUiBBDBkPdinQlgFzIN16qKQS25BHx+agGCvs0MxA0Ycwv6gyLlWUKbgKrRD0RU+7ybDW8fSVRjlAAOVK1BIm/b1oCyuGTeQ4fbuDKTjfjrA2tIaJmDxXKSqiSl7N3qwQZE5Z+szWSRVSqJCQVdX77C8/KeG7+xzJ13IZkru9C4HUL8iBjMwUgaCsZhQEWlb9WtkjvXlFVzGG2Z2M/FX6JLcCjjcx5oEFm4XzX+CL63B9uRb1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMDLvz81SS9bqOJud2zkwn6UMAeSGYjSNIkxREiGk1E=;
 b=wgoUd4+2Wq8JvdhUYHeZeG1RQCkbWKItiE/kxKbXxCiX3/ND4bUjztPMvfGuaSqF0u+5Zt3AcqgljEl9/E23dgx2T1SxPDL9ytCKrn7KtzKiZhCh8n+DyoLFGkcwilJhIdN8twhC7WqIczCRYhkoEsQzkZpdkpXfnbsVrh77Dvw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5714.namprd10.prod.outlook.com (2603:10b6:303:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.32; Fri, 1 Mar
 2024 18:18:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.039; Fri, 1 Mar 2024
 18:18:05 +0000
Message-ID: <fcad0227-dfd9-4fe4-b977-2eaf6242ea48@oracle.com>
Date: Fri, 1 Mar 2024 18:18:01 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make CRC_T10DIF support optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172320.2494100-1-bvanassche@acm.org>
 <d94983a5-9c0c-494d-8fb7-51e3dd2d3460@oracle.com>
 <61b4391a-8613-4ca5-b250-3253f2085712@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <61b4391a-8613-4ca5-b250-3253f2085712@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0015.eurprd04.prod.outlook.com
 (2603:10a6:208:122::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: 3245ded8-252c-47e1-97d1-08dc3a1bf081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xBapydCq6CqLvHeZjKULmGC945IPK783Rxk/z3vjglsEAFVDCmWGyrqSZYyhDbfwd2p6thER1KcHYZqoJcvMgViiMmaPbxwcalj03MWLu2/zD+d4LZZir3aXhDk5HbzcQN5GHxQn9C7qT6gzxT6SdPIHoHbLaLUrz7dKTiB9512Vdy9pd0lEbLad5WIcjHJQ1r4cYn/trB495NDOj36Vx5ZYSp6HRuu0/Eh0KAYDWXqW+zfo7iVwOsjP4dYE1NnB7Sj8SLgh9Y2BnzQls8MXwvFnuzT36X+Cz4FYsiMtftrJqNE+L6JRXbMZ1khENmb0Wlc9bUVtvLAmHRMdtZXf43FsoH2gx+GC7OUjUNPz71DeMMvx3C4cbZqNaPASa2xuQGNuzdx1j5YKd2V69AoAZqF6jkAPlEaKhFeG8KmzqmW0DQXhQ6E3hF5vPu7+BRFaxLMcGPQbPli/9LIGhErmQKflnoeGPHhIrSaJ2HhKENi3mwWGQ9D1DxCJ7SuTjVPXcJmubprXJUMNCqokKM71TNDWiziAGYj6IWvxx4ESMdBcScDv57aFyyDGl16vRn2lj9cvm3Q9HSjNpNxkMXQBo9/bgvDD3niC5xlQJyCxW1DpLcqLcxkyd+rluaosprGAqUvpAKPJnDn8td4vm/fpGQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M0FtanZwb3U4eXdmVEVFVFZjZ3ZuQytra3Btcy9DNmdHWWJXb1k0cnA5YjIw?=
 =?utf-8?B?V1ZRVi9DVlhhdm9kakxXZ0x6ZThZYXRlbXE2QzB3N2dZR3R2TDhzYWZidnUy?=
 =?utf-8?B?Wm5kUW1Nb1FNVEl3VmpPbkYvUE5ncGZ0NllTeGpoUGFETFowOHdpVXJBbUVZ?=
 =?utf-8?B?V1FFUDNaRXQwenJnZUVjdkRieE5sWGZ5U1dCWkM3ZFd3QzByTWF2NjNvbHho?=
 =?utf-8?B?RFhoWWNSY08zK0FtN0x6SjN3cWc0bFF2VmFGbzBoMnhTRm5OKzhmY3JGakVV?=
 =?utf-8?B?UmRSWk5seVJoTE14TzhzcDVCcHY5R0VBSWZqUWF3TEwrelo0UTdjV3dqWHpn?=
 =?utf-8?B?SmovWFlnZU15cGx1WWpjeXBNVWZZa2JWK3RjOFAyNnlNejZSMktUNzNrWHk3?=
 =?utf-8?B?Y1B1dlZCSW1aZjdpbmV2WmN3Qi9EV3pNd2Z1Nml0L2N3bktIa3gzUUxWMEEv?=
 =?utf-8?B?aHV1T1FkSUEyRUgwNHZOaGw1cHlnaDNlSk5CQ0diOWhLU3lDc2NsN0dyZ0Fr?=
 =?utf-8?B?dGpReE9HZngvMU1lb2oxdDlSMUpQMTQ4WWx1cy9lMnIwMkczSzRiTFJhcldq?=
 =?utf-8?B?bmxhY213Z3NabGUyaUVYVm8yelBUc00xQ1l3MUtHZDZVWERhSy9QbXlyWFFG?=
 =?utf-8?B?Kyt2MkRzYkUyc0Z2M3l2OHBPcFBuUmhWTDRrMjUyOHV1eGRCT2VqdkpxbmZn?=
 =?utf-8?B?SHJKUWdid0p5TEhDTDFHd3BsSzVaZUVObWNCRjNoaWtJS2tWeGRFajY2eDdp?=
 =?utf-8?B?Y3oyZCtINVoycGtmZ0dFeHZkaFE2Ry9TMGlpZlVmMmJqTmszSENMaVRHUEVp?=
 =?utf-8?B?Z1ZLYmRxMS92RHFsYWtuaXpTZnJHdjFvU3hSTFQxS3RNMFJSTnEvTzJESkZx?=
 =?utf-8?B?SFV1SENPOXFPaEFaeDh6Qm5uRGRENG9HTE5sZW9SR29qTWZtbkhqZVRqK3FH?=
 =?utf-8?B?MjBtYm9kZmk2OFl3SFp4R1NYK0g5a3F1VzAvQXdidndkVFE1ZHlCVlZOMzdl?=
 =?utf-8?B?N2VnWjZNOTlFQVFFQXhuNHRDTnZ2Uks0NEsvK04xV3NtRHNLZ09jZXVPUDhI?=
 =?utf-8?B?Yk9YdDZkZ3EyRXp5SmNtTUx1alpiSlZxU0hRS0pCUWtYMWlPcVFIVUFIckxI?=
 =?utf-8?B?SFhwVHp4WG9jWDVkUkkyeGZFM1JYVFZ0N1dJRVlVSndtOTZxNDIwbjhMRExY?=
 =?utf-8?B?NjJIN3dTQnVWMzFzSHorSDdwVFQxNkNwb3hYTm9WM2Y3UzJWcjJucnoycEZ1?=
 =?utf-8?B?aU1zR0xxTEZkcXZMUi9DYXMzOUhNeUwxVmtVb0hOWEhqaWpvMC96UUtxMDhE?=
 =?utf-8?B?WFRQaFpyV2VXVTg2bnZFd3UrS3RraURmMWltenI1RkcyMTY5ME9xZ09QbjVN?=
 =?utf-8?B?bFFzQnlwRm9ja0lWR01ySFo3akZ4a0RUVjI3T2ZGOUk5ZXl2OTBLMmhZZndL?=
 =?utf-8?B?M3BVNHNCR3M2b3V1NDI0M3J2cE1sTlh4WHVUMDliTUZoaUVUd2w0N3YybHRx?=
 =?utf-8?B?eVVxVDdhRmUxREdCam1HRlJEVUNVR3p5SzJjaHFpdzBidDR5czZDWWs5RExB?=
 =?utf-8?B?cTdKNUxYbnZQbVRZbHdhQUVmdDRkYnlrT0MvS1ZFazFReDJ1VzJGM09iYm5a?=
 =?utf-8?B?R29TTnlpNHRuc09paVIrTkFBYVhQMm1ycmIwVm84Uk1mRHNYcVlWRzVqMzVt?=
 =?utf-8?B?c2FOdXg5WmxwakxXbDV5M1NmTmtWTkNDOUZubHhvZHM4RW1PTFNlaVFhVlQ5?=
 =?utf-8?B?bDZYeHc4MHJBWnF0VlRhK2NYYVJVa0hPMEJhRDd0K2dqdDdndHZXYlZOWlpX?=
 =?utf-8?B?ZU5zRVdjOCt4SEV6eEZmNzNpQ2dhbm1nRUxybVRvNkFOUFNyeTdsU2paQmg1?=
 =?utf-8?B?bzRURHlkVmJiWi9lMHFTMGRjT2FueDBjWHdEcHFMdytUU1NCb1ZQMExEVnh1?=
 =?utf-8?B?bUZKK3RZR09OYnVmakVFY0F5bE9VQW5YejZ3UEl2ak9VdzRjTVdwOFM4NHU0?=
 =?utf-8?B?VEQ4eFVoOWl0RVI1bi9PWWwxdlZLKzd2eUR2NHo0NnQ1UTlEb1UxeG1QVzVI?=
 =?utf-8?B?UVdCWTJvaWFheFM1WDUveEU0TGRreFRGbng1RDlXYnVIV0U4ODVqNGtudmFq?=
 =?utf-8?Q?iD4Y5xJK0/YzYkSwsrqLFfFZM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7kz20HQFh2w4bbqViGMFv64TurLTvVil6e7+omONAi/MiUn5/qCezytdgE8tCIxTAwSgzGtMGtOv2uqa3MjF+GZ/TJkL4ChZs60NcqSV2qVK1ij+aoPx6X9oiYZ4DGl+kgiBJFGnrd7etr5Pi1IiViPnrYSRzoHTlmS1OKlw77UCSJndgh4/m1M3gPTm2pksK6mEIz4hfvdINbyhNoZVl7VXoigC2yO8m0s2SQJYK5cLM/q2gPyKPTedaqgVoohEPdq8XM5Nl4YOxRKVyKbGrvugTLFSrX/ar0yla5Cb+FP75gAnJ+kDwV44H3nDukmqNh/zZfxXgMbw3SLCgu1hHHWCqYQPhCouRXbPmw+bp4HjYGDke931SLoVgpHxCJ8wMLL0v74Bzvhq99/SDoyMAHwNoHlCqtGL3/BrkdBRiudy7fbnUwknmJLEpKogRoKcS/s0/Acosg73M/OEGGZq5OlysR+IwElwuO1PeokP3ZzDsBDq4LES+x9L4soDHqEj1lV81widdyfyocxjM4Gp015IHF2T+/hkDIW8WghZT69lGShREkkUIVNdJVI37osG9XfcaW0Gs4ryVD+JS9IxJmMMzolF49d4KXYLIjJO2gk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3245ded8-252c-47e1-97d1-08dc3a1bf081
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 18:18:05.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtTmy65d+77IdS8/Q0n5phQS03naDY/92i2Z3KM73jLo6hhextttGtDGyFTiHvdBRAMKMDfqh8o3Bs61QeEcvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_20,2024-03-01_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403010152
X-Proofpoint-ORIG-GUID: r6DeZ7dsW92Pun7XVzlSo6B3v1Lpplu3
X-Proofpoint-GUID: r6DeZ7dsW92Pun7XVzlSo6B3v1Lpplu3

On 01/03/2024 16:30, Bart Van Assche wrote:
>>> Not all scsi_debug users need data integrity support. Hence modify the
>>> scsi_debug driver such that it becomes possible to build this driver
>>> without data integrity support.
>>>
>>> Cc: Douglas Gilbert<dgilbert@interlog.com>
>>> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
>>> ---
>>>   drivers/scsi/Kconfig                          |   2 +-
>>>   drivers/scsi/Makefile                         |   2 +
>>>   drivers/scsi/scsi_debug-dif.h                 |  65 +++++
>>>   drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++
>>>   .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
>>>   5 files changed, 308 insertions(+), 242 deletions(-)
>>
>> That's a pretty light commit message for so many modifications.
> 
> Hi John,
> 
> Thanks for having taken a look. The patch description is short because
> this patch doesn't do much: it 


> splits the scsi_debug source code in two
> files and modifies the Kconfig and Makefile. No functional changes are
> present in this patch.

I think that this info is useful.

About this:

On 29/02/2024 17:23, Bart Van Assche wrote:
 >   config SCSI_DEBUG
 >   	tristate "SCSI debugging host and device simulator"
 >   	depends on SCSI
 > -	select CRC_T10DIF
 > +	select CRC_T10DIF if SCSI_DEBUG = y

So this means that we select CRC_T10DIF if SCSI_DEBUG is only built-in, 
right?

Thanks,
John




