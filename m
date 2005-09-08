From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Possible bug in usb storage (2.6.11 kernel)
Date: Thu, 8 Sep 2005 16:40:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081637410.4545-100000@iolanthe.rowland.org>
References: <4789af9e05090813287f05e12a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-users-admin@lists.sourceforge.net>
In-Reply-To: <4789af9e05090813287f05e12a@mail.gmail.com>
Sender: linux-usb-users-admin@lists.sourceforge.net
Errors-To: linux-usb-users-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
To: Jim Ramsay <jim.ramsay@gmail.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, linux-usb-users@lists.sourceforge.net, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 8 Sep 2005, Jim Ramsay wrote:

> More information:
> 
> The error only occurrs during device sensing when the
> srb->request_buffer is assigned as follows, by usb/storage/transport.c
> in the routine usb_stor_invoke_transport:
> 
> old_request_buffer = srb->request_buffer;
> srb->request_buffer = srb->sense_buffer;
> 
> Now, this is a problem because srb->sense_buffer is defined as follows
> in the struct scsi_cmnd:
> 
> #define SCSI_SENSE_BUFFERSIZE   96
>         unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
> 
> Since it is not allocated at runtime there is NO WAY the SCSI layer
> can possibly guarantee it is page- or cache-aligned and ready for DMA.
> 
> Any suggestions on best fix for this?  Is it still a SCSI-layer issue?
>  Or should USB step up in this case and ensure this buffer is dma-safe
> itself?

Aha!

I've long thought that usb-storage should allocate its own transfer buffer 
for sense data.  In the past people have said, "No, don't bother, it's not 
really needed."  Here's a good reason for doing it.

Expect a patch before long.

Alan Stern



-------------------------------------------------------
SF.Net email is Sponsored by the Better Software Conference & EXPO
September 19-22, 2005 * San Francisco, CA * Development Lifecycle Practices
Agile & Plan-Driven Development * Managing Projects & Teams * Testing & QA
Security * Process Improvement & Measurement * http://www.sqe.com/bsce5sf
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
