Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0297ECA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjILIuQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjILIuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:50:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BB410CB;
        Tue, 12 Sep 2023 01:50:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7h6fe011029;
        Tue, 12 Sep 2023 08:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7Bg35gm+HeQGHUrrsbIsCZipkPdgNl0aWAUgmOUx7GQ=;
 b=jnC3OXtQVieeeWZhu1YqPl5bsaQWWJgfPsod/pRqEVjWCI9tJxicg4et50C6MPhUzkoL
 9DAoW9fDuVIjK4+cGq1rr5NHAEfcUc/kan6IYcrJ9OmX24t8BQ2Lng24kSmPx7ZRX8ZW
 w1+iQBdRWZ1XlmV6fGfiInMW3OzqoDh+6GuYtKkvuixXvPNLYZu3gSa0WfCijE1AfniD
 qAyqraxIeB4R7kG3GwDxWSoBBCGmWGvxRFlmAkLxV0wwENo100GKuo20Bqbk8BXiKzU9
 LntM0pTqCJgfeYdZPI9cWBRp5xVYv80g0xkD3D7RbRNblUm29i3cwZ99RjWEkOB5H0ou IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1ju1uf04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:49:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C6hbJY002372;
        Tue, 12 Sep 2023 08:49:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5bppqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8K+zGDBm+EvIFSvOBuM7rFRLo+VpuOLmTX/fNN5RP++x333YxcD6jI7nUJU+3b3TBVUdYZ7MCqxnpeQuyCc6a2w+/7TtOeVEuZEnWBSt5f1hUCU6WkBsdG83xFQqYtGwWC/vD9pB0VLVoHt0ITJoRaIe5IjfT8BcHqrkNmYUXZN+wsv4Xfrbb2Ss+9hDvq4pDr/Ly6mjlmMEnA1m4AkGw6ii6J7CyZ7TT8loIRdIU/9utPCkUmW32MGbrmdgQ/6O6W1h0/74hT/5zuPPu7OJX0y92Q8G/muciBRu4CcvwLQ0qv3aBpxjgLkL1gLqweUZuRpkPQhlP3Tvzx3mwrwAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Bg35gm+HeQGHUrrsbIsCZipkPdgNl0aWAUgmOUx7GQ=;
 b=eVTCUprJDh/jclefFSXqW/bJZNJSy34woxs6RFqzs5sWv2z3/HnwSHe5chkuiW1IT2POYtKGWDlrr1QaJwvv8fw5k8/tTxTZ/BRmUMq7xpCtJkU9pL94+7fdNzqho+ScqJpmwN5llW19tMJSbqnebcouncu8XDLqyB/mqo636Yzx4ZKOuIM40MK+wPv+7emcqZznoE7bPfvnVjmyDg6fS+IcEe9bNB75KhrgUH3oufhKee5kTbWvrFW9+ixFrbImyin8hTsIAie2lGxps5iXVbbNQEY2amsYXpgffk0zdqJDcI1ulXlNdInPbcOTMq0QRhXd7vy0rdD8mwJp8SogMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Bg35gm+HeQGHUrrsbIsCZipkPdgNl0aWAUgmOUx7GQ=;
 b=HbwRqHSQn23NgU7xGMJKA0X5PyXl+1ko2DByOx7oU4rDttpjLJN2RFPwkk66kGLIf7LqaOGqJDiT6RcF0PlSzuNbRTM8q6cpPS+mtOCTm85AtEbHCQ9/KZszTQ7MRCk/DNQPXOjBGUzY71uBefvopQP0otTBcwU/+W8nHMsDkFE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7531.namprd10.prod.outlook.com (2603:10b6:610:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Tue, 12 Sep
 2023 08:49:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 08:49:51 +0000
Message-ID: <bb89fdf9-7f7a-c7ee-7295-edbb4563dd2a@oracle.com>
Date:   Tue, 12 Sep 2023 09:49:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
To:     Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
 <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
 <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
 <b3af36cd-a126-24ac-739c-5d1a192c2b2b@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b3af36cd-a126-24ac-739c-5d1a192c2b2b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0301.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7531:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d2e75fa-075a-4211-213d-08dbb36d3a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TidF1e+S8VEvAnZszGW5XcouVXeLZTFZlMwjzHo8gSmW3u0MlmvEr0Y4TsJeBcqlQ5UR++3gqoeqQyKYgamSVW2DM0SyqIOgs+o4soOSs4wQqgHvhL9itL6yEjLMzB+y60ISyrudCFb7l/tVlBC9e201ZWQV9bNSlnrwk9yAdJXMal8X55I636QG/OGkoOOf2xiwgHNZz3nPUtwBuckKxcS148Q+BA3qVTdbeVYLDVXX70TZAcLEuwB3OtJ5PEfgLrZZeaG31qsh3RCCEMtjqAeQItWe8R56cNJumZkvbuavg7rEDct7pm8QEQGGEBUa57pwkKFI/WosOzFMITJDWct83CIGAEmpZVRKUEYb+0N+bapk1z6ZCsZg4PnoJ2zo8+G0g5ThANNzfrKxNuaz+Ixg16Xk90C+m1EokZVvQ2CSithS+Rgb1lg4DN77xBIChloHO8E8S7ayfJPDCc84xR/Il8tbJGfUv8cqhCRDKsUqy01ISRWC0XLV7M0sFwq2RpRP/O7DUo5VKE2mKaoIp0Duy8SlcnB5mx61U3IP/gmVd8cZEYDCu9sBEvt1XXHE7OjM9kUrWuKKGbKjBp0ZK3pUM00vozJ30pPYGUnWxTM7fC/CfO5x28A5csV+gxMZRN7+XtvoeV8sTZuJHRcQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(346002)(396003)(376002)(186009)(1800799009)(451199024)(41300700001)(54906003)(66946007)(66556008)(110136005)(66476007)(316002)(478600001)(38100700002)(36756003)(2906002)(31696002)(86362001)(5660300002)(4326008)(8676002)(8936002)(83380400001)(6512007)(2616005)(26005)(6666004)(6506007)(6486002)(36916002)(31686004)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emxReHR4WkFpYkZ4L1dVL1p6WUlXUWdocU5Cb2xlY3VxYTA3RGdUQkRudW9N?=
 =?utf-8?B?RmNNUFdZWDVYcHRoalhud0FnNkkrRVdvMzVuaUxselZkNlVFRUxjempkZjZh?=
 =?utf-8?B?U1orbjRZWGcyWkJ5L2E0WitRaWZtc3MwUGJUcWRQTFZyWkpOMFY1bVdNeVNR?=
 =?utf-8?B?aXpGSUYxcHFxNm5iNWFnSzU0YXd2RWt3Z29FSEtVREJ6WjkyYkdSN1gwd1dn?=
 =?utf-8?B?RlZWNGJyOGpxN1oxUWxTSVJnV1dHQnA0L2RHb1NXN1EyTU9KYS9oVVk4b3JN?=
 =?utf-8?B?WmgzNzdnbjF4cWFCNGluZTY0cHljYUI1dCtvK05xUlNkWXJaSHlwWUpRa0hj?=
 =?utf-8?B?V24wRTBub2xJcW5yeEpFK1VQZFFBOWdSOWRIK2FsbDdEbzJuMEU1L2VyY2p4?=
 =?utf-8?B?b0I1OEV3NWZ0TXJYSHA0NkFaVXZkbURzQWxYSmw2ZnpPMDhvNDhiZ05rY2V5?=
 =?utf-8?B?cWt6RHZtbEhFQ2VlOVZ0RE5UbW1zaTcwTElqSVVIY21ZbkM4TmVxSC9YWHZZ?=
 =?utf-8?B?YzBxaW96M2NKNk4rTnA1dFVsR2hJSlQzZzRlV0hjZTFQWTlVM3lRYWlyR2RT?=
 =?utf-8?B?cENFVERVZkFtR09abXliOWpZajlnbVpURnR1UXBKN0ZnWEJralVCVmRwMnFr?=
 =?utf-8?B?Y2JTMVNDTUY2aXBZR0lGTXlFT1UwamdUSEUvVVpiNlcyM1F5REhQd0plcnl1?=
 =?utf-8?B?S0dNTjZBZDA2eThtUlEwVWdmRmRWeVdXMEhEUS94SkxQZnNIUUZVZEsxY3Vv?=
 =?utf-8?B?TTB5NjRkbkxGQ2svS1lDaVc0QW9DbUh1aGtNM25CN0lKMm54RnB3eUEwM2Fk?=
 =?utf-8?B?OGVJa2VuejB6S0NDM3k3WFhvVkk4dVJOZmdSems4d0dxWmxqS2xSVCtidUhQ?=
 =?utf-8?B?eVpYRTN5YmNXT29yQjRSdHVYNEpIcHp5dEJ4SWJzakx0YjkrakZaMi8wUU9H?=
 =?utf-8?B?MmtFbFUvNHFpRUNYOXdnUlFUMmJaNkhxR0tBclZyYnBZd29NRVlhQWw3bXlo?=
 =?utf-8?B?em40NmkrOHliZTRDNHVmZ2RydCsraHFzc3FTQnd2aHRidU0xd1RGRW9SR3FV?=
 =?utf-8?B?aFBBZ1pJbmphQVhzdEdDOXl6aFNqUUk2OWZxd0ZRRGN3RXNwNWREWVFSbGhS?=
 =?utf-8?B?bmJYS0xHTGZPajhteHU1RE1RaExXazVVMVYxeVJzQVpqWXdVVXVqaWQyT0ZK?=
 =?utf-8?B?M2Y1eTl1ZUVyZ1RVeTJ1elQyMVdDdmp4aHJYS2Q3YWhSazNLZVFXUDJJTVlp?=
 =?utf-8?B?bjc5bGJaMkRvdjJUYlNBcEtCOERPQnZWdEdtd2pwTUo1alIybVRCV3dhNEtn?=
 =?utf-8?B?cllGaU16enZ3VHdxZXBMTXJRd3RteGxkdUFWYW9mK3FqNXVGWitsV2F3dFp5?=
 =?utf-8?B?aVhpSnhqQ0k1MTFsVEwzSHNsTnAwN1lKdkdiZDZnY0lNTnF3YVA5KzZMemQw?=
 =?utf-8?B?V09wbTRJR2ppUlhnNFNwbEhJMmtjU28xWXE5SkVvVG1tMGdhd0RjLy9TVEhI?=
 =?utf-8?B?cjRwdjFveGtSdzNyUG1kNEJFRUtPRW5uYXIyN1VBNk1yRU1mNy9RTEdTQ290?=
 =?utf-8?B?Q3NYVlowenJkZEtCS0dHZlUyQ1hQNDNLdmlwMlZaQTZsTDB4MDNPNXZaMys2?=
 =?utf-8?B?dUNzL2NrSitqNFpESk9nN09sRWlSR1c4dDF3Vzl5V1VLcUNiTGpLUDBjZUJx?=
 =?utf-8?B?clFNUFFKN204NUpNTU8vbWZXWmlLOFJTMVFsSWQ3c2ZzWjF4cEhIOXkrNHND?=
 =?utf-8?B?S0Z5d3FZLzNUUXBueEc3STJvL3N4ZXN2czJaYmxrWmh1MnptMlpldHVsb0ky?=
 =?utf-8?B?bDBad3BVQ01JbnJmaVZ0K09GdHRFbjZodlFkV1RPb2F4Q3hxZ0ZmaEs3R2wz?=
 =?utf-8?B?b1orclVueDU3UkJhcVRXVDJsSlpqaU50Y2dYSXZWbjBiRmF2eU1CL29NNE02?=
 =?utf-8?B?Wk5GVWcrUG5ncUM3RGVoaFlrNE9ldk1sUzZiNDNoMXo5c05Na3NIelV1RGNU?=
 =?utf-8?B?WTFIajJWN2d4Qm5ucmZEcEtMR2dyRG80S0s1Ulcwd0d2clgrWGU3MkkxdldV?=
 =?utf-8?B?UXdMdmd3Y1BKMU9UeUVmR0hCOFNJTTZzUmFESEd4b0dCWStSZEdKYk9PTEQr?=
 =?utf-8?B?eWxtYmdiUmxzR204SytkWVFnZlU4aGk2eURBQmIvWC8yaEF1VUdLMUlnUm00?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?KzluMXNpcG5UUUtQSXlaWWppQlBnZHFUMEhhem1xMnRFMkFLb0s5YlZTMnJr?=
 =?utf-8?B?dndPVTc0VzN2Q1BkbmU5UktMR0M1c0hNSFNmSHZ3bVF4SFd2bWZQU0xjdzE3?=
 =?utf-8?B?MjZhQWo0cWQ2dmNyS3lua1lrNXN6aENEVEpEQTRuNnY0VzJQQytQeDNJNGhC?=
 =?utf-8?B?cVE0ZERNK0l4WjQvdk9uV3l5TWhMMHZ5RTc1VWhPRzhjTjdUdVJaVk5xdWdq?=
 =?utf-8?B?YWR1WFNEMEQ5TEpVVUFXOEFDTVJzT1dyVFNTTGFOVkl5WVFLTnBWRHlwWjdZ?=
 =?utf-8?B?aGFTczdFTG5nUE13WUtrVkZyRWdSRENMdkYzNGppMk56T1VMQWFRZTdEYW9z?=
 =?utf-8?B?TXRUTDNqS1IycnZEUDhFTHF4V3Ntd2w1NnNNYVZmRHdvRklKNFZ0dkFCUDQ3?=
 =?utf-8?B?eE0zTi94NFErSlJ6Zk9mT2NFb0xUazZod2pBcWRocTFRZ1lUbjRRaWFWTzA4?=
 =?utf-8?B?TnF1enNveTM5eEVnTFY5RWlrTzlLcm8rdmxqZU5UL2MycWl6bG9JbEpxZ1FY?=
 =?utf-8?B?L0VYb1V4ZHZuTjBEa3Q2T2l3QmlrRVplbTl3cVhhckxEdjRyUEhjN2wrNlJR?=
 =?utf-8?B?Q2pjdUlIWWtMelZhTlhCMDZoeDlWTENqK3lwSEs5d1ZpK2lHQk9KTjVwMEoz?=
 =?utf-8?B?RzA5bVJaU2o3d2RMZk0vWnZ5dkxzY25qZEpFNzJBUHYxMi9uSXVPLzdBSUJN?=
 =?utf-8?B?N1BwMmF3RHVJUmNKNjhVQ0NINTlxMTJsYlR3aG1mU3NocTlqMk0zY3NwRGJ1?=
 =?utf-8?B?d1I5dlpjck5saXNjZ0lpdlUvT0xCNGFvNmRBWmhHa3dKQW42WUx5MGFkWjNz?=
 =?utf-8?B?bVNQU1gvaTNzczFmVEZYRVhtdExvUExaM1J1RG1jTWJDdjVKQXJkc3JxN2I2?=
 =?utf-8?B?WXJEY0lhcmNTTVk2SHJtVmtJdWlUL2QrZWc2SHF2c1pCUW1jSC81UU9aY2Q4?=
 =?utf-8?B?NUZsUVczeGVKZW5DU2tVNXFJMTBraThBeTVueGRhK293V0Z0RnFSNWxoY2dG?=
 =?utf-8?B?VmRZK2VjZStwbTJKOWZ2Z3NveTdJR0lzL043ZGwwWkYvTkpwSkd2WENvakI2?=
 =?utf-8?B?bjdsTmQ2ZHBML2M5REowcGMzWUY4R3ZNdndFaFh3Z1RhWnpoM1lXUzRrY3RX?=
 =?utf-8?B?bHVQaUJmUThnU2U2eWhmSUtrL2V0R2VJSG5SRzFwQ2VKck9KalZ0MXEyZWhM?=
 =?utf-8?B?TmN2S0VpNDVIbDkxVDJMRXFoRFF1a3k3NXhVbXNJTFZxYlkvdXUwTm1GVjNs?=
 =?utf-8?Q?9efsZkSCyV+YkPn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2e75fa-075a-4211-213d-08dbb36d3a2e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 08:49:51.4088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZXnov9Mubr5KEOnfoARzdq9QCqqkQA9Fq+j3/VF0qCw/+CARNriQb4/BdesGk4Dz8+EmniQxIKAPFUso6dm0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309120074
X-Proofpoint-GUID: ZVHucBZSwfbeQoaWy_XQBKhpjwPvjnr-
X-Proofpoint-ORIG-GUID: ZVHucBZSwfbeQoaWy_XQBKhpjwPvjnr-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/09/2023 07:13, Damien Le Moal wrote:
>> hmm... maybe scsi_debug could be modified to support ATA devices (with
>> libata).
>>
>> Regardless, I'm happy to check the code change which you attempted if
>> shared.
> I had a closer look at what the hisi_sas driver is doing. The link it creates
> with device_add_link() is between the scsi device gendev and the hisi_hba->dev,
> that is, the HBA device.


> So nothing to do with libata port of device.

Correct, it's just for the sdev -> host dev link

> 
> Trying to mimic what libata is now doing, I tried this:
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 12e2653846e3..91d76258e6ea 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -624,6 +624,26 @@ int sas_ata_init(struct domain_device *found_dev)
>          return rc;
>   }
> 
> +int sas_ata_slave_configure(struct scsi_device *sdev)
> +{
> +       struct domain_device *dev = sdev_to_domain_dev(sdev);
> +       struct ata_port *ap = dev->sata_dev.ap;
> +       struct device *sdev_dev = &sdev->sdev_gendev;
> +       struct device_link *link;
> +
> +       ata_sas_slave_configure(sdev, ap);
> +
> +       link = device_link_add(sdev_dev, &ap->tdev,
> +                              DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);

I am not sure what is the point of this. For libsas/pm8001 driver, there 
is no ata_port -> .. -> host dev link, right? If so, it just seems that 
you are are adding a dependency to a device (&ap->tdev) which has no 
dependency to a real device itself.

> +       if (!link && pm_runtime_enabled(sdev_dev)) {
> +               dev_err(sdev_dev,
> +                       "add device link failed, disabling runtime PM for the
> host\n");
> +               pm_runtime_disable(sdev_dev);
> +       }
> +
> +       return 0;
> +}
> +
>   void sas_ata_task_abort(struct sas_task *task)
>   {
>          struct ata_queued_cmd *qc = task->uldd_task;
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index a6dc7dc07fce..82c6d8e1e8c7 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -58,6 +58,8 @@ void sas_enable_revalidation(struct sas_ha_struct *ha);
>   void sas_queue_deferred_work(struct sas_ha_struct *ha);
>   void __sas_drain_work(struct sas_ha_struct *ha);
> 
> +int sas_ata_slave_configure(struct scsi_device *sdev);
> +
>   void sas_deform_port(struct asd_sas_phy *phy, int gone);
> 
>   void sas_porte_bytes_dmaed(struct work_struct *work);
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 9047cfcd1072..b6c419aa563e 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -810,10 +810,8 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
> 
>          BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
> 
> -       if (dev_is_sata(dev)) {
> -               ata_sas_slave_configure(scsi_dev, dev->sata_dev.ap);
> -               return 0;
> -       }
> +       if (dev_is_sata(dev))
> +               return sas_ata_slave_configure(scsi_dev);
> 
>          sas_read_port_mode_page(scsi_dev);
> 
> This does not change the drive discovery, all drives connected to the HBA are
> found and identified:
> 
> [   52.974154] scsi host12: pm80xx
> [   54.445986] sas: phy-12:4 added to port-12:0, phy_mask:0x10 (50010860002f5644)
> [   54.449019] sas: DOING DISCOVERY on port 0, pid:423
> [   54.461108] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   54.465601] sas: ata13: end_device-12:0: dev error handler
> [   54.618588] ata13.00: ATA-11: WDC  WUH721818ALN604, PCGNW232, max UDMA/133
> [   56.295486] ata13.00: 4394582016 sectors, multi 0: LBA48 NCQ (depth 32)
> [   56.306849] ata13.00: Features: NCQ-sndrcv NCQ-prio
> [   56.320849] ata13.00: configured for UDMA/133
> [   56.324504] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [   56.340346] scsi 12:0:0:0: Direct-Access     ATA      WDC  WUH721818AL W232
> PQ: 0 ANSI: 5
> [   56.347160] sas: DONE DISCOVERY on port 0, pid:423, result:0
> [   56.348161] sas: phy-12:5 added to port-12:1, phy_mask:0x20 (50010860002f5645)
> [   56.351291] sas: DOING DISCOVERY on port 1, pid:423
> [   56.363285] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   56.368788] sas: ata13: end_device-12:0: dev error handler
> [   56.368859] sas: ata14: end_device-12:1: dev error handler
> [   56.522903] ata14.00: ATA-11: WDC  WUH721818ALN604, PCGNWTW2, max UDMA/133
> [   58.402015] ata14.00: 4394582016 sectors, multi 0: LBA48 NCQ (depth 32)
> [   58.406207] ata14.00: Features: NCQ-sndrcv NCQ-prio
> [   58.420254] ata14.00: configured for UDMA/133
> [   58.423222] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [   58.438869] scsi 12:0:1:0: Direct-Access     ATA      WDC  WUH721818AL WTW2
> PQ: 0 ANSI: 5
> [   58.445619] sas: DONE DISCOVERY on port 1, pid:423, result:0
> [   58.446687] sas: phy-12:6 added to port-12:2, phy_mask:0x40 (50010860002f5646)
> [   58.449803] sas: DOING DISCOVERY on port 2, pid:423
> [   58.461732] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   58.465369] sas: ata13: end_device-12:0: dev error handler
> [   58.465426] sas: ata14: end_device-12:1: dev error handler
> [   58.465432] sas: ata15: end_device-12:2: dev error handler
> [   58.622345] ata15.00: ATA-12: WDC  WUH722222ALN604, LNGNW1TZ, max UDMA/133
> [   59.540468] ata15.00: 5371330560 sectors, multi 0: LBA48 NCQ (depth 32)
> [   59.588217] ata15.00: Features: NCQ-sndrcv NCQ-prio CDL
> [   59.697588] ata15.00: configured for UDMA/133
> [   59.700514] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [   59.716067] scsi 12:0:2:0: Direct-Access     ATA      WDC  WUH722222AL W1TZ
> PQ: 0 ANSI: 5
> [   59.723838] sas: DONE DISCOVERY on port 2, pid:423, result:0
> [   59.724893] sas: phy-12:7 added to port-12:3, phy_mask:0x80 (50010860002f5647)
> [   59.727852] sas: DOING DISCOVERY on port 3, pid:423
> [   59.739699] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   59.743344] sas: ata13: end_device-12:0: dev error handler
> [   59.743402] sas: ata14: end_device-12:1: dev error handler
> [   59.743405] sas: ata15: end_device-12:2: dev error handler
> [   59.743429] sas: ata16: end_device-12:3: dev error handler
> [   59.898839] ata16.00: ATA-11: WDC  WSH722020ALN604, PCGMW803, max UDMA/133
> [   62.348080] ata16.00: 4882956288 sectors, multi 0: LBA48 NCQ (depth 32)
> [   62.353731] ata16.00: Features: NCQ-sndrcv NCQ-prio
> [   62.370011] ata16.00: configured for UDMA/133
> [   62.373532] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [   62.389238] scsi 12:0:3:0: Direct-Access-ZBC ATA      WDC  WSH722020AL W803
> PQ: 0 ANSI: 7
> [   62.396642] sas: DONE DISCOVERY on port 3, pid:423, result:0
> 
> But no scsi disk added: >
> # lsscsi
> [12:0:0:0]   disk    ATA      WDC  WUH721818AL W232  -
> [12:0:1:0]   disk    ATA      WDC  WUH721818AL WTW2  -
> [12:0:2:0]   disk    ATA      WDC  WUH722222AL W1TZ  -
> [12:0:3:0]   zbc     ATA      WDC  WSH722020AL W803  -
> 
> (no /dev/sdX device).
> While not printed on this run, I often see messages like
> 
> scsi 12:0:0:0: deferred probe error
> 
> No idea why... I do not see where that comes from.

It might be related to what I mention, above. Anyway, I would rather you 
don't get this series bogged down in libsas issues.

> 
> This is all with pm8001 driver.

Thanks,
John
