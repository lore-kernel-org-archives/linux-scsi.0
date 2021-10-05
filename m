Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5E0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC1C611F0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhJEDjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:39:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60906 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEDjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:39:10 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1951tBjR004524;
        Tue, 5 Oct 2021 03:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qG3YB/2xvdyPxIjQS03mm9belASy4dnfki2qlV1WmAM=;
 b=vPMe4joOMMQp/TmeQJWwORwMO4tXB0YouoZ7D2ycoO8h58ez9P39AWZfSxdj2Ui5Ruaz
 xBpJCDFE97cfIJkMotPb5ZY6gTekIB1uPvwFc1cdiw17kMvq2n00dCM+A41u2FY2x+en
 86YnKEbNuOJG+n2Qs+CqEjYaOSiungQ0JgWKL02sx3BIeVk3oYX8uBsr9jtEQrFMzY7u
 9Dp5AdsgIjZ0EOs6iLexsMw2RFY27VoF80CFdLm9Qlefr1CjguXzrFlXAIf37KpI+3uw
 BxIiPlwz4qNuREVOj2HUxFX1gE3mQdobKT0ARgyBNHStLodwT68WYS0n2XkuH2Ds4b38 VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43dv1vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:32:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1953QHXH027970;
        Tue, 5 Oct 2021 03:32:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 3bev8w32my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:32:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha5A0skRHcQwKoQrMm3rVZrHOmLWxVxDkLpudd+WLEqoMFIiKUI4g5o+aDfTati3bJ2bdUHqcIFZi1Dg6ltw+GxSN/1ZQre6VtnuBOaXvmpg6AwrUa3yE8GD5rgBdL/Zqt/EtExC6lezNGa/RViBb03wP0BHU03VDagiN5RP3XuT3efosXb6ZKX6kr5sGeaebd2pkpA27BfsUu6INWuhQnrxWLO0NK4+d+jaqka6Zv9SmYPl8UzREVfxLaZr4WzX4uXyiBhhdSklgvYvA6RvXntv/6Db8lzaaX0nQOJvx3l16HA1yQzKfobKNzw3Z4qHg18cliy0wDEnS75PXgodtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG3YB/2xvdyPxIjQS03mm9belASy4dnfki2qlV1WmAM=;
 b=Xs7C/RVPKoNoISfMn1o9FH1iEGX80vOdTTl2eSn4H24etXPwxLxPEZ0uEsE5S47ahdYR0sSIJ5OYV2dA8j+dJYgA2pOFfIZjE7Nvdv/cLF3c4tHw2Wlsmb9plktlWrUFc4KRnX1t3/Llvij8+iqt7bl1nH6pOlGlFiA8EObw/AUFFEzC0iqQQI1ydBqG30pHw8WkDcoAMslE8q9WT1TAx9UT3H8SxplS5O9ZbsFY6hhz+iU4OpxQVhdJ3ukWavi8L0V2mjMGczNTzmsq4oDsxUVfaJroMj7Fp0OpXn59hctyUsT0IKAym3dyDAICfXC3+5ywSudZAgVQzEuEPUSAGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG3YB/2xvdyPxIjQS03mm9belASy4dnfki2qlV1WmAM=;
 b=yTcxBCVd3aIB50ImMQO4g8schS0JovaKbvaCgSh3GGRew+U27BVHoSM577CYpyGwx10b5TOp5SSszbHmXJnNdPI3pfj01sSR4S3k1P+CDoxwUFVqIWGDYwuQP7TvpH+CFsI9SaZDrj9gDNH6DUBuQ8Z6lZHZSVMiyXaxUEJojLA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 03:32:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:32:10 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: pm80xx: Replace open coded check with
 dev_is_expander()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfxg6tav.fsf@ca-mkp.ca.oracle.com>
