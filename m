Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223D6C3F68F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 03:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01D1120705
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 03:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgAIDS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 22:18:58 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35575 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgAIDS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 22:18:57 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so2519615pgk.2;
        Wed, 08 Jan 2020 19:18:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xvwJUZHq6lxJoKDxCisGtxxmXtMnuv/UNfH5O07lFZo=;
        b=DxyiTs2pTSnSUEDg/ioaVbWN14CQlUAs6+bU3RV8NpZo5LCb59mi8RhRmBHtxJBO5d
         GMEfr27z+7mKMQBoMT77GGnJf6zquQ8olxlZjL14J7lsRJiAbXu+rqsM3yym0TmHBKBL
         rkORCfnzzdqyReqOHTP2Y6lSkgdToC+01sEkwnPzlI5KBGQzPLixT1E3n5wpkYftI8m5
         mLrkRAYWLj4Y/y45/1IQ7tt9sszEeqm3NiMnf097bY0E2MLDMaocMu+oHh9vUABALOq2
         GO7Muzrvit64/YFWpJe19Gj8N8pyN7FcXGLHbiZjZGIHpnuMG6hCEm2mLXGr3JBlWBI2
         I2tw==
X-Gm-Message-State: APjAAAVjcdsK845gO+3fhQZ1ZsUeWZ4zxjbEWnmtKRYYdaw0xJnlirIC
        Yj3QPR2Nhz1py1eZLDEr5tc=
X-Google-Smtp-Source: APXvYqyGcYW8QghgpwpHDZvledwi63ygsODu3fJ9j6dW7GYv2QsLTnEXqFY8v4xdUd00X1/vgofBjA==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr8663718pgk.357.1578539936882;
        Wed, 08 Jan 2020 19:18:56 -0800 (PST)
Received: from ?IPv6:2601:647:4000:13e0:f4e4:e61b:5262:7ebf? ([2601:647:4000:13e0:f4e4:e61b:5262:7ebf])
        by smtp.gmail.com with ESMTPSA id h126sm5594082pfe.19.2020.01.08.19.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 19:18:55 -0800 (PST)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>, "hare@suse.de" <hare@suse.de>,
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
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org>
Date:   Wed, 8 Jan 2020 19:18:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-07 10:14, Chaitanya Kulkarni wrote:
> * Current state of the work :-
> -----------------------------------------------------------------------
> 
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.

