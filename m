From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device
 flag
Date: Mon, 02 Aug 2010 23:43:25 +0200
Message-ID: <4C573BFD.8090407@redhat.com>
References: <1279875174-2905-1-git-send-email-hdegoede@redhat.com> <1280323195.30808.58.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab0HBVjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 17:39:23 -0400
In-Reply-To: <1280323195.30808.58.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Hi,

On 07/28/2010 03:19 PM, James Bottomley wrote:
> On Fri, 2010-07-23 at 10:52 +0200, Hans de Goede wrote:
>> Some USB devices emulate a usb-mass-storage attached (scsi) cdrom device,
>> usually this fake cdrom contains the windows software for the device.
>> While working on supporting Appotech ax3003 based photoframes, which do
>> this I discovered that they will go of into lala land when ever they
>> see a READ_DISC_INFO scsi command.
>>
>> Thus this patch adds a scsi_device flag (which can then be set by the
>> usb-storage driver through an unsual-devs entry), to indicate this, and
>> makes the sr driver honor this flag.
>>
>> I know this sucks, but as discussed on linux-scsi list there is no other
>> way to make this device work properly.
>>
>> Looking at usb traces made under windows, windows never sends a
>> READ_DISC_INFO during normal interactions with a usb cdrom device. So as
>> this cdrom emulation thingie becomes more common we might see more of
>> this problem.
>
> So, I suppose we can do this.  I dislike threading device bugs like this
> up and down the stack.  The usb stor_control_thread already does some
> command filtering; if it just rejected this command and READ
> CAPACITY(16) on the flags, I think it would be far less code and the
> SCSI subsystem would just do the right thing.
>
> I'd actually like to hear from USB what they'd prefer to do.
>

I was sort of hoping that Alan Stern would reply to this, but maybe he is
on vacation?

The reason I've done this patchset this way, is that I've added several
other usb mass storage specific quirks in the past and each time the USB
guys said that they don't want to do any (extra) command filtering and
asked me to split the patch in a scsi / sd flag adding patch and a
patch for the usb mass storage driver to use that flag.

Regards,

Hans
