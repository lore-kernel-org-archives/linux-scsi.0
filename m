Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107FBC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D809B6100B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 02:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhFOCbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:31:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFOCbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 22:31:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2EgXs015195;
        Tue, 15 Jun 2021 02:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lBIvaqU0ifA0JSc2mqXm3jQjhKOaz1dCqeJVBkYkhv8=;
 b=swtKs0cgmQtviGGnfU3XICCt5A4ZfepIlNpizmyB6jpoEAAuQMqFUDxBNsWQFd70Imyp
 Ffc+xcdKtRUhVzgt7LHnfgCLUyPVkuqhXI4kJCrL4zcJFPbaLIK1c+2hRn7a5L/zfFlj
 kMV3CeJIg5pV78VKYeXgPDVDQGC1ur/ooxE0pKyVp6e41EhC7fAeJ1aajUTI3IBc41ZT
 9uiFGviEdJpO5hP6GSg5KjiIFiAqWJLdlHfamohK0hIQNxXKz/0YvGZCa1cM1apWaxst
 It67AWHAX9PA/VA1Pf9zTrHDuOfjvLpXQEqqqKZh1BegNx9AM59UyIQIrgVv1dh89q4x aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 394njnvwe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:28:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15F2FOUW196284;
        Tue, 15 Jun 2021 02:28:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 395hk31y38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 02:28:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhLrZ5VZQV6oH9lbrUniuMV2otAwebLiDAbfu44Xy3xelugd9I03n3gWliu8uHHE9AFB3fn/eAXFrXGgOf/MrQq9LtzjlDEoMEtd2c/G++F9L8LxkT9PjI/4FKh13tyS6OtQYe4MbbmfMEaIWfwMAtvurosoE+/SaZD1zqBQbecqEE+lS31aQMIfJlJ9ehJvRxEdn6V1ZjysYGxDxXTuYmpRQTgb22IGIsxZb8GH3i3vFZNZF+JJuznmoBGAN/KwQqF9IEiGw4SW3AA5UsMrabT1XMOIRY+w7CFR/QtNfLFYZNy1T1EeLOsWQaoF/9iNGbVIuWBfXzix9PIbWE5oaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBIvaqU0ifA0JSc2mqXm3jQjhKOaz1dCqeJVBkYkhv8=;
 b=Z6zSqOpw5r+HGPKzIzMEUSzCSPyOUYUrr2kt8Tm8lRr+LRvP8EK+9iwx8gPLbcE3YHo6QbuLtg5qiaaj/JOFOANEq7LfgPBXv0n4wGJZ8Cp+2zuNxgi2o2V8FfSPc68oyznyfKiVL3w2HhpIbFvaXjDyy3cS59YpEPIAUdYpXVyaoYmbKO0Jo7nvHeceZVkNdJxPifW4gLC3Pvdzy3MuAS8+nOULK1rSWLv874IOEiabtoK0Dt5mKIaU+k/x/4j+AK82vnGtPrzFuQ4ZHfeprCEhJAaVyubRM7B1IUN6T/XuwlWLyImwjpCss/N3GQp7KQqHa1qbDLFIhL4vbgc2ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBIvaqU0ifA0JSc2mqXm3jQjhKOaz1dCqeJVBkYkhv8=;
 b=hUllcs0r2/kpOQeRlSAGephKsfpmAx5dfjk8KdlEa72wz4+G3khvScLe4dXUe9sCvdRP8gtRQYk+0ct4KjiCkauqdV9XbjFsK/mesAoOPLjLAg36Eis1jtSpIh9Ekav8ZE8ZvRooyRKo/jD1rt+Icqh/mZ17bInrk0cdkovdIhc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 02:28:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 02:28:54 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 10/15] scsi: core: Introduce scsi_get_sector()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s3bamko.fsf@ca-mkp.ca.oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
        <20210609033929.3815-11-martin.petersen@oracle.com>
        <YMdsTOpT3a4TA3E5@t480-pf1aa2c2.linux.ibm.com>
