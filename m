Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC95CC3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 13:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF4F22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 13:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="czj+54lA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bk6hbWzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbfIDNiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 09:38:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:58339 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfIDNiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 09:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567604304; x=1599140304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QEBDlRk53d2YIVuVwppq7SB9yVMPS2NMj+ClfyESP6Q=;
  b=czj+54lA1In721pNHSl5GbVuPm51Ci4f0WRgpcprQnprlsHYEQpedpXG
   IJduUMMVK6jysDk/ak7Ch75R0t0lfK3LAIa4owo3EgqzupLq35HfeyFiy
   UYmt9JK5q8p8gOmZpP4D/PaogTCxtQBisBddCp0eZvI9lUZj0/iqLBrMc
   NqnSKIX5AnegtWlNL+h/TN6FsPcLJMQz1+UlD7eMJBTv0YySZhUq91Kbp
   VMdBF56A58rW9xVT5w+ZRvQgQOD8xjMO+Tbxpo6pKOky9W90AyqT3P2Wn
   BiS0BRxx2B8EqAeu2VdR2RtWrU8I2L1oT4vu+oToTLvYO7VE4AOxWCxjR
   w==;
IronPort-SDR: S2CkkG+gQOGr1APQN4i3h16nEcVVQ0m2PNcJ6nn0JDpEV5GQ68V06KeWJezArRzeYCTma4/FKT
 wzLrV88OUacvVEi0255S5B+fVN1bGWYV2ySYd+ld3ESdK32Dq+EAtUJR3Ir4slVYPRCBNEGfGh
 rAtFZRuexvXVynjzvsRa0/jeJU1d1qxwxMjzi2f2BMesHxQRokkrx2/lkDpEYI4Zesa3L+C0FF
 io60FWlK7oxNSq5p3hRQay6bN49GpBdOCij1rrDwMLwHN2JX/iKZAu7NgBKGtmI30DGCHA7CvJ
 mfo=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118977239"
Received: from mail-sn1nam01lp2055.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.55])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 21:38:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDzLOnZFcRqxzCCTj8vKuGH9XhYJd6+o5swHUZpV4BsMKI9sYedm4WpGocFTDH2Lvbo/d6cSua9Y9ezAXEdEIqNx/7Gv/HzV9XD56W4H9DAXAcqGcTGnJhdbrARy0gRxuKxPDze9KcwBbIbRmOIjID+AOvE6n7Kul2Gf4MIwq+h10rp22ZedpB8qMgcX+6Bf1O4511otWm2fKFbMIIJzvtA8tYh2kJFxwrpOc1tXqduVq8IKVu+jWJH2t7CjL45xYJ1Z0LiOuv4hSzrxocD5VFU/eTusZskpjF0pk3i+EUAklpO8VLwQkODI5kqgcU0sixFsYN7FV1T0/nJVqZqk0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEBDlRk53d2YIVuVwppq7SB9yVMPS2NMj+ClfyESP6Q=;
 b=FBk1004aKIU4c6oD9+yEbImdYFOGyvHL9aKb9Y+B1QIR1e3kujiAqcJvBGy9UDgBZk3lhFXmL1DJJBSfgScQUeH1suHeGywCrpRAC0STM6pMlPBDLFDD2RVe1DuR82+kPoWh80TEuLjaWm57eYTAHyPMev6QJ7ckxQDuMfSJ9j0CUWQHY5Dl5jdI4i6RGJEjKIXNsuWiRQks2nfq+p8V5ApVXgDa07crE3CPp7QkpyjGWlBhynStZlKYbDpowSY+gkEMID9pjU6im/dnFS7zoK4CkY8PqCVwE2djhPaZxY1hAcdOamXmcoBSYskPiBCZ2zSIutnyByGylrHQBEotFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEBDlRk53d2YIVuVwppq7SB9yVMPS2NMj+ClfyESP6Q=;
 b=bk6hbWzbBO4at4D0sL8h0M7kRxACFkPokl6x3YmiqZlD1kcjz7n/zaFhCnf7BkMkqMJzrTYR0MOv3JfDPai1j+UQvNzIYQc0ZWgA1ulZqtyhEfyfSRWE3UqEhXnCHTofTHlfUFa05+r/yRml429W6bwQjSvYar1oLLM+nGJkn00=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6207.namprd04.prod.outlook.com (20.178.247.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 13:38:21 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9c2b:ac1b:67b8:f371%2]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 13:38:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] scsi: ufshcd: use devm_platform_ioremap_resource()
 to simplify code
Thread-Topic: [PATCH -next] scsi: ufshcd: use devm_platform_ioremap_resource()
 to simplify code
Thread-Index: AQHVYyFNcbv0BpeaK0u9DOtRqqxMvKcbhYrA
Date:   Wed, 4 Sep 2019 13:38:21 +0000
Message-ID: <MN2PR04MB699101C0087D9F902629FC36FCB80@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20190904130348.24772-1-yuehaibing@huawei.com>
In-Reply-To: <20190904130348.24772-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e3cc7c-f39b-400d-f2dc-08d7313d2719
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6207;
x-ms-traffictypediagnostic: MN2PR04MB6207:
x-microsoft-antispam-prvs: <MN2PR04MB6207E6A4B2E85847A24D943DFCB80@MN2PR04MB6207.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(189003)(199004)(55016002)(446003)(6116002)(316002)(2501003)(71200400001)(558084003)(54906003)(229853002)(14454004)(66946007)(74316002)(76116006)(3846002)(26005)(11346002)(8676002)(71190400001)(76176011)(5660300002)(25786009)(53936002)(4326008)(256004)(110136005)(8936002)(7696005)(2906002)(33656002)(476003)(186003)(9686003)(7416002)(66066001)(6246003)(99286004)(6436002)(2201001)(7736002)(305945005)(478600001)(6506007)(81156014)(64756008)(102836004)(66556008)(52536014)(66476007)(86362001)(66446008)(81166006)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6207;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2L4osgAbRxAiAV23omt0+TJK5bhs+WadPHPAjhFAz9CqoH+bWRx6y6guggw4dJWWvhm7W0VnZEIEPtJuwAMW8jYEEiCGg0jdVPIHuaKJgFkxOgNZzsKh1vIPuSiXgIiw2otc9G7fFnvW0th+Dosl7NLqjbkSl7FjOA/rllCwgygjzdXayh/A2+BTMp4qqvjIJfETwtk386vi/qiGt9PZXmj4EXCaZgsQY0MCBxVx/RqLjsSLW5KPS8KJCDjE9XUYSfDfaCNJcJydUnCVbM/4o3PE2sRzJmh+9bl3+voG22IAY2fP9S0JTSMK/MkTlLMTrKJwwJkYXVuT43AVMDkTwrsatLZ6S8Z7SwJ6S8izlZsh5JMaqLPU9vAeR11q2JD6i3Pg4fjuAi/O6CKyp/tg6vePu12GvqLD6SpbOrVwbUw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e3cc7c-f39b-400d-f2dc-08d7313d2719
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 13:38:21.3171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iOKV2GLtwOVGIfctlC9uYVTsWoJEY1584Du61WhWK6iJjq5LtYZaqZDqE1RO86CxcosvAUadMKEZ00lMUu/n6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6207
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
