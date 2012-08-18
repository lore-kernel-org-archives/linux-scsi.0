From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Remove unused se_cmd.cmd_spdtl
Date: Sat, 18 Aug 2012 15:18:51 -0700
Message-ID: <1345328331.25161.355.camel@haakon2.linux-iscsi.org>
References: <1345091092-4539-1-git-send-email-roland@kernel.org>
	 <CAL1RGDVOdPCOv-frz6UkD9DKp_DW10MmWyWQA7CnyDeGqSQ6=Q@mail.gmail.com>
	 <1345155175.25161.85.camel@haakon2.linux-iscsi.org>
	 <CAG4TOxNfzdSKUcB0sEb_WnaBeOUOiSms0hkX3NiY6GShrvuXjA@mail.gmail.com>
	 <1345251732.25161.284.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUvs5iPhypq5aWuR15yrVvBuV-bbk1f_oWBfd=fiqsSQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDUvs5iPhypq5aWuR15yrVvBuV-bbk1f_oWBfd=fiqsSQw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2012-08-18 at 10:13 -0700, Roland Dreier wrote:
> On Fri, Aug 17, 2012 at 6:02 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > No, or at least that is not what happens anymore with current target
> > core + iscsi-target code..
> >
> > The se_cmd->data_length re-assignment here is what will be used by
> > iscsi-target fabric code for all iSCSI descriptor related allocations
> > +ransfer, instead of the original fabric 'expected transfer length' that
> > declares the size of the SCSI initiator's available buffer at the other
> > end.
> 
> Not sure I follow this.  Isn't cmd->data_length also what we use to
> allocate the buffer used to store the data we're going to transfer?
> 

se_cmd->data_length is initially set up by transport_init_se_cmd() based
upon the fabric provided expected transfer length.  It then gets
adjusted (before any allocations happen) based upon underflow..   So in
the overflow case w/ the proposed patch, we want to keep the original
se_cmd->data_length because it's smaller than the CDB provided
allocation length.

> I guess my example with READ(10) actually works, because
> iblock_execute_rw() just uses the buffer allocated, rather than
> paying attention to the sector count in the command.
> 

Correct, this is true for all SCF_SCSI_DATA_CDB with virtual backends,
they no longer look into the CDB.

> But what if an initiator sends, say, REPORT LUNS or PR OUT
> with an allocation length of 8192, but a transport-level length
> of only 4096?  If the REPORT LUNS or PR OUT response is
> bigger than 4096 bytes, we'll overflow the allocated buffer with
> your patch, right?
> 

With virtual backends + TCM control CDB emulation, the emulation code
should be using (the possibly adjusted) se_cmd->data_length as it's
upper limit for building a response payload, and not the possibly
overflowed allocation length it may extracted from the CDB.

So as long as the control CDB emulation code is doing the right thing
here by using se_cmd->data_length, we should be OK for the virtual
backend cases.  (Need to audit this)

Now for pSCSI that may not be the case because we do expect underlying
layers to look into the CDB at some point, but currently we are passing
in SGLs based from the adjusted se_cmd->data_length, so this might end
up causing a problem in SCSI..  (Need to test this)

Otherwise, I'm tempted to just reject all CDB overflow cases for pSCSI
backends, as every host SCSI stack I've seen in practice only ends up
generating underflow cases for control CDBs anyways..

--nab
