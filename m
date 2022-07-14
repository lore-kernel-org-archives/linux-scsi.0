Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FFCC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 17:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiGNRJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 13:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiGNRJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 13:09:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880844B0D4
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 10:09:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EG798L026610;
        Thu, 14 Jul 2022 17:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pymyDiq7kkFOVGndElDnLw6YVgAaWAw2Lj9xMjulPj8=;
 b=iM7edB7gOeIsFOL5yzNOiVm2/wcKIMBzag5sjdrO7yVF8JGiJgoFu1YnEfBlk97NX28a
 tlriTMPX6Iss2RTFYGLpw1ucUzKIsfdfMgXCtv5MRu4PYMtCdt29YbHZ6Yzg79lfRRhs
 7bgPg9u8cycd5sl+TSHHhrBL0f7/c1ateFV/l7+e+T72ufJqAh30YQ5DzivNedcEuc63
 AKYiLYjer/c/unnrUV8OYdIT5Yd3QhTepHQfLo6erqXla1qTUu+JIpK2Sn9YxPlPF8hL
 wU2UBh6n4LXmG4rcZr1G84LwOXbosuDdCRpxKF2YMyianaFdLDSaFaVu7vhGfdD7bgrJ tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1dbjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 17:09:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EH1SL5030412;
        Thu, 14 Jul 2022 17:09:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7046ghar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 17:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsW9Ax4yxz174wKt3wPvr/kHalgM6KF9mVX+E6QpoYBlrh5T14JfFdfOIyi3r+zCGVokq7RFoIw5NCaG5isEOuVgeNwQftdAwYSerg9XGayzQA/kk5PYdkX2EVdNDdE0KDfcZCLIQ0XFD9fVxjuzCCO4PkuMOF6XZ9xGm40lskfAKTydW5iOz+axGYP4mqqbmOGWvEjPVcpamKNg8BM+7qDZg9+VWfL0S+jpO9IW5stcFtz71c2htC6rTYtfFs/vZ+MqCxM7i/yK6aewREQ+wB/c5/t1IidbOzFTPYYqCBABkycMdzHeeGKEll5k1PzSS55FTnY/yy+oLvdsPqClyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pymyDiq7kkFOVGndElDnLw6YVgAaWAw2Lj9xMjulPj8=;
 b=ihmtaDMIfF/uGJTAwrheiDgIKu/BMA0d9QRXko+SGeN6EaRtNQ+bhstyzn/BHzU5CzoILtg1lQ7pp67v4R0mWOFSwl3KZZ1tFa9vaqwVeGYug3ISXJYp7I4LAeelHVInuiXB4SiY0TRv4S02LiE/2PEVOt0fLJYc+a7PZLHZtdv3Itksi1g+TRk5kHjq9B3aFqpHgLaANatmFET8gFwQvJHrMBdF3jqZq2WAWS+khdKZ0JqpDZ/TrWpbTvkCWnljYofuPdFSAS+I1QtQJNgIHC5TCfjoRx/avkawDzxaj3syoWGJlA5F00MgdrZ+CMtz7D3Kox4evV5Gfa+eqbdR0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pymyDiq7kkFOVGndElDnLw6YVgAaWAw2Lj9xMjulPj8=;
 b=jJ95BhfbRD+RCRzbAjwaxedMa2Q2EvDqO/hQsOiZZjEofTbe0J/38+MynmL6gcVUhj7jaVQuOQ4I5ajv2sJ7ByuwIWZE6ojtBM36yQq3uHL6RKx5WYjy72SI7bBvYvZR88ZNrzZpAaw8/5bbx75gvFa39BKhEQt2L00zUp32itU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3818.namprd10.prod.outlook.com (2603:10b6:5:1ff::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.14; Thu, 14 Jul 2022 17:09:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Thu, 14 Jul 2022
 17:09:14 +0000
Message-ID: <993fad0d-8bf8-11dc-345b-e8e7ab0faed9@oracle.com>
Date:   Thu, 14 Jul 2022 12:09:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/4] scsi: core: Make sure that hosts outlive targets
Content-Language: en-US
From:   michael.christie@oracle.com
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-3-bvanassche@acm.org>
 <1f0fb268-fa12-7665-01ae-e19be75ddbf5@oracle.com>
