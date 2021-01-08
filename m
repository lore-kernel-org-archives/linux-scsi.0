Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F365C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4544523601
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAHDlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:41:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbhAHDlJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:41:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083TCnm148918;
        Fri, 8 Jan 2021 03:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6UI4nMCCdEe3y+n3+uO1mYNbf+HgN7Je+0c3S98uGl0=;
 b=gbmeZbpRwmlpkFdul9b5i9s/LDrCb3FpWZX3sWPXFfdSSoUebqs2v/fvcwzUliLurqrY
 0LIBisux0ksFRIS7HrHbm0hlglj12aUoaThr+dhm1tXUo/+PiKRRRjY8+z8gT0+7MaJQ
 nSihc50NAAPlNzIAhZ58CN26ky9a32gNJ1nWlNtZzskEhKrsst7HTD5TfNDrilqID2M1
 RdhZ0ZaE/tFjjeKVO3omaQqMYX9xgxyZ2SILfpUS/gecMknSyxwEI/ykjX6kLYOS/Czw
 CxmXywyix0Vl130OnRIDWTtMv3gqCGtK7IqDU2E2QGF+zgj+LyrktErfzP0HEBm7ps0N 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35wcuxyq6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:40:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083UUmA146165;
        Fri, 8 Jan 2021 03:40:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3020.oracle.com with ESMTP id 35w3qur8dq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXYpIjHKe/HFflrfHzqY6RtQMi0qb8+sgPOsUrCOqnqEeAzb5YrNDewJVci5a3ymcr0XU63XtDGQx5kvdCMDnObAYG5x58Ax/Cu6Wq2avA6pXNWrtwUaDJcoKPQP5SrWlq4Hve3OPyLfU0eHWxGSgCX38+6krWaqgPId/yp3Xm3OtCDK1pHMA7LyX1nRIHM+dcI4U7pDw2LEDqGbbfvtLfQlg7gDUXlOb4XEka4Kkd2G4H0oEYVsoc0kk5MhEmcQEn/iNIQT0O7h9V3zEFZbJQaw8GrzcEwR6wfmcnX+X8UURNhh91KHIDSvSz+OAhct3iCXAgX5lV3BFb6fJlzekA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UI4nMCCdEe3y+n3+uO1mYNbf+HgN7Je+0c3S98uGl0=;
 b=VOtAYf5Zx2WDB6K6+f7uad3lrxCWcEN+OJPexaeyEKx3ObNGsVp0oM0zjmAsyLqmnSOzQNxebSXAR6qATGtfsOf1nKj3T7G3/1xaPchK2WXH3OlHrCbZgBmE1ITZLc1aiLwD04eh6uy3ctFtz/ElyiV0huMqBpBiAro217RKolTE3f264APTk4ZXWt9Vdjh/0eCE5SnnM/hW6269O84PVU247+ASSiGqq5IPOEFJvka7/RLIEOAX1VOE7nXI+hr8gnlCzP4A7bOqm/vXTOPaofn73QCsTViV/zoC8M4wJsSn6SG5z9nubF1Z/aQoe+KRycv85DTAEpGomyWU88U1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UI4nMCCdEe3y+n3+uO1mYNbf+HgN7Je+0c3S98uGl0=;
 b=ELGBAMgC/fe0hdmWV38dVU83US6B5FNdJ8gE5GzxpkQtD3YZl5ZUGyV/NY2TPFu4KhlR06mTAroIOh+OH5GA2DIeDUZEuTQ+vfJSdEoJyxnuDCtMrX5LC1CcLF1dEBe6rEO37Bwyc3rsKfeiL7hEAcNpZyDxxtAQ5sx3nwrqsqw=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 03:40:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:40:14 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: ufs: fix all Kconfig help text indentation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6tkcd0q.fsf@ca-mkp.ca.oracle.com>
