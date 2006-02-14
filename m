From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: question on TMF for ISP2432 (linux 2.6.x driver ver 8.01.01)
Date: Tue, 14 Feb 2006 08:46:59 -0800
Message-ID: <20060214164659.GB2051@andrew-vasquezs-powerbook-g4-15.local>
References: <2bd90fb70602140135t572cfcd5x51b0c250af50bca1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33579 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1422642AbWBNQrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 11:47:07 -0500
Content-Disposition: inline
In-Reply-To: <2bd90fb70602140135t572cfcd5x51b0c250af50bca1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "T.Krishnanand" <krishnanand.thommandra@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 14 Feb 2006, T.Krishnanand wrote:

> Does ISP2432 support ABORT_TASK_SET and CLEAR_TASK_SET TMFs ?

Yes.

> I understand that Linux SCSI EH strategy doesnt make use of these TMFs
> so QLA2xxx driver doesn't have code related to these.

Also correct.

> But If I want to extend the QLA driver to support these TMFs using
> following mailbox commands:
> 
> MBC_ABORT_TASK_SET
> MBC_CLEAR_TASK_SET
> 
> so that I can invoke them thru some IOCTL based appln...
> 
> a) would ISP 2432 firmware/asic support these TMFs ? Are there any
> known gotchas that one should be careful about while implementing
> these?

It does, but not via a synchronous mailbox command.  Instead you need
to use a TASK-management IOCB to send the requests to the firmware via
the request-queue.  Take a look at the tsk_mgmt_entry structure in
qla_fw.h.

> b) While coding the handler for these TMFs which existing EH routine
> would u recommend to be used as template/reference ?

A reference implementation of the driver issuing a LUN-RESET via the
IOCB can be found in qla24xx_lun_reset().

> c) Since current/latest driver doesnt have any code for these TMFs,
> what is the exact mailbox command format for these TMFs ?

--
av
