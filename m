From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 17:03:03 +0200
Message-ID: <56FD3C27.2050708@redhat.com>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com>
 <1459435682.2958.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcCaPDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 11:03:10 -0400
In-Reply-To: <1459435682.2958.19.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: David Webb <djw@noc.ac.uk>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 31-03-16 16:48, James Bottomley wrote:
> On Thu, 2016-03-31 at 14:22 +0200, Hans de Goede wrote:
>> Add a new NO_REPORT_LUNS quirk and set it for Seagate drives with
>> an usb-id of: 0bc2:331a, as these will fail to respond to a
>> REPORT_LUNS command.
>
> Actually, if we're sending them a report luns command, they must be
> reporting in at SCSI-3 SPC or higher.  Should we be quirking them down
> to SCSI-2 instead because it reduces the risk of running into something
> else they're not doing from the SPC command set?

These are fairly new devices, so they should really be scsi3, but the
usb <-> sata bridge (presumably) used does not seem to like report_luns.

Note that usb-storage simple sets no_report_luns conditionally for all
usb-storage devices. The scsi people have repeatedly asked me to not
do this kinda blanket blacklisting for uas devices, because they hope
that uas will allow them to more or less do proper scsi over usb, so
we end up with blacklisting specific commands every now and then to
get devices to work.

Regards,

Hans
