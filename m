Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6958DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32B1B61073
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhD0CqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:46:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbhD0CqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 22:46:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2aDYY032454;
        Tue, 27 Apr 2021 02:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8bx9jMOW2zJ3MRPGKPogp90bjkAOn6twRiCOgwelb0E=;
 b=Npxch+y0uXiIM7I/QbGD0iUodxKqR0rTG1FWfursv5ak0HRqROFAHKMa7zb33N8N/wIE
 5XmJzocD8sTYL8m7E5/o81n1L/tcqJHVHZBjN0JxtdWcq0IWf0MMDUg+zE8z0KkvaJqW
 uYWxOQ1SE8fAgIzST56w9zVDhwtPguNC4nKc+KPwyilpyBcD9zVhQ5n+AY/oKaM0dYG4
 BqAW7GHhyejmP0E0v8EZ8VNo1/0oXA2nGtSccDnQv4/viI61ebxMrIKWhGT5e972Wc1I
 lab7/y8RPgtJWsRq6hY+A3PziV0OiIM8XWQA6tUewVqqP4WoK3HGLDymBTOgf5ncRJaa Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsuy3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:44:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2econ090774;
        Tue, 27 Apr 2021 02:44:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3848ewa7qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:44:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSncC/SyW+1nX/wY+skNgy8X/b+c8wxhbW8Dme5HvnxI8iHS5tFZ6WEvFhotOnY10sWXwXKo9rZ1AbHX1INRjpRoHyr/H60canAmQmc1cwWb1cNZcllaN07JMFkNrV8Tsgh/tNqSAznRWG8Au4HAydfGp+fbjLTJAVdg5lBYIrMSIV6yp/aggyXKYqZHvEZfZ9lzFANujKIPV1BOTXh3w1nqWtqT0I/4c5IY9EMqQuvfM/lPJ51sb+/yXjYoOvHPY/ITnPv6O3mL9t8fH01Mov5YWpWh2NGMHL7Zfj0Vn2LG5/OyEMnvHJbpzser8WzSM/YPhRoybJY4Fqr0SE/Zsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bx9jMOW2zJ3MRPGKPogp90bjkAOn6twRiCOgwelb0E=;
 b=dstNxTQr2QKYcGxYOVWB1xsETaeNfChCoLijJCOdVwWRQHY7FlzSCctM9IQOVuYb8hXFeU9kyPzEISAPPGfcVIshv6rYEwljfTQzorg0yQ8Oa45abQe6bhDxdrDuB1Bq3Y+iRCL6xqHMcXxeKjSOolOA2lFrfGi1y/P5REZtSn0MEmvyY8MXM2nmHFyiUpE+OI5g7gHeqDl27iKKIDxsi60Tp4oj4FHN2BQchCuxjA/NVc5zLGBGEfY6S7F4DFU5TWmUY7afXfD6GcgpxNRdnZHJ4Bd3ePuOQcmI8TsetawgrQWHbU23R/SNRHOkmKQ7zJx2gScsliq/VxId8Rqiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bx9jMOW2zJ3MRPGKPogp90bjkAOn6twRiCOgwelb0E=;
 b=ta+ypT1/zxpvw3pVFbx4YYmMXmOaCXXj6IW/ltrD0i9Wka4cq5Ve5mmOlxk+QHSDm97UuUjEHuSvJtvty+syFGZp4dY4F4yp2zVmmy5lwqb9+kbem+4SpVHUs9oUdyVXWtStJYqT1vwDjoxgSW5pIVzUd1jvLrsZSfINojWQtu8=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Tue, 27 Apr
 2021 02:44:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:44:53 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: documentation cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tunso39d.fsf@ca-mkp.ca.oracle.com>
