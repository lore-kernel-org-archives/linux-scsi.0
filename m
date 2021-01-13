Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF8DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F652221ED
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbhAMFJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:09:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54664 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAMFJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:09:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D55JvG056814;
        Wed, 13 Jan 2021 05:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AaVQg/3VLwgREcfGzg7FeISW+ypLwFn00GidfTArHr4=;
 b=zuGPenvRhyAHlBsW9FDzMqToWY4Dnt6ebqemjxs8bpYwWqAfZrPyicVR5dGeKP622neO
 WA+cktZIA55jRigkssGqOBXh64BRxKOecj1/+zmAl29mePtPWFsubzu0giLuo0EAoCFe
 WXktTvombaZjFp9DXffxDfTMDU++IkkfVsZm0fN04IDj+PZ2zGIsd6eHROMo45is1xLv
 dAUVpcjy+wMb7JSHbg4Mq35MDr/tcnTd+tVPCB5bOOxoVV8V5BfltOd7EF/Mx72kj8XQ
 +iyeBuOOonr7BRahjcReB+gFlT2J9X/d3+jwP31m9iSqcWEyCZtNL8hgjfUhPTVRrNnz aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 360kvk1gev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:08:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D50eCc079349;
        Wed, 13 Jan 2021 05:06:40 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2059.outbound.protection.outlook.com [104.47.46.59])
        by userp3030.oracle.com with ESMTP id 360kejeg3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:06:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBmPIKMf7gwU3UY3o0uzFtd8yCZTeNA8mASyk5DpPMKCqbT9V/HlwhWFyVqbSr9asCLVX2II/lVCG8UZ1ST8f5+i2T/RBbpVK8mw+AzlDesXjJNI9jqNL/xky+TIfxHw5x65UIkzXCQdZL2XWF6zE+dh0XKRQu5eZHO+Q6xsUzkoYTeJmqHgJCyWcTzr6b+mEnUQKPNqZXRfWScHJU9oOATseygOxaIACPfF3jO+SOIkNVMEM80sinEks4K2des+zcIrXg4vnufa8O2F4DPD4COrjrS0xmtmBm+8elilasu+K5tnEP+YK2DeQ4O3MOwhH8fNwNakXxOPz+G6a22Jjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaVQg/3VLwgREcfGzg7FeISW+ypLwFn00GidfTArHr4=;
 b=RpO+8ljgiIaRsc1tswGRqZhrsosHcUu6rcQ7YuNysK7BsPaRxA3FPAHHL//kENa3Wnv514otgQzJwAx5PT5xRgyfrNBWNIIy51i4VL4GFNSlR301OKCnSxB3UoI4fPV4s31seAu/K9dih9ukhPdUdqJ3voQY/p/XPeUJAc098z1y8LyWz7QZ5oeSQYGZTB7K9pttjEsdrofaejZZGa+xMJ0PGQBdJOqunB3s/eArqyUa3h5IxKqC7KL/YBcm2T0gw3Px1E+NGXHDmMyzZswjAaI02Y518TpJQ+S6l3PSsp5RTpwPN4WWdf7CsVHafPwxVDYjNnHuEjSekExo3Mev0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaVQg/3VLwgREcfGzg7FeISW+ypLwFn00GidfTArHr4=;
 b=TVISrRQl2mXDRZyW1sFPpNa6cfSM2d7aLS021EuvZnNGoGTpNiQeeiDVzb6a12F7cJ64hDyxC8EiTnHsAOyO6vJNXF5Laebu5BE62jAKRjWyQ9q5ANvK/8jkMza0xW+Gccdjwe66JtAlwhc/HXTpWfdrd5qiaTOTTNyk2ecSa7Q=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:06:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:06:37 +0000
