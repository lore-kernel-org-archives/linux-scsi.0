Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B46DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 08:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiLUIcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 03:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLUIcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 03:32:06 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16C4120A3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 00:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671611524; x=1703147524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GpSoAKsiBOwoBfW9vBweEHhy/wwzt4SgDIbpqyU2VXE=;
  b=JSB1mMhGlFMXld9//BQKI1bvm4HjdpJ+XQ7U0pLKJ2phZInOod7RK58k
   g7o6YWu4tY73DxViwxXQ+YjAVExVGD8ya2EtUNZQ69cBV0ra9zxHC3XA4
   qYdgWrDlcqCg7Ww2gJBPflz2njR1+VDnShWcHIz9uNbAgEyMMWOAW4JDc
   7mxezWNJMNtjCjdqE6RgVIfVQ8ynpQprFAhELu0PG2p2DBHOPbO9L0ned
   nPPiCwaVdY1GfXqTl/pHC7DP6DIVmOMcttcDIiXCP65UerfgnDmrKhrK7
   OeNXIeRPq8Jb/G2tDuhTpgOxHP4vdECuC5UVKXGG0qxALLOzWcz/FamK2
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665417600"; 
   d="scan'208";a="217381156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Dec 2022 16:32:03 +0800
IronPort-SDR: v8k++FXpKVhXWwDTOICWNjmTU0p0QRWEjvf7PS2rEismICsW+EhPx9ckyC6hYjAps4RWBoMiFr
 wtZqc11ybAAZwFPFLwcL3CTsrT28zg7wBeGnimstZw+QOeg65pR42Ul30NcgAM7LrlJfyoK9bL
 1ck9J/JjlSAmUvhTDUc2f/X05oV5d6vA2pxfUL7kTiVxQG2Zpjzt+34tx0oTCcx5W7O8/kUpfO
 N6/ytXX8jk9tVkHdMibcUB3A2c0Q/Gjn+NxGCMD7m/jXyk3y56wZDNQORcdbcnUCVXnMvIT4V2
 E8Q=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Dec 2022 23:50:17 -0800
IronPort-SDR: Z4K9Jw9okZ9GGrqFXz5JsfufHUiKP8QMOd/WonpEJCi55E0qvff2Am7H18TMQkeur7jcIIlakj
 mmb/unSlBzwXwmAtvhbwIAj0Iqb66FwCd4b4ahLbSRa38UbmKFiWhMCoSQCg/g+kl95VzUtrLc
 aeo+EN3pMhjdCYmtJqBqZ14PjLNUu7rIv7WKtMaccSQNfkwEKVjszvGNmVjmlJqNx4bOyL1E+6
 6k0EIjzq370/XXgwysaTWVzMykI9wG/+ShXwAt9c4LivMkiP79c2MmXt2ioqYKvQuhsHte8TBL
 pEw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Dec 2022 00:32:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NcRWR2Rhpz1Rwtl
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 00:32:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1671611522; x=1674203523; bh=GpSoAKsiBOwoBfW9vBweEHhy/wwzt4SgDIb
        pqyU2VXE=; b=UCqarplSyQQFIhovNM+CxAlLoeL4zzCcSau7cQmfKpy5n5mTfND
        Vs2DVLwi+rzoNWdy8bw7A/tFxj7nNQDPFk2sl7qwOpsJG6ZerbNW4REmlqTE3XLY
        UCxLDm53P2p0TEdfW8YGqmqWnCZkfzkS+vtv+KyCuAqMyENbL+zeRD57O6BCrNMC
        Ba2APSGIddWLyI4Jc3Bm7c9ZGdSxMWKEEtYMI0LKHMMMvattD79cPqvvtrAqvuSF
        LdnPkKuGLNYJk98Xk7WIFsNbbByN7uxAB2gQalDePUGOElwk2N1ENodQWRcnKNKl
        wSPpKTsyzh5mVWwzkd6oRtPz6oVXR8fQ0UQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JLP4C8N5FIB3 for <linux-scsi@vger.kernel.org>;
        Wed, 21 Dec 2022 00:32:02 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NcRWN4RKSz1RvLy;
        Wed, 21 Dec 2022 00:32:00 -0800 (PST)
Message-ID: <f77c7872-3711-2216-c17c-e23591f745c7@opensource.wdc.com>
Date:   Wed, 21 Dec 2022 17:31:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: libsas: Grab the host lock in
 sas_ata_device_link_abort()
