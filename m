From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [PATCH 2.4 2/2] cpqfc: Reduce stack usage of 2 functions
Date: Tue, 3 Jan 2006 08:29:14 -0200
Message-ID: <20060103102914.GA3760@dmt.cnet>
References: <200601021244.40636@bilbo.math.uni-mannheim.de> <200601021305.38412@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:1255 "EHLO hera.kernel.org")
	by vger.kernel.org with ESMTP id S932356AbWACNaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 08:30:20 -0500
Content-Disposition: inline
In-Reply-To: <200601021305.38412@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 02, 2006 at 01:05:37PM +0100, Rolf Eike Beer wrote:
> There are 2 function that do a lookup to the queue and buffer the result. 
> They only care about the first few bytes (to be exactly: 38*sizeof(u32)), 
> but they always pass a buffer of 2kB, which is located on the stack.
> 
> This patch reduces this buffer to the really needed size and changes it's 
> type to the correct target type. The rest of the queue is still looked up 
> but the result is ignored (as it would anyway).
> 
> There are also some small cleanups for the other arguments of 
> CpqTsGetSFQEntry(), which is the lookup function.

Hi Rolf,

Is there an evidence that the gratuitous stack usage is causing problems with
an 8kB stack? 

In other ways, this looks more like an optimization than a serious bugfix? 
