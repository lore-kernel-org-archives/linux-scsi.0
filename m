From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH
	interpretation
Date: Wed, 9 Dec 2009 12:04:13 -0700
Message-ID: <20091209190413.GB7246@parisc-linux.org>
References: <200912091952.19978.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58153 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZLITEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2009 14:04:07 -0500
Content-Disposition: inline
In-Reply-To: <200912091952.19978.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Wed, Dec 09, 2009 at 07:52:19PM +0100, Bart Van Assche wrote:
> Fix a bug in the interpretation of the ADDITIONAL CDB LENGTH (add_cdb_len)
> field of SRP_CMD requests. According to the SRP specification, the layout
> of this single-byte field is as follows:
> * Bits 0 and 1 are reserved.
> * Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolically
>   represented as n.
> * Still according to the SRP specification, the ADDITIONAL CDB section
>   takes 4*n bytes.

Your interpretation of the SRP spec does seem to be correct, and I can
totally see how the original author of this code got it wrong.

> -	offset = cmd->add_cdb_len * 4;
> +	offset = (cmd->add_cdb_len >> 2) * 4;

Would this not be better written as:

	offset = cmd->add_cdb_len & ~3;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
