From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 22:35:08 +0000
Message-ID: <20041123223508.GA1819@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B694F1B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:31696 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261561AbUKWWfV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:35:21 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694F1B@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Ryan Anderson <ryan@autoweb.net>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Tue, Nov 23, 2004 at 05:07:51PM -0500, Salyzyn, Mark wrote:
> Do you have the latest Firmware from Dell? Do you have the Read and
> Write Cache disabled as Dell has recommended (for pre 6091(?) Firmware)?
> 
> The `container going offline' is a result of the Firmware in the card
> not responding to a SCSI command within 60 seconds (the Linux SCSI layer
> timeout). In the older firmware this would occur at the combination of
> high load, drive or scsi bus problems and the card flushing the cache.
> If the problem persists, preventing the card building up a large amount
> of cache data may be the only way to mitigate this.
> 
> I have had others experiment with overriding the SCSI timeout (the
> Adaptec driver branch has an AAC_EXTENDED_TIMEOUT) to limited success.
> Turning off the SCSI timeout (add a scsi_del_timer as command is issued
> to the controller, and a scsi_add_timer in the interrupt service routine
> before completion) worked extremely well, but this makes me
> understandably nervous.

You can do this without these horrible timer hacks by setting sdev->timeout
to a bigger value in your ->slave_configure method.

