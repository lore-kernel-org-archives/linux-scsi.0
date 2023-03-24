Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F790C6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCXSmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCXSmP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:42:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B07746AD;
        Fri, 24 Mar 2023 11:42:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OIYQFx023731;
        Fri, 24 Mar 2023 18:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=AfQjFU5bngCwCWiJnND4pbYZ/d4vQRe78CCpuK4I06w=;
 b=QnVBNzbcgZXR2noCp+q9yf6M4JvbJr5UA6YwqyfPdZGD5rukNuIIfK7801s5x3r2wApq
 +CaMdVM65wqsaWsgJk0+rsnLH792a4eC+tqRBVApsgK58OKi1LFwgulENLeK6a4F7c7E
 3/uqDaoApzoNFeEYmhpVUFJPd3aRFlfj+QbgvljR4b2YZKN2ce8oGBETkQg+nPLwpzww
 7sG6WBX5/bNJywT7yEEv2VhDpgKHxrUnOxuqX5LnKL4uKkWkuzVwVCnp7/UQ3F3gWiZs
 qUOb26ihMpDkT5PrPDB3ROfs5dzgfQJPc3Nr2vMS4q8V8FUIarWI8QQyUFtNu/1SbIz2 RA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phh8sr0g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:41:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OI8rRW003899;
        Fri, 24 Mar 2023 18:41:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk5n2g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb4dsaXwgVnDsiON7G5boJnMfeyjqitrhRcEGEgHFmKQXdibv/UlEkrGU65oocDYVW8PgENdmcc5gmqHbct06pahFYQfSIjTLUf1cPX9QvjpzGyoN2g02d7x35vEQrBastA5sce+zobWXJgMKfy+1VZGrUlqpc5j3bmxhEOJNbERG6/v+PcpiZ9VoOsYL65uGn8+E2jQBwQtr1ipS3uGSSTTevo2isu6NZfIb/uZ1tGZUVlwBky2t84ct1fZI6y2HZXqqJMTqOHW8GFwNYla2yXkcRHe1WqOftQlO5ZSihoYIQdRzEnmH8S+lwuIlEoFXhDgEHE3cZPWEzqy7gyBnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfQjFU5bngCwCWiJnND4pbYZ/d4vQRe78CCpuK4I06w=;
 b=f2zqwGztAT3QDOq+AUyH6fjrj/glgdObFu6XjRaEzBziToMcOJGcalOdCveJZOvE0xiyuRSFf8cBkDl6ylMXTVV5OsVN4X8rCnzTBFucKRz+Qenovzr92Fr1M+lzeGicjRPjepNnjeyhahCsMwb5/QKbB9RjsxjCMrxF6EDysDCVZ+BhNRl3UNw/Kp2hk/nYBAL5EfxMceE2aKSHoYs62DN+jHoqAGQz+I4hP4G6zdA3RymOQvayrPM3EUs893RSDcteYH9dMCWZTI7ODG0C4qfnGKegmiE4p7Bx13QmE6D0H4B6VL5aXtXOZX8DaluKIqi2kdGbm2obxdDUfZw3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfQjFU5bngCwCWiJnND4pbYZ/d4vQRe78CCpuK4I06w=;
 b=JG23M6i8joityMD6owd9Q0r/fTnP9rxIyx1hEAF8IHqeFbF/Voyf2OiJOghvW0Lp07TPg7MQatPh+vB1rhpfA72EadyTc4RkY+q/G64jprG2X9qSedhgcfH80im23WQYe03mz9L5Y6bkxjmkKYEJpPdek6IaXur6nPDiqpU/QGY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5633.namprd10.prod.outlook.com (2603:10b6:303:148::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 18:41:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 18:41:52 +0000
Message-ID: <e2b0a834-dccb-b8e7-4354-a2e803fb5187@oracle.com>
Date:   Fri, 24 Mar 2023 13:41:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v5 04/18] scsi: Move sd_pr_type to header to share
To:     Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-5-michael.christie@oracle.com>
 <298ce171-8738-1cd6-bce6-a846fb6469af@acm.org>
