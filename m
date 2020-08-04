Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D5BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 06:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 595F320722
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 06:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="tys/mVfc";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="csXqKYHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgHDGdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 02:33:37 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:56412 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgHDGdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 02:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596522816; x=1628058816;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hRqXLMTlbupm1x6MunGSs6wi6dz2xA/PNSIdaSTjdkw=;
  b=tys/mVfc5A2YvQiGFenBBLzSPibovBbI73NZELBArTFKoYztRUc2he5Q
   9t+omHXT/NbSu3V6OodEfbF2T7T1f0z6og9gDl8I0waNZBwLx5d2oRHCI
   adLxKJGKUTToJpxr9BxDQlAQfHVbIeRP3SOe439YUQGymcUphfyo6Ewlq
   5pS+bjXquDlezH5+0zdL1PiRV5VyF2oeTROWdaKzWjiZfTm2iSwmt+ETv
   Qzx6km7NwLEBGi/9ZiD9xSfm9l0jM7QWp/4mv6fW5s8HXvT3Qs83ObBmn
   gf/+ZbUjcWdGK9+J29P7WkMo0OuylmS8N9mtuKE6uEE79q++af+FtTQZy
   A==;
IronPort-SDR: dm9uQRIPh0hVoAmxEGoST1Y1AoFLfLab6L2mkOS8gCB/pZL0B+Hw89TyW0z1GYx7UJvWLskT0F
 vDE2/grRXYWkGdTBo5MhvqZVWJ4TOThGxpyB9DSlS/9PagzKkb6QOXWNdimpkljYw29PSvHNTi
 vb5mtk7vSTk00pmoxDV5ITCEpCbQe2UPsqOdu/Rb0Hj5gXqfYBiNEurM9L6wBEfho74yGRBwx1
 yit+cx0vc4z6gSf+xRXn4GM+Z3Da9po2L5mVH9Lz6Ux7+o1oTCN4aLvD7Kf8zGrsZqT4DWwYkD
 4OI=
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="84329486"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2020 23:33:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 23:33:34 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 3 Aug 2020 23:33:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyFWLrx8aB4gI/czEIRbZBqMgGBp7/6Ya9TuOGwjlSCwpQq5XyfMNWYVogBdX6onjDf1hhSMT76G59p77MSbmMQEg3mWGbvS9/wb5OMUiZDS3fJvmev9DLcLMuUTBjzB122ku6C4xvTyS0MXBEME/TS6WyPhnwmcapb2ppTVzuhaGPM1LTV4puGa5E9Mzh54QldcmelKDvZE7vn1L7E8pPwd73W1ty5fGfLDiWR+hDtdnpWth+GEaPEvJ3UjfKq4DgPDg5KZuxjYvBsaBJ756EsfEj+PQNwYqyuKtjdE0oNzp46Pek8CSn2+ZboVzlmfNsCVnAZ1WtvgB+ro2EG/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAHNlucNwEJkd4pGXSQd1pYZNgKLM+/juIc95xjrCss=;
 b=CG8etogKwdXktWwdyHO7qKyfoxba68ABOI87c/bFCJw0bSc4KupzH4lrfC2OFu7D9il76K7OnsgCkcjySr+cGrEqS6DBhrU2SmAjIe33+9ElFpbYLos3beaRFTTEQZKxqTEWlzN1BPk/eZc3z2KST8/kQ45zAg/V7NQZPqMSb8etBVCCvwhGLgzDubUq23CTWuHfi8IIG38Qg1M9TgUWu3+tXyBU1y8rLLSSQcFoAyAv/Jsjrx9yb0WcTR5/7UMNhI5VHaHGRfr6jM2vpkDPF1H1KWLS+9bcPFB4zJkMPv4HwLO6LVIImyTw2shlawxqocWmFE3jhglLfuEaIK3D+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAHNlucNwEJkd4pGXSQd1pYZNgKLM+/juIc95xjrCss=;
 b=csXqKYHSXFYh1q63UsVzuUole/yTl9e9Maxzj0E9ag++Ialu9xSFHgBhGGF6mOaB9rF23uQeUELrf0zf40vDVTUK9ai/x6me6XV17odVULj4ZdOGsbg+vjJnJdzQBy6Hnxbz3DlD9UftsmhuZFR0y1CRJMjQco7AuBMfIDJqp7I=
