Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70242C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 10:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9F62073E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 10:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IQM/eID7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="z5jQkuJq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgGAKKL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 06:10:11 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31336 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbgGAKKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 06:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593598210; x=1625134210;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KbN6wtyIukU+eRPtx4kpOJ2NEitHj1g8hleFUqs4iEw=;
  b=IQM/eID7XdsCFm1UPEQYSGC3IwPNlifKHvzQuggH1DRhQWUV253T0nqs
   RH1P1rBCOHS5WvbGtS3v/cR6ZAE4bCySTSA1LP13xVf2R+lhKHuEQTz0N
   w4LqoR65DasShEOnUfN/DUiGsBPd2fpfrjk9+lrJj0bMS/xjUonhCcmPQ
   Ik6Y4n1EbuwI6jvDNnka/1ggWW2s9rltDt4Pa3SHODFvGgJXJ7S4VK8aN
   xF+XCZ0fOWsKBDFsIrq6d+AoYulqYYdBQVWZLFXuS1+wtxk3wxapLvAAE
   jlcyK19WvrpaM/3Z8/mKYbWeDHwXddIx1jReWuBCeRWGTpGuHzRBAAhZF
   g==;
IronPort-SDR: lTD1U5mMzmfUh4XcHh5r6/utP9Ruo2P+CZ8lvtaJ2ec/sY6tChqidRD5/Dcu2Soi9WnnxUpcn1
 TFBUzcD7HE1fwu1Rn3mPk5zRujvWT+pNaWr5cOmhBoylRBO4pq9n4cer5Mmf8lh9+lMEVYzsc7
 0duiKlCisZlS4nGezJxyvnCahHVLG6m/MTzzXfXGEXkXvbfDFI0OC3ng0Qx7MpUuawqTlLlsKw
 bqIm0TG7p/eEJhv4rUoxnWxs5oN3AYu5Aod0jZqkj23Feo1LTJmLNxJk3AcjqArUOvcB7EX6cW
 3Ag=
