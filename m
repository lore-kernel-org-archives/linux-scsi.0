From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 02 Nov 2015 16:32:31 +0100
Message-ID: <5637820F.9080503@suse.de>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com> <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com> <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com> <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de> <20151102133119.GA23234@redhat.com> <56376B8C.5010001@suse.de> <563778B9.7060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbbKBPcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 10:32:33 -0500
In-Reply-To: <563778B9.7060900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 11/02/2015 03:52 PM, Paolo Bonzini wrote:
>=20
>=20
> On 02/11/2015 14:56, Hannes Reinecke wrote:
>> But then the real question remains:
>>
>> What is the 'correct' behaviour for ioctls when no path retry
>> is active (or when no paths are present)?
>>
>> Should we start path activation?
>> If so, should we wait for path activation to finish, risking udev
>> killing the worker for that event (udev has a built-in timeout of
>> 120 seconds, which we might easily exceed when we need to activate
>> paths for large installations or slow path activation ... just
>> thinking of NetApp takeover/giveback cycle)?
>> If we're not waiting for path activation, where would be the point
>> in starting it, seeing that we're not actually interested in the res=
ult?
>> And if we shouldn't start a path activation, what is the point of
>> having code for it in the first place?
>=20
> That's a fair question, and it depends on what said udev worker actua=
lly
> does.
>=20
Point is, we have no idea whatsoever what udev might be doing.

And experience shows that while most admins/distros etc have a fair
knowledge of writing valid udev rules, more often than not the
'queue_if_no_path' feature from multipath totally escapes them.
So we will be finding ourselves in positions where programs from
udev rules issue ioctls to devices where queue_if_no_path is active.

Plus it's a really daunting task to validate all udev rules to check
if any of those programs might issue ioctls and blank them out for
the queue_if_no_path case.
I did a review once for SUSE, but even that might be obsoleted now
as rules are being changed all the time.

> In any case, if we don't start path activation we should return
> ENOTCONN, not ENOTTY.
>=20
No problem with that.

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
