From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Thu, 15 Mar 2012 15:16:04 -0700
Message-ID: <CABE8wwuuM8XoTUy_+1nXMt9WvieWgmt-NHS=ybN_ndOdwk+gjQ@mail.gmail.com>
References: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com>
	<Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 15, 2012 at 12:54 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Thu, 15 Mar 2012, Williams, Dan J wrote:
>
>> > Hmm... I was wondering why we needed a kernel global sync. =A0If t=
his is
>> > just for probe work what about just doing something like the follo=
wing?
>> > Keep the sync operation local to probe-work and not entangle with =
the
>> > resume-work? =A0I'll give this a shot when I get back to my test s=
ystem.
>> >
>> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> > index bd17cf8..ec69e35 100644
>> > --- a/drivers/scsi/sd.c
>> > +++ b/drivers/scsi/sd.c
>> > @@ -2629,6 +2629,8 @@ static void sd_probe_async(void *data, async=
_cookie_t cookie)
>> > =A0 =A0 =A0 =A0put_device(&sdkp->dev);
>> > =A0}
>> >
>> > +static LIST_HEAD(sd_probe_domain);
>
> Take a look at fea6d607e154cf96ab22254ccb48addfd43d4cb5; it might be =
a
> good idea to make this domain available to scsi_bus_prepare(). =A0For
> example, it could made into a SCSI-wide domain, defined in the SCSI
> core and exported for use by sd.

Nice, thanks for the pointer.  Yes, I'll up-level this.

>
>> This works fine for me for resolving the deadlock, but I found I als=
o
>> needed the following to fix a spurious:
>>
>> =A0 =A0scsi 6:0:1:0: Illegal state transition deleted->running
>>
>> ...in the resume path.
>>
>> @@ -2348,10 +2349,11 @@ EXPORT_SYMBOL(scsi_device_quiesce);
>> =A0 *
>> =A0 * =A0 =A0 Must be called with user context, may sleep.
>> =A0 */
>> -void
>> -scsi_device_resume(struct scsi_device *sdev)
>> +void scsi_device_resume(struct scsi_device *sdev)
>> =A0{
>> - =A0 =A0 =A0 if(scsi_device_set_state(sdev, SDEV_RUNNING))
>> + =A0 =A0 =A0 /* check if the device was deleted during suspend */
>> + =A0 =A0 =A0 if (sdev->sdev_state =3D=3D SDEV_DEL ||
>> + =A0 =A0 =A0 =A0 =A0 scsi_device_set_state(sdev, SDEV_RUNNING))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> =A0 =A0 =A0 =A0 scsi_run_queue(sdev->request_queue);
>> =A0}
>>
>> Unless someone can point out something I'm missing I'll go ahead and
>> roll this into it's own patch and rebase/drop the hack out of the
>> libsas resume code.
>
> The device might be in some other state. =A0Perhaps it would be bette=
r to
> do
>
> =A0 =A0 =A0 =A0if (sdev->sdev_state !=3D SDEV_QUIESCE ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_device_set_state(=
sdev, SDEV_RUNNING))
>
> I'm not sure what guarantees this function is supposed to provide, bu=
t
> the comment indicates that it's meant just to handle quiesced devices=
=2E
>

I'm not sure either, but I can get on board with this change to say
"the world changed when you weren't looking, assume whomever changed
the state is taking care of the device".

--
Dan
