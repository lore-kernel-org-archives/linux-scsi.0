From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Disabling dev_loss_tmo?
Date: Tue, 13 Nov 2007 11:18:49 -0500
Message-ID: <4739CE69.3040602@emulex.com>
References: <47396A5B.5040001@linpro.no>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47480 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbXKMQf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 11:35:26 -0500
In-Reply-To: <47396A5B.5040001@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>, Christoph Hellwig <hch@infradead.org>, MLOEHR@de.ibm.com

We had a lot of conversations on what to have the transport do after
connectivity was lost to a device. Suffice to say - the answer was to
remove the device.  The dev_loss_tmo value was the compromise between
the kernel architectural position, and what FC drivers had always
managed and hidden from the kernel in the past.

Unfortunately, even though DM has known of this behavior for a long tim=
e
(it's existed since 2.6.<early teens>, no-one has bothered to update DM
to support it. One train of thought is : fixing it for FC doesn't
address the issue, as other transports may still encounter it. It's a D=
M
thing, and should stay this way to ensure that DM fixes it.

You noted that the FC transport, in SLES10 and RHEL5, added a patch
that allowed for the scsi targets not to be torn down when dev_loss_tmo
timed out. This had little to do with DM, and everything to do with
reuse-after-free issues on mid-layer data structures that were released
as part of the teardown, as well as the timing of the upstream reuse
patches vs what the distro kernels could accept. But DM certainly
benefited from its behavior.

I'd rather that DM got fixed so that it supports the necessary
architectural behavior. But, we've lived with the disto-specific
behavior as well, so it's not a strong sentiment.

-- james s


Tore Anderson wrote:
> Hi.  Recent kernels will remove the block devices if a FC rport is lo=
st,
> which causes a number of problems when dm-multipath is used:
>=20
> 1) Multipathd will receive an event notifying it of the removed rport=
,
> and will respond by removing the path.  This causes a suspend which
> flushes outstanding I/O, and in a all-paths-down scenario this will
> cause I/O errors to propagate up to the file system layer - even if
> queue_if_no_path is in use.  This is fixed in newer versions of
> multipath-tools, but old versions are still shipped by the various
> server distros.
>=20
> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4005
>=20
> 2) Multipathd will often keep open the device as it's being removed,
> resulting in an error message when attempting to re-register the
> recently revived rport:
>=20
> =C2=ABobject_add failed for H:B:T:L with -EEXIST, don't try to regist=
er
> things with the same name in the same directory=C2=BB
>=20
> The newly added path will therefore not make it back into the
> dm-multipath map (and won't be available as a block device either).
>=20
> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4240/f=
ocus=3D4255
>=20
> 3) Even when the -EEXIST error doesn't show up, udev/multipath/someth=
ing
> seems to get it wrong sometimes. Either the revived path is added to =
the
> wrong (a new) priority group, or it's not added at all.  Most of the
> time it works fine, but it's can't be relied upon in my experience.
> Haven't been able to track this one down, unfortunately.
>=20
> Anyway.  I believe all of these problems would be possible to avoid i=
f I
> could simply make it so that block devices would never be removed due=
 to
> rports becoming unavailable.  dm-multipath would fail the path anyway=
,
> and multipathd would just keep on testing its availability and would
> re-instate when/if it came back online.  If it didn't, it would of
> course hang around as harmless junk - but fibre channel SANs are usua=
lly
> quite stable anyway, and the admin will always have the possibility o=
f
> removing the block device manually if it bugs him.  In any case it wo=
uld
> be better than the loss of reliability I experience now.
>=20
> So what I suggest is a way of disabling dev_loss_tmo (or setting it t=
o
> unlimited).  Think that's doable for a kernel newbie like me, or are
> there any takers?
>=20
> Regards
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
