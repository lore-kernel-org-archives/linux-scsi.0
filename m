From: Luben Tuikov <luben@splentec.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 14:49:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D90B3A4.5005A87F@splentec.com>
References: <200209241346.g8ODkER09516@localhost.localdomain> <3D90A79F.47A37BC2@splentec.com> <20020924183907.GA1330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Russell King <rmk@arm.linux.org.uk>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> 
> Luben Tuikov [luben@splentec.com] wrote:
> > Add a flag, say unsigned I:1; to scsi_cmnd, which if set to 1, will
> > make add it to the head of the queue, irrespective of its serial
> > number, else the command is added according to its serial number
> > in the pending commands queue.
> 
> The code path currently being discussed is a request path and we do not

Sorry Mike,

I didn't really bother to look this up -- I just wanted to
send along an idea -- whether it be a request or cmnd,
the important thing is that you get the idea.

> have a scsi_cmnd until it is processed by the scsi_request_fn. There is
> already an interface to insert the request at the head of the queue
> scsi_insert_special_req, but we always set it to 0. We also do not

Should be a flag. ``Make'' it private to SCSI core, e.g.
by setting it to 0 when entering from ULP, etc.

Thus, the queue insertion code would be quite generic; also
using list_head as Doug has suggested, would do wonders (again
I'm _not_ looking this up).

> expose this interface high enough to let requests set this. We do
> expose it through the older scsi_insert_special_cmd interface used by
> scsi_mlqueue_insert.

-- 
Luben
