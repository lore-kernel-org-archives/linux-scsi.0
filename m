Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5532C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 02:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378477AbiAUCPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jan 2022 21:15:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50126 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378481AbiAUCPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jan 2022 21:15:05 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03r7i001013;
        Fri, 21 Jan 2022 02:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AxdR4CZ+6KXyw3ucKYiDxRIAszDQx2wjCzeGDiCVoOM=;
 b=Oq592ka2Wtt3Pshvjl+UMUTkeUR6cqwxIjRZ0flKAR+jwTDaLETFjaRuDl6lAikZRN8H
 H6Yq4lw51sYfKuSTZIkVXbC0+zbMNaDC57XPxfs/FSoJOI7Eo/DzyK5yiea+UtKZX/VH
 0zjLl9/L/PacWpXRCUeDR9oB/1DTtr9iwkEBLfF14T8wnfF2FfepPAgm/3NWlomRpI9u
 CzViibwkruSGDWDZEJNnE93gAQgASwLejwT0RMOlQfdTmjoMPsyLxQtG6VT2sn7L5AIY
 3NQtMa+XG7h6kYMoP43qBbKU38cbi92XnhnzfzuExUWBcFuMeWSeojHrMtOzG4YES8P/ vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9r4vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 02:15:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L2B0v9066497;
        Fri, 21 Jan 2022 02:15:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3030.oracle.com with ESMTP id 3dqj05cu11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 02:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhN/LQnvAZFuHnHaxeD70jizL54boOA2hLrHrMNA8UL6MKZlutRVsdumrerdZrh8U2H61YpXH6lZyjsmG7xFstHfYVMKngcW1duBzXW5w5gVJAh72gNZZ+l5Hbjk4NjM39GVv9Vq3Fi3KimbJelj2Vj95nbNrmAM2JV5ivaXNL30JD8BXud4S9pvWoVFNACEsTW4HQvBn2nbtLjMtbYyauMNnW0ve6asYeUtFI4U+U4lU1tg+EMmZXtLD7CVfDQ6ZbDD7wMr1zI5ZTVgsWcO4zHOOqt+24o04SFLZ9KI1yLUit1v6gBLGcMiSalS+KLve/tuFd9dMXKyS8+kx4LSIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxdR4CZ+6KXyw3ucKYiDxRIAszDQx2wjCzeGDiCVoOM=;
 b=LnBkwDG2BhJ+nhXPOnPXbGa8ahDhpEIlvuc7m6t+e4i4pewoVj1ut7SNXFsO2W5B8htBu/0wSYwk+ObkLm959+KVbzrYjR/GoRntofBmm3XO/JqNIiLnLwbzZcfsLnxMy3inZ34j7JLkVnbN9/M84OWlnaAsd2sI0yDzXe61grXP5TNjcXfp7K3gC4pj/ra+CjPf3FR1YkLzQotSQzaLDzO338PoVGmbsmVgcXxUx/ckgBWDsybOC5ZK08rbDMY4QoueMHYYuOGT1OkmnKEMQQ/gux+xq2foC/fKAOOyWrWK1XgGP9nEjOkk0a2VINFCoz7XYfKZy7khj8Dv1h7JFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxdR4CZ+6KXyw3ucKYiDxRIAszDQx2wjCzeGDiCVoOM=;
 b=n7PWVipGNcZpDHB52AiNKqDq0qt2WA6oJudcPiPPO3s08fWGWoARHM+/qyubx1uAl/iUhvENnmnRLJx8ZEEqLq4we91VGr6aBha0isDWMQX/wx7H/RUYHVH+8TgLxS5tsvI6LoCeTPSlvGszPZlGI2DD4lGVD04IzGsBy++d+zU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 02:15:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%6]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 02:14:59 +0000
To:     Sven Hugi <hugi.sven@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Samsung t5 / t3 problem with ncq trim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnithm6g.fsf@ca-mkp.ca.oracle.com>
References: <CAFrqyV4COFCGCRN3bXjoSnudMtr0JhhFviUj8QtEZfJq4ZxinA@mail.gmail.com>
        <yq1tue0mn3l.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV59OHp3mWLg87wuymJTBXG2i_QwZjUFNtrB4cpt98tgaw@mail.gmail.com>
        <yq1lezbk7v7.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV5O5u3_BsrOY_E2qfSNWfz5CS0-bymMDGPx00y-f5SezA@mail.gmail.com>
        <yq1tudzidng.fsf@ca-mkp.ca.oracle.com>
        <CAFrqyV6hhTDW9m+azsLGth+Jok=KFc+pkoGnTrsr5qDCazY-Kg@mail.gmail.com>
        <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com>
