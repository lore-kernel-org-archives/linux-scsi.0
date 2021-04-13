Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FB6C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC7C61221
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhDMEca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 00:32:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhDMEc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 00:32:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4U5Mb159499;
        Tue, 13 Apr 2021 04:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hvtu1ScuhRL4xns2dIl1vrXLxNB1hmRCKSzJ9rwaPgw=;
 b=oSeVy0jYVa7VmDrTz1gHR6oxMMYgUOwEXi9Wcu4JbDqnZrao+VX9FErs1XDZOMFcK2nD
 NKXnL+2/fJQnzs9mhHKAxGmqz3V/KanqXOJL/J/esUtAIw0b/BkxM0XKWSTGZLiics/r
 oIfTKLqhNrECp4q49lNukWecYD/Z4IjMjyJYD2fdcsmPMQI7j1+iGVdUrdNzuLnbLMea
 NR/scQaoQlXwTTF1cxaTUHhGXAo3VCmv95kIuKoZt5eSD9wnJ0WqZ/QqyIlrxNEJGJaS
 GD1ejezG1ABZCy1f70F3j5kB9CRdvd3JIZAhkiKNk5wlls6QNeBeogZbFUA/CUeTYwpQ GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erdrk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:32:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4Vet8127134;
        Tue, 13 Apr 2021 04:32:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 37unwyaau1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:32:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ+se7fDCXNGxSy6l/aTY/bqQAllnQnGVZce3Q3W282v/30ktv2d3iv0S9/k5vAHAPJiLRE6GtudbLdr4O6EJvH/ck3WYypC4ENpRnDtjD7NvZbaBDybFEw88Y3Ux2MOwx7cSKirJzhETwLbvf2RmBA1F+z/tVVwJPeVwnIGWOilkoCJwecwPVjVjut1QVNRrW4rZ3LB5OZxWny5pQHBD5Z/xpg5f56WuMPPZ7a/xvH/80Ht3VuHrFfpXr7IvBiUpQbnD/QCrYONXXaJ9Wkz9oYTEM4hvAiw9Q+Qjci2kHzSXzNHlXTSiTaV8vJQqTRlE7USonXPhKM+9rGQOJWjmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hvtu1ScuhRL4xns2dIl1vrXLxNB1hmRCKSzJ9rwaPgw=;
 b=L2XTBce1Zo+/HaxlZRExabiXl0qH4A7/d0UMqGWEs/YE88dxKwlrmpSYxjuC0j2QNFlBQ/f7T4ts95pd3xVIPzkjP0azyLHhNhC1WYJ9lNhmizJwKfSmPY10+jx8g75mR2yHdovI1YdIdWZvzyXcE+ejByBpdKh7igQooK1JctZbvwspLy26WG18k7l/apYGqtXOXdKM75GsM8zS95y2ukq2tlnJLc2+v1XDy38zkeQfQMJNDpdBirmUf7EQJdoxgvBPlW9eJQk25jyknrLX6pl3xGf92D3+V+3CX+kUFry45LVAVRR5u/uJHxLi8EX/bJuqXqYMVPzMEy4FusjNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hvtu1ScuhRL4xns2dIl1vrXLxNB1hmRCKSzJ9rwaPgw=;
 b=WLLibS2oA+TcWN4pysKBTIGXW2x8yt/2mAHd9gzGbI0IUC3kVIPz+2Jh2jM/488sWQa/U+7rcItpul36jI4AiZt+oDhEgEJmljK9RVQWJqL0g0Ti2xmpJDjppJmwtPVbPetDCwr6MNVMJfOpzTtDehwqVGE0IJd9zTGvM4nAr+s=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 04:32:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 04:32:02 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix out-of-bounds warnings in
 _ctl_addnl_diag_query
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtu27qku.fsf@ca-mkp.ca.oracle.com>
References: <20210401162054.GA397186@embeddedor>
Date:   Tue, 13 Apr 2021 00:31:59 -0400
In-Reply-To: <20210401162054.GA397186@embeddedor> (Gustavo A. R. Silva's
        message of "Thu, 1 Apr 2021 11:20:54 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR03CA0026.namprd03.prod.outlook.com (2603:10b6:a02:a8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 04:32:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b017530-1312-4638-f933-08d8fe351577
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB544960937B2032B23E430CA78E4F9@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7nKwJHM7N+6k+yhef/Xtlx0I18ivL+VOKSACEdwNaAdV8swLWDzyI9Ch/XIW1IFaXSN7u+7bPM7frCw5Ecp/3c7K/NWY4Yo/Nw9XlLWhRCCfNfi2J4itN0PxKYzPPOCQjHxF1X0ZZNRSYYfLA6snPbVr3DLxN7MpK/XFExvJ3NTdmvIqFZkEX6q7orOteY8Vmbe9ULIn2Df2tiYTP2DTtTLMl2qWR3qUbn74DWqL8Qus5BKtL9cJtA1cziqSSdwavS2qsSDI0Yk2HdV/FLxO1I8y3fY9Fp3ep42/Hmkb9uygZf0DSS2TNaGeuBeU69JbF3Jpbls4VPEH+OZrJjt01Y1n5IwPqt+c3p8UCXWBWMwtwWG8EYzhPkTQoLxvbwCEJk+5SjBSKI7AGIKM2FypkTHsvE1fZE+M1sMxpIQC+AKa/r2YbYbMQhPVptLe3iGdwkdlDTYNR8T6PioYNxP6zGUTnaIIlaJJFxY0eTlBeCxKBdFIN56JcrEU03goh76K1PwZZhszcTCULCFL7EfGOFz10wR+yAHFL6wgZmOji1leRQI/dn1wH+PSmAIvqMEAtCP6rNM5jf97sqUs1/nBKxpKgUbkqSrkSxohddmTZaLsp9lTi4wq99KGe4l+NtUp7iOBjahovx2UO0Pgt3j/yS2IxPx3d50rR60v2d09g1PERVThlMg8LzLk79vYxPa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(86362001)(66946007)(8936002)(52116002)(2906002)(38350700002)(38100700002)(558084003)(66556008)(7696005)(6916009)(5660300002)(316002)(4326008)(55016002)(186003)(8676002)(66476007)(956004)(478600001)(16526019)(36916002)(26005)(54906003)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ICcN4q4Ok9bCDL4q+pBsGm0xxowEgwMiiWrwdNUKpvrVsrzrR5Mvm0D4sBZ7?=
 =?us-ascii?Q?2rNqHEL0hb3KLc5G3FbU2vaqjDKWTThxhRt845bvZvAMwG1TK4QZjmBAxvTf?=
 =?us-ascii?Q?taE2UavKDwDw7fqCbw3001oim50f0PA+bj+mCdtp71w+D2pXrZvuzf2I2k/L?=
 =?us-ascii?Q?wZHym51GwX8Jegl6vCjfBGDc4tMi77u2yE4Ng7qM41cNblllQeG9EWrPPamM?=
 =?us-ascii?Q?PmEqvNgFqyY9twZ7odqvlIPOmScgNS2x7Ury7EG9jhphXYTOo3ZiigPs6Rfq?=
 =?us-ascii?Q?KLyodBkwR/OQf2+Vo572wD/vsred/fTJaO4QTRGrR5VaimuUjLm3QZWytpI9?=
 =?us-ascii?Q?ONs6LjWAqRSaRb83XtN+rnrfuxBUFJ5iwHUwyxpp9rm/um3Zj2yuKszO7Q+d?=
 =?us-ascii?Q?MVQZIi3bvdz5Q6HuLtiFpoatIa3JdqZ4gdW+NUGwDmmXBzKUEKzrvvTLiA+8?=
 =?us-ascii?Q?zGk70YBwx+dJpFGUcRU6eXJYkYhoctRmYRhiWX4Vpv0vwl8UeOlfHc4GhggJ?=
 =?us-ascii?Q?2F3mAJM8vj/yam+kUeOOpyIqbtOZFpw+PjIDerM3JavH/V3DbrzZR0KgOXRg?=
 =?us-ascii?Q?jshajL5n3hp2zjmV82Fj9APcHIqxyCSHBrcZCQy3jkqvwGkt9Qm/RUomSixs?=
 =?us-ascii?Q?wXYqbpZAN5rf94sGcPm2aYAiUiQtYxzj0KPaZ4+xTu3ZGG7qRMsxFhRyxlyo?=
 =?us-ascii?Q?2Oo7vrBOMlfZ6d9yO4SchBe07YeM0I8phfv2pf0vAL7dhz8bLIz5nFEQd7lc?=
 =?us-ascii?Q?3hjEigPrnxC81RSTcJHIgV9xj/Nbvp+sU07E0ZjKE+DBO5s4HRJKshlizUW5?=
 =?us-ascii?Q?APUpcSnyw4V0TgHmukcKZr3n5htZAHhCiaHYC2eR941wFgtgw89dfXsNBoeB?=
 =?us-ascii?Q?W1pAto/wkEObBdgjFq3lXqB+w3Bfe7tCWHH3Mw4U89Ucy59uCDtdAVejdUmL?=
 =?us-ascii?Q?6zZ+tEdiwMxvPGdgZVm1LLPi6QNFmacITW6dIY67P24TjjWGsJ/SYFKcKO7o?=
 =?us-ascii?Q?BOGqUtaKoPEIb/kHIagJhbWzvezbfiLjihY9AVhRaURMzGMouJrK6P6N9WNR?=
 =?us-ascii?Q?cQ6PlN40S3DhYWXDCsVZzALKlNlYrOLkjPRW7S5IKPyqsN/v6f/acQOY1kTf?=
 =?us-ascii?Q?gqNXA3nf5Kb0q42SUv7UetRLKiguNw9b1i9qq7hidE6pIKsbPsIUk/xAbOTj?=
 =?us-ascii?Q?EstGxrdqcR1DWKP2pqjCCOw60ZQ3kbabK3Fb/sPtxDKg1u4PzR31R01AQNhO?=
 =?us-ascii?Q?iD9n0EZVJv1HIExyQxXCoirBqA7AjUxgTB61nqEpOVdA2QkuhyQbcolG+PKE?=
 =?us-ascii?Q?noGRewcC5iCmNCtSEiMiKoGK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b017530-1312-4638-f933-08d8fe351577
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 04:32:02.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPc/s3yywIlZjo6ubra+BaLU+mCO9x6BwMVEUa8uV/7dPec+qxwEPEOxAdte5SGT3sEF1GE0Axl+HKx0zOQboTGspr6Nbjv3BEfGR06DW9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130028
X-Proofpoint-ORIG-GUID: c_fJFoDp5FrsSmeSmOoJTZwjjOI8WaS3
X-Proofpoint-GUID: c_fJFoDp5FrsSmeSmOoJTZwjjOI8WaS3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> Fix the following out-of-bounds warnings by embedding existing struct
> htb_rel_query into struct mpt3_addnl_diag_query, instead of
> duplicating its members:

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
