Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C277BFA373D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 09:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiJ0JRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 05:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbiJ0JRF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 05:17:05 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF1E2ED42
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2022 02:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666862224; x=1698398224;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q9/SkNOCAmP0U3/ZAegGPkz4MOkCYIOvnO9GX9L+WZ8=;
  b=FiFxzkBe8B/W427d+VlSeWxsJY/X5J4MuTS9LHlnrJWkPIXo2NH5hY59
   k2XkaGjtYJmxWDEGvGe1KLffz6X8Jk2zpymUKPQ5+NW4BPbFq1OJoloUN
   688fSRIrMZ520+1sUWGPNWlEsd28vKdsIhrbKRN3cDYjNAX8QzZ9gFJqy
   hJ2V/ElfJVajPHZPRH3HHrUXlp2qLp8G1TShWswGW4WUUoNK1KZA8f8js
   zSBw/MkC71p2P17FX918JR5CY20t7UW+LwEV2RJ35ctSVe0iaQjy+1xy4
   5WkEPRTq33voJ2va0J1eQp4NRzygWIUQtaTAUnoGdZkDgM6N9N5/Lj9ne
   A==;
X-IronPort-AV: E=Sophos;i="5.95,217,1661788800"; 
   d="scan'208";a="319187620"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 17:17:03 +0800
IronPort-SDR: BPaBGV+RmAqn6EE0gViG9HVyCbzDEmvJHDM6GlTW5uQi3EfKM7mei+bJ1GFxieohheJsGBkJts
 vgr4SX351E/AssW1WeBOe9t+SgoQ36TyTX93xpAu6X3sdtJ+cOjAITLq+55akDUx1n240Xc++S
 7DwFTW0hlFN5Buk3unSBMs3F1p9mSdi5Rs7uZXRs7+UbpTd2ru/ID+EryjcA/qkmJWCJ15tF22
 bdsLi/rXMQ5keKK5Yyb/wiTqnjrG4b+o0ELB+Gh7h7DeFQWZYZuZMBLnJ7F3DtRN5uHPpIgUud
 wtEzGKht3H41k1yucl9s5kDp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2022 01:30:41 -0700
IronPort-SDR: k0q6HXnboe4KRLZt+acW1N6+6Xkrop6CD5efP49EFYCdlDVs+6JThTbWimU1/M/rIdQT4YjtOI
 BCOseFV0sdZksnJnL1P7ZCDx7gpzwuu1TNsWXg5U91xVzdx00gwr1o/+SBsGZrS90b5O5+qL21
 V4P9lLg0WgdZX2iyYVDSVRJU8GlKhV9i2AyjUWR3KOa2o3TmotO8W++LVr4E6JNxp1gz98BtKK
 fkGgmw91OZHcgM2Cy+Pxw3oxXb8z4BhVpQL7vCDAG78qpZbTF35tTkjvNpGwXV5Px4mIGSmUuJ
 XFg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Oct 2022 02:17:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Myg6k2WrPz1Rx15
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2022 02:17:02 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666862221; x=1669454222; bh=q9/SkNOCAmP0U3/ZAegGPkz4MOkCYIOvnO9
        GX9L+WZ8=; b=HCUwTD893R86qXUKjy/7Q/QgwKisfnOpf+wcnmvlw6Qee3jbci/
        k0vDkv8exAqpG7/eVpPvfM1+K52Y9loTziS/s9NlLs8QsHXSRXqfAZiZYOJjORQE
        TjdjkYUJnKBdzchXhSzxW5XRmy25c8Mw8MbuCJLxIMSo9URc9N3XmzKggne91YI/
        Fs4gOFz7qWeVwg3fzHNVEqWd4fOXIVjRRyfGlBZjuF16sJw81XbIcf7NoyjyaYg6
        kq5rLUp4bXzNoaMfcX1J1lDv1nPD89SWGYHT/uGZP9qo5ghtFgnACkJxk5CVzLGb
        ZUawYHcUUKYNX+aWKD62tCm9uTT6hWc4o6g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7SWeZAyCKdiA for <linux-scsi@vger.kernel.org>;
        Thu, 27 Oct 2022 02:17:01 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Myg6f00VXz1RvLy;
        Thu, 27 Oct 2022 02:16:57 -0700 (PDT)
Message-ID: <5417d401-6fb3-c1d7-58df-e24e0013cfb8@opensource.wdc.com>
Date:   Thu, 27 Oct 2022 18:16:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH RFC v3 16/22] ata: libata-scsi: Allocate sdev early in
 port probe
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@cloud.ionos.com, bvanassche@acm.org, hch@lst.de,
        ming.lei@redhat.com, niklas.cassel@wdc.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
References: <1666693096-180008-1-git-send-email-john.garry@huawei.com>
 <1666693096-180008-17-git-send-email-john.garry@huawei.com>
 <6c0a4a75-786a-c946-57f2-c511bd765bcc@opensource.wdc.com>
 <d4535f4f-d9cf-30de-ce8c-9d8ee9c0decb@suse.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <d4535f4f-d9cf-30de-ce8c-9d8ee9c0decb@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/22 17:11, Hannes Reinecke wrote:
