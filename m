Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8E2C07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC2B46023D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhGMBpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:45:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15410 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMBpO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 21:45:14 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1fEpF014309;
        Tue, 13 Jul 2021 01:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HizAIB8cOvUpNXzNs8YO17JjTcp5rtdhd8I+XGUv4T0=;
 b=UO7dwMRylcM9z5bCeU4IiuYmTprrBfiu/60r0B6nyzyW17+XAE78d9kxfaGWZGkTZdIe
 eXqERdS9GMPuUlsWOqGYeU7Kd9Ui++cvbqjQjAhTgtseYRql2zbvfVyRfFd3Jz/NdRJ0
 hbV6LX0tcKvOfMEPuYrBNJkMNr8ojKghCaPMtqSTPXDBXw5dMIHQ9bEtu/zP2Wj6jpMC
 FOEDaOKw/V6gIXE8Br3FJpzawMr6EDWM26I4+1uiLvjmwbWHqm1b0BNDd9p13+IIqrei
 9fDTJmay27RU+iTtq6fAOvNLQJPrv9puVHSPma3lRw7IWM/3zBUSM0noiWOpjPx82l0F Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb1798-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:41:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1eRHe099219;
        Tue, 13 Jul 2021 01:41:51 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by userp3030.oracle.com with ESMTP id 39q0p2a8p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:41:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR1l0Szhpngs51knttShnMusHPyluHbD14UGfmKEsnqNqUF26+B0qcUx9V2IC9WyMLIETXRKHPoNmguidccKEwcTVgBXiiW832XJTpHQZKYJHb6ysxT0NjunR/8yH1uccYFTBIVvK507mqzsp/Uwutk1o+GfJbjXO1Q4ikEemiyImQymq2mLn7uWQ7RYtGOwrm28EO/b7DxiAF6L0iSK5y4dNyZhzWtB8q0StlLzfgzFFPS5cG5OaVX8xt11veVqbYnL03U3YCrMn1izABYRIjxV0I+n3bPAdV3DwGbCFZToojrlBOa3y0Ld1YbDnhkQpZ89rsZVBFgw6GoES3u2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HizAIB8cOvUpNXzNs8YO17JjTcp5rtdhd8I+XGUv4T0=;
 b=fV0hR48IhKaXL3rPjUmjPDF6aEKi+ZSgnbgsxoh55sWk7Q7sY7AybBmDJjXG1q5mxqPrdAp1mqSmkmTu8CpGZfyQw2/gJVzRRSf5EPVraQrrI013Y0Bvd62ICzYR7YPloTI+SQXFAKSJ/9j4Owo7KRgm4J9wTzt3TTxthdVzIAuclkAGzVOcwsQJ1N7dF2nNR9JuJqG9FjZno/f6l6aQHdQm3DDVxr/4ccf01lGqJ94AYF4sUF73b9U8JvFIuX0Z1zs46jpGKTvdxytGaZJNnrnbeht+Ep+h9809AOIOv5qfZpo+LvYrBqXfny5sCOAgirvpMOwM7m1V6hDQqDU49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HizAIB8cOvUpNXzNs8YO17JjTcp5rtdhd8I+XGUv4T0=;
 b=nzWBDj5bcsJHw4zauRbXp/2jFbNxSgVSTe0DijhX2lav+7hOpz6KotLtKGMc7OibB+z1D+6sDoIm7md82LukAtwf8jLdNop+Q4Vce98zFCRmCO1T4iZ9kXLj0EgWTY8MbX94x8so5Tu3yluYNs8rbwovbF9Egpr8ToGPWautabQ=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4561.namprd10.prod.outlook.com (2603:10b6:303:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 01:41:49 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:41:49 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: fas216: Fix a build error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2ab56sv.fsf@ca-mkp.ca.oracle.com>
References: <20210711033623.11267-1-bvanassche@acm.org>
Date:   Mon, 12 Jul 2021 21:41:47 -0400
In-Reply-To: <20210711033623.11267-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sat, 10 Jul 2021 20:36:23 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 01:41:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a17f487-ee17-4864-052c-08d9459f61ac
X-MS-TrafficTypeDiagnostic: CO1PR10MB4561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4561DF26963BADCA03726A6B8E149@CO1PR10MB4561.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yme38rOiUBo+YGS1euajKJigW45YOUSI5MizRJY50Tit4iG1lNjW+T5ZLztbN+ZvhsuyEVLl4sMG8e5lZej4QfHqctel9ORt2RzJ8YBxJk6Gpt4XmvPTuSsKf4MaJU4QHq8ljAm+jaLR59ONf/YzeMgZwZ5zXSSo+6dVQ/Pk5Sw5Zb9yibjv5D6G6bQIVoQ841YPmR1cSUs4F88NKHZD3Bp0PYIOYqBTr9rea2wqEUkwtfUs1A5jOWqA5DRQnBGnmSHNxqYBUwSMctQoNSns+Se9KSMSvElUZEmXCwsNiZBX7oXZRtSN5gOn7wxdI+ycAcBtYo4+f2qxMmaYZnwgtbmoHVJHquNd5aUmOAsocGiJyzUIcoTm3P+uEUCMSYbG4gNDFU2nU27k+PGzTNGRO6q7Gt0IXM316x1TCYnLWDM3/db6Sr+NglPVdD1KjANBf6/OaMbLzs1l0E3itK6mEk0xbCsL3TI4Am3jaxg3roTxteP6tMCQdTvuOibWKtY42kllzhVhrolrWsjlueY5T4DOy+6AuY8tOFPwsUys7Tl8ssJiJSEtWjqUItim1/UaQ2MvU8/ZmYwZ86qAHXJd/K3fBNoNb3jUmNj7KfW6uv7uEMYQNGmyxqtPnpLmbSOE9qcH/uv1aEPOPDe3j7yjmuE/P8+iU6ruTraNRBTXNR3VRQVPw2mZi2oj6SCWzg3t/4E3P5ITuLFGPCKzgkt2hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(36916002)(7696005)(52116002)(5660300002)(55016002)(26005)(66946007)(2906002)(558084003)(66556008)(66476007)(38100700002)(54906003)(4326008)(38350700002)(316002)(956004)(8936002)(86362001)(186003)(8676002)(478600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/pZo0MfCsVjUQVlouY9QT4UuedJZlJZBhKObkmov3saarjFeQ0YFURug1MAp?=
 =?us-ascii?Q?fUNNLyGvAEFVHN8vq1S3Sgj+FS/YIM2S27pwSEXECmwo3xSP4XQDFVVne1Lo?=
 =?us-ascii?Q?9goT3AC/vaNmHUSxrDcb3Vq+MuBk25qbOh3nw8Y02Nn0EyJtZac2HvbrSEmM?=
 =?us-ascii?Q?29WgRsDDbCVIq++Qjmz0LFFInMbDYJBgEMNkNlFR2aAnxPDQ4t3OVmvQn5FL?=
 =?us-ascii?Q?cb5Gzc868EuNCW8iCSDyHvU3OTyeYXxQFGc4nRVRy4CCepl4Y3Lvt3P3oCza?=
 =?us-ascii?Q?BrUAWFqTsqWGBzacp8FH2PyPOgtd/UBYmah02xg7jVWkVV87elBKq5XQP0ST?=
 =?us-ascii?Q?8lhwDnRCmFckShEkwcwTgynMifm9NzaBHkWZUt+pyQLUMYCaB98WJfWcjQ4u?=
 =?us-ascii?Q?NQsVpiUBapHk3pvVtJhxS5KgHsqOVD7YjQTCen57riTshUwY4SZTgc4+kV7c?=
 =?us-ascii?Q?UmDxC/15ZbQV3GZm/prmO9ekRsgp95MVZXFXZoqr2zCBRSQ1QO8fIbWhttNV?=
 =?us-ascii?Q?87gBgMH+/RJIfegFTJT7ovtgtKj4xNT7vigmRVrkxOotFw1CD9m0fzP1eaf0?=
 =?us-ascii?Q?NXi1L2aWy3fXI5VYRZgN5jr1zMDZn9riXT7eYaT2NuZmQz5C6p+3Fpm2i3eF?=
 =?us-ascii?Q?013e79Zf5PD+mH4f74qTDpZ4yDLYplqH+cFSq9+CXpj5ZKhx5ARiIp1saxGu?=
 =?us-ascii?Q?lGQ/FfKe2eW65XkZ1mFwaYowjLdyvsIuQ5ZIXdX7gRkKPwVO++2zY0DZoEZD?=
 =?us-ascii?Q?T1SKccJPMPReB8Hg/ymJqOzzxt6F44olKnIdz/0XvdQTKHyiZYrsE8Q8teok?=
 =?us-ascii?Q?9IeqZtMZRUxpy5nvwys5LAUQ4hzL10NX6MDr7d6vxU6PWrErFyiy9sLpAj4m?=
 =?us-ascii?Q?2xQbspotW8EMjQIdTM4IZ3+gWgzfA/MAT8qyyJa2x9rU2flyINNbLGgrlie4?=
 =?us-ascii?Q?aSwWXLYBgR69B3hESQVlGiLWxgzJIyoQru465DMHgla7t27xZhd8efvj1pbD?=
 =?us-ascii?Q?Dm6tPOcmNKEIss49AEuhP0ZFrafAUN3b6xYKr8wUOIsoMOWeYLoFFlfYm6/C?=
 =?us-ascii?Q?GPy13th90afne9rkP9jOsvR6IleKAe/iDUSsXQ96VMU5NUfG6YQfSaREwrY9?=
 =?us-ascii?Q?sFBAjeLHI1D9yQBGAau/NdE14goOKmQmVp2JjnchulYmr+babSGWXADl/v8z?=
 =?us-ascii?Q?QllFh5FpVwSPsKUVnhhEV7xNyZqm7Po8ZZaqgk5mCeOmtjG7deQ6YE+i/gDX?=
 =?us-ascii?Q?rVwnJ1naisZ7ZMsBxpb3x8zw+0qfMQa6Y7y2h0Nu6aIWj3hOtwC8q/8PTrqs?=
 =?us-ascii?Q?wnzoIBwikmLmOaIH9DCh6kgJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a17f487-ee17-4864-052c-08d9459f61ac
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:41:49.1700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWtL6/dctew0zdqWqUP/IgYFspvDLr6JVY9lcWuejq8y20j4zI/t9ttrJEMLOcU3k+ODIcaXM/T1vDxbyDH72CfKyyu2J7By+0aO2n6NHFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4561
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130008
X-Proofpoint-ORIG-GUID: 7RxAs1iIsUxHQUjInwA-lu4xeX9JF7px
X-Proofpoint-GUID: 7RxAs1iIsUxHQUjInwA-lu4xeX9JF7px
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Use SAM_STAT_GOOD instead of GOOD since GOOD has been removed.

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
