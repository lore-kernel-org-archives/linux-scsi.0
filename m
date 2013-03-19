From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V5 1/5] virtio-scsi: redo allocation of target data
Date: Tue, 19 Mar 2013 12:00:27 +0000
Message-ID: <1363694427.2377.57.camel@dabdike.int.hansenpartnership.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
	  <1363687057-13580-2-git-send-email-gaowanlong@cn.fujitsu.com>
	 <1363692727.2377.53.camel@dabdike.int.hansenpartnership.com>
	 <51484FC2.6030601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51484FC2.6030601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-03-19 at 12:45 +0100, Paolo Bonzini wrote:
> Il 19/03/2013 12:32, James Bottomley ha scritto:
> > On Tue, 2013-03-19 at 17:57 +0800, Wanlong Gao wrote:
> >> From: Paolo Bonzini <pbonzini@redhat.com>
> >>
> >> virtio_scsi_target_state is now empty.  We will find new uses for it in
> >> the next few patches, so this patch does not drop it completely.
> >> However, having dropped the sglist flexible array member, we can turn
> >> the tgt array-of-pointers into a simple array.  This simplifies the
> >> allocation.
> >>
> >> Even simpler would be to place the virtio_scsi_target_state structs in a
> >> flexible array member at the end of struct virtio_scsi.  But we do not
> >> do that, because we will place the virtqueues there in the next patches.
> > 
> > I'm really sorry, but I must have been asleep at the wheel when I let
> > code like this go in.  No modern driver should have fixed arrays for
> > target information.  The way this is supposed to work is that you have
> > entries in the host template for target_alloc and target_destroy.  You
> > hook into these and attach your struct virtio_scsi_target_state to
> > scsi_target->hostdata,
> 
> So that would be sc->device->sdev_target->hostdata.

No, unfortunate name, but it's used for something else (actually, I
think it *was* used by something else and is unused now).  The construct
is

scsi_target(sc->device)->hostdata

James
