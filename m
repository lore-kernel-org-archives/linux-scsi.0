Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F768C6FD19
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 09:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjCJJ2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCJJ1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 04:27:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4F87614B
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:25:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx1LC003614;
        Fri, 10 Mar 2023 09:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=lmtqb4hp7Ey0Ua1uubhAx66pLF2bkEih7wYL1E4v/js=;
 b=FbuND+QzI9HA0B9kDK/z8sNHbc7AflkUkihcL+0kOoWEWZdJv4JLm7B/yo0hO0D0nxLi
 9JwSLJRO1QG9H/XqOts4jNOYp3m7p/zefvJ4GQffWIGh2L5onXT90qWqXyEe5krjoJKm
 eV0KrgU5NEKbWT4t6AVEz5lXF1wZ1t8+vhXmVpgD3dO1DSTHSSK7MYJsN5WV8Kzfc6ET
 xgecY7csahOo5DMq8KRsE9ZAMJ4+VGrybc7Sz5RR1GYOTd7hbu/w7qJW0Gl+38genF6o
 Vuz/PyKbg2y+Kav8khtRlmIapjU8ebEnqLSOPfatN3u0l9YCFfjCC1tSeYfm3dq7vL9e Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wvu5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:24:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A7wlQu021680;
        Fri, 10 Mar 2023 09:24:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6frbgdap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 09:24:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+fi0rb0TTbAcxhJhAk58NGToLYDCXeZgFfFtm5BMpvPaZ5gHnc2aYUEhAtkBWe+hmpnUIWvnLAuofU5Hcige8khSMLOIhLIkbSf3a0HGg4TjzcQBLzCkNMfOSWpwo6uNbukpfJjSVul6AR3twxaTJ9WCDvChXtbT11gDkJxj9EQr8yu8g+6mjVTaaye5Z9EiooVZa3ayiwoKsrKUA23FF2xBqn7bMN/mjKJU1ysFLW91JW0/RRj+TUG0YbDXcPfqYtqL7If7wzohZQMO8iRqJrDJNqq/eW4YL0tyTCufDy1N/XbAYB8Tp+HynV7ebWpKCfd84mEb/6bMJsaH1kQew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmtqb4hp7Ey0Ua1uubhAx66pLF2bkEih7wYL1E4v/js=;
 b=DtZsXvAJJ35S1tVeRqa2k6F1t91Cyl1/VoF7n1Kks755iLY7DPCxfjZrUm+B9/iXkzIkj2wa2xx+6KfeV2Qgn1XDpv/JH/ZoEN/yr9FaL3SbcB5+Albm4WijMQzLa4+nunQU9aiwxhOkZH6UlzymUzyaLGWcs2UXT1DaPNR3dfkFMFHG9WoxwDmZLQsiFFjJOyWZT+G+mCS6PbYleZcmhGHXffRKQBEFZ8sgNrB9nGoYZpAckBlsxDX7cy8YJf4NDlfRIunsO6pqx32R3GLWTX0msTaKC2s04B0+BzlhWrTIIpK4xqRpBaqW371qYpvntpdbyVYM+cN0828/wsOO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmtqb4hp7Ey0Ua1uubhAx66pLF2bkEih7wYL1E4v/js=;
 b=RubP5Sy7Zr6OBlX451rpk8Z41fK+2n0tfo6GS38qWtyFwRkpdmKU043TQBCjwV7pqe6DF0rw+TbsOrhKtOIsuyjleD3HETl2191LAEyy1yCNvnzImuIIboUG92LXo5r/izwE3yrm14A1/RB3WoY09QoaywIOVC+x5kH2idCQloc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7595.namprd10.prod.outlook.com (2603:10b6:806:388::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:24:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:24:48 +0000
Message-ID: <9344cf42-b823-c04a-8d65-a62522eae3cc@oracle.com>
Date:   Fri, 10 Mar 2023 09:24:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 03/82] scsi: core: Declare SCSI host template pointer
 members const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-4-bvanassche@acm.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230309192614.2240602-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c77ead5-f346-4d29-e8a7-08db21494af6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4kFEo6yIuac406ELEuSxYY721NrF2y4ISpZ6406KaQUO/AUI5aC4N84nd2e1J2Ve72YAFWwa0JKonWGDaa4xMsi5aEsZb9kx+sxJvOkOYRylb9pKulq4RWmyljFt83hvQxdUkqaxX4PkKSayU4OxPX+V3GwQ8xfb5O4ix/39fpyvPPJx9iAEYV6sqEF5rmOxVAViM9OWBWJon7DHjGH6VmEdvjPYLUJ8WXPJaHbWWgJRV/LVXfmA++TnWwRWkwXW9bR0ZZNIls5p2qZt3WooHEfcJdjEZm5BO95rX2OIR0dXhuMnh81FlmgdX1fJvrK2hc/rKAIyP+Hc2g1XXt9vLnlpxGTkBoKeSlu5MqN/L5hieYcTNalxMhpZg2LUtg2GxEJ1e87D8QnrSt4FgLxNctSuh5nWElCXO4uh6mDC5uR0sTaLonHB0WNCQhytKg7/2VPTH0sJ8sDLWUMjNjpLIvqaF+kdXu9ux+UnCCj+u4RNbjIZetPtjTzW+jAjqPdIxLg4GyjM6LNFkxWyvPEI1z5ltJFiIXm3AK9fbyDclxueCzZs1xpXZ8cpmoycZFXMeCyFsJhgbtcQaeq5UqGoi2C1vaLmPGNgoRv7BP6a5ii7TTvRIsgc7yoVnqzM9zFGHn4YI2vV3ZCKzm0uC9Qq2uBs6dxekehfoCjKpHJ/8UGWeZVA6wP74gTWciG6+KSf/kYGR6puQ18fVnBzHAZEFPcsgXsEDSOAbKUbWfCJ8OY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199018)(8676002)(4326008)(54906003)(41300700001)(31686004)(66556008)(66476007)(66946007)(6636002)(316002)(36916002)(110136005)(5660300002)(4744005)(2906002)(6486002)(53546011)(6512007)(6506007)(26005)(6666004)(2616005)(186003)(8936002)(478600001)(36756003)(31696002)(86362001)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2tZMC85Skkva0lkWkgwNktCQ0crMVpFYUhCbW9rWUF3QXMvSmVEZURkRzRt?=
 =?utf-8?B?M243bmhxMy8vQVZTOGFRWUlYNDg1YWlXbWNvc3o2T3BJSW5UU1JDYVBQZUFu?=
 =?utf-8?B?WnRwS0x4QUxXYURseGxVQXFJN0lPTkJIU3Q5VVFLRHRPcjlyZGJXdWRjTDRq?=
 =?utf-8?B?ZFdlUnhldzYzQzZxMWlKajlqbFM1bU5WQk4xRm1IbjgvNkExemQ1dGlXdGFo?=
 =?utf-8?B?MW5kejJsclZYUWZld0xlaWVLSFV6c3pzUHhqallBcmhDOTd5NUJwQWszdTFX?=
 =?utf-8?B?clhYUkxxS096MGxWR0trQTBFMFQ1TnpQMXFvTXZRK00vZW9McjdWb1BrZUJr?=
 =?utf-8?B?WC9PTTd6Wkl4akZmQnR4VTM0WmJ4Yi9janNtKzNHQjZGU0VQd1NKRXV3Zi91?=
 =?utf-8?B?cktuMHR6amM2L28wZ1VqMmRvOVRqdkkyQ3FoWEF1VkJCanBSZi9IMDNpUmdZ?=
 =?utf-8?B?ZDByMnFZekZjMzlXd1E4YlFBZlhRdkgxaXZ1TWVBdUl3SjlreG9YSjBtZVBZ?=
 =?utf-8?B?dXRjeDhxQi9hakQrSEgwc3AxdU1FMk45YWZwa1gyTmQxaDJVSlVWWitRSUcr?=
 =?utf-8?B?akY1Yk9lNjVXT1NNd3M0TXlyVllBOUUrdTZWSng0YmxHN1lqTGRhb2RoRzNG?=
 =?utf-8?B?enJqMmN5S3VuS0FSSTBmU3EvZlY2SHdad1ZIU01waVZmUHlIRnJvblQvWHdI?=
 =?utf-8?B?R3hSRE9LZC85dmlxM2tUNURMbWh3bVllZjBDRk9wYVorQVgwakdUVTBqR05p?=
 =?utf-8?B?citvNFFKVFQzdHdSODRuT3dpK3cvbGtUejY1OXhkdUhycVpRMUdkdkZiZWI2?=
 =?utf-8?B?RzZIbUZGR1RkSTJMc2lrM1U5UXNoUFBGS3hjUnhCSUNDN3dPbjNxQTFIb2xm?=
 =?utf-8?B?UFFObExvY3N1blRmWC9FYjd3ekpyZkpPNDA3VGFNV2l3TGgzV0Vaek9yU0RF?=
 =?utf-8?B?QUYxeEVIcEZmZE42MGlQaCtkNzBJQTd3U2RydFh3TmZ4di9GN25meGMzRVZT?=
 =?utf-8?B?dEs3UXR2MTl0MDBseE1TUHdEbGl3aUZiSVVHMVZWVUMyQWJhbndQd1h1N3dv?=
 =?utf-8?B?dWoyR1FqeVhEQzR5QzhNTGFhS3BTZ3gybFZMdlJWeVdHNWcrd2ZacVJDbTNS?=
 =?utf-8?B?eUN6Q1B6NVMxemg1bDhxaERadXlaOW5rK1N5U1MrOG1WeEVSY2c2UTUrNTZW?=
 =?utf-8?B?ajdTdURhT1llRGw3NGN2ekI3U0paS3M0K2RyekVzb3hWTWdhaWk3bTBiYlJU?=
 =?utf-8?B?N2lwbWcrbndmY0NKRzFGRHp2WjdUMU1QeE9zeGxtT3Jiek9VNW9yeUh4bytJ?=
 =?utf-8?B?enExQzROd21HNUZwME9GaUJxcU5QL0tCVUJTaE0xLzBIbVFOa1FxSzREOXFz?=
 =?utf-8?B?YlVjRVZJdEZ6K3J0ZjhYTXNZRXZJYnI1MW0vL2ZSV0FoZ09hVjhVbHVraElv?=
 =?utf-8?B?YkZhY2NxUTUzVXJZWE5IV1NLOERjWVFMRlZvcXZXNlAyYlRiYnRoZGVPZHI3?=
 =?utf-8?B?WE9nWENCOGV5aStGMUtjSjE5RCs1RmpJZjlsem0wTzV6M24reWNTam1DdkJD?=
 =?utf-8?B?VmZDd0RxTm0vM0VtMnEydE5vOUtHd1N6OTVPQnlBTW01eWdJdEpyVktTS3Iy?=
 =?utf-8?B?UHBGL1hnRERmT2RMYWRNdE5TdDZzektzSXdjTWVvbjRQSzdSaWRNcWdGcFBm?=
 =?utf-8?B?VjBYK25mcVo3R3RqbnFYbm9DM2hoSGtKWTF0L01DRmxhUlJLeTR0OWlLaW1k?=
 =?utf-8?B?cWxHa2k4NGxEdGRlTDBnT1MrRFpDOEdleUZOS2t3bTV0OWMyOCszZk5oOXQx?=
 =?utf-8?B?alg3S2dsNjY2bW56RWU1a0IyQm1obUJhekNCVEoyZUI4eEhjOTYvdm5aTkJn?=
 =?utf-8?B?Mk5QbTdUSHlQWmpOR2NjaGc1am4vbTN0TWNGV29WS1RTSnhWaEVHd01LeWZX?=
 =?utf-8?B?SVR2emdNclRPUnRuWk1wTWlaOVFRWU50TVRWVXlOSkY5VmRhNEg2RkJrbTNI?=
 =?utf-8?B?d0dVMU5qUzRHRXhwRmdYMGhJcHhhSXp2NVFEZ0NjUHRFUXdsdUhoc2Z0YVpk?=
 =?utf-8?B?VTdhcTVoMjUxaEZ4QlgydDJMVlZhSlZkOWxpOFYxWU9Jd2VmVk5kaCswend0?=
 =?utf-8?B?Um5qY3Zsd3RMblkrTXhDOFNkbGNsUlUvUzBlUUVkKzVudEZCYTFOTDVnemxG?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aOHNz0f0za1tp8Sato5FSAUp7wf1Bt7oPjFPriNJBVq5I4+maCb7sBCG1j312ME/TenQid6L0LG+qk4DFZ8OKohU8hjKYbO2hjbu+ir1J2eTwPIzXnFFZexDVUogXxxXge1T5Ri++rbuOoWIZjAnI0RBldANV8Vi/WlDSvguRG0l/dO85mK2O+Wa+p+OGuFG8HQ1LBu6tafCAAKc1jGFO5/hWyqthhTwm2JLGhsb6pIM5dVqiyU6Q/SZeQTQB9ScPs2OkP7/rLgZLqkvJDvuVTvTNtuifkLrgse7dJsIHYE18hu7XDRgM0JyUpUQWqUdLFZqe6iTzADiYl9fqAcf6xwH4JZc67Zsbl1PIQe+YavEc/KPkTkwBiU7u9NjZ4kM7JmuTwQchEeAJxUV97N8Fz7K5fsMv5iYr0TYZa+Mv+1asjujtWFYg7N1bnltbZD7GDpoEICkY9r7SvQGifhdBIRmnKNY5tJ4iB7NuCf7QGyFwVYjJhGdR/tg6wKibPnCe1vgav6lvX40La0JQOEjF1TbSJEYnBTOOLRoAzm5E2yzxQcZTrWdqVbw+NMOCHgBSUJN1gIMb7GtmaZhcO7vkAyU87803C3H7N3klKm0dV3KO0e3uZLX349K8LHnrhm0jJ/mzA96Dfx6aa7y4Yimkn4mtgUuFFNX1bJ5EKplPCyz0d08gCLeMDeIvZ6iJi/3uRr/uK8fJ2xPgDhgXJPh0P1UePm01S5AyKAOALcZ0AEFpHJ9PA4Iq4zSdS94z/oBqSJyrRRfvO7eMW69ss8xC7ie5D5RD/EwYvWVYNBjcEOUohKjkxRbUyAixLQG94DeZ2bHhSVi1daCHMZyd6WFvCihxP3z28yeEZWIVNsnTx6/a8dpXKNaryt5WT2TmVkScyBEtjf65MmavdrueWG1tg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c77ead5-f346-4d29-e8a7-08db21494af6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:24:47.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gzAiG9Ge5OL6t6GE7GyOApfLnkD8TQH3iBWPE0ohxJzbZlspIf9uBF8Ae5AE/93ialtQEspsKvdacY8gxB4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_03,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100071
X-Proofpoint-GUID: IFTYq9OL3nhbcamGN-bweWUq9nKIg9vB
X-Proofpoint-ORIG-GUID: IFTYq9OL3nhbcamGN-bweWUq9nKIg9vB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2023 19:24, Bart Van Assche wrote:
> Declare the SCSI host template pointer members const and also the
> remaining SCSI host template pointers in the SCSI core.
> 
> Reviewed-by: Benjamin Block<bblock@linux.ibm.com>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> Cc: Christoph Hellwig<hch@lst.de>
> Cc: Ming Lei<ming.lei@redhat.com>
> Cc: Hannes Reinecke<hare@suse.de>
> Cc: Mike Christie<michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c       | 4 ++--
>   include/linux/raid_class.h | 2 +-
>   include/scsi/libfc.h       | 2 +-
>   include/scsi/scsi_host.h   | 4 ++--
>   4 files changed, 6 insertions(+), 6 deletions(-)


BTW, I don't think that it will do much harm to update the 
scsi_host_alloc() prototype in scsi_mid_low_api.rst - I am not sure how 
up-to-date that doc is....

Thanks,
John

