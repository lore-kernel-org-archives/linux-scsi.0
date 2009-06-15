From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 10:40:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906151038050.5057-100000@iolanthe.rowland.org>
References: <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7aae30906150707we781237o366950971d748b6f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2009, Ramya Desai wrote:

> I already have an array length of 10 for the bellow members.
>        struct scsi_cmnd        *srb;            /* current srb         */
>        unsigned int            tag;              /* current dCBWTag     */
> 
> I am maintaining an internal queue for the commands.
> My main problem is , I am not getting the next command in my USB
> storage driver ( My custom) , until the first command is done.

When you say "first command", do you mean the _very first_ command sent 
to the device (an INQUIRY command)?  Or are referring to READ(10) 
commands in general?

> How can I get the next command, while processing the first command?

You can't.  Linux never sends any other commands to a SCSI device until
the first INQUIRY is complete.

But you should be getting multiple READ(10) commands.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
