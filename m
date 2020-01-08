Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A56C33C9E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 10:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1E62072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 10:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="EDnLJIr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbgAHKSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 05:18:04 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32797 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAHKSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 05:18:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so2779489lji.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 02:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xKXl8mES0mj219S7GiqAgh2w0+y6gtLh3SMd5LwoB2w=;
        b=EDnLJIr1hw5V3+k4YlmnhWxmnQgzORCuxNgnWc/PF3iJS2BrzhooA1Ms4qf0rpqqEa
         DAaMhr79XAz7dhgrAPr6l8R1scHIGJvjPrDhEZub4HXKW7acxGnY8peAqLOZ0opcx5+h
         d9cL5q78Z8EqcMY8wy0D/XkfUE4Z4/T4LU+S68mm2cBAaqDVS1Qa6h4eEKi9fMPjj1Uk
         ADnUeNR3j/Y+e/TDpivRiMbMFx0CWCS38J1s5EobOHBk4iq/hX27hHMVq5rD2phlaCv3
         cGtf3mAn0OxKkL/9chgNJPHji+mZta8QWOPc30epJ/5giT2W3hlEV+JRWTCQ50Ume2lj
         z6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xKXl8mES0mj219S7GiqAgh2w0+y6gtLh3SMd5LwoB2w=;
        b=byH1MuOpSH8lZ5+S92/LxTycX99aLT9GVWwUfRMLdoNtKb+hR4V3ZB6TO7TTA0M5Ka
         ZsoMJQ4T+E4kYJQeHcp7R5fFbHI6JbU33GxYTRRdjIU0zaC7tqbiVQMkG/xy3S9KFoSh
         vZ9qsC9WfCYEQ1vmjquhD8liVDP1ox0WzV/Ldhonymrn9BN2nZmTRyOnHmjHefGI/IdF
         nRIuulhbPAEzOAhYaG07MlywciPMvYTuIvwjt97FHbSpPBIUwKsN3CWp0xemc2WxdR3A
         Ds4ozLSxlP+PDLBZnZG5Amj6YQlUjiyozs1jdF7LzaouAu8SsvSZX7yy8ij6hu7Sva6A
         oSvQ==
X-Gm-Message-State: APjAAAUOgGjGoMRs5SjS5IuhpAuvfwfNUJwucNWRkcA1ZzA4yw/aR2F9
        DeVX4ojEMFlSo8IU2IbggRLXZw==
X-Google-Smtp-Source: APXvYqxkrQcJp1PRSIjXq1IfBZjXHOW7grwryb0mwHMQOGl3j6AuqxM80gYItsKZXFTgXF0ueCxUyw==
X-Received: by 2002:a2e:9e4c:: with SMTP id g12mr2396280ljk.15.1578478681198;
        Wed, 08 Jan 2020 02:18:01 -0800 (PST)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id q13sm1157778ljj.63.2020.01.08.02.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 02:18:00 -0800 (PST)
