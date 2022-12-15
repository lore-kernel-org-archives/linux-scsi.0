Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D807C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 09:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiLOJ7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 04:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLOJ7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 04:59:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDAF2C67E
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 01:59:33 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF2OLFf023859;
        Thu, 15 Dec 2022 09:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=J7jZPu7COADde/n5CFUE1C9+Ga8hfdNT7Z0JK2nxxrU=;
 b=VFNwfTRKClDeI2rr/gRbXw5cPZ12/HA6sEvq4cPHsI3ois6AkRhNUpZIks2kX6ukKjG4
 2NhrP0BubPJtJAX3eDpPH60CQIvrs+ZikMagyvwDpULhxfm/i5McUdtMssBWE/BDlw+t
 B2Oubo4FU94CCv8dEg1T6ivEEIoAF8qc9u7ggSHTVdP9Ps5X7Mba3EYB0aMoWoRY/z0V
 oBRsrSFdoyA8tNNAMEZVZNafTqy8zDO0C3aPSjQEmcf3cU8OV/8r79UmMShihGZ3Zaaz
 1ctnXKMrO0oBbl4ojbx97WRlzC42MKYV81SPBSGkaRAYgilkqmkMewByOLSxj1JEVaUa 8A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewcjwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 09:59:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BF80XWS003995;
        Thu, 15 Dec 2022 09:59:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyexed9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 09:59:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahRRpwPBsVmGudKrDrPeq31LKfPx3yYftDBXBcnhxZJ7QKcdL8by5esoa9tcbt+ZVRuhP5FWFMIREJlK5biX+pYqXx1NL9piy3+FMeFIxPTl4WSjG6mlZjkTW1yg4iLmirEx8+fG2Cht7RxuLBu0PErqJespoBR6voreJkmBiIxAN/MRv327+gdPiVO2nC3d3o9ZGf/gYtWikTd1+EJFRjOPJE798rulA5SzIfF3mmHWqakuaFO+QdcvkHoGgS4N+B8blphR99vuC+yIubiaUnmdpWInyaC17LYnPPpefZNmhiniTkfaio37mwy1Qb4m5rM6wpcRsn6dzyUGjWs/Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7jZPu7COADde/n5CFUE1C9+Ga8hfdNT7Z0JK2nxxrU=;
 b=k5/0Tg7ZwogN5P0SQYx2gDpoUIeFvmvXfEX/K5lzjKL9nWPD60c8bL81k3ETiQFyhLnvl0TZDJafdf68y5G+WYmOG9DPRWxOYk8yx1cd11LrndW3W9PexwD0/zVX2KlhyVYrEAXjYC2qQB1k92jzSdtEMCutp/PTOI6erhtjgpTL2RLEJNzfGx9MUZjd+L1/N34Q5PZ6cK0GwO4BaSRzMVTC0U/SuYbyvLsOpR2LM2apTmlp2rDpYzNAToEk9wm2q+OSSyM2NTL1CQinweT6sc+dMckqtzoHLnhjG8oH+5u9Fuc+YweX6q79YcGV18QFmL1/kizjiYYrGJ3Ljo6GLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7jZPu7COADde/n5CFUE1C9+Ga8hfdNT7Z0JK2nxxrU=;
 b=CqRzYrf2AyrAKLc7jeB/hn1QvqMS53ax48UallVu/d1y6iylEXUc/MVrrpIXeoRmUaItjgy2zyPtsR2zaF2ystjTtK6a0OTTcMW0i/rI6Xzv7pC1fZ5RbSUnSHMDy4/2bGN8cWwrU1+JNkzrlZLY4plqGTpyXal5jx6PGrK/kvY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN2PR10MB4333.namprd10.prod.outlook.com (2603:10b6:208:199::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 09:59:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff%6]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 09:59:20 +0000
Message-ID: <fe9d338a-f6f4-f97a-d71b-607d62d4ff82@oracle.com>
Date:   Thu, 15 Dec 2022 09:59:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/15] scsi: Add struct for args to execution functions
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221214235001.57267-1-michael.christie@oracle.com>
 <20221214235001.57267-2-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221214235001.57267-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN2PR10MB4333:EE_
