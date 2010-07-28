From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:24:11 +0200
Message-ID: <4C4FF73B.3070504@kernel.org>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF42C.1050701@suse.de> <20100728091633.GA10219@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0G1JYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 05:24:36 -0400
In-Reply-To: <20100728091633.GA10219@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 07/28/2010 11:16 AM, Christoph Hellwig wrote:
> The problem is to emulate it properly on devices that do no actually
> support the FUA bit.  Of which we unfortunately have a lot given
> that libata by default disables the FUA support even if the device
> supports.

These were the reasons.

* Some controllers puke for FUA commands whether the device supports
  it or not.

* With the traditional strong barriers, it doesn't make much
  difference whether FUA is used or not.  The full queue has already
  been stalled and flushed by the time barrier write is issued and all
  that we save is overhead for a single command which doesn't make any
  difference to actual timing of completion.

* Low confidence in drives reporting FUA support.  New features in ATA
  world seldomly work well and I'm fairly sure there are devices which
  report FUA support and handle FUA writes exactly the same way as
  regular writes.  :-(

So, until now, it just wasn't worth the effort / risk.  If filesystems
can make use of more relaxed ordering including avoiding full flush
completely, it might make sense to revisit it.  But, in general, I
think most barriers, even when relaxed, would at least involve single
flush before the FUA write and in that case I'm pretty skeptical how
useful FUA write for the barrier itself would be.

Thanks.

-- 
tejun
