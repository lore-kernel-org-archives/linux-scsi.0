Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01254C3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 05:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B477922CED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 05:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Fl8rRJ20";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TP49g3rK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfHZFzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 01:55:16 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:28275 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfHZFzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 01:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566798917; x=1598334917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tso5whEfIHIp/RSDmgB4Np84xeTOTHZ7IjsgiFcyEns=;
  b=Fl8rRJ20v7yxUZ3CDUM5M6i37jJGnAu9xtdl5iiccMKJBjQrPwELu7bx
   s77otoDyEWfgr8/fmNKenuUl8o//k+znWF3NEwa0xgXQjEokBj2PPrMWh
   DhTMqRG+MguhOFopKDzIW38lbgtF9D4hZHzxBwd5Qqqbjh56neL8z0DEb
   eyhY0rO8k3TkRvCmrnWHg/ZqvS5/QBOh52hSCstK68tW2NxsM5W/oy3BB
   eY1TEaCRl67vb1pbA9dERBO3Sx6MklyXZEAE6NfOY9RAcATjlG0xF3BFI
   QvYCyTcGxWIie3iYhwX6LU9C2zNQXd7Yb9JzMZn61eZqzj58aPq7vfDnh
   w==;
IronPort-SDR: sCf1jV8fwrwKjXswGSm3gURGPvHfsH6Lau1sL3z4qFFxoyAE9sSsO9rfnRioy7z51GWT4j/E1d
 xcngfYvIFlntAZvtaEKgKzDN/KBb0md8yc05HP1TQBYm7nZQipn5vZEOr7auA5fGV710qK/4/B
 C9/Hm+Y+lTBfmM3T8yVqdlDwOdgOMC7CYSZzWI+J6OHZNKCHwhxONJEv7FxywVswVf4TkXYJAj
 eknj2WgpB4pw6WWYT9j/oAllTGuNUX+Zdh3ZRfaP4OOi1NlI6spfllKPJYygQPNjw/tirpSaGf
 QSo=
X-IronPort-AV: E=Sophos;i="5.64,431,1559491200"; 
   d="scan'208";a="217121778"
Received: from mail-bn3nam01lp2059.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.59])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2019 13:55:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtssQXna0r9JH1bI4Ia0CWjm/phSrhOaM9TNn0BMUtklVq2UO/on9SIpLgkVEeW+KJuXhYkqcHPq19xeEhEQ7yB0SZwvDQFYJjn4eFX6f9LJtLhzuMzdlHERfes1UanYvEigwJJQcWMeBRg5jvPwnU9mG3Ot5cum4BYUdeHudIlukCzaTMVm9pW7MAu9kdIJN5hnqHDfeAqrZ8sPizNgvCTsLuFCBAtU9PhahdXBPGh1Gh3JFgTN7W1MrK0VpjjD0el9I2QSTPpFx0pK067Afi5F1Fa7S8BXifVbnRRxR5kq+QOot8nBZuYjqk31rCzWOgUOCkXURpdr+KSdt1uStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDGd1GQ5mOWpob9vEEb3yrIDmmDhT3iWrpCL7xQdpVg=;
 b=B9KeXC72i0yQyNyvnERrLolSlSk19vbWF9LlJxgH+D2o/cF7G21gNiFiEw0RlasXzhkpK3FTtA3hgvXfrwT06RdCh8RQrbHvHhL4eNu0JKiGV8BPT+VqGV/lBVG8dTbxxT+ZzR/w812wgU3tRPF7tHiL/nUzaNFNpnL4ZvgEE3+Ipw5h3NdAQJIwIBaoipKmg3v+fOTIFFT3fRrdGnz3Zo+JD2S5lo1yyecfggdnVIiBqP+w8clAGJOX8ZsripiKyBmV6JlQgAgRJZt4HkUL7THEC1tOnJwjf9DC2ixjlaD/fhjZ9mzz+RYWJOZ3H2IzTQN9vGUZnnLXOyiobkwvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDGd1GQ5mOWpob9vEEb3yrIDmmDhT3iWrpCL7xQdpVg=;
 b=TP49g3rKMr1EGT78fseA7WwfBrrEnXdPa5AL1M7vKork6IwSQ+13RGADB77YGYqgHM4/o1c/mRn3FaGyPhxmHJ9cp5liHNP2gG1krtemXEZiwVxSTHoxjU3KZ9u80C4h2pG4XdfhFcP/xve29hwBDah4XwJ1w08b5Zev85/MBbU=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6800.namprd04.prod.outlook.com (10.186.145.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Mon, 26 Aug 2019 05:55:14 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::2d21:f967:8f3e:84fe]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::2d21:f967:8f3e:84fe%2]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 05:55:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] scsi: ufs: remove set but not used variable 'val'
