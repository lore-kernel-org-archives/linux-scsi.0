From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 17 Feb 2003 11:51:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217115121.A371@beaverton.ibm.com>
References: <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217193737.GB1990@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Feb 17, 2003 at 11:37:37AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Feb 17, 2003 at 11:37:37AM -0800, Mike Anderson wrote:
> 
> The scsi_set_device_offline interface is part of the last patch (scsi
> error) I sent to linux-scsi. I updated my patch post some comments from
> the list, but I am working on issue with the patch before I resend.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com

One point with the interface - can we have a bit higher level interface
based on what has happened to the adapter, so that if scsi wants to behave
differently in the future the interface need not change?

That is, have an exported scsi_host_removed(struct scsi_host *shost) versus
a scsi_set_device_offline(struct scsi_device *sdev)?

scsi_host_removed can offline all sdev's etc. for now, and if we ever want
to change data structure layouts or the behaviour in the future (i.e. allow
surprise removal/replacement of the same storage without forcing removal
of a scsi_device) the interface need not change.

-- Patrick Mansfield