> On 10/27/22 03:34, Damien Le Moal wrote:
>> On 10/25/22 19:18, John Garry wrote:
>>> Currently the per-ata device sdev is allocated as part of the scsi
>>> target
>>> scan, which is after the ata port probe.
>>>
>>> However it is useful to have the sdev available in the port probe. As=
 an
>>> example of an advantage, if the request queue is available in the pro=
be
>>> (which it would be if the sdev is available), then it is possible to =
use
>>> a SCSI cmnd for ATA internal commands. The benefit of this is then we
>>> can
>>> put the ATA qc structure in the SCSI cmnd private data. It will also =
be
>>> useful if we want to send ATA internal commands as requests.
>>>
>>> Export scsi_target_reap() so that it can be used to put the extra
>>> reference we get when allocating the sdev.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>> =C2=A0 drivers/ata/libata-eh.c=C2=A0=C2=A0 |=C2=A0 1 +
>>> =C2=A0 drivers/ata/libata-scsi.c | 23 +++++++++--------------
>>> =C2=A0 drivers/scsi/scsi_scan.c=C2=A0 |=C2=A0 1 +
>>> =C2=A0 3 files changed, 11 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>>> index 08e11bc312c2..1ed5b1b64792 100644
>>> --- a/drivers/ata/libata-eh.c
>>> +++ b/drivers/ata/libata-eh.c
>>> @@ -3446,6 +3446,7 @@ static int ata_eh_schedule_probe(struct
>>> ata_device *dev)
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ata_eh_detach_dev(dev);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ata_dev_init(dev);
>>> +=C2=A0=C2=A0=C2=A0 ata_scsi_setup_sdev(dev);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ehc->did_probe_mask |=3D (1 << dev->de=
vno);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ehc->i.action |=3D ATA_EH_RESET;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ehc->saved_xfer_mode[dev->devno] =3D 0=
;
>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>> index efdba852e363..476e0ef4bd29 100644
>>> --- a/drivers/ata/libata-scsi.c
>>> +++ b/drivers/ata/libata-scsi.c
>>> @@ -1109,7 +1109,12 @@ int ata_scsi_dev_config(struct scsi_device
>>> *sdev, struct ata_device *dev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dev->flags & ATA_DFLAG_TRUSTED)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdev->security=
_supported =3D 1;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 dev->sdev =3D sdev;
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Put extra reference which we get when all=
ocating the starget
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * initially
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 scsi_target_reap(scsi_target(sdev));
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 }
>>> =C2=A0 @@ -4289,26 +4294,16 @@ void ata_scsi_scan_host(struct ata_por=
t
>>> *ap, int sync)
>>> =C2=A0=C2=A0 repeat:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ata_for_each_link(link, ap, EDGE) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ata_for_each_d=
ev(dev, link, ENABLED) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
truct scsi_device *sdev;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
truct Scsi_Host *shost =3D ap->scsi_host;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 int channel =3D 0, id =3D 0;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (dev->sdev)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 continue;
>>> -
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ata_is_host_link(link))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 id =3D dev->devno;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 else
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 channel =3D link->pmp;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 sdev =3D __scsi_add_device(ap->scsi_host, channel, id, 0,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 NULL);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (!IS_ERR(sdev)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 dev->sdev =3D sdev;
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ata_scsi_assign_ofnode(dev, ap);
>>
>> Is there something equivalent to what this function does inside
>> scsi_scan_target() ? I had a quick look but did not see anything...
>>
> Typically, the SCSI layer has two ways of scanning.
> One it the old-style serial scanning (originating in the old SCSI
> parallel model):
> The scanning code will blindly scan _all_ devices up to max_luns, and
> attach every device for which the scanning code returns 'OK'.
> The other one is to issue REPORT_LUNS and scan all LUNs returned there.
>=20
> Mapped to libata we would need to figure out a stable SCSI enumeration,
> given that we have PMP and slave devices to content with.
> To my knowledge we have ATA ports, each can have either a 'master' and
> 'slave' device, _or_ it be a PMP port when it can support up to 16
> devices, right?

yes

> Point being, master/slave and PMP are exclusive, right?

Never heard of pmp with ide cable :)

> So we can make the master as LUN 0, and the slave as LUN 1.

Yes, but isn't that a little wrong ? That would assume that the ata port
is the device and the ata devices the luns of that device. But beside
the "link busy" stuff that needs to be dealt with, master and slave are
independent devices, unlike LUNs. No ?

> And for PMP we can use each PMP address as LUN <pmp> + 1, and keeping
> the actual device as LUN 0.
>=20
> I think we can figure out whether it's a master/slave device setup
> upfront, so we should be able to set max_luns to '2' for these devices.
> For PMP-capable (or devices which _might_ be PMP capable), we could
> emulate the REPORT LUNS command, mapping on the PMP mechanism to figure
> out which devices are connected.
>=20
> Would that work?
>=20
> Cheers,
>=20
> Hannes

--=20
Damien Le Moal
Western Digital Research

