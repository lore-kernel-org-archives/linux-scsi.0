From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/18] block copy: initial XCOPY offload support
Date: Fri, 31 Oct 2014 10:22:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410310931530.9022@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1410220926180.31351@file01.intranet.prod.int.rdu2.redhat.com> <5447D74E.3080503@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5447D74E.3080503@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Wed, 22 Oct 2014, Douglas Gilbert wrote:

> See below ...
> 
> Perhaps you are checking somewhere else ... EXTENDED_COPY
> opcode (0x83) has had service actions since SPC-4 rev 34
> (February 2012). By the time SPC-4 becomes standardized
> this command will most likely be called EXTENDED COPY(LID1)
> and will be opcode=0x83, service_action=0.
> 
> To change the level of confusion, opcode 0x83 itself has
> been renamed "Third-party Copy OUT". Not sure why T10 went
> for mixed capitalization here when most other opcode names
> are in upper case, perhaps to stress that it was an opcode
> shared by several commands.
> 
> So please add a further check for ((cmd[1] & 0x1f) == 0)
> unless that has been done elsewhere. With that in place
> a COPY OPERATION ABORT [opcode=0x83, service_action=0x1c]
> issued from my ddptctl utility won't trigger this code.

OK, I changed that. BTW. what happens if that code path is executed as a 
result of a command submitted via SG_IO? Is it correct to call sd_config_* 
or modify req->__data_len in that case? The WRITE_SAME path modifies 
req->__data_len too.

> There is a T10 proposal to drop EXTENDED COPY(LID1) in
> SPC-5 in favour of EXTENDED COPY(LID4) [opcode=0x83,
> service_action=0x1] which can be considered as a
> superset of the former. Something to think about for
> the future; perhaps a comment.
>
> And to push my own barrow here, have you considered
> token based copies based on POPULATE TOKEN and WRITE
> USING TOKEN? If not I can continue to use FreeBSD and
> FreeNAS as they have implemented them (plus the LID4
> equivalent of what its being presented here).

Is there some software iSCSI implementation that supports these commands? 
Target core doesn't seem to support them. If it doesn't support them, I 
can't test it.

> and ....
> 
> >   			case UNMAP:
> >   				sd_config_discard(sdkp, SD_LBP_DISABLE);
> >   				break;
> > @@ -2745,6 +2910,105 @@ static void sd_read_write_same(struct sc
> >   		sdkp->ws10 = 1;
> >   }
> > 
> > +static void sd_read_copy_operations(struct scsi_disk *sdkp,
> > +				    unsigned char *buffer)
> > +{
> > +	struct scsi_device *sdev = sdkp->device;
> > +	struct scsi_sense_hdr sshdr;
> > +	unsigned char cdb[16];
> > +	unsigned int result, len, i;
> > +	bool b2b_desc = false, id_desc = false;
> > +
> > +	if (sdev->naa_len == 0)
> > +		return;
> > +
> > +	/* Verify that the device has 3PC set in INQUIRY response */
> > +	if (sdev->inquiry_len < 6 || (sdev->inquiry[5] & (1 << 3)) == 0)
> > +		return;
> > +
> > +	/* Receive Copy Operation Parameters */
> > +	memset(cdb, 0, 16);
> > +	cdb[0] = RECEIVE_COPY_RESULTS;
> 
> This is now the "Third-party Copy IN" opcode [0x84]. In this
> case RECEIVE_COPY_RESULTS is deceptive as this is _not_ the
> command being built.
> 
> > +	cdb[1] = 0x3;
> 
> with service action 0x3 which is the RECEIVE COPY OPERATION
> PARAMETERS command. Opcode 0x84 has had service actions for
> a lot longer than opcode 0x83, but the original naming lingers
> on.
> 
> The code is correct, the naming could be clearer.
> 
> Doug Gilbert

SPC-4 lists the command as RECEIVE_COPY_RESULTS and Linux already uses 
that name in the target-core driver.

Mikulas
