From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/20] ALUA device handler update, part II
Date: Tue, 8 Dec 2015 16:06:10 +0100
Message-ID: <5666F1E2.5090801@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbbLHPGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 10:06:11 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/08/2015 08:37 AM, Hannes Reinecke wrote:
> Hi all,
>
> as promised here is now the second part of my ALUA device handler upd=
ate.
> This contains a major rework of the ALUA device handler as execution =
is
> moved onto a workqueue. This has the advantage that we avoid having t=
o
> do multiple calls to the same LUN (as happens frequently when failing
> over a LUN with several paths) and finally retries are handled correc=
tly.
> As some arrays are only capable of handling one STPG at a time I've a=
dded
> a module parameter 'sync_stpg' which switches to a singlethreaded
> workqueue, thereby effectively synchronize STPG handling.
> Thanks to Bart for this suggestion.
>
> As usual, comments and reviews are welcome.
>
As I've been reminded a git reference would be welcome for review.
So you can find the entire patchset at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
branch alua.v8

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
