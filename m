Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6066C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 12:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiKKMJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 07:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiKKMIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 07:08:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4A5E006
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 04:08:28 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABC2264023419;
        Fri, 11 Nov 2022 12:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=C1Ni0wR9TSWxVD6Hgfp9F1s782kbS6TxwG5Fn9q9uEk=;
 b=GmtHvOg+Ie/EjwMl4WWqIPMgw0ZGEpvLQ/pCWThvsrDQVz1uA/lCAn79X9MFD73+kRfX
 Afvx0XK33yIPukjp8f3BSNR2nfp7oQdMxX+ZD79HBBiqzHU11ShRSio4lSuxOsrRq7SL
 JIcNWq/i1/rRsEUxhn42wdGI/jjJrjUcecPCm1VLTSbtGqVvuUE7tzzx7ZT/ZRiLRkRy
 KqqrXkJkwt9QrRH+R6ZcoHq9Q7Z7QxXDsbGH58yoIZ5YB2KgVbAW5WaliqMus+BSmgNx
 tvqyqejpHCQvKdXHxsMD3WyaXLpYBpbKkMGlJlHY7wzsKIj0OrD9aAYxURhB+vsuFIwk 0A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksp1v010k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 12:08:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABC5YaC034053;
        Fri, 11 Nov 2022 12:07:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcyt8t46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 12:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/MI2EtsWqvSrn4bohlPjUThcBd0oRpXrlGToyTGmBVH4ToNnvF9frk9BDedQbbp7XGjkTEhorrtrORA8WoxpPvBEG5tI/OZgS+aCIsp+jeYo2ojgshc5UKQPFtqxnd+yY1BrxNxGPHNttln1QPifmHBoCJPlGZRfpGQn04tb6lldhqOmqnc2RSwo5BfYZI0MTS45mkCsqxweA09GXxqlvYEiNEI9Ko/DYEmh1sJUUv4Mh6BfoFPQXouR/20mhoEAYoavOzYel3Y742W1M6/EizX0xbJpfJS7E6b9Kf4IfSzRquZAL4uNPlf2dc0Jhb7r/+avyti7pFd/FLDj19WBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1Ni0wR9TSWxVD6Hgfp9F1s782kbS6TxwG5Fn9q9uEk=;
 b=gj3OFh4YErNTaeWLTfQMDBw/LGxNgiczaJ+YmTya6jVJ4dgdze8pujZiOR85qhBpNevjkmpyu1EMOACLaZbHT4OgyDw1ayvUFQmDKdYQYhRXUNvs90cHRYHRzciEZ/eAqbptV4UFgDNwvhRabTcvp1S+zc94CufTHYH+YatFAZEha7Wqu06pR3gfb9ttDRwZi/F/sYPCT4vn/004X9h01Kq35WJXM0oSnAnSgxKNBNHfchsz1BZcK2AL2iX5GFg9LBwEdAvk7IRFZYWRxS39nNMzh1fXUh0PqBtklVo1YbPP2FjwhVX5cDFZbUZ6pMoi4Zd32Ak33QgG/Tf+YJFRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1Ni0wR9TSWxVD6Hgfp9F1s782kbS6TxwG5Fn9q9uEk=;
 b=mDb0yp4sCcDiXkD0ueFnIRnbx+9IV2Xy6YQZ86Y5kwd/jU7MOm+QsnP3fBdDvTWs/LzacOblzpgwykkoirj/sGEXV+vx5yC24wN0TSabZZA/yY5yq+gXK8zOsnHEIfBRCyH4EBCvN+5J8U+Ve92TnPYPfqVomdYFHDk3xDeHdEQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 12:07:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 12:07:31 +0000
