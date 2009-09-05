From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 14118] New: USB storage: "No sense [current]"
 when connecting
Date: Sat, 5 Sep 2009 17:18:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0909051705350.6891-100000@netrider.rowland.org>
References: <20090905135342.002b40b4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090905135342.002b40b4.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mantas =?UTF-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 5 Sep 2009, Andrew Morton wrote:

> OK, I reassigned it to scsi, but I expect it would help the scsi guys
> if someone could add a new summary of what they think the actual bug is.

Okay, here's a quick summary.  This USB mass storage device has a bug: 
It doesn't like to access the last 16 or so sectors of LUN 0.  When 
asked to read from those sectors it returns no data and Check Condition 
set.  Then in response to REQUEST SENSE it returns no information 
(SK=0, ASC=ASCQ=0).

This causes the SCSI midlayer to reissue the read request, with the 
same result.  We enter an unending loop because each READ is a new 
request with a new timeout.  That's the real problem -- the bug in the 
phone wouldn't matter much if SCSI would just give up and fail the READ 
after a couple of retries.

There are a few more details in comment #4.  Note that recently people
have been encountering more and more devices with this same kind of bug
(READ fails, REQUEST SENSE returns nothing).

My suggestion for a fix: Don't call scsi_requeue_command() if the 
current command made zero forward progress.  But this will have to be 
elaborated and made reliable.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
