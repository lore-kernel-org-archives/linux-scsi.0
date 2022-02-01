Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E8DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 17:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiBAR6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:58:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48296 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235079AbiBAR6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 12:58:17 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HE4vS004865;
        Tue, 1 Feb 2022 17:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5yI8+8k01CPPQD+pOUWIJmRR0RYXAtL2Zsk5LZhPKn8=;
 b=tqB3caYbJIE3FL97EPllKhPgYp0Hm2Qpt8OcskrEW/t47tNxGru8vdhHZaxDOtjsMwMy
 kF1lVTc8f7peeMN8bKXRKvNVrcrZCzt76wI+3Ie6GsyZkmIqJovSNxglEGc1Sb3ThFc1
 VCxsoPPxC+WlyrsXGV8LvZwceUhDthgRK2vQl0JsBA6uhAe6xH15MsE6IiCGLrX8QecX
 RZBCMwnIud0+Zeg8DaVuYdBnu35FsghdiwjtncA9NTUEXTa4RM8J8RHzO+fcdrg9qRc5
 hZZ/DO7NVkwausZyoZqIVR52TAqeAzeSPSYIkF24kNFi74++1jbPlcyqXjcqq4yWo0Cc CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9wbp9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:58:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HpYEA167346;
        Tue, 1 Feb 2022 17:58:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3020.oracle.com with ESMTP id 3dvy1qesjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:58:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIVBGs4odwJ+pA5IIazGIavOVGxdybOynH2LUTa/ccfUbi8Ub5UDxI+kJPewvkVGWkYiOTEvBLyMEW5HJWgovldpRSlXNCPnuR6Qur+ig1eihJTEru7aVQECj8hK7bOiTE+RCp0CBzD8h7txNQMwO3dH5kjCWkWWlYbUL0U+Mm6fGInlyuf5qyMbLB4yHn5Sb0aZ3GWnV1GMonQfXmWQkQoKcE9SxAZyM6L+1d+gS33ih3TpoooRjw9Ta2DACSUFU5BQ64pMziJAeYXNYKAXaUr/+qb9mzWAUkIy/FtkIzO9SGZI26RgG+jtPfoaollWgZSzyRRe8y57bFNrrt/bfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yI8+8k01CPPQD+pOUWIJmRR0RYXAtL2Zsk5LZhPKn8=;
 b=dJVFPximC70LPb16cVfCP9BsgIFu3ySzuRmHF4hUTcq4Q4j6cvH6OdXqlOI3DU5ZId8LNGM4gm018P0hnpxA0I8U3YS+OCxTfU/l0T0Gt7SiIpqIPn8hN3e0nZARYWHlbvI1H2PNS7HWCFRa1QXihuclvcGEw5pcnwiC9BOSuJDQtIhXtUqk0h9GynUuI6SsWYgIzN7j3hD/l2muFfugbLsCFqK3bV2AF+yQeuJRJ4eMlKqJ8KhrZDANEyviUR1DgNCO0G0DGxQ7wjn2EQ6wu7ONpLABTCDGGgsVWOBfU7ikMsZ88iDbdVDKjva9pLauJt/iLG/jQ03V5RGbhsec+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yI8+8k01CPPQD+pOUWIJmRR0RYXAtL2Zsk5LZhPKn8=;
 b=Fk6vqDLBxsGSBlWIkZfJkLiSTBTZlvRRdb0YeReFuNTaY+H2Rl2WLpHyT6UojKDeUSbIDyfObtNY/tIBrE1wqLM5ldHlCjkzZrEC+ZBQoHtbFDhOMeHaQnNLezjBLeLHGQYGFfSTDyJOqs3qDg8lvcGC6DdZ0mvhiUh1H1HwPa0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB3971.namprd10.prod.outlook.com (2603:10b6:a03:1f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 1 Feb
 2022 17:58:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%9]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:58:12 +0000
