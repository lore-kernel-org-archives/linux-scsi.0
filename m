Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F337FC64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 09:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCJJXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCJJXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 04:23:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888DFF786E
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:19:05 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LxdL9014203;
        Fri, 10 Mar 2023 09:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8XQHeGtTvwO88Bo4DZwxDwE7uv9AFqCA165kypLQdhU=;
 b=WItcjJxqFSL9UfPz2+0aRXxc3K++jgK50PcQyM6ehvYJoHuv/us6eK+FM0W5pLgTlb+Q
 wSfL7svumgvIEn6AS6uULDSy4FL+His3ezdOvM7v7XL68Sf5OlYfaxkokjKqPcRtKkpD
 lMlXRut8QwQLJ5WFKuit95hXBZtUAwZRfGCavccRrdjbovzH3bNE+iVpQTrIOFsLi/oT
 tWHYBp92qEDEITKP8ygxRPWu9T2t3D2xuXZ04JSpjjrJFyHIQA+M7BPozKL7HacVvNuR
 EslVcvnUrhK3krrjFMOOdYwwVGyLBYOZfxOJRyjSq1YghZWK05DloOfz0DJ3d3co8DrD Cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y4utn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:17:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A8uWZL036414;
        Fri, 10 Mar 2023 09:17:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4871r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:17:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkYXxGghK9XxYvmPbjnYWnPcn4aKZiKqJ649BuTdNd2mDOGwxhm25lZtUKKj7HkU2wa/GocZtAT6MzNoUfLxV3/jqNOJ9aw4ICKeGbrQCqNjdBGndm2igdYVU3BOS4aC5BqTRC5S1i7wiXH4l9adHT0LD1N25sDu3dfYSacmk1bg1dnMXkv7S/uOTMCeud4ZDfWqZ3Azc5BcZ6M1vhlupqQPxRun4zVCf4Lz1rcJc6BJC1FwS5tGx5hgaae/ovfwguBJM25EBDXR9EIX5fsca5lWATwpFMjGHdw98SUDXfYZBVbLRusG3+mwC59oK9LssQ9UCdpDlNrnnsK+rXKu4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XQHeGtTvwO88Bo4DZwxDwE7uv9AFqCA165kypLQdhU=;
 b=X5C3lDLqPDZvi7HwsviR7nvmnggM8qU/5qBZvWNU5RVZhWLZALy4LKMHZFUqbaU+PqdG4KUfHEMss/uelvSgHsneLo1GXtho2cOiWmaw/LdbECjP19JKGX3EAe9F2+CE4ex6QOAo/eQDJ4G/5ddg9aqZQsv6HDxzJo5hf2TsSUqE5hmZtDWt+uml+M9m7bEMAKDV4kZQCYBXwD3jMausvezFDeY6mgnTc09ag7ge0X5w6jznUetuAg3ZyIxkhDHd2OckC4jvvDkOGOK5t5TcI1d6p1uYDzezdW69isbRTnkSXWcrHbEqfcjJrR1gOO50wIhKZcjSSishsSl7YWdIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XQHeGtTvwO88Bo4DZwxDwE7uv9AFqCA165kypLQdhU=;
 b=al1b/Pi2afa6Ym1uczJgdZpHJa2Qwgv+i3q0iv13WSHgXPaiIJ62BSxHR3/1Rq/OEKmy51Ge3/8uaEx96T5J/e6T2wNJY08u9DxV1fidArXFakzj/eFL+hpDLGPKDFsCg0p2SlOYnwPnYy//kIGjVcWFhciHdzz/m5Rc9pYMELI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5726.namprd10.prod.outlook.com (2603:10b6:303:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:17:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:17:10 +0000