Received: from DM5PR11MB1563.namprd11.prod.outlook.com (2603:10b6:4:5::13) by
 DM6PR11MB4203.namprd11.prod.outlook.com (2603:10b6:5:14d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.15; Tue, 4 Aug 2020 06:33:32 +0000
Received: from DM5PR11MB1563.namprd11.prod.outlook.com
 ([fe80::f5c9:c236:4395:c1d6]) by DM5PR11MB1563.namprd11.prod.outlook.com
 ([fe80::f5c9:c236:4395:c1d6%10]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 06:33:32 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Topic: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Index: AQHWahpYwcBHbbKDcU2nwyxmUYyn4KkndX2AgAAIPuA=
Date:   Tue, 4 Aug 2020 06:33:31 +0000
Message-ID: <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
 <20200804060235.GA28428@infradead.org>
In-Reply-To: <20200804060235.GA28428@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [103.252.170.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14d58c65-b8c7-4588-17d8-08d838404e94
x-ms-traffictypediagnostic: DM6PR11MB4203:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4203BE68F1AADE0FE3296BFCEF4A0@DM6PR11MB4203.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/4X8Luv9nejeidwrfDNG9gGV8oefKX1dwymxWAua3JpmJs4UCC4ZfIETpgBUxbKZJmoe7FB6IH1WjpsZgFHWxTJmTAVR73vL14dXpkxS/QhFaMENTi6t1/agTbHRr1E6H2icyYw0D39ceV6IbAKO+dFW0pyP2pZ/8mC3eSpl5uq1KxNE9uBvEXkTguqM0EiH12G1hd4pDXCd11blvBSw16TB/0hEvGt34J8lBouiep1BjSY8hnyp48KXGvmYEQ3Qs+8Kbzg0zwoiQyqjSWpEH8rCTKkjyFHega38foIUl9bgrjL1ayFEQj+3qmL5Cpv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1563.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(316002)(9686003)(6916009)(54906003)(4744005)(55016002)(5660300002)(478600001)(2906002)(52536014)(7416002)(8676002)(7696005)(4326008)(86362001)(6506007)(53546011)(33656002)(8936002)(66946007)(186003)(66476007)(66556008)(76116006)(26005)(83380400001)(71200400001)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KueatDVZJTYxYCFmDsThQ/zpEkxSHoyRPfIz9oBudHmOcP3IFzwe9AuZQnpGCrSQv7PlmZU19DQ/bMQQgw/UN1+yF/bEXXhZrR5LOjwguWp+C/lTdrENMq//VwAr0sZDZToXYXt+LeXRDW/Slti425CP6fgsGIuL2M/owKM4bLce9ONGOA2JW/lgA3KItzTg02aLjTKYfNbzvsqggB+s9olkEM9IOxcoVfTOL6PeDuke6D+Fyd98Q0tS9ZYpb0ryu4FPVILr5Ngq1Olnpl3hTysQdqNl5cKjOJyVz59VoLF/gMjxcl1G6l1n5htsWzBB8vkmVdfe1lBmWzegXH90xbES4zfd55z1b13Vcp3VKGo9IhUHcImN2iIFzpTaDfy64k7o2vn/5JxdkzA/fzxuhupZibsrNDG+EAWaaCt/Jv3L6CjLSGoaBGaVsWx4M1hq2OGPnDa8iTZMvj0zFXsGPpCYj/iU3e/PtR86doue69dZIIMZTyIW3asaC2YbKeENpyi/RIqQkWSPkLCnxzxON5u25oaMsG95X52DkW/qf7goVfgVQy11p0hYXILiJf6IQkjvYk4OP46CbbrPpwsuV+8vndT4D//nIifXetoTQMqQPnD6kfCtDerldlVhrksiEY9LTqUZkYW7KnzAyzOO7g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1563.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d58c65-b8c7-4588-17d8-08d838404e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 06:33:31.8916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PT6rnBDCmUY4T+f5B4/XkrPLZBochfbQGpQKIKTFWeJA55YtPgKNMw12SgmrQFxb9SRhbOOhZXpMdlvcZxbIM9BUCGy/TBtRCvDV7UPYjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4203
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

Yes, It is better to be implemented in libsas. Since the out of box pm80xx =
driver has this support, we would like to push this for the time being. We =
will see how this can be moved to libsas.    =20

Regards,
Deepak

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]=20
Sent: Tuesday, August 4, 2020 11:33 AM
To: Deepak Ukey - I31172 <Deepak.Ukey@microchip.com>
Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664 <Vasan=
thalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667 <Viswas.G@microchi=
p.com>; jinpu.wang@profitbricks.com; martin.petersen@oracle.com; yuuzheng@g=
oogle.com; auradkar@google.com; vishakhavc@google.com; bjashnani@google.com=
; radha@google.com; akshatzen@google.com
Subject: Re: [PATCH V6 2/2] pm80xx : Staggered spin up support.

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

As mentioned before - this should be a libsas or transport class policy, an=
d not a module parameter hack in one driver.
