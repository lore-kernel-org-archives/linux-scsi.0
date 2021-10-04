Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EDCC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E5C6124B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJDHJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 03:09:28 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:17875 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhJDHJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 03:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633331259; x=1664867259;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Re/isQf3so99NTJXTejO9XNFIvY2oanyqRqXJq5x+30=;
  b=C7uH4+mSmjbHnEzXGYH0qidwV9fD0yoMfVjrFw4BJ0NL8zA5XwluQlKb
   mp/jfnP9/lohuMtk1EpK/G4SKsWu3w+M7ZYjX6xCDB0UkE2CojMWXCxGB
   fhxkQ+O5PKP1YtKFPD8+tiThecD3JrSM/FOzX7Ao3M2lOIufMFwYTBaxU
   luMrVvF70fvmblNV34ZkhKgDGvClm0Txl+3CaA+pJe5eZLXY1VQtxSxfH
   UeAvQrR66Bh+P/RB/eWAePdMVHWSLQTF2rG0Lyi/eEH9K1zbhmjIfff2H
   AukSUgRW28k8Rs9lcZwAmOf4bxik+IVmgL61h/P8AdSfa0AvOZcTVSMDm
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,345,1624291200"; 
   d="scan'208";a="285579460"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2021 15:07:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwrIldJrXQZqRqeuJ6rShh/NAtHhll9e1v0VzzVoDrr6NInpsm0EoAuch7ad46NV06IHwdrYvlI/r9vAMnDF7SAcpx9gHJ+MTxwGLhFf8Ti4eY6OblAI6wGxEHVo7o/5CG2s+jzHQiSWT1f8Ajdt5eSZsIr3PQJU9nBz/Hs2mCMORBbLjSJKayxiHX0lV8POMNoXRnX6uaXudqWMKx4uWxJY7mWV8HRZ5439or0WvhGc5WW8E7aPgS/qiY042+vCuW2RboreBsYkxSElhhUNneSiRdqqf0dZDDCY+IW7oNjfm2jcusErmaH0VvLOex8iq/h1Oxy0E9V57XuVgiGuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Re/isQf3so99NTJXTejO9XNFIvY2oanyqRqXJq5x+30=;
 b=F6/xCBS8dVkB3WNzA6pYhIKS8gA2YOWY8WlN6fzyRBmlo1gGKp5tlX5uGARV+qzKUdCmgjUZ7gBwrb2sMu22CASC1xcM3a0VG6eTiqsr2batsTUAYl0D/y5/0aG1Rh4cf70ad6ekqY/2WVprzJ7tGcO1FAN0GxyoWNBq8sB84SxCP8KtO9fGvg55OGebQ2fJm5JchAjkMrKqR6+WUkfUNnO5QENW/jqlJGMA2GmY1KokGh9WXC38NZa6DYa4bWwl4lscF1lAUXovCt2nAbuOI1xbYylxj7iRiFxyYifdocNONme/FLimGD+TqJOjJrmVdJ0nfKDSXGZRYjopE/69Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Re/isQf3so99NTJXTejO9XNFIvY2oanyqRqXJq5x+30=;
 b=AN1johZlqJ0lgtERSnoUUtNHycxGc49lneGdPCVVDyrlWFwFLcHsLBnWYfUt2A9VdkHi5+324HKIntUgu9ZLH8IiNwFF4rvGsnhLSUR5RCbEB+0cNCSvbWuH/bJx/LnPKIrixA/gej5qvkNItuyz8+wdyz54Qlc6dVWve77dKn0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7431.namprd04.prod.outlook.com (2603:10b6:510:16::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 07:07:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::5d0d:3d52:2041:885a%4]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 07:07:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v21 00/46] sg: add v4 interface
