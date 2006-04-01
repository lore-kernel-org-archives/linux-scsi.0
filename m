From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] SCSI: implement scsi_eh_schedule()
Date: Sat, 01 Apr 2006 15:14:23 -0500
Message-ID: <442EDF1F.6000001@pobox.com>
References: <20060401103857.GG13172@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060401103857.GG13172@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> [PATCH] SCSI: implement scsi_eh_schedule()
> 
> This patch implements scsi_eh_schedule() which provides a way to
> directly invoke SCSI EH from drivers which implement EH using
> ->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
> gives such drivers complete control over when and how to invoke EH and
> handle failed commands.
> 
> scsi_eh_schedule() can also be invoked without a scmd.  This is useful
> for handling exception conditions occurring while no command is in
> progress.  New Scsi_Host field host_eh_invoked is added for this.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Not so sure about this one:

1) Rather than creating the scmd==NULL special case path, just create a 
new function scsi_kick_eh() or somesuch.  I presume such an 
implementation would be quite tiny:  satisfy the condition 
'shost->host_busy == shost->host_failed', then call scsi_eh_wakeup().

2) Looks almost exactly like scsi_eh_scmd_add().  Minus the code deleted 
via suggestion #1, you really just add a timer check.  Why not add a 
SCSI EH flag which says "check timer", then just call scsi_eh_scmd_add()?

3) I would think that host_eh_invoked could be deduced.

	Jeff


