Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE329C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C2D23B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAWD1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:27:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54982 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbhAWD0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:26:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N39i5h035932;
        Sat, 23 Jan 2021 03:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YkkTmpO8M9YmEaZzBf0cULgasEChr8GIEum9EX1qYPA=;
 b=iq+Z34VgY6twc2sGo4hRUZEHplEM9CU0aBETqeiJMvgt57bqdcbd8YIcyLtWAiEou5cr
 +jfRomkv0k2idnam690ebi0GdC1cfYfBDY5Ek8rCX+22Ku2GuWnacQdHXPYMUkauCID1
 5w5fjEOEATKv4Ju4qht28yeujmnz5Dd2SSdRaW1SOPkbK41i1mSLCty5GGoTEk4j8xeU
 8WTb4SgoEmITfu3rULldIPDIk8VYOtHiP+mzhPn6ZMlo+XHYnRTBmIsB+0Z3RiwStqGc
 Q7nvGxusdMI2hOzmUnCKaU5BtRTXRHwBLjvjgjFde7N20UdE+8V+59jwCFvGna1aGeFr 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qg2qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:25:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3B1Et043567;
        Sat, 23 Jan 2021 03:25:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 368b4grx8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:25:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2F5j19EcIM73mMiQ5TcqE13vR9RnuPpebL8CYXes2KHyXI1lqxOEDdzFytd3Lbp8xd0QBfqcSfaiuJ7Uz80+NCbaIQo+ZshdXL9vZi5WtJJaeNfrUflz5wGMWylBPgfbIMnmTgVndzzV5n5NPks4I1LOCLMnWB3WEcXcCP7plysBXvx635SfmWzpRU6FCWlkhjlll81xitk5qvU1vr7RjMD0MChCiVTS5OoGCdjTo2PzoMXjxc1DK5qV3Lvouwa5g68AYQH9GgldeMZ43SU5Nx0HZN8mNUcWkeDztbOpFTnKU5h+BPk6SjQvZ6Pn9nyMWA94hHe7w5M9tlrcl3K5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkkTmpO8M9YmEaZzBf0cULgasEChr8GIEum9EX1qYPA=;
 b=Ze2Rx3nUMw/5Tmrc5oVK36ibshKoOF7DQUVqBlfH+Q66VPOb7zSoOhmTGGpvQ1BB9tYDeb0Qxq93Ej237Bcbn0QITwRhV7RxShzms96FEOM6NOuFzikD5MyXmpYbbBlvfJDRLPDYgVtcPNtEgZm81R92T16hU82xPE62gOM3FipEB6+F0s+EO1eTh+er951TEsET0hH8trykzO95b0FvoGCDVPopRzmNqNArwT1PMTpQ7BBMky/G8qqe5UFtADhBWq/9iLUpDO+9Y+W+6VR5H/CBvnJx4/2UUXW5+UElIj3qFXGi0VRzD9asIKfb61W0Y8L6f5QuLFp4WU1FA/AuiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkkTmpO8M9YmEaZzBf0cULgasEChr8GIEum9EX1qYPA=;
 b=Qmx3uI9cgmVIpzkbHWUVmFPuaM6gbGJNg/ytFV0VII/2G721ymj1WuQc8kyqUmvfYvz1LP0bUtwDajfq9Mue2hbhK0BTGw1nUm8vZNhd4vrAKdLN672MBWG4ZPmVgHOhTCsevOIF0xJ9DJL4kVpM/bPVBPArq7z0Mqy0i1hhEec=
