From: Tejun Heo <tj@kernel.org>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 05:21:21 -0500
Message-ID: <20140117102121.GA8598@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
 <1389953809.21408.7.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:44144 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaAQKVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 05:21:33 -0500
Received: by mail-qe0-f44.google.com with SMTP id 1so3766810qee.31
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 02:21:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1389953809.21408.7.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hello,

On Fri, Jan 17, 2014 at 11:16:49AM +0100, Oliver Neukum wrote:
> The START-STOP may result in an error. What do you do in that case?

At least for libata, worrying about suspend/resume failures don't make
whole lot of sense.  If suspend failed, just proceed with suspend.  If
the device can't be woken up afterwards, that's that.  There isn't
anything we could have done differently anyway.  The same for resume,
if spinup fails, the device is dud and the following commands will
invoke EH actions and will eventually fail.  Again, there really isn't
any *choice* to make.  Just making sure the errors are handled
gracefully (ie. don't crash) and the following commands are handled
correctly should be enough.

Thanks.

-- 
tejun
