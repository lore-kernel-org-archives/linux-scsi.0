Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BD3C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C2361284
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhEZEG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:06:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhEZEGZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:06:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q40HV5185090;
        Wed, 26 May 2021 04:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MnJBqlv/sxdlpvDAAsyw0Zv+zS4yA0siA6MB8R02ilg=;
 b=BiJicE5zjbkEdbFCJJtx4MQQrf+pQMJWcdsj1CPCv3YpeL5NhOBEYBBgFcdHzjZ58er+
 IjOnMEWzndedBw8DsTWGhVbeZ4/JmWzuPcM6Sg9+dql9FOBupuXFfOsHwxLRRts8F6Hf
 Aei3NNlHSPvcCVpoKT0Bu5OuUyk5NaTeSU55CX7RUm188PpCt8noi1E/NIKNkohDpkYy
 qwUsl6k+62Pkxn9cT9IGkre1vXkzsf/9zK3zADE4DV9g/rRJ6jEUdUPTy7vx4qyhJc6X
 KnxxVNAdbtrp/5JkDNIPfPMO3uWSUrQM3Y9OPSfgvHnRTwpAHfWDYsJz2JsD3oUAYcfZ FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcftbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:04:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q404rN156128;
        Wed, 26 May 2021 04:04:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3030.oracle.com with ESMTP id 38pr0ccjwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKooLRAahlHdqT8NismeSaxUn9Mq5RT+0ESor5zT8KsalGyaHZ3Q6XHzgR2EutVNgIu1bLMlqouicDajZr0+QY0n+izlRHiclW6AvWK6QPtGPvlZ41QzZ7jkZFUK7pISDjZpXDdKdpKd8ZjLTUzqENqBNB5mgHNyD29dQlQlN9+oFpNaWoFPnDTw+S1+Nx1TTUpB9xZdNd/mUG21TTbjtmAorsfgOAjdir8XhYKk9ZF3xZy5gND1eT3VwCI1s1DnA5MZadzYFLRtxV+VCrVYA3Hd7J1GtpnvsoGUuJNoKMz1D1ZZcsW7PqOzX85yPza+a3AYDvjRAPg9ObNWp0W8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnJBqlv/sxdlpvDAAsyw0Zv+zS4yA0siA6MB8R02ilg=;
 b=eeOwc7PLJ8Ee0ngBIzMXhTDC2QuHaJwXiELoMgiPCjmNkpGCONoUYJFcdAir5dpgkfBtM+XPv6938o401z1vY3KUKNFNnPtx2XnvZQEWe54d56LMDCcl423VTulcHrCpfdiINY8jis+hJnEsX+G8nmcqvxKlFSZ2IB5mDvI6nVIW+ZYiTSUz/GFas4AKvxcRG0xLCPAVi5SJ35tGu0h60BW4H2whFa2up3vgQv8W6K8dTEFTR6Agu6UEBE0WdZkpbwAbK7sVtSdyWFch/iAzm0jSWKCQyyKCw2nwCW2z4+JmLT++A/IQksn+VcaGlXTzvk0302o9G/f4EmanY8/5Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnJBqlv/sxdlpvDAAsyw0Zv+zS4yA0siA6MB8R02ilg=;
 b=fmZVlKEF3IS2GT9eHksiMrSfjg4Y6NBWtDXFLraMIO8A/ss9uJWS/G27qhgqYYKAFYfBqS5w27WS5yvXpmbhdFEjDscrukQRbeKyw7BRI542lJRC1EHUmwufWosqczIzdGn+KYhEQ6UaZDXEBXon+kgWQeH2w2oF8z4gUk7mVQg=
Authentication-Results: philpotter.co.uk; dkim=none (message not signed)
 header.d=none;philpotter.co.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:04:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:04:49 +0000
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: skip checks when media is present if
 sd_read_capacity reports zero
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1huw3xu.fsf@ca-mkp.ca.oracle.com>
References: <20210506073610.33867-1-phil@philpotter.co.uk>
        <yq1pmxj526p.fsf@ca-mkp.ca.oracle.com>
        <CAA=Fs0ndZNqz-Tdhxxi6GFqyinAoS9v0syGrJf=uR768FcuuDA@mail.gmail.com>
