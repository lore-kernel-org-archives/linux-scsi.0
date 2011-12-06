From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
Date: Tue, 06 Dec 2011 12:09:59 -0600
Message-ID: <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>
	 <1323106159-6562-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54827 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995Ab1LFSKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 13:10:01 -0500
In-Reply-To: <1323106159-6562-2-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

On Mon, 2011-12-05 at 18:29 +0100, Paolo Bonzini wrote:
> The virtio-scsi HBA is the basis of an alternative storage stack
> for QEMU-based virtual machines (including KVM).

Could you clarify what the problem with virtio-blk is?

>   Compared to
> virtio-blk it is more scalable, because it supports many LUNs
> on a single PCI slot),

This is just multiplexing, surely, which should be easily fixable in
virtio-blk?

>  more powerful (it more easily supports
> passthrough of host devices to the guest)

I assume this means exclusive passthrough?  In which case, why doesn't
passing the host block queue through to the guest just work?  That means
the host is doing all the SCSI back end stuff and you've just got a
lightweight queue pass through.

>  and more easily
> extensible (new SCSI features implemented by QEMU should not
> require updating the driver in the guest).

I don't really understand this comment at all:  The block protocol is
far simpler than SCSI, but includes SG_IO, which can encapsulate all of
the SCSI features ... I'm not familiar necessarily with the problems of
QEMU devices, but surely it can unwrap the SG_IO transport generically
rather than having to emulate on a per feature basis?

James


