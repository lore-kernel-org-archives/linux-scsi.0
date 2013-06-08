From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] target: Add transport_cmd_check_stop write_pending
	bit
Date: Sat, 8 Jun 2013 08:29:29 +0200
Message-ID: <20130608062929.GA27566@lst.de>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org> <1370640864-15568-2-git-send-email-nab@linux-iscsi.org> <20130608040035.GA2580@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42493 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3FHGh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jun 2013 02:37:28 -0400
Content-Disposition: inline
In-Reply-To: <20130608040035.GA2580@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>

On Sat, Jun 08, 2013 at 12:00:36AM -0400, J=F6rn Engel wrote:
> > -static int transport_cmd_check_stop(struct se_cmd *cmd, bool remov=
e_from_lists)
> > +static int transport_cmd_check_stop(struct se_cmd *cmd, bool remov=
e_from_lists,
> > +				    bool write_pending)
> ...
>=20
> > -	return transport_cmd_check_stop(cmd, true);
> > +	return transport_cmd_check_stop(cmd, true, false);
>=20
> At this point I would prefer to pass in a flags.
> transport_cmd_check_stop(cmd, SC_REMOVE_FROM_LISTS) seems more
> readable to me.

The whole area needs a major cleanup.  The list removal is mostly unrel=
ated
to the rest of the function, so it really should be split out.

Tje all to target_remove_from_state_list actually happens unconditional=
y,
just that in the CMD_T_LUN_STOP case it is done after clearing CMD_T_AC=
TIVE.

I can't see a reason for that delay, so unless proven otherwise the cal=
l
to it should be lifted from transport_cmd_check_stop to
transport_cmd_check_stop_to_fabric.  The same probably applies to the c=
learing
of cmd->se_lun, and the call to ->check_stop_free can already be done i=
n
the caller just based on the return value from transport_cmd_check_stop=
=2E

Then we can replace the irqsave locking with just _irq locking because=20
static int transport_cmd_check_stop should never be called with irqs
disabled and finally add a variant that has the lock already taken
instead of adding the new flag.

Longer term down the road we should get rid of the _irq locking in the =
target
core entirely.  As we moved all major work to workqueues a while ago no=
thing
should be nessecary although a small audit is needed first.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
