From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2 00/13] mpt3sas driver NVMe support:
Date: Mon, 7 Aug 2017 20:01:52 +0530
Message-ID: <da1e0ded0c7d4bab1cfa0850488c8fb7@mail.gmail.com>
References: <1500038560-11231-1-git-send-email-suganath-prabu.subramani@broadcom.com>
         <e679a449-90c3-d2e1-2b31-1387cf414e09@suse.de>   <20170805135353.GA7526@infradead.org>
         <1501944129.3649.9.camel@HansenPartnership.com>         <0ada8680ebfeb026662d858ec2b38ef4@mail.gmail.com>
 <1502115492.2841.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502115492.2841.20.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Monday, August 07, 2017 7:48 PM
> To: Kashyap Desai; Christoph Hellwig; Hannes Reinecke
> Cc: Suganath Prabu Subramani; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Sathya Prakash Veerichetty; linux-
> kernel@vger.kernel.org; Chaitra Basappa; Sreekanth Reddy; linux-
> nvme@lists.infradead.org
> Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
>
> On Mon, 2017-08-07 at 19:26 +0530, Kashyap Desai wrote:
> > >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com
> > > ]
> > > Sent: Saturday, August 05, 2017 8:12 PM
> > > To: Christoph Hellwig; Hannes Reinecke
> > > Cc: Suganath Prabu S; martin.petersen@oracle.com; linux-
> > > scsi@vger.kernel.org; Sathya.Prakash@broadcom.com;
> > > kashyap.desai@broadcom.com; linux-kernel@vger.kernel.org;
> > > chaitra.basappa@broadcom.com; sreekanth.reddy@broadcom.com; linux-
> > > nvme@lists.infradead.org
> > > Subject: Re: [PATCH v2 00/13] mpt3sas driver NVMe support:
> > >
> > > On Sat, 2017-08-05 at 06:53 -0700, Christoph Hellwig wrote:
> > > >
> > > > On Wed, Aug 02, 2017 at 10:14:40AM +0200, Hannes Reinecke wrote:
> > > > >
> > > > >
> > > > > I'm not happy with this approach.
> > > > > NVMe devices should _not_ appear as SCSI devices; this will just
> > > > > confuse matters _and_ will be incompatible with 'normal' NVMe
> > > > > devices.
> > > > >
> > > > > Rather I would like to see the driver to hook into the existing
> > > > > NVMe framework (which essentially means to treat the mpt3sas as
> > > > > a weird NVMe-over-Fabrics HBA), and expose the NVMe devices like
> > > > > any other NVMe HBA.
> > > >
> > > > That doesn't make any sense.  The devices behind the mpt adapter
> > > > don't look like NVMe devices at all for the hosts - there are no
> > > > NVMe commands or queues involved at all, they hide behind the same
> > > > somewhat leaky scsi abstraction as other devices behind the mpt
> > > > controller.
> > >
> > > You might think about what we did for SAS: split the generic handler
> > > into two pieces, libsas for driving the devices, which mpt didn't
> > > need because of the fat firmware and the SAS transport class so mpt
> > > could at least show the same sysfs files as everything else for SAS
> > > devices.
> >
> >  Ventura generation of controllers are adding connectivity of NVME
> >  drives seamlessly and protocol handling is in Firmware.
> >  Same as SCSI to ATA translation done in firmware, Ventura controller
> >  is doing SCSI to NVME translation and for end user protocol handling
> >  is abstracted.
> >
> >  This product handles new Transport protocol (NVME) same as ATA and
> >  transport is abstracted for end user.
> >
> > NVME pass-through related driver code, it is just a big tunnel for
> > user space application. It is just a basic framework like SATA PASS-
> > Through in existing mpt3sas driver.
>
> I know how it works ... and I'm on record as not liking your SATL approach
> because we keep tripping across bugs in the SATL that we have to fix in
> the
> driver.

We discussed about NVME device support behind <mpt3sas> to Hannes and
he suggested to describe to product behavior to wider audience to be aware.
Just wanted to share the notes.

>
> However, at least for bot SAS and SATA they appear to the system as SCSI
> devices regardless of HBA, so we've largely smoothed over any problems if
> you
> transfer from mp3sas to another SAS/SATA controller.
>
> I believe your current proposal is to have NVMe devices appear as SCSI,
> which
> isn't how the native NVMe driver handles them at all.  This is going to
> have to
> be special cased in any tool designed to handle nvme devices and it's
> going to
> cause big problems if someone changes controller (or moves the
> device).  What's the proposal for making this as painless as possible?

We have to attempt this use case and see how it behaves. I have not tried
this, so not sure if things are really bad or just some tuning may be
helpful. I will revert back to you on this.

I understood request as -  We need some udev rules to be working well for
*same* NVME drives if it is behind <mpt3sas> or native <nvme>.
Example - If user has OS installed on NVME drive which is behind <mpt3sas>
driver as SCSI disk should be able to boot if he/she hooked same NVME drive
which is detected by native <nvme> driver (and vice versa.)

>
> James
