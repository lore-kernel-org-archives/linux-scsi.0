Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA69C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0495613EC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhEUU7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:59:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41402 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUU7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:59:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKeRgP156549;
        Fri, 21 May 2021 20:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XOSf83UUlGapsVt+bRtxUTLtmDC3apEVfzEV1BXjGZk=;
 b=folWVZEe1WCpGo6ETrf+zCpWyTHDwq0lgEO/+vqhOntBo9hvQp7lBhdEG443OXJ6i9YK
 DAOMpYYoRO8yGDr5vBlv9ocoZHW+fsJuCp2+EmJCOteQJb7zC5KRsJwPHYUsO5rBVCLG
 T5RHme2gujsjz1HUGUtETyw6PCJDRFPEtiuTLiNiuj+Z4JBBcjzk+spaFRHSwsCuvsm7
 60yCzKd8CbxJTiL+Z++BtYDJS3Bguma92MLdPNfVdSFijlqdSf0msAmxqqM3G4Dxtszh
 zOk2PDwrrFfVbV7cXdn9JhRA6w8Tg19FCPuQ5W7dB6KuTBkvH2+F9oJKNJaTB2dhLyxt 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38j3tbru3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:58:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKfiLQ096613;
        Fri, 21 May 2021 20:58:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 38meej2f4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uht2oFjmRXyRnvib84fb2/cZ8ovxnjrBmpJzw4fPS6fAIcTAJOjtCOyRYwKZ61xKWaz4tumDblrmZXhQaQJIvhIcelINxZ3mb3QxOTQm8+HwdbfbJY2ZxUNb+rzi5qKODd1304RjXl/QehKDnFUzKLRLs5ce2ae6X8G1DwGKsb8ZgI98tCvZaB1l4CN+bOSE2YNXtPz0NklsmjQy9Q3gs4LvOpkwDr2mO/77MQ+aPgNFfrjz9s9F8rGzuR1PiKY13nHQUxEHepcZTBUW7j+nBn6i1e85spVEMj/kaH7RqLQBoQhIk/IGewEIWD3ryIw9RsRv29+j9UqXbhLyCnrn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOSf83UUlGapsVt+bRtxUTLtmDC3apEVfzEV1BXjGZk=;
 b=AdubJXOZGVy/Xl2cbW17P/fLh4SwMUUo/GSuXfr9Fng4jjzsbPVg21kyPDg/5QSHhMs4VM7Si+iieuPELl5fndQdIAMbFCZJjFPx1dbD6BbtZhXV8QPSI6liZcxx4lJmaC2V/mZTxbsIzxp5tB/62m82UdrA2acU4KnJApL+hMwRoJUtBTMN9C8WadNIRp1Lg6U/R4h80FgVvqjJwMmNyqdayWtaXlADV18LF4w7BDommUuGnPorCH8lOE0ApRREfDmaclZb+9OHT5UoizOoZ81Y88eE72VVr2ckFLb5AWKo30Hqysv4q1co5SJHDA4XlmCnp1QCFy1XYXQyEOZwJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOSf83UUlGapsVt+bRtxUTLtmDC3apEVfzEV1BXjGZk=;
 b=OEYjUeUzXtjtVzR0XJijH40bpTGxOwT14CsqkRpWqPtTpnQTYB9xLCPybMVP0fo14Qn3yYXURIsQYs291B0t6gOZagO69VMDdGHgXNbXGTXKrWg55iW2GPxv+2TVD2r/xwIEWOA0thksjbeDcmP3hiyveAX9lX5NUIwjwHgoRV8=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 20:58:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:58:14 +0000
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: scsi_transport_fc: Remove double FC_FPORT_DELETED
 in mask creation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg2f3iub.fsf@ca-mkp.ca.oracle.com>
