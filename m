From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v3 2/2] libata-scsi: better style in ata_msense_caching()
Date: Wed, 13 Jul 2016 00:20:40 +0800
Message-ID: <CAGnHSEn-S1G55uNE9Wm9026Gny0f_Udu6F2auvDJksEKg3p_=g@mail.gmail.com>
References: <5784f28c.c4d0620a.69372.3df2@mx.google.com> <20160712144824.GD3190@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160712144824.GD3190@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

First of all "changeable" is the "version" of mode page requested by
the user, while ata_id_*_enabled(id) are the value of setting reported
by the device. I think it's ugly and confusing to check values of
totally different nature "together".

The worse thing is, since we have implemented MODE SELECT /
ata_mselect_caching() to serve exclusively the write cache feature,
the difference in the two if-conditions made the code look even more
arcane.

In my version, it is clear that when the user request the changeable
mode page, the value for the WCE bit will always be "1" / "y", since
we've made (only) it changeable in ata_mselect_caching(); and when the
user request the current / default page, the values reflect the
settings from the drive.

On 12 July 2016 at 22:48, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jul 12, 2016 at 09:37:03PM +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index bfec66f..48ea887 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -2424,10 +2424,12 @@ static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
>>  static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
>>  {
>>       modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
>> -     if (changeable || ata_id_wcache_enabled(id))
>> -             buf[2] |= (1 << 2);     /* write cache enable */
>> -     if (!changeable && !ata_id_rahead_enabled(id))
>> -             buf[12] |= (1 << 5);    /* disable read ahead */
>> +     if (changeable) {
>> +             buf[2] |= 1 << 2; /* ata_mselect_caching() */
>> +     } else {
>> +             buf[2] |= ata_id_wcache_enabled(id) << 2;       /* write cache enable */
>> +             buf[12] |= !ata_id_rahead_enabled(id) << 5;     /* disable read ahead */
>> +     }
>
> It's different but I'm not sure this is better.
>
> Thanks.
>
> --
> tejun
