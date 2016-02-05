From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/6] ibmvscsi: Remove unsupported host config MAD and
 sysfs interface
Date: Fri, 5 Feb 2016 09:34:13 +0100
Message-ID: <20160205083413.GF27969@c203.arch.suse.de>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-6-git-send-email-tyreld@linux.vnet.ibm.com>
 <20160204080317.GT27969@c203.arch.suse.de>
 <56B38EE7.6060102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B38EE7.6060102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, linux-kernel@vger.kernel.org, hare@suse.de, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 04, 2016 at 09:48:23AM -0800, Tyrel Datwyler wrote:
> On 02/04/2016 12:03 AM, Johannes Thumshirn wrote:
> > On Wed, Feb 03, 2016 at 05:28:33PM -0600, Tyrel Datwyler wrote:
> >> A VIOSRP_HOST_CONFIG_TYPE management datagram (MAD) has existed in
> >> the code for some time. From what information I've gathered from
> >> Brian King this was likely implemented on the host side in a SLES =
9
> >> based VIOS, which is no longer supported anywhere. Further, it is
> >> not defined in PAPR or supported by any AIX based VIOS.
> >>
> >> Treating as bit rot and removing the sysfs interface and associate=
d
> >> host config code accordingly.
> >=20
> > Doesn't removing a sysfs interface potentially break userspace code=
?
> >=20
>=20
> In the general case yes, but I feel in this case no. First, Reading f=
rom
> this config attribute of a vscsi host adapter always returns nothing.
> Second, any userspace code using this attribute better be checking fo=
r
> the existence of config. Just a quick look for
> /sys/class/scsi_host/host*/config under other host adapters on my sys=
tem
> I find that attribute doesn't exist for any of them.
>=20
> If there is truly enough concern that somebody may actually be access=
ing
> this useless attribute from userspace then we can still strip out the
> unsupported code, but leave the attribute and return nothing directly
> from the show function.

Which is what I kinda prefer. Slowly deprecate and phase out, but don't=
 break
userspace. You never know who is writing some obscure piece of code rel=
aying on
some sysfs attribute.

Thanks,
	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