References: <20210520073127.132456-1-dwagner@suse.de>
Date:   Fri, 21 May 2021 16:58:10 -0400
In-Reply-To: <20210520073127.132456-1-dwagner@suse.de> (Daniel Wagner's
        message of "Thu, 20 May 2021 09:31:27 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0131.namprd05.prod.outlook.com
 (2603:10b6:803:42::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0131.namprd05.prod.outlook.com (2603:10b6:803:42::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Fri, 21 May 2021 20:58:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85adfb85-1b15-4bc7-5131-08d91c9b2682
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47096B80E4912FB2C95605D78E299@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VXBPDQg/gyRu2Huc2r6LhDmHgj3jvLXKupdmOsZ6PdhFv0Sq2YQb8HiQeWnGW8MnhptQv1gmRKohjN7WTjXjlTmGLWC5nkJG+JA01s5RmTZlucBjGIPmOGQ5N66rWZHJuzBaEZPz41WiC5SBcQR7uPsRpGTu6IVpxaWDcj/ri77p63udfTOCvZecEgB1A74tye62fqLHlKs4D1UmisqZE140PxowtCI71WtrHbJVVNw7Q3TlsjSGF4qBZz+ms8/ttZLUpqfq3OTK967NZ5nTeuENsy71OgdYppPn7hD8Fpd3ZngazfSJtsK8GiBMhGYz7w20P9mPVE6iVgwh+BfwpaTXGGmsQyAuzrQDIC/mIGOPRleZR3/XCrVZdvIeliesWpfFBusTiWszntARM85Pmt9bISluVuHbdLPKbcYPKjuOaPF7x2bpjjf/YutmST204XyZxR4GIZO7qLStQYrI/0SfQI3Iw5kfWIe6IRTup+wQuGSAvllHigQ7NR639GfCFwSa66/AruWsLqpDepWPnbdFjRyQSOwK2gUrdb+XjHLpQo7RahaHvtue3u6PXmfBy18ktM7CBNwxykgtZygWFSK7PCjDBPebbscVwpobo5ETB5ZdEGsA5yYnROlWhnwCUl8y6uGKpydbFVucnZIDJvDoWrPKJwQzupBetDg6mm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(316002)(66476007)(36916002)(54906003)(7696005)(52116002)(16526019)(8936002)(956004)(186003)(8676002)(4744005)(66556008)(66946007)(86362001)(5660300002)(83380400001)(6916009)(2906002)(478600001)(38100700002)(38350700002)(55016002)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TlZe3S+YC1Th/1cLcx2KqMTqN/3JkD8+AbnPGZBI/JI6ogsAa4ufEtjZs2wC?=
 =?us-ascii?Q?qNOTE1F1VFw5Ls3UZq/ZZD4060r+3zSJBSY3xrG0e03FXHscfjj1XjbO4Fy9?=
 =?us-ascii?Q?vwNcwgQIZAwXCWW9wiH+4fr35zDz7yqgmLWvHz2fOVuMbcFHAflsP8OyBaKm?=
 =?us-ascii?Q?L6xjC5YJRAe/tX4Mc4//kpWfnjU1H2DlWzizTeudKkBObRgAcS0K1BAbY/nY?=
 =?us-ascii?Q?jHRxFfNBgZnUjm20KbskSTju0mGNV5L8IMpn7w0hTw/aUubWxC7piITkXM4S?=
 =?us-ascii?Q?OghDZ/5ebAN4h75QsPqMHGrctHHUopPGoSHNnNpJXVMujBaAQLa7D7OB4WFk?=
 =?us-ascii?Q?thul316iGpUaC9NxDy8k6eaa+16m7lv99gBbSYC779oC6gmfWu63tBdr43gu?=
 =?us-ascii?Q?14m43Pj+698Dr3deuRuGMJJohilsJZmq9hu0+ayzRnw4Y4ssAGZ8OXDER4zx?=
 =?us-ascii?Q?UqKBHKsm8p+URcPOb0lkEbQjv0lZZUW2a10TW5KeHEWj/RNf3QaCTt4lNhDe?=
 =?us-ascii?Q?vu3ixHScNidyVrqrAV7SM9cGWize5I5E2Xu0dmQjeSJ5hW3B04YLIDATrpNy?=
 =?us-ascii?Q?7VLJjpaSDaSDMpE0doVeA1uD3g6PHAva+EmPsoZBTg5p9OXt+uTDkUf12dIx?=
 =?us-ascii?Q?mBjckyZPefsf+JGCXFu/68nkRpLi9LQm4cD3L4X6nuB80iU9InxXT11b24uz?=
 =?us-ascii?Q?W85vEKGaAoRyh4EfR36hHNQ7p0pwJ5kCshWMqH79Fs+6Rtfd7GBQOK554VnK?=
 =?us-ascii?Q?n5mpW5Kn5Ib0ZJ3r27ARGfe24CnHmP9/II3eYsDeCXkzT1YS0CiPOHrwoURR?=
 =?us-ascii?Q?xDZ95cymT1DRb82DWKqfi+nRAOh3NIWnFPHTyBY7uUhte/j813MozpHdzKq7?=
 =?us-ascii?Q?EpQMcqz9xR+ziLoKUx9hLr+UIzNlq2lc8J+hc1fBnSwIjpl4w/WX7ZwxBmGz?=
 =?us-ascii?Q?zNZI1AN1g+vk0ZwtKND3SUpMuqrQzGR0llIWuVBmBjHKdrUW9ArxtvzXKv06?=
 =?us-ascii?Q?m5j/UeJvNMp+Q308kGwHvldnjfEiQjRO+qd9CgX26fG/RWbOcytcVUFB2OIl?=
 =?us-ascii?Q?79rK+7eNrNBYiBcJcywcBFdbqcWGpmUJEuFrsTtEBSCXoepZ1/qz5O0Z5HZs?=
 =?us-ascii?Q?hS4ELZNo9C+FY7oK+qJGusDLLuu9tHULvr01S4GutBtnJGXWYg54jtgQ9R/y?=
 =?us-ascii?Q?q27HbBzpzoDOmiy8AlaVcc9Ky/NsDPFMZZeHIlOsH29NcHnrubi4q9PLiXOY?=
 =?us-ascii?Q?/i7iro9qTKg524hvauDHKJxkXFMDvk9F3HBcojroNKc3jYLrl9G82xjg1t9B?=
 =?us-ascii?Q?6rWYAIBOxwiXaw2iHl+TaaVf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85adfb85-1b15-4bc7-5131-08d91c9b2682
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:58:14.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7SnoIJ9kKWANtm+h4Un39oc+Go7R3Q7yLJLq+m2zZXG4MktI8QJF0l4HjhGFV9Q2cU79c6bbixwqRDA8bqTEG4xNBkIBKFg54lLNZ5C7L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210113
X-Proofpoint-ORIG-GUID: AA4TySuT5X-f1L7jcIdjsFMRDOJhV2Vn
X-Proofpoint-GUID: AA4TySuT5X-f1L7jcIdjsFMRDOJhV2Vn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> Remove the double listed FC_FPORT_DELETING from the mask creation.
>
> Commit 260f4aeddb48 ("scsi: scsi_transport_fc: return -EBUSY for
> deleted vport") added VC_VPORT_DELETING to the flag masks. This is not
> necessary as FC_FPORT_DEL is defined as VC_FPORT_DELETED |
> FC_FPORT_DELETING.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
