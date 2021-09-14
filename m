Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B39C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B27A610CE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhINDpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:43 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44554 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239219AbhINDpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E1Uaoj024053;
        Tue, 14 Sep 2021 03:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=M2W0EfF9TsRpJPP+BWsQEhVba8SRPhsGmNTZhnDRai8=;
 b=es7K1ucsE/2l1acGF8wy1BXpzG85w5I8SlTNGgEq7gH0ndC53wbPdNAzeOBywOvA6zvU
 aD7IGy9/LtQHTwDE3Rri+fcupsFWyLmXioyChNTe/adSIvUcLdilXldTvK/V62AOsQsl
 h7KNHQ8h9+EeOUes4rSGU3anrLy5ucJqsFMZnJnepQdJLxFGGEwGJf0yKYKHAFZVbm/1
 87AK3jfV/t+VeZ1M+5jUBeyfYOMddrlKG9cHtfqBDU5vw48wItRRiYrydu2MjUgzKM1u
 2PvjXv1eFExjKPJewdEsNoYektyfIzHwf+KRGg7psJScSsM74ArR95WyKtIV5Vi4eW1C vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=M2W0EfF9TsRpJPP+BWsQEhVba8SRPhsGmNTZhnDRai8=;
 b=nz1UaIABHWDn8KrsD0lSD9H9WLLgaluX0F3Hg4Micon3ehK8ThQJ4Q0UKzRykaGJ+oiT
 Y8/ERPlQFkgUc+pAVLbB/NZqO+XqurEEh29fKvjNNVAYW8rorSrs9fSNpLdi8ipM8/1J
 MhMaj5hwUUaVy9VCcW3JJxfAdki41IRjfZfA2ecWhbWqwgIOVr42J7XwauVlQUiP15om
 Wv+S7y5keqZhJXEuQyf4MQK2I/pjXWLfaIdNTGXxs9pWqef9Fr3stP3qFh3/I3tmZNKg
 osv05Kv7rjm+U4vaZsDiw/t2h3jkaUcGmo60j6FfrpTw02emsf60Dw/C04XrzFyOcafK lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2j4s87qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f8hT097913;
        Tue, 14 Sep 2021 03:44:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3b0hjuesuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZHJVeIwO8hCYd8ni4Ep1tsdf6lXxj2M9gvTLY6S3NGftAmkkQYFWVAxszoD4Tvj3zDrWIJGhexOKb0z0oC29zSx2HUajtk3akSiOouh0nZLrv+QEuXgz1SOr0Vo3kUDhm8dkJkS0ZElPY6LeitPIN0dKu/o2143EQJjVuNsWAckr20/9Hfnr0febSEykVrwUxO4h9S5RnH+v5FJ86oRIvdsjLyOCHmbXJ2XvZ0BFiBFuVEPh3jvyhG3vaD7uSNLw1wCwguryeBqDKck/wOzMTv881q1AAyJtmDMIxI3QoHSm6B0Y5KJA8D25CwEfbiyHTXub0N7rs4Jsb1qW9NKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M2W0EfF9TsRpJPP+BWsQEhVba8SRPhsGmNTZhnDRai8=;
 b=ibBV2kLrpaWWrgJbuwBExB8sskGRcHbYNicSU4Ax3eFwdfPQ2mJnWENGOY/8WFwJ7Y3h7JAcJ903SHUHdz2OoogLjUuOYwU0T5jUpP/vD0DQinGd9ykEauYX5HFWl9LBA7uBVVC0Vs0IgiqqlpHFZQufX7WRf+PRpr/OG5Oksdct9LFyH2eHnF/RxA8Sy1zSIyqgGSS6dy/xnGppGDQBcO0KHsHNvXDZu5pHLihhPAQvEJDtL3hK6QPVLnve/4nxQw3vM5kBFkDvgO8AVUHvTgSNw6g286EytQiriqa8AaVAz6XpE1mZFHnqzbt/BDjwbLs/+h6/SapnlN2r7l2YPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2W0EfF9TsRpJPP+BWsQEhVba8SRPhsGmNTZhnDRai8=;
 b=JTuR0A3IcgEQ+AFjFwQwLP4w5PY2nYyA8JxVne6HiIFZZ63NM1Yuhh+rCX0IzZR5yzs2Bz2DUtKj+k4JH+yWIzrRZ0dgs14REr3wkOP14cPzO1e8/V14We0kQynKIpypsZn00txfrLloeFgdqDs47IfPUoha9nYYe1L7bJaG7Yc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix cpu to/from endian warnings introduced by els processing
