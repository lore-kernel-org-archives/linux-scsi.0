Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66099C32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 19:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjARTNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 14:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjARTNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 14:13:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F003E53571;
        Wed, 18 Jan 2023 11:13:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30II3wQ0025082;
        Wed, 18 Jan 2023 19:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PBrOspa9R+rZ9isPnjPCs1kH0rR+fEKwaT99z2IhLuE=;
 b=GPuSots4dtyPWi4Tm1udHqFbsKIPxohql3NrSt8WVRMQezN6qAAUp3FjZN0WEMAH/Wn2
 Dz9mdYnX2DBHjaVhv085jbRoaKLCh3sUkUcSRdz8g2ujTFjdbv5USR22nFHaOtxc6E4L
 nhrdOfnWbz1AdtDywh18Q4HXHA8+ArGlcFmdqO7ay0j7hcT2o7AhUUTl/FbXoKQmD7Gu
 PSgWL4k0ZO2wZIkLV54/b0FRj0fFNQujhPYNGI+NIwMPAMMH2eSDS4yT1yr4MmaNvYW3
 OL1E7wyi4AW7emmF+uDOO1LpJaqKKX05Dy4EAtFEoRvRqjjEPMwHNJ64UeS/b1Rg6ZWa gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3jturb7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 19:12:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IIrql0037051;
        Wed, 18 Jan 2023 19:12:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6pexgy94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 19:12:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1z8g8j8JT9rY03F3tY2aOV7AfJAgZ6fMC3tL+pvMe8VbzI7LFNBHKJuigEeV1v08H5PqQiXIhHh2SloVLKyZ1mkekVTs17O6i9l+2ihiExKkqUaiYZHBRnWWg3AsIhVwx5h4dBsfVpujgoSQvqp5Gjnp0i5mDxg0Fut+XXZzzPpSHDpAMXEqPBP62320CxiPWnvkTk+1e+bClgdyJRPkR2FkKiVCjJCXNYYe9s2whPlapEFzzWRAiVM1EyBCzIi9wcXgf814ukA9Ze7gVkYHcj/DXAEl/vayjUvuPeULYNrfEuo7J/UXueOYbpn4qF50lV9HsbZuCZU6w9XvTwwow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBrOspa9R+rZ9isPnjPCs1kH0rR+fEKwaT99z2IhLuE=;
 b=N73upDngo+YRO0PrPFHjJxo2qRzlHoAb6H7F5imebkKQLl5rkPzwXuwM7A34a2z/2Wxfr62g2N+LsUN51dQoU1M4lNjsqTM42JB0XH7e3WsElDekdvQzPP5IQq/F1zOMTev8EuezklVNai2F0rRThjkD/vI9PIEI65dJZoLcy6KkozSvOsAEX7sOwkyTa4/CjzPDSEBsK9fUescQnvWvsYP9hnpdagmqF4n1Kh7pzJUrqZwDXSAVt8aSa9hFOAPI/pD7FFPFqqFIy4iafjy1b6LwYzd15Z4zpejpqaa+qZisMtb7LArWJsTNWrs392qhNO9RqYn1RUVWJpDuVzM8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBrOspa9R+rZ9isPnjPCs1kH0rR+fEKwaT99z2IhLuE=;
 b=xRNXNS7sl29uPo31KytmAUcAI8dHjQkLZc3YnpH6Y2H1x1Oz+hV3Y9sKbvWx/C1bB5KaHaJgto68hGhjjxPnCZpLmAw5Q1saYyHvzo0N8NK91XGcmiZkhNWHI/YdqSV2BwNW0C5kkzH9R6RFH1qMLAH+WyKwuKYsT1BprnU6YrE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH3PR10MB7416.namprd10.prod.outlook.com (2603:10b6:610:156::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.12; Wed, 18 Jan 2023 19:12:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 19:12:38 +0000
Message-ID: <d8a17e67-03bb-2f11-8ccd-6f375f4d0bb0@oracle.com>
Date:   Wed, 18 Jan 2023 13:12:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v2 11/13] scsi: target: Treat CMD_T_FABRIC_STOP like
 CMD_T_STOP
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-12-michael.christie@oracle.com>
 <20230113141512.GB31614@yadro.com> <20230117115257.GC31614@yadro.com>
 <5574fcc5-49ea-0cb4-bb95-cb011f21fc8c@oracle.com>
 <20230117195540.GD31614@yadro.com>
