From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd
 numbered atomic_t counter
Date: Thu, 11 Nov 2010 14:36:50 -0800
Message-ID: <20101111223650.GA10257@linux.vnet.ibm.com>
References: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
 <1289490783.2982.33.camel@mulgrave.site>
 <1289511475.2867.138.camel@haakon2.linux-iscsi.org>
 <1289512549.2982.44.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1289512549.2982.44.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> wrote:
> On Thu, 2010-11-11 at 13:37 -0800, Nicholas A. Bellinger wrote:
> >
> >  ..snip..
> >
> > Sounds good to me, but you will recall the last attempt to make
> > scsi_cmd_get_serial() optional for the special case LLDs, that we
> > started running quickly in the legacy usage of cmd->serial_number in
> > scsi_softirq_done() and the side effects in scsi_try_to_abort_cmd(), who
> > use is complex enough that we have not found a proper resolution
> > sufficent to andmike discussed here:
> 
> Yes, that's what I meant by "eliminate the overloading of the serial
> number zero value" above.  This needs fixing before the serial number
> can be dumped for fast hba drivers.
> 

In the last email referenced below I believed that since
scsi_softirq_done is calling scsi_eh_scmd_add without the
SCSI_EH_CANCEL_CMD flag set this will stop scsi_try_to_abort_cmd from
being called. Since scsi_softirq_done is the one setting serial_number
to 0 I do not believe we can hit the serial number == 0 check in
scsi_try_to_abort_cmd anymore.

> > http://marc.info/?l=linux-scsi&m=128820726325009&w=2

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
