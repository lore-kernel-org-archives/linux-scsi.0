From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Tue, 26 Aug 2003 17:49:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030826174944.A29235@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568D0@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:28935 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262802AbTHZQtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 12:49:47 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568D0@OTCEXC01>; from mark_salyzyn@adaptec.com on Mon, Aug 25, 2003 at 04:50:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

On Mon, Aug 25, 2003 at 04:50:31PM -0400, Salyzyn, Mark wrote:
> Hope this following helps the Yikes a bit (!)
> 
> Container deletions have a Container Delete AIF, and a container change AIF.
> The array goes offline and is no longer accessible. We could monitor the
> Container Delete AIF event to trigger a scsi_remove_device for this.

Yup.

> The
> container change AIF could be used to call *something* with a null effect.

Now that we have the Container Delete AIF we can always handle a
container change AIF as 'lookup the struct scsi_device and try
scsi_rescan_device' - it we removed the device in the Container Delete AIF
just before the lookup won't find it.

> Creating an array has a Container Add AIF and a container change AIF. This
> is a totally new array. We could monitor the Container Add AIF event to
> trigger a scsi_add_device for this.

Yupp.

> The container change AIF could be used
> to call *something* with a null effect.

Again we'd do the lookup & scsi_rescan_device - it would succeed but not
change anything as we just did the scanning.

> Now I get `sticky' ...
> 
> Upon completion of a zero, we get just a container change AIF.

Also fine, the scsi_rescan_device shouldn be the right thing in this
case, too.

> But the array
> had gone offline when the Zero started, no events, except periodic generic
> percentage progress report AIFs, any I/O to the ID could return offline
> errors while clearing.

Okay, that's bad.

> We want the container change AIF to get the SCSI
> subsystem to re-activate this array. The ID did not really go away, it is
> just write protected while zeroing. We may be able to report the I/O error
> differently so that the SCSI subsystem does not take it permanently offline,
> just temporarily inactive? If we altered the error report so that the device
> information remained, could a triggered scsi_rescan_device be used to import
> the zero'd partition table and have the side effect of bringing the device
> active again? Would this have the null effect desired above?

We don't remove the device either on I/O errors, just the online flag
is cleared.  scsi_rescan_device will not set it online again, but you
can do it manually before calling it.

