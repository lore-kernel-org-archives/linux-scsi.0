Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC1FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9659613AD
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhDMDXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:23:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54358 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbhDMDXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 23:23:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D39xcu185011;
        Tue, 13 Apr 2021 03:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=B0iQ8iAE04BYQR8D7MW5JYGBPgJiVgCXkLRFsU+dP0g=;
 b=OJ/tAt1ShehlFihwendjlJJa9HIJnKXsLw0B6/VzuXYTYsUIAxR4dccoxIcjaOuEe14a
 3QsGzmpOQr2HX3EwMdCESLGAUZ6Te5oqC7PetL5+JJeFg5ReLqirqk+S4NSocQwHEY2t
 d48nFGxT2RNzSM86wlnsqCdR6Wpxo69GakX8PIThvoyLDFIDD+wiZDRGK9+0ne8KOYZH
 Z3A21gfgsxu3uYm9TDl1nash/dIVcKbXzCpLvZvAlY02kkZG1wRGQO4dNivL46Oqe51N
 NdrFq3LZoXfvPa/9MAqgFZ7U+MwLju5kuBFFjQAewImmdK8PBENBRh3HmEryDJDjIydn 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbdrey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:22:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3BRHH085532;
        Tue, 13 Apr 2021 03:22:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 37unsrubwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:22:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjCWmf9uAg9bKRurqaUpt0w0mYmlkwsH0xHkxxFhssdmjJvSM2C4iPnjEEwMHOtAQIjoOBQcKf1IBBXKJPNRj2RPxamgGuYmkM5jXo9gtw/nlMxxeqqZY9xdJIxYbD3Co8WIH0tlkOKREiSOtKaKeFQxN2J24dKlDPtK7T2n7X8E3E4zdwIVvZgLfD7PmnRrQ69n+TE1SuWdzVY3BynjRbDUo+RxxdktehAoWl9h21lzjtcmacg+e/kZvbYFhMvPPS14VeonhvT3ixbmRuO6jHtxK2//VnpJhV5pOvl2etc+2eJqfvbf7KYX7p8wao7WjHt7utS/nUeVg4JmNeJYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0iQ8iAE04BYQR8D7MW5JYGBPgJiVgCXkLRFsU+dP0g=;
 b=FPq1pRC4p6B8VsXzjpIE27udPfAcK12nRLeZle0ynjgnGJbtrOhTa95jwja9u6EerP8JOk0SQaptQrtdsPmU1JyK1xMaj46cUvoO24XlJd28o6Aep3cDc+KcQGuJ1Wa85guZSpJlVyzUnCqWL4REddW7YPqduB6IRtfUV03dETUQ+cnv4qBr5qVddSldtHk4EIk44fMDYVSlTjMBkXh2x2AQLTC58FtendNUQ6sgc8fYjpABgg7xASyvlJKdAQc21KLRpgJ9u8fOeYzuiqRRcMP3Ek6f1UGbVVxyJ3GOgdLBQlv73HYdu7yz2SnH5H77PpD5w7cTA3LqEXsLil9dnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0iQ8iAE04BYQR8D7MW5JYGBPgJiVgCXkLRFsU+dP0g=;
 b=YrxAuyTpLgGjQsa7GdIH+l3GhogwD1PKqEYo51zPoyBKwVnPvewbG1gd77B5bhwYHeplEytedc2yIhTXeuDiPPLCmvY0MGjZDLJIuLxpFZmYuxGS4b/siZQHhWRGYE/blaYp0+fUMf3Jr/InHywevyUBPYU4Y+erR2hbtOeBCRk=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 03:22:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 03:22:43 +0000
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v3 0/2] scsi: pm8001: tiny clean up patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135vu98cm.fsf@ca-mkp.ca.oracle.com>
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
Date:   Mon, 12 Apr 2021 23:22:39 -0400
In-Reply-To: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com> (Luo
        Jiaxing's message of "Thu, 8 Apr 2021 20:56:31 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0141.namprd11.prod.outlook.com
 (2603:10b6:806:131::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0141.namprd11.prod.outlook.com (2603:10b6:806:131::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 03:22:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc78de80-41d6-4ba3-a899-08d8fe2b665f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442143088CE7C68F6FD6FFBE8E4F9@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kxm3MlINNPISWzTgwX6QfTmc538QXGuosOhTdE/QZ+yllmU+qsMe5A4BOz7DS0MfevrF1k0nOVTrvnlYmxVmLFqzynFsK0VHgLTqbi7NqamcOFSV6UnxJuh2uFu6sNtzmlPJcfd7QesiIQ4y/iP/dT5qSiL1OT7VxYRnOHHFheHKZLGB5jDZCnnd6P6NwOWenlKWmu8QeTO1rtAm9M1HP736mjXzJf3O8jWPixe/XbAWCWjCeCajcPqaZELxUA7abQNHuYcvqSWoH/dHBvuVQLXlLGaiAetYGBYLG+Ff+wLGNq6gMov2S4tpQnbSdpGDXA6FdZE2X1brZCKXumd8F722FPoP2wbFeJfRd2Qut4SDkCMNH+4eU9tCD0PvTSxeSEuIHPQiYnTyE6lIgoVZqT2+6Q9rcoDpy9QcdFBZaZWvUGCCjnE91Q+O4IWI1xOLo3/hS3Wytlvv5lnyizfvabbkE6B5M066G/9SzeTkZI/sZ5PDPk4SCHoDifMvgx6/aL1rQcQdylZVAI4etYrQMBjboZ+2Plg3AE9vZNdKZweRPPtmtkoQkmzoxGGf2LL5llecsFpml/htzqLN6wYqxKYN3EbgRvPtnvSTfVcIdTf3VHYuae+zAhynpyFcKrBpoN+mDedGWuA5gN0SmyESnakiS+M3rNRS1/M8JOD+zSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(956004)(478600001)(558084003)(66556008)(186003)(86362001)(36916002)(66476007)(6666004)(6916009)(316002)(8676002)(8936002)(38350700002)(52116002)(16526019)(2906002)(4326008)(38100700002)(55016002)(54906003)(5660300002)(66946007)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w01LgPAZKi9rueh49J0kw21V30OgPRNPwAmh3j1q8mzYF1ANss4L9gdotK9f?=
 =?us-ascii?Q?4Ppm9v6z1P7ijNkmhUa0N1Ev0SPQl+tHOg+Pi+hIjlk/5lzHJyOh9sofK7e3?=
 =?us-ascii?Q?lglOlEkoLZFHNuBStOweblj2LRXe+lXX55A7zEcun1k2F822uVu3mJZniPXg?=
 =?us-ascii?Q?JwrAWB+a5OTXsEM5hoOIEhUEDJwvyHe9LZ3ykdSDT3bYNof8Fkzd5dSYPSES?=
 =?us-ascii?Q?Eurgbuxnp1Rf1wc4wkFcdJr0Xi0Ql8hzV7frf+aGDKlAuSxOd1gSFDS980jO?=
 =?us-ascii?Q?6aqQ1fViDfUcN0KnU7dkcoyRgFGrIBeRYMrbz58SkGUkmM1QqTxFnsPFvy9S?=
 =?us-ascii?Q?Z5Fo85fQmJvPdid3QX7osMUR0Jg/Nd54NIPtJLh3vcCvz5dQ855QAOfkuLW+?=
 =?us-ascii?Q?6TKr9kZd8VzVtOT/c/tmpPMRgN3WbTSG7SQM32LJ9s/DVdHhiM8zOQoh68PB?=
 =?us-ascii?Q?M0kpUeKOFqPC9+FEDo6loSo2gFvtKGc8g+W1a5yqfLvqrHFsGKaVpoNZrI/W?=
 =?us-ascii?Q?96wHG2YbAVHSyBZ+oXsaKiQn2TkJcQ8PrfQbYalxcdJ2ShqsDou9vEmczLyP?=
 =?us-ascii?Q?dmbX4Ktq9hlTxMqTPWyD90ZgL8Jjh3Anl6K9H4Q39mz3SM/2rX08FGs2O+eu?=
 =?us-ascii?Q?gcNmLo83KWGUdC/SYYX5g3K3sSpOkxIhnqR/tyk/eBZOyFrQ8k48Nytx3mek?=
 =?us-ascii?Q?Vng1RB3r/wLtpwfPhyxE15NCJtr6gT4Gg3EGhDKFMgvA4JxwbW+Tm0dN81Nq?=
 =?us-ascii?Q?eEknj6/6xD1bclZVXOpvczv4+nYsY1/jDt82Sp8EWgn8EC0CC15x8QjB1T4Z?=
 =?us-ascii?Q?N3lTjZQXXVtCRPXwIYc94OaR/QKeieNjyk4TbNhz37G1CI1lTBHSx0Gzt+p8?=
 =?us-ascii?Q?WuK2vVVzjQrPeUIxh4sr0F0om0jbNxr7lpxfhd1Qt6Qjqp2dIREJOTDRgefG?=
 =?us-ascii?Q?6MkMUX6iBP8liMY4bj3BxXV+vE5RxrNbcoKnqOaIWV6dqbQc7mStsnuLCLrT?=
 =?us-ascii?Q?VZlt8AeTLtIPrANwDMMDxg2pOUG4X74yCqn40XJ07Flrr+lIR2J37Epk36aY?=
 =?us-ascii?Q?cp9rydT+GDo8vsCHLrgvKLzA4ITPcT0ijVp2+JoVbirCvW26wxphkYJr0/K6?=
 =?us-ascii?Q?n3hWDASjZpWkyb+1Dc1KmCzCr+8slx66WvnQSo5YcdbDU0m6VXzs53iAZZdL?=
 =?us-ascii?Q?atFlcEfpvB8Wycb1V8I3MnTmXtMPDtCabRDLytShrfQzioKzd4UCZaOLRwqc?=
 =?us-ascii?Q?OW2OGm1v80VuhAuTHqkLWoPstdLhC3+27S/iqv4r21RIAyPHvJVLCAdFI2q5?=
 =?us-ascii?Q?NCcmVPGByU3woxJyUAfBON3E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc78de80-41d6-4ba3-a899-08d8fe2b665f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 03:22:42.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMhh21FaPVZfv5jotIv3dxt2o+VqsAFoTpWA4DsvZscgrVql0Ac2zybyxyQX5qpepO5DWZUS7TX0sEc6ojzodi/UYZSy202E8N3ttfJdZgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=867 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130021
X-Proofpoint-GUID: p3vbmrYALbqN3kKMmqe7piJgZh5rCCiq
X-Proofpoint-ORIG-GUID: p3vbmrYALbqN3kKMmqe7piJgZh5rCCiq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Luo,

> Several error is reported by checkpatch.pl, here are two patches to clean
> them up.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
