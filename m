Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FA1C433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58CFA61955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhC3Dzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhC3DzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3kLH2142240;
        Tue, 30 Mar 2021 03:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=u3HYOUq8oEs+zGpWZvXlUTbBd1UDVDD2ap00h15iJRM=;
 b=LL7JVOcwo7qaSEdI1SZC1GyT0lCJ4k8uSdQSX4arsGmXl9x/AcdBL7h3yRlUg5etTvqu
 EmhgxyESx9yI5fKZSQKLVR37OYcPA3UNRVhWuLQDIH87EvkjAogHbxdA6drQGjY8U9TW
 n2jYMk3xnFgRnR/VGqh5V9SP8MQbCU+EKhfM48vKriLSArH2aHkyQ4BfuHP29KNi4spw
 1Xr0tsTOwN8SiyXSMVJwkDZ6I9KQ5bHqc+omHdQFeqFAJgA00QzgkbRqOwFkBL1AW9PX
 pv8FdvZOqGF9LJN7XfxmypZk1C0e3uHM1sMbe1AdsclvpLY6y02ooR8cMap7Coxv8gf/ /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37hv4r5k2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3ijJV193039;
        Tue, 30 Mar 2021 03:54:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 37jekxyv1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nW+hI8VDCbFREeRIIQmmd+Hxa85t08mINfkNaXwWTdpv7j5yiwNVJFRUf8Q+dQvaCeEtovieNNoFuZSS18CGDcsEgASPhRN09mpCrGaUNRlKIgkHvRf33YnnjsHiajgDdoNehejZbUgVDc32v4waCZYueTtvXzZAjdVNpbacpkgVaCz5SutxsKYvnHpi9SbRvtjOEThwy54s0bdDZzjwGU273NVcvugBAOJHqRVTWVyhml+LCDSETXJxKLbzd4565jjWT406hvpYMtHdFX56M61gF9hJiXci0/svT7rde7vlfujsmCkJOzFb+QVUKSgCLxcRvPvihAnz8DRdgNFdww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3HYOUq8oEs+zGpWZvXlUTbBd1UDVDD2ap00h15iJRM=;
 b=WCZT/3DG+1oDEEwpcEgWgHQ4KXijcwZlZ2S0U2w2/+8PYcV1GoitG70t6nLHqLeSc+puipKQe0Nh0N3Jkq56Nqf5Mn7cQiO6wlsvxBQ3GTBR6d3SF1cK7E6NJCdvg/ojBERMutkhEYedRuD3/1t07VHi2q54RJ73GmlrPEWSRmke9W0BouzMucRJwU2nzzMuBzUkFtmY7TK/y4X92RPwwt8lpocHiGAO3qN/hYoAmdVCAkUxHK1DkX4sIZpEQ48Gghz0Hi63vmFglgpCEZlLwnxSAjJ9Es3Ji2z10dRAnu9KWmOThupB7wY7O8mboNcXRrYxTLILVumj4EVqlie0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3HYOUq8oEs+zGpWZvXlUTbBd1UDVDD2ap00h15iJRM=;
 b=odQUudWCcMqTg70U5iusbdmkU/kNMZGSlKCknUSDe416t75GwCh2Nif79Z5RBfhl3htDkxvz1x4/1Dnc1buCArt668e3wXr6pNjPPqCi7OV398JCeEyjxr5duITt/O8jyXnJQpEDJISv8wkjI7Q7YHMR6sbO09ufxVRAjq0sVkU=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:54:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:54:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Perches <joe@perches.com>,
        Viswas G <Viswas.G@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-scsi@vger.kernel.org,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] scsi: pm8001: avoid -Wrestrict warning