Message-ID: <d3e1d2ea-a68d-da0e-7379-dd583ebcec61@oracle.com>
Date:   Fri, 11 Nov 2022 12:07:26 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-4-michael.christie@oracle.com>
 <1bd9df90-fda6-270e-e437-e1039a0a8b76@oracle.com>
 <02dd9d58-a5dc-2733-5b34-481f276fe231@oracle.com>
 <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a215068e-a5f6-34ce-2b23-8f964b09db4c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4597:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb6584e-ff28-4c3c-7abd-08dac3dd4f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANL+FIWRq36BdreCfD7ZoPyDomuM/oNL9i9jRMil5mzbwQ7F4/fMabz+v2oLdCIhWOnBgRuMxOg6q5iWGPrTKf3U0IhU/4168Z95z62bE+56/PmYV/4C+Hp5W3YdRpG7Qok/lt7c6BRvsFwsUl4CnxDmaMs0aGa2MEuvnZXublrH8w5K9iNAoLeqqzK+Kk4etRnwISUVY0QMZZUwMA6AETPloWGYN2SA4vkAHyIura71SuMBpzE52FgV2ehwoWsMCz7Mb5pYgT3PRsolesZtpLxoSNDD53AwcHivAL827gDGLJAGxPNpzPVDR4JuEu0Ow3zmUTr5B1O+/LqeZx8ffGQ6ig59FiN+OXb5CPtG8/yNJSjSt8mi9ASouK9gbkTTa63plSKR9SLOANQRQS98z9nEgypuEaqCtNp0xl2RhdRwRmGROZUhatt34zIC3OQA82KpfGgYBOLC00UuE1gx7xIiIPRBEGGrzQ+Ybx6yXxnhgjbfUrvOA0YvlJGJmeYiEnTAZOFNmn7HfjYWzZ32Kirb7yB05demrg+wFp+Pgj/2bB4zBVjqqd5F2zWr839pORe4rofJ0joBT+YU0G7Zkt5X0Lphi+pMMF2lUwHEz7M4MRkWi6Jjvbrd3O4h+feBNgnIRvKtmyc+t5HyGkjfa4UknKTDXgWEdFxqaefXyn5U97P96gS8vruhP2Szii+9pcSAgNutATbSSL50mOm56esVMicZKea6eeeiC3pt9F58cwM9ffVHWiWlyvb2DY5L8OkxyIE34L6qWxZI233Yjh38aJkSgf9Iq7gKrIll2cs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66946007)(66476007)(66556008)(86362001)(316002)(31696002)(186003)(8936002)(5660300002)(36916002)(53546011)(41300700001)(6666004)(6506007)(2616005)(6512007)(26005)(8676002)(2906002)(38100700002)(478600001)(83380400001)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1pYRURyQ1YyQnRpejlwMGpHQ0tGY2pzcGV0c3NmRWVHVUs5MmV3TGczY2hR?=
 =?utf-8?B?TFhUbDJJUUJINXZ0UnZIY2ZWdm9hMWhEOTBzVFU0V1MzWW5BbUZ2UDFyajJq?=
 =?utf-8?B?ZkQvKzFkNjRGVlhWZ25oUUNEMk8yZXN2T1dya2lickd6UlNaS3VtZ3oxZkxC?=
 =?utf-8?B?dnFRaVVmWUFwZVZIbFlYeWZCeWpMcit6NGd3elJyRnBMSWVINWhSQVJXUzhZ?=
 =?utf-8?B?amtMQnFTNFhDN1BvWFNUbVNkNSs4L1hudHRFODBJTUpNdThSbnBiaGJiemN4?=
 =?utf-8?B?SGtvQmQ0WitMVlhha2RUc09MeU8zbUlhVmZkRER6MHQ5dkh5QTAxOVdudzZI?=
 =?utf-8?B?emVSQ2ZZSktZL0dKVVpRbWFtQ011Q0tDUnhPNFAwS0luMXM5dWlWakZqU3Nu?=
 =?utf-8?B?c0hxUnJlRzZ5R3MwRFZFdUx6WXhCU0cvMHdRTEtDenBPM2k5NkxndmFkQStC?=
 =?utf-8?B?OU56MVY4Ris4VTFRUUV5QmtHSDgyTEZBN21DK2Y4cjlsQitRaUh0RDRWdGdp?=
 =?utf-8?B?UmlHbzFMa1RjUEpWL01vd1ZVRGdnZCtnRzJULzJSTUJXTlZIWm1QaS9MSVNs?=
 =?utf-8?B?NTNRQ0RORmU2SGZ6ZW5lVzFSWU05Wlp1UXdtcWd0WlBGdGJ5M1hjSkFtalRF?=
 =?utf-8?B?WFVrNHl1U3EvaFpiYVMydCtnci9JekpmbjVrWVFxR2lnMjllOTFhOFN3MCt2?=
 =?utf-8?B?SUhQY1YwTDlROTN5aWZjK1JBc2tacGl6UWpIekFqWmxZZEx3UTdTNHlFazZ6?=
 =?utf-8?B?MmE0RWlqUGc5ZWRxRGNZSXpnSW9iSlh1YlFJVVRuS0dONkFlU3AzVFhIRWQ0?=
 =?utf-8?B?R0FXZXp0OVM3cWxzckI4ajJ4UjJSa0F4T1pqS3MvU2hCM1ZMZmtFYlprWFRx?=
 =?utf-8?B?NHRtZ1BoY0kxZnJ1ejc5ZHBIQVpaRWEwYjhEU0p1c3BjMFZ5RzhHeiswY0Ur?=
 =?utf-8?B?aktDbytYWXQvcklWSTVDTTNFZE50MENuQWkvWU5YbGtxSm1USlFNQk5JK1hE?=
 =?utf-8?B?eFVIRnlRNStpYm12N3ZvZk5HSndyU1NKa1dFNnQ4VzlqaCtWTWNuekpxcWQv?=
 =?utf-8?B?NTV5QytpbTBoY0V6SDdpS09LTmZTcFRTaTVodFVlNUN3ZEdwNHU5R3NXY0t3?=
 =?utf-8?B?RzJVU1ZKeXNsbm05akR6T3Q5Zmd6S1NJRUNFNTNRQUxxQUVyVTdueDI3ZThr?=
 =?utf-8?B?eHo0cVJoKzk3ZEZEUnFXSUoyYWVWNWRyaG5vUDVsa1hYR1JzOFhSeHRJcUtv?=
 =?utf-8?B?am05NXFqV2UzNGl3NjFxbUVpaloyQjVqeHZJN1VzdmJNZ3VCZU5FT3gwWHJz?=
 =?utf-8?B?TlRFSHByTVd5czVJWTZ3UllUU1dIKzZVVjVQQXcrTzdlN1NUbDBRblNBbzlU?=
 =?utf-8?B?VkJyL0IvVFJKOGxTdi9rWG9ydVc2b0E5aVNVWjBjUUlOOFNDcjhJT3VXcDZ5?=
 =?utf-8?B?b1NiNi9UcFMrRHdzRXVSdjRDYXk0bW9MUzlyRVM2Q0ZVcm93dXR0Mnhvak9S?=
 =?utf-8?B?bmU1R1NRQ2ZQa2UrVzU5UTVkbWJoRk1rd050QjBZV1hoNy9HSHNjcTBtQXdj?=
 =?utf-8?B?RUdyNk1EVDBiRDcxSUVvUGgwQzk3RjcwajUwamV3R28vOVYzNFBaYVRJeGpC?=
 =?utf-8?B?UTdad2gzV0tNN1kwRXpvV2grdktJL042SXp0M3Znb01wdXVTdjg5T2ZuWE1s?=
 =?utf-8?B?TmgxeTFmL1hERnppQ1Z5N3ZjcW5Ud3Y5ZmFHbEtkNkEwTEk0bnlBWHVmNjd4?=
 =?utf-8?B?RVdkcWxKQzVqQldCNXdmazVXVk9vNWg1YXFnZmJyL3FRM1RlQXZBNy90bnI0?=
 =?utf-8?B?V0d5NnNnUHlwMFhiYlhUclFOV3dNSEE1UmpRS1dldmk2WjdyOThJamJiTE9t?=
 =?utf-8?B?OFlyRE03WHlVdHVoeXh4bEp6VTNicDlFZUFxQW9lZGxGTWo0a3BNd085TkxE?=
 =?utf-8?B?clg2TWVYR2hnSThEekxzMUxRamNkekwyalYvQ0g2ejV2L2cxVlJ5eDRoaXh4?=
 =?utf-8?B?NFdqSFAzak5rOUVtSUErRld6Mm9LaUczK3hrNEMxaHJjZGZac2pQUG9JcFFK?=
 =?utf-8?B?K3hoQWJidndoU3pBSGpveTU4aldrWVFpTXh4aHQ5SGhsS0tpVVdrenNxMk4y?=
 =?utf-8?Q?lXaCZrdEr16QMaA3odL1KJQjC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb6584e-ff28-4c3c-7abd-08dac3dd4f19
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 12:07:31.0635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtHLaxski7o9b/kzXWeO9e3RYlwl6ZFAkSwF8n3cF01KnTkNOV7UMQU5G574iCnADxan8FYY7aukbmTdR1/fRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_06,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110081
X-Proofpoint-GUID: EZ_Efiu1Wxxesuc0c6p0Z2l9UqHTR-c-
X-Proofpoint-ORIG-GUID: EZ_Efiu1Wxxesuc0c6p0Z2l9UqHTR-c-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2022 19:26, Mike Christie wrote:
>> I'll change the types in another patchset,
> Oh wait, I could probably handle your comments in this set if we
> wanted to.

hmmm...maybe it's better to be done in another series, as you might get 
bogged down here with other comments ...

> scsi_execute could already take the block layer flags, so we already
> are doing that type of thing so when I was thinking the scsi_execute
> interface should be less block layer'y I was wrong. So, I could convert
> the users to use the REQ_OP_DRV instead of DMA values when I do the args
> conversion since we normally do just pass it in the directly (vs libata
> where we do some extra work).

Further to that, I do wonder why we even need a separate dma_dir flag at 
all.

We already pass a blk_opt_t arg in flags, so why have a separate conduit 
to set REQ_OP_DRV_{IN/OUT}? A couple of other observations:
a. why do we manually set req->cmd_flags from flags instead of passing 
flags directly to scsi_alloc_request()
b. why pass a req_flags_t instead of a blk_mq_req_flags_t - as I see, 
rq_flags arg is only ever set to RQF_PM or 0, so no need for a conversion.

> 
> One thing that is weird to me is that scsi_execute_req is the more scsi'ish
> interface. I would have thought since it took the req flag since it has the
> req naming in it.
> 
> I don't care either way.

Thanks,
John
