From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Sun, 2 Apr 2006 16:49:32 -0700 (PDT)
Message-ID: <20060402234932.96444.qmail@web31810.mail.mud.yahoo.com>
References: <20060402160414.GM13172@htj.dyndns.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060402160414.GM13172@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> This patch implements scsi_eh_schedule_cmd() which provides a way to
> directly invoke SCSI EH from drivers implementing
> ->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
> gives such drivers complete control over when and how to invoke EH and
> handle failed commands.

Hi Tejun,

I sent an almost identical patch, albeit much more general, see this:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113833937421677&w=2

Here is the core of it:
--start-quote--
This function requests that SCSI Core start recovery for the
command by deleting the timer and adding the command to the eh
queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
implement their own error recovery MAY ignore the timeout event if
they generated scsi_req_abort_cmd.

void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
{
	if (!scsi_delete_timer(cmd))
		return;
	scsi_times_out(cmd);
}
--end-quote---

To have a consistent and complete error recovery solution, given
the current SCSI Core infrastructure, as is requred for your SATA effort,
and other (protocol) work, this is what one needs to implement:

1. eh_timed_out(),
2. eh_strategy_handler(),
3. scsi_req_abort_cmd()  (as shown above), and finally,
4. scsi_req_dev_reset().

I keep those in my own git trees. (Had 3 been accepted, I would've sent 4.)

Beware, Bottomley will most likely have his own ideas on error recovery,
as he did when I posted my patch above.  I didn't bother to explain, from a
protocol point of view, why it is needed.

Good luck!
     Luben

