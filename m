From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:38:12 +0200
Message-ID: <20100728093812.GB11862@lst.de>
References: <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF42C.1050701@suse.de> <20100728091633.GA10219@lst.de> <4C4FF73B.3070504@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38191 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0G1Jih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 05:38:37 -0400
Content-Disposition: inline
In-Reply-To: <4C4FF73B.3070504@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, Jul 28, 2010 at 11:24:11AM +0200, Tejun Heo wrote:
> On 07/28/2010 11:16 AM, Christoph Hellwig wrote:
> > The problem is to emulate it properly on devices that do no actually
> > support the FUA bit.  Of which we unfortunately have a lot given
> > that libata by default disables the FUA support even if the device
> > supports.
> 
> These were the reasons.
> 
> * Some controllers puke for FUA commands whether the device supports
>   it or not.
> 
> * Low confidence in drives reporting FUA support.  New features in ATA
>   world seldomly work well and I'm fairly sure there are devices which
>   report FUA support and handle FUA writes exactly the same way as
>   regular writes.  :-(

Jens recently told that Windows seems to send lots of FUA requests these
days, which should really have helped shacking it out.

> completely, it might make sense to revisit it.  But, in general, I
> think most barriers, even when relaxed, would at least involve single
> flush before the FUA write and in that case I'm pretty skeptical how
> useful FUA write for the barrier itself would be.

At least for XFS we should be able to get away with almost no full
flush at all for special workloads (no fsyncs/syncs, not appending file
writes).  With more normal workloads that get a fsync/sync once in
a while we'd almost alwasy do a full flush for every log write, though.
