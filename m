Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D30C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 19:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63746208C3
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 19:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="QVXqJM9V";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="uws01eLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFRTOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 15:14:12 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19268 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgFRTOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 15:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592507649; x=1624043649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hyFKrgEtTh0jqNk9ds2u8Mg5RScq9ETiPJVRk55ToT8=;
  b=QVXqJM9VZ3gh+KKAhJ9o7MZCcsPch+lrZluvCPEUamdN+MA6qvDJG4y1
   q/8fzUFcj2lFI121PmY5JVKLU4zHGoYZXIittn58P+2XIfuy0qI5RTaDK
   EVieWnnVDrYk08fFBQRfBxMiNEUsP8yEqZOHhoTmhANVPLJNEPHdIZ/iz
   92ftyb2nAuYOmHs+CX7JNapjyKFgvZSAckIacO0VkYElo15CEF2LIvY52
   pMCdUAAULSePjdViwdMQqAyOQVgP9GroEaXbrCm54vy+6h7M/CrvYfKhY
   iGQv65NGEA0NVZUoXnEAnG88/6ONa1697vw3BqkOIjOYpoxXbpLzYy3Bk
   g==;
IronPort-SDR: beUXWtB787ZBfq0ryZwN+wnK1OXtvy737Tq+VMaNdJVLWRsFs3VVwmMcceUBuUrOiZk0Y9+Gsp
 zxFJz15i98QY5/gf71G61j8idMaJrcrepkYPDTjI0dW7dvi7nsBtcG5SovJgiXscIzMLjGOzC4
 oHCKTgMVsgaQosa+nAb9VOEZ9jKpfNzgRjEjz2OaBx3bzhT3p1+XJmo5vf6m9+f3m0ngPR9O63
 +ncK2lWbJi/ybtkBB3B9PLl10lyh+RZVQlCeBBYSM2Mo+t+vKqEwg0f3jIO8urspES81IXV3dB
 S5k=
X-IronPort-AV: E=Sophos;i="5.75,252,1589266800"; 
   d="scan'208";a="78999932"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jun 2020 12:14:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 12:14:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 18 Jun 2020 12:14:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OV7082n5+amLyZ3DMzDqLFDKHgE3dTVPlqAav6kGR9xn2aYlcnC5zdwnfOzE/ClYbNEvXUPJn9iwhg4pv0aFzR228c2L/GMq59O4c8uAawYj/k6hO8WK180TbHaieuazuyjqOycIun1z+YiNtc7jhtmzHR2JnB+gw9IkK+qV6aRQqxOpg5Kd0GDRA8qVCvHzbxplegHdxw7l7hoI0W0YUhTPOb8mcMVDf/CFkVPNmSkmsKmme2Qioc7UInJqljbO0vFJafv5w0qX/SRFu9KaDV0cfvcqf1+S1mGiFCoQQuP3LDxkwu7ga6O/nvEaSJFL3tPIUktVKO4shkrmqdJ8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyFKrgEtTh0jqNk9ds2u8Mg5RScq9ETiPJVRk55ToT8=;
 b=CY+qgHepCYCxn1CTThUnvjx1VfKk6ZRasiLq0psjZcSCqG43kPA2UwvGlZWoUg/Ew9AvvA45j9Z0UXK7Sj7aJp45BMa14aI2zlcEW8/AnpYJRtXjEARNSMpYQJQN86kzpxUSBx2zxiAQOBqUflDfRU9CfkoYjnEv8xeajssW9syehJqMX/IzMfevLd/jt2ulIHONusBW8D4UM26E5nt5k7zL2OsoID2eokIAFvpzUDJq3XSa8xiCkEUYoln6IBilbwPk3Nnu8GW7/YVf+sZUaxAK9xFbEyPisxpitx1AcBEdpqiwpW65hrITASgafqrqljrcsYP7md2o7zFepwB8ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyFKrgEtTh0jqNk9ds2u8Mg5RScq9ETiPJVRk55ToT8=;
 b=uws01eLWdSFAJ/yHITe1mZEi5ID2fY14v+G/9WE7z4sen4n+4lcZwv4bkZI7FyPMMgIHKi0AsH7HqbQoRqzZ88zQaLv/a5IsaVJBK6n6Uhzn8yFvmpYlZpJZem5leygEgpLL8OvkahDk+5uBJoESZU62MLxNx6Z7haOujyTPjnE=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3517.namprd11.prod.outlook.com (2603:10b6:805:dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 19:14:08 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5907:a4c5:ee9b:8cde%7]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 19:14:08 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <don.brace@microsemi.com>,
        <martin.petersen@oracle.com>