References: <20210106205554.18082-1-rdunlap@infradead.org>
Date:   Thu, 07 Jan 2021 22:40:11 -0500
In-Reply-To: <20210106205554.18082-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Wed, 6 Jan 2021 12:55:54 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0115.namprd11.prod.outlook.com
 (2603:10b6:806:d1::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0115.namprd11.prod.outlook.com (2603:10b6:806:d1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:40:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5afdbd7a-0cc9-434f-efa5-08d8b3871bf4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4437432B26D5E9DA37A824A88EAE0@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eRbcEs+xC+OK/DW0FJM8OIlS6p/60uoRV+cpsuVy1nKoYnO1DDPBldySbKEBHwddPgNrnj1F/HnDS7LcTgXJRUbAdJ0k2RZqD3efcb9TKElopuLKu0gbCufGjsFf5CmI0RQZXBZu5sx4PedIO1Pr9SHINuHR7jEdypWBzfNMjmB/4B7stuUp3j/V1E87FRCLkr/L53UjTIoxTMmrK1b6BQrGBld3uvvxDbEdsQSHvkdEkjJcAYDieaLgAC3tU1YqWNnVp0PTdD56uBs7Dnv82euRjCZ2V7h/HtddAYESXnymX6B/CXT8hN6/UmPe+wUSJww8GVzNQVWmRNOXGCEA/hZ2BqObaarwXKBpAS5GwmkoJCVn5QT53FT35vrUxZIe1q4eyZ+s+MDG1t7DxJJSjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39850400004)(396003)(346002)(4326008)(5660300002)(107886003)(8936002)(66556008)(8676002)(558084003)(66476007)(6916009)(66946007)(36916002)(54906003)(86362001)(16526019)(478600001)(186003)(316002)(2906002)(956004)(52116002)(7696005)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XPweZMjHfagE+R2s6fuE34XLbE3+K+aIc8eIW/dmk1ZYBvdncO87cW1UtjDk?=
 =?us-ascii?Q?F8zmashHGiKIayppIjiFKFODrG0bPqy0LKeeEnjM3vB1p5Zu8ASjDEiFwZpS?=
 =?us-ascii?Q?r5ettA1VLWKVVHOs+lb2EZLjICWLl3LPYqX3B47IqhUJFh37frr94dxP517S?=
 =?us-ascii?Q?Pos5KC7zLI0/gG7ra0x5LZVQIyOFqu5y6S5XJW5N4JL84nRDWiwSZH39+cLq?=
 =?us-ascii?Q?mtFlKu5vsEoGMgR10epjiAKK7xv6wfjWlnTnR/9mxpP48ksl2gVdV/FGJLE7?=
 =?us-ascii?Q?txg0IhzxGpLI2NqaMt5rc6WaE0gCLC2CCO1GiJicbY0i4q1SE4mCvIajJN+h?=
 =?us-ascii?Q?KlzR4t76Lpd6SYE7+TPpc0fBmo3CsAWI+1rC7RqdM5sfvcCQ+QR2FVtmkEWn?=
 =?us-ascii?Q?oZIJwdB84EM6IDTaz5XffLI6XL+AS5t0k3YcSlvgJigqEfgxySUY2xTuRhu6?=
 =?us-ascii?Q?05R4Qjr3THnRRoLmVEnVo5DMs4yR/gEnaG8diOwR4IJZlViwG/SYx/4AZyaJ?=
 =?us-ascii?Q?pIxVm1CPBOrmN1PTCjBP4n/4ctRo0RqmUbxb6MyTJ6eK6plrf0fNiTMHOmuD?=
 =?us-ascii?Q?YvSX67ujXKRuMFLLgO0vmaDujBWQlYQfyNFDmK2hlPbR75XTslB3zFIe97KN?=
 =?us-ascii?Q?hj+UWjuV5M4FHqbpl4hd6dURjafNwEjEGknVOt6+T0fgujZP7om1DwSRFpfc?=
 =?us-ascii?Q?OG1qyh7Ly91VPTY5KAdK4Q+r10QDDtneCTN9L5QcwHt4JIUzipH6H0F5vVUo?=
 =?us-ascii?Q?GafmRDVTnRhCwkwHhxCphmbe8+dysTQZ9wVvgOSLCEy/k8tUOX7j/PB1KsFk?=
 =?us-ascii?Q?35q6HTmPsclv7YE3p6FTbxOVFuDAVXIhgsBMy6HWHg73ZvK7BxS6r80oaIUc?=
 =?us-ascii?Q?y0SWfTyyBywkzeHYRLpjj3c8rBl3/F1snhSpEdmuJgQj0e/3M9GRcAYgGUBE?=
 =?us-ascii?Q?SshwdKpEGwRdp8pRU6zk8h7SZuy8Z420fWhF8g+lWEI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:40:14.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afdbd7a-0cc9-434f-efa5-08d8b3871bf4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2wpxWu1tzHts+zawsk7JkgrAO94qCcTliQyf0IO/PL0yc6fXOb2+HFEm86i0KMOcmkIn+8OJiiQdx42QEBKy0Crr4WglQb+oIKfbswCe8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=963 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Use consistent and expected indentation for all Kconfig text.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