Message-ID: <0097e3ec-bf37-1ac6-a3a0-46212729e988@oracle.com>
Date:   Fri, 10 Mar 2023 09:17:04 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 04/82] ata: Declare SCSI host templates const
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Ondrej Zary <linux@zary.sk>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-5-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230309192614.2240602-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0025.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e4a48f3-dd6b-4cf8-2716-08db21483a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WK8rgSpuGEb3ZNatjye3c/MkmhiS9LDKyjXUHrHqCaczWR89yCGIXe7K09YxcUU8U3AZFa3QOwgptfPPMK9WSLHyaOppsCkfbDYRSOIfd3LqBzP85CTTA2GcT/l+XTM1DJeMidcYdXb5QepioZF2tWajSufFM7vv0oIje07yobGOvsJ4Bjli/yre7WDMMeI+ZVAeV8MYHM0P1W6ff6ZDYAbuFz53i9WHT+Zr6CVA6lhVBNkg1EojGVA2FQagzBqbfgfwUVbxp+84TAhEA+LULNaAahNi5bvnN4qa0eft1h/vD7We/hYA0ZC4Q8pN2LY3aXuyCIRwwwiUY5ckiTw1P+EpmhHQtzfnvYmzE0IOPowZhOr7d6azpNw6jr+VOm+vqZOYlvOeSmleeBQq3BD/AbTwIFEtSRo0mWnqS/abqu5YsECmkkGMLw9J1lIOK6gi1GjxDI0Ncq3V/3IVnL+ta3Lw7nXvKtqctKHZAmQfUAx28vu6yAo/3Vp/AkdZe5nYTYVN2NLzY3R6VN1RQNok+hOMLPR4eq+qzc8rEHZr42cP9gPC0IEpIgjBHfJ1lUBrPCciQhNleIR+aFC8GhFW+d5WGc4yDgWHg95pJsQm21VifuJ4C7qZECwB9KLBub5PQ+lQ1gReIg+I4qKvxuumW4LaoiDoysDlysR6bpDCkDyj8RoC1pSs+CPqYmOtV7GD4JBFQS0xPEMLxfMXnRqzHwEFgMiivpoR/34AwpuHLJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(31686004)(110136005)(54906003)(6636002)(38100700002)(36756003)(316002)(6506007)(86362001)(31696002)(186003)(478600001)(6666004)(6512007)(53546011)(26005)(2616005)(8936002)(36916002)(6486002)(5660300002)(7416002)(41300700001)(4744005)(2906002)(8676002)(66556008)(66476007)(4326008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1ZqdDRBTDFzSjN1eDZFb0d1dFJjb0Y3YXdJMDJqRElBSnAxMmE0ZithOGQ5?=
 =?utf-8?B?ZXo5cG15T25XMW41UW91QlJlZnJEQjZZREpFRExNOVZyYWc3dkk3V3J1aHJm?=
 =?utf-8?B?anNUMVhpR3FZeVFZRkl0aEpuUnRaT0o5RVhtYS94SDNyRjg5bU9Gcy9nWFl3?=
 =?utf-8?B?Ynh1aGpMdkFKNFN1a01mczJyb1BhaFVkU2RkQ3NIU1ByMlNPVm50OEVGMmlU?=
 =?utf-8?B?SHNldmhDdy9BVWtlU2dlQStKc01ZYml1STRFU0pzKy9BcDlXZ0hmWDVldmNY?=
 =?utf-8?B?WFFsZFVTSE83c1FJZkpWRVA3QUtuaVFOcHZvbGFhZDZJQUtEOTFVU0RrVm02?=
 =?utf-8?B?bFBwTU55REJFKy9KM0kxR0Q4SzgyMFkzcGUreEQzOVlsMG9kS3hBVExiM1Ns?=
 =?utf-8?B?RW9Ua2tMZ044YWlyV0dUNFdOTk9RR0V0RDN4V3FTTERQbWNGRkdxQWQ3SDdi?=
 =?utf-8?B?N0c1SUZKWWlIbmkwUjdpN2tCNmdNc3FIZUw1UW9hSURBR29ycDBMZTRodmdJ?=
 =?utf-8?B?V1Q2alB4STZ0NWpYTDgvNEdFNW9aVis4RHJINUxidGxkNERNYTZTRHUwd0ta?=
 =?utf-8?B?V2dGSGN1eUtsM1NBMkdJdHdwT3FSMDBQeGI1bzlUNm82QVlKTndPb2FqZ1hU?=
 =?utf-8?B?WlZJd09adzI4R0JrNEkwU29nR1E5c0RvQUVacHhGY1g5RFM0SDdFNFhqK215?=
 =?utf-8?B?VkZUcWhGT1krOHMzNEkxT3BhaWpEUnB1YVA3Uy82N0xSMzhyaEI5STlNZGJM?=
 =?utf-8?B?TmNLS0NzenVZQ0M1V3VCQ0lKSnE3ZHE0elpQbFdmKyt3V2ZmTkQ1Tzh2MXRU?=
 =?utf-8?B?b05TbVdLWTZuZENBa2pMTmRjaE8vQnhoSDQzSGhjNlNnZ0dTUkNaL2RoN3pT?=
 =?utf-8?B?bjdpZVczdW40WWs2UHRxSlk1Zk9rMkViQVRGT1NkR1VEVHhBQlVnQXJMLzgv?=
 =?utf-8?B?YlNXZlAzcytDdms1Ynk4NXFVL3lIRmttdWFqTHRPY2l2TTNxbzAxYnl2NTdD?=
 =?utf-8?B?eTNOaGg3bDRWaGhmZ1pNWTg1VTF4MzVleXJiOUdRejVtQTAzNVNYMkFUTUM4?=
 =?utf-8?B?TTd0enpBQmxpUkVSQ2RIbEtzMGJudlRqV1hVMEZGNk94MUxhcUFQZVNFSDcv?=
 =?utf-8?B?SDE3aHYyYk5PSkJCQldQMW1TNmNOMVlwQ09tUloxRVFvbElCMnhKK3dndTI4?=
 =?utf-8?B?QlYrOGRpblBRcnMzTmlrZ2pnaVp4L1o1ZWNCeHdlajFiUkw2emYvMlR2N3Z0?=
 =?utf-8?B?cUc3dDRyMno2cUVrcU9IeDJibERiVlFqSVhrbnBIVkpYVGlQaHVTdE5WQ3Jx?=
 =?utf-8?B?aE4vU1crVXZCa1ZQOUc1NnhHOUYwTVNNZGh0cnhjZUZJaTNiZTdBRkhWK0VS?=
 =?utf-8?B?ZzRnUWc4T1BWSW5zVHNpTElabVo0bytrMmttaFRoQ0c0dStyaFNQWmpkZGZH?=
 =?utf-8?B?R0tQSDk5RlBQNlJEd0I1K3FjRTFidUUzbllvZk1Obm1PVWJZUUFxc2lKdXFM?=
 =?utf-8?B?c2UzQnlyb3N3ZWRkNkFiOGc3QTRNVTg2amlrcDByUmlpemc3Umt2NXNKQ0lQ?=
 =?utf-8?B?WFJwMkdPZ3JDbnpEQ21yeEVNY3VCREFQa2d2aFpWYUtlWGxsOHByeGp3RUhn?=
 =?utf-8?B?aHlOR3lMeEhIUFVYWE9leTJoSWlFcXFpeFIzRUEzMkc0K0gxcWpnWExYOWtu?=
 =?utf-8?B?Wnp0ckdsMmhQUDA2UzMyV1JwT25CR0pTWHF1aFdaNEZud0FVZ0xwVXdWWU5M?=
 =?utf-8?B?UFppSWVFa3NjYXk5N0dndUlHZ3VFcTBueWcrOGh5bTAxQTBBK2RieUhua3Z2?=
 =?utf-8?B?QUFVTGd3UVZCK1A4bjBxMDloUi9PU0lpcS9lWlpqc3l2Z3REUDR4TkcweHVE?=
 =?utf-8?B?Q0wrMVBZcHVoUlNtU1JaaWpKYWUxdDBZUmJlZmN4L3pDZGk4TG84UW9pUlBS?=
 =?utf-8?B?bTFtWXBBdzJzdnhtbndtc1hLRXdMZ0syN3pDa3NHczZSNHlUL3lMSm9nNG1R?=
 =?utf-8?B?L2F1OWZVQjFMTGNvaU9pU1ZKUFh5eHN1Q3JxWXMwN0VNWUZwU2M5L25SMEpU?=
 =?utf-8?B?a3pxK2F5b3Ewd1E3aFdseXROaDBiYmc5QW9LVG0vOHhlL083Sm9rckVzYUVy?=
 =?utf-8?B?Ylg2VjFaZFhLUW5PME1WMG5zb05FeXQvRGlmR0Q1RHdYNS91VGdIMFIwelU1?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TzkvcFZIR3VvWFlMMysvVDlSb2tPcmtrRlVsclEzQVI4S0V5cWh3cEpkcDJ1?=
 =?utf-8?B?Lzd2MEx6a3YwT0lGNUxMMnRJMHFSSE1JZ3E2MG1oMVljVkUwTm80VW1CY2Iz?=
 =?utf-8?B?SjhLUVQzODVzWGdJSkRwdEZuczAreU1QMTVoVUJ4bE5iRzcrbzBmUUxXd3Er?=
 =?utf-8?B?THNrbkRvVWdTTmMxeC9qdUpOSzlWbFhTNWUrRmhjb2RqNGZXcFFXUHc3L21F?=
 =?utf-8?B?Q3Q1WjhLWkxHaGw4OExOQjZ3YzBMdXg2ZUNxTnBKb2FJN2JvaWt1K0NHNURZ?=
 =?utf-8?B?OE1iVFRUcGUyMU1HUmlQdXFXZW9sUzZvWEJHVU1CUmdpUHlJT2pwK1hWOVpP?=
 =?utf-8?B?VjVJNkRMVk9TcGFsQ0pzMFl5MVNNcWJoNGp3dFQ1aVJwbnZSK2ZFQU5hNHpJ?=
 =?utf-8?B?Nk5XbXhsYUUwTW55YmZyUjhvaTNvNFZxQkpYWWFyUHh3aEUzQmNlUjRrMmRm?=
 =?utf-8?B?VFAwQUZRRjRicEYzTmMrYmRCaFVXa2RsaXBBRFE4d1pVNHVTU2lUK012R1hp?=
 =?utf-8?B?bys3MlE4c1ZSb1RFOFZNUVp1NHpDc0Q3NXhSb3cvSDlKQ2E1UWRrcTVMZ2Zq?=
 =?utf-8?B?aHRLUmhTTnYvdXZsMWlJOEtpUDNQWEFWZ3VvYWhrZnFoUW9yS1VGeHZNODI0?=
 =?utf-8?B?d1FxMG0xSXdubmFhS29XRk1HQjU0aTZIYkpCemZFOTJTalhoM3d3aXFwajJP?=
 =?utf-8?B?NGhDdkZ1eDZjY2c2U0NFakZPWEZOMmg4N01FMEhQUk9mb2FqRFB4SlBLamlj?=
 =?utf-8?B?VVZVTVV6eUw4ZmxYN2VTK3BZdE05RnVLN2Z6RUpLdXQwQm16ejlqRnJ0WHlS?=
 =?utf-8?B?dTRXWmtTQlhnZ1pMV0hVb1NialZlanYzQmFMU1lKQkpmdVpPenZrRTZzbUJL?=
 =?utf-8?B?Zm9obFV6ZEpsSlVubDJJaXc2VnN3d2hvZlVpTzVUL0hUL045Z3NFTElhWU1I?=
 =?utf-8?B?N0FtblVyTEREMG9qZGZDcEN3UEJ5bWR2OVY0ekJiOWNaTkRGcFVBT3I4ZEtM?=
 =?utf-8?B?ZEQySXJ0V2tHM3RlQXFvVWtzS2QzbzJSSkduL1c5MW01UzBrZ0ZuMnF2VFhs?=
 =?utf-8?B?Q21CMzFQM0hzRllRUFNvNGIwaDJabnR4VnFaWEcvVCtIMHRzK2xvU3p0Qmhw?=
 =?utf-8?B?MDRtV1M0WE43cXZaMkFqbjRHUld5eHA4OVZ1R2lOM21YRVdkVjMzREVEWTBk?=
 =?utf-8?B?dzVFSHpIdVo2MFNUOU9HbEFjUVcxbGZEVVdZT3puN1d0WGRUbXRlUlY5R2N4?=
 =?utf-8?B?NXZWVkN1cXpycTFUeWRGNEN2d0RIa2xpUm1qbEQvQjAzNm53NnpYVkdySG1Y?=
 =?utf-8?B?VUhMNzMzT0FtclpkODViWk82a0lGV0xnREpmSXArSDRucjJwWXJJRWZRKzNH?=
 =?utf-8?B?MGFHeTI2RGJLN2NnSVpkWEhzMVppa2lEcWdPTUdORC9nUVZOT0p1cSt6T2VV?=
 =?utf-8?B?cnpNSjR3eDZLRTV0NGtObC81THlNYjkrVXd1V0ZYWEVNS2JrNUZnYkZwYzcv?=
 =?utf-8?B?VEdHcERHYjlFYTJrVTZFWHVRTmpBbk43QVZmWnpWSTRqeitrc2JhVWVnUU55?=
 =?utf-8?B?ZFZjNlU1bWRQMGtFVTNnOW01VncvK05OTE5RYlpZditGSkUvZmdGR1BkdW01?=
 =?utf-8?B?N25NWUZxcy9PQ00vRE5Ma1kxQjBGaWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4a48f3-dd6b-4cf8-2716-08db21483a48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:17:10.4737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69TDJRBQIf/5wK70q3LDk3u2eiVwt+sGOx4/TA7kVkGhgAygs1UCgmllmz7sR6HBKGbpDXKq5S7ImOGTPfJe/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_03,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100069
X-Proofpoint-GUID: xk0tfbEBwL78JYc1Y_ZmUH9L51W1lGNa
X-Proofpoint-ORIG-GUID: xk0tfbEBwL78JYc1Y_ZmUH9L51W1lGNa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2023 19:24, Bart Van Assche wrote:
> Make it explicit that ATA host templates are not modified.
> 
> Reviewed-by: Linus Walleij<linus.walleij@linaro.org>
> Acked-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
> Cc: Christoph Hellwig<hch@lst.de>
> Cc: Ming Lei<ming.lei@redhat.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Cc: John Garry<john.g.garry@oracle.com>
> Cc: Mike Christie<michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
