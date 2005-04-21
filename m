From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 23:18:51 +0200
Message-ID: <20050421211851.GS17315@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A922@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:14520 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S261884AbVDUVS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 17:18:58 -0400
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321A922@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

On 2005-04-21T17:02:44, "goggin, edward" <egoggin@emc.com> wrote:

> Depending on the "queue_if_no_path" feature has the current undesirab=
le
> side-effect of requiring intervention of the user space multipath com=
ponents
> to reinstate at least one of the paths to a useable state in the mult=
ipath
> target driver.  This dependency currently creates the potential for d=
eadlock
> scenarios since the user space multipath components (nor the kernel f=
or that
> matter) are currently architected to avoid them.

multipath-tools is, to a certain degree, architected to avoid them. And
the kernel is meant to be, too - there's bugs and known FIXME's, but
those are just bugs and we're taking patches gladly ;-)

> I think for now it may be better to try to avoid having to fail a pat=
h if it
> is possible that an io error is not path related.

No. Basically every time out error creates a "dunno why" error right no=
w
- could be the storage system itself, could be the network in between.

A failover to another path is the obvious remedy; take for example the
CX series where even if it's not the path, it's the SP, and failing ove=
r
to the other SP will cure the problem.

If the storage at least rejects the IO with a specific error code, it
can be worked around by a specific hw handler which doesn't fail the
path but just causes the IO to be queued and retried; that's a pretty
simple hardware handler to write.

But quite frankly, storage subsystems which _reject_ all IO for a given
time are just broken for reliable configurations. What good are they in
multipath configurations if they fail _all_ paths at the same time? How
can they even dare claim redundancy? We can build more or less smelly
kludges around them, but it remains a problem to be fixed at the storag=
e
subsystem level IMNSHO.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
