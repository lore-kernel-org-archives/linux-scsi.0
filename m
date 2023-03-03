Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CB9C7EE39
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 16:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjCCQyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbjCCQyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 11:54:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04653CA3D;
        Fri,  3 Mar 2023 08:54:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323GcqEa025266;
        Fri, 3 Mar 2023 16:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EjRjJ0Ph+R3Cs/Z0kedmN4AMC7JeEldLiWFhhcyQ0WY=;
 b=zBXKnzPiMbzI+OsKDMNjVpfOxXWmklLZf0bZ4LQqD81Uzy6uF5TkNJ1sbGSJFgkoEu1b
 Kp2SU/Heq3yy4u+BaD1ESfuj4AJN2qO+zIEJfmOBVyuUUFyK4dkBbWzlSJcNpahDOo/e
 CaegPTnssnMDDnv/oLooMWgVFAYtGXE+xf7+wz0sTNRr1sqS2+dudMcrdyWhS8Lk96I3
 3eLMHqYDREwauQFYT4/J/43/BstEIYogj6k33L2D5D5iasiL0CkwMgfhXnxTLd10VxRG
 WQY8VWrFCbcOVDtlmMGrmOYCOIlrOQozGuE06SLGEKL7kHL2WT8eDLWAlJDS0IJMAQTI rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7ppbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 16:52:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 323FYO49000581;
        Fri, 3 Mar 2023 16:52:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sbq8s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 16:52:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvGOhZ/QfKxrtoJhh7Usi59v6zuDAgLIoNsy2J4HZIaRkB6Pe9xluhfbIIlODs4A1JGGdglKUSCis9IVGJbKHJTf84HLtFJn7y+1FW3JiCqN6Bp93OMFXSIp4tk0vJJoasfb0XU2pxkmFwIHYf7gTDW0EzLWyw8iHkesrJO2ilOHqdu0WgOMS43Hp3vEPqJnqVP3f1f6bvmQhMuwAI22Vn65I4mpyUT67K3+oWBQCgRODqALudtlKqPSfSsBuf2uDyE3/KfLxUIW2uBjzsVS7HqAbytSPwiUYS9E5lROfokdPtfXY4G8/zulNOZe5rcA7SsCvKZWBC/tYj5inslKpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjRjJ0Ph+R3Cs/Z0kedmN4AMC7JeEldLiWFhhcyQ0WY=;
 b=c+x/A4tQHnvCu8lERvatcjlNzYqBsNHK/8QVghPwQkbhSULCN/mdQh5fRTScTxlSQvvVH/tMPm3sACqU7OiY37VGdSomEnMdXPjK1XPlxqOLhHs0CI7p2cx/n8l5O6Ca//19BPqI/uh3GaScYOpVLEh4/plnNLdMBrePx9d3zvKGJ2v7Wvkt/TDQ6bFVUMTQ0BiZxlSGs891+kRMy0SiHoF0uEqIVHENIRzwyLRCnsKCGUXeSv5vyVi48Y8tD+VaSV5fiS8o0zz9FBj/QWrBALzNLMCT5UbSJbyu3PiBOd+0dQofrRAV2GiBLYilFnOtsAirTS5iGnhsnuykOi1uSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjRjJ0Ph+R3Cs/Z0kedmN4AMC7JeEldLiWFhhcyQ0WY=;
 b=RfnqmhkTfQtEOL+MehLYdXeFBHu9UQkq5N7ywFU/iYsqvt3oSrT0Le4RAoQmaFIeOJSnzU4Lb0nrDcBwGW1hH61vCVBvOAUmv4AYKK3lB3B5Vc56pWlDpdyZSIOzz7+sj/6N3sd5FHM5VvxKQXr+sYvbI4/NTJGHPJA10rTfSSo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5555.namprd10.prod.outlook.com (2603:10b6:303:142::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.17; Fri, 3 Mar 2023 16:52:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 16:52:53 +0000
Message-ID: <04556c0c-6020-7329-9d6c-f922dcf884ae@oracle.com>
Date:   Fri, 3 Mar 2023 10:52:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230129234441.116310-1-michael.christie@oracle.com>
 <20230129234441.116310-8-michael.christie@oracle.com>
 <20230211085922.GA5419@yadro.com> <20230302094317.GB1340@yadro.com>
 <896813f7-9296-8072-fd2b-de25d9d4ffe0@oracle.com>
 <20230303092650.GC1340@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230303092650.GC1340@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0070.namprd06.prod.outlook.com
 (2603:10b6:5:54::47) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5555:EE_
X-MS-Office365-Filtering-Correlation-Id: 47d7cd1f-edae-4060-f7ef-08db1c07bb21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4FUL2Z/zz1jQ1XO0bhUxGWPMClewQO1pxwLy61enEl0RgjfTZ5lygQaDmGDKCl0VSHHnDohhxhKqVjoSVaGWd0dbtQHpSVW1MSty61UAN1l1bBR7SQIBfATJdMounywOFquyJhb58hXzj5rZjKPb0/qN4rpzlm9fJpVroc9DzfwHl74WFWQ2K6nFh9dAJEWwODravmgX3DK1U7G7NtTW58dG7New9wd/owvFiLy//YIGtWKcZwK4sxQt8Wr1iYLKWmk4K961MA7q0gQS8t4AjoJqg7Aho9nDt+BKX96VIgq9doo1p6O/XgBtWFBYkKhPSzNRzt8wXcfiBsg35RRdIXfHmD5InCgdzhnUsxuJPEXOeq947m9OMSLeiuoiFg5nrWPp6e2YFkJfi/uETM+oVZiB7m5CBt3sI6OJ1AZBv1XYrpy3wcdVp8jM1NlJ8qvKYIBcxyqMdDhFOctoC3KsdnwpQnbxaUgDGkJKdWeRbmXzH3BTRqzRuVAWUtBLLgO/wQp2kYILspwliQ6KTiDUxNsdDhjAI0EyrIjjkos1eQcUfJNXHIrYzZgxOGEZjHTMask2bsFceAszY5/t342OlFBCbjyrP3QCxNOyIcJvl3qbcRj/uceC1Nr9gmERpvzgAb5F1GCeSe9FilbMvwxlX+X6Fmty5f8pV46wNAwmjg7qytTEeln2vpbOPo0HZ8LMF8ahNpeOyFvHdWGxTT11pXnFvycEnhUWeWhlGpyANk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(6916009)(4326008)(66946007)(66556008)(66476007)(8676002)(41300700001)(26005)(6512007)(186003)(6506007)(53546011)(36756003)(31686004)(31696002)(86362001)(2906002)(8936002)(5660300002)(83380400001)(38100700002)(6486002)(316002)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHE2Nkg0c0NwKzkyc1BWbHdaS1lzODlZODljOGtycVVySHhKSnZSc29ZTE9R?=
 =?utf-8?B?SDlGcnJoOHZRZ1dmZXJrRE9INU04bGY1MFZIUGV4MDRIUVRUSzBVN2lZMFVu?=
 =?utf-8?B?cko0RmtlMk5GcEZ3RzFWckR5azIyem13ZVlvaEEzbUVTRG4vQVY3YnlxWWFw?=
 =?utf-8?B?TWYzS213Z0l6RzhvM0dkTE5ucVZvL29sNEhGZmZZcXErdEQvMi85UjQwaFpo?=
 =?utf-8?B?dnpxQ0hST2ZDMXhzbUdGeGRwUU1kb0JIM2RzT1Z6SkR2RHNVcEtmL1JxR253?=
 =?utf-8?B?NWRxQnlwNkRRVERqTCsxMk1UYVhSeHBpOVJsakdKTEVLVm44R1RBUnlBTVZS?=
 =?utf-8?B?WWFHcWpNVmR4YzVqd0puSCtoK0oraC9oNGg5YnUyQmpQYThvUTdkMDNWcHJF?=
 =?utf-8?B?bTVRSXJVR3lPeStWNTF5TlRBUzEwcStJT0x6YUFnbFR4VFlRdmlIRGpUampq?=
 =?utf-8?B?dTNzMkR6dFhJWjBhZlprOEJpc21yd2tvVWcvUmpOMnhjKytabytzcEdWQ0Fv?=
 =?utf-8?B?T0NzY0xQTWhxRlBjWlhVZHdLa1BlTUYvS1RqSGdPbXNGcjlUeHM3TGFTaDRq?=
 =?utf-8?B?eFJZV3dmYkMwbldFbU1iUzRVcTB0b05QaUl3NnZpclcybC9tai9ZRktNYWt4?=
 =?utf-8?B?WjAwZmhOc1JTcFhIZ1RTNzNVQWxMb0VJOHA1UGtoQnhhU2svZE91K2lSTVUx?=
 =?utf-8?B?QVBrQTFKWTdoQmVqelpzWG1yQUxmNnZ2eXQ5WlFpalJCOFYzM0MweHdzeTZi?=
 =?utf-8?B?WUQwVTduNmdVNlFpdmc1WWJWYWRBZlJRczQrdm9pM1NyckxabU00dlFjUWZH?=
 =?utf-8?B?a3d2eFo0Q0YrNEdOUFdsZlZ5d2hmSjZqWFB3Y2lBeC9qbk9XbFI3Z3dadkhT?=
 =?utf-8?B?cVdLWVUvWVlJdXErRndjd0tiUC9iODUxOGEvS1NBQndrb0w0UTZ2VWlxeDFn?=
 =?utf-8?B?NDlHa1FRRGJEeDc4MzFOeS80VFJUVGMrdEN6QjR3U3V5VmM4OHV2NWw5WlE5?=
 =?utf-8?B?Z2xiaTF0OVBJYkUzYWNzRE5nZGlTTlBTVTJ3WjVqMzBtRS9Ia3hacHdFVlJs?=
 =?utf-8?B?VVUrVVVhRmpzS3lCeUFsNjI4Sy9OdXlrMlBNTE5yVVRJTHZGc1l1UTRmb1Uv?=
 =?utf-8?B?ZklKRlZaWHJLQnQ3NEplTUZMTDFQVlk0bzNDbU8zUVVwSE4rWkJUZVRwOVp1?=
 =?utf-8?B?amorMG9uWWhRd2JPa0h4TUl2eG5IK1hwZjdlVUUrZy9iNldiY01mTllPNGxm?=
 =?utf-8?B?cFVsMVVKRTJmcG1CUDU1alhOZjlJN3RVYjEzQTUwU2F1enVwd2JoYlZaTTlk?=
 =?utf-8?B?UnVNZ1NsZXhDSEVSWnFwdjRwdXlWb2paT1lwTmM3aVd1WjRhSXEvRzdVQkwz?=
 =?utf-8?B?QjNsQVU1azJPZlcyOGVCSW9HckxjS3hqa0lPZXZnVWpFUFRWalpieWpXaUQv?=
 =?utf-8?B?NlNaUU4xa3U2QWM0dEJxUUNRTElWYzhFSTRjRFpzUG1DUGdBdU9KdVRzc1g4?=
 =?utf-8?B?c3lxVmZaMmlwaDYxWlJOQlYvajFvQmJCeEhFZ0VMaHZzVnJrQktKTDdNK3F4?=
 =?utf-8?B?YTJTQnZyWVExemNuTG8wWFFnZ3FWZjJuQUJZSTJsOGN4bkNpRWszWU5tL3cr?=
 =?utf-8?B?WEwyVFRlUGowMkV1c1VoaEk4UGcraEVQeXdtUk1OTWFZMHgyVkVhWFZRZWZW?=
 =?utf-8?B?YUlVTnB5N1V5RHc2Nk1PTUhGVE9yS3FDb0Zpd05YZ0NKZ1JHUXdocVZUVStG?=
 =?utf-8?B?R3BSeUxheW1ROThONTBiMUNvaDRpaEJFby9FSVpNbHgxcjEzSVNvdm9QMzRP?=
 =?utf-8?B?VDBIVlo3N3R1KzRPOVl4NXFieGpsZmlwSGNaZ3M0M1NPMVNZekhLenpCcjRG?=
 =?utf-8?B?cGpNemE2RlVFUWpBK3c4Nkp0cmx6dS9iT1RSeW1vcmtReUFodlhLOUFlRkhL?=
 =?utf-8?B?Y3lYcTM5cDNNMWhranFWYkdEc0t5VnF4NGQyVTFyWnQ2aXFWM1B1WGk2eWxy?=
 =?utf-8?B?SGJKby9wL3lscHcyUE8vWmxqMEZYL1ExYmtxMEloOEVqcFo3N3NMQmQ2bjBP?=
 =?utf-8?B?ZXpoSnBHUnNlSS9LSXV5cWhqeDVxNW5zdHdyaFJxTVVJZlE0cExVQnI0TU1C?=
 =?utf-8?B?MC9PQXcvMVdQSzE3TkVFektqN2dkS2taTE9oRndad3hmU2hudDBTdW5WNUJP?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RaovqPAGfIV+344OtqjYicAqHePny/NI2h68NrB4l495X5Jh5czljfVGnjw2n9MKRKtRgLTifsq4AVtpqOKVL8/3bgI5P+Swp1t3oEcKyojPAh3vbeUcVF6abTAiRb0qCTW35l7OX1UlD9vLKqxblygEb19lX6WKIEznmn5uD7em3rQTV95jwC9ISmW6ZzbNq+mOImGEF9SgYM4JRtahyZvK91XFTxuIKSXWoKy31NNzu1IM6x9QsrOJ9o6GQigDI1MFhUzd4XeasSjLj7krMU5j09DHtqgpFEC1QXXygZ0+CbxUKXaAFFZ/pg7BD2kTk+MXTNIorm1rFVgh/S/Zgvngr5+4RGqUe5Gu9kIuTPfEtyJdT2eRT7Nh6UjvMTNjr3ccAR2WzsB3vUgGoCLe4Rb10dsu1ojWlQBuSB7X2llaeFAdvjIsK7EXufP6RzzAn2AX9IS6csfJdw2nrzAKMmaLdJb+mmDkeUpyk+xaBy6l32+iLdJgzWRGxsiUKGFKhv7WwpKyoqNO6ZiQQFyFh4ktRJ9Ejh8JEg7jMqYgn+++yBdc+SozftwUVGMUomYz0EXIQaN0dZzn877VvkIzVYlIhHDQbuKf9JWIQheqt1nkZbAejbaWTJuph9Uz8s369bqfOzjM6DwJl2EfhlZEkQAFxr04UEFLUcOwboh/JOy2KLOUWSc4BLqADXGl0F+KvXQJEdDphQ9J69YJ7VZ34KML+lNnzL68q61gZ48bO9DW11tj44+QweXW8oYY3mx0IF81zy8AFnu6lSi5ekLZVlGls62wszQTFQaKejnGH2/2uzSe3o7geOK7DwWD2oUB+eGO6FQBtnnpPSUcUuSxv7J3b4N+UlGh4ETi97skdAb51i0jp0tcoitIgHayuYk3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d7cd1f-edae-4060-f7ef-08db1c07bb21
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 16:52:53.4690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKugJjvANRbddi+oqXSIMdm+BCK+UR7mwLp5wFhVuQFGJaBJt0zi7MPxWtiuErd/quWEkAzBTtR2/evBwAWxp83ruUPaRyQOJ+6HGrPBOcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_03,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030146
X-Proofpoint-ORIG-GUID: Io1Gnj40R9mScAgfqIdHZXVK0YBvU0Yo
X-Proofpoint-GUID: Io1Gnj40R9mScAgfqIdHZXVK0YBvU0Yo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 3:26 AM, Dmitry Bogdanov wrote:
> On Thu, Mar 02, 2023 at 11:29:50AM -0600, Mike Christie wrote:
>>
>> On 3/2/23 3:43 AM, Dmitry Bogdanov wrote:
>>> On Sat, Feb 11, 2023 at 11:59:22AM +0300, Dmitry Bogdanov wrote:
>>>> On Sun, Jan 29, 2023 at 05:44:34PM -0600, Mike Christie wrote:
>>>>>
>>>>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
>>>>> up running commands when it hasn't. The bug was added in:
>>>>>
>>>>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
>>>>>
>>>>> The problem occurs when:
>>>>>
>>>>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
>>>>> 2. The initiator sends a LUN_RESET for each session.
>>>>> 3. session1's LUN_RESET loops over all the running commands from both
>>>>> sessions and moves them to its local drain_task_list.
>>>>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
>>>>> the commit above has it remove itself. session2 also does not see any
>>>>> commands since the other reset moved them off the state lists.
>>>>> 5. sessions2's LUN_RESET will then complete with a successful response.
>>>>> 6. sessions2's inititor believes the running commands on its session are
>>>>> now cleaned up due to the successful response and cleans up the running
>>>>> commands from its side. It then restarts them.
>>>>> 7. The commands do eventually complete on the backend and the target
>>>>> starts to return aborted task statuses for them. The initiator will
>>>>> either throw a invalid ITT error or might accidentally lookup a new task
>>>>> if the ITT has been reallocated already.
>>>>>
>>>>> This fixes the bug by reverting the patch.
>>>>>
>>>>> Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
>>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>>>
>>>> Actually, this patch even fixes a crash that we've just faced.
>>>> The second LUN_RESET moves the first LUN_RESET from tmr_list to its
>>>> drain_tmr_list, then the first LUN_RESET removes itself from second`s
>>>> drain_tmr_list, then the second LUN_RESET tries to remove the first from
>>>> the list and crashes because it was deleted already.
>>>> So,
>>>>
>>>> Tested-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>>
>>> Unfortunately, I am revoking my tags. This patch leads to deadlock of two
>>> LUN_RESETs waiting for each other in its drain_tmr_list.
>>>
>>> To keep LUN_RESETs ignoring each other something like that is needed:
>>>> ---
>>>>  drivers/target/target_core_tmr.c | 5 +++--
>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>>>> index 2b95b4550a63..a60802b4c5a3 100644
>>>> --- a/drivers/target/target_core_tmr.c
>>>> +++ b/drivers/target/target_core_tmr.c
>>>> @@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
>>>>          * LUN_RESET tmr..
>>>>          */
>>>>         spin_lock_irqsave(&dev->se_tmr_lock, flags);
>>>> -       if (tmr)
>>>> -               list_del_init(&tmr->tmr_list);
>>>>         list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
>>> - > +               if (tmr_p == tmr)
>>> - > +                       continue;
>>> - > +
>>>
>>> +             /* Ignore LUN_RESETs to avoid deadlocks */
>>> +             if (tmr_p->function == TMR_LUN_RESET)
>>> +                     continue;
>>> +
>>
>> Shoot, that adds back the bug I was hitting.
> 
> Haha, exactly.
> 
>> I have an idea for how to fix both issues, but let me do some more testing
>> and will repost the set. Thanks for testing and reviewing this.
> 
> scst serializes LUN_RESET execution, may be we should do the same.
> 

That's what I'm working on.

I was thinking async aborts are nice for ESX where you have N VMs on a LUN
and you don't want VM1's abort to have to wait for VM2's abort so left that.
However, for LUN_RESET, it has to wait for all the commands, so it's not as
bad to serialize them.