Thread-Topic: [PATCH v21 00/46] sg: add v4 interface
Thread-Index: AQHXuHRKZtyGFgtpVUeHwdniv2QRFQ==
Date:   Mon, 4 Oct 2021 07:07:35 +0000
Message-ID: <PH0PR04MB741616797A78DA07A7886FF39BAE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20211003163151.585349-1-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cc11bd4-49eb-49a0-6673-08d98705a4d1
x-ms-traffictypediagnostic: PH0PR04MB7431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB74318E4806F12B5037AE875F9BAE9@PH0PR04MB7431.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2JwfSEzALomzhi4+SrvwMzHeQdJvr+mrx72fRvFBe309xsRD3+WkO7R1/y3KUE8m2MqfUxUJIvIrxYZjm6MXMN3IxfTDizFRESKulKUo1ZQmT/jWOzaQSJL74MtZ7FoJa2wxgFb+aSCIcPjcuq9xj+xTkEUPh0wZxVOTUjWd2QYlD1AJnI9lga91x4ZoU4hQwd6PH6lcZfPlzBQujcfRvbsLVOnGfjODcL1pgkaNiLbQAJvmJwsGxYs5Febs3t4lcwblCHbmR7QCXnLiIuaIBVBBp14uCXim4i3Ac1L/yrZZ+LgUU6R2p91n/ny3EAuatx/8Y3+JE48LPqshEw6fHpGU3t/lWD1bNpgvQOSxFTeaUtwIjXe4yc10ZrhnWdjHC/i9zJJiLrlzqg7gs+VHWxuJ7ELPdlm8s4jouaHdcsN1YvMwg9QsAiwKWC94UHT7QWHrJyjWpReoHR4qzW3Tnwt7zBC0a1wvxY9AR9/qvbhCm5OX0CZJ87qFi/KgXp7mVcuGmriuLD8oBknn9jK4G0sCuuHSY6FBezcmYfdPdX81H50t0iQysFMRTRfDmL65yF3wKVskeSj3v47CU/GzQrQo4etf/yiKHx1liFV3pq1UtsyLhfv9UVGVovJ5K8yEsd92Cwn2RORc8vq2yYOFTerbw6oYMkVVl2cXDGHc9iMtvoOLHZPPku+uuqj/1fF9YjzDlTBpiEFHG3BRdijpfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(9686003)(76116006)(66946007)(52536014)(5660300002)(4744005)(4326008)(71200400001)(66446008)(64756008)(66556008)(66476007)(55016002)(122000001)(33656002)(38100700002)(508600001)(8936002)(38070700005)(54906003)(316002)(6506007)(8676002)(186003)(86362001)(2906002)(110136005)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sgSohGuabv/rWju+qLhhIExbiZkO5doqT6tSi0ih81lAaemIqMg+8ygRODYd?=
 =?us-ascii?Q?K6kEkk4HNT1wfdNhxZSNK+IUgU+lnnHiY1ew9qRaTeB6RHYy2AeDUGY1X9VT?=
 =?us-ascii?Q?TBVibh7zg7W7dUrE5Bi4FC+H5PlUcjs1J+k1eS/6V/l3QLFJUsVBqt5O2jB9?=
 =?us-ascii?Q?RXy8zt73CFNM1YmAsZah3fWLHF8xQ7fHZZDTyqpLHjsw+VIIEWc2U8FsnhMQ?=
 =?us-ascii?Q?Dq7Y9RiZI63u+7irKJBqNxy5QnKyXT86J7nRzgiPeOgGD4xXaz5+PgMEf0pQ?=
 =?us-ascii?Q?p/LDovPupG8WzcFo8KBHqMyT1iudgj4OKxUV8iu17FJGCxll9BoLziQjmPIx?=
 =?us-ascii?Q?N+7KJoHGMTl3rGlvEu875R7KsB+M06OEFx5Ztl0qECWPnxHEYm1t3XB2hsjT?=
 =?us-ascii?Q?xOnEVKmcaExRFA4D0LUFBaHRwiQb2Jkm5GJ4okImykYjw1yKL55ftpsMTmLn?=
 =?us-ascii?Q?qrfT/uhJRXxIXEHsi8kGx7kcck8q7VeqY343GaVSb4+s1sptvRAuYkGy7PY+?=
 =?us-ascii?Q?+nPY6NwKDycKD1yD1WmQClOTUZ2C3H2ES/lpzwQ6Rr8LiTc8i+8WegYN1Lx2?=
 =?us-ascii?Q?wYvrymucVhYbb5bO/7Ic1kRu6Ue+2QgjmBzy9E4T8TJoyphwbfH9Bjta1wkc?=
 =?us-ascii?Q?It+XerooZGpnSG9bkDQOPRKyV1CFtKsORXJ/AbljKNLLJfhn0ZhJoRsW2Zmq?=
 =?us-ascii?Q?LmHqyvniSVftVi5lgoQwS7yrEEy7H4G/5xYYKzXVUfA4ZjuRyV5DQZKS1P1p?=
 =?us-ascii?Q?r0PS6/9s4Ssq4vBKv/3S5m1FpvGozIk9TZxDOTFO5QtkWxCAI0KOyGfGLlez?=
 =?us-ascii?Q?KomFbuwv8XxZVgAe/21kTYd92bw5ZY/WA0b2Uv0tdOO1AB12XxUhLzBaCiP+?=
 =?us-ascii?Q?/H06LfKvVsLXoSzoiYP49Q2CR5TLCV9OD/Tx7wzyGwWorwOv4CPfvGvW9sbv?=
 =?us-ascii?Q?X8leYlW6M2AXGoo5kWg7fTTU65UCvGa26dx6M4J9yqmvulqhUNfepxJ5uymn?=
 =?us-ascii?Q?CyDZgAjrCkQkFC0VftPeGaLoqSFFFA4Rds9rKRW3zQqTEASAMOFlpq3pRShH?=
 =?us-ascii?Q?9kyiRFKari/Vmtb5RTN4o3uPtCSWrY68JJCLoiAA1nHz+94UQ5pjtHXSj9tC?=
 =?us-ascii?Q?3ukVclqsSBpbClWV0Y6HZZ47IlPAp3h0Xo3QKZRwA0ni8miuAVnLqdkKAvTo?=
 =?us-ascii?Q?RMAiU4QUWjI1Ui+eGwi26/1Pq5Rglpk2etsk1yhGy+p2m9Dv8H8HRuTmTxy1?=
 =?us-ascii?Q?cvMwB10ea7eFZeY/e0HUNM9L/PoSl/WohkI6Rh/qGxU7kFjkAdpwYvLQuR7V?=
 =?us-ascii?Q?Orqr9LKa3O71FM75bAvNRbv1u4HUCjdglQm1YW4tM+FHfJ6AhZDg/f3u1fM5?=
 =?us-ascii?Q?SRmLm1ogrlaJ+hXB8aK/6dNy3xA9sS7U90P34Om1+XlvsuwfTA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc11bd4-49eb-49a0-6673-08d98705a4d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 07:07:35.8243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YakzmugQe+hupwQN41PHlwkZcya1YoTcxJBZSqy+CwsaCQXjlBeg7+OrHVgXK4EzyKqpJ9C18P2JNZwzsfiNZd6eI7A+05JSLSA4/emNuFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7431
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/10/2021 18:32, Douglas Gilbert wrote:=0A=
> This patchset is the first stage of a two stage rewrite of the scsi=0A=
> generic (sg) driver. The main goal of the first stage is to introduce=0A=
> the sg v4 interface that uses 'struct sg_io_v4' as well as keeping and=0A=
> modernizing the sg v3 interface (based on 'struct sg_io_hdr'). The=0A=
> async interface formerly requiring the use of write() and read()=0A=
> system calls now has ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE)=0A=
> replacements. The sg v4 interface is not new, it has been used by=0A=
> the bsg driver since it was introduced to the kernel around 15=0A=
> years ago.=0A=
=0A=
Hi all, what's the plan on moving this forward? The patchset has been=0A=
around for quite some time now and doesn't make a lot of forward =0A=
progress.=0A=
=0A=
How about splitting it up into more digestible chunks, at first the=0A=
cleanup up until "sg: sense buffer rework" and have that one Reviewed =0A=
and tested. Then proceed with the v4 interface?=0A=
