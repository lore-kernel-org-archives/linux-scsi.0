From: Benny Halevy <bhalevy@tonian.com>
Subject: Re: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 11:51:32 +0200
Message-ID: <CAEMWVhuS5Dg8XAQjxrb_VO-T0S7jS5knOmEWvvJ18xY8hp08hg@mail.gmail.com>
References: <20130130070602.GB12396@elgon.mountain> <5108D6AF.5040205@bfs.de>
 <20130130082741.GT16282@mwanda> <5108E08E.70302@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52308 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3A3Jvx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 04:51:53 -0500
Received: by mail-ob0-f173.google.com with SMTP id dn14so1388658obc.4
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2013 01:51:52 -0800 (PST)
In-Reply-To: <5108E08E.70302@bfs.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wharms@bfs.de
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Jan 30, 2013 at 10:57 AM, walter harms <wharms@bfs.de> wrote:
>
>
> Am 30.01.2013 09:27, schrieb Dan Carpenter:
>> On Wed, Jan 30, 2013 at 09:15:43AM +0100, walter harms wrote:
>>>
>>>
>>> Am 30.01.2013 08:06, schrieb Dan Carpenter:
>>>> There wasn't any error handling for this kzalloc().
>>>>
>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>
>>>> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
>>>> index c06b8e5..d8293f2 100644
>>>> --- a/drivers/scsi/osd/osd_initiator.c
>>>> +++ b/drivers/scsi/osd/osd_initiator.c
>>>> @@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>>>>     odi->osdname_len = get_attrs[a].len;
>>>>     /* Avoid NULL for memcmp optimization 0-length is good enough */
>>>>     odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
>>>> +   if (!odi->osdname) {
>>>> +           ret = -ENOMEM;
>>>> +           goto out;
>>>> +   }
>>>>     if (odi->osdname_len)
>>>>             memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>>>>     OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
>>>> --
>>>
>>> this looks like strdup() ?
>>>
>>
>> Maybe?  It's a funny thing going on with the NUL terminator and I
>> don't understand what the comment is about.
>>
>> It appears that normally "get_attrs[a].val_ptr" is a NUL terminated
>> string but "get_attrs[a].len" does not count the terminator.
>>
>> Odd.
>>
> i have no clue what the programmer was thinking. if i read this correct
> osdname is u8 *osdname; so a simple strdup() or strndup() would be ok
> the comment seems to indicate that get_attrs[a].val_ptr could be NULL
> but where is the check ?
> Perhaps they are not using ascii here ? then a memdup(get_attrs[a].len)
> would be better.

There are subtle differences between kstrdup or kmemdup and this implementation.

kmemdup is problematic as get_attrs[a].val_ptr does not contain the
NUL terminator

In the following case:
if get_attrs[a].len == 0
then get_attrs[a].val_ptr == NULL

The end result should be
odi->osdname_len = 0
odi->osdname = kzalloc(1, GFP_KERNEL);

while with kstrdup, odi->osdname will end up being NULL
as it's input arg "s" is NULL.

Benny

>
> re,
>  wh
>
>