In-Reply-To: <1f0fb268-fa12-7665-01ae-e19be75ddbf5@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd850f0f-8760-43ff-c3d4-08da65bb941d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3818:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AWfojh7rzt5ras930EICT3kOJRFntJrMop1QnNYF9TMzLMetaK5tRnqynPhDgoOeLmBn1giFcuKBHEYbsHDehita7vHKjdPC0Ye06AUwG/qW2uMv/mikA24nUhSZfVAcZLy1tjyILxECSMSs+6ySUvA/6pMDwZIFa4qRPmg4GYQG12lF2P2zTwHkg8DAy9ibA46PH7vbqkQbnMv6M2w38RAlah6BSns1qoCH/k3fDQkKuzl0RdajqCs6D86X94IDfdF4+yGA51pBViX4IUQlj6lUPES1scWHSlVW3p5uSKL1lYkGLd5p6IWDlJdc+/I+yZHX9jCN6tFqUucPaxLKiC/AEkejlGFZCNc6udtXR2twUKMEMLFHHiHyNtA24B+uPekBjI+j1BLI9FMlZvwcGyq69htTjdwYazhKTA+9cAn8y5uq/8GMPAKPhTRrsSzng+pAM26rmkAq9QeiXS3VKffIpiM5DjoDZxAOHIKvtE2NVA2Fw06+DGGJqOmwibJoe8hmAQCS1BYdiSNBesnbbFwVMgp1UkJYMGaEr8fhqOO7ZmUm9YnOGosi/3jaGOPcLEGfkkf7nn3k9Ct6JczagEtGdPwQd0ZzeJZRb7HEpFd3edvY7ly75VYuYDPk3/EnGOF+AF9LX7Ia4tmDC7LuQq1T8SuZd9PTu2W2y1QLl0B7TMbwGRj/aWgPg0/Dr7CgD//Elue/bKAv/aoazLwvfulUpWVye9omUc82SpUs11efeUzuB5HstgsFCLcqKls+KX8KhoqVhj98Sx4+5RcZD76OtWNeRiP/m6+jKvaBu1JIAFQP6mshHdl+/gxp4Ed
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(136003)(346002)(376002)(366004)(478600001)(6506007)(5660300002)(6486002)(31696002)(9686003)(66476007)(41300700001)(26005)(66946007)(66556008)(6512007)(8936002)(53546011)(4326008)(2906002)(8676002)(86362001)(186003)(38100700002)(31686004)(36756003)(2616005)(316002)(110136005)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFVlK1dMUTVMTk11cHMrVjR0OGRHaTRrdjArQjZ0MFdWTkh3MDM1bTNQSDI0?=
 =?utf-8?B?N0p5ZHVQY2lQWFd3RW1Nb0hFY1RXSXNqeEgwcmxwdmJ6MEVkWXhIR2lTd1RG?=
 =?utf-8?B?bkxNL08xQ1RDaStWRlQzeU0zczBaeXpmTm0zbnZKaEJuYVpNQnpKRzdSbUI2?=
 =?utf-8?B?bDZBVkVLcG5CUkJTMkpDeVBEWkE0NjlKZTB4VjdnVUdpSkNOYVNUZ29xaW5O?=
 =?utf-8?B?NzgvYTF6RXQ4dm5pUGdGM3I3SUtSNW1SajJkYW5iYmtyN1ZSeWVkdWo1K0VR?=
 =?utf-8?B?RTFVTjBBWGl6K05HWGlZM3hUK29SNVJvVi9rVVd5RXowNFJvUjJxZWt5UEd3?=
 =?utf-8?B?SVA0cUNMeG5PREVUTTdZcE16MXErUXN3czNadjI1WlRpS3ozVzJrWlZZdXgv?=
 =?utf-8?B?RFMyMlNUM2JFVkkwckpHRUpCdGdHSFRZUysyTkJlNm4xUjNKY2cvYktWRHdh?=
 =?utf-8?B?QXVPeGl5U1hUM2VXSzUzQ3d2ZVZ3aXRUS081dmRNZlN5bWIzc21OQ1FBaTFi?=
 =?utf-8?B?YTlSUHhaUmc2V0FSdVZHQVZRcXcwdGI5TnRrYkJEVU5Gay9OV2FtcXVKdkR2?=
 =?utf-8?B?aXB4RHVpcThVZnoxS3l3Q0lCOWR4N0pZV2ZVKy84K1EvRFo4djM4RFpiTDBm?=
 =?utf-8?B?QlF5Nyszb0paa1hLcnFxemxFVkdsV2VRU2Jjck5HNnBJYXZ2clE4NUVYOVJk?=
 =?utf-8?B?UklFMHRIdXRnZGgrN0w2VTlGbUZWZlJjODU4UXJZeU9pUW5uc05GdEhaRjNy?=
 =?utf-8?B?SVF3OWY2RXI5UTRYbUZKcysvTXpwd1hnVW9LcDZSNks3LzJZcFZZVGYzWmtP?=
 =?utf-8?B?UzJ0VDEzdlUya3RtN1lxdDM2aG8wSHFTZE4wNEVUVVVTT0QxZC9NUlFQTnNh?=
 =?utf-8?B?RzlMVDQySjlUcnRiNDJhL1Y0NUFwSk9PM0FKTjJNbjI0WWRzQy9nR2ZxK0NK?=
 =?utf-8?B?QVdtVytXSzFtaVVadjA5MDczT0prK1oyZE9WdXNSdmdDOUhDMm1uVGFYY3FK?=
 =?utf-8?B?Z3IxMXdWcGxIZnBKYTdBOWtDeWNCTW9WRTVnNGRlbiswdmExRDFOUnJVT2ta?=
 =?utf-8?B?b29CaTYyYWFkb0NZVTFDaDNyMVBNUUQvV2JYSkd5VzRtRFZBYlpFdVhqblBy?=
 =?utf-8?B?QU50cjFkb0NpR0tpL0hBQUJuWmhzVkJUbjkxU2Z3a3ZDOFpib2RqTGZXcGU0?=
 =?utf-8?B?dm5oRWxUMWFKWnM2U1l1Tllzc1U3NzRnTjhiZmpWZ2hEMy9QODdzM2dpNUhI?=
 =?utf-8?B?N1pXY08wRmg3MU9uVUZuZzI3azYrZmxvc0s4WGFFRlNnM1Q1L3NzR2Q4RmUx?=
 =?utf-8?B?b3ZtN2lzaG1BbVFsS3p5NUZzT2VManZCQzdyUFhCb0planQrUUJ1aUZjMGMx?=
 =?utf-8?B?ODRMYi9LUEl5UFM2OFIwQ1p0VHkrSUxiRmIvVHBCKzNqa2JDM0tGYXZpVVRl?=
 =?utf-8?B?U004aFZHb3VvOURnV3BtbzVQY1pUV3lXZlRwUGdyQUE3Nnc0cmJ5VlZFck91?=
 =?utf-8?B?elk2cEcxUUlIMEtXSTZqZmZkUDlkVjF4NjNPY05lZ0h4YzRxdHJESGMzdnlX?=
 =?utf-8?B?NTllQXlVNnhCZ2dCa25PNS9ramhjeitsSWljT0ttd3hsbHBxRkVtbVFYazFK?=
 =?utf-8?B?ajN4d2dSY0hIZXNqcGQweExrSTNXVzlJUWVlalJRVWkwZUdoK2F0YkRXSGUx?=
 =?utf-8?B?bnJSeUhwK3RYQk1rVVk0dVRJUFUxaWJTOFdlTW55WUNNaWVxSk03b0JMYXcz?=
 =?utf-8?B?Vmc3b25takJQOTRDL0pGZWtnUVk2VDRRQ2FyVmVVRENOUkVyUGhOSDgwMVdz?=
 =?utf-8?B?dUsyQzVnTStYSForRFRtRFRkL1E0NnkzVzJVV2J0VU5ua0lSUFlubU96bjlQ?=
 =?utf-8?B?bUZYb1JNODh0UXJCd3crbS9tM1JPRDFIb3dIdHN0YTc3SXRYMm5LZGdvNm1K?=
 =?utf-8?B?SWMxMVFYVVJGNkVVdFFrbzdkYXk4YmJWWDZUSlNkUEZBeW9MZzlmV3g2eEtI?=
 =?utf-8?B?NnRramlHSWIzREVvUmNuWUtzR3hCbWFxVkdOU3NmS3BJNHlHNTVwUTNkVENW?=
 =?utf-8?B?U3A2Q3hrckMwbk5SUnRGMGRmZ0dRYks2V1kxQUZJakJDbkVrMmNVdkFCOC8w?=
 =?utf-8?B?Q1piaW05YnlJS1dLNzZwYUxVK2J1ZXp6QjFaWmo4ZUYwWnc0NWxkd0ZKZEhw?=
 =?utf-8?B?WlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd850f0f-8760-43ff-c3d4-08da65bb941d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 17:09:14.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWMpv78OOJQXvU2LLPfvk1Tt9hJxWxiDWPUL0j4+RQ9lsz4NGkOSy80JAvN450766UqOi+iVP13Dr2NIJiAWfPA4Ot9ayE1AwwxNIXIzNhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3818
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_14:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140074
X-Proofpoint-ORIG-GUID: IvialejzDkPpu-9GCG_QoMmIqIaqEL44
X-Proofpoint-GUID: IvialejzDkPpu-9GCG_QoMmIqIaqEL44
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/22 11:02 AM, Mike Christie wrote:
> On 7/12/22 5:19 PM, Bart Van Assche wrote:
>> From: Ming Lei <ming.lei@redhat.com>
>>
>> Fix the race conditions between SCSI LLD kernel module unloading and SCSI
>> device and target removal by making sure that SCSI hosts are destroyed after
>> all associated target and device objects have been freed.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Mike Christie <michael.christie@oracle.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: John Garry <john.garry@huawei.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> [ bvanassche: Reworked Ming's patch and split it ]
>> ---
>>  drivers/scsi/hosts.c     | 8 ++++++++
>>  drivers/scsi/scsi_scan.c | 7 +++++++
>>  include/scsi/scsi_host.h | 3 +++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index ef6c0e37acce..8fa98c8d0ee0 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -190,6 +190,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
>>  	transport_unregister_device(&shost->shost_gendev);
>>  	device_unregister(&shost->shost_dev);
>>  	device_del(&shost->shost_gendev);
>> +
>> +	/*
>> +	 * After scsi_remove_host() has returned the scsi LLD module can be
>> +	 * unloaded and/or the host resources can be released. Hence wait until
>> +	 * the dependent SCSI targets and devices are gone before returning.
>> +	 */
>> +	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
>>  }
> 
> If we only wait here we can still hit the race I described right?
> 

Sorry Bart. Ignore this mail. I missed patch 1/4. I see we do the wait in
__scsi_remove_target.

