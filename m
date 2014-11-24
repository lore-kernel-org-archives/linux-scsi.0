From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_debug: switch to table based parser
Date: Mon, 24 Nov 2014 10:00:35 +0100
Message-ID: <5472F3B3.9070602@suse.de>
References: <54496606.3050608@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaKXJAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 04:00:37 -0500
In-Reply-To: <54496606.3050608@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 10/23/2014 10:33 PM, Douglas Gilbert wrote:
> Changing a frequently hacked, big switch parser to being table
> based is, of necessity, not a small patch. Testing showed up
> some breakages which required extra code and re-factoring.
> Since supporting the REPORT SUPPORTED OPERATION CODES command,
> checking cdbs for non-zero values in reserved locations, and
> the table based parser are closely related; implementing them
> at the same time seemed to be practical. But some additions,
> such as the COMPARE AND WRITE command, should really be in
> their own patches (but adding new bugs was a useful technique
> for finding existing ones).
>=20
> The first attachment is large and against Christoph's
> drivers-for-3.19 branch. It will also apply to his
> drivers-for-3.18 branch. The second, smaller attachment is
> for anyone who wants to look at (or try) this patch on
> lk 3.17.1; first apply the second patch, then the first.
> Almost all of my testing has been on lk 3.17.0 and .1 .
>=20
> Perhaps contributors to this driver, such as Martin Petersen
> who has written large parts of this driver (e.g. logical block
> provisioning, DIF and error injection), might run any test
> cases they have to determine what I have broken.
>=20
> Speed improvements at this stage are marginal at best.
>=20
> ChangeLog:
>    - remove big switch statement in queuecommand() and replace
>      with a table based parser
>    - implement REPORT SUPPORTED OPERATION CODES command which
>      reads that table
>    - add 'strict' option which when set will cause each incoming
>      cdb to be checked against the cdb usage mask held in the
>      table based parser
>    - add logic for ILLEGAL REQUEST sense key specific field
>      pointers, use for most ILLEGAL REQUESTs
>    - add 'capacity data has changed' unit attention since the
>      virtual_gb  option can be changed on-the-fly
>    - implement REPORT SUPPORTED TASK MANAGEMENT FUNCTIONS command
>    - implement COMPARE AND WRITE command
>    - implement NDOB (no data-out buffer) in WRITE SAME(16)
>    - make GET LBA STATUS work when no logical block provisioning
>=20
> Todo:
>    - re-order teardown in scsi_debug_exit()
>    - make sdebug_dev_info::stopped atomic (add to end of uas_bm ?)
>    - review Rob Elliott's suggestions; look at speed ups
>    - remove host_lock logic and make the host_lock option a dummy
>    - update some mode page and VPD data to reflect more recent
>      devices
>    - changing remaining >> and << byte handling over to
>      get/put_unaligned_be*()
>    - set INFO field for COMPARE AND WRITE command MISCOMPAREs
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Hmm. There are at least three things packed into this patch:
- Table-based parsing
- Sense code generation fixes for invalid field in cdb
- Additional cdb decoding.

Can you please split the patch into logical sections, eg
patches for
- sense code generation improvements
- table-based parsing
- Additional CDB decoding

With that it should be easier to review.

And please add a definition to XDWRITEREAD(10) to
include/scsi/scsi.h instead of using the raw value
in scsi_debug.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