References: <20210418203246.782-1-rdunlap@infradead.org>
Date:   Mon, 26 Apr 2021 22:44:49 -0400
In-Reply-To: <20210418203246.782-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sun, 18 Apr 2021 13:32:46 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0134.namprd11.prod.outlook.com
 (2603:10b6:806:131::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0134.namprd11.prod.outlook.com (2603:10b6:806:131::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 27 Apr 2021 02:44:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80672f18-22cd-4088-7a6e-08d909266f54
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4776285AB07A1372A4875C1B8E419@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTw2wM+xN+90flxYpDuUVduH3PvAyvYxPWuBb/Fa9knhJC8VZj6zwWHT+ZEqt/550vg11nfDT0AcGLh7ilVIWnMXShONgPg58VRifrP0O9wn/8BpHfco6bewjyk6lyFW10aMULCLb6/Lsmm5Sx/70M8dl2td28btFLovifqY3yLmg9DjEuUEz/KCQnTBEdVEtWcTRzEbtWu0OhHBEKQEl+MgCPwu2S7H+pTdU/ZJMc2fg1MnpRDWCi6wNpxIQ8m6CPgWrxtzCbDU/psQBnwXZ0riL7n57zhCMtIRVskyA8QL6+C36GNKs+xFeeraJJgIDoMacM7Mh5i3znj66t2FAox11SVvbxqnHlJ6NylGZqLI/KGwZnk1hpOxRebZgyZ55/G6LEHF+YOg6g6rSUWhqRbifiebTEyhYMZMkMOU5PkpHJX1qE5esXsvf+Hg4grVui8NfZOTLEJ4o9re6rAa+s1PU9Xx8eshO/2XhDPPvmts/u5OGWMbEB5aANOjHPXd9LuBT92EYm8LHw5M6AZJsasVIavQwx81fWmS9NJvw8TBsSYLxe/TU72NTmFMP3oNjg16FSHnPKddm3IjREHzTyVjAtVbOoF4nHQQSBvxm5oYZn0tpES6wdQImZ65ze0O1grPKtxq1r7Rzl7kk704ZNCJrqURy2PGkkAt4ybybZhFgml4j9flM/+BKTLjw4FR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(66476007)(66556008)(5660300002)(956004)(86362001)(6666004)(2906002)(66946007)(26005)(8676002)(8936002)(316002)(16526019)(186003)(83380400001)(52116002)(38350700002)(36916002)(6916009)(38100700002)(7696005)(54906003)(4326008)(4744005)(478600001)(55016002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QlcjECCNg56nRISHwMmAv0ZDNtbIdILYpAjFxlEsdBFS54JlvAB6OOLl0uZO?=
 =?us-ascii?Q?2DCYaOdenDqb9BZFnWDOZk5CkzugMSeTkRzhNtdQglZvN5RNMfwurq5igj4H?=
 =?us-ascii?Q?c8o7WcpiDOUOD1446yGNlXspH9S0djjnDmvD7UGNUNpCcTJg/kcYST8kKkPz?=
 =?us-ascii?Q?S9Ov23LlKCINzdTymCwbQo+m7yKHpfvhkK82FMIdc/ZUcOy6AWDdtEzpTu64?=
 =?us-ascii?Q?SttCs8EJen94zPR9CoT7b4MfICb1jILNvc636nii1R4ZAG268eykCPDO7mjG?=
 =?us-ascii?Q?RdeZQAU8KWhAGoCnX9lVvylu4jJmdz0BP9QT8LwRFuLcxVx93vy6Gk3sWlVD?=
 =?us-ascii?Q?nx5B8ZmLK6SAjuFg23XZ4HgRfdvxZHIdZAgHgpG6brkf96/87tkoJU9rtM3m?=
 =?us-ascii?Q?BMX/nhlTyVwPjHYqwr/oZCj7G3vVB8AgD/BqTklSnbDatkNfnbU6aNIsMg7i?=
 =?us-ascii?Q?Xxnz6QC1AK+/aKtGu5PC+dxr1rfv5Sim2FDEGnbEu8ePtMoKACAwPQgwxYcJ?=
 =?us-ascii?Q?cWlrA4hWX8t4b5Odj5rcM50RVLuubnZqjFh7N3pZm+cPsju0nTtD4cdt7kys?=
 =?us-ascii?Q?lUS6hArKvImBQnGZRvrVvYnvybx2c4LoOxl2bpHuuCMiv0dYdk83lkHEYtqH?=
 =?us-ascii?Q?pyhjc4IOzQ9Usakejtf1cUGgUSgzDuTY+vbbRaWyKWlp8ESd6kb9nHHk2a0q?=
 =?us-ascii?Q?l1nidImMxHB0IW3emJ5jrfG/TvJO2L/OLLK5tP+1QTfGXLwlxafwPpzgrNTF?=
 =?us-ascii?Q?lYNEYEKb2niwRF9+D9NqL17kpFI01exeG24vE7Lzd8zRYF0DjpTkPiHa4+av?=
 =?us-ascii?Q?xAl3IA93niLFjADbtZJVN4Uk27y/YzRkWafJD4fb3NHxj1Edrml/s/ZqN5z0?=
 =?us-ascii?Q?zHG7E1Ju6l7atdqQZBiPO1qy1OGrxxJVH0uZsePCAqtoq1JYSes9fiNsfzlY?=
 =?us-ascii?Q?cwBk8Q2MWYFeNDNTXmJAclYLL7fGCUNXbqs0qCrGI4J3pc5BKKIAhEWxdnrD?=
 =?us-ascii?Q?DjfEvq67Fiaj8pfRuP8GGIujkZwCS7Kfr1SPSrVakMz2v1VsghGhKTUYASiW?=
 =?us-ascii?Q?BXENoOXp+2yWLVh3krIZaUR0Eoh1IOHNMgljL67DtRtv7pBW66dxeC28v30V?=
 =?us-ascii?Q?LEWbxyLnb4y8CPEB3F83/iW4gL15SCjpL6fXjIMcm5US2Q8zupD9xOsn/F1N?=
 =?us-ascii?Q?p+9oowRBl5jglMqaOd1jD40K5b41a15nZxyHtmvWW0ZzukdM6RIfxcrYjYgi?=
 =?us-ascii?Q?iF7SVZO6RNyCR48+z98XWiN5mlOW7MzegaJICxcMwQnBrY/STKBj/i/jOeqY?=
 =?us-ascii?Q?KMJbBAaZk0FamFstedh0l1vN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80672f18-22cd-4088-7a6e-08d909266f54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 02:44:53.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eV8r1P8kbPGQOa759YTGU+EF+hs10D0gexM6iaxHsXypg4fuuggy7e0nKsudU+cjEogM8F53ZPd18kmTYziCy9XOXAxtPymytlVmihYQJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270017
X-Proofpoint-GUID: czhIa77HVDmaSPje3kWJJe9rHOA_hEbg
X-Proofpoint-ORIG-GUID: czhIa77HVDmaSPje3kWJJe9rHOA_hEbg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Fix kernel-doc warnings, spellos, and typos.
>
> drivers/scsi/mpt3sas/mpt3sas_base.c:5430: warning: Excess function parameter 'ct' description in '_base_allocate_pcie_sgl_pool'
> drivers/scsi/mpt3sas/mpt3sas_base.c:5493: warning: Excess function parameter 'ctr' description in '_base_allocate_chain_dma_pool'
> mpt3sas_base.c:1362: warning: missing initial short description on line:
>  * _base_display_reply_info -
> mpt3sas_base.c:2151: warning: contents before sections
> mpt3sas_base.c:2314: warning: missing initial short description on line:
>  * base_make_prp_nvme -

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
