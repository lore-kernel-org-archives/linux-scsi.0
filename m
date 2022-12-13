Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69640C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 16:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiLMQJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiLMQJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 11:09:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CBC26DB
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 08:09:21 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDwsgU031182;
        Tue, 13 Dec 2022 16:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=lCJOEEnqHpzw2+gUYdmFMmRdPbAXQLitRVvn3ydst7s=;
 b=KMvT6yiLND6Z3Ek6TgBi/f3ElqHYl44cZoOs3AxX8sSwcbOpjSBbrs1xZW2D5M6VBvmZ
 viV+V4+QYxtHlV7KgPbhIQp3MfY25SWLlwENwU5JJJaKRKi8x52Spn2GGtV/+3C4Egk8
 zCAmc4FyHiWTR/w47cnsrvN6qICZbRVRIoi5VkvQ3dfdnB7/SMM6AV9EH+vhHV98gPfR
 3Dc1oI0286wF8nbTaCkrZVuQc8cmwzXQMUzUXs8rjgykdy+K+cVc6F2NcW/jqK5aNVUi
 OTygJoKVM5kXb4tHwAoOLk3y9YSo9Ud/JzfUNaoUUGjsEFnZMLt5XaA48/HsRL2t8CMl BQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcghcns4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:08:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCRYq032736;
        Tue, 13 Dec 2022 16:08:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjc9eeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 16:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAS9zn1zoAFLYkDqNhm8S/5eBVXcvMup9ZWsJ2GgchpnG5BuKP+yqZ2MsL0XGTWs4mySRCo+8ZU5sZOsebU4j8NWXg7uEL/n/+6ZUuPAb9R2+vksOeoKH7xcF63u3xeoX1TX2hEcn6cEzP4kYNmCVfqqk0/DjjcUiw5Q0GToJhyB9Fz6LKdnWdj2Phv3U08LFx3ACAyPxXV/ZZey3bc2NkVCX55yXgV5qztHQqXPteaDberdfZY0qkpgwuPjSxAmX04mrb82AbU359V7V6+dLUqrP7tXeBd0XLSjKHM8iuE8lHUB65+ay0Q4sHF0zBZqrTsCfUXeJUAmbiqbtThT0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCJOEEnqHpzw2+gUYdmFMmRdPbAXQLitRVvn3ydst7s=;
 b=dBLpe9CceVg5z8LRhPjGRlLzoBWccf7qwhrfs9CHOG46QzwYjesOYUCyq8M5SFv5Byj5fz0AHINiVVUl99AamhwL+hL824pXr9BWqJ+nZq8W6+C11kY/SUNlBMptiudPrJFU8KDLk9TPWZJHJ/+026ml5GtCEsJGbjKRhpbzJ5bSInaOTj3NR6DtxSElmxrHZLU16E3zrXKBrc4BEBXVNXDn5LOpp+VuUXOQXQOxmrRnuo8Br7Epf2t+H2D6aWnxIeKH6M2N6+fBpITb9SUtdI89/JwtHqSMm7quTavaNGYNfhykA2xG0P1eZSGNZHSNP9eEnkTXjcnHoLph+p5hvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCJOEEnqHpzw2+gUYdmFMmRdPbAXQLitRVvn3ydst7s=;
 b=GYp04VO1Zr5iPRUr3vzz3A8CSr+rjTFHzjr1P8jA7bQokfdhnbKSp+S7HTRQwtOURVhiOWzlim1QTbYxlDWjmsfiHROudy7U54n8WfyLmxQ5S1nb0VN4eKMPy8+mQasNJfT25xVbalWTjQnhH6YRHKBNzQI91xHCbQoD1nyUl9o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 16:08:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 16:08:57 +0000
