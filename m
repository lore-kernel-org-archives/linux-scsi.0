From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] zfcp: add rports to enable scsi_add_device to work
	again
Date: Sat, 27 Aug 2005 12:38:27 -0500
Message-ID: <1125164308.5159.21.camel@mulgrave>
References: <20050827120136.GA8412@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8580 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751625AbVH0Ric (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 13:38:32 -0400
In-Reply-To: <20050827120136.GA8412@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sat, 2005-08-27 at 14:01 +0200, Andreas Herrmann wrote:
> this patch fixes a severe problem with 2.6.13-rc7.
> 
> Due to recent SCSI changes it is not possible to add any
> LUNs to the zfcp device driver anymore. With registration
> of remote ports this is fixed.
> 
> Please integrate the patch in the 2.6.13 kernel or if it
> is already too late for this release then please integrate it
> in 2.6.13.1
> 
> Thanks a lot.

Well, OK, but your usage isn't quite optimal.  The fibre channel
transport class retains a list of ports per host, so your maintenance of
an identical list in zfcp_adapter duplicates this.

However, we can put this in for now and worry about removing all of the
fc transport class duplication from zfcp later.

James


