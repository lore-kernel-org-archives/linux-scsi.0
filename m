From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 11:13:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906161111170.3740-100000@iolanthe.rowland.org>
References: <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7aae30906160635g4d191a4exdb710554a349cac0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 16 Jun 2009, Ramya Desai wrote:

> If I call void (*done)(struct scsi_cmnd *) call back immediately after
> receiving a command, will I get another command ?

You MUST NOT do that!  Never call (*done)() until the scsi_cmnd is 
actually complete.  That's what it's for -- to tell the SCSI midlayer 
that the command has been carried out.

Can you post your code for queuecommand()?  That's probably where the
real problem is.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