Date:   Mon, 13 Sep 2021 23:43:51 -0400
Message-Id: <163159094717.20733.7806392260547542403.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210830231243.6227-1-jsmart2021@gmail.com>
References: <20210830231243.6227-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75fda376-e38e-437b-667b-08d97731eb8f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502544974D5C044AE1A45078EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 28nSa1V8rkYXE/2/X5G5L/58Aq16qS2UaH4+5aJETR855iHl/iKGJggcERk1Sp7cJXvj8QucGpnLQv461VdUYje/R1m/9fDxeps+bnv8DAfYZzp4dLTtxJXhoEfMKFH5qKZ2z/jeMqDsJUgWqIaOrX9LxgGTb5msAQkyElX9rB+QSDRZFXBLhNKPAS7wcnwlX5aTQzm8V90bbRqQwgZL1D4R0Qg2f4TQ2Ym1ZSAmYut7Fre0jBaklP6Y9D2SuGmy8ckYHO1oYt2vn7M+zkk0TKZlVepEJytcqJ03/9e075nKIlseYAu63dJlvx/2LJO9L/r18o2Lt38+kNaMaMYb4k+HV2bkuo6vbL0Ejb3qXaSZJmylhqE0/SnUN8DiSwYSIypOLSYzJuNlMR2cWj8YSAlIDEj7KNF9yg5BNrE5VAXRE4ajv4q4/D8jV1HAZ6etHhL3+X8eVqiEdS903rZ0q504JyPgkuk/ahWpGDLaK72ir1FjdOfyWiIP3jiWY+wC+ItctnLY2ZPwHYc4HM8CZBwcelEFoiPn+nwcIqB9fDtJdND7qJ7J6ZzfvcJuXObXR2+hGMwxJTEpB0KmArWLNcRVrTMW3MsgTlnfquwTy/XIorxTScvYiV9Qtwli9HLTwiQhAGq0f+JL8jUtk5q2nOVkN9TZJsHI0MTyWaUExLcKzeR6WU9QyenDHrewWCCIq8m2IpdH6ERc30JLC6k2TlcG2u7S4xXEVSw7Ol6fGMQi5WBmfAktC/d8JZu4pBU3WH7hnKt80R+ZZNE6Bl2Sh+sH2hWS09x0CJ29ms79Qlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVlZNTVGWGg3WFlOM29MVkxyaUlOdUl2RWNoU2tOVE5tM1VOVHY1N0l6WWta?=
 =?utf-8?B?dVd2ZVJqVnhqbnlDekxJK1FFdzljSTVjd2UwcGU5d2Yrc0IzYU1kU0ZaSzh5?=
 =?utf-8?B?V0hNRGJFQWU2Qkt4N2Q3N29IUE95M1NLc0xuS2JVSFJRUHBubi9ERVI5YkZW?=
 =?utf-8?B?cXYvSjdoRERLNmE4ekJ1MzhOaGU1WGxRRG1Qdzd2SVRUR0NVRjdBWW4rcHZR?=
 =?utf-8?B?aTZtYnM1MkowNFZyTk95eUs3TXF0Umg2VlFEb3N6NW1ZYStPZnk5bXo4Skxq?=
 =?utf-8?B?WDcvRWY1OWlOOHFIRGdyQmsxeTIwbXcydEs3UjlWWXlRUFdHT1ZhQkVabjBQ?=
 =?utf-8?B?eTBwV3IwL05Od1VMemtQTWYvOVhhYkxWK3FIMU1oQ1pGNnZHS1k3b1VWQm04?=
 =?utf-8?B?RFBQdHZjbWtlWGYraDV0VGs3N3F6K1JvbXZzbitrRWRSdnl1U3BSUmxJN3Fy?=
 =?utf-8?B?ekhaajV6WVc4bTZnSGFxR3BteDIxQmg3NG0xVzNOd3NLdGNibjh6WHFod2pQ?=
 =?utf-8?B?K1Jya3NPOVVwN2JZdEJUZHJQUXVHY1hzUDYwUThIak45TFFnNGtidHNweVBp?=
 =?utf-8?B?YWZTajZaYTNqVS9YdkpxM2g3ZHlYZVczTHppYzYwWDVaM2lRY2JhUmQ0bG5h?=
 =?utf-8?B?Mm4rTDZYZEpqRDM4SUtmTjB2UmdtNW51OC9yVUZWcGZSSjVyekZ4TFJlM0Zy?=
 =?utf-8?B?MXlXRjJRbUVqR2JpOGF4bVpsMDRjUG1sd2JueFJTUEs2aGFSSWhVVlp4ZFVW?=
 =?utf-8?B?dDFFN2o4YXRkeDhBS05ndXRudDJMTmxGNWFvUkg3VGxQYy9qR1M2N0ZXMnlo?=
 =?utf-8?B?TXpYOXIrcEx5T3Iwa3UrM1NnZmJOQ0Jwb3hLTlc0ZVo3MnhCQ3BSZVpNb1hQ?=
 =?utf-8?B?aTdFZ0xzbUZ6N0hkbUZ3aTJYZmRBbGVzdC96TklVU2V2RUVYc2t3KzVCS3Ev?=
 =?utf-8?B?VXVZeE83RmRQQ1FkTm1TaXl4enR6UnhQT2NwMlFQNzV3UStCcGg2TkNEUnh0?=
 =?utf-8?B?NVZHbTQ0NXUzUXZiTEdqTHV5dk1oMElrZWI3UDlBUVh2K3NVRUk2RUY4Q3Jk?=
 =?utf-8?B?dldFc2tVaGdmbDF4VlZoOS8wVWtkMnlCVWh6YWdiOTYwQ2ZIT09jN2xvdkdF?=
 =?utf-8?B?aTdreDdBVHFsNVJaZDlhdEtKM2dmdTlLOTlIcmttWHJHKzBiRm12MjFPcUZN?=
 =?utf-8?B?WTJLRWVUMkFUU1BWdEJDVWVwRWpQZHRoajhXcXlLcEwxYXpWd1lUeGg4VjBn?=
 =?utf-8?B?UXdRcXdJQnNNcHN4cElkbGVOSG1NRTJ5c2RMNGgwZTV2QTlKYmprNWNzU0FQ?=
 =?utf-8?B?M3YvSnQ0NWNwUnk2dTA5RFBFeFlyTW12OVI4aGI0b3loKzlPbHlkaDM5Nkw5?=
 =?utf-8?B?c1Q3Y3A5Y251R3hzL2FQSmxJWndRZWlhQ2JJV0U2RGllbkZ0MjVJV3g1RWM5?=
 =?utf-8?B?TVFKVlRUSkYyZWZJKzB6c2pnQytBaUY5V0ZVSzJCdHh2cHc1TGo0Q1RoWE03?=
 =?utf-8?B?TFlkQkZodk41RGIza1BaNFlxTjR2TUxtbkJJaTV6d0RocVZtS2QrTU9hWjRy?=
 =?utf-8?B?d083VURDSDkxWWVJRzFvNDRDR0VIb1FYQVEzMXRMRXBBY3hqeFVnZytzMis5?=
 =?utf-8?B?ZmpIYllGVGt5TmkwdXBIZkF3YjFHeXloY3M4ZkRBMnhqMkMxN2tuMzhyMzdX?=
 =?utf-8?B?QWMxbzZHMGlNeStpemVld1pDbUEyWU9BMjI0RUZkckhHdXk1b3N0a1JEbUxy?=
 =?utf-8?Q?OMlcpk2Rv9wS0mEvm/8kBoHhvolpTnjkIkGmitv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fda376-e38e-437b-667b-08d97731eb8f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:14.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luQ590TBxpzqz6LgBTjZdfVP+RKp+K8txj4AkzxclkEThq4I8kQGKfIF3VS8Y7AxYLkzhXZKIoiMo4hsJ02u9hrfwxRzlwg1siv6A/k0FZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=984 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: k6mIJr4UJFzsO4jYS3qEUL0TB2WcQkVB
X-Proofpoint-GUID: k6mIJr4UJFzsO4jYS3qEUL0TB2WcQkVB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 30 Aug 2021 16:12:43 -0700, James Smart wrote:

> The kernel test robot reported the following sparse warning:
> ".../lpfc_els.c:3984:25: sparse: sparse: cast from restricted __be16"
> 
> For the error being flagged, using be32_to_cpu() on a be16 data type,
> it was simple enough. But a review of other elements and warnings were
> also evaluated.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] lpfc: Fix cpu to/from endian warnings introduced by els processing
      https://git.kernel.org/mkp/scsi/c/59936430e6a6

-- 
Martin K. Petersen	Oracle Linux Engineering
