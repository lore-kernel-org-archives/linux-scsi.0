From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
Date: Fri, 26 Apr 2013 10:10:31 -0700
Message-ID: <20130426171031.GA29600@kroah.com>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49509 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3DZRKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 13:10:34 -0400
Received: by mail-pb0-f48.google.com with SMTP id wy7so174463pbc.21
        for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2013 10:10:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Fri, Apr 26, 2013 at 11:39:33AM -0500, Steven J. Magnani wrote:
> Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> set_media_not_present() in a way that prevents the sd driver from
> remembering that a non-removable device has reported "Medium Not Present".
> This condition can occur on hotplug of a (i.e.) USB Mass Storage device
> whose medium is offline due to an unrecoverable controller error,
> but which is otherwise capable of SCSI communication (to download new 
> microcode, etc.).
> 
> Under these conditions, the changed code results in an infinite loop
> between the kernel and udevd. When udevd attempts to open the device
> in response to a change notification, a SCSI "Medium Not Present" error
> occurs which causes the kernel to signal another change. The cycle
> repeats until the device is unplugged, resulting in udevd consuming ever-
> increasing amounts of CPU and virtual memory.
> 
> Resolve this by remembering "media not present" whether the device has
> declared itself "removable" or not.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
