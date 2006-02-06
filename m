From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] FC transport & lpfc : Avoid device offline cases by stalling aborts until device unblocked
Date: Mon, 6 Feb 2006 16:33:36 +0000
Message-ID: <20060206163336.GA23967@infradead.org>
References: <43E77970.1030500@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44689 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932199AbWBFQdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 11:33:42 -0500
Content-Disposition: inline
In-Reply-To: <43E77970.1030500@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Feb 06, 2006 at 11:29:36AM -0500, James Smart wrote:
>   Also, as Christoph just recently removed the eh_timed_out use in the
>   megaraid driver - he eliminated the only other (in-kernel) user of this
>   interface. Perhaps we should consider changing the design and realign
>   the EH_RESET_TIMER functionality to what EH_TRANSPORT_BLOCKED does.
>   Thoughts ?

I'd rather kill it completely and make eh_times out a transport callout,
instead of the host template.  Right now every FC driver would need an
update to call your routine, and this should really be handled transparently
by the transport class.

