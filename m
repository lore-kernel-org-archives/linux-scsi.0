From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: ibmvscsi compile error in 2.6.20-rc1
Date: Sun, 10 Dec 2006 23:00:23 +1100
Message-ID: <20061210230023.8defde28.sfr@canb.auug.org.au>
References: <20061210114806.GA8687@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:36883 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758397AbWLJMAT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Dec 2006 07:00:19 -0500
In-Reply-To: <20061210114806.GA8687@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org

On Sun, 10 Dec 2006 12:48:03 +0100 (MET) Olaf Hering <olaf@aepfle.de> wrote:
>
> This happens when client and server are enabled.
> And CONFIG_ISERIES is enabled too in my ppc64_defconfig.

Known problem.  There is a patch available.  I am hoping Paulus will put
it in soon ...

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index 4e247b6..6661d74 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,5 +1,7 @@
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
 
 ibmvscsic-y			+= ibmvscsi.o
+ifneq ($(CONFIG_PPC_PSERIES),y)
 ibmvscsic-$(CONFIG_PPC_ISERIES)	+= iseries_vscsi.o 
+endif
 ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
