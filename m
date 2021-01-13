Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F0CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED8F23132
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAMFd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:33:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbhAMFd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:33:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5OZ6E051577;
        Wed, 13 Jan 2021 05:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=po0GY6IjNWAXYc0F5RJed6FfI16vyc2x0SijAyiUTh0=;
 b=angdl5kYh8Kg2Hgu8jIyyHubpWMht0x6sEU3PvfqvuGzNNQXa//LZBFKvmR/E5g93RLr
 tluvqdM9Xnf7IEhFeLKSB+EnayP/k4oZ+hEdc3pTHjiHBHsUNhSfcZA2KM9JC4xsH8vC
 QCUbucUmGK4L19SbkZvQkIh+j+X9s3Vh4BI5Ye5/MNBq4/RG9PJEr4Gxp077tUptq0Ds
 crbZMtgneTpu3H0d1tuW9WkJt7wAA/Q62DiQ7Xrrjo69zERs9ADFm1t/0CnG7t+zlnFK
 goCvqbn7L9bKaxxKBA0zBnNzr6NgKJPy1VMKxjjFrTeERFjb9opn9gxmYccHcuO39E7Q wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcysmvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:33:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Q4N1102736;
        Wed, 13 Jan 2021 05:33:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 360kf003nr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:33:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG2yjz/h9ufOT1ioRFEtnoC0575APJhXMNEkgAaYlZprWKoWg89gmX2BH4miz9MQcUzhN5gW2urSSz5I0/idC3ryPIAyEqV4d+9sMsx6HzTWs0eOm6h4RAhteJYldaXhMGuHpNLeFbkb7dWyfYdQdTU1lCEXjGM0f8icjYr7ZcFgdTPWyHY3C3odKNA0Zbnt7LC9Hvw7XCrjb/pciRikXa/+poCq4tAUDvIlTCLy5Oo99jRBo8f82dFpkELruZ78zkL9DFWbibtocyg2rg9TlMKLShD1w60uHdgTVKCqdi6Vj9d1XR1U4kV4NFA+LIcJdaVJJTuijBCk43zD8l+yGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=po0GY6IjNWAXYc0F5RJed6FfI16vyc2x0SijAyiUTh0=;
 b=Iqfk30mua7xqCKM+KhVRKXq2WKUNQ/irKe+44uwzqLkodDXr4VQ3ymj6b4hIjlwBSLMgU+99H6HVg3yBvYTHdtR5DlYPQZEbal8+dr9BNeGohtlxjA20TBWudkC34obQ/WSeoka6s/6X5GX9C+WX8msrpyvurOpGDoIHvi+vqFA3qZONUZufRu0ipLe8750jzoUbtMUsYcMtiQTSh+RLn43HzLg4p1hcQ/Kk6gkTPDDR8FT3uFCIfEPISaIISsfRbWZQgI0B5fRtfndbYcfJl8WNHcSdLD81feDaFe51+NbctSb4OhjjbUfPvKLXuaUNjqcQgY6hL7oKSSd8Y2tnJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=po0GY6IjNWAXYc0F5RJed6FfI16vyc2x0SijAyiUTh0=;
 b=gk4hOVd0B5venKjaGMWv1eEQuPLbrdp8uwJz10yfaUXJNPDmFrOOojX8hf1t03jjb2Ad2OgduD4Lbk2zH3+oB9SeowJKGZ8KBA5WcbRVwbx5IQDg/e3l7y5pRcqh4ppdoj2TjmWsVHU1RDpdItYbBKvG7h3YyGym5zku2F6voYk=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 05:33:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:33:03 +0000
To:     Ziqi Chen <ziqichen@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        cang@codeaurora.org, hongwus@codeaurora.org, rnayak@codeaurora.org,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v6 0/2] Two changes to fix ufs power down/on specs
 violation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czy92yhi.fsf@ca-mkp.ca.oracle.com>
