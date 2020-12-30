Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF42C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 07:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601BE21BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 07:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgL3HVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Dec 2020 02:21:21 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:46080 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgL3HVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Dec 2020 02:21:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609312880; x=1640848880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ErTuUrKIvUB+z+Il+kKMcwCozAIj2++4wtGxiqjw7IE=;
  b=eBJawP+/Rj14yhJFwqZC8Q9N+mlId3QNU0bPtiYV32O/ZIuWEu5StHnW
   G58W4DYXhKyZGlLjTTt/F+PcYxoMhadSagdgR453XWwtGcPX1SwE7cka3
   HWq/zr1QOOXTSqN6LPbuEt6bh30/TP6R9Rw5KDtNr2in3iCu7853M74Ox
   iJKHFszIAOyov0cMyxNUQBc3rp3/a94t4FUmg+Rso6irDo5GNbopReAsa
   vNZQVfSacwn7tdn7wbt1Zx8+RbKb95flvsNbGsDwus7NbdjLW1Epe6KT+
   YQE6am8LJW0g/P4c4dZvI5pfj9tLXVFg+ri5I+iL9JW44jb3BelutI84E
   Q==;
IronPort-SDR: tT+AlSEYZA92ucalOyezTSAUsVkTj28wLJxyXDxzm1gDe1Hdf2gfEonM0CI5IsmRdgUFvHSrKS
 Um5Nnud0g1zIAgTP5KLK1p/ND6snyj1znldFBTSgT2eMUI104vpN0LQcNdkbnmPJm0rBAljYtm
 ZOtDJ8iAlNUasDva2vb5O7nidmIBNtyCVBQJz9yUy7GuwymWP3BWAcjg8eHNtI0XRVk9B35TvM
 hoTy9kds4mm5KrWHf/iMjs32TJOvgTu00+szVTNXNn93HvJ9bI41FTI5B9nB+ukoe8ILuQLH/e
 +Fo=
