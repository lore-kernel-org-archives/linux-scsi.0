Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AAAC76195
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 08:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjC1IuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjC1IuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 04:50:02 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2068.outbound.protection.outlook.com [40.107.249.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECD646B7;
        Tue, 28 Mar 2023 01:49:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQCDb7R+/xjCntzgJNoEU4lPZFCr65SE/DfX6HcTngK4VXxAlfMxpoXCyHAvbgsH+ai8VdqV1HYeASim11xcBSPIm9HGN5F9rEtBoVCYmBQFKbbAwi3H8yx8Ahl/i8KnCIPa3Ratodm8jEv/F0FcXr3Jot2rbfp8NsuPdmjGHQGctXk3YlNC0MkDD/4RsxvZJn0uaBllp0KL1lSNFfxjQFsmkSh1GhOROawh/Eexv5jCrT0lOUEdipv2/psuoes/8u/UcBMO18fev1g6ixD9Qk03lBi+7UbqvoxNQD++3tyC9LB+J763wZi37BEtJZx4HxNt9FErMi4hWDLAHgYHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6YRyz5AoY9qIqIrOdutnc4VK6EgGycdISiwawQbeWMM=;
 b=dL+4/RfCJjPN1zjy639qKu6mZrzjWLObq6aACjamQm4slKslqaN8F63MM7G7DwyRX3FwFkkNKrH+g1JhcPb/Q/pJTH7oLJYMfxvSsbT8E0I6an7Z6/KLoV52e83o/9n9VU7kOwPraq9L2qdjsYP1/OU8pUdgTOAmi4jbaOe0IRcx5vwLw0I+Nzi1+/l7LEGNKEcBE3tS81LxM0bC9+WcXwZyBoFWRNiGlg7ZjTZyt1z+SyQHWXYwvSe0WymDxzSiAktPHLzr8NOlCbcYb6GAGjmoTOh8TYYZyqcRQ97SELxzdG+IV2iWn3AXa9228VHF4Pw03FbuS9C+xXGCrNVk7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YRyz5AoY9qIqIrOdutnc4VK6EgGycdISiwawQbeWMM=;
 b=B1rHJ05ypGjX+8ilxcFSCLQVuB4CFDGnqmDNP5Nc0mqOgAZIdjNzxPYm/kFraQJEZrxVV/UnS6lyqOYsJ86lhU3LGT9cyRKMbumAOI2WuT3mDNkq6q5bxBHwpo3iD+Zfnh8bVsYge6+2h+t9lZsuEmTNHgQZKVWbiYMa6KO3t8Sob2rIA+kueeflwdTHFvwkxwuCB+odPW+9syzzu5e0OSqVTjv66fOfXMPDD4Rr5UXSq2ZX52IrmiP56oP1ra8HS69NNleSvJ6ecg4dxkTDv+BjFhrCy92WedMkHPEFQkoFA4EqsaiRiQve+I98DNVulAU8ToD1U4CIUVQMkIbwkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DBBPR04MB7545.eurprd04.prod.outlook.com (2603:10a6:10:200::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 08:49:55 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7])
 by VI1PR04MB7104.eurprd04.prod.outlook.com ([fe80::2ea:4a86:9ab7%4]) with
 mapi id 15.20.6178.041; Tue, 28 Mar 2023 08:49:55 +0000
