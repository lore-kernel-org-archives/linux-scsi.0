From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.12-rc4-mm1 3/4] megaraid_sas: updating the driver
Date: Mon, 16 May 2005 09:18:03 -0500
Message-ID: <1116253084.5040.1.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCE7C@exa-atlanta>
	 <1116230776.6274.20.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12716 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261659AbVEPOS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 10:18:28 -0400
In-Reply-To: <1116230776.6274.20.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

On Mon, 2005-05-16 at 10:06 +0200, Arjan van de Ven wrote:
> > +			spin_lock( instance->host_lock );
> > +			cmd->scmd->scsi_done( cmd->scmd );
> > +			spin_unlock( instance->host_lock );
> 
> are you really sure you don't want to use spin_lock_irqsave() here ?

Actually, don't bother with the lock at all.  scsi_done() is designed to
be called locklessly.

James


