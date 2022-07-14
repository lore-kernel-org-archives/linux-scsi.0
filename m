Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A38C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 16:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiGNQDv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiGNQDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 12:03:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FFC60EB
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 09:03:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EFrJwa000875;
        Thu, 14 Jul 2022 16:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wFnkyUI9lpKadPfeU44Afuh+OyAsLU3yNgRSyxiH2LA=;
 b=vn1LceF+QGhRvdOGkPCKm81apoxVIv7nDL6pUgw0nK78Uv19mnJ1Cd4wn0VyOO3CRLhL
 pZ6GlodrsUH0xSykCb8yWxXW9/ESiiGoaj0dL0LiEV2USpK7nr6Auqn5jV6r5hzE3Flo
 r3hUOci+6Kmft5FCyFDyaAgr8pJQtm/V5jealhiNolchjyrH+l/50AeAG5nbfC4Bciug
 CfolcMY8uS7pegs8q+HN4r6rXJio0V/xjQpY7esR8TD1gJ/lPAZkr+3xn89nCjkBf34E
 F4lYMzhQITQqmlgtxL6Opf+iORie+rpsUEtY/LwSu4NyDciZRJipIKPQe7y3zUNC3dcO JQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71xrnm28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 16:02:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EFvPMA031339;
        Thu, 14 Jul 2022 16:02:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045pm41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 16:02:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fio7EnNVAN90/Dr+3q8fNljWzZl9ldW4LC25l7MVbpRcSwgAmQvQ8j1VI4dtErYQIKkASvNlj2WpXei0g4HEdsv3pRGvJLEhu02SUQJkHdAsB7iTjchjdv4kHq82hFK9sG8MWGdX85c0tiabZL/D32FkHeuXW+i0jR/7EBeqIikBXI/uOOWtfBlChaz4Zh5cb37EIChPJaUk5Scr0x0HROjRZbCqhyYl4qkoOel2PmQ3pU8iYVW+MzozPsdUnMaxB+03O7lLXMfzBx8aOaMd97SMpJIL+A5qdwo9dpiOilxbW9rfzUjM42M3kCze0oi+yZqtFRjhvDh2rhxcLjSx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFnkyUI9lpKadPfeU44Afuh+OyAsLU3yNgRSyxiH2LA=;
 b=E1yAoPkL3wdEi89M27/+ZfZtduDbGyZ4DGXPV00NGmWIKgjvHuZWXIhBXDYlIYS7wyeDmFchsEoiA8B8p4vz5TLKtn2jtkoTPgVf1vGOP4q/Uot6W6UYRXe0HWrlAbfeehZ2ZAhtYPyNm6nLuHJu/gL/wsWymPL8R5TKqSueNBgoyK0MMbUjDb9UburncTyGTzJp0s7w8ifu/XkI0PzVyq9y0aP7WPQ33FVBfh9pOab1lxmAstpcc2uvRD2IfFzzu2b+PfRDimLyzPnHsdoC7y8lWVNiueNVV8jc0yhPRJGyUpRJD9XGvSDtk8ECYvO2FL7XKnlzkpQQkuV5dpMxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFnkyUI9lpKadPfeU44Afuh+OyAsLU3yNgRSyxiH2LA=;
 b=dAunf0zIKhhGapGfW9kSlLd6zmVV8w3wYHTseHVRYYnIlq0vsrx6FhsTUmLGTNYKnfAwsbywDcKOwIE2K+Zp2AprScoHLVQG0/WQarLgFpLw4Qx1ZIDtuJvRIhgVIO64KGNDQ+9g4w1Hf8Xyyf7LWnpM6UvoBf8iHdenhrwD0OQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3257.namprd10.prod.outlook.com (2603:10b6:5:1a1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.13; Thu, 14 Jul 2022 16:02:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Thu, 14 Jul 2022
 16:02:38 +0000
Message-ID: <1f0fb268-fa12-7665-01ae-e19be75ddbf5@oracle.com>
Date:   Thu, 14 Jul 2022 11:02:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v4 2/4] scsi: core: Make sure that hosts outlive targets
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-3-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220712221936.1199196-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c87a90bf-017d-4010-329f-08da65b24667
X-MS-TrafficTypeDiagnostic: DM6PR10MB3257:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZY5z8Ycb8qsH8SPaSZjx1aLA/9yFpGiW7X3PCsfqNkyRzp1QOrrs7on8h3WcKfhL7HMCmNNsnbPR7c8QAYLUlM4etN3pQhFU3s/PxXiuLwzqtH6KRNuCrewPUtBTpAy2iUatsR9n3Tay9gifaIIbBXpvjy4nEyIwkM44Z9S1mg+2VB0rSh5puTg9KDNNNh5ob9/sxx6HibF78JIVIM+gmsr0cfdS0dYzz6lQ/8zF/aCVS9xLOqvxEp9rQKMJPlpgIB4wW+/+WoMEh8s9i5CsUKf/zukFPL1+xnm1ik9WhotesRHfEoRozhqRTBjNnuW2m/uCodua2llwmq/c1cdnym1AMVaTEpMZIzUWE6UusEa+5/+SQydkJlpsspFlFDzZJ/kw7P/6bwiqmWWb2yg8y1BMJUqIyEsup5EL3/hn8LbaitPEwU3D5ir9gBTbG5XK/oTbu4dzlzRSry1vqa/MRhfPgR42llf4Xx7KDJWStwNHxV+Fy7feELQTHK7jU0qE2TZxsEZvu/+dA+BQJBg1PuJwkfuPcOcCGjyVoL1TwgRuqDx875eaAJVNjkATJ7E2r1ux31W9lWJ4nQAqECLYOuw8npKP9h3Ggysk3Bqgk5i2S4lXytrjOS+COX9pUg3GUbjwQw0ZTiTqLSLCYGmZ2Xi7bjJAWWebSTQn+1zuenI41O/wHvZGODkSjjquAVY7kOsqsXltIXxgpmcj+xVGzeBU4/Xo5/PHPEP1uWSqyJdus3/Vkv464BfwHVMv7K7rT2aM6EGhqzJE12ajk0lIsT71U53eLgdniiACjOYprhcAl4RQxLupuNHCmawUA2ep/3UrVIgXoRaLjgrrb/VPPCib4ZW5rcfyd6PmdlAc90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39860400002)(376002)(396003)(346002)(54906003)(6636002)(66476007)(110136005)(66556008)(66946007)(8676002)(4326008)(31696002)(5660300002)(86362001)(316002)(8936002)(83380400001)(478600001)(38100700002)(36756003)(31686004)(6486002)(6506007)(53546011)(41300700001)(186003)(26005)(2906002)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1FoUU1KRFdzQWtqQUxPSy9iZll1aXRuVmsvSUI3S1BBazM2ck1VNXk0MFN6?=
 =?utf-8?B?bEFIcVFCWnlQcFdFZ0licjRPNGRMQnc0MGNEYUlkcVdSSmpzdDllSTVsZEhD?=
 =?utf-8?B?eFdrOUd5MHl6Zmc5S3lIODdIOHhVUTI0NzJzTitVc21ja3Zodm9tSXM0TzIx?=
 =?utf-8?B?eFZGdVhqSGxaZG8zWk1CS0JUVk5qMkVyeS9SNFN0MS93SEU0YkltS3FMMFJp?=
 =?utf-8?B?VEtCdEFDM09NY2FNbmpwSU1qcTAxT0o2TGVYT05EcjlxdlowaTVzNFVudmha?=
 =?utf-8?B?TTN2UTg0UkJUNnVSQ1kzUXovcWVWTDE2SkxyL3FxdXVEQVdQSVV2VmhhSkpK?=
 =?utf-8?B?dTNJZE5VMnRZb0plMWNnVWpHanl0LzNsdWdmQTNGMUFHbVRicXRzc0xlMzJ6?=
 =?utf-8?B?bVcvVk8vMzJCQTFhT1QyN0IwTE9iN2VIUkgwN0F4UkUrZUx2R3VNR3czVDl1?=
 =?utf-8?B?WDBJSHFIZWZuU2UxRGc2RkdGMDhXSndTRm91MCt4Z1B6V0UrSmRqZkxxZzV6?=
 =?utf-8?B?VmpXY3Z5dW9KcXZDOHlVQ0RaREhiK0RGalFGRE9scGFRSXhsUkZpTVhITDla?=
 =?utf-8?B?WlIwVVVlVUZPS25GRWp5cVRMVFRHcFpaSHdPanFRU2xaSy9rQnZLV09vSWdH?=
 =?utf-8?B?c3JZYXpKM2Y1OUlMVStEWTI0cC8rRUdIUFdKa05NZ294ZGpJYmhzd2xWRXhN?=
 =?utf-8?B?YTFWbEdGbW1NdTNGSnRJeUg5N3FqYWJCUUtVUGZ5UTU3eVpJWFlGWHozajVM?=
 =?utf-8?B?OGtCT0lDdE9Ha0JCamVwZ3Vaalg5aXRaUStGZnhPaHRXdlN0TkUwR3JQZlpu?=
 =?utf-8?B?M2tQQzhBWW00dkdUZzJBT1RtVlljTEVDdExyN3FKNWhpdUtSM1M0QlJKeC82?=
 =?utf-8?B?VGFNNjI2T1RYNjdVNk9BWFBFUFVwcUNmbVIxdUg1MXZjK04rWWNrdHQyMjA5?=
 =?utf-8?B?MEN4YzM3c2VvSkw1d3hZWEtJeEluQWRHTVJtVGhyWkNVeVRLRDdmUDQ1WDVi?=
 =?utf-8?B?M2x6VzZ4NmZ2OWEzZTBqYVJsTGhXQ3JpZXhBOGtiVXpNeHFXZFV6WTBnWmhD?=
 =?utf-8?B?YjhCdVV2VUF3YXc5M055ajk0c2hiUm45OEhWazZIWTRtRFhQR1VhUXFZcWdK?=
 =?utf-8?B?bzU3Wmh6N3RRaGJudTdGdDN2RzhiREVBRTEwRjM0aitGMGVSNHZzcUtDVVkv?=
 =?utf-8?B?UnBMREJ4QXhwMmgvNDg5SVQwQVRtL0NBcjc0T3JvRDNSaUhTZkZsQ3B1TDdE?=
 =?utf-8?B?dG1TMVNkbURGUENqVE4rMW11ZnJFTlR1U2crUkJGWTA0c0FmTzVzV251Slhk?=
 =?utf-8?B?eVZERGIzMEFhZmNNYmJwMkllWElGUFErYXA2Qm02L2tCeHpTNE0xOVpyZzBJ?=
 =?utf-8?B?OHgrYUhnT2ltSnE3S0xuYTFsVXNqNk9rdVFEQ0RvV3ZaQ0ZjanBRK0x2L3ZC?=
 =?utf-8?B?MHZwSTV3NWd3QnIyb3pGVFEwZ0srWk1QY2JaUjUvMGlEVVAza3J6ekZJUlN3?=
 =?utf-8?B?dGJsUG0vbnlISTlsdHpRQnlPWnJaVDRYdEFoN0dDOXZ6UjdOMU9NRmN3NWZp?=
 =?utf-8?B?UkRHQ3pYdEpsSUcrWTZPckhvYkpkUklkcEZxaHU2K1Q4cVJuZ0RxQnN3NURG?=
 =?utf-8?B?ZWRYbUp5QkVNdXcxaXpPNjJMWUFBcit4R0pUaHVtam1FSldkbmVqWHI4MTdU?=
 =?utf-8?B?dTVCNVRpTmtYc1phMUR4V04wNDAzbkRkOThiK3JaUHpNb1BzSXhYWmJXbmFF?=
 =?utf-8?B?dnEreXpTbFkrZ0RnWEZ1VGFNWUFiNjc2WnZ5WkhNZEZ4K0lUcmN3QjhwOCtz?=
 =?utf-8?B?YVgwa0RCQTFXQUlUZXcvdXhZT0E3L3FQcEczb2tid2h3cjdmbEJldzFDZTgv?=
 =?utf-8?B?ZjVRM1JYUXlSaEVqekh5VTBpOHRGNWh5d2pVWW5ybGl5Tk9OVHZncjFsRjIz?=
 =?utf-8?B?cTBCSitzMk9JSlVnSTkyZjdKQkUxVVVvdlNnUnEvSmUzb0QyYTJFUmRoWTJr?=
 =?utf-8?B?ckI1Um04WU9BNlJXTVhScmNUazZ0M0JrTVRiMlAzQUhIMS93ZFd6djFRQU5E?=
 =?utf-8?B?aWtDYjRZbXZESVdQbWovdy84RjQ0b2tmQk81bEdBVmdDU0gvaWpiLzBUTGda?=
 =?utf-8?B?ZXRVM2ZaNmtMN2h0TEt1WXc0QW9vZ3l2RVViTzlscGlHeE4zKytNSUN3VURC?=
 =?utf-8?B?ZVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87a90bf-017d-4010-329f-08da65b24667
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 16:02:38.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Go8IU298aDwWJyXYA4uAd4RARFztsCp9bZLWkG0frZ5spW1FJUtbP2dZSpXFgC/o4NeWTGsornII8nDHYXLIn59RgZK+msiCbHSJ7UMphJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3257
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_13:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140069
X-Proofpoint-GUID: 9AYgHx1t8TPSIyXeUsOTy2CLI0X9duVQ
X-Proofpoint-ORIG-GUID: 9AYgHx1t8TPSIyXeUsOTy2CLI0X9duVQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 5:19 PM, Bart Van Assche wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> Fix the race conditions between SCSI LLD kernel module unloading and SCSI
> device and target removal by making sure that SCSI hosts are destroyed after
> all associated target and device objects have been freed.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> [ bvanassche: Reworked Ming's patch and split it ]
> ---
>  drivers/scsi/hosts.c     | 8 ++++++++
>  drivers/scsi/scsi_scan.c | 7 +++++++
>  include/scsi/scsi_host.h | 3 +++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ef6c0e37acce..8fa98c8d0ee0 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -190,6 +190,13 @@ void scsi_remove_host(struct Scsi_Host *shost)
>  	transport_unregister_device(&shost->shost_gendev);
>  	device_unregister(&shost->shost_dev);
>  	device_del(&shost->shost_gendev);
> +
> +	/*
> +	 * After scsi_remove_host() has returned the scsi LLD module can be
> +	 * unloaded and/or the host resources can be released. Hence wait until
> +	 * the dependent SCSI targets and devices are gone before returning.
> +	 */
> +	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
>  }

