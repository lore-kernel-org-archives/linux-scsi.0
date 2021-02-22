Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A88DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 14:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5289B64E41
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 14:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhBVOhB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 09:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbhBVOgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 09:36:36 -0500
X-Greylist: delayed 665 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Feb 2021 06:35:54 PST
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [IPv6:2a05:d018:e66:3130::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87274C061574
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 06:35:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by omni.filmlight.ltd.uk (Postfix) with ESMTP id EB2C140000C3;
        Mon, 22 Feb 2021 14:23:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk EB2C140000C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=filmlight.ltd.uk;
        s=default; t=1614003839;
        bh=VQMtc55Ljvumw+7wILvvZy3NPSK961oavnjbLzhYXnc=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=pBtydMo4oIZirGKjdr6pTl50Cp1DvJy/Xnf6dUsmH/mQCSniyaAghoNpyoEId4qB8
         Ytf3gnV/hEI9RBtYby6IitnQ1DlFOzEbNmNDKGwBUiDNRHv3piY1/hps7nMet0fhdA
         juadogP5GRMBkCdTtHALxnp9EPFtBeUeFXrPSuXg=
Received: from [192.168.0.78] (cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: roger)
        by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 7321A86A260;
        Mon, 22 Feb 2021 14:23:59 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
Date:   Mon, 22 Feb 2021 14:23:59 +0000
Cc:     Roger Willcocks <roger@filmlight.ltd.uk>, mwilck@suse.com,
        john.garry@huawei.com, buczek@molgen.mpg.de,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, hare@suse.de,
        Kevin.Barnett@microchip.com, pmenzel@molgen.mpg.de, hare@suse.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
To:     Don.Brace@microchip.com
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FYI we have exactly this issue on a machine here running CentOS 8.3 =
(kernel 4.18.0-240.1.1) (so presumably this happens in RHEL 8 too.)

Controller is MSCC / Adaptec 3154-8i16e driving 60 x 12TB HGST drives =
configured as five x twelve-drive raid-6, software striped using md, and =
formatted with xfs.

Test software writes to the array using multiple threads in parallel.

The smartpqi driver would report controller offline within ten minutes =
or so, with status code 0x6100c

Changed the driver to set 'nr_hw_queues =3D 1=E2=80=99 and then tested =
by filling the array with random files (which took a couple of days), =
which completed fine, so it looks like that one-line change fixes it.

Would, of course, be helpful if this was back-ported.

=E2=80=94
Roger



> On 3 Feb 2021, at 15:56, Don.Brace@microchip.com wrote:
>=20
> -----Original Message-----
> From: Martin Wilck [mailto:mwilck@suse.com]=20
> Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count =
early
>=20
>>=20
>>=20
>> Confirmed my suspicions - it looks like the host is sent more =
commands=20
>> than it can handle. We would need many disks to see this issue =
though,=20
>> which you have.
>>=20
>> So for stable kernels, 6eb045e092ef is not in 5.4 . Next is 5.10, and=20=

>> I suppose it could be simply fixed by setting .host_tagset in scsi=20
>> host template there.
>>=20
>> Thanks,
>> John
>> --
>> Don: Even though this works for current kernels, what would chances =
of=20
>> this getting back-ported to 5.9 or even further?
>>=20
>> Otherwise the original patch smartpqi_fix_host_qdepth_limit would=20
>> correct this issue for older kernels.
>=20
> True. However this is 5.12 material, so we shouldn't be bothered by =
that here. For 5.5 up to 5.9, you need a workaround. But I'm unsure =
whether smartpqi_fix_host_qdepth_limit would be the solution.
> You could simply divide can_queue by nr_hw_queues, as suggested =
before, or even simpler, set nr_hw_queues =3D 1.
>=20
> How much performance would that cost you?
>=20
> Don: For my HBA disk tests...
>=20
> Dividing can_queue / nr_hw_queues is about a 40% drop.
> ~380K - 400K IOPS
> Setting nr_hw_queues =3D 1 results in a 1.5 X gain in performance.
> ~980K IOPS
> Setting host_tagset =3D 1
> ~640K IOPS
>=20
> So, it seem that setting nr_hw_queues =3D 1 results in the best =
performance.
>=20
> Is this expected? Would this also be true for the future?
>=20
> Thanks,
> Don Brace
>=20
> Below is my setup.
> ---
> [3:0:0:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdd=20
> [3:0:1:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sde=20
> [3:0:2:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdf=20
> [3:0:3:0]    disk    HP       EH0300FBQDD      HPD5  /dev/sdg=20
> [3:0:4:0]    disk    HP       EG0900FDJYR      HPD4  /dev/sdh=20
> [3:0:5:0]    disk    HP       EG0300FCVBF      HPD9  /dev/sdi=20
> [3:0:6:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdj=20
> [3:0:7:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdk=20
> [3:0:8:0]    disk    HP       EG0900FBLSK      HPD7  /dev/sdl=20
> [3:0:9:0]    disk    HP       MO0200FBRWB      HPD9  /dev/sdm=20
> [3:0:10:0]   disk    HP       MM0500FBFVQ      HPD8  /dev/sdn=20
> [3:0:11:0]   disk    ATA      MM0500GBKAK      HPGC  /dev/sdo=20
> [3:0:12:0]   disk    HP       EG0900FBVFQ      HPDC  /dev/sdp=20
> [3:0:13:0]   disk    HP       VO006400JWZJT    HP00  /dev/sdq=20
> [3:0:14:0]   disk    HP       VO015360JWZJN    HP00  /dev/sdr=20
> [3:0:15:0]   enclosu HP       D3700            5.04  -       =20
> [3:0:16:0]   enclosu HP       D3700            5.04  -       =20
> [3:0:17:0]   enclosu HPE      Smart Adapter    3.00  -       =20
> [3:1:0:0]    disk    HPE      LOGICAL VOLUME   3.00  /dev/sds=20
> [3:2:0:0]    storage HPE      P408e-p SR Gen10 3.00  -       =20
> -----
> [global]
> ioengine=3Dlibaio
> ; rw=3Drandwrite
> ; percentage_random=3D40
> rw=3Dwrite
> size=3D100g
> bs=3D4k
> direct=3D1
> ramp_time=3D15
> ; filename=3D/mnt/fio_test
> ; cpus_allowed=3D0-27
> iodepth=3D4096
>=20
> [/dev/sdd]
> [/dev/sde]
> [/dev/sdf]
> [/dev/sdg]
> [/dev/sdh]
> [/dev/sdi]
> [/dev/sdj]
> [/dev/sdk]
> [/dev/sdl]
> [/dev/sdm]
> [/dev/sdn]
> [/dev/sdo]
> [/dev/sdp]
> [/dev/sdq]
> [/dev/sdr]
>=20
>=20
> Distribution kernels would be yet another issue, distros can backport =
host_tagset and get rid of the issue.
>=20
> Regards
> Martin
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20

