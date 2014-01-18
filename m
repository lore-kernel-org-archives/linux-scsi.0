From: walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Sat, 18 Jan 2014 10:34:16 -0800
Message-ID: <52DAC928.2070002@gmail.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45EDA3-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/17/2014 06:34 AM, David Laight wrote:
> From: walt
>> Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
>> the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
>> docking station, too.)
>>
>> I can't believe the adapter works perfectly in a different computer.  Have you
>> seen this kind of thing before?
> 
> Could be a horrid timing race between the cpu and xchi controller.
> If the cpu manages to write a NOP or LINK TRB for a following transfer
> before the controller polls the next entry (after raising the IRQ)
> then the controller might process the LINK and then get confused
> when it can't process the linked-to TRB.
> This might not sound likely, but PCIe has significant latency.

 
> Can you try the patch I posted that stops the ownership on LINK TRBs
> being changed before that on the linked-to TRB?

David, the patch doesn't apply cleanly to any 3.12.x sources I can find,
including the latest git from Linus.  Half of the hunks fail.  Could you
create a fresh patch against vanilla 3.12.8 so I can test it? Or point me
to the correct kernel sources, perhaps.

Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
