Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD227C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 15:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbjFGPRA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 11:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbjFGPQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 11:16:59 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A8EE6B;
        Wed,  7 Jun 2023 08:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686151018; x=1717687018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZFSfPJ/KchLLqV1gJFe+ZYETOU+O6+o5PTUHGWE3E1M=;
  b=pZZPs+83qS7tw/USi6gdXxN7p6vwLlLMdqlXSKhZXOm/dYyYtOKQv3FN
   gII6ALKhU2hDHQZHGndMTgZYGrFRa0EIm8fHC9Tan+q16Y7SoZasY/1ui
   zWjRnPaXjUO5w1TPmLogXreKnLX1e1tjxDjpmIoM/sSfnVHJYEvg2+7cc
   6up3E5HnjUzE9mT1V5vZIlDcsCSf8rrqSY1jhqlLkzGkqOuvfKazzEuTJ
   ONNIWaN2eWh3gWCmSF8qg/ldLlFmiOGJsAqzq53uz2qZk+uDe+q80UKfi
   ocvdQvE/Busx2P//opUPOyuxIC7iyq+VzgNcm3x7uwvsqjUxUSHu9LVec
   w==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="337555571"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 23:16:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaFcBW05FBrx11OTbzewOOyGg63KQxSMl6cVe63gnmAwfnGADfzYuai3jr9BqmPKNYc9dcmCPFdbhawqTs7kAvBRn2o8bDkVVqMt4cQLNuyRLWfMGnqqWnaG2b8vsbkC9+mryIoN5/lh91pAAR7WQltNEYBmutYzJa54cypf4dFO6KHY4Dxn74wFZ3H2G191qIyvLv/qPatogzIsCbPEganIYd++/j5qpOphx3oW19GYl6VXlTtaCteuSV0SvFfcCOr0QXvjKMoQCwk5BoXWNFTSPLSvzCoGhK4CaYXToSbHXFEmM7Ols26PU4zl1ompvCRPJ3svw8hWMiqrAj5J+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFSfPJ/KchLLqV1gJFe+ZYETOU+O6+o5PTUHGWE3E1M=;
 b=Wcox9DhJumR3Qroa2AyU/11TMfM7EvwcvG6D5Uora0i1qaoyYFCoy1vk9rRo25P3Mq67szsXy87pdQUNeoZg+bSLtCLz+CzKgDMuN/9PBDit2CZOY+9tnC05v0qnw/CbGLo9PNcRcWGt9aT+vL/7x+jjIbZK2V6U45k41/EUVlfMWVIjZ8zJO5A1aaaSl9h0yPJ0A53lke3T0D/47cjIdUu2PuHaDDPRqxp33RsMwGbV+tsGImduzbQVZdCdcgRzs2S/Gpm5evW/dEIHjvnEH6KBNoN+AKXBSpq3VUqfoU0Ga8iiYvWeRfQuI0Lshf491LJuXRi4yliJA2cjyTW/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFSfPJ/KchLLqV1gJFe+ZYETOU+O6+o5PTUHGWE3E1M=;
 b=X4G0PIisKQqMoC0R9mUtPWppPyDCPnSMHuaGRun1CxXpPO5Uwv3cvsdjs1QiG/VqvzJ7yLN17MH4/HsMyIO6eu9IB/uf2P9lZR9kaJBiw2ZDyEPq8Q0viIN2jPATsIRqWtWVTR/BI9EC92jLCzHLnE30vwd1rFQ6kfLPI97HK5I=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB8426.namprd04.prod.outlook.com (2603:10b6:303:145::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:16:54 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 15:16:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] block: improve ioprio value validity checks
Thread-Topic: [PATCH] block: improve ioprio value validity checks
Thread-Index: AQHZktZckVbA+TzTBEuV9kJAy3hRQ69yrowAgAzR8oA=
Date:   Wed, 7 Jun 2023 15:16:54 +0000
Message-ID: <ZICfY7ssJ2qoxNnc@x1-carbon>
References: <20230530061307.525644-1-dlemoal@kernel.org>
 <ZHW9IQvePaG0yxY8@x1-carbon>
 <CACRpkdZskZ-GktsYL0MXbMwdOQmF=-4yyns3u+-2eHP1Nt_RHg@mail.gmail.com>
