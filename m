Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B0FC7EE30
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 00:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCBACn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 19:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCBACm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 19:02:42 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274A515D5
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 16:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677715360; x=1709251360;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=34dfqjtuiGcwJrLLugWDHI6y0A7gz4kEwjRvn80jzs8=;
  b=Dxr+Xnv9S7hzgkEhBtrQzzE6cY4qF9UC7wd/XSoVzLiQoj3rhmSbuoyO
   akc5tigfxVySrBjpFKAjvrfAHWu66ohFhpgxncXZS3bzgPHyqaxfbX8Ol
   5nlTTq3LBbgwKYTnaTqgChhQQ9D4mDjlASHjVn5kiXNV4f0VE8GQ2E9iL
   AsC1mOqRBwHkWyCdR10BejXVIlb0PaEK2l8shY24OwIXucpabmV5rcZF/
   4n7m0dptIYuUPtumJygwruWVtEj8i+gfgpqEokTPxDVr7XvmVarew2rKK
   z7EV4R1Br+Gu4B2ozIn2wtBsLLLKteOYM75GFFXikPA7yf44gTVViLEIM
   g==;
X-IronPort-AV: E=Sophos;i="5.98,225,1673884800"; 
   d="scan'208";a="222857514"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2023 08:02:38 +0800
IronPort-SDR: 2zpah96JWB5iPgVim8YmIAygG7lsC6o00xBzT2j3+BVLaVwtvy7KL7HxiOh1xTr1jAdTN6Zx0G
 6jruGKylOTO0Ic9NZyAasMlNNmxcnoO4BT6mJIEMd4xfuZKYUM8yR6JkEaHlkewz11/spC8bQ1
 qYzW9u7OS9TI12EEPQXSH6vfdFCmVV0wfVOlQ62fFInwj6RT7QSZKE8NNy0KdBelFk6uX5ott+
 lbR5kq/DJeQ08aNPPLK9hQfVSaFTakwBaPOf6/fXvSeMoP2H/TcYxSNYWodPRYyn8RS/nbaygR
 VQg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2023 15:13:43 -0800
IronPort-SDR: vdQmVkgn15G2L8p+8zD+/6qDYH0pCpS7A2YlRjrVoyuwELsB7GegdGGAqSqTtNH9wrsxS4elMF
 E9HzZn/TzxQw/T4x3UZ8ZTk+Ty3OuKhp7DxDkC7jC7w/QKFupf/hwEG4nOZESGxCjj7kmuXorn
 oc9EZsZ1jXk+dMHuMXCzBjUF3DTtOXPOna2aDAZUOLuB+TujMKb/Do8JwSFjvPVJ/ZYHrt9+fU
 VW339UbfwveJdFBvj8MhVBlCbC08bYCH8hZkFPwR6uhlY1fNCXSpIY5BXa1q1JPSuWRdJ76N+W
 q5c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Mar 2023 16:02:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PRrrt3B0Cz1RwqL
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 16:02:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677715357; x=1680307358; bh=34dfqjtuiGcwJrLLugWDHI6y0A7gz4kEwjR
        vn80jzs8=; b=ilviGqxl+OdhJv/DRUfBiZCw2Fe1MdlybWUNNA9X9mipco5y0x9
        SZgYyKKMfJwvue+QXv3WLJ91dN+80132LCvJUAXyKEEqY+FzlC8LwF2hvGxsLvQE
        CZcubahKUVyOl+n0tA+V5vvDDkNArtuhjTCGQh9S0xTKZLrA+uk0bWWT1iEo1bu3
        /6POhE273tl2ioE5sPKm/yJLPwBuq5DVeapJ82xXoB2DwHY9be49PH5+2j60cywx
        Kn+rVSpoKY6EfcT3mHRGBM/302uD9tXm7dmF5kJMqkbS7AshLn0HW1GqgJWfk2fM
        aiIBkKFJu4B9sZ4y+9hyEtxhkANevJk5kPg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iB_INrx6lreo for <linux-scsi@vger.kernel.org>;
        Wed,  1 Mar 2023 16:02:37 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PRrrs1bdgz1RvLy;
        Wed,  1 Mar 2023 16:02:36 -0800 (PST)
