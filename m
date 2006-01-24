From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Tue, 24 Jan 2006 10:25:26 -0800 (PST)
Message-ID: <20060124182526.43335.qmail@web31813.mail.mud.yahoo.com>
References: <1138123250.2977.49.camel@laptopd505.fenrus.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:10320 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932480AbWAXSZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 13:25:26 -0500
In-Reply-To: <1138123250.2977.49.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com

--- Arjan van de Ven <arjan@infradead.org> wrote:
> custom error handling was supposed to have gone away already, but then
> libata came around for now... (until that moves to be a block driver),
> so.. I don't see the problem really.

Shouldn't one want more "custom error handling"?  That is, per protocol.
So in effect what you call "custom error handling" actually means
per protocol error handling, be it FC, SATA, iSCSI, USB, SAS, etc.

So SCSI Core offloads recovery to the protocol stack, which depending
on the transport/interconnect may offload some (but not all) functionality
to the port driver.  (Case in point: tunneling protocols.)

Then you can have SCSI Core only decide whether to retry to command.
(If so asked by the submitter from uppper layer.)

     Luben

