From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 3 Dec 2003 19:36:48 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03120319364802.02505@naveenb-lnx.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <03120217260300.01630@naveenb-lnx.cisco.com> <1070383028.2345.8.camel@mulgrave>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:17416 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S264566AbTLCOF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 09:05:28 -0500
In-Reply-To: <1070383028.2345.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com


PREVENT_DATA_CORRUPTION was based on our assumption which is not correct and 
Linux SCSI subsystem is architected for zero copy, therefore we are removing 
PREVENT_DATA_CORRUPTION.

Thanks,
Naveen.

On Tuesday 02 December 2003 10:07 pm, James Bottomley wrote:
> On Tue, 2003-12-02 at 05:56, Naveen Burmi wrote:
> > Our assumption so far was that if a buffer is given to SCSI HBA driver,
> > then nobody can touch the buffer until the HBA says that he is done with
> > the buffer. It seems that this assumption isn't true. Can you give an
> > instance where somebody (probably buffer cache) will modify the buffer
> > which is handed over to an HBA driver?
>
> This is an incorrect assumption.  The Linux SCSI subsystem is
> architected for zero copy, meaning that if the user maps a copy of the
> data, they can alter it at will, even if it is in flight within the
> driver.  The only thing you can guarantee is that you will get another
> write request for any page the user dirtied.
>
> Also note that glibc uses mmaping to handle file descriptors in linux,
> so almost every application can alter in-flight data depending on how it
> works.
>
> James
