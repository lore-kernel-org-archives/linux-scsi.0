Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9D0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 16:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351130AbiDOQeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350753AbiDOQeC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 12:34:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2139.outbound.protection.outlook.com [40.107.92.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF432985AB;
        Fri, 15 Apr 2022 09:31:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RixedP9FrHeucZjcNSbC8lO6paQPSOFr/JB6CwvhH5l1vtGa405TXQYIiu9tZUTZYa7Db+zeFQAOPNxmsc/D2Li+V1z9YYqRfTtulY/gcfLhmJw8xB9FtKaxKyFiUQA4POgu9FwmXf1Jyzu6bZ8rAgQfZ5lTdV/uT0UQRbEnGuKwd9e0pqLChffUw47vGiIMJjft/SqDOuvcX7f3zHc3+Ie8cbFCWnmvmWsYg+KJMjnR8JyE4AK00Dl+nw3zFSDyJfQGu75u2iaWqUoRgJHhU7sWuNCNHMJwUcXxdi6upe85DGlfhegtIOhal2+4CHeioBfsDgUnIYPVquUGbsERpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkLlqBulU++Q1CeexRfyzGKmiCa4j5ESTIx7DZKme6k=;
 b=oYz98bmIvqBJIu5gvGh+3u0uCMdNTOelV6+E5NgFOlsuNbziwQUnnsUAc1Su48EXrDxSyqP1Eb6JKdzH4uWezZRAVrPV+kDsZ599cnyFgT/1DjoHR0ENhDZBAr5B7aRn2mGCKs20wsYOuIVM41Mfi1/hGStUYKSjlplKq657KT6z+px67PSDZQPewrA07ehW20T8cCJd7IhuM5FaaSdTCB5ahTgCEdwSkRISH+oOivsTFa5hxFlKFEVY/okvhTbb72E973VCeZbS3mWM+0iSREwHfF7geJzc9y16h556cq3dI41ogXti9Ig++4sL7kgnG8XB4h2TT136AKXAZovLcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkLlqBulU++Q1CeexRfyzGKmiCa4j5ESTIx7DZKme6k=;
 b=mPwnpSjM9ZmYPUKgkh8vGNZjfFmRWLVurh2B+C1RFkdWMLE2DRIblXeM4t5J2yEgja3i5u12F7MDtrPZQ/6UsD7kZ8WeUWeTYsxLCi+sv1TS27bjUb1nNvpUvQTa1s+Qm8YJpXkf6xlJW8Z5G/oShjzoT3rLUYK437n8DBctuFdsJ8WsLylHVpWO1XeCGNpg6w8HvBxxB9UmV5PFU5FWDUy5Fn9gR2d0Yhv9nOJinRjnu7XR9suX2EbnSN6XytsdenAj2hhfWcv0yRbJ9kfxZRLoJu/yMhe/k0S10p3MHEJGeG3NifLUSw/6m9QA62zfUk+SLGn4Ih4HJEYLA/dEpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 BN6PR01MB2801.prod.exchangelabs.com (2603:10b6:404:d1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.26; Fri, 15 Apr 2022 16:31:30 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875])
 by PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875%5]) with
 mapi id 15.20.5164.020; Fri, 15 Apr 2022 16:31:29 +0000
Message-ID: <5df912ea-8a24-29b8-4ce3-b5be0356ce36@cornelisnetworks.com>
Date:   Fri, 15 Apr 2022 12:31:26 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: Problems removing ramdisk backed luns
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        mingzhe.zou@easystack.cn, Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com>
 <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23c32123-58b0-4565-d039-08da1efd64f1
