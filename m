From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 14:17:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096463876.15905.23.camel@localhost.localdomain>
References: <415A67B8.2080003@suse.de>  <1096466196.2028.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:6794 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268447AbUI2OUy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 10:20:54 -0400
In-Reply-To: <1096466196.2028.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mer, 2004-09-29 at 14:56, James Bottomley wrote:
> The key to the solution of this problem is to know what USB is trying to
> do with the dead device.  SCSI is trying to be polite and explicitly
> kill the outstanding commands before it removes the HBA.  Presumably USB
> is returning something that says this can't be done so the EH gets all
> the way up to offlining.

Its nothing to do with USB, rmmod with eh running crashes all the other
SCSI drivers I've tested too. After the state transition fails you get
kobject related errors and a crash. 

That makes me suspect whatever is ill is in the scsi core.

Alan

