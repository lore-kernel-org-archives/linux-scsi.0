Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B6AC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D442078D
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XqDmiD6R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yRC+Vy3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHTGDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:03:50 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54883 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHTGDt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 02:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597903429; x=1629439429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sOXwJsCQWu+b4I7y3270lKaVRfDiZrhJKY8XBiceV0Q=;
  b=XqDmiD6RojQWOtRjZSEiUjtJEzO22BmGNekzCCoWFcjtdKRAQW4r1GP2
   ac6pJusyNSyEEZrOSPw5QCzFxe0g8VKPRv8dmv3wRobFYWk0hA+cQGxKJ
   20Pt6MsSEZjnovY47qiGyT6pBBUntM0mirB4PE9bfvwBMpX04yblP45ya
   8yoSFiPFPhE2setoiLYunrOxkKMO0dg7YFHe4aprYpPmlRuRJ8kjHPT6d
   1WLBTnRYP1Msubli/+sGfzWmrXJGwb/RJnd/AY+qE+dpOrA0h3G4knaof
   bWWUihol594zn1xOIOsPoVnUsuqnMBeU+L1A+D1BG3X0KSzPrjZ1Zp3nt
   A==;
IronPort-SDR: S3bT1xzbnBuEoNX+9Z0NH553IqVw2cY7wIATP2k+3sQiSjp14IPlFGCUmEr/U5tyD6b9k+Szfc
 NyUwRi+yKm/+I+5aTrmO/+KqN7n6hb1aNOuLOqdaDwp8Yw/WvMc7JK29CIHmdUte9qT7U99yak
 7rTZ75hqBiwejlCtc5U7XRLN6ITcw2ff1YJRONe7yQ6KxbvWXgI3ntPnVdgMFNaEOBEvGn80+M
 eprZkn/QjU3/qMdXAx/V5of0ZQmXfg1IzlC0+LQlFk8j1wMlWJondn7arpVLtZ1Z7qBDdlI6eb
 zFw=
X-IronPort-AV: E=Sophos;i="5.76,332,1592841600"; 
   d="scan'208";a="146607435"
Received: from mail-sn1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.54])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2020 14:03:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeGVGiVKmfEZcNCe+RsfzK54N6TsltllNQVDt2NrzM8DPIRp7ehnW9aSmjHDSo42JL6cgPmg3v3NUxhDEhz57WH8tBTkt+HHaZ9mbx4jND1tu47AK+14NDnSUtWutMBL0nd8waLCM8uj+bKv1LPSoi0dd4JRheh2pLbTU+Ru4NYb2xd2pOlNy+0DEl6qMRQa5XD0Pn2fgUgsy7E5pCQSyWED4N2kN714790MLo8B8Mh359iMq7h0+t3+cZqdKAo5HnJ9oaVtuTAlutyJRUWGc+lQJ47zFDpISvlc36UIwE84qcy6ZEpC5yYtUVQeyfisyAis0nvyCaBcOLf/jQmFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOXwJsCQWu+b4I7y3270lKaVRfDiZrhJKY8XBiceV0Q=;
 b=Wn/yksH1cxbPpoK1W2Pke2svT2ClSDlL5gA/EJSO2gI7hkz8ZcDsq0hYvm/0ZM/7rS18r1MkPshIszTCxN9tFc0pME6oi7o5z+FQPoMQPX7RNzrhOT0E60fNnBQFgA9G3hHKJ1wc5k+ZSrz5N78MtsocjIAJUcWjUVxclUyDNQGa7nf1y4pU0MbMdVxsQ6LQuAb3JRqWvziOR+NCFQDFVbuVwKFLbDxrU1wC2W3Jtl5CzUb+3Wtx8Jw+TDsRkjA16VDm2zgzOS2qKGTCOKHcky5p+5n1QDd73WJWumSb0HXsMk3i9eVc5H4HrnvkXWucA+YjgUdYVk5YDzagWfSSpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOXwJsCQWu+b4I7y3270lKaVRfDiZrhJKY8XBiceV0Q=;
 b=yRC+Vy3Nx/3y8zeLwqJ6SDUGNM7f1Q9OvaO8bRZ4X4AF2emWB5BXVR6y0dB4qzspXovHyjgvLwCU5lnX6QPVgFG+2FBso/T7+SqRhHow+/BHGMcnOAFO0DcInoAme8ZJ9cp7opNQMhMwa4EnAokMlrrDfSv8KVfEImr2fUwurNc=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB5447.namprd04.prod.outlook.com (2603:10b6:a03:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Thu, 20 Aug
 2020 06:03:45 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 06:03:45 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH] scsi: ufs-mediatek: Modify the minimum RX/TX lane count
 to 2