Message-ID: <f054cece-14f2-8333-4583-9c725de887af@opensource.wdc.com>
Date:   Thu, 2 Mar 2023 09:02:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
Content-Language: en-US
To:     Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/23 08:34, Khazhy Kumykov wrote:
> HSMR HDDs are a type of SMR HDD that allow for a dynamic mixture of
> CMR and SMR zones, allowing users to convert regions of the disk
> between the two. The way this is implemented as specified by the SCSI
> ZAC-2 specification is there=E2=80=99s a set of =E2=80=9CCMR=E2=80=9D r=
egions and =E2=80=9CSMR=E2=80=9D
> regions. These may be grouped into =E2=80=9Crealms=E2=80=9D that may, a=
s a group, be
> online or offline. Zone management can bring online a domain/zone and
> offline any corresponding domains/zones.
>=20
> I=E2=80=99d like to discuss what path makes sense for supporting these
> devices, and also how to avoid potential issues specific to the =E2=80=9C=
mixed
> CMR & SMR IO traffic=E2=80=9D use case - particularly around latency du=
e to
> potentially unneeded (from the perspective of an application) zone
> management commands.

Hard no on supporting these. See below.

>=20
> Points of Discussion
> =3D=3D=3D=3D
>=20
>  - There=E2=80=99s already support in the kernel for marking zones
> online/offline and cmr/smr, but this is fixed, not dynamic. Would
> there be hiccups with allowing zones to come online/offline while
> running?

No, there is no support for "marking" zones offline (or read only): trans=
itions
into these states are not explicit due to any command execution, but dete=
rmined
by the drive, and asynchronous as far as the host is concerned. There is =
support
for *detecting* offline zones though, so that FSes do not attempt to use =
these
dead zones. But that is more part of error processing than the regular IO=
 path
because seeing offline zones is not expected, but rather, the result of a=
 drive
going bad. HMSMR would essentially allow users to explicitly offline zone=
s,
wreaking the IO path and potentially generating lots of IO errors.

So HSMR support should only be allowed (if it ever is) to be controlled b=
y a
file system, not by the user. And if the user wants to do raw block devic=
e IOs,
then it can use passthrough commands to control the activation state of z=
ones.

>  - There may be multiple CMR =E2=80=9Czones=E2=80=9D that are contiguou=
s in LBA space.
> A benefit of HSMR disks is, to a certain extent, software which is
> designed for all-CMR disks can work similarly on a contiguous CMR area
> of the HSMR disk (modulo handling =E2=80=9Cresizes=E2=80=9D). This may =
result in IO
> that can straddle two CMR =E2=80=9Czones=E2=80=9D. It=E2=80=99s not a p=
roblem for writes to
> span CMR zones, but it is for SMR zones, so this distinction is useful
> to have in the block layer.

Writes to CMR zones on regular host-managed SMR can straddle CMR zone bou=
ndaries
too (but not CMR-to-SMR boundary). We do not allow it because micro optim=
izing
for this case is not worth the overhead it introduces. So hard no on this=
.

>  - What makes sense as an interface for managing these types of
> not-quite CMR and not quite SMR disks? Some of the featureset overlaps
> with existing SMR support in blkdev_zone_mgmt_ioctl, so perhaps the
> additional conversion commands could be added there?

Passthrough commands. There are no kernel internal users of this, so I do=
 not
see any need to add an interface for activate/deactivate zones. libzbc v6=
 is
coming soon with an API for zone domains/zone realms commands (already av=
ailable
with the zone-domains branch of the source code).

>  - mitigating & limiting tail latency effects due to report zones
> commands / limiting =E2=80=9Cunnecessary=E2=80=9D zone management calls=
.

There is no implicit zone management commands issued by the kernel, excep=
t the
one report zones done on disk scan/revalidate. Any zone management comman=
d is
explicit, asked for by the user or FS using the drive. So that is up to t=
he user
to limit these to control the overhead.

In general, support for hybrid SMR (Zone domains / zone realms) is a hard=
 no
from me. This feature set is a total nightmare to deal with in the kernel=
. It
opens a ton of corner cases that will require lots of checks in the hot p=
ath. We
definitely do not want that.

--=20
Damien Le Moal
Western Digital Research

