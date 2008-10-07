From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [ PATCH 2/4 ] mpt fusion disable hard resets for 53C1030 based devices
Date: Tue, 7 Oct 2008 19:09:52 +0200
Message-ID: <200810071909.53997.bs@q-leap.de>
References: <660360F4F2570145BD872F298951B17A5CA01BDD@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:57138 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYJGRKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 13:10:00 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A5CA01BDD@cosmail03.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Hello Eric, hello Sathya,

I am open to other ideas, of course. Here a few notes:

I didn't entirely remove the hard reset handler. It is only remove for 53C1030 
based chips. Though, I'm not entire sure, if struct _MPT_ADAPTER is 
initialized with zeros for FC and SAS cards. If not, we need to fix the patch 
to set ioc->no_hard_reset=0 on these. If you look at the patch, you will see 
one **needs** to set ioc->no_hard_reset=1 to disable the hard reset handler.
Furthermore, the hard resets are *only* disabled, when there is an alt_ioc 
with connected devices.
So I already tried my best not break other customers. If you think the tests 
still need to be extended, please tell me what needs to be done.

I guess you count the LSI22320R HBA as "multifunction card"? This is the card 
I wrote the patches for, since the way the hard reset handler destroys the 
operational state of the second port is simply not acceptable. Basically what 
happens is the following:

1) scsi error handler activates the fusion reset handler

2) The port of the LSI22320R which the hard reset handler was activated for 
recovers properly. However, now devices on the second port of this HBA 
suddenly fail with DID_SOFT_ERROR ==> Goto 1)

3) Eventually the chip is in such a bad state by a number of hard resets, that 
even the hard reset handler fails ==> devices on both ports are offlined

If you are 'luckily' the ping-pong of hard resets may last for hours, please 
see my messages to scsi list back in December. I have some generic (not yet 
posted) scsi-error patches here, which will at least limit the maximum number 
of failures within a given time frame and then offline the device.

Of course, it would be optimal to make the hard reset handler not to cause 
errors on the second port. If you have an idea how to archieve this, I 
absolutely open for this perfect solution.

Do you have an example of multifunction 53C1030 cards, of which you know the 
hard resets won't trouble? Working for a small mostly hardware selling 
company, I don't have the possibilty to test all of your hardware, but on the 
other hand I now tested the LSI22320R for weeks. And it definitely works 
better without the hardware reset handler...


Cheers,
Bernd