Date:   Wed, 8 Jan 2020 11:17:59 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
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
        Matias Bjorling <Matias.Bjorling@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20200108101759.32gkjxakxigolail@mpHalley.local>
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07.01.2020 18:14, Chaitanya Kulkarni wrote:
>Hi all,
>
>* Background :-
>-----------------------------------------------------------------------
>
>Copy offload is a feature that allows file-systems or storage devices
>to be instructed to copy files/logical blocks without requiring
>involvement of the local CPU.
>
>With reference to the RISC-V summit keynote [1] single threaded
>performance is limiting due to Denard scaling and multi-threaded
>performance is slowing down due Moore's law limitations. With the rise
>of SNIA Computation Technical Storage Working Group (TWG) [2],
>offloading computations to the device or over the fabrics is becoming
>popular as there are several solutions available [2]. One of the common
>operation which is popular in the kernel and is not merged yet is Copy
>offload over the fabrics or on to the device.
>
>* Problem :-
>-----------------------------------------------------------------------
>
>The original work which is done by Martin is present here [3]. The
>latest work which is posted by Mikulas [4] is not merged yet. These two
>approaches are totally different from each other. Several storage
>vendors discourage mixing copy offload requests with regular READ/WRITE
>I/O. Also, the fact that the operation fails if a copy request ever
>needs to be split as it traverses the stack it has the unfortunate
>side-effect of preventing copy offload from working in pretty much
>every common deployment configuration out there.
>
>* Current state of the work :-
>-----------------------------------------------------------------------
>
>With [3] being hard to handle arbitrary DM/MD stacking without
>splitting the command in two, one for copying IN and one for copying
>OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
>candidate. Also, with [4] there is an unresolved problem with the
>two-command approach about how to handle changes to the DM layout
>between an IN and OUT operations.
>
>* Why Linux Kernel Storage System needs Copy Offload support now ?
>-----------------------------------------------------------------------
>
>With the rise of the SNIA Computational Storage TWG and solutions [2],
>existing SCSI XCopy support in the protocol, recent advancement in the
>Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
>DMA support in the Linux Kernel mainly for NVMe devices [7] and
>eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
>from Copy offload operation.
>
>With this background we have significant number of use-cases which are
>strong candidates waiting for outstanding Linux Kernel Block Layer Copy
>Offload support, so that Linux Kernel Storage subsystem can to address
>previously mentioned problems [1] and allow efficient offloading of the
>data related operations. (Such as move/copy etc.)
>
>For reference following is the list of the use-cases/candidates waiting
>for Copy Offload support :-
>
>1. SCSI-attached storage arrays.
>2. Stacking drivers supporting XCopy DM/MD.
>3. Computational Storage solutions.
>7. File systems :- Local, NFS and Zonefs.
>4. Block devices :- Distributed, local, and Zoned devices.
>5. Peer to Peer DMA support solutions.
>6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>
>* What we will discuss in the proposed session ?
>-----------------------------------------------------------------------
>
>I'd like to propose a session to go over this topic to understand :-
>
>1. What are the blockers for Copy Offload implementation ?
>2. Discussion about having a file system interface.
>3. Discussion about having right system call for user-space.
>4. What is the right way to move this work forward ?
>5. How can we help to contribute and move this work forward ?
>
>* Required Participants :-
>-----------------------------------------------------------------------
>
>I'd like to invite block layer, device drivers and file system
>developers to:-
>
>1. Share their opinion on the topic.
>2. Share their experience and any other issues with [4].
>3. Uncover additional details that are missing from this proposal.
>
>Required attendees :-
>
>Martin K. Petersen
>Jens Axboe
>Christoph Hellwig
>Bart Van Assche
>Stephen Bates
>Zach Brown
>Roland Dreier
>Ric Wheeler
>Trond Myklebust
>Mike Snitzer
>Keith Busch
>Sagi Grimberg
>Hannes Reinecke
>Frederick Knight
>Mikulas Patocka
>Matias Bjørling
>
>[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
>[2] https://www.snia.org/computational
>https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
>      https://www.eideticom.com/products.html
>https://www.xilinx.com/applications/data-center/computational-storage.html
>[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
>[4] https://www.spinics.net/lists/linux-block/msg00599.html
>[5] https://lwn.net/Articles/793585/
>[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
>namespaces-zns-as-go-to-industry-technology/
>[7] https://github.com/sbates130272/linux-p2pmem
>[8] https://kernel.dk/io_uring.pdf
>
>Regards,
>Chaitanya

I think this is good topic and I would like to participate in the
discussion too. I think that Logan Gunthorpe would also be interested
(Cc). Adding Kanchan too, who is also working on this and can contribute
to the discussion

We discussed this in the context of P2P at different SNIA events in the
context of computational offloads and also as the backend implementation
for Simple Copy, which is coming in NVMe. Discussing this (again) at
LSF/MM and finding a way to finally get XCOPY merged would be great.

Thanks,
Javier



