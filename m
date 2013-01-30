From: walter harms <wharms@bfs.de>
Subject: Re: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 15:34:39 +0100
Message-ID: <51092F7F.2090105@bfs.de>
References: <20130130070602.GB12396@elgon.mountain> <5108D6AF.5040205@bfs.de> <20130130082741.GT16282@mwanda> <5108E08E.70302@bfs.de> <CAEMWVhuS5Dg8XAQjxrb_VO-T0S7jS5knOmEWvvJ18xY8hp08hg@mail.gmail.com> <51091951.5090709@bfs.de> <CAEMWVhsAysz6QQnBkNteVExAVdQ6YRZd62WE0vzmd1hvNa0-zg@mail.gmail.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:31949 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3A3Oem (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 09:34:42 -0500
In-Reply-To: <CAEMWVhsAysz6QQnBkNteVExAVdQ6YRZd62WE0vzmd1hvNa0-zg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@tonian.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 30.01.2013 14:40, schrieb Benny Halevy:
> On Wed, Jan 30, 2013 at 3:00 PM, walter harms <wharms@bfs.de> wrote:
>>
>>
>> Am 30.01.2013 10:51, schrieb Benny Halevy:
>>> On Wed, Jan 30, 2013 at 10:57 AM, walter harms <wharms@bfs.de> wrote:
>>>>
>>>>
>>>> Am 30.01.2013 09:27, schrieb Dan Carpenter:
>>>>> On Wed, Jan 30, 2013 at 09:15:43AM +0100, walter harms wrote:
>>>>>>
>>>>>>
>>>>>> Am 30.01.2013 08:06, schrieb Dan Carpenter:
>>>>>>> There wasn't any error handling for this kzalloc().
>>>>>>>
>>>>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>>>>
>>>>>>> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
>>>>>>> index c06b8e5..d8293f2 100644
>>>>>>> --- a/drivers/scsi/osd/osd_initiator.c
>>>>>>> +++ b/drivers/scsi/osd/osd_initiator.c
>>>>>>> @@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>>>>>>>     odi->osdname_len = get_attrs[a].len;
>>>>>>>     /* Avoid NULL for memcmp optimization 0-length is good enough */
>>>>>>>     odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
>>>>>>> +   if (!odi->osdname) {
>>>>>>> +           ret = -ENOMEM;
>>>>>>> +           goto out;
>>>>>>> +   }
>>>>>>>     if (odi->osdname_len)
>>>>>>>             memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>>>>>>>     OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
>>>>>>> --
>>>>>>
>>>>>> this looks like strdup() ?
>>>>>>
>>>>>
>>>>> Maybe?  It's a funny thing going on with the NUL terminator and I
>>>>> don't understand what the comment is about.
>>>>>
>>>>> It appears that normally "get_attrs[a].val_ptr" is a NUL terminated
>>>>> string but "get_attrs[a].len" does not count the terminator.
>>>>>
>>>>> Odd.
>>>>>
>>>> i have no clue what the programmer was thinking. if i read this correct
>>>> osdname is u8 *osdname; so a simple strdup() or strndup() would be ok
>>>> the comment seems to indicate that get_attrs[a].val_ptr could be NULL
>>>> but where is the check ?
>>>> Perhaps they are not using ascii here ? then a memdup(get_attrs[a].len)
>>>> would be better.
>>>
>>> There are subtle differences between kstrdup or kmemdup and this implementation.
>>>
>>> kmemdup is problematic as get_attrs[a].val_ptr does not contain the
>>> NUL terminator
>>
>> ok, i understand - but can we assume that we are talking ascii here ?
>>
> 
> No, it can be anything.  UTF-8 is more likely but not guaranteed either.
> 

I start to see the complexity of the situation. Would you mind to add
the comment "it can be anything.  UTF-8 is more likely but not guaranteed either" ?
For now using a pascal-string seems the best solution but it should be warned
that get_attrs[a].val_ptr is NOT a c-string and therefore can not be used with
the printf-family (i guess the situation will become more clear in future)

I have no clue why you need that, using c-strings makes life more easy in the
last minute a sprintf(buf,"%u") will save the day ;)

>>> In the following case:
>>> if get_attrs[a].len == 0
>>> then get_attrs[a].val_ptr == NULL
>>>
>>> The end result should be
>>> odi->osdname_len = 0
>>> odi->osdname = kzalloc(1, GFP_KERNEL);
>>>
>>> while with kstrdup, odi->osdname will end up being NULL
>>> as it's input arg "s" is NULL.
>>>
>>
>> and you want the argument to be "" ?
>> May i ask why ? kfree() can handle NULL and kprintf() (-family) also.
> 
> It was Boaz' decision at the time to simplify internal tests
> like _the_same_or_null in drivers/scsi/osd/osd_uld.c
> that doesn't check for NULL
> 
It look clever to add the NULL test here.
Noone reviewing the code will understand that.
(Rule of least surprise)

just my 2 cents,
re,
 wh


> Nothing spectacular :)
> 
> Benny
> 
>>
>> re,
>>  wh
>>
>>
>>> Benny
>>>
>>>>
>>>> re,
>>>>  wh
>>>>
>>>>
>>>
>>>
> 
> 
