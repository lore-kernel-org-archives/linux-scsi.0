Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6DDC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLIKPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLIKPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:15:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC17E69AB3
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:15:04 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nWO5026777;
        Fri, 9 Dec 2022 10:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CE31kUAmWQoVN4cSkoXofxktTI4fjQTvY2Ek4Xff+BA=;
 b=JeMtJjpRXExfS44WsQIssnkWR+3QGK7PMGiIGMDuU2Q2KCgRzTS4sGff8k1KzFb/7WCh
 kwfbwqvTdXzQUsWzdZdCHI+XD1p/HLIkk8G+1/+coevLrnQVzoxxgrCJF4bh/fmJyzo2
 DvCOTbR3fhT3nsuNMTB7BUgZyo7/HAEqzFif7xxQZigQvgM3QWijaTVSlU+vLRz1ZQzg
 ggb0pr23JufUVOk/oz1aauJk406eCGAxqcYyseqCRvxpbse6Sc7e3SOGVBC8/wWWVSW0
 0h2xKqWmVFK05R9Z7gSxWFdvvi/hhKHL3QGb4s4gfIW9BDCl4fff9NQX/Q7GW18lP/3T kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74x88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:14:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B99JUGU033750;
        Fri, 9 Dec 2022 10:14:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6cduca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:14:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0bBu1wLKu/1v9uLDbYOlcrB9xcgIRDtTNc0b0HSXpj9M+f+7Vt4Rs8W3nhUoS7ies9qSAgjnjdfVi1/hU39v/VvE6bIknHZ7HWtMS39sMQuESWxaOMzgAmpSuDkbvx6IDvyUwWmLpJd2DbBdyo6uea896LK6TtGRwBGDTtAlrga58JyPkQrsgRcoB/J2R5GkQYbp/hmKCAv/6Cv4YC8D2S7OqDb9TMHZamB/O/FCv/Mcg9SuakXFssI3FxGHr3te2E0pv2m1J4L7RBM6pLiZxm4TBz8uOekZLfRxZbh4XdWmZ+c1nGwmUfk7WNU9dJ+AJRVwCoLInQP1LFI9Xcx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CE31kUAmWQoVN4cSkoXofxktTI4fjQTvY2Ek4Xff+BA=;
 b=LuIKM+MnpG2NUsEtsMAU4P5HRXA6cA2LlabFaYMMu8Qj6OEowK77OUNurfSg1gGJ946fGWu8zcsbOyIpVOKDPQCLgNwtf4nl/NOGRNVxDLHPws9uANa3qYDkjbzj3+jVhIRdq3xn1SG5PYbSOg4TvJ3y8MPL941Y0XkcSozRaUJ+8Hx3oB8jqJu48nhcYpMhya02mXukm6HkX5SAG+O6RJ6OxS7wHV3QoHYSuMNVKLGDNF9mLHQRpD0i/fsIB+2taVqwSdQwzgtd5IZMKMgLc65ty0ONmnqjVcdUjYkm73jddLw+2xKzN3v2QHr9NJsWhmlWNQz3S+ZPL4fst4Cv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE31kUAmWQoVN4cSkoXofxktTI4fjQTvY2Ek4Xff+BA=;
 b=wZhCeLHO0xTIJbogD4WeWLtfJ5kgde5LLraBbtmfY4Saz1hr1wJPXqs9Qj7PSWAAm5ExNEpruhRM2k3Bw9MA+epHWxCZASpn+MniOa62AUIfhLRV3rYXPVE0s+vJ0L2bQWHOURcZVFw9JHb+LMkHkOZX15dr+8gdt9zcJWcXyVg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:14:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:14:55 +0000
