From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 02 Dec 2003 10:37:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070383028.2345.8.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<Pine.LNX.4.58.0312011655240.26106@serv>
	<03120217260300.01630@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:27396 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262373AbTLBQi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 11:38:58 -0500
In-Reply-To: <03120217260300.01630@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: naveenb@cisco.com
Cc: Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-12-02 at 05:56, Naveen Burmi wrote:
> Our assumption so far was that if a buffer is given to SCSI HBA driver, then 
> nobody can touch the buffer until the HBA says that he is done with the 
> buffer. It seems that this assumption isn't true. Can you give an instance 
> where somebody (probably buffer cache) will modify the buffer which is handed
> over to an HBA driver?

This is an incorrect assumption.  The Linux SCSI subsystem is
architected for zero copy, meaning that if the user maps a copy of the
data, they can alter it at will, even if it is in flight within the
driver.  The only thing you can guarantee is that you will get another
write request for any page the user dirtied.

Also note that glibc uses mmaping to handle file descriptors in linux,
so almost every application can alter in-flight data depending on how it
works.

James



