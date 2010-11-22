From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Mon, 22 Nov 2010 12:02:26 -0800 (PST)
Message-ID: <538170.68988.qm@web31803.mail.mud.yahoo.com>
References: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:43712 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757448Ab0KVUC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 15:02:27 -0500
In-Reply-To: <AANLkTi=7tW6wqrk8ZkFuTYwmS-wZ4nQ+jkxk8U95H42F@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>

--- On Mon, 11/22/10, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > Some kernel transport drivers unconditionally disable
> > retrieval of the Caching mode page. One such for
> example is
> > the BBB/CBI transport over USB.
> 
> One reason for that is that historically we've seen devices
> that
> simply go crazy - to the point of simply stopping to
> respond to
> anything - when you ask for pages that Windows doesn't ask
> for.
> 
> It's especially common on USB storage, but it happens
> elsewhere too.
> The device firmware simply hasn't ever been tested in that
> situation,
> and it's buggy.
> 
> So I don't mind the patch per se, but I think it's
> potentially way
> more dangerous than it looks.

This patch does not ask for pages that Windows doesn't ask for. The sd driver already asks for all pages (page code 0x3F) and then checks if the device is write protected. Here is the present code:

  2217                  sd_read_write_protect_flag(sdkp, buffer);
  2218                  sd_read_cache_type(sdkp, buffer);
  2219                  sd_read_app_tag_own(sdkp, buffer);

Line 2217 asks for page code 0x3F, meaning all mode pages.
Line 2218 asks for the Caching mode page or not at all if the device flags forbid it (all USB storage devices in the Linux kernel).

This patch adds processing of the data returned when all mode pages are asked for (0x3F) in the function on line 2218. It then parses the data to find out if the Caching mode page is present.

   Luben

