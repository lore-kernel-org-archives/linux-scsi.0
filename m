From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fix dma mapping leak in fusion
Date: Mon, 30 Aug 2004 18:29:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704F631BD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23276 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264795AbUH3W34 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 18:29:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, linux-scsi@vger.kernel.org

On Saturday, August 28, 2004 1:03 PM, Christoph Hellwig wrote:

> 
> On Mon, Aug 23, 2004 at 11:56:50AM -0400, Moore, Eric Dean wrote:
> > Christoph - What is the criteria for the mid-layer
> > to offline a device? 
> 
> When eh_abort didn't succeed for all outstanding commands and 
> the various
> reset methods failed aswell.

Look in mptscsih_abort.  If abort task management request failed,
it will immediately complete the command to mid-layer, returning
FAILED.  If we succeeded issuing the command, we return SUCCESS, and
the command would be completed later by mptscsih_taskmgmt_complete.
If mptscsih_taskmgmt_complete fails to be called, then timer would
expire, calling mptscsih_taskmgmt_timeout.  This will eventually endup
reseting card, and flusing the outstanding commands from 
mptscsih_flush_running_commands.

> 
> > The dmesg dump in previous email indicates that mid-layer 
> > issued several aborts to the LLD, then mpt driver is returning 
> > SUCCESS. However at some point the midlayer offlines the device,
> > however commands are still in the LLD, and completed 
> sometime later after
> > the mptscsih_taskmgmt_timeout is called, thus hitting the
> > oops(because request_buffer=NULL), as we have removed the 
> > scsi_device_online check per your request.
> 
> I'm looking over fusion code with your latest patch applied now.  What
> worries me is mptscsih_flush_running_cmds where's you're erroring out
> commands possibly from withing EH methods (?, I have a hard time
> following the code from mptscsih to mptbase and back), but not under
> EH control.
> 
> Btw, when looking over this it seems to me you could kill
> mptscsih_search_running_cmds - the scsi core makes sure you'll never
> have outstanding commands when it calls ->slave_destory.
> 

I don't recommend removing mptscsih_search_running_cmds. 
This is cleaning up the scsi-look table, chain buffer, and msg frames.

  
