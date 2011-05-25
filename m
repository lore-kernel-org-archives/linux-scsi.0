From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 16:18:23 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty> <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1306062530-1306354710=:8972"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1306062530-1306354710=:8972
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 25 May 2011, Linus Torvalds wrote:

> On Wed, May 25, 2011 at 12:52 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >
> > +static inline int sdev_early_check(struct scsi_device *sdev)
> > +{
> > +       if (!sdev || sdev->sdev_state == SDEV_DEL
> > +               || sdev->sdev_state > SDEV_QUIESCE)
> > +               return -ENXIO;
> > +       return 0;
> > +}
> 
> Can somebody explain why it's those states, and nothing else?
> 
> Quite frankly, if it's about "don't oops on sdev->queue not existing",
> then test for that. Not for some random and uncommented list of
> states.

List of states and what commands if any are accepeted for each state are 
explained in scsi_device.h enum definition of scsi_device_state : 

enum scsi_device_state {
        SDEV_CREATED = 1,       /* device created but not added to sysfs
                                 * Only internal commands allowed (for 
inq) */
        SDEV_RUNNING,           /* device properly configured
                                 * All commands allowed */
        SDEV_CANCEL,            /* beginning to delete device
                                 * Only error handler commands allowed */
        SDEV_DEL,               /* device deleted 
                                 * no commands allowed */
        SDEV_QUIESCE,           /* Device quiescent.  No block commands
                                 * will be accepted, only specials (which
                                 * originate in the mid-layer) */
        SDEV_OFFLINE,           /* Device offlined (by error handling or
                                 * user request */
        SDEV_BLOCK,             /* Device blocked by scsi lld.  No
                                 * scsi commands from user or midlayer
                                 * should be issued to the scsi
                                 * lld. */
        SDEV_CREATED_BLOCK,     /* same as above but for created devices 
*/
};

In this case - we check for cases where no commands are allowed and reject 
those right away, leaving prep_state_check to do filtering at lower level 
for which commands are allowed and which are not as the state permits.
 
Parag
--8323329-1306062530-1306354710=:8972--
