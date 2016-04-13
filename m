From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v2 01/16] iscsi-target: add callback to alloc and free PDU
Date: Wed, 13 Apr 2016 21:51:30 +0530
Message-ID: <20160413162129.GA1680@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
 <674e8ae2dae3d6274dcb1abe6ddef253f6a71256.1460204441.git.varun@chelsio.com>
 <570A8E81.8010007@grimberg.me>
 <20160411145446.GA1987@chelsio.com>
 <570E17C9.3010204@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570E17C9.3010204@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 13, 2016 at 12:56:25PM +0300, Sagi Grimberg wrote:
> 
> >>On 09/04/16 16:11, Varun Prakash wrote:
> >>>Add two callbacks to struct iscsit_transport -
> >>>
> >>>1. void *(*iscsit_alloc_pdu)()
> >>>    iscsi-target uses this callback for
> >>>    iSCSI PDU allocation.
> >>>
> >>>2. void (*iscsit_free_pdu)
> >>>    iscsi-target uses this callback
> >>>    to free an iSCSI PDU which was
> >>>    allocated by iscsit_alloc_pdu().
> >>
> >>Can you please explain why are you adding two different
> >>callouts? Who (Chelsio T5) will need it, and why they can't
> >>use the in-cmd pdu?
> >
> >I am adding these to avoid per PDU 48 bytes(BHS) memcpy from cmd->pdu to
> >transport driver tx buffer, iscsi-target can directly form iscsi hdr
> >in transport driver tx buffer.
> 
> Is that what it's for? Looks meaningless to me, do
> you have an indication that this is some sort of bottleneck?
> 
> I see you memset in your pdu_alloc, where is the gain
> here anyway?

We can definitely avoid memcpy if iscsi-target fills all
the fields in iscsi hdr, in current code some fields
are assumed to be zero so a memset is required in transport
driver.
I will drop this patch in -v3, thanks. 