Authentication-Results: inria.fr; dkim=none (message not signed)
 header.d=none;inria.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 03:25:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:25:48 +0000
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH] scsi: megaraid: fix ifnullfree.cocci warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bldg9vww.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012111113060.2669@hadrien>
Date:   Fri, 22 Jan 2021 22:25:44 -0500
In-Reply-To: <alpine.DEB.2.22.394.2012111113060.2669@hadrien> (Julia Lawall's
        message of "Fri, 11 Dec 2020 11:16:15 +0100 (CET)")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:610:54::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR11CA0006.namprd11.prod.outlook.com (2603:10b6:610:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Sat, 23 Jan 2021 03:25:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfe87636-75e7-4071-7f4f-08d8bf4e93e7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469625C4440A8F41B8F1C4178EBF9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZHiInDx4GwXpKC6LAi1fgIgxs63xihuSgsuafcShDYofxnKhWoz35fyMcZ54b/yr2QuX9eGbFWddU2vJti/V+DdEdJNUHaiJLgtJB+Y+9ihwu5Nrpr77RlWLPHeVAY+lyG7EUmDWtPkrx/IO+OUe4PLobrWIAjYS+SfA6Rc6czyi+4IkaxeareBVAYuk8VWOY5xz7rKsTgiFuNqOHpsLEOIT/tWUTbluPAa/R9UVPntoClrT9olK3wnb66kj+iako46C4dGOm/UeHcYX5XpbmBRM6e5O9EgIJ9xPjZ/4J+0Desn6TI1c//e7QfxNZ6ghGKYDQLtsXCUPFzei7rVLafOtjOP9z1Y44jex5VKVF1q0AwmXXzU6196r6namSPJzOGiyx2puvGznqiHSKb67w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(6916009)(66556008)(66476007)(6666004)(8676002)(66946007)(54906003)(4326008)(7416002)(86362001)(316002)(558084003)(7696005)(956004)(5660300002)(52116002)(478600001)(186003)(26005)(16526019)(36916002)(8936002)(55016002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KDLnlBOkeEgvl+SS6Q22c5+wVwE2ArNUZVlM+g3El3vmwAxNKKXgvyt0+h6T?=
 =?us-ascii?Q?/gt5QBY6yoDVQzeA5FbpyURnBwJ9TsamprVqL9WAd227jcMMml7yK2mBmXNJ?=
 =?us-ascii?Q?XNTagmYoobAPvmrzjo7+mkjF+y8hGO9DOVvSohoV4bb2XxSm3Bkggv01ndTD?=
 =?us-ascii?Q?/oatZbUxIPkm/nlD5SUlBdH7RZ+ofKA1pNhUA1P0/ITF1USDWpZrAJNn2ZUm?=
 =?us-ascii?Q?B01arq0cNPmXDcC1wCrD93xhPBDcsEw7EqSTlCMdE9MGOcWPxvAWYzUjaI9m?=
 =?us-ascii?Q?QrcVgyJ5acEbk9JdY9JcwkcA/rg+KClLU5ZbPMisgb2gTqqR8AZ+WvveRtiR?=
 =?us-ascii?Q?xIUeVEWcuPwsIsYJVm9Y0i0itQCOVYtCtI7jWRzn85f5OvGPmuM6wSk97eIE?=
 =?us-ascii?Q?yb5P0JmnLC4oqdXlVgckhilac7hZi5c5VeWDpuOeDUUxiiY6OeOsGVIVSf0l?=
 =?us-ascii?Q?DvqiUhVlbaL30mFuSIz3iN3bQ70J256u2o0k4qQmRjtfCxy3KxSUyrWJBdBf?=
 =?us-ascii?Q?g0QRPPJFXkgyw7twhPW4+3nrNmAWM2CpjlKHeQiHngDEh99wRSmnNmwB77ty?=
 =?us-ascii?Q?gVTCW/MdJGkqWVu5UDr6txXBH8TNjfblQhCOTTq6e2qFVualZaOGH4/RaOQ1?=
 =?us-ascii?Q?Aku7NKPckAjokVXlicTunzK78dFLFR2kD4UudgoeMiFBKUXr+x1ocbu8I4Pl?=
 =?us-ascii?Q?oGprx3TZTwbn5+SmsrXLmbbPIz67oiIzzmG5dbylVmEaRPihnkFjVVEoZ+6W?=
 =?us-ascii?Q?Z/4NaRJTUx1TrMpINDXy4wcFS8XM4giw4ykpupVE/Nzh1FCSrbWSB14YN9rF?=
 =?us-ascii?Q?KvbO6Iax1egsOEAT/Dr7X1pX1JAzIu/Fa7vFmLOOhRw3OUPZ/xbiMJBAcvPT?=
 =?us-ascii?Q?Pm6dFvFJC+EVFAc1r2y2gYfdPzfy5fQurApwQR1PPC7ThFW46jeliaZYjKbu?=
 =?us-ascii?Q?emb9SamPOpiK2UEBZxzjfo5DnYsFhgGJhdJNx76JiWmM12uf0XV5dJpm4z3I?=
 =?us-ascii?Q?2Q31aBX7B1a2U8+kS8C22BT9zGwwY15a73bNEyYPZPup+Yb3lUdkKEGtCiGu?=
 =?us-ascii?Q?LDsOZP9s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe87636-75e7-4071-7f4f-08d8bf4e93e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:25:48.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JP6VFwUTshrCpqVJU3YZIKergpuOBjZQ0CRhqjfVI+ARO8UuUuAUI719bL7/nql+6BJpk5g5cRsbnX7n3VIsIEJL7DzhYCZPWlwUMY7Y/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=956 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Julia,

> NULL check before vfree is not needed.
>
> Generated by: scripts/coccinelle/free/ifnullfree.cocci

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
