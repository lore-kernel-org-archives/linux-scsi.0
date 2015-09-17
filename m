From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: DEFINE_IDA causing memory leaks? (was Re: [PATCH 1/2] virtio: fix
 memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 08:51:54 +0200
Message-ID: <55FA630A.4020707@suse.de>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
 <1442449758-14594-2-git-send-email-s-anna@ti.com>
 <20150917082425-mutt-send-email-mst@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCHZVHVFVMARBDGG5GXQKGQEKAPENRA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150917082425-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Suman Anna <s-anna-l0cyMroinI0@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-O3H1v1f1dlM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 09/17/2015 07:33 AM, Michael S. Tsirkin wrote:
> On Wed, Sep 16, 2015 at 07:29:17PM -0500, Suman Anna wrote:
>> The virtio core uses a static ida named virtio_index_ida for
>> assigning index numbers to virtio devices during registration.
>> The ida core may allocate some internal idr cache layers and
>> an ida bitmap upon any ida allocation, and all these layers are
>> truely freed only upon the ida destruction. The virtio_index_ida
>> is not destroyed at present, leading to a memory leak when using
>> the virtio core as a module and atleast one virtio device is
>> registered and unregistered.
>>
>> Fix this by invoking ida_destroy() in the virtio core module
>> exit.
>>
>> Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Suman Anna <s-anna-l0cyMroinI0@public.gmane.org>
>=20
> Interesting.
> Will the same apply to e.g. sd_index_ida in drivers/scsi/sd.c
> or iscsi_sess_ida in drivers/scsi/scsi_transport_iscsi.c?
>=20
> If no, why not?
>=20
> One doesn't generally expect to have to free global variables.
> Maybe we should forbid DEFINE_IDA in modules?
>=20
> James, could you comment on this please?
>=20
Well, looking at the code 'ida_destroy' only need to be called
if you want/need to do a general cleanup.
It shouldn't be required if you do correct reference counting
on your objects, and call idr_remove() on each of them.

Unless I'm misreading something.

Seems like a topic for KS; Johannes had a larger patchset recently to
clean up idr, which run into very much the same issues.

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
