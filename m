From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC 3/Di Container goes offline
Date: Wed, 24 Nov 2004 07:59:04 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694FA8@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:35743 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262861AbUKXVag convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 16:30:36 -0500
Received: from magic.adaptec.com (magic.adaptec.com [216.52.22.17])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAOLScH6014608
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 13:28:46 -0800
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ryan Anderson <ryan@autoweb.net>, linux-scsi@vger.kernel.org

I dropped Andrew Morton from the direct mail recipients.

Thanks, made the change in my branch of the code. This adjustment will
probably never be submitted to MarkH since I use it only for debugging
purposes. However, would it be nice if the global scsi timeout could be
`user' adjustable?

Not that I advocate it as readily accessible, since any storage device
that takes longer than ten seconds is in `trouble', and any timeout
longer than two minutes will no doubt cause servers to go offline on the
internet. Its purpose is only for troubleshooting.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, November 23, 2004 5:35 PM
To: Salyzyn, Mark
Cc: Ryan Anderson; Andrew Morton; linux-scsi@vger.kernel.org
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600
aacraidPERC 3/Di Container goes offline

On Tue, Nov 23, 2004 at 05:07:51PM -0500, Salyzyn, Mark wrote:
> Do you have the latest Firmware from Dell? Do you have the Read and
> Write Cache disabled as Dell has recommended (for pre 6091(?)
Firmware)?
> 
> The `container going offline' is a result of the Firmware in the card
> not responding to a SCSI command within 60 seconds (the Linux SCSI
layer
> timeout). In the older firmware this would occur at the combination of
> high load, drive or scsi bus problems and the card flushing the cache.
> If the problem persists, preventing the card building up a large
amount
> of cache data may be the only way to mitigate this.
> 
> I have had others experiment with overriding the SCSI timeout (the
> Adaptec driver branch has an AAC_EXTENDED_TIMEOUT) to limited success.
> Turning off the SCSI timeout (add a scsi_del_timer as command is
issued
> to the controller, and a scsi_add_timer in the interrupt service
routine
> before completion) worked extremely well, but this makes me
> understandably nervous.

You can do this without these horrible timer hacks by setting
sdev->timeout
to a bigger value in your ->slave_configure method.

