From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 03:00:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505100056.GI8416@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <3EB63188.3080703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:20376 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262124AbTEEJrF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 05:47:05 -0400
Content-Disposition: inline
In-Reply-To: <3EB63188.3080703@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> [HBA REMOVAL new]
> LLD                      mid level                 LLD
> ---                      ---------                 ---
> scsi_remove_host() ---------+
>                             |
>                      slave_destroy()
>                      slave_destroy()
>                         release()     -->     scsi_unregister()
> 
> In the new model there is nothing left to do after
> scsi_remove_host() has finished since everything happened
> during that call. The the LLD is re-entered to cleanup
> up any HBA specific device resources (slave_destroy()).
> Finally the LLD is re-entered by the release().
> 
> Also module unloads (should) use the ->remove
> method as well. Does the LLD need to know
> whether a HBA removal is hot or not?
> 

I believe Christoph is indicating that if something has a ref on
scsi_host and this causes the release to be called after the return from
scsi_remove_host than this would not be good. I believe the LLDD model
would stay like the old method except in the mid layer there would be a
change in how / when kfree(shost) is called.

LLD			mid level
scsi_remove_host()  -----+
                         |
		     slave_destroy()
		     slave_destroy()
		     slave_destroy()
scsi_unregister()  ------+
			 |
			 kfree of scsi_host may happen here or sometime
			 later depending on the ref count.


-andmike
--
Michael Anderson
andmike@us.ibm.com

