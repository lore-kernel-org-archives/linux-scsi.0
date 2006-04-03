From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Mon, 03 Apr 2006 10:24:47 +0900
Message-ID: <4430795F.8000703@gmail.com>
References: <20060402234932.96444.qmail@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060402234932.96444.qmail@web31810.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Luben.

Luben Tuikov wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
>> This patch implements scsi_eh_schedule_cmd() which provides a way to
>> directly invoke SCSI EH from drivers implementing
>> ->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
>> gives such drivers complete control over when and how to invoke EH and
>> handle failed commands.
> 
> Hi Tejun,
> 
> I sent an almost identical patch, albeit much more general, see this:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113833937421677&w=2
> 
> Here is the core of it:
> --start-quote--
> This function requests that SCSI Core start recovery for the
> command by deleting the timer and adding the command to the eh
> queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
> implement their own error recovery MAY ignore the timeout event if
> they generated scsi_req_abort_cmd.
> 
> void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
> {
> 	if (!scsi_delete_timer(cmd))
> 		return;
> 	scsi_times_out(cmd);
> }
> --end-quote---
> 
> To have a consistent and complete error recovery solution, given
> the current SCSI Core infrastructure, as is requred for your SATA effort,
> and other (protocol) work, this is what one needs to implement:
> 
> 1. eh_timed_out(),
> 2. eh_strategy_handler(),
> 3. scsi_req_abort_cmd()  (as shown above), and finally,
> 4. scsi_req_dev_reset().
> 
> I keep those in my own git trees. (Had 3 been accepted, I would've sent 4.)

Hmmm... Is scsi_req_dev_reset() similar to scsi_eh_schedule_host()?  ie. 
Does it request EH without scmd?  If so, can you post the patch?  I'm 
okay with anything that works.  All that I need are...

* Non-hackish way to invoke EH on scmd from drivers implementing its own 
EH.  DID_TIME_OUT solution James talked about in the thread isn't 
enough.  It needs to invoke EH whatever the command is.

* Invoking EH without scmd.

IMHO, it's better to allow such driver to tap directly into EH rather 
than making it pass through normal SCSI EH decision making process 
(scsi_device_disposition).  It's much simpler that way.

James, can you tell us what you're thinking about this matter?

Thanks.

-- 
tejun
