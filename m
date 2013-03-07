From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Thu, 7 Mar 2013 14:13:19 -0600
Message-ID: <5138F4DF.9010906@tributary.com>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <5138E84B.8030803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:31735 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3CGUN0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 15:13:26 -0500
In-Reply-To: <5138E84B.8030803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/7/2013 1:19 PM, Mike Christie wrote:
> What happens for lpfc? It seems __fc_remote_port_delete ends up calling the
> fast io fail code right away and that sets FC_RPORT_FAST_FAIL_TIMEDOUT. We
> will then call lpfc_terminate_rport_io which only will send aborts for the
> commands. We will then call fc_block_scsi_eh above and that returns
> FAST_IO_FAIL and we will pass that back up to the scsi eh right away.

	
	For lpfc, you never get to the code. Or rather when I was testing it, I
couldn't find any way to propagate an error beyond the initial
lpfc_reset_flush_io_context() call in lpfc_device_reset_handler().

	That call pretty much always returns success indpependent of the remote
device because the firmware acks the context clear aborts, resulting in the
outstanding iocb count being zero (independent of both the mid layer status
and the actual device state).
	
	Result: all the code beyond the device reset handler never gets called.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJROPTfAAoJEL5i86xrzcy7MSMIAKaUZV1sfE55/n95b28WTdAS
7HdUechq5JRh2jqW+PVQub3iADgjl5RZkj8T3vNTZgzR9pcQ6NE/qdkwho+p29Wx
enBa68HMosO+oiqPVSz7mmyuOsubB/DxPC3D+5ODu3nTJNMBxE4wYgdfGYsXVZS7
f/HCLo0Ysg7SBzTBQKvk0E1UtMJv1miEsIgxxqYSvOAOcHtKwUaYtCclE2z9egby
AnyVV1UrVa/cI8R4w0nArnyLCrLzG4IVAMByyb0KAQ3NKOdxGPqxPTkoY6GEpcQ9
GxzoZVWerGbzdjYXz2gckiN8oonBIB3esrrOTyq14sTqfOxtynH+8X3qS2uRFhg=
=t9Gx
-----END PGP SIGNATURE-----
