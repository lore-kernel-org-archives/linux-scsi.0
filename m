From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Tue, 31 Aug 2004 08:56:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41347570.4020409@adaptec.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704F631BD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8413 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S268455AbUHaM4X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 08:56:23 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704F631BD@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, linux-scsi@vger.kernel.org

> Look in mptscsih_abort.  If abort task management request failed,
> it will immediately complete the command to mid-layer, returning
> FAILED.  If we succeeded issuing the command, we return SUCCESS, and
> the command would be completed later by mptscsih_taskmgmt_complete.
> If mptscsih_taskmgmt_complete fails to be called, then timer would
> expire, calling mptscsih_taskmgmt_timeout.  This will eventually endup
> reseting card, and flusing the outstanding commands from
> mptscsih_flush_running_commands.

It doesn't make much sense for ABORT TASK to return FAILED.  The
reasons,
	"In either case, the SCSI target device shall guarantee
	that no further responses from the task are sent to the
	SCSI initiator port.", SAM3r13, 7.2.

That is, unless the delivery subsystem wants to let know the
application client about the _delivery_ status of the TMF,
we're better off returning SUCCESS.

So, in either case, we "_kill_" the task (slot) in the driver
queue.  If the service response did fail and we couldn't send
the TMF, and the aborted task did return status, we'd not
find it in our queues and thus know that it is/was a cancelled
task and therefore _not_ report status to SCSI Core,
which is _not_ expecting status for that command.  This is
a more graceful solution, rather than resetting the host,
when ABORT TASK delivery fails, and thus zapping other
initiator ports' tasks, etc.

Either way, I cannot imagine _recovering_ TMFs.

BTW, it is my conviction that _most_ (and maybe all) TMFs should
be HOQ attribute tasks.  (This is one "feature" which would
distinguish between different, say, iSCSI vendors, for example.
"Did it hang?" "No, it recovered quickly.", etc.)

		Luben
 
>  >
>  > > The dmesg dump in previous email indicates that mid-layer
>  > > issued several aborts to the LLD, then mpt driver is returning
>  > > SUCCESS. However at some point the midlayer offlines the device,
>  > > however commands are still in the LLD, and completed
>  > sometime later after
>  > > the mptscsih_taskmgmt_timeout is called, thus hitting the
>  > > oops(because request_buffer=NULL), as we have removed the
>  > > scsi_device_online check per your request.
>  >
>  > I'm looking over fusion code with your latest patch applied now.  What
>  > worries me is mptscsih_flush_running_cmds where's you're erroring out
>  > commands possibly from withing EH methods (?, I have a hard time
>  > following the code from mptscsih to mptbase and back), but not under
>  > EH control.
>  >
>  > Btw, when looking over this it seems to me you could kill
>  > mptscsih_search_running_cmds - the scsi core makes sure you'll never
>  > have outstanding commands when it calls ->slave_destory.
>  >
> 
> I don't recommend removing mptscsih_search_running_cmds.
> This is cleaning up the scsi-look table, chain buffer, and msg frames.
> 
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

