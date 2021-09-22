Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE5CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CA061166
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhIVEqh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65502 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhIVEqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1wB7t010075;
        Wed, 22 Sep 2021 04:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LkIN9I6mq6WOhoq+jPn+JHhWYSR7jQxuE867jo8m8wg=;
 b=SAG5lbka8LB/1FhNbnYPTDU3+IEJhXyhelRAEZIS8iKJEP7CiZyO1K+mp833+tRaBX3J
 gFhmYQdSURKp/lXbmmrKwj/AMbIO5zwruRPvPnEimWtnEkcpU0ERq6lZdRCBIS5AuXGX
 Lg28SE3TKOxECRafRMqgtIWF7Bhd2cTC2a4jS1y5oi7g44umOFuOctvSX+pkHO2vI6Zg
 70TlZOzRevbfbQ7/cbglOGkasV6ukH6t5LcZePUGarD3aOHrSGZWYIbg6MxDoj6YdD4N
 WytPiQHYJwLIm7ml/1wfdniMeG+hhKjKcsM0lUpZdj011M423AbZMLfBegQRkYVLoeE8 Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p9av2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4iwBk195776;
        Wed, 22 Sep 2021 04:45:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3b7q5bks3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:44:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzT+Q5VLqv2sux6O5oX462FPeFcc4edE097y1UcKZixbe4G/O//pZQ0uceq27Zd09FI/8rApNfSJ/dqouutih+H7MckFezKdiaUID7kL9QRoqknsLhxTFlwa5JjSILCPXUMNWVmLILV+E36zs9ozbRJcL2sGRNuhKhrWyR3fBwAYuLAcOItgCxJ6gAJ7KIQFJoVvCBwTlW0lL9hNXLKn5UUzjVFwDKURVLO8f9xLF7/2vkXxMif8Kgir0lVl57PFmzW30QSRhU3QbS2mG6Ucq1X8oU6HZovLhrZD8kR2Fh2dJJ8PT12svpygIym4ueHcTJlYY/xXqiijPGS43p7HGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LkIN9I6mq6WOhoq+jPn+JHhWYSR7jQxuE867jo8m8wg=;
 b=dEftmf3TCVNtb1iXIkZxEst4xJrNF4G+vefKCe9xluUdYPbmtvQUf2th5zqNmpltPi35C9AaHneWcUYrmeVW9h+AcFd2R2apsuAPlwKsCN6p4RXStWwe9kUJqnZcII+HeOxWyGCsx2ENpnbUiGBBK1f8SbcL+j+CHxa/DwFDp79yeyLqEppgx1aw+IJAA+HNqlwL4gle8n5S6e3zlg7CH/R2zHgNfx8dlZTzprGIkzS9eSS+fC+iqCtHVLMMq++kJ5iqTIHltpDX6+ZhSjfBOLqcT22CLp562RqFoqMEbM87WeeZE2YhIDCU2pVsnf3GD9DMgCyJVtI1Id/4r1YTnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkIN9I6mq6WOhoq+jPn+JHhWYSR7jQxuE867jo8m8wg=;
 b=H/+vOUwXecUm9XcFfKT6/1zhOb18MFuxIw8ewcgb7GoJt1WmuEgonwTR3SpCFwzIkdtJyvNruTQMogO5s0ccfFzzT++sKJDKnyPuChsXdkTaFjic5rUqvgFyHqlp9hSYhiRnDT1vjNskbpnDOfqxbY565+0vuwjMEmUaKOPW6Gg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:44:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:44:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Arnd Bergmann <arnd@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix gcc -Wstringop-overread warning, again
