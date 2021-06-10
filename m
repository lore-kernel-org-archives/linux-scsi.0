Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401D7C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218116141D
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFJDAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:00:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56238 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhFJDAi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:00:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A2tVNi036425;
        Thu, 10 Jun 2021 02:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PnTUMc1qwKg3cJMZkFcDXnz37nDFdivD5vITZkDg9Xo=;
 b=iB8S+xVu8uDUmEVSQo0vnE3TtavW62G9R7OA2HcuUQZbm3gPiguS6sceplT3ruz31Uhi
 BXmV0I2oaCLOxXqaTPgbqSG9pGBKGodGWJTAPqeV2ilX6qadlqedi2cm0AQFKk1p1aN0
 C4aDUxIdur5VmvLOzLzw0OmfPdRzwP998mvzr7gJ1iEl99HzTVoqHT44XesZRtoQujuy
 clKu0QY1QeTOLhtYd0Thmob2mQxo/gIbnKZQO3Tp55TT7Q0V+6wGKHO09H+9oyjrESpq
 +7+zEXp8EgbimFHGzLXWfetVD4MHNhpto85HLKj4TkD9eWgyXnorkj+tAcUumEwlVQMT Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38yxscjs7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:58:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A2swgn003071;
        Thu, 10 Jun 2021 02:58:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 38yyac6br2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhVxzkyXqfNv2obhcW5dw/x6OZeef++gFl+A/YUdsweagxEdqkrT/RH2GUSDhCqSVj7CZvSVQwLIIULecpNqw6APB9ogihpB5IgAULOduTZysUj1hCdv49h1j8qJdRl4WLvC4OjFMm4uB+XWi2xZnlO4gWS46N90R0XR/q/Rp2MNfaFvPvGN/Z+IQd0R1fQtwzIXKmIF/1kOt89jlv4Z5MEVufUfd6kPBmTC8+fIDcJNiwuGCW/DRcxg5jBQ6VDKuSZH2MCnHIm5vJGjIbLTcluyX6t1eOmjFLTZHPnDIDMfsq/tYjYgAuosrEJkQ7uNxZm8MlyR2k7RLUJQMX9JUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnTUMc1qwKg3cJMZkFcDXnz37nDFdivD5vITZkDg9Xo=;
 b=DrKIiStgxUd99szcI5/+fYFzk4VTezQBB57fQxsdD8KiYnebUonSo4za485FYhxXiWrkVL9kqQrduowNa06QKysvTFlBqH3y2zP9GNvd3RlyHteUO4hOvYFKTe9866l8/fqVg/OhX37xE94/x8mFYFRy1TraU2Y3cTrGL1AKZBhuG0mCMtFnLJTHQzMg2HjDb5XC4drw2IqoKoSs2Dl8bY3HgApNItXYH6ueHcPzTFnUAcRrziszPpMJx6053YrHdEhA/ob0SbAFxWV79qchvyGom1PtuDmevgWyW3jTc2dxOeIrATgDel3jtiCMLLA8zOXu6KE581zpXD7erNoFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnTUMc1qwKg3cJMZkFcDXnz37nDFdivD5vITZkDg9Xo=;
 b=ILCLJbGm8oPTVNjSNSjphEnarvbvw07F3A0XcDVH/Xxx6xTWVyvCN9x9P7F5kkhy3kRu79ct+Nahc6bNakBof5ZzjjZQpCKjHZpGzQ5JlEqJfYufY3xxOlxMjB5ZsBXTXnRl29/ts//5K2XqrLXyn5/pEFOcpJ8QEegdoo/cBRA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5451.namprd10.prod.outlook.com (2603:10b6:510:e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 02:58:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 02:58:37 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH V2] mpi3mr: fix a double free
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7i6h1d9.fsf@ca-mkp.ca.oracle.com>
References: <20210608145712.16386-1-thenzl@redhat.com>
Date:   Wed, 09 Jun 2021 22:58:34 -0400
In-Reply-To: <20210608145712.16386-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Tue, 8 Jun 2021 16:57:12 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:a03:255::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR10CA0029.namprd10.prod.outlook.com (2603:10b6:a03:255::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 02:58:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2194fc8-eb5c-4981-48bb-08d92bbba49c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5451B24A76166EA635D922A88E359@PH0PR10MB5451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9WvU3sMNSYNCpmiHM1gpdJv2Lr+NlZFjIEwcULBgC1GAR/6j4mNm430fCflcqBspZ6mDrdyyipQ6FpghR5HLAfqi7H9nXxfawTJwGJs/HOrT53DSG1UzdojmONAyz3PMqm9f2lah8Ow3fDABX9FGlW4J4PH09LZxjxYOHryfH1E4QdZlHRAthghVk5eUp8/bMnAP3SouBdlE2P28ZE1FiURwKpH6SqBP0udD3LVg8iz83Jc3P7QxdLaODI0YJZamXARgv0RjIDegO9y1QE8tsunOnnre1Y6qyoudxeWyy/2cwLAa/SxIk7Te16n9D3uesBhnTZGIBGiSZOH5okJaaTrlfwAVudSwVnb1D2EeHDDxQgNnrVvlWGRrQOmoHyHtMrlhCSXM4EJlDZdnn25HPKCs+zLOoKfD+G/w5x8Iw6SQ5T1S6Z4aF17EQ5W72C2EXICw+livldIx0BRYy3Lqree2IAsjVo0xepkBu6hCca2afAxDgcxHbyo+naRbpy1IIWB7FI9XqTRex8CDLrCaGthi5cnO0XJE36WLc/dvsGsUZ94mes0xSW2bkClyPVBXT3AI4APGtfB6wtFdU/0mWeS2fXwB/8FcyFkBCnt2XNg0PZC2uzXVMnIPi1ZFMyYUZ3p2WNO5n2rY3LwqNtovCnYUuFnTMkM0TkPNJ/sp3/oGfCcsOQMdBAmDmwQlHiG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(26005)(6916009)(16526019)(7696005)(38350700002)(36916002)(52116002)(66556008)(186003)(66476007)(478600001)(66946007)(956004)(8676002)(55016002)(316002)(38100700002)(2906002)(4326008)(5660300002)(86362001)(8936002)(558084003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4skxm21zo3zJJeZ4Ij0xdJOVtL+l+wBUujcWE50gNKMwldgJJYSbHZMrY8VW?=
 =?us-ascii?Q?SeYcGX986aCBjR58dwter3AYgXXnwMOhHVUmdJ+MTye6e9MYtTOqOENz6tpX?=
 =?us-ascii?Q?4RcqfUHg0K3LcYzuwQoH+jvOJW2IpzznK4xlWDreEbDaTVRdyS61z37BhCbC?=
 =?us-ascii?Q?zpLruk4sMiGABELyOuFkv7RS1qM3xCCiYgoe+K41NYIymUhlWTVIyyUUzdto?=
 =?us-ascii?Q?UTRz7ikiknGdNXoNgo0B4jl+6FHtJ9yLzQ3YPzesXzFLVEczLwdaWmnN4Bx+?=
 =?us-ascii?Q?gwzeGZJ6UuilO3ir9fpxiQlKBVNNBHK9tFYoLWFicqBPFRUvAstzG837o8bc?=
 =?us-ascii?Q?IwyL1D051NIe6EddkXttj9LQT0ZiskTnST3U3L6xDP/8HyB5iFu19kljBK6k?=
 =?us-ascii?Q?gwUjTHTwIpPks5Gl8v8Vauxlkc8iTOpahqUl05U5RsDURb7ZMCDAlT72h+t2?=
 =?us-ascii?Q?DYubH9sAL1AWD+i+uXkjE/oxKWuTBgc1omw8I4b4Yt430TN2Q10Ihna9U9Go?=
 =?us-ascii?Q?/pzhv1tHz5QMBZlrzPHS3kPaCDJWhzpjumipFt7l0YUahBxWQlH0cOcReFRW?=
 =?us-ascii?Q?iBikgYrQ/cAtnQ+2Wz5b+ckkXCJQHNaTVN49V+ZlgGpegQpgh+ASQLMCz6Hc?=
 =?us-ascii?Q?78Wfi8Jkx6CZi4qzp5n/I3Fo7xAp/lW+PVkVqhN9SDgdibQtgDkSyr90UiiG?=
 =?us-ascii?Q?PBmczulz8NZCWR0HuqLx5cNlHjRKkumLGZtSWEIG33uh0Jzsaam+k8xfPL8a?=
 =?us-ascii?Q?qlGfoM5lIwzJAAFBLxhnhyJjWbeKxcW14uZRMbUcVXH9nWkXn3Ja8YI6Z7Ux?=
 =?us-ascii?Q?dFAFu2m00r41tdttm9PAs58Eh2u4OSWQ54XR4sYMS48Z22mrzrpuSZhyKqxI?=
 =?us-ascii?Q?ul3KtfBlkR+rEEPKBo7gAQpUr+b87vZl/BWkKmVvFFBAubAURvTtPb2TfUBa?=
 =?us-ascii?Q?FtD4bkvPrMLVjvPO2vNHpNCBIb5i7tP4lobN/NOBd1DOALNBHu4aeVyigi4J?=
 =?us-ascii?Q?EigLKNw2/ACmRKKcJl3moloxMilsbNV1knGgQ2eRSs+32gAgEQgsPP2kIONs?=
 =?us-ascii?Q?pZv7IOwPyw5pR1ZnBCUWJ7QLRgFQ87MXFOjolDmATCxRbQy+57YCvvG6N/MG?=
 =?us-ascii?Q?2O+xpD8wAgZmBh8581KnCRGiS6Opm0oOxPyq966Xyi9rpNHm/DLa9jMdgNeX?=
 =?us-ascii?Q?8qAFPBfvJRkPZxX9YICpxP6zWpktIFTrB7EmFMYOO3y2dwJBjnht7MFPerss?=
 =?us-ascii?Q?LI6FuCg6b500DbiszPjGS25GAxH6MLUy+4VGc+xXicVD/zSU83MxmXs02RUi?=
 =?us-ascii?Q?aNDT9d6Apmoo6jtnShoI1QLt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2194fc8-eb5c-4981-48bb-08d92bbba49c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 02:58:37.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OLNEhTe94GELvKx4qByCuD09bikL8NjZK3KGQIgo3FIFpfe5lBtKU+3UokqffLrgDMc2ifo1eTeNfqxwby1yFZI+jGWtwpcikJmm7oxyXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=942 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100017
X-Proofpoint-ORIG-GUID: oahCBjtTr8o1Uk-XTLB5f3nedqFl1nVx
X-Proofpoint-GUID: oahCBjtTr8o1Uk-XTLB5f3nedqFl1nVx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Fix a double free, scsi_tgt_priv_data will be freed in
> mpi3mr_target_destroy so remove the kfree from mpi3mr_target_alloc.
> I've also removed few unneeded initialisations.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
