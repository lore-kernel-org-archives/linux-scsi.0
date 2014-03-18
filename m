From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 1/3] libata, libsas: kill pm_result and related cleanup
Date: Tue, 18 Mar 2014 16:18:05 -0400
Message-ID: <20140318201805.GB32357@mtj.dyndns.org>
References: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
 <20140314205248.1269.33730.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:59379 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbaCRUSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 16:18:10 -0400
Content-Disposition: inline
In-Reply-To: <20140314205248.1269.33730.stgit@viggo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@Parallels.com, Phillip Susi <psusi@ubuntu.com>, Todd Brandt <todd.e.brandt@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Fri, Mar 14, 2014 at 01:52:48PM -0700, Dan Williams wrote:
> Tejun says:
>   "At least for libata, worrying about suspend/resume failures don't make
>    whole lot of sense.  If suspend failed, just proceed with suspend.  If
>    the device can't be woken up afterwards, that's that.  There isn't
>    anything we could have done differently anyway.  The same for resume, if
>    spinup fails, the device is dud and the following commands will invoke
>    EH actions and will eventually fail.  Again, there really isn't any
>    *choice* to make.  Just making sure the errors are handled gracefully
>    (ie. don't crash) and the following commands are handled correctly
>    should be enough."
> 
> The only libata user that actually cares about the result from a suspend
> operation is libsas.  However, it only cares about whether queuing a new
> operation collides with an in-flight one.  All libsas does with the
> error is retry, but we can just let libata wait for the previous
> operation before continuing.
> 
> Other cleanups include:
> 1/ Unifying all ata port pm operations on an ata_port_pm_ prefix
> 2/ Marking all ata port pm helper routines as returning void, only
>    ata_port_pm_ entry points need to fake a 0 return value.
> 3/ Killing ata_port_{suspend|resume}_common() in favor of calling
>    ata_port_request_pm() directly
> 4/ Killing the wrappers that just do a to_ata_port() conversion
> 5/ Clearly marking the entry points that do async operations with an
>   _async suffix.
> 
> Reference: http://marc.info/?l=linux-scsi&m=138995409532286&w=2
> 
> Cc: Phillip Susi <psusi@ubuntu.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Applied 1-2 to libata/for-3.15.

Thanks.

-- 
tejun