Thread-Topic: [PATCH] scsi: ufs-mediatek: Modify the minimum RX/TX lane count
 to 2
Thread-Index: AQHWdgTc2Id9u3Ln3Ua1qwoK877ZRalAgmqA
Date:   Thu, 20 Aug 2020 06:03:45 +0000
Message-ID: <BY5PR04MB67057C0623170CFABE9E8AFBFC5A0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200819084340.7021-1-stanley.chu@mediatek.com>
In-Reply-To: <20200819084340.7021-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8db1184b-285a-4a59-dfb6-08d844cecc84
x-ms-traffictypediagnostic: BYAPR04MB5447:
x-microsoft-antispam-prvs: <BYAPR04MB54471D0DA44EAA6716359F5FFC5A0@BYAPR04MB5447.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YNBgw1mtvTp58eP0gvij6Fdt6w2nXWh1CJRRRnmkGnotlojNBdw5MO1hM+JpPGrgJGf+Fwh0pKL4mnLZHQJx3oKDDn3vNHJnRcUELgVaXPAAAiywlZzta7qI6HoBdc5JVIDjvqCXgeruPMh5mO4feyGeU5XBYEZFMVAseF0adkI2ZoTnOdVRM+lZTPryriNdyK1FFfpBpNRAv/PmgMpJ9iIgPXOmf2pgsqIceDRydjnwrQjj/XUCJNNP1XtFxTwDU4BLoEuTUR4yzNT0Cmmo5Ce+fjp+0lpy3onCrBO5xCruVH9U6zgzSWbFGwgQasqBjJRrrX8G0+lx43911xQgNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(6506007)(76116006)(2906002)(7416002)(186003)(83380400001)(33656002)(316002)(8676002)(54906003)(110136005)(5660300002)(71200400001)(66946007)(52536014)(66556008)(9686003)(86362001)(8936002)(4744005)(64756008)(478600001)(66446008)(26005)(55016002)(7696005)(4326008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PHOGIh4suJWpg+gypi/j+EwCdKrWaBmf+mwVKZDQmjvJ5x7QGIGZuVzUx6Law1ApiD6xk1WLjIBSYy00Ev7evU+Oli9jnuBmuYbPRmkQh/l/wIu9LaE0guQPAjEtDxSNwyMq/quze6kU6aAudBBG71FuNTi8bEYZUfjiLXct9BWGW12YZ8IghtJp+5rd3PhfVk12Afxv9DmWz9Zdr3ce+CG+I6++x2u5ScbBXiVDfioycqlgEGyDVHw7fhaNLLdoGRmjKH734pHAPffIQP+UANq0vki2ep+XDQDteskWzRi6qQra81r25h67ORSv8jyPGxdqgpIR+3TfTl/6llPgqwtTe/IYyBVS7wrkOk6h4jBtKZhvvAoqaI/uPE6IYDReZeXdhGhQC9xV1lVKGvfmygU9lXK8XvBhGxYcI5RCxvQB/3FrpyD3SstMo9Unaj4MTlfOwzzQiXkmlm1hA9x/K7lZsVHwdPBgbJrgGvIhy+7/pzzhKJRrucAIJZLRsXAV4D1C40H8WDkdGa3NB0NHmGkONUNWMmilBbLJdMnXQNg36CcjZRCyE7ToSucuLUAOy5hflelofewWdbEaoEoG87ZBKEwB4x8A/67fqJEvZcuBqVPsj7qwJy8nyBBhax1Nef3ipqsg1DYagE0JSIRMIg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db1184b-285a-4a59-dfb6-08d844cecc84
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 06:03:45.7290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6e1elYAWlc/NWkq2qYda2Yr2FwSVLwXAYnwAcZOeAiGMOSopLhwrHPIItbV/C+FDbaKYFw+nVRqSyOESXFLFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5447
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Andy Teng <andy.teng@mediatek.com>
>=20
> MediaTek UFS host starts to support 2 lanes, thus modify the
> minimum lane count to 2.
>=20
> This modification shall not impact old 1-lane host because
> PA_CONNECTEDRXDATALANES and PA_CONNECTEDTXDATALANES will limit
> the
> target lanes properly during power mode change. So we could relax
> the limitation in ufs_dev_params.
>=20
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Andy Teng <andy.teng@mediatek.com>
> Singed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

But then again, why those constants needs to be re-negotiated every pre-cha=
nge?

Thanks,
Avri
