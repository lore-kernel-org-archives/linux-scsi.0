From: Alok Kataria <alokkataria1@gmail.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 09:08:48 -0700
Message-ID: <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <1251755593.16169.51.camel@ank32.eng.vmware.com>
	 <1251815012.3864.55.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f188.google.com ([209.85.211.188]:55617 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZIAQIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:08:46 -0400
In-Reply-To: <1251815012.3864.55.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>

Hi James,

On Tue, Sep 1, 2009 at 7:23 AM, James Bottomley<James.Bottomley@suse.de=
> wrote:
> On Mon, 2009-08-31 at 14:53 -0700, Alok Kataria wrote:
>> Hi James,
>>
>> Thanks for your comments.
>>
>> On Mon, 2009-08-31 at 11:00 -0700, James Bottomley wrote:
>> > On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
>> > > VMware PVSCSI driver - v2.
>> >
>> > OK, so the first thing that springs to mind is that we already hav=
e one
>> > of these things: the ibmvscsi ... is there no way we can share cod=
e
>> > between this and the other PV drivers?
>>
>> I took a quick look at the ibmvscsi driver, and there are lot of
>> differences between the two, mainly the ABI that is shared between t=
he
>> hypervisor and driver differ.
>
> Well, that's pretty abstractable, surely? =A0However, there is an
> interesting question of what the best hypervisor interface actually i=
s.
>
>> =A0Also the ibmvscsi driver seems to offer a
>> lot of other features as well, like the SRP.
>
> SRP is the protocol transfer abstraction. =A0It's just a way of packa=
ging
> up SCSI commands for transfer over a DMA protocol (OK, so it was
> envisaged that the DMA protocol would be RDMA, but a hypervisor
> interface is also a DMA protocol).
>
>> The pvscsi driver is a simple SCSI adapter driver and is basically n=
o
>> different than any other SCSI driver written for a particular HBA.
>
> Well, it is really ... hopefully all the hypervisor interfaces won't
> decide to be completely incompatible, so there's a good chance of cod=
e
> sharing between them.

Well, going by that theory every SCSI driver can share some code with
any other SCSI driver, In short we can come up with an low level SCSI
driver interface which every SCSI driver can make use of, to reduce
code duplicity.  We don't do that, and the reason being, that its a
device and we shouldn't expect every device to share common features
or design decisions.

We already virtualize storage at the lowest (read device) level to
avoid duplicating stuff in a guest operating system.
If this was say a block level virtaulizing scheme sharing would be
more eminent, but given that we are a device its better to keep things
separate and IMHO, it might be an overkill to design a new pv-driver
or some such layer for every device that you virtualize.

Thanks,
Alok



>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
