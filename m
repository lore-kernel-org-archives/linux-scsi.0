From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 17:43:28 +1000
Message-ID: <421ED720.6090308@torque.net>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:42204 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262642AbVBYHml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 02:42:41 -0500
In-Reply-To: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> Don't use cmd->request->nr_hw_segments as it may not be initialized
> (SG_IO in particular bypasses anything that initializes this and just
> uses scsi_do_req to insert a scsi_request directly on the head of the
> queue) and a bogus value here can trip up the checks to make sure that
> the number of segments will fit in the queue ring buffer, resulting in
> commands that are never completed.

Doug,
Which SG_IO code path (via the block layer or the sg driver)
does this happen on?
Looking at the sg driver code, it calls scsi_allocate_request()
prior to calling scsi_do_req(). scsi_allocate _request()
allocates a block of memory starting with a scsi_request
instance followed by a struct request instance; then zeroes the
whole block, etc. nr_hw_segments is a member of struct request.
I would expect that is the same struct request instance that
the LLD ends up seeing. Zero may not be an ideal value but
at least it is not random.

It is not as clear to me what is happening in this regard
when the SG_IO ioctl is used in the block layer. If the
problem is in that path then perhaps a "rq->nr_hw_segment = 0;"
could be placed in block/scsi_ioctl.c::sg_io() to make it
consistent (i.e. zero) with the sg driver path.

If zero in request::nr_hw_segment is invalid, the perhaps
scsi_do_req() could adjust it to something sensible
(sg_tablesize ??).

Doug Gilbert
