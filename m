Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E1FC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1182467B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 14:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=arrikto-com.20150623.gappssmtp.com header.i=@arrikto-com.20150623.gappssmtp.com header.b="TbF89NBr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgAXOXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:23:24 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45397 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731659AbgAXOXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 09:23:24 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so1210179lfa.12
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 06:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M7Z8KguGyGrtLfBMqY4wl99vU+N7ApmZw1y+IbjQEx0=;
        b=TbF89NBrPPtjbS1P/FwyWSe2nucdwaM3kEujRt5kLsRMVFROqH9NQRxQmABrsIhhPp
         SpB7JmLw4eAdnKL6c7VYyEeRZwIoNchwIliPsTOznaUpWABB6caAUy5145uw/iclv6UM
         h0Spd29IN39wMT+jIr6fp8x5MZa4fNiZTMk/X5pgfPoGL/sxmENh4rZn0ilVb/G1V4iT
         6+UEglC+0uEu9gFgBXevCz89sUnlWTu9BOUDS3jIq7sBahbQgkCFQV3vN7u+avzs/3dq
         PvGIGn5GcGEKrYWzcJl6s3CDEC2MR6aZkwhyWfz+h/wvmyFiNETQ6v53gyBnIdPFEND/
         2ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M7Z8KguGyGrtLfBMqY4wl99vU+N7ApmZw1y+IbjQEx0=;
        b=Ei21B6y+ziCW3CVuKHzd6blomqlhVqacanhL2ghxgpFWlTuseVEFQBKdX6a/OMyr8z
         g2coU0c4Wyq8nprqjpzGnZkFzQgn3lcIuBBXp0kGn/LLHcxguLOoJedrNOX7RRWV12EZ
         6lwQ2KyBXZusK6FQT6+9aqnUsQp+sa83v4KWVKnAbGNWGOLF3gFpiZ588GJcCif7gWKA
         jjc3eTcSZelcFi6jt23zDgGt1HPW2rHsDbDKzZTUQL7H4AOKqG+IjKVQOBr0mQSMCrBg
         2LeaBkzNXLvctd+fhEZsf5jMXSXNhoSXj+neeQix68mzsIweuK9kSSxHJOxeeZbgNgN7
         mkpw==
X-Gm-Message-State: APjAAAVwQ5Rt3bTioHxKo2/SqHsV5tduLJ3/z+wuEJ+1CEljWa2U92Bj
        hxnMzax+5i/fxaCtCm2x7HOckw==
X-Google-Smtp-Source: APXvYqxYFxC8cAjCsNefWipfW5e+yY7MTZfna3SxpxHUdRcvEVbmwtNUP/9O6SCBCuYG19sj+hF7LQ==
X-Received: by 2002:ac2:5388:: with SMTP id g8mr1495011lfh.43.1579875801941;
        Fri, 24 Jan 2020 06:23:21 -0800 (PST)
Received: from [10.94.250.133] ([31.177.62.212])
        by smtp.gmail.com with ESMTPSA id r21sm3158951ljn.64.2020.01.24.06.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 06:23:21 -0800 (PST)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Bates <sbates@raithlin.com>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "frederick.knight@netapp.com" <frederick.knight@netapp.com>,
        Matias Bjorling <Matias.Bjorling@wdc.com>
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
From:   Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <e67bf36e-18cb-a170-39ad-a1081fae5e50@arrikto.com>
Date:   Fri, 24 Jan 2020 16:23:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/20 8:14 PM, Chaitanya Kulkarni wrote:
> Hi all,
> 
> * Background :-
> -----------------------------------------------------------------------
> 
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.
> 
> With reference to the RISC-V summit keynote [1] single threaded
> performance is limiting due to Denard scaling and multi-threaded
> performance is slowing down due Moore's law limitations. With the rise
> of SNIA Computation Technical Storage Working Group (TWG) [2],
> offloading computations to the device or over the fabrics is becoming
> popular as there are several solutions available [2]. One of the common
> operation which is popular in the kernel and is not merged yet is Copy
> offload over the fabrics or on to the device.
> 
> * Problem :-
> -----------------------------------------------------------------------
> 
> The original work which is done by Martin is present here [3]. The
> latest work which is posted by Mikulas [4] is not merged yet. These two
> approaches are totally different from each other. Several storage
> vendors discourage mixing copy offload requests with regular READ/WRITE
> I/O. Also, the fact that the operation fails if a copy request ever
> needs to be split as it traverses the stack it has the unfortunate
> side-effect of preventing copy offload from working in pretty much
> every common deployment configuration out there.
> 
> * Current state of the work :-
> -----------------------------------------------------------------------
> 
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.
> 
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> -----------------------------------------------------------------------
> 
> With the rise of the SNIA Computational Storage TWG and solutions [2],
> existing SCSI XCopy support in the protocol, recent advancement in the
> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
> DMA support in the Linux Kernel mainly for NVMe devices [7] and
> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
> from Copy offload operation.
> 
> With this background we have significant number of use-cases which are
> strong candidates waiting for outstanding Linux Kernel Block Layer Copy
> Offload support, so that Linux Kernel Storage subsystem can to address
> previously mentioned problems [1] and allow efficient offloading of the
> data related operations. (Such as move/copy etc.)
> 
> For reference following is the list of the use-cases/candidates waiting
> for Copy Offload support :-
> 
> 1. SCSI-attached storage arrays.
> 2. Stacking drivers supporting XCopy DM/MD.
> 3. Computational Storage solutions.
> 7. File systems :- Local, NFS and Zonefs.
> 4. Block devices :- Distributed, local, and Zoned devices.
> 5. Peer to Peer DMA support solutions.
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
> 
> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
> 
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
> 
> * Required Participants :-
> -----------------------------------------------------------------------
> 
> I'd like to invite block layer, device drivers and file system
> developers to:-
> 
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
> 
> Required attendees :-
> 
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
> Stephen Bates
> Zach Brown
> Roland Dreier
> Ric Wheeler
> Trond Myklebust
> Mike Snitzer
> Keith Busch
> Sagi Grimberg
> Hannes Reinecke
> Frederick Knight
> Mikulas Patocka
> Matias Bjørling
> 
> [1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
> [2] https://www.snia.org/computational
> https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
>        https://www.eideticom.com/products.html
> https://www.xilinx.com/applications/data-center/computational-storage.html
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
> [4] https://www.spinics.net/lists/linux-block/msg00599.html
> [5] https://lwn.net/Articles/793585/
> [6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
> namespaces-zns-as-go-to-industry-technology/
> [7] https://github.com/sbates130272/linux-p2pmem
> [8] https://kernel.dk/io_uring.pdf
> 
> Regards,
> Chaitanya
> 

This is a very interesting topic and I would like to participate in the
discussion too.

The dm-clone target would also benefit from copy offload, as it heavily
employs dm-kcopyd. I have been exploring redesigning kcopyd in order to
achieve increased IOPS in dm-clone and dm-snapshot for small copies over
NVMe devices, but copy offload sounds even more promising, especially
for larger copies happening in the background (as is the case with
dm-clone's background hydration).

Thanks,
Nikos
