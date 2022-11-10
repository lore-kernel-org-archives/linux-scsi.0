Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC239C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 11:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKJL42 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 06:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiKJL40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 06:56:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7830E5D6B5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 03:56:23 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AABlYOq029315;
        Thu, 10 Nov 2022 11:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JBrvWa8f1irJ83u0BXPF65VxSevMrsVSuA7LJqQmX5E=;
 b=g2SjMK0RtGpxFSlce6YpPCeSH3zAVdDFNNZqaPgopQ3GE5rAgg0nHuV+V9azrZft0Gsl
 FdIJJwzgyzz0zB5AmzCJwjWgCir4TnwvRJ0R2/jHlRlBnapFeRoZdhr1KJVQoemOp261
 5MIlzajZYWys234JEJVdWakSKCdoPoxf2LuEyHgBi5WEGj+xQYLV2epMmNhIX+LQUR9M
 qHJv2WbCELw20ZsqEyGxzPilsFEDLjQ+NTjfC7/P1mertZk2g+axe9908Iym6b/ysyRh
 jZX1AfhnpbE6eulkiFSTJvfyXWL/75cnTTcbndl7AFgLz0IuYBBmAvdPsmjCr5k+ZmC7 ow== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks0qyg0qd-25
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 11:56:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAAINHG035671;
        Thu, 10 Nov 2022 11:15:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsgbmbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 11:15:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zsb36tzLcGjgS01Aft24bmENsWf6ZRnbHZxF75Qg4oNiqCLnl0blWvPszitlWFMCgEGN1bgk6nLQaO9vlcEdhUwD5PmSZBw4NHRS2d6HF6nD8GADKT4kEUws/SYdXOh5Pt4Rtz43E1u/wjQY5LyvYKVJi5o28x1j/QqKAerC86qYv65viWQkonrW9SlXVVSW0sRLziIWweFMggW5uD8+4X/Gs4z9nE5HiYnY6Ch567vFzJU3RX9jmFVkHSoKIVXmuiK8szjZ9s5tWO364Tc87+RKKkMHYBu1tQ8oPhJE0h4tUBhRHh1NIcM8t+D29OVEYnrj3B2HpgHK89neKomXsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBrvWa8f1irJ83u0BXPF65VxSevMrsVSuA7LJqQmX5E=;
 b=finXZpWEZiOw8O5N4BKKErgw459eXv8W/s7x8Z7j5pOq1PbxFXTOf+946SxvFwpqcVIgDypncxgqNTv5kRPQE3OZo+mOJqo9J0pxFmC0JB+Rz69Mk4kZ3VI2zHoDEuIjjtcdgR6w/7qBUkolKj6+kfMORFZXsEyV6y60f74qsfm9NrAZRJLi2341noxYam74Eu609ZHjFLtbcbPARYXqcWQxMgFcW2qr+iLK2SNne1y4TB0gF+yWTkGrbdtlvj2kBEz/64x8aaCNvBxGw1qYlXd3ZmJCd3YDbN9lBSrc/Gxr3xZYNZM7AD7NNKY8v1XuSSO8ZZ+iejgsTF3W27yDNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBrvWa8f1irJ83u0BXPF65VxSevMrsVSuA7LJqQmX5E=;
 b=xOZq29ZufmtCy++IeeXWRaVg22sJMnreKkbcDjXZhs/mH8wgwboWF1XTMDIrudl5tPLPj2nAu32dKfABWq9zcT/P59OqccDfx+icGekZeIeF5t4h2QcHIUEFv503lljZzKCWLVB9XHV79Mq83FOs4G5TlU6R/vsTn1J6dkQNN6c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4155.namprd10.prod.outlook.com (2603:10b6:5:214::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 11:15:29 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%5]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 11:15:29 +0000
