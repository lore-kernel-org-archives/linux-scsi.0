From: Stephen Cameron <steve.cameron@hp.com>
Subject: Re: [PATCH] update cciss in 2.5 to use modern scsi APIs
Date: Tue, 25 Feb 2003 13:37:54 +0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030225073754.GA19075@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


(I already replied to this privately, not realizing
this was on linux-scsi, now here is a public reply...)

Christoph Hellwig (hch@lst.de) wrote:

> Using scsi_add_host/scsi_Remove_host gets rid of lots of cruft.
> The driver would still benefit from passing around objects instead of
> indices.
[...]
>  */
> -#ifdef CONFIG_CISS_SCSI_TAPE

Thanks for pointing out scsi_add_host/scsi_remove_host.  
I didn't know about those.
 
By removing CONFIG_CISS_SCSI_TAPE, the cciss driver then
always requires scsi to be compiled.  If CONFIG_CISS_SCSI_TAPE is
present, but turned off, then it is possible to use cciss 
without SCSI at all, so we probably want to keep it.

BTW, cciss_scsi.c is #included in cciss.c, which is not intuitive.
I couldn't figure a way to separately compile them and combine
them into a single module which did not require scsi at all when
the tape support was disabled.  So that's why it is the way it is.

Thanks

-- steve

