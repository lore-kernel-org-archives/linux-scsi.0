Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAA2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 15:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiB1PyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 10:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiB1PyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 10:54:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A925011A1E
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 07:53:24 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SDIEAA030109;
        Mon, 28 Feb 2022 15:53:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i+Aq3KAyXl83HMaQHGiFnMxY3VvP+hv7BfGMdw5Idnc=;
 b=MvacmRfD+FlePSS9GlGEKlt11vhEWLi7CLDJde5C80FPJ7Fw7XHhbBt84NInNjpmhG9s
 5kOJONXFh0AgPT/Q7Orwrgra4yBwJDnPMZAdBoV5vloFKyDo/V/0wqXstNQaBDfs1bU2
 vDUESFJHty1H8hMGsbD72DWNR2n3T4l/QZxTiHFfZwgE72Dov52/SPfsrLAN9AD1acyL
 BUwNgpeMHaGdsE2JCF1hS2viYKJELGoywoMd+SLRE76AAPnizMPunKVdt156kFQiE6j1
 4BAfSmvbL6Lozn7xHZfjPQUJC32DrRJYQZc3CSZWPmkW8k2vFbhZhgvj6uuH90A9pZDV jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamcckju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 15:53:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SFkj7l114477;
        Mon, 28 Feb 2022 15:53:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3efc135pg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 15:53:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG/iRVzRdO2rrEpAS0nKONm0DwRxnSOIH+tdTNAAvxWepHZ2SMxamFtC/vEfic1lwHHecXeSQUfI+cpgbU3TXgWAG6dDGwiJ+5rU6BZhWbSMYPtOJLpyq2vDlYgD0HdgOH6icp8ELkSyBksOKEhgZ8n2SfFT2Gn88HBwvzPtE6pEoEAw3ldMJXxQM8Bp8NHsUvT47NjJahFbwUuI/T+YLAu+c84/FirCt1AaAbduq1fIbsOE769wHLPsddUhQBiPG5fz7L7MiCLOrhfQ3MEjAst1Ju9DA4YS3WsjE7BalBKCu+VpxCkvH/AmtvnyAz1qG0WHcGB0PVZr8upAkOBccw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+Aq3KAyXl83HMaQHGiFnMxY3VvP+hv7BfGMdw5Idnc=;
 b=NUbR6iECCyR9/ars1zZyPHjE79Ltt/8X43UD7GlGFi2mcw1ciX2DbKgQV4KXiZJja5MjfXMzhuOhCtvdHr7QJ0PAzElalXfBFlFwO53aTv/UCcwZ0cdfyvsqEFNwPNURs8MDlsBGdPQlpICrPym01WquepxkEwzgwgtxtWNof9sievN6OJz2Sha6B49fNjKCOBS4uRWYNs/4rakQPcXGR277SIL7s4kBS2q1POinFe7wreg+kfeyUJnKjbXYEAlThxA8biRj1/NKCq+PsPvfsCrRSP44CNaxmNfefh6EUXYU4f228EMrof2wU/mcbagXDTye8a3xAcAw1cRW03YQ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+Aq3KAyXl83HMaQHGiFnMxY3VvP+hv7BfGMdw5Idnc=;
 b=DuXdrtip933fIklmcSe8nbCB5jT5CjAnOA1dcGslGOG8IGNJw0nY2NrpgqrMjSo6PShX+sXP/6yDcGrA8lplj+wGh7cF6EWwFNmqWqku758tAzKKiO9ZmNP3jxtl/cQtYBtoHtj048gMBAtGFukXPHjJaTluA46UUUp+WWylUiQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.25; Mon, 28 Feb 2022 15:53:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 15:53:16 +0000
