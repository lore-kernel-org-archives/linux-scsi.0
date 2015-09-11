From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/2] mpt3sas: Refcount sas_device objects and fix
 unsafe list usage
Date: Thu, 10 Sep 2015 23:55:37 -0700
Message-ID: <1441954537.21634.21.camel@haakon3.risingtidesystems.com>
References: <1440921279-9973-1-git-send-email-nab@daterainc.com>
	 <1440921279-9973-2-git-send-email-nab@daterainc.com>
	 <CAK=zhgrTpxiiEbHCvLL09EhyLq+xAdteMU1Gzd3jPg9UGo=BDA@mail.gmail.com>
	 <e0bde29b9384f924b2868cd81b7b1c8d@mail.gmail.com>
	 <1441836181.6836.4.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441836181.6836.4.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@avagotech.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>, kernel-team <kernel-team@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-09-09 at 15:03 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-09-09 at 19:59 +0530, Chaitra Basappa wrote:
> > From: Sreekanth Reddy [mailto:sreekanth.reddy@avagotech.com]
> > Sent: Tuesday, September 08, 2015 5:26 PM
> > To: Nicholas A. Bellinger
> > Cc: linux-scsi; linux-kernel; James Bottomley; Calvin Owens; Christoph
> > Hellwig; MPT-FusionLinux.pdl; kernel-team; Nicholas Bellinger; Chaitra
> > Basappa
> > Subject: Re: [PATCH-v2 1/2] mpt3sas: Refcount sas_device objects and fix
> > unsafe list usage
> > 
> > On Sun, Aug 30, 2015 at 1:24 PM, Nicholas A. Bellinger <nab@daterainc.com>
> > wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > >
> > > These objects can be referenced concurrently throughout the driver, we
> > > need a way to make sure threads can't delete them out from under each
> > > other. This patch adds the refcount, and refactors the code to use it.
> > >
> > > Additionally, we cannot iterate over the sas_device_list without
> > > holding the lock, or we risk corrupting random memory if items are
> > > added or deleted as we iterate. This patch refactors
> > > _scsih_probe_sas() to use the sas_device_list in a safe way.
> > >
> > > This patch is a port of Calvin's PATCH-v4 for mpt2sas code, atop
> > > mpt3sas changes in scsi.git/for-next.
> > >
> > > Cc: Calvin Owens <calvinowens@fb.com>
> > > Cc: Christoph Hellwig <hch@infradead.org>
> > > Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> > > Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
> > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > ---
> > >  drivers/scsi/mpt3sas/mpt3sas_base.h      |  25 +-
> > >  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 479
> > > +++++++++++++++++++++----------
> > >  drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
> > >  3 files changed, 364 insertions(+), 158 deletions(-)
> > >
> > > @@ -2763,7 +2874,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc,
> > > u16 handle)
> > >         struct scsi_device *sdev;
> > >         struct _sas_device *sas_device;
> > >
> > 
> > [Sreekanth] Here sas_device_lock spin lock needs to be acquired before
> > calling
> >                   __mpt3sas_get_sdev_by_addr() function.
> > 
> > [Chaitra]Here instead of calling " __mpt3sas_get_sdev_by_handle()" function
> > calling
> > 	"mpt3sas_get_sdev_by_handle()" function will fixes "invalid page access"
> > type of kernel panic
> > 
> > > -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> > > +       sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
> > >         if (!sas_device)
> > >                 return;
> > >
> 
> Whoops, missed this comment in _scsih_block_io_device() from Sreekanth's
> earlier reply.
> 
> Here's the updated incremental patch atop target-pending/for-next-merge
> to use the protected callers for both cases.
> 
> Please review + ACK ASAP.

The mpt3sas -v2 series + v4.3-rc0 breakage incremental patch here made
it into linux-next-09102015, and at this point I don't see a scenario
where keeping around the broken list_head dereferences makes sense.

So that said, I'd like to send a target-pending/for-next-merge PULL
request out to Linus in the next 48 hours.

Any objections from Avago folks..?

Thank you,

--nab
