From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Sat, 6 Dec 2003 11:37:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312061111220.18839-100000@master.linux-ide.org>
References: <1070383028.2345.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:23818
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S265137AbTLFTmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2003 14:42:11 -0500
In-Reply-To: <1070383028.2345.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


James:

Thank you for explaining to Roman and company the obvious nature of
BLOCK on top of SCSI.  This is only a point of proof that I was correct in
my statements earlier.

iSCSI(MC) will corrupt randomly.

iSCSI(ZC) will fail data digests and invoke the retry.

Also iSCSI ERL = 0 is in the class of functional (waste) transport,
period.

Retrying entire commands because one PDU data digest fails is lame.

If a single command had for example 20 PDU's, and one failed a data
digest, iSCSI(ERL = 0) will have to dump all PDU's on the floor and retry
all of the command (oh and hope there are no other failure, or will retry
again).  Thus network transaction overhead of the original 20 PDU's is now
doubled to 40 PDU's.  This is just laughable and a joke if you are serious
about your data.

Same example with iSCSI(ERL = 1), the original 19 good PDU's are buffered
and an in-connection recovery is executed for the one failed.

Translation:

iSCSI(ERL = 0) 20 * (m + 1), m = I(all postive integers)

iSCSI(ERL = 1) 20 + n, n = I(all postive integers)

m == the number of entire commands retired.
n == the number of PDU's retried.

For ease, make m == n = 1;

iSCSI(ERL = 0) == 40 PDU's

iSCSI(ERL = 1) == 21 PDU's

The only case where they are equal is if all PDU's in iSCSI(ERL = 1) had
to be retried.

The goal of the exercise is to show that both Roman's and Cisco's
iSCSI(ERL = 0) initaitors are not in a data integrity class acceptable for
anyone.

Should either of these parties have an iSCSI(ERL = 1) product then it
becomes more useful.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On 2 Dec 2003, James Bottomley wrote:

> On Tue, 2003-12-02 at 05:56, Naveen Burmi wrote:
> > Our assumption so far was that if a buffer is given to SCSI HBA driver, then 
> > nobody can touch the buffer until the HBA says that he is done with the 
> > buffer. It seems that this assumption isn't true. Can you give an instance 
> > where somebody (probably buffer cache) will modify the buffer which is handed
> > over to an HBA driver?
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
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

