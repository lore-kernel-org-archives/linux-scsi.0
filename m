From: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libiscsi: use vzalloc for large allocations in iscsi_pool_init
Date: Wed, 5 Apr 2017 09:50:10 -0400
Message-ID: <63C25EDB-036E-40D9-8A9D-42984E7EDB8E@oracle.com>
References: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com> <CAHnHxtyP=OGgCePeb9bde1GR_-nk1QdG7Ou9ndMSpatxH=oomQ@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDQYRBHCWYHBBGPMSPDQKGQEDIZRJBQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAHnHxtyP=OGgCePeb9bde1GR_-nk1QdG7Ou9ndMSpatxH=oomQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chet L <chetanloke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Apr 3, 2017, at 3:46 PM, Chet L <chetanloke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Mon, Apr 3, 2017 at 6:30 AM, Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrot=
e:
>=20
>>=20
>>        for (i =3D 0; i < q->max; i++)
>>                kfree(q->pool[i]);
>> -       kfree(q->pool);
>> +       if (q->is_pool_vmalloc)
>=20
> you could do something like:
>=20
> if (is_vmalloc_addr(q->pool))
>    vfree(...);
> else
>    kfree(..);
>=20
> And then remove the bool.
>=20
> Chetan

Using linux-mmots.git which includes the new kvmalloc api, this patch is gr=
eatly simplified to a 2 character change (=E2=80=98v=E2=80=99 x 2) of using=
 kvmalloc / kvfree for the iscsi_pool allocation.  When kvmalloc is accepte=
d into mainline and makes it into scsi.git, then I=E2=80=99ll post the v2 p=
atch using that.

--
Kyle Fortin - Oracle Linux Engineering




--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