Date:   Wed, 22 Sep 2021 00:44:44 -0400
Message-Id: <163228551953.26896.13635500020872473940.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210920095628.1191676-1-arnd@kernel.org>
References: <20210920095628.1191676-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:44:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e39e16a-85e0-4ce9-3a85-08d97d83ba60
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45187BE4BA17D1B8316C31938EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0NnyGau3DTu8nneN8LDIXiARRhOwF+n95OYJRIckCn8ZUdpYXi2Dp1YT4cGZdCvjGrr0OVVJmAIDyn2DYff5saP0pga9utH6ioYoxE440GjCYOctr401N1LCt0HFeeGU2rSj0rBPIVCvSeZkG0Miuxk+ta3KtypJQD2DRtu5CCtCmQbgBYaRrEDuGY7sBVdb3jZgkeOEolo22M6G15+X+oZ+lD2Ykrt/gmpxI4wX9gNGgQs+IymgKLaAs+vdrYfNCQoq9mij24ST4T17j3AthCMXwjd/oJ1b9hAripXgYh5dUCJ2k2p4i2XhWvxi12JiwG/ticeH5g8X9tcmqu3kgjO4rzKne38jAqpeVgLLOto+L9eEt75U+1Jq/adrDT6o23i5DjqMZZFFyuJgDaMNX82ey3O5ZqXVTeQt09mEqkQ+ZsjbX1wLQ+QQ+h2l9/Onl6vjfUcyq+cW37Fhp60QfRIBjdxngogpiL1QX8pp2ycVmTojtf9tHu3Zq7JVRBGoLXxQxr24Y1BJk2SuULD34c2r2nX77lJLTww1tG6sQHizZZkgtiHrtSMBPWkDM2lRRN+K8ssGFBzhwehsuW4vDyZIyV79lJWQ1/2ySh8zNcwoO5pJw3nyb4zYON989PkyJuyTWRlGljNkMvCptsMSxLouvO/h5uxH750py2F1LOjTmRcG5Ly675VEvp5i8fCxesSCEhuk4+EsfnFSMjZDnvJlwd5K4479ACFfYUXp0TmOooZ6Qml2RDVFB6QNytpXaPw6ICHHXsbELac7RCA1wDNVwYNEK1/lbLPAwh0fVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(110136005)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjFVdDlVeE1UbXNncVNvRlpRclNMU1JzWjVCbGk1ejZJUjNIYUdqQTR6Q0lP?=
 =?utf-8?B?aitiUHUwQlVlY0d6ZFlqNXJvdnBueERVc21qZkxmdjUyK1pSVkdNVkk2Zi9F?=
 =?utf-8?B?THlYd2Q4Rm5jRlY3U2Y5b3ZGdURvczYrQnMwVks4WFNSYXlTblgxQ1RnOGpz?=
 =?utf-8?B?aDY0TDNRWndOQ0pOVzNISDRxV3FWb0xqQm9FVHorZEc0aGdXYzZ1b3pWQ0Z3?=
 =?utf-8?B?NDEzSUZ1UkhmSkxHRkYrZG9OY2dGTDQycThVenMwd1ZCcGZXbFdMSHQ1Q2d1?=
 =?utf-8?B?V09abWJtZmE3ZVlXNm5lWU5IQWY4VzhMdDQ4UnVtZ0ZRMnZSeUtsZUU3Mm5L?=
 =?utf-8?B?cktsOUtBcEhMNmlydmlXMkxzVU1jKzZYNzBLYnM5NDJPUlhWN1JJejBMTkxv?=
 =?utf-8?B?d01IbmpZL3lxYTI0RTJ6UXVON0xselEza2pmZjV3bW5aUkRlQlJQSkd2K0x4?=
 =?utf-8?B?OEd6TjVNU2pZMzB1U2pqQVM2Y3hOR3BST29oR1RrUzBjOXFLTGpoUzJBQWVw?=
 =?utf-8?B?WWtEanR5M09IQURQYlNwNWd3TlV2QWVhVVNRenlQbVdnVE1CZW5FTzdGOW5Y?=
 =?utf-8?B?TTBJdkx6VXBGRkY0WXF3OHFEK0x1QmYrejgrSmYyeU9LR0d2L21LU3UrSDdr?=
 =?utf-8?B?MmxMb20rSVRYVVJ3TFJPQ3dxNDJIdFdqT1JQdHV3akhGOGhpckRRekJ5UVNh?=
 =?utf-8?B?dkVob2ZIQ1R1c25SMTBOcERPTnhxeWsxRTZIaGIvSnVaa2xESHF2cUYzV0t4?=
 =?utf-8?B?bkx5N2RYMUlHdUJ1cUxmeXhhWWhhMTJFMFdScDZqdWdpR1BoTC8vT3FPRU8r?=
 =?utf-8?B?Q2Y2cTlWdnltRmdFL1ozd0pFYmhQT0dBaGxad3V1ZG9KQ0tLMERRS0ZBbDdi?=
 =?utf-8?B?QXYrSEdoS0oxZDNhcXZCdUJHdjZIUmhxTHlVT0RhWkhJaUh5QVZGUS9lbWI0?=
 =?utf-8?B?VmFNVEowTVRwV2FWYXdPTmNxRVIrbzJDVVZ6a3JGREpOa1M4enBWRjhocEF1?=
 =?utf-8?B?d1Z6N2I4NXJDTW5Bays5bUtXRG8zZ0JuMVdGdk1NRGpaVDJkVGVBTFRuSmJy?=
 =?utf-8?B?MlR6ZThMVjU3S1ByUWlVcHZuZ2Vuci9KNllpVjJONGltZ0NRcTNtb2VndWtu?=
 =?utf-8?B?VFBISDRUeTVZRGdIVWtDY3NYMjRyOVAvWkluM3ZmdWxiWVdoSXQ3MW9KQ2t3?=
 =?utf-8?B?Nzh3Y1BpbFpidFVoM2tjd1FOOGhVMTZDTHlWM1NoaXVZU1gzK1QxMCs5Mlpm?=
 =?utf-8?B?QnIxNUkrYkwyYzNxQVJkN0g5ZUtDV2tpK2lWNmthM2Q1eTJmZktORk1HRVBW?=
 =?utf-8?B?TmdDWWlCQkVWYitnNDZuaHB4YkZ0MlJaa29UemJxQ3pvOW5ZZVdlSm0zS1FL?=
 =?utf-8?B?WnRuV3VicnhZVVNvS0tScnRPaU1XVTMwSEE4SlFVN0g3NVl3N014Z3Ezbk8z?=
 =?utf-8?B?ZlR0a2g1aXVrS1hmTlhnNFk1RzFJNy9mcndnUUROQnBtN1RpRWxvbnhKT2lq?=
 =?utf-8?B?aFRTTXFtSGdvVm5xd0NCc2p2WGtweitibFMvNG1kM1FUUTV4U1hiVkM4WFdF?=
 =?utf-8?B?bDhYQ0ZBVkdQR25LU28rdFZ5ZytHdlNlVnI3VnlTVXdYRTVqeFdJUHphVlBE?=
 =?utf-8?B?V2F0QU9wRWZVc3BTeFhNL2FKY2s4NzR6WGZBaVhRUkJrRXZuVW9WRU1sMDVw?=
 =?utf-8?B?eXhCQ0FZRHA5WU1DR25yR2w5dVNFVXRYQ1FrOXg0RTdxUVFMYkpDajBMQVhl?=
 =?utf-8?Q?i/g8CfO/cTh4lv9RLgCQQy21XjHOVw/APk71qdP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e39e16a-85e0-4ce9-3a85-08d97d83ba60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:44:57.2016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CalwsUbQ/swhaKP/bITk4PjLh4QkHWogseUWGiSL/Cwnsq5P0lQYLylK8HHe30eAsD1BgdlQTjb/1Q2Vpa2LopAK6tJqHM73mwn2QkBibU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-ORIG-GUID: iZ064dkdy2pseiE8bA9PHj9orAwCiUCk
X-Proofpoint-GUID: iZ064dkdy2pseiE8bA9PHj9orAwCiUCk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Sep 2021 11:56:22 +0200, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> I fixed a stringop-overread warning earlier this year, now a
> second copy of the original code was added and the warning came
> back:
> 
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_cmf_info_show':
> drivers/scsi/lpfc/lpfc_attr.c:289:25: error: 'strnlen' specified bound 4095 exceeds source size 24 [-Werror=stringop-overread]
>   289 |                         strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1),
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix gcc -Wstringop-overread warning, again
      https://git.kernel.org/mkp/scsi/c/a38923f2d088

-- 
Martin K. Petersen	Oracle Linux Engineering
