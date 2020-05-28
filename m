Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB75C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 08:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E72B02088E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 08:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C709W4BT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FAYB6APw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgE1I5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 04:57:49 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:32963 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgE1I5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 04:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590656268; x=1622192268;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=h/I/9xZjkFRtVfje3pdXs9BhFKosta3CEFdwxVvq5M8=;
  b=C709W4BTnzCCjSvVOhp5IzEBA/ImUUXKpRyZgT6qtGoYyX+980pRy2C8
   FrX9kU4MCRaLG293tJpAQM8M9joR/7MsqDN6CLkP50tNL89lWUxrmu18I
   ULzJfsX9lPwcvIj2X8HNKD3pWcZDlg2c19pzzCETPN5YxH0H7BKh26Mdp
   KEfO6nEDkN1DclycoDjp3HcZv0PQTAnUVAb6MZEibFn0Xj/H8pms+1Lk7
   8GeRhVPxYV6m3rFFH6ZZqFhjsEDE//RL1Nek4DB5CHEsgoFd2ofzVbEIn
   dZd1UyaEkyPUmj/Ffrx85VmY2pOBxSaPamxqvLijb6ClzJGxxZ2O+Q47d
   Q==;
IronPort-SDR: 0PijYfsGqGIV5TcDLhNgVM0e5lXjlsFXKYHDkmh+7yIA6JY7DWQVEykQycPUxrMIA2w7zvEijt
 uah2+jLb167PyvpnhlvM7Zc7WqfyO68417Q77KF8WCYboYz8vTPYYyUwRMi9IyzC7yUZk7jT6+
 06jk1IV6N6uoiJffkwb4Qe+FfPVYYF8dfsOz+7z5AhZWewKCpNHl2tJzcY+bfhjEDVTFQsCRAX
 apiEBePTBILjrg9OIbGDkqRbJMyVYN0jVKXqunDCBkqL/8X5VXAx5HQ6/kDj25GafFZP79DH1w
 Nlg=
