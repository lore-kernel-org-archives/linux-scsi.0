From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sat, 03 Jan 2004 15:24:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1281722704.1073168654@aslan.scsiguy.com>
References: <1073076654.2048.19.camel@opiate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:41735 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S264322AbUACWYQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jan 2004 17:24:16 -0500
In-Reply-To: <1073076654.2048.19.camel@opiate>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>, linux-scsi@vger.kernel.org

> Loading the aic7xxx or aic79xx modules, on a machine that did not
> contain the card, left a stale entry in the pci_device list.  This
> caused an oops upon loading the next module that registered a
> pci_device. 
> 
> The patches below will unregister the pci_device if it successfully
> registers the device, but does not find any cards. 
> 
> Comments are appreciated.

A more complete solution is to have the generic init function call
the exit function before returning failed status.  This ensures that
*any state*, not just PCI state, is properly cleaned up.

--
Justin