To:     Ewan Milne <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: scsi-staging crashing on boot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilty8o81.fsf@ca-mkp.ca.oracle.com>
References: <CAGtn9rmosXZtSgn24gFNYTzkFrHgY+pQBNTiP-3N6-a8OX+HzA@mail.gmail.com>
Date:   Tue, 01 Feb 2022 12:58:09 -0500
In-Reply-To: <CAGtn9rmosXZtSgn24gFNYTzkFrHgY+pQBNTiP-3N6-a8OX+HzA@mail.gmail.com>
        (Ewan Milne's message of "Tue, 1 Feb 2022 12:52:57 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a45e0713-ff09-497d-ca3c-08d9e5ac6a12
X-MS-TrafficTypeDiagnostic: BY5PR10MB3971:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB39715D13AE7CFFC457A5065C8E269@BY5PR10MB3971.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUHnTUlyep79L/Jl8t2gpOdx+t1haGd5I6KrnYkfYMrcBU7ZYbAeO1m6oEi8AJPCczh9qtvMlMz1REUAxUfDFIe5vnqnHmaxLAer5DFDJTSnjTOQ79CdpbGi8wXjRT1iVl1rcoawPd+UJmZPxkwsK4UOHIQBjcLH8EHnODMNWlfC/Kn4t3vFEVEkA4nGjtAKxd3sTg5LVl64pxf71BXcetr0T4RoLHf7DD+9l/ChyWK9a9CJbxOPqQ5TpD0uzesvXkdcApzrEPYQFEzPHD5LR/uPia+LBhBjDa2R+lCCUNplE1vplYnGYk4gVhGBlhJ2aalYAt6INnGhFVHJVFd8vzTAFUy4V4iaAe3Coq8zMh9IFTM2S4msWEEIG70emCF2Ot9mAzU36NnbgAbAZRY9v6RwcAjgSnOOh0D79iOCvJJSvLk24nobVOz33Z7oyUk2CPgfPzKWKzDz3BssFES72/v8XkSmhFA8nmsWh/58j8FhXHUhXjQ7jaa3d5wZ+H6x4QBlDnZ/MMUTKEEhxUNvifci3ghe6nkek8aYXA0GODAF2u/c+JBQFsJkrNsn1dN8oNQd/rT7JOLntZ+vfUQ80ChbSC/frhZsu6h2rNARndQwgAI2472MM+Q1MWxcGNv8mr7YagcDRxKKeUszZMWUnF+jXD6GbiX5ye88uHSS7DC+0c8Kk+0AZOaWBTa2Z3XpXI7r1ccug8vGGitQmmpphg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38350700002)(2906002)(38100700002)(5660300002)(3480700007)(4744005)(36916002)(52116002)(4326008)(66946007)(8936002)(8676002)(6666004)(6512007)(6506007)(508600001)(66556008)(6486002)(83380400001)(186003)(26005)(6916009)(316002)(66476007)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIzMEHg9z9Fd3FZsmMJBrQdgvPN0iBDeQjZ1lMoNaSXmC9Jas77LBxuiblYm?=
 =?us-ascii?Q?qSmqSL2w/623tzm9pnhSldMSK6DLEP7a8GylCtR76yEbhJxX+mvL4Wjb8jaC?=
 =?us-ascii?Q?6JcgQ0U1HwKg+CdK++spa0zevL7bLxTuS7YfURpYOXmqofQUjI3bM5DnJDWg?=
 =?us-ascii?Q?WdebeY1IEp2NR0QhH7eXeAL02zWcYW2jLkjs5j0Pn+TNk9G1anrYm712rqwX?=
 =?us-ascii?Q?YOrKzADo3TN8/CoiZrcYF+zDIYZc5vmsLed7h753eGodoDNutWmG/F8lQZax?=
 =?us-ascii?Q?cmiLM7fu2IoewFuSwajKd4ObHsWkqQ9wlelojUnh3H/LkQng9FRhMbJB/pU7?=
 =?us-ascii?Q?w//HHLU8iF+60sYDghhptbsqaOYv0x4AZGbw4oAUoMqzFMhj4X8MMTmaKwUM?=
 =?us-ascii?Q?rU0ryDVTT/zM0xD5cJur8OAxZNEaeijgmVhEKOZy+krfe+5dkn9zRmNUK0nh?=
 =?us-ascii?Q?+kHd1s4QK3Osrju2l6t7qC+WDitBM+Vw9i4AAFhpebK7fnQecT8PoAblXGQt?=
 =?us-ascii?Q?P2Nn80fRoswUKZnbJAaH96QMUiBa/5FufsHwyb4i/bIQ06KfTPKlCcjlxFIh?=
 =?us-ascii?Q?TM4B2XUvVdLhbX6LsTWSoi3jWenp5jAFiJebji5Y2856cC9wF7jRDVz039uq?=
 =?us-ascii?Q?KtUrqwmfFKhy4EirZ5TRe0dT9PHpD/cQlRrMHEi8tSONYG5dWmFUmjvj6wG3?=
 =?us-ascii?Q?+Gy2smGB4YL12xJNCeaSkLwnkga+PZ90x9gjiVV6kdS9Tev4VXAyy2yzR+Ij?=
 =?us-ascii?Q?Ia73SxLVRBMTciP5vbfUByuiAlVw7GeA6niTQCyaTn+heP8kCsJsNX5I+soF?=
 =?us-ascii?Q?sD5OcKET4AIkz+ifE/GIMXK2H01haU+YdhWRsypoMGPn91jA2+T8c9OzRAQE?=
 =?us-ascii?Q?oT/tdogD1/eAJubS6xRM6NOTfzP2vQiRhA2M74sc3AEtGJo/xsDk4DtWlbeJ?=
 =?us-ascii?Q?oA+6kJoJz0p3WCzUJAT4cebZms4FhRq2zu2BMB9zUulnh1+2KQ1Hf5duxbuO?=
 =?us-ascii?Q?KtKZoBI4YUSJjRbyKh11oCVlLDPlpGGH4MInR8xf/5ypL+AkIe67zx8QxVaS?=
 =?us-ascii?Q?YDZDI1Avhg41EByGa6U2HrX3FXQNnM+mNfGaRo/9mtHL2AB8IlrWBLsynrMW?=
 =?us-ascii?Q?zO0uI2z4Q7kBGlyVWW+mgOtsjPZddiND1JWj81+NCD9AYeugbMoNTzd5lmJl?=
 =?us-ascii?Q?VjAF90zdxSDkEV/fCH0O+0od1ZL+6GZdyuGtl4PdsWeF7A+M8FbtkHn3ULse?=
 =?us-ascii?Q?iP83eGTmZosy8gDr1tOUvKkXM4DM7lRvOx7gbwmJ+bljc67IIznkBUpqNZwd?=
 =?us-ascii?Q?BMVL7sIot6+5iNHvBUgxJeUMsiy2hC86kHrKr/XdrcE+kTXF+vnjh5oAcBhJ?=
 =?us-ascii?Q?atnZ8X4iZwfkci2AJTXQCm8SIVtRYbFq0Lggiw+4gmRIv+vHQijEhpJ6UZ7L?=
 =?us-ascii?Q?RKQAUe1t7/0URrTReJWvk0YURYmwU0NPbjZl4EPphE6QlKkktbUUFideIbtl?=
 =?us-ascii?Q?aaS+GLrF3TPdBuIXX5iM8bSsb7ZKWGPmz3M3E8RPfhrZA0NWoGKE0rA9C+QW?=
 =?us-ascii?Q?cmvSAoB4TJ0fKSw1b6k1FMh2Y4pBvroFXz4PIoJOxiVtI15W2sCUif/fMFNI?=
 =?us-ascii?Q?LcJp9HKRGLqySrLMuX/+PIyjhq9mXJY4d0yNtw5U4nF7sxVN5zaEjRLacdQP?=
 =?us-ascii?Q?QD5Oqg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45e0713-ff09-497d-ca3c-08d9e5ac6a12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:58:12.8106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFYcEWmlIp/RFLfG8S4JEDc23X9+IV93P7CRi0PQJA8eMidQQm2klaUb0FV7RvIX3MXf16USBzwNaUzJ5T2CnHKtneGtrBBdosppUxhbsA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3971
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=792 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010100
X-Proofpoint-ORIG-GUID: Y0v6c8TpKLvjuO8-LvrrG2bigMJ9Lc7F
X-Proofpoint-GUID: Y0v6c8TpKLvjuO8-LvrrG2bigMJ9Lc7F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

> Anybody else hit this?  We are seeing a crash right after boot.
> Machine has an Emulex HBA, we don't see this on a similar machine
> w/Qlogic.
>
> This was detected w/automation, we'll try backing out the last commit
> (below)

That would be great. I had lab problems yesterday so I didn't get a
chance to complete my usual run prior to pushing.

-- 
Martin K. Petersen	Oracle Linux Engineering
