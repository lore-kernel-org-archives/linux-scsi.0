From: Christoph Hellwig <hch@lst.de>
Subject: Re: IA32 (2.6.1 - 2003-12-30.22.30) - 4 New warnings (gcc 3.2.2)
Date: Wed, 31 Dec 2003 13:08:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031231120824.GB16225@lst.de>
References: <200312311132.hBVBWcg6008411@cherrypit.pdx.osdl.net> <20031231040047.19174e49.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:54172 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264310AbTLaMI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 07:08:28 -0500
Content-Disposition: inline
In-Reply-To: <20031231040047.19174e49.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: John Cherry <cherry@osdl.org>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Dec 31, 2003 at 04:00:47AM -0800, Andrew Morton wrote:
> John Cherry <cherry@osdl.org> wrote:
> >
> > drivers/scsi/aacraid/aachba.c:1409: warning: `flag' might be used uninitialized in this function

hmm, I don't get that warning, but I guess some gcc versions aren't
smart enough to figure out that the four values we handle are the only
possible one, "fix" below:


--- 1.21/drivers/scsi/aacraid/aachba.c	Wed Nov 19 19:36:23 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Wed Dec 31 14:06:40 2003
@@ -1427,6 +1427,7 @@
 		flag = SRB_DataIn;
 		break;
 	case DMA_NONE:
+	default:	/* shuts up some versions of gcc */
 		flag = SRB_NoDataXfer;
 		break;
 	}
