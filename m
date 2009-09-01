From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 18:34:30 +0200
Message-ID: <e2e108260909010934k7be05930lfa544ea914224cf1@mail.gmail.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
	 <adaws4iod8k.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932085AbZIAQeb@vger.kernel.org>
In-Reply-To: <adaws4iod8k.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 1, 2009 at 6:12 PM, Roland Dreier <rdreier@cisco.com> wrote=
:
> =A0> - Reuse the ib_ipoib kernel module to provide an IP stack on top=
 of
> =A0> the new RDMA driver instead of having to maintain a separate net=
work
> =A0> driver for this hardware (ibmveth).
>
> I don't think this really makes sense, because IPoIB is not really
> handling ethernet (it is a different L2 ethernet encapsulation), and =
I
> think the commonality with ibmveth is going to be minimal.

What I had in mind was not to start searching for code shared between
the ipoib and ibmveth kernel modules, but to replace the virtual
Ethernet layer by IPoIB on top of a new RDMA driver. I'm not sure
however this approach would work better than the currently implemented
approach in ibmveth.

> I'm not really sure we should be trying to force drivers to share jus=
t
> because they are paravirtualized -- if there is real commonality, the=
n
> sure put it in common code, but different hypervisors are probably as
> different as different hardware.

Agreed. But several people are currently looking at how to improve the
performance of I/O performed inside a virtual machine without being
familiar with the VIA architecture or the RDMA API. This is a pity
because the Virtual Interface Architecture was designed to allow
high-throughput low-latency I/O, and has some features that are not
present in any other mainstream I/O architecture I know of (e.g. the
ability to perform I/O from userspace without having to invoke any
system call in the performance-critical path).

Bart.
