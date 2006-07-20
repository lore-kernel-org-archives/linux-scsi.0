From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Thu, 20 Jul 2006 17:27:21 -0400
Message-ID: <44BFF539.4000700@garzik.org>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030380AbWGTV10@vger.kernel.org>
In-Reply-To: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>
List-Id: linux-scsi@vger.kernel.org

Ed Lin wrote:
> Please review following patch based on the 'stex' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 
> Jeff Garzik already finished some changes, and these are the rest.
> 
>>From Christoph Hellwig's comments:
> 	use scsi_kmap_atomic_sg/scsi_kunmap_atomic_sg
>     callback argument to ->queuecommand changed to 'done'
> 	merge init functions into .probe
> 
>>From Alexey Dobriyan's comments:
> 	__le32 *time
> 
> Promise code changes:
> 	add hard reset function
> 	extend reset wait time
> 	add new device ids
> 	white space/ minor fix(INQUIRY, max_channel)
> 
> Block layer tag: 
> 	It is not implemented because here tag is adapter wide,
> 	not for single device.
> Non-sg codepath:
> 	It can be eliminated when Christoph Hellwig's patch
> 	upstream.
> Firmware lun issue:
> 	Firmware uses an id/lun pair for a logical drive. But
> 	lun could be always 0 in Linux(when you do not config
> 	CONFIG_SCSI_MULTI_LUN).I use channel to map lun,
> 	otherwise max_id will be 256.
> INQUIRY, passthru command:
> 	Needed by management software. The special handling of
> 	INQUIRY is for management software to have a sg device
> 	to issue commands.

Overall, the patch looks good.  My quick review finds a couple nits, though:

1) [major] The Intel bridge code ("pci_get_device(0x8086, 0x0370, bus0),
...") is not the type of thing we normally put into a driver.  If there
is a problem with a specific bridge, we would prefer to patch
drivers/pci/quirks.c.

Touching _another_ piece of hardware, other than your own, is a big deal
and generally unwise.

2) [minor] Adding "magic numbers" in stex_hard_reset().  Easy to fix:
convert "0x3e", "0x84", "1 << 5" etc. to named constants.  The named
constants should have sufficiently good names to understand their
purpose, without being overly long C symbols.

3) [minor] For sleeping longer than one second, ssleep() is preferred to
msleep().

4) [minor] 'void *scratch' in struct st_hba tells us nothing about its
usage.  At the very least, a comment, if not a better name, would be good.

5) [agreement/correction]  The block tagging API supports adapter-wide
tags just fine.  HOWEVER, I nonetheless feel that block tagging API use
should be considered post-merge.  The 'stex' driver is working and
tested today.  Since _no individual SCSI driver_ uses the block layer
tagging, it is likely that some instability and core kernel development
will occur, in order to make that work.

All your other changes look good to me.

	Jeff
