From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] Allow retrieval of the Caching mode page
Date: Thu, 21 Oct 2010 21:06:47 -0700 (PDT)
Message-ID: <965283.41083.qm@web31805.mail.mud.yahoo.com>
References: <20101022000405.GC25431@one-eyed-alien.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:40777 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751899Ab0JVEGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2010 00:06:48 -0400
In-Reply-To: <20101022000405.GC25431@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- On Thu, 10/21/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> If you remove this, there are several devices which will
> stop working.
> They will simply go out-to-lunch when the sd_mod driver
> sends a request for
> Mode Page 8.

That's true. But it seems unfair to punish good devices which do support
the Caching mode page.

sd_revalidate_disk() calls in succession sd_read_write_protect_flag(),
sd_read_cache_type() and sd_read_app_tag_own().  The first, asks for all
pages by setting the page code to 0x3F. Surely if the device server
supports the Caching mode page, it will be returned. The second call, asks
only for the Caching mode page, and here is where some (few?) broken
devices fail.

If the skip_ms_page_8 is set, why not request all pages, and see if the
Caching mode page is part of the parameter data.

Anyone willing to code that up in sd_read_cache_type()?

