From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Thu, 22 Mar 2012 23:51:33 +0100
Message-ID: <20120322235133.269b74b8@stein>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	<20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	<20120322143959.GF19835@kroah.com>
	<CABE8wwtyxJaSfZREKRLDTZEef3nk=b+RFSe9i_UmV9knbQJ-tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwtyxJaSfZREKRLDTZEef3nk=b+RFSe9i_UmV9knbQJ-tg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mar 22 Williams, Dan J wrote:
> On Thu, Mar 22, 2012 at 7:39 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Mar 21, 2012 at 11:32:14PM -0700, Dan Williams wrote:
> [..]
> >> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> >> index 7fdf6a7..86521ee 100644
> >> --- a/fs/sysfs/dir.c
> >> +++ b/fs/sysfs/dir.c
> >> @@ -714,6 +714,9 @@ int sysfs_create_dir(struct kobject * kobj)
> >> =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 parent_sd =3D &sy=
sfs_root;
> >>
> >> + =C2=A0 =C2=A0 if (!parent_sd)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOENT;
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 if (sysfs_ns_type(parent_sd))
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ns =3D kobj->ktyp=
e->namespace(kobj);
> >> =C2=A0 =C2=A0 =C2=A0 type =3D sysfs_read_ns_type(kobj);
> >
> > So what happens if this is true? =C2=A0Does this patch fix the oops=
?
>=20
> This patch downgrades the oops by turning it into a device_add()
> failure, but the patches that *fix* this warning are here [1] and her=
e
> [2].
[...]
> [1]: http://marc.info/?l=3Dlinux-scsi&m=3D133239707903443&w=3D2
> [2]: http://marc.info/?l=3Dlinux-scsi&m=3D133239709603452&w=3D2

Isn't this something which is to be accomplished by counting references=
 to
the parent device?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D=3D-- --=3D=3D =3D-=3D=3D-
http://arcgraph.de/sr/
