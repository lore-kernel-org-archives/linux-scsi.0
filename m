From: vaughan <vaughan.cao@oracle.com>
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
Date: Thu, 06 Jun 2013 00:16:45 +0800
Message-ID: <51AF646D.7030903@oracle.com>
References: <51AF0269.9070900@oracle.com> <20130605132746.GA1690@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130605132746.GA1690@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

=E4=BA=8E 2013=E5=B9=B406=E6=9C=8805=E6=97=A5 21:27, J=C3=B6rn Engel =E5=
=86=99=E9=81=93:
> On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
>>
>> Check and set sdp->exclude should be atomic when set in sg_open().
>
> The patch is line-wrapped.  More importantly, it doesn't seem to do
It's shorter than the original line, so I just leave it like this...

> what your description indicates it should do.  And lastly, does this
> fix a bug, possibly even one you have a testcase for, or was it found
> by code inspection?
I found it by code inspection. A race condition may happen with the old=
=20
code if two threads are both trying to open the same sg with O_EXCL=20
simultaneously. It's possible that they both find fsds list is empty an=
d=20
get_exclude(sdp) returns 0, then they both call set_exclude() and break=
=20
out from wait_event_interruptible and resume open. So it's necessary to=
=20
check again with sg_open_exclusive_lock held to ensure only one can set=
=20
sdp->exclude and return >0 to break out from wait_event loop.

>
>> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
>> ---
>>   drivers/scsi/sg.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 25b5455..0ede08f 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -245,6 +245,21 @@ static int set_exclude(Sg_device *sdp, char val=
)
>>       return val;
>>   }
>>
>> +/* Check if we can set exclude and then set, return 1 if success */
>> +static int try_set_exclude(Sg_device *sdp)
>> +{
>> +    unsigned long flags;
>> +
>> +    spin_lock_irqsave(&sg_open_exclusive_lock, flags);
>> +    if (sdp->exclude) {
>> +        spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
>> +        return 0;
>> +    }
>> +    sdp->exclude =3D 1;
>> +    spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
>> +    return 1;
>> +}
>> +
>>   static int sfds_list_empty(Sg_device *sdp)
>>   {
>>       unsigned long flags;
>> @@ -303,7 +318,7 @@ sg_open(struct inode *inode, struct file *filp)
>>               goto error_out;
>>           }
>>           res =3D wait_event_interruptible(sdp->o_excl_wait,
>> -                       ((!sfds_list_empty(sdp) || get_exclude(sdp))
>> ? 0 : set_exclude(sdp, 1)));
>> +            ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 :
>> try_set_exclude(sdp)));
>>           if (res) {
>>               retval =3D res;    /* -ERESTARTSYS because signal hit =
process */
>>               goto error_out;
>> --
>> 1.7.11.7
>>
>
> J=C3=B6rn
>
> --
> Fantasy is more important than knowledge. Knowledge is limited,
> while fantasy embraces the whole world.
> -- Albert Einstein
>
