From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 04 May 2009 20:22:42 +0200
Message-ID: <49FF3272.5040406@s5r6.in-berlin.de>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw> <49FEFF7A.3090603@s5r6.in-berlin.de> <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com> <20090504150616.GY8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47681 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZEDSXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 14:23:10 -0400
In-Reply-To: <20090504150616.GY8822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Ronald <Ronald@ioi.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

OK, so the upshot is:

   - The usually used commands READ CAPACITY (10), READ (10), WRITE (10)
     support 32 bits wide logical block addresses (LBAs), which is
     sufficient for up to 2 TB at the currently ubiquitously used block
     size of 512 bytes.

   - Linux will use READ CAPACITY (16), READ (16), WRITE (16) if the disk
     behaves like an SBC disk, particularly, if the disk responds with
     0xffffffff to READ CAPACITY (10) like defined in SBC.  This will
     happen regardless whether the disk showed itself as SBC or RBC disk
     in the INQUIRY response (which comes before the capacity is read).
     So the fact that many IEEE 1394 disks show themselves as RBC in the
     INQUIRY response doesn't matter in this regard, what matters is
     the implemented READ CAPACITY behavior of the disk.

     READ CAPACITY (16), READ (16), WRITE (16) have 64 bits wide LBA
     fields and thus enable disk sizes of more than 2 TB.

   - Furthermore, Linux will use READ CAPACITY (16) even before having
     tried READ CAPACITY (10) under some special circumstances, which
     also depend on the kernel version.  This however is less relevant to
     the problem at hand.

And lastly, one thing which I almost forgot:

On 32 bit CPU architectures, it is necessary that the kernel was 
compiled with the option "Support for large block devices and files" 
(LBD) switched on.  My guess is that all commonly used Linux 
distributions for 32bit systems do have this option enabled in their 
standard kernel packages --- at least the more recent ones.  It's not an 
issue with 64 bit CPU architectures.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
