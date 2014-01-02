From: Mark Lord <mlord@pobox.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Thu, 02 Jan 2014 16:01:29 -0500
Message-ID: <52C5D3A9.60708@pobox.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140102191510.GA9621@xanatos>
Sender: linux-kernel-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-01-02 02:15 PM, Sarah Sharp wrote:
> On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
..
>> Unfortunately this patch causes a regression when copying large files to my
>> outboard USB3 drive. (Nothing at all to do with networking.)
>>
>> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
>> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
>>
>> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
>> patch completely fixes the problem.
> 
> Ok, I had feared that would be a consequence of this patch.  I think the
> problem is that the usb-storage driver submitted an URB with more
> scatter-gather entries than would fit on the ring segment, the xHCI
> driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
> up on the SCSI command.


Is there not a block layer / scheduler tunable for max sg entries or something?
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