In-Reply-To: <CACRpkdZskZ-GktsYL0MXbMwdOQmF=-4yyns3u+-2eHP1Nt_RHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB8426:EE_
x-ms-office365-filtering-correlation-id: e3849d90-4dfe-490a-1059-08db676a3a13
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zeCfod4JQP4WPEDd7Lq3KNsRSazd0VsOkW9lkZ1ORywGnM0zGec37XTfbargZ2AFud+HrMrfLRQKKbbK03Oldlgd0/rOb9H4klGzGcbcUWiWV++WjyYiH+T7R7ln1oBzor9IZlSeO/d+NWZdwuJlZMqIv5bgn5nEgcxTGy573Gmgfi0g2BsuzzLbOnIfxlC1j78Py0WE5JfbSpu5LDWu+moyLeX9WUuYSXgMY6gDoESBwTdbokqxz41VhVqvyERbjXjBrcI/Nhk7CjfoMec4/q45UA2F+Tg5auqpbK6TQvyKmCgfS/Ko+APr+Tc/kdu4DSMNw/JWPtc63SY1LQv9uRRRTS3lHho1rrf4ulsbvH6g53nEtoE2ugJmZ60wUh7bkyo2iG3Lfg1r/veOVyKhewo2LJ1Xmg5ciiR/mRwWlykslkbCn8I/g50ZzmlyWxRheoWZeKUhPSSTzHd59srcirjGCXTphQlRzRmbFLKIBQcV2JkLMjnXqPS/IgQYZuXBXlz2V+e2Mg0Bzm/SOpy7EcEFpPkV1UexMgU+aGfN1xN5ZAtNSR6ygfvn8UQCFVLnqNjjRWiwKTFR2jzftyliV5ZITPXLUOMnAcYXM3D+LMnOmoDf6hhuury+nUXVJ/Ju
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(86362001)(122000001)(54906003)(4326008)(64756008)(91956017)(66476007)(6916009)(38100700002)(66946007)(66556008)(76116006)(66446008)(6486002)(71200400001)(478600001)(2906002)(186003)(33716001)(4744005)(38070700005)(5660300002)(8936002)(41300700001)(8676002)(316002)(82960400001)(26005)(53546011)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHJxbCtTSlJaWGhUb1pDcDlXL3NRSWN4MnE5aFM2OU80Z2RCRmQ5QmREOFJS?=
 =?utf-8?B?eng4TjE4TlVuN0NobUhlblhvYjBjbXBPcTkwc2ZEd2RVTzVZZUovell2WnRv?=
 =?utf-8?B?SjF1Q2xqd01SK1JaOXI4WlVpeEt0YlFQL2NrUmlsUUdHRC9sa3FRZ05EV2U5?=
 =?utf-8?B?STZobHdad1N5TjVZckFxeC9YV0k1QWxNZ3MzMlltUEtTd25JNlRjSUJydzhP?=
 =?utf-8?B?UG5HQUZxNzBDWkgxZEVnaGdZU3lsS2Q1WmNPYjNxNlFIRFFzNzRtRkZIUDV1?=
 =?utf-8?B?Sjc1d2F2emsxbUdreDNNcHZkSm5zcTNGTmpMYUZSK2xZQlNUeG1OelZkeWI2?=
 =?utf-8?B?MkNOclBrNU9lRUpvMDl1WkJNRWtnMG1JeGUrQUZJYlhmeGVIbks1TjkzRkxW?=
 =?utf-8?B?YlBsWndDdFVCZGYzdTQzNDBLMUxnQWxBb1NZdlVEVDV1aGhIMnk0YjVTa21D?=
 =?utf-8?B?ZWtNQ0N3V29LME5WT1VmTEdWUnZkcERhQkN5SGlyUU5PdGJlMm9Xd0tqeWhk?=
 =?utf-8?B?YzZHRVRxMFVFdjc3Z3ltOGdhNFpKcEFWR1JyWHN5Q0NTWmw1QitQcUl0cEJw?=
 =?utf-8?B?SzhBMTR6cUYxTnNuU1B0SG94U05PTE9scnNvdCttRWlJMTl2THZBV1Azb0VM?=
 =?utf-8?B?eXlHam50QW1RTCtuY2ZGNklYb1FVYmpHQ0o1dWNyS2JURzRUTXUrNC9hcHk4?=
 =?utf-8?B?cWVwWWZnelRvc1hBVmFQNldJQ1dPYXVRdWQ3a3Jmb3lvd1BwcVc1WUR6MUpQ?=
 =?utf-8?B?MVN1YURuVklsVmRXMDJCVHQ5eUV2TWU3alNTd3hXLzJzV1BNUm44SVZCZHpp?=
 =?utf-8?B?dmxyck5iUStzblFiTUNPVk9hdGc0TVc0Z2pBcDVobERmdVAzSUJWQXgrb2wx?=
 =?utf-8?B?ZllrNS9yc0I1UHpwSU9uaXdLbGpDOERVZDNXOVkzN1pMUDRhWk1aZGtSemI1?=
 =?utf-8?B?ZGtYVFZQKzdyVEhWa1JNT3JlYkFZc0E5TG5qM09kQTFrSmRERXRUbWNGb1ly?=
 =?utf-8?B?V2szNzM2L0tGa3RzejN1Vk03Rk0xZG9HOHhvMC9vWk8wNTRTYUVydk52amJW?=
 =?utf-8?B?aWZqVGwzeDQ2Smw4bUNmeThESXJOeURiY29UcUZ6UnB5aDFqNHdIQ2JUbW5a?=
 =?utf-8?B?SE9UQTYvaDFYRGNLQkFTeFJIazNHMElLTlczMUlsQURxOU9ZREh1Zlg5TEJs?=
 =?utf-8?B?dDhQa0tuMEZrcHlGTkdjb1hPTGxrUlNQNDZzY0xpd21TbWJKaGNQS05mQzdC?=
 =?utf-8?B?bXFaL0R3M2w4VG1BQVdyR09GcHRrbVE0cEoxd2plUHQ5ZTdxMFEwdWdQb0tw?=
 =?utf-8?B?c3JYcUhYVWlHcm1HYlkzeXN6a3VtZ3FLVE93WFhLdEZpK0tPamwwWkdEMjJn?=
 =?utf-8?B?blcxbzNtbzBpN3NBeUFhV0pwWjJVQjNsRUZhYnpSMWhtMEN3cnZUQlZGVDRw?=
 =?utf-8?B?V2xUVmZZYzIyZDFTTk80dnh6UTcxMlUvK0lScHl6MHZvY3Q0czdGc1JZYUVJ?=
 =?utf-8?B?YWo0K01ESTd6K0VSS2o2TW56d3d3WCttS01UQzhUQnJWYit2ZzVKdUdNa2o2?=
 =?utf-8?B?QXNiQk5DSWx5V3BPZXlxWkdPVWFneWZDNEZybkcyYkoyNXhleFJWTERwVWdJ?=
 =?utf-8?B?andLZUl0TWl1cGNITTFZaXZSM3VoSkNiTFBGVnViUjZ2aU1QQWtZOEI1MW1m?=
 =?utf-8?B?cjloOVNMTXZmWEIwOXdXd3JOWFpiM1hYb0lPTlFyM1NhM2wvTFI2eVhnK3dM?=
 =?utf-8?B?eTBmTUFYZmpCbUQ0VE9KYnIxRUhlbWxzcFNJcHhMUGlGRDllQjU5UERnUi91?=
 =?utf-8?B?Y2xhb05vck1QYzg0VHgybml1VzJZV2pRS01JTFEzeW1SU25EQUxDQ2I0bVF5?=
 =?utf-8?B?enBYUG11RlJsbHUzM1U0VTR6cy9BZ3BEdFIvZjJUWDNaZ2kvZW1NNVJWcE1u?=
 =?utf-8?B?dVlhR3dOVFpsVThLNXVrV1lXQnNrSTJHdUNJY0Y2MXRPVUh6Z2YrVU1aRENh?=
 =?utf-8?B?Z1hFTklJcE4xcXFzS3NsaTkyVzRmZjlvb055b2NURzNRSjIwVG9oTHBJR2xr?=
 =?utf-8?B?NGtzMEZ5ZXl1ZUlORThUY3V5aWVCWXZoWFl0Unh1SzBsTEd3NGZDSTd0cS91?=
 =?utf-8?B?U2FzWUhPeFFyWTEveklVTkhaQ2t5VEROQVRFZ2tsVVUxRDczOWpXeUMvMWVF?=
 =?utf-8?B?cXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1E6B0203C069344A11FE393188CB3B2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: A6rSfpDjL3sDzIAAPuONZ2uae/ZarWACdUN4cSMS3PaiJdhbVsI/Oi1FOC636jLk6q6fKwQy5svjO1RHsRub7kimiZLTzYRjyBJzxArnkLYBDC3dN8lW6hw7zXOpZmV+gz9PshX9OJfnQO49lxIbuZ3dF4VBRvJndGeirlFj5cGSpeJHiOTSniTt6PYsev28yaZcAqEeyvqrMpj0/rcqrqhLRbW8RaGAQeHnxpVydgOAPFwdykq3WZfKDhdJLSDDotu2iILScMooWymLKmw4vMWfV2PZ3PunEl5rmM2ad+TQ9u4TekKNdZOLri7eReP5iT+hUTau7yR1ATq00IjkAAhLsEgprm3w5aqBWdMV2KK/+e3b4cd5+eZeOnVYtUJK6Nf3+2bl5UotISABIFYrM/rJR9n/KYJ35ZbPw8klzGTbDKox1zl0TEoiz+DAjII+ilFTEr0ZYbqjjc4BgpYk18udsSEXI2+NpnWzHldQybnussHOOiXXcBj7GQfITho56t/JG3EPq2+uusubBqhJrF/WAtPr3INjM/zw/S3TmP9fmm1BiKLBKJvNC/xmf9kmj50bnLoUsDhdBxNihBtxPYR5gX2qvJ+K4PIl8mPDucKH8P7LifrACHlmDJnfMfnEUOX+yho6hxzLFICpHmVAisJwk0aHz0IjzaNQVaYIPAdTSq9PqzfKKW4PiQoGE22jwDPOLQivIKY2ydlw3zSGCfaCaaMOyub2yHn4uaXSGM824W1Iuk7YaLak3nQ01B7yZ5AEODR4Jvmg2Zo8gnoG5EsfPevqwnsjgVZ8yaZXw33mWO0Mta63l5/Nq3+N45pecutjwhAai+bdXEwaIFLWrHzfbINbkY1IDphD6C/Q7m79MfRTzW1XYFucpGHm0F4i7aCROWl0tKhJSuGBxAyHpw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3849d90-4dfe-490a-1059-08db676a3a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 15:16:54.1025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utAEzeAOfnm6v5TyG+ww50HEZtZKFbAbtrlNbr/glm13YLVWlH/li5pTSyQ6t4Wm2Z+BQf9fyOkqsrl0wKH8XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8426
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgMDE6MzA6MThQTSArMDIwMCwgTGludXMgV2FsbGVpaiB3
cm90ZToNCj4gT24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgMTE6MDnigK9BTSBOaWtsYXMgQ2Fzc2Vs
IDxOaWtsYXMuQ2Fzc2VsQHdkYy5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGUgZml4IHRoYXQgRGFt
aWVuIHN1Z2dlc3RlZCwgd2hpY2ggYWRkcyBtdWx0aXBsZSBib3VuZGFyeSBjaGVja3MgaW4gdGhl
DQo+ID4gSU9QUklPX1BSSU9fVkFMVUUoKSBtYWNybyB3aWxsIGZpeCBhbnkgdXNlciBzcGFjZSBw
cm9ncmFtIHRoYXQgdXNlcyB0aGUgdWFwaQ0KPiA+IGhlYWRlci4NCj4gDQo+IEZpeGluZyB0aGlu
Z3MgaW4gdGhlIFVBUEkgaGVhZGVycyBtYWtlIGl0IGVhc2llciB0byBkbyB0aGluZ3MgcmlnaHQN
Cj4gZ29pbmcgZm9yd2FyZCB3aXRoIGNsYXNzZXMgYW5kIGFsbC4NCg0KSGVsbG8gTGludXMsDQoN
ClRoYW5rIHlvdSBmb3IgcHJvdmlkaW5nIHlvdXIgaW5wdXQhDQoNCkNvbnNpZGVyaW5nIHRoYXQg
eW91IHNlZW0gdG8gYmUgaW4gZmF2b3Igb2YgZml4aW5nIHRoaW5ncyBpbiB0aGUgVUFQSQ0KaGVh
ZGVycyAoaS5lLiB0aGUgcGF0Y2ggaW4gJHN1YmplY3QpLg0KDQpDb3VsZCB5b3UgcG9zc2libHkg
Y29uc2lkZXIgc2VuZGluZyBhIHByb3BlciBBLWIgb3IgUi1iIHRhZz8NCg0KDQpLaW5kIHJlZ2Fy
ZHMsDQpOaWtsYXM=
