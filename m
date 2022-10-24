Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF68C67871
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 20:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiJXU3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 16:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiJXU2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 16:28:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6EE9A9CD
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 11:41:06 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OIAHB4016463;
        Mon, 24 Oct 2022 18:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3xomT3GZitvFB3jZwBbKeHinNoLtI/FMEBNFNkzK4rA=;
 b=TKrjkeLCwZ6dbtIq9IGTRTu1bweEVvCSX5qagHsf6N+43fm/QHGryLlPsGJBquhmsvqK
 XU6ltofTOVOq86iXFtMoWj8LqoGkSaD2pOGLjMTXUmy7B+gsp66IZQYIUG+KuONJCIAm
 scMTFHeZFrMl5fRiIQOCEucFLC+POSl5kzgKgXM6qUm4daFiE00sOhfhwrtVzum2VANx
 OVJOM4VSnKQwveKHmgDQnp2pbT9uesjT6IQBxvySSlRCFhAkyY6qeM3AjSKdXtzC+xGb
 OPmo70z3O/xgEp7zHQhjwZeBycmqUbjFxUFOA+ehBlHPWOyTxRnL9hefHEAARdDZ+Y3i Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbcmq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 18:39:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29OGr7jw017361;
        Mon, 24 Oct 2022 18:39:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y43xxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 18:39:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQxYxWb/1lEmtzIxcH250DSxuCmRDE3GVMOgst4D1HJc3yBgr5H1Yd7MxOM4Y/V0k1AXbx6hGsPknz8Db13lr6vYrAGLVSi4nYfQHo0LYKg+ZQ8k+IFONTZfvKuVQV+yLidVmHQ0CoLgtjjAOc5RiaW/MtE2SZaVH4c6mzBM/iEUS8uyrV/++NtbkLFysDOwJpzxaShUFgGjuqzbllTVbHQLMyDtUHhQP9jh65RbcJe85iAwKZC6RT/z2H1whCDUMjPprkmCQMBQk5qnfVrL/x3RKDhIMb9inpThGD3Mnzl657EoFh8NrDEDWCk61TfgMK+ih0b0O+evOoWwauHXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xomT3GZitvFB3jZwBbKeHinNoLtI/FMEBNFNkzK4rA=;
 b=Hg4+74XTCPhvEayevhBFPVeY4+VipgQHPXDiFh+t3YzBO3V2piJH1Ot7zJbSJ4ETQbQR4i9vEREF2IJQxzOXTkgj1OjsVFeawtXMYpteblPuMXmhIE/XnHSyw4FbpRmg7me0uoj+RZ+O4771v2ChmQMWthXsRXn4Wxowp67v0ufZRSJvR371sLZX7h5dSTzoNCvGH6/mSw1Fsx9cemW7nCjX2lJMOiA2DyNPpLNNG+VK04xrazRDt0LcM4Q39N4FXxPvjKk+Kx5nE1y2Kg7dclAWw227lChrz70cq+8rhEn1DefOQIiEDux06KZO4v3yDWXm43M2sMR3xRXOB9zNVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xomT3GZitvFB3jZwBbKeHinNoLtI/FMEBNFNkzK4rA=;
 b=NB+GomSoFBYiE9lnI8i0i7QfoOA+ewhSHe7Ip/Heq3I6Kbpk+/hbfmsVqzvDLMtAUTOpY3Xn256+7IvqYJttuIKvd8NPKaXEy/wcseODGgRHPsyXuZm8l1dmetP1og14n0hzMP0VCR5la+WgH4vwIVILjDbOYq145G0GGw1ay+k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5806.namprd10.prod.outlook.com (2603:10b6:303:193::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Mon, 24 Oct
 2022 18:39:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 18:39:50 +0000
Message-ID: <d2ee2cd6-ee75-9ccf-ac08-c096711bedab@oracle.com>
Date:   Mon, 24 Oct 2022 13:39:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v5 35/35] scsi: Add kunit tests for scsi_check_passthrough
To:     kernel test robot <lkp@intel.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     kbuild-all@lists.01.org
References: <20221023030403.33845-36-michael.christie@oracle.com>
 <202210231450.rSoaGXfs-lkp@intel.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <202210231450.rSoaGXfs-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:610:38::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8adf26-e067-4465-cbf5-08dab5ef227a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dp664xDwj0iaVcEXvy9r4gN5WW32bJ6Bx3t0CvPf6v228G1jUjmDC//Bmg/xX5pc6oaK3wsIAh5T//qV7FKHa/rYyFs/G9ZT5LAdcQdRj7MmisYS7OYZFXXtLkZMMBrm+FrF0mCJV1KEwDjXdCbUwNHAtoIbiKJNgpwtAfMOVbj1gkHGXYIGDXBi82JPeyzMzf93NNcI/GCK+LY75kJwlz7TFUQCluPQfkH2xDob01t/Tc19muAp3rMztbFQjeG9yHWRh32OrFzx2/m9FJjhMQBNoILvT8aFXkjNF6oA85cHN8nkYLVsPprBlUpg4Bs9oO5JIGlDPMoAUFdy9sH6n655M/7Z2G56xnKAQatAAURwJP0RYGJUIKrVnEZfYzDIyCzTFyn4gQw45Am/3nsFLSQ1CCjIc5YoZiGS1iE9cXb653VrluI+ScqjM3GqIiLIWUMGRbaTdXSrIOSP/LtW4n3bMkvcLT0Nm9lTjevrOEtctjuTBpol3Z6uia9GEgzLqgQtFkPgB9O5OwqJoaR2EBrbnlT8LUv+LTp6R95TlWPPSIGzF5/H32L606a7PR8yl9Loi0ENeE7V4MvPSUg79ohGiDcu423+eNBMq/VsXooA9nRqhONeeEkDz7aAjIuSAmvIbhZShNDq82uJ5cFfMg8HcmMCUnNxh/hO721pElFfCXy3zsueVHQykPXA74aJjp6w9vc1gdn4Blzo1o/e6U0gdohYUnjUu15VNeEdAIU82KQdHCwEtmlGvDgxZWqBcSNvw4BKRyUu6UcHWxahw7F1i08xkGFRoKNzb9Vn0LVmU/Q3IW1wk7T7jR4yCFFPRRUcXXb4QqOxIfLGuUGQyHNevoS8ERhc1iRxLCtMNlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199015)(966005)(478600001)(6486002)(31686004)(4326008)(5660300002)(66476007)(2906002)(41300700001)(66556008)(66946007)(8676002)(6512007)(6506007)(8936002)(26005)(2616005)(53546011)(186003)(38100700002)(316002)(86362001)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qzc1Z3JYa2VGYXhwNE5HdS9nZEJWL3pua0hzSCtRUnFxYWhlKzhOU01CZC84?=
 =?utf-8?B?c3VhNis0YVQxa2lKck5oMlNhZ0daMFVGY296MDl2RUFsZFdQSEtTeDVyWW9J?=
 =?utf-8?B?cWNRL0syaGc2NFFzdVM5VVYwSzF2WVlzeTViUFRBZTNPQ0RBNitWUjU2bHNU?=
 =?utf-8?B?aWc1NTRkQnFWWlQ5emYvY3JQNUFBUEF6STNjKzlZWGwxWm16UElMRW1JQVpK?=
 =?utf-8?B?eGZWS0lVRmxJRUxHWmFOTmF6YkczK0dUOXk5aGRVOHdYS0djdDQxTmp6cmZE?=
 =?utf-8?B?TUhOMlV3ZTQ5VmpjTUU5dG0vb1FRTkhoQVBUUU1lcm4zV3hWMkV5aTRBYjFB?=
 =?utf-8?B?RTV4MnlSaEhOMjBVeEJPTUE0MEpneEJ5QW9xdVFTVG9BbjJwSVBrZVNXTXZT?=
 =?utf-8?B?TWkrRFdJY0Q2VFdBYktZVDEzUklaeU1pb1EyRWhkdkRuazQwMHoyQ2FXaVJE?=
 =?utf-8?B?ZXo2YytKWGx4aUkvbFJTNGIxaUsvVndVT2xWQSszOGw0bTd1bmZxSFpPOWsz?=
 =?utf-8?B?NDY0VUFoYzAwenRUam8wRGFGeEtvU2FrclRqQWNSWkRSWkdCUVRKK3hWYUJj?=
 =?utf-8?B?dmE4dFpCbXloUVlnM2xvY0NSdGdMZk9kRjN2ZXd0ZWhlNHRpWEJjcnFtd3A2?=
 =?utf-8?B?WXBTVkRKNURPWVk3TUZoUHZpRFUwaVVuZUdlaDRNSGNpc0oxUDVvTXBVTE8r?=
 =?utf-8?B?NE5oNDJLSGhSY2Z4WnFMU3drU2ZMZGcvc0tkeUZnRWQ4Z0FrZ21iMm9senJN?=
 =?utf-8?B?SXBRVlRZQzlHL3hoL1VnMndBQ1NLSW9XdTZ1WEdoRW5McmtNeXM5RXlxWTAw?=
 =?utf-8?B?cVU0QitGZWZLRzVrc1pidXBQeE9VZk4ydTh4dUcrMXV0eEtWelpQc3ZXR3hu?=
 =?utf-8?B?NlZUZkd6ejU2M25LMW5QOFZ2N0ZlSzl5OGFVd1hZSzhLNHcyMFVWNkZ6L0sz?=
 =?utf-8?B?THFjU1A5Yi9LcTd4M0JraHVVdUpIQ3Y0N2lCRDFGcFAwT2tLc1phVWtaM2Fq?=
 =?utf-8?B?Sy82RnlUY0ZlK0psZjBKakJhWEV0WTNGRUtkcWJITzFHTDRFakMvNld3SHds?=
 =?utf-8?B?b0NZVmhJektKM0s2WkhpeXQya3hRVXFydXZhcVhwU2FtNEllaGN0cnE5QjFw?=
 =?utf-8?B?Vkk0ZkRyRlhFRGJqdVNxd2ExcnlaSHBFK3Z6ckpPbDRqOUdZeEg5ZHJFTmZC?=
 =?utf-8?B?cUJCWkN1Z0pmeloxY2djdHFiQ0tHbEJvN0VBV0t6WjNTUTNaN2Jpb21PeGpM?=
 =?utf-8?B?Q3M1bzEwZkk4cXBCaG41VUpEVS9Sb1hnRmZ4V1lNZEZCc1JlMU9vYTMyQmJH?=
 =?utf-8?B?MjdxRlozUHFJeElzc1g1ZUgwYjUydFpLYWgvR0c2c1N1QnFiSUgxaEVCWEc3?=
 =?utf-8?B?WG5qUVdkWktDckR0VnhGNHB0cmZnbDhUQitZdFcrclEvQnlnY0hDT0w3Z3JW?=
 =?utf-8?B?RC92VkMveXBWUmNKb1krYjRMRXBxYjdQTy93RjZOWXZNaTdLSVJLbzB5T0dt?=
 =?utf-8?B?aHE3VmlOMERoVU5Xd3lESnM1d1RVcWdJOUNVaVlTWmNpNEE0UTI0d2N2alJn?=
 =?utf-8?B?dHY5S28vN3U2MHlmR2o3QUVZNkNocmxIU3JDMjlWUUtSWXQ0dVgzbDNib3RS?=
 =?utf-8?B?aWxpQ2tEdnczQTZjL2xVTnArdWErTFVjZURMampTcFI4QmZIZWVUM091ZlV6?=
 =?utf-8?B?WkFuWDZyaTNHWUVwYzQvZ1U0Z2xjTk9KM21IZURiOENna0VURmQ3RmJEZjlU?=
 =?utf-8?B?K3NsYnplMk5KZEFUdjNJQmVsSkNtMmVjQXRCVGxTTUY5RC9MZDJ6cG9iZzFk?=
 =?utf-8?B?M2U5Z09kMzl6Zk9hZ3NOWkxmL0k1bXNFYkFBRDkzanczbE9SdS9wRUxMSDhk?=
 =?utf-8?B?OVljY2xPa25iZ1pBbFpkVERUK3RZTkF5dHpvN3IzWkxHSnhXcnZSVUlKeTdy?=
 =?utf-8?B?a1hMdWtOVEM1QTFpclJSMExtQkJVU0kxVFprc3FUTXNzZDRNY3E4ZTZmek9N?=
 =?utf-8?B?dDRLWGdkYWcxa3NyNW55cnhRNnZuVmNnM29ZYmdWcmlER1J1Z2tRbnN1QmZ0?=
 =?utf-8?B?b0tKNzUvUy9Lb3VucXFSc1RHb294emVSRURiYnZvcW1BODZFZm1hdnBsZ1Zy?=
 =?utf-8?B?K3BNckhVdUN6ODVxbmsxc3puMlkyV1FuTEFxOUVlZVVDZXgyNHJFWUQyMnYz?=
 =?utf-8?B?Q0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8adf26-e067-4465-cbf5-08dab5ef227a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 18:39:50.8661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeugYDmGdpx4YzTcA0bYtCo9F1gAS7s4+l+ULMpMH2iN/X2l6zOQkOy25RnV3E2Crl7OdXlhtz2kngTuPBxV0mpz+N6a+joqsonUO4lo9A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_06,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240112
