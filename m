Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D425C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 03:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8D464EE3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 03:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBZDJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:09:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46644 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhBZDJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 22:09:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2sw2J000944;
        Fri, 26 Feb 2021 03:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=80g0WSdi4evxdQWZjAKAnng6xGThJojnS6tTGhbEX38=;
 b=CwEvborx7qbFV15TMIpXw3Bix0ZEshkTmnPaRWbbbA3LNOTcU0SiArWS9tkV/Bo2dZuR
 YZHXlkeyNMLm+ePnFcPqsrd8elCMdAkCXF2Uzubq0k8I0cM+4/Wgs+79czH3MXhCCf/G
 aD4/TX6iZfHsxFGoU+PgiHgvWryzgWcMCbxErbjoVZ7l8F5FaCQ4KQYCYQ9aRHUn+xHR
 /8arSEP5ylv6RRbyWV3+c7xUIxDTv4oZjDp+VCEDzgAPPTkZuLTj6h2Pn9jD8P1+XwIH
 X/8Wtsfnww8yGzAcMuA3Dqn3sJHzoovRIT6xwwbIfSiJEyGyEkqUVXq8TNR1v7yms70D cA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36xqkf837f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:08:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2uggc027624;
        Fri, 26 Feb 2021 03:08:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 36v9m83knr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 03:08:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enR87S3134+QyOXqgH/d8VkPPqDF3ICHzqI2o1L1EP9+I5rv2YOrpouFBAb2I448bx8dqnMVmopAQLxNt+XYEwIpPWM14WCGTppzFGfefn4oJ7G6ywph8Oe4UW4rw6Z2HnTqzavjPoBj9EhHbOGOJ60MIwk1wHITfYTDfWj/xeGQIybfg37cFYgPAQDBsA9I1l2D+24FdeUoMbfy9pusIQp9ObSnCg9zpQb+gDYvn7T+TNc47PWR/r3JGyAD+lxSQaj5M672jIgGlVd5jtkYEXHh3GlbCTVRoiWNoWmEKNVmA4qRH71o3ymaSH3rm/aDRBTz1nay6Npav3pIO6MguQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80g0WSdi4evxdQWZjAKAnng6xGThJojnS6tTGhbEX38=;
 b=JoquocYzncTHQSf0qt9iKXO5EcNW3cCbfVaDGF3G8yEIOTlGIKq+13qSfAwTjivsiw+RSQsCqivYUUI8j9SC/scXI5QhxMcL39Psrr8GG1oFIjqUG6mKOjjwMu/tSRwislJRZFYJYJPgNfWd6PawhQtRuZLGDntBeYN/e/0x2Qypa4swfSfC1zQ7f6Q7WED/weBz6ddWf0LwHBF/VRuDu2d3QFmf48Hh1kyqLwnY2Fy3joOltqRPMfV3JBp6LtLxM0xNEgnrJYDu+7gmfymSbnuJiGUv1tDkq10RCdXmYG9Dlho0XrGOrLtuTPDVELQMNKaf81S9I6OGt13V0aY3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80g0WSdi4evxdQWZjAKAnng6xGThJojnS6tTGhbEX38=;
 b=KaJqGj3A/31cpMVnb54PpuHJFmvs2MWmOGn5bxfH2WgiCzx2RJd4+lGWMSO5DlvDTl6p3G0FpGL7GvFdM6kiZRQEQSrtjhY528SJmZAuG11/m2u408+w1cFXk1uwcMvgC7NrgRrb5UGf6oBD0E60uAwA1gKPGX+lx5BDTmTK9CY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Fri, 26 Feb
 2021 03:08:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 03:08:39 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 03/22] lpfc: Fix reftag generation sizing errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czwnledy.fsf@ca-mkp.ca.oracle.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
        <20210211234443.3107-4-jsmart2021@gmail.com>
