Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5F8EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 16:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjGFQ7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjGFQ7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 12:59:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEDD1BF3
        for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2023 09:59:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b8b318c5cfso5861165ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jul 2023 09:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1688662748; x=1691254748;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4gTb79PzD+Bp2K1St3Arp6MKpukyjkPSawUeRda+hU=;
        b=KsljQ3aPQzLZudpcr8DkfxCP3zVtWPyao6bHP2sAaLsyW9wZfmvN73x4fh/yqs7rKa
         QxA4Wt137grXYkcnr1GyqbGBZVyOHJiV/l31bHFIK8vc5enXT+gLwK9hLjOnmEeyPjo4
         X/vFMXIZrc+m/rUXiFoPKS2ETfD/QMkr05z2B1KVDMRcnxjBnJwFyXZ0dZqkVsIj2cLZ
         Mn94ia0M03T2N6tkWlfqbjtC/EiOQzCSc6HHxIFsIACexB+ixSnvAKDV3R7QCIL4Arzl
         WpD0knIMMVrxy/qX/ygY3/LxlsENGxsyqGvQDqlo7nq8CLRGQTs8Q2b3HQHCJajRoIHM
         AlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662748; x=1691254748;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4gTb79PzD+Bp2K1St3Arp6MKpukyjkPSawUeRda+hU=;
        b=QJy2mMoEUGwxLXpeO91NuiS6Xy1E/UQ19b1RdftsR5+TG6CqV5BAqJZ05wTHBpfd6b
         NS9ePNwGvijWqK8NSXVq2EWyW7ahJkirKQKHGDnNg36cp0Qp6AX0P78ELX13Qu1xJI13
         hdtZhYz5F0lbd2LTz15adr2rTxdyJLQQXh/SjbP5YvdexZe1+EiN62P5ePdGjsBy2TkK
         EfFo1iA740jIuLnyisLIjJZ/MaoDorf7UfRYVwJW1Q9/+P2Bip7B6vMlzsnaaZqPA4w0
         T34WIXJIq4IN8JKD7Tmub1r3TNmxKYXY/wdH5zNwoaegGOvhXHWaTcgkZLqcGhlc+bdW
         OS+Q==
X-Gm-Message-State: ABy/qLaYd3weUFCN5W1ERLjOsu1g/Sgps7dpjB4zfRS6Kaiam1zcTn7p
        kBa5/s6yI/s6OZvEVAsiA88RjMMg9L2LNeXcNwrRqwirP40tdnu1XIFLp11WQwNhS3hkRLxy7/v
        Xc+W6oQftDYtEiKcI3bvifbE8lDq8XH23hBKN/wsMnEKrmKGBvOksLzaLymkri3hIslSClMWt5F
        NWhnxBRi36
X-Google-Smtp-Source: APBJJlGbozC+LqTeT4Nb+/DSXmZd+HDRSkVmUHcWF7V8aGa9dymDhVrHNLcAXXWvUev0C53bhci5sg==
X-Received: by 2002:a17:902:d892:b0:1b8:36a8:faf9 with SMTP id b18-20020a170902d89200b001b836a8faf9mr2662505plz.38.1688662748271;
        Thu, 06 Jul 2023 09:59:08 -0700 (PDT)
Received: from smtpclient.apple ([136.226.79.24])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b8b6089eecsm1658417plb.143.2023.07.06.09.59.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jul 2023 09:59:07 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN
 list
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <20220729233839.GA578093@dev-ushankar.dev.purestorage.com>
Date:   Thu, 6 Jul 2023 09:58:56 -0700
Cc:     Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>,
        Uday Shankar <ushankar@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B5030FEC-EE79-4C30-B2F8-8EFA687A2D9B@purestorage.com>
References: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
 <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
 <20220729233839.GA578093@dev-ushankar.dev.purestorage.com>
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3731.600.7)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Jul 29, 2022, at 4:38 PM, Uday Shankar <ushankar@purestorage.com> =
wrote:
>=20
> Hannes, I understand that Brian reached out to you for feedback on =
this
> patch. I still have doubts I'd like to clarify; I quote portions of
> your response below.
>=20
>> Biggest problem is that we currently cannot 'reload' an existing SCSI
>> device, as the inquiry data is fixed.
>=20
> I agree; scsi_probe_and_add_lun called with rescan =3D=3D =
SCSI_SCAN_MANUAL
> on a LUN for which we already have a struct scsi_device seems to be
> essentially no-op. scsi_rescan_device will update VPD, but not other
> inquiry data.
>=20
>> So if we come across things like EMC Clariion which changes the
>> inquiry data for LUN0 when mapping devices to the host we don't have
>> any other choice but to physically remove the device and rescan it
>> again. Which is okay if you run under multipath, but for directly
>> accessed devices it'll kill your machine :-(
>=20
> I don't understand how a "reload" will help in this scenario. I don't
> know the specifics of the EMC Clariion behavior, but based on your
> description and what I've read in the driver code I assume the device
> changes the PDT/PQ fields in the LUN 0 inquiry depending on whether or
> not there is storage attached to it. There are two "transitions:"
>=20
> Attaching storage to LUN 0: We don't save a struct scsi_device for
> devices whose PDT/PQ indicates "no storage attached," so when storage
> gets attached and PDT/PQ changes, scsi_probe_and_add_lun will act as =
if
> its seeing a new device for the first time. Everything should work.
>=20
> Detaching storage from LUN 0: The current implementation of target =
scan
> won't pick up the updated inquiry data, sure, but a "reload" can't =
save
> your machine from dying if programs were accessing the LUN 0 volume
> directly, can it? Regardless of what the host does, the fact remains
> that it can no longer do I/O on the LUN 0 volume. The only thing the
> host can control is the particular flavor of errors delivered to these
> programs, and the one associated to "device is gone" seems to be most
> accurate, and the one that Brian's patch (if it applied to all =
devices,
> not just those with vendor PURE) would deliver.
>=20
> Overall: we'd like to eliminate the need for manual rescans wherever
> possible, and we're willing to revise the patch and/or submit patches
> elsewhere as needed to achieve that goal. Please advise.
>=20
> Thanks,
> Uday

Recently I came across this from RedHat which shows that the open source
provisioning applications have similarly run into the same issues with =
the
orphaned devices being re-used by different volumes. In light of this, =
in a
more dynamic world where connections and disconnections will be more
common, does this change the idea around device purging in the kernel
for LUN ID=E2=80=99s not returned in the reported LUN list? It seems =
like each of
these provisioning tools will hit this if they don=E2=80=99t account =
specifically for it.

https://access.redhat.com/solutions/7012184

Thanks,
Brian

