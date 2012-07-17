From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RESEND 0/3] scsi: fix internal write cache issue on usb
 hdd.
Date: Tue, 17 Jul 2012 08:19:14 +0100
Message-ID: <1342509554.3039.4.camel@dabdike.int.hansenpartnership.com>
References: <1341716685-6631-1-git-send-email-linkinjeon@gmail.com>
	 <20120716234805.GA9875@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120716234805.GA9875-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 16:48 -0700, Greg KH wrote:
> On Sat, Jul 07, 2012 at 11:04:45PM -0400, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > 
> > The numbers of USB HDDs(All USB HDD I checked) does not respond
> > correctly to scsi mode sense command for retrieving the write cache
> > page status. Even though write cache is enabled by default, due to
> > scsi driver assume that cache is not enabled which in turn might lead
> > to loss of data since data still will be in cache.
> > This result that all filesystems is not stable on USB HDD when the
> > device is unplugged abruptly, even though these are having journaling
> > feature. Our first trying is that scsi driver send ATA command
> > (ATA Pass through, #85) to USB HDD after failure from normal routine to
> > know write cache enable.
> > We have known it is dangerous after testing several USB HDD. some of
> > HDD is stalled by this command(A-DATA HDD). So we tried to make the
> > patch James Bottomley's suggestion(usb quirk) on version 2 that add
> > product ID and verdor ID of USB HDD to USB quirk list after checking
> > write cache.
> > All filesystem will be stable on USB HDD registered in quirk list.
> > And it will be updated continuously.
> 
> Now applied to the usb-next branch.

It's been in scsi#misc for ten days with no problems.  Lets leave it
there rather than create merge and rebase issues.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
