From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Wed, 13 Apr 2011 19:18:10 -0700
Message-ID: <20110414021810.GA13436@kroah.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
 <20110405161400.GA885@kroah.com>
 <4D9F17DF.5030601@hitachi.com>
 <4D9F1CD1.2020600@suse.de>
 <4DA656A9.8040609@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DA656A9.8040609@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2011 at 11:06:33AM +0900, Nao Nishijima wrote:
> Hi Hannes
>=20
> (2011/04/08 23:33), Hannes Reinecke wrote:
> > On 04/08/2011 07:12 AM, Nao Nishijima wrote:
> >> Hi,
> >>
> >> (2011/04/06 1:14), Greg KH wrote:
> >>> On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
> >>>> This patch series provides a SCSI option for persistent device
> >>>> names in kernel. With this option, user can always assign a
> >>>> same device name (e.g. sda) to a specific device according to
> >>>> udev rules and device id.
> >>>>
> >>>> Issue:
> >>>> Recently, kernel registers block devices in parallel. As a resul=
t,
> >>>> different device names will be assigned at each boot time. This
> >>>> will confuse file-system mounter, thus we usually use persistent
> >>>> symbolic links provided by udev.
> >>>
> >>> Yes, that is what you should use if you care about this.
> >>>
> >>>> However, dmesg and procfs outputs
> >>>> show device names instead of the symbolic link names. This cause=
s
> >>>> a serious problem when managing multiple devices (e.g. on a
> >>>> large-scale storage), because usually, device errors are output
> >>>> with device names on dmesg.
> >>>
> >>> Then fix your tools that read the output of these files to point =
to the
> >>> proper persistent name instead of trying to get the kernel to sol=
ve the
> >>> problem.
> >>>
> >>
> >> Yes, the tools should be revised if users get a device name using =
them.
> >>
> >> The problem I would like to discuss here is that users can not ide=
ntify
> >> a disk from kernel messages when they DIRECTLY refer to these mess=
ages.
> >> For example, a device name is used instead of a symbolic link name=
s in
> >> bootup messages, I/O devices errors and /proc/partitions =E2=80=A6=
etc.
> >>
> >> In particular, users can not identify an appropriate device from a
> >> device name in syslog since different device name may be assigned =
to it
> >> at each boot time.
> >>
> >> My idea is able to fix this issue with small changes in scsi subsy=
stem.
> >> Also, it is implemented as an option. Therefore, it does not affec=
t
> >> users who do not select this option.
> >>
> > We have been discussing this problem several times in the past, and
> > indeed on these very mailing list.
> >=20
> > The conclusion we arrived at is that the kernel-provided device nod=
e
> > name is inherently unstable and impossible to fix within the existi=
ng
> > 'sdX' naming scheme.
> > So the choices have been to either move to a totally different nami=
ng
> > scheme or keep the naming scheme and provide the required informati=
on
> > by other means.
> > We have decided on the latter, and agreed on using udev to provide
> > persistent device names.
>=20
> Could you tell me why you chose the latter?
>=20
>=20
> > We are fully aware that any kernel related messages are subject to
> > chance after reboot, but then most kernel related messages are
> > (PID number, timestamps, login tty etc).
> > And also we are aware that any kernel messages need to be matched
> > against the current system layout to figure out any hardware-relate=
d
> > issue.
> >=20
> > But then basically all products requiring to filter out information
> > from kernel messages already do so I don't see a problem with that.
> >=20
>=20
> All users did not always use the products. Users can see directly
> kernel messages (dmesg, /proc/partitions). Therefore I think that
> kernel messages need to provide the required mapping.

No they don't.  Anyone who wants to look at those files "knows" what
they are doing and the kernel name is fine to use.

thanks,

greg k-h