Message-ID: <c5890408-3723-0ead-6d9e-7ab7614d8392@suse.com>
Date:   Tue, 28 Mar 2023 10:49:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: UAS error optimal I/O size is obscene
Content-Language: en-US
To:     Stephen Samuel <samuel@bcgreen.com>, oneukum@suse.com
Cc:     linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
References: <CALp1NBjzaCkqcHnW9rJ-o5iE2weU-T49vxzLjWirQ1T7c6CDGA@mail.gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CALp1NBjzaCkqcHnW9rJ-o5iE2weU-T49vxzLjWirQ1T7c6CDGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::13) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DBBPR04MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: bc16705f-4fed-481a-ba07-08db2f696731
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Traaq6izTQyKauAfWw5ZrxCqahfOoW6XCJcLtjbxq2bM6XFtaHaEEennjp1rQ+7vaVSrxyIuWpCwoyO/yzz1j6I353OHarISC1fxk4M+T13NVmGaxELBYV4yrM3a0nV+Q1bR7RcVwYwbbmX8FLfy+HRimbUv39hK1Y4Ls0boIClvi7VhnZlRwO/H+e9XOJ2fwF1SgcobubIzi+m5G2MJbExG5dNxnfks4x+QgeslJCtdV41GGAlSt6GNwCFSkVkofhYBhja0xavXvOYa0IIlNQesss8l0Xfxh6+JqUuaew1fY74LPtmWUQq2wx4Ox3NSX0P/wFJuAxasdiG5O7M5bv3pBCrcKL5Oe82K1E6wJfBu+kDk/KjZ1PWMCOzPLoR/DaDFDkyTuSMfiugYxc7/3cF6IZe1n1gd2N8vcNgC/kADjlNjTsLHj2bTIQLvPbmYcEGQflk9/OfX/+fOHlP8OaZMILHY5cyd0cl5JC9dO8wKYM5meRkVVsCEGlOaLXpdRyteUBZT80yHI2OtJmbx4Rkd4C21PFzL00I5FPMTnC9oRhcxIyXGMyg70pPH61uhaeFMJEQClRWY0AvE04/lhNwgjiOa+ayYDAY1DyufYVjGX8SJh0Ib6D1TVEDTk4Je72AnVNdyBRhXdVl3Dezudlw4fsukSF6nYP1GPleX10Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199021)(41300700001)(66476007)(8676002)(66946007)(4326008)(66556008)(186003)(2906002)(36756003)(5660300002)(4744005)(83380400001)(31696002)(38100700002)(86362001)(8936002)(2616005)(478600001)(6486002)(31686004)(53546011)(55236004)(26005)(6512007)(6506007)(316002)(194693001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGpWRURkRTZaclhJWTlDSkh5UjZpU1p3dUhQa3RzbmFsRnh0RUhVVDBnUkFL?=
 =?utf-8?B?YkRid0ZWNmRRVGVBZjIvTStMTnZIWWlqdkRaSzZGWk9LclhNWkswTWZmUHZx?=
 =?utf-8?B?YVpGdWdvRkxjcWpJSWh5dVpOTHRDT3RUN1NwcVpvSkk4N3c3RlM4R0dHc3ll?=
 =?utf-8?B?RS9zZWF4WWJFMkNEeTRhOVpyeFFuczJISVd0RHMwd0NOalc1czVpUWt4dFVI?=
 =?utf-8?B?UjdrV1RSREFvZXI5VmU0dmtrTTVnOUtxQkU0Z0RiZHRmTTAxNnUwR2VnSlAx?=
 =?utf-8?B?Qy9BUGo3Y0RYTFozZVB3aHlXQWV4bnRaQzlodFJUM3grUDFvWUNBYXdEWW80?=
 =?utf-8?B?K2ZmMnR4bG9JaGVNNjJCT2RTVnYyOW9tK3NoazN6ajloZFNMQ1JMcU4xZ1E5?=
 =?utf-8?B?TEhpY0dqQ0g3aFVXR0lKVEFDNlZVNnNIU2Y2bmVIckZUREJ0b0EwQUwzd0gy?=
 =?utf-8?B?SXkrMkJuV3BkZ0FSMDZQVzFhZnJ6TEwyK3V6Zm9RRmdEMW1kVEVHMUNWa3hO?=
 =?utf-8?B?TzhmR3dhWG5ERlNPTVpITVkzcFQ4L2RyVTFwbkplUDllVWVlU0RoTjlKb3VQ?=
 =?utf-8?B?UGYvcjNQektiZjI2aks0dHJCemptQkVvZmowK3dIMDFvY21XVW1qM1pwUldv?=
 =?utf-8?B?ZStOcTYyQzVMeDN0S2NYaWRwc2lBdksyZm01a0RjWnRxcWFWV3V2V0c3RGtH?=
 =?utf-8?B?UkN3UXJFNW1jUDk0b3lyOXNKRy9xVlpDeGQ5Q3lDOUNhb2g2QmlZVUs4OEhQ?=
 =?utf-8?B?azZZTnhQWHhOc0hsWko4VFZ2VzJMdkdyMGlxLzByck52TExDVVdWZmhZR09o?=
 =?utf-8?B?R1MyYmRhZXI2OCt5WWhHZkVPR1JWVGo5dG1mUjNQWktkUHpDZTQ5anpyaEFQ?=
 =?utf-8?B?VWlmUDJLNE1LWjd0TEtCTUkyZU85bHVvOHRXOEZtSDhKZGR2UklLMTUrN2Ry?=
 =?utf-8?B?alJKZzFoNlF4KytQYkZwVVVuVXBRcmZjUVFQN3VoRDFUSEFOSnBoWnZTekhB?=
 =?utf-8?B?QkswbGVmR0t2eWlRaUVVWXU4YTJEanJFeDRvQVpjQmhIS1Jrd2o2aWxEWldK?=
 =?utf-8?B?VHROREZpelArb2VrWDNDeVlIRTBMcjdzbTdvOVhQWk9ydmN5NU52N09XN0Zk?=
 =?utf-8?B?MGFUeElQL3FQMUU1em5JZDdXMFJDc3c5a1Vhazg5L1V0WFJMTkRhZEJrSml6?=
 =?utf-8?B?anN2OFFKcnk5TTQwbTZ2b1VsK25DVU5Xb2RZOXdDbStCZjRyeFBpaDFUbitM?=
 =?utf-8?B?SFVXNk9KQlVUTjhrOGtSc1owUnFOQU1wN0V5Q3d3aXRjeHloMDJoeFBYaEpQ?=
 =?utf-8?B?cjRBTnNsZzRpUFNPQUVyOGljemxPb2JDVlcwZUtLSWUzSkU0MVR2eTJ2dFMz?=
 =?utf-8?B?bXBhcmFqVDV2dU9rcGdvWU04RHl1NGhLRGV3ZFlQazZxajAxSHpkaEE4OGhD?=
 =?utf-8?B?cmNJSU82ZWhsMU1YQUZUZ1dtSVpKNU51d3lvMjRVYVIrK0ZCY1VsbW1remt2?=
 =?utf-8?B?aTlINFJjUEdLeFdUMEdQTkkwamFGeDMwK1B3eGZCREN4bHhHQ1JVMFp3VEVO?=
 =?utf-8?B?UlFLS25mK0NETFNjdzdkN3J3ckgvdlByNnJmTGZyVUZjQWxXYThvUUpFVUts?=
 =?utf-8?B?dk1uaHIrY2NIRjlnTmVUenU1UUJlbEpvMFFGd0hIZEFxNmlkRFBFd2M2RnV6?=
 =?utf-8?B?a3ozeXcvTGFWTjdNRFdKS0NIVk5mRS9FMWl5R2lkZXpsT01ZTFlUUkZJR3A2?=
 =?utf-8?B?YmMzNHZEMXBuK1VwNFMranUyYlZPbDkrT09TOGNQWDU0cVNjdjQvWXoyUXNu?=
 =?utf-8?B?VHVmSWlkei9kSTVQcnJrY1Yrc0xaSFpXVlZ6L0trbEhlem9KQ2J0ZncrVEp0?=
 =?utf-8?B?cXBQTkZXNmdJTlVlUWM4WUFnajdFb0dYbkdRaHRzN1U5bm5vSVBLUXdGVldE?=
 =?utf-8?B?YWs5Vmd4N0VMVGszNERjc21vUGxUaFl3OGdTYy80SXZwSXJjRVJyWDFXOHZW?=
 =?utf-8?B?c0k2c09OSkxEYWY2b2ZHcDkxWURFbVpFeHAzZGFaR1c0MytRTXp5cEx4cVlL?=
 =?utf-8?B?NURBdW1ZUkxHZWdVMnlsczVLYmpZR09mdjg3M2k2LzFiNmswN0hlbkw3aEpD?=
 =?utf-8?Q?QPBI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc16705f-4fed-481a-ba07-08db2f696731
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 08:49:55.4471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqlc5vp+Hea4ZOAbwqlyx9kIJLUtw8Jyk5qNiOtwP2OkiLqkByZo0o/bGxBACZLO4X8JOgbk226eiUhSIi0GXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7545
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 26.03.23 15:39, Stephen Samuel wrote:
> Disk /dev/sdc: 74.52 GiB, 80000000000 bytes, 156250000 sectors
> Disk model:
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 4096 bytes / *33553920* bytes
> Disklabel type: dos
> Disk identifier: 0xb66b1d61
> 
> 33553920 comes to 65535 512 byte sectors. I believe that there is an attempt to assign -1 to  what ends up being a 16 bit unsigned.  This number breaks things.
> assigning zero instead of -1 would be consistent with what happens when UAS is disabled.

Hi,

that's plausible, but we need to know why that happens.
Please provide the full dmesg.

	Regards
		Oliver

