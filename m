From: Jack Suter <jack@suter.io>
Subject: Re: "hpsa: Change SAS transport devices to bus 0." commit breaks
 hpacucli on old controller firmware
Date: Thu, 17 Nov 2016 15:22:18 -0500
Message-ID: <1479414138.1169824.791372345.7E83C0B5@webmail.messagingengine.com>
References: <1477592113.812104.769415169.23FCE36A@webmail.messagingengine.com>
 <b73337d1-fd89-9310-5998-f62388028ef5@microsemi.com>
 <0dda89dd-ba20-6fbb-d4dd-1bb6601a4108@gmail.com>
 <f6b163ab-29ca-a9f2-6eef-2d6aec03fd02@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39557 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752346AbcKQUWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 15:22:20 -0500
In-Reply-To: <f6b163ab-29ca-a9f2-6eef-2d6aec03fd02@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, brace77070@gmail.com
Cc: iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, scott.teel@microsemi.com, kevin.barnett@microsemi.com, thenzl@redhat.com

Thanks from me as well for the patch. I've tested it on the problematic
controller and it appears to be working. The hpsa driver isn't throwing
any errors and hpacucli works as expected.

Cheers,

Jack Suter

On Thu, Nov 17, 2016, at 06:17, Hannes Reinecke wrote:
> On 11/16/2016 05:09 PM, brace77070@gmail.com wrote:
> > On 10/31/2016 02:06 PM, Don Brace wrote:
> >> On 10/27/2016 01:15 PM, Jack Suter wrote:
> >>> Hi there,
> >>>
> >>> Commit "hpsa: Change SAS transport devices to bus 0."
> >>> (09371d623c9c3dc6ed7f53ec8ab01d25f0c6c697) breaks the hpacucli utility
> >>> for some HP Smart Array controllers with old firmware.
> >>>
> >>> Specifically, I have a P410 connected to an HP DL180 G6 running firmw=
are
> >>> version 1.66. Yes, the firmware is old, but it works. On the 4.4 seri=
es
> >>> kernels and earlier, hpacucli works with no trouble. On 4.5 and later,
> >>> the hpsa driver reports errors  in the kernel log, and hpacucli repor=
ts
> >>> "Error: No controllers detected."
> >>>
> >>> Oct 27 15:50:30 hostname kernel: [   32.189495] hpsa 0000:06:00.0: sc=
si
> >>> 0:0:0:0: added RAID              HP       P410 controller
> >>> SSDSmartPathCap- En- Exp=3D1
> >>> Oct 27 15:50:30 hostname kernel: [   32.190054] hpsa 0000:06:00.0:
> >>> addition failed -19, device not added.
> >>>
> >>> Reverting the above commit resolves both the hpsa errors and the
> >>> hpacucli error when tested with kernel 4.7.9.
> >>>
> >>> In addition to this troublesome server, I have a handful of servers w=
ith
> >>> P410 controllers and firmware versions ranging from 3.52 to 6.60. All=
 of
> >>> them work with the 09371d62 commit in place, which leads me to believe
> >>> it is just this old 1.66 firmware that is incompatible.
> >>>
> >>> While a firmware upgrade seems like the simple solution, I think this
> >>> should be considered a bug/regression due to it breaking functionality
> >>> that previously worked. It appears others may have run into this issue
> >>> too:
> >>> http://superuser.com/questions/1093124/coreos-hp410-raid1-device-not-=
added-19
> >>>
> >>>
> >>> Some dmesg output (grep -e hpsa -e sg) is below from both a 4.4.2 ker=
nel
> >>> (working) and 4.5.7 kernel (broken). Note the change in SCSI address
> >>> from 0:3:0:0 to 0:0:0:0.
> >>>
> >>> Please let me know if you need me to do any testing to help resolve
> >>> this.
> >>>
> >>> Jack Suter
> >> I discussed this with the ssacli developers and they do not look
> >> at the bus, but I see "device not added" messages that
> >> should not be there. I'll attack your issue from that
> >> perspective.
> >>
> >> Thanks,
> >> Don Brace
> >=20
> > The root cause is that this older firmware is not scsi revision 5 and
> > thus we add the
> > controller at the end of the list, not at the beginning.
> >=20
> >         if (is_scsi_rev_5(h))
> >                 raid_ctlr_position =3D 0;
> >         else
> >                 raid_ctlr_position =3D nphysicals + nlogicals;
> >=20
> > So the first logical volume gets BTL 0:0:0 and then we attempt to add in
> > the controller
> > using the same BTL values at the end of the list. Thus you get the
> > "device not added" messages.
> >=20
> > The change to bus 0 was because the SAS transport is using bus 0 and
> > there was a
> > discrepancy in what the driver was putting the controller on and what
> > the SAS
> > transport was actually using.
> >=20
> > I'll work on a patch to resolve this for you.
> >=20
> One can resolve this issue with checking the SCSI revision of the
> controller, and move every controller with revision '0' to bus 3.
> That solved the issue for me.
>=20
> Patch posted in a different mail.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
