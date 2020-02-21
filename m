Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90777C35641
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 09:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E42222C4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 09:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e9Ofif/r";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qwOUUBWL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgBUJtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 04:49:36 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5909 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgBUJtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 04:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582278576; x=1613814576;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=35H2XjP9XK7nrJjVEAXOFB5t8KVRX1rGhmKaJr2u8w0=;
  b=e9Ofif/rEbdPN3V8kd4gvzMRAyilou/JQukyX4+TF2RF52XnPBq4jmnS
   vtd2iHPezWwNkUMX2pSI53CiV43SOwBJNrlOY7gxON65Pur+2KLpOhUBX
   Z00GVFQPQokbsPxddZYHiqQpKQykJmMLeu2UGktiU0TARhqVbJ+7PbxxR
   8itKAawPPLxdb+OLaliUTfTvBh0fksm5f8vKldGGWLob90ganYdENrykE
   KM7pY47uMXRsjiBQ3YFBZFD+i0NPlDhp9CCiYY3ZiZ3xd18+3HCW8z1et
   MC2P1MecQYbyLCVI3RK/JnWaSbIFMbufiRIObDF7YrExkoqgzjvB12PkD
   g==;
IronPort-SDR: mf1pmw/0QySwsJg3GojiaWoRt2gYSpgPJxH1jbxBvF77kUTn2VaiHpZWrCZ/iTePI8q5NYZKbi
 pOHZu6r+sTH/IdzXdskHz/2wi3hE+t85MweR27+7PawNwFwYyUdDIN8LA4Gvu/ukVGdJBljrK7
 QXfP75Fgu0iPwmMz3OQtziNepr3wCC9Xzp3ANE9iQdmKnGJlnX9Cf/bJl0BN+a55X6sFfPZ/fD
 mw9Pf5yhkLMmnF5rFt6G6xRpGDDXpvG7F8KxlpvLIk3yRcamzebh13bsPoh0bo7qRMGX28vfZB
 324=
X-IronPort-AV: E=Sophos;i="5.70,467,1574092800"; 
   d="scan'208";a="134740450"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2020 17:49:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHSVr130RO1BxHPYJGkWoJKleWi9nhQ7BBszq4+YSBFJq3Qcj49Zn6grI3ScoBERDvklA+bz7P7IQ113sfv4c1i7I+jPvmU5oJk2bxY4lVcv0VSUm8vUWBPAe0TI7tzrvFA70oW7XtryzTFq4LaljIGYIOU9KRKlmZ+2DE7HScpe4w0ysaJTfVlLZV8ul6u9MSkjoPAf/W8ak6Ionq1iqRPwrtQoxzs87fTMK//PVGWu3kCeU4nw0LF3M0JLzleMmJa9eqXrMD/9IMsTbfKdO+OrK7wAILX77+4evhBWbr7MVKTS+hj/Jq48hyol1nUD8flrKWdoOr+pV9stqFWS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QGqy1tfX5RAakmiiDOzSOwNh+WNl1ng+epGS7w6avk=;
 b=bX4DR2E876cV4ow+aB96nouwZLe7l0XgKSvPTgA1nOgSh3/mSGmSoIcYtluyA+eL/X/YHnJIKe3WM/1mRB3X/Bn2H5KGgaDO2inJ0HHhyco0SRtiQvHjX2TUagk/fTbm5amsnf2sOMewZsj4+oQSfJt949THaci+9rxeQb91JeEYG4FD5d2mrzRULXlm8X7EHL5HfqNzZ9uKQ/W98WN/e5EsitJ8Nk9T1g4mGoDBCtKK2DcG8FOZ1ze91h4iR75OdaLycbEJAPEDzn8g+q2qIeLGv5UDoV95QeoPbxUoBSbp8DeYDd6/LYsiCMStOgJccQQzbfwUkgovE/w12g0mHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QGqy1tfX5RAakmiiDOzSOwNh+WNl1ng+epGS7w6avk=;
 b=qwOUUBWLOwk2dKi3xnIAishMwO/Piy0YvlLGubYFAb3+91JBO70UVkoewU/iW6AHlK+jp70Z/sZmDxA9S4mfyJmE8DOzllpRa+JkrqHKhOBF2jRSMb5eA7oFuXexwpTxXIu1Irm183FqYMKDfYT3kyRXLE3F4eWC6D0PpXiQMuA=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (10.167.109.143) by
 DM5PR0401MB3704.namprd04.prod.outlook.com (10.167.110.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 09:49:32 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::2481:ca52:b929:3077]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::2481:ca52:b929:3077%5]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 09:49:32 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 09/15] scsi_debug: zbc module parameter
