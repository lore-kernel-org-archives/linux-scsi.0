Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9440C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 07:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhKVHm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 02:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhKVHmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 02:42:55 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12301C061574;
        Sun, 21 Nov 2021 23:39:49 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d5so30950240wrc.1;
        Sun, 21 Nov 2021 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=59Uf33qFbC50ReMtjtCPkloBHRUfMzOqwlWxxxPFuLU=;
        b=D5rYQu/sC3/VbXCvDhnGLF31bs7GNDQ0e0Hf6LdaiGM0Z955z/bj+i9ILcMnMXi6tC
         wBncqaYCXCiQlfD+OKcaXdM+Zju0MS6BmslxwXHNiJgKx2ckIoqvThDnOZ5pDi6SB0Wv
         MR1wlpZjCEghZG2Z3LhyaXKsJMZhSHe4UhKWLeokSKaCcHNn5E6xLOFdM7RDLPXAQfTV
         DfE/pZCHigD5uF01VbnRh8qrytIy85xzPDZy2K5NO/0PnsaaccL1irSnrKdIjRFbm/Gk
         hznyGXdbMGlCXsunXJ0rXpUHjQiYlJXvwdkFlIiPo1nDAUEny9DJQ/f7FyTY6vVsXWPr
         mmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=59Uf33qFbC50ReMtjtCPkloBHRUfMzOqwlWxxxPFuLU=;
        b=k0Je2GaeFzF2ZHF9QiTh12eqeiPPaMofkwQnlwXMsmLzFqfF/CUgUl04fTEtEw3brc
         1oBILhZAu2tnsZG/qyvMUYh/Cr3P2eVsicj/YETDcIv42KhVWwQeWBZWoiNXA3ipyUJg
         Nm91szegQch6TiWucZoEgO9nc/UkmqWakTcpvvWIDHB8e424eiNf1Z3R6m+iLgyOzY5P
         ygRoO5qMyPLkjHvs27u5z0gPl0+mgJJln4iRtxMf1V5t3FEWII/oGBP9S//DXTc5EOAp
         J3K3901ZiPMdUF5wouTwVVsDcXxp7eW01iqKzvcBAAhkqY3kB+AEj1+razw/Xeu9aIyc
         H8RA==
X-Gm-Message-State: AOAM5315/9StQ4Ix8S4enNZfmzBJNXBm5vQUoa6267P/BXxjKe7YVkBs
        BxP6zfafA9zx+3v67B2PlURRkRDeUe+dvj0BgLs=
X-Google-Smtp-Source: ABdhPJzlurbcl6fKzLl3g89MINwTiqNH1fxX1EGfM0gA2NeWfvkvhN1/nxnVHg4NbFTuJ4XTOVtqX5UItInjbbe9hJE=
X-Received: by 2002:a5d:47a1:: with SMTP id 1mr34008799wrb.436.1637566787459;
 Sun, 21 Nov 2021 23:39:47 -0800 (PST)
MIME-Version: 1.0
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org> <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org> <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com> <20211029081447.ativv64dofpqq22m@ArmHalley.local>
 <20211103192700.clqzvvillfnml2nu@mpHalley-2> <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
In-Reply-To: <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 22 Nov 2021 13:09:22 +0530
Message-ID: <CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Updated one (points from Keith and Bart) -

Given the multitude of things accumulated on this topic, Martin
suggested to have a table/matrix.
Some of those should go in the initial patchset, and the remaining are
to be staged for subsequent work.
Here is the attempt to split the stuff into two buckets. Please change
if something needs to be changed below.

1. Driver
*********
Initial: NVMe Copy command (single NS), including support in nvme-target
Subsequent: Multi NS copy, XCopy/Token-based Copy

2. Block layer
**************
Initial:
- Block-generic copy (REQ_OP_COPY), with interface accommodating two block-=
devs
- Emulation, when offload is natively absent
- DM support (at least dm-linear)

Subsequent: Integrity and encryption support

3. User-interface
*****************
Initial: new ioctl or io_uring opcode

4. In-kernel user
******************
Initial: at least one user
- dm-kcopyd user (e.g. dm-clone), or FS requiring GC (F2FS/Btrfs)

