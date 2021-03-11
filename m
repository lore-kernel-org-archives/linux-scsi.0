Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F060EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A091F64FA6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbhCKPS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:18:58 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39157 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbhCKPSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 10:18:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615475934; x=1647011934;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=tsZOKnTZITUcHs3d60ORdRJGann69CLC580c3mFNt6k=;
  b=S89kn//eNTRZdw/8tfO0TOL1iH7Ry7tdUu/10C0QPVvbksxt3csh/qdl
   VCTJ2zxzBEipZrzTEWz/AU902QTfpzJheQmAy8CuIuFahHLCrx6FEIuOG
   bBl8YRiRE1u/Q5ykpnVT/Ehgq0n8tQI6Xc6j/hvt3wJ+8qnkadPmj+H2v
   Mw2oFRTJUR2ky6fHAxYSIijPQT2UjYOmNyOXXMLDgfd5sdRcb+38cm1CO
   ZAnj9U+Vx+66qCOK4J3W3WOfUHciNlEK0+nRIsUGHTGIqalbd2EeHzfU5
   FuSugilkxMewJMxAZgD+aO2fuoyMJa0iPLk3tqg679Lo9VGbae8FwIVDy
   w==;
IronPort-SDR: EO5+e8q6jr9MFyWhG0YwSoa6ciBK3hCf4LyRLEGB3hdPOuihevagBGHegmPr+3q0Zdk4BkkBvh
 +cjGsyl/AoEesCiDRapIGG2UnyAHgXmF9iaB2CTdpT/AJbMtn0mpM8t5XynncDWblKNh9yhiBP
 Ln+k12xizLUw7WW/oALofaMtRvEq+3Ry7VH9eIy/FGkvPOmWmMPx4JxRla0bWAMQv79zTDNen2
 atvZRbStG6Zh14kbPYGs/FAmtWHN8hPV/hdMxy/JZ2DXd/7EebXQzCPkc2UA+OWqSJJJyeBJ8f
 VjM=
