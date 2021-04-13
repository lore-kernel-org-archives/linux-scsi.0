Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6C6C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF08C613AE
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbhDMFTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:19:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44834 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbhDMFTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:19:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5FNsT164521;
        Tue, 13 Apr 2021 05:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YS3Jnk/LZTvKD4WR2B38gaVEsDqCBmwJRJ2p1esUkiY=;
 b=j5eMRPRxuQoQCkyg/lm+w5ZP3HnSD4BtHDqPI42IuZkRGB854OgbSMUbrhogDzUHIn6I
 mlh1K48EUl9ptvpiJkGHoHJ3GCagMvPq2sh8cV/ykCyJQIlXN4vvvDWHlSRjtX7Gq9ai
 cQT+Mmd4WJ5Xn1tGlasZKi/mKt+NxTBbPw+vsmpcbQFTm/2nkS6e8277FhG/JyvAD3np
 PivMARh/tQ5E6aUkyjRtS+oKWzZeVhSkCBGjEZbcbF7cgOiDtEwp5ANGv1AEb99fI9PF
 JozDNZBxh0BgL2jxyFuvQGzZFz19Eh9zt7koM+fPNYrsgsRj15VXq3D5yfmQV/JvXDt7 ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbdwaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:19:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5GR9w061981;
        Tue, 13 Apr 2021 05:19:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 37unkp3240-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKnMNSUp/rcQJlY4FlRO9AUJZIyfApwltYMkCxBzl+cgQuC548mJPOowqkoqRnLpHfsKy/+eHGheclu6tFd/4F/ogyrRyXJTFO5O3rKyBzPIXuuRtnE/g+kB9NRlcv5PXbE+aRcPh/2yqKfDhqytI2zvSeJKJogTBuk4q+AujkFKHki3oxV9Lteru6dn+x8ITjOqoEEChbSfMlJ6kdKMy/zb69DIv2l4BNRDgwP3CNRd2QHrgLnM9HLdh9MpmPAcM6iDRiOprbvkQcREyLNAFeYWSVqD0RQksZQd6htbfyAyNxUQW/0STjBDIqgBMMClXVNnDvDT3jYkpdet2wgz4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS3Jnk/LZTvKD4WR2B38gaVEsDqCBmwJRJ2p1esUkiY=;
 b=cqjrJecbOXNEAiZfXOLsVMbxcijW6mhCJsLA/bET3dcaglcib5qXzAjGUhB9Jw4KZnoi3MrMkOooVnCxksRs6Qmhh90KKckYwwMIug2r89ScSsIxDmetjSwx91KTt6vvB4JWE86RqoAt3dT0X6OQQCswih45s4sacDnceDl6E4IRZiM7V2XWoJcVjX/wFFWHVs8ztGr/le2nQX1rdUZRF1Op1bx6tXIB164GyHzOf7btrn5dzBFJnbn5NuPufnzJJp33Q1q5JgN7VUzc9oD5MB3mfuORagnrntQZwKVwXtMCDkDKUbQ4+yBj77Ck/90aFwL1irofokpU55JBBF6ujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YS3Jnk/LZTvKD4WR2B38gaVEsDqCBmwJRJ2p1esUkiY=;
 b=SezhYumZNTYAAn0ro79JnJv2909Xx7lcxRx43qX5HHLIQRoUb7adGCNHSHc1m7Ok9l2yuvZeUVA8AhkZSgSTtIQ2wmvHUSM5rks1QJOpBSoFGCkkIsvifCIh+YCeKIMiudBZlCBsjfyUJYj2+ddMa1+BNtG5b/hQELzkkFYVwyI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4791.namprd10.prod.outlook.com (2603:10b6:510:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:19:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:19:08 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/16] lpfc: Update lpfc to revision 12.8.0.9
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z0q7oe6.fsf@ca-mkp.ca.oracle.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
Date:   Tue, 13 Apr 2021 01:19:04 -0400
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com> (James Smart's
        message of "Sun, 11 Apr 2021 18:31:11 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0201CA0067.namprd02.prod.outlook.com
 (2603:10b6:803:20::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0067.namprd02.prod.outlook.com (2603:10b6:803:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 05:19:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af7a7ff6-8525-4c9a-9e2f-08d8fe3baa46
X-MS-TrafficTypeDiagnostic: PH0PR10MB4791:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47912FC6B5EE5AA324F3E66C8E4F9@PH0PR10MB4791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0+oiePLdZRdREwcIZslCqk7fUkStBb01aSEnxP1qhp1RlBL+mE4VZo8h+uEJ1MDwT6gfv0TY+G6gJeca3E3XA/K/uJm1PRru8QdFhfEQIDTgix70XPd1UAaE/BDzb9nRawOuV67OuUORa0QWjrEsVuS1apeQHlniUrCnSG963e6Ock+2B4/J7lRzwtuWCbjA14knSZRJWbfg+F5pe9u3olyDffLQ51WOLdIHgSkXbFuFqKso6UdBAcI5AfXl4sE7xGYJc2d7IY0fkOyomi8IvtDurkksaKCLoGGuAVi9CBJK3Ucrhzjp/hR3tEzFNTEsbFUiS2mMvhNlzbF//U34FvGaH+cEL/BuDdacEsjIIzV8qPYCK3KE6JnAwnKwTsP4zanyyMGvXF3gdWhWs8QUK/bpEYj1EHhZ0Nh2ms9eUJcodMJMQ9CPv7THLnhvRsDSE8NmOorQwMVBPQ3X5wXyfU/LxAF6HXnImzSeBUy5cdjF2+LVn/wV2IpvMg39jx4p3IZFfb8Uikger/LLQq/LbPQW0i9Doy3A4RkSQBzg/nH8PxdPxnTJ3vBmWNKHWECJbGZ+3LW5TzdliEgEt7pf2MwxS4YmDoank28LfBJ7YUA3p3ZPoQCOhIq27r+MUBxziaJ+AtJY2wE8s8WjvLfA8iHa9X4yywceMuGckH3zOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(66946007)(6666004)(66476007)(83380400001)(66556008)(558084003)(956004)(16526019)(478600001)(8676002)(15650500001)(55016002)(26005)(6916009)(38350700002)(7696005)(52116002)(186003)(2906002)(36916002)(316002)(5660300002)(86362001)(38100700002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EyZWtJOdmoqKmHwA2pLF/Y8owVWgWL1QQCi5QCB+vdRDmbqWlTAHji0tVFVs?=
 =?us-ascii?Q?oWkiTbuQujG3h8+t1PrCYNKEtRutEUaOl50nxfEM+xyZvY1s+Ll0eH0TYC9T?=
 =?us-ascii?Q?qY82bIAODs42ncd1ZPnI3dSriQf9/jnGPRfPEpewtjdJINsVfPwXCQbp4Rrv?=
 =?us-ascii?Q?6uhaoFp4YiWj3vFD7CE4O+OXX3tXyfTGSsrLwWwV+UY/6Tw5wwgWHLs8G06o?=
 =?us-ascii?Q?6X7E/9oVEdWsmQT2yqMkWc2pcI2SG0/CsnwM2HBVhB59PhTXkFRokk6JqID8?=
 =?us-ascii?Q?Otp9ihvl8nfq7QWNMExaVKOT9WNyz4ZYzJ5rWJBcHSaTUddP6a2/Jx9Pctsk?=
 =?us-ascii?Q?pXyaDRpTBGCBplo866zwtT8x+dRv02qA2KbyhLQk9kF/OYxSkolELyHlTfqm?=
 =?us-ascii?Q?AkFdGn0xSRMLVJVH700c37JxW+/R+KGA8dpRDqENXE/ea4zOySV2k/dLS8tX?=
 =?us-ascii?Q?Ya2sHDpPDRNpOp6XTL0cU3E8NSzW9Tj01Z+ZTaNeA0LGidycAX+/zi5Qj/KV?=
 =?us-ascii?Q?ruP8HH4nO0OJTsX9Rkl6LOqjdUc07rFSILzAjLNZjQM7LFD3f5ondoe5CeqA?=
 =?us-ascii?Q?dL+Zbj/13h6Wu08kiVUpGMWZM+ADqzaaw1PcgUTr/XhwkzcxC6QRABjqPEvv?=
 =?us-ascii?Q?ns5FCGdTDGrKXCRBpCpB8Y0lmN3XMwS+YX0f3aPMbOXWLsZD5ifAsZuiUJgS?=
 =?us-ascii?Q?Lim6EFUb+a/qPO9kILFi2xWrrhIqp+amTGnRdJmx3YxLkEwzoLGqeYGOSo0c?=
 =?us-ascii?Q?8vHXLTWN/gLxiZ7GGLqyY8CZlKbRD+T6KT9yEboQXDaLfFcmLg9uIjGxzWOH?=
 =?us-ascii?Q?S/29nrARdOzT+b78OfKluXPvN77ToBfI4jZXKF4Ac3Zl1ifaLzsxZTKmX+Vl?=
 =?us-ascii?Q?5j4S2/oVMaU1XiAlUUgBlnTz0Pm7AoisaSTwT4WLJfz5pV1jEpkjwdYMogOF?=
 =?us-ascii?Q?vGmcLpXON6TvXMYy4KBtaTjfVhxiMS48K7BaTnyj5SC6QaCLIXC3CvdTJGkJ?=
 =?us-ascii?Q?51eKDM4RZ0QxcDqG0Qkg2Yoyg5MPV7NE8Q9wHB8l2imbNR4TeR6nF7X7zNF0?=
 =?us-ascii?Q?WxIh2YueTeKCWx14d0HznGsQGqCNqVJtLedtOMNDG4xI+enFpuQRnXp3YSnp?=
 =?us-ascii?Q?p6QfuH7CFSf4ISzscnnIOt6hUjNndCgqNe+23cLpQvudV7eON4X+3o1wVEQg?=
 =?us-ascii?Q?Z7bOewz+mL1KmwPk/jtGoEbXP/hPYR45AcQZ2iMQjY8Gu65QHqIuJoK16sNy?=
 =?us-ascii?Q?41rDiMJ8ZY3D58I9qHQ9AbC+67Nrzi0TqpucSnp7T9eNrtCEZHbsue2RehP9?=
 =?us-ascii?Q?BifS+2t8aGC/zra655kUkv6n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7a7ff6-8525-4c9a-9e2f-08d8fe3baa46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:19:08.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/M8z1DcwegYAlf+nYWKvA2iaOpmUNEr/VxdvvWZYsNnC0yWTbdTrbzrNzDQzT/y/iFAkBqpFUDd5TVUfZjvr017SFNHYHUXV1iLoFCaeF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130034
X-Proofpoint-GUID: TSAbum8XGWiBdK320SUodTM_7HHYoDnI
X-Proofpoint-ORIG-GUID: TSAbum8XGWiBdK320SUodTM_7HHYoDnI
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.9

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
