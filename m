From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address if the adapter lacks one
Date: Wed, 10 Oct 2007 12:38:42 -0700 (PDT)
Message-ID: <105757.49287.qm@web31805.mail.mud.yahoo.com>
References: <470CE78B.2080509@emulex.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:40797 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756307AbXJJTio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2007 15:38:44 -0400
In-Reply-To: <470CE78B.2080509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

--- James Smart <James.Smart@Emulex.Com> wrote:
> Here's one pro for setting WWNs at arbitrary times...
>    If the box is migrating applications (say containers) that want
>    different SAN connectivity, where that connectivity (view) is based
>    on their WWN, it would be really nice to selectively set the WWN and
>    not touch the SAN config.

No.  The WWN stays the same and the SAN is re-configured to be
aware of the node migration.  Access patterns could be more
complex than just a single portal allowing access to/from the
SAN from/to the node.

WWN is supposed to be persistent.  This is what it actually is.
It is NOT supposed to be "(auto)generated" and/or changed at a whim.

This also has security implications, and enterprise networks may
refuse to use software (read "kernel") which allows for arbitrary
changes to a node's WWN.

If access to a node is compromised, a rogue agent may change
the node's WWN in order to access SAN zones that it normally
will be denied access to.

    Luben

