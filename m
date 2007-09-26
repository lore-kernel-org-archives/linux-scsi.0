From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Wed, 26 Sep 2007 09:02:16 -0600
Message-ID: <20070926150216.GH3899@parisc-linux.org>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53740 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXIZPCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 11:02:17 -0400
Content-Disposition: inline
In-Reply-To: <20070420204720.GM31947@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Fri, Apr 20, 2007 at 03:47:20PM -0500, Linas Vepstas wrote:
> Implement the so-called "first failure data capture" (FFDC) for the
> symbios PCI error recovery.  After a PCI error event is reported,
> the driver requests that MMIO be enabled. Once enabled, it 
> then reads and dumps assorted status registers, and concludes
> by requesting the usual reset sequence.

> +	/* Request that MMIO be enabled, so register dump can be taken. */
> +	return PCI_ERS_RESULT_CAN_RECOVER;
> +}

I'm a little concerned by the mention of MMIO.  It's entirely possible
for the sym2 driver to be using ioports to access the card rather than
MMIO.  Is it simply that it can't on the platform you test on?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
