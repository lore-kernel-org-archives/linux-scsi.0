Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F8DC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 08:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiKIIao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 03:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiKIIaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 03:30:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA42522B07
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 00:29:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A98Kxb8009603;
        Wed, 9 Nov 2022 08:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0ZM9/Ebqea9l7t5yRmacQ17dQjk7YyTbBLQF/oKwEYk=;
 b=WiwB1AZ7sMfHK96XCjGH/O6yfH4rWhwKt2uD2m2B5UTxDx08a7Sa7s6MnU1SFp7OJLXN
 UMuS0eEmGf4oDB2h2m72idJOvP03xgCF1fIoV0k/jgHEAvpjYbpLN/1bM7S1E8nqEpen
 uafKHprimqbZ7ewJT0E9rQR4ZYi3r6M+vY3CDnbFtOTIzwy0Td3Xfm2Z8F3bSe1YoTQF
 Szh2TaRZenEr0GM8qlGcOh/7TKFP52YBPVo4N86t1pT60591pxscLSAak0qvjtvnM7Yc
 cuA4CRY35w5XY1kFBiv2iB2Zgs5NlRWcmt7DR1ZJ9gE+Z5JSKASS1+9BtYE+sVYtXY9N eQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kr8ma01g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 08:29:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A97UAgZ018955;
        Wed, 9 Nov 2022 08:29:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctmjwej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 08:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/R1D1xzTObXfcC2laU1Tf+AtDkhArvjDR+C04Ui3gcB3CnY+3ndoPpuHibfWKZwwsEgFA/uJFncdrScxUI71tt91DC02AvtW/sF9m0linzH751Jx8N6e4UTORJCh11vSM3jV8Vmcb5uFwvoPkP7E+bzeSKYYPz4wUcDfGHskV586VNSzBFDZ3XNhRL9D96YL8Nrt1RtydWFzfqoH/s0tp8PNKXt3ECZF9UTyEFNKB/oFKxXqlwnCuwUH5gLl5E21Rqcto/kTluGAt+EuCMglVmxVLsooNtr0AKJ17lWmUYQ1wC2rsLCFGjDelHt6NmzCZKqB4GftYUk6uUXG/zwyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZM9/Ebqea9l7t5yRmacQ17dQjk7YyTbBLQF/oKwEYk=;
 b=m3siYezrg8+OtlEscV7ABpjuSsRTr8SE6dm42M8vaJPXagA1jTOIPa7WYLZJx2OdbbtTelz/M/VJu4HvUyKKaZtqC+H9l5TWOrqCdwR/paZ6WCbjPocuZ348QenamOmdqa9cwM++1apY8Bir9xD82MrD2v3qgK7fd3yIDy3LLg8+fw2FfRs32EUPVWGo+rLplGB3HfTo9nhpbsbtoCGksgaJMHZXmI9/TihN5AYVLubyP5PztZa0kB4boDLDulR9Hcj40y6aAXx9vxI7iD6Zyd6xfYDu38LaqxqQ/o/R+tsHe1ZmVgx4ZnGwd9HyVqBkmqe1Lcu2kJUyDoBkg/aa/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZM9/Ebqea9l7t5yRmacQ17dQjk7YyTbBLQF/oKwEYk=;
 b=Hv3lbXELtgQhb8idOHNe5lFTiR3N66xy8lQdpGo3c6U67X0kmZljAwNprJElW7pD/YuApRcSzEBlQ7uPi6N3QmJJRurNDMk1iCLQuWHKpqc/Fxmy9hegwUygLt8l65xWA0AB1aH1UA4CKIAWN/nvt3iebn+QxEHBbHFlGvH56Vk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5145.namprd10.prod.outlook.com (2603:10b6:610:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 08:28:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 08:28:58 +0000
Message-ID: <bc23a83b-af57-0920-4155-cf6aa4057a60@oracle.com>
Date:   Wed, 9 Nov 2022 08:28:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [External] : [PATCH] scsi_error: do not queue pointless abort
 workqueue functions
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221109074754.24075-1-hare@suse.de>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221109074754.24075-1-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0309.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5145:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab70855-d68a-467c-3d41-08dac22c729f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Scf/thqsDPQkDYbKGV6TZJ26SHchSIv+C5uAuvKWHbPLQpbp4DXqHQXoVt93ixfIRkLGVfluetK7yeUIb8AYH1Z5Eu/OSUEbWU9QCl5qRoPXZ5hBnE2XjFuAjbXADe72/kXd0MPkrfMQor290S/ieZVDefJFlB6QVPjBfvXWcNm4E2XOQUc+cm6NH2hXwUwHT8uPuwpeLQaRwCmVny6CanTmZ/HOWosfo2jv4kxJXIO7iKfZHd2po1mVDQBQelfV4exebhm4L4anlYTNHxSCKYu6HG5c6Pc2OZvP/90WXs2IdTasK9e8APuWaQWjAsBG5cEIhmCB+3m0hvvj/xsWI6EN49EcQhno7nWJzlneWrPH43RfINUXQVVHUv0vi8jetsqDnCJ81rWXOAYbeUj8RaXI3zYoGutKfW+fHChoKuYd7fcpFMih0hEDvbbAH001iw+PfSNf57JBv7VyWdqnk3x1ZoSdLZ4hdozp6Ztda3LMJIZJfIKuSCr9kUK7lL0kfzBTinqUZxv6V2y9XgDwLtljKTim2HqWQAY0+UMHxiqSwb9Qiz0tO2ezarfxwgqfPMtx4LBpsVC2SQ1SSzpkNmYbJCYVWB3LXUE+cgsAKswEg7jhgfgwr6Wxn0TRgf1hxHwkchqDC1pbkRsXwKrbbm+Cc+A0jXCOb9PRZ6JDeA+cDmBLUITiFqW1PKpaOyesHLMAjNGXYOORJBseVIwSNJRFs70v5TEPngIXneJMez+S/d+3kBHD1irDdSCpxcg7osLbIVQ/JpvjetRnmtTq61s+F5QEKNCykSFDrrmYv4Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199015)(2616005)(6506007)(53546011)(6512007)(36756003)(186003)(26005)(86362001)(31696002)(36916002)(83380400001)(66946007)(2906002)(38100700002)(66476007)(8676002)(4326008)(31686004)(66556008)(5660300002)(8936002)(6486002)(41300700001)(478600001)(6666004)(6636002)(316002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFJVSHVqMGZYb0FCMVhiY1FnU3dBa1FEMnJURFJtWVhsYkNEckErVWJlOUpG?=
 =?utf-8?B?TU9lUjVTRC9ub1l6UEJNNXJOOFovZW1KdWJWZ3hrVjM4T1dVV3RrdHp0UWhE?=
 =?utf-8?B?TktYQXpXN3BpdVY4T0xHVU5MK2U5a0hQTk1vTkdkblRlZzAxZWFCZ0FSTmlR?=
 =?utf-8?B?ckQ1c0M5R2hZWWdtM2VteDQwTlYzZldZcTBCWTluV1B0VGhETUZ5VzJYZzk1?=
 =?utf-8?B?cmZFVkU5aDN4cFlNdEJNZi81cURES0JXSVo3OVdxaGZOT0Y3ZitWbzZ4VTZ6?=
 =?utf-8?B?TzRrMW56aldBZmpXQ2JNRGxYeCtFcDFSVGZPOStLRm1McnBLOHRJOVNKZFp1?=
 =?utf-8?B?b2pROWxaY2dsUlpBTFVmZ3JyTHFGWkZRVTF4Y0Z5WmlscTlrTGZVd2gxNFhB?=
 =?utf-8?B?WDE0a3Z0dUxJYlV2aVpueFZuNlVHelM0dmZISFZmcTdVd0JkbHNJNHlXbndK?=
 =?utf-8?B?UG9IN3JwS0JYTDQrdk1ZRHh3NERtWHhhb1VlZjl6R1BDWXNOWXpGdGdneW5h?=
 =?utf-8?B?UmpQRXFqV01ReXNXaEtkMnFpcVI0U3kxTGk0VlIvQXhSWHByazJUU215dDM0?=
 =?utf-8?B?TmpUUFpBRXpIcjNiSkhBMXpKUlhJSlFFOGVDbFYxUk5DMnJKN0gvYkI3cU80?=
 =?utf-8?B?UGVVaDRTelNSMEVrWnBIdmJ1eTVDUU1jenZYT1o0YmVqeENhbjlNQThwcHFB?=
 =?utf-8?B?RzZ5NzdDVGloaU9hY3FVQTdrWWxPZU41bWRqd1JzR25qM3Z2QlVHOWhScHRm?=
 =?utf-8?B?ZVFZdmNmeWs1OTJwMm1BSC9zell1RUxFeHBNblVob0pMbDlsN0QvODFjMjdk?=
 =?utf-8?B?WFN0ZGpGVnZXVGVPeWpBMVh3ZkxZcElWb1lkTXcvYTZ2ZEZLM2tpVkphR08r?=
 =?utf-8?B?U0pmQXI4WllSaEgwTkZPRHN5WDhzWTd2R3BHcU51clJzNE1VNk9zMmtqaFVk?=
 =?utf-8?B?bEJlRjZvZGNWVk95ckNLS25BSGh2VzFiT0E5Y3R6SGk2NjEwOXhlNy8zR1p3?=
 =?utf-8?B?Tk9SSml6cy9aeXd5ODc2T21aRnNKTVMxSHhrSG9wQ0ZobEpBdXFnNDVwOGpL?=
 =?utf-8?B?aTNpTGl3MER4bUxJUU90cFJ2YU1HMG1IRmJZeFN4SlBoV0cwQ0hIQ0pJcC9H?=
 =?utf-8?B?TFIwNzlBc1dHTkQzbjlJbDFYSXBTY29JOFpaNmtJNUdHbDBtQkNCUHgzWFNP?=
 =?utf-8?B?aENndlh0VjlPRG5WL2JhbHBCbEoxb2d0S1lzbUY2R0U0YnJRamc1dUZmeTBF?=
 =?utf-8?B?VVBpSG11KzJ4U3FZV1RRM2VVSzZCV09zL1d0OEIvQ01paTk2YTVzcHByK3ZO?=
 =?utf-8?B?R1VES29yU3R6MHFZaVprN1QydGd3TTlCZUJCT1RHbXNNNWhMQnduTXV0cjln?=
 =?utf-8?B?S0NyanI1ODRKK0VWcnBWL1NGenY1bXZpYlVaZjJDRUJRSENKZm9zcFRmR0ZV?=
 =?utf-8?B?NjZjbFJnL0xWZHJuM2pnb0RhSzVzT1hXZ2pJaUpxN2NZTVdneXJKRlBwSEJ5?=
 =?utf-8?B?cnhYVDJvM21FQ1VPZzRsRkxyV0Z0aEQ5SlBHTTJCNGt4R0crNFJoTlUrSFlZ?=
 =?utf-8?B?ckRZdk8vTTl0NVh4Q2hGZVgzL0FEWWdjRmlTajBMOTZkWG4rTmtIWGYzei92?=
 =?utf-8?B?L0svTHhkamxIb1c0WUt6K2VoaUlyZDRDTTdOQ0Vjc1JIRk04eC9SQndacFdy?=
 =?utf-8?B?eXBhcVR3eEU0MHpWeTVXWDVvVURJMndjWCt5WHN2WVVVTEVzRWJiWVJoVVNR?=
 =?utf-8?B?eHdQR25XZURNYTVDWnQvaDlvSGVEbGVhQ2dhYm5xRURDTHljOVpuZkVKL2VB?=
 =?utf-8?B?VUE5K081UWEwallQOFBMR3Vxdkw2RmdXMW1oK1Fpd20vZU53TWMxRW5zQTF2?=
 =?utf-8?B?aGwvWFJYMUdqZi9nT0V6N0tLRStwTkFyRkRTa1E2ZlJoTXR4d3lvK2JwSlkw?=
 =?utf-8?B?WnZ3eVlDTmhRL0hEeFR1MXpXSmsvUDNOMmthSnVPVlJXeTQ3K0NQQTlGd3pq?=
 =?utf-8?B?ajF4OFlsdmxQV1h4QkdKTW15UjdEeThBRE42KzFVQWZ6bUk2ZjZXU0xFNUxs?=
 =?utf-8?B?OFZpenBrTFRGQjdYMDkyMTdUbWxtWmtERC9HVEtYaCtTMGxCeTdWR3dIaWVQ?=
 =?utf-8?B?NVBzVnJ1bzFNOGdrQ0Zhd1RjeU1mNXVpMnVzYUhNTU5rcmhDUDdqcWthY3dT?=
 =?utf-8?B?dHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab70855-d68a-467c-3d41-08dac22c729f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 08:28:58.5295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbnosn8QVaZy2YprFq4uCVSUtY8AI6uOAGDtEuJWKuODskINISwgWwoltKa0o+E6JEn833mRlQFYJzOBbSUUcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_03,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090065
X-Proofpoint-GUID: 5W-B4zKu61JkVSeAj-DHicBVFPDvTHH8
X-Proofpoint-ORIG-GUID: 5W-B4zKu61JkVSeAj-DHicBVFPDvTHH8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/11/2022 07:47, Hannes Reinecke wrote:
> If a host template doesn't implement the .eh_abort_handler()
> there is no point in queueing the abort workqueue function;
> all it does is invoking SCSI EH anyway.
> So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
> is not implemented and save us from having to wait for the
> abort workqueue function to complete.

Do we ever use shost->tmf_work_q in this case? Doesn't seem much point 
in allocating it, apart from keeping the code simpler

> 
> Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: John Garry <john.garry@oracle.com>

That's someone else :)

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index be2a70c5ac6d..e9f9c8f52c59 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   		return FAILED;
>   	}
>   
> +	if (!shost->hostt->eh_abort_handler) {

nit: no need for {}, but maybe better put comment above the check if 
removing it. However maybe it's also a bit obvious comment.

> +		/* No abort handler, fail command directly */
> +		return FAILED;
> +	}
> +
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	if (shost->eh_deadline != -1 && !shost->last_reset)
>   		shost->last_reset = jiffies;