Date:   Thu, 25 Feb 2021 22:08:37 -0500
In-Reply-To: <20210211234443.3107-4-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 11 Feb 2021 15:44:24 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0138.namprd03.prod.outlook.com (2603:10b6:a03:33c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Fri, 26 Feb 2021 03:08:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6478e3db-eeaf-42d7-95b3-08d8da03d0d2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469185C3FABE5A0520D120F8E9D9@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIMDaotea6Bj8G/0Z85lexj1JEeOitVljMXzm7E1Jnq3jUBvKj3W32MRWBk7j6lPit3fdTkL4w14g2ia2lI/E95bpOU3XH656Em7E6xgwEKvXWZm039MutT7oZ2acWPGS3ZXROU3mmxyav1pQ2Moq/YsdZvO1v8P1NZtQFdhTULOSfBA0tRKUgk1CUxtb4hUEMfefwwLtPfOwo334XLiAtVb+FQ5DTXfsn0V2kqz9/sOrMO2qJPw5ymCYfnlFz9edLeoSasVGtU77pmpG42KsDa7asUw62cPf9rq1ydahcOz18/jjJ6McF4cHG33BqkCrm6c+QxWYCGsuFbzeduaAYZ+vz+/VQxuzS7xA0mfbSB/qEl8Mwb+/8I9Ybdy8RykYACj1fQajfEgmRxtr5yAU/tn9Qcc4ChoMNUc7zaKOdNEleXHAGizd78bCyL0zpGDKtKX9Ow1JNhB4cumplG2Gqi81CLY7OIYwqjplmUvOn1kNek/BIdK4LS73EIAW2RpyuAc1iqJK3VKiTnZm03xiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(6916009)(5660300002)(83380400001)(478600001)(36916002)(2906002)(316002)(66946007)(55016002)(16526019)(186003)(4326008)(86362001)(66556008)(52116002)(7696005)(8936002)(66476007)(26005)(956004)(8676002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0wz9DOdVIizgbJVY4jFffVd9XDa1ofGyxOTsDIh845LPaSZFfKqrxV1kPoD+?=
 =?us-ascii?Q?lSIf2ZgtPeeLEP5ubxyPlSifj7zmSLbpL1XtRaJ7tnGYVA81+KPPEhfZbLII?=
 =?us-ascii?Q?6hrRiXgi/c5yhdgn+/WrMWGRoxnWE+Yph6ijJn9Y7pEVWqcyf/IK47a2vLFP?=
 =?us-ascii?Q?Qiaiz4oldsbD229BdoOadVlK3xhxMu1domJZNNfCJ9irYHgos7+qE3pTd5gy?=
 =?us-ascii?Q?cmvIJZM9jo3yyjgy8wLDmG38CmT8JGPDoYT6Q/aKQgfVKNHQCx471A3zh/Vq?=
 =?us-ascii?Q?F7gWwnvaJlcDSkx72yvS3tTFBWDHXbVGtLbGkqkiQmPWq8CIsnOqqXM4ZbZx?=
 =?us-ascii?Q?G89fku5HqRYfz1jCGvC8EDQwgsMv06hSFAJE5Lpe5sK3hpz1iDOqn5+LGy+k?=
 =?us-ascii?Q?6xCIKXNXquA/c5saDxF4YR0UuHO6H9oB4iZ4ailwv3r5N19qki6n2PIbDsJv?=
 =?us-ascii?Q?LPy/dKFasnc5nkDQT3tt07254rBbVVGXKJrTCLiK/dBGiZecouamym5ThmGm?=
 =?us-ascii?Q?gGV/FdqSqyCJKDRr6CUNwkWm8eIbjvVd/DPmM3rA9BkUuc2JoJtxBbjCLvzc?=
 =?us-ascii?Q?dWpWRSi1HDzNRcLXfPwWe3WgN+j8qMR7JnFKX9mSjMWJnTu353Pz5fJnZpwL?=
 =?us-ascii?Q?cvUyi77bjtMW0kSaiPw6pY3q/NnyqWZUYd0mbmaIfkM1ofsMGZDmOKEdWRpj?=
 =?us-ascii?Q?CZtS5BsXRdMMnXxTY2VlRxEjZvhqN2CAWc4FaDrGsRaNVpb5odjKpywNEu8m?=
 =?us-ascii?Q?nF45FHZcc/H9J2iiHkjw8Mk3n6VzZr/L5o1C91qI2D5UKds6hAoJR0vvas9d?=
 =?us-ascii?Q?bRiuTzjUmawQSLQSIbps/9YTusrp7d6Uyg/wz8lbaYZ1UliveZAgqLsSIhdV?=
 =?us-ascii?Q?ATFEt10CmB4/IcmIkPgmFGz/kHTjHB4zZ8JW4wSEohhua+YYvArQbjNt7EHe?=
 =?us-ascii?Q?93b2Ke4SLaXsEgTgE3eW/kpPDPMACcCihOWVvklY4lzKk04fh6U32JRJXK0f?=
 =?us-ascii?Q?Vai/WEMABuuT9MYmjYHmlHUDY4gRaoo9bEwvEh+Hq/HRCoaPBGMWu5IjS9IX?=
 =?us-ascii?Q?VGc2hzUOe5LjkxwF/mLILhPujWRLHK5W5CN7uDXjdsjqWpxMe6UW/oWSevqV?=
 =?us-ascii?Q?UtumP5kTlP6m+iAtvn78jB9zqkH+GdtQF3OuhxsPb9tZayVPyp8OonBjaPHZ?=
 =?us-ascii?Q?0hIFHrgafzvEeG2hDUYom52Dt4Pav2Me+4pBNEkq/hVhfgVwXVgwlniGZmeK?=
 =?us-ascii?Q?wp0ZJjhuPeBEPaEbhFfe+VloVV/8yT9tQhCF5WDDoe41xrKzVfFTcDQp9lNN?=
 =?us-ascii?Q?1ixke1JxcmW1JSxBdqd/o+rz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6478e3db-eeaf-42d7-95b3-08d8da03d0d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 03:08:39.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCYZ7OvYBZHTEL2UzmgzQRpHnIAaFUVzN/qp4orkOTq/7wvqFNQ1sX8xFi9QV5S3qFD3RsKuwpNdumVDs5pcYYdPPkltPePrkBZamu0OFPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=980 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> +static u32
> +lpfc_scsi_get_reftag(struct scsi_cmnd *sc)
> +{
> +	sector_t lba;
> +
> +	lba = scsi_get_lba(sc);
> +
> +	/* Now truncate the LBA to 4 bytes, reftag size */
> +	return (u32)(lba & 0xffffffff);
> +}
> +

ref_tag = t10_pi_ref_tag(sc->request);

-- 
Martin K. Petersen	Oracle Linux Engineering
