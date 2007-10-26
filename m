From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Questions about proc_scsi_write() in scsi_proc.c
Date: Fri, 26 Oct 2007 16:09:37 -0500
Message-ID: <1193432977.3293.76.camel@localhost.localdomain>
References: <200710261507.49284.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33600 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759523AbXJZVJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 17:09:39 -0400
In-Reply-To: <200710261507.49284.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-10-26 at 15:07 -0500, Rob Landley wrote:
> I don't understanding this code:
> 
> 1) for echo "scsi add-single-device 0 1 2 3" > /proc/scsi/scsi, is this only 
> for parallel scsi? 

No.

>  I thought most modern busses (usb, sata, FC, firewire, 
> etc) dynamically assign these numbers and just use them as a unique 
> identifier ala kdev_t.  How would this work on one of the other devices?

It's most often used to add or remove LUNs.

> 2) How do you trigger this?  /proc/scsi/scsi is read only even for root.

root can still write to it.

> 3) This bit is repeated in both the add and remove logic:
>                 p = buffer + 23;
> 
>                 host = simple_strtoul(p, &p, 0);
>                 channel = simple_strtoul(p + 1, &p, 0);
>                 id = simple_strtoul(p + 1, &p, 0);
>                 lun = simple_strtoul(p + 1, &p, 0);
> 
> So what happens if you echo "scsi add-single-device 0" > /proc/scsi/scsi (or 
> wherever file would trigger this function) so the read for channel skips over 
> the null terminator (I'm assuming there is one) and reads who knows what?  Or 
> what if instead of ending that with one 0, you end it with enough zeroes to 
> pad right up to PAGE_SIZE, so it reads the next page?  (I don't even know 
> what the page protections are on that, depends how 
> __get_free_page(GFP_KERNEL) works...)
> 
> Confused,

It's relying on the user buffer being zero padded, but even if it isn't,
there's not much that can go wrong.  It's also a deprecated interface.

James


