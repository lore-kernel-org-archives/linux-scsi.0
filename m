From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [oops] rmmod aic7xyz (2.6.14-rc3 and 2.6.13)
Date: Sun, 02 Oct 2005 11:29:26 +0200
Message-ID: <433FA876.2010108@s5r6.in-berlin.de>
References: <20051001221746.54d26f43.rdunlap@xenotime.net> <433FA586.8020002@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:194 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751037AbVJBJ3c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 05:29:32 -0400
In-Reply-To: <433FA586.8020002@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, jejb <james.bottomley@steeleye.com>

I wrote:
> The solution is probably to add calls to scsi_remove_device() for each 
> device on the host as first action in ahc_linux_pci_dev_remove(). That 
> way, scsi high-level drivers are able to perform their shutdown 
> functions before the host adapter ceases to operate.

scsi_remove_host(), if called before any ahc_... action, is perhaps be 
able to accomplish the same.

> More care needs to be taken for hotswappable hardware. I don't know if 
> aic7xxx falls into this category. If yes, ahc_linux_queue() must be made 
> aware of that the adapter is gone and has to immediately complete any 
> commands with DID_NO_CONNECT. Similarly, the eh handlers should take 
> shortcuts when the adpater is gone.
> 
> AFAIK.
-- 
Stefan Richter
-=====-=-=-= =-=- ---=-
http://arcgraph.de/sr/