Date:   Mon, 29 Mar 2021 23:54:31 -0400
Message-Id: <161707636883.29267.13458445568299805895.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210323125458.1825564-1-arnd@kernel.org>
References: <20210323125458.1825564-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:54:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f451f16e-e116-4691-7f31-08d8f32f942b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758DE8BE22490BEE41DF72B8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P0r8OatTx9UMUyQaw9r8ljj3PWRhGF/lFbk+wYC5lIiT+KG/nCxJpDrUY3wYGgT0KroH0+Isj6tuMq78c9QPZRxT2qJCe5eb2H8T7UMq7yatAlIN09KTU5lHOVKJmBLOHmQy8GeUQix4ljTSSw3oPtxaKQK+3Mydijnwe0hC5CKgL1Dxca+Pt6PnBLBuBSgfN/GLnuWgmotv7VSgnGOhLu6CqU9cTi1+bolDctwRTSBeivabcZKuOq0iXqvY5HzDTmhNYBsHgKnaD/qR2J054Mghcj2cDxobFPqxLB4Ojn7umStGttbUsArTIqXrXkPYOq/zq44/DdcMdQynpF/zyVqQ0x2ClBnVkvJ+27Tfk3WlcsvZcPURdzVzk0p3PzVuvm70aaYvzBHgjjqhp2mpmhC7uKf63k+tEadMTypSzpEGuKbuoHl77Rqvq6GRtC2a2mnxUT3hl40c+xY0MXwfdhwgRkf02iRSmGZaBuqsdjPeb8kC4lIepxbtbxfbGHH+YHxrSgqMCSLYAyeT/2/+ki8RxMBZ4neqEOOrHhXU3MsQgW5F9+0ra+3g72HWe91qvmjpVxwnJMuz4pl5y0MulXafhrgZX738r45KHDPZgh1fXlsK/YwcsGojvNXTOdzRpVNcocN08oL0J2fO2AZtRjzhcAOWqw/KV94G1oP1WzU1ReZDqLsrxKYn3tktM9SPFkNZPaQobEw2XPfJPlaHxsn/ER6t19p96kxi5ON8ot4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(4744005)(956004)(6486002)(110136005)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(54906003)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RkpYRkJGK0NSTmVxMzh4UTBBZGhEa2RTbGFHUFQ5dDVRQk5WUjhlVUZXOWFs?=
 =?utf-8?B?WXJuTzltT0ljZTJXWGwrdlZ5UElUZWg5SXJhWUV6NzloKy95WWVNazdjWGEy?=
 =?utf-8?B?R01zRnVwdit0Z2Fzc0tMWHBPaDQrbGwxbGp1U3dqU3hQVVpPNXN0TWxhRUla?=
 =?utf-8?B?djZXSW11NTdyTlRkNjNjYml0Yk1ldVB0Mld2bno2R1A5L3NQb3BIVVAraHFj?=
 =?utf-8?B?eEVXa0F6eHR4UTIrRC96TG9iRWNOcWt5alk0Z05zOUpsbDEycHhodExKSjND?=
 =?utf-8?B?bW9VWmhKL2t5QWZpOTBSNVJxVEQrdllHUUk2WkI3L0xEWW1DaENHMTNhRkZ4?=
 =?utf-8?B?bWU0TC9uMkhtOU9WRHFWaDQ0bUF1V2llZE5MR0hOczIrM21wSW9KQkFES2Ey?=
 =?utf-8?B?ckxNYkpoRWJCdDdIWE1kRHRBYUtWbUtYbTBFSXA4UExvbVdTdGRDWmZYeUhJ?=
 =?utf-8?B?bzJOeUtsWGpxbGtINmhhWDVvUXhMQzduTWxGZ2VBcXRGM01DWXpHVkJvQmNr?=
 =?utf-8?B?ckRCbTh1MnRjbWFjM04yMjAxeWQ1aVdVblEwU0pRT212SUM3TEh2RVNoU1pL?=
 =?utf-8?B?bjhUNElTTnRtT2hSVi9vOUQ1K0ZUMlc1dVM4QW9ha0p1QjBUTkFTdXExK282?=
 =?utf-8?B?MTFjaVpKcjlybENlenB3ci9BaHkwNkR0b0NoeVQwdkRaNjFXcUZsVS9BS0xq?=
 =?utf-8?B?US9iQitPQjNPMUdSVElhVjZpeCtuQ3V3WTNiM3Q3Vm4yVWNLeWlXV2xhUzBV?=
 =?utf-8?B?Z3BlQVZRT08zZ29qMkZ6TzZxTzNQWXJBNXp2N2hQQ0hZZ2Z1MjhYSXhmVjN6?=
 =?utf-8?B?NXBnS3F6ZzIzUzMxeE01ajhYTWZZNkdFUUZGdWJ0N1BmUk5nY2paQ0d2bTJw?=
 =?utf-8?B?OGJTMU41YWYwRWpQTUlKWERxQlV2YTZqTDRNelA1c0wrc3ZDZWE5QzlERWkz?=
 =?utf-8?B?SlNhYnU3OHlWSWRWL1pLVXN6VTdkbi9uOTA0ZmRLWkV2LzU3Q0ZoeGJtc1M5?=
 =?utf-8?B?eFJuQ09temVGYWozN3FQV0V1Y0ZUSWdGSmZWNVBuQkZWTlptUk5vYkJDZmNH?=
 =?utf-8?B?d3FnaFU4TXBmWUtQZDlpQU9veHl3SnZubmV6T1pOeUJzZkk3d2xJY0VZNzdV?=
 =?utf-8?B?TkZDWWJWQ0RCK3JOajBPUjg4alZnaVRPM0R5QWc0eGI4UGxaR3R2M3ZydnhU?=
 =?utf-8?B?OWxBZlpwSFJ0NGpBc2E2Q21KQXY3SnE5S0ZBQmlJRVJHZ1VOY0UvNHcwRk8w?=
 =?utf-8?B?d2VPVjByL3FnRmtpQjJWQStUQUxkUThySEhXV1J3aE5FcDFBcHFtL3BxSjdO?=
 =?utf-8?B?bjdJblRQVjh2dWVEZDN1Q1pYV1NaVDhDTmY4d1NyV3VlTE5aOW5FWG9TaTFt?=
 =?utf-8?B?VlVNOStYOUVuQmw0UUVZRzJSR2RFc0tRY3B4U1c1a0tCQXorSHEyRnpqWFYy?=
 =?utf-8?B?a0FOZjY1ODlBR01oTHNPSEhPQlZrSHVlL1M0cHJETWtSb2Y3MlEwNzNvUzB6?=
 =?utf-8?B?UFlwaCtwbDgzRjRrMHNCUTA1empVYUdodjRpTjRwclc1U1MwaHBYUk10RVhO?=
 =?utf-8?B?YnJWQ3FsQWhJSllDRmlsUGxiSncrOFQzR0RCdk0wWDQrdWkxR0hwTVlGb0pN?=
 =?utf-8?B?QUNSWTlMSitVTTZocEJLYW90bzdGaGFoZ0ZDbXJRdkcvdnlZcndRYXNKRU5p?=
 =?utf-8?B?TWlzb01ZTXNhb3ZEQVFRM3crU0xzcHV6TGpDaG4rY2MwQnY5T2g5UzZwYm1Z?=
 =?utf-8?Q?su008zZcR2cBM31iMe3cEBEeJBNevmyv/qPXik6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f451f16e-e116-4691-7f31-08d8f32f942b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:54:54.9986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbeZQEG+pYntzv36HUDgqYlTJsGot+xWpry2EXoEEQE/DyCPm7QbGd6U8z/QaNFMUGQ8eix057CWnp6Gl5h8uZXRH3YV+Xd0XmojZZVND9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: Ah2VZeZaKSoT0Fr7TmunUbgsvrsa8A9o
X-Proofpoint-GUID: Ah2VZeZaKSoT0Fr7TmunUbgsvrsa8A9o
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Mar 2021 13:54:23 +0100, Arnd Bergmann wrote:

> On some configurations, gcc warns about overlapping source and
> destination arguments to snprintf:
> 
> drivers/scsi/pm8001/pm8001_init.c: In function 'pm8001_request_msix':
> drivers/scsi/pm8001/pm8001_init.c:977:3: error: 'snprintf' argument 4 may overlap destination object 'pm8001_ha' [-Werror=restrict]
>   977 |   snprintf(drvname, len, "%s-%d", pm8001_ha->name, i);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/pm8001/pm8001_init.c:962:56: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>   962 | static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
>       |                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: pm8001: avoid -Wrestrict warning
      https://git.kernel.org/mkp/scsi/c/c2255ece2be2

-- 
Martin K. Petersen	Oracle Linux Engineering
