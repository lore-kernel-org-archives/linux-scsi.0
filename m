From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH/RFC] allow userspace to modify scsi command filter on per device basis
Date: Fri, 13 Jun 2008 22:23:51 +0200
Message-ID: <6cf6b73e0806131323w5b921c05jd1166ab88471bfd1@mail.gmail.com>
References: <6cf6b73e0806131233i53942756j24a00ba18abebb47@mail.gmail.com>
	 <20080613195448.GA30405@parisc-linux.org>
	 <6cf6b73e0806131322n7642d2d1ne90f70c2b3728f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:47526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbYFMUX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2008 16:23:56 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2868056fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2008 13:23:51 -0700 (PDT)
In-Reply-To: <6cf6b73e0806131322n7642d2d1ne90f70c2b3728f8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, Jens Axboe <jens.axboe@oracle.com>

2008/6/13 Adel Gadllah <adel.gadllah@gmail.com>:
> 2008/6/13 Matthew Wilcox <matthew@wil.cx>:
>> On Fri, Jun 13, 2008 at 09:33:27PM +0200, Adel Gadllah wrote:
>>> -             if (blk_verify_command(rq->cmd, has_write_perm))
>>> +             if (blk_cmd_filter_verify_command(bd->cmd_filter, rq->cmd, bd->f_mode))
>>
>> Could you wrap to 80 columns?
>
> yeah fixed all checkpatch.pl errors/warnings in the attached patch.
>
>>> +static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
>>> +                           const char *page, size_t count, int rw)
>>> +{
>>> +     ssize_t ret = 0;
>>> +     unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
>>> +     int cmd, status, len;
>>> +     substring_t ss;
>>> +
>>> +     memset(&okbits, 0, sizeof (okbits));
>>> +
>>> +     for (len = strlen(page); len > 0; len -= 3) {
>>> +             if (len < 2)
>>> +                     break;
>>> +             ss.from = (char *) page + ret;
>>> +             ss.to = (char *) page + ret + 2;
>>> +             ret+=3;
>>> +             status = match_hex(&ss, &cmd);
>>> +             /* either of these cases means invalid input, so do nothing. */
>>> +             if (status || cmd >= BLK_SCSI_MAX_CMDS)
>>> +                     return -EINVAL;
>>> +
>>> +             set_bit(cmd, okbits);
>>
>> set_bit is atomic.  locked ops can be quite painful on some processors.
>> Since okbits is local, the atomicity isn't necessary and you can simply
>> use __set_bit.
>
> ok, fixed.
>
>>> +static void rcf_set_defaults(struct blk_scsi_cmd_filter *filter)
>>> +{
>>> +     /* Basic read-only commands */
>>> +     set_bit(TEST_UNIT_READY, filter->read_ok);
>>
>> The set_bit vs __set_bit comment also applies here.
>
> fixed.
>
>>> +int blk_register_filter(struct gendisk *disk)
>>> +{
>>> +     int ret;
>>> +     struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
>>> +     struct kobject *parent = kobject_get(disk->holder_dir);
>>> +
>>> +     if(!parent) {
>>> +             return -EBUSY;
>>> +     }
>>
>> Normal style would be to write
>>
>>        if (!parent)
>>                return -EBUSY;
>
> fixed while adressing the checkpatch.pl stuff.
>
>> (though I don't understand why no parent means we're busy)
>
> changed to -ENODEV;
>
>>> +
>>> +     ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent, "%s", "filter");
>>> +
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     rcf_set_defaults(filter);
>>
>> Surely we should set the bits before we make the object visible?
>
> When is the kobject
^^ made visisble
