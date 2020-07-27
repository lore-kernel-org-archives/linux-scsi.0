Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51232C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1576020838
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="fdPHX6hn";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="c3G78BuJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbgG0ObN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:31:13 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63987 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgG0ObM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595860271; x=1627396271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WEFJejrE2K6+cxqiS184y6xquo4gM2yd4k0TlwrDFA0=;
  b=fdPHX6hnw5SB0LjOTGmJNn2yrmSsHra33pNhV5g4s8H10i8hrJHxd1b5
   Tn9Oy5rgrNxRi/pSaDA+GfYuB+W/FoWnEh67oYbL1sUDB1THQnx/F4E7W
   /brCf/v1Ac+pr2e7eeW+kBS+KPS5l86UwKRRPTPFFPD9+hMNLyDIgKFEf
   gOseNoB/lzsNKh/yKdmomr8YruDD9h7DoZy4XNaBE1qYqJ2jBC3XJTFPl
   mJAi7ju4BuGoRvxRYiOqMxVqekWNGfvGpsJGJo7sOcIyRqXo9qzyk4QSk
   gdqaOUS2elpFUIuaUD04pRskrSQyj5F7G+EgGvWW8jcKZDyFFrwe1YwWD
   w==;
IronPort-SDR: 0EIJSwmY2SLRk9cqsfGTJj+gn+ZLtxPuwNCH3zBW3/ZXDIOzS8Hq+Rgo6lJcKFZMr/Tpw6UrIP
 drpwWVRgQ5jNw61KQmg1TbfAfT5ROC7iZTLCALqj4WbnsaiLPaIiAEZtAM2TNvRQYkfK64CcUD
 qNfQApt6lcnaoNGAqhP+ZFuqmTbAAzMhHjIwbkgBiNWP9uczBN3oLYEB1jv71Foln6pOyfGPQH
 pRWlgXFJ+VouXztiwejv7woDwEde5fxfd/6s2eBXP279u3pOPq4toct0R+xetGIvMCd1/Dei7l
 O/o=
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="83395159"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 07:31:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 07:31:06 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 27 Jul 2020 07:31:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U33Y6PSXWzmzYA7GYF8MvY0sNqnL30rDUDFxF1Zv2EZbVcF2rHcBq72rcM03jDSyHdu8sCqy57tUdzyEnrChOds+zDS6K0HKOez+AHu6qVQSVA3FyYrBaHUFG4pAJBbHNQxJf6R0wzFIawIm1uEdj9ukdymrt3TCRP4c/u210Clr+RwOF93Dz2o44R96WN1wmhRkWSwc/PhCZB51Sdi7WYxhUIMI5DOviLSyWSFA8ZbiHfiWQ41TxwGExxLkDbbyOQph7tc2SEYdAZPoFP89vhp2wuxEoLteCzJsESzUw6Sxm75q1g2tAvQ87N5llAl0MB5vIFaOA64rp36lgbJ1xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4k5/cVz95gfrPSSp+xTz8PdHIEv0Jqle3IwIuFXwiCI=;
 b=mhL/kdyMsx+/4+5+JukscuUwckqv8KjcehuP12V5g/CwaMGyvLotgM1fmEN9gJiVpDONXzf+YhV6042B8sUt6uhXuI7cH6x8prjVCDLE+7L3iRP6hfx1csj5qoET4ERCRRPk70B7ezHjtXUqmPF021f9ZUsDDN1PIAFvdqUnjJBnyq3ZiRWGNRd7p1PrrRKxiu/x/n+6/yNXbwXgazbMVffQB77TcRcyz2jCFW5sNgRg4N8JKUPtbU2vjjEWB0kEQemtdUxsRVQuRlQN1zAB11xL1Koa3lOceclALITLXB0hgmxAguByDw8PT4r4ZuFsjL7Fexxa9OeESNz7+wjOEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4k5/cVz95gfrPSSp+xTz8PdHIEv0Jqle3IwIuFXwiCI=;
 b=c3G78BuJHZ4zMuwmbBTDs/L8cyf+C3zxDViOFvKrvDKNver2FQN8y25YqYgAhLqTN7izDzH6SG+qFczOkkmTpqWN18O5watRux2UlAMENd2YxfCn/KRWQDarNBqA0X0aX4toW9iuGK2ahOsDXZxfZldkxg3ZuSm9E85DEzz4nsM=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3440.namprd11.prod.outlook.com (2603:10b6:805:cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Mon, 27 Jul
 2020 14:31:04 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 14:31:04 +0000
From:   <Don.Brace@microchip.com>
To:     <dan.carpenter@oracle.com>, <don.brace@microsemi.com>
CC:     <esc.storagedev@microsemi.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [bug report] scsi: hpsa: Increase controller error handling
 timeout
Thread-Topic: [bug report] scsi: hpsa: Increase controller error handling
 timeout
Thread-Index: AQHWZAfavmHWFbxWME6Maduyd4XJ8akbfEyQ
Date:   Mon, 27 Jul 2020 14:31:03 +0000
Message-ID: <SN6PR11MB2848817240DB67D54180666FE1720@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20200727111916.GC389488@mwanda>
In-Reply-To: <20200727111916.GC389488@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d994de55-d248-463a-666a-08d83239b149
x-ms-traffictypediagnostic: SN6PR11MB3440:
x-microsoft-antispam-prvs: <SN6PR11MB3440F56D955320C8AA7212E2E1720@SN6PR11MB3440.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qy7xoLkjFrr9+R/6hgN0hUD3ma+Pmpt2hWJyeO9GRoeWOJY2zgC7giEYdWQNlGrTDyWHib/NV7r86vCtx0VJs8rVS4d1o+4YsauYXCaL1QhQsXcWG5TFIprLuIlevvc16bYpLzwwhkuVh6Ha038g3xkfX8qLtr6VgE2xmznv4rzgdindimqGH28Lb3rkmvJzaX3s9nsKzcpvgwW6U2UX6lic/ahptrclBIJixwMviX9BkcoY7WBa1SxAqX3x2c/HhQPszqssCfu1ayQjs2OSWcoilmUdcCkhAKhFClS9B+w0ITu+xGPKa/aLumtkEjDvworRKeh1NPr6TyL+uBK1Kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(478600001)(71200400001)(55016002)(9686003)(110136005)(316002)(186003)(54906003)(2906002)(26005)(8676002)(8936002)(4326008)(66476007)(66556008)(64756008)(86362001)(66446008)(7696005)(83380400001)(6506007)(53546011)(76116006)(33656002)(5660300002)(66946007)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jmBgtXsaxrSXlvhU8b74i8KHWuVyJEg8AEufWQnZLCtrKEKWylhrpw1yp/+XN/+Rd4wMydFB8Dp612QMstDqfNeChkZjbRDdlriNc4zYY1kAEBq7GhijffBfUnbzeVc/giRDCIbwVfhn0YOJSwH6r5tTnuu16iWZLNsfqxUvZ4UYo0mmBqC5X4NoyjkNHdkYlKa/C7+X7bKqDGVmjK6qH/mXXKM7bXolXv5VGKaq3vc+YYJLnPYSdW4UXjO2To5j6R+oRlGrgfuvSxBN+vtcpSHtJP/R6JKPcmzTy4eULN7naFhnqY+XxMQ7NvYNhN6NCtBFn6GAyJzeapSlD3Pvg+ARJuBjQ0ZnwERHaQqX5m/7BqK/h5MICDSozY98FiEt0rIw44HbFhzqZ0OpvLwf6fZsVJseMq9zgWhTD16o9f+z2t3yVhEKH+HUq8uPZnYvfBptbAwmip/TdS0jygxqAFJeadGTqU+34s+fizdYrko=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d994de55-d248-463a-666a-08d83239b149
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 14:31:04.0987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3X5Bw4Ij/OBLFHdzhdQpgPkQkuX98BI5J2V3j59b05C5AxnwKfntwustG6zA7aCn56MIRJkLnZ37I17p9bV/Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3440
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of dan.carpenter@oracle.com
Sent: Monday, July 27, 2020 6:19 AM
To: don.brace@microsemi.com

Hello Don Brace,

The patch c73deaf3b001: "scsi: hpsa: Increase controller error handling tim=
eout" from Jul 20, 2020, leads to the following static checker warning:

        drivers/scsi/hpsa.c:2163 hpsa_slave_configure()
        error: uninitialized symbol 'queue_depth'.

I uploaded the patch bellow on Friday to correct this.
I should have asked for the patch to be squashed into this patch.

commit e5ad119720fd64cb7dd1fdd41e12f2fa5655b608
Author: Don Brace <don.brace@microsemi.com>
Date:   Fri Jul 24 15:26:39 2020 -0500

    hpsa: correct ctrl queue depth
   =20
     - need to set queue depth for controller devices.
     - corrects compiler warning in patch:
       hpsa-increase-ctlr-eh-timeout
   =20
    Reviewed-by: Scott Teel <scott.teel@microsemi.com>
    Signed-off-by: Don Brace <don.brace@microsemi.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 90c36d75bf92..91794a50b31f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2145,20 +2145,21 @@ static int hpsa_slave_configure(struct scsi_device =
*sdev)
=20
        if (sd) {
                sd->was_removed =3D 0;
+               queue_depth =3D sd->queue_depth !=3D 0 ?
+                               sd->queue_depth : sdev->host->can_queue;
                if (sd->external) {
                        queue_depth =3D EXTERNAL_QD;
                        sdev->eh_timeout =3D HPSA_EH_PTRAID_TIMEOUT;
                        blk_queue_rq_timeout(sdev->request_queue,
                                                HPSA_EH_PTRAID_TIMEOUT);
-               } else if (is_hba_lunid(sd->scsi3addr)) {
+               }
+               if (is_hba_lunid(sd->scsi3addr)) {
                        sdev->eh_timeout =3D CTLR_TIMEOUT;
                        blk_queue_rq_timeout(sdev->request_queue, CTLR_TIME=
OUT);
-               } else {
-                       queue_depth =3D sd->queue_depth !=3D 0 ?
-                                       sd->queue_depth : sdev->host->can_q=
ueue;
                }
-       } else
+       } else {
                queue_depth =3D sdev->host->can_queue;
+       }
=20
        scsi_change_queue_depth(sdev, queue_depth);


regards,
dan carpenter
