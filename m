From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: Sat, 17 Jan 2004 22:21:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118062157.GA11083@praka.local.home>
References: <1074382860.1756.20.camel@mulgrave> <20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:39582 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266245AbUARGdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 01:33:32 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-03-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0I6XTF3014173
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2004 22:33:31 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1074395819.1756.31.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, 17 Jan 2004, James Bottomley wrote:

> On Sat, 2004-01-17 at 21:43, Jeremy Higdon wrote:
> > What is the reason for this change?  Is there an alternate way that this
> > gets set?
> 
> That's reason number three in the previous email: apparently you can't
> simply address the card in 64 bit mode if the nvram is set up for 32 bit
> mode.  We either have to take the nvram value or find a way to switch
> the card into 64 bit mode.
> 

That NVRAM setting really has no functional meaning for the card or
Linux driver.  I believe it was an artifact from some ancient
(non-linux) driver.  In essence, the ha flag simply indicates the
which type of IOCBs are used to initiate the CDB transfer.

> This was causing transfer failures on a 64 bit parisc box.  The nvram
> returns 32 bit, and no transfers were occurring when it was addressed in
> 64 bit mode.  It may be because there's an endianness failure somewhere
> in the 64bit_start_scsi routine, but if there is I couldn't find it. 
>

Either could I (but then again its late :).  What I did notice was
some rather weird code being executed when the CDB calls for no data
to transfer (both 64/32_start).  The code in question is this small
snippet:

	...
        } else {        /* No data transfer */
                dword_ptr = (uint32_t *)(pkt + 1);
                *dword_ptr++ = 0;
                *dword_ptr++ = 0;
                *dword_ptr = 0;
                dprintk(5, "qla1280_64bit_start_scsi: No data, command "
                        "packet data - b %i, t %i, l %i \n",
                        SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
			SCSI_LUN_32(cmd));
		qla1280_dump_buffer(5, (char *)pkt, REQUEST_ENTRY_SIZE);
        }

What exactly are we trying to zero out here?  The IOCB has already
been cleared with the following line earlier in the function:

        /* Zero out remaining portion of packet. */
        memset(((char *)pkt + 8), 0, (REQUEST_ENTRY_SIZE - 8));

pkt points to:

        /*
	 * Build command packet.
	 */
        pkt = (cmd_a64_entry_t *) ha->request_ring_ptr;

(uint32_t *)(pkt + 1) points to the next request_ring entry.
Certainly not what we want.

Here's a small patch, not sure if its going to solve your problem
though.  I'll look some more tomorrow.

Jeremy:  have you had any problems with running I/O down the 64bit
capable IOCB path?

--
Andrew

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1280-no_data_transfer.diff"

--- qla1280.c.orig	2004-01-17 22:18:16.000000000 -0800
+++ qla1280.c	2004-01-17 22:19:18.000000000 -0800
@@ -3325,10 +3325,6 @@
 					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer */
-		dword_ptr = (uint32_t *)(pkt + 1);
-		*dword_ptr++ = 0;
-		*dword_ptr++ = 0;
-		*dword_ptr = 0;
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
 			"packet data - b %i, t %i, l %i \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
@@ -3593,9 +3589,6 @@
 			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
 		}
 	} else {	/* No data transfer at all */
-		dword_ptr = (uint32_t *)(pkt + 1);
-		*dword_ptr++ = 0;
-		*dword_ptr = 0;
 		dprintk(5, "qla1280_32bit_start_scsi: No data, command "
 			"packet data - \n");
 		qla1280_dump_buffer(5, (char *)pkt, REQUEST_ENTRY_SIZE);

--LZvS9be/3tNcYl/X--