X-Proofpoint-ORIG-GUID: hfUEvbTqnAbY9MugGyEFZp2hWkfS075A
X-Proofpoint-GUID: hfUEvbTqnAbY9MugGyEFZp2hWkfS075A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/22 1:32 AM, kernel test robot wrote:
> Hi Mike,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on jejb-scsi/for-next]
> [also build test ERROR on groeck-staging/hwmon-next linus/master v6.1-rc1 next-20221021]
> [cannot apply to mkp-scsi/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/Allow-scsi_execute-users-to-control-retries/20221023-111103
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> patch link:    https://lore.kernel.org/r/20221023030403.33845-36-michael.christie%40oracle.com
> patch subject: [PATCH v5 35/35] scsi: Add kunit tests for scsi_check_passthrough
> config: arc-randconfig-r025-20221023
> compiler: arc-elf-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/5c568c0893302315545f701ffe9d0aa2afb276d4
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Mike-Christie/Allow-scsi_execute-users-to-control-retries/20221023-111103
>         git checkout 5c568c0893302315545f701ffe9d0aa2afb276d4
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    arc-elf-ld: drivers/scsi/scsi_error.o: in function `scsi_test_error_check_passthough':
>>> drivers/scsi/scsi_error_test.c:139: undefined reference to `kunit_binary_assert_format'
>>> arc-elf-ld: drivers/scsi/scsi_error_test.c:139: undefined reference to `kunit_binary_assert_format'

Looks like I didn't test the case where scsi is built into the kernel but
kunit is built as a module. Will fix in a v6 posting.

