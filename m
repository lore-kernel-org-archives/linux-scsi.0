Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408CFC43331
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 22:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F228E2166E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 22:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gTzUsTgT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ioTO/FWv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbfKFWN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 17:13:28 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:52491 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKFWN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 17:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573078408; x=1604614408;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SALUI6zjpNfmxokBl8QGvQm4DKTxv5qapkVKFZZp17E=;
  b=gTzUsTgT575Uiy1umNgzzk3aYUY1iO2AM6mQEtrsiYBpGSXDNUWTcA5a
   6nqzFFqI7YT9h77DpRtIgfDqcJyDV/51OSe3YnL+3WjBgWMbKnVOeHQu3
   hx9cTlHGacxay0vuVOGCAE8r2GIujX/5KWv2jYDn8fSeU2vZKITfCOgiE
   1S849cG95FQfK7bAyWAioPx5Nkt7p4GKwB9P5UxbmzZuDzfhKeYsGM/e/
   qV6646uFeCfkdl2qYON4UYV2jYfr78PFQGFHh0y+3W3Yd4UbCyjGa78gZ
   6TBzOdFg4N3UAIZ29pYxNn98tvfo8UsWtQIhlC6iCb3OBqYMB2Ir0ZVoJ
   A==;
IronPort-SDR: zvmqvBLWy/fXWiEWrAktv67xH4sZN9GLjEU1zjj+M0hbQHe1yw8PWfrBQZzIeUxVk9FfZwgsUv
 tRt5nViqzE2lhI5+7Nv62RxSvu/QBVp+WFj4SN5upWI5TZAULDXpwUKlC1LEnUOwdvXa3nunZl
 k6ubcpkZR/wMd0R76Fwilib0PX0z4HA9YcvskBwGnnnqn/mXx12AszPsiCB62mBbbdlbFQWW0K
 0spgnylwNCV3CYzJ6XcfWCPJ13zi5aE8q2UXoNZ6CV9BREuFWNkULHaLBO/BjMUZAquKAdbE7i
 JOw=
X-IronPort-AV: E=Sophos;i="5.68,275,1569254400"; 
   d="scan'208";a="123060653"