Content-Language: en-US
In-Reply-To: <20230117195540.GD31614@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH3PR10MB7416:EE_
X-MS-Office365-Filtering-Correlation-Id: db55dba3-1c3d-4595-e8ac-08daf987f6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1o0djnV46++UWXgrXFqPTetZ2zWxZKw4rd9RClqNT/EqfQYMn5ElPPwZl0nYe2Xm/l1DXjVrEdfjzC7S9udAQvyMv/XL4C40lRpKE2//iu40haRFMsxIFmCWjU1SrxKnSdnxUs1oj+MoIHMtsYS90tYNKMqs9jw9Jy9q+qtTez9oAEwDuAzdWl3eVbGQwcHUh3u5b7aHyoJLuci970UgDZIGM66H3AVUi+lKYo/uUWuOA7UdjCKNBQbgxQ451LmTy3Ttaa3FatzdzaJYruepLIiyv15+SjdTN9kMUb106yx74vhe65EzhB+DpYezIsiKxoHcj/MzdAtQVat6wT5TSKht/yPOtSXezTBlzTcZxSprAKvLdbOGj7GT67AGpW8vKKq0yKGg6zmuYpb/EAapCbip6k8zHSzkV55hf0dTddyj8md0UbEjcuMOpD33VlxCyHOjnZbJFicnGhndF9Vs0YopZcY//ogq4vCN1Je18TPxjMC1x0qsadgondvTTHpPj5TOj2SxQKDxvP3PCTKR71Ro3yFsCcikiBhxyYf3Zd7OkxfTRAuJusveVUjp0xo39PFXokwOtUGf+W3fORxPDdXzkz5Et3aT48zYM+GbFdq3GGe6s1zdm4CLP3GDmTUwpDbEvaKbxLkOD8YMlPuiSgvHSK9TMCaX9X4Rv1fjwIClaEOyJwYkkI3FZHwZiJtGrEPA9ipaKUGEnaDcfHYsyWRPFvXS02xxdoFqoKey1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(31686004)(86362001)(2906002)(66946007)(66556008)(8936002)(5660300002)(38100700002)(31696002)(66476007)(316002)(6486002)(6506007)(478600001)(36756003)(8676002)(4326008)(6916009)(41300700001)(26005)(186003)(83380400001)(6512007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTd1cVFVaUtBeHdDSkozK2xyOUFEdVZYdVB1a215NUJZQ3FwOVZFSEpqRnlj?=
 =?utf-8?B?VllkY3RWNjJSeGpuVko3L0JncC9YdktkL1pSUmZBQXRqOFNMeEVlSHpsSmJS?=
 =?utf-8?B?TFNOUUhKN1VrSkhJMEJQem9mb2RtNDBtbEwyUk1rS1kxRmNGTFRDQUJldUU5?=
 =?utf-8?B?R05uTzBSQzRQb0RNbnBIY3doa0d6REpGdmtxMURuUDhPU2xNRXZ6QThoSU9h?=
 =?utf-8?B?dEVJM01MN241MW02S0NkTlJhclBZSHY0cEUwOVMwem1pNEdnZlVFY0FmaGFt?=
 =?utf-8?B?QzhTQ2s4dmo3Um1LWHZ4OVoxZFVnWndGK3Z6cnREWStxc2FpOThlVzA0VEVr?=
 =?utf-8?B?djdkemx3WDB0bGd6QUdvdW1iZWJFWHdlc3paV1VZaEsvQUZwbFdxaVFxUU1U?=
 =?utf-8?B?RyswbUliQldDbjZvVC84eWlkTmd3UHBMaE85bzdRWkFIZUtDK2NFY3JlRWtq?=
 =?utf-8?B?d3ZxY1ViV1JPRGNyTHhBMHJ0N0RoQVRZYWhQMmkyanVHc2lMOHNqckJ6YUZY?=
 =?utf-8?B?bUplNTQxSnhmTEUwVUJCN0J5WXRDK2JEM1JBM2dPNXZEcnFpRVhvOFc0THBW?=
 =?utf-8?B?Mkt0aTNnSkd6c2Jzd20rQkgzSmJMTmdrNHM2Z29PdEQxVFUxaG5PcEc1THVO?=
 =?utf-8?B?dnJzTHp6ODFBcVg1NE9ycU9GYmZBQ0E2THQxek41RmQ1eGFVdkgyalVzaFZn?=
 =?utf-8?B?VmY1NmJjWEJsbkZZaUZoZmNaZFh5aWhPaUp2OVhzeExFQTBkT0NuRWpBK3Qx?=
 =?utf-8?B?SnA1Q0NRUzVhOUNGamF1VW45RzM5OHhTazJCNmRhK2ZDMWtYK0JVYWUyUVBi?=
 =?utf-8?B?K1dKTlVnV21QNWRIQVEzS0tXQllCb0dpb05uejR4Tm5IcmVEc1IxYjZGMElL?=
 =?utf-8?B?S1NiUXBWcDJCNFZMb2RqZEJsdTV2c1BPMklGbDVkQ1dOc0t6UjVXd1hsajd0?=
 =?utf-8?B?WFpHdEw2blZGaFNyMFpvRXBQdkVrd05ma3VXUnllV0RFWVNUdGVQdDlMMVhs?=
 =?utf-8?B?ekJEeXFuUEdDcUt0ZDNMcXBEYUdrWldjM1ErUFhINTltRlhTWUNHeXFrZ0V5?=
 =?utf-8?B?ZzkxQ2l0YWM0d055YjdkbTd4V0xTdG02T0RwWldlV0Nabk8rMDUwWWU2bUtt?=
 =?utf-8?B?NGNVT2pnYWUwbE9uNWJNY3U3dGZWcWNTNjMyaVN0SGY0VGpWME5HajNvVUdv?=
 =?utf-8?B?VFFhUWRpeUl0Q0JZdHlvZnJWOVRGQTZScFAxWlJQKzh6S2ZXOVhjTkhLelQz?=
 =?utf-8?B?eVNlYzVETDh4MmZCZHVFZVJOc0JUZk50L1dwSDZ0QjQyRWR0cW1BdjBRdkpN?=
 =?utf-8?B?VnBnMDdreGdtckZzN0JQSkM0cGdveXdveWVJcVQyV28xTXoxT0lqSnpwRXdi?=
 =?utf-8?B?Zy9meW00aHhmUWJBN2NhSzJQMWhvSXA4Yk5meGlOZlBrdTVXT0ltM1hUVkJY?=
 =?utf-8?B?THlaQmtXSnhzcUwweTk1TE1BV0ppelZoSkRNR0F0WUoweUpMNU01WHVmWkc2?=
 =?utf-8?B?dEtYYitlMW43cVlCMUh3eW5keEh5NXhvY3ZrSkZ0UFE3QUNIVG5wL2ZrVis1?=
 =?utf-8?B?dTVxMHp3WXUxOWJvQlI4aHdFRXU3VlBwZG1IZGZ6ZkZnL28xWXJYelIvZnJa?=
 =?utf-8?B?VGJ1QVZNUWttbWJQM3oxU2ZIeXduLzMzYmdjTzBHSjZvTGZNajFiYUFDd1VI?=
 =?utf-8?B?NmdSMlMxSTJhRzJhZXhIbXVzSEJKQTV4L2tVVkpxTC90UlUvYlRTaTZpaHB2?=
 =?utf-8?B?aWFiZDA2VTduV3RXbFZZNjdzdS91Vm85Sk52dy80Vk03V25hT1NwQ3ZNSGMv?=
 =?utf-8?B?YUJIaWF5VnVlTWNqbzkwbmQ5ZElzQ2lyRWlMWXFYNGNmbWJmSlduaHRpYXRq?=
 =?utf-8?B?Q3ZTa3VmaUpuTExPSHgyUHVucm9FUGxSVDFFQ1E2NExGd0pWNUwrYzVTQXN3?=
 =?utf-8?B?ZCtjeDNKSXg3NXUxMEk4OUNzVklSN1ZNQ1ZLOENzZHM5Z0xPZWxDcEo4eENr?=
 =?utf-8?B?OWNlREljc0x4eVBBZ0FHSUpWbUdYMHZEeTNTSFdJWHF5ZEpEZ3U3WGhoSHZh?=
 =?utf-8?B?cmJ4M1BmR0VoM1FwTmk1U25LS0Z6Q01ZS0ZOODN6K2JXdkhnNmxnZVVBNC9x?=
 =?utf-8?B?MkgrMDZGTkZ2ZFFQbGVTa1cxSlYzdTM0V0p3NEk4ZVBDQ05JTlRxZURodTJ4?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 88Aez5tqkJQXxf2p2BuAwFa1JZZyIC6yGBvmjye+4y4io5fTKmT0CsUSeBZIslMTcddjal5iveR7AucwXTfacKYBvpz5vwVwluTXZRN0hADY/gqp/fvrZyGEUrf81swqcGYPChjAXHadJDZQc7ZX5mD1kyW6H1Qak1qcGSfMBwbeLjFEV7pMeN4qT52R4c3maLruFnUAikg8dZDERfQyC2Clar6o5FS/quCo+LksTgMCn85GLCuxGoNmqxeQnWeRx+ONIueJUP5R6IwPGayZdmQFFWfx4fH0qD7GWVESa2mDId8rcb3Ny9eqR2xNeADZC9odxfzHgXR1ACfxaMkDHTiwk8MjT0TMQPcLIungUk7EM1mk2cwa+9n+MAdrm+O0fBiVcS9Mu0PHXsBvuWJ98N83gvpSNxZ86BPr3wW0ZirC7SAJ6S9MhRF99szJZ0G8AwbC9Nqhfp0pEc5Ij9GORSaxCYq1IUHzLmnDrRBEeVPQk/a8xoke9hVsetuRJm9B9m7/6wbvMo8kqRfBwzrz8NeP9pDWXI9YjWr6UhShS89Wvjfxa4MsSdlPw/CilLVZD/A1IIGkLSJKyfFvtyCu/JsKKfJwa7u2VK4bcH8s3/UYzWUV2s4YNZbmD91iheDqh/f6Ypd/x8sZFRdb4q0+iQDQZiCmL3p8nDDRFwLYhWktLxbo3KscmUoJjH5FRRHuI5+QJq/lCGNs0p7aaXqS5ZtpTDAhL8/wLG6pTSnVb/4jrcS0TuWoMd7D/vvr8Up3UY3GkcmKKN1G7yUqoXuuBVjWsVXuYlryF1ZpipuE2ThCnYVKAN0LN9W5hwtyZEFlpS7/4GdpMXIHuNLcpCYgi5GC5vezFphANaGA+Nrgqpxsh6t2bNPSHQimQHBoy4Lj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db55dba3-1c3d-4595-e8ac-08daf987f6d9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 19:12:38.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYiGZ8nSl2NrWq0pSMAT3zykDAr8iBOkZ+z3ulsWoBODjzSE+dySZxdwV+aPOHMZ6ftuPjZtWLPwadcliR0libZX1rpgqd6CmnNnlRNLYHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7416
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=760 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180162
X-Proofpoint-GUID: NbYeVPv44Vhjh4dNAPCGhdK2ra2DtBp8
X-Proofpoint-ORIG-GUID: NbYeVPv44Vhjh4dNAPCGhdK2ra2DtBp8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 13:55, Dmitry Bogdanov wrote
>>>>> -       if (target_cmd_interrupted(cmd))
>>>>> +       spin_lock_irqsave(&cmd->t_state_lock, flags);
>>>>
>>>> That leads to a hardlock because
>>>> target_cmd_interrupted() => cmd->transport_complete_callback() also tooks
>>>> cmd->t_state_lock.
>>
>> We shouldn't lock up because for the failure cases the transport_complete_callback
>> functions don't take the lock. They just cleanup and return.
> 
> The second callback (compare_and_write_post) does take the lock always.
> Although to be honest, that lock there has no sense.

You're right. I messed up. I removed it in my tree in a prep patch
but never posted it.

> 
>>> But the taking the lock for read+write of cmd->t*_state is absolutelly right!
>>> It would be great if you manage to move transport_complete_callback()
>>> into other thread/job.
>>
>> I'm not sure why we want to do that since none of the transport_complete_callback
>> sleep on failure. It seems to just add more complexity and we only have the 2
>> transport_complete_callback uses now, so it seems overkill.
> 
> I have a personal interest on that :) Of course, it is just one of the
> ways to solve it.

Ah ok. I'm going to do the more standard process and code for the what we
have right now since we don't know when your code will be pushed upstream.
It's also the more simple approach so we can always change it and make it more
complicated later on. We just really have to get these regressions fixed.
