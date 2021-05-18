Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEBDC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 00:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABFD61360
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 00:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbhERAQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 20:16:39 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:39708 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344949AbhERAQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 20:16:33 -0400
Received: by mail-pg1-f178.google.com with SMTP id v14so3021888pgi.6;
        Mon, 17 May 2021 17:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ma0y+AVUF5FMxdqp11h4WFBWrewppi+BP0ptgmZXHNY=;
        b=rcf5780RorwrxoweWjAm501Qj583TK4nRZdNSJVKBvEZ3QQGFBks/nNpEyrI9URLIx
         S+aZ+42V6IfSvdCgQzF670BMAx0kPP0RGcld98ROcvyOsi70h82SK/1HutoWIb2Zw61L
         NY4x2LJ3OJfSIxMLrOg4iVVcDGI67IghEervJvzbqzFvzwcp4PV3hHzsUlrsM+zgw2xx
         ne2f+Dv48NlwBcH2fXDV3+QrKLwAp0mBxODdo0nqc/XsVoolXE+/yFCjfWnDpq1RAY4A
         Zq/8yuEJfBxCmlq16SnCFejH8Dr2K3B7NJGV4pbY7FZbku8Dq74IpsQ0r6Mzx9Ex36kK
         Qh4Q==
X-Gm-Message-State: AOAM53243qSUMMJN+/Volr7L3l9Ls/WxTCt54Ge4pQnz749YencvpuxM
        5rQtGz6GD1MB7AQD/B33eUc=
X-Google-Smtp-Source: ABdhPJwRgqjZwa+aml3zeF/6QupA23QGawzuRvsXsHqBnEjcM+kPVN9ffwKUcYegX+/ZwO/OZBf4Vg==
X-Received: by 2002:a65:48c5:: with SMTP id o5mr2168498pgs.101.1621296915872;
        Mon, 17 May 2021 17:15:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9781:8633:8854:8704? ([2601:647:4000:d7:9781:8633:8854:8704])
        by smtp.gmail.com with ESMTPSA id 10sm5158247pgl.39.2021.05.17.17.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 17:15:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
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
        "osandov@fb.com" <osandov@fb.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Message-ID: <0cfa9399-701a-9fa2-3225-3b54007462e7@acm.org>
Date:   Mon, 17 May 2021 17:15:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/21 5:15 PM, Chaitanya Kulkarni wrote:
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?

We need to achieve agreement about an approach. The text below is my
attempt at guiding the discussion. A HTML version is available at
https://github.com/bvanassche/linux-kernel-copy-offload. As usual,
feedback is welcome.

Bart.


# Implementing Copy Offloading in the Linux Kernel

## Introduction

Efforts to add copy offloading support in the Linux kernel started considerable
time ago. Despite this copy offloading support is not yet upstream and there is
no detailed plan yet of how to implement copy offloading.

This document outlines a possible implementation. The purpose of this document
is to help guiding the conversations around copy offloading.

## Block Layer

We need an interface to pass copy offload requests from user space or file
systems to block drivers. Although the first implementation of copy offloading
added a single operation to the block layer for copy offloading, there seems
to be agreement today to implement copy offloading as two operations,
namely `REQ_COPY_IN` and `REQ_COPY_OUT`.

A possible approach is as follows:

* Fall back to a non-offloaded copy operation if necessary, e.g. if copy
  offloading is not supported or if data is encrypted and the ciphertext
  depends on the LBA. The following code may be a good starting point:
  `drivers/md/dm-kcopyd.c`.
* If the block driver supports copy offloading, submit the `REQ_COPY_IN`
  operation first. The block driver stores the data ranges associated with the
  `REQ_COPY_IN` operation.
* Wait for completion of the `REQ_COPY_IN` operation.
* After the `REQ_COPY_IN` operation has completed, submit the `REQ_COPY_OUT`
  operation and include a reference to the `REQ_COPY_IN` operation. If the
  block driver that receives the `REQ_COPY_OUT` operation receives a matching
  `REQ_COPY_IN` operation, offload the copy operation. Otherwise report that no
  data has been copied and let the block layer perform a non-offloaded copy
  operation.