Thread-Topic: [PATCH v2] scsi: ufs: remove set but not used variable 'val'
Thread-Index: AQHVW6rxl1wpe9GijU++6BvKl/LOxqcM7hx+
Date:   Mon, 26 Aug 2019 05:55:13 +0000
Message-ID: <MN2PR04MB69917DEBB72E5350566FE8D1FCA10@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1566782149-63502-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566782149-63502-1-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [192.116.177.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58993994-b309-444f-47c5-08d729e9f6c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6800;
x-ms-traffictypediagnostic: MN2PR04MB6800:
x-microsoft-antispam-prvs: <MN2PR04MB68002998608F620846F1C79CFCA10@MN2PR04MB6800.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(189003)(199004)(6506007)(446003)(74316002)(486006)(81156014)(14444005)(2906002)(71190400001)(5024004)(6436002)(71200400001)(91956017)(76116006)(5660300002)(52536014)(66946007)(66476007)(66556008)(64756008)(66446008)(66066001)(53936002)(316002)(33656002)(256004)(478600001)(14454004)(2201001)(25786009)(4326008)(55016002)(86362001)(9686003)(7736002)(110136005)(102836004)(305945005)(186003)(8936002)(8676002)(7696005)(2501003)(229853002)(76176011)(11346002)(476003)(6246003)(53546011)(99286004)(26005)(3846002)(81166006)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6800;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KDSsPn6P6UJHFu6mDKDXnmEKaOzg5GMNliEJdJsfDZ/1AcvYW+YQFtMQmE1iaY8mR1SnC/9As/5Pq6SDXfCN+M8apV+P+TVuI/nxeBnO3SfBNI2RSVefHbvvwz7zWXDv2zshGaZF2lnhK8hwKXSIc4Zl7cXLc/new3UByQAo5Tsdlp8RFM3lxTpvb8i/zXOCkoZlz2sUR5a5eyysTdgslVdObQJ9tchTWQOgqUvlcUc4goEWg1CpvUl3r4UUOgG3TQX6K81GZQC9vAmlgZUdTVnTLgR97NBv0uRvfaVJjYgxL6+7rgzP1UF1xoa3NbZ5vJ+TXC2BVeM+fERSg8hW0icsZKS6bMUfI16i5oWKiwwKB6qY9fh6YL2ejXQzY4QnuUU57KL5Rdts/XTRBP1aV4O8E61dBH4rvg7XdT7NePQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58993994-b309-444f-47c5-08d729e9f6c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 05:55:13.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ql3lafDG6gNp/znzVQDKIVTFlWaxWCLHGViuge0Xa50OBhEdlOqo1YdE+fH0hUCzdhXsM6TigJ3iaA/G/Fml1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6800
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine to me.
Avri



________________________________________
From: zhengbin <zhengbin13@huawei.com>
Sent: Monday, August 26, 2019 4:15:49 AM
To: agross@kernel.org; Avri Altman; pedrom.sousa@synopsys.com; jejb@linux.i=
bm.com; martin.petersen@oracle.com; linux-scsi@vger.kernel.org
Cc: yi.zhang@huawei.com; zhengbin13@huawei.com
Subject: [PATCH v2] scsi: ufs: remove set but not used variable 'val'

CAUTION: This email originated from outside of Western Digital. Do not clic=
k on links or open attachments unless you recognize the sender and know tha=
t the content is safe.


Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/ufs/ufs-qcom.c: In function ufs_qcom_pwr_change_notify:
drivers/scsi/ufs/ufs-qcom.c:808:6: warning: variable val set but not used [=
-Wunused-but-set-variable]

Fixes: 1e1e465c6d23 ("scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from ho=
st")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4473f33..02cdcef 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -800,7 +800,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *h=
ba,
                                struct ufs_pa_layer_attr *dev_max_params,
                                struct ufs_pa_layer_attr *dev_req_params)
 {
-       u32 val;
        struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
        struct ufs_dev_params ufs_qcom_cap;
        int ret =3D 0;
@@ -869,8 +868,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *h=
ba,
                        ret =3D -EINVAL;
                }

-               val =3D ~(MAX_U32 << dev_req_params->lane_tx);
-
                /* cache the power mode parameters to use internally */
                memcpy(&host->dev_req_params,
                                dev_req_params, sizeof(*dev_req_params));
--
2.7.4

