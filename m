From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] s390 (8/10): zfcp fixes.
Date: Wed, 17 Mar 2004 11:35:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8DCA3DF7.E2D5F381-ONC1256E5A.0038C669-C1256E5A.003A3EB2@de.ibm.com>
References: <1079473944.1804.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:58836 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261369AbUCQKgB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 05:36:01 -0500
In-Reply-To: <1079473944.1804.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>

> > +ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n", zfcp_get_busid_by_unit(unit));
> > +ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n", unit->port->wwpn);
> > +ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n", unit->fcp_lun);
> These attributes all properly belong in the fibrechannel transport
> class, could you look at moving them over, please.

We can certainly do that for the wwpn (->port_name). For the fcp_lun we
would need to extend the fc transport class.
The hba_id doesn't belong to the fc transport class at all. It's just
the busid of our host adapter, so that we can identify it uniquely.

By the way, Christoph asked why we have the zfcp lldd in
drivers/s390/scsi. This is just for historical reasons. If you don't
mind seeing a ~32000 lines patch we can move it to drivers/scsi/zfcp.

Heiko