Received: from mail-dm3nam03lp2057.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.57])
  by ob1.hgst.iphmx.com with ESMTP; 07 Nov 2019 06:13:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR5IDqMysT/iUTXtM36ij1QBBc0JvAFshe3+YzmqlgpRgAdTzI/RQPLpOu2m70r/UU+Y+YbMbwZaKpPwjpyJRsd2HmxYKxtaW3UklhBf6bMDsG6+ANPe380hQppURaNtANrlXYD4wT9alFvT7WCggYLKPVKyiia9L2sfhnCgQKaDTHMTzuGlkrDX7TJYDP+Xf297HwGGyuZhHeyBtvEqFvZ5GLRYiPFYoj6vZF8ZBxdlByLMxwoMeepFJj+HKxfKhOruFWu+/0X4FAAneL8UJ/aCSAFdpYURfjHkXjNfbYIHR1f75gEWMbv0CoePk7YvyNAWkxBwU4kwH+35kutoew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKVx82VYpKt4Gev1+16+m1MhXGBQ9+8JDJB96xOiyiU=;
 b=gVa3YVgVYeteFA0OKrqGxKQQ/zyxHDv2Jn8hgpZHxJtyRKOw1wi+HIGsamqNbz9FmbFOc5BxN4NWgofOC/vTWL17lo+EIME8kISKCVWdy2VcE142xAGhbd1zMWgaBsZAfL6hrZNlQGyzOU5UFVF9Ia4VdX2V8N+Bi2t1cGa1hU98563z3VwXp6a552iPyIRT+JA3LOQy21YCgefFYkYA81VuO3Ytjzpud2zumq5lKhqlRej5Fw2H0sL3bM/tPx93gV2xwqLuTZVH2soA8cbwHhxINeEed1nJewmBQCJbTVNMuEa7q4uUkgopTSWOWSWRNar3WkUDP+DQvUZv4anD+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKVx82VYpKt4Gev1+16+m1MhXGBQ9+8JDJB96xOiyiU=;
 b=ioTO/FWvhMcpE1Cc6ssLDXUqJxjtzKO7sUSuaBWgfvg7Aoob7VevcW2v9vdOyv2bvGO7872HuQBTw6xadfe7kw81sK4TZjWbp1UJISYSQ7c1bN/+e0Vi+yo26U2u7JFaCcAHCA3zaXeUY+bHYBwl5SFNAES2XdNDGe8wdcTvY/8=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4039.namprd04.prod.outlook.com (52.135.213.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 22:13:25 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:13:25 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>
CC:     Andrea Vai <andrea.vai@unipv.it>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Topic: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Thread-Index: AQHVV3qbTKYWY4pSG0OtJLbZzV/0bg==
Date:   Wed, 6 Nov 2019 22:13:24 +0000
Message-ID: <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e790d844-572d-46bc-7e25-08d763068b2c
x-ms-traffictypediagnostic: BYAPR04MB4039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB40396374C30CEF5BEEDBDA8EE7790@BYAPR04MB4039.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(110136005)(54906003)(91956017)(446003)(476003)(33656002)(71200400001)(7696005)(486006)(102836004)(305945005)(316002)(2906002)(8936002)(6246003)(4326008)(229853002)(6436002)(66066001)(186003)(71190400001)(86362001)(26005)(99286004)(14444005)(76176011)(256004)(53546011)(6506007)(5024004)(14454004)(3846002)(52536014)(66476007)(66556008)(64756008)(66446008)(66946007)(25786009)(76116006)(478600001)(9686003)(6116002)(7416002)(2171002)(74316002)(8676002)(81156014)(81166006)(7736002)(55016002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4039;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PuEzR0BziA9IKd/pq3hzWt3872BwMkHxssTssHrlMOJaGeq+H+yB/wReyZrW/yxiFwVxKgwuXZ9Rxd/tvHUEk9ko6x01tTcyvZjE7KpsLVo/09fmzYguUVhTxZ4O8J7m3jYlpaCS4tyyhXant1oEcoc3MiuH2d2ayRsqy/zyShpmhlMhdrCtGnfuCY1G7g3qWYj97iJb+lAkj4m2zB3wM2KG45pidRDPqQOhMzAXZB2apJDuXkQYZyWiov9vkQFeHzhdVO/3BcaEiZw0L2x5pHgjvnvLTHp4ouFEpNWrLw7q377hpWnsG5xxCYOo26/PHlRK/O7I1RmHwF4A3DGy1P5qjDDtBLNpLKIj9U/7mI+VzLOaHv+sk9p7rE5H9Gn804WSzrmpUPh/zKsIxz5k4JH8ByDUYGcmyBtSFEho0Fn/41szCxfcE7V3zu6sKd/v
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e790d844-572d-46bc-7e25-08d763068b2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:13:24.9478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCrMbAmqJw8pjrUMaOTadnMUAEjt9y3Sm9H8FnAWgfuSztRS+iYo2/8RxqUKoQq41S8/eoAJiYPdEh+TX5wmdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4039
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/07 1:04, Alan Stern wrote:=0A=
> On Tue, 5 Nov 2019, Jens Axboe wrote:=0A=
> =0A=
>> On 11/5/19 11:31 AM, Alan Stern wrote:=0A=
>>> On Tue, 5 Nov 2019, Andrea Vai wrote:=0A=
>>>=0A=
>>>> Il giorno lun, 04/11/2019 alle 13.20 -0500, Alan Stern ha scritto:=0A=
>>>=0A=
>>>>> You should be able to do something like this:=0A=
>>>>>=0A=
>>>>>          cd linux=0A=
>>>>>          patch -p1 </path/to/patch2=0A=
>>>>>=0A=
>>>>> and that should work with no errors.  You don't need to use git to=0A=
>>>>> apply a patch.=0A=
>>>>>=0A=
>>>>> In case that patch2 file was mangled somewhere along the way, I=0A=
>>>>> have=0A=
>>>>> attached a copy to this message.=0A=
>>>>=0A=
>>>> Ok, so the "patch" command worked, the kernel compiled and ran, but=0A=
>>>> the test still failed (273, 108, 104, 260, 177, 236, 179, 1123, 289,=
=0A=
>>>> 873 seconds to copy a 500MB file, vs. ~30 seconds with the "good"=0A=
>>>> kernel).=0A=
>>>>=0A=
>>>> Let me know what else could I do,=0A=
>>>=0A=
>>> I'm out of suggestions.  If anyone else knows how to make a kernel with=
=0A=
>>> no legacy queuing support -- only multiqueue -- issue I/O requests=0A=
>>> sequentially, please speak up.=0A=
>>=0A=
>> Do we know for a fact that the device needs strictly serialized requests=
=0A=
>> to not stall?=0A=
> =0A=
> Not exactly, but that is far and away the most likely explanation for=0A=
> the device's behavior.  We tried making a bunch of changes, some of=0A=
> which helped a little bit, but all of them left a very large=0A=
> performance gap.  I/O monitoring showed that the only noticeable=0A=
> difference in the kernel-device interaction caused by the $SUBJECT=0A=
> commit was the non-sequential access pattern.=0A=
> =0A=
>> And writes in particular?=0A=
> =0A=
> Andrea has tested only the write behavior.  Possibly reading will be=0A=
> affected too, but my guess is that it won't be.=0A=
> =0A=
>> I won't comment on how broken=0A=
>> that is, just trying to establish this as the problem that's making this=
=0A=
>> particular device be slow?=0A=
> =0A=
> It seems reasonable that the access pattern could make a significant=0A=
> difference.  The device's behavior suggests that it buffers incoming=0A=
> data and pauses from time to time to write the accumulated data into=0A=
> non-volatile storage.  If its algorithm for allocating, erasing, and=0A=
> writing data blocks is optimized for the sequential case, you can=0A=
> easily imagine that non-sequential accesses would cause it to pause=0A=
> more often and for longer times -- which is exactly what we observed.=0A=
> These extra pauses are what resulted in the overall performance =0A=
> decrease.=0A=
> =0A=
> So far we have had no way to perform a direct test.  That is, we don't=0A=
> know of any setting that would change a single kernel between=0A=
> sequential and non-sequential access.  If you can suggest a simple way=0A=
> to force a kernel without the $SUBJECT commit to do non-sequential=0A=
> writes, I'm sure Andrea will be happy to try it out and see if it=0A=
> causes a slowdown.=0A=
> =0A=
>> I've lost track of this thread, but has mq-deadline been tried as the=0A=
>> IO scheduler? We do have support for strictly serialized (writes)=0A=
>> since that's required for zoned device, wouldn't be hard at all to make=
=0A=
>> this cover a blacklisted device like this one.=0A=
> =0A=
> Please spell out the exact procedure in detail so that Andrea can try =0A=
> it.  He's not a kernel hacker, and I know very little about the block =0A=
> layer.=0A=
=0A=
Please simply try your write tests after doing this:=0A=
=0A=
echo mq-deadline > /sys/block/<name of your USB disk>/queue/scheduler=0A=
=0A=
And confirm that mq-deadline is selected with:=0A=
=0A=
cat /sys/block/<name of your USB disk>/queue/scheduler=0A=
[mq-deadline] kyber bfq none=0A=
=0A=
=0A=
> =0A=
> Alan Stern=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