To:     Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Xingui Yang <yangxingui@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, niklas.cassel@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        kangfenglong@huawei.com
References: <20221220125349.45091-1-yangxingui@huawei.com>
 <4ec9dbed-1758-d6b4-dc1d-ac42e8c22731@oracle.com>
 <c8387766-2ca0-51f3-e332-71492b13e5c1@opensource.wdc.com>
 <7347d117-6e0b-dd18-90a8-25685f757689@huawei.com>
 <4ff0ca00-31f5-2867-ff59-cecb5d6d1048@opensource.wdc.com>
 <755d7a9c-427e-024a-8509-449ebc5a00e6@huawei.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <755d7a9c-427e-024a-8509-449ebc5a00e6@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21/22 15:35, Jason Yan wrote:
> On 2022/12/21 11:59, Damien Le Moal wrote:
>> On 2022/12/21 11:42, Jason Yan wrote:
>>> On 2022/12/21 8:36, Damien Le Moal wrote:
>>>> On 2022/12/20 23:59, John Garry wrote:
>>>>> On 20/12/2022 12:53, Xingui Yang wrote:
>>>>>> Grab the host lock in sas_ata_device_link_abort() before calling
>>>>>
>>>>> This is should be the ata port lock, right? I know that the ata
>>>>> comments
>>>>> say differently.
>>>>>
>>>>>> ata_link_abort(), as the comment in ata_link_abort() mentions.
>>>>>>
>>>>>
>>>>> Can you please add a fixes tag?
>>>>>
>>>>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>>>>
>>>>> Reviewed-by: John Garry <john.g.garry@oracle.com>
>>>>>
>>>>>> ---
>>>>>> =C2=A0=C2=A0=C2=A0 drivers/scsi/libsas/sas_ata.c | 3 +++
>>>>>> =C2=A0=C2=A0=C2=A0 1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/scsi/libsas/sas_ata.c
>>>>>> b/drivers/scsi/libsas/sas_ata.c
>>>>>> index f7439bf9cdc6..4f2017b21e6d 100644
>>>>>> --- a/drivers/scsi/libsas/sas_ata.c
>>>>>> +++ b/drivers/scsi/libsas/sas_ata.c
>>>>>> @@ -889,7 +889,9 @@ void sas_ata_device_link_abort(struct
>>>>>> domain_device *device, bool force_reset)
>>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ata_port *ap =3D=
 device->sata_dev.ap;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ata_link *link =3D=
 &ap->link;
>>>>>> +=C2=A0=C2=A0=C2=A0 unsigned long flags;
>>>>>> =C2=A0=C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(ap->lock,=
 flags);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->sata_dev.fis[2]=
 =3D ATA_ERR | ATA_DRDY; /* tf status */
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->sata_dev.fis[3]=
 =3D ATA_ABORTED; /* tf error */
>>>>>> =C2=A0=C2=A0=C2=A0 @@ -897,6 +899,7 @@ void sas_ata_device_link_ab=
ort(struct
>>>>>> domain_device *device, bool force_reset)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (force_reset)
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 link->eh_info.action |=3D ATA_EH_RESET;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ata_link_abort(link);
>>>>
>>>> Really need to add lockdep annotations in libata to avoid/catch such
>>>> bugs...
>>>> Will work on that.
>>>
>>> Actually in libata there are many places calling ata_link_abort() not
>>> holding port lock. And some places are holding the real host
>>> lock(ata_host->lock) while calling ata_link_abort(). So if you add th=
e
>>> lockdep annotations, there may be too many warnings. If these are rea=
l
>>> issues, we should fix them first.
>>
>> libata-EH does most of its work without the port lock held because by
>> the time
>> we get EH started, we are guaranteed to be idle with no commands in
>> flight. That
>> is why the calls you mention look like "bugs" but are not.
>=20
> What about the interrupt handler such as ahci_error_intr()? I didn't se=
e
> the callers hold the port lock too. Do they need the port lock?

It looks like it is missing for ahci_thunderx_irq_handler() but that one
takes the host lock. Same for xgene_ahci_irq_intr(), again no port lock
but host lock taken. And again for ahci_single_level_irq_intr() for the
non MSI case. For modern MSI adapters, the port lock is taken in

For other cases, ahci_multi_irqs_intr_hard) takes the port lock.

So it looks like ahci_port_intr() needs to take the lock and some
cleanups overall (the host lock should not be necessary in the command
path. But nobody seems to have issues with the "bad" cases... Probably
because they are not mainstream adapters.

Definitely some work needed here.

--=20
Damien Le Moal
Western Digital Research

