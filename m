From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] scsi_transport_sas: move bsg destructor into
 sas_rphy_remove
Date: Fri, 21 Feb 2014 17:15:02 -0500
Message-ID: <20140221171502.74830b03@jlaw-desktop.mno.stratus.com>
References: <20131120140840.4d1f23ca@jlaw-desktop.mno.stratus.com>
	<20131125112339.45e279db@jlaw-desktop.mno.stratus.com>
	<20131203130305.1d414258@jlaw-desktop.mno.stratus.com>
	<20131203131550.17a56000@jlaw-desktop.mno.stratus.com>
	<CAA9_cme2REPT4L+uBkZaYtnfq1W2efO3Cs+5i61ArHiB4XdOgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:44338 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaBUWPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:15:25 -0500
In-Reply-To: <CAA9_cme2REPT4L+uBkZaYtnfq1W2efO3Cs+5i61ArHiB4XdOgg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dave Jiang <dave.jiang@gmail.com>, artur.paszkiewicz@intel.com, Lukasz Dorau <lukasz.dorau@intel.com>

On Wed, 12 Feb 2014 11:13:22 -0800
Dan Williams <dan.j.williams@intel.com> wrote:
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> I think this is the right move, and some follow-up cleanups / fixes
> come to mind:

Dan -- Thanks for taking a look.  A few comments below.

> 1/ Why is sas_bsg_remove() multiplexing 2 use cases?  Let's just have
> a sas_host_bsg_remove() and a sas_device_bsg_remove().

Splitting the two use cases reduces them into a simple conditional call
to bsg_unregister_queue(), that could just be done in place.  On the
other hand, sas_bsg_initialize() looks like it handles both cases as
well.

> 2/ I think sas_rphy_free() mishandles the reference counts in the
> sas_rphy_add() failing case.
> sas_rphy_free() does:
>         transport_destroy_device(dev); /* which is just put_device(dev) */
>         put_device(dev);
> 
> ...but if sas_rphy_add() failed we never took the reference from
> transport_add_device() and I expect we only have the one reference
> from device_initialize() to drop.
> 
> We also ignore the return code from transport_add_device() which is
> another hole.

Ugh, I think fixing this properly would require piping the return code
of the trigger function back out of the attribute container code:

void transport_add_device()
  void attribute_container_device_trigger()
    loop through the attribute_container_list
      if match
        int transport_add_class_device()
          ... return error ...

Not to mention several callers of sas_rphy_add keep on truckin' when it
does return failure.

Perhaps this can be handled in another way?

> Commenting on this mail should refresh this in James' queue.  But you
> may want to resend anyways given this is a few months old.

Whatever is easier for James.

Regards,

-- Joe