On Tuesday 07 October 2008 18:25:35 Moore, Eric wrote:
> Bernd -  No we can not remove the hard reset from the code.  Your going to
> break a whole lot of customers.    The hard reset is a "start of day" big
> hammer reset, where the controller firmware is reloaded.  The soft reset is
> not doing a 'start of day"reset, hence why its called soft reset. The soft
> reset will only reset a single function of the controller, and not effect
> the other function.   Firmware is not reloaded in the case of soft reset. 
> We have several multifunction cards like the 53c1030 ULTRA320 controller,
> and several in a line of the Fibre Channel Cards.   The soft reset added to
> address some problems with timeouts on one channel resulting in host reset
> being called, and when you did that it would kill all the IO on the other
> channel, resulting in timeouts on the other channel.   So adding the soft
> reset prevented the other channel from being effected.    In some cases the
> soft reset doesnt not recover the card, we need the bigg hammer to do a
> "start of day recovery" The  ioc->alt_ioc  pointer is used in the case of
> multifunction card, where one function is pointing to the other.  There are
> cases where we need to be aware of the other controller, for instanced some
> controllers require that firmware be uploaded into driver memory ,and when
> ever we unload the driver, we can only download the image back on one
> function (not both).
>
> Eric
>
> On Tuesday, October 07, 2008 4:56 AM, Prakash, Sathya wrote:
> > Eric,
> > I think this patch will create more trouble, can you please
> > send your thoughts on this at your free time. I strongly
> > believe that removing hard reset totally is a bad Idea.
> >
> > Thanks
> > Sathya
> >
> > -----Original Message-----
> > From: Bernd Schubert [mailto:bs@q-leap.de]
> > Sent: Monday, October 06, 2008 3:02 PM
> > To: Prakash, Sathya
> > Cc: Linux SCSI Mailing List; Moore, Eric; James Bottomley;
> > DL-MPT Fusion Linux
> > Subject: Re: [ PATCH 2/4 ] mpt fusion disable hard resets for
> > 53C1030 based devices
> >
> > Hello Sathya,
> >
> > On Monday 06 October 2008 11:07:00 Prakash, Sathya wrote:
> > > Hi Bernd,
> > > There are some cases where we MUST need hardreset for the
> >
> > firmware to
> >
> > > recover. So we can not completely avoid SoftReset, That is the main
> > > purpose of our design of first to try softreset and if it
> >
> > is failing
> >
> > > then to go for hard reset.
> > >
> > > So I would suggest it is better not to remove the hard
> >
> > reset. If you
> >
> > > think the latest LSI provided driver has some cases of
> >
> > avoiding hard
> >
> > > reset like the one in this patch. Please let me know I will
> >
> > check and revert back.
> >
> > yes I can understand that, however, it only skips the hard
> > reset, when it knows it will cause even more trouble than
> > without it. Primary rule really MUST be "Do not kill innocent
> > unrelated devices!".
> >
> > What are the requirements for a hard reset? When BOTH IOCs
> > are in trouble, a single hard reset wouldn't make the situation worse.
> > I didn't check yet and maybe you know immediately, is
> > ioc->alt_ioc a pointer to the real IOC structure? If so, we
> > could use it to check if this IOC also is in deep trouble.
> >
> >
> > Cheers,
> > Bernd
> >
> > > Thanks
> > > Sathya
> > >
> > >
> > > -----Original Message-----
> > > From: Bernd Schubert [mailto:bs@q-leap.de]
> > > Sent: Tuesday, September 23, 2008 7:00 PM
> > > To: Linux SCSI Mailing List
> > > Cc: Moore, Eric; Prakash, Sathya; James Bottomley; DL-MPT
> >
> > Fusion Linux
> >
> > > Subject: Re: [ PATCH 2/4 ] mpt fusion disable hard resets
> >
> > for 53C1030
> >
> > > based devices
> > >
> > > This is patch 2/4 ...
> > >
> > > On Tuesday 23 September 2008 15:26:30 Bernd Schubert wrote:
> > > > For 53C1030 based dual port HBAs the hard reset handler
> >
> > will cause
> >
> > > > trouble on the second channel with innocent devices. It is then
> > > > better to fail the device which activated the error
> >
> > handler than to
> >
> > > > fail cause errors on unrelated devices. Of course, the real
> > > > solutions would be to figure out why the hard reset handler cause
> > > > trouble on the second channel. Probably only LSI can do, though.
> > > >
> > > > Signed-off-by: Bernd Schubert <bs@q-leap.de>
> > > >
> > > >  drivers/message/fusion/mptbase.c |   42
> >
> > ++++++++++++++++++++++++++++-
> >
> > > >  drivers/message/fusion/mptspi.c  |   31 +++++++++++++++++++++
> > > >  2 files changed, 72 insertions(+), 1 deletion(-)
> > > >
> > > > Index: linux-2.6.26/drivers/message/fusion/mptbase.c
> >
> > ===================================================================
> >
> > > > --- linux-2.6.26.orig/drivers/message/fusion/mptbase.c
> > > > +++ linux-2.6.26/drivers/message/fusion/mptbase.c
> > > > @@ -59,6 +59,7 @@
> > > >  #include <linux/interrupt.h>         /* needed for
> >
> > in_interrupt() proto
> >
> > > > */ #include <linux/dma-mapping.h>
> > > >  #include <asm/io.h>
> > > > +#include <scsi/scsi_device.h>
> > > >  #ifdef CONFIG_MTRR
> > > >  #include <asm/mtrr.h>
> > > >  #endif
> > > > @@ -6452,6 +6453,33 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i  }
> > > >
> > > >  /**
> > > > +  * Check if there are devices connected to the second (alt) ioc.
> > > > +  * Return 1 if there is at least on device and 0 if there are
> > > > +  * none or no alt_ioc.
> > > > +  */
> > > > +static int
> > > > +alt_ioc_with_dev(MPT_ADAPTER *ioc)
> > > > +{
> > > > +     struct Scsi_Host        *shost;
> > > > +     struct scsi_device      *sdev;
> > > > +     int                     have_devices = 0;
> > > > +
> > > > +     if (!ioc->alt_ioc)
> > > > +             return 0;
> > > > +
> > > > +     shost = ioc->alt_ioc->sh;
> > > > +
> > > > +     shost_for_each_device(sdev, shost) {
> > > > +             /* when we are here, we know there is is a device
> > > > +              * attached to this host, which is all we
> >
> > need to know */
> >
> > > > +             have_devices = 1;
> > > > +             break;
> > > > +     }
> > > > +
> > > > +     return have_devices;
> > > > +}
> > > > +
> > > > +/**
> > > >   *   mpt_SoftHardResetHandler - Generic reset handler
> > > >   *   @ioc: Pointer to MPT_ADAPTER structure
> > > >   *   @sleepFlag: Indicates if sleep or schedule must be called.
> > > > @@ -6466,7 +6494,19 @@ mpt_SoftHardResetHandler(MPT_ADAPTER *io
> > > >
> > > >       rc = mpt_SoftResetHandler(ioc, sleepFlag);
> > > >       if (rc) {
> > > > -             rc = mpt_HardResetHandler(ioc, sleepFlag);
> > > > +             if (ioc->no_hard_reset && alt_ioc_with_dev(ioc)) {
> > > > +                     /* On dual port HBAs based on the
> >
> > 53C1030 chip the
> >
> > > > +                     * hard reset handler will cause
> >
> > DID_SOFT_ERROR on
> >
> > > > +                     * the second (in principle
> >
> > independent) port.
> >
> > > > +                     * Almost always this error cannot
> >
> > be recovered
> >
> > > > +                     * causing entire device failures.
> >
> > So it better not
> >
> > > > +                     * to call the hard reset handler at
> >
> > all in order to
> >
> > > > +                     * prevent failures of independent devices */
> > > > +                     printk(MYIOC_s_INFO_FMT "Skipping
> >
> > hard reset in "
> >
> > > > +                             "order to prevent failures
> >
> > on %s.\n",
> >
> > > > +                             ioc->name, ioc->alt_ioc->name);
> > > > +             } else
> > > > +                     rc = mpt_HardResetHandler(ioc, sleepFlag);
> > > >       }
> > > >
> > > >       return rc;
> > > > Index: linux-2.6.26/drivers/message/fusion/mptspi.c
> >
> > ===================================================================
> >
> > > > --- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
> > > > +++ linux-2.6.26/drivers/message/fusion/mptspi.c
> > > > @@ -1301,6 +1301,33 @@ mptspi_resume(struct pci_dev *pdev)  #endif
> > >
> > >/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> > >
> > > >-=-=
> > > >-= -=*/ +/**
> > > > +  * avoid_hard_reset - check if hard resets should be avoided
> > > > +  * @pdev: Pointer to pci_dev structure
> > > > +  *
> > > > +  * Hard resets will cause trouble on the the secondary IOC of
> > > > +  * 53C1030 based devices.
> > > > +  *
> > > > +  * Returns 1 if affected chip is found and 1 for
> >
> > unaffected chips
> >
> > > > +  */
> > > > +static int
> > > > +avoid_hard_reset(struct pci_dev *pdev) {
> > > > +     int avoid;
> > > > +
> > > > +     switch (pdev->device) {
> > > > +     case MPI_MANUFACTPAGE_DEVID_53C1030:
> > > > +     case MPI_MANUFACTPAGE_DEVID_53C1030ZC:
> > > > +             /* TODO: which chips are affected as well? */
> > > > +             avoid = 1;
> > > > +             break;
> > > > +     default:
> > > > +             avoid = 0;
> > > > +     }
> > > > +
> > > > +     return avoid;
> > > > +}
> > > > +
> > >
> > >/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> > >
> > > >-=-=
> > > >-= -=*/ /*
> > > >   *   mptspi_probe - Installs scsi devices per bus.
> > > > @@ -1509,6 +1536,10 @@ mptspi_probe(struct pci_dev *pdev, const
> > > >               goto out_mptspi_probe;
> > > >       }
> > > >
> > > > +     /* hard resets on 53C1030 HBAs will cause trouble on
> > > > + secondaray
> > > > (alt) +      * IOCs, so better no hard reset on these */
> > > > +     ioc->no_hard_reset = avoid_hard_reset(pdev);
> > > > +
> > > >       /*
> > > >        * issue internal bus reset
> > > >        */
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-scsi" in the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > > --
> > > Bernd Schubert
> > > Q-Leap Networks GmbH
> >
> > --
> > Bernd Schubert
> > Q-Leap Networks GmbH



-- 
Bernd Schubert
Q-Leap Networks GmbH
