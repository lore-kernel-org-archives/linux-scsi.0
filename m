From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 20:46:52 +0200
Message-ID: <471E419C.9020005@panasas.com>
References: <20071019183331.GC30807@parisc-linux.org> <471E260D.6030605@panasas.com> <20071023174804.GR27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13019 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbXJWSqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 14:46:54 -0400
In-Reply-To: <20071023174804.GR27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 23 2007 at 19:48 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Oct 23, 2007 at 06:49:17PM +0200, Boaz Harrosh wrote:
>> You know Matthew when you first talked about this, I envisioned
>> something else.
> 
> Right, so did I.  Christoph felt that alloc_cmnd/destroy_cmnd a la the
> VFS layer's alloc_inode/destroy_inode was a better route.  I didn't have
> a strong feeling, so I implemented that.
> 
>> This serves the drivers well because all they need to do is set
>> host_cmnd_extra_bytes = size_of(my_cmnd_stuff) and start using
>> it. much more simple than setting up cache pools. It also keeps
>> the Q per host vs Q per driver.
> 
> The allocation pool is currently for the whole subsystem, not per host.
> I assumed you meant 'pool' rather than 'queue', since I didn't touch the
> queues.
> 
rrr Your right, I got confused here, the pools are global, I forgot.
That kind of kills my plan (I don't even dare a maybe)

> Hosts already have allocation pools (er, I think they all do anyway
> ... and any that don't, I'm quite happy to write a generic_alloc_cmnd
> and stick it in scsi_lib).
> 
Yes that would be nice. Make it as easy as possible for drivers.
Also for us when we sweep through them. (I'm here to help).

Most of them don't. Most of them either overload SCp or have
static arrays the size of their .can_queue .

>> This also solves your problem with locks and allocation flags
>> since nothing changes, and it is all private to the mid-layer.
> 
> It doesn't solve that problem -- we already have that problem; it's just
> that it's kept in the midlayer.
> 
OK I see...

>> And it serves me, because when bidi comes I just do:
>> sizeof(struct scsi_cmnd) + host_cmnd_extra_bytes + sizeof(bidi_stuff)
>> for hosts that support bidi. And the rest of the work was done by you.
> 
> I have to admit to not having a clear picture of how bidi is supposed to
> work.  Could we do it something like this?
> 
> struct bidi_cmnd {
> 	struct scsi_cmnd;
> 	...
> };
> 
Yes nice

> struct qla_cmnd {
> 	struct bidi_cmnd bd_cmnd;
> 	...
> };
> 
yes OK

> We could also add an alloc_bidi_cmnd/destroy_bidi_cmnd to the shost
> template.  Presumably most commands won't be bidi for any given host,
> so it'd be a waste of space to allocate them for all commands.
> 

Well no one really knows. The OSD scsi devices I use are bidi only commands
(OK not only, 99%). The rest are not yet defined. (Like raid arrays that do 
write-return-XOR)

Boaz

