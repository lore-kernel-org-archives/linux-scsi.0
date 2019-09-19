Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B5CC4CECE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58629218AF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 12:57:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="amfogpvs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DvQ2u2Vv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388618AbfISM5Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 08:57:16 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:56011 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfISM5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 08:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568897835; x=1600433835;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=POt2XX5Qu6Y7l/GoGnwvu1QXK/TRGL3CIaFKgHE7UWo=;
  b=amfogpvsUo8q1VPT0sbPyQ87xjrbxKpdlI6u7q/49Ksj6Ogyf30LCMGN
   SeUyawwx5DB3i0Shj3B819qCUchl2Twpek8mNCq1e8Ccfr3AxTlcu3Fxv
   RWUaI+OR4rQuLMxHhTjY0QRT6YuKCqQgzz1zkeovez+lzR5ct062OQRRA
   OP4mt6vu2JldNEUYIvOXWmak/aosOAugZgaKOocFmwCML5AaRKYK1ZcYT
   afZjQd8xZoijlSsfIBpLZa6Gfu9UIrNNw/5N2Aj5WiUBEjaD43iSBoQIt
   8DmtIAYphtBI06vUmTW9nz/9ERThzUz1ZJ4/aD/A7SpzQ2TDVxFNESXaI
   A==;
IronPort-SDR: FrmAdRGK1CQJTWZzbIpBqQ5DmoaeDngqvJbjfhOqZH0caosdtGItqeo9amWQGGghlgrBcUoE69
 R2SmS15G+x9Vsb+VFO2muuPDe3quyXhWpgoKpWIkdHuS375UqoBbPxYYJ/n1g1Vq9H/v165AkK
 Eh4dY6Jz5QJcqeaGRA0Cml+CKzRCfwDM2xRMaDwb4elqoYzkoIQEVFi7oqr6vAci6K8yb1RZ+9
 Q8UE4vktrpc8qX3KtlUOR1PdBITzOBWv/kdvvxGkbVH8jqdcowV9nqWEY1jzASwqmTMsYLUrrP
 sdY=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="123106568"
Received: from mail-bn3nam04lp2057.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.57])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 20:57:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfnW2QdZ7mGjuU7d6oMybx+ou2hQTkVGGEq/bmYeeRUuq05zVQu+ZofDt3Ib6khMgRbRo++Uv1CHpXWnhcQTnYgsEYahwoHDjAf5W9prdw5Hkb/Ro4tXIbiu45oBMpwa18s7fOE6kWag/+QFi+dntwSXqt0BCjpf5PMexsfHTcYSADbzPGU38alTT20HbLKrQVfmeum/WgAh/3EVFfVZue0UQ8lhOstuz36Sjn4cTxAYGrL3RPk1DgIE6HenN+UirFpVMVt8BRbuSynYTau/zTXt2PBae7+OKlRmcOOcAOkZSmmn5Xa8DUf0YZAh0waUKiFa9Hj5gHNyF/IBifZEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNMr/eVU3rSND+ZmKRImIDaB0gFlFipMpD37suJ/xI4=;
 b=ZuiQjxBvrtUK+qVnhxY3F0+wVESNG9637aTiG+GaWCMyl4jGr5MZouWDYsg7AJQ2lP+xUj5CFgr9E4yIu2c1xS39W6o5f+DPZBk3cJY9/CQ4CqEu3w5qT96a+SllE9Q6JbYW8X0Fe1fCS8PIxtELQriKHkLhCLnVFKtuRo/YzrsiA14DjNRb0sSefhRZCFbnjMcCUpT24q4eZkU+xyQMkdM/4S3GtDGnvL76V+ns7FBundc2SsdkjtAAFxrL1pPxxbOqTItZL54wD5eTJTZqztNgKhjJDbC9MOo0slMazpvV+PpZi4CYPfXssUXhOFy0vvidDcJ+sqUgQoKHj0GjYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNMr/eVU3rSND+ZmKRImIDaB0gFlFipMpD37suJ/xI4=;
 b=DvQ2u2VvLg02rm3Rv3I8DeyicqsBF1cizM9YBOCyac41st3CC6GQQdXrX6fQK/67OaH0N9+9IWhBLN/9NDzH/lWPKNgkgn+pIfYmIdn07ob3M1ZI3nGs2tyv+jplsfP4cG1d1ASQnfS9Yi+wUqYg1EgqW8WX6YXU3pbLuOtauzw=
