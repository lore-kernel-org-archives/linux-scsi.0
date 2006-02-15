From: "T.Krishnanand" <krishnanand.thommandra@gmail.com>
Subject: Re: question on TMF for ISP2432 (linux 2.6.x driver ver 8.01.01)
Date: Wed, 15 Feb 2006 10:11:37 +0530
Message-ID: <2bd90fb70602142041t21a8e548qf23d201f56864b5e@mail.gmail.com>
References: <2bd90fb70602140135t572cfcd5x51b0c250af50bca1@mail.gmail.com>
	 <20060214164659.GB2051@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.204]:47267 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1422658AbWBOEli convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 23:41:38 -0500
Received: by zproxy.gmail.com with SMTP id l8so1444133nzf
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2006 20:41:37 -0800 (PST)
In-Reply-To: <20060214164659.GB2051@andrew-vasquezs-powerbook-g4-15.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Andrew,

Thanks for the info.

I have few more questions based on the review of qla24xx_lun_reset() code,

1) From the code it appears that the LUN-reset uses synchronous
context/mailbox command since:

qla24xx_lun_reset --> qla2x00_issue_iocb --> qla2x00_mailbox_command

so abort-taskset / clear-taskset would also use the same code flow.
Just wanted to confirm from u since in ur previous email u mentioned
otherwise.

2) Since abort/clear-taskset TMFs operate on the specified LUN's
taskset (similar to LUN-reset) I think these TMFs would also need only
MK_SYNC_ID_LUN marker IOCB as in qla24xx_lun_reset. Plz confirm.

thanks,
tkrishna


On 2/14/06, Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> On Tue, 14 Feb 2006, T.Krishnanand wrote:
>
> > Does ISP2432 support ABORT_TASK_SET and CLEAR_TASK_SET TMFs ?
>
> Yes.
>
> > I understand that Linux SCSI EH strategy doesnt make use of these TMFs
> > so QLA2xxx driver doesn't have code related to these.
>
> Also correct.
>
> > But If I want to extend the QLA driver to support these TMFs using
> > following mailbox commands:
> >
> > MBC_ABORT_TASK_SET
> > MBC_CLEAR_TASK_SET
> >
> > so that I can invoke them thru some IOCTL based appln...
> >
> > a) would ISP 2432 firmware/asic support these TMFs ? Are there any
> > known gotchas that one should be careful about while implementing
> > these?
>
> It does, but not via a synchronous mailbox command.  Instead you need
> to use a TASK-management IOCB to send the requests to the firmware via
> the request-queue.  Take a look at the tsk_mgmt_entry structure in
> qla_fw.h.
>
> > b) While coding the handler for these TMFs which existing EH routine
> > would u recommend to be used as template/reference ?
>
> A reference implementation of the driver issuing a LUN-RESET via the
> IOCB can be found in qla24xx_lun_reset().
>
> > c) Since current/latest driver doesnt have any code for these TMFs,
> > what is the exact mailbox command format for these TMFs ?
>
> --
> av
>
