From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 14:31:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415AAB0F.2080802@suse.de>
References: <415A67B8.2080003@suse.de> <20040929130332.A11785@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60307 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S268339AbUI2Mb1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 08:31:27 -0400
In-Reply-To: <20040929130332.A11785@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>

Christoph Hellwig wrote:
> [please send scsi issues to linux-scsi, thanks]
>=20
>=20
>>It turned out that in drivers/scsi/hosts.c:scsi_remove_host()
>>first the host is removed with scsi_forget_host() and _then_ all=20
>>outstanding I/O to this host is cancelled with scsi_host_cancel().=20
>>Sounds a bit fishy as scsi_host_cancel() tries to talk to a host whic=
h=20
>>we just have deleted ...
>>(Incidentally, this is most likely the same bug as Bug #2752 and #348=
0=20
>>from bugme.osdl.org :-).
>>(And also #133249 from bugzilla.redhat.com :-).
>>
>>The attached patch corrects this.
>>Please apply.
>=20
>=20
> I'ts not that easy.  If we cancel the host first we won't get our wri=
te
> caches flushed because the drivers don't accept the SYNCRHONIZE_CACHE=
=2E
> command in cancelled state.  Mike just changed the order to what it i=
s
> now a short while ago.
>=20
Yeah, Jens Axboe just pointed that out.

> So we'll have to find a way to send a SYNCHRNOZIE_CACHE command even
> in canncelled state.
>=20
> In fact I can't see how these problems could happen, and that they on=
ly
> happen with usb-storage seems strange.
Well, the thing is: When usb-storage calls scsi_remove_host() the devic=
e=20
is already gone; whether or not we can synchronize the cache is a moot=20
point there.

And if I understood the comment to the Changeset properly, the patch wa=
s=20
just to remove the 'Synchronizing SCSI cache' message.
I can live with that. Kernel Oops is much worse.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