X-IronPort-AV: E=Sophos;i="5.78,460,1599494400"; 
   d="scan'208";a="157479456"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 30 Dec 2020 15:20:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAPsg412imsXOE/fYqgvOXyEPktUcS8/r1gAFfSa3p3TDdMd/KpJcAedcrK8ZkUkzgDmvbABZrDARSTOExhIFcOmueJPI4yYUy5miDcAGO9zDQQoGLv6YxHt7Hxj4Tbdx+VB2uHH7R8yj53XummiUgSNwio/BWozqecn4k1qEDzUzDzpzrkxdNfX2NE+oXp0CXa+dl144DKFgh2iUkz12DUzaHVMjDWZIXN4M9r7IG1MIxaOioCCSTfneSJ6+ffoj9QYYXtRX5qZG3l2Nv9jCUmENWtKj/0ATVzG0UaikeOZULomITNIo1z7gxJvwLFQppfZ8z1WX5egYMr2wU0BNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErTuUrKIvUB+z+Il+kKMcwCozAIj2++4wtGxiqjw7IE=;
 b=Bzl3nBaH4bYhxFdWkln2qJM546yTkOVeUFihi6AE3ML3AW4PvtVnGKJUJrS+PHf7xqIzHbgbEMiBdMK3vEK5WO7HZcyNt+dx9YgtescaBNVLnEYoFL4vjTOvVd10J8RP/oHseMrE8Q1GPPpgs80Cvx6veSk4TSFAoUODYyehQWzjl/SF/9xZfRJkbmJl026MUQtQSSy2GfxrAFvGCcmxxE8y3HuxtixErnmon/+DkdBBEfVDs5eYcNdNrFbQPez3ZZXH/0PauhTDHD4/5h8sgroizSxYYYp7tLD/VXLYAP9M2E8C2UstevgVbyo+bu8uI8pDQLvYUT4UERMx/n/Ovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErTuUrKIvUB+z+Il+kKMcwCozAIj2++4wtGxiqjw7IE=;
 b=ReIrf4eUShdYFjnk/ADFYNPWFhvSAdGvLOhJKOozdvLakeL2NDMKpB4iwKSjNTnU9vR9jypzfP0D1c0GdHlRA/jWgXInoS2ilSf5emDx9TPLIeLK99qESf1XczBsFCSaIE5909SAbbAl7YCR6zf+B4R/9nUH8zT13v+6nuFVwUk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5019.namprd04.prod.outlook.com (2603:10b6:5:11::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.27; Wed, 30 Dec 2020 07:20:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3700.031; Wed, 30 Dec 2020
 07:20:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "ziqichen@codeaurora.org" <ziqichen@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Correct the lun used in
 eh_device_reset_handler() callback
Thread-Topic: [PATCH] scsi: ufs: Correct the lun used in
 eh_device_reset_handler() callback
Thread-Index: AQHW3RGjU+atJau5E0KlM708whiep6oPPYFw
Date:   Wed, 30 Dec 2020 07:20:11 +0000
Message-ID: <DM6PR04MB65753653372A85F4F9B57FD6FCD70@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1609157080-26283-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b755cf08-a004-4987-6c5f-08d8ac935824
x-ms-traffictypediagnostic: DM6PR04MB5019:
x-microsoft-antispam-prvs: <DM6PR04MB501947F126741C7185C20C89FCD70@DM6PR04MB5019.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kkRUETjSVUW0wCLotm3gEq2RMDpSNkC2UFYH9bEw62WR+kQP7WGEotjLn71cCe+5PTy8YMNvrnDSw3o7B2YZUOCssVnrqD5id4kb6qH6eGA1n6xRtbSV80xEu5roxPd5dbSz2nN1+1KGrK5g1GeMmcoqtpCuPPYo1uF/XZ7JFM+5WudCRNAIWYHSYMZRMzTNPtlVzZUPOgob0PLXeNF9pMep9fOCxzMMJCLZjihFQ+nY9EyKYq0vexVCvUhouSNhfdvKA0P/HY5xk790XLTIdtDAi/FqkLOFnWK5LL22ZgYWW9opgJu5IeOvKsonRdOja70WK4k3H7Osr2jdUsHdXRwwfcD40/xoobfR1qLuOfleIPanLZUZ26SDYo0eoBG8/TVwZZA8vhWi8TOu36C40ZfFosRclNkUEUXI2LxtsSkFrNAO22FIwPEsdbDV/IjX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(4326008)(5660300002)(66476007)(33656002)(7696005)(83380400001)(76116006)(86362001)(66946007)(4744005)(66446008)(55016002)(52536014)(478600001)(64756008)(66556008)(7416002)(6506007)(54906003)(26005)(186003)(110136005)(71200400001)(921005)(8936002)(9686003)(2906002)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?B14pT2AxBPMx7WSBvkQBFWu2XErTWG/Ca+HsP8mrboPgKceyywz2EdiRLjj1?=
 =?us-ascii?Q?JfphNIsJ7wzgGQx0jcvJt89G2YxFFa6Id21OlUtFPn6iHZBwFSJUZpS2TeJp?=
 =?us-ascii?Q?181GtSMULBj/A9CgJRLOULP1YRRp9MgtaPd7jSCjYbNwx60a1TfgTg8q7Aft?=
 =?us-ascii?Q?rWRG3bXK6givSHRS2Xz8cwkraB0pxOacu4fGjAiifYqwh6bT6w8WOsHeGoDN?=
 =?us-ascii?Q?Y1sDOZGQHNVfxz21vr8ZBQnbEDCNpZ2JYJtDpKce5f9PmVrINFo1EiICwXQr?=
 =?us-ascii?Q?QLbTAxTyommW5XKiGHENRb7yKUfTx/5FU5hwu9PvRA5UgQXA/0gADz0eySy7?=
 =?us-ascii?Q?e8LAs7icavBzu5Ykv3LOfowwYYFyRvkvVbNGhId5UELAN3XAVDiYf4hjnmZE?=
 =?us-ascii?Q?fjyIplVI4Q5UEFmdIeM8SXl2+buGwm1onbZ1kiOw34w40KccbNyVRq0WjIVU?=
 =?us-ascii?Q?8JWMs84sX+BGc5vJzD/AzsAk8WWBIDZyoB9f2g7Afui8cMJQoE3eEqF91k9i?=
 =?us-ascii?Q?2jdM9C5bLGItzjRCn7NM5LSlePMoMqPaGKj8BwTpVQl5OHXkyzGKolD0zTgM?=
 =?us-ascii?Q?zWyTSUKQ0jT79eRTEzwM01lbudG2klMt9J35lgK6ayG04118lqI5bfNnKaC/?=
 =?us-ascii?Q?U21YP3C0FidLLkGGQ7nh1lDXtdL0dEZwZ45l+kDrl96nNXE3WOBSlPOWg4S1?=
 =?us-ascii?Q?LNPOBz/fcfLrEm43jDgusnoN+LzRrBkuIIkfcX2VgJ7hJ6W+jCAT0t7/8We8?=
 =?us-ascii?Q?2iVPynnCgV7ScY5olF+pp3L3Z2PNoLf9T20jYcbD5im5F/HXJ93HJykJrt+7?=
 =?us-ascii?Q?XwHzbBOY1+Yzec/DzYT2VuPG7IUGrrwwrSZevUxxo/Yk/10otdk4AdXU6gk9?=
 =?us-ascii?Q?c3+MBvgT9+1lWkmgGHt7rWonIeW5Ex6vOYeHI+xSVl7Z4S/Und7moA2Ho8oS?=
 =?us-ascii?Q?RdE7qWhoSDa6W16NZPm60owAoNP/40Z11Op22d6Kt/M=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b755cf08-a004-4987-6c5f-08d8ac935824
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2020 07:20:11.1020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aW6zvWvfZ0tXbZ4lQCuO7VSoecq9XOmsuTpBGPYcDjuT6BfX8HXIuZr6V83KZ64un3HZfvzwFOjIF5y74+sr2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Users can initiate resets to specific SCSI device/target/host through
> IOCTL. When this happens, the SCSI cmd passed to eh_device/target/host
> _reset_handler() callbacks is initialized with a request whose tag is -1.
> So, in this case, it is not right for eh_device_reset_handler() callback
> to count on the lun get from hba->lrb[-1]. Fix it by getting lun from the
> SCSI device associated with the SCSI cmd.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Btw, am surprised to see that you guys are still using sg_reset instead of =
ufs-utils?

Thanks,
Avri
