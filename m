From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition
 devices
Date: Tue, 17 Jan 2012 12:03:17 -0800
Message-ID: <20120117200317.GA14237@kroah.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
 <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 14, 2012 at 03:43:01PM -0800, Linus Torvalds wrote:
> On Thu, Jan 12, 2012 at 7:01 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
> > + =A0 =A0 =A0 case CDROM_GET_CAPABILITY:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Keep this until we remove the prin=
tk below. =A0udev sends it
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* and we do not want to spam dmesg=
 about it. =A0 CD-ROMs do
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* not have partitions, so we get h=
ere only for disks.
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOIOCTLCMD;
>=20
> Looks like CDROMMULTISESSION is another of these.
>=20
> I get two of these:
>=20
>    mount: sending ioctl 5310 to a partition!
>=20
> with Fedora 14 whenever a USB stick is inserted (I changed your patch
> to also print the name of the program). Let's see if anything else
> pops up.
>=20
> Anyway, with the changes to print out warnings and still allow it for
> root, this all looked safe and nice, so they are in my tree now. I
> only noticed after applying them that you hadn't marked them with 'cc=
:
> stable@kernel.org', so we should probably point Greg at them. They ar=
e
> commits
>=20
>   577ebb374c78 block: add and use scsi_blk_cmd_ioctl
>   0bfc96cb7722 block: fail SCSI passthrough ioctls on partition devic=
es
>   ec8013beddd7 dm: do not forward ioctls from logical volumes to the
> underlying device
>=20
> in my tree now.

Thanks, I've queued them all up for the 3.2 and 3.0-stable trees.

greg k-h
