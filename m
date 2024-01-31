Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F06AE545
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668555; cv=fail; b=Itu3mGPpSokc3pNXeojc78njL+tjCNPsnLXEcH5dCn1JNO+m/oii72GX7iwugdW9G3XkivZn13siCqqEkUUz4BUczlNa/qJhC9S8WkZCZVeGJTaIxCyk//WbZ8WegN86VcH4WELpmQUmS8cMqOUuZtXttK2WDFXpvbsggxgpJOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668555; c=relaxed/simple;
	bh=fKTIF/fcmNJIo/Ai5VnA28N6X7PgNKvNdu5/bcS7M80=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CAv/mhDEfWlrVEBP8OQ2ddwzGLvMIwG/dYnXulkSlq8eiQMIVRTmkmF1bxUYvh2SFeGUK/ZorNQia8bOZMGwLe/tOjrR9rY2cRexgA2dAMzZSRdlEW+qfU+Cd6OT1I8TIaZYExDCkcej6vsjdJV2DBJdjrPZwzJxF4/QHIxOshY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JzlP6qm6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EmnfRTOa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JzlP6qm6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EmnfRTOa"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxEV9017261;
	Wed, 31 Jan 2024 02:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=u/kOv8/dTdea1AQCb21L+UnkaDAGoXRdYL5npVa7+RA=;
 b=JzlP6qm6Vv2MgusJgyOcriIrDJbuPlNu9YeBQYfNzn7csj4pGzGfh3oJ2Lvs3SBMgHyr
 k9OZPZbCGNBWJiTdfYZswYOZgsBFuNads6ZsZ+5Wx3Jpr2GlcgNukGZWPtPks2zHQkDe
 zKKdqw/Ym0xC9hzy0yzybRl7VmuMc0tK833Wt4ATwlAnTEsdQgyuIIeBYx3GhmrGmMn0
 Zr93xdowWxF2SYelEW+3r5bGNwCTQa1T8KXuf8+Dt9uKEL32dAh3THROwbnaFcv2vcJR
 sjmS7gIrbxz/Rbv4T4hyosgwQMqxUKHfJ2BLRR2KT1ad0zenZ39nIjVQU0QKS5tl6Bul YA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsvdrmxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:35:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V1rTxI014462;
	Wed, 31 Jan 2024 02:35:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr984apx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:35:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8cIcLS2gkRKi+2EK9j7oTw4484mjS/D+QmJIdQQ5Yw5V/vV7V/ToHKs9BRsIUR4g5S1adVmwszTvYplsuNC/WLf331Z+QDqM7DqNZI69CxN2jYi1ixQ+GNM/LnYllgol2XtYzKx2YuM1fxB99I+EQOCJcsCNqRY4NFC8Kk0+yVw9BZeYGk4p4gxOKSB3vAX6kjkqQA5qiytJMrAee5hz9cnMQoOFZCxGYOpI/800PaCaHgmMnnvgKo7Fm/h9Fo/HpWiELlB/apYjwhYR2PL6VIKHlW5fd2O39qopPN44o6HTCEazo7nDDs9mHS+3lnZj2fJGPhZt09Wh+F/JX0X5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/kOv8/dTdea1AQCb21L+UnkaDAGoXRdYL5npVa7+RA=;
 b=l9vhjvd/ciyO0MhDNkxlVw7URoJfYo7SDKgigtW5ainWBokIe2gEG7QogOW18E+C3oBEnr+u6G+UBHXkWdIcIFdC5W4/WIb9urQyHWqNiVg2FkOHzpMZ2mQHHqaDWYKvAbvgggo1rKilC/GY0KbVAA6W6YYhEWv9GaYC1Dz1uv3TEauKRSuX142qxGd4lBd3GNMxDy1vF+OYzEgViF1qvL4qR5LvDHmDn/v6MKpAtnrAwKSJkiMODWVCm4/c1QKmkL6spCLJjOVGVcECcLj0EbSGreGsr4eDo0ThZNtDiKD0q8nziM2kSzpZdAIRxIpVRVvjeiu7SZ10VHlqlKdhJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/kOv8/dTdea1AQCb21L+UnkaDAGoXRdYL5npVa7+RA=;
 b=EmnfRTOaADuCC89JbY7s9HnXrmAGUVPanIC7sfrLjcxJtonfFiIBfSPistELzj6mxmTeTXZvlzaZ/xLtBF5cpDLIfbtpDbDddREnS5dGoqJ8NxB+tdNscSaT455GKlMaF97urWr+808lA18o/fdjQPWEZt5bkM6647pfUuZhl14=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:35:49 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:35:49 +0000
