From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel2.9.1-rc1-bk1
 trough rc2-bk12
Date: Sun, 3 Oct 2004 12:37:20 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0410031224090.4017@kai.makisara.local>
References: <13842.1096472870@www69.gmx.net><1096732158.2169.13.camel@mulgrave>
 <Pine.LNX.4.58.0410022246140.1977@kai.makisara.local> <1096756118.4415.39.camel@mulgrave>
 <00df01c4a928$7fd0e8c0$8511050a@alexs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:29539 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S267769AbUJCJhY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Oct 2004 05:37:24 -0400
In-Reply-To: <00df01c4a928$7fd0e8c0$8511050a@alexs>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Stohr <alexander.stohr@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com

On Sun, 3 Oct 2004, Alexander Stohr wrote:

> what information would you need from me
> to identify the bitness of the adapter and
> the device so that i can see an advance
> in my situation as well?
> 
Whenever you report tape problems, it would be helpful to know at least 
the drive mode (fixed vs. variable block mode) and block size (if fixed 
block mode). You can get this information with 'mt status'. Additionally 
it is useful to see the sequence of commands leading to the problem. The 
tape is a sequential device and all previous operations may influence what 
happens next. These things allow duplication of the problem. Additionally, 
it is useful to know the SCSI adapter and drive model (which you have 
included already).

What you see suggests that you are trying to do something that one should 
not do with tapes, i.e., trying to read the tape in fixed block mode with 
different block size than was used when writing. However, from the system 
point of view, this should not cause problems. The drive should report the 
conditions cleanly to st using sense data.

To me your problems seem to be in the communication between the drive and 
the adapter. The sym53c8xx_2 driver has had problems in speed negotiation 
recently. As I mentioned, the speed negotiation did not succeed with my 
drives at some point. I have here patch-2.6.9-rc2-bk14 and it does not 
seem to have those fixes yet. It might be good if you could try a new 
kernel (2.6.9-rc3 is certainly new enough) and see if this helps.

--
Kai