Thread-Topic: [PATCH v3 09/15] scsi_debug: zbc module parameter
Thread-Index: AQHV6CmcSg21fCjsakeEuIqAfzfsJg==
Date:   Fri, 21 Feb 2020 09:49:32 +0000
Message-ID: <DM5PR0401MB359146F8251034D19365A9909B120@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
 <20200220200838.15809-10-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [46.244.193.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a57c2543-b7a9-461d-605a-08d7b6b35a08
x-ms-traffictypediagnostic: DM5PR0401MB3704:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0401MB3704FCEF904373BA64DC23039B120@DM5PR0401MB3704.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(199004)(189003)(4744005)(54906003)(110136005)(33656002)(71200400001)(9686003)(55016002)(5660300002)(4326008)(52536014)(86362001)(2906002)(186003)(6506007)(26005)(66556008)(64756008)(66446008)(7696005)(53546011)(316002)(478600001)(8676002)(81156014)(91956017)(81166006)(76116006)(66476007)(8936002)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR0401MB3704;H:DM5PR0401MB3591.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EWx9c4a2Fu79nJz3ReoD8tB4yKzvrS7CTLSPkF/HkTdKIo3VDQJlc6HEwaaU/iPaq2mRif/CuISIhfHWEAGVzJa0L29LWdShM5qBujqrs526RDfOzjw/5PckB42abHDY7B7Dbjq+4bDooc9lQah/5VbRyyswONuaXcTwLhzzaclWZbKPNSCZnDP8Qrg7JZV55rOxpHx8cgKCNCKDv8DKt67agUSQm52XQwlUxHOrwycRQGeI6hE12BMjF+xsPm9ZQTTd0GQPXuWuKTh+YxGHWuf3Q+OyhI2ayTx2/iXzuyVkfLwBhSpgsGaPAk33Fbtbra3P/y/WZO7yhwr+g2ukeAxs/V0kNX/zTJ2/+GDM2p+cGbHOT76S4KQTwXP24r1t1y/M2p+NKOaFNi+ixFuTgoQe/sqCTd1ZzKFS6EQQav2J+8uMolYMiNB6TuWJhXWV
x-ms-exchange-antispam-messagedata: kfQlgzHDivm2CF+u/OqVivKY+uUsifdpGhXI59sqUrlg0t2yFU98L1AjrO/zxuRl8h5GNEkdDcc3D636Y7jbgNpyo4h7ZJDW5lBp5jGJsqy4NYGKJZGzz5inSBXZ9pl0EKXU/ZUVv8wPpCXnWNQehw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57c2543-b7a9-461d-605a-08d7b6b35a08
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 09:49:32.1354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ohDEzk8aIgn53pYfPQKYDJED3CM9kFrRXXGa/Wd1XsjEdr8IgnEZs9Fgifr9T9OiU5wODOUxiNiUlfdiPc5FgKHJR484DNz4Cb2VlACNJiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3704
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/02/2020 21:09, Douglas Gilbert wrote:=0A=
> +MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity e=
xponent (def=3Dphysblk_exp)");=0A=
>   MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recover=
ed_err... (def=3D0)");=0A=
>   MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=3D0)");=0A=
> -MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity e=
xponent (def=3Dphysblk_exp)");=0A=
=0A=
Unrelated change, isn't it?=0A=