Message-ID: <0f52f156-00fa-d1a7-6816-a02a31816698@oracle.com>
Date:   Mon, 28 Feb 2022 09:53:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 0/6] iscsi: Speed up failover with lots of devices.
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        cleech@redhat.com, liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0046.namprd21.prod.outlook.com
 (2603:10b6:3:ed::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9025743e-abdd-44f0-0006-08d9fad26ecb
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15641679CD8939EFD69CF909F1019@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iu5Ow+2770B+USkWk7j3m8V+ai1ckp8FKNczKvclXXMuOicLjZKw4FV0Do4LFZOBICShsbIwD7N8z5jzZeFc6bN1QbjuP7Q70pFX5ytGAxw7KiDvuR3EsQ37UZYmixwsBDaTn9WtCPvwA8ZwiBe5Ls2anGK9KMh5JdcFboTrYlczpjcpQ0izkLkKJ5co+s4OUBNzHrtA+GL+VPNWvim/RlUmxxnVJTSrO24vQkAizAqLW3/eFYUhqUCTMBPy1WcBBQIhZ+vkxkI2PZ7SYesLmxpcWzJa5/MzEEOb6jKig8Bb2qvO/V9NHHCnlkaZCqgHyzTMW0OKh7TVfmYA3hrAejYuSoUn3FhMTbeRiBPHX36LbU5+xa1sZ9SyIv2fzih46DuTJiL5203kkEBpC4FHN9vBU7K5zzFajuNSlaztQWrd8I8y59lRDMQHJudPoXaxkMGijKNJUiN6NI7xF4II2xDqhFuREqEpZpti4OaqpZj93DMJQFX1MuDdBv69+tGC1Zc6TAJdE0GnDgwW1tlFD+gbCrraHIqqPdvH7HhyrIpX/0TW6IcS6h6iI/z0EBaQmqcff4InughKs4wYPVJ4u4f68h/ZII30KZCSytGUj6fT7JDEs89VCLNejbDUJCOMv7yn+nO6SzjKpJDGhGdohhIz2waXu4jEf5RAPFRh93yAqtW9E34AarZsJOUOWQcGzNjnEXRJk4KT45rhcrOrA9/Gs5YpYaIDr56NItO0xlw7cpO9AMwPN75U3LsxaldzeOyCDdfa7OBArk8pIEc8Kffd+FXa+Y5bysksUHC+mQnBdnMkEp117shP39pMDuEE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(508600001)(6486002)(36756003)(53546011)(6506007)(316002)(66476007)(8676002)(66556008)(8936002)(38100700002)(66946007)(6512007)(186003)(31686004)(86362001)(31696002)(2616005)(2906002)(26005)(5660300002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmhSNytnRWt4alZZbHZLRU9NM3RJTnZlRUF0Umt4NWFxOWZTU0UzaDdPZ0w3?=
 =?utf-8?B?WW1zT1MyWEVzRE5SRUlmMDYydzAzcU9rV1NMVTJiTVBNZFQvTmhIeENSaFZa?=
 =?utf-8?B?U2NFUmVuOU1GQWp2YVA2UlVmbGdpVys3RlVoSkozRmdaL3NrQkpxSEhLWWlZ?=
 =?utf-8?B?amhaV0lkME1IbEx4YUYvb3hleGp3bENMVGNpTmw5WGtHU1orTHlNWEdYZ1Jw?=
 =?utf-8?B?YjIxUVVKS002YjJ2ZW1XNmFaemtITnV0WkczL0VjUmtnYUR0ZkdMMDlvZGQ0?=
 =?utf-8?B?bys3WDg3R0ZRbmVUN2o0b0Fud3NrcFJDSXlSNnh4bUhVT0owT2x0OVU1eFRq?=
 =?utf-8?B?VnE4MEtQL1QyZm90UUdqK3NndWdzcU5QT0RrR1N4cG1WblhDSmNBSFJCei9q?=
 =?utf-8?B?clNVamhFTGFKaC84UlF1Rm1PSVUzOS9MTExIeDkyUEtNQlI2alZ3UC9ZcjRt?=
 =?utf-8?B?SjU0RStyUmZMdW80NEY1VGxuYmdaeXlFWmhGVXljQWNnUnlTdUpIcjZqZVpy?=
 =?utf-8?B?VWlyUkNyb1VTZ1FBRnJBZGFXcENlU0FsK0lwUS9KM3RIVlJXMlF6bitnTHh2?=
 =?utf-8?B?QWxUQ0FyaGRWNXRMRlBMWmN4NXQyZ2tLTHUwSHZ6M2ZSR0xzSXdTeUtNY3RP?=
 =?utf-8?B?cWN5YUF1UThwUThEWGxGOHV6MGRNSlhuNkNFZkZSdGlSZ0xCQ1A2ZVVKWmFu?=
 =?utf-8?B?S2NXMlcxZWI3S3BNc2lyaG9mdEN4UlRITWh1WThOSjlXaEJuWDZVMFNSVFc0?=
 =?utf-8?B?S1JIak51T21KSWZmV21IYmhQUGQ0TlhxWGljWmE1SjJYMXM1K1NOeFVoRDhQ?=
 =?utf-8?B?K3ZZM2hvcEFKWEdpd2ZWcnlUNEgwV1V3dnJJNXlSSTIvSXppWDJjanhHS3Nk?=
 =?utf-8?B?WlJPamM3RisyZjBDQ1VUTXNnQlZaV0ZzMzlUdGpTNU0wYjJaMGZQRkVmRU9j?=
 =?utf-8?B?WDVCM3dQaExZaThsRzVJNmNsbFY3ZEQvQmMwcHAxRVc3dVlONHBiWCs2R0FG?=
 =?utf-8?B?V2FiSEF2TUxSRjRXVFUvVWVVRWN5cGJrSUxid0JHc0l0WWcrR1ZxRDhYYnlY?=
 =?utf-8?B?TkVxMHAvcTRIUWFmRDNtTWpvOGhLaEhzTVJHU2JwQWptN1dTSkptYmlnU2V3?=
 =?utf-8?B?M3hwc3YvUHoxNzBUS2lyeWl2ckp1TDBqS0F4RHBreTY0OGZmZTNvdEQ3aWZ2?=
 =?utf-8?B?QUZ1YVl2cjc3K2c4Ky9kdzZGUTRCVmdEWlpRc0VsTUJCYXg3dDBmbEhxOU8v?=
 =?utf-8?B?WVZaNTduUDJ5citpS1d6RWxvejcyMkovNHpzMjZOSWdtNXk3Zm1LMnZsNmEw?=
 =?utf-8?B?ZDhMMnBCUEpZcVRQTWw5akpLbWxOOXpSSW1BRFZKMzNKdll2djc5R1RsRGoz?=
 =?utf-8?B?WTFIUTBGT2VMYlBYUEIwKzdxa3NhY1pMQnFHbG4vQVVxSXVKRDF0YjhCazNP?=
 =?utf-8?B?NC9qTE1tcUx1YWovWUFOc0oxV0MzbDJkTCsweitseTB1T1JSRThwVDU3UVY0?=
 =?utf-8?B?eEozQ3JNN3c2b3ZqQ1lUMTh4OVhDSFZrQTVWdDRwaTZaMlVKdzdSa1pLWUJT?=
 =?utf-8?B?TWk2bXUzUUgwNUF5ZGJUZHZQbEI5M0JaRHR4d3I5QjZEbjRwL0NPMEFNTE9o?=
 =?utf-8?B?UHQxS29TWmsvUFFUV0RXV1RHT2dzMGR5YTRDeFMwTzdWa1cwU2N0WUUvWFdh?=
 =?utf-8?B?Q2hZeldPeUU3alFwWEVOU0RHclBJeWVkVU1iZ2NkVllpQm10cFBVQUdaYlN1?=
 =?utf-8?B?Uzh0YWdFZ1MrNmZNeDd5aklMeGxVeG1NSnBxRzdsekpoWWNEQlpTRlQzYlB6?=
 =?utf-8?B?V3ZoVVdwRnppK0JFR2F4NldCbkhzN05XMG5va2h2alljbTllQXpDNHY3UVB0?=
 =?utf-8?B?NUJOd0ZzUUV1Nll6N1RwTFdKV2ZqOFFoY1BDNjBucGFDWEpESkhBK2pBWTk2?=
 =?utf-8?B?OEc3akVXVFczdUJwTnJWZVQrOFdCRkZZL0hrZE42ejQ3WlhXMnNxWW1Pc0ZE?=
 =?utf-8?B?cVhzTytKWkVuNU9HTG5SY3NOVFBpQnFPVU5HTTZCZmJKRGMxUndLeHlHOXZr?=
 =?utf-8?B?aVhwNFNoMlliQklZT3hLQ1p6TXhpRXFUdXRaK1lpUXkwUjF6bkhDQmJZcTZq?=
 =?utf-8?B?aGk5aUhZTWk5L0ZGbEZpdkNHQVYxblU1UmJLeUZmM1IyR2c3SUVXcFFvVyt0?=
 =?utf-8?B?WDNNUGJmTXdSKzJ0MzhQYWJVc09rSFNEeExrL0hSQXpPVHJudFM5NE5IN1c2?=
 =?utf-8?B?cHE0M2QycmtEeW5UaXpFR21jMmpBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9025743e-abdd-44f0-0006-08d9fad26ecb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 15:53:15.9759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yb9ohnzbWgNRfQd8WzWiew4HCOfZ5IHZhFyI+Aq60HQhAZl1gvzy8nstaRx3I1exkhbDkqPvpr4g2X5NOAQ/kug4/Ks/cjW6eYyUcY2Axc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280084
X-Proofpoint-ORIG-GUID: hI4PA_0nEBewWU_VEo5GdkJdVbCanhF5
X-Proofpoint-GUID: hI4PA_0nEBewWU_VEo5GdkJdVbCanhF5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Lee,
On 2/26/22 5:04 PM, Mike Christie wrote:
> In:
> 
> https://lore.kernel.org/all/CAK3e-EZbJMDHkozGiz8LnMNAZ+SoCA+QeK0kpkqM4vQ4pz86SQ@mail.gmail.com/t/ 
> 
> Zhengyuan Liu found an issue where failovers are taking a long time
> with lots of devices (/dev/sdXYZ nodes). The problem is that iscsid
> expects most nl operations to be fast (ignoring mem issues) and when
> the session block code was written blocking a queue/scsi_device was
> just setting some flag bits and state values more or less. Now a block
> call will actually handle IO that has been sent to the driver, so it
> can be expensive. When you add in more and more devices, then a
> session block call will take longer and longer.
> 
> This patchset moves the recovery and unbind operations to a per
> session work queue instead of the mix or per session, host and module.


If you get to the end of the patchset and wonder if there is a patch
missing, there is :)

I have one more patchset that is related to this, but not required for
to handle Zhengyuan Liu's issue. I think I can also kill
iscsi_conn_cleanup_workq and use the iscsi wq instead, but I want to
think about it some more and test it out. And since it's not needed
to handle the issue in the thread below, it should be ok to do
separately.

It might just be a simple kill iscsi_conn_cleanup_workq and use the
iscsi wq, or I might be able to go more invasive and drop some
code. I'm not sure yet.


