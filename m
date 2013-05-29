From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Tue, 28 May 2013 23:12:28 -0700
Message-ID: <51A59C4C.1050005@vlnb.net>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>	<519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org>	<519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org>	<519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org>	<519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org>	<519CE9FE.2030007@redhat.com> <yq1vc6b561q.fsf@sermon.lab.mkp.net>	<51A035FA.6070409@vlnb.net> <yq17gii3l93.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq17gii3l93.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen, on 05/28/2013 01:25 PM wrote:
> Vladislav> Linux block layer is purely artificial creature slowly
> Vladislav> reinventing wheel creating more problems, than solving.
> 
> On the contrary. I do think we solve a whole bunch of problems.
> 
> 
> Vladislav> It enforces approach, where often "impossible" means
> Vladislav> "impossible in this interface".
> 
> I agree we have limitations. I do not agree that all limitations are
> bad. Sometimes it's OK to say no.
> 
> 
> Vladislav> For instance, how about copy offload?  How about atomic
> Vladislav> writes?
> 
> I'm actively working on copy offload. Nobody appears to be interested in
> atomic writes. Otherwise I'd work on those as well.
> 
> 
> Vladislav> Why was it needed to create special blk integrity interface
> Vladislav> with the only end user - SCSI?
> 
> Simple. Because we did not want to interleave data and PI 512+8+512+8
> neither in memory, nor at DMA time.

It can similarly be done in SCSI-like interface without need for any middleman.

> Furthermore, the ATA EPP proposal
> was still on the table so I also needed to support ATA.
> 
> And finally, NVM Express uses the blk_integrity interface as well.
> 
> 
> Vladislav> The block layer keeps repeating SCSI. So, maybe, after all,
> Vladislav> it's better to acknowledge that direct usage of SCSI without
> Vladislav> any intermediate layers and translations is more productive?
> Vladislav> And for those minors not using SCSI internally, translate
> Vladislav> from SCSI to their internal commands? Creating and filling
> Vladislav> CDB fields for most cases isn't anyhow harder, than creating
> Vladislav> and feeling bio fields.
> 
> This is quite possibly the worst idea I have heard all week.
> 
> As it stands it's a headache for the disk ULD driver to figure out which
> of the bazillion READ/WRITE variants to send to a SCSI/ATA device. What
> makes you think that an application or filesystem would be better
> equipped to make that call?
> 
> See also: WRITE SAME w/ zeroes vs. WRITE SAME w/ UNMAP vs. UNMAP 
> 
> See also: EXTENDED COPY vs. the PROXY command set
> 
> See also: USB-ATA bridge chips
> 
> You make it sound like all the block layer does is filling out
> CDBs. Which it doesn't in fact have anything to do with at all.
> 
> When you are talking about CDBs we're down in the SBC/SSC territory.
> Which is such a tiny bit of what's going on. We have transports, we have
> SAM, we have HBA controller DMA constraints, system DMA constraints,
> buffer bouncing, etc. There's a ton of stuff that needs to happen before
> the CDB and the data physically reach the storage.
> 
> You seem to be advocating that everything up to the point where the
> device receives the command is in the way. Well, by all means. Why limit
> ourselves to the confines of SCSI? Why not get rid of POSIX
> read()/write(), page cache, filesystems and let applications speak
> ST-506 directly?
> 
> I know we're doing different things. My job is to make a general purpose
> operating system with interfaces that make sense to normal applications.
> That does not preclude special cases where it may make sense to poke at
> the device directly. For testing purposes, for instance. But I consider
> it a failure when we start having applications that know about hardware
> intricacies, cylinders/heads/sectors, etc. That road leads straight to
> the 1980s...

What you mean is true, but my point is that this abstraction is better to be done in
SCSI, i.e. SAM, manner. Now need to write fields inside of CDBs, it would be pretty
inconvenient ;). But CDBs fields can be fields in some scsi_io structure. Exact opcodes
can be easily abstracted to be filled on the last stage, where end CDB is constructed
from those fields.

Problem with block abstraction is that it is the least common denominator of all block
devices capabilities, hence advanced capabilities, available only some class of
devices, are automatically become "impossible". Hence, it would be more productive
instead to use the most capable abstraction, which is SAM. In this abstraction there's
no need to reinvent complex interfaces and write complex middleman code for every
advanced capability. All advanced capabilities there are available by definition, if
supported by underlying hardware. That's my point.

POSIX is for simple applications, for which read()/write() calls are sufficient. They
are outside of our discussions. But advanced applications need more. I know plenty of
applications issuing direct SCSI commands, but how many can you name applications using
block interface (bsg)? I can recall only one quite relatively used Linux specific
library. That's all. This interface is not demanded by applications.

Vlad
