From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Tue, 27 Jan 2004 18:48:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401625CA.1070404@torque.net>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com> <1075136727.2290.48.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:62478 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262674AbUA0IvY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 03:51:24 -0500
In-Reply-To: <1075136727.2290.48.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

James Bottomley wrote:
> On Mon, 2004-01-26 at 11:01, Moore, Eric Dean wrote:
> 
>>I will work on that.  
> 
> 
> Thanks.
> 
> 
>>I had avoided it due the comments in the code
>>from sralston and pdelaney about sg interface 
>>gererating wrong direction in some cases.  
> 
> 
> If you find a problem, I'll fix the generic code...

James,
The newer sg_io_hdr based code (as used by the SG_IO ioctl)
requires that the user explicitly define the data direction
if any data transfer is involved. There is however a
SG_DXFER_UNKNOWN which maps to SCSI_DATA_UNKNOWN which
maps to DMA_BIDIRECTIONAL **.

The older sg_header based code (and the SCSI_IOCTL_SEND_COMMAND
ioctl) deduced the direction from various data buffer lengths
provided by the user. If those length implied both read and write
then the data direction is set as "FROM_DEVICE" (i.e. read
dominates).

So the sg (or SG_IO/SCSI_IOCTL_SEND_COMMAND ioctl) user controls
the data direction and they are free to get it wrong:-)


** The Object Storage Device (OSD) commands use bidirectional
data transfers so perhaps we should think about catering for
that.

Doug Gilbert

