From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 13:40:20 -0700 (PDT)
Message-ID: <20050821204020.80730.qmail@web51612.mail.yahoo.com>
Reply-To: luben_tuikov@adaptec.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751093AbVHUUnq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, luben_tuikov@adaptec.com
Cc: Andrew Morton <akpm@osdl.org>, Jim Houston <jim.houston@ccur.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

--- Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > However, there is an infrastructure in the block layer called the
> > generic tag infrastructure which was designed precisely for this purpose
> > and which is designed to operate in IRQ context.
> 
> James, I'm sure you're well aware that,
>    - a request_queue is LU-bound,
>    - a SCSI _transport_ (*ANY*) can _only_ address domain devices, but
>      _not_ LUs.  LUs are *not* seen on the domain.

Another thing very important to mention is that the layering
infrastructure should _not_ be broken, whereby LLDD are required
to use block layer tags.

First, there may not be one to one correspondence accross layers.

Second, a tag on a layer identifies that particular _layer_ object.
It should not be used across layers or across several layers:
Block->Scsi Core->LLDD.

Third, although SCSI task tags are a SAM concept, they are defined
by the protocol in use and generated and assigned by the Initiator
port.  The block layer is _not_ an Initiator port.  SCSI Core is
also _not_ an Initiator port.

SCSI Core should be impervious to task tags, i.e. to the Q in
I_T_L_Q nexus.  The Q is never visible to it.

      Luben