Content-Language: en-US
From:   michael.christie@oracle.com
In-Reply-To: <298ce171-8738-1cd6-bce6-a846fb6469af@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:5:15b::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5633:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d54955d-81c1-4b91-c602-08db2c976f1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbAjk4dZpDzyzW2zGVSnbrCaCf3ZlOcZOqW/HLW/RHUFUMUcEU61pkWXdoG1J6pNiseI08pIFqfavMy8EiGU4jBkwW2UIPotA1A+z1tXHF+bDu55yQwadJPSDyh7xbU8FsdCJNOqnEfPxKkV6x8YyfxXBUhQZaFSv+o6aeU1q1EedQxWTknduxI4YjvDiWcVCJ3UbhH/z6s6K8Shkvu/I/o2bQ2D5K2CP7iaWUnfYSkKXmgoY3bJClGT08v1lut4BfjWJPHGkAQsfGUOu/CMOEREmyOFwaMwdPgmHyA2SCY+vrvP9aqPebB6O4aCRuHyCG/a7awNsn4ir3NS+kllQ+s+pXYZ7qIgu7941XrJOUew6FqojHTNHeSXTNxcN2Lkw9kXgqQPblWJdVhnUd9ANnJb+mMxeqhI40WgDh+pNQhYA3KziiffNaZ7NK2K0HCJZYLFyQSJeDyU+U4s1zqnlnKFP4ltWDGlZbBiYYYo2opWTUvwz5CEWpOAggx0WxNr9T1/cTNFIjwMcNFP5oThbfb1MxMS4/f/NB5ftUuRqURUtlra7LiYMuTeYpEVlUn6lA1Kq7qhjT0zP80dv0oqRGv81CFYuMzmFjlgaLPhyRE622lDHENFD/K3qQPZalZR6VdXlIEwN8Z4XRMPjHcVSqxMksAZPk0NPT/V3FiFLLks7AXuWr+ldxkkwBG+NPTix78IfDckhnMIVrEZFbubP4xYZ6O+j2GDSYCGRsNsYOA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(31696002)(86362001)(66476007)(5660300002)(41300700001)(31686004)(66556008)(7416002)(8936002)(2616005)(4326008)(6506007)(186003)(53546011)(9686003)(38100700002)(83380400001)(66946007)(36756003)(6512007)(921005)(6486002)(26005)(8676002)(316002)(478600001)(6666004)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXFhbEg4bXdic1R4ZlVwVDhYSVFDSmUxa2NINTc5amtESC9MdEJLMmY5T1ph?=
 =?utf-8?B?SjVxQXFhVWJZNE4xL2tBaHdOYXBMWnRJRVl1MG5JQ3FvMm43WWFZZlBsbmF3?=
 =?utf-8?B?OGJkTTRxeGpjaDFROUllUHorVzFLa0FlbHJIa1ptaGtwUGQwdzg4d0psMm1l?=
 =?utf-8?B?ZVd5dGpVMGFvTy9CYmdia25UOTJwU0NPNFNaNHhwaC9oOHVrRElsZWRNWlJs?=
 =?utf-8?B?SHZyWS9QaCtZdEUzbzNXdHp0VUlvYTJ3OWZUZDBVczdXVzlON21LQmZaYlRq?=
 =?utf-8?B?cm94TzlJM09VTFNieS9GL3FLZ0pMNHZxOTBuMlZFM0RZaElaWmZNVzhnZm10?=
 =?utf-8?B?cEdXZkx2aW9PVzJTWXV6azNwNjB3dUUrVFFjQUtrM0tsY1J3K21Ienp5bXg2?=
 =?utf-8?B?MXl1c0ZNdmQwQjV2WHpTMEF1ZStRT3F1M0l5Rk40ODdYRm5tajdiaEV3VXhN?=
 =?utf-8?B?N3dIYXpiM3padTRaSjVyZGwwZ1pxNi8yVHM0SjM2K2N0NWVQSVVKKzJ0YzVG?=
 =?utf-8?B?d3MyT2h6c3ZKVThxbkJtak95bm43eVVhUzhoSzhFRG9Na0w3cFpRVlViSjF1?=
 =?utf-8?B?eUgxdSsxVEY1MkJmVUJ1UVFVWURjSXRSMEthcEpqajFIcGtUWkUzMlB5ZmZL?=
 =?utf-8?B?dFVVbE5nNlZYQlJLTktvbTF3dnpiVnJNakZ0UnhwamdQMFZUZ3lMSzVyOVJx?=
 =?utf-8?B?eko2YlRVYTBpU3BXcHVwc2ZYb051YXEvbDNVUHBGeW1jd3doMG1ndWNkRlZl?=
 =?utf-8?B?Z0hqcXdqM0UxVUZ4cW5qYkx4K2dSTkt3Wnk4TFlWQU5udWtqdm5VYVJ5dFJ4?=
 =?utf-8?B?RTUyRUpzdGtDT1Z3YTAyc3RnRFByd000NjZYS0tFakJLMlhxNlgwdk1BRFNV?=
 =?utf-8?B?M2ZLOERYSC9hTFp4ZUdETlIrMXNPUFFncVZIOW9EVkNKR2VJdDF0WGxaTnB1?=
 =?utf-8?B?YUNNZHVaWU5VbkdCRHUzM1pJanFvRXQxQTNOV0UzeDJxNHZIZkovZDZ5aytU?=
 =?utf-8?B?VGJGZFRKZ09UQW1VZDhOM0hkZnhpNW1HeVFjVm5OY1djZ0huZS9wWG5OaE56?=
 =?utf-8?B?bzZSaXhWYkN0bmVNblNQN2wwOHZWUEpkT3JIbzhFTldJaFFtVW1PVEltMDBn?=
 =?utf-8?B?TlNXcmgvQ2V4ZUw5K2t4V1NFZGh0ajhWb2hML2x4bUQ4WmdqMDZxcGcwRzNY?=
 =?utf-8?B?QTdlaWphQnFDbUpBRVY1dkpzc0w2cDJPWVkwVEU3bGJPSGF4K3RCeElwbVRu?=
 =?utf-8?B?N2lqNmh1VmJycWE4ODloSFhBc2U1U1h4bnBTcURHV0huYVJsaG51Z3F4QlBP?=
 =?utf-8?B?VUlzRkZYQk1GYXVNM2s5YzFTYm9LQjdKN05jYTcwVVpGMVh5UWdkN2lOUS80?=
 =?utf-8?B?Z294WndsVHhsNWY1NmFpeTRUd2NXVGdZbE5xdFpXcTFKcU4vbE1RQk1FSnBy?=
 =?utf-8?B?a1pIR1NqYnFrL0RyZDdvcVRTYUVuOGE4cDJJRkxjNVhPVkI2N2s1RXg1R0VU?=
 =?utf-8?B?RjNGNWdzZEl2cmoyV2tkOC9VbjU3a3pvSWlwRXB1U0ZxRmd3TU8veTV6OFV0?=
 =?utf-8?B?L1U5aFFndVBrWTdlR204K2k4ekJ0dmlTMS9JYitQUWNaaEx2UWErMmVBZGtB?=
 =?utf-8?B?L2h4WVNaNENBQ2cwdkx5ZGRVbkhPQk9LZWhIVkRMWCtTbEJLK2hrZWFUWVdC?=
 =?utf-8?B?YWUxaXFJVWozeDlqSTFXNXhMWGFEUnRIcDZ0TUE4SC9Dbnhqdno1Y3Q1QklB?=
 =?utf-8?B?bVJycHBYNFIrK3djeUdlY1Y2bW5uRUFEWnNzK3FBSk1qRUVuZ2Vwek80cGVx?=
 =?utf-8?B?ZG1GNS9CbE1hdW9UMHNKRVVEaE83OXBwaGhYV3AzemF2aGtOUTNqZTY5eDNp?=
 =?utf-8?B?OXdFRmJ6RU9VVUZmYUgyZlBqNEpyUWdmVHNuMVp6WlZMSzRVN09FWFozc3BT?=
 =?utf-8?B?c2R2Zkp0cUFKc0lPUTlXcG1Id3lGYVZiTHRLZTZvMFpIZVJGcHZRZEh4OG1q?=
 =?utf-8?B?VHA2L0RONG9LZGQydit4NmhBWXM2eW50WkQwTU94MENCd0dUSElyZStKaEMy?=
 =?utf-8?B?dlUydjR4QVFTb01YYXhvckpHK1NSa3NLZTFTSnM3YWlFY0hrT1JEQjFZUExo?=
 =?utf-8?B?bWtIWFJuQXBiRGg5em11WnVjZCtBM3kxc2UrUGZ1a1pWM3ZmaU1HTkk5c1Ir?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TDBMSDlaNEdEODN2ZkdBQWd4SzlXRGI1QmVKVmdFMGE2ckloenVuUS9UMWRo?=
 =?utf-8?B?STIwbm81NjY4VUxQZ2E0cHdWMjczSlMvZFdmYmFHMnk1T3F3UUd2VzU1TTA0?=
 =?utf-8?B?THVWUHJSMms2dzNOMGVNU05ZRDNFZHRFQnpMUzNITkRPUjdxUlk1TWtIVk85?=
 =?utf-8?B?UlpROGZBbmVVak5wOUVNZm9aL2cxY1ROa1EzRmtFdFRUenFGRHA1ZW9xYnNW?=
 =?utf-8?B?L1BZaUhSS05kYTNCVUM0bDh4Q056VGRGWXB4TUtVWVJ0bTRsVFBESHVLaVpQ?=
 =?utf-8?B?YUdtZmtob1pMWUt4QURHdjFXL25xZStxaUFTZ1lzSTEweHNHZ25GUGxLUldV?=
 =?utf-8?B?M3kraW9uSlhONW53QWx6ajFNRW1mYXNIRWdSbVZyNVAxK2hsM0dvRm4zSnhx?=
 =?utf-8?B?N0d5VkVETHJKNVVtQzlETEkvK2E4b3hUalFBaTZkQUVYTUJodmVzWGVRL0NI?=
 =?utf-8?B?RlozcVJSV0lQV2lyN3J4TDA5VTJINTNzMEFlZkZsYXQydVAxOEtFaWJteDVC?=
 =?utf-8?B?Ulp4QnVGSGJFNSt3emRnRG4rVG45UjQ0VXNWWWJJK1QvZlZrQ2VaWGVaaVhO?=
 =?utf-8?B?WkVHSlB4TDNOVWU3UVk1UWFSOHJUNlZ1ZG5OUGZwZFAyeDNtb1h4L2NMcytF?=
 =?utf-8?B?NkxZTmI0czgwdFFrVzRFMkFlaGxRZG8vSG93WCt6VTJWVThNQkIwSU1XZERz?=
 =?utf-8?B?REJtS3M2S2RaTXZyNXhpdElDUlVjbDlKMFg1YmI5dm5rdTNNeGJTcE80SEtH?=
 =?utf-8?B?U0d3aENMVHh2Smc5ckJTL3U4bG1QK0M5MWI2Yml4MUJZcGtwNVRGSDlMcXFY?=
 =?utf-8?B?Q0VITEFOK1BPbm9CUXRjb1BPWkNTYytUdnlSeFF5VUFqY3pZY1loVUZBT3hQ?=
 =?utf-8?B?ZUJybVRpTytUL2pSY2w3MEZ6aEJBOVo1YVlCN1gzdC92NnpVTUJhZHRFTVRa?=
 =?utf-8?B?QktsalBGQWs2MDR1QnVEMnhWa1hQSWdkRk1xajBpdnpZVHRVOTY5bXZhTDMr?=
 =?utf-8?B?eWdVMWpHNFp6R2V3bnEwZDB6bEZCbzhoUENFTm5GcXFLUkEzZWlnenVTM1Rw?=
 =?utf-8?B?cmZnSkFxekgvaFFabzk5YnZiNUNuMFA2UWtPRlF5K3NmN3FpVGhRTUlyUTQy?=
 =?utf-8?B?ckhUckVJMC80UkJCYWZXYzBaUlNIMFNaek1aQVZIYmhBRjVsNDE5dHJWUFJK?=
 =?utf-8?B?R1Q0VHo5NnUwL0ZueGlyZ0NqaCtkcHVmalpLT29QSFQybVhSK1B5MGYrV0xs?=
 =?utf-8?B?YkZYZ3BPaHl5UFpOL0d4OGxONFhYeWMxS3Baa29Xbnc2NzJxR1BvdHhGRllN?=
 =?utf-8?B?Z09sV1BWd2NhM21laUZVbWNhVDI3Wmc4eEU4cjhORW5WQ3V5YlRBN2VxVzhv?=
 =?utf-8?B?bDZuL2h3VGRIVWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d54955d-81c1-4b91-c602-08db2c976f1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 18:41:52.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqVX3ugQflH+AlAYBasqrE1hsIkCd4ajdlyOijSqw721GDWRPqSiDAPiWw293HrrM+0vlHeUNe3TMYmZF7kgy2lKQyg2XyVSkxW3QUiMecY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303240146