Was this last discussed during the 2018 edition of LSF/MM (see also
https://www.spinics.net/lists/linux-block/msg24986.html)? Has anyone
taken notes during that session? I haven't found a report of that
session in the official proceedings (https://lwn.net/Articles/752509/).

Thanks,

Bart.


This is my own collection with two year old notes about copy offloading
for the Linux Kernel:

Potential Users
* All dm-kcopyd users, e.g. dm-cache-target, dm-raid1, dm-snap, dm-thin,
  dm-writecache and dm-zoned.
* Local filesystems like BTRFS, f2fs and bcachefs: garbage collection
  and RAID, at least if RAID is supported by the filesystem. Note: the
  BTRFS_IOC_CLONE_RANGE ioctl is no longer supported. Applications
  should use FICLONERANGE instead.
* Network filesystems, e.g. NFS. Copying at the server side can reduce
  network traffic significantly.
* Linux SCSI initiator systems connected to SAN systems such that
  copying can happen locally on the storage array. XCOPY is widely used
  for provisioning virtual machine images.
* Copy offloading in NVMe fabrics using PCIe peer-to-peer communication.

Requirements
* The block layer must gain support for XCOPY. The new XCOPY API must
  support asynchronous operation such that users of this API are not
  blocked while the XCOPY operation is in progress.
* Copying must be supported not only within a single storage device but
  also between storage devices.
* The SCSI sd driver must gain support for XCOPY.
* A user space API must be added and that API must support asynchronous
  (non-blocking) operation.
* The block layer XCOPY primitive must be support by the device mapper.

SCSI Extended Copy (ANSI T10 SPC)
The SCSI commands that support extended copy operations are:
* POPULATE TOKEN + WRITE USING TOKEN.
* EXTENDED COPY(LID1/4) + RECEIVE COPY STATUS(LID1/4). LID1 stands for a
  List Identifier length of 1 byte and LID4 stands for a List Identifier
  length of 4 bytes.
* SPC-3 and before define EXTENDED COPY(LID1) (83h/00h). SPC-4 added
  EXTENDED COPY(LID4) (83h/01h).

Existing Users and Implementations of SCSI XCOPY
* VMware, which uses XCOPY (with a one-byte length ID, aka LID1).
* Microsoft, which uses ODX (aka LID4 because it has a four-byte length
  ID).
* Storage vendors all support XCOPY, but ODX support is growing.

Block Layer Notes
The block layer supports the following types of block drivers:
* blk-mq request-based drivers.
* make_request drivers.

Notes:
With each request a list of bio's is associated.
Since submit_bio() only accepts a single bio and not a bio list this
means that all make_request block drivers process one bio at a time.

Device Mapper
The device mapper core supports bio processing and blk-mq requests. The
function in the device mapper that creates a request queue is called
alloc_dev(). That function not only allocates a request queue but also
associates a struct gendisk with the request queue. The
DM_DEV_CREATE_CMD ioctl triggers a call of alloc_dev(). The
DM_TABLE_LOAD ioctl loads a table definition. Loading a table definition
causes the type of a dm device to be set to one of the following:
DM_TYPE_NONE;
DM_TYPE_BIO_BASED;
DM_TYPE_REQUEST_BASED;
DM_TYPE_MQ_REQUEST_BASED;
DM_TYPE_DAX_BIO_BASED;
DM_TYPE_NVME_BIO_BASED.

Device mapper drivers must implement target_type.map(),
target_type.clone_and_map_rq() or both. .map() maps a bio list.
.clone_and_map_rq() maps a single request. The multipath and error
device mapper drivers implement both methods. All other dm drivers only
implement the .map() method.

Device mapper bio processing
submit_bio()
-> generic_make_request()
  -> dm_make_request()
    -> __dm_make_request()
      -> __split_and_process_bio()
        -> __split_and_process_non_flush()
          -> __clone_and_map_data_bio()
          -> alloc_tio()
          -> clone_bio()
            -> bio_advance()
          -> __map_bio()

Existing Linux Copy Offload APIs
* The FICLONERANGE ioctl. From <include/linux/fs.h>:
  #define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)

struct file_clone_range {
	__s64 src_fd;
	__u64 src_offset;
	__u64 src_length;
	__u64 dest_offset;
};

* The sendfile() system call. sendfile() copies a given number of bytes
  from one file to another. The output offset is the offset of the
  output file descriptor. The input offset is either the input file
  descriptor offset or can be specified explicitly. The sendfile()
  prototype is as follows:
  ssize_t sendfile(int out_fd, int in_fd, off_t *ppos, size_t count);
  ssize_t sendfile64(int out_fd, int in_fd, loff_t *ppos, size_t count);
* The copy_file_range() system call. See also vfs_copy_file_range(). Its
  prototype is as follows:
  ssize_t copy_file_range(int fd_in, loff_t *off_in, int fd_out,
     loff_t *off_out, size_t len, unsigned int flags);
* The splice() system call is not appropriate for adding extended copy
  functionality since it copies data from or to a pipe. Its prototype is
  as follows:
  long splice(struct file *in, loff_t *off_in, struct file *out,
    loff_t *off_out, size_t len, unsigned int flags);

Existing Linux Block Layer Copy Offload Implementations
* Martin Petersen's REQ_COPY bio, where source and destination block
  device are both specified in the same bio. Only works for block
  devices. Does not work for files. Adds a new blocking ioctl() for
  XCOPY from user space.
* Mikulas Patocka's approach: separate REQ_OP_COPY_WRITE and
  REQ_OP_COPY_READ operations. These are sent individually down stacked
  drivers and are paired by the driver at the bottom of the stack.