X-MS-Office365-Filtering-Correlation-Id: 9adbcc54-3ff6-49fb-723b-08dade830922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5FgKdbQ4O3TnM0Xz5ePL+dO0cV/s4fzEgfOxQDB0ImTdRVlYk0DQgb4IBaOWQ9qAI8E2QkrYMMqLAlZzYckFMzEGeqdm5eB70Id5naGON6+iJFY9QWACvrppDQ3j9kCtLTOa3Yk5l4OgdKhesQ+4IwqqB5TQpL5PMVU1mhWobNR+HnewnNX9T3DPFJHk8ppRvj8A8vUv3gy2q7WDZcyHKaeIyky52bOjtNlUVR0Q/23KwWvDauys29NCBW8ooKlI7pVXV+pJ1dc/omjTiDg8nERRDGeojoCRleB4OHtLNxXDhDSoASLfgf5gPuuef/lEgV7AxaXQBSFDWVX5FpiASA1w6a2Y+T2P9rygccfTNgsYi9eMZTVMU6RHD7QBbLAlIBlp7NZsd+/jD2b76sB0UD1BoHGsgGdjXtlEddJ3qBkP3F+WVATto6etIHMSJCkmKu5BE8gDrkrsUv2F3f/lu5QB9jUtJGuT/c5BjiBoVaK0EMU3fVtOexd/Ywr0ei/m/6QUhJ7bfxLZcu5ukZquhehGT7TcPiZUBvHUNwBPpo1Q9091EWN+Ak3Jh0DkO+eaW4jVFuK3bTrL22XQhT8YYXfZqF6haP+o2k0d6Wdfbw9WesCUTPCzc/d5O4LFL0zl2rh0vOI8t1Ot40xFTi5qJJLumFo9i3EAh1xfskI1WVwhC9eAf9RxC3qD5q3N1y5dleTNKXNUO7K2Z4OQhzypeBLApTPoFW74JMEuoZgO8bk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199015)(31686004)(53546011)(478600001)(36916002)(66476007)(2616005)(66556008)(6512007)(186003)(26005)(8676002)(41300700001)(8936002)(83380400001)(5660300002)(66946007)(2906002)(6666004)(31696002)(38100700002)(6506007)(316002)(6486002)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXdKSVU5NUZpQVVrd0c0OWt4QXcxTlVFK2lRMUFVY1FYZ3NyUmpIcUY4NWJE?=
 =?utf-8?B?NllDWm9kUURtSXZDQXNHeW4vcS9Yb2NreFo3NjRxQlJqUHNoWDliOTIrYUNC?=
 =?utf-8?B?MXoxWDBhZG0zUHNBMW1oYlFMbjBQUWNWVWdYNER4QkxrTUlyZkc4VmJNQlNn?=
 =?utf-8?B?U3lqU2dReEVuNWdHQi9FV1FHWllzdnlaYlBNa0VUZFJnaTY3ekRWaDRkekxF?=
 =?utf-8?B?eURHcjBFeGhwVFZSTGxLNDlndHR1TUt1ciswY1U2RWNiSTNrRDI5N2NtSEpj?=
 =?utf-8?B?Y2x0SjJqcVpFaURlVE9CbzRXUHRxVWVWZGRDSFVWSUZscnJES1g1enlISkRh?=
 =?utf-8?B?SzFueWkrYWJsSHVPd3R3dzV1S1Yrd3cwYWRTbmhjUGJMRW5LbkRVSm1OZ3RI?=
 =?utf-8?B?SkE1MzR4L1RkdG9jMlRmSTRZcmUxZDYvSjZsV3JLSzB2blVUNE1JbmJCVkM4?=
 =?utf-8?B?K3VqbkNRelVuY3E2cmdVTjNCeFdaS3RoVllLUmszYm1aOEhicFIzaGRNYjFy?=
 =?utf-8?B?Q1hEUWkwZ1I4L0VaMjE1UHBCNWlCVmJHeDhPaWJCK2xkUEJNME9ab0RrTEF2?=
 =?utf-8?B?QWM1NmFHTTFDS0p3VHhudE1QTzlKaXVTckh4eDhLMHJST3RSKzNyR2VvR3VE?=
 =?utf-8?B?VjduaWRvWElreW1PYzAxRlREaVd1R2xGUG5yaXdwYXFoZ3J4NHA5ZlpXc0pU?=
 =?utf-8?B?b3hzbHRJZXlvZTRQeTFXL0w5YkNLNzdGQ1psRnNWU3FzVkhraDA1NUc5UFpZ?=
 =?utf-8?B?dWJid3lOTHRLOU1JUU5MbzJKc2xFZThlbWx1VXc1bUdvZ1dUZTZTTmpKSktO?=
 =?utf-8?B?VGdsTVRqalU1Q1pSY3JpMHR1bGJ2bGk5TlFjQ3djOEpYTGhTNmpSbERTbVU5?=
 =?utf-8?B?Q2dBL3FZaVhwMmgxQnFxeStPV2pab05pUHZGWG1sOHQvYlNrb09PSzJQd1Rz?=
 =?utf-8?B?NFNXMDExbmxWU2hWci9PeG96bFRLR0s4czBKWmJoK2l0c3htNHBsL2VVMzNN?=
 =?utf-8?B?eEtFeksrRThXV0czcGxUMnZWd2padlZKWVVwckZ5Z0o1OVVkSjhWb2NMdjJ2?=
 =?utf-8?B?NEpYTy8wTHRva1drK2RRelBVeXlqbkMzM09UeWtzME9Nbm42MnVoZkEvdFZq?=
 =?utf-8?B?UXl6eEg1c0ZLbW42UjM1OHIzQkJRcVphRmN5V2ZXU1lpcDlvVWVvSnBRM2hM?=
 =?utf-8?B?TDFZTjl5UERwb3FROWFPVisxRVdtVjBSd3k5UENuN090Q2ZxcGxrcGdrRkg4?=
 =?utf-8?B?T0ZEdThLd2taeldnUEEvVmRtQWlhVHRlZUVTTG0yOFIxSVdnRVdCOTJXNlRv?=
 =?utf-8?B?VWE1Z2llelJVVWtUYy9wUXJRWStZNzZubmFCQ1creEYzbXBNMzYxR0x3UXJh?=
 =?utf-8?B?S3BobHh3cjd3SFhKYzNnb1VsMko5K2JGcXNZcjZ0V3dTbnhoWkFzYkhjQWx4?=
 =?utf-8?B?SnZPMnBWemJVMTdnd0RxV05LdU5HSElXUys2TGJwUGhWd1RnVFVTVTYrVWk0?=
 =?utf-8?B?cCs2ajdLZTJGSzdTTjNKd1hITjBzSXdKL3NuSlZTTVkyWUtYbVVYOGVFa3lY?=
 =?utf-8?B?K2xJTXZhWlArWVNGVklFZUFaZkR2Qjh0M0I5UlBucGR3NWtwblRkV08razNK?=
 =?utf-8?B?L2hVQSt1SnFiTy9KdUxVQ2lrNG8rYWsvSnEzblluQ21uS251ZW5HR1lSNFBt?=
 =?utf-8?B?eW5qZFEvQ1V2dllHZFdhOTRZRlE1M3NrN2xBRkRzeVJjUCtsZkh1MTZWZldp?=
 =?utf-8?B?S0VaOE5KZW5oc2lRZnpXRWE0S1RNaCtKU2pDeHovMzVVSlF6K1ZPWmo0TXNO?=
 =?utf-8?B?eFRheEdYNm9GY28yNDQzSTNlcnhGbFNuU3c1Zk9BdytIRTkzMnVSTG94OWRJ?=
 =?utf-8?B?ckI5VzZJVGU2VjJkYkVaQzZVUWZhc2EyMGR1MmR2cUJtRGtUUk1PY1B1RmNE?=
 =?utf-8?B?bTMzZGN4N2N5alF3UU0vZ2FqUlNwYkQyWUdJdm00V2JsUlZDdUloWEg5bmNQ?=
 =?utf-8?B?QU1EcTBnMzM1bURiSUpmYWpabTdrN2FlSXFKUlJ3eW9WNW8xY2V1QnA4RUxi?=
 =?utf-8?B?dUVkcUZSc0ZjVHdiTVRyY3RteGVoVTFNaEpMTmwyYnRuQkFibmlNQll2Q0lS?=
 =?utf-8?B?NXc3eVdwNDdoeVNFOUhOanM2VVVFVy83K2orcHk0czVFQjlaTlZrSUhGMFp5?=
 =?utf-8?B?bWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9adbcc54-3ff6-49fb-723b-08dade830922
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:59:20.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61ukERC7wJwcZhsfYB62WVydDDTCSZBCvLVZU28au2Slhs6kZOt4IdydxXoJfaRa6L6RAew/Nzdnj32kJYR7Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4333
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_04,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150079
X-Proofpoint-GUID: oUJcYGI5Ko9qiXWZkJtDo2qxHyW7UgQE
X-Proofpoint-ORIG-GUID: oUJcYGI5Ko9qiXWZkJtDo2qxHyW7UgQE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/12/2022 23:49, Mike Christie wrote:
> This begins to move the SCSI execution functions to use a struct for
> passing in optional args. This patch adds the new struct, temporarily
> converts scsi_execute and scsi_execute_req ands a new helper,
> scsi_execute_cmd, which takes the scsi_exec_args struct.
> 
> There should be no change in behavior. We no longer alilow users to pass
> in any request->rq_flags valu, but they were only passing in RQF_QUIET
> which we do support by allowing users to pass in the BLK_MQ_REQ flags used
> by blk_mq_alloc_request.
> 
> The next patches will convert scsi_execute and scsi_execute_req users to
> the new helpers then remove scsi_execute and scsi_execute_req.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_lib.c    | 52 ++++++++++++++++++--------------------
>   include/scsi/scsi_device.h | 51 +++++++++++++++++++++++++++----------
>   2 files changed, 62 insertions(+), 41 deletions(-)

...

>   
> -	req = scsi_alloc_request(sdev->request_queue,
> -			data_direction == DMA_TO_DEVICE ?
> -			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> -			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
> +	if (!args)
> +		args = &default_args;
> +	else if (WARN_ON_ONCE(args->sense &&
> +			      args->sense_len != SCSI_SENSE_BUFFERSIZE))

As mentioned elsewhere, this size check is not fool proof as it does 
rely on the caller to set sense_len to what really is the size of the 
memory pointed to by args->sense. Better than nothing, I suppose.

> +		return -EINVAL;
> +

