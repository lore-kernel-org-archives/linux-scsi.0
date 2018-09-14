From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running
 rotational device
Date: Thu, 13 Sep 2018 22:05:42 -0700
Message-ID: <CAHo-OozTguSTmLv=eCsKysSMdphRDKo=eiD69URJ6MV_mrm_GQ@mail.gmail.com>
References: <20180906203719.209399-1-xueweiz@google.com> <20180909115205.GA17732@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180909115205.GA17732@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Xuewei Zhang <xueweiz@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>, Guenter Roeck <groeck@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 9, 2018 at 4:52 AM, Ming Lei <ming.lei@redhat.com> wrote:
> On Thu, Sep 06, 2018 at 01:37:19PM -0700, Xuewei Zhang wrote:
>> Currently a scsi device won't contribute to kernel randomness when it
>> uses blk-mq. Since we commonly use scsi on rotational device with
>> blk-mq, it make sense to keep contributing to kernel randomness in these
>> cases. This is especially important for virtual machines.
>>
>> commit b5b6e8c8d3b4 ("scsi: virtio_scsi: fix IO hang caused by automatic
>> irq vector affinity") made all virtio-scsi device to use blk-mq, which
>> does not contribute to randomness today. So for a virtual machine only
>> having virtio-scsi disk (which is common), it will simple stop getting
>> randomness from its disks in today's implementation.
>>
>> With this patch, if the above VM has rotational virtio-scsi device, then
>> it can still benefit from the entropy generated from the disk.
>>
>> Reported-by: Xuewei Zhang <xueweiz@google.com>
>> Signed-off-by: Xuewei Zhang <xueweiz@google.com>
>> ---
>>  drivers/scsi/sd.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index b79b366a94f7..5e4f10d28065 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2959,6 +2959,9 @@ static void sd_read_block_characteristics(struct s=
csi_disk *sdkp)
>>       if (rot =3D=3D 1) {
>>               blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>>               blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>> +     } else {
>> +             blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
>> +             blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
>>       }
>>
>>       if (sdkp->device->type =3D=3D TYPE_ZBC) {
>> --
>> 2.19.0.rc2.392.g5ba43deb5a-goog
>>
>
> Look reasonable, especially the disk randomness is added by SCSI itself.
>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>
> Thanks,
> Ming

Also, see: https://bugzilla.redhat.com/show_bug.cgi?id=3D1572944
where we're having randomness starvation problems on FC28
running 4.18.5 due to lack of virtio-rng device in VM.
(VM boot takes 9+ hours or 2 haswell VMs)

I'd kindly request we get this not only into 4.19 but also stable trees.
(along with Ted's other randomization fixes)

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
