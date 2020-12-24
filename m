Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB3EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 09:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2698E22D6E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 09:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgLXJgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 04:36:17 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8497 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLXJgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 04:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608802576; x=1640338576;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vrNc2wBP2PT3UaYKr9kUJ0t1M9wh8iibc0dMJuq3B2w=;
  b=EYJ4vO2v2CwrHJG/Oykbm3C+q2C5mb4bloi38WWm57U+7jvSmQCLW4Aq
   TDx7iyc121E6uAKUA2d9jGWYmyBznzY6qmFitOtCHH9fFCBnMmvf0K17F
   zb5wnVEOOJGuEePS65TUKpJ7Hnrg19h3BG2ZlAb6rt2joq8AMXaEybgv6
   CN5hUj3r9k2dJc9oPGfSDQlcMVHJtA7l+KSojOGBZmHDNR7rrjaVJZptk
   n5ypDGtGd5TyQeaI0OMYbVAHQtaqQk4DvyJzwqObLu8VGBAKyYpMfDeUF
   zAbMjds0USZ/zuTynosjiIP5qq53vjW/mnJ7ZMxhX7Zr1RrcX88OY14HZ
   w==;
IronPort-SDR: 5Hy7SwMU8sE2i3khHFyKRj/KOGUXB+jtTAnCQMlkTff/H0AXideO0TclkBMHU4kwbhP1WxK9Jy
 Gy1bSsWi/lfMiHebQ4kJGxayFg9rU07SXKXYuznsQbi0WQjzrcfGF5O5lxuhQTVBvsDWtyAbLB
 smfvCHLHR2scPR/j4GQo+Rcz30rls8fVR8oHhkOOkjsk3DJH36F5/8176AsLtswyV5lF47iOz/
 LOGpzE8RKN0D048zGjpP6OnChpYYQBCvJbvvtMeN+UuxJAs0awoDPznE1FuxvmewURaK+tMP0c
 f44=
X-IronPort-AV: E=Sophos;i="5.78,444,1599494400"; 
   d="scan'208";a="157167944"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 24 Dec 2020 17:35:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpFpKz7J6m481P3vmtfTQIKW+yKtbd0MPnDdq6SfkuPDcmk2H8k535skdmQGrSeDG3MnQZwUz/ZfeNKNpIPzyCUOo+e/+AqECoer2GNs2dgaThOClIRWw6sIAH7f3bpaq+j9USkGSBUssrsWkfgg9UV+lMJmkZTEaAxtFEKMxkOPY5yd3Va7SQtglK2ew5qa/hljZaV8xpkN93o1uyxnVjvFuLoMlcYoSAmXGkZtrlSmLmthKn5BZZkX61gCOduNj9LpRluXtqsW/zT+Na2Qp6KTXXDvw2Ln7owoQ8uui9GePS0smriSlFKgfpZ+/uj6OcuVb1dOky3sl+KbqFqOAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrNc2wBP2PT3UaYKr9kUJ0t1M9wh8iibc0dMJuq3B2w=;
 b=YQPJcn40Ct1kd4kIzmlUIkNngXRDuRB+/cNwJbA+OeUT2oLYIupZLS/WIb1psoORReSWZMQfpuFPzfCfvl2OSw1aG0aHfKNtp+1G7/lFqv58vzPuvfWo3VlU4nIJrwJ4/+DaP9bk1ORJoXEnfLIUVHCEvT9AibgO/dv+bTEZbfHOFVSrxvOrpCOCcfr85D6/TfLduPfT5BflMbzyiouqqj0hZfypZLU8YFfCH4grNhnXTMYPrVBNtR4h/r95JX+asi8LwxPTSw/RbLaDt573KLmSTTQ2+SVFWWludzeiKH+o1K2CgZdWVM3ARtJF1qjpLIOdqADZ+kQ4y9WPi6b2Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrNc2wBP2PT3UaYKr9kUJ0t1M9wh8iibc0dMJuq3B2w=;
 b=FJIsFGJpjDnsLHe8nG/bNgYnHDen/6SzZEFzCZ/xpdwJPaW6thwPfiDGsmBvwF4nTc1S001PXSQNcTLa4gryvV9cohHOeI6snMqdgmr8TYezmVxsbz2UBNf8ECSS3ewhwngfuuBS2ElWdnT5kGqW1bCGZCL8thWdrKcgMCMKv5E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.27; Thu, 24 Dec 2020 09:35:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3700.026; Thu, 24 Dec 2020
 09:35:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Replace sprintf and snprintf with
 sysfs_emit
Thread-Topic: [PATCH v1 1/2] scsi: ufs: Replace sprintf and snprintf with
 sysfs_emit
Thread-Index: AQHW2XP7vCTQxnez7E6lA1ILp1fWoaoF/P7g
Date:   Thu, 24 Dec 2020 09:35:07 +0000
Message-ID: <DM6PR04MB65759462C8FE3E5C32907C49FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201223213826.20252-1-huobean@gmail.com>
 <20201223213826.20252-2-huobean@gmail.com>
