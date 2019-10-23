Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C210CA9EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 10:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C262064A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 10:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cneQ/nKt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f0jRZ8Oh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404530AbfJWKdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:33:20 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404332AbfJWKdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 06:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571826799; x=1603362799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MRAouh2VRVHhVMAH/E+k/pdKQ9zmNfZGhoIN3rQ5FIQ=;
  b=cneQ/nKtaoaPL4eEvC3iFAbqq1aPqtAHiHWUrCifp5fIBIS5GCS2ymeQ
   is5uDNd7iQe44QQHDUHC8eqLA5fLvPulBEDyI4WaMEu2AX0D7abCjTd4L
   pbqLlpwEQ/h6LiW/PqjI10NSqKzo5WjJpWLFLoRxtR8IXdsBDGqe/jcUv
   zx8mquu7i6EzU/1vWCXYk7t6MRDtPWIFEtx0rNyKElBJzIyUCNdw3pyS8
   uwIObEijqpvSizi/I2gLKK7u4t93PZdd87I+JHPo5Fd7V/DTJXTJZhns9
   8nMpFN9xXxHstHnRr+G5FEBbRV3gZK8uJYSRhOmTCOfWvQdD5w8Ap6826
   Q==;
IronPort-SDR: 9tV5ArE5EfhNEyCQKSuHyj0Kio3igHPAL/Xedt+WNp6pm0nWD6UZ/uvIebDSqN79fruV9PhUJP
 HiFLq0vEoypHsW4NSm1BrEMNrL8PQiTKeXOQP0dG9emYK9UehCjCD79rG+ZL9LuObDR+mi3AIj
 JR5Mb5bhhT+6xOLPwc3Es63n5aEDwVgqjFbp44DM4l9PEPneR4CbAM+7OiiDzdvIORM12AWOVW
 pah44TI+MN8KwSAlwe83IjgB9oYRJLAxfugZHKuEp2TnJsTs7BDrIkPMlPbPBJPTzvHeA6TQLK
 E+w=
X-IronPort-AV: E=Sophos;i="5.68,220,1569254400"; 
   d="scan'208";a="122723483"
Received: from mail-by2nam03lp2057.outbound.protection.outlook.com (HELO NAM03-BY2-obe.outbound.protection.outlook.com) ([104.47.42.57])
  by ob1.hgst.iphmx.com with ESMTP; 23 Oct 2019 18:33:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcN/qTaMhje3YtEJaS4qIaX/qHn5wkDH5K+njBtzn2Yn18RnDept0lL/Jpx3QZDPrlTHKsPWhtlASe52BDKzZDX+DBUXWmGc6cF8e9vcevt6NlmhV9pqke+Z7fsJpwQSGvB+cQVl8rmOAvyFlq8nB4XNzUs0LyYHy9lPaRCvIqvBDafB00JFnV70npbBd5gpKv42hkvmdrOwl6z2sxFXSPDRsUOkrNN3Al572fJDIagST2ouPDa+p+ljD6t3GJTaSyrbsoFuE2UrYLAqQbAJ4nu+tJb2fsN4D9solVaKLny8prAqStTPKE3CJSkZtlWtfro/7o7/D3GBM2jz6W8P+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRAouh2VRVHhVMAH/E+k/pdKQ9zmNfZGhoIN3rQ5FIQ=;
 b=b0khvwdNNqIBaUnlsKYU20pkooDxuTVQZtLIno1DZ+BCMgZWzYiIwQJSwkLWyMbiIOy0RlmuSZHeZ1376kCyx9Z+fz6rsIICTV8hY9lafQF5O+PWKTUCS5cp3oV/P/h3oo4yD5OthkuSo+bLNcKLbLc2Wemb0HUJTWOllBCRS7GYt89H1Z6H7gK4l7xFlJAzAd43WUfmrjMEYFkeZGmoXTufr2ddZ19lVhtRUWWDjCPQPKiyolo8EiGwrkHXa39AinGY8mKohkLHrEUIWjoGvMvslaJnK7wJdBIMioC2EsmdawWlw0z8ung4TMYyCh1HIQBzqapNajEo72GeQvPzDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRAouh2VRVHhVMAH/E+k/pdKQ9zmNfZGhoIN3rQ5FIQ=;
 b=f0jRZ8Oh19RlN9lcxwpmeoS8EUY2y3GCtwj09lVRm9PrCqjSGfeSKSbzDlF32HQ1eBAGV2OJQRQ6SfznfZpskQc1H2d51EbWdWmBzqklIcbq2APvUnKwHCch8tLpjZbCdv7Z9RuOoRSQo4J9brqxtwvsBEKp7Sy0PByxsFp11rI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 10:33:10 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::cd55:cc47:e0ff:1604]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::cd55:cc47:e0ff:1604%6]) with mapi id 15.20.2367.022; Wed, 23 Oct 2019
 10:33:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Winkler, Tomas" <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
