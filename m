Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BA9C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 22:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiBSWTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 17:19:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiBSWTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 17:19:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599785675E
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 14:19:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JKNBNc007169;
        Sat, 19 Feb 2022 22:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vWurgEctHmIRwVYxaQGjQ0XasJDD4gfmLGAxrcZI7lo=;
 b=D7xzGBFzhmfCgRqRI6iTbddupctKzI0KSBkpHD5xmV07+u03ZB6e+SPGx8AOBKmNk3KS
 Kyq2/ytdpnTQxc8r7TwgeDwCD4GnqtXlwwX/lMFVpECZtdy5H9AlHRZLraqdtzgMOCOX
 +LfxD1G1l3wNjE7llKjMMteE1j1w7v71iBbWyUkL3BvnoYz4KHv7qPFLjwsdpALdY2S/
 8ELkpBm5JNbOP4HebHAxqT7IlSCLmCB2YofKB6ON0QkndKcnuFRoesMRTGudyCZQn/5E
 KNLuVqTapIcITMugurugjQWmqsJsk3/HqHCfLqKKHo5/XtJPnm1XwkmR3fO+0BLOBNMk sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaq5293gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:17:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JMGJgq189963;
        Sat, 19 Feb 2022 22:17:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3eb47x5hbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:17:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaf0+qUMEE7f+IbOj8GH8WvG4M68IeSj0elCb3oJhI3F9+t3jzHG4W2538Qsc+2hfFsqqAMRchJgBbIwdHx6kj5+pXKC52BIPA3/l3/oa2SxAiQz7yqrtYhvk2/P33U+cRdB9W5VAT5d8JAq1p+mgoJJnRAqXurGWBzViW568bF5Ad4zVJFIDZ03ZZH6KDijWENTrXsXmGVJjmxs9sbKW6PRIYHUGBK084fAY6QBT+0lm434PbE4iv/LEV4QBDAtG2crm4b8QShRejuTjJdYXtk7jVK5TOSCjNX1KCJqUPJoyuwte/0qKW6MiW/8crBZPMZQctwaBON+SICK9n5XhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWurgEctHmIRwVYxaQGjQ0XasJDD4gfmLGAxrcZI7lo=;
 b=g+5fVAziXYvrQWYTWUeEJmsQbP5UBza797st1fwvwwHS4Rf7XH136lYAHYEsoIDq+f2GyzHZ5Qm3vfsdkMRzipYSnlUdJly4TiAucf5MqXrROYHusqQRntVxq5Pbsq9brXzkrOvsY/t2X4ksHB2uqxsXbj6B5PpLWRqQD2L8COp/dUfb9XH29SNEbYU8rHE8TXNHsYLaMUysn33fUVS+DqOOVpCVVEYm7kwwRCu8fTYe6k4uM9XH9QDuLobWK1tzcVwz801Ngsf5/Tn4mXCFkcMb07ys6Or/8Ri+hkbcDZ7R5hg90N3Fbh8B535M8ITy/YcPG2vP2oGLcNABnrHCbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWurgEctHmIRwVYxaQGjQ0XasJDD4gfmLGAxrcZI7lo=;
 b=jkeMInZJEGB2SuHM999YglWCZz3oKAeVts6Mnz5JXrzzW/cXp1vsbKZJ9Yw659+Fm8FhvYstvDoZBCh+fPe1VUJJu9h/rB+iUATgTVODBbsmIscIe9oX7Rum90kpn9LLAHbpXdx4xx73fTBe/j6PM/pue3BtkIALiaRfCQYNob0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR1001MB2407.namprd10.prod.outlook.com (2603:10b6:910:47::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sat, 19 Feb
 2022 22:16:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026; Sat, 19 Feb 2022
 22:16:57 +0000
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] qla2xxx: Use named initializers for q_dev_state
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czjih584.fsf@ca-mkp.ca.oracle.com>
References: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Date:   Sat, 19 Feb 2022 17:16:55 -0500
In-Reply-To: <AS8PR10MB495298515A7553C8D6D6E74D9D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
        (Chesnokov Gleb's message of "Tue, 15 Feb 2022 17:13:59 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0071.namprd05.prod.outlook.com
 (2603:10b6:a03:332::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16262bb4-61cd-417b-316d-08d9f3f58afd
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2407:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB24072D7A8771BB03EC9C85448E389@CY4PR1001MB2407.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XU5/uJaE7PWJGneIB4C62Fpccz5Oqe+7+nI/KBDsoRG2lgby8wO40W6+s6uIdUn9t2jzU2ZEci7071J6Hd8eQnvBO0zMnEYU2Og9kDhCTO4vz93yTqq4MzDb6eEeAUsHUJY4e1mZDWGTPxmIirEwY3wWS6qa8/ZF2DTxrsPZj6YN5Q19pj0MXZoJNu/m2mzu16vbjojHKRPeGNalj5a0JD1hbURcaTUa0anQPvcY9kw4OKMI2hGHHPKdEvo2MsTLXqDNNQ7gtORxLoL/c3jURpBTns88Xa9SvCGY2UVQ9BQYlRYqda+k39OaWB24JkGKu1RoGGMZ/QMzq2K44cQnWSLb7bTMKU3nxusHP7ErdOYN30ojcmfMOBMo6JaV4YdlWW6+kFUMPFYLJCvMddJy4lNdg6QvjrLa9j/oiQL21+XxW2K5WiZpAuLXExYcRjHwaOapR+nULeXOQBwE2hLIhrQ/iVayXqkoiLQz4m97GBatQkSUHiQm5hiAJS0GNEXQnESDnQURJboa4DeNP/FONLRTO+FZl+0M8UuK5jUwlNVJm7LCmS8Oyta59TOhm68Vn1evvqkj/Io/rHxeNQqp1Pn229ok3FJWUVsu9cBFxVDYjlo4IhCe4oDKv5N0cg07bcsTfBIWyquH/JX7GCQxd+czuJHsJXGXhNll1pXIddHsEYbJ+zDDtOTwlQ6iSvuo/UcjafhCZHwaAr3nzSYfIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(316002)(66556008)(8676002)(26005)(186003)(4326008)(66946007)(86362001)(38350700002)(6512007)(6506007)(36916002)(52116002)(5660300002)(6486002)(38100700002)(66476007)(508600001)(2906002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aI7iHGXEpYaBNyUvVuXWbOeptQWW/I7Lhx8ONviEUYN2XOmwwrY3rABOcor3?=
 =?us-ascii?Q?prC/06nUUC3iUYDVRLv2Tv/06bpx6ZKlP6ThARfW40meWotZ0kPn19KkxjCg?=
 =?us-ascii?Q?oScVdhskblSKXAfRUiuQUlK+alLQJCO7ifjhLwTjnVz740ejzWc+IDrf5Ji7?=
 =?us-ascii?Q?8m+KAUw/5ldjf3K5U3X5dLUk8mzfQw+5JLP4lHQw6VIWHJOACMAECULbjJiY?=
 =?us-ascii?Q?dpwkZJkBDOpj9QSfOWVWx4UPyI16y3J0Uyf9/UJ5n0xoPiGSiD4qi6cPIS3L?=
 =?us-ascii?Q?zZ+jTANWaNOUM80SdVbO6OMJa/enm3Ufdj8w/BKueqtzAFH5EJwA1NMIHQLM?=
 =?us-ascii?Q?iFydJcBYNgIC4Z+qElM2RrfL9NytCPtPyW873S+jramvuLLghBrGmx6pp0mN?=
 =?us-ascii?Q?ErVsKmGPChGh0aOEi7vMvNtLFuc8eheESlgZbFWkwXcSfJn8qT4jyZ34rywK?=
 =?us-ascii?Q?Px5FokX7McAjWk/myT7EAP5nmHrw2QP4/OokhFwzd6qEpddeg80o6GP+Aaub?=
 =?us-ascii?Q?Vz/nM7KYw82TcjDy5Dxemlqz6Ci1NAwYcceFX1walIBKSuEwnnmZOvIfnqZM?=
 =?us-ascii?Q?tqoq1JW1dvifjx3udE2feNFDIXLXQHmntGI3RZA2ygVP+KiigP5+h7qOBKt+?=
 =?us-ascii?Q?h2tIrQpZ8RTc+VUXh9ezRyhCIR6XShAiBFXWfCSKNOJPkmqZ3N20NutBCEsL?=
 =?us-ascii?Q?CEZ2XJRP3o71oFahSbNlZXPJf/WeRwMk2Dv2EBpoKWUQ36YuUkV5d5vERm+W?=
 =?us-ascii?Q?Q18cdJd/UNXNT2zFv3IcfD79cULw4RpRIWu+cEoBGLBg6f8U0/rgvRwFxc9E?=
 =?us-ascii?Q?dL66r6TUv2gaoVnQFjO4qqo887x5ObvN1x8OFbgZtG2L/LZSWRCh0yWcoNIQ?=
 =?us-ascii?Q?aOQQdivvAiWMfbByOd4xe7gB2Xc079HSVr2Eoq6dMQKmbDe/OdeSfkIdOKxk?=
 =?us-ascii?Q?0U2rnNvoF0MEoa1gHxSOIdTeLI/TGF+dkaK01G0eq9byyY/267pXnbRenaNc?=
 =?us-ascii?Q?vhRYaO9R7Vp1o8uR0caxg8KMwfSaPf1pW0CHMCDvV+zcu7EW6Pfob/VbtT69?=
 =?us-ascii?Q?W7EhaSquErHE8VKcjTEAlukKqya2wc67o+itKXp8XIjAs72znwVuiFBhTb8C?=
 =?us-ascii?Q?yBLLf/ZQTVVXtzjpOfHnFSHyuXOnE2iF6vOCy45MTEb/KI40JOf1fFct6nAr?=
 =?us-ascii?Q?dAKR2jX37NJqLFZKLD/3S2tTgu5u9rVeOnDLEXlscGQ2ha69lLbf/fACzL88?=
 =?us-ascii?Q?WMXQ3fKeVOG+9CSZquyBcsr1RhCrwqlzy+szMqeKqEnqper6LXq/uoRzA3m3?=
 =?us-ascii?Q?i6XP10KV59/7TM78B1EhBoVpwQJfuAwCYTh27Lh5NMlapgQBv7KPD9LdH4Wc?=
 =?us-ascii?Q?NapseaeBk1UA+8+EEjN0d2mnMvbzZpPZbMK0dvuDq8od3S+p08xd5kuKx9Pi?=
 =?us-ascii?Q?hKiJXDBGk3VH/y6Rb5upoFbsxkVCKI2jydRD8C/rjtC9AEt30R/pKqJWWdcF?=
 =?us-ascii?Q?J8TdQC4XtVvCcPRqvCwmSnNjMzipKWDSUgEkQQvT+/9YYR0lwLaZs6iaFpil?=
 =?us-ascii?Q?H/I6P7v1InKZ7iq6cHqUud7k/AbQLyZ+FLeEjLQX0yIrfpYRw3bbNM1XKMjC?=
 =?us-ascii?Q?pTZXt7TkMEC4+wJkzytkZ2mU+XeKZ/GfpD6RzD1YMvpSNV4vmgSYLapNuz29?=
 =?us-ascii?Q?5qAY/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16262bb4-61cd-417b-316d-08d9f3f58afd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 22:16:57.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dezf0nufdMgo485OCRiNG92RqdeTXwYF1Ntuc5ElILNK3GMkde4wVxcoOWxUQuCsleV10/wckQ3xxfUeB2OrgqhMdo9paAQISKwn2GOCV7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2407
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=923 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190144
X-Proofpoint-GUID: guIawMSgFrBwGZip6PRlLepmZJhiKV_L
X-Proofpoint-ORIG-GUID: guIawMSgFrBwGZip6PRlLepmZJhiKV_L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Make q_dev_state a little more readable and maintainable by using
> named initializers.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
