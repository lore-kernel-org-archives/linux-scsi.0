From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/21] advansys: Convert to pci_register_driver interface
Date: Thu, 26 Jul 2007 17:21:15 -0400
Message-ID: <46A9104B.60706@garzik.org>
References: <11854705774041-git-send-email-matthew@wil.cx> <46A8F689.108@garzik.org> <20070726204915.GS19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759638AbXGZVVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 17:21:18 -0400
In-Reply-To: <20070726204915.GS19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org


I'll respond to the other stuff soon, but I wanted to add:

>>> +	for (i = 0; i < asc_board_count; i++) {
>>> +		struct Scsi_Host *host = asc_host[i];
>>> +		if (!host)
>>> +			continue;
>>> +		scsi_remove_host(host);
>>> +		advansys_release(host);
>>> +		asc_host[i] = NULL;


It is wise to have two loops in module exit:

1) For each host, call scsi_remove_host()

2) For each host, {do the rest of the cleanup}

scsi_module.c behaves in this way.

There is no strict requirement to do this, but IMO it is wise because 
you don't have to worry about the SCSI midlayer passing new traffic to 
asc_host[x+1] while you are deactivating and freeing asc_host[x].

Obviously this goes away for the new-style PCI/EISA/ISA probe APIs, once 
asc_host[] goes away.

	Jeff


