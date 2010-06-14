From: Hannes Reinecke <hare@suse.de>
Subject: megaraid_sas locks down frame count to 8
Date: Mon, 14 Jun 2010 16:30:49 +0200
Message-ID: <4C163D19.2030905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0FNOau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2010 10:30:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

we have this bit in drivers/scsi/megaraid/megaraid_sas.c:799

	if (frame_count > 7)
		frame_count =3D 8;

which is supposed to report the number of frames required
to handle the passed in sg list.
This results in a nice memory scribble if we pass in a
large enough sg list, as the sg list contents will then
written in the memory area for the next frame.

Any comments here?

If it were me I would just remove that check, but
then LSI might have a valid reason for doing so.

Cheers,

Hannes
--
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
