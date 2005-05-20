From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Perform uncached reads on SCSI drives?
Date: Fri, 20 May 2005 22:16:57 +1000
Message-ID: <428DD539.8070901@torque.net>
References: <66F9227F7417874C8DB3CEB0577274170450FD@MILEX0.Miltope.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:15291 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261446AbVETMQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 08:16:53 -0400
In-Reply-To: <66F9227F7417874C8DB3CEB0577274170450FD@MILEX0.Miltope.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew Winstel <DWinstel@Miltope.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, "Linux-scsi (E-mail)" <linux-scsi@vger.kernel.org>

Drew Winstel wrote:
> Hello, Patrick, and thanks for the reply.
> 
> 
>>You could try setting read cache disable, I don't know if that setting
>>must be honored, or how ATA/SATA handle it. See mode page 8 for SCSI block
>>commands. 
> 
> 
> Hmm, that's definitely worth a shot.  I'll try it and let you know how it
> works.
> 
> 
>>The sg utilities sg_modes can probably set it.
> 
> 
> As would the new sdparm, I imagine.

Drew,
sg_modes only reads mode pages. They can be changed with
sginfo (or scsiinfo) and sg_wr_mode. The simplest is
probably:
   sdparm --set=RCD /dev/sda

or, if you want the change to survive the next disk
power cycle:
   sdparm --set=RCD --save /dev/sda

If /dev/sda is really a ATA/SATA disk then I don't
think the read cache can be disabled (judging from
the SAT document).

BTW If the sd driver sees a disk with WCE=1 and RCD=1
it outputs: "driver cache: write back, no read (daft)".
IMO the "daft" bit is itself daft. It is logically valid
(i.e. a read of a block in the write cache will cause
that block to be written to the media, then read back)
and reserves the cache exclusively for writing. When
copying one disk (or partition) to another, caching
reads seems futile.

Doug Gilbert

