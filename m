From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Increased memory usage with scsi-mq
Date: Fri, 4 Aug 2017 22:00:47 +0100
Message-ID: <20170804210035.GA10017@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=1478201

We have a libguestfs test which adds 256 virtio-scsi disks to a qemu
virtual machine.  The VM has 500 MB of RAM, 1 vCPU and no swap.

This test has been failing for a little while.  It runs out of memory
during SCSI enumeration in early boot.

Tonight I bisected the cause to:

  5c279bd9e40624f4ab6e688671026d6005b066fa is the first bad commit
  commit 5c279bd9e40624f4ab6e688671026d6005b066fa
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Fri Jun 16 10:27:55 2017 +0200

    scsi: default to scsi-mq
    
    Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq I/O
    path now that we had plenty of testing, and have I/O schedulers for
    blk-mq.  The module option to disable the blk-mq path is kept around for
    now.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

  :040000 040000 57ec7d5d2ba76592a695f533a69f747700c31966
  c79f6ecb070acc4fadf6fc05ca9ba32bc9c0c665 M	drivers

I also wrote a small test to see the maximum number of virtio-scsi
disks I could add to the above VM.  The results were very surprising
(to me anyhow):

  With scsi-mq enabled:   175 disks
  With scsi-mq disabled: 1755 disks

I don't know why the ratio is almost exactly 10 times.

I read your slides about scsi-mq and it seems like a significant
benefit to large machines, but could the out of the box defaults be
made more friendly for small memory machines?

Thanks,

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
