Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF7C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 16:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiFGQGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbiFGQGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 12:06:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C64AF8E5E
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 09:06:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257F91wW005922;
        Tue, 7 Jun 2022 16:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dKm9Yih7thkA3rr5KvQVIxINgWf12mG072zVUGTAZL8=;
 b=ZoLTYnIcro29SFT4O+tsR1DwGsPWpajhMTj2itBwbVvVCWqikdckv2Kc1Dmeh0RFVXsJ
 i7UOaUqnar7G4ntyJKikDnuk4bB7v6pT4ESZNzmoHznj0CuP675Cyz2e5f42lfAFl98h
 KwIBYMh0mnUx4o9P65f2jsDhIJvpV1zgi/AOx+Lrj3kjtgt4+6MI4uxM+28WUQELvVbH
 /g7Fr6vb8uN2f9nqXZJekNFHpj4yFq5JtUBDMnJNQ3P1uDCL7ykaAUOjtLDYG2Zy8pzL
 6PCNOhZPRgnLgh7zpGLqA1nlPUeUrwLfBg5+zuek0oam+1bDpFxpzwTIuLglnIo5R0YL 9g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexebmd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 16:06:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 257G0GEH020954;
        Tue, 7 Jun 2022 16:06:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu36ej4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 16:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l12XxHcV2hOLVCSzPFzZYNJMsq+Gx0+LbDxTNTIq8+TDzDBs9NW2KllizEZjTBBYWbAlX6okDbDvLsJodYXQdEAyTzI+TFk88ZkSPkUFM7ADJS7QsYPyA6YunlG1VMGQv+gdH9sU21gx+7dxMCZbnE9tuZd37HfkMsoItFZfOaawhUDrAFiFR/juXCz8zrs8cf5M2Yu64ygmt4NjTxOhx80wwIh8S9ZLqZ6rSMzBh7vBI9+xZ4NZCEQjAhmPmq+1IDk0ecyC7HRgguGpAPFGcAE1VYaeWUxCThp9OqdbHPqJ9P7nmcLjV+je7OikDh3pLy6J6eE/M029+qbHk5DYEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKm9Yih7thkA3rr5KvQVIxINgWf12mG072zVUGTAZL8=;
 b=g4zFflXsUhYB9xZJWuAY2PvVGb5tUyc+l+JuifYw2eXaO7JKmyojaEpA5/Dj9ACai1uZ2XFbW/2vSruFOSAg7T7yTmp1hu/BUwLehUcZ6fMczETAVZHvNc8ihvQYI4but5ijrfYXR8i+CFDay9YFO5D1ZgNmBWIZbAB54aDlvPvVRkRajZEZIeX7ziKP/J2smZIC3NV9hJVlBk47nfsGXrqjJEnUq1RflBBQORNMIAj5KzRZTAy2wsG40xz90kxgfteO6JYGQj89UMYopNgmPgg5wD/yDQcJyB/j4uRyqxJ69GPSalOvOmliEUVHbSI7hljbxkfyEbvOIPMatleC2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKm9Yih7thkA3rr5KvQVIxINgWf12mG072zVUGTAZL8=;
 b=Sc3+8Op6snK1uBx36t/1ILiWApcX5r0BMv2fMwvob5iSxsVKUj+np5o9Oir9oXE+y32setXOIyQqpyU0hTCT98gtVOuZqiiXnLKgx10g0LkvgXEmbeitOLWziCXtUaYeXsbQ4TPTsYyEVNQIy/RMizj3WxZ2l71NscL5hDdrD9s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN8PR10MB3316.namprd10.prod.outlook.com (2603:10b6:408:cd::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.18; Tue, 7 Jun 2022 16:06:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 16:06:13 +0000
Message-ID: <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
Date:   Tue, 7 Jun 2022 11:06:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux@yadro.com, Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
In-Reply-To: <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:610:5a::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82c3b1ce-3c6e-4b39-6dae-08da489fa51f
X-MS-TrafficTypeDiagnostic: BN8PR10MB3316:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3316F34FEB2F268B5418FA3EF1A59@BN8PR10MB3316.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xc+SpJuuTnBz4B5T8Uja3r7RlUgur48uHSG0dNaRZvaUZ7QMCgP19iO2lWMpS/02YSpUdA8s2YNlkTqlO9rl0rrKUNx2ZFCFDT2nsDnJEZF/5trICSvC1DGMsO+OVJXpEfsE3jZPO8P6Yd3Eyxa4XqmZarrq7BDVxavbEbcQBwXZ/OpO/kaoEyNGO4Sxn7B6Ud8DMjFkqvy5yqnDK5VMsI7ZUHkIxZ/jg8LaMyKfDPPyoalR5g9spBARSIWZULgfLcgbJAkAgFFd3j9Ovw2nEooRb3c7OKaWQVJznyuKGcCWZ12ksp5EGh1KB2ZwV1UjmOin9wogSYmVBsnVTHA+WNVHvzrw5nU+uOMF4WKfmNG8scHvVYJZc9Q540aKjeFMvIF6+DqqI+m15MqWGKOMcQdNohbQ1wdp8YB9WiFbhIExopeNun05QVC7grIzOHG7+eD7b1pJVuq9/ZtEk0CuQXqb14ToOK8GpB4/OfG4UQUeY3ow4wO/A9/nmORhJ9al6UMsRrHmKF0eqlBPiFQjhUOACUnUyErW+ALEudkyIaSfyUJbvUIdv6pypr2/gLM2udCTV370CALIXWucKwVpz2Wj6nJG02CXbyYmmqAQXnef7bBqFpsb71T6VmdGvoVP3nTlW8bQ3aE+be65UTsZPjcOuJDqumNii/1CC9lIFQ6jtJo0RyikYex08VnVwBqGTZUDi44pCI9zElHnNKX0O2QLyxuDWCsvd7mrd/NItKcC0AMftvYx2vOz/mtHbgKBjY7Iw5B+N06PZdfbEuMjvltLZACtBhX1oXnsMliBv41E+RUzcnWuQ4uTEGnmlXxwr9h78ZRrmpk1yZDal2Rftg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(508600001)(6486002)(53546011)(86362001)(31696002)(6506007)(966005)(26005)(2906002)(6512007)(2616005)(186003)(38100700002)(83380400001)(110136005)(8676002)(31686004)(4326008)(66476007)(66946007)(66556008)(316002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2tTTGtCYmxIUFdTZTR4WTFiQkdLSWhSeXVBNE5VUHMzaFJzeGF2TDkzTUgr?=
 =?utf-8?B?SmtDQ1U2dk40akYyejFlNk50Q2x2Y29DSlNneW9QelhuNGFMeVFDaStNVXhh?=
 =?utf-8?B?bEtsTE9GaGdqUXpBdjRoeVFZaXdrYnJRek85V0NRcTlpKzdsVmJ6alRaOXdt?=
 =?utf-8?B?enFhWGtWUTQrai9tOWsxejdkY0F3eG5VOE9VSHQ3TUNtWmNZS1Rvak9nZ3dF?=
 =?utf-8?B?d296ejlvdGZvSEV5N2h0czlZUlJBQ1JiaDJDdkN4bUxPMWorZDBxYWhWOFJO?=
 =?utf-8?B?VlVCNHhlVVF4OUtKdy9PcEgxMlpkSStOSXpvckJmdEt0RHVOd3ZpdzNRZkRK?=
 =?utf-8?B?cmxNeFJpUFB2SndTeVUxR0pGM3hyakRwR0s4QlBGV3ZIN2dGUEFrZTdTb3Rn?=
 =?utf-8?B?ZDRsaURqNzE5UlcxOHZhZ1oyY1h4MW93eWl2MElvTlpxVVB4SEJHMVZ3ZGJY?=
 =?utf-8?B?SmkrczlOWmx0bFUwVVMxSURxVHF2TVlTK3JOMkN2T2VlK01wOXBmQUR2ZlB1?=
 =?utf-8?B?M2h6aHBYWEMwdUd6R3g4Ujl6My9VQnJTMFFla0VPUy91UGFSYVdOUk5zVHFD?=
 =?utf-8?B?WHFibGVDZ1YrL0h4QmdpQVNuRkVxcDRGQnNFdkZEekVJNkVoSWsxQ01oUlcw?=
 =?utf-8?B?L0tiMjBXRUJGTG42VlAraHlxaFdFT2RScndtUEFnMVAvODdUNStFWXFBRm1i?=
 =?utf-8?B?RTR2S1h2OFJOblJqdEtySkxnUjljUU16KzFPeTRnZHJURlBFY1ZxSWo2aWpq?=
 =?utf-8?B?UHFock54K0xEeFF3eWZESkROS2NXZ2luUTBYcFFOS0hyb08rQW9KNU5vbU1K?=
 =?utf-8?B?K0RpQk5vVkJJMlNXZDVLQktVdmZmL2ZRZ0o2bVFMR05oMHQ2dHlieVA4VHgy?=
 =?utf-8?B?MDljTnRGdHpsaHhFblVqNlR0NTJ4VHROa2hWT1NNaFd5a0ZoOThhUTZhUkxF?=
 =?utf-8?B?bTZDQlRKa2FISHByK08wRDJIZEFXR005L3cyQUhoQXVUTlB5bFl2UzZlOTNs?=
 =?utf-8?B?cXFIZlZOdm9HSldObFk4dkRNU0Z5cy9URC9GWW1hb2dhd05sayt3N2U1QWYv?=
 =?utf-8?B?Tm5pZTRBRWVvblpuVGNETVJXZ2h4R2tLREVBdUF6eG1BclBVV2MrNDV1dzNu?=
 =?utf-8?B?ZThxMmRKNU1rRFJsSXVVZFEvcHlKR2ZyUXh5OWJTaGxIOVRYVkxsdk5kMEtx?=
 =?utf-8?B?NkcxNGRvbUxmRjNITWhqdFRzb1hMNDhkZDc0T0tPYzRQcUZhWjk0WXRsaTR2?=
 =?utf-8?B?a0JDOGxEYW1XbXZSa0gvcU5DVFFLTlZmRGNOV3RydTdOQ0JVTFdSSXdRaGs1?=
 =?utf-8?B?VGY0emJiUnBZUE9hQlBxcFFKdDYvZ2N5Vk11NzF6ZUlXRC9oY1N1U1h5SUEz?=
 =?utf-8?B?UC90c2czVUwybVlkWFhydXlILzVMeXdSRmtxUnVxVDU5OCtuWGdGSEl1MWhG?=
 =?utf-8?B?b2xLcW82VFdnTExUSWhsR2QrSWZoVkVOeTVqOHpWNkVxVjhHSk5lSWszU2Y2?=
 =?utf-8?B?SEF2V1dOQ2lnSHp6VkRvbnlTZmYvL2F1czFhMGRrOFhYeFc5WVVkMDAvYVlZ?=
 =?utf-8?B?STRhSktRMUg0dnVGODFNaS9IKzlnMnRYenZxWFg0MEFKeU1zdkVvMVpnWklh?=
 =?utf-8?B?OUkvL2w3dm0vREhPcGoveHBqYlRJOFFlU2NHZ3Q4aDBCbDNWZ1lHK3FwZjVW?=
 =?utf-8?B?clN4eUhVa1BFeTN3UnNjSkJhRjRnaFhGV0IycmlaeXp3NTE2aitobGZSbFFU?=
 =?utf-8?B?RnhjOHFUaDlnbzNCdnozMDM2cUQ3RnFwKzZ2aEh3VllMSzY1MFJoL1FHdVJ1?=
 =?utf-8?B?Ujd3SUlkR1d1UktPRmdWN0thZGFUcjEyOUFRVDBNWlFSbEg0Nnc2ek9SYXBv?=
 =?utf-8?B?NHVuWVBlSmsrS1JVdEkzeUVVRHpoVnNIcysxejQ2MkJISGhzRkVlbkc2Sitz?=
 =?utf-8?B?Z2pLTFhySEdSYXl5YUloV2lSTWJhaGJUZmJ1cUZmaVc5Qm4vcGdxS1ZoMktX?=
 =?utf-8?B?cEhZM294dlZqSVltbFdZd3JwUEI5MGFFd3JDOVlIZ1Z6bzNOUVdnWFR6NEQ0?=
 =?utf-8?B?OGhOODg3aWczMzdwZEVqay9jVjBsZ1ZzVHdMWHRPOWU4a1FEbWYwR1hJS2lW?=
 =?utf-8?B?cGExb0J6bHQ2d3NhRlRsT0czOWNMcGhYL3E2aTJESmc5RzNiSHVwVzJCWHdF?=
 =?utf-8?B?dldKdnlYeDQ0cDMwOXRuYXpDNEhSNDJiSkNCSm5BRThCT3RiME9VRjlkdlFV?=
 =?utf-8?B?ZkE5UFY1VHEwdnNLb0ZvVW9hRDlWUTAra3FUdnhxMjhNWVdDZ2lMZjJsUWNH?=
 =?utf-8?B?a3J5YVQ5M2VQQ3dPR3lqRkZWeGltcy94VDJkUE1OM0FNYUU2R01yOHM0R0h2?=
 =?utf-8?Q?QygpqkYpYlt5lZ0k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c3b1ce-3c6e-4b39-6dae-08da489fa51f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 16:06:13.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6OjuITyxgef/2mp2GpDJzbUyva+7m8Np5MrNvJGIQ1+DEOq/rUL0reJ5Co2Mw2XS4V/9iprlrFTJ4qDx8B4Y5JUtzZUojtkaN3eMdK0jnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3316
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_07:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070065
X-Proofpoint-GUID: Ga3jLAV6xY48Y889T2-DnjkKrxAFJWF4
X-Proofpoint-ORIG-GUID: Ga3jLAV6xY48Y889T2-DnjkKrxAFJWF4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/22 10:55 AM, Mike Christie wrote:
> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
>> In function iscsi_data_xmit (TX worker) there is walking through the
>> queue of new SCSI commands that is replenished in parallell. And only
>> after that queue got emptied the function will start sending pending
>> DataOut PDUs. That lead to DataOut timer time out on target side and
>> to connection reinstatment.
>>
>> This patch swaps walking through the new commands queue and the pending
>> DataOut queue. To make a preference to ongoing commands over new ones.
>>
> 
> ...
> 
>>  		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>> @@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>  		 */
>>  		if (!list_empty(&conn->mgmtqueue))
>>  			goto check_mgmt;
>> +		if (!list_empty(&conn->requeue))
>> +			goto check_requeue;
> 
> 
> 
> Hey, I've been posting a similar patch:
> 
> https://www.spinics.net/lists/linux-scsi/msg156939.html
> 
> A problem I hit is a possible pref regression so I tried to allow
> us to start up a burst of cmds in parallel. It's pretty simple where
> we allow up to a queue's worth of cmds to start. It doesn't try to
> check that all cmds are from the same queue or anything fancy to try
> and keep the code simple. Mostly just assuming users might try to bunch
> cmds together during submission or they might hit the queue plugging
> code.
> 
> What do you think?

Oh yeah, what about a modparam batch_limit? It's between 0 and cmd_per_lun.
0 would check after every transmission like above.