X-Proofpoint-ORIG-GUID: tuY458BjjcjPQmHde1ATjZhmmroq3rzT
X-Proofpoint-GUID: tuY458BjjcjPQmHde1ATjZhmmroq3rzT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/23 1:25 PM, Bart Van Assche wrote:
> On 3/24/23 11:17, Mike Christie wrote:
>> diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
>> new file mode 100644
>> index 000000000000..44766d7a81d8
>> --- /dev/null
>> +++ b/include/scsi/scsi_block_pr.h
>> @@ -0,0 +1,36 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _SCSI_BLOCK_PR_H
>> +#define _SCSI_BLOCK_PR_H
>> +
>> +#include <uapi/linux/pr.h>
>> +
>> +enum scsi_pr_type {
>> +    SCSI_PR_WRITE_EXCLUSIVE            = 0x01,
>> +    SCSI_PR_EXCLUSIVE_ACCESS        = 0x03,
>> +    SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY    = 0x05,
>> +    SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY    = 0x06,
>> +    SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS    = 0x07,
>> +    SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS    = 0x08,
>> +};
>> +
>> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
>> +{
>> +    switch (type) {
>> +    case PR_WRITE_EXCLUSIVE:
>> +        return SCSI_PR_WRITE_EXCLUSIVE;
>> +    case PR_EXCLUSIVE_ACCESS:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS;
>> +    case PR_WRITE_EXCLUSIVE_REG_ONLY:
>> +        return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
>> +    case PR_EXCLUSIVE_ACCESS_REG_ONLY:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
>> +    case PR_WRITE_EXCLUSIVE_ALL_REGS:
>> +        return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
>> +    case PR_EXCLUSIVE_ACCESS_ALL_REGS:
>> +        return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +#endif
> 
> Hi Mike,
> 
> Has it been considered to move enum scsi_pr_type into include/scsi/scsi_common.h and block_pr_type_to_scsi() into drivers/scsi/scsi_common.c? Other definitions that are shared between SCSI initiator and SCSI target code exist in these files.

Nice. I didn't know that existed. Will move them.

