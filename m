From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Is scsi_cmnd::underflow still useful?
Date: Tue, 13 Jul 2004 18:09:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F45D7C.3030903@torque.net>
References: <40F2E93B.3040607@torque.net> <1089680114.2074.198.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts20.bellnexxia.net ([209.226.175.74]:5512 "EHLO
	tomts20-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S266917AbUGMWJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 18:09:04 -0400
In-Reply-To: <1089680114.2074.198.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de

James Bottomley wrote:
> On Mon, 2004-07-12 at 14:40, Douglas Gilbert wrote:
> 
>>Doesn't look like many LLDs act on scsi_cmnd::underflow.
>>Seems to me that scsi_cmnd::resid is a more general
>>replacement.
> 
> 
> well, I know I suggested a recent use of it to the USB people , so I
> don't think it's entirely unused.  resid can't be a replacement because
> they mean different things:
> 
> resid - number of bytes left over after a transaction
> underflow - driver must return error if less than this amount
> transferred.

James,
Here is a code snippet from one of the few LLDs that acts on
scsi_cmnd::underflow: qla2xxx/qla_isr.c . It shows
the relationship between request_buflen, resid and underflow:

    if ((unsigned)(cp->request_bufflen - resid) <
                   cp->underflow) {
        qla_printk(KERN_INFO, ha,
                   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
                   "detected (%x of %x bytes)...returning "
                   "error status.\n",
                   ha->host_no, b, t, l, resid,
                   cp->request_bufflen);
                   cp->result = DID_ERROR << 16;
                   break;
     }

Rather than ask the LLD report an error (and leave the upper
layers wondering if any data was sent or received) wouldn't
it be better to allow the issuer of the scsi_cmnd object to
decide whether the response was deficient (based on resid)?

I am responsible for resid being added (in the lk 2.3 series)
at the prompting of Joerg Schilling. The scsi_cmnd::underflow
parameter was not of use to him, even if I exposed it to
applications via sg_io_hdr. resid is a "steal" from CAM and
the only complaints I have received about it are concerning
LLDs that do _not_ implement it.

Doug Gilbert