X-MS-TrafficTypeDiagnostic: BN6PR01MB2801:EE_
X-Microsoft-Antispam-PRVS: <BN6PR01MB280132DF8EC0E65BED542BCEF4EE9@BN6PR01MB2801.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/8SPvQ6sSEYJXoRjeW0sLySdk1MMq3mtY4qU9T3aksW1QuxEl5OOTq4XxYc34QlAYDyq5GSuE5U+ADwmETgg2QSjcONEw3s0bgmJgxf0a6b2JtTyo+4Eo4vhqQ0LsTkmXCHYtYqda3dbMOeqm8nCChJktNkjgtuZGvLDVY98kkLvxaivnKkkLk/VRQ76Y7iLzQHK4/jgFjtqlxanNjnvHLSagKbW+nXtx3iVjl5XUKaVjwrGZUnf966ZzUFoF9rloq//WllRYTJrsiaJ6kwUkJJSDQffO5HCFrqSPBrP6CNCnnwQT6ajA63gQK/qzEVJAi/KidD7oIrG2959+EjkNwLcgj1sLbQNysQTQ9b3zEWivLUQETE2bXZVyQyQhP/S/SnpL8wd7dE0lZvGODiKv6pdZbaSA2VFPW7CWHS410+vFYw8nBTMov+X4g4fqigN97Va2SqKwX/lyokx5KLWjSv0sDiznRie4W9SbsAUO56c3GdWeHIdo5CyJqVnKd7H7nqZEx1UFhiIDxYGSJ2gj051hZEEg3C6Y2Vny5OsnusXm7h5YGTTf+l1mcbm2BQzcTcsnoCNofoH6DIWYYf6Mtm7LQYOvhxT6yp9I673EagRXaCb7LbbkphTlqK1qsx9Td4FA0ylf7CwSd8kDheo5XLqByPGeqodpYWMdj4fva95Cv91H68kCjrbpToYjmaoFu1LDa60e/KLpZ6pr4/iL/ziHbsukIwmMnWKVUY8df+ZWRzQ8EtviLpPRq6hn6QxeSIU//guiRdP2jaD7ReCqoizLlNTvVUEMQCRFWP3Qy4RUXH4VH9EmhRtSuwV31p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(136003)(366004)(346002)(396003)(39840400004)(6666004)(4744005)(53546011)(52116002)(6512007)(5660300002)(36756003)(44832011)(86362001)(31686004)(966005)(2906002)(2616005)(508600001)(83380400001)(316002)(38350700002)(38100700002)(6486002)(8936002)(31696002)(66556008)(66946007)(6506007)(66476007)(26005)(8676002)(4326008)(186003)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkZkOXpGNUoxSXFSUU1KcmpUbkhLdHVkWWp5b3hPajdtajRrSUk5T1Q1WTFH?=
 =?utf-8?B?MVhESWdhUVpvVjZ3R2llZEsveTArM3N3dE9pSzM1dXVqMTJNMWdyYVFPZ2No?=
 =?utf-8?B?Yi9FVU1zaG5wYi9EMm5YQm5UVGpiVlcxdHUwbk94Ry95eFUyV2U2NGNYNW54?=
 =?utf-8?B?ZVlqNko0OE4yMXQ1aGZ2eG5KckFYMFhlUU5tNFRJK3NrS3ZycG5UdmJEZFNw?=
 =?utf-8?B?NDdZczdPZ3d1MUQ2WDZOUzBNSDhIV1g2dkh3TEpRK3laMkFnNnQzKzhBWkJx?=
 =?utf-8?B?VzdDaFVXelBObkR6dUtyZS8wMXhUTEk3SGhoaEZkc01yaWd1YmQwdDNSNVlj?=
 =?utf-8?B?SXJGcFZrUVJhT1JCeW9HUmNsMjAvelE0a3B5VGdDRExoZGgvSGh1UERyNmlK?=
 =?utf-8?B?aU5WN2tjSDRGNE9GMmZvdHNqb0RzMkJSRFdCdXI1cFVjbVJ0c3E3dGdRVUNP?=
 =?utf-8?B?T1lkYTEvbW5EcDBwYWVuMU51MWtuL0Y2MjNxbEFDSnd1c3FPQ3B4cVdNNHd4?=
 =?utf-8?B?bWJOMUlaR2RuSTNweVFBNnBUSDZSNXhxNnlUK0RQZUlsUm5ueGlOeTNXMVZQ?=
 =?utf-8?B?cnEvelJiM3BxOVZvVy84aUxLTDgwcSthQWtoUTVQSkVjSWhIaTQrdVNPUUVN?=
 =?utf-8?B?aEhHSWo4Z1hpZ3F6eGtqVTR6b0RmNDQrcUhBRmNIRWI4eHpnZ2NTeVBuait1?=
 =?utf-8?B?Z2dLV3Mvb09NcHNQUmcyRld1L1MxZWFteFJtdVdlUWN0Y2doa2hGVWdJdG1I?=
 =?utf-8?B?dklaVU1kNkRndGhEVkhlZjVncGlJeUgvYU1mSmdldllrTCtLdldQMnRNVkto?=
 =?utf-8?B?bFZJUytsVXp2a2ZiM2NCWnFOTzZhWW93eGxiZUFTaHpIWUpmLzVwTHorSmtC?=
 =?utf-8?B?ZEFSRXdBTmdQaUxmUUoyZnVtdXArbkc3UmtBQy9mQ2hydnhJN3Jmd1ozUkMw?=
 =?utf-8?B?c0IwY2hiRnVhdGNhZkdwTXNiaHNaZnZyZGcrU1o3bW0reHJnV1paUzNTemdW?=
 =?utf-8?B?QXNjSEdocnJvdWhvbXQzdHIzbENoYjVqZmlGZWdFbzNyUHgxeklaMnB2Z0Zr?=
 =?utf-8?B?ajhQdTZ0Q3QyZGdsQkVYMUozTDBzYXRnaGRack1kMzFtbWFvNUFwWTJNZmpl?=
 =?utf-8?B?Y3lHbzBxZks2aEludFhhTDhKVGVXL0tpeWEyTGlYbmw4VjBPTUp3akk2cWZG?=
 =?utf-8?B?V3VLekh4QkFreUJNWjI0ZENzdCt6OW1JeEZpd0xpL3BzYm5vVXh1UlpQS0Y2?=
 =?utf-8?B?K0dqZjV1NWVyK1NMZWlPMTJ3SVAzbUZZaHE2dThjZHFRQUNVNmNuVnpBWWh6?=
 =?utf-8?B?a3BzWHg1RUsxYXcwQWJFSDVVWi9aNytXalVYZTFaK1VhVzBwc253ZUQvNkhJ?=
 =?utf-8?B?THFuZ2ZvUlFyMi9YTUk3VENzeG1SZXVrbExRT2dxRkVSVVBMaTlWaHdBcSth?=
 =?utf-8?B?U0JwQ240QW9SN0c0NGZvODBUV0IwK2M4dkpxdlVXMlZsbWlQKytLb2E1UHJy?=
 =?utf-8?B?YjVYZTl6ODd2dXliRHNzNWpHV0k0U1VqOHZEVmdLMlR3Yk1DT3M4RUg4Rmk1?=
 =?utf-8?B?a0FOUWF1VXRwMEd3QVg3WUVvR2EyUzZKUzZOOVl5LytjakVGNDJLc2ZDWUJN?=
 =?utf-8?B?NHJGVmkvS3hNQW1XeHM5RGt5ZEcvVGRwbFJ6N045WWxtQmJQS25SMk8wOHN3?=
 =?utf-8?B?N0ZXSmVraVFXV1lhQ0MveEExaklwbTBjMCtldFZKMVVLcUdoOUxYZmhNaTNK?=
 =?utf-8?B?YmVQbnlEVFVkaE00NUx6N2dXdkkraHEzcnRnbTFVa0VtTm5LemFuSkY5V2tX?=
 =?utf-8?B?YjFpOU5qcUdvL0txQWtNZTRSNnpONFgwTHZnbi9FR0w2UVE4YlZ5S1lQMFQ0?=
 =?utf-8?B?UWhGZURyZFB5RWdSVlpvSW5xczVyTTFXQ0JRRkdVZDFOUS9ic0xQMzBncjJG?=
 =?utf-8?B?WXA4V0NOQXQrRlBnME5ubGFDTDBZaWJhU1NuazI2Mm11NTVmN2pKY3d1YVhZ?=
 =?utf-8?B?QTVQN29vZVlrTGhEcmRuajNWU2c1OW5ySFlHMmloTFR0bGlBcXByNzRRZThq?=
 =?utf-8?B?anZwQVAyeE5abElldzZzUHNyNnFuc0lrNmhLaFJ6R21Wc3ZlKyttcGpYelVB?=
 =?utf-8?B?ei9tNytrYWpBeUFlc1pabjBQT09qM3htUUJxeXo0RVZLa3dmK0s5TVl4Y1ov?=
 =?utf-8?B?WkNOQTZGTXc5RjY5azdHUjZkbTA2NTFHbi9MWkc5cFl3NG9DOVNtMUovT0xH?=
 =?utf-8?B?MjBvNUJFTWRsMHNVRmt4K2xHY3hUUnJ0eEdLVVFyVTFhVUJBYkt2dTdIdmt2?=
 =?utf-8?B?QlhnTDFhWm1uektHcnA2ZklNSmVFNUxESDcrdlhRWjcwemYvSlhjVmJnMm5J?=
 =?utf-8?Q?UoVsbqWg8fA79VLWlwhup1nTmjLgo26CZpWhl?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c32123-58b0-4565-d039-08da1efd64f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:31:29.7193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82wDC5BFn064/x1ETQkmAJOaneUMevkRi2oXdiErbQwK7yt87UORQnIhqzmHeEbdEImrqz+vOVjrku+jc+asG+TUHxxlhMqpCX4nUB47ZWGStYF5M9jexVcJYKiYVWvi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2801
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/14/22 5:14 PM, Mike Christie wrote:
> Ccing Maurizio.
> 
> On 4/14/22 1:05 PM, Dennis Dalessandro wrote:
>> This all seems to work OK and it appears I can do I/O to the LUNs. Then when we
>> go to tear things down:
>>
>> targetcli /iscsi delete ${wwn}
>> targetcli /backstores/ramdisk delete ${lun_prefix}_${lun} <-- ERROR
>>
> 
> Zou fixed this in the current rtslib tree:
> 
> https://github.com/open-iscsi/rtslib-fb/commit/8d2543c4da62e962661011fea5b19252b9660822
> 
> If you grab that patch and are running the upstream kernel you
> probably also want:
> 
> https://github.com/open-iscsi/rtslib-fb/pull/184
> 
> which should fix a warning you might see after you apply Zou's fix.

Ah great. Will grab those patches. Is there documentation somewhere on how to
build/install the package? I'm not seeing anything in the README. Looks like the
Makefile creates a tarball, not sure how to install from that.

-Denny