Thread-Topic: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
Thread-Index: AQHViWLhprkG394+5UW4GUZ9ZO/s2adn01AAgAAzmCA=
Date:   Wed, 23 Oct 2019 10:33:10 +0000
Message-ID: <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c71b6ac6-c8a8-49f9-524a-08d757a466c8
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-microsoft-antispam-prvs: <MN2PR04MB69911AF741D0E99BD6BD8D8CFC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(199004)(189003)(2201001)(81166006)(81156014)(25786009)(4744005)(66946007)(8936002)(476003)(186003)(256004)(71200400001)(486006)(71190400001)(446003)(14444005)(3846002)(52536014)(2906002)(6116002)(8676002)(66556008)(66446008)(66476007)(64756008)(11346002)(86362001)(55016002)(33656002)(5660300002)(9686003)(76116006)(99286004)(478600001)(7416002)(110136005)(54906003)(6246003)(7736002)(4326008)(305945005)(6436002)(316002)(26005)(66066001)(74316002)(6506007)(14454004)(2501003)(76176011)(7696005)(102836004)(229853002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6991;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vKW+kisKbnFR427rlDim/ToXELoye9A7I/0YCmH/RLBjTHk4iLEKqPUMhBkM6SKMt4gf3v/dFQFf3LwAd0kgfM8PrKz+W1rZ+UnCblU03qnGVLYcUfLVJ9or6zJwW8I7hopJ4u8A/92eEVoSnNESkm3E2SRQ5ZOO7Sp10+/pxRZ4C/3eoBdfLdgsKN1spiShiPBJf/8Q/Z2ve3R6pQWC1sndZK5XuXigpXwx8Q6LUWElTz4OTnwg0UZJzDXwmzgBMiMOB4uqLUjADXlulWI+9Jg3Im/3P1N+AvceJvfgNI04vFxiRixTgxBb+JXbFWZsqzhI5OFmD4ncyqEE5PQPS0UuC/tWWa2Qh4rMtOzsePemEBM5N82qzuUIIQcwAS1NQbjsEixQ07tLS4gi/2+oJkO5fIIyM7u/6t2Q5mnJPT/q6KML86YRm6o+Nq32qBqJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c71b6ac6-c8a8-49f9-524a-08d757a466c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 10:33:10.4741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: omN+G7DuKEzDYA4oLbYXYvTFqyjfqgYTQ+tDFvl1do4FYc2h+HBf4oav/ibxy5kKrwJFXlcQUg0cPdzIsEwqhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> > Add the necessary infrastructure to keep timestamp history of
> > commands, events and other useful info for debugging complex issues.
> > This helps in diagnosing events leading upto failure.
>=20
> Why not use tracepoints, for that?
Ack on Tomas's comment.
Are there any pieces of information that you need not provided by the upiu =
tracer?

Thanks,
Avri
