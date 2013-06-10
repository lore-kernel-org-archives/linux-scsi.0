From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 19:24:47 -0400
Message-ID: <20130610232446.GD18076@logfs.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-4-git-send-email-hare@suse.de>
 <20130610082001.GB7816@infradead.org>
 <51B595C1.8040106@suse.de>
 <20130610151916.GA18076@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59521 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3FKAyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 20:54:18 -0400
Content-Disposition: inline
In-Reply-To: <20130610151916.GA18076@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On Mon, 10 June 2013 11:19:16 -0400, J=C3=B6rn Engel wrote:
>=20
> I don't care too much whether we use per-command work items or a
> single system-global thread.

Actually, I do care.  We have to abort the commands in parallel, as a
fairly large number of abort can queue up and individual aborts can
take 20s on hardware I care about.

20s for an abort is pretty bad, but given today's reality there is no
need to make things worse by serializing.

J=C3=B6rn

--
A defeated army first battles and then seeks victory.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
