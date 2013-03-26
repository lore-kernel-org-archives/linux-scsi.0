From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 26 Mar 2013 14:00:01 -0400
Message-ID: <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:10941
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab3CZSAK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Mar 2013 14:00:10 -0400
In-Reply-To: <1361261883-41467-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>



On Tue, 19 Feb 2013, Hannes Reinecke wrote:

> This patchset updates the SCSI midlayer to use 64-bit LUNs internally.
> It eliminates the need to limit the number of LUNs artificially to
> avoid aliasing issues; the SCSI midlayer can now accept any LUN presented
> to it.
>
> The LLDD specific settings for 'max_lun' have been left untouched;
> it should be raised to '~0' if the HBA supports 64-bit LUNs internally.
> However, it is up to the driver maintainer to raise that limit.
>
> Hannes Reinecke (4):
>  scsi_scan: Fixup scsilun_to_int()
>  scsi: use 64-bit LUNs
>  scsi: use 64-bit value for 'max_luns'
>  scsi: Remove CONFIG_SCSI_MULTI_LUN
>

Hannes,

As we've reviewed these patches internally, the one question that keeps
coming up is how do we handle hardware that cannot handle a 64-bit LUN
address? For example, some of our older 2G/bps hardware can only handle a
16-bit LUN address.  Currently we convert the u32 value to u16.  Do we do
the same for the 64-bit conversion? Can a way be devised to "opt-out" of
receiving a 64-bit address in the first place (IIRC this was an option in
the v1 patch set)?

Thanks,
Chad

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

