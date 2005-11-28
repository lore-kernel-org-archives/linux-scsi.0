From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/11]  lpfc 8.1.1 : Add support for more members of the Light Pulse 11xxx (4Gb) family
Date: Mon, 28 Nov 2005 10:49:36 -0700
Message-ID: <20051128174936.GD13338@parisc-linux.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B73@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:20141 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751271AbVK1Rtl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 12:49:41 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B73@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 12:08:46PM -0500, James.Smart@Emulex.Com wrote:
> Please note: there will be 2 other areas where we will still be accessing
> config space:
>   - We need the bar value, as the hardware sees it, to program a base
>     address it can decode to keep ring accesses on-chip. The current pci
>     infrastructure doesn't provide this. (we've talked about this on this
>     reflector before).

sym2 has the same need for pretty much the same reason.  It has a
private function called pci_get_base_address() right now.  I believe the
correct thing to do (but haven't got round to trying it yet) is to call
pcibios_resource_to_bus().

>   - If we reset the card, there were hardware-isms that may erroneously
>     drive perr/serr. So, we need to temporarily turn them off while we
>     reset. (I believe we went through this as well on this list early on).

That's certainly a reasonable need.
