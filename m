From: Luben Tuikov <luben@splentec.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 13:57:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D90A79F.47A37BC2@splentec.com>
References: <200209241346.g8ODkER09516@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> I think it's method of operation is misplaced.  What it should probably be
> doing is simply adding a doorlock to the head of the queue and then go back
> around.  Since we know the doorlock now preceeds the command that instigated
> the issue the door should be locked before anything else happens.  It should
> simply loop around and process the door lock request so it doesn't have to
> wait for anything else to occur (any commands which come down in the interim
> should go on the queue tail).
> 

Similar mechanism exists in some current SCSI transport/interconnect
protocols.

The notion of _an_immediate_command_ does exactly that.

Add a flag, say unsigned I:1; to scsi_cmnd, which if set to 1, will
make add it to the head of the queue, irrespective of its serial
number, else the command is added according to its serial number
in the pending commands queue.

-- 
Luben