Subsequent:
- copy_file_range

On Tue, Nov 16, 2021 at 7:15 PM Javier Gonz=C3=A1lez <javier@javigon.com> w=
rote:
>
> Hi all,
>
> Thanks for attending the call on Copy Offload yesterday. Here you have
> the meeting notes and 2 specific actions before we proceed with another
> version of the patchset.
>
> We will work on a version of the use-case matrix internally and reply
> here in the next couple of days.
>
> Please, add to the notes and the matrix as you see fit.
>
> Thanks,
> Javier
>
> ----
>
> ATTENDEES
>
> - Adam
> - Arnav
> - Chaitanya
> - Himashu
> - Johannes
> - Kanchan
> - Keith
> - Martin
> - Mikulas
> - Niklas
> - Nitesh
> - Selva
> - Vincent
> - Bart
>
> NOTES
>
> - MD and DM are hard requirements
>         - We need support for all the main users of the block layer
>         - Same problem with crypto and integrity
> - Martin would be OK with separating Simple Copy in ZNS and Copy Offload
> - Why did Mikulas work not get upstream?
>         - Timing was an issue
>                 - Use-case was about copying data across VMs
>                 - No HW vendor support
>                 - Hard from a protocol perspective
>                         - At that point, SCSI was still adding support in=
 the spec
>                         - MSFT could not implement extended copy command =
in the target (destination) device.
>                                 - This is what triggered the token-based =
implementation
>                                 - This triggered array vendors to impleme=
nt support for copy offload as token-based. This allows mixing with normal =
read / write workloads
>                         - Martin lost the implementation and dropped it
>
> DIRECTION
>
> - Keeping the IOCTL interface is an option. It might make sense to move f=
rom IOCTL to io_uring opcode
> - Martin is happy to do the SCSIpart if the block layer API is upstreamed
> - Token-based implementationis the norm. This allows mixing normal read /=
 write workloads to avoid DoS
>         - This is the direction as opposed to the extended copy command
>         - It addresses problems when integrating with DM and simplifies c=
ommand multiplexing a single bio into many
>         - It simplifies multiple bios
>         - We should explore Mikulas approach with pointers.
> - Use-cases
>         - ZNS GC
>         - dm-kcopyd
>         - file system GC
>         - fabrics offload to the storage node
>         - copy_file_range
> - It is OK to implement support incrementally, but the interface needs to=
 support all customers of the block layer
>         - OK to not support specific DMs (e.g., RAID5)
>         - We should support DM and MD as a framework and the personalitie=
s that are needed. Inspiration in integrity
>                 - dm-linear
>                 - dm-crypt and dm-verify are needed for F2FSuse-case in A=
ndrod
>                         - Here, we need copy emulation to support encrypt=
ion without dealing with HW issues and garbage
> - User-interface can wait and be carried out on the side
> - Maybe it makes sense to start with internal users
>         - copy_file_range
>         - F2FS GC, btrfs GC
> - User-space should be allowed to do anything and kernel-space can chop t=
he command accordingly
> - We need to define the heuristics of the sizes
> - User-space should only work on block devices (no other constructs that =
are protocol-specific) . Export capabilities in sysfs
>         - Need copy domains to be exposed in sysfs
>         - We need to start with bdev to bdev in block layer
>         - Not specific requirement on multi-namespace in NVMe, but it sho=
uld be extendable
>         - Plumbing will support all use-cases
> - Try to start with one in-kernel consumer
> - Emulation is a must
>         - Needed for failed I/Os
>         - Expose capabilities so that users can decide
> - We can get help from btrfs and F2FS folks
> - The use case for GC and for copy are different. We might have to reflec=
t this in the interface, but the internal plumbing should allow both paths =
to be maintained as a single one.
>
> ACTIONS
>
> - [ ] Make a list of use-cases that we want to support in each specificat=
ion and pick 1-2 examples for MD, DM. Make sure that the interfaces support=
 this
> - [ ] Vendors: Ask internally what is the recommended size for copy, if
>    any
>


--=20
Joshi
