From: "Tony Aiello" <Tony.Aiello@pmcs.com>
Subject: Scattererd write support
Date: Wed, 29 May 2013 08:04:06 -0700
Message-ID: <40A0B8B92CE0F94685A03264958540C4B1036A@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca>
References: <40A0B8B92CE0F94685A03264958540C4B10355@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49981 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966381Ab3E2PEH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 May 2013 11:04:07 -0400
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id DC2A28E0222
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2013 08:04:06 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (bby1exg02 [216.241.231.167])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with SMTP id CE5508E01C5
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2013 08:04:06 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <40A0B8B92CE0F94685A03264958540C4B10355@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There's T10 work describing scattered write operations and an evolving =
spec from SNIA about Non-Volatile Memory operations on flash of atomic =
multiwrite. These take advantage of the fact that flash has no locality=
 and that writing to a vector of block addresses in an atomic manner is=
 not all that different for a flash translation layer than processing a=
ny other write operation.

However, the expression of these writes - and the corresponding gathere=
d reads, don't look like any other write/read operation.Writev, readv c=
ome close as they have a vector of memory addresses, but lack =A0a vect=
or of block addresses as well.

Naturally this isn't just a storage stack problem. The expression of a =
vector of blocks in addition to a vector of memory addresses needs supp=
ort thru the file operations definition to allow applications to access=
 the methods.=20

But for this I'm interested in knowing if there's any thoughts/work on =
the SCSI stack to support this write scattered operation.=20

Thanks.

Tony

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
