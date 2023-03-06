Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA05C6FD1E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCFR1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCFR1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:27:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE08935B1;
        Mon,  6 Mar 2023 09:27:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Gwldr021464;
        Mon, 6 Mar 2023 17:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eI4NlNU3Dl6/1cHuETDFvEnXdbXz+ab0uBJpKKn5iZo=;
 b=Z7gzJbx6xyV4Q+lsbrt5h5CjZT7iGzQZwudu6Ecn5NJvjWy8PRiatK/YL6SAeYGUvTRi
 2uwrqp2uocSi4pxX3VHOeWfK++nsaFkQzJgbsj1CDfpld+s5UjZxqf8/MuZ/MNC10VDx
 4tSbNT1SebscyskUTJjq4ikGtJ5/zt8uIXFZimhOUrqjfmzVJdTR66yM37gsV4X5Bmva
 l4TGWmsZQ7wtaSJKf5xjosCAjlBxD9QBO8QFErcBssRUhY3Zv2aUvpyy9IzhH0o1vgJL
 +J2a5+GmYSaV2Tpzy9TADe1Qag0u3w+eng0NM1y4fs9+3oPzUOU8XLP/47wT6+n7UsIg gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161ufns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:25:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326HMpgl023367;
        Mon, 6 Mar 2023 17:25:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u051fcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAWpvLZiKFNW3thHlYM0eHppDKkXZ8/0NMhT1XJ/VTo3sSe9PkbQEjqcN5mMrPiC+zJ9oN6Bu52NbwasyDvqRt65cUpgDwaJkM3sCZYJanowkjkWsn1Zeoyly3MPyKekVogHn4L++pbJi9tUbtEpsFwdybNiZVOQ12l352WcWlUiFEKSKliC60eztpYdToJcflzQM4eiKoUdZX2dpvOHW0ZiBV9Shr3qvAneDHWlt9ny10PL0SRs7if3PAHULomg7iZFAV1OxFn4SIQ0I5i0umz3Jf6aRF8+UwsqLE+od6tEREJmQR9zoAIDBXKD4keijREGCNmbm5WDlZ+5Qlymgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eI4NlNU3Dl6/1cHuETDFvEnXdbXz+ab0uBJpKKn5iZo=;
 b=Kxc+9MYvgw2TQzzN3VQMc81HFov53cnTPqM5gS6y1LMqwXLEUfOtisCzkvkBjdsEiVDbdSpZCVwOzP8ZmVWNc+eJ92pIZkrxYweKJ2XSDjEAra2VknR2kUIzfFP1tEjeL+cUAml1z8N09ND2+1NDoWbcgkk323/BaUO7EXhcsVmT7LVyWKQ1TkqX6hWfQWGBh7oPD+4d5onFHncjWtVZjJBa+UX6GdqB0Qi9CuQKIZLEnWo3FA3BYgUTKMRBTAV+CK+aBLZn5hD4Sqhp9Dg2/Xmy2qzS2X/Uld+MbgqqjZRSuALSrXoGEI2wfIf9K7onib4JZV3RoAnFusnFMtU/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI4NlNU3Dl6/1cHuETDFvEnXdbXz+ab0uBJpKKn5iZo=;
 b=k3794LO0rP0QFUs/QR/8uPUMn9m2pIVz88KKX6U/frEzm+c1fpGSlm54rYNQF8WdpW72POS1QFdt1J3JjZPXy2ylA9D40zf5p2PPJl64ma2o4kznFko5LsXIL5lXDglZDptBEMvyV+hJAWoc55H+P1NxYKQhpnUKkWwRIacmA3w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB7546.namprd10.prod.outlook.com (2603:10b6:208:483::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Mon, 6 Mar 2023 17:25:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:25:22 +0000
Message-ID: <9fc842c2-d842-5803-3f79-2c593d61743b@oracle.com>
Date:   Mon, 6 Mar 2023 11:25:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev
References: <20230224174502.321490-14-michael.christie@oracle.com>
 <202302250448.cEVYdC1I-lkp@intel.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <202302250448.cEVYdC1I-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 439c992f-f01c-48f9-2121-08db1e67c3d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAeHx3Hm8QUhxpYv1Qa5HXwwVZIs/8/Icr6e5hRKirP7OQgZAMXAXg127JxlU2FylwH7ginlXl4vku6kcSZ4GWuuFkd1mXmYqrx60nb0xzd8LG1hI9jN2yDztrv+eXMEcFCVpBVH9bVOgZ17Kg8YzRLBSsYUvX5HJpYv8Uk8kAX27pRULP8vB/RVBULbB6ky8zfcwqGkv52DGF141scifkKd0CVWx3gHb0jaWMC6l5c9ays/GM30tTdDO0YrwsLqslgSKBRqcVHw4sWYN0BnAVklpfRuL9Z6mmi6zqLuA8VUt3L543B/d2q9hUgQT3bfJGYht564b8iGDqDGP0v9ffOCcAUK00tkXHb82B5sJfi4XEdlOlG/qZB4ealMZiSYcW4CLg3j1xBP8c9+6gNlNqyiE2cHQ8eowLcyon4TtCoDRtelJUOOmyWICvcq5+6TQGczrm60bTXJcgXkKle0qYwA26rQqrZ84ZYdkdFjouZLo903s8PRCY0uB2g0bH1C2pl0dFEI+n6H/SIxcCFTrZIDfE+wBezgZxgYWZTOymdVegGfEU/YEVMTiq619QfOPf/wYUBSXbWuUE+KJ57gAMZkPC/NByfUpr4+yZ7nptCc2nl+qk8pzB/BlCfKlq5XFUTq84fVF9UW9db3AstEvQpzn7JCV8wztrgaE5mY3eZBgb+mwWjVleP3PQ9PLHTD6B/8bshrBQN744UBQlXsFX2e0Mu8YPzqHq958pKjjdXYPVbfDnEZiAgM0hAXmFxF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(921005)(86362001)(31696002)(38100700002)(36756003)(4744005)(2906002)(41300700001)(8676002)(7416002)(5660300002)(8936002)(4326008)(66556008)(66476007)(53546011)(6512007)(186003)(26005)(2616005)(6506007)(83380400001)(478600001)(316002)(6486002)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUZCaTlaTW0yT0FiYnNzb1hSMEU2aCs2c0pRL0ZHMnFvZzFiVEZWMlRGM1VJ?=
 =?utf-8?B?R2F4YmpQT1lOTWoySkhpdFdSb295dk1aVHhYbnhENFpneWF6R2VJaTFxbWlq?=
 =?utf-8?B?Vlo5bVdSUzVURkpoVzgrSDRDUUxxWEhFcjI2YnhYTmpQaTM0VjNmNUx1U2VH?=
 =?utf-8?B?ZTF0QVdNQjdGWXpPS051NmJEWE9acmI2a0ZMSzZycGt3MTg0bkV5SDZEUm9C?=
 =?utf-8?B?UVZEN3VDcGFTWjdIS254M2s2R1N0SVBxZHROSFFSOWpmMWxGR0NsRE1NMEsw?=
 =?utf-8?B?OWlwYWwvSUZLdE1VeHh3R29Wb3RhUFBoMnFwWUhKNFYrbEpqUUZRWE5tVFFY?=
 =?utf-8?B?WmV0dVovZWFjU1oxU3UvN0hGNEU2Zm96bUZBLytTVXVHZUQxUUMxRFdwUDI3?=
 =?utf-8?B?ak9DdlkwVldDQ1NVWnhsdkRvdkVTSjRaeEtiWm40YlpqZHRuc1Y5d0RVMjhF?=
 =?utf-8?B?Rzdrbjd2MTJ0blFWT3pHTkpnQW9hMko4cHVtMEVXVWdWU0EzRFVFUjdzVmha?=
 =?utf-8?B?NytmUk54MWUrSkNNU3RWWDFzWTd5SUo0ZGZXZFJBVWt2U3M4M0MrUmRLalo5?=
 =?utf-8?B?ZzZJY01BVVJsUFBYMitUcytzZXNCMW4yY0RUYmduV3RtUitXdExKLzZoeVI3?=
 =?utf-8?B?NFA2N1p4YVp2UEVYSEZmUWExbFRSaW9TZXBxR0RIMDUwdHlFancycWdaYndq?=
 =?utf-8?B?UTdpN2tjZU5WQWhieS8zcEhhMnkzVE00dTErSjI3MVBhak1tYWpsb1dJZWUw?=
 =?utf-8?B?ZjZQclB2cm1iSWtVRUFFZWYra0xCUXRsUVM5Z0JVbWlRY0ZHS09HdVJWZFg0?=
 =?utf-8?B?NE91aHB4amsxaUV6SWdMS0VxRUdEbXJnaTV4eVZKSHM0QlNOQkIwb1ltcFpV?=
 =?utf-8?B?YTZER0FiVFR4OU9nM2k5ZitDY0ZHTmNvN3NTblRjeXYya2QraHk2bFl2anlX?=
 =?utf-8?B?UXM5USsxaUlGa3JWRHdraUJFd2pPNW9WN25aVmZUeGgrZUlPeTlqbDJaeDEz?=
 =?utf-8?B?bkVYcExKZnk4WXpVUGZiRGk1OGlzakFXSUhHWEYrODdkRE1SZGNFRC9FZm5B?=
 =?utf-8?B?K0xEc2tRa2REYm5JdG10emovaTdObWg3YVI5bFllZTNXcHlaeUdyQ1hlblJB?=
 =?utf-8?B?bG5oODF6SHEyTTJVVEwrVHNMZEhyTTF3Rkt3UmwwWXRNb09VR0FwTUpFQS9y?=
 =?utf-8?B?Q0F3c1hpUk5jTVFGTDhxZkEzeiszU1hnUlIyV2JFc1ZWdVhmQm5uMlhJanYw?=
 =?utf-8?B?YXBXenpJUTJsTDVGVUpCUXdPSDFIa1l0bkwrQXZ0ZXlONDQxYk9Rc1NndGNl?=
 =?utf-8?B?VFpuSVdhUmNrVWR0eWVIRlIyaXA1cTkzajBpM3U4Um81bnhLOFhhTStwNzRp?=
 =?utf-8?B?VDI4cVdaYTdGOStOR2xnKzljQkErRlB1VDFhWFlMUjlXc1RIOGxyT1FDMWFW?=
 =?utf-8?B?MlJoWkY0S000Rzl6cCsvdnJiMXphUVpkQ0xGcXhadm9iT2hDc1Z1Ri9DN3kx?=
 =?utf-8?B?QzFqZ3JMRFphWDhnYU9oNTU4RFJOS2xyV2plSmIvUUFNbk1BT2lzNld6ZzV5?=
 =?utf-8?B?dEdZRlg4cXZmVWZyZXNPdTY0MGhvMktMMEZxcVBoSWUwSE1HdFlBUTlQWWlp?=
 =?utf-8?B?SGJDRm82N1FrL3N6Ti81dUR1THVpVzNibEJhVE15V3d5aHNRcU1BYlB2MU9p?=
 =?utf-8?B?dmNvK2dmVG01VEJPYzk1Zit4WWU4elozVVVJTkNZVi9JUTRzRkJFVGQ5Slpw?=
 =?utf-8?B?K3hqSzBpRDRzeU90MzFuUExwUFQxVUpmUjZqTnA1WDVzcHJ3aXZZc0hNTDRv?=
 =?utf-8?B?NWpwbDZDRDlYQWJsNWF6N3VNMFEwK015Q1ZFajhzQkJaaTZ2SFpGVUZoTklh?=
 =?utf-8?B?L3Y0eFFiWTROc2RkYlNiazBLTzRmVE5FZDZ4cU5Icys3UkRhYXMzdmFPVGNw?=
 =?utf-8?B?aHpyUXRyMyt2TVh0aHBrYmJQdGpDYThUdExwTW1NZ0doZDZ2ZzN4aGdZSTdI?=
 =?utf-8?B?V1BqMVVRcURuUHhEQ2FyRmZRZklQTmtnWFp4R2p1T2gyOXhtS0t0RG5HS2M1?=
 =?utf-8?B?VitSaEZkcmFQNFZNYVAvYjB6NVJtLzRFNExHazBaZEtXSE5VNVRJRVNxVGxu?=
 =?utf-8?B?VytSYlNJa3U5QTcwTC9wTHdETWt3c2U2cGNlSHJ1cUg4NlNBUkZ1ZDFHOE8x?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ejF2ZlljSzNVTmtXYlNzR2EyUmRVWTBJU2FWMUg2NWsvNVd5eDFxZnorQVZL?=
 =?utf-8?B?M3VSbkZQSzE4OG5BT05lRVVBa3FKSlRLQUR3OU8zU1ZCNElqeWFRa3B5WktB?=
 =?utf-8?B?bG9kbjhzNE5MQ2FmaU1xek14Y3ZFQU5lVmZ6bFZlZ3pzeHQxb2lVcDJNUExS?=
 =?utf-8?B?cVFOMnFHV2lRVzdjandXN051TEFjZDBYeDFZa2ttcHZKRjZCcElNZTB4WUhC?=
 =?utf-8?B?UmNjbWtoVy90VFhmUjV3eEdmWk9JZTFuWkZwd3N0UER6dXV4dUpzc0pUVno0?=
 =?utf-8?B?aWVZOC93TDlvMTJyNUlwd244WlhIamh3T3dYSUpWVTdHSC9lVlg2b0tDZWVT?=
 =?utf-8?B?b29Ia0pyR2hDY0hJNy9YVnZ1L1FmU3RXN1k3VTFVMmlwQ0FXR0dmUEhVSGY2?=
 =?utf-8?B?NDZPZndTbjlUeHNmVkUvSWNTSHZiUTJqVkRIQmJVcytoUHg4N0s1WWN3SU56?=
 =?utf-8?B?MjQ0QVRiMUovQ3o1NkxpRHF0L2p3TXV6SUhDM054anc2WHEzR08zWEZHQ0Zo?=
 =?utf-8?B?RllPY2pNQXIyZUd5SHdabGhtdmp3K0FUcHg5SDVpTlZwbFk2ZndRd0lFU3hx?=
 =?utf-8?B?OEV4Y1dpTm1NWlpTRW5wRUlDN2IxenFBVkJ6cGtOWmZOM0dBK0p1Z3JHL1B6?=
 =?utf-8?B?YlNDelU0QmxVQVFpMGV6ZGxvVXBET1JBZ21kTGRIdzJhV3IzRmVKWkxCeWJx?=
 =?utf-8?B?eG5EWFhZZkVrd29tSnRvNnAybXV5VUFWRkZwM1pSemJMdndyR0h1VU02MjQ1?=
 =?utf-8?B?QzJIL3M5WGVrNEpELzhOOVd0YXNnQllpYU14OUxQMFlYQ05Td2NIUzdIdzdU?=
 =?utf-8?B?bkNGTGFESHFuemh2MGMvd3NzNERqVHBLZTFtWW1uWm8wby85MndnSTN4MEtQ?=
 =?utf-8?B?K0IzcDBsUENWNWJ5VzFyalZLdEJrZWNXQmg3WkhvZE1qd3U1Uk53d3JSaDlD?=
 =?utf-8?B?aElnNzJleVVDdnJxTm1LeHdvNVFEa0xYajV2QS91azB4c01SWld1Z2lsNyt3?=
 =?utf-8?B?K1dtME5vVjFRL2NmTW9VNTh6MkQwOGZzVDY5WnczZUR1RmxhTjQxQUZCZ3ND?=
 =?utf-8?B?QWE2ZFFRVzJrSDc0cGNJMzJuV3VhcmxMTU9GWkoxaDBzT0pWWC9heXRLVXc1?=
 =?utf-8?B?SS9FZ0xxUU9lTzFYNm1pMjZiclFsMFdQN2VnWVppNjBKd3ZXa2R6Qi9Ed3do?=
 =?utf-8?B?WWxJMFRTNzM0akJ2MzZJdVNzRkE3Zmh4eVBCNVRkeWNkVVNFRzByQjJraWEw?=
 =?utf-8?B?SXUyM2FKM2s1WWxJRDdZWDdmV3ZjMENocnJnczhOd3VLU2dDK3NZZGpnSGp0?=
 =?utf-8?B?MUZFRWRScXc5WVBEeW5ZazNraExwNndoVW41V3plNkRTS2hGT00wcDhQUkVm?=
 =?utf-8?B?dmRGQUxlUTRrQTdMYzhCc2FPTzJObitxbWNyU0FTQzkxV0hRTUxDTU1PUlBz?=
 =?utf-8?B?NExZc0pIaWdwQTlCRXBaQ09XUTZucTZLT3h3ZElRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439c992f-f01c-48f9-2121-08db1e67c3d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:25:22.0609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /X4AyNiHpjINZ5sFnFfLrYokR3u+g0TBcHYsYkmq5sTsOFbprAskFp3gKTWCVFjfwbYxnnqTh2FQTCuXBfpLUEbSdI8pKR2HnjDzlMlB7ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_10,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060154
X-Proofpoint-GUID: aBsc09qXi4EqZ6bBycaoCEF28idtbs0r
X-Proofpoint-ORIG-GUID: aBsc09qXi4EqZ6bBycaoCEF28idtbs0r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/23 3:04 PM, kernel test robot wrote:
> 
>    drivers/nvme/host/pr.c: In function 'block_pr_type_from_nvme':
>>> drivers/nvme/host/pr.c:43:24: warning: implicit conversion from 'enum nvme_pr_type' to 'enum pr_type' [-Wenum-conversion]
>       43 |                 return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Should have been PR_EXCLUSIVE_ACCESS_ALL_REGS. Will fix.
