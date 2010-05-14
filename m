From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Fri, 14 May 2010 02:42:14 -0700
Message-ID: <1273830134.27867.44.camel@haakon2.linux-iscsi.org>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
	 <4BECFA39.7040809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:22115 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753050Ab0ENJmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2010 05:42:22 -0400
In-Reply-To: <4BECFA39.7040809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2010-05-14 at 09:22 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > Greetings Hannes and co,
> > 
<SNIP>
> 
> > So, I ended up needing requiring the following quick hack for
> > hw/scsi-generic.c:execute_command_run() to make SG_IO function
> > synchronously using bdrv_ioctl(), which at least gets LUN registration
> > and basic control path CDBs working for the XP guest.
> > 
> > Here is how it looks in action on a v2.6.34-rc7 host so far:
> > 
> > http://www.linux-iscsi.org/images/TCM-KVM-megasas-XP-05132010.png
> > 
> > 
> > diff --git a/hw/scsi-generic.c b/hw/scsi-generic.c
> > index 6c58742..aa1eb83 100644
> > --- a/hw/scsi-generic.c
> > +++ b/hw/scsi-generic.c
> > @@ -140,6 +140,7 @@ static int execute_command_run(SCSIGenericReq *r,
> >  {
> >      BlockDriverState *bdrv = r->req.dev->conf.dinfo->bdrv;
> >      SCSIGenericState *s = DO_UPCAST(SCSIGenericState, qdev, r->req.dev);
> > +    int ret;
> >  
> >      r->io_header.interface_id = 'S';
> >      r->io_header.dxfer_direction = sgdir[r->req.cmd.mode];
> > @@ -161,11 +162,16 @@ static int execute_command_run(SCSIGenericReq *r,
> >      printf("\n");
> >      }
> >  #endif
> > +#if 0
> >      r->req.aiocb = bdrv_aio_ioctl(bdrv, SG_IO, &r->io_header, complete, r);
> >      if (r->req.aiocb == NULL) {
> >          BADF("execute_command: read failed !\n");
> >          return -1;
> >      }
> > +#else
> > +    ret = bdrv_ioctl(bdrv, SG_IO, &r->io_header);
> > +    complete((void *)r, ret);
> > +#endif
> >  
> >       *      return 0;
> >  }
> > 
> > 
> > Beyond the initial LUN registration and control CDB parts, doing bulk
> > DATA_SG_IO traffic is completing successfully (and everything looks sane
> > with TCM_Loop and Linux/SCSI) but it appears that the correct blocks are
> > not actually getting written/read by megasas.  This appears to be the
> > case with both hw/scsi-generic.c and hw/scsi-disk.c modes of operation
> > for megasas with the win32 XP guest.
> > 
> Oh. Hmm.
>
> > So I was wondering if anyone aware of known issues with QEMU
> > asynchronous SG_IO into MSFT KVM guests with virtio or hw/lsi53c895a.c,
> > or would this be something specific to megasas HBA emulation and XP
> > guests..?
> > 
> > Hannes, which MSFT guest + driver did you get work stable with bulk
> > DATA_SG_IO and hw/scsi-disk.c..?
> > 
> Well, I have two more patches for megasas.
> The one is just a cleanup to remove duplicate definitions, but the
> other contains a real issue with a misjudged cast in megasas_enqueue_frame().
> Not sure if that helps here, but it's worth a try nevertheless.
> 
> I'll be sending them with separate mails.
> 

Thanks, applied both patches to the megasas friendly qemu-kvm.git tree.

> Let's see if I can find some time working on the megasas emulation.
> Maybe I find something.
> Last time I checked it was with a Windows7 build, but I didn't do
> any real tests there. Basically just checking if the system boots up :-)
> 

Nothing fancy just yet.  This is involving a normal NTFS filesystem
format on a small TCM/FILEIO LUN using scsi-generic and a userspace
FILEIO with scsi-disk.

This involves the XP guest waiting until the very last READ_10 once the
format has completed (eg: all WRITE and VERIFY CDBs complete with GOOD
status AFAICT) before announcing that mkfs.ntfs failed without any
helpful exception message (due to missing metadata of some sort I would
assume..?)

So perhaps dumping QEMU and TCM_Loop SCSI payloads to determine if any
correct blocks from megasas_handle_io() are actually making it out to
KVM host is going to be my next option.  ;)

I might try with a newer version (and 64-bit) version of windows server
and see if that can produce some manner of more useful information for
us.

Best,

--nab

