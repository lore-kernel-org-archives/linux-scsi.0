From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Wed, 5 Jan 2005 10:50:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501051039250.635-100000@ida.rowland.org>
References: <20050105001420.5f4c8623.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20050105001420.5f4c8623.akpm@osdl.org>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Srihari Vijayaraghavan <harisri@internode.on.net>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 5 Jan 2005, Andrew Morton wrote:

> Looks like the scsi-vs-usb-storage bunfight isn't yet settled...
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 31 Dec 2004 14:44:44 +1100
> From: Srihari Vijayaraghavan <harisri@internode.on.net>
> To: linux-kernel@vger.kernel.org
> Subject: [BUG] USB Storage OOPS and a D state process in 2.6.10
> 
> 
> Can easily reproduce this by plugging and unplugging an external USB DVD-RW a 
> few times on my Athlon 64 desktop:
> 
> usb-storage: device scan complete
> usb 1-2: USB disconnect, address 22
> Unable to handle kernel paging request at 000000000044c8c6 RIP: 
> <ffffffffa0108252>{:usb_storage:bus_reset+66}

> Process scsi_eh_22 (pid: 8843, threadinfo 000001002f9a6000, task 
> 00000100369f70f0)
> Stack: 0000010037d6f640 0000010037d6f640 0000010037d6f670 ffffffffa0003c31 
>        0000000000000282 0000000000000000 0000010037d6f640 ffffffffa000463b 
>        ff000000ff000000 ff000000ff000000 
> Call Trace:<ffffffffa0003c31>{:scsi_mod:scsi_try_bus_reset+113} 
>        <ffffffffa000463b>{:scsi_mod:scsi_error_handler+2251} 
>        <ffffffff8010ebf3>{child_rip+8} 
> <ffffffffa0003d70>{:scsi_mod:scsi_error_handler+0} 
>        <ffffffff8010ebeb>{child_rip+0} 

> And a D state hald process:


On Wed, 5 Jan 2005, James Bottomley wrote:

> Actually, this one looks pretty clear cut:
>
> According to the trace, we get into error handling for a removed device.
> This:
>
> > RIP <ffffffffa0108252>{:usb_storage:bus_reset+66} RSP 
<000001002f9a7e68>
>
> says that the usb_storage bus_reset routine never returns.
>
> So the system is hung in error handling and the kernel is waiting for
> everything to return to normal.  The fix is to work out why usb_storage
> hung there instead of returning success or fail.


I agree with James, although it's clear from the oops report why the 
routine doesn't return: It tries to reference an invalid address.

Not being at all familiar with 64-bit code, I can't tell exactly where the
invalid reference occurred.  It looks like it's near the start of the
bus_reset routine, but that doesn't make sense because none of the data
structures referred to there should have been deallocated yet.  That 
doesn't happen until after scsi_remove_host returns, and once that happens 
the error handler shouldn't run at all.

Another question is why we get into the error handler in the first place.  
No way to tell from the information provided, but I suspect the haldaemon 
process isn't doing what it should.

Srihari, can you try reproducing this after rebuilding the usb-storage 
driver with CONFIG_USB_STORAGE_DEBUG=y?

Alan Stern



-------------------------------------------------------
The SF.Net email is sponsored by: Beat the post-holiday blues
Get a FREE limited edition SourceForge.net t-shirt from ThinkGeek.
It's fun and FREE -- well, almost....http://www.thinkgeek.com/sfshirt
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
