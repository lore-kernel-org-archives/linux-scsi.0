Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D46C43215
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 01:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D5EF2075C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 01:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PaxjvKoH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CxenDINz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfKRBK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 20:10:57 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18931 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfKRBK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 20:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574039457; x=1605575457;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ilG4BHBXqUXZc1SG+qiVGcXs2D0JhPjmMh3xw+CTfCc=;
  b=PaxjvKoHdPEPy2F8WIiboKmT3xGS9oUzBxBahLcSyFWQJxB4/yR3Hvwg
   IctF8+lJo1cayveRBF+jRzfDbhwOiVvUq+jirbSXi4cc1T84mTXtLTkZ0
   UbE5XLbooJ2pOfJkfm+KhKWzjHIspzCybtjR5Dyx3ObTFXv0k8BSLperV
   6LVeVM1Y+Ws3s3Q0CwwfFI91WTYDpsvzdiuThSrb3Y+EGCUSP8RhKCHMk
   aX2yE8I/eLo5Gc1D9sb4J0/nfxvT04ibTE2aekxbK7TIrEIApo7FRHir8
   IM4Pxa5lyJ0zEgddrTnuFw8tlAxjhGT4L35qNkeF7o7QRnhA+tuTIwDK/
   g==;
IronPort-SDR: GNHe4jL6GvSh+irL5yOXG8EZFRPlSpdXh1WIlHWhtdxZSifzdHuqZxImxavvuyhDDqKNiC+Jym
 eP7LeVyrVRYoVTHiSGWfOoOf+s4L1tQFrbKrZzXeJ+//KBZyM7tFzdbo7uc0QqQe2sV3dX5EDU
 U9MJPND38hRKsidCg5SHbpyaSTTCYCvnCyloRI7+x0pp0dLBHgX6vDp8E0U5WkM+UX3hfsO7dx
 IFDlVWcPRN0n83ZU8euJAqifUbzNUP7o4FirX8PEV1HPegVmda85DJCSI/8U3bVVoWb21wszc6
 d70=
X-IronPort-AV: E=Sophos;i="5.68,318,1569254400"; 
   d="scan'208";a="124023957"
