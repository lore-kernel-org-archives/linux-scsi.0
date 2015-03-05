From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Thu, 05 Mar 2015 16:22:43 -0500
Message-ID: <54F8C923.5010202@interlog.com>
References: <20150305153338.GA16293@aepfle.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59697 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbbCEVXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 16:23:06 -0500
In-Reply-To: <20150305153338.GA16293@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>, Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On 15-03-05 10:33 AM, Olaf Hering wrote:
> I'm using scsi_debug to implement and test tools for xen-scsiback. Today
> I discovered that each LUN uses the very same storage, as described in
> the docs. What would it take to optionally use dedicated storage for
> each LUN?
>
> This is how I load scsi_debug:
> modprobe scsi_debug add_host=4 dev_size_mb=4 max_luns=4 num_parts=4 num_tgts=4 vpd_use_hostno=1

Olaf,
Just having a quick look: the fake_storep, dif_storep and
map_storep heaps would need to be per LU; IOWs placed in
struct sdebug_dev_info. Also atomic_rw would need to be
placed in that structure.

To be backward compatible to what the scsi_debug driver
does now (i.e. shares storage) accessor functions might
be employed to hide whether the global or per LU instance
is being handled.

Handling the inevitable ENOMEM errors might be a bit tricky
especially since extra LUs and hosts can be added dynamically
via sysfs.


So it is possible. The stock answer has typically been that
you should probably be using the target subsystem for that.
Thoughts?

Doug Gilbert

