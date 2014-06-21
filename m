From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] sg: O_EXCL and other lock handling
Date: Sat, 21 Jun 2014 13:01:21 +0200
Message-ID: <53A56601.9010701@suse.de>
References: <539A453F.5020502@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaFULBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2014 07:01:25 -0400
In-Reply-To: <539A453F.5020502@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, vaughan <vaughan.cao@oracle.com>

On 06/13/2014 02:26 AM, Douglas Gilbert wrote:
> This is a re-presentation of a patch to the sg driver
> whose v3 was sent in November 2013:
>    http://www.spinics.net/lists/linux-scsi/msg69957.html
>
> It addresses a problem reported by Vaughan Cao concerning
> the correctness of the O_EXCL logic in the sg driver. POSIX
> doesn't defined O_EXCL semantics on devices but "allow only
> one open file descriptor at a time per sg device" is a rough
> definition. The sg driver's semantics have been to wait
> on an open() when O_NONBLOCK is not given and there are
> O_EXCL headwinds. Nasty things can happen during that wait
> such as the device being detached (removed). So multiple
> locks are reworked in this patch making it large and hard
> to break down into digestible bits.
>
> This patch is against Linus's current git repository which
> doesn't include any sg patches sent in the last few weeks.
> Hence this patch touches as little as possible that it
> doesn't need to and strips out most SCSI_LOG_TIMEOUT()
> changes in v3 because Hannes said he was going to rework all
> that stuff.
>
> The sg3_utils package has several test programs written to
> test this patch. See examples/sg_tst_excl*.cpp .
>
> Not all the locks and flags in sg have been re-worked in
> this patch, notably sg_request::done . That can wait for
> a follow-up patch if this one meets with approval.
>
> ChangeLog v4:
>    - based on the current kernel tree: pre 3.16-rc1
>    - strip out clean-ups in v3 that others are better
>      placed to do (e.g. debug/logging)
>    - simplify open_wait_event() logic and add comment
>
> ChangeLog v3 and earlier: see link in the first paragraph.
>
>
> Could anyone confirm whether v3 of this patch has found its
> way into any distro and/or been tested or used more widely?
>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>
>
We've tested a similar version here.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
