From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/17] scsi_dh_alua: simplify sense code handling
Date: Tue, 12 May 2015 10:20:49 +0200
Message-ID: <20150512082049.GC27168@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-12-git-send-email-hare@suse.de> <20150511065802.GH30516@lst.de> <5550C21E.1040103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44178 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbELIUu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 04:20:50 -0400
Content-Disposition: inline
In-Reply-To: <5550C21E.1040103@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, May 11, 2015 at 04:52:14PM +0200, Hannes Reinecke wrote:
> Sigh. This is one of the sore topics with the SCSI stack.
>=20
> The default sense code handling is correct only for filesystem
> I/O; BLOCK_PC callers are expected to handle all errors themselves.
> Which typically is a pain as one always forgets the one or the
> other issue.
>=20
> The device handlers have a callout into that generic function
> to handle and device handler specific sense codes.
>=20
> So with that I do agree that calling alua_check_sense() here
> is dubious as it should have been run from the generic path already.
>=20
> Will be checking and fixing it up.

What I meant is that we really shouldn't handle the sense codes in
the ALUA handler - they are generic SCS=D0=86 sense codes and we'd bett=
er
handle them in the core code, ditto for the other device handlers actua=
lly.

Now the problem of BLOCK_PC ignoring the sense handling is a different
one, but why don't we export scsi_check_sense and allow BLOCK_PC caller=
s
like the device handlers reuse the logic instead of duplicating it?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
