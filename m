From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Page allocation failure (order 7) in UAS code
Date: Tue, 1 Mar 2016 11:49:51 +0100
Message-ID: <56D573CF.1000600@redhat.com>
References: <1456825361.17330.9.camel@corsac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbcCAKt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 05:49:58 -0500
In-Reply-To: <1456825361.17330.9.camel@corsac.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yves-Alexis Perez <corsac@corsac.net>, Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On 01-03-16 10:42, Yves-Alexis Perez wrote:
> Hi,
>
> [sorry if this is not the right point for reporting bugs, I took the email
> addresses from MAINTAINERS but please point me to the correct place if needed]
>
> I have an external USB drive (Samsung M3), which apparently uses the UAS code.
> Starting with 4.4 (from Debian sid, I could retry with vanilla if needed), I
> can't mount the drive anymore after a while (few hours/days uptime). Just
> plugging the disk, I get page allocation failure in kernel logs:

Can you try building a kernel with the following line in drivers/usb/storage/uas.c :

         .can_queue = 65536,     /* Is there a limit on the _host_ ? */

(around line 815) Replaced with

         .can_queue = MAX_CMNDS,

That should help as MAX_CMNDS is 256, so claiming that we can queue more
is not helpful, and that likely is what is causing this quite high order alloc.

Regards,

Hans