Date:   Thu, 20 Jan 2022 21:14:57 -0500
In-Reply-To: <CAFrqyV4n8r6TwNsETfVTv+F_nn8Hg=HuZ6OHgmG_HxPVcvfPzA@mail.gmail.com>
        (Sven Hugi's message of "Thu, 20 Jan 2022 16:42:37 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d534dbfd-01a9-4e90-7820-08d9dc83d37d
X-MS-TrafficTypeDiagnostic: CH0PR10MB5132:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5132B65BAA512A75375F96128E5B9@CH0PR10MB5132.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ha09vuqceJymdk04PvBAFDCTJGPx1TErxtabacDMGkV3pBk9mdIY7O3FPyu3LhU2UQMypef6MG+2wQCPQ7aaNlzRRLArwV9c9Z7I2KhoLIYMSt83kY823YoUs4Vcx9HTunP2sxig1Lcas26aGQq/yTvwMdenyIS+6XH7YC6K1JEN1r5KV9TQCnZrrz8soSfXFtwJFyBNDg7hQDX3rKa42z5p2+lN/x6z0qxo8i547ri0rmsUFS7hKVoTIwDNXkbyhLWMlG3xiFzGQCdGUhXRY/2eweQbih37ZqFcu+iumR38SUNF0szM8I+lNg9zV12eBwgn7v4Gv6z3+VqseOUO4KhwdNZCDEqi+1WPuGNe6WTuqQihj5DdT5qSDgId2qSYMnSkuvJW4wDFRmg8ipF5MnjyQBi5DjIt8T1oIstasv+k1dAz3TK58Nipx2hgHUKciy8/a1R0eZ0DO3zNs4pH2erRaeoc9HLAGgKHkueqwkgtvDi7aHAiRPvbm8EesEud6rMP3Tqm1V8YS13QJkO4oD0s6XTjvrgEhr0qP4OhE4uzZ2MO3WramjuXohtY3jASjE1zeyrHH2KJGRx0fd46DBZgGT9uR0hnVegnw6sa1DcSaLdzXZAYm6IklO5iOjw33ooYfbniwpOIS/neXwzNEEe9yOwHi6t6qeTey/e0qAxNSOcFcdup7ASo4JXAyllGQFHZfzpls8ytTCx3uj5TQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(6486002)(508600001)(52116002)(6916009)(66946007)(4326008)(36916002)(66476007)(6512007)(8936002)(8676002)(6506007)(86362001)(38100700002)(38350700002)(2906002)(5660300002)(26005)(316002)(4744005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KdaI5etP7wW7PV1qmWaxDMngHStcrWGvLUwBWs0XBURqyq1amC+ZSOfpUhh5?=
 =?us-ascii?Q?SmT86G4TRvuS5op2FLEXv4I1Wa+IAsHYLZESTADSdhIbnk+S0hgA+oKAOQfa?=
 =?us-ascii?Q?qhukBy7e2YvgTSwnSTvQQcynQqOcDPdVwptKcaDQRoLDzbsb1NPO4Htij5s0?=
 =?us-ascii?Q?49dpQ/jEVFkCjlurtkEgfyUXpItDqZaOh5/D49Ba94GFr8G6GubUWpi1EfoC?=
 =?us-ascii?Q?DlARI3DlwriwebYEoMhkMYCH1/4PsP/9U4CsE2FL1B1ZrWAnKOX/oNNiNhRp?=
 =?us-ascii?Q?p5bBU6SfrlSdM3NJWBphMx1poynSPsinoqGWtVwNWZK6WtZmLQDrgEA5Wb8x?=
 =?us-ascii?Q?3AGy61ZKwvP2mDXpWQxRRe7FLYcsDYGg4qw7j1jA/JyVogQoyn0xFy/fg7OG?=
 =?us-ascii?Q?mZR/ePpEHFoVs6qvSA2kNqy9xaQ124E3Z34LjW3A55V//Iw2E6y7Hn8HAmil?=
 =?us-ascii?Q?AC8gtDhNeV6N3FxR3Q2jzAD0kl3BRg6tPyUVOS6PUX+CxSlph5fCEYQqdrrC?=
 =?us-ascii?Q?1j7YKuTsGM5sMbb+77bhQZx3+6RC0LOUp6MXPmJGN8Xezgk6IQZBMtSeiaM2?=
 =?us-ascii?Q?YcoM8+ikJLrD5IAJIy0T/PQNLCskKtYOhao+KPJCP4e8dAkRZuk+Vg3e51p1?=
 =?us-ascii?Q?g5ku1DJXIzxcgNedRWpFsj6SeCpvv0cUoVeZM6T4KWWzym+LmdpTnyvfPgfb?=
 =?us-ascii?Q?BdKL3gAm2pYwCwm644ugTD0LV4j91VYUc9Rh+RnzubLfDYmnl+lNCSLkvVJx?=
 =?us-ascii?Q?TrwHtpM5R0Tt7Rrc/7WyIi5yZslKEAUIn+Ce68iPQ6n9wevkZN5BtvTGrFSc?=
 =?us-ascii?Q?IOYb4Y6CpZmHcFfW22PgWVGXGHUVHcUIEHu4FjEpkmvkDZUf09/PxdDR2N/M?=
 =?us-ascii?Q?sfx3eRg6t+P7LIpvHG3h86JXf6d6tgCYCeMcrBoWZCAdVsxxcjPAh8HyRVkb?=
 =?us-ascii?Q?3wrXTj2XzkxfMXDKab3FaPYnbOsYamFXXzpNieq3zGciwnGp5FlqJM+6y4dN?=
 =?us-ascii?Q?rMUGgWnwLFxqTN5ipHRI4420W1ydRfSULIRymROWDUfDVgbWTZTE0SGErQEF?=
 =?us-ascii?Q?A8QUaketoPB4xRNjmUi1TEFQcKx1x7NhM/yV3EfQuFlntDsf6aDsxNC6g6zv?=
 =?us-ascii?Q?9B8aviNbRnFKx81NHwgieVF070eEE9g7IfTwysSj3DZQrYjt5xMH40f6BG6s?=
 =?us-ascii?Q?4YM1iMM/JQTM803nSoC/Kr+dTK+Ucm+yKEMuyf+rdeEaqr+PLuP9axI774e5?=
 =?us-ascii?Q?0X2LkD48xDtfvVpRQRFiGu3Fe7kwHrC8nq/+WoscmnO58/m0SqMa9gWq13PX?=
 =?us-ascii?Q?BHAXZ3MIU0G2NJ+tgVZO0rQ2qxbfRwCw9qXBza4Ijbbvx1jKl8ie90Qwc0z6?=
 =?us-ascii?Q?Qq16Yc2R399J81UyhH3Ccv0kzhidKVobA8hM2/EDsxD6l+Gd44tcelehkx4+?=
 =?us-ascii?Q?NUZWoTbTmb68uAo5NmEiE40N0jrUNddPVAS0xjSfCV8rT3KKSmHUAZsKv1uv?=
 =?us-ascii?Q?Im6lDBAKmu4DLxf7zdfEHtB2Ttfsd09MvH8udNgBDqIXXqxwPHobV0CP+UMZ?=
 =?us-ascii?Q?KKdjlPxpnD8Wmx9kQqz8l51Yf/thcVqlohAJwS7Eg7j8+xfUGsqrusM09rRU?=
 =?us-ascii?Q?sHUHtgqyx72KSH0gbTK9XGlpOwvTPfk7DaETh/EJKQjeWe2lJH0Rg6I1mjCr?=
 =?us-ascii?Q?i8sokw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d534dbfd-01a9-4e90-7820-08d9dc83d37d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 02:14:59.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63jw4/k1P6uyla4EriZzOnDNzUDguIEvvks2zkwJrfge+l9r1sdxKqsQ1DWwlRaYKSziItpiCU96EecGWJLlHTzJ1r/vDvLgUb5CcLEdiXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=933
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210013
X-Proofpoint-GUID: 963hn4wDBuKtsxQ_CUpyO35WfUL5N3EZ
X-Proofpoint-ORIG-GUID: 963hn4wDBuKtsxQ_CUpyO35WfUL5N3EZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sven,

>  -> sudo sg_readcap -l sda
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last LBA=976773167 (0x3a38602f), Number of logical blocks=976773168
>    Logical block length=512 bytes

> lbpme=0...
> so, i guess it's not because of trim...

Correct, Linux wouldn't be sending trims to that drive.

-- 
Martin K. Petersen	Oracle Linux Engineering
