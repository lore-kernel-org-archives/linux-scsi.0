Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BA1C43215
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00AC6218AC
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HtkiCDow";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CAJ1Hjdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLBHXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:23:09 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62601 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfLBHXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575271388; x=1606807388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nKnmcQSIz/eBtDMryhLw75xT3kXzZsBKEPrXspIgR8M=;
  b=HtkiCDowy6+P3alrtI6WiArHx60XnfFTvYBIp5KyNezFHtU5FpfbX0jU
   quMCe8VNMlzf+NL98uafw6+A3aQ9SSjVmzz/y044uOlwVAfdyQ0UsqdaP
   K5tFAHLyhdPmRy56ahAY4p1ZGtMSgNNs+lgVFukFt4Y1w1j0o91lNZ9qT
   QLZWTJOzeoTlruGuIs7rSySsmLA5oz4t+E4p2FukXsTvU6RXqmTRu6HyW
   iqyUSyg98R37vd2CyYmMedn94t3/lBWmmuxKSXPmXt2ACcgkiBuZsQgin
   hkLbU2ps3bKDboarUxDMHQWEyCmD4M+xcAaBgXr+HP+QEugjTkexs+flA
   w==;
IronPort-SDR: Um91IJy6P5w0giIwsYSo6QbjNt4vCFdfUPiQeUMu8o/lT5jRzb3PLUNBpBlH7lmSwSCwj1dhK9
 99i0CTapmrlfO7x7oioywB2Vax1a7Fw86CmNgXkkVlI+3ckpq/KPnFLH5BaOMwyi8cjtZLuB3X
 TCTbP3Yz7tyGXtnIqdFLsNhwOE1hZ/1Hcu0VVyiFkq4ug74E+FrVnWFH3ZLAOZNcmVdKjWzTXs
 dlDgwYloaCrYYXh+YzFl3H4AakIJ4kmQFaLmoyIUMlyR0iFhlXhly/bvuq2owogQcTMV9xbOiO
 O5U=
X-IronPort-AV: E=Sophos;i="5.69,268,1571673600"; 
   d="scan'208";a="128818157"