The operation type is stored in the top bits of the `bi_opf` member of struct
bio.  With each bio a single data buffer and a single contiguous byte range on
the storage medium are associated. Pointers to the data buffer occur in
`bi_io_vec[]`. The affected byte range is represented by `bi_iter.bi_sector` and
`bi_iter.bi_size`.

While the NVMe and SCSI copy offload commands both support multiple source
ranges, XCOPY supports multiple destination ranges while the NVMe simple copy
command supports a single destination range.

Possible approaches for passing the data ranges involved in a copy operation
from the block layer to block drivers are as follows:

* Attach a bio to each copy offload request and encode all relevant copy
  offload parameters in that data buffer. These parameters include source
  device and source ranges for `REQ_COPY_IN` and destination device and
  destination ranges for `REQ_COPY_OUT`. Let the block drivers translate these
  parameters into something the storage device understands (NVMe simple copy
  parameters or SCSI XCOPY parameters). Fill in the parameter structure size
  in `bi_iter.bi_size`. Set `bi_vcnt` to 1 and fill in `bio->bi_io_vec[0]`.
* Map each source range and each destination range onto a different bio. Link
  all the bios with the `bi_next` pointer and attach these bios to the copy
  offload requests. Leave `bi_vcnt` zero. This is related but not identical to
  the approach followed by `__blkdev_issue_discard()`.

I think that the first approach would require more changes in the device mapper
than the second approach since the device mapper code knows how to split bios
but not how to split a buffer with LBA range descriptors.

The following code needs to be modified no matter how copy offloading is
implemented:

* Request cloning. The code for checking the limits before request are cloned
  compares `blk_rq_sectors()` with `max_sectors`. This is inappropriate for
  `REQ_COPY_*` requests.
* Request splitting. `bio_split()` assumes that `bi_iter.bi_size` represents
  the number of bytes affected on the medium.
* Code related to retrying the original requests of a merged request with
  mixed failfast attributes, e.g. `blk_rq_err_bytes()`.
* Code related to partially completing a request, e.g. `blk_update_request()`.
* The code for merging block layer requests.
* `blk_mq_end_request()` since it calls `blk_update_request()` and
  `blk_rq_bytes()`.
* The plugging code because of the following test in the plugging code:
  `blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE`.
* The I/O accounting code (task_io_account_read()) since that code uses
  bio_has_data() and hence skips discard, secure erase and write zeroes
  requests:
```
static inline bool bio_has_data(struct bio *bio)
{
	return bio && bio->bi_iter.bi_size &&
	    bio_op(bio) != REQ_OP_DISCARD &&
	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
	    bio_op(bio) != REQ_OP_WRITE_ZEROESy;
}
```

Block drivers will need to use the `special_vec` member of struct request to
pass the copy offload parameters to the storage device. That member is used
e.g. when a REQ_OP_DISCARD operation is submitted to an NVMe driver. The SCSI
sd driver uses `special_vec` while processing an UNMAP or WRITE SAME command.

## Device Mapper

The device mapper may have to split a request. As an example, LVM is
based on the dm-linear driver. A request that is submitted to an LVM volume
has to be split if it affects multiple block devices. Copy offload requests
that affect multiple block devices should be split or should be onloaded.

The call chain for bio-based dm drivers is as follows:
```
dm_submit_bio(bio)
-> __split_and_process_bio(md, map, bio)
  -> __split_and_process_non_flush(clone_info)
    -> __clone_and_map_data_bio(clone_info, target_info, sector, len)
      -> clone_bio(dm_target_io, bio, sector, len)
      -> __map_bio(dm_target_io)
        -> ti->type->map(dm_target_io, clone)
```

## NVMe

Process copy offload commands by translating REQ_COPY_OUT requests into simple
copy commands.

