From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] 2.5.31 scsi_error.c cleanup
Date: Thu, 22 Aug 2002 09:34:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020822163439.GA1336@beaverton.ibm.com>
References: <20020812233815.GA1334@beaverton.ibm.com> <200208221405.g7ME5XE02754@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208221405.g7ME5XE02754@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> andmike@us.ibm.com said:
> > I did not change any of the current error policy. I would like to do
> > that in the future. 
> 
> Looking through the patch, it seems you've changed the offline behavior.  Now 
> if all error recovery fails, the machine will panic instead of just offlining 
> the failed device.  I know offlining has never worked correctly, because it 
> always seems to leave the system hanging, but it is a useful feature for large 
> machines with many SCSI attachments, could you look at trying to get it to 
> work corectly?
> 
> Thanks,
> 
> James


Thanks for the feedback my intent was not to panic on failed recovery. I
will re-verify an offline case.

All sdev's that fail to recover in scsi_eh_bus_host_reset through a bus
and/or host reset should be offlined at the bottom of the channel for
loop before we go on to the next channel. The BUG_ON(shost->host_failed)
in scsi_unjam host is a carryover from the old scsi_error panic that I
believe was trying to catch race conditions / code problems. I left the
check in for now.

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

