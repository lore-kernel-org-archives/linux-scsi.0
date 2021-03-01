Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD955C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7853264D90
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 10:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhCAKrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:47:09 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:53930 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhCAKqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 05:46:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614595699; x=1646131699;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3otifNW+0st0GwuhkLIQaF7EKSAJjffuq303i0K8mlk=;
  b=qhXkWxsB3vWSBxMI2BtzZkklOk7E5Q7WoAOGZGa1/GmA6W7cNrh27OB5
   jMtbzAsDY8PrPpnMPHIhf/dfs2tOEnmLID6hDgh1sfijVd3+TF23KGOD9
   p0XgS9ZKZPQAFk9wH7qdYn7SMvF8YjEzf0F6Zwx3X7AhLUV2lG/jm4pQJ
   +hR0DRlswySsYl9EYbgJio1itkIAJnB1z7Bw4/8ocD7a4BLehTPCDbKnl
   kXmc1gzfO9KcCe38t8UQ8aTHGi5obECrVXULGaT6mUXwjf0CvO1JLNkbC
   PvAA/jSIQTZPvur6FGBpd2+vlYknHpniwhtaQtGV2eqLG60oBANIvGFFX
   Q==;
IronPort-SDR: nAno6/TD3BnlqUsGgxDSTIHh84vP3tdyTuZS5/0XbeagNvBTvdBTBdD1cJqqOT9BPCmn16qnuR
 pOfvwmM5tQZ5xXZmKgCu+RJlq+lclt6Xof37x2Iv0CE1Uv1NK+yLN3WgVpXoVH3Ed4gde68rjY
 ecy5EbyjaXItS4aNFWYMqdVezwH0A6wdDoDj2fTgTMcAb46kF5ID/72JJMyqytKYksOq+Onsdi
 eXg6S9Kh5mSZILPaTXXhMT2wwHD0Mxh+wBG0P8c7ViMDPUO0shmAFExZ36aah4u5in99mflYSk
 L9o=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265323319"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 18:46:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBIpJBv0ZJf3zc+mSqHdSLp0WoLqpRofPdrQ+cl3CKnuNY5dC5QAyAiB75IlwFisdNCAakJR7uZLiurqoY7xlcyZqOABn/Lw4IfURnUDB9OtG1bcsLKD3Du9GtXs2ck46QXSUuJAvzFGB7HM1ZyEpSKEe4wWEOH+wl5NrzOl6TUWm3oOA2tCI9BoWZXXRyGUaioCFBFZYOHrkEqf5zUT/gOrjG96hpbuiGnKRnqoIfFhMqZGPPjswB4WO6TB3wmZ7YmyghPo5C6+r5KNDJ2S0bOyfHtbAXbALJZH3+v9LXsiWKseX+hNdKE04OxO5ZvYZzD2Ab/wx1UpRO2GBwXGIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3otifNW+0st0GwuhkLIQaF7EKSAJjffuq303i0K8mlk=;
 b=cq3mH8L1hNrziuhZ4Y+72O9NM/+oPorOT1qR7eygF1zYaVmgmW+EAMbt5ZDYHbocKEjxLJW2RuSCtN7E1GjfPOfDkrDi1ZOrkPgMx/Mw/mgfZwSYGhy3mdSRtl4FsbOQIVlqAQhZQLXvVv7btoDnkeT0olGbErPupN218/fQDXKWabmH1UxkiasJ9AW06V63zIWCuOawrhM2iPpe7id3KEMCGo6er+maaLpg5sda+iVJYq2PcvEhRB6YX/dJOCUfIyItnBMAgwL/aCcSQEdfCINSKbr2siP1jHboCj76iubW2pQVXx1rql4qCEYapWa/IXA4gxS4z1XDVkPEzZY1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3otifNW+0st0GwuhkLIQaF7EKSAJjffuq303i0K8mlk=;
 b=yyJ70/Wkeggp8Or19Gbd0wEGoIjr3Af/htOskCjJCkUl7cz9RS7byB8x+/EnAdj7dOQgZkL5hlMBgkRTHX8UyWvHObSLo1HC6L6mAI2ZF9Lr6bDgTT3HUTZyGMi1ylStvo6bOZL8QPPZc2BAEgrNYqglIvR9K1TrPs5g70N5MEA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7269.namprd04.prod.outlook.com (2603:10b6:510:1c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 10:45:42 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:45:42 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 03/23] target/iblock: fix the type of the logs_per_phys
