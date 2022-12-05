Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A237C4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 09:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLEJZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 04:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLEJZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 04:25:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5663FBC23
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 01:25:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B57WlNq002205;
        Mon, 5 Dec 2022 09:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wp2tCmdP8itsfc6U5ofBkb9OpMkRvWqPkbrd+1jZfaM=;
 b=GZGrGLl4qW0Oeyg7V84m3FDlzY55ccP+CqPOYfA9PRgmmjfYsQI2Dg2jQ34QMo7dDHo1
 2laWeBLxYVzqWhBRRcP7sxArNK0kWoUSmY7aSXYdlbFhAq7t9iErqjMuKvVwM5ShuCnN
 M7o9UnBFI6EvIEM8u8fCkkgaMDS15P6hyw5rKbLutnxp5q/vM4PBuQe53jlYAOUsh7Cj
 FUJcDG/rv8vsD/pDIGW9gQ8CybSmDg0vYttkadqpCPfkPY+cGgda5GTZ+xx+uEtpmSnt
 BBnzWsUN16pInyZoJCrOQ2V8ox9D5HZez2FRqUJGyJ9+ow+2ib35qLzyy7fxsooUjHAR xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqk06y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:25:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B58wlRT021884;
        Mon, 5 Dec 2022 09:25:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ugduu0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:25:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqhs8QjZkr8gRs4LKjgdhQyryDC6z2vuubAU+jo8L5kGjWXDshnq268pMFfArUsE5cAFXkIosfzeet4XrOH+wTyVELwI1CguLZWVMQVFHKd7bAayIJaPcxs2OglPsB+lBIDMzcurjozx92jV4xeJqhFK6/AmunzcZxcO5SvrycuM6JWJ9ok4kOTjviD0e2ntCisYQReQSy0t8vjyszXaicNhSGXpAQ5plna7/vmq8L+kpxDuS4MRflwX82xT3A8NleKD5ldmRXaNbvzATtaIHhj+fsGpejifxGKUXgP6w5uLH0Q1s4PkJweUlkJe6U8X12v8pJXg5fV0EDhbq/uF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wp2tCmdP8itsfc6U5ofBkb9OpMkRvWqPkbrd+1jZfaM=;
 b=T8Y9492T1oFlx2LA3rVWZH1t6MPT4i5B6/onLGLU6XuDNVQELJTMkRVjXGvgdyUrAOu/ax46a6yAXz1GzoVuHGJgQNmLWyrp2b709rBnMkpkJwYEbNwK25t8zM3MaeQFkUy5DS2liY1GwCvgb8D346KJ0IYxvbJsSm9zpjWFHz5NnZqc6XyJ2AyufrPnxGCybZmTr/M1VmNGuhVPkcVdbZ5BgUdj/2dPsqSSB/kgaPuQFb4S7sV0YEfbrfmRWkQt+nwWFl1zK1U45nFhOWo+wEqYwE+DVZiaV0oLSeNbTkqKbkiJj6gKTrjGxCHQPph80EQIoe3mm9ol5Uz0L3EM+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wp2tCmdP8itsfc6U5ofBkb9OpMkRvWqPkbrd+1jZfaM=;
 b=xO/9uZBY7HlGgAc7a4IPHra28p9m5e2nF7tPOf2VWVFuo75SGqrQw5qVPn+Y+NoO+ltZrLXjiI8X8oLq29wJc8N3Z35s/oc+B4ZXVwxHdyJONkEVIDQXRs9UN8spF/2cmizCiBv/6Gr9UXxitkX5U0SWi/HGI+PHi67k1DtWJL8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 09:25:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 09:25:03 +0000
