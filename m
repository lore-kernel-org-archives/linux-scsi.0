Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EA6C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 10:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiLHKqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 05:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiLHKpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 05:45:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7112F7E42B
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 02:41:05 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B87jHdf023767;
        Thu, 8 Dec 2022 10:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PmWaKdJUVR/XGCnTwJGAPWaw3jjjWB7yJny+cCuLoCo=;
 b=k/QGaVJvQX9LlZWF1d55jWUxaD1Dj4kT2D/uLak/2yGJk9mW8YTtZ5XVv7HgeTHRAf2N
 mnXj9puCFj1r09AtsJ6jlAVQU2+fuuVwTpcjDbtPlI1cr6nTeASGwrWlcoxYZAjA5GOl
 7URodvBKdgJt5M2nL3abrmWsTZ1AKMMcpg2/fGJs17cHEY8aTWAFB1UhpGz6c6A2lC3m
 BYGlS219SRB6KNR2tBnGPPNjabJoBGitMIMIqKo7pfU7YECf2Wzl60tNKgibGlqvpaEV
 FIP/TrGIKs+bF59Vvg0/yYzIAbMbOx2W4Tv6GkaniOdV6tzEFO2Cgymj3RoVcoX5UAbm Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudutf2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 10:40:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8A8M1d016045;
        Thu, 8 Dec 2022 10:40:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4rjw3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 10:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4Gnum5VN7w6m9UBdy8Dug2CqmZOrHj5mRwCMH5s/FHgypHJV6x4+aoLKrnP/LdEJAF5G0CTn2HfZcV99UwvZ8gxXXlgoR0mGbG9ddcB5CrRw7EuyXHrJXl2Jt8gaaGHIbjaRy3QtJmmoXUSrsMRCLcpgLP0kWhAKiaiexuG07cyw+Hxth4XMeL+ADLT0ZN+G13M0QMBrO2P+1IDOY/Gsi+qD0Z3GcqFO3XzuB/BCcrdhadfBmzGWCo4s0MUOZJi5jQV1PkEph5HZi1ZHIYV5fEBBhEECKyGDpzD3sG0gAY+Iil9ooStucTCcRl1S+/cKsZdRN2dn4yfEx1ClzV0Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmWaKdJUVR/XGCnTwJGAPWaw3jjjWB7yJny+cCuLoCo=;
 b=DcmICpTBIxKdFY9DE05T3nzUzmoERs5OFkuw/hfr3Q1k7r0W92U5t21+ZX27hnCdLmACI+nKbEHLBdaxnDS+lFhFmAcp+SvsqQUfdEL2LGKEUbhrvnFfs3tkZ61O1dfBjf5vNz8bnwfseN2imu7IoaGfUoIBuJoU11Db993zuu1lyq2PzLvZ37IrqqwnXIam0e4M+ozrwWfNU+b1CRkRox/gVF1aFTb5Ax3YQxylBZKL2sV9QZnChSkDbH67scP+L4CIRmN3QrlkfO86DhNRMg5X+EBqhvLglHY+RCD5utC/gikcNYEeRKLdMsrqIOQtt22xMZnJKLYgdLYHED8Vzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmWaKdJUVR/XGCnTwJGAPWaw3jjjWB7yJny+cCuLoCo=;
 b=H/1ErzJa+y8agOL9CLEL7IWCf/eAKDA859hgQH7hH3L3QGOttCiapva52/lNr2/c9fOdpBJmJtYqjAHfwovECTs7uMpHmHtCv9WnJjQO9ncuQk245lC2xvjUBx3ov70PWeJerSB9dl8XoqvBHAOmixY1Gi3GwHu+gvRrqEwLLfw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB5944.namprd10.prod.outlook.com (2603:10b6:8:aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 10:40:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 10:40:47 +0000
Message-ID: <8e077620-e0e8-71f0-0a77-66fd91320a78@oracle.com>
Date:   Thu, 8 Dec 2022 10:40:42 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 4/6] scsi: libsas: remove useless dev_list delete in
 sas_ex_discover_end_dev()
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-5-yanaijie@huawei.com>
 <aaeef818-97d6-6f38-4a10-36a5d5473b50@oracle.com>
 <1a1f0169-bb89-c9fb-b26a-f8c03c669bd3@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1a1f0169-bb89-c9fb-b26a-f8c03c669bd3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0469.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 39302726-321c-4213-9713-08dad908aaa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71FMM8JcNtqv/w9o5amMI3ekBE6Fw0SkFT1Ric6cmWh8b3mg1P34hFqgpC8mvJ2yhmYdtcDMXohZJA3qzWoWFsJ5HHH+ksb0048AYJ4lbj9xghAiCxcQZ//BFHtRHR8jHP0vUh1fs3VlUpgoKsEv3tqYKOUsxINGdFwF8jFK588V+e0wQmk3TMhy+44tD3otSIFhKm6J7UjJz3itW+cjxVB1oHz1bfT8DLIxiRgWGlLWoSPpX/R12YoiU3CkQD4TVYEIZivxSUdXOcqtEtFHBbJbXnS1ZB/xuLum0LcRCoczFicRf/NgA2TP5lXH30vFZ9AVO7+21Eg8GvvxaqzyDo2rfoNjnGH7oawQVeth2IktgheyaDZiMsu1b+nF3JAZfOV+btU0VxXYM6XG9eXiwnMYT4DeZAlN8PLkxtKkBcv0+x3gMBQtV2wlwrZBvbJFvDOHviNjqaf0sc/zozSVnGCu5iG9Q9VJlNHUyL4Vd2Q4jp7nYwzkLmeUvrZ1Sif2aIyEcK5clm1EQ1Ddx0i13/U50r5Ox582qw2AT6LxJqdq6KNT2WF0qQKuqbRllh/mcM2gV8C9uYHOVtySWNvwV4rufeBS03kcxcqkcPMT/JShCTmW6p+OB4T0JxeIFnUPi4l7EtZr4ff4/4zHIhHCXu4gKU0v4nG92NJNaLof+G2IhGavzFpdnJdbzbQycKIcOePWXPEhKIzFGEBjtsLKDrugdNPjoYjgPkURzL6BRRU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199015)(31686004)(4744005)(478600001)(6486002)(6666004)(36756003)(86362001)(31696002)(2906002)(83380400001)(2616005)(4326008)(186003)(5660300002)(26005)(66476007)(66556008)(66946007)(6506007)(38100700002)(6512007)(53546011)(316002)(8676002)(41300700001)(36916002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1d0K3ExMmN5eDVkMzFjZzV4c0M5QjJJOFFaVytXbUx4aGZPbm9nS2VOdkgr?=
 =?utf-8?B?NFIzNkRRR3dmd3FlZmRuUkNJanpNVHVYVEdwZENyZDVIZDYxN05MSmNicWtI?=
 =?utf-8?B?aExEc2FaSDI1dWxFVHdXandwMFVXTXZDbEo0bVN6WlNGeVRVdGRJVmxyd2hp?=
 =?utf-8?B?YzIzUWhnLzM4K3FnTEtJSnJucWNMaFRGNDZrMjN5YU5sS0lyODhuNGpaaE9w?=
 =?utf-8?B?d2dmcWJmbUVoVzNRTExpeFEvbUIvSkgrWVVkRzlEQkw4MlRpcVM1RjR3dTJI?=
 =?utf-8?B?M3F6S3F5THU5azhSVEZIR2N5alF3VDArazR2WU04eTAwYjBrQStTOTZCNVZw?=
 =?utf-8?B?ZVZHNzhDUjNOdWVGbFVEbVUveTdPTWo3dEttRTY1OFpBMDYxSW53Mm5lM0Rq?=
 =?utf-8?B?Z3psYUZ3bmR4Rjd4NFhScTZUeHNNZDM1aHNncXQ4R1NVZUpKYnNOd20zczB1?=
 =?utf-8?B?TCs0N2cweWdFemZKNk14WVlBd0UxdGNlZXArOGREQ1c1WlB0ZU9aWWFnLytj?=
 =?utf-8?B?M1hkSUl2MjR4ckRaYkNqYlR3NFp6SE43b2tXTzlJSmVvVklEQU1nR0V5RVZx?=
 =?utf-8?B?UmEvZzFmem5iQ0tyVTdaSnJheHdvMEFINlVRaHlwVTJ1MWQzaXFtZDdUWXRo?=
 =?utf-8?B?aVl5eERuZFNXQk9uTW0vazZEQnJQZlBMWTFMVUMwTFpHK2Zka2hsOXpFeWlW?=
 =?utf-8?B?azhka2lpaEZzaGhxaEVVSGQ1WERna0N3bVZOVE5BNkp3NHcrOGZlNnFCUitE?=
 =?utf-8?B?UmxZMmpUNGVlSXozNElvMlJMKzE0R0ZhMkx0NFJ1YkpCU1FyRFBOb3c4S2ty?=
 =?utf-8?B?cXd3ZEpCZDhBUXRnQjdzVno2SG1JYk5NRitadURtdTZWTmxBUERaaU9sWkdp?=
 =?utf-8?B?NU0ydWpKSXNtOFdFd0ZkZzRHUUVjVGRkNTQ5bFR0dkhZdjRHVmhxRTZTVzFK?=
 =?utf-8?B?dnJkMi9mN0FwTUVFaWhrUFlNelRJcXl0SWNzbE9FOUpzbC9XOTRiaHVqaS9i?=
 =?utf-8?B?K211WThBdDZHWlZHbnJ4cUROZkVjMGc1bXdaZk5nS2RVZTBieWdSVkhyRStQ?=
 =?utf-8?B?K05PeXN1cm9MLzlna2dycmxnZFUzTGIyc09SMzhnM1puWDd3NnNCQVRIdkZm?=
 =?utf-8?B?Ymp1MEJPbHh4MnFVbzlRcTg4Rks5VzNONEQxSGUrMHJDYkp6c2lPQjFKZncv?=
 =?utf-8?B?N1YwRGlmSEY2QmNqaUN6cFA5Y1c5UXZPSmsrdWtrbEZkdW8yY3F5ZUU5QkpO?=
 =?utf-8?B?UlB0Q3JMU0FwODdFVVFDMTFGN3BCMldPcVFsTlo2R1hITnhXUisrTnlLUXNv?=
 =?utf-8?B?bmU5dElBZGpLdnArdnFOcm1ESG95UmZubHNHUWtPQVVDTDJRdXk0NUdXS1Nz?=
 =?utf-8?B?S3U0OWI3cVdvNnRXMzFJYjNZRlRUWGhBRWxrUXk4aXJOR04wbzZ4cVFCaTB2?=
 =?utf-8?B?Vml5ZW5RZDFEZlFoTDFRV2JTd1lmci9qK25mRjZlZURTZXo0MFlvTk0yakRB?=
 =?utf-8?B?ODZubGxNVjEyLzdoUGRSMUlsV3pVMkRYdGJPY2dKL2czM0NkWURDemI2SE5Y?=
 =?utf-8?B?QThpdEROTkhMQXl3aUNPa3lMVEVEck03bkJFcGlrWDViSVdpbkZSa1lwalp5?=
 =?utf-8?B?cHcrc3VSenF1SWxlS2haVTg4QmEwajUvTjRIakxKWnE3VC9PWmlGUkF6WW1u?=
 =?utf-8?B?ZzBBeHpZOTh4RVhWbzBBTlg5bDlxVEhDZzY1UFBlM0ZQMEpYNEtTWU5Db1RX?=
 =?utf-8?B?UnFWU1JYc0UwTmVwM3pxUUJCdjlSQUZIVmk2U3J5Wi94dCt3aE1TRzhyUjlP?=
 =?utf-8?B?R0xVbTdaY3NSeEliaXM5S0VMVmhBOG1DV0VvRmJsVzNya29HM2NnNzZ6ejBL?=
 =?utf-8?B?Vi85blVlTHBEamhrbkd4RE4vdGl4Z0dhbGVYb0FzdFQyMHZMYmVvWmsrUmlH?=
 =?utf-8?B?VVlINzdMU3RzVUpQb2N1S2lPbU5yTTJDSDlxR3d0Q3p6dVFia1l5RjJ3RFdJ?=
 =?utf-8?B?alh0b1ZnZkNLMndUNUdxa1ZSblV3SzljeXd6a1VNZkhuQ2hBRnRoWXppcVJH?=
 =?utf-8?B?RTJhcXAyRFkxYXBqKzRhd0pHd2ZDbTc0am5najlXVjI1RnIvcVNTTjVyVncy?=
 =?utf-8?Q?qQ+PjF821VjvqQS4BC8Kk6GRR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39302726-321c-4213-9713-08dad908aaa9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 10:40:47.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrvBaGZ027IQdBISYthUXeHB31JzXaD2+L+LWc4NCArJCyuleVag0r9iScEVzsWkNPJyqcyNJlT83Whc0klzZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_06,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080087
X-Proofpoint-ORIG-GUID: unT-BTFA4pWr2mO3GLVFjQXRlr4rkC77
X-Proofpoint-GUID: unT-BTFA4pWr2mO3GLVFjQXRlr4rkC77
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2022 07:21, Jason Yan wrote:
>>> t_list_del:
>>>       sas_rphy_free(child->rphy);
>>>       list_del(&child->disco_list_node);
>>> -    spin_lock_irq(&parent->port->dev_list_lock);
>>> -    list_del(&child->dev_list_node);
>>> -    spin_unlock_irq(&parent->port->dev_list_lock);
>>
>> Since we have the spin lock'ing, this seems to be have been 
>> intentionally added (and not some simple typo or similar) - any idea 
>> of the origin?
> 
> The new device used to be added to the dev_list in this function. But 
> after 92625f9bff38 ("[SCSI] libsas: restore scan order") and 
> 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing with 
> ata error handling") it is added to the disco_list instead. But the 
> list_del() and locking is forgot to be removed.

OK, so can we have a fixes tag then? That even helps review, as I can 
then quickly see where we went wrong.

Thanks,
John
