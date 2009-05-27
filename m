From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
Date: Wed, 27 May 2009 10:36:40 +0900
Message-ID: <20090527103637W.fujita.tomonori@lab.ntt.co.jp>
References: <1243349222.2815.22.camel@localhost.localdomain>
	<20090527003152X.fujita.tomonori@lab.ntt.co.jp>
	<4A1C1331.8060304@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49539 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZE0Bif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 21:38:35 -0400
In-Reply-To: <4A1C1331.8060304@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org

On Tue, 26 May 2009 19:05:05 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
> > 
> > Can we just fix some drivers not to do the DMA with the sense buffer in
> > scsi_cmnd? IIRC, there are only five or six drivers that do such.
> 
> This is not so.
> All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
> the regular read path. Including all the drivers that do nothing and let
> scsi-ml do the REQUEST_SENSE
> 
> Actually I have exact numbers, from the last time I did all that

Hmm, we discussed this before, I think.

scsi-ml uses scsi_eh_prep_cmnd only via scsi_send_eh_cmnd(). There are
some users of scsi_send_eh_cmnd in scsi-ml but only scsi_request_sense
does the DMA in the sense_buffer of scsi_cmnd.

Only scsi_error_handler() uses scsi_request_sense() and
scsi_send_eh_cmnd() works synchronously. So scsi-ml can easily avoid
the the DMA in the sense_buffer of scsi_cmnd if we have one sense
buffer per scsi_host.
