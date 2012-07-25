From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
 VHOST_SCSI_GET_ABI_VERSION
Date: Wed, 25 Jul 2012 14:10:48 -0700
Message-ID: <1343250648.1813.169.camel@haakon2.linux-iscsi.org>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	 <20120724015634.GD4093@kroah.com>
	 <1343162724.1813.111.camel@haakon2.linux-iscsi.org>
	 <500FF05B.8060602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46909 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2GYVKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 17:10:52 -0400
In-Reply-To: <500FF05B.8060602@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

On Wed, 2012-07-25 at 16:10 +0300, Avi Kivity wrote:
> On 07/24/2012 11:45 PM, Nicholas A. Bellinger wrote:
> 
> >> > diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
> >> > index e942df9..3d5378f 100644
> >> > --- a/drivers/vhost/tcm_vhost.h
> >> > +++ b/drivers/vhost/tcm_vhost.h
> >> > @@ -80,7 +80,17 @@ struct tcm_vhost_tport {
> >> >  
> >> >  #include <linux/vhost.h>
> >> >  
> >> > +/*
> >> > + * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
> >> > + *
> >> > + * ABI Rev 0: All pre 2012 revisions used by prototype out-of-tree code
> >> > + * ABI Rev 1: 2012 version for v3.6 kernel merge candiate
> >> > + */
> 
> 
> If it's out of tree, why consider it at all?  Put a stable ABI in tree
> and extend it in compatible ways.
> 
> 

This comment was supposed to convey that ABI=0 vhost-scsi userspace code
is not supported with tcm_vhost mainline code.

But obviously that was not clear enough here.  Updating the comment to
reflect to make this clear.

So the main question here was if it's fine to start with ABI=1, and
require >= ABI=1 for all vhost-scsi userspace code to function with
tcm_vhost.

The idea was to avoid confusion for the ABI=0 vhost-scsi code that's
been floating around for the last 2 years.

--nab







