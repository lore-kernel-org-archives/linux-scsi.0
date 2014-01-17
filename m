From: Tejun Heo <tj@kernel.org>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 14:07:54 -0500
Message-ID: <20140117190754.GA23024@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
 <1389953809.21408.7.camel@linux-fkkt.site>
 <20140117102121.GA8598@htj.dyndns.org>
 <1389983977.2723.18.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:41549 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaAQTH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 14:07:58 -0500
Received: by mail-qe0-f44.google.com with SMTP id 1so4311332qee.17
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 11:07:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1389983977.2723.18.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hello, James.

On Fri, Jan 17, 2014 at 10:39:37AM -0800, James Bottomley wrote:
> The specific worry is the writeback cache.  If the flush fails and we
> power down with dirty blocks in the cache, those blocks are lost but the
> filesystem still thinks they're committed.  I think as long as you're
> using flush barriers on your system, this isn't a problem, but if you're
> not using barriers, it can lead to undetected corruption that blows up
> later.  If it were a choice between suspend my laptop and save my data,
> I'd choose the latter.  But the question is do we care ... perhaps we
> can just say you have to use flush barriers if you want to suspend.

Ooh, yeah, flush failure is special.  That said, I think the right way
to deal with that is marking the device as failed and fail writes /
flushes afterwards instead of failing suspend.  It's hightly unlikely
the device is in any useable state after failing flushes anyway and
failing suspend has potential to lead to pretty dramatic failure
conditions (device overheating in the bag would be a common one) too.

Thanks.

-- 
tejun
