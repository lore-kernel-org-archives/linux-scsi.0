Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D10DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 02:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80437610C7
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 02:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhIJCbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 22:31:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34302 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhIJCbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 22:31:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189Lrfsp029669;
        Fri, 10 Sep 2021 02:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ERjOMCivSLmHwelRSGtJc0/Ob72NUNdjqD7LlRtf7Sk=;
 b=IUdVfNIzHWTsq+PdndRADmW3DYnCoJtSuJy+df2cFWTJEy3EEo3TJGdDaEVzB+RXsBss
 zJ89VUTgA57KULVTeOCBDUuPJ47yjz7PAujJzZ7lC6w3zNAL8pMbIvejstzz/1fqjbZb
 5G0OH99I0EkmLX1Dtgq7Q1KCAEKf9IhRID5hFDxJ5MEUX/5a+aaO43P16idZisa+Mybr
 EfD7xIm474sCqctVnyVCsCgIfQnB08RXZpypCASwBpERQU5vn9p4qbjtsirja4lIvcj0
 qZuKj0CfNueCKzVhYh3MABEcIbeZe5KHuCFuE384HgWvZwlxpilUrkrW5W932hknnhOq 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ERjOMCivSLmHwelRSGtJc0/Ob72NUNdjqD7LlRtf7Sk=;
 b=u/2AulIG+z7HftqZ0tiblA+KedGCq8JiFasAY3RvM+1zMvsvaDxc5iue5s9gYzndJQql
 0JggwWiWYQ5iud+shBbaP6Pp50+yT8iuQzndXsuTIjfpjambmINo3aFf5YW8Cn87DZgE
 kYO0yomBlZhNKp8fxdesTRkjkAvOYesxLj5WbTYVY1m6LO8y2ztqUXcbB0KzBjOs1v/v
 mdf8GzjdPhFWoHlmlxeXFQDoxpPJ4RE473zjLUFswDB/OZhrb8qZGNfKhLJ/UDnkSHLA
 iUtICCoWkqnuoWCNHH3Sabi/BbmCfmm2l0i58Gt9sZ5FtUoiEWrrgyJ2BQhXdvAamWBA fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytk8rfnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 02:30:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18A2U9Z3153764;
        Fri, 10 Sep 2021 02:30:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by aserp3020.oracle.com with ESMTP id 3aytfxrxwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 02:30:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/bJMaE0r9xMIWEWdecWK3/JxIDTszZzLf1nNNF8oFzcHTVnJxijw2mJIk0TKxfEp6dzsd9bxuY0sZHEVUqQxnAW52g9WnPNeRJMcvUMgyt2o9GT1MBtfcgPjHc1/H/8TcyknyHg1dApdozyxVrp0pqBCR4OrgTXjA2OpcBvrCVJdtaszLwObbRhKhUMzM1aVjQNKGAK0tefXP+fkD2Jp+UKBGXuZtxJzO7x5E0mGi9+5LYS8ox8WyeiHobcvpErGGTOEsf+TUU3rhJTa9nXI9nTH7Q6+KR5/LRSo8K4TwZZQ75j+9n4RJblssy5kYNf+qxqt4kevF9DJb8fbvgF6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ERjOMCivSLmHwelRSGtJc0/Ob72NUNdjqD7LlRtf7Sk=;
 b=jgsCmXLYpyjZsu9vBLB/9GyhPpLQSt1h2AtIj+xQ++dlaTHEBC8H1R4YSTTfnc5S1vDiAMFN11mRje6NsDChfxgnLWU4aUTCl7uXab9xxYXXV/izEKuAJzdk+zPPhA0InuNN5uVhCSXXh1fYbAWXrpUImPwcq5BdFXIJkNKsomCd95APBOWYfcl7Jobcz++fSmHBdVHYL3J90C7z/wp+kXkTjs/vOSCzgt+hCEx/0v/80X+KJMkwkv/W+LoRd6v6ofNbKefPQpdkPnD2HcJYmFMWvGflVmh/pFGrmaW+EznYVYraRBfnQnrnphEE4TwWs7Op9Oxn34H7sPcgoTUNEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERjOMCivSLmHwelRSGtJc0/Ob72NUNdjqD7LlRtf7Sk=;
 b=SJBbVyUPmZc9B1TIYAmJ2J+B1w7GdXIG2vfWYZTN2N9kIWLrf5mR67kDVpPnExFQBBS8JB5goIZq/RLmVXbA+MDZW1+V7wDEGHhx2fuK5pDXk9F/1PAUa5NM1VuxQ0HoiFiwOIw2K3LXZu7Z4tTc4NRBpeKoXA//3IsjibLfvqg=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4741.namprd10.prod.outlook.com (2603:10b6:510:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 02:30:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 02:30:31 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czph2nr3.fsf@ca-mkp.ca.oracle.com>
