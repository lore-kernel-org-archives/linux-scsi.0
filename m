From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Thu, 05 Feb 2004 08:56:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075989386.19275.1895.camel@bianchi.boston.redhat.com>
References: <OFCBD64150.59466282-ON87256E31.0002462C-88256E31.0002E095@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37302 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265269AbUBEN70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 08:59:26 -0500
In-Reply-To: <OFCBD64150.59466282-ON87256E31.0002462C-88256E31.0002E095@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Martin Peschke3 <MPESCHKE@de.ibm.com>, "Robert J. Adams (jason)" <radams@siscom.net>

On Wed, 2004-02-04 at 19:33, Bryan Henderson wrote:

> I stand corrected.  Upon further investigation, I realize that I confused 
> WWN with WWNN.  WWN (worldwide name) is a generic term referring to, well, 
> world wide names.  There are at least 3 WWNs in FCP systems:  WWPN 
> (worldwide port name) to identify a port in an FC network, WWNN (worldwide 
> node name) to identify a node in an FC network, which corresponds to an 
> FCP target (physical unit), and a logical unit WWN, which I have seen 
> called LUSN (Logical Unit Serial Number), but now I see others calling it 
> the LU WWN and logical unit name too.
> 
> I haven't see any relevant standards, but I'll take your word for it that 
> SPC-3 calls the VPD field in question a 'WWN' and because it's a VPD page 
> for a logical, that means it is the LU WWN.

Each identifier on the SPC-3 Device Identification VPD page (page 83)
has an "association" field, with one of the following values:

- The IDENTIFIER field is associated with the addressed logical unit. 
- The IDENTIFIER field is associated with the SCSI target port that
received the request. 
- The IDENTIFIER field is associated with the SCSI target device that
contains the addressed logical unit. 

So, an identifier on page 83 may be either an LU WWN, WWPN, or a WWNN. 

We need to check the association field, and use the identifier
appropriately, and we need to insist that storage vendors implement it
correctly.