References: <20210929025807.646589-1-ipylypiv@google.com>
Date:   Mon, 04 Oct 2021 23:32:08 -0400
In-Reply-To: <20210929025807.646589-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Tue, 28 Sep 2021 19:58:07 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:805:f2::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN6PR04CA0092.namprd04.prod.outlook.com (2603:10b6:805:f2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20 via Frontend Transport; Tue, 5 Oct 2021 03:32:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08ff35b1-03b7-47d2-2340-08d987b0b6d0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744E64C911111E02AD2F67A8EAF9@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWsr1aG/7iBEpHP9omVFgVXy40QOCAbMu74oIijnZIJIft2ukLZOtkyzaqcTZOh4hLP4TBiHEzw3yG5EEOWnr9Qn7Ze3P8GJ5/D3wFQFXAUpU5xJNaLS9XHrSAiWEo4bRICFi2K6vdgeRQK4Wbptmic4XEuzAo95P9uvfMt0kXuBMmeuFxS9sx351oQDg0Kf2MZiU9Vy9lFq7oAE/u8HDgkUlpX9NeRPzM0Dg6ZYFSuxANPiunKoVrywtJ7Aep22CX9ccQ+2bwdQP8krNBqmgmmtwBAo6K6NCb7e1ICzK6PpZVF4lynFFlXk8Ek4bTuJlR4OGy2/00MHaNOzmugCq0mUP24za9ktriKBHuIrCHQ12m6c6VqumiR8++CGPUU9MUCiT141vliLdxeWPUNv7h1yOHEU6Y1ozn/FQPE4vQHlG2UrQmZLHTTDqIxuqM3JTK7HfwgUErGvhhkEX2RkrverveV/443YhFctbt8KrYepG/A201jf+z/kS5g6JMYcKsQplF1qzPTDCpyPcczoACal49NFBbAFlXmjJzRLtTf+Iw51xx1Hcev0et+rflP97tEZESxL5+NAcX9ad+8QSV/PoALkUaCueQJB6A9zMNgsyWE29SDC+ECeVvpc9n8vyaSFblQbGMJEMaj8U0DdqvN9OHrQ5O0B5h4xnSf8jjzPVTz5DHTFTH079U5QlCVVZ0qWQmuql1y47dPu3onxDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(956004)(4326008)(55016002)(2906002)(86362001)(8936002)(8676002)(38350700002)(66946007)(6916009)(508600001)(36916002)(52116002)(7696005)(186003)(54906003)(26005)(5660300002)(316002)(38100700002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C+OuneqJsUCAbJ3YbJlY1vqZO2iEakhh7MRAy5rhoCvV0ci5mHaa5Ji7KKUt?=
 =?us-ascii?Q?ozh1L7GCs44J0jlPENEp/h1RtrMbZCfoQOPqBbTqnIDDtVz1xF1sWyhqQfVf?=
 =?us-ascii?Q?eCmljawNksw3Iei9xBghQ/htf5FV6Tb5oiHh/vczJDYtxukEWJ2gepX/icZY?=
 =?us-ascii?Q?4kJH0Sn9EUyH6F4woji7k80I5dlMlaVBXa/hTzn66RdSNJl5y/5d0sS3Fuvv?=
 =?us-ascii?Q?RYc0zxoPQlJh6MuiITGT4m1uN8NRxRwPObczv8pTm5INaAZ9T+oDkN2nWZW1?=
 =?us-ascii?Q?xJBwkZW8bX69Cdo5sOccDQtV0fP/WeOojIk2Fi/37DtCKmqoK5F3h7dGhr3P?=
 =?us-ascii?Q?ig6ujwuYUbD3IUmdh9mvgc588xxeITU5qKReEkjLTUeMvDjcvcxM3ROq2PVy?=
 =?us-ascii?Q?opXUGQ+y6qem6hjUEChG9xVs5hFT+U9vVddEINO63UsnWckNssXfHhaAZN9Q?=
 =?us-ascii?Q?apEdiG4XLgeqoJUpXNrkYPJ5FpxH8Zw0gvGEjrwBstHxxF+7Exdfl0sgPX3r?=
 =?us-ascii?Q?qrobjiAGq948dKbA5kcAgmTtc1wEXI2KOGDlaOMHkYPUZ+7GfDwzUqvvorS7?=
 =?us-ascii?Q?pI2Q/mN/QtAxg0if6qmYivR1xrEZ82OVpdvAtq6ikRd+xgNoz33HaXkPuCXY?=
 =?us-ascii?Q?QUHS31rdy2KeYzBXOS/iORmlanooKiKu/f41NJJSarKSFRj1+LIAtJykEbIn?=
 =?us-ascii?Q?57GZuLFaUhLG1atZp4tSore9g6M2ssMGLoDvEan5d/49zBscqZEa99UhyOmO?=
 =?us-ascii?Q?W7gIVbH3+NXfbqAVqFdbesQT1bwHbNWm9xgm9Ro4NknnrYA8bjzXpcWuu0Jd?=
 =?us-ascii?Q?T2S/W5aYiKUOkP7QRQ9UnUmE4ZEI6D/xjWCuier67Bmmgd9jNXgXONqSNkZb?=
 =?us-ascii?Q?GpWKCc81NVVqt6xwvZCDprS6AofN4Eiz92ytNSh8EOXRyAglCju/01oAoQb9?=
 =?us-ascii?Q?hrK9jX+TuyveROQ5FYyyRWlrSXOOoJCSi3VU0wSxoBkAQ7CwykZ8nCVj6n6P?=
 =?us-ascii?Q?LtdXxv8KFfBGhoNh8GuuIVpB38TMTJAW+A4OY9hbY8/ARvObi9/jWBDGvowP?=
 =?us-ascii?Q?zO2Pd6DRsDgEXlpJHoRjMUwvEZfIZ4EkikS+kiGKhyyPPWhVdXB+fA6mirZT?=
 =?us-ascii?Q?XNhWynQNvoDTpJPGwIjsy9bnF/FzuSLn+eXcD/dq401HUuyBiXV2P5ktJ6hF?=
 =?us-ascii?Q?zQKdOrXBziFEDAniRjKof8gZOamkiNGezpnhMzhJf/HnMw+nLOgK5gkET274?=
 =?us-ascii?Q?xnwIu+EaH8UNoqAwOUJY5hVZiHZD5ClKkYSylo+zMbjN2HKTG3RkopONg8iA?=
 =?us-ascii?Q?b2ePOVHgWxBS7tIOIfn/SiDl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ff35b1-03b7-47d2-2340-08d987b0b6d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 03:32:10.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ve33wldmEet357yX19rr8RuXbDPK8RzexCkxRdeNUh+NTedV18dhYsE2szedKhlpa8EiQDak/htut5qiMTH+VkMlruYe+15B2gg1jNo32Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=860 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050018
X-Proofpoint-GUID: k6i94-OgYFxjruZK0hsu1h60Shw3s7C9
X-Proofpoint-ORIG-GUID: k6i94-OgYFxjruZK0hsu1h60Shw3s7C9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> This is a follow up cleanup to the commit 924a3541eab0 ("scsi: libsas:
> aic94xx: hisi_sas: mvsas: pm8001: Use dev_is_expander()")

Applied 1+2 to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
