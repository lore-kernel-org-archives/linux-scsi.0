From: Hannes Reinecke <hare@suse.de>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Mon, 19 Dec 2011 13:38:23 +0100
Message-ID: <4EEF303F.8090809@suse.de>
References: <4EE8F75F.6070800@gmail.com> <20111214195931.GC10664@samba2> <4EE90753.6060700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab1LSMiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 07:38:25 -0500
In-Reply-To: <4EE90753.6060700@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Jeremy Allison <jra@samba.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 12/14/2011 09:30 PM, Ric Wheeler wrote:
> On 12/14/2011 02:59 PM, Jeremy Allison wrote:
>> On Wed, Dec 14, 2011 at 02:22:07PM -0500, Ric Wheeler wrote:
>>> Back at LinuxCon Prague, we talked about the new NFS and SCSI
>>> commands that let us offload copy operations to a storage device
>>> (like an NFS server or storage array).
>>>
>>> This got new life in the virtual machine world where you might want
>>> to clone bulky guest files or ranges of blocks and was driven
>>> through the standards bodies by vmware, microsoft and some of the
>>> major storage vendors. Windows8 has this functionality fully coded
>>> and integrated in the GUI, I assume vmware also uses it and there
>>> are some vendors who announced support at the SNIA SDC conference.
>>>
>>> We had an active thread a couple of years back that came out of the
>>> reflink work and, at the time, there seemed to be moderately
>>> positive support for adding a new system call that would fit this
>>> use case (Joel Becker's copyfile()).
>>>
>>> Can we resurrect this effort? Is copyfile() still a good way to go,
>>> or should we look at other hooks?
>> Windows uses a COPYCHUNK call, which specifies the
>> following parameters:
>>
>> Definition of a copy "chunk":
>>
>> hyper source_off;
>> hyper target_off;
>> uint32 length;
>>
>> and an array of these chunks which is passed
>> into their kernel.
>>
>> This is what we have to implement in Samba.
>>
>> Jeremy.
>=20
> This is a public pointer to the draft NFS proposal:
>=20
> http://tools.ietf.org/id/draft-lentini-nfsv4-server-side-copy-06.txt
>=20
> The T10 site has some click through that I was not too happy about
> agreeing to. NetApp (Fred Knight) had some nice presentations that
> he presented about how SCSI does this in two different ways...
>=20

Yes, the 'XCOPY Lite' mechanism.

With that the whole copy process is broken into two steps:
- Create a reference to the requested blocks
- Use that reference to request the operation

The neat thing with that is that there might be some delay between
those steps, effectively creating a snapshot in time.

An additional bonus is that one doesn't have to create those
over-complicated source and target descriptors, but rather have the
array create one for you.

So all-in-all nice and easy to use. With the slight disadvantage
that no-one implements it. Yet.

Hence we might be wanting to use the old-style EXTENDED COPY after
all ...

However, both approaches have in common that an opaque 'identifier'
is used to identify any currently running copy process.

So when designing this interface we should keep in mind that we
would need to store this identifier somewhere. As as loath as I'm to
admit it, the async-I/O mechanism would fit the bill far better than
a single copyfile() call ...

Which could be easily implemented on top of the Async I/O call, btw.

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
