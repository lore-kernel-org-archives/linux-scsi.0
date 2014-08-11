From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RFC 0/2] percpu_tags: Prototype implementation
Date: Mon, 11 Aug 2014 13:52:21 -0700
Message-ID: <1407790341.334.2.camel@haakon3.risingtidesystems.com>
References: <cover.1405678629.git.agordeev@redhat.com>
	 <20140811201744.GD8397@lenovo-rd230-04.lab.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140811201744.GD8397@lenovo-rd230-04.lab.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Nicholas Bellinger <nab@daterainc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Kent Overstreet <kmo@daterainc.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

(Responding again without gmail, as the last email hit a failure when
responding to the lists..)

On Mon, 2014-08-11 at 16:17 -0400, Alexander Gordeev wrote:
> On Fri, Jul 18, 2014 at 12:20:56PM +0200, Alexander Gordeev wrote:
> > The performance test is not decent, though. I used "fio" random
> > read against a "null_blk" device sitting on top of "percpu_tags",
> > which is not exactly how "percpu_ida" is used. This is another
> > reason I am posting - an advice on how to properly test is very
> > appreciated.
> 
> Hi Nicholas et al,
> 
> I expect the best possible performance test for percpu_ida/percpu_tags
> would be to stress drivers/vhost/scsi.c vhost_scsi_get_tag() function.
> 
> I tried to make such test by attaching ramdisk to a virtual machine
> (similar to https://lkml.org/lkml/2012/8/10/347) but ultimately failed
> to configure the necessary environment - the stock qemu does not have
> -vhost-scsi parameter.
> 
> Could you please advice how to make this configuration exposed to guests?
> 
> o- / ..................................................................... [...]
>   o- backstores .......................................................... [...]
>   | o- block .............................................. [Storage Objects: 0]
>   | o- fileio ............................................. [Storage Objects: 0]
>   | o- pscsi .............................................. [Storage Objects: 0]
>   | o- ramdisk ............................................ [Storage Objects: 1]
>   |   o- rda .............................................. [(1.0GiB) activated]
>   o- iscsi ........................................................ [Targets: 0]
>   o- loopback ..................................................... [Targets: 0]
>   o- vhost ........................................................ [Targets: 1]
>     o- naa.5001405b171ee405 .......................................... [TPGs: 1]
>       o- tpg1 .............................. [naa.5001405983a5b1a4, no-gen-acls]
>         o- acls ...................................................... [ACLs: 0]
>         o- luns ...................................................... [LUNs: 1]
>           o- lun0 ................................................ [ramdisk/rda]
> 

So qemu expects '-device vhost-scsi-pci' with the following syntax:

   -device vhost-scsi-pci,wwpn=naa.5001405b171ee405,num_queues=1,cmd_per_lun=64

For best results I'd recommend setting the IRQ affinity for each of the
virtio*_request MSI-X vectors to a dedicated vCPU in KVM guest.

Also, I've been using the scsi-mq prototype for small block I/O
performance testing in order to push vhost-scsi and avoid the legacy
scsi_request_fn() bottleneck(s) with virtio-scsi, and now that hch's
scsi-mq work (CC'ed) has been merged upstream in v3.17-rc0, it would be
a good time for a scsi-mq + virtio-scsi + vhost-scsi performance
checkpoint.  ;)

--nab
