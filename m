Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4D0EE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 08:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjHVIJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 04:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbjHVIJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 04:09:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C81A2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 01:09:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M1RlPC024095;
        Tue, 22 Aug 2023 08:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=aAipSdf97wS9hptHVvDeWj7AvAcW36XI0p0ARONmXkc=;
 b=ibRb9LBQSMA2Sw1NZ5fpIg0xmIJ/H87A0Mfzc90lcK6ElR4XtF+ymxqoPl0iJAaYJl9B
 JAg5adi582NCEmz2qVKJE9hSANzGIUri6Uu3xPeVUMpmrmmP01Q4fsUi7iq4tT46AdT7
 wwfnKaumCdOwK8PdrrEniQvHm6JyVf6QdhFJhhbW98UVK/Mm13Cav59RFo9+g8yW5AUQ
 E3zDGx6nOYs1EAKbVORSoDix9xg0PJyHlf5ZtiTsDbgyluUW25XlZ0SVHqhq8k2ijAX7
 o8BGvJhW2ligPG0OdYaZMpb6wSjCjo1XoEqI65gmCr22SLnSerDodlNj0MyOxzuWsUQn cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnma4nas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 08:09:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37M80NsN030429;
        Tue, 22 Aug 2023 08:09:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm64hmqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 08:09:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmDZK3K+tgRIJzvhYP9wE4lw3KHxqtpQ2ZHpdWe4avKCzYzGt5TPunBIGaB1JY+vcmoqnITTarvvhgMcHp+C6kTaR6DD3FOpExJ0Fa2PAPP0SC7+LGt3DIye5YbPhWKeZR5HdH0x2+M8DBKKHECnUrsgdd3y0eCEk3V95NDq1smqk4O6aJip+CCycYeY2rZZwrdo86e/OeuS+dDe8V1/PaYvz1fFruN0HIXpdTc02/eS5WkEwEtZvCp2m8LJ9UDT/JufDN45uVwjalmkd2Aj1Ayy4BmJDC4YTg678FRm3oh5jGBt7O6ZVgLXb8Jm5ysgl7Ozsg4xwFcrE8WUmeN7yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAipSdf97wS9hptHVvDeWj7AvAcW36XI0p0ARONmXkc=;
 b=QaPAzQ29pC0rJulufS9Y+2el9SqBjNWnTn/RcdQ6o88FWkulo1fu+90boLDZew+6xEWzcbdTPMtoleDvLVMa32aeB/4TC3f+RA39sYnpiJiG4AJ3NQFjOvsZ5ZESeuWd4v5k4l2xCxC37GUWc1aml3ljnV4MYDxKrktRIM4urI0KR9Fck39rC58xPjPcory6Qm5pFegwBG7y+lB/9eWwVp3+17AjcYRWIVE0Zj4x7Zlub7PpeR7VaseOvx9FzHhmgngjlu0kz6jQ0LrgBEubxQayxa5fgU1HuroN9/grw7yAeqf+crkc1GKc36oozPu7JXLUPwDNYbkMCVa2HqrkfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAipSdf97wS9hptHVvDeWj7AvAcW36XI0p0ARONmXkc=;
 b=JN2EJvG6d/OlEAkjlreh+rdSFRgcLesxdUQGmEWDt7lvy+ZKD4Wfb9f7BRrJEYufEhLTEP8pHAMnh5uqdJezJCfmkKjDHHx9H6UQ7dCqbn+xv6DB4Df6jUYjI2LKTN5SiXO5yEiC5ePn35v0O2C2+jlR9JqYJLU8AvXxGewqNk0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6673.namprd10.prod.outlook.com (2603:10b6:510:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 08:09:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 08:09:06 +0000
Message-ID: <083ed8cd-537d-47c7-c4e3-6318e407ceae@oracle.com>
Date:   Tue, 22 Aug 2023 09:09:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] scsi: core: Improve type safety of scsi_rescan_device()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230821204009.3601639-1-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230821204009.3601639-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6673:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c94d8e-4651-4d15-17d1-08dba2e70e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Dun2dM7RWNxRM+aOd32FN2Zbhxvm+KEds/SdNBABXJERVIb+jYUCcu/bC2puoCtAgfhcd6YUHF7CpgUzMKj9Ksg3I6yFhnLg74iiRsOQd8PDm7ILb5pnAjkP6sNT+L4zImVEY1Ozr+E06rnPo9LqgBEAHFl0sdJIhSMEy1/Qt0wpa5ofFNEjoZpWYpWszwNAwffZ9MabZxQMjNsZH20BHnvNm9LbVVYUYccY6aai88BzYlVjr2uisLa3TGj80CjhQOznv0H46h/SANV8EEVCjjEBS4qoBVmr1khhcg9JJ38P5zezgw2GzoQXpo8pEnGunaVSi0F20tN9pmR+qUzeQ7XUluIdPkQmLZQxypwBmcy9Mbe4l6hYbGa6vrMCTnHJFPz9xCQ8xCdk2eT6CDs0AMqDv59NuzsncxH8ZLIxdE4JR/Np5YHKnw94I5KIvJcbQDTZaT3NrijmzDYVS7E/lcNU4fTVuN0idMwnuvWZvITPJSeViqc7ORZ5wkSbZCjbjnUBt/+GIDawq5PGZ19BtihyMmcCQcS8tL/8oIfTiqrwmJKV8NNM42CRakI/ynyAR79Jwssc3mPzyk/XV5cUc6i44di3DkJanhCD5/aczlBATplmRcn+y9zFIcdYCrGEqTVnd9k0vUez9Im7KB2/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6636002)(66556008)(66946007)(6512007)(316002)(66476007)(110136005)(8936002)(8676002)(2616005)(4326008)(41300700001)(36756003)(478600001)(6666004)(36916002)(38100700002)(53546011)(6486002)(6506007)(2906002)(7416002)(83380400001)(86362001)(31696002)(31686004)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTNmSzVnMnhQU3lZbm81Z0RjUFBNelBMdTZzUVJHOGxXU05wVStRdURlcXZI?=
 =?utf-8?B?bzdtdWxORXNLWmtSWnJRcWM0enRBczFVYWpjZGFwRWI3UlRTVkZ5MjNHWDEv?=
 =?utf-8?B?MndoZytHbDFaRVJwQk1oNHJid0hrV1dCcnZnUlB3SWhtWW9GS0JMeE5QSVJk?=
 =?utf-8?B?ZmxaOFdrRlJzR3ZIS0RYVVRuMHhobTVxc3BKd3IvUGtJU0FtMmNWL05UVHlT?=
 =?utf-8?B?OFRKYnRtQjR6VGVZdVBFYzJZZzdtRUdBS1RIZ3RqZ1VJVkFTL1VjazB2WmEr?=
 =?utf-8?B?ZnUvTEk0dlRxckpnK0NZaUJiK3VBaDZ0VEk5K1h4ZkdCeE1xNWZLc2xHY0cw?=
 =?utf-8?B?YkpiRDRWV09Hd3hMVXBSeHJiUk40S0dFR3hoM2NJekdod3E4MW16RnJMN2dF?=
 =?utf-8?B?blhEZW85OG53K3FvdXFNYXN1SGRrVXdueFZkSFpEZXQ5NGhoU1YvOFpPRkRr?=
 =?utf-8?B?U2JlWDhiOGwzamtuUGVnWWpyYWVpczBVTVRCTFRnWTlZUE44OWZMNHEzZGxG?=
 =?utf-8?B?bFAyRGppRExVTEZxVGJ1NmwxaHVwTmpQSnBIaGw4dmJDZnNSWkR1T09NVy80?=
 =?utf-8?B?UzVnaGRBSkJFOHROVlZZSCtnYlZoTnU2ZjU2RXpCOVNzSnZqb0pXRy9KWHBs?=
 =?utf-8?B?MzUrNUdtYktvSGs1NkJuQUdCa1N1WHA1OWZoS3UxYy9vTENYQ3JrY0lnRzdm?=
 =?utf-8?B?dmNYdVhiYzJSekhBR042UjBlaWpTcCtwSUJrR3I4VnBTYWZuN1p0VlRQZzZG?=
 =?utf-8?B?aWpPZ0htRVBqTFNqUmw5RlZxaHZhMGM4cVBPbENvaFo2Z24xMVRkOGN1ckFx?=
 =?utf-8?B?dlJTbDJPeHVSNWNvSHQzOVdJVk1KQXh5UnhFbkFQSDM4TDFRSi9XVm1DWlBO?=
 =?utf-8?B?MWErMlNvdzhjSXpEQUVFWFJLcmlHcktyRlJLNU9CaDNZU2ZHc1VObVVTZWpZ?=
 =?utf-8?B?UWJTSFBCUGlSOWZCbHUzZjRIaG1aMUxVWUJVb0loVlp2SWxDbFdxd3d4K1pj?=
 =?utf-8?B?ZnpsNWlMQjhkclc4bDBiOHdnWFdLZFp1dHR2aklKWVJTOUVhVFdxMjlQV2NX?=
 =?utf-8?B?KzdBanczYlVneTRXZDRqemc3RlVUOHFzVmxxK1IzVTh0d3FCcURCOEFvZWRN?=
 =?utf-8?B?RUNjUDdXQWVFVW54Z0FRTEFDdFhxRmJLYm1zOHhCWDRXeDdXY2NFbVlXeVdh?=
 =?utf-8?B?Uk9SS2Fwc2M0c2YwL3FjdGhxVWx4MGdrMzMydklPVERua0NQYTlmbFBnd0FV?=
 =?utf-8?B?N2pPd3ljaGdqZThWOWUyMHBvcW9KNzF4VUVSaVJCTHhYWEpjY21oSnhPaEdl?=
 =?utf-8?B?cmplMkZRLzFKV2tCNHFKOXU0bEt5ekpJZ2tTajNhZnFiUjFsenQ2MXh2Rmlo?=
 =?utf-8?B?dWlpcFpZOEgvK3NhTldGbC9qNVJJWVRaK09wWXB4R1hSM3YvQ3c1WGxCQmNn?=
 =?utf-8?B?Y0R6bDNBdjVJZ05zd1ZMNFN3clY0bklDcGZ4V1EwYUp3d1YzN09YcWRyalpO?=
 =?utf-8?B?TWxOMGdFRERhR2RWTHJzRkg3Y0J6OVNzRHFYcHFzZGVkNnAxdEFVRDVUVXlm?=
 =?utf-8?B?UXdFVmozQnlHTHVyclFXSGtNN05tUmg0b043djNYOTRDejNuNWFBeENaRUtw?=
 =?utf-8?B?WjltTHZHL3hsUm1uTEtKTGMyZ3Y5dDBhaGQ5UGRhRklub1RBZHpJVUhOcWZa?=
 =?utf-8?B?SFpDU05tZlRrdEdJL3RXNmg3T2luWTljWHVLOEpoVHRuMUhGYi9VNkFjS0FT?=
 =?utf-8?B?RUFOWk1vdDRIaDVJR1Q3VGhPYVpZYmRtc3UzdXlXK2VvUmozbWJLRHVLbDBL?=
 =?utf-8?B?a3VJaWs3THFHNElxcjlFRmtwZGdVNFFVK25NMGJvODR1RzdPcmQ2SlFDaHgr?=
 =?utf-8?B?aCtoSFZsaHdYZ2hYc3RPbmdDbTAzRnppVXlKaXlXMGI4cEg1aG1yazN4R3JM?=
 =?utf-8?B?ekVsMkF5Nk93RnYzclJRUDFOZ2I3YW91ZDg2SEF3QWRxVFVCZVR5R0d1U25v?=
 =?utf-8?B?ZXlLWnN1c1VJQ082bjFjbE52L1VkUndpZjhDb1JseWhXK2UvdFZmVnE4N09i?=
 =?utf-8?B?KzNiamhZNjRURDRUc0Z2WVdkTk9NY3BQSm9sY3N3NlJZM1RsdzlhaWlQYld5?=
 =?utf-8?Q?BsN58TrQIIHuDuBx8cmd1tE4Q?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?clhTVjR2YmU4ZDVaWWt6eXkvR0p6U3FQemRGb3VIS0dTYk1ETkxNeG56Vzh0?=
 =?utf-8?B?RUtRanZQNUV1c29jSHhyc1ZZTHdvQStWVFRwMUYrTVJ0bnpNa1BHdzJhcGVz?=
 =?utf-8?B?bW1NNkk3QkhBQmYwZzlqeXVod1Qwb2g1NmFnbmcwQy94QUg0cnRVSWdpWlRh?=
 =?utf-8?B?dld1RnozaWt6WFdKOFZSbmZYVG5ZaE5ZRUZxbDZ0NkxmR3g1TnJoQUtBdjF6?=
 =?utf-8?B?NWhUZE83U1BOQXBXYzlzVkMwb3FYeDRIVUZhNTE3cnpST2pjTTVpSFJ5MGhq?=
 =?utf-8?B?V0VZb205MGdUMURNaTNJV1R1bHJQc3RPN2VhT1FxVlM3SnhPQXMzd1hOckJl?=
 =?utf-8?B?cERDZTBKR3VIdmgvOFdYUThVVnhNb0d5anY5MjI5MDZ1RjAya3lkblBYMndv?=
 =?utf-8?B?UVpYMnBERU5PaHdBcnJBSG9JMW5LUnBkQWlIZ1EyYXlRNDdDQzN3dTRZU29N?=
 =?utf-8?B?bmZLeGF5ajl2bHBXekRpMlZkdU5JSTNtVXdTT3dkYnZvc3B0OXVha3FGeWFw?=
 =?utf-8?B?cmdGR1NXNzFjTSt6MWZiYkppRkpJN2k0aEE1V3B2Z0hxZzI5Y0dRbU5jYllX?=
 =?utf-8?B?N01LbmJ4ZmlwMlhWMjRaU1M0K2N6L1JZNkxkOFZqbHJOL0ZGMmRyS095NW51?=
 =?utf-8?B?UFJVM0QvSU0wcDVSM01sSEVPSUZLUjl0NURvbldCRHJBTEliK3NyWmtFdHY3?=
 =?utf-8?B?U0V1SE1NN2JZdjdrMzZoemVKRU8vU0FSRmhyWHpIY2tleHhYK2dSR1Z1VXNE?=
 =?utf-8?B?b0huN1RGZ2dCd1VPUFdDTjNjZ21KWU9wd2xrL0d6RXkwK1MvVTZIaUFUU280?=
 =?utf-8?B?NDBkbW9mT01LUk9ONExDSUhCazVqUGZZWDdTbXc1UlVqWTlPelI3U25VZmpT?=
 =?utf-8?B?ODB4UVB2Q2s1dE5jU2IrTFhOVHJDS1NpdGgzdXpaNWhqMXhtVnhBRUhxR2xM?=
 =?utf-8?B?QnFSeSs4VTFmUkZIcjZ6a0JsdnUxT1g2MFhLNnNFbWlEVDVFQlI0MktuLzdB?=
 =?utf-8?B?NkZyejNXZDJJd2NrZytPeUp2Mml1Q1JXSGwrSmFKSDdKZGhOdjFYMktqd1pp?=
 =?utf-8?B?MjRYSG1OUFhSRTNpV3NObDZBU0RNZXNKLzdIS29Vd25kQ2N0OGxoMnJkZmlO?=
 =?utf-8?B?Qkplc2kzbElIR0VqMUR2dVJuVzNBak1mZkJxczZQRkd3RU1ia0JLV1RSVitD?=
 =?utf-8?B?YnF1bWkxT0ludVVzb0FydTdhQ1ljMXoyQ2hjS0dRT2s1NVdWMEZiVXRpTHJL?=
 =?utf-8?B?WlhsUGwrZHBtK1dmQzRxMXpkUlAvdG12TGtuR1hxZDFwTjZuMUdhNUx5Qkdu?=
 =?utf-8?B?QXNFelFnSXBSS2RMb2pNd3NzRXRIL2t3ZzhZZU5TRC9LM015ZnBtOGpnTitt?=
 =?utf-8?B?RDNCTExIa1hBSzdNN0JMSGVGOFRSZGFjdmJ0YXYwa21FcGNqc3c4Qm5kRnhJ?=
 =?utf-8?Q?/MEMlQc2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c94d8e-4651-4d15-17d1-08dba2e70e42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 08:09:06.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0/38lerOPeCHrWQ8jx33SKak1tQqd6khH9vZ4Fppoczpz34gLvGhx5j5T54hvTK1tLvTOZuymUAH+am1JANpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_07,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308220063
