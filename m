From: Hannes Reinecke <hare@suse.de>
Subject: Re: [V2 PATCH 2/2] scsi: TUR path is down after adapter gets reset
 with multipath
Date: Wed, 05 Nov 2014 09:56:24 +0100
Message-ID: <5459E638.6010707@suse.de>
References: <20141103211806.572351346@linux.vnet.ibm.com> <20141103211815.000777763@linux.vnet.ibm.com> <54587E69.50108@suse.de> <20141104150152.GA17309@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKEI40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 03:56:26 -0500
In-Reply-To: <20141104150152.GA17309@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: wenxiong@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, "Elliott, Robert (Server Storage)" <elliott@hp.com>

On 11/04/2014 04:01 PM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 08:21:13AM +0100, Hannes Reinecke wrote:
>> Why did you use a wrapper for an already existing function?
>> Please fold the logic into alua_check_sense().
>=20
> That's what the first version did.  See the response from Rob to it
> on why it's done this way.

Hmm. I see. But I still thing it should be wrapped into
alua_check_sense().
The main objection from Rob was that a sense code of 02/04/02 should
cause a START STOP UNIT to be sent, but the latter is might be
invalid for certain ALUA states.
Thing is, we're only sending START STOP UNIT as part of the main
SCSI EH routine, so that would work in either way.

And looking a scsi_dh_alua we're only checking a return value of
ADD_TO_MLQUEUE; any other value is treated as an I/O error.
So it doesn't really matter if alua_check_sense would return
=46AILED here; it still would be folded into the final return value of
SCSI_DH_IO.

So I don't think we need to have a wrapper around alua_check_sense()
but can rather merge them both.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
