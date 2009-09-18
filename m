From: David Miller <davem@davemloft.net>
Subject: Re: [net-2.6 PATCH 1/6] net: initialize rmem_alloc and omem_alloc
 to 0 in netlink socket
Date: Thu, 17 Sep 2009 18:29:30 -0700 (PDT)
Message-ID: <20090917.182930.202162971.davem@davemloft.net>
References: <20090918005708.25594.52575.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57860
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbZIRB3N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2009 21:29:13 -0400
In-Reply-To: <20090918005708.25594.52575.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, gospo@redhat.com, linux-scsi@vger.kernel.org, john.r.fastabend@intel.com

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 17 Sep 2009 17:57:09 -0700

> From: John Fastabend <john.r.fastabend@intel.com>
> 
> The rmem_alloc and omem_alloc socket fields are not
> initialized.  This sets each variable to zero when a socket
> is created.  Note the sk_wmem_alloc is already initialized
> in sock_init_data.
> 
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

It's set to zero implicitly by the memset() done at sock_alloc()
time.

Re-setting it again here explicitly will just add unnecessary
memory traffic.
