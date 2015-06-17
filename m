From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: optimal io size / custom alignment
Date: Wed, 17 Jun 2015 17:49:51 +0800
Message-ID: <CAGnHSEnMgivXU_0gDaOkHFkbc=Ve8PaPR0ho8+VhdcUuNu89Gw@mail.gmail.com>
References: <CAGnHSE=gtd2WVcxOBoyfqnp3QtT4RHfK356GHastBbiK5mtmFA@mail.gmail.com>
	<20150615133154.GV1992@ws.net.home>
	<CAGnHSEm6wDq_EjJXYwqV2Tt2868DbR0bNRYvevhN1AM4qJpaPw@mail.gmail.com>
	<yq1zj3zfuna.fsf@sermon.lab.mkp.net>
	<CAGnHSEkBXevNmrL7NFO=nKekZdZE6KtzjGvA8sM=onjUfd8KHQ@mail.gmail.com>
	<yq1d20vfimj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1d20vfimj.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 17 June 2015 at 05:28, Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> There are plenty of SSDs that report 4K physical sectors, fwiw.

Oh didn't know that. Wonder if it's yet another garbage info. Though
4k is often a nice value to make use of.

> We gave up on USB-SATA bridges long ago. Their designers appear to have
> a pretty comprehensive misunderstanding of both the ATA and SCSI
> protocols.

Aren't there tons of thumb drives make use of it anyway?

> Tom> I just feel like the kernel shouldn't bind values from totally
> Tom> different source (raid stripe vs vpd limit) to the same variable.
>
> RAID devices communicate the stripe width through the Block Limits VPD.

No I put it in the wrong way. What I meant was "sd vs md". For
example, couldn't the scsi disk driver bind the value it reads from
the VPD to another variable instead of "optimal i/o size", so that
this value would be exclusively for RAID (and other virtual devices)?
Is it even necessary for it to report? Because it seems only to make
this variable ambiguous.

If it HAS TO BE ambiguous, I see no reason why fdisk should use it to
derive the alignment. It should simply let the users do their
judgement and provide a way for them to adjust manually.
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
