From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Tue, 9 Nov 2004 14:20:04 +0000
Message-ID: <20041109142004.GA5565@infradead.org>
References: <91888D455306F94EBD4D168954A9457C2D1EB5@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:19211 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261523AbUKIOUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Nov 2004 09:20:09 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C2D1EB5@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, "Stephens, Larry" <larry.stephens@lsil.com>

On Mon, Nov 08, 2004 at 04:35:06PM -0700, Moore, Eric Dean wrote:
> 
> On Saturday, November 06, 2004 4:03 PM, Christoph Hellwig wrote:
> > 
> >  - ioc->sasDeviceList still exists although it's not actually 
> > traversed,
> >    and quite a lot od dead code to fill it
> 
> Yes this is being used, and its not dead code.  Its filled and deleted
> in mptscsih.c when devices are added and removed.  It appears now
> that you had me removed the CSMI IOCTLs last week, this code will be
> needed in other aspects such as sas transport layer, misc future features, 
> and debugging.

Aka it's not used in the current code but may in the future.  Please keep
it around as a patch or whatever until your introduce actual users of it.

I'm pretty sure we will try to do this kind of bookkepping in the sas
transport class later on.

> >  - what's that ->last_lun thing about?
> 
> This fixes a bug sent to us by Tom Coughlan of Redhat; here
> is the description of the bug from Tom : 
> 
> "When SPARSELUN is set, the SCSI midlayer unconditionally probes LUN
> values up to max_lun in the SCSI host template.  In recent versions of
> the mpt fusion driver this is set to 256. The problem is that on
> non-U320 SCSI (non-packetized) the identify message is used, and its LUN
> field is only 6 bits, allowing only 64 LUNs. This causes
> selectio/reselection problems on the SCSI bus, resulting the
> configuration of non-existant devices, or maybe worse."

Just setting max_lun in struct Scsi_Host before calling scsi_scan_host
to either MPT_LAST_LUN or MPT_NON_IU_LAST_LUN should fix that issue.

The max_lun parameter in the host template is just the default value
set during scsi_host_alloc.

> >  - if you already changed the boot parameter syntax please move to
> >    a module_param for each individual parameter
> 
> I will consider moving saf-te and pt_clear seperate.
> However no change to the existing paramers that are dv 
> associated parameters passed on the same line with "mptscsih".

Well, you're disallowing one of the existant syntaxes anyway, right?

At least add a separate one for each of the parameters (and only
add those for the new parameter) so the old ones can spit a warning
and be removed after a longer timeframe.

