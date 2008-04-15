From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] iscsi_tcp: Enable large commands
Date: Tue, 15 Apr 2008 22:46:41 +0900
Message-ID: <20080415224639Q.tomof@acm.org>
References: <48049E8A.7030700@panasas.com>
	<4804A16D.7000002@panasas.com>
	<4804A8C7.504@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:54123 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990AbYDONtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2008 09:49:03 -0400
In-Reply-To: <4804A8C7.504@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Tue, 15 Apr 2008 09:08:23 -0400
James Smart <James.Smart@Emulex.Com> wrote:

> Boaz Harrosh wrote:
> > Let through up to the largest command of 260 defined by the scsi standard.
> > iscsi core supports this already. Now that the scsi-ml supports it we can
> > start using large commands.
> 
> Just to double-check:
> if we use sg_io to pass through requests from user-land, which are addressed to
> drivers or transports, and which may not be a SCSI command but rather just something
> utilizing the sg_io infrastructure for management or pass-thru, are we limited to
> 260 bytes for request/cmd payload ?

With SG_IO (block, sg.c, and bsg), the command length is still limited
to 16 bytes (BLK_MAX_CDB). We will remove the limit in bsg shortly.

As you know, bsg supports bidi data transfer and there is no limit on
the length of request and response payload. SAS management protocol
uses request and response payload for data transfer. It doesn't use
the command area (that is used for SCSI command).
