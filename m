From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] target: Remove unused se_cmd.cmd_spdtl
Date: Sat, 18 Aug 2012 10:13:54 -0700
Message-ID: <CAL1RGDUvs5iPhypq5aWuR15yrVvBuV-bbk1f_oWBfd=fiqsSQw@mail.gmail.com>
References: <1345091092-4539-1-git-send-email-roland@kernel.org>
 <CAL1RGDVOdPCOv-frz6UkD9DKp_DW10MmWyWQA7CnyDeGqSQ6=Q@mail.gmail.com>
 <1345155175.25161.85.camel@haakon2.linux-iscsi.org> <CAG4TOxNfzdSKUcB0sEb_WnaBeOUOiSms0hkX3NiY6GShrvuXjA@mail.gmail.com>
 <1345251732.25161.284.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1345251732.25161.284.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 17, 2012 at 6:02 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> No, or at least that is not what happens anymore with current target
> core + iscsi-target code..
>
> The se_cmd->data_length re-assignment here is what will be used by
> iscsi-target fabric code for all iSCSI descriptor related allocations
> +ransfer, instead of the original fabric 'expected transfer length' that
> declares the size of the SCSI initiator's available buffer at the other
> end.

Not sure I follow this.  Isn't cmd->data_length also what we use to
allocate the buffer used to store the data we're going to transfer?

I guess my example with READ(10) actually works, because
iblock_execute_rw() just uses the buffer allocated, rather than
paying attention to the sector count in the command.

But what if an initiator sends, say, REPORT LUNS or PR OUT
with an allocation length of 8192, but a transport-level length
of only 4096?  If the REPORT LUNS or PR OUT response is
bigger than 4096 bytes, we'll overflow the allocated buffer with
your patch, right?

 - R.
