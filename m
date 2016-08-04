From: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usb: storage: fix runtime pm issue in usb_stor_probe2
Date: Thu, 4 Aug 2016 07:34:03 +0200
Message-ID: <b3ef758f-f519-3d90-3d9b-9abf8e6d7f7b@gmail.com>
References: <Pine.LNX.4.44L0.1608031656060.2040-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1608031656060.2040-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux USB Mailing List <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Am 03.08.2016 um 23:25 schrieb Alan Stern:
> On Wed, 3 Aug 2016, Heiner Kallweit wrote:
> 
>> Since commit 71723f95463d "PM / runtime: print error when activating a
>> child to unactive parent" I see the following error message:
>>
>> scsi host2: usb-storage 1-3:1.0
>> scsi host2: runtime PM trying to activate child device host2 but parent
>> 	    (1-3:1.0) is not active
>>
>> Digging into it it seems to be related to the problem described in the
>> commit message for cd998ded5c12 "i2c: designware: Prevent runtime
>> suspend during adapter registration" as scsi_add_host also calls
>> device_add and after the call to device_add the parent device is
>> suspended.
>>
>> Fix this by using the approach from the mentioned commit and getting
>> the runtime pm reference before calling scsi_add_host.
> 
> Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> 
> There's nothing wrong with this patch; it's a worthwhile thing to do 
> because it can prevent an unnecessary runtime-suspend/resume cycle.
> 
> Still, it looks like the real problem here may lie in
> drivers/scsi/hosts.c.  Commit bc4f24014de5 ("[SCSI] implement runtime
> Power Management") added a call to pm_runtime_set_active() in
> scsi_add_host_with_dma() _after_ device_add() instead of _before_.
> 
> If that were changed, this problem would not have occurred.
> 
In parallel to this patch I sent another one to address exactly the
ordering issue in scsi_add_host_with_dma you mention.
The other patch went to Martin and the SCSI mailing list only, sorry.
I'll forward it to you for review.

Heiner

> Alan Stern
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
