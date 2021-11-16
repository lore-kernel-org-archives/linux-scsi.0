Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176BAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 13:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE25261A09
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 13:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhKPNq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 08:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236748AbhKPNqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 08:46:23 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCECAC061746
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 05:43:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so88218953edd.10
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 05:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KRYob5UpR+HW1UgJCdrQVrkG2CB+gcAgwD9AJ1Q6jl8=;
        b=McbNpWKdQv3snjiBdKVjiCMPrmcuVNKLy58ZVz8ly2z0KQlalBGOOYQIYxCtwWRqkR
         N0YStnPB7SqmKlST3AaDjU3xT385xq8vmeT93EA9zlXhobbyQf7XFwJ+kWKVR8Ghsw8O
         rNR7rZyCycl/+D19EN+oFfcpp94opyYH3WOISiPNdg36NMcR3HTNeWcV9/XeNya+IUDE
         oYZka/qD1VqAR8QwQAVa05b3XDntn9SmmnF+3fY736rtZ1V6PG8wG7NKuqv3sQtfbX/U
         MuaRZmiRvUtEMsjohHyGe02gIBaJJcD9LTvOV89ofuTMBow/cbJCnTrBvITqTlCrKIMb
         X/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KRYob5UpR+HW1UgJCdrQVrkG2CB+gcAgwD9AJ1Q6jl8=;
        b=d8ZoSMvN6oW0dP1E25MYgOkY1p7cmDnry2HLwHYVeNu9X+Zsb5qOoSy8hVVcfq0U0M
         DGCI3Z4wW4PBgbIe/0cr5ckmjgtjw1md1F04rQ26qN9AWlQriaMHE66cZYvDaUzStdbE
         RD8HM8wUhZm+WpD6iqP1VxCINV4c9S/LM885BAAM4mL237zhT+nIPYVKwAIyffQfwsOr
         b/799MUIVLJGvFMn489qpSo6Itn/xI8WwZaUdkZiTzguN7y+Sn2lH5mc4SDPNZgLHw/8
         vJLKvRMcpMT/acwe6VKzrfMXM0hDL/5g1cHs3jzXOEUm34ZNaJ0b7C2/FutBY5vEnhBH
         6Nag==
X-Gm-Message-State: AOAM531FaWQgdR7j3hvru2NotXDO6I1269luM/vD+jkqGNm68LNgruCV
        FdMbOu4jiJFaKQ2xmNI/rz+8LQ==
X-Google-Smtp-Source: ABdhPJxUIBIRGuiudLhLqlGGmXvbEWTLx3ubRxQoIdfOPt1u04Vu3kDjMVkYGgkbKcw0d0AJNIREWQ==
X-Received: by 2002:a17:907:9801:: with SMTP id ji1mr10190475ejc.170.1637070205347;
        Tue, 16 Nov 2021 05:43:25 -0800 (PST)
Received: from localhost (5.186.126.13.cgn.fibianet.dk. [5.186.126.13])
        by smtp.gmail.com with ESMTPSA id i5sm8426046ejw.121.2021.11.16.05.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 05:43:24 -0800 (PST)
Date:   Tue, 16 Nov 2021 14:43:24 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
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
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <20211029081447.ativv64dofpqq22m@ArmHalley.local>
 <20211103192700.clqzvvillfnml2nu@mpHalley-2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20211103192700.clqzvvillfnml2nu@mpHalley-2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Thanks for attending the call on Copy Offload yesterday. Here you have
the meeting notes and 2 specific actions before we proceed with another
version of the patchset.

We will work on a version of the use-case matrix internally and reply
here in the next couple of days.

Please, add to the notes and the matrix as you see fit.

Thanks,
Javier

----

ATTENDEES

- Adam
- Arnav
- Chaitanya
- Himashu
- Johannes
- Kanchan
- Keith
- Martin
- Mikulas
- Niklas
- Nitesh
- Selva
- Vincent
- Bart

NOTES

- MD and DM are hard requirements
	- We need support for all the main users of the block layer
	- Same problem with crypto and integrity
- Martin would be OK with separating Simple Copy in ZNS and Copy Offload
- Why did Mikulas work not get upstream?
	- Timing was an issue
		- Use-case was about copying data across VMs
		- No HW vendor support
		- Hard from a protocol perspective
			- At that point, SCSI was still adding support in the spec
			- MSFT could not implement extended copy command in the target (destination) device.
				- This is what triggered the token-based implementation
				- This triggered array vendors to implement support for copy offload as token-based. This allows mixing with normal read / write workloads
			- Martin lost the implementation and dropped it

DIRECTION

- Keeping the IOCTL interface is an option. It might make sense to move from IOCTL to io_uring opcode
- Martin is happy to do the SCSIpart if the block layer API is upstreamed
- Token-based implementationis the norm. This allows mixing normal read / write workloads to avoid DoS
	- This is the direction as opposed to the extended copy command
	- It addresses problems when integrating with DM and simplifies command multiplexing a single bio into many
	- It simplifies multiple bios
	- We should explore Mikulas approach with pointers.
- Use-cases
	- ZNS GC
	- dm-kcopyd
	- file system GC
	- fabrics offload to the storage node
	- copy_file_range
- It is OK to implement support incrementally, but the interface needs to support all customers of the block layer
	- OK to not support specific DMs (e.g., RAID5)
	- We should support DM and MD as a framework and the personalities that are needed. Inspiration in integrity
		- dm-linear
		- dm-crypt and dm-verify are needed for F2FSuse-case in Androd
			- Here, we need copy emulation to support encryption without dealing with HW issues and garbage
- User-interface can wait and be carried out on the side
- Maybe it makes sense to start with internal users
	- copy_file_range
	- F2FS GC, btrfs GC
- User-space should be allowed to do anything and kernel-space can chop the command accordingly
- We need to define the heuristics of the sizes
- User-space should only work on block devices (no other constructs that are protocol-specific) . Export capabilities in sysfs
	- Need copy domains to be exposed in sysfs
	- We need to start with bdev to bdev in block layer
	- Not specific requirement on multi-namespace in NVMe, but it should be extendable
	- Plumbing will support all use-cases
- Try to start with one in-kernel consumer
- Emulation is a must
	- Needed for failed I/Os
	- Expose capabilities so that users can decide
- We can get help from btrfs and F2FS folks
- The use case for GC and for copy are different. We might have to reflect this in the interface, but the internal plumbing should allow both paths to be maintained as a single one.

ACTIONS

- [ ] Make a list of use-cases that we want to support in each specification and pick 1-2 examples for MD, DM. Make sure that the interfaces support this
- [ ] Vendors: Ask internally what is the recommended size for copy, if
   any

