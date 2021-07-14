Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C51C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B225461380
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbhGNB0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:26:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24756 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237223AbhGNB0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:26:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1HdKu026658;
        Wed, 14 Jul 2021 01:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HhDOIGrF6r01BnNMu3friLwwAliKi2199b9QlnH9NoI=;
 b=OXjYQrUfbPRHSOnID18VpTv+VBv4F1N+BFE7VgCGPKAOWG9Y7OVQ91UK+9g+o5v/lfT1
 cE0o/0H/P4WiYPMWSNJwHeckki7YecqB0uO4A8Gp1b8dWesEJHIt7y57mXIDsQR93UXh
 240JB/DdXVWiimAy2ooh9+Owwt38Rzumey13IkeIlRMK+RyiN7hJrLbP7LfhwZDW0yJQ
 KgLcLwcjwJJigA8w3rsBm4fXFewRrY8W3X/weDFcXm+qjPHhvOKEya+BkWmvKfDkTEZh
 LflBM6jgSPx6Q6pKJoxqpNS3WH3RIWsdHuyYPjH/QpiIHvsApEUquGzXy+kUyVYECeHO ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdktpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:21:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1Glat051196;
        Wed, 14 Jul 2021 01:21:23 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3030.oracle.com with ESMTP id 39q0p6jn64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:21:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqj2eur5iJqKY4/S8ZMvY9BDpaNNBvewmLkKvol7DRm6aTU2itiIRBVTB0fzlYkBNjLwY4jXEEs4zWBwkao1eHGL+P0jfhdk72r0IUY8N0uROg4Mu5k8U8MLGYk6PSCwqGex74Pz+QrofMdblpxhjeDPOfIqvoUlgzu7bVR9ZY+C//4aE/8NrIQlHUDEkJZfVOPO0dmiC6R6cYZTpa1pkQRBo46ChvjeA91oZY6K3VvDBs+kbneq5RiE2qxbj3ZA9yg7Fj2jXWVbJn6dMFrgm48jYe8xaqjRU60/LSMzxr+F5LgDFMRqP+SyC8bikTlm7xk3MY901zxEGDI4fg5NTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhDOIGrF6r01BnNMu3friLwwAliKi2199b9QlnH9NoI=;
 b=FOQ5C38Q4GZEtr90COF5BUdg6yk/6CDW4ba+KgsS/sDISOouzrxbIVx3r2HohJV1SR/RrJX9wpAXSZWTrWPH6lLE6VyHoiQmSJy254Cn+p+Je5PjIWQkTlhtwYaDK8js7ieMOW+DAk4S/g+miPr0OfbI2QEWinavJ9L9a7vTmjrY9yersPovhJrj4kmtj3t+ytG/lULcKyDOu2DL63M+9TIzI7uK2HHIiIi5DqldJ7mphKieaJxRtM7ZK3tlyizg+CDou3/a1XZbkBGg13Nd9rRhHi7SD5g53BTwMim+81NBij4JWYvd+x9EBYuZWguBGxnMuT1GgYAyQ4CggY238g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhDOIGrF6r01BnNMu3friLwwAliKi2199b9QlnH9NoI=;
 b=VZLkmQhKKJk7NSljS58cz4hW76WNjMCPQmNmIjJ/Hv8ZdPhaovFC+GghkJ2iQ0ASEi0GL8yWiTT1saAwFGja/uWz6OP/L8nS0GvKBSKpq7NqLPHMu1rW4+0S/AX8aaZAObG0msKpJYai3mMHkps/2mpcwbs8gwjrahGOio02eZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR1001MB2349.namprd10.prod.outlook.com (2603:10b6:301:30::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Wed, 14 Jul
 2021 01:21:18 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:21:18 +0000
Subject: Re: [smartpqi updates V2 PATCH 5/9] smartpqi: add SCSI cmd info for
 resets
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-6-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <0b7233d7-4b4f-61e7-ec31-8a5de59f4628@oracle.com>
Date:   Tue, 13 Jul 2021 20:21:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-6-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:3:12b::16) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:3:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 01:21:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5081156c-3053-49c5-296f-08d94665ae82
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2349C22A87C40F88099B46B5C7139@MWHPR1001MB2349.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e3GIOGc1gD51XcYcOxyfXEXVlj5Vno3wIxSpVI8fV46wbw76XVcG8U+WBF2vxx/n/CmiSe0CJnZmfv9tkQUBr77sOHm9Q2g3o0i5JDg15TC/UMRuQyR/aDTXOn9mHB9m+v/NjL3Gz18Y7odi3HF7+Y1ypDfTWkQMzijaxd4xBlXoBJyD8mMUM4K18W+o6i/cNEgluDJruBsvwAFIEdXorrbpiH7XSdnMpcWsitC7xwfGpiCkKpDP8e4ygKXCccsk80gyVoayVNeFnl+kHn7ePDTa7Spcx90R9LDeve9hIuacUfw8E9+nFojD4xvK/yjcR/SPNvDqJy8ZN/zPgQZxi26nCG0vEDI0TxzETOtaWO0skM8FO9JyHtOd9WOGAADkOp3ePT1IlXB4WRoV1lxWLrGwjCq/sCiYxmHVItyfbgkVUdWBLtIoWkF+EHt7r5E7qsr0XmXJXjQnVWlKw8US5y9G1HsN2FoIPgU55pYwhnQVEU4MpKCz8UpHaN6uSUf0DDPcRnUCNrYjI6mSnz/kmuuHQOsw9Ilqm4h+1l9LbX3OhNBQ9WzE1tmXZKtMJHqJDCJMHLEyrhumHEjvRUSPGHcdsHi7jfmcpnAF8ksh9aiHcen6/gzoVadhmbfN8EWuRnrj1fTMRA1hPABqvxS5XT1F+Y6/2IfHDwkLZagBiEWyfTh1XMPYkamTzZvislMB0syqhHLPZpAd/I3lpw6eXE6i+y067BEz85YkT1CGJwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(4326008)(478600001)(86362001)(186003)(31686004)(5660300002)(316002)(16576012)(6486002)(26005)(38100700002)(7416002)(2616005)(66556008)(956004)(2906002)(66476007)(66946007)(53546011)(8676002)(83380400001)(36756003)(8936002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDJKUE1ueDhpU09TM1NZU3p1dkUrTm50V0krdVY4Qkd5ckthdkVOQnQ0N2o1?=
 =?utf-8?B?ejZLLzR5TjBZNzRpZ1RYT2lVOXA3TENKM0szazAzbTNtOUJMVXBIY01ubHFV?=
 =?utf-8?B?OE42WVd3bWM3c1k2WlhIa1d4enJlbDRrN3lKeVVKdy9jMDI0cGV1WmVtb2Qw?=
 =?utf-8?B?NVZTNzFEcjdTL1ZTSEdYOWJsaWloYXVHUHg0UHRWYkNuRHBTWjFXRUlMd083?=
 =?utf-8?B?bzFZa3EwczBZSElqOXhDWTgrNGhER3V5eHBhSW9nQ3NhZVFYM2QvTStDbVZ5?=
 =?utf-8?B?bkNTWkthNW9QNGZoSkREN2tGaE9vVy8vc2ZacFFSOFlhSCtBd1hHYWIwdDRU?=
 =?utf-8?B?dXRKSzVNU240QXV6R0ozWGFIL0oyeUVHcWlCWUVwOStUNExzU3BOdHp2MDA5?=
 =?utf-8?B?eXIwTXV2UmRSTTBFVXpvZm1LSkUzaGFNejJPa0o4VlF2KzRNcWYwSGh2TnBE?=
 =?utf-8?B?VzIxZHYyN3R1dkRYWHJqRFRXdVViZGRGTUcwa1RvZXJhY2xaZHVCU3d6eHpG?=
 =?utf-8?B?bk9wSlRaNEZjNnFxdEhnZDQ2bjdzVHAyTXJ1UDR5dWVrbzVMQ05IWngyaXht?=
 =?utf-8?B?SkNpZ3pSR09wZTVvS29IZGVUVlQ3ZVlRR05QYzVaN2lkZDFOcXYyQ2RqUk9l?=
 =?utf-8?B?d09jWkVKNk8wNmRaUk1YUGdLcThGTG80ZmVvbVQyNzhWcy85THVMYXdXQWNM?=
 =?utf-8?B?ZlhmbWUzT2xucWhrS0VCNTIzdHNGM29LZXN6a3RiOXMxcm9lU2hVOE9RMExB?=
 =?utf-8?B?UkJwZkN1WmZRb1dDOFJLYkZmbTNjL3BTcnRTWk5ZZjBNU1JNVkhKUTJEblZH?=
 =?utf-8?B?aGZCZDdpV0VUSFB4dTFZV2ZlTzZHOFUydC9vZ2ZwK0thb3BUb1htTkU4Q2tU?=
 =?utf-8?B?cmczc0pUZ1J5bWtCZHZtM1VQekkybEcvZFUzM0d2eTF4LzZkRStKU2h5QlZt?=
 =?utf-8?B?TE1CLzdMU2d3cnlhMWdEZndwQjYxMy93WGVRTEdPSWd1Z2tHTWN5Q2tXL0Zi?=
 =?utf-8?B?dFplYStCdUc2ZkRSY3h4TDRVMWpIVlFLUS95anMraTQ3enJ0WVZIaHQ4VzVB?=
 =?utf-8?B?WHdKL0ZpRUhTOUJnVGdkMDBIVlExcnJMRWN5eEJ6bkZxT1U3RzZMS3EyNVJN?=
 =?utf-8?B?aktDZ3NNTDl4SjVpWW9nUEhjbitLSTZKVDh6QUNlQ2hKY1A4T1YvbUZUOE5s?=
 =?utf-8?B?dDBadURLVHJwUGpGQ044dFJTUGRXWCt3elMzYnRIR1g5d2NVaG1oZFFXbm1W?=
 =?utf-8?B?UEE2ZzZ5bi9SL1JPQllmSFlWZHk3WkVMeTlhVDQveEVOaWJpbEpUQ3pSZjRY?=
 =?utf-8?B?OFZlMWJzNTBDT2J4MkxyN0lpRVNTdjVzVHlmclZ1VTZFUUVrUGdTbEl4ZXpT?=
 =?utf-8?B?MWZZNkd3VDJnOWlhdmU1UHl5ZUphOVovYlNJUkVhYUQ0cWlTc3Q1MUZWSHVr?=
 =?utf-8?B?VkJ1NkMxMVp3SStuNmJFNmFDZWxoemxQTU9BeCtMRk5scSt3VVJNM0lwdHcx?=
 =?utf-8?B?NFlKcVY4eGM0RFhBWjlSbWRjTGhkWllqcERSZUhsZFFVLyt6ekFFK2tGU2Qv?=
 =?utf-8?B?QlppcWsvRzYvenJ0SlVNM2lqbEx3dHdWaVl1ZlExOEswVEFpT0lmajlQbWlj?=
 =?utf-8?B?bnJ5bng3QW5DdDVoL21UZGFVM1hmaGxBdFgvU3p2TXZXdm9UR2tLa0llUFZX?=
 =?utf-8?B?dlZzZGphdExBN2RQSnFHYmIzSjFjT1ZPSDE3YkFPQkM4S3FPSC92SDJxc1Zt?=
 =?utf-8?Q?nTg9PGbIDF2EYOJs4K4YeDUfZeOIC1Fkhxuru7H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5081156c-3053-49c5-296f-08d94665ae82
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:21:18.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO3Oo8SaAlWxLMKLkdjOqPvYJOW8O2Eh0HtOTP4PW68tPkGYpHMbzztsEjX8/Xc0id6lkpF7h3/12u2WYcY7SyTR7XSVzqGDEHZYG1aOC4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2349
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140004
X-Proofpoint-GUID: qfeZL3A3tzLlGIBfhSprGp5Vb3bLnQiu
X-Proofpoint-ORIG-GUID: qfeZL3A3tzLlGIBfhSprGp5Vb3bLnQiu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> Report on SCSI command that has triggered the reset.
>   - Also add check for NULL SCSI commands resulting from
>     issuing sg_reset when there is no outstanding commands.
> 
>     Example:
>     sg_reset -d /dev/sgXY
>     smartpqi 0000:39:00.0: resetting scsi 4:0:1:0 due to cmd 0x12
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by:  John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 29382b290243..ffc7ca221e27 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6033,8 +6033,10 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
>   	mutex_lock(&ctrl_info->lun_reset_mutex);
>   
>   	dev_err(&ctrl_info->pci_dev->dev,
> -		"resetting scsi %d:%d:%d:%d\n",
> -		shost->host_no, device->bus, device->target, device->lun);
> +		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
> +		shost->host_no,
> +		device->bus, device->target, device->lun,
> +		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
>   
>   	pqi_check_ctrl_health(ctrl_info);
>   	if (pqi_ctrl_offline(ctrl_info))
> 

