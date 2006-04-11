From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Tue, 11 Apr 2006 14:28:30 -0700
Message-ID: <20060411212830.GA9234@us.ibm.com>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com> <442F25BD.8040000@gmail.com> <20060402160414.GM13172@htj.dyndns.org> <443BEA65.7020800@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <443BEA65.7020800@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2006 at 01:41:57PM -0400, Jeff Garzik wrote:
> Tejun Heo wrote:
> >This patch implements scsi_eh_schedule_cmd() which provides a way to
> >directly invoke SCSI EH from drivers implementing
> >->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
> >gives such drivers complete control over when and how to invoke EH and
> >handle failed commands.


> >+ * scsi_eh_schedule_cmd - schedule scsi cmd for error handling.
> >+ * @scmd:	scmd to run eh on.
> >+ *
> >+ * Description:
> >+ *	This function is used by LLDDs which don't use standard SCSI
> >+ *	EH to schedule scmd for EH.
> >+ *
> >+ * Return value:
> >+ *	0 on failure.
> >+ **/
> >+int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)
> >+{
> >+	struct Scsi_Host *shost = scmd->device->host;
> >+
> >+	WARN_ON(!shost->hostt->eh_strategy_handler);
> >+
> >+	if (!scsi_delete_timer(scmd))
> >+		return 0;	/* timeout won */
> >+
> >+	return scsi_eh_scmd_add(scmd, 0);
> >+}
> >+EXPORT_SYMBOL_GPL(scsi_eh_schedule_cmd);
> 
> 
> ACK, though this patch makes me think that there are some non-libata 
> pieces of code that could use this function.
> 
> Unfortunately for libata, we are stuck waiting on linux-scsi people to 
> return and give their opinion.  If nobody complains, I'll apply it, if 
> it doesn't appear in scsi-misc-2.6 sometime vaguely soon.

Per other email it should be called scsi_req_abort_cmd() or such, as that
is the only reason to call it, correct?

Any other handling can be completed by calling the ->done function.

Even the abort/cancel could be done in the driver without this, I assume
it is avaiable so the driver can use the eh process and existing code
paths rather than duplicate similar code.

-- Patrick Mansfield
