Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4B9C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLIKk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIKkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:40:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D29BDF8D
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:40:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nWRd026777;
        Fri, 9 Dec 2022 10:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XmQVJ1GPS+S8blK4/Jntdeqeq+8Q70RqLgi4krD3Lwk=;
 b=DqwG0NUbTXbVR0GQxjBPMcZ7Q6RXmqLtDy7JjVWdsDsSw+cutsvmyANqMBvYYHw7T72C
 nKpaTRVw7VriMpaHcD25lBzLnxDVpz+KPewb/RDJ3DFc8zXsmQiTeuZrgbzkDhN7qC34
 Y8VRENQAXkXrdbYoxfsTdGxpmhfDHa2T7zD6wfg0y4m+FxMtDUBtGL+cdR64Lx4GhwdB
 dPmMgUvbp9m7eNufqm3K54zL16O89QWdYliRKkzZa1vFeyoLJbOGSqjg3mIpHYmKjTWx
 shtgA6oxtFfd7p/YNy/OGk7LANWJtcClofbCc5LtgHRyfHN6p8akD28lbS6g+I0d5DMY wQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74y8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:40:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B99CJ2m034426;
        Fri, 9 Dec 2022 10:40:43 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4tgt7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:40:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDlTHDwd40TOBxjIKLsW2PVQHwdr9+M+zuY0ECwTsFlVZLLu3kqFoN4YCr8mTp1HLPx7bXQZxA041prhd63ZTi6CMPTO5j9wFK4ChCrzgCGPmhV/NgUtP6+TIpd1+Y6CMclvUnzDfJynIeg6LREdavQX7rFv6jSfRXNLyLoKJzbl0fNMbdij2bQMly7MBGl/vzpP8hkT5fVa1pH7sYiYlAJj96ttRMyk5/sMMyf0C2AF8sQxW1G5/roEdAeGT2D1GQf2qT0dtKup4qf5P+8Hthx7KN5Wlcs58Ofmk6bUEDLpN/Ksdr38QSxyoXO298iQLED/W2qqtpCDQZ90OwHXKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmQVJ1GPS+S8blK4/Jntdeqeq+8Q70RqLgi4krD3Lwk=;
 b=jEqcVIYomhfGKmel7LoCYQlcxpcvmqYYytbRUhblrEy+3I6ZPol54C4RWNKEayw7C1fh1qWkndCbmkOA7K8AAy7zSP8WzwS7oKxYvyX0DiPZrPnDRQwyb2Ffjnp4zQGITU5L2sZiHrW0nEsK7cdq8OOs+t3ZJddvIIkPe4FllmaIAqCw7AMtbP3pNR9T1LV1DoN5cmN8zMNSu0lfvanR2shOs556BnX54sodvrfplOY5epRIp/dHyRSMnONeGi4d++Ga0R1diDMXDZBoShan/rTb1D5VPJbPeht9TLL4k9m66kZqbGeEgeZ/jL4kUucga0yOXiPo0CS48rV89aIzIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmQVJ1GPS+S8blK4/Jntdeqeq+8Q70RqLgi4krD3Lwk=;
 b=LAvxf6U0JjqnV8nx4ZkZrM4yvKF+insxib/HB1UvTyXbzu/U88XTiyo/zqg6z48zg7gZi52aXbTsebvbMGidPXe5/0jCYasND/xIwczLyWaCbuSXgojqfErPzg+rX8HfNtg3qKEq3VjaYu/rzfgAuNWD91vGklE/aflMJB/ykNY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN0PR10MB5934.namprd10.prod.outlook.com (2603:10b6:208:3ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Fri, 9 Dec
 2022 10:40:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:40:40 +0000
Message-ID: <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
Date:   Fri, 9 Dec 2022 10:40:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0130.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN0PR10MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: e557fe88-0573-4c06-4560-08dad9d1d10f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hy1QZ/FGLO9l7oQZxu1bNnmBYp5RHysQe8dBs9yzdH2NszlKHHrxq13Q0P+aEokGR6l+1qLPbr3k8xa4anI5M6ek25O3qLtZPveIepzwCgtMJCoH06sXrleHsJ78dEqDvCF0uzSqpRNd6fWtTtkr68IiSNlwFvJ8A9KX7k3LsCslRYyAG0kXx70Nt1SHUw9+LMhuFCWniBsoIAa3X7CwFUOueQeBq7SzGPzZAV3BtCHPXK0bA2zJCJPCxsPY+A9oQPZq6zroas6f4Oxe6VpEGElrd5kcHXU296UVVjsPLQDFIF6sci5QGrXaxL9Z04a3u3tgBgxUdmJhWo3VwecaeJMYhyOXbypULr7v6Xif2GrQCYmGhBKK1ZxHlVU/Y27fIRk/d5iqsr5vrBeuEXloHcdhtGBV523xj06rSOAVV497t8QOAQ39w1xpUzSPU3uTC+166MXgZZzdi7zNDyXt2I7OC/woIwYQ/kNaw72qx2/7S0lBUyaimtZ/SCoxLSRgoDCZY/vA/FcT3SsAXtVKrXtS+HQbYMe2y1vs7/YAnFAHMI13Vzq3QIjUM9sHm885G0NQLFC/TIASLSF2ifqBmCYAS0jP9maeG7NRfHcjIUS0Q5U64ar76JHph8jbX50NRb6P9/9kY38IQu9iD8Ds9NJ00O+qGpl7up+Iaen/XmVA9eH4gDe0GxemfSzQgPYyVZGCfYEhHsraWoqo6M5v8y1BvUW8KPQ/18ecHVGrcj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(86362001)(5660300002)(2906002)(38100700002)(83380400001)(31696002)(31686004)(6506007)(53546011)(26005)(478600001)(6512007)(6666004)(316002)(6486002)(186003)(36916002)(66556008)(8676002)(41300700001)(8936002)(2616005)(66476007)(66946007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDAwTTFpdm9YU2x0QUxWd2FmNzBpaEZ3eHF6UTFKMS9TOXJiSmhock5ONUxN?=
 =?utf-8?B?elJwS0tRWEhTa2J1VGxoNXFPZVVWaHZHeVB1dzhISndFd0Rja09vdnFyN3B5?=
 =?utf-8?B?a3p3c2tYOXp0bll1SzI2M2lpWEFSZS9vaGpvSGJnMzRoT1FkRnFibVVLTkw2?=
 =?utf-8?B?WEtkaUk0WldFWC9Hazl1VEM5bDlCbFlLcEMwcTFGVDhYWDNRZTEvd0pmUkZT?=
 =?utf-8?B?UkFuQStoM3hyMzJ6WDE5MU5wWU1LVGZKOVplQUtuaHA2cVJjeVE0bWJKVUFu?=
 =?utf-8?B?T3lUcWRITmhPaVZvUWZzOGhjOFVOOFdieVVCVi9iaFUyWjBRUU00RUxmOWRI?=
 =?utf-8?B?K1d6WjdaMFZNZEtUZENteTVFZEN0S3JjZWk5d0ZCZUw0MUpUejBaYmc2WHJP?=
 =?utf-8?B?NFExcnpBaUxTVElqN2hwYVU4YndPTGZ3Q0RUWG9DSnJrd2k0OW01dnp1bThB?=
 =?utf-8?B?eWI3NElQem5VTjkxR2tmTjU3d3dXQUMrYkpHZ056Z093QTkwSlRDeTZpajRJ?=
 =?utf-8?B?Q3c0WHJIWGkwN1dvRWxMd05jYXVwUkM2Zmx5Qk5Qd1RpcVRmSW5DalhvYVRy?=
 =?utf-8?B?NVc5bGlqWjJPZWY3OXNVSmFiQ3lzMTlyWXJla1RQc0pjdXBMbnBaaTJzTzFm?=
 =?utf-8?B?NzRTZ2h6Y2VzcU5lOE1SdzVXQWZwRnpFc0wxbGI3OEg5ZldiWDQyODlmdGpU?=
 =?utf-8?B?MXZHTVl3cCtocm0vQVBNMjNyWUFONTYxbG82YjNvRStWYTFlTUt3bEx3UzVV?=
 =?utf-8?B?djExQkhGTUEzeUdObGdXcVZDVnNpblJXRnViWVUxRGdUT2J1ZnVjQVpRbHF6?=
 =?utf-8?B?bEZqMng1ZHg5VEF2OEdPRGFCbXFCRXY3SEYwdFhQSGhQNnZ1Vm9xMEk2Sm5h?=
 =?utf-8?B?N3BYNU1pUlRiQkp1bGlzOE90bUhXSDlhZEliZFNJMTNhN2JRd1djOVg5Mjlj?=
 =?utf-8?B?cHlSbEZ4V00wMGI5SHh5UVpxcWdPOXgzVjZ1L1lLeXMvaU1DZlhhZXpqZjY5?=
 =?utf-8?B?T25WcEJBeThUTGRHOGs3UEJ0VjRUS1huOEl5N0tqZVVNUUtlOHhkWXRPT2k1?=
 =?utf-8?B?SGRacnM0NTZMdS9MYWlCd0xUb2Mvekx2ZUdkdkVxVzdKQlpVNEdqV1FvZTI2?=
 =?utf-8?B?VDgrNVJVbEMwQnhLTVQybnVvb0drM2g3TFNqN3FKZzVpRy95a3NlTTc3UnVj?=
 =?utf-8?B?bW5CTkp3VERDN0I3dkNjemZKRjc4N0FiSXpyeHdRY3VMN0h6ek9QYlBQODVE?=
 =?utf-8?B?YlVEUG5OYUcyaWxWSWNmaU5HRjd6WlJBSWVKNEFDbnp3QVU2VEU5MUdiS2JO?=
 =?utf-8?B?dEN6Z3U0RG1Gejc5UkZld1k0azhkZElCQ0xVYy9JZ1RxNU81UzV6eEVHNHhm?=
 =?utf-8?B?SGp1Q0FKWkxQRURqRng1ZjN0TDZvN3NEWEpkR2VJL0lPNC9hN2NxZXZsblRD?=
 =?utf-8?B?NU1PUlNMemYyYk9Zdk9VcDNqcXRUQ1graU5FVXBTV1Jvd2dJK0pEM0tPcGdJ?=
 =?utf-8?B?eGZCbFMwcUx2S3F5SWFkRExZRGNNVC8zb3VEd25DOWFTK1dacU5heDc4Zmwv?=
 =?utf-8?B?b2hWYmJMT1RFR3RoWmVGTUNidlFIR2ZjYzc3NjNoSWp2d0hFb3NGZU9TZmM1?=
 =?utf-8?B?UXlsdytPZ3Ard0M1NGkzZUZuNTBTKzQ0a0kwb0lXRW9IWHhJcVdUQ2NuVUVK?=
 =?utf-8?B?bURpVThRVEtYY2xrWDUwMUg3VHBVVXZCYkloTC9QWlVWQ09iMEx4elRjTUU5?=
 =?utf-8?B?NkJ2M0p6SVdTZGF5UlU2aHpNa1FzYUt3b2c3ZlZFbVFvYlprTm5yVndoRWJr?=
 =?utf-8?B?eTIyelZRekUyS1Z1eFpCWmtQZThuS0Q5T0tRdXI0MDM0eHNUNUV0MlVzNjE5?=
 =?utf-8?B?bUFxODBaSFEwUVB2NDZCUDRaTWUzbjB5ZFNQc0s1d3JHYXBWY2tJWGw1WEFQ?=
 =?utf-8?B?L0grL0g4ZWQ1U3JTZytwQ29xekxVcUJISDYxVmtCRDNoZkxNbmgyUXdCOE14?=
 =?utf-8?B?NGtqTnVONWMzQzBYNGhmbWJTZ1RaY2kwYUIxRzlnS2p6azI5d0pIU1E0SzFM?=
 =?utf-8?B?a2hIb0ZaVVVkWVUwY1BxTjV2ZDJsNFROR29OWG1tZW1WTzBZbkFzeDZDR1NF?=
 =?utf-8?B?TUs4N2czOG5lMnBiRUdpejI5VGJSTWlVWWgwWDFIOCtrZnlVc2w2cjBOVnpY?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e557fe88-0573-4c06-4560-08dad9d1d10f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:40:40.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5jKjAgiNacdy/mY8TCcdBCghYKoVRbWKPn86BkWDZuGFhXNx8BOnRsdU8tVO+4vTROedOlUcGH2C8TK58rUYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5934
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: f3liy5apfMTXXYRjllWbwitiMgXB3ZF6
X-Proofpoint-ORIG-GUID: f3liy5apfMTXXYRjllWbwitiMgXB3ZF6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> Subject:
> [PATCH v2 01/15] scsi: Add struct for args to execution functions
> From:
> Mike Christie <michael.christie@oracle.com>
> Date:
> 09/12/2022, 06:13
> 
> To:
> john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, 
> hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
> james.bottomley@hansenpartnership.com
> CC:
> Mike Christie <michael.christie@oracle.com>

Generally I think that this looks ok, but I have a bit of a niggle about 
the sense_len argument, below.

> 
> 
> This begins to move the SCSI execution functions to use a struct for
> passing in optional args. This patch adds the new struct, temporarily
> converts scsi_execute and scsi_execute_req and add two helpers:
> 1. scsi_execute_args which takes the scsi_exec_args struct.
> 2. scsi_execute_cmd does not support the scsi_exec_args struct.
> 
> The next patches will convert scsi_execute and scsi_execute_req users to
> the new helpers then remove scsi_execute and scsi_execute_req.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---

...

>   
>   	/*
>   	 * head injection*required*  here otherwise quiesce won't work
> @@ -249,13 +238,14 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
>   		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
>   
> -	if (resid)
> -		*resid = scmd->resid_len;
> -	if (sense && scmd->sense_len)
> -		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> -	if (sshdr)
> -		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
> -				     sshdr);
> +	if (args.resid)
> +		*args.resid = scmd->resid_len;
> +	if (args.sense && scmd->sense_len)

I am not sure that you require the sense_len check as you effectively 
have that same check in scsi_execute_args(), which is the only caller 
which would have args.sense set. But I suppose __scsi_execute() is still 
a public API (so should still check); but, by that same token, we have 
no sanity check for args.sense_len value here then. Is it possible to 
make __scsi_execute() non-public or move/add the check for proper 
sense_len here? I'm being extra cautious about this, I suppose.

> +		memcpy(args.sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> +	if (args.sshdr)
> +		scsi_normalize_sense(scmd->sense_buffer,
> +				     scmd->sense_len, args.sshdr);
> +
>   	ret = scmd->result;
>    out:
>   	blk_mq_free_request(req);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 3642b8e3928b..eb960aa73b3b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h

...

> +
> +#define scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
> +			 retries)					\
> +({									\
> +	struct scsi_exec_args exec_args = {};				\

nit: I think that this can be static const, but no biggie

> +									\
> +	__scsi_execute(sdev, cmd, opf, buffer, bufflen, timeout,	\
> +		       retries, exec_args);				\
> +})
> +