References: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
        <d086adfb-9cfe-6f3c-aae1-b9106436037d@kernel.dk>
        <yq1ilz92osg.fsf@ca-mkp.ca.oracle.com>
        <23620431-4066-957a-2823-2fc1526b3432@kernel.dk>
Date:   Thu, 09 Sep 2021 22:30:29 -0400
In-Reply-To: <23620431-4066-957a-2823-2fc1526b3432@kernel.dk> (Jens Axboe's
        message of "Thu, 9 Sep 2021 19:58:50 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0034.namprd04.prod.outlook.com
 (2603:10b6:803:2a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SN4PR0401CA0034.namprd04.prod.outlook.com (2603:10b6:803:2a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 02:30:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ab6097e-fb05-439c-d47a-08d97402f614
X-MS-TrafficTypeDiagnostic: PH0PR10MB4741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4741A6AA1C2BEE2025740F708ED69@PH0PR10MB4741.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZ0YjUnnfXij4R0DZnyGFsq2D/Ta6hO5b31//Dv/2NbClAwREPnjpk87g5buKM5cQmVPWtnRDVCgShDZ4MRbVlVdVDlwjgLr+iK+gXu6SYIz1yiBtgy6oSvmnGD7xvLLBSOOmMJP7QoVBEyA+IuXlRv/iPQQTOl5DhEjiO5Z9zjYjxmcGYOGuJ33GSOOiunCIt3LLfeRn50KVdG+p8Wuf9ZcwFCircqkbYjgHWeOP0PEhqtO9p4HrjxJ9jx+gKwBG/LVBLxYw4h6P8qcsE+1pDV6A5g14Ybnoj001lBixLslZXNbrIkZtoF5z2UjrujyWFdUbwOZulbswse4biIeC2P93lYbG62euUg7bMMxYtGMis7ZZTIL/s2+w0UvdKescsuefqBvoeBCDydQDS5I5N61e7V91hF88SGAyZHS6oR1wHAyRK74YEMxXzWiKsjNoYdEuuIQ4c0hPl7+LpABNRViUWL3kAQuJi2bEQtvL9eeaaqaBO9Np73Gh4XVqAcW6t5SAM2Wb4XYqjmxs2GKYFn9mZHJhHmjWXolIi4jcyRwgA7K4aGhjhu/yGZtwk7Iy+jQ7vWRNoHPm0eeOOIgbNSP0FwBZtMJPgmUOoB732426N55/XzQnCmZuAMtb+mdAH1Gf4kazDvcdtN1WaZc+HAx2PdVXBfS1T3UhRJ63bQ6YsXg/thM+6IgLx2O2TfBlzvkZyN0RI8zToJExhSOGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(376002)(136003)(396003)(55016002)(66946007)(4326008)(6916009)(8936002)(8676002)(5660300002)(186003)(7696005)(38100700002)(38350700002)(2906002)(4744005)(26005)(478600001)(52116002)(36916002)(54906003)(66476007)(316002)(66556008)(83380400001)(86362001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LH7GqtOSfMvkErTG4YdfjZSzBQg5eQQmcVA0DWtfNj9H7alWPm3LW9Fid8Si?=
 =?us-ascii?Q?dyNu2vZlXiftH9WGwz/ek0T75IcFXEllAu1+ms6EC6JwIc9fLF4UCzwB/H6c?=
 =?us-ascii?Q?i2jO7M15UUcbGUn24xvlK5ednpuUbgRbtygCCiodlJST1D0YzhAk759ZGpvi?=
 =?us-ascii?Q?iieL1i08XisL14tYYdp5Dt7c+hsQr8fMjbdNhp/WknGHb/poM1KkGYnlMaot?=
 =?us-ascii?Q?YK+7LL4Ud4blQMeBlYeWSyh+m+uWYZhT+LFSM5NLbA5yNDrjtZfpWphYN/Zi?=
 =?us-ascii?Q?3B4UNKsFV8ogY57h/i9zYVIESMowlHxELaM1AyGHfcyXusvLcb9CYpj/Qd00?=
 =?us-ascii?Q?ZcB4UlQmArUvQW+c8U+B0fFp6LwzWMOb5YbLtoNy3P8w+NqPPOix2Z9hmwKi?=
 =?us-ascii?Q?rqNmMDXfJGxB55SMO9nVSpE0aaJyvX0UmmEBpDPfO/1r0k4TdbizmJ4Q2arQ?=
 =?us-ascii?Q?JfXRPAWD8E74K3PKroVFR5BxrTd+WU9CFxQDwov0ztKg5haNn/FKM4plpuRL?=
 =?us-ascii?Q?okWfy8AIyR3hZMnYxXdz38mpJksy5diaQiIsAeCDFSWntvkQXeHHm5vRWxVn?=
 =?us-ascii?Q?klOv/emQKyc0sYVMQucR3mV2wVD7otR8S96Ii3XQURSVNef460w1cD5pozlH?=
 =?us-ascii?Q?WllknATpmM32KCRqO9Bw5O8NnHa9R4P33yCQ3AOMK1UrJGPMsaHSEaci6dLp?=
 =?us-ascii?Q?frQRMAPA3iifDzgipnT0Xxuji5rFL5vtyfK1Z60u2JUFH8TVfW6CZNaNPlxq?=
 =?us-ascii?Q?eD19XhbkcYECCju36w5ooOksQ2/IHHS+EZ2QpYh+HQOoHOdUNyoSF7KlUirV?=
 =?us-ascii?Q?oAoRSIMO3Hj/HY/FjHD1KHNsHQt7yRg1lg3s3OCVnJWLtifHC0ULXYOthP9f?=
 =?us-ascii?Q?Ey2ts/95ewlhkq/ApOcxBqP2w2k5IzGfb07qsICT0JxFT1Gc0o1lyS/HY94W?=
 =?us-ascii?Q?rGXKCEyPv3NZSnvdR78sVuhnZgMKq+HkOuSqNnd/wIUWR4IZrdomwpLn9wgc?=
 =?us-ascii?Q?Vp8MN229texdFXDumAxRximxtG9/vP5FGTEUJkGsiwymWgZqVYyeMQy6gssm?=
 =?us-ascii?Q?4AWimx3gH2rhoKh1yRYAjzYPsMMHmu6g79+l5AQQRKqQ1B+Gz5J+t6w1fO/U?=
 =?us-ascii?Q?/mbmfK5/PREyCOztz+PyvKqoJlzM7BtrCNBK1yX3jCpVfoFSKiSTFla2LUSn?=
 =?us-ascii?Q?CUjUDQKJ7V3KZnTjNSbbNMhCryKtCSBuVPd4xeXza+KGe3E+w8x2mKLmeVcp?=
 =?us-ascii?Q?wkkbKyX6EfCtRdO6bfrMy5XQzKOq8o1cBeCI3IS3SQPro/jmf+vsKbsbg1oJ?=
 =?us-ascii?Q?apvpWelVc2iSvk8W02zwtP/w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab6097e-fb05-439c-d47a-08d97402f614
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 02:30:31.8217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAGRZ1eT5nkHrfx1uARl1ZBGy1gRvUxW+BU6vqLBO6Z+1FIgoNPOn9nBDglOtbpS8PGWedIri0xIjNqAzCKmHSUEc4HbivBiRoVCdD4mlqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4741
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100013
X-Proofpoint-GUID: nxYbF7NUwKMsrhMT1bNrHmzQdnrd07lK
X-Proofpoint-ORIG-GUID: nxYbF7NUwKMsrhMT1bNrHmzQdnrd07lK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> Ah ok, just wanted to make sure it wasn't missed, since I hadn't heard
> anything.

A perfect storm of commit description typos and missed Reviewed-by: tags
has kept stuff in the staging branch longer than I've wanted this
week. I held back the notifications due to the unexpected churn.

-- 
Martin K. Petersen	Oracle Linux Engineering