Date:   Mon, 14 Jun 2021 22:28:52 -0400
In-Reply-To: <YMdsTOpT3a4TA3E5@t480-pf1aa2c2.linux.ibm.com> (Benjamin Block's
        message of "Mon, 14 Jun 2021 16:48:44 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0078.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0078.namprd13.prod.outlook.com (2603:10b6:a03:2c4::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Tue, 15 Jun 2021 02:28:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 252826ad-e985-4d71-6391-08d92fa551e9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450133F0DD0A2D075A1345698E309@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3D0k/5ik5go7SOtW3Tt+dUnVBSDxfz/RlN2qhCHoDTW0KjqBy/bSVEVlxMmCQm1E10+yb7+yhjTuSTDjFcIcUzSbnwUhd4LdmZAf1aXRQzkN9UywbdUIKDQpZwicw5q8H6WDo5vCh98tsSdUXVZVGcpTaZudTQrvcHrfbdxa0ULgTjsWzwCzjJ6fMnpPOfg+xJbm4KcQByGeDVqdTb0l8CoKwpcv+ilREFbF5DhzHoVfP4iCZBkAib/17XDihgDSg7qVr5u77yv0Tm1+XWVo50uORcO6uAkp6p1PU2K8BBKAvqJdQBd71yZDAh3iTxT2palLtcrvRFml00nTmPSmV4ly2t6ZhbM1+nYx2WeD8C4TAZkfJcGwMi6RPEfAGTGfSbhrJiODnY1dHBlb3sldAnVDZ83v/8t1g9S50xWLrEZ6WVgZQl8j8BWxfJgt1dLRje8jy03zh5iENNK0u0euJI85XAGa3KYxoxtBMDEyR6ALz8wSLZ13lG6waSao4BFsSU0ergITb91tX7Gjmci9Qt0haSxFTA4I/9lCXxkv99Lj0kIfocExbo9RPsBqBoLAliMSzCzRyIi3JvP/eKAeB3an2TrIqQY2XGe87ghfZRCiNNVUqoGPZAFLum7NFULjuKwz5UXVgjCeTZ/ThI/o8dU1tLCjK1dAKn1SV78XaOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(66946007)(4326008)(36916002)(38350700002)(16526019)(26005)(66476007)(6916009)(66556008)(186003)(52116002)(7696005)(83380400001)(316002)(2906002)(86362001)(55016002)(38100700002)(8676002)(478600001)(5660300002)(4744005)(956004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FL3IMJf5l5upgXrrSWbWXgB4L3LbIembaoSUeCcGmQEvWfli0ygBMHPXVgO1?=
 =?us-ascii?Q?8eBu+nQBKu869sl3nkXRpx8lC+35+wpVlrfIl/R15X6nCDHd4IoeXOMxvmM3?=
 =?us-ascii?Q?3RdZO/adS8cUJkUp89hHhJsJR4FHpox1EJJUINim44ks3rMAUjSR8fcz5Zr1?=
 =?us-ascii?Q?+rs7IXxwfN2M4fZ9+RaEx8OyiguNsr2ByfrWeWIqs7d1D6tHPOQTon/oz6Iy?=
 =?us-ascii?Q?/bN7saJ+TwmqA0cl4g84v1PRZl27nUKtdQM4SPkrFbs5Zsc761VLkLU6Kfg/?=
 =?us-ascii?Q?Ajma1mkeU5nuhD4ykN2B87s2Ey4k8dX1cRqlE2j81R9JZUedTO6UwOlbt+ZN?=
 =?us-ascii?Q?+qezp2KE7/TipO6IuMhaLvl9gaCiabZEHjXlQViJHrgrrJ0qSt+XjUMgzB5n?=
 =?us-ascii?Q?8UCNu9yxZaJtJ2WXDQ2wJ/FaUYrFKXEFroi6aKzBNET/o0AYuzAE8egWVPpG?=
 =?us-ascii?Q?28xCE8dlSyZlUcPiCtoWQ9AbWTixIziTdU5EoHndt3VTf8Y5+Z+YLcZ02UOi?=
 =?us-ascii?Q?+QllpuLy7wzQfCpxO58hBJm0/uadz1k3Sam/gWXUU7UAgeQa8IBNgawYgcFv?=
 =?us-ascii?Q?AjKB3OyCOBnsOG0VnweySIp3Pi5OSSLrehKIDRcvr2pPC9VHdCyuBIoSRhD7?=
 =?us-ascii?Q?Ejc0rD5c4ZkAcnGyMO6gNg+q6Zolyg2lU0fS/E2+OFginKUsRUcfs18/ZthJ?=
 =?us-ascii?Q?9gtgOIvPkRveSY9C5r/4vG9+TwqixwHDnUdbUdmE2OnvG+RxIygmwSkIlhph?=
 =?us-ascii?Q?6HY9y1MSqQ+dY1at7vQ9SsEqrsFA8oAomo9ZT7sSfbmc42pDTVYeOvd5Cxdz?=
 =?us-ascii?Q?Gl2Kl5KnV/W7mudPPTNd/eX8wHeqy3RsARd1J2jv4/ITZsrOUKuslgQwwtKa?=
 =?us-ascii?Q?7+uHbKEcqK0dbTGc2YMSqjX5CRjMSSJxcYXLDDXHRXrNfEUWrpBZVacwRosK?=
 =?us-ascii?Q?c7vuAfn2ZUoTzUiR928kyBRwZ0hWAIwDRHl6j0fl2LyLvcpuPZXqIKHFP3FI?=
 =?us-ascii?Q?YotifTFATn2D6HkpYMreap8BOH3Ltqmmzx3MW4it+w7yAlo1s4kTn2c3x5Pt?=
 =?us-ascii?Q?EtJlWkgbl2C1oOqdoYBa4Dk50LSSdzcURpPHaI8iD8lVQfdFMA+yu5NLZVZy?=
 =?us-ascii?Q?0MRyXqQu6lrBc1+Dgq/9unP2ojnaGD2KemNK5rrTXfaWWgzgHayqMtla26VJ?=
 =?us-ascii?Q?Id0CwdmZXqWIfu8KHlA+knpuS8MvrvjWqK6zTqFRdnh5C3tr6WELBBgbS++7?=
 =?us-ascii?Q?/8xevAse0rqcWNq23U963BP/Rv+K/j7gbwNDkuvvfPrIfSEBkX+h6Ioef0nf?=
 =?us-ascii?Q?rm0WWXTT5OS7kfEnQQg2eW/M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252826ad-e985-4d71-6391-08d92fa551e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 02:28:54.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NWA3VZ3ysZD2ZZVNUfvqG/6LrDSSNsliRki5Xe+AFVO7Sp+lckQv51t9RA3qSAB8YLZYVAAKvOWjbcq28xwGV5NClF9Xg1gxc9FD8OdYGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150013
X-Proofpoint-GUID: g9PIR7MUyezNdgSRH9Gc_VrD97Y56NFA
X-Proofpoint-ORIG-GUID: g9PIR7MUyezNdgSRH9Gc_VrD97Y56NFA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> Wondering a bit why this still uses the request pointer, after you say
> in patch 01 that it goes away. So it should probably use
> `blk_mq_rq_from_pdu()`?

I was just getting everything ready for Bart's series that makes this
change throughout the tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
