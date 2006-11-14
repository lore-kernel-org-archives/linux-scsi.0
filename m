From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sas_ata: satisfy libata qc function locking requirements
Date: Tue, 14 Nov 2006 18:07:03 -0500
Message-ID: <455A4C17.5000902@garzik.org>
References: <455A395D.1060407@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:25043 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S966447AbWKNXHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 18:07:06 -0500
In-Reply-To: <455A395D.1060407@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> ata_qc_complete and ata_sas_queuecmd require that the port lock be held
> when they are called.  sas_ata doesn't do this, leading to BUG messages
> about qc tags newly allocated qc tags already being in use.  This patch
> fixes the locking, which should clean up the rest of those messages.
> 
> So far I've tested this against an IBM x206m with two SATA disks with no
> BUG messages and no other signs of things going wrong, and the machine
> finally passed the pounder stress test.  The patch is against jejb's
> aic94xx-sas tree.
> 
> --
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

heh, yeah, proper locking helps :)

Glad to hear the progress.  Adaptec just sent me a cable that will allow 
me to use my Razor card as a SATA controller, so I can finally start 
testing that.

	Jeff