Date:   Wed, 26 May 2021 00:04:46 -0400
In-Reply-To: <CAA=Fs0ndZNqz-Tdhxxi6GFqyinAoS9v0syGrJf=uR768FcuuDA@mail.gmail.com>
        (Phillip Potter's message of "Sun, 23 May 2021 01:06:32 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 04:04:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 878cc35c-dcb6-41af-d94f-08d91ffb6817
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4549B080DBA9527606B6A3D68E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8H+AdIop+m5fE5BPCiLNeI+pY1e2xpL/fAdjF8d48Ec6B9Ro+BNF+V8IF/NCstikWll+cjaxL9i/+AAxokindMXSuyYMob9mkGOe18FQ1MlCM+/OZwsILHJmX77g8bRcyuBGRTYqhMbDmthOu37T5piHApE0+xY8xuRAm0JE0ZJz5S4TREO8MF69/WlHM8RLNs9dxBCX3pCw4YuWrwbME8u5IZXx+c0JoXFLBAAej0gyHETSjEES5KLFDXwm6F0q6c8KsPRhi/Cn5rcTgN2vIsKr06aBzcYIBnYV+p76Q12F373YrmhYjUQ50p1ZuSFofHYyM+uS/LgL9ZFRypsgquQ0kidWFRNE9UupES9TI+cPdM7rZuj8XRZ9ziUxY/c/aB0A6vu/ZanBmGa+c3BKT1E1vUCn2ub7oYF5kxOYIe/w2rbU+aDSuXQbq058dvluRSakUFlkYlsVLnpq41AoKdyedwQyA8+XRTx/0sCxIhZfxsmR2A0A75b0ECAfS9MO9TUs2mML5MZ6SwTtSEDRyXDemW/q/I0+WhQECfihVOJ+b1rbcXc+ulpX/zDvs6yicCjr4SGCvmReFumo7H5XQEY6r9RHhqZM3ubn8nLrPXls5NOjbwdMV1nGm37HG5+KYl9iVTwypChYj7CRPce6vJU/HUtns6Dl1TgJE4Oyls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(366004)(346002)(2906002)(186003)(6916009)(26005)(7696005)(316002)(36916002)(8676002)(8936002)(16526019)(55016002)(66476007)(52116002)(66946007)(83380400001)(478600001)(66556008)(38100700002)(86362001)(38350700002)(54906003)(956004)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SyzTeWFzYEJAwFQ1Qz/h7EQajOKQDjvpjbJd96cm4+Dlcoas0uUC/mQzOA2U?=
 =?us-ascii?Q?fh8yaWOifZg9AeYQEo1QmEynQg1dMrfFZQSFc551+SVlHIC918ry0TK7KhFc?=
 =?us-ascii?Q?+OQs2SOBty2yYSJYHRTF9ArsMQtQn/ZNdzJLn2EcCu4nwUm5ZYOKVLnWhBPq?=
 =?us-ascii?Q?ldpaSMSGMw/NjUwMuFSE73UJqe0lVxdP1WSxsdJDXgOL3ozFnRixs70LoLtB?=
 =?us-ascii?Q?UCymzH5DROdjWRp4keGnFivehFn2JHMKzeuDZcWyuHSedzeeutZ9otRDOA/g?=
 =?us-ascii?Q?AxgdqXtfHoevZx3dO6FOXoxwaAa3BIS4FoO2fuVd4ros2dhxK9lqWG3pumfU?=
 =?us-ascii?Q?HDjdMc9dkggZeDJn1XL6sdN6fcxXcj8hfQ/lNt0D1ufsKuws6l8upt0Jkbxq?=
 =?us-ascii?Q?QckfhQUs/Qt/NZrIB4NsYOsNUvundZrSxFS6+6Ceo+iWRkgjfdPAR2g99cfN?=
 =?us-ascii?Q?mE0x0zJyYc8XkMCNW09R2709DhPw1cAkalY2uZh0jjhpc33PQ50NmA1P5rtG?=
 =?us-ascii?Q?8Y2+bkfVyjCUyjtSSYsWWUJbNFWj+YIeqeSysPdZGD2HWZIcvIhiNtZFhIwT?=
 =?us-ascii?Q?B7KO/S8Y7Rpq4lVIsARhGH9YccycaFosLG7FjQdv7U8mZUjtZvQGbbn2NcjZ?=
 =?us-ascii?Q?7rd+NxBgkemxH6oZVFAOq3BYK1wpFE9QPUAGYnSM1mX8HfeoodzrId7Ikuc6?=
 =?us-ascii?Q?5sRkPi+t9xDVeLkaW6pr/IdWGDe7AaYrXcqmopvVsAjJRo0ug+6hTpskCu3s?=
 =?us-ascii?Q?GvU2+2R8iuTJ/8l6Ih8dQRTL07EcYTdTVIt3X+FUJGh4GYLXqrtf47qJb5Co?=
 =?us-ascii?Q?3m/IxDSDl1HzoE6tuU/JoCgxL5s+JjThAX2TTuBKiT1th0e0qeXF9x0wyGT2?=
 =?us-ascii?Q?UZEyBUtc/aPoYYkXm2Sp0NgwMqXMDikbI9uphBXjzQ/0UIqZ5/XXrtWo3T9I?=
 =?us-ascii?Q?9SISoeqQlcSJjXcM90W0R0yFVxWLZgKjjgYTzoF0WZi6w9TG/zdEOtB4Xg9e?=
 =?us-ascii?Q?z3yxgUCE369lem76n3lZk9+rPX4JPPXHlRUtjFr0ruKdM2aR+8BUMrGHp50H?=
 =?us-ascii?Q?KS6z3kQwE25W8lUlswMRMDbbRV/WQmlT14LpM/DMw9C4vpaDljaSjYmIGaP8?=
 =?us-ascii?Q?3pDIXWcpsk5cUSOIoYZT5k196D/bJepSM5VfU6dQ+ADRUAsNpMZct54VYMqC?=
 =?us-ascii?Q?tZ04mBdkSObCwBPuZGQzzeUpiDxlXYMWhYnn126dQnMS9+2G+oBsZ1OLXafO?=
 =?us-ascii?Q?sr2mqtwUljkLQEEqp4YB3SM58Fi/+r94VvvaoHo1Ne8I89p88zXx/S+mKsUK?=
 =?us-ascii?Q?vJaaGJ5OdnEI/LEN5xzkhN1T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878cc35c-dcb6-41af-d94f-08d91ffb6817
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:04:49.5203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEooBrrzAy8UvsMTdQJn/vecsRuDIPq38MqxveAqaweeS9f/f80nj3LBJoB2FIyMWLn8dnTtWuxAZur2rZ/xbqZdw4gTbfwtRMpF2bFZyY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
X-Proofpoint-ORIG-GUID: VP7Br4P1s-VU1FwI1Sovs2ifdAzBSkbr
X-Proofpoint-GUID: VP7Br4P1s-VU1FwI1Sovs2ifdAzBSkbr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Phillip,

> It occurred to me that a capacity of zero for a media which is present
> would make the following function calls/checks invalid, hence the
> motivation for my patch, as skipping all those checks with such a size
> prevents this bug.

Yes and no. In theory most of these are orthogonal to what the reported
capacity is. But obviously the values reported are not terribly useful
if capacity is zero.

> Another thing I noticed was that (unless I'm reading this wrong which
> is certainly possible) the buffer is never fully memset. It is
> allocated to be 512 bytes in size (as SD_BUF_SIZE) and yet
> sd_do_mode_sense/scsi_mode_sense is never called with a len param of
> this size but in fact much lower.

Correct. To avoid a bazillion different allocations in the device
discovery path we allocate one buffer that the various functions then
take turns using. With suitable lengths passed in based on what the
protocol defines. I don't know if KMSAN is smart enough to handle that
scenario?

If it is then there must be a real problem lurking somewhere in the
discovery path. I would prefer to track that down (as opposed to masking
the problem by exiting early if capacity is zero).

-- 
Martin K. Petersen	Oracle Linux Engineering
