From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 03/21] uas: Fix resetting flag handling
Date: Wed, 10 Sep 2014 15:50:31 +0200
Message-ID: <54105727.2020402@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>	 <1410349611-17573-4-git-send-email-hdegoede@redhat.com> <1410356429.12706.26.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaIJNuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 09:50:39 -0400
In-Reply-To: <1410356429.12706.26.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

First of all, thank you for reviewing this.

On 09/10/2014 03:40 PM, Oliver Neukum wrote:
> On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
>> - Make sure we always hold the lock when setting / checking resetting
>> - Check resetting before checking urb->status
>> - Add missing check for resetting to uas_data_cmplt
>> - Add missing check for resetting to uas_do_work
> 
> Why is the checking for stat and data inconsistent?

With stat urbs there is no direct reference from the urb
to the scsi cmnd, since when using usb-2 the sense urbs
may arrive in a different order then the cmnds where issued.
instead for sense urbs we look up the cmnd by tag, likewise
there is no reference from the cmnd back to the sense-urb.

For data urbs however the urb->context pointer points directly
to the cmnd struct, and the cmnd struct has a pointer back in
the form of devinfo->data_[in|out]_urb. When the urb completes
we want to NULL the devinfo->data_[in|out]_urb pointers even
when resetting. So that we don't try to deref a pointer to
a free-ed urb later on (this does not become an issue until
after the "uas: Free data urbs on completion" commit).

Regards,

Hans