X-IronPort-AV: E=Sophos;i="5.73,444,1583164800"; 
   d="scan'208";a="138688878"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 28 May 2020 16:57:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fcik9Uw8ecWxanBp1Fi90mNBr+ElVE3zuqNt1ELHRIatMSGL9P7bCwPMbFZYhmZmN2mf8w4FkMrlj/AxIXwi9PSryicRXq4B10ZOELnNa3oAx8JlUMR/Uog4cSfcrBBlRu4lyOoYl6a7+GLk1fMghuaCg0+MUnq3u0jGxB30aWZAqfMhh16+WACmXMqjbkUWmfnjAXoMKCr/Zh+VTNo4TxRrRj2N9WIPvEycyRfXcrzM98gOeQ5Eh0pGMPd9Csy6ziRDH9yV+Dm2O6JXyDz5h0pfSUMuKTGCeLsQwhGGYWPoeSwbj49uL2ANQyRy41MZ9395YQyrRE6nZofObsnV3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmkthvyAFz2wZxbjwyZsblKMDLRt04Vg0RkUqRZGXos=;
 b=GcvYPn9Z07/HbfVIdnDKgcxYmHJNrKv2WGjVl0GyQgVHNlHnA0uF0exe/fmN9DaiCRvQcECc9D5L6rssYT+BcUkBFvh8yrorlCbIPJ3buF4uHawQHDE6krUQ4qpUP6rww3yOPVS1eAxttlIvHawJVz+wbBEKo+7x2evVD8/b0pPCQr6pCBEEtUY7ntQ3dlHlNSiX83Jv4vukopx0nNKzvRUBZLiv+vFHtqKkaEvK0/sa5dhKVIM6zy40XiNk7aTQBm+0qfPKD9+gwxgmoIRX254tOBTBrKo7ORVneV1HLxGPXpwfZFpC6IM1WWmS8xc3GDIWXgdNKvXElTJAJmfFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmkthvyAFz2wZxbjwyZsblKMDLRt04Vg0RkUqRZGXos=;
 b=FAYB6APwmbO0MaN1u7aAgtS/A6i/2/glrvJEQqaYeczZAf6wsuAeewGxZaJdt9XYTCxHJATRRusW1M2vsdjpzoF2t9H9iM905lBFopLw8iWUSjiRkgxSSREpfx1J2i7xag0yywXas7MvjTLQUeT3eKYnVOsrftCFnaQaRPu0Qc0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3550.namprd04.prod.outlook.com
 (2603:10b6:803:46::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 08:57:45 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3021.030; Thu, 28 May 2020
 08:57:45 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
Thread-Topic: [PATCH 1/4] scsi: convert target lookup to xarray
Thread-Index: AQHWNM2GW0LN5YtayEuY3Usabhqz/w==
Date:   Thu, 28 May 2020 08:57:45 +0000
Message-ID: <SN4PR0401MB3598F50F2A783DCE68DF92839B8E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200528084227.122885-1-hare@suse.de>
 <20200528084227.122885-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30dd4f67-a20d-40e0-a2bd-08d802e5307d
x-ms-traffictypediagnostic: SN4PR0401MB3550:
x-microsoft-antispam-prvs: <SN4PR0401MB3550D1BDDEE196DEF6367BB99B8E0@SN4PR0401MB3550.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6ej2RN/wfxHNmifOy+I0Y8NPAWeueFOkF4/tN/Ire9WKmYUOxAWSCB0ndY/psaW8z134wem2nnriEDcSZsZ025ErmBLeT3gctnAI7BE4koouQN66sw5W/zR2Y1EOUgFAVskNRuoLY8NncnarvtB8z6Pm+xRb4LOEUbRebAP5oDbO1I7DXFu/n2BCsVljRsCU+xAoi69/Hy0dNfwswdtVk9nPY36gIZ/UQTK80CYUAgWaxvZyVxeGwj6mhAvIp6Szoc5OKjTI64KQNpByJ6tIvt5gCd7sRwIlKgvIBTXWBv0YYSd45r7Z2tuFkUL71kWK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(8936002)(5660300002)(8676002)(52536014)(55016002)(9686003)(86362001)(71200400001)(478600001)(558084003)(4326008)(316002)(186003)(33656002)(53546011)(7696005)(6506007)(110136005)(26005)(2906002)(66476007)(54906003)(76116006)(66946007)(91956017)(66446008)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Sh2Vud5kAI/Of7CJuSnQqBWiDa4rYBzYdicFkKT0NYUmn0SHW68okjHzYwlvbUdklMyLLFHWhORj1JpC3ltg2IynBP7lBLDEPxZDGDdmdLIxshzAqIM1KVAOBpiTpLVZ1wQXYB5O+e42pBx16RJB8Waup7lA5GE9OZbtSnua5QPShbArdOJVMNx2mqbKybw1QwIwwM3NNyNPrJTQXmx4dscx8eIXVOVUM4KUXiKLLZuxALXvH5PPMCe09lITvZIj2EOIYCdykY0lUrZwsRu9XI7VKJGSqLAyz3nNkkPc1Dp0PY23XLSbnmaL3nc+rt7ZprDZAQMjIjz9eeWqDLJWRu2h8LRyEAVNdVyPUuA4JBgjnyZXv+XAcsoBjTx4UvKulXDP3JU2j9jQE9LthP+gWJG5CB1QHgrp3JDuKwJzw+AHTU3XnNiZrc7Nf9NUGwF6REWI62n3LkYvZDMExyThEJ1JNzmJuZtTBk+LyYRqQiS11x7bqu9uc7DaXYZo8AiS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30dd4f67-a20d-40e0-a2bd-08d802e5307d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 08:57:45.5932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHvnr8UGgOh3S7EgB8OWtOrmZ1zxau4E9pqUdCmTgdnxvBzN5Kz0HDE/DFQpkIJ7rFYfZuomHsA+8PUUEQYJXqCNRInK7twNzF449jTJo5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3550
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/05/2020 10:53, Hannes Reinecke wrote:=0A=
> +	sdev =3D __scsi_device_lookup_by_target(starget, lun);=0A=
> +	if (sdev && sdev->sdev_state =3D=3D SDEV_DEL)=0A=
> +		sdev =3D NULL;=0A=
=0A=
Nope, still there.=0A=
