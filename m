From: vaughan <vaughan.cao@oracle.com>
Subject: Re: [PATCH v2 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Date: Sun, 07 Jul 2013 01:24:44 +0800
Message-ID: <51D852DC.4070808@oracle.com>
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org> <51AF646D.7030903@oracle.com> <20130605154106.GA2737@logfs.org> <51BF0ADD.1080604@oracle.com> <20130705173953.GA15089@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130705173953.GA15089@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 07/06/2013 01:39 AM, J=C3=B6rn Engel wrote:
> Sorry about replying so late.
>
> On Mon, 17 June 2013 21:10:53 +0800, vaughan wrote:
>> Rewrite the last patch.
>> Add a new field 'toopen' in sg_device to count ongoing sg_open's. By=
 checking both 'toopen' and 'exclude' marks when do exclusive open, old=
 race conditions can be avoided.
>> Replace global sg_open_exclusive_lock with a per device lock - sfd_l=
ock. Since sfds list is now protected by the lock owned by the same sg_=
device, sg_index_lock becomes a real global lock to only protect sg dev=
ices lookup.
>> Also did some cleanup, such as remove get_exclude() and rename set_e=
xclude() to clear_exclude().
>>
> ...
>> @@ -171,10 +168,10 @@ typedef struct sg_device { /* holds the state =
of each scsi generic device */
>>   	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use=
 */
>>   	int sg_tablesize;	/* adapter's max scatter-gather table size */
>>   	u32 index;		/* device index number */
>> -	/* sfds is protected by sg_index_lock */
>> +	spinlock_t sfd_lock;	/* protect sfds, exclude, toopen */
>>   	struct list_head sfds;
>> +	int toopen;		/* number of who are ready to open sg */
>                                              ^
> I think the 'toopen' is a bad choice.  I'm having trouble wrapping my
> head around the semantics of this variable, your description feels a
> bit handwavy, the main noun is missing in the command above, I think =
I
> found one more overflow bug,...
>
> What you ended up doing is reimplement a rw_semaphone.  Why not use
> one instead?  down_write() for exclusive access, down_read() for
> non-exclusive, _trylock variants for nonblocking opens, etc.
The critical part of open is to add a new sfd to the list and its=20
protected by the
spin_lock(sg_index_lock previously) well. So I added an counter as a=20
sign rather than
introducing another spinlock or mutex which means I should deal with=20
potential deadlock.
The code may be simpler with a rwsem implementation as you suggest, I'l=
l=20
modify it in
this way.

There is no overflow bug, I eliminated it with the following line :)
      if (!sdp->exclude && sdp->toopen !=3D INT_MAX) { ...

Do you agree that I use a per device spin_lock 'sfd_lock' to protect=20
sfds list and leave sg_index_lock
only protect the global sg device lookup? I think it's reasonable for=20
concurrency.


Thanks,
Vaughan

>
> Would this work?

>
> J=C3=B6rn
>
> --
> I've never met a human being who would want to read 17,000 pages of
> documentation, and if there was, I'd kill him to get him out of the
> gene pool.
> -- Joseph Costello
