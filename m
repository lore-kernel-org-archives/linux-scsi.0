From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi driver - third version
Date: Wed, 25 Feb 2004 13:45:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225134518.A4238@infradead.org>
References: <opr3u0ffo7l6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:4881 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261327AbUBYNpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 08:45:22 -0500
Content-Disposition: inline
In-Reply-To: <opr3u0ffo7l6e53g@us.ibm.com>; from sleddog@us.ibm.com on Mon, Feb 23, 2004 at 11:34:17PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 23, 2004 at 11:34:17PM -0600, Dave Boutcher wrote:
> This is the third version of the SCSI driver to support the adapter 
> implemented by the IBM Power5 firmware.  I have incorporated all comments 
>  from the previous submissions.  Probably the most significant functional 
> change is that all locking is done with the host_lock now.

This one still has the issue with error returns from queuecommand.

Here are the rules for queuecommand again:

 - either your return 0, then you must finish the command through it's
   ->done callback
 - or you return SCSI_MLQUEUE_HOST_BUSY/SCSI_MLQUEUE_DEVICE_BUSY and must
   _not_ call ->done.

There's also a fair share of style issues left.  What about simply running
it through scripts/Lindent?

