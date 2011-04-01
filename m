From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 09:30:04 -0700
Message-ID: <AANLkTinZCx3gq-iDjPLzkvSFQNqAc1-bGN8xgzRz_=yj@mail.gmail.com>
References: <1301373398.2590.20.camel@mulgrave.site>
	<4D91BF90.8070909@redhat.com>
	<1301445210.2731.14.camel@mingming-laptop>
	<20110330021742.GL3008@dastard>
	<E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
	<4D9313E2.6080006@gmail.com>
	<20110401151907.GG21075@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110401151907.GG21075@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 1, 2011 at 8:19 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Mar 30, 2011 at 07:28:34AM -0400, Ric Wheeler wrote:
>>
>> What possible semantics could you have?
>>
>> If you ever write concurrently from multiple processes without
>> locking, you clearly are at the mercy of the scheduler and the
>> underlying storage which could fragment a single write into multiple
>> IO's sent to the backend device.
>>
>> I would agree with Dave, let's not make it overly complicated or try
>> to give people "atomic" unbounded size writes just because they set
>> the O_DIRECT flag :)
>
> I just want to have it written down. =A0After getting burned with ext=
3's
> semantics promising more than what the standard guaranteed, I've just
> gotten paranoid about application programmers getting upset when
> things change on them --- and in the case of direct I/O, this stuff
> isn't even clearly documented anywhere official.
>
> I just think it's best that we document it the fact that concurrent
> DIO's to the same region may result in completely arbitrary behaviour=
,
> make sure it's well publicized to likely users (and I'm more worried
> about the open source code bases than Oracle DB), and then call it a =
day.
>
> The closest place that we have to any official documentation about
> O_DIRECT semantics is the open(2) man page in the Linux manpages, and
> it doesn't say anything about this. =A0It does give a recommendation
> against not mixing buffered and O_DIRECT accesses to the same file,
> but it does promise that things will work in that case. =A0(Even if i=
t
> does, do we really want to make the promise that it will always work?=
)

when writing DIO to indirect mapped file holes, we fall back to buffere=
d write
(so we won't expose stale data in the case of a crash) concurrent DIO r=
eads
to that file (before data writeback) can expose stale data. right?
do you consider this case mixing buffered and DIO access?
do you consider that as a problem?

the case interests me because I am afraid we may have to use the fallba=
ck
trick for extent move on write from DIO (we did so in current
implementation anyway).

of course, if we end up implementing in-memory extent tree, we will pro=
bably be
able to cope with DIO MOW without fallback to buffered IO.

>
> In any case, adding some text in that paragraph, or just after that
> paragraph, to the effect that two concurrent DIO accesses to the same
> file block, even by two different processes will result in undefined
> behavior would be a good start.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 - Ted
> _______________________________________________
> Lsf mailing list
> Lsf@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/lsf
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
