From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fix dma mapping leak in fusion
Date: Tue, 31 Aug 2004 10:42:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704F6322D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42737 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268674AbUHaOnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 10:43:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, linux-scsi@vger.kernel.org

On Tuesday, August 31, 2004 6:56 AM, Luben Tuikov wrote
> 
> > Look in mptscsih_abort.  If abort task management request failed,
> > it will immediately complete the command to mid-layer, returning
> > FAILED.  If we succeeded issuing the command, we return SUCCESS, and
> > the command would be completed later by mptscsih_taskmgmt_complete.
> > If mptscsih_taskmgmt_complete fails to be called, then timer would
> > expire, calling mptscsih_taskmgmt_timeout.  This will 
> eventually endup
> > reseting card, and flusing the outstanding commands from
> > mptscsih_flush_running_commands.
> 
> It doesn't make much sense for ABORT TASK to return FAILED.  The
> reasons,
> 	"In either case, the SCSI target device shall guarantee
> 	that no further responses from the task are sent to the
> 	SCSI initiator port.", SAM3r13, 7.2.

For this represented path in the driver, we just tried
to issue the ABORT TASK, and for some reason the HBA failed to accept
the ABORT TASK,  thus the driver immediately completes the SCSI command,
and returns FAILED to mid layer.   I didn't think it would be appropiate
to tell the midlayer we succeeded in issuing the abort, when it actually
failed.

> 
> That is, unless the delivery subsystem wants to let know the
> application client about the _delivery_ status of the TMF,
> we're better off returning SUCCESS.
> 
> So, in either case, we "_kill_" the task (slot) in the driver
> queue.  If the service response did fail and we couldn't send
> the TMF, and the aborted task did return status, we'd not
> find it in our queues and thus know that it is/was a cancelled
> task and therefore _not_ report status to SCSI Core,
> which is _not_ expecting status for that command.  This is
> a more graceful solution, rather than resetting the host,
> when ABORT TASK delivery fails, and thus zapping other
> initiator ports' tasks, etc.
> 

The reset is issued only after the timeout of the TM timer has expired.
The reset is to get the HBA back into known state, and terminate
outstanding commands.  It wouldn't be good idea to start releasing dma to 
commands when we don't know what state they are at down in the firmware.


> Either way, I cannot imagine _recovering_ TMFs.
> 
> BTW, it is my conviction that _most_ (and maybe all) TMFs should
> be HOQ attribute tasks.  (This is one "feature" which would
> distinguish between different, say, iSCSI vendors, for example.
> "Did it hang?" "No, it recovered quickly.", etc.)
> 
> 		Luben
>  
> >  >
> >  > > The dmesg dump in previous email indicates that mid-layer
> >  > > issued several aborts to the LLD, then mpt driver is returning
> >  > > SUCCESS. However at some point the midlayer offlines 
> the device,
> >  > > however commands are still in the LLD, and completed
> >  > sometime later after
> >  > > the mptscsih_taskmgmt_timeout is called, thus hitting the
> >  > > oops(because request_buffer=NULL), as we have removed the
> >  > > scsi_device_online check per your request.
> >  >
> >  > I'm looking over fusion code with your latest patch 
> applied now.  What
> >  > worries me is mptscsih_flush_running_cmds where's you're 
> erroring out
> >  > commands possibly from withing EH methods (?, I have a hard time
> >  > following the code from mptscsih to mptbase and back), 
> but not under
> >  > EH control.
> >  >
> >  > Btw, when looking over this it seems to me you could kill
> >  > mptscsih_search_running_cmds - the scsi core makes sure 
> you'll never
> >  > have outstanding commands when it calls ->slave_destory.
> >  >
> > 
> > I don't recommend removing mptscsih_search_running_cmds.
> > This is cleaning up the scsi-look table, chain buffer, and 
> msg frames.
> > 
> >  
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