Received: from SN6PR04MB3886.namprd04.prod.outlook.com (52.135.81.151) by
 SN6PR04MB5455.namprd04.prod.outlook.com (20.177.254.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Thu, 19 Sep 2019 12:57:09 +0000
Received: from SN6PR04MB3886.namprd04.prod.outlook.com
 ([fe80::b869:4231:8ab3:24bc]) by SN6PR04MB3886.namprd04.prod.outlook.com
 ([fe80::b869:4231:8ab3:24bc%6]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 12:57:09 +0000
From:   Hans Holmberg <Hans.Holmberg@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Index: AQHVbum/gL9AYsauPEqAkOhCDfLySQ==
Date:   Thu, 19 Sep 2019 12:57:09 +0000
Message-ID: <SN6PR04MB3886E534864F4909E690672BEB890@SN6PR04MB3886.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.Holmberg@wdc.com; 
x-originating-ip: [85.230.191.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0084802-4b1d-4e72-89f7-08d73d00e216
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN6PR04MB5455;
x-ms-traffictypediagnostic: SN6PR04MB5455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5455721E33A0C22DF52E6DC0EB890@SN6PR04MB5455.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(199004)(189003)(53754006)(66446008)(6246003)(91956017)(4744005)(6116002)(14444005)(76116006)(33656002)(186003)(316002)(3846002)(66066001)(66946007)(4326008)(305945005)(66476007)(8676002)(55016002)(9686003)(64756008)(5660300002)(2906002)(7696005)(7736002)(86362001)(81166006)(25786009)(81156014)(6436002)(76176011)(229853002)(66556008)(71190400001)(74316002)(71200400001)(476003)(446003)(486006)(478600001)(53546011)(54906003)(6506007)(110136005)(99286004)(52536014)(256004)(26005)(102836004)(14454004)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB5455;H:SN6PR04MB3886.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o6UfzVQZ0OkKR/2BcX8ccx0mkxQxbwnR11qMcSnuCcqaGTl/Mpzwh2psBoSmYTyRfsJtvmZl518P7M166gLFZ0z20eayVj37c982JrFynAb1lh1ezigCv/+ttvDwYzQAnWcvhVe5OHfdjSC0/Qc3ZThnwq1gZ1p0i59IZO8evGhGbqrQFFaoSj5lXts+BWDL7ldRsMztiFtdeq6E0R95KkTGTuPjsDrApisYpAt1zwQYpd4SxJkFkssb5wn/fOMoWgO37hfnndrMKy6vG+C/MaI0AfWkbkKk1ID/E+SVr/kOOeY+GHWQSxMrf3pZPuTdynpiD4akkrDvnJ8i2Y+0KnU43zTk4m31DLAoEkFDUtImksap0pipjYx6oPzc+lk59c7r5GkyFskfVOfFyveo4RlK9G47YN5FKX02VdJEwYo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0084802-4b1d-4e72-89f7-08d73d00e216
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 12:57:09.7657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 657SVMb37saSt9N3w6O+WA9lzSNFaURHbM2I+AwJ+5IyY3xSAugDVTCg1l63xh2sVcY4zOl7ntLelBaNngHSZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5455
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-19 11:45, Hannes Reinecke wrote:=0A=
> Hi all,=0A=
> =0A=
> Damien pointed out that there are some areas in the blk-mq I/O=0A=
> scheduling algorithm which have a distinct legacy feel to it,=0A=
> and prohibit multiqueue I/O schedulers from working properly.=0A=
> These two patches should clear up this situation, but as it's=0A=
> not quite clear what the original intention of the code was=0A=
> I'll be posting them as an RFC.=0A=
> =0A=
> So as usual, comments and reviews are welcome.=0A=
> =0A=
> Hannes Reinecke (2):=0A=
>    blk-mq: fixup request re-insert in blk_mq_try_issue_list_directly()=0A=
>    blk-mq: always call into the scheduler in blk_mq_make_request()=0A=
> =0A=
>   block/blk-mq.c | 9 ++-------=0A=
>   1 file changed, 2 insertions(+), 7 deletions(-)=0A=
> =0A=
=0A=
I tested this patch set in qemu and confirmed that write locking for ZBD =
=0A=
now works again.=0A=
=0A=
The bypass of the scheduler(in case (q->nr_hw_queues > 1 && is_sync) is =0A=
the culprit, and with this removed, we're good again for zoned block =0A=
devices.=0A=
=0A=
Cheers,=0A=
Hans=0A=
