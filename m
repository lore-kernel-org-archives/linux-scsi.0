From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 15:45:36 -0700
Message-ID: <1342651536.18004.702.camel@haakon2.linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	 <20120717150548.GA11587@redhat.com>  <5005B52E.20509@us.ibm.com>
	 <1342561819.18004.470.camel@haakon2.linux-iscsi.org>
	 <5006BD3D.7090104@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36870 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2GRWpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2012 18:45:39 -0400
In-Reply-To: <5006BD3D.7090104@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>

On Wed, 2012-07-18 at 08:42 -0500, Anthony Liguori wrote:
> On 07/17/2012 04:50 PM, Nicholas A. Bellinger wrote:
> > On Tue, 2012-07-17 at 13:55 -0500, Anthony Liguori wrote:
> >> On 07/17/2012 10:05 AM, Michael S. Tsirkin wrote:
> >>> On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger w=
rote:
> >

<SNIP>

> >
> >> But I do think the kernel should carefully consider whether it wan=
ts to support
> >> an interface like this.  This an extremely complicated ABI with a =
lot of subtle
> >> details around state and compatibility.
> >>
> >> Are you absolutely confident that you can support a userspace appl=
ication that
> >> expects to get exactly the same response from all possible command=
s in 20 kernel
> >> versions from now?  Virtualization requires absolutely precise com=
patibility in
> >> terms of bugs and features.  This is probably not something the TC=
M stack has
> >> had to consider yet.
> >>
> >
> > We most certainly have thought about long term userspace compatibil=
ity
> > with TCM.  Our userspace code (that's now available in all major
> > distros) is completely forward-compatible with new fabric modules s=
uch
> > as tcm_vhost.  No update required.
>=20
> I'm not sure we're talking about the same thing when we say compatibi=
lity.
>=20
> I'm not talking about the API.  I'm talking about the behavior of the=
 commands=20
> that tcm_vhost supports.
>=20

OK, I understand what your getting at now..

> If you add support for a new command, you need to provide userspace a=
 way to=20
> disable this command.  If you change what gets reported for VPD, you =
need to=20
> provide userspace a way to make VPD look like what it did in a previo=
us version.
>=20
> Basically, you need to be able to make a TCM device behave 100% the s=
ame as it=20
> did in an older version of the kernel.
>=20
> This is unique to virtualization due to live migration.  If you migra=
te from a=20
> 3.6 kernel to a 3.8 kernel, you need to make sure that the 3.8 kernel=
's TCM=20
> device behaves exactly like the 3.6 kernel because the guest that is =
interacting=20
> with it does not realize that live migration happened.
>=20
> Yes, you can add knobs via configfs to control this behavior, but I t=
hink the=20
> question is, what's the plan for this?
>=20

So we already allow for some types of CDBs emulation to be toggled via
backend device attributes:

root@tifa:/usr/src/target-pending.git# tree /sys/kernel/config/target/c=
ore/iblock_2/fioa/attrib/
/sys/kernel/config/target/core/iblock_2/fioa/attrib/
=E2=94=9C=E2=94=80=E2=94=80 block_size
=E2=94=9C=E2=94=80=E2=94=80 emulate_dpo
=E2=94=9C=E2=94=80=E2=94=80 emulate_fua_read
=E2=94=9C=E2=94=80=E2=94=80 emulate_fua_write
=E2=94=9C=E2=94=80=E2=94=80 emulate_rest_reord
=E2=94=9C=E2=94=80=E2=94=80 emulate_tas
=E2=94=9C=E2=94=80=E2=94=80 emulate_tpu
=E2=94=9C=E2=94=80=E2=94=80 emulate_tpws
=E2=94=9C=E2=94=80=E2=94=80 emulate_ua_intlck_ctrl
=E2=94=9C=E2=94=80=E2=94=80 emulate_write_cache
=E2=94=9C=E2=94=80=E2=94=80 enforce_pr_isids

<SNIP>

Some things like SPC-3 persistent reservations + implict/explict ALUA
multipath currently can't be disabled, but adding two more backend
attributes to disable/enable this logic individual is easy enough to do=
=2E

So that said, I don't have a problem with adding the necessary device
attributes to limit what type of CDBs a backend device is capable of
processing.

Trying to limiting this per-guest (instead of per-device) is where
things get a little more tricky..

> BTW, I think this is a good thing to cover in Documentation/vhost/tcm=
_vhost.txt.=20
>   I think that's probably the only change that's needed here.
>=20

Sure, but I'll need to know what else that you'd like to optionally
restrict it terms of CDB processing that's not already there..

Thanks for your feedback!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
