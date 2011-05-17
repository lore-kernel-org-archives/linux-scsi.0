From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] isci merge candidate
Date: Mon, 16 May 2011 17:39:26 -0700
Message-ID: <BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
References: <1305317680.21099.83.camel@dwillia2-linux>
	<BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
	<4DCDA663.2040202@intel.com>
	<1305324962.2781.5.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305324962.2781.5.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 13, 2011 at 3:16 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> It's a SAS (serial-attached-scsi) driver so it ties in to libsas rat=
her
>> than libata (libsas itself ties in to libata for tunnelling SATA
>> protocol over SAS). =A0The size is attributable to the fact that all
>> protocol handling for non-fast path i/o is handled by software. =A0T=
here
>> are still cleanups that can be made, but likely not on the on the sa=
me
>> order of what we have already done.
>
> How much of that non-fast-path could/should be in generic code vs. in
> the driver specific code ? IE. If somebody comes up with another "dum=
b"

I prefer the word "thin" :-), where "fat" refers to controllers that
hide this logic in offload cpu's, firmware, and or custom asics.

> SAS adapter tomorrow that doesn't do all that magic in an offload CPU=
,
> is any of that code re-usable ?

At a minimum It would require a more verbose interface to
libsas/libata (or new libframe?) to allow us to deliver raw
unsolicited frames into common protocol handlers.  The concern would
be wrangling different sets of protocol states and exception
conditions that individual vendors would choose to/not to offload.  To
date no other libsas based controller has taken this approach.

--
Dan