X-IronPort-AV: E=Sophos;i="5.81,241,1610380800"; 
   d="scan'208";a="161912127"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 23:18:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlaYP/iRS07vjZ6oiW8fDhYyBvCJ3l8dr9dEwvs4M0a6x4oJKBIaEKXlUW/rFU15769bqTPEQ7v99wArBS17NlFHX9s72lWa2sAJDn4zY9OH9wNgvVwflniM73RkgKJgiEBCL6P4VW0Z9bcxe5LXk05ZrIGmszdIXYB2nFDCNf8ZoKVpbUNzjw4RlIPsqNXiirWsYROlSziNcuNXeau2HH8s7CPiCI1wFF7fZ+qgp/czL6p4zFM1QU8oGZ3NURUek+QdnQqiAQGMtEK5Kj/w2MKt9CG3/VSMBisgOgpbkpqryO9FSQ+sed1RhhQE8dLG1vPA6T1glUDl8mg+mjKl4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsZOKnTZITUcHs3d60ORdRJGann69CLC580c3mFNt6k=;
 b=ZgZ0Ucdj1cdeY6WVcF3YLWNdOObKzeL7PlKk/K1SjD/9Muc8dtVRqKMFDQjEzFzAmxjdhpQGDSnOY2r3DiCC4Mt4lEibiyv4gvXoUBdKp1H1vIkR+awFRK9gTs0JWmWm5fvBrjYFGmZCaWiyTrC3NXC/BmN/R0dNbMEK6TzCchtaW3H0aG7P5sEUgWsczU3uGpYZ8m1SqWtcguslr42T/3DFq1etJUAIZDtKXFp5u2EgTCDXxWXZSiHW33qF5sN3LBiIjWfJeHBWqr14eB22Or3dr1YKVtRn+ZN13B+7GBKqnULOH3MyL1gJiAl9ePNiByo9lMsGOvKetlgnrVXSEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsZOKnTZITUcHs3d60ORdRJGann69CLC580c3mFNt6k=;
 b=nx+5FYahuAChAphuqUpdrJU1f+Vrtm8aRNkQcqXF5FuSRaKaYwr0zbE88zRTztZaPIh0zTI7vsHw6JrAMkd8sYlOaSTGuarsQ8N6GKy8kZexY4DYo6s54/6fzmETh8E3BuMstvvIZtzXyl8wgWsS1NpH5ubDmXUt8wmUstKB6ng=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7718.namprd04.prod.outlook.com (2603:10b6:510:56::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Thu, 11 Mar
 2021 15:18:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 15:18:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Thu, 11 Mar 2021 15:18:47 +0000
Message-ID: <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:d87b:bccb:ca15:1ed8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7df4e7a2-5070-4d09-9297-08d8e4a0f78e
x-ms-traffictypediagnostic: PH0PR04MB7718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB77186914D86FE51004E70F349B909@PH0PR04MB7718.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:216;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4r/LoDco1kFhNZJ0ZnWDSKbnALYPCh1iMsTsg5kotP9jSijiFwIpupGDlc+k7tFyKA1Zo9vEVdfH/Hgs5g1SycvnREai5J4QVjZ59S22jMDL4C14AOCUy6zaNUVm63ZSHbruvV92PdSJUS+efl11FltymVxfCX7UL4wcNe63GVdo5XLIkVu5Jp97lL9SPtM5lfwZ5GBC5TKcwXu1Wo6Qla1UksoQa1VV/3f5hHPvZ73NW8j8qVrz1nzckoE0RQ81zJkKMkuJO5KtZzkP6UEnyJqIvB8sXLgumVRM2Yfaq4Gf8vbJICPFBqMF+4MKPGu8OJHL/WP+eBD7TAEb1NAZMuuGmU3ILFEeN9yF76RdfcdeM/wlsHOWWmHMQgmCrI48hD0iua4vZd2CTW5YGkf62x4mOP8m0xDIkdpsACGrStnD6dAm39Quau3FUDa1PH2gcp5n0tqcTxlc6diimTooOcmCMvGvXma1IqedWDFH0cYopyIlUjCpDs61wAP4wFA0OprxEEUwfPBdV/80RdqM3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(8676002)(66476007)(478600001)(2906002)(9686003)(8936002)(64756008)(53546011)(66556008)(71200400001)(66946007)(55016002)(91956017)(76116006)(66446008)(54906003)(4326008)(316002)(110136005)(86362001)(7696005)(4744005)(33656002)(5660300002)(52536014)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?niFoD+1m/CUlTkjJaxGXi75ZlB68tPGwmK2yduiW4Wo8mMWYywkDgIjYqACA?=
 =?us-ascii?Q?oq3yqFB5lER/dlyNVi3/HjJDpIs9pF6T9PgBsTfNCMD0wxA0keAJOyTQ0RkW?=
 =?us-ascii?Q?PbHpndkS3yN2BWcy+adQLR65UkHPsJsHNouefl9ajDqQ1iDXZ2MCU4f4I91B?=
 =?us-ascii?Q?hdey5PP1lFC3oXRrVKzk//PXTYSDkzhfv6FzYxyc+HPxhVsXwqGFChtEl0BY?=
 =?us-ascii?Q?tc8hSEL/azrUPbVGUAeEbAc2Ojg8Hd55NmYIZ8WBlhUVmAqxk4jRaXXkLj11?=
 =?us-ascii?Q?r3FSbda9pIHdo8oCXdmVERtn2myYCaiDnDdjO2qA8IqVsXynAXwBB63FCgSw?=
 =?us-ascii?Q?BR9pmtu+YTbPqqvJXXmocnU3hS21jrb04KmRYYkugGzLMa0NmWViYgF8g9bP?=
 =?us-ascii?Q?f6wgY60gX0tsojbORzI0DbVuLnXL+3iOzJwSUtctBbgQ5GNsHcOxkoz4hLXV?=
 =?us-ascii?Q?LJ6Mnh0j0D8CDyWkP7IIObGFb21NqJqJp5iXBBPK5ZsOhSHAGlUCTWxI6fCk?=
 =?us-ascii?Q?Jt2hFcuwk1OF2u1kiyzUO1whoJFDfD7WClsEpqGORYb9C+UEzRX1c8qKDq1d?=
 =?us-ascii?Q?+TRrX/BVfrpxRkImtg3n8+5q4FAK6YPj3CiUiQY41HccY5GNSIPUZ/JKXxSx?=
 =?us-ascii?Q?ZiNbgmcqaJmxUm7QYySc3A4A7k8zl/31IXS6kovsCXEhmQmC+I/IgGvKn2dw?=
 =?us-ascii?Q?tqk/qvT+kptLR8D2v+gf1/WdZHqmtJOi1e0JIrhxkqHgSUvidxJIRGL6a4nb?=
 =?us-ascii?Q?ql1hPfAG5qtoY938F8Px51Minh2iKFrVvsEsMx0HZatNU86v7D434k6c/Rrr?=
 =?us-ascii?Q?1mF+Budt7yn11WbM8BNv5cMTec7po+kbpq6dEftvgmOSatS280itQItE10bI?=
 =?us-ascii?Q?pmj+WdJCZ52X98j3TbfALd0baPvMVqJvr5RwHPAO/rCKbk3V1NNbb8xx2Lpa?=
 =?us-ascii?Q?K/erDnV6QVm4cxEO2yqgJEMDgrHDoy+TOLlSMDJs7E2SlXXUrs31tZlkNr5o?=
 =?us-ascii?Q?FMHnoTS411uSixW3ECcnRzHeE8dzDHNME4EV/EWsZm+ER/sVE9D6en2bmD7G?=
 =?us-ascii?Q?McfBKkUMG510jU5zWLSRSRMZiE1YE3xawYUb1+OPQ7FHtbm2CW/IfmCXvEVj?=
 =?us-ascii?Q?rPasJ7Px5pljZMqTwtLJgmpfu62+Bm5nU0mwWT9jjVD0BNTQVTHQCmmXCDXA?=
 =?us-ascii?Q?p759GT2UspmTbkGU+LnRu0mAHonLkqzLIjr0Zukh7Th72mtrtewQ48+nrCje?=
 =?us-ascii?Q?P/3hRpqV5ODbNgYLcnpAn69kZCQee+t7FGn1TPan7rQ/xtDdf9K4EKf5h/Fi?=
 =?us-ascii?Q?Cv/LmNAieeXvjon8ezqG45ma3x86ZRFKVcswixoeDSysZjJ8Bsq1nuzGomw7?=
 =?us-ascii?Q?eE10qoP7L409IUnRlzB5uLE5Fy27Saqo662O0AwfXT2D+JShiA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df4e7a2-5070-4d09-9297-08d8e4a0f78e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 15:18:47.0827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQMWcvkENJ/dlpwBB9DxxqgbV4FoRCmoco12IOBuJKi9fKaiX1SoIJgR7/6CRa6X21Jqu197/X3u3A/HUGMAZhtN4/ecfstbVYuZHef770k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7718
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/03/2021 16:13, Bart Van Assche wrote:=0A=
> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:=0A=
>> Recent changes [ ... ]=0A=
> =0A=
> Please add Fixes: and/or Cc: stable tags as appropriate.=0A=
=0A=
I couldn't pin down the offending commit and I can't reproduce it locally=
=0A=
as well, so I opted out of this. But it must be something between v5.11 and=
 v5.12-rc2.=0A=
