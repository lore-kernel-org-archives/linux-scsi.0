From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 09:49:48 +0200
Message-ID: <5384439C.1040604@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>	 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:38314 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaE0Htu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 03:49:50 -0400
In-Reply-To: <1401118025.3303.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On 05/26/14 17:27, James Bottomley wrote:
> On Mon, 2014-05-26 at 17:15 +0200, Bart Van Assche wrote:
>> Make it possible to test the REQ_ATOM_COMPLETE bit from outside the
>> block layer core.
> 
> I don't see the value of patches 2,3 they're checking for an impossible
> condition ... why might it be possible?

When reading the source code in scsi_error.c it's easy to overlook that
scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
set. Although it is possible to mention this as a comment above these
functions, such comments are not checked at runtime. It would require
additional work from the reader to verify whether or not such source
code comments are up to date. However, the condition inside a
WARN_ON_ONCE() statement is checked every time the code is executed.
Hence my preference for a WARN_ON_ONCE() statement instead of writing
down somewhere that these three functions operate on requests in which
the REQ_ATOM_COMPLETE bit has been set.

Bart.

