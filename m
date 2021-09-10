Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488DBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230C4610F8
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhIJBaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:30:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11642 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229844AbhIJBaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 21:30:16 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189MGsHt002721;
        Fri, 10 Sep 2021 01:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=SyeEWzf0akjRRk4Dyu8/TwQMbkgg+ntLEAItW6KzcD8=;
 b=eYaYuKBnEzf3zeQf+aHO6s49U6rovndo4MP6K3WpKe31CV2AcSybxZfpJQcuwYw+Nssn
 8WOf+I5ul3nXLZhkCzGJsI6ZJB5q80vpmVfsaJOXd/LP1WTZ6C50yMl3CSOvAyaEJqYO
 qoB3fkDTynI2DWmm6zgNCko5SW1o9zPVEtf7Sl9dZ0+u7U6eD3HvqJ45fBLpXr9oZMZ6
 PPkUaVuPZMBA6/yIDJSezS0WbJF5JUsd9SI3JkpX+69zNb0HNk7RreMOy/FCS5cmH6XY
 5h+46XxCBixDDYoNDk0h+k7acEeaHm1TWNIon3g80F3Xw8ghO0cr71rcpc9Cd/aYSWJf Sw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SyeEWzf0akjRRk4Dyu8/TwQMbkgg+ntLEAItW6KzcD8=;
 b=UYzeiZ6fInD1rUzY5PAvS0ovDlwJDgezZvIN4129hyyHlVg9HI9ux5LnqGt+g4blHT75
 9qZmrNZcSEROPvABg0DrckY/XUdorWBktrtMAhAGMXhI+bnYxhmHTu3EvDrsWFmcmIg3
 xorKLYkAKE61zX5aC5eFXOJodz3mC9IHD/pjy3I0+xutuEcxNykPpT0oFCZa4bTPOwgq
 BeOYorszzjBOBHKJQ9IuQXyBsA8gcnYgdwAJxuNetsOhMQzWgRRlr2bdIj3xh/fTpQ6U
 5jnRDvrj4WEJJobVg9fcTkLKcczaqKpV9G1KyacKxwsLOppQB1qJGAN6mk0+FuD2HAaI sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytx4rb2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 01:28:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18A1G9CZ154683;
        Fri, 10 Sep 2021 01:28:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 3aytfxqc83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 01:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSIkQVyBr7W0/4aXbdH4n8ztPcBse6we2R+1U7Sq6hc8fkacgtpx8+LuFGIenb2vo5HDnhmgInsFwMkmq89eqI3m/r/Yk239z1xkuWAvtgJ91M/a9+r2zbWb/sPZ8qENQTBfhCF/Dvdb74Oxwc6Lqr/VvB7iCpxk1nzDy0Cc7OynmAOLAU5sS4qLG6+DARDHlt4UINzuFee3PoPdCqLXvplEhYObVndWTGTvYKyGmclUl6bz+QM0pygwPHb7ic6Bvs3g/97NdrDjkwCKp2UJixyBrrEj4BnNLtNUsLfzsa/OWbcVGM+E7s14KIWKoXTgCZnNKNnRp99/9RTVecQcfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SyeEWzf0akjRRk4Dyu8/TwQMbkgg+ntLEAItW6KzcD8=;
 b=AgAFupQomTFkWFsGFc+00uwqLu0g4Us3D1jgmqKQVCtAsTpFh44qlZWj4XikyaniJJ6wthkmrczN+xH8hbWozC4Jl68y+B3srtysB3HDr+3v8yaIJrOviQ+l9TEgmXBVUuGP+T/Su2FKFTI+bDmWcHL3ebZxPpKFQWSp/EZZzqU9cjKko51qeCiVyp6KbwbiZFIKi3LLy65ArfvFqRSlotSPrNVE5ENrc6Ep+Mx/bk26CgCIsD50eLEM2ELPiA4Z+6JIVy7QWes+r0iVYjl9J/Slbj83gF0nugzWnviGn5ws4zrUpnV9qjUWM9JuE5UEksDjMl3V+mpxysQIjSNu6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyeEWzf0akjRRk4Dyu8/TwQMbkgg+ntLEAItW6KzcD8=;
 b=R5lo3y7sCu6RN6KHDtehdECm53CS/p0bUD0wCXzqOQhsC9mJ73YAS35nWEY6ENIgjOwVWJk8wlwDhXAHO293p6zYN2MiTqUNrf88dG4gCZYcYGeXf8sEArIkRzwmoUU64X9FxVib7G4LAx2u2PkhClKXOKHLLHGaGvKWxEABpSs=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4629.namprd10.prod.outlook.com (2603:10b6:510:31::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 01:28:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 01:28:50 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com,
        hch@lst.de, gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8912p8p.fsf@ca-mkp.ca.oracle.com>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
        <78c3c08b-ebba-8d46-7eae-f82d0b1c50fe@kernel.dk>
        <ac61cf8b-061e-dd96-1730-edec5a886c62@kernel.dk>
Date:   Thu, 09 Sep 2021 21:28:47 -0400
In-Reply-To: <ac61cf8b-061e-dd96-1730-edec5a886c62@kernel.dk> (Jens Axboe's
        message of "Thu, 9 Sep 2021 14:42:10 -0600")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by BY5PR17CA0001.namprd17.prod.outlook.com (2603:10b6:a03:1b8::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 01:28:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22a81901-1029-4dab-a1e1-08d973fa580b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4629B9DDA0D701AECAE8E8838ED69@PH0PR10MB4629.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRllYJrZ8KtH962QrKA8N4ucb9FHp8hBtaPDmo0B2kvdDxNTuAsYKWKke3qAdxrEQBtTOyLG9I6tOD2YalvSecBysppM5olgwsbltddEVTXZj7CqjbHeigxEAM/gppEqu5+XguOdB2BugipJ9iH+8SnUmzQ3sdT62WJsO7vR0vdxxym8lwF6pEZIQ1G1tWXKiku98xVC9I3s4bWBmbVNylxDdllArju+vHjafLxhaIX6Fy6nwFBW7rdQXbKQeWsNE9626GBIIQU5Vsfktqu1RI0bXxDOYZH3hlJ/sJEau661PzjxCR72rfXy5PynxWTdAzGAYUz/GZ2m0EUcW+JvzIQgpFSuF9OqjQaGmUsDQmtILQUg1vosutvO4ZANwJfdooG/cpAD+662UzdLJKXhTNRD6JTLPNxPN2WAzkB5lwr+ZwulbCI1nGWU+RWW3tNh3c/Ps7mAah56sJJttw6WQM6Mx+hMkzEbpo+VwlM3i3VTbkV+c5ksesw8O6AcF4HnEylP4fQME3aY4R+zA8rfAJteZVVHJ7g8+WSuFvL1bUy0btFhqCYS8sLjwJ5+2XXAx7fmGWDn3Y4jKtTIGW7rdtgvepSlN1o6+reMfyxwEX8tT2n3Kd0YOJCZD6AgtIXuE+zlaRNkF+ta9z8vnZSpf/9v7jaGVX748AYxmZgkP3M5gk6BNnwOhGMC7bcTOx6g+tUEZvCMXr7AFugr0e5hXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(6916009)(86362001)(316002)(7696005)(55016002)(186003)(8936002)(6666004)(4326008)(8676002)(38350700002)(508600001)(2906002)(26005)(36916002)(52116002)(66946007)(66556008)(66476007)(38100700002)(956004)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E86BQpnqRvGwvcDmd0+XetkCrUFLhdV/CoscQ6uHHmMDD1iLM6opP3/WPeMS?=
 =?us-ascii?Q?7tbzdd3bCVBLsrIoE+1t5wD3D4MfDGy/jjvPFV/+yM78dZ/rF9iAcYH09/3d?=
 =?us-ascii?Q?Tp/9Z3uEHWu5rnLramgmyHoN3eFiMgHgdyqKrJuYgexlG0HEwny5Lid6nV2f?=
 =?us-ascii?Q?zSV21LGlBrhCnAUiiqQpWu6zbwW4xQYdCwlL8CgeUDpZIJDr0tODPVxr2fGG?=
 =?us-ascii?Q?31PdlwVhog1LAPi5Gtwd4SgVrTgi2SioYR14MJlv/3mbkq5SQ76tONOzGP8e?=
 =?us-ascii?Q?4oFIpWrlc+A7zhpa91juDo2FnhkW4nLAfQH3JxfYY6HRlSFqPCGGlObR3ixK?=
 =?us-ascii?Q?qWWrFZ8f5slTrYDQYsM8NCysdwoqP3tewT6PS1X2ehGjLzMBRZ6aQqt+wgoF?=
 =?us-ascii?Q?/iSqbDq3Ahu68k7+5EBAzHUwy/QRfTA1uiB3QTXcoey/jEVqYENCa2Tx6Q22?=
 =?us-ascii?Q?st5hpSjsVaHVAYetkJrCj75WFKFkW7D4ax6a33HOMZjhq2sUgizFHoXMaKUi?=
 =?us-ascii?Q?oE2fYS6VIaw47JyF8BfRhgaplh7+8y8vx9gKIeJFO7DWz2jABYD/pVNSX53+?=
 =?us-ascii?Q?szIWcYOGJbPoBgJAUSfEXHrvnowZI+tUYXUfQxBMEJs5LbDO8wecEazvOtRr?=
 =?us-ascii?Q?bvN6DH9nJPxcFFcrqlXQ+GPX0/ZWpEYB2KOwxT+eY2G3ZvqD3LscwZmeeq/e?=
 =?us-ascii?Q?ZBCLjSajabNHaiRaGBwvw5EgpGZUOy1ZkPxx0RzOorhBEFOiLJjsTTYHn2cR?=
 =?us-ascii?Q?irVzqJDYuTH6Cdd+pAUsUiyOOjO/OJSmHAtIYvHvCqDEVCnLa5LtBpZBr8S6?=
 =?us-ascii?Q?N7KTx6dH8Qnqx7xylnYpouIg2fc6l/rfzPMO6g+hfjZBKzCzbqs1t0qKOvSK?=
 =?us-ascii?Q?m8uQwmV+w1MQKo30Qswxov4xvoKXORSoqPi3d/yQHARK9HqglzfwaKTbWqzB?=
 =?us-ascii?Q?fJG/7D8BkNT6RVLbphb4Tvh7k6UspS3aOyJ9w7d0Y/y/I0cBH6jbvhUJp1yv?=
 =?us-ascii?Q?+8mWShWtIAwvQnMb8YNpc2FWexvJgx6hHuQqWCYACKrPhFa0IExy7LME/pNZ?=
 =?us-ascii?Q?UnHQtzAy5bjVf7YkpOGCTxEexDvN2Fs4TYfH7W+rJaPH4Orgo3Lp88oa98YP?=
 =?us-ascii?Q?T3tZDz+bvkYXJu3cR/QTTEh9KuJp9J4NRLGU52C+mbb1m7ZaGU+KrPNFj8Rl?=
 =?us-ascii?Q?HS856OdBxeWLrEJ0wd3NLqAG+8LUEwNdSpKUWmzzSF1Bx7W6bMpAJkjQUqI7?=
 =?us-ascii?Q?Y4G4t81QH1JtbqGqOLMZoh2DUeT3HrdxitM2yA6nFP2gbxSY8DkkBdYrAaw2?=
 =?us-ascii?Q?DPfet9vdktqb/nReU1HOkcq7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a81901-1029-4dab-a1e1-08d973fa580b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 01:28:50.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSr6r6+GqvNZ5KpCWLCFK5/Te1wa48q1W5Q4JgejaPdFAASSbzQ5TK9p3lwyEl5LRGXzYnP5EaC9w8DHjvdEccVYc0Ky/7H5pR5UOwlm/WU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4629
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=769 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100006
X-Proofpoint-ORIG-GUID: VmZpH8BZHHenA9WhbyZCPPRiLmOM1ogJ
X-Proofpoint-GUID: VmZpH8BZHHenA9WhbyZCPPRiLmOM1ogJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> Actually, let's move this through the SCSI tree, as the offending
> patch went that way (and my branches are behind that point).

Sure. I queued it up...

-- 
Martin K. Petersen	Oracle Linux Engineering