Message-ID: <9eeaad19-c1e6-f401-3bdf-a7c3d0b3ab77@oracle.com>
Date:   Mon, 5 Dec 2022 09:24:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5/6] scsi: libsas: factor out sas_ata_add_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-6-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221204081643.3835966-6-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0230.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: b14ca53a-0e1b-4446-de1e-08dad6a296ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGVyZL0oiwcHIDUMqc6QyaRvAJiB3WJtaZfbFDZHoIRKuBhKIDtTsRy7rCvIgXQXn9mWQ15tlgJO/KdOzO6EjzKquvyLSIB2mAFotjmCcuzqpngkbN69h4a+2HWlipzHJfMp72nI3Y2/MELTycFfTBVTiRA7DVUAoQh/bAJ/LKcW4QfgPK2B4VYtodiKm76xcTvZ6Iw+6+VphWwtNG9IEqitS42nLLtLfWb9HUN6lEwGUuqj8OhVGjsvbyAu3HLtPipsTgUH7gCAxaNQn8hCrGeY2m0eLkTYOp3v6UI8qIRBU6qG5C/NebYAhfOmi2zlzoSUfRdXrT+8CAIoqARXIp3vf5tKrgnL+ZP21MpeIoonDIeIj64XicD5ebtLMwgPGugk12cAuAooiZO893v7kE2COZCPo/qU+WvYdx+Ldu4o0vN9mq/6yBnboWkdLGLZdeHXe3BkjuNrBdCQ36+Ja0iEZR/ZP3TZJHkXizqg/sMhg8g6Ml+SXBH/R+f4iQesJtDQlQ8TMM71tRa7vCMgvYUaEB7y+UTYYWTz/YypwURBoBCdpHUDj1l/IFFGu3DtRAOfqrR6OmoL3K6tjC5lv6dbnZ5UhdI4m7N3rECWvfL96u3u+pSTkfvrFvNvWPeJbqVMuhrHBUWtan34grboUD8hFP7GOCJabsB1Fn0CBiHP7dEPaBT8ht1ZpfpfD1HB8g3AHvPvpMvTOS9rFW7qQmQ3SxrGLkgcmRJl9fv1E4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(36756003)(31686004)(38100700002)(86362001)(31696002)(2906002)(41300700001)(8936002)(4326008)(4744005)(5660300002)(83380400001)(66946007)(478600001)(6486002)(66476007)(66556008)(316002)(2616005)(36916002)(8676002)(6666004)(53546011)(6506007)(26005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTZjdVBRajg3QXBOaWI5REFNcHl6SlRraEo5Z0Nyd1dIWHJac1NDTUxpemJ6?=
 =?utf-8?B?UVMreG1sd2JzUGNKNzRGN1JqM211alRDblozbHgvaURkczcvZDltTkFMVjFk?=
 =?utf-8?B?NTJIVXJGSjQ4aWJoNnFQZ05RMGo4bUQvU2ZjODE4dDNQTE1BWWRMd1Z3SWdZ?=
 =?utf-8?B?aWpsdDNqOGQxSlFtUVdhY0ZvclE3R1Z4anRJV1B6MTZ3c1hyV1h0cStUcjFr?=
 =?utf-8?B?SE9SVmYvdXViYXgrZ3dnY1lJUkdKWGswblgyUGZBNzBWd0l5THFyS1ZuY0h3?=
 =?utf-8?B?ekR5SEI3SXJ1aXVIZ0pVa25xWWF0bTJiakJ5NVFtT2FZVk9Qd2xtLzJYcGpk?=
 =?utf-8?B?b2JwMkVwV1NQVklWbGthTkdackhzQ05TS0R0RlNMSTBmQ1VlTmJBeTBXYTdH?=
 =?utf-8?B?NkFZUmRtMThZNUV6UldYUG1SbGxZenM5YVNPMWRLWmtMY01OYnlFc0xaTTJq?=
 =?utf-8?B?akRoTURjaFEyOFNWZk9taUJVTklUTVR5ZmFscWplbjE5L2JRNkdWa0NFRFRU?=
 =?utf-8?B?MVhWUzRMbTlKSFhnRWRWZXp2VzFlUmZDb0hOdnJoWEZsRjdjQk9icFRUdDZ3?=
 =?utf-8?B?dFlTMFYxSzZYWlJlWGJtMHp6R2JHejIwQ1U5UU9XSVRZN2VpaHBsZkJaWThl?=
 =?utf-8?B?ZEp0UEpaWFhtUndCNEo4UFZnTDZFZWxFQk00TnozTU1XTW50UzJ4R1prVTlo?=
 =?utf-8?B?UW9GelNVMGNGM2gyRVFZOFFkeHFuOWRtZWJRdVoySDVjOEV2VmNjdUlRZXhQ?=
 =?utf-8?B?dVZuK2J5MjF0KzJnR29pYWtCRkRSOE1DTjdoQ0dmekFWYjFwK05neEFFRmk4?=
 =?utf-8?B?WEpDZGNDWW01OWh2eWZYN2ZyR3BiUkExV01xakFzVE9PRGFtQUlKVytyWEY5?=
 =?utf-8?B?VGJRZ08vZE5CZHZ6MmlEOWE4N0VUVjdhMmpmdnlaVzMwNnF4OWJNSFg2d1pB?=
 =?utf-8?B?YzdJUHJQaHRwN0xjc2dQWGpwdFpSMWc1MEkybndGMWQxYzQvK0VMUHByRWpq?=
 =?utf-8?B?dVV6SXVhakthWUpwZzVHUHdJNWtQQ3haZjVCYWs0RC9QTGptTWwvWHp5TEV4?=
 =?utf-8?B?dXM4dythdWxoRkYxNDhBdnBNcForZkpXeUI0U0JvakczbVByTUtKaWtBajkw?=
 =?utf-8?B?ZVpJdEVWUFh4ZTlLVEJrYXd1OEd6MGhjc200VklTRm4rT1Q4d1dZQXhiT0pz?=
 =?utf-8?B?N3JPWHV4Smtoa1J2TTNiSEk5bSt0ZzB5N3Zib2k3cVVjUk11SEJKZ3I4djlr?=
 =?utf-8?B?TWZtcm5wWjJ6TG5SRXFrRHJpWVp1b0ZyOXJwR3Myai85SkpQaVVlU0RYTmhB?=
 =?utf-8?B?SnZtK3hRRXRrZnh5b2hUbVRPK0FnOHpQc0lFb29zcUdOUit0R1ZFR3U3bGRZ?=
 =?utf-8?B?cFovcWUzOHY0cFJPTW10QmxwT2RNQkltSUlkcHAyWkxyTksyeUIxYzZGekQv?=
 =?utf-8?B?TCtpVUNVSi9zNnVxNnJ6UnRDcEhCdnhNbjNibk9NalhReWxWdXdqemFjbjNx?=
 =?utf-8?B?b1YxUE40RzBDbkQ1ZVY1RDlZQ2lDb0ZCWFFHRFY1U2kyTHJYdmhZRlBzcTk5?=
 =?utf-8?B?Z05zZmlmemlVUTVQRkY1ZDhhUjZxT1dWTlR6amRxY3oycVNNSFVnNUttbjMw?=
 =?utf-8?B?SFBxTEVXRGYzcnNQaWFlVnhyV0dnL0ZQQlh6WnRCdjdRUXh5OVoyUFBIRVda?=
 =?utf-8?B?M3R2MGJxQlBHS0cxQkFIU3NqcFFMZW1WRjdjc25yOGF4cFVPRHJxWmo2QXpz?=
 =?utf-8?B?MmZsbGtKd2NhbS9Kbks5QmgxTjlOK1F4aGpja1A0Y0wxTUM4S2pORVVRQnBY?=
 =?utf-8?B?cE11Tk1ibVJJYVBzNENYSHJPRHNzVHRuK25CV2xmREtETEE3bEYvSUxCSGMy?=
 =?utf-8?B?Y1BlRUtjSDQ2anUvVUYxMjJLRmRUa1E0aDNxN0dNYkdaZWNUcGdCaHN6b0Zi?=
 =?utf-8?B?V3RlYmhHR0FpVzFZVHB0eWJ1L21NeHJOZlBKWjJDdkJQaFJqQjJMSVhwSGwy?=
 =?utf-8?B?NVJUSVRLTXZoNzR1WVdRdE9kckZPeFYyc08vampzWlBYTHpFTldHSVU5bGNR?=
 =?utf-8?B?S3RTeE55M3JxRE0zZ0dQVzVGRlBsVXFWVm1wNHZOd0didWxUUmwwMjU3ZzNM?=
 =?utf-8?B?ZUV0U1dkNVI4ZnU3SlFRcGVNOUhzcnA3RmJUdTlaL0Z0bm8zeVk0RGk2Q251?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Z0h0SFBXelgvNDhXdkNHc1ZRZTlMYjhRL256Q3JjcHNLYVN0VEo4b05UVm50?=
 =?utf-8?B?NFgySnhZUmZDd2Y4aVBveDVWUHp6Vkg5VnNtaGg4VmU4WXZuQmVNbHRpT1NK?=
 =?utf-8?B?TUR1NUZVOVN6ZVRmSEFlWjliNjBYbVNaRU9pVkpRclZkVWpmcGVOK2FpeGdp?=
 =?utf-8?B?UzBQWGd4RFNaS1JDM0VSWHJvV09ENHYyWnN0VlZrM1BkYnVsSzBCR2djSVVm?=
 =?utf-8?B?WjFtWE8wdlpGUVRQSzNHWnp2NWNwQXZvZFlsUDZDeDFIL1M2eHN6cDViVGcw?=
 =?utf-8?B?WSt5bGswV1J1S2VyREYvbktjdGVKTjhianlqS1Z6OUk4SnExbnFaNTJxaktX?=
 =?utf-8?B?YTdRZEtNM0lFdGdjQy83dXFqVUIvUDF2V1VqWmt0WWtEYnhGMW1TVlU1ZWxn?=
 =?utf-8?B?eWVRN0V1OGxEWFFNeTAwdStJU29IcDVGbG1qVkNzekp2c1Q5cmF0SUx2bEl5?=
 =?utf-8?B?VDNkMHJ3emwrNytVSUYveWdJZ0JTek83U2doZHcwcC9nV2xqbjdoNnVOQVVP?=
 =?utf-8?B?OGd4c09FN05IOWFON3R5N0tiL0o3dGk5RUF2UGtQVXdwTjNBQWJ3bWkrR0Y3?=
 =?utf-8?B?NmdmTXk0N1psaWVGOC9mNkZ5N2xYYVJFTVRMbWRMZzRmRjR2TkpncHlaZFkv?=
 =?utf-8?B?REYzU3RvT3F4cXBXSyt5bGNHOVAxM2RDc084dzdVb1BqK201U2gveXBMcGV6?=
 =?utf-8?B?VlhSZ05qK040MmJOR3Y3WTZTN0w2ZS8ybERSMDd4d0xuVnZIREpFNzBvV3dT?=
 =?utf-8?B?dXB0dHdnYUhZbDJ0TXE3MWc0VGNka3VreE9uV3BnMm4rakxnVlloQXptNVAy?=
 =?utf-8?B?bGhlWVIxb2hsbnlOR0krYU9sTy9jUmRQbFhXaGJ6OHIraWtnNlBIL2JjZzlx?=
 =?utf-8?B?RC9NbTVkd3laZUVsYzlEQzZqQzlYZmRDeXlJU3p2MWgyZ0xHRW9rM0lSeUs2?=
 =?utf-8?B?Qk1ETndpUGVDeUlyN1JNYjJrWDJ6QkkxelBmaVQwemI2Qmt3Y0RtRXNkZHpS?=
 =?utf-8?B?OEc1TU16ajVTWHRKTmRudFhzdnh1K1EvWXMzSmJXMVVJZ1RoOUl6MGttRzNV?=
 =?utf-8?B?SFFqYUdQbEZoeEc1K3c0bWFTcFNGZTdMWlJjUmVucmk1Z2tLc0c1bk5yMmk3?=
 =?utf-8?B?elNEUUhQMWs3ZWxPRUhNRzlyUk9JUllPdkRuR3N1R1Y3MjFlNFFLNm04djRC?=
 =?utf-8?B?cFZYRkloN2M4ZmxSQUNQVTFlRGE1Z0kzb01iNEFrTFE5WEFrMzNkaUt5SjdZ?=
 =?utf-8?B?RU9LOXdQNUZseGlxTnVCMDNQVkpCcEw3bnFtZ1MwbDlZUUZkL1MzbVVQdVh1?=
 =?utf-8?Q?ow5aoPvxJWdOI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14ca53a-0e1b-4446-de1e-08dad6a296ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 09:25:03.3816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16l7rUwSU+5krXrVJpFBUHWhbxXYSOVuW6hayzh1h1KvPXL4REHVmz8LYznc5vNrzIgw9AG9Xek613vbW0zyzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=921 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050075
X-Proofpoint-GUID: vhrI_OMcsYYrsKEzEX62Y-U29eijcOnM
X-Proofpoint-ORIG-GUID: vhrI_OMcsYYrsKEzEX62Y-U29eijcOnM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/12/2022 08:16, Jason Yan wrote:
> +static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
> +				  struct domain_device *child, int phy_id)
> +{
> +	pr_notice("ATA is not enabled, target proto 0x%x at %016llx:0x%x\n",

nit: how about add "SCSI_SAS_ATA is not enabled ..." or use similar to 
the log in sas_discover_domain()?

> +		  phy->attached_tproto, SAS_ADDR(parent->sas_addr), phy_id);
> +	return -ENODEV;