Message-ID: <b4a37782-8d0b-4e5f-baec-4c741a261330@oracle.com>
Date: Tue, 30 Jan 2024 18:35:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] lpfc: Fix possible memory leak in lpfc_rcv_padisc
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-3-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-3-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ec4bdb-30d2-4eb3-9cd1-08dc220555d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sx6HkxReyRienIyReGVAIXS/e/iIdxyq/HnL+Yne66M5F2AXE2Qk/Ir1iroeZvaP1AksmXWmHgjSsNRPBI0AGG8AEUpqgAYCAoyRHtO3HazUYtVEpr/GUdvhf2cHQt31liNCh4kZSGXHnTRWmnRwxWS8FTJ6/NLZk/bJMCSeQvgd7KW3WdTZlcGVp9Td36UPCeFTQA1xWLZWmuBrYFJ/fbARiYSkHCioH0FrRvQsxSfOvoRPJKXnWazjVYoRfU6X9/Xr9F81HzWe960U8pT/3YQVUjcGw5dfGLT/Cdn26nJjJ15fiOtuEWwu9dIsneaBOeJJS10k0JcTJ8uAzespedLiGqh4BwBj26K1EealkY6tKdwZer8/ROggUoPIPav2NRDMyzdA2rtlY4Pu4r0bbbFHrwuLab9oHDvvz8b9NJgYJ6xDK/2JItfXd7W8GAkLZo9kQN3yB7qdSqR5MgNodx5QGQPJCmjqcC94CEbgN/NJYpRO9qeqeJSzWV8XJjgYvIPnkLcjV2Q3m+aA1Idj3bAtN9ydU3mqAScIfi/PAiiFDLfBCubpBiSVO8owU2f6OZ12MH3IBvO7dtkL1CyaB4TsmxkXdtgS8IfXApKn/IAChXW/c4NVmcSpiwI84DXPkREHu0HyubWD1hB5OKOhvw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K0plK3JYaXJ1dFE0aUsycEY3aXdjeXR5eUVKQUhHQm1BWVA1MmFYQlBVcHN2?=
 =?utf-8?B?cHRTNnB5aE00YlhSdFJTVU5ETkl0TmlEd2psZEpOSGs1KzBaOWIwYlZXWVBm?=
 =?utf-8?B?bUdnM0htdTlQbXFxbEI5Z1VpbGlld3NxMXdsYVdWSDNWZk5QVlB2NGFqRDlK?=
 =?utf-8?B?cFJKUjh5Nk1rRTFLanJTdEh1MWJNWU1QMzNkendIaG9JcWZBdytQSW54VjRq?=
 =?utf-8?B?OFpGMDlYVzhSdWtBaDltb2tNYVlWM1RrUlo4Qzg4STlwbHViaG5lQlNQVlRw?=
 =?utf-8?B?TkxEayt5TWxEQjNoTEhnK0NQRWc4QUtvMW9SY2pJYzNtNzgvZkUra01NWUlQ?=
 =?utf-8?B?UEc0REh1bmxiTXRvMzNleTNEN2s3NUJFMEJuWWxxb0gvd1psZmRSeUVJb1VK?=
 =?utf-8?B?Z1FwbEpiUDBjYkRwaGRLbTJ6ajdDSTFLN0lIS25VUTY4RmRVeFBJYnZKM2dN?=
 =?utf-8?B?RCtxZzNubTMwd2d0dnRNN2V4eGpIK1JlckdxWXB1YzNad1AvOXRnQUIxQkhZ?=
 =?utf-8?B?UUxHTnJZUXZqMHhCZUhVS04xZDduZFRlRjRQOUF3MTBLWU1XM0cwWlBjMGk5?=
 =?utf-8?B?andBR2Y1VmhlMDZPTkNUb29wcEJOd1owQzNpMlBVWUJSNGh5MmtYdzBRcDVq?=
 =?utf-8?B?aFYwN2hlVHdXajNrWGJ5TzdMa2pkdCt1OGJaVCtwdzhKd0FmM2lKVUt5OWpt?=
 =?utf-8?B?bTRlZWVUaWFGM0l1SzlYaG9kYUtkRmNxYXhpcXVscnNlUVFmSFUvcXBBTkgr?=
 =?utf-8?B?RXIyNnA5eFE0NWhlbWZmemhQNHpQRk8rcFN5cDBmeWxnWHNHS3JnQXhSem5O?=
 =?utf-8?B?ZDdDYTRIM0JBSmFPeG9iakozVzFFWlBhYXNCQXFuY2VOeHBOc2RuVEVPbTdY?=
 =?utf-8?B?SStpbDNIZ0ZmQ3FTUlZXbi9hZThUUkdJYUMrQ0FPYm5jQllmanpEUm1DRFJh?=
 =?utf-8?B?MDVUYVVsWUxkVXI2dmZhVGpUNXFucmpuY0JkTm0xQUxZUDd5MDdYWGltbXVO?=
 =?utf-8?B?L3F6NWdEWFlIQ09tNGJQVncvem96RlYwU1lKdkFKR3puWjh3WlFhVkxBQUU2?=
 =?utf-8?B?VWRpcjRicWNxV3d5VXo4dEo0N2VCd09LYlQ3bGdKck1POE5qVkZKSEh4bERr?=
 =?utf-8?B?M2NwMUJCL3hOaFoyWXhKSUl5REEvZCtFa0lXTjN2ektkQVdsZjJHSTAwaHNB?=
 =?utf-8?B?RHc3VFk3OUh5dUVYdEZIcjJDRmhJblVHbEJIdm9uME45THVrODRiM2RjV2ZC?=
 =?utf-8?B?T3BrRzF5MGxKOStqT0M4YjdYRmFkN2hsdjAxOUVoVVlTN0ZHYnRkblNDZ29O?=
 =?utf-8?B?YVdoL0gwWUp5NXlPMFZGUnNzUDVEN1V5SUkwemtFQ2ZsZW5NeWFSM0hLOE9y?=
 =?utf-8?B?WWs3cDl0WUJZZUVQaUNHbnZ3R0J5R1NwbUJmNHJRSTZQQW1QOWVIdDYvTktx?=
 =?utf-8?B?aXBtZDFuRHF0ZGNFeUNmUG1pTjRuTURmSHJxR1VOSDVkT0tDbTQ4YWhvOFhI?=
 =?utf-8?B?T05mdDlxWW8zbjZVOU9ZY2ZvR0RzaEV4T1pMRjYrZTZDY3JYdXVIZ0NMamsz?=
 =?utf-8?B?ZnlINng0V0RyOWZ0QkZkYzVndkt3ZGpRRGlRR2k3MjRGUnhwKzM3cGRYQ3Bq?=
 =?utf-8?B?aTZ1L1psMDhtTWF6dTdnU0cvYi8wZEZVbGZqSWdvMDRKWmN5WC8rQ2ZlbmRM?=
 =?utf-8?B?NTRRTWp6QitRSXJaYVZTODBjUTluMXNLa1hza0p3UkVTazFTc0orTVZMVEtn?=
 =?utf-8?B?RFVCMFJuRk5CYjRWYTAvWmVzRHBvQXIzZTRpZFhhQUxuOVhydndjRGl2K0ZT?=
 =?utf-8?B?T2xJRnpFMTBxekxOT3FHYjhHYWgrS0tKUGM3dWE4d1A3dzlwSG84YmZpU1RE?=
 =?utf-8?B?a2J5c1Q0Zms5aFdZS0p3bVRIVWtOVnYzRTV0bElaTmhHYllLczVLWGMycmZR?=
 =?utf-8?B?OHpJVGI0V3FWVkZsSzl2bjh5VC83bi9NT0ZQNHE4WE03eWJQS3VydFRBL2Fy?=
 =?utf-8?B?UW85UEgxUnpRVDdNTmR2Q0JMNW1yc3NwSWdVRDN6L01TcXlyd2dEckwxQnh0?=
 =?utf-8?B?SFN1YUR1cHl0ZUM0aVVqNmJYNTNobDI4L2gwUGRDQm0wcVA4c0c3a0NBMXR3?=
 =?utf-8?B?ZXRhTFl5aFM4WStUOFZFZllnS3labkQ2V2JqQkJZbkRrTW5CQmFrSno0Q1Nl?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	k1JUaTj8T3yMV9plsmKpBp4g1xKcpHYsqdJqZXYi1iE4CvodXNuqjKNm6PlM3Gl1RxyesyqIAqCyIpNjUwHvKz06ICpyjF0U9ZrO2N78Yur9QOxVx181Aiwl3QsiOamuYDC6MGxOsEOFEOrTL8C1iT3Fnb+uqFSX+MBfm4dT/R6wnOlAQKWsRb6ji3ijfS/nfAg+0xDEsEOZceLSHV/6Q6AbZDlxNslfBhl6xCKJzSf1TEjrGM6YZvtBvEeIHOCxNNm5UZSFxHQ2nLaCkiyDuH9HQMKP5+8tIqJriG4HZ4QV+2YsboMkx1GQgtI0BGYTVAwjw7zoFmhzDN6D/oqfvL3j7pAocd6Ncq7QdMXyEZVZAfrCHd0P8AIAEvR4tVPSEAzSUb/FHX4lodR83xC2Hp2xCEqc+Zq7z6s7IDgShO9PC+K0ZgI5X+jXwPiD0OPW7M0w0o1ocGVxEROtbciL6qua0BshlLaI6nzn6/d5fP+abvYvl4AhrJqXrfxmC0ca/cXpB7XYFQ0WBFPQdh4TXpZcVfTR1mryPEPC1C6wg6abo2rATzGjqKR24XISLia/q0Xu7g69QuFcH9i1swAwGOcDLjqpKmPZgHx4zN2X7wc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ec4bdb-30d2-4eb3-9cd1-08dc220555d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:35:49.1048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uF5q3XPzPfKsvCed2IFq0sjF5DcNjx0KM2wvdTGfZnBQL2DkXuNEoJRsR+gtVAZkqC4V0JRvhts6oPY8wsyFvdZ8VkgTMsVs2r59ccOgHcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-ORIG-GUID: 7Mp1jqPRLr5gNSPXjriQamTLYdwrXRX0
X-Proofpoint-GUID: 7Mp1jqPRLr5gNSPXjriQamTLYdwrXRX0



On 1/30/24 16:35, Justin Tee wrote:
> The call to lpfc_sli4_resume_rpi in lpfc_rcv_padisc may return an
> unsuccessful status.  In such cases, the elsiocb is not issued, the
> completion is not called, and thus the elsiocb resource is leaked.
> 
> Check return value after calling lpfc_sli4_resume_rpi and conditionally
> release the elsiocb resource.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index d9074929fbab..b147304b01fa 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -748,8 +748,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   				/* Save the ELS cmd */
>   				elsiocb->drvrTimeout = cmd;
>   
> -				lpfc_sli4_resume_rpi(ndlp,
> -					lpfc_mbx_cmpl_resume_rpi, elsiocb);
> +				if (lpfc_sli4_resume_rpi(ndlp,
> +						lpfc_mbx_cmpl_resume_rpi,
> +						elsiocb))
> +					kfree(elsiocb);
>   				goto out;
>   			}
>   		}

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