Message-ID: <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
Date:   Thu, 10 Nov 2022 11:15:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221104231927.9613-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0560.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4155:EE_
X-MS-Office365-Filtering-Correlation-Id: 1312a17e-eebf-40a7-ef3e-08dac30cdf73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJPjkJVfA7D8cRAAJP7ohdbfQud6kXpLiF6HyZecm41UJKwedXnM+b4h+DfNsT2QAC01h913WhAs19FWmEzvSNBCUTSK6+lC298L2VvK5RLQqVvnCxIs0NFm293WY+VQrRS5Maxp/irLJk3cXt5wr+29hPcdmqj0FbrvQNu2zpsIFK+TR/Ae/LEqLHLp21p/lxQ2iQ62ewXsMRRhYvfg02Hz48tMr4bTsUamQjhEecb3A1Fl8f3olTDDd1eSUu5LpNMXZu5+aXZ3BGLEXmBKIFCVLW0uVM4wPJfe8CCXhYe7SL2e+NMO5ltsXP/IMAxIXjWGyCUiVtfjFi/X4Ih5nTKOOwp5Koma1ti2Dcz3tffSxQiVzRht23XtsYpK7v+kTrp9jx0AmwIkVvGU8tY6tpLujY7N9nCe3z6Zjssb+1JssMMgIrJPB7HcS7BXCwa6M1Asr7RlQUEFPSNMOgGgh+haENODXAwB6lbUG6VQKXIVz/LxuYIVeD7aceao1D1S7wC6Yzv5aJUtuZN3AH+F9sXHuasAdxhnxY+vVnSyyIKzK/fnzg69uFL+9NAYXsPhXbE29juRJElHFxmbDMC1oFZGbM3qZBhH5n7kRSZpu30SfkO19sI5rZX477iIWdmJ8PtPiaMplv1AwKF0P5jpiHpVr8cZyN1tTX/+s5pMLdI8B6b1/Yy5fxrGENQrkUFTCJ/1KmlD8jfAfyzB1zgly2xXAkM/IGFsGYTMgiwEXLfUJJirY3gnWst3Lo2vUK/rJ8IG6IV9dza4zB0r1KIkOhsBYdFs7Pg4RB/1UkDG7pI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(31686004)(83380400001)(478600001)(38100700002)(36756003)(86362001)(31696002)(6512007)(6506007)(26005)(8936002)(36916002)(4744005)(2906002)(316002)(6666004)(53546011)(41300700001)(6486002)(5660300002)(66556008)(2616005)(186003)(66946007)(66476007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3hvdVVPV0FydUluNkpNaFNZYXBJcVVnVFdSbGRqd0ZqMTRFM3F3RkV6Y3hN?=
 =?utf-8?B?TGdxT2pLakY5V1RITE9PTlpSUEU2M0RKejEya2FRZGFkd251UGJUWmpEV2gz?=
 =?utf-8?B?YWVZek5pM290Z3JxMmJnN1ZTNTRobzRaM0dhWCtWdUV0Y2VSOGYycFRaejlF?=
 =?utf-8?B?MkR0OXJLNWkwYVFnN1JRMy96ZnNlaDBwZFVRTnB2YnlaMTJBbVlyZkQwdktR?=
 =?utf-8?B?aVN1VzVCS09EelFxbmNsNnA3MEx2Q0w5NHdYelZFSHNHNXpsKzh3ZUdRK2d6?=
 =?utf-8?B?bFR1azJSN050M09aNDhuY1UrUjNrN2d4aS9PWEY4V0ZpSEF6YUVaaldGZmpr?=
 =?utf-8?B?UzRUeWI0Mmt5SVE0NE54YVJJdmZ3L2lRM1hIWERxcEh1NWhyTmdmd1NTeVVZ?=
 =?utf-8?B?QXJVNlZKMitjc2tZYUFTYmFkY2FaeHdtbTRZN2kzS0JBdFJTY05QLzdRMlov?=
 =?utf-8?B?dzJsalhOajlhbjFnbHBoRnlTRVl3QUY0cm5qU0NEQnZ3N0FtbjN2UmVmbFBw?=
 =?utf-8?B?STdwMWZodlQwU0p3RXROQjZOS0JEZ2RxYkxGM21lTi9EcC9YbkpJcnpHSlFW?=
 =?utf-8?B?U09namtjalpKcm9ZRmxWMGtsVjBTTXpQQmhKZXVyZjdHZlZIU2RyTllkckJL?=
 =?utf-8?B?RGh2TkhSNkpHS2dSR252cUo0MG8rRElvMVkra25XMlg0cXU5TDhXZ0s3VWhE?=
 =?utf-8?B?Y0VkOTNvTzEwdkE5aTFTRGNGTmpmRFZDTlU4MVU4bXhqNnlHOWdzWmZIeVBV?=
 =?utf-8?B?R1ZwWXVrTTNtdWZQZWphYTUxOXVvbmhuNTY2am8xM0dZa0V2V1VmcGJOaEpw?=
 =?utf-8?B?cHpMb0E5RUp3NEpCYzRsaEY3WU1jSkl1WXI0aWxkRThwT05ocHh5bXpPQ3Zx?=
 =?utf-8?B?NXdlWnNvS1NvaVJBUjlZWjlXTlliRDhzYnBoc1RRb01ReHlEVXNiaG9WMm52?=
 =?utf-8?B?cmlTR21HOVRRYm5LUjBQelFzRHdvMnBjaGlCeUpOR1FidGl3MUxEZ2dkNEti?=
 =?utf-8?B?ZWttaUZjck54WUJFL0ZGaFFWUTlyZ1YzaHlWTmJQTGhGdW0vbThuNDlLWVZi?=
 =?utf-8?B?WTZsZHgrVFo1bWdOb1RQSWJvTUMrM2JwS01GcEg4SEdCMGtGL1dhSEQwYng4?=
 =?utf-8?B?by9lbnUyVm5nVDFBVzZmc1RpV2N0YWg4WHdnSHFWa2ppMWRXK3BteUc0NDRr?=
 =?utf-8?B?MkcyT0hCTHArcGlDb3pmMEhOTlpESkFOcUFXNlh0d1MwcDFCbEdsMmZKVXhq?=
 =?utf-8?B?U3grdzZEZCtSL2tURU5zYkFKdlA4N3piMzM5aFpGV0hsTWl1RFp1N0RaczJE?=
 =?utf-8?B?SC9IZFZyaWhLRWVGQVVndXYwSEhzcmdtWi9RYjMyVERjWlQ1S2V4MWE2M3Jy?=
 =?utf-8?B?VEt2ZU1RKzc0WEx4RFVXUGlZQnBGenNLSThKS0Vjd1lJRnRMb0FOT3NpR0FS?=
 =?utf-8?B?RytDRUszVUlLTWxQZ0I5OXJ6b09xUEo1UE1kK1BNVEJFa0VzTzZqVXpCWWJs?=
 =?utf-8?B?eG5sVnlpU0lyUnNoS0VvZkxVdWZWYnhTL0IwaElhU2M4UXdaNVQ0T2VJeU5m?=
 =?utf-8?B?RHNneE1GR0NkRjFTWVpCd1FxYmNORjJqblBvWENkM2lIOHIxblBKd2ZKZERT?=
 =?utf-8?B?cXZJeFMvTFljZ1h3SzZmcHZZaU5xcW4vbE5RN0Y5RlJKcnVtU2trZHZhOW50?=
 =?utf-8?B?ZGpYUmtIVDZScy9uekQ4MFh1TWFVTkpDbnZxVUpsM2p5eHd1ZFk1WkxlWXpP?=
 =?utf-8?B?a25xU0FPUTk4YjZkczZocXVzSFRKbXRQVkkrVzRvaTB6a0JYT01EeUoyc0JF?=
 =?utf-8?B?YlFOSTc4Q056a29Xa2QxTTEwUk13VEhaZnNuUktMekxHT0srbnNSVFBEcXBx?=
 =?utf-8?B?V1IycVMrN3BFdmc0V01hNkpIbUNyVncycDVHYStlWTFENGNZRVZiMjRMaEpN?=
 =?utf-8?B?Ukozc2ViS1A0VFFxTE1NcVpkMlpMS0x0b2paTXNpbzFvMVA0RC9YTGpKYnJh?=
 =?utf-8?B?VWxpd3BkbmNNYkFrbUtIdXhoK3daZWhJYkVUVmR0QVZrQS9EaHlDTkxONGVm?=
 =?utf-8?B?SEFybUQzQ3JMQVIwR0swZzcxZHlZb0lQSDdjWFRON2NSRVByUzVTYTRPU29m?=
 =?utf-8?B?TnNRZlNoUWRnRzJqK3lBV0xZSXZmRTh2bks5b2hQS0RhMkRmblpJampRUHE5?=
 =?utf-8?B?aFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1312a17e-eebf-40a7-ef3e-08dac30cdf73
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 11:15:29.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTfGkbQZT1OwUwmXDXwEfq2RpdNI0wAQOg7hUtJxd9jbUY46Aw8i3DzLoL2oRFVXefvCiFKPSgOmoURfj+uvtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_08,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100083
X-Proofpoint-GUID: thgiJ-FBI3zH0Z68zSQwij0tqeb9EIAv
X-Proofpoint-ORIG-GUID: thgiJ-FBI3zH0Z68zSQwij0tqeb9EIAv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/11/2022 23:18, Mike Christie wrote:
> -		 req_flags_t rq_flags, int *resid)
> +int __scsi_exec_req(const struct scsi_exec_args *args)

nit: I would expect a req to be passed based on the name, like 
blk_execute_rq()

>   {
>   	struct request *req;
>   	struct scsi_cmnd *scmd;
>   	int ret;
>   
> -	req = scsi_alloc_request(sdev->request_queue,
> -			data_direction == DMA_TO_DEVICE ?
> -			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> -			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
> +	req = scsi_alloc_request(args->sdev->request_queue,
> +				 args->data_dir == DMA_TO_DEVICE ?
> +				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,

Did you ever consider just putting the scsi_alloc_request() opf arg in 
struct scsi_exec_args (rather than data_dir), i.e. have the caller 
evaluate? We already do it in other callers to scsi_alloc_request().

Current method means a store (in scsi_exec_args struct), a load, a 
comparison, and a mov value to register whose value depends on 
comparison. That's most relevant on performance being a concern.

Thanks,
John