Thread-Topic: [PATCH 03/23] target/iblock: fix the type of the logs_per_phys
Thread-Index: AQHXDZcDqFIlNANr7EeGSD9YR3+IcQ==
Date:   Mon, 1 Mar 2021 10:45:41 +0000
Message-ID: <PH0PR04MB74160CE8A74A767557E438849B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-4-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c89787b8-68bd-4ab9-325d-08d8dc9f2917
x-ms-traffictypediagnostic: PH0PR04MB7269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB72690EBD6BDAA16644DEA90A9B9A9@PH0PR04MB7269.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3VRQPH98QZeKp3rpLrZG4f8sQrIMqMptsvBYdSxK4Mrk0SpA31X5FgyPP+7OMlqH7jHnw/BoEEvqjwFjgbG387TIUgg/9ogespmHNWUYhUssSwn9owMdi1Q8kM9fLZqx4e2b6/wVemZGSmIeA95J9d9t+XdqiOuqwr98TZ4EJ6PpuSKiZfW31VHjg4TQXljOXpBjvhBS6BHp/ROjTHSpZosfZBzTLRj5N3STtCg48VMeW6tkDnSLYIb2esQa66tTqxOsYHSUy0cNPN60ggM0eq3+N66aE5dNzg+kcjHCUsnDauVwZJqB/nRFrs2uA4E6RABJEr1rdMfKzwDJSuFdjZ8g1TQSwnuts6aJGiFjZbQROFEDBsLUaXfRywxoVcze2y9oYwtoptTtuY2mxLltNI9bDmBirm+Es28DNqKhf+lm4/VeJ8SR4f7kJCkCIwk3jXDOVyY0whskIuoAU3Oe76Vg/TI7xQ3CUjTQi9QsVm4nc99V7SudtQZhLwZatzV2Nabx0pHrP7113T29fZMLvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(110136005)(8936002)(71200400001)(186003)(33656002)(7696005)(6506007)(53546011)(54906003)(316002)(8676002)(83380400001)(76116006)(52536014)(55016002)(558084003)(2906002)(66556008)(66476007)(4326008)(66946007)(64756008)(91956017)(66446008)(26005)(478600001)(5660300002)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?rxTc6ENR9QaHqGiG5AsER266+QEQRAVDXxK6pyoXWHqP3hNkHXkRf1b7S5?=
 =?iso-8859-1?Q?CnRe9ucBOidhQm4WcLAlCzHKOxL7E5Vp+jYsxSUkM4S+PZOQN3/nus76hn?=
 =?iso-8859-1?Q?6Kcuf9qDqKi6Kc7NYA9E5D+613wdlfVGNUCFAO5cPbnJKdEiWhrwp8SJA5?=
 =?iso-8859-1?Q?xdrXFYSXROurCLEDXF8djGi0mCmFlDA7aXkclY5Z9WJnEYVuhvHe6Ekn+e?=
 =?iso-8859-1?Q?visrO5OMmlXG5EwAWbT2hwa3wYNLDDd/SBnrdMokWVPdG9SLIH0dqspHz/?=
 =?iso-8859-1?Q?vYj1xF1nPHK42dlDTAUpNy3s/9z3Yr3Sy+kEQHLsRlRVt/AyN+qLx9+1FE?=
 =?iso-8859-1?Q?8TPm7TP+7AQT6gzEl8XhlYIEyHgfmUVl38sOSxNdbr8c9FGUaZ3rkm66kx?=
 =?iso-8859-1?Q?8RvHzPaNZoMuO+9xTbT5XVILVjPe+L9Uy4irQ9ZCO014zceck+FIGYyev1?=
 =?iso-8859-1?Q?RK0jxiHUdklWcfzXUzK1vuiVCtDExdXNqa4MGILQTlyo8TbwZUgaIT0CGE?=
 =?iso-8859-1?Q?wGZvQ+mwUhmWZLd8y80oVhxvzzu+8qQnj1JFHM8u67K9zIe6MZPmJNa+Zo?=
 =?iso-8859-1?Q?a73m4jjZpFs7nTMWV2qzWhaPFRhilF3uw18MOozsZiibBOwH9MoVBShcxz?=
 =?iso-8859-1?Q?/mnOcB0h/6Q1UnyidUJTU/c9blEQZI83X5dm+M7P8X2PKzwYAM1kevOhiZ?=
 =?iso-8859-1?Q?7WpnrwFFrhvglahrMOjmdHkd3inz1Plc3pGm+7T+4OwpX05Zmif23wZXOB?=
 =?iso-8859-1?Q?CO1UPluF0AYH0R+ZMbV9OELvXl1oGx5tWDllgs9+3JOnPAToAixavACdLy?=
 =?iso-8859-1?Q?kAiFe9+ksdYbplKYo+ORuuuwya6ZzFa8qkLMFJsGSVQIpsWZxKNuvhAX9l?=
 =?iso-8859-1?Q?bXLFQkPHh5nHQk5uNkt3Z5rChH6JCX0b+5FP1Lj0i2SWgKkqUds21EOR2r?=
 =?iso-8859-1?Q?0xQ/FksgAB0PmUN72L93uh9VGqz8h9uFzj5I3Oz16RXAb40Bnua2BQjfiR?=
 =?iso-8859-1?Q?HaYbRXFK8fLqRtFQIl04J1TZ7IM8QE6Tbx70JgUoY5Zmhnd/2vDdqbH60n?=
 =?iso-8859-1?Q?PX3TK4Mrm3IDLdWfkaAC8XcqcCVKIa2SqCn0KDWd2YjdKtt4+ggg7Xr7bW?=
 =?iso-8859-1?Q?t4nD6Y52pi8Zp/19VxlkoJDGuxyXnPtRXpnESP3NHBcwbAinZjfNzAISTk?=
 =?iso-8859-1?Q?1Ue1c54B0NsAiDu/lyi/V5T2IUw3qDeHiuadx39g8ai+2vNP+UL8mI8UVS?=
 =?iso-8859-1?Q?ce+Ev8Y/d27McWjznnOcpXcOEAsrEpJ9x76mpHz5le5f3pfj/hwqh58kYK?=
 =?iso-8859-1?Q?C++So0MsC1/92c7uOQvaeYuE9HqLYogxCiIj8aiIlpQi9fSDFBK186oTy4?=
 =?iso-8859-1?Q?f9gQlEei87jh+S2yNbddwBmVoftN9PSg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89787b8-68bd-4ab9-325d-08d8dc9f2917
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 10:45:41.8778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaMxjyi599lcn+XJpyjUSkwCO3OB4uBdJM/tnGFZdeJXdvZpSff6yyO0up8sXEHV+5x9GGX9hKtV47/aSZiQ9gkbJ047NBKI5e8a2IriaLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7269
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/02/2021 07:00, Chaitanya Kulkarni wrote:=0A=
> " =C2=A0147 =C2=A0* ilog2 - log base 2 of 32-bit or a 64-bit unsigned val=
ue"=0A=
=0A=
Not sure if it's only my mail client, but there's some stray characters=0A=
in the quotation.=0A=
=0A=
Code wise it looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
