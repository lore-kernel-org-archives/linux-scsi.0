Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C35C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF32C61026
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 18:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhFASLQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 14:11:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhFASLN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 14:11:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151I6Zsg108566;
        Tue, 1 Jun 2021 18:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sCk8E1HYvKXigGHxWehp+fd5yvN97fHYu9vp41tcaRM=;
 b=ZP9NxfD/g9+ijp07rVHfHQ9ARYM+f9dqLBnOB8Bmd7O5oygkPtIZjPXxjV+yenqOEZVM
 gizJGNJI+4Zh1sbUZ2N4s8AoGNvcRd4jLtjBtEetatDicKoiy5R95EZUGBcSKEJe4LlY
 Ow/r1EgiZRUzJS2CAKMKIyIGueVTy70C/ddvFqdsgXpEXFF+ETWZdEOembKPqAlpWFA2
 +5J43R875XkHk7sTEZttZWXCqjWPd3vqL+WDqY5HCiGLz7r8iw+Ym8dRBVNQIPy3Yjp6
 OuKjl13K9/TWsqUB+Txir5AAG2vHG4wbsAySL2yFD2vHbT/pp7dp+he+TGIWPMLaU+ln 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1secge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:09:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151I5so0116776;
        Tue, 1 Jun 2021 18:09:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 38uaqwhe3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 18:09:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NB7SZV6oVLQVkuvCDJwzqZ2kTQSikzrY9H5mhOUddZc7r9rZx/S9BAgp0hLnndo4APXdyund1m91F5GJRsvSlOWnLv6kYOcyoVVBKRAMNVRLM9Smpc09lvRDmLoEjZIfcZKM8Wuhmf9Zib42PMBjlAnEWE6Q3hz+ynIiWdYhA6VobqGETShvLx5VsITsJqyba446lp6aAuHPjnJT6doZEpKmJp9kQooMLjnjco2AVrBOJ5eFolRbs2Km43J6a+3GE6x2hZqcQIY7crURj4fexqf8YEjpYuT7TtY5nbQUZHk8GB9igu6DVBhGt2PsDG2/fY1V8ZBNNM0Lqd/p8KzS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCk8E1HYvKXigGHxWehp+fd5yvN97fHYu9vp41tcaRM=;
 b=UTYlpjOxcq1wOeNdCru8ujugRjTq619pOX1t2dw6C82C4GFTvkk0HudW45OhyStFBrCZ30w7rFyH5fUt5Nat42Ly7bGtW+d4BYxGX5gHsv8PwM2Qm0oM9bXmQGwBYaYbY4qI0ovoS17+Bskc0P9x5loWpqeTpNw6hEFLMHIfxQ80XllfJaBXbh+r3WpBNsEJDk059HtXmI7scnh+IUB+O0IdOHMCbPB91EzjWEyFjaHU7yESRL6y2C+w+Ub+pflur2+/0HAiYesGULPvXXp9+dWUqcBDOnJM1RhgkgDjGQ1/i9wnbBFTjOQeHlb8gKn36C5y/j/RqSs+zdy7vecQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCk8E1HYvKXigGHxWehp+fd5yvN97fHYu9vp41tcaRM=;
 b=h1oHJ6m2EElWOYB+axsmmUNESpGuQGLQ4rsjBKQaw6GTy8fvJGRDQ05S1KfgQcg6VIXKg1fSwLxAuuA6Gy29BFtK+t0FVatqqrf8L2nZ/IRtEsICEuH3+hDyfQbwGS1eOl4N5arilAmjUiHeKoqXUJVH4qZ0KcWYeRCLEH17EIg=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3454.namprd10.prod.outlook.com (2603:10b6:805:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 18:09:25 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 18:09:25 +0000
Subject: Re: [PATCH v2 00/10] qla2xxx: Add EDIF support
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <8f1cda2d-6a3f-9870-1960-17852aca658a@oracle.com>
Date:   Tue, 1 Jun 2021 13:09:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::27]
X-ClientProxiedBy: SN4PR0201CA0013.namprd02.prod.outlook.com
 (2603:10b6:803:2b::23) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::a72] (2606:b400:8004:44::27) by SN4PR0201CA0013.namprd02.prod.outlook.com (2603:10b6:803:2b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 18:09:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05f0744f-cd38-4fdb-6c46-08d9252863af
X-MS-TrafficTypeDiagnostic: SN6PR10MB3454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB34544B8FC0045B27A8C08B53E63E9@SN6PR10MB3454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2L014/mRWXHou5GFelUJzeNRBwS4Tt1NOZk7HiDj153KDKiUg9dw2HzJXSRXUyd0M5ZXCjzHNUJali03y80639SoPnlo1UGOK67QpSVT5ot8Gz5kDKaaYXN+8xSqRWHtEc2hnINjeotMR/4XB39LrMh4Lzal2he8zjEWNlOR0T915Mgzja0ThdTUuNTOVc6B7H0yy1H3q/qXWN55Oj07ef0rJL5/ExfcJyqQqIts021Rot8VFbdFuxGgpc4MM3sv+6kmmBwnItlpjHlEurt5GiQbCiGTlACucz7jD1KDlFNbfULRfqgYG6IaFqawgMUTMTTXGYE+oidp456s3Zn1HFzabmAsSHmuHG3e3nTcH+IgbNtVkIsjjHwezxYj5G9FA3D8GeC4ApRw/obfGbzN3RR0VJa/ewqXZYaqDys6Cs/usLK7spqGZZsuIbs7eYrL5NscTpX9y70UmYliywT1oBvIaZciSvDwuMnpa6bUHk8JuFGcQ92Pqt6o9ZKfCwby9yWXbf+AHkd8mNAJJLn8vnIhujVTU6W/mYdlZcfzMBCROe/eqDhIAMlVgW1oSWuCqP/ve7RFZ1HAzFIWcph5e8U887UYnhlC/YSAHYStQZS0RKsixkHIlQLTK2cH/kdltnS0Ju3sUgM+3d9n+pNyNlrIrj0WBo+/GvSIuaDDw8cZS1eU7Ruq8mJZw6TY9QtG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(376002)(39850400004)(396003)(66946007)(53546011)(36756003)(5660300002)(2616005)(86362001)(66556008)(6636002)(38100700002)(83380400001)(36916002)(2906002)(66476007)(31686004)(8676002)(8936002)(44832011)(186003)(31696002)(6486002)(316002)(478600001)(4326008)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZStpNWZaMTlFSXNmNVIvQU1qa1dib3NzdkZ2VkhydlF4VFljSTFMV00rU2pr?=
 =?utf-8?B?ZGRocXNYMDFFSVJNQlpKUVQva1kxdG9odW1LTlVJY1dkSzV3T21wWGUyVTgv?=
 =?utf-8?B?Y1FkRGxKUks3eFJTN3Nma1dERmpRWXBpK05mQW45TVBWMjY0RzM1d3Z1bnkv?=
 =?utf-8?B?UDZ5L1BhZW9BM1NQRWU0MmRmelhPMkdldDdmU0VldHRXVGxhQ1ZzT0hiWVlM?=
 =?utf-8?B?WldoamFxSncwdHFzTVRmc2h2UGFhM3ZGYXZ2ZjkxN1kzQ0VIdWVoeXFFbTB2?=
 =?utf-8?B?dGlsWnJXcDZEK1VkTzhvcXhWNjhyZ1J6dGUyaGc2eVR6K3FSZCsxcXRKWllv?=
 =?utf-8?B?eXg4aWVQSy9MZTEwQWZTV3dIbkhYTUVXY1dwSVYwNkMxTldKZHE5QTZjVUZG?=
 =?utf-8?B?eVpzblBRdjN3UXB1aElPbnBWcU9jK0VPVUg0RjZxZnNUNkFOZXVYSzVVYXhM?=
 =?utf-8?B?NVliZlVLcTFObFNZQ3VJK2lYd1RrMU8wSjJRZjBza3htLzIyN1VQZEQzVTl3?=
 =?utf-8?B?WmoralBad0lnUWVUZW9VeFE0STVBRlhSN2tpdkxHN0xXaUlWTEtJdDJZeTJJ?=
 =?utf-8?B?WDQwQzI0UGZVY3ZpZ3BURmllZWFZY0h3SmNDOWxTeHRCT2R2eGZnbE0rQjhp?=
 =?utf-8?B?UmIzM1F5empvQkFWZHFDUnc2bFIvVjd5RGo0NThudityOFNxcUgwa293WjlN?=
 =?utf-8?B?cVlCd215T2E2eGJLNk15dFdCZWZ6dTllRFRzQi9WUGlUOHVPb09yclZFOHR6?=
 =?utf-8?B?dDM0Vlo1MFpMTXFqQ2VCc2NlYW00eFh4eWNob2xFaDRYYnIzWkw0RW9VR2x5?=
 =?utf-8?B?bmJ5RmF1MS9KVzNiUjlxZnFtS3FZclB1OVpyTmZudEk0UkVLZTNwV2hLK2sr?=
 =?utf-8?B?Q3ZvdFhFZ0gzZ1BDMngrREZlWk1qZzRjaUtyYkIrQS8vWSt1VDc0V0xDN3M4?=
 =?utf-8?B?QVp4TnQ4R1hPWXllTkNHYnJPRXc4SjlFc0JZRERRRzhXQ1haRlFiVHR1TGEw?=
 =?utf-8?B?cnBRdW5kekMyUmhLVXhLNDlhT3U3UnVhVDNuRDAvcGFkd2pPaWtEOGVtbHB4?=
 =?utf-8?B?alNGU1pIcDJuc1owS2x3aGZJWG4vWDRmS1lST2hsUGtkbklWYitRa3ljcnlH?=
 =?utf-8?B?VFpqK0FTa2J4SEdLS1JvOWJWaTVPTnUwbjM5bGd4ckF1L20yQ2NxcUhMQi8y?=
 =?utf-8?B?aHZ6Tkc5TEdtaWZzK3Q2elc1aUtQYW5jMU9UcGM5SGljOTlqUW1VWEs5dlRT?=
 =?utf-8?B?dWE4SER2dE4xUHpGam5QamlzdGFPRE41dGJ3cHNKaEpjYlpGZFRFS0lwRVRB?=
 =?utf-8?B?M2pwdmUrRVA2T2dvOFdFZ3FtMTg0RmU5aWdTd09EMVZrVEhFTzAyWVZSSUlo?=
 =?utf-8?B?cFVoTVV2SmdkTW1zVTJVdHBpZnc2UTdyblR6OFFYNzdOVzZlTnNQaFR2U0Iv?=
 =?utf-8?B?azkzWmpRTndVem1IM0hMTXRBaDBZc0ZlRUFRUno2dXg4Q1RXV3cvTjZtUCtU?=
 =?utf-8?B?UEJDY1pnOTczdHBzenNFdWxsS0dVVU0zN3ZMUU5xaHJ1cWFYUGxrenJtNFdS?=
 =?utf-8?B?ME92U1BUbkZQNGszOUg1MmVsZ0hrSmpiNXNjT2N6OGxqNmtWUmx6RDRvdVdW?=
 =?utf-8?B?bWtjZzFUL2xuekRYN3ZWSGNxa1VLNnU1WFArcEI4SlJZRk5YRnI0dTNBeGV3?=
 =?utf-8?B?Rk84ZlFpTEJCNDllVjl6WDdjR2dWT1lDR1ZmbGRVZ2gxenNvZWRHR0NVN0N2?=
 =?utf-8?B?dlhweGFJcmJlV0hQZUNObWQyb2p0dVpWakRUT2o1U2R3NW84ckltZEE4TlZP?=
 =?utf-8?B?NHU3VWpHWkE4Wi9IcFhlZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f0744f-cd38-4fdb-6c46-08d9252863af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 18:09:25.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JU4Zj9Y6jsSBBuLoDcv79QYZ6q/VLn1IrtqarJorc8LaKg4gHrXkXaPVkc2e+MAKE/lF1jm/JZZ3G1DRbVhSwTx6VirGEQnQ1/rr+5D0ZHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010122
X-Proofpoint-ORIG-GUID: lAOrGfHOluBnHNvLV4hpqhxkE35Juz0U
X-Proofpoint-GUID: lAOrGfHOluBnHNvLV4hpqhxkE35Juz0U
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nilesh,


On 5/31/21 2:05 AM, Nilesh Javali wrote:
> Martin,
> Please apply the EDIF support feature to the scsi tree at your earliest
> convenience.
> 
> v2:
> Split the EDIF support feature into logical commits for better readability.
> 
> Thanks,
> Nilesh
> 
> Nilesh Javali (1):
>    qla2xxx: Update version to 10.02.00.107-k
> 
> Quinn Tran (9):
>    qla2xxx: Add start + stop bsg's
>    qla2xxx: Add getfcinfo and statistic bsg's
>    qla2xxx: Add send, receive and accept for auth_els
>    qla2xxx: Add extraction of auth_els from the wire
>    qla2xxx: Add key update
>    qla2xxx: Add authentication pass + fail bsg's
>    qla2xxx: Add detection of secure device
>    qla2xxx: Add doorbell notification for app
>    qla2xxx: Add encryption to IO path
> 
>   drivers/scsi/qla2xxx/Makefile       |    3 +-
>   drivers/scsi/qla2xxx/qla_attr.c     |    5 +
>   drivers/scsi/qla2xxx/qla_bsg.c      |   90 +-
>   drivers/scsi/qla2xxx/qla_bsg.h      |    3 +
>   drivers/scsi/qla2xxx/qla_dbg.h      |    1 +
>   drivers/scsi/qla2xxx/qla_def.h      |  196 +-
>   drivers/scsi/qla2xxx/qla_edif.c     | 3472 +++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_edif.h     |  131 +
>   drivers/scsi/qla2xxx/qla_edif_bsg.h |  225 ++
>   drivers/scsi/qla2xxx/qla_fw.h       |   12 +-
>   drivers/scsi/qla2xxx/qla_gbl.h      |   50 +-
>   drivers/scsi/qla2xxx/qla_gs.c       |    6 +-
>   drivers/scsi/qla2xxx/qla_init.c     |  166 +-
>   drivers/scsi/qla2xxx/qla_iocb.c     |   70 +-
>   drivers/scsi/qla2xxx/qla_isr.c      |  291 ++-
>   drivers/scsi/qla2xxx/qla_mbx.c      |   34 +-
>   drivers/scsi/qla2xxx/qla_mid.c      |    7 +-
>   drivers/scsi/qla2xxx/qla_nvme.c     |    4 +
>   drivers/scsi/qla2xxx/qla_os.c       |  105 +-
>   drivers/scsi/qla2xxx/qla_target.c   |  145 +-
>   drivers/scsi/qla2xxx/qla_target.h   |   19 +-
>   drivers/scsi/qla2xxx/qla_version.h  |    4 +-
>   22 files changed, 4895 insertions(+), 144 deletions(-)
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
>   create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h
> 
> 
> base-commit: 39107e8577ad177db4585d99f1fcc5a29a754ee2
> 

Thanks for splitting this into logical patches. I will review them later 
today.

-- 
Himanshu Madhani                                Oracle Linux Engineering
