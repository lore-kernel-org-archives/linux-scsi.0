From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Mon, 15 Apr 2002 15:51:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204152051.g3FKpOa25340@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Mon, 15 Apr 2002 14:40:39 MDT." <200204152040.g3FKed982111@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

gibbs@scsiguy.com said:
> Looking at the latest version of your tree via bitkeeper, it seems
> that the wrong patch has been applied to sd.c.  In its current state,
> the disk driver will fail to act upon any sense data returned by the
> low level controller.  The following patch restores correct behavior. 

Actually, this should be using the scsi_sense_valid() function call in 
scsi_error.c, shouldn't it?  Especially since the criterion for valid sense is 
merely that bit 7 be set with the error code (which can be either 0x70 or 
0x71) in bits 0-6.

James


