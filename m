Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E4FC6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 09:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCJJ4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjCJJ4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 04:56:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F5D108690;
        Fri, 10 Mar 2023 01:56:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx1P6003622;
        Fri, 10 Mar 2023 09:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jiZJv29P7MylvM47Hmd2FI0PG2ZCmGGYfeEfnc1TEsk=;
 b=18G3iFqQIaMN0tY2kN8mbEL5r8DuuHxviZkDTz52Y4+fUQbdA0XL0LYlSj1+yE8fFOLk
 AcCc77rz+siWbGOf4FELDXk/fiS+PEKuyPvplhsUpJoqsFXVDoEZlMrL/XqR/APsLRj2
 d9bPWUreXto125vX3squtWE266GVjPbrjK/Px0PZSPnhjoaeuo/hDzMKoio/ZAhpmnzF
 eYbfk7jP3IMKREIgY132LXryu9Yt65t9w9y+TXg6P1WU+FUSVo3yuybpCG80cQEaPR77
 1GBa5j0YJcm3uvHjt49SpRcHrelvdmvefGdnDtEVEbMfOdGSJ4WDgIzeX986IxeHKSao 0g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wvwg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:56:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A87xbU015264;
        Fri, 10 Mar 2023 09:56:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6feq0rym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB7LNMywsTHXBqAPWkyD3RlrLJQopl4Ne7cnNsyxg7I8j8LLxeCyLCWsIimlJntjh83c0T4AVsq5CtGzaa8SzQKDxdhWxYi/C1429YQHEyvRwiJLouxkV2dT8Tw2QVNGQNnG0W8Xue4rRjPdrnOUYwFhLtOLGwvJ3I352hzm6qhZgXDsXchJJsD/3IjIC3LVAur2ex0hLD/cARfJByarEAylxDYaic6wI+8AzvHCN9EFQzujs6UIPHIIXmHIQqflATewm1/lAgZwOJihCdU4QMrHvPhjNHm3jiOo0QyvNH/HsObp3bMUAkB8Dc7DVW/R9rJG1IV498SrEgh/130/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiZJv29P7MylvM47Hmd2FI0PG2ZCmGGYfeEfnc1TEsk=;
 b=lmgzem4744IZAu63wIOxdbPshKp+hg88KN3KgrCj15AZXQa1oG5QPpSKxtXnjxV/T+/hSiSowB63rH5A/KjUGbva4T2wGoitg+E+gWk+vjf28z/G6PAg9ozfwhCHVDXNMl8p/cBhCjyykeA29NCiBE4H6cHXFB6PqvJOqkLdXIPsu4jNYPJA9R/CJ96O/XBHAuiySCvKrwaaySST8DuDvSNYwxf1e0wlkuRVY55/aplkGdvEOYqPhHmdyoWqFtoD/c7nydFsjm56+Q0BxVTZmijaCCp6RQ8P9XPaPhjgxJCMC9fr61VVPVZM2zoABMianXP0MiMMSWya3WDnQBMwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiZJv29P7MylvM47Hmd2FI0PG2ZCmGGYfeEfnc1TEsk=;
 b=R3fbgxHyBDJVzSWvHgrtquPhLKPW1pbRHVXRwhWH+7txaOiOWmmdET0HmvedN7FlHcplCeOJGAn4TrkO71LbyQjh0VVdSuOwwfv6sQOPkN0ErbLpyoUOvDOZMa3uR0/twv+84/6yBN7CMlRAjN4BcCKlFwvXaoysEad6tmWLl9s=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6869.namprd10.prod.outlook.com (2603:10b6:8:136::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:56:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:56:39 +0000
Message-ID: <afaf9f0e-b29d-123b-68f0-38e4a741e07d@oracle.com>
Date:   Fri, 10 Mar 2023 09:56:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Do we still need the scsi IPR driver ?
To:     Brian King <brking@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
 <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
 <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
 <6c1f12d2-9211-85ef-dfd5-e091ea1559d7@suse.de>
 <b7c0f38b-b56f-761b-9ce7-7b3d67a564d0@linux.vnet.ibm.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b7c0f38b-b56f-761b-9ce7-7b3d67a564d0@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:207:1::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: d267adf7-c618-4c6d-cade-08db214dbe3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TmBJA+N3m7ABdeG3agASW5D9p2XFtC3L0E+3S2rtd+5wDObr3GNvtIIDrPTF4uZu81UcdjncJ9XY9FpxN8WhFM0vYS4dOhWsDgNxMDxl6pGxegl6DawjLmNF6HlYZjDhREj2tfyS4AXGwCTkvj2s6iOFILirHNuunN5a8mhcbfSnI4n2eaFNJSyQPa7cyalLlBW3OVdx2cf/yHrvvV4rzptSfAAwATyknLodC3V29Atc84AFP7UoPebpdiipOf/EiguJnRK14z3tu2USu03eNtk5vdGSm3oBbqfulR1rhOq99IJDLFsLqEMkymcSulRX5JHKXxw2ISNN9QaXiIXipaRFcq2YLAt9dzZRFPIDyc4Gp5GISycXBmvGfx9xbdyNawv5+ZKYnFH8LKQN9mx80XeuujQsC0YDA+qo/lw72SBjDEcZfTQcJ90qMu3qZe9qB68l6EVy9WhVEj3VZAwkqtuihPToXDf5YDb0ybKCivFV5S7sSCvvltSAjXBqUWy53gwEcesBmETQgDUr64wj8NZg4GKKKLEeUjOi9Ouv4dBVsDSidJzu3UAWyRzta4/vwRIUtgad7W10CCyBA8eCIAie+E3mjiuWeE70KOw9wJliu7gyzvoLXxXhNYGhLOIujZZJrcuXbUnAzWvyXGYYEp40FoTvPhmvd5jgTyG1eY9Q4I9ZGklBv3AKkfFsCYDNA8OCeCnHP7ydnQ2Q4vK1H6nrVRwARNiz+GV4S5GedwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199018)(2616005)(66556008)(66476007)(66946007)(8676002)(31686004)(316002)(6666004)(41300700001)(26005)(83380400001)(6506007)(53546011)(6512007)(38100700002)(31696002)(86362001)(110136005)(186003)(2906002)(478600001)(5660300002)(36916002)(8936002)(36756003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWRMdVVVRUxaOGU1dEloYUd4MzM3RklNOC80SWZBdGI1eUNwdjVZUXFVTUkv?=
 =?utf-8?B?cDR1cFpxQXlvTVl0dERVKzZ2L2puQzJRSzF2eG1KU3ViUUlwN3d3YUNjR3pn?=
 =?utf-8?B?aEdTNlVIaTNSbzVSd1hNbkpMeXRKTnhSSG1rMnZ4bklPVzN5UVA1cXgzS0Zk?=
 =?utf-8?B?N0lacTkzSE1nTitFYkliVmJmUytXZGI3M1MzM2FTM0hvV0ZrSktiR1hpMlJ0?=
 =?utf-8?B?WllKVGwyUUZqd1NEOUdFZitWbzY1bE5lVnhvMVZuSmtLWGJhUFVOcWp2VUxS?=
 =?utf-8?B?TFFjSXFnT3NjMUJDd0hoSVVkMUd1Qnh2ek1OY3dSZHhNL1k3NFlNM0l3TjhE?=
 =?utf-8?B?L3VnMjY1MDdicmhJYmRYaUJKK2NONWZ3cmJhU1RHL3ZSVmVBR1I4UW1sVmZT?=
 =?utf-8?B?eTVDZXpaTFhLQTBiOGhJTm40bnNNVkNZQVFSYzd1dStzaGl1NU9QaXRRSU95?=
 =?utf-8?B?aHg5dXlzYjhJcnhTQitLWU52N0o4czAxRXQySStUSE1oazBFZWV5TUkxNmdm?=
 =?utf-8?B?NFVwWmtwRHdLNTlzeVFmYnpxSDBxOWFSNVJ0VTRjNDZ6cWk0U216T3JoQkpn?=
 =?utf-8?B?SExQNjlnMEtpbUxIZHk4b29mbU8yTVZ6dXJFczgxRnBWMVI3ZU95cERaaHF1?=
 =?utf-8?B?bEt2cDdlTTVaSWYreGVDa0YxNEhLbThzVVFNRDBkZTdDclliUVR3YTBEamt4?=
 =?utf-8?B?a2JUbGJJZWtsNXFMQ3FQQUZ6citPcXl1RDA4Z0R5R0ljWFJyUk9MWTBSUXk5?=
 =?utf-8?B?a3ZlWWFaVzlrMmxLUGRxN2N3U3BEWEc3aFBWNzlnUy9LNzlrL2lUcXFrN1hV?=
 =?utf-8?B?M21PdjlWQUdOV1ljZXZGRzYyUjNqN0gxb2ZoWGZaMHhQbXQ2QzZmWGRQWXBj?=
 =?utf-8?B?d3QwOVVtZDFRL0RSb1lqbklKQUtIaFFSUkJpa01LN2dPT2FBUzNZTDR6aUhH?=
 =?utf-8?B?a0FGcXlhTjJKMXRaeU1kMHdSa01iNUJRWlJ2MFlFUjVDVXpTRmc2QklwZEpa?=
 =?utf-8?B?K0hoRm9rNUkwbjFKK1NmSms5RmJoSWVYL3QzZmZLc25NS1RvT0IxRDNUMEJK?=
 =?utf-8?B?RmMwTU5ZeGt2cnA0TkFMbXpUbUtCaGR6L0trQkJ2WWdoci9saWY2bFVKWHpC?=
 =?utf-8?B?bndBY1VFOWdaM1VMcHpvNkZUcnRHR1ZTR000dklwNFNxcjN3NnpJWmo3Ykho?=
 =?utf-8?B?SUc3VE1UWTdJbzBrVTUyRkE0ejRIbXJyT0l4Zi9HOVl1elNQcmlUR1ZveEZW?=
 =?utf-8?B?NzR5L1lUUXhRNGtSTUdPT1kxK2hkNTJqbm1QSEc3RXZ6Q0pOUjlqeEhlUUVm?=
 =?utf-8?B?cU43dC85NDFvQ0JQdXZyS09PN0VJMVJPcUdNT2tIZmpMajllSzVkZHNaVjg2?=
 =?utf-8?B?Z0orR0xGanl4OGJkMHJWZFhCeXU0QUVWZlZud05JR3Jld09YN0ZVQ0k1bFNN?=
 =?utf-8?B?aUREVjZaYjZhRzhxNnZMTVBoQ3hLdlpqYnhvRmxxZDV0UVN3eDBRSVBBZnlG?=
 =?utf-8?B?bmJlQ01Bb0piQ0h3ZUE0dUhockRPaDFXRVprd2c4L0pmMjVQMjZya2VXOTBI?=
 =?utf-8?B?Y210N3ZocnhKMWhUMFhqVXRNOUJyYk5VQkhGcFJaUWlYaGsxREY5TkRWRGt3?=
 =?utf-8?B?QjRHOHNLU0pqSkZReitWa0Y5SisxUE9ZSzIxNzFPNGhkanRZeHM0eEdPdllD?=
 =?utf-8?B?Mnhyb0ZNV3VDdVVjb1RmMDNzN0xQQnVzVnYwMDBENmdjdTdYcllRTEFCMGxj?=
 =?utf-8?B?bGd2TFR0cVBRSXpQbUh2V2UwdU9QTFZQK1E4dmpPSFlvVWVINmNDRjNIelZv?=
 =?utf-8?B?ekM3SDBzQ3R4Y0Rxei9Xd0hjRExPT2NoMWlIWmx4RUFtMHR0WHlsNTJueTk1?=
 =?utf-8?B?OFFkcFNuVjUzaGJYdDIyZmg1WEd4RjRpcVhIb1YraUsrS2ZYZjgrR3dicFQz?=
 =?utf-8?B?ZWEvMzlRUHcxTFNpRFMyYlhMT0FQWFkrRG0rdElQK0hmUHdUd1ZCM0ZBSWZ1?=
 =?utf-8?B?ZFkweERsUGJIZzh2ajRzbjJ2NnpQNlhPcjZsZXVlNVFTQ0NKWlIvdVJUa3lG?=
 =?utf-8?B?QmNlc3Z1QThKcjVNSnJSM2x5TDl3ak9kRmdDVVo5SVhGTFlFYXNMbmVrSnlq?=
 =?utf-8?B?UUNXdlEyazVBeDEzWTVRZzB4QjdCTTF5Q21wTndDRDlyQUZaWDVkTEkwclNB?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SZYk43DTVDknqud1+9V3aVW5dFvXaMtztGKodADLCJecoUvs14CepnZPHpIZxOdY/VrEbQt4mJ+Wq/CxVH+D9hoOOI8fX+RUy0JWgxg+YMo7yhe4Hhja/q36+TygCkyzI1nJH/0dEsm+YMjM06pUgFqRjhVPrVkzm2jZJUo41crlq4U6jvAEetAQJUDePVg1FYiZD0aiWgpBgUFdO7HV1dV2SyTpMmyde8LCl+UE0gs54JG+gu7edIZDAneG2v1/VwB1QMY/fL5poOMznsDYJLsGE5zLuh1k0V/8BJt9O+HDL5IwbSh6vflG9OxZAN9dT/JvxCb9LRbofyQJ8kTtOtTgY8QkvtrbTEzDBQwQPLKjMq/oIyJLV4c8BhiLIB3S1wxA9SNnPCzTiQLnzozsmAemae4XwoNB0r0H1/ZoCCDu8/ZWPrRUyrxzhU/XP2AMB1HSEHgRO2/Id8kd91S31dcbXxKlIXv6z9Cjz6RD/CPgpf6C4IXtT1i7G/2TuyhSgHyjRo2LrmMlWC/TdUIAiUEM0KTWPO+oxeD9zYqb6DuozbS1EEt09n6BXLroRu929YVqKelNcDLO/tBDdj3b/TfSlvLFB+medd8MxWVSCusRNSBQ8X5nsYXhTdCVd6IzL0E7O3/Z82qDpThTjMnog04hH+ahTd2Ke2gUhL5Gp/9PLAjUgYdzHc2xvyxFVhp6rWriYWxUD3uBZhk0m3PJ7IYF6r14duSwniI7P7o4boEqbFacRchzqqpacceLBMIrxpygUoh/Pp7axnd2zqP/CjpXbqMzIVbH1Qp++oSlTvXJQq86yrrUtA6U24SI/4YGM7u1rOvRsoPpTQojjLdABre4uvpt0DBsSMi/TmmSihgQxWDls8XLHR97HE3HVZLF+dQPY7mUNLx03NjEV1kOEApPxn8dmWMSDqXPmDnM6tI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d267adf7-c618-4c6d-cade-08db214dbe3e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:56:39.4803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62gdJxJkc1FDll0wJeQOcVO+7q8IoIc3K5JBms3lUrG3pNTGwLrXiIlxV4iPyL39VwhRGG0T0wW4Gn4VmEPmOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_03,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100075
X-Proofpoint-GUID: XHXVpkGmhO0WafTx6ADFvEd_6qULXNg8
X-Proofpoint-ORIG-GUID: XHXVpkGmhO0WafTx6ADFvEd_6qULXNg8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/10/2022 04:36, Brian King wrote:
>>> I've made some progress. I was able to dig up the code to move ipr to use error_handler
>>> and have gotten it to compile, but haven't gotten to trying it in the lab yet.
>>>
>> Hmm. In which machines can I find an IPR installed? I could go hunting in our lab, maybe I can locate one and aid testing/development ...
> Any Power 9 or older generation PowerVM based system would have an IPR installed as the boot device.
> Additionally, on Power 10 systems, ipr SAS controllers are available as an add in card.
> 
> However, the SATA support in ipr was only used to attach the onboard SATA DVD. Power 8 systems were
> the last generation of systems that had an onboard SATA DVD. So, to do any testing with a
> SATA DVD, you'd need a Power 8 or older system.
> 
> Right now I have a patch that removes the SATA support from ipr completely and a patch that changes
> to use the error_handler libata support. The one that changes to use the error_handler libata API
> adds a bit of complexity for a function that should have few or no users that would need this support
> on a current upstream kernel, since only Power 8 and older systems use this support. I'm getting
> a system setup to try out both patches, but at this point I'm leaning towards the patch that
> removes the libata dependency from ipr.

Hi Brian,

I was just wondering did you ever get to test these patches you mention? 
Or any other update on this topic?

Thanks,
John