## SCSI

From inside `sd_revalidate_disk()`, query the third-party copy VPD page. Extract
the following parameters (see also SPC-6):

* MAXIMUM CSCD DESCRIPTOR COUNT
* MAXIMUM SEGMENT DESCRIPTOR COUNT
* MAXIMUM DESCRIPTOR LIST LENGTH
* Supported third-party copy commands.
* SUPPORTED CSCD DESCRIPTOR ID (0 or more)
* ROD type descriptor (0 or more)
* TOTAL CONCURRENT COPIES
* MAXIMUM IDENTIFIED CONCURRENT COPIES
* MAXIMUM SEGMENT LENGTH

From inside `sd_init_command()`, translate REQ_COPY_OUT into either EXTENDED
COPY or POPULATE TOKEN + WRITE USING TOKEN.

Set the parameters in the copy offload commands as follows:

* We may have to set the STR bit. From SPC-6: "A sequential striped (STR) bit
  set to one specifies to the copy manager that the majority of the block
  device references in the parameter list represent sequential access of
  several block devices that are striped. This may be used by the copy manager
  to perform reads from a copy source block device at any time and in any
  order during processing of an EXTENDED COPY command as described in
  6.6.5.3. A STR bit set to zero specifies to the copy manager that disk
  references, if any, may not be sequential."
* Set the LIST ID USAGE field to 3 and the LIST ID to 0. This means that
  neither "held data" nor the RECEIVE COPY STATUS command are supported. This
  improves security because the data that is being copied cannot be accessed
  via the LIST ID.
* We may have to set the G_SENSE (good with sense data) bit. From SPC-6: " If
  the G _SENSE bit is set to one and the copy manager completes the EXTENDED
  COPY command with GOOD status, then the copy manager shall include sense
  data with the GOOD status in which the sense key is set to COMPLETED, the
  additional sense code is set to EXTENDED COPY INFORMATION AVAILABLE, and the
  COMMAND-SPECIFIC INFORMATION field is set to the number of segment
  descriptors the copy manager has processed."
* Clear the IMMED bit.

## System Call Interface

To submit copy offload requests from user space, we need:

* A system call for passing these requests, e.g. copy_file_range() or io_uring.
* Add a copy offload parameter format description to the user space ABI. The
  parameters include source device, source ranges, destination device and
  destination ranges.
* A flag that indicates whether or not it is acceptable to fall back to
  onloading the copy operation.

## Sysfs Interface

To do: define which aspects of copy offloading should be configurable through
new sysfs parameters under /sys/block/*/queue/.

## See Also

* Martin Petersen, [Copy
  Offload](https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg28998.html),
  linux-scsi, 28 May 2014.
* Mikulas Patocka, [ANNOUNCE: SCSI XCOPY support for the kernel and device
  mapper](https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg686111.html),
  15 July 2014.
* [kcopyd documentation](https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/kcopyd.html), kernel.org.
* Martin K. Petersen, [Copy Offload - Here Be Dragons](http://mkp.net/pubs/xcopy.pdf), 2019-08-21.
* Martin K. Petersen, [Re: [dm-devel] [RFC PATCH v2 1/2] block: add simple copy
support](https://lore.kernel.org/linux-nvme/yq1blf3smcl.fsf@ca-mkp.ca.oracle.com/), linux-nvme mailing list, 2020-12-08.
* NVM Express Organization, [NVMe - TP 4065b Simple Copy Command 2021.01.25 -
  Ratified.pdf](https://workspace.nvmexpress.org/apps/org/workgroup/allmembers/download.php/4773/NVMe%20-%20TP%204065b%20Simple%20Copy%20Command%202021.01.25%20-%20Ratified.pdf), 2021-01-25.
* Selvakumar S, [[RFC PATCH v5 0/4] add simple copy
  support](https://lore.kernel.org/linux-nvme/20210219124517.79359-1-selvakuma.s1@samsung.com/),
  linux-nvme, 2021-02-19.

