From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] hpsa: work in progress "lockless monster" patches
Date: Sun, 27 Jul 2014 17:24:46 +0200
Message-ID: <53D519BE.9000204@suse.de>
References: <20140725192859.GU14599@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaG0PYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2014 11:24:51 -0400
In-Reply-To: <20140725192859.GU14599@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, martin.petersen@oracle.com, thenzl@redhat.com, hch@infradead.org, bvanassche@acm.org, axboe@kernel.dk, elliott@hp.com, scott.teel@hp.com, webbnh@hp.com, joseph.t.handzik@hp.com, justin.lindley@hp.com

On 07/25/2014 09:28 PM, scameron@beardog.cce.hp.com wrote:
>
> hpsa: Work In Progress: "lockless monster" patches
>
> To be clear, I am not suggesting that these patches be merged at this=
 time.
>
> This patchset is vs. Christoph Hellwig's scsi-mq.4 branch which
> may be found here: git://git.infradead.org/users/hch/scsi.git
>
> We've been working for a long time on a patchset for hpsa to remove
> all the locks from the main i/o path in pursuit of high IOPS.  Some
> of that work is already upstream, but a lot more of it is not quite
> yet ready to be merged.  However, I think we've "gone dark" for a bit
> too long on this, and even though the patches aren't really ready to
> be merged just yet, I thought I should let other people who might be
> interested have a look anyway, as things are starting to be at least
> more stable than unstable.  Be warned though, there are still some
> problems, esp. around error recovery.
>
> That being said, with the right hardware (fast SAS SSDs, recent Smart
> Arrays e.g. P430, with up-to-date firmware, attached to recent disk e=
nclosures)
> with these patches and the scsi-mq patches, it is possible to get aro=
und
> ~970k IOPS from a single logical drive on a single controller.
>
> There are about 150 patches in this set.  Rather than bomb the list
> with that, here is a link to a tarball of the patches in the form of
> an stgit patch series:
>
> https://github.com/smcameron/hpsa-lockless-patches-work-in-progress/b=
lob/master/hpsa-lockless-vs-hch-scsi-mq.4-2014-07-25-1415CDT.tar.bz2?ra=
w=3Dtrue
>
> In some cases, I have probably erred on the side of having too many t=
oo
> small patches, on the theory that it is easier to bake a cake than to
> unbake a cake.  Before these are submitted "for reals", there will be
> some squashing of patches, along with other cleaning up.
>
> There are some patches in this set which are already upstream in
> James's tree which do not happen to be in Christoph's tree
> (most of which are named "*_sent_to_james").  There are also
> quite a few patches which are strictly for debugging and are not
> ever intended to be merged.
>
Hmm. While you're about to engage on a massive rewrite _and_ we're=20
having 64bit LUN support now, what about getting rid of the weird=20
internal LUN mapping? That way you would get rid of this LUN rescan=20
thingie and the driver would look more sane.
Plus the REPORT LUN command would actually return the correct data ...

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
