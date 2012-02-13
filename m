From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Mon, 13 Feb 2012 08:05:59 +0100
Message-ID: <4F38B657.7060405@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au
List-Id: linux-scsi@vger.kernel.org

On 12/02/12 21:16, James Bottomley wrote:
> Well, no-one's yet answered the question I had about why.  

Just to give one example from a different angle:
In the big datacenters tape libraries are still very important, and lots
of them have a scsi attachement. virtio-blk certainly is not the right
way to handle those. Furthermore it seems even pretty hard to craft
a virtio-tape since most of those libraries have vendor specific library
controls (via sg). We would need to duplicate scsi generic (hint, hint :-)

> virtio-scsi seems to be a basic duplication of virtio-blk except that it seems to
> fix some problems virtio-blk has.  Namely queue parameter discover,
> which virtio-blk doesn't seem to do.  There may also be a reason to cut
> the stack lower down.  Error handling is most often cited for this, but
> no-one's satisfactorily explaned why it's better to do error handling in
> the guest instead of the host.
> 
> Could someone please explain to me why you can't simply fix virtio-blk?

I dont think that virtio-scsi will replace virtio-blk everywhere. For non-scsi
block devices, image files or logical volumes virtio-blk seems to be the right 
approach, I think.

> Or would virtio-blk maintainers give a reason why they're unwilling to
> have it fixed?

I dont consider virtio-blk broken. It just doesnt cover everything.

Christian
