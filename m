From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RFC 0/2] percpu_tags: Prototype implementation
Date: Mon, 11 Aug 2014 16:17:45 -0400
Message-ID: <20140811201744.GD8397@lenovo-rd230-04.lab.bos.redhat.com>
References: <cover.1405678629.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1405678629.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Kent Overstreet <kmo@daterainc.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 18, 2014 at 12:20:56PM +0200, Alexander Gordeev wrote:
> The performance test is not decent, though. I used "fio" random
> read against a "null_blk" device sitting on top of "percpu_tags",
> which is not exactly how "percpu_ida" is used. This is another
> reason I am posting - an advice on how to properly test is very
> appreciated.

Hi Nicholas et al,

I expect the best possible performance test for percpu_ida/percpu_tags
would be to stress drivers/vhost/scsi.c vhost_scsi_get_tag() function.

I tried to make such test by attaching ramdisk to a virtual machine
(similar to https://lkml.org/lkml/2012/8/10/347) but ultimately failed
to configure the necessary environment - the stock qemu does not have
-vhost-scsi parameter.

Could you please advice how to make this configuration exposed to guests?

o- / ..................................................................... [...]
  o- backstores .......................................................... [...]
  | o- block .............................................. [Storage Objects: 0]
  | o- fileio ............................................. [Storage Objects: 0]
  | o- pscsi .............................................. [Storage Objects: 0]
  | o- ramdisk ............................................ [Storage Objects: 1]
  |   o- rda .............................................. [(1.0GiB) activated]
  o- iscsi ........................................................ [Targets: 0]
  o- loopback ..................................................... [Targets: 0]
  o- vhost ........................................................ [Targets: 1]
    o- naa.5001405b171ee405 .......................................... [TPGs: 1]
      o- tpg1 .............................. [naa.5001405983a5b1a4, no-gen-acls]
        o- acls ...................................................... [ACLs: 0]
        o- luns ...................................................... [LUNs: 1]
          o- lun0 ................................................ [ramdisk/rda]

Thanks!