References: <1610103385-45755-1-git-send-email-ziqichen@codeaurora.org>
Date:   Wed, 13 Jan 2021 00:32:58 -0500
In-Reply-To: <1610103385-45755-1-git-send-email-ziqichen@codeaurora.org> (Ziqi
        Chen's message of "Fri, 8 Jan 2021 18:56:23 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR06CA0045.namprd06.prod.outlook.com
 (2603:10b6:3:5d::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR06CA0045.namprd06.prod.outlook.com (2603:10b6:3:5d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 05:33:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b881e577-a7ee-49f7-22ba-08d8b784b283
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46947B954536B2ED89143ED98EA90@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJR0+nB8c0/aDIN2J7NkdHIEYYSqT/hzTc8yrkqz9bPZrZxjUn1CrsUYeijRf9Aflb4VhWVEy3AShzNiarVK8ILFGfqBvt5ovaoQ5JenWa/nfGc2QqXumt7BB+qTlZWDYQdcGoEeqd/AmcxeikS4gQAMDo7v98uXWTl6kjVsnF2ONLbubJ+Hbj8zkyf2xR8UDXUpYvS1G+4fF3gi1JHLgoP8/w2ADaYpSl+NIgXSlzFmzjhMTiKyqx1bD2aj/cfc27ad6KMWax8WmrOKIozIBhoyN1AjcGQk+Y51OG9xjp8IK7r0iKpOC5bDtau/cxLCIrJHZuTRAvhbMNRdWRv6wwrsa6Dw5kex0/hoNMxDSSZWq46VEhzeDikjexV0KCe4URiJ6zL4bwfxmgAhrg8S9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39850400004)(55016002)(66556008)(66476007)(316002)(66946007)(186003)(8676002)(16526019)(4326008)(86362001)(956004)(5660300002)(6666004)(7696005)(6916009)(52116002)(8936002)(2906002)(36916002)(478600001)(7416002)(26005)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MFfuoWcGfDblokvOucm7Ziet0q+XOokHHfyJZNWn4mEwJYG8ASaq0LcdrgW2?=
 =?us-ascii?Q?kltT7wS9cLiQUsEQ8G9DaeppDdr944XhKSjgMq7FBMCRRZDUF+QdXJ/ayznu?=
 =?us-ascii?Q?QrjyZ6q03gnITno2bDqR7vHypJcik7/+ns3KtjcTXcIMePNOlMPTGxUEwW+O?=
 =?us-ascii?Q?SIT1g+gwSQGwQdYYrKZ8iDulZZO6O3lANp2Jp0HXqNfleiTvVnipnYoKSLqs?=
 =?us-ascii?Q?oCgDFW6bvR/h0uKjol6FEGsVMtE31NMXZT1Mv5E0LLAUT5C4W1oGpvVD8yO6?=
 =?us-ascii?Q?/TKTmjQ5al8VkyA0hBMQpO5esJcdNFjOZ9KABHNYt7FutfkXtq9/43fk+PoQ?=
 =?us-ascii?Q?14zIA3DMbWepUU4AbBd+jHexSgHTXqrc9l/BmaRoeYn/EhTU+V4wnDatB0O6?=
 =?us-ascii?Q?mLjdLxwvj1tKfYG7QyduDTuDu/VBW+V3yST5txeQ+ar6C7CIjoKhAIRJ67NV?=
 =?us-ascii?Q?+AoVSzZxdOYMeFV4Y1fzbMWm0y1+NKeXQhMKQT3Pwp2VSOXn29lHxE1gpLiU?=
 =?us-ascii?Q?RONYNZt2n2ijsbzCmSGfM/XuIj/TQZwTUYsM5bSqC6faz7Xnxn7Q++gwLxJy?=
 =?us-ascii?Q?2ZIS+thWJbzDxquHiu0CTFTcmmusdio1O+wyaCSlC2jtk+fI3jb4yDG8yAno?=
 =?us-ascii?Q?rjW/yMezVoUyAbSeX397vwgj/WKhCK08ChDiAMV85K/XYGj6UZQAVJhXRafl?=
 =?us-ascii?Q?+s3I1yMoka59UlWBVAJGWu+Oqminc5nwMfxPr1bQo2faP0MRus6qsdDMKzTC?=
 =?us-ascii?Q?B111oXchzehwqPM4ncKYyUQ51SyjCI35cZ8ZUjrZwGicFJbXfQH2Rc527x+w?=
 =?us-ascii?Q?9YzzzukIzwokmpE9pF9ocZrV7E2ymFFF8FWAFVur6HstojTZvJBNja/6Ufmc?=
 =?us-ascii?Q?uBgfeRLaueXpH+7Y/9HG6l23oculTmPfHdI8aGnrH+IcMpC1WaQk6YBnKwCA?=
 =?us-ascii?Q?Ond187xcJj4Emub0Y1jj0F1Kj+AQHCkAWukpaSNVAgDDMG57dRXy/Uo8k+u6?=
 =?us-ascii?Q?Uqv1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:33:02.9956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: b881e577-a7ee-49f7-22ba-08d8b784b283
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VkMulBQ/YUsgxu7SQJR+zMumhalIjtslPi9nSl1+1zR9ME8hMszWifNQQbkbkBZ1EF1w3A6MPZCnTxFICSgpzHKIKb+AA2msbI2IL18uZAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ziqi,

> As per specs, e.g, JESD220E chapter 7.2, while powering off/on the ufs
> device, RST_N signal and REF_CLK signal should be between VSS(Ground)
> and VCCQ/VCCQ2.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