Message-ID: <b2b4b24c-7c92-db27-6d4e-9ec8a2438369@oracle.com>
Date:   Tue, 13 Dec 2022 16:08:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/5] scsi: libsas: change the coding style of
 sas_discover_sata()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-3-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213150942.988371-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: 992535c6-57b7-487d-5e9c-08dadd2456d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFSJUlEXo0FbEM3UeLElAQN3p3piWKPeIneclJEiBT+iiEJqUUqQYAj3xrA07xXI9PS49tKi2GWROWnFdJQQNSwTnEpbqtAF/4WPx+AU5dj4Sosj54ffQe2toTjtJmQGMll/VeIII3mUvEjxnXUkkvfUb2k5/4V0wbQoRiVuDZe5/AJIfI4X0AWVcrX6h5lT66A4fC7q/ccTXCakLEGvVi9I5CWRezjujkYufEoZoDyAcCGXcHwIBqo4cNzKVvCOra8+YadqPV6umTr/A3bMnNwI99E+BsZIGB6HqZjihv5fyr+xyFNDJvANU66mkXkbveMLpXcwytwImhqBennkzIw1ci5akN46R13aoOURShcgC3WHEDVfcEpZOAL6fkfF1XidyF3KmnIco+7Oyo2OFazCyz7f1L1NykM1esHJYBzwRn49OLteVpoKwgt8xSbDYGHigO8/1ov6vqNROohsggbCOivzQy0QfDgTLh/eoB4yMNQ0qp5lfw+H2CM+rHQFKFx6XacyDtIsjA8kBGgbXO+Veg8AjrWmwsml3Q71tlyF2Uu22s6llfIFGVjS4u4pdQsi0Lpm1wY7A4b0XGsaEUaDC0lwrgmj4foBTSvGtXJjnQp87rvxN6PgYqGXJBOD6BdMqqd51L6x8YQP83YUGbPaGC2YK1ROLqCwNv39CgQf/GO8/Y466rBP2JtmBJPj1LP6NngD1cxKG+QCpC/wWIrPSoAacgBDQB8UUJSiA9w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(36756003)(41300700001)(8936002)(6666004)(478600001)(36916002)(38100700002)(86362001)(6486002)(31696002)(5660300002)(53546011)(2616005)(31686004)(4326008)(316002)(66556008)(8676002)(66946007)(186003)(6512007)(26005)(6506007)(66476007)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWhYRTZyQWtLRkxINGRYYWthLzJiME5iYUpuZmowRnFTV0thZlpJVTBVYmln?=
 =?utf-8?B?RGhEMWpxOHFIZGVRK3NUSnRDTGM4Q2V0aHlWdW1wc0dBNFRkdE9NY1ZoWGs3?=
 =?utf-8?B?VEFMRFB5TEFNVnlmTmZCd3dZUmpvNUhGcEtLRHF6S1Judi9vWmxYenRCSnpO?=
 =?utf-8?B?Sndhd1BUdFhoVStPdDMvcEFOaHU3c0Era29hVUJzYlFjNkJOcDkramxCTlRY?=
 =?utf-8?B?c1ZnblVwYnMrQlFVQk13NEdIaUNweU11VHBxejY4NlcrN0FQUnVPbUU5SGFs?=
 =?utf-8?B?SVowTjlzQUVXdDN1Qjl0YVdoQmVCWjhicXByN3hNSUNPL2lBM3N6NkQ3bGRx?=
 =?utf-8?B?TGR3TlFsdGdLU2Jtdzd4V3dmaXJoemZObmkxOUcybWF2aUVBVmJkYmZ1UUFL?=
 =?utf-8?B?QURmUGdiV2tzdEt3a1NISEhjQVIrOVVscGJUQlA0TFlNQlRvOXYxOVBSVnVs?=
 =?utf-8?B?OWxubEc5TW5zdlNhcDlXSkViMkZhN3VCbUJvNURNU05hMitGSC9xY3hTRjk3?=
 =?utf-8?B?K1lQd0paWXBtWGJzTUxlcG8rM0ROWVkzV3hiRE1xV1pSZjRxcy8yVWtidTZN?=
 =?utf-8?B?UEIzQTViUFFzOGlaUFYyS3lBcEM3SjRWeHE5RE13cVZ4VUxicGFYL2hVZElq?=
 =?utf-8?B?NjNqRHdDYnV3Vml3WC9HZEJOTWoxMjJxbHVVZEZzVmRtMnp2UzJDRTR0VHpt?=
 =?utf-8?B?cEwramZveUFQWTBRM3JYSnNyRG84VmZHdyt5eDE4OGhyZFM1RW8yY1EySmVX?=
 =?utf-8?B?RmVkVUhVTmRPdEVIRDB4c3daMGxkM09PMlZrdDZEM2szemMrNlA2OVRMUjY5?=
 =?utf-8?B?VURkTzUvT0hiU1VWU1V1eWdUYTJTd25GZVBScGZ1Ri8rREZZU2VBWlkyZ0hL?=
 =?utf-8?B?a3MyNytwMHIwZmdIb2pzZTFlMGNna1NnU2JNc0dTdnlEV3dSUVJnVElJRUJx?=
 =?utf-8?B?NWNxczdzcDVIMWIzNnJkL2ZRM1NlcWFkaFFpSDJLUFAyOEJwbmZkN0Q1STJI?=
 =?utf-8?B?UFNqMm1FNEFyOVV3VkxIdTA4emNVdllIUlRBai8zMllIdDZBWXdpSDBlaE9x?=
 =?utf-8?B?RVZ5dk50Mi91aWNjcCs1QjEvMCtlZHcremQ1Q1hqbHFBd2RzQjVuTERIUTNj?=
 =?utf-8?B?RThvRUJpVjk3ajdGVEFtYnVyV0NLNk1kd1BrUTgzU1RjemtuclBmQmRRU1Jx?=
 =?utf-8?B?RE5KNURZaXdUa1lISXRJem9ZNnNLbU45aHl1aXZKV0tqQ0xOMjNrWjUxc2d2?=
 =?utf-8?B?M2p2OHowRzk0cXI5N0hLK1FabEYzU3J0cDQ2aUJlOFFVNzUvYVRIOVZaa2lG?=
 =?utf-8?B?UVFSV05FQkJldUhFTTBLblp0YThWUTZucmdiZExjaitIS3dTaHl1OWtKNmYz?=
 =?utf-8?B?VEdEWDhJSU1idkhmTG90TEFpVmJrVnk5THNmOVdmRlQzaDNHeURUaXlVcVg1?=
 =?utf-8?B?Smw5ZHpuUEw2Y0ZLT2pPT0NYbTAzTERlbVcwek9ydHl5dkEwQmsxdGxvQUoz?=
 =?utf-8?B?Q1Voc25MM3hTc2d6ak9ycmtNaUMwcmkzSUxEbEhoM2U1c1BxK0hURGpZSW5V?=
 =?utf-8?B?VWFnWElMOXozSlJ6TVI4NHdra2xZVnozZjRwSURTWkY1STdFbFAzVnVXMkxY?=
 =?utf-8?B?dFBNMkRrdXF2Ri9yRkxnUjE1SStHdVBpUG5pMDM1V3dMZEdyTDlqdTBVWnVD?=
 =?utf-8?B?Qm5YckNDSmtFSVNJTC9zejFxb0MyU3lEWXJBa0NxY2doUnQzMHZucUovWW1X?=
 =?utf-8?B?UGFRMDRMUjM3SnlKNHkxbE1XaWt4QlMwVU84VkVnRFZvVjYxK0ZBWms5OGtX?=
 =?utf-8?B?WEEvNFkrbE12blZPRVJNc1k1WlJKNzR4MTZGQTVzZitKNFl3LzVuTXBNVkFz?=
 =?utf-8?B?S21yNmZIR3hSZUdON2JuaHJZbG1RaHBPTHBKcy90VjhsdXI0TGpqcGNIM2dL?=
 =?utf-8?B?K0orbGRUa09qeGRvOG1RY3R5Q0ZKTWZ6Y2RCb2hMQVFGRjVoOVd3OW9GS1U2?=
 =?utf-8?B?ekRaejF6STh1ekFhN0hRUlNvcXpWdFRuM2R3bWNSZ2tZVlgza0FhZzdnS0tj?=
 =?utf-8?B?TWM1MU8waXk3akc3YnRqZTZHZkN4cEpmdjNnMWlmdE84a3BxQUE3bHVodXJ4?=
 =?utf-8?B?ZUhVQVBpL3p0cjF3QTdzSncxTGZ1eHJlQmNCZ3lEUkZBdzBjLzQ3bFZPb21m?=
 =?utf-8?B?UVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992535c6-57b7-487d-5e9c-08dadd2456d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 16:08:57.3278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/Xx7LwthWfoi9s/5V1xZhZLPDBCYAUw7y8EXrB1JwoaGjOJ1Jh/O4/7UGBzPMvuuXVAADMrYEglyrCVPeDsOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130143
