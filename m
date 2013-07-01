From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Mon, 1 Jul 2013 13:44:23 -0400
Message-ID: <20130701174423.GA10645@logfs.org>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59699 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3GATPB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 15:15:01 -0400
Content-Disposition: inline
In-Reply-To: <1372661455-122384-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Mon, 1 July 2013 08:50:48 +0200, Hannes Reinecke wrote:
>=20
> This patchset implements a new 'eh_deadline' attribute to the
> SCSI host. It will limit the overall SCSI EH runtime by a given
> timeout. If the timeout is reached all intermediate EH steps
> will be skipped and host reset will be scheduled immediately.

I have mixed opinions about the concept.

Having a command timeout is of limited use if you can still spend
several minutes after the timeout in random processing.  Userspace
either needs -EIO reasonably quickly after a command timeout or will
have to implement it's own timeout mechanism.  I prefer having a
single implementation in the kernel, so your patches are a step in the
right direction.

Host reset is an expensive and harmful operation.  You lose access to
all devices behind the host.  At best this is a performance blip, at
worst someone actually cared about some realtime properties.  My main
grump is that a single bad device can trigger this behaviour,
essentially doing a DoS on the rest of the system.  While that problem
is somewhat orthogonal, your patchset can only make matters worse.

Ideally we would have a way to detect the system geometry and next the
error location.  If a single device is bad, don't ever do a host
reset.  If you have redundant paths, never do a host reset on both
controllers at the same time.  Etc, etc.

Getting there will be a lot of work and the result may be too
error-prone to maintain without constantly breaking one exotic setup
or another.  But if someone could pull it off, it would be really nice
to have.

That said, now I should actually read your patches. ;)

J=C3=B6rn

--
Measure. Don't tune for speed until you've measured, and even then
don't unless one part of the code overwhelms the rest.
-- Rob Pike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
