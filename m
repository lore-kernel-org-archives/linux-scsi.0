From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] libfc: fix seconds_since_last_reset miscalculation
Date: Thu, 17 Nov 2016 14:48:42 +0100
Message-ID: <3375236.FqBgC7CYno@wuerfel>
References: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:62863 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752902AbcKQObI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 09:31:08 -0500
In-Reply-To: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Thursday, November 17, 2016 1:39:27 PM CET Johannes Thumshirn wrote:
> Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset calculation'
> removed the use of 'struct timespec' from fc_get_host_stats(). This broke the
> output of 'fcoeadm -s' after kernel 4.8-rc1.
> 
> Fixes: 540eb1eef ('scsi: libfc: fix seconds_since_last_reset calculation')
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

I actually made the same patch today and was going to send it out
after getting my other patches to build cleanly, but you were faster.

Are we worried about 32-bit systems overflowing here when the elapsed
time since the last reset is over 49 days? If we are, we probably
want another patch on top, though this one is sufficient to fix
the regression, and it has no problems on 64-bit machines.

	Arnd
