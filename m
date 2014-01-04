From: Mark Lord <mlord@pobox.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Sat, 04 Jan 2014 09:03:26 -0500
Message-ID: <52C814AE.2040402@pobox.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52C6D9F1.9000709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: walt <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-01-03 10:40 AM, walt wrote:
> On 01/02/2014 11:15 AM, Sarah Sharp wrote:
>> On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
>>> On 12/18/2013 01:11 PM, Greg Kroah-Hartman wrote:
>>>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: David Laight <David.Laight@ACULAB.COM>
>>>>
>>>> commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e upstream.
>>>>
>>>> Section 4.11.7.1 of rev 1.0 of the xhci specification states that a link TRB
>>>> can only occur at a boundary between underlying USB frames (512 bytes for
>>>> high speed devices).
>>>>
>>>> If this isn't done the USB frames aren't formatted correctly and, for example,
>>>> the USB3 ethernet ax88179_178a card will stop sending...
>>>
>>>
>>> Unfortunately this patch causes a regression when copying large files to my
>>> outboard USB3 drive. (Nothing at all to do with networking.)
> 
>> Do you have CONFIG_USB_DEBUG turned on for 3.13?  If so, you should see
>> dmesg output from this statement shortly before your drive fails:
>>
>> if (num_trbs >= TRBS_PER_SEGMENT) {
>> 	xhci_err(xhci, "Too many fragments %d, max %d\n",
>> 		num_trbs, TRBS_PER_SEGMENT - 1);
>> 	return -ENOMEM;
>> }
> 
> Well, the answers depend on whether the usb3 drive uses logical volumes or not
> (lvm2), which I can't explain.  What I've described so far is with lvm2.
> 
> When using lvm2 on the usb3 drive, turning on USB_DEBUG has *no* effect -- the
> console prints two or three lines stating that the ext4 journal has quit and
> the drive is remounted ro.  That particular drive stays wedged until the next
> reboot, but no other ill effects to the system.
> 
> OTOH, when I put a disk with just an ordinary ext4 partition in the usb3 dock,
> (no logical volumes) the copy failure becomes catastrophic, with kernel panic
> messages, leaving the system unresponsive and needing a hard reset to recover.
> 
> I also tried your other suggestion:
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 4265b48..1a6a43d 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4714,7 +4714,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>         int                     retval;
>  
>         /* Accept arbitrarily long scatter-gather lists */
> -       hcd->self.sg_tablesize = ~0;
> +       hcd->self.sg_tablesize = 31;
>  
>         /* support to build packet from discontinuous buffers */
>         hcd->self.no_sg_constraint = 1;
> 
> Sadly it didn't fix the problem.  Did I get the patch right?


That sounds almost as if the old version is still being loaded/run,
possibly from the initramfs image?

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