If we only wait here we can still hit the race I described right?

Is the issue where we might be misunderstanding each other that the target
removal is slightly different from the host removal? For host removal we call
scsi_forget_host with the scan_mutex already held. So when scsi_forget_host
loops over the devices we know that there is no thread doing:

sdev_store_delete -> scsi_remove_device -> __scsi_remove_device -> blk_cleanup_queue

Since the sdev_store_delete call to scsi_remove_device call also grabs the scan_mutex,
we can't call scsi_forget_host until sdev_store_delete -> scsi_remove_device has returned.

For target removal,__scsi_remove_target doesn't take the scan_mutex when checking the
device state. So, we have this race:

1. syfs deletion runs  sdev_store_delete -> scsi_remove_device and
that takes the scan_mutex.

It then sets the state to SDEV_DEL.

2. fc/iscsi thread does __scsi_remove_target and it sees the device is in
the SDEV_DEL state. It skips the device and then we return from
__scsi_remove_target without having waited on that device's removal like is done
in other cases.

If the only issue we are concerned with is blk_cleanup_queue completing when we
remove the host or target, then for the target race above I think we can just use
the scan_mutex in __scsi_remove_target (that function then would use __scsi_remove_device).

If the issue is that there would be other threads holding a ref to the scsi_device
and they can call into the driver. and we want to make sure those refs are dropped
when scsi_remove_target returns then we need to do what I described in the other thread.