X-Proofpoint-ORIG-GUID: RZ977_hy7FU3fOIz7F7q94cqen_sMlV5
X-Proofpoint-GUID: RZ977_hy7FU3fOIz7F7q94cqen_sMlV5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/12/2022 15:09, Jason Yan wrote:
> The coding style where calling this interface is inconsistent with other
> interfaces for sata devices. The standard style for other sata interfaces

nit: capitalize acronyms, so /s/sata/SATA/

> is like:
> 
>      #ifdefine CONFIG_SCSI_SAS_ATA
>      void sas_ata_task_abort(struct sas_task *task);
>      #else
>      static inline void sas_ata_task_abort(struct sas_task *task)
>      {
>      }
>      #endif
> 
> And the callers does not have to do things like "#ifdefine CONFIG_SCSI_SAS_ATA"
> and may call the interface directly. So follow the standard style here.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/libsas/sas_discover.c | 6 ------
>   include/scsi/libsas.h              | 1 -
>   include/scsi/sas_ata.h             | 6 ++++++
>   3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index d5bc1314c341..72fdb2e5d047 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -455,14 +455,8 @@ static void sas_discover_domain(struct work_struct *work)
>   		break;
>   	case SAS_SATA_DEV:
>   	case SAS_SATA_PM:
> -#ifdef CONFIG_SCSI_SAS_ATA
>   		error = sas_discover_sata(dev);
>   		break;
> -#else
> -		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
> -		fallthrough;
> -#endif
> -		/* Fall through - only for the #else condition above. */
>   	default:
>   		error = -ENXIO;
>   		pr_err("unhandled device %d\n", dev->dev_type);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 1aee3d0ebbb2..159823e0afbf 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -735,7 +735,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>   void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>   void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
>   
> -int  sas_discover_sata(struct domain_device *);
>   int  sas_discover_end_dev(struct domain_device *);
>   
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
> diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
> index 9c927d46f136..2fd15f194316 100644
> --- a/include/scsi/sas_ata.h
> +++ b/include/scsi/sas_ata.h
> @@ -36,6 +36,7 @@ void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
>   int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
>   			int force_phy_id);
>   int smp_ata_check_ready_type(struct ata_link *link);
> +int sas_discover_sata(struct domain_device *dev);
>   #else
>   
>   
> @@ -103,6 +104,11 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
>   {
>   	return 0;
>   }

nit: is there a blank line missing?

> +static inline int sas_discover_sata(struct domain_device *dev)
> +{
> +	pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
> +	return -ENXIO;
> +}
>   #endif
>   
>   #endif /* _SAS_ATA_H_ */