X-Proofpoint-ORIG-GUID: 8OHsxhpoTY5K0M2YXDxAO5nWEfgXjNMe
X-Proofpoint-GUID: 8OHsxhpoTY5K0M2YXDxAO5nWEfgXjNMe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/08/2023 21:40, Bart Van Assche wrote:
> Most callers of scsi_rescan_device() have the scsi_device pointer
> available. 

Indirect response to Damien, I think that you mean "... have the 
scsi_device pointer readily available."

> Pass a struct scsi_device pointer to scsi_rescan_device()
> instead of a struct device pointer. This change prevents that a
> pointer to another struct device pointer would be passed accidentally to
> scsi_rescan_device().
> 

Looking back through history, I assume that scsi_rescan_device() was 
originally written to accept a device * because the only caller only had 
a device * available; and the function only required the device *. Then 
sdev->handler and vpd support was then added there, which was when the 
sdev pointer was required.

So ok, I suppose:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> Remove the scsi_rescan_device() declaration from the scsi_priv.h header
> file since it duplicates the declaration in <scsi/scsi_host.h>.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ata/libata-scsi.c             | 2 +-
>   drivers/scsi/aacraid/commsup.c        | 2 +-
>   drivers/scsi/mvumi.c                  | 2 +-
>   drivers/scsi/scsi_lib.c               | 2 +-
>   drivers/scsi/scsi_priv.h              | 1 -
>   drivers/scsi/scsi_scan.c              | 4 ++--
>   drivers/scsi/scsi_sysfs.c             | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>   drivers/scsi/storvsc_drv.c            | 2 +-
>   drivers/scsi/virtio_scsi.c            | 2 +-
>   include/scsi/scsi_host.h              | 2 +-
>   11 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 370d18aca71e..f5c36c8c243a 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -4884,7 +4884,7 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>   			}
>   
>   			spin_unlock_irqrestore(ap->lock, flags);
> -			scsi_rescan_device(&(sdev->sdev_gendev));
> +			scsi_rescan_device(sdev);
>   			scsi_device_put(sdev);
>   			spin_lock_irqsave(ap->lock, flags);
>   		}
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 3f062e4013ab..013a9a334972 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1451,7 +1451,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
>   #endif
>   				break;
>   			}
> -			scsi_rescan_device(&device->sdev_gendev);
> +			scsi_rescan_device(device);


nit: how about change this code to have the variable named as sdev, not 
device? That name would be more consistent. That would not be a small 
change, so maybe not worth it.

>   			break;
>   
>   		default:
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 73aa7059b556..6cfbac518085 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