X-IronPort-AV: E=Sophos;i="5.75,299,1589212800"; 
   d="scan'208";a="250603494"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 18:10:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF9tCTDPMw4VrBR3pXATFZ7HNEfzOhtOVAl1p+aFjLQbioolxL3DHnVCWOFtwAaAWM/9XVrFVu3bGS4FaF+PlJU9z9KFtHXCVXXNevnOxbyk5HZVFn0xw5ti1cj3iYd9doF3mb/G1V1fkz8xDALKwrafGIQ2BoHyqZE6ksbLRsJY/0QM+Xj6LLan91ZCEUEXF+lvnO6dyacGjPEeq1I7dTe93MjqgxvqAuZzm7yaJ6urwrakSvNxS6c4lmZuD8lLXDJVDQm/wPNJwiwvpoxQAP3hfhcE62iE9pTjzQdWxMghSyFkAhQg79QYCnd4dKknRX7bRbe4tVFEQ4cF3T6ptw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3STEK6MS3EUO02G8R5ln5TLQ2Obfgqn41fVH2TvJ9xw=;
 b=jDvZCsoXC8Rp1ZA/sKOVY628RJEEgzZeTE8str8WEqJYzNqCerWH06IcHtw+iEkh7fkZ69lF4V/2HBPspYqZ93LpJ78W6BZvyfMohCuWrYS+4gVg/oncgWu/liCk4LI1+2nBfJMEMVdEySF6xEmt/TbrSi8IlQBtCtprKf5MYv8AVTMnzHZujUFbkCXWPvHRjN2e+SekiTI53Po3g2YuTjaVXoK10iw1vwv7ij9pn3okNI9YnrAMwWAjV8Cq7vTr0gXTvDAYTq2T3t7lEZ7z/yx9K8oQy5hGU4QqUoKFZyptB+Gl0TDSpp/XomgiLKR46LQ9kvsQAHsMtEgapzJOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3STEK6MS3EUO02G8R5ln5TLQ2Obfgqn41fVH2TvJ9xw=;
 b=z5jQkuJqN7pPmj8FFcURxlCJttdAoP3K/TXuFM8Nsre7KjzjQnIZU9JUmw3nZdZr8+yjbgZ5R3fqJcRJZhknxxUkVFumS1kpiuCIsiOdeeZ/6OB83UN3XVXfmsMeHy1MAVILdsNDwHjqcHj7jC1nD7OefylFYeCwWMicdpfMcA0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4605.namprd04.prod.outlook.com
 (2603:10b6:805:b2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 1 Jul
 2020 10:10:06 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 10:10:06 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Topic: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Index: AQHWT4UHyypkjO12MkqbAgkXoaoEPA==
Date:   Wed, 1 Jul 2020 10:10:06 +0000
Message-ID: <SN4PR0401MB35981C2AD1B925263A35B3C59B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200701085254.51740-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:115:56a6:c821:2683]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5dbbe361-5894-4d7b-9fc9-08d81da6edee
x-ms-traffictypediagnostic: SN6PR04MB4605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4605A06394A92A0D776AB6399B6C0@SN6PR04MB4605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mcO4B+51lad0kjVzJR0G3fym80CteJlyX50kqqfwDH8FVBxIOyVAb6U+Mauo7GxFKgd3X6kTYQkcSZooyXpFFRsmrFQ1jIbKeskYPktemsE1M6SozAag8Pbs83vG/qNiF1Fjz/fL3xT2jWoaaIdP/ZbqCgxpBv7BCjsK4IRy67cza2uWnQnftJuFRNDE1lSNQS+LMKah1d6NhKH71Sidjcoeh65J4gETGL1nZw95dsu5Su24UKClFppEAeyFU7etGaburksAAa7AQHwrfXsWN7LzTNZZDd0I7LAuzRYNjZNpMes4beo4Et0SvtraMkE9vXt33sQyEuTsubBxZeGDJivRw55hc0TnScM2r+R7GiFrJo4/KRAuQgm8E+hzWtEr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(33656002)(52536014)(83380400001)(478600001)(9686003)(76116006)(91956017)(66446008)(66476007)(66556008)(64756008)(66946007)(2906002)(5660300002)(110136005)(55016002)(7696005)(86362001)(8676002)(186003)(71200400001)(8936002)(6506007)(316002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jaX1Kq0C9Y5ZbyFKX4czaXk3v8CXYXazQa3vIw4z6DLvjdz5lQzQa9CpzjX94vrNVNPnzYRqoqMRbL6Jo3qfhN2DypYOKLSQb1o2wirNuXbEkA7MM2Vf+BwYgqPkpa8NLM3ZaRdAXCiOnmKub/mWPA6LVxAb3Gll0uSHCy2X6uppQ+h37lN8R83cakU/ioEdU81fCjQZThQ60Czzc+maSqbA75Ux0Vi8aiZHmN/Dlq0VwGYHy7RJb0NNAMSUW3A9RM4R4R1vhKApreFCFpxGKEMo8aCJ+UbZYPr6FLMMQb47qRG+C1hw6VcliHzXThxaRjkpDBVXqq+Cc6bgbVZA4PZPpGfcBPEns96/8ZTYzIyRFkuq4v3hQab7SJkYxEAj8Hn3Pm3WqvCbObDDJpqKmlYSY65IaoOIM3VVnwIlxW8mH3uVqnzyfy3o38y/UqyNAnvuQGTGzcRQPOCfreOSArYYlSqkqhnG8MekSlUz3HMm61Dj0iW1COvQo2bB+sGUaE9Oe1e29iKGqMbs2A8tnGgJRsPKgg3h4AMOZMmeb10VN3mKyIwTCpGhXIRfQtOZ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbbe361-5894-4d7b-9fc9-08d81da6edee
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 10:10:06.5760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjzL+7Lc4aoPEQk/wGgJ4nuoXEaoxBr8lrJEeGLMCDjKU47DvsVFImEaYT+yZl/z/TPoDhB9gBFErbhtDm1M9Lv+fHlrbVtPrJQabSKsGXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4605
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
=0A=
While we're at it the next block does a direct return manually unlocking =
=0A=
'ioc->pci_access_mutex' and rc is never set for any of the error paths =0A=
in 'BRM_status_show'...=0A=
=0A=
Maybe we should add this one on top of your patch:=0A=
=0A=
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3=
sas_ctl.c=0A=
index 62e552838565..70d2d0987249 100644=0A=
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
@@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct device_=
attribute *attr,=0A=
        }=0A=
        /* pci_access_mutex lock acquired by sysfs show path */=0A=
        mutex_lock(&ioc->pci_access_mutex);=0A=
-       if (ioc->pci_error_recovery || ioc->remove_host) {=0A=
-               mutex_unlock(&ioc->pci_access_mutex);=0A=
-               return 0;=0A=
-       }=0A=
+       if (ioc->pci_error_recovery || ioc->remove_host)=0A=
+               goto out;=0A=
 =0A=
        /* allocate upto GPIOVal 36 entries */=0A=
        sz =3D offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);=
=0A=
        io_unit_pg3 =3D kzalloc(sz, GFP_KERNEL);=0A=
        if (!io_unit_pg3) {=0A=
+               rc =3D -ENOMEM;=0A=
                ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: =
(%d) bytes\n",=0A=
                        __func__, sz);=0A=
                goto out;=0A=
        }=0A=
 =0A=
+       rc =3D -EINVAL;=0A=
        if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz)=
 !=3D=0A=
            0) {=0A=
                ioc_err(ioc, "%s: failed reading iounit_pg3\n",=0A=