Received: from mail-dm3nam03lp2052.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.52])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2019 15:23:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4mOamWVEDnAm0IkmbY7D55HIu3iu62s4oeIYZOdwWhSGxrPbW1w9D+Ip7p+hK4/p0y6sRXMNbfx8uoyp9uAvf31Wa4LP9WjLZ+S/cHTFLHbouMCF4UaX28SzNtI2MqzZ0iwt76bCq5IvDORnqRDiUz2rEW/ynsBvRh4fS+NNWWZzLIvpEhvdcgWkg0iGDjzNMvv0W3/kj2egJByDkrP2jE9pKPmHnn0SaqrapSXqlBURlooGZg4tDaalybnkHTyrIXzocgzZLcdEiDM1vYI95Lx4OQCF6DuuZmuUNqTo5MKcoBquu8tH1wISsPnHApB4jmtZHqWK4YkQ3IwxGfZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbV4BKKaYu3VEcshL6m6vgFp4EJkJ2a7rIQlXDty2uc=;
 b=Hbd7it2xX57eXZJg3YXeP2fHfaEqJKl2rZU9kmI9GiPLP27x1jI8cY+PQSmLsN7IryTMlbGxtbYy4A/lL6AydgZC4cmm/yQvrIldP9iEkCr1keicu62iKD21hDZ12wJpTRMceYTqgwA0TLVmJU6zvlqwYvJ7LfWtgP7ubTo9X5aSAvmyXNqbI+eRLsqOf3/K3W/prLquriHTM7kqR9gBmJljdUSrZqro+ouop1v3qXdyjOXLxfrDTd4qR9Md1t3L/DQPCfrB5T1JeoL+cRNKdrSR88bKVhQpmtz9cYhNTxwDIeJLcIuQsxGtaXA+v2w6HJ3K20ECmzZsWthw4VxcNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbV4BKKaYu3VEcshL6m6vgFp4EJkJ2a7rIQlXDty2uc=;
 b=CAJ1Hjdpyql5wuUwTFJpEmmPWW4/gijnKS108iBZQ1pWUyiAxATiM/3K/k8wUrtaPbw5TRG8e4gWI0CQ8CUHitHIvu1v01NYOmpf5XyUMHUh1bM5SXfyU+8ujv6sGEs2NCnTlwl9KAvgWjWgk66jL8YNUuUzhTMQZyYOL9Agk9M=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6445.namprd04.prod.outlook.com (52.132.168.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Mon, 2 Dec 2019 07:23:05 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 07:23:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
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
        Bean Huo <beanhuo@micron.com>,
        Evan Green <evgreen@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
Thread-Topic: [PATCH] scsi: ufs: Give an unique ID to each ufs-bsg
Thread-Index: AQHVqL/hFybx9sJSP0mlYCF52U9X+qembdBA
Date:   Mon, 2 Dec 2019 07:23:05 +0000
Message-ID: <MN2PR04MB699154831CDD5847C4674632FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ec4a25faa-77e03f78-006b-4b7c-bf8a-d56378f4b1be-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ec4a25faa-77e03f78-006b-4b7c-bf8a-d56378f4b1be-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 853ed48c-a894-463d-84f0-08d776f8795b
x-ms-traffictypediagnostic: MN2PR04MB6445:
x-microsoft-antispam-prvs: <MN2PR04MB64451D8E96D16AFBC008B21CFC430@MN2PR04MB6445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(189003)(199004)(76116006)(2906002)(8936002)(9686003)(71190400001)(71200400001)(33656002)(478600001)(3846002)(6116002)(5660300002)(26005)(99286004)(2501003)(14454004)(7696005)(446003)(76176011)(52536014)(6506007)(81156014)(74316002)(66066001)(81166006)(7736002)(305945005)(55016002)(66556008)(66946007)(102836004)(11346002)(8676002)(229853002)(186003)(256004)(6436002)(2201001)(25786009)(7416002)(4326008)(316002)(110136005)(54906003)(4744005)(6246003)(66446008)(86362001)(64756008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6445;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dNYLi+nlOqYBllavDgjSURV/RoA1aWfgoEYl+GqYw9V7YeIarRycUWW2ncVDxZNaTyuubujUb+lVdl7YjxfZsRDqf/CNQShePnHJQVvFw3gO6uA7/QCxiD+48X4LvWs608krShQ9XyOuz52iWP0jxE9bUtSEKuppMe84rOQpA8Bk/J5umuwbaSLLcOaVEZdoHTnHezJuWaZnvE6ozsIGistMoAMwMAwH86ioZkFT0UYfDhM7m/aY3Dei4x+3jmVfE4hDp52ipdjxiCD5cX9GThGAG17YG9gowXgio2sCH7mXoLGNf4pb6gM8nRpqxl+ayi6MWhawOVtnriJjP1j3sMB0fc2ub65Ep7j5LjWXiHRnRpz+V5o0kQcV7D3KyoB22FJYCumTZ9+L/AS3v8vf86gu1e8tFIvpTcP5vL4qWUH8ryGdOnVktAHM0zc+5Edd
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853ed48c-a894-463d-84f0-08d776f8795b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 07:23:05.4918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2ZSdetZWihXLRb6DqERQb+5BE1WWYeaLyDWo1NFLbS2R+kOxwvWdGUYbESBoh69W1TGqw2nBjGkgIbwhklowg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6445
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
>=20
> Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an =
unique
> ID by appending the scsi host number to its device name.
Can you refer me to such a design?

Thanks,
Avri

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
>=20
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c inde=
x
> dc2f6d2..3ef5b78 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>         bsg_dev->parent =3D get_device(parent);
>         bsg_dev->release =3D ufs_bsg_node_release;
>=20
> -       dev_set_name(bsg_dev, "ufs-bsg");
> +       dev_set_name(bsg_dev, "ufs-bsg%d", shost->host_no);
>=20
>         ret =3D device_add(bsg_dev);
>         if (ret)
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