CC:     <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>,
        <shane.seymour@hpe.com>
Subject: RE: [PATCH v2 0/3] scsi: smartpqi: fixes for scsi device removal
Thread-Topic: [PATCH v2 0/3] scsi: smartpqi: fixes for scsi device removal
Thread-Index: AQHWRIJZE08BPNprAUyiUXsfulgsfajev4uQ
Date:   Thu, 18 Jun 2020 19:14:07 +0000
Message-ID: <SN6PR11MB2848A39E8B726862BF2E9500E19B0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20200617083514.19174-1-mwilck@suse.com>
In-Reply-To: <20200617083514.19174-1-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.211.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b83a8cc-ba3b-4989-7007-08d813bbc662
x-ms-traffictypediagnostic: SN6PR11MB3517:
x-microsoft-antispam-prvs: <SN6PR11MB3517E051DAB8EB15F659BD5FE19B0@SN6PR11MB3517.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F+0kvmcPpqpi8SjgUMXeDhnKE8SEL/tgmYszRpZCgKzAdCcFpuc2/qcJXnTQdsmsxF2fA9+b8TeIuHYcbfvH5xzpNsjeS4ZC+cFKJ2okFGmWdDWo5nLtty1/i89SN5gY/xnOZCTrlcG3aMvAv+PXj4p3eJPwRgBxdCqdqqzXb38Eo3GQHURk1Lkh792aP32j/fRvpHm7CIuOZSlUBscGzFGaC5q7OHPHHzRyR7EhrM5ImyJQPzcULi/5uoyjI/PQqp7AheKvnwmvhOJpHK4JNMDAjzVTvN5eZ6U1fVIYM0yKaeEDVb2bakG2wkWa+Wem6TeAj3QR1zbhAIeeVWmxXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(71200400001)(5660300002)(316002)(54906003)(110136005)(83380400001)(4326008)(9686003)(55016002)(8676002)(8936002)(478600001)(2906002)(558084003)(66946007)(66476007)(66556008)(186003)(86362001)(26005)(6506007)(7696005)(76116006)(66446008)(52536014)(33656002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mfKPfuNWSRiquQSqqbHvkaTXkqSXFGdjNemVN9HQMNLs7v/+jeuXvqjrE3gJJek/ffvsqYX6+VF0eoD86uQ7oN54RAipFAlVN0IqIHSH0AL+smm/apw+keNo5CgaXkgcsqhnkuBynP1QVs8kRsp4mpsOK4jto3QzVq06Cxjut25Pf80aHZf5rm6oXSJLH7O0ROaKSwsSWjIeFOXGcxQ9uKmfFfJtdnjtH00/UX7DXSy6iKT76T9V7LIHRwkM3VAlUPcYtteN9Zm+dUcsnyUXYA/gBNgQHTM7q+UNb1fwpTv1ZOy0NfKgv+JdGwwF5R55Nrkd2YA9ufuc9pC3nIQJ77zyrQlkoF6I2vaEjyXRlbHbsPAFvthE15mSDf4dZ/wemU9BtCw8s0S2cf2DXHMpu3VwZdhX62DrKRwe+wa7rrG3EHyMOZATcjZx6f4swoQNf+hpuOObnC+1srL3QexbYBqah/WN3zUTqJx0YK9HpX4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b83a8cc-ba3b-4989-7007-08d813bbc662
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 19:14:07.8978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AB2qqkIPZZnUWjJ3VJOnerQ2Ua88noAaQkx0enhjOpDzfJNR2cfTKBGznDA5BZP0QZQZM1RFdArCk4ijTtxiTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3517
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


From: Martin Wilck <mwilck@suse.com>

>>Hi Don, Martin,

>>here's a small update for the mini-series I sent yesterday.

NAK
We have a smaller patch set that will be ready soon. Currently in test-phas=
e.

Thanks,
Don