In-Reply-To: <20201223213826.20252-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f31202c-4fb2-4cd8-0990-08d8a7ef3364
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-microsoft-antispam-prvs: <DM6PR04MB4154690D2C05BFAF86D62AFBFCDD0@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w3PwVqKc0eaTm1Ty0GzhTIs2gTlBJB01HvJqVp0sVoJ55RtVXCp7JNzSx1McZ9lpS4NOhC9QAr9Bk4+QLvaqq7mk1MSBlf0Fxk1jw8IkJTTiJoTOXATW9RpB2QcpEFwmTDLiz6Ab+Ia0/VrGhWmd43cBB+p53WgaqFLiDkRq37/pGD0WwxYxfBDvwGmuQqEYc/JOZtaUoTv2oZ/8tbqpJKo+P2a3BTvW33VP044Xc38Q2PJEUrMtyPwYLOG2cZF0N725O8r+oVSGxrXvRWI0f+JamcFusKNU1nRj4MWjvkQonLrAilSLtOp0cjMiRmwSu8uNRlAE5uHxogrXeTZKUD3Asx4Y18FDORXEm4l51QFv2SkbwpyKPeb2MFfGlwvJp3dfJggA4QCE5CbTnEh7NLSih16yvfJ5iezsvuc2XoDotAhgfbeYt6WQE/GEChA7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(52536014)(5660300002)(2906002)(558084003)(64756008)(110136005)(66946007)(33656002)(8936002)(66556008)(71200400001)(54906003)(478600001)(66446008)(66476007)(76116006)(7416002)(6506007)(7696005)(4326008)(921005)(9686003)(316002)(86362001)(186003)(55016002)(8676002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qb4MXxq0pcz5ql7qzAdPXfkcl+P6PQYMkRxA2Q7qaInJPySvdEjwZ9s/X7sP?=
 =?us-ascii?Q?ZVSWtFhjqoT69/UZJHdfCPF4Pc+WCZ6WVIshWjbrkLppMdwvvFfdzcX/1Osa?=
 =?us-ascii?Q?lMgCXt7m+kHBUbZKEBsF2bMB331Tcg5cAFB/paGGrcwynI0MtGFb2qgo7dQf?=
 =?us-ascii?Q?w7HOXAp4cBHubq6Sq/QqIZPa4+Nno84v6h3qz9Hu98EvJfSirF0/S1z39WFI?=
 =?us-ascii?Q?XJFYehQAgxNY7z36iA14lbcKMAB3ONazU4c8WC1wsLwPG3R3wJxWIAM/nHHQ?=
 =?us-ascii?Q?GcyX59MpXOPMPGgCO0TUL6pSgOyWNhFT4k3mNuS1WypiDMVWDS3Py0ajL8qv?=
 =?us-ascii?Q?kF2AcrqD6vDn8J6iD+XWu12SHVaHRkoE4nWYlXn42UivgNL01iG9rD6bhZgk?=
 =?us-ascii?Q?PPiiunT4TGVikopIMCsdgR9etKUFqr+/1qghw24yVxyg4c/AxLb/uCFmylRX?=
 =?us-ascii?Q?kT6aHZJR0/hrDAFt16RAfJQQkxNEQwdaXlSHRyLOTxEunnmChdN/MZEgLHwu?=
 =?us-ascii?Q?Dh8KHZ+1PvP0pKUZOsfjWWi4JZ0fmck5axZGxwvNcjv52Jvm1UK140jES+Pf?=
 =?us-ascii?Q?Sq8CC5ykBFu1Gpg87+Zgk4lDu9ZlE3fP2dSi8jT73GpoF4j2PATh0nGHoB1W?=
 =?us-ascii?Q?BdgRNj812jmR7fbAMuKaU5yJyE7dxwXtqTqYlJmPNdTyJ6fZmvZvHg3O3n/p?=
 =?us-ascii?Q?O1YaSEJPLCfN2HKLcde2a6dIJPV8tRDg/qDCxMNO13MMGN4GyYYGbowG5p3r?=
 =?us-ascii?Q?VP/Xtwh04w1HR7hpwuSt0RY2OD3iE+sFRasRGNueVTxenpLSUpzNptN8mz1q?=
 =?us-ascii?Q?04Ujawu9u9xOlXv2vlbc6l7QaftBb0xsVredi/EPKt3mKBSuiWz2FQ3wYmfH?=
 =?us-ascii?Q?N0aPo7lZi6GmbkPRwKkyU8KuVratLWThIyd7C65S7v7uiWOn2mN6xsEoh1Na?=
 =?us-ascii?Q?zpws+oodYv/U0j5eh9qSltJRAHs1+XvMO2cP+WvqgJg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f31202c-4fb2-4cd8-0990-08d8a7ef3364
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2020 09:35:07.3474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yLt6cnQObHNwz3FYtvnJoIgknoGFI6G0N5asMaiVH7BQD4Cj3iBwjIiAPt+FMaa7ninGy/DkO/23b6ZtJtdtcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> sprintf and snprintf may cause output defect in sysfs content, it is
> better to use new added sysfs_emit function which knows the size of the
> temporary buffer.
>=20
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
