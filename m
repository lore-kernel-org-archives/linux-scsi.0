From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 13:36:36 -0500
Message-ID: <20081107183636.GB29717@mit.edu>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42851 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbYKGSgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 13:36:42 -0500
Content-Disposition: inline
In-Reply-To: <4914846C.5060103@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Fri, Nov 07, 2008 at 01:09:48PM -0500, Ric Wheeler wrote:
>
> I don't think that trim bugs should be that common - we just have to be  
> very careful never to send down a trim for any uncommitted block.
>

The trim code probably deserves a very aggressive unit test to make
sure it works correctly, but yeah, we should be able to control any
trim bugs.

> Simple is always good, but I still think that the coalescing (even basic  
> coalescing) will be a critical performance feature.

Will we be able to query the device and find out its TRIM/UNMAP
alignment requirements?  There is also a balanace between performance
(at least if the concern is sending too many separate TRIM commands)
and giving the SSD more flexibility in its wear-leveling allocation
decisions by sending TRIM commands sooner rather than later.

	     	     	  	   	  	 - Ted
