From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 10:39:37 -0800
Message-ID: <1389983977.2723.18.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
	 <1389953809.21408.7.camel@linux-fkkt.site>
	 <20140117102121.GA8598@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35672 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbaAQSjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 13:39:39 -0500
In-Reply-To: <20140117102121.GA8598@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2014-01-17 at 05:21 -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 17, 2014 at 11:16:49AM +0100, Oliver Neukum wrote:
> > The START-STOP may result in an error. What do you do in that case?
> 
> At least for libata, worrying about suspend/resume failures don't make
> whole lot of sense.  If suspend failed, just proceed with suspend.  If
> the device can't be woken up afterwards, that's that.

The specific worry is the writeback cache.  If the flush fails and we
power down with dirty blocks in the cache, those blocks are lost but the
filesystem still thinks they're committed.  I think as long as you're
using flush barriers on your system, this isn't a problem, but if you're
not using barriers, it can lead to undetected corruption that blows up
later.  If it were a choice between suspend my laptop and save my data,
I'd choose the latter.  But the question is do we care ... perhaps we
can just say you have to use flush barriers if you want to suspend.

James