Received: from mail-bn3nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.57])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 09:10:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjS02I2jJpx9o4LjFzMqRn9dTNx+L3VzXiHR01k7v6fAX98lOxW9k+FTGBJnKkZ9j79b/pgxyxXJJmmk5mz7DYjSM2a1Gp0lvzPRWrRlpGlYowoSyCghRrDE733SXsUDiY3UI7+vRUcBEyFMuhzBkADXwkc23nQMSPjqEo6YEMkcrNECUvEQJbbHEK/POhR9BhYyXBLavNHMvbRqXLAySeoKhdHC4nrFQ15qFIhRE06y6nzMTs3kubWKqzMfeamR+glVghTtKU1Ipi9/Tyyj2nrwuxUzQLldbhDWXpQXMub19ooxIwMeyPpI2KigX3ge6qTOIjqp2qfhOczuH8f5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilG4BHBXqUXZc1SG+qiVGcXs2D0JhPjmMh3xw+CTfCc=;
 b=OUirKM/ixD9BKINYoLksaIxXDbKPQ0a+vkFmP7J1KFSdHVuWp61TFVCBg9uRwK4iktE3zvvo+Ts2n9xYVDOOwsZ44tXwyFe2d6o/tOa3SfablRJrqRWX4kj00fnXX8c7QoSJ+prypo2gJjkQWUO8/KXqBSQGYLoqvXjjfq7san7irH6IrnSYG3r+8PIwVutyBIky93zEfpZzup5uo4gR7pk2IYLDhfwYZrpXvua+mA3ucp5+gQlJzdjFagozx2u8K9eaU4tIceO9o5OoOCHDGqWsqOxSJacs4fHqFBUJaAFv58tyLoTLsCKvq+oFkKzrIvoeoI91kcp7BydFHQHoxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilG4BHBXqUXZc1SG+qiVGcXs2D0JhPjmMh3xw+CTfCc=;
 b=CxenDINzrSWZHG4uuQ0KsLzbAj99c/MA6aKAN0ko7K0Az2AQRkemEMTIDgNEzuLTqDmuDHwv2eUcMdfEef9w8N1CPIAaDya/pa50QEmPhiyRgXy3KOv58bUxNJBKaarqYcwNa7n4CZWg6Q/oyANA8Tsvh0crg8CEufsCki8bRdQ=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4583.namprd04.prod.outlook.com (52.135.238.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Mon, 18 Nov 2019 01:10:53 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 01:10:52 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Topic: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Index: AQHVnR45YZU1Ch7oXEGY0W7soieOsg==
Date:   Mon, 18 Nov 2019 01:10:52 +0000
Message-ID: <BYAPR04MB58168A786B828CCF5FCDA935E74D0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191117080818.2664-1-ming.lei@redhat.com>
 <BYAPR04MB5816F43072584F8F20EF4292E74D0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20191118004721.GB30795@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3cc20306-62b9-4328-1852-08d76bc42840
x-ms-traffictypediagnostic: BYAPR04MB4583:
x-microsoft-antispam-prvs: <BYAPR04MB4583E86C8BBA485CE3269956E74D0@BYAPR04MB4583.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(54094003)(199004)(189003)(4326008)(5660300002)(55016002)(6916009)(316002)(52536014)(81166006)(86362001)(66066001)(81156014)(54906003)(99286004)(229853002)(8676002)(6506007)(53546011)(14444005)(256004)(66946007)(478600001)(71190400001)(102836004)(71200400001)(305945005)(14454004)(8936002)(25786009)(6436002)(66446008)(9686003)(66476007)(64756008)(66556008)(476003)(2906002)(7416002)(486006)(3846002)(26005)(6246003)(7736002)(74316002)(446003)(91956017)(76116006)(76176011)(6116002)(7696005)(33656002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4583;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +M/YlJQ2MazciPFLCbEzFmidxAgtgVBkug1ly7YKse97nBX+dG9CanfPtkLexu0B6L7u6Rb9GbkEYM5Ls0jJXBAjFudU/ZPjOrjM8AWXnY8b6OqecTlo+SkKIpIELfhEJsU4pNf0fZMFePlcR1gdEGey60/y9r8B7SCzZEMm89pBb6Bgk2ZOXG04nizkWZ8DlU4rd5c/vNuw3MFv7dlpRFlgESJvLWGtu35LA6ol8Pz1pp+d+ukZ1OxW/P7KnLNdTmhfPhKYbCmqMe4rSPvmsfPn6XbfQKQUB4xgifRlsCH3fBOrHG8FA9ohSzzOs/ifpaOuWQt4Z1lD85WPHpmOOxrlSYszT+rx80s9huTF7ojk2r5Xc/H81Qzk5UghXaazgL+9SCWGbbqvICxQL8hKqmus8+lujIp7OJthipPQ9issc9EN3GDHPBct7mtH59/N
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc20306-62b9-4328-1852-08d76bc42840
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 01:10:52.7476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jps+N6CFFK2l4f7ke2590JZ9/R4hwMIbN6YOuTEa4XRIJMHLw7bBGpgM/CMV+DdyOFV3s4isz8KvIdTSJsxWzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4583
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/18 9:47, Ming Lei wrote:=0A=
> Hi Damine,=0A=
> =0A=
> On Mon, Nov 18, 2019 at 12:18:48AM +0000, Damien Le Moal wrote:=0A=
>> On 2019/11/17 17:08, Ming Lei wrote:=0A=
>>> Now the requeue queue is run in scsi_end_request() unconditionally if b=
oth=0A=
>>> target queue and host queue is ready. We should have re-run request que=
ue=0A=
>>> only after this device queue becomes busy for restarting this LUN only.=
=0A=
>>>=0A=
>>> Recently Long Li reported that cost of run queue may be very heavy in=
=0A=
>>> case of high queue depth. So improve this situation by only running=0A=
>>> requesut queue when this LUN is busy.=0A=
>>=0A=
>> s/requesut/request=0A=
>>=0A=
>> Also, shouldn't this patch have the tag:=0A=
>>=0A=
>> Reported-by: Long Li <longli@microsoft.com>=0A=
>>=0A=
>> ?=0A=
> =0A=
> Will do that in V2.=0A=
> =0A=
>>=0A=
>> Another remark is that Long's approach is generic to the block layer=0A=
>> while your patch here is scsi specific. I wonder if the same problem=0A=
>> cannot happen with other drivers too ?=0A=
> =0A=
> Not sure what you meant about the same problem.=0A=
> =0A=
> It is definitely bad to unconditionally call blk_mq_run_hw_queues()=0A=
> in driver's IO completion handler from performance viewpoint.=0A=
> =0A=
> This patch simply addresses this SCSI specific issue, since blk_mq_run_hw=
_queues()=0A=
> shouldn't be called from scsi_end_request() when the device queue isn't b=
usy.=0A=
> =0A=
> If other driver has such kind of issue, I believe it should have been fix=
ed in=0A=
> driver too.=0A=
> =0A=
> So my patch isn't contradictory with Long's patch which improves generic =
blk-mq's=0A=
> run queue.=0A=
=0A=
OK. Thanks.=0A=
=0A=
> =0A=
> Thanks,=0A=
> Ming=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
