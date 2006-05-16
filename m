From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 12:06:17 -0400
Message-ID: <4469F879.9020009@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> No ... in that case the eh is already active, and your API does this:
> 
> void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
> {
> 	if (!scsi_delete_timer(cmd))
> 		return;
> 		^^^^^^^
> 	scsi_times_out(cmd);
> }
> 
> Which likewise does nothing if the timer has already fired, so they both
> have the same effect.

Sigh.  They clearly do not have the same effect, because the above code 
guarantees that a timeout is forced, regardless of whether the timer has 
fired or not.  That in turn guarantees that the timeout callback 
(->eh_timed_out) is called, and the cmd is in a very specific state.

Completion-or-timeout has none of these attributes.

Any alternative is forced to deal with two very different command, and 
EH, states...  to achieve the same eventual result.  Thus, the code 
presented is the one of least complexity, AFAICS.

	Jeff


