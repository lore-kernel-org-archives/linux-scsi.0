From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Mon, 13 Oct 2014 11:15:19 +0200
Message-ID: <543B9827.2060305@acm.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net> <20141011161110.GA16812@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:51113 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJMJP0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2014 05:15:26 -0400
In-Reply-To: <20141011161110.GA16812@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On 10/11/14 18:11, Christoph Hellwig wrote:
> Hi Robert,
>
> can you take a look at the patches at:
>
> http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/scsi-ioctl
>
> and confirm if they fix your issue?

Hello Christoph,

At least to me patches 1/4..3/4 look like nice cleanup patches. 
Regarding patch 4/4: I'm not sure yet what's the best way for addressing 
potentially concurrent SG_SCSI_RESET ioctl calls. As far as I know many 
SCSI LLDs have been implemented assuming that eh_*_reset_handler() calls 
are serialized per SCSI host. Does this mean that a mutex has to be 
added to avoid that an eh_*_reset_handler() call can be triggered via an 
ioctl while at the same time the SCSI error handler thread is invoking 
one of the eh_*_reset_handler() callback functions due to SCSI error 
handling ?

For a prior discussion of this topic, see also 
http://thread.gmane.org/gmane.linux.scsi/82582/focus=82747.

Bart.

