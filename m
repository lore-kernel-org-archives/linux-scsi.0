From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [LSF/MM TOPIC] Target fabric module for SCSI para-virtualization
Date: Mon, 7 Feb 2011 11:06:33 +0000
Message-ID: <AANLkTikXXsF010TC9mh2JMimfOgQ+-3UK_o+V+Z8eo4X@mail.gmail.com>
References: <1297065435.13752.173.camel@haakon2.linux-iscsi.org>
	<4D4FC90E.60701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61835 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1BGLGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 06:06:34 -0500
Received: by gwj20 with SMTP id 20so1636810gwj.19
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2011 03:06:33 -0800 (PST)
In-Reply-To: <4D4FC90E.60701@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc@lists.linuxfoundation.org, linux-scsi <linux-scsi@vger.kernel.org>, Anthony Liguori <anthony@codemonkey.ws>, Christoph Hellwig <hch@lst.de>

On Mon, Feb 7, 2011 at 10:27 AM, Boaz Harrosh <openosd@gmail.com> wrote=
:
> On 02/07/2011 09:57 AM, Nicholas A. Bellinger wrote:
>> *) Guest OS specific para-virtualized SCSI driver packages (similar =
to
>> virtio-blk) performing SCSI I/O handoff into passthrough interface v=
ia
>> SCSI I_T nexues, with proper T10 WWN Port and LUN naming provided fr=
om
>> underlying TCM v4.x infrastructure =A0(eg: full compat w/ existing S=
PC-3
>> capable cluster clients)
>>
>
> I agree with the 2 above points on a better scsi-based Kernel-only
> passthrough code in the KVM host. But the 3rd point, could we not use=
d any
> one of the few LLDs that already exist? I think there are already 3 o=
f these,
> no? including the one Microsoft submitted.

It could be done either way but there are some unique properties of a
virtio-scsi HBA.

A virtio-scsi HBA can be implemented on the host as a vhost-scsi
in-kernel device (like vhost-net today).  That allows it to hand off
requests to the SCSI target without switching to userspace.  It can
interact directly with the TCM fabric module because it is in the
kernel, like TCM_Loop today.

The alternative is to emulate an existing HBA and that would be done
in QEMU userspace, at which point you need an interface to talk to the
SCSI target stack inside the kernel - this already exists today with
QEMU SCSI emulation and scsi-generic/BSG devices but is not the same
as fabric-level support.

Virtio is extensible and this has proven essential for evolving and
optimizing the I/O path.  If we choose an interface whose
specification we cannot modify, then we're stuck with its feature set
and performance limitations.

Guest support is important though, so it's worth looking more at
well-supported SCSI HBAs and see if there is a middle path to take.

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