To:     Viswas G <Viswas.G@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 0/8] pm80xx updates.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh1d2zvl.fsf@ca-mkp.ca.oracle.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
Date:   Wed, 13 Jan 2021 00:06:34 -0500
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com> (Viswas G.'s
        message of "Sat, 9 Jan 2021 18:08:41 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:806:23::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0061.namprd13.prod.outlook.com (2603:10b6:806:23::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Wed, 13 Jan 2021 05:06:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f9d6189-bb83-415c-1829-08d8b781017a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46775AD569EAFD98CF002B2D8EA90@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TmEEgDr2pmS5mguKPXqw6fXAzHJabAAjFE+/QiaDEXj1izQHX02Q03Ms5qfkjr1M5YW8R8wVIJBU0eG7QW3nchQDP9c3kN/m2Ri/B40Rai9JZ5xECZ1H/kumGWzB4a3BW+Hm63SVPBzpojUrh0gcQXLYeMgssbaYnQa9SkjUXFp/xzgt+3B9Gi8iVrcSB94y2ny1Hx2DqwMnxgM3jGvxHdGJ5Ve2p0GJ/36OH5WhSmSjQXVwsXa2dreLZt84bXDqGqVZHJvh/dq7gb8a04UyoYyT1t2f3mHFr1u1if+4nePy68FTRDox+LcxK3X6B5zpGmGp3pFas8tne489t5fkceVq6T5oNZPOtU3zZp91osf9tHzuJdw6BmhrzQQnapdDegQzwTu98rCWlZXEMShKsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39850400004)(396003)(136003)(4744005)(6916009)(4326008)(316002)(66556008)(36916002)(66946007)(8676002)(52116002)(478600001)(5660300002)(66476007)(7696005)(55016002)(16526019)(86362001)(7416002)(186003)(956004)(26005)(2906002)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iPm9CDSsxlAIunyU8so1Y2SlP2zCYT9qGjGlP18Y3CgW4yH2iE+hRriCTJOM?=
 =?us-ascii?Q?a2g4WkNoCZQFD/bhDlbaBE5VFfsI8hGlieRBASCKARGXtvAXTuuA9Gcx4aNk?=
 =?us-ascii?Q?zdQv2a2ADoFzvducqWyf3Duhu2oIU7TRpYp0cg+1bYIqboceyb7zwRz+dBGL?=
 =?us-ascii?Q?morQv3cGZKqqD7H9PrKAbKeNzwBjGu8TjZ45uFbFjGMvJqd4Pl9OI8DRHRGp?=
 =?us-ascii?Q?fbxmsJOPB7DIALCIiucpNsKWlz+J+5VJ9W2w0ku9NcO0Lig/u6KtaLoslr9G?=
 =?us-ascii?Q?t0Ehv2zcEe9rbtXIPOd3vG1WVRX8kdSJp68p7mKdeFPsTwOcMYwOItpPOsYK?=
 =?us-ascii?Q?SEFPx9esSaMC48z8sdeRpP4fa6L3wmWoDEY7H53lSweLnpTDbvyN5kuzBlQf?=
 =?us-ascii?Q?ugIp9Ph+SHAEnW0Hw7es1uhMAvYzqYD1Zh511VXRqpCci3ebyyBFTMUdUrbo?=
 =?us-ascii?Q?f+RC6OBKi1qFTzRRj6a6qR2Ub38+Xan6loHFDKYqG7JBUr2t+4XzrCemqvPj?=
 =?us-ascii?Q?i68pKRHIfBme8ZfR5feNkvmfdzDxNZqWgw4/S5NQfKyIvp0g6RBdRZocGT9d?=
 =?us-ascii?Q?EabjQbHq7jJ51tm+bRlC2tlcImZgMKhWa3bVsUSa5+rLL3EwBPAuasZvJJEK?=
 =?us-ascii?Q?BJR365FOWT8LyhGrdddlg0hg71cj7O7w1EEXzJ8XRi9xfGByawiLl6SsBtOe?=
 =?us-ascii?Q?r56HTNu0GlV/n6x/6DyCsBjqdMG1Pzb2hNJIuabsgrz1McE9QYNSNypcp9lV?=
 =?us-ascii?Q?tEAD+AMhD/S2OwnUsh9+D1ak6fnUZXdcbiccgUG8/8GvrZs28HusMy1rWlca?=
 =?us-ascii?Q?ADk+HZV3ePTc2rEeV70fNJHIzUKSqg2DRyJV0BzJruRNzUpJgshq+T7CDSWp?=
 =?us-ascii?Q?Q36bqUEpuXCVfICsPKauIYEJ89ed9EVlpNIRhkrx4JYjbJgAamzIZOONqlrw?=
 =?us-ascii?Q?R/8Ibd8h17IwVuJzsTdT0Mzx9+Afh3OAstPVKpHvFkes/X0uxmYSkg26FrJt?=
 =?us-ascii?Q?UIj8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:06:37.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9d6189-bb83-415c-1829-08d8b781017a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bY3s/vm8Tq1844ZPmVUBlkvMEl4+uZui5h0kKG8JqOzZp8SPIag+B7bn7uOFz8IlKlxoL6PweHHjzEB93ZCW41INaYehdUodiU7eVQ6dKGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=888 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> This patch set include some bug fixes and enhancements for pm80xx
> driver.

Applied #1-#7 to 5.12/scsi-staging.

The health monitoring patch needs a rework. We only print one value per
file in sysfs. I.e. you'll need to create separate sysfs files for each
of the fields you want to monitor.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