Message-ID: <16a80988-d95b-80d4-c133-32dcb6481c9e@oracle.com>
Date:   Fri, 9 Dec 2022 10:14:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 10/15] scsi: ses: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-11-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0449.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 0803bd75-6845-43a2-5e89-08dad9ce37c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tffzhZt+NN/eEnBBekcCQHetoz/ymzFNsv8H41BHSvC+q1LX4hkmFsEBNxXazHDKd2xPOA3tB6TJADWU3nJdFTX7XdoA3zhUUCtEKIlJDcO5bgPCS5gAekYt89ABa+4dcFQ0k/h1UmqOi4wBWdC2+3JaI3dx2fn2isv5R1ZntTSU0hSldUJL+9SRXQj/Nnv0Om9n0LUPCtZtNObAyAxG/kiboGmPsO6a+qPMRRwRx4HZvLE22jAPwL7DMAq1D9Q1VeLHwmvg2lMycprRly90xk+j801pL5vG30B/tbrZUsmGQuzq8fctqL9CLou+7bj4LH12Zr4n7ceOLBW1K0EOaTShqkiIqJfG7A1yjIJVSUgLlK048UiQYJQdJRReB7ZE6QASBApks/8SlyqKqLK5a5Hc9HGcNEaJ+VSjnwPfCbcLYSx4KMPnGPTfqDKPcqqhBG++jkwUKZskLl8DQXlno7bq8HxBwgxaY8itRwwZ2mZEVRv+6z7LUlSpIwVZmTtnLErUsrkbKHYKksHzSh8EzNFe0IHGUOCRmkU1LZb/c2YX4c6Iz4nrYLoyt8DG/IrDAgzRvv8+b9v27IIv/TfF1rz/bn3S0RwyhEt6kg58G25+yBh2+MLp9qbev6UVEbYNSmXYEcDSoj5ybB9gfMSxSQmuZArv2U0Q6pcVfLCWbCAptLnLrvBCWYMx4O8k18xb/zGWHD2CvF8K9wFIZO4CklnLx7Ufl7zQYVODsc3TnE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(31686004)(6506007)(6486002)(478600001)(6666004)(53546011)(36916002)(5660300002)(38100700002)(2616005)(36756003)(186003)(8676002)(316002)(41300700001)(26005)(66476007)(558084003)(8936002)(66556008)(86362001)(66946007)(2906002)(31696002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0lPNGlXdjJiQnJWdUw2OEJKM25xcHhHdjFRWnczbHJwa1NXS3ZwOWZLVmMr?=
 =?utf-8?B?ckh6VC9NUFJtbVZtWUtRVmFCMlFIZ1p2NE1wYjZqQURWR290a3kvVnlQY1l4?=
 =?utf-8?B?NXFkakJndk9LT2NoMjI3cmc4N0lBcXhZZWVjQ0RLaDNKeGhDSlVRT3p1RkVB?=
 =?utf-8?B?NmJXVk1BK1pxajNmUU1zcmxzRnFGTEVhZ0grdGptS2JZdEh6cnJocHlrcFRO?=
 =?utf-8?B?d2QwNEJCeDFFZzl3T2Z6ZGM1ZGwyRE5kOHdFNDR1SEpaMG5ITm11ZHIzQ2V0?=
 =?utf-8?B?amt2MHVjYnVmVi9WR3RvYmJUbGpldFg3YVFvRmhLc1B3WElqUHZ6WG9XRnY0?=
 =?utf-8?B?dk9MRm01eW5TUWRuSEVSRWhqcjhNZUFLdUt1ZXVQK083Y2owTm03Q0c3ODhT?=
 =?utf-8?B?aFUwQWhrVktVbEJJMlFQcjVwNk8yaWJCalFZOTI5NklxTHFRVlZTRnBvK1R6?=
 =?utf-8?B?c3RCUTlQeUZ5MkV3U09SR3Q4dmtaVUs0Yk1veGhxenVRY0hzM05UMFlDS29V?=
 =?utf-8?B?UVNXTndGRVc3c2x0T2Iwem5qRFlBaUZCUWhuQ3N3NS9FOWNQY0J6Y0g5b1hz?=
 =?utf-8?B?cFJ0YWpxU3BPUTNCbDEzTDRWTEhWWmI3UURWTGZBSFJDbDRpWU5CM2w2SzNF?=
 =?utf-8?B?ZG45cXREM1VET3VObllsZmVUeUhOMW9IQTdRSjhKMlFXY05iRUNNdFpMdEhx?=
 =?utf-8?B?VTZPT0JDMmpkYmhTeUVjdnAxYlRRSnJzTkdseW8xVWorbkk2aEFXK1ErM3JS?=
 =?utf-8?B?WVNNVlIzSWVrVGtxa1hXT0VrNWtxb0UwRE9OVEZwdGNLam5ibDI3dlRrME0w?=
 =?utf-8?B?UnVyUXV4MTBid2ZmWDZmVjkxZHIyaXlxeG9DTG1NamxnNVZENjUvTFVTQVFG?=
 =?utf-8?B?WFZOQUVxWHM4UG45aGpxKzNiWXFRZWtEZTZQdjloZVZ4RjF5QkJBb1V4WWh6?=
 =?utf-8?B?c0czN3IvL3IrUGFDckJHdHFuU2FmNG9DeFoyVld3MlExOXFuM3FNZEJkNWRr?=
 =?utf-8?B?WStSRTFtQ2xiU3cwaDJjMXRvcThGdjlRWGxiamdLV0oxN3A3ZnZRZHdMTDhl?=
 =?utf-8?B?Qkp1YTdUdG80SFlFclZFajBxT3BQWWdhOWVzVnZNSVFJelR6ZjhQQ3VZQVhE?=
 =?utf-8?B?NFJLRUlyc1M2ZGM3S0FFWU8vUFJjTmYxRzd5eWtLdVZVZitEWVpaVmVybVZX?=
 =?utf-8?B?NmRUWmN6NTArSHI3ZTI3b240T2hpR1Jwb2V3cFEzcElSK1IyclR6ZFBDMVQ5?=
 =?utf-8?B?N1VqSE5DMGVEejZKZmhjWER0a1FUaUVZcXBCQjkzZi9kR3JpWDNSVmpTUzlR?=
 =?utf-8?B?Nkh3TjNQQTFTTkJxVUoraVpCTGZMR3RzbFd1ZVlSWHlOMlV1WEEzTG5ZUVhJ?=
 =?utf-8?B?R3dYWE9oT0FrMER6UVRibGEySWdENTNtZCt3ZUhVRDZKZG5rODRnQzh1azRa?=
 =?utf-8?B?QXpGN3ozU3Rha0l6ZHRvMnV3czFlN09ZNnFkYXdHeXJiNXp0R1lGNUNXUkpC?=
 =?utf-8?B?WFM5K3IySXRKY0xCb0ljejd2VVlBa2tvN3dpQTFJVGVUcnVkZnN5QktQWjQy?=
 =?utf-8?B?VTlURUtsSGZaTTBrV3FWZk9kbVgzZ0o1cDdGZnQybS9XVWhjTmdnSHE2YlVV?=
 =?utf-8?B?emt1VzRkSWpxUXJIaUdHSDJhUzVaczRyTFhJWDdlMHlydGZsRmRCRTJ5aUdY?=
 =?utf-8?B?d3F1NnZYbFZkd1BXTXlnTGhiTkVlRk44OEk3TTBNQkx0Ykpod1lhY0h1Um5Y?=
 =?utf-8?B?ODVMemJzSDI3eUdwVnlIV2xaSDU0SDNRbVc5VnZia2pTbFVuL1U5c2VZSkhk?=
 =?utf-8?B?LzlWRWF6ZkE1VVFiSFRmRzIwdWtrZjZSeDA2eldBMlVONHFUS1lnMFU0c1Iy?=
 =?utf-8?B?dEJRVjBlc2NDaWQwck1veXd2UU1wNjlLeDFCTGlSVHlVZHVxY0lHbmN0dXd1?=
 =?utf-8?B?NW95ZHRTNGk4ZGRzY1RCK0NGUTRRUDZWUzl6a2NvNlZBMmZ6ZUJ3U0lERW9E?=
 =?utf-8?B?M3FyV05nYzNWbEora2tyVFBTeFora2w5QXRSRXJ6ZGdNMUZrWmMvWjNVZWlW?=
 =?utf-8?B?djkyRHRydHlhWFlhTnp2RXgxd2YyczlmdzY1Nmd2L1pRemNBcEcrOWRwZ1dm?=
 =?utf-8?B?bUo5dUVMTERPYWhDcnVJVlRXT3lUeHNoWlFGWVF1SlExSlBkanNiZU1MazdS?=
 =?utf-8?B?TWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0803bd75-6845-43a2-5e89-08dad9ce37c7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:14:55.1148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+YQT63GDEjtK/TjGY3KFfZO+Y8kRjnXQsNDmE4mkjGAPGe6MkxDaZM+A02xn6BMNPA8UB4XV637zdBPy60fNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: dbXrK_66WYr0KEjREFdWHjQAaYTxdIWm
X-Proofpoint-ORIG-GUID: dbXrK_66WYr0KEjREFdWHjQAaYTxdIWm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert ses to scsi_execute_args.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
