From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Wed, 26 Jul 2017 09:22:25 +0200
Message-ID: <20170726072225.GB4039@linux-x5ow.site>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
 <20170719070335.GC4151@linux-x5ow.site>
 <ufazic0974h.fsf@epithumia.math.uh.edu>
 <20170719083654.GE4151@linux-x5ow.site>
 <5520d33f-06a0-f880-94f9-c014c11c1bc5@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5520d33f-06a0-f880-94f9-c014c11c1bc5@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jason L Tibbitts III <tibbs@math.uh.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2017 at 03:09:00PM -0400, Douglas Gilbert wrote:
> _TO_ is toward the device (i.e. WRITE) and what T10 call "data-out".
> _FROM_ is from the device (e.g. INQUIRY) and what T10 call "data-in".
> 
> _TO_FROM_ is basically _FROM_ (and has nothing to do with bidi).
> _TO_FROM_ is very old and is meant to try and detect "short reads"
> by prefilling the indirect buffer (by reading from dxferp) before
> it is overwritten by the _FROM_ (and then writing to dxferp). It
> is from the time when not all LLDs or HBAs provided an indication
> of a "short read". Today users have the 'sg_io_hdr_t::resid' for
> that purpose. Whether the sg driver in lk 4.12 still does that
> I haven't checked.
> 
> The only limit that should be placed on dxfer_len is something like
> <= 2**28 (256M) in my opinion. Big enough that the kernel would
> reject it and small enough to catch negative values placed in an
> unsigned.

OK. I'll give it a shot, thanks.

> 
> 
> The overall problem is that sg_is_valid_dxfer() introduced in lk 4.12
> is doing more sanity checks than were done before. My policy was
> to ignore ("don't care") combinations of dxfer_direction, dxferp and
> dxfer_len that were harmless. Anyway those three variables are
> incomplete since the SCSI command and the device also dictate the
> length of the data-in transfer.

The problem with these don't care combinations was, that user-space could then
easily crash the kernel. This is the reason I introduced sg_is_valid_dxfer().
It's sole purpuse was to avoid more CVEs, but unfortunately it turned into
quite some regressions.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
