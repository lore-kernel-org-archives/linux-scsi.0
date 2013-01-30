From: walter harms <wharms@bfs.de>
Subject: Re: [patch] [SCSI] libosd: check for kzalloc() failure
Date: Wed, 30 Jan 2013 09:57:50 +0100
Message-ID: <5108E08E.70302@bfs.de>
References: <20130130070602.GB12396@elgon.mountain> <5108D6AF.5040205@bfs.de> <20130130082741.GT16282@mwanda>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:28889 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3A3I5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 03:57:52 -0500
In-Reply-To: <20130130082741.GT16282@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 30.01.2013 09:27, schrieb Dan Carpenter:
> On Wed, Jan 30, 2013 at 09:15:43AM +0100, walter harms wrote:
>>
>>
>> Am 30.01.2013 08:06, schrieb Dan Carpenter:
>>> There wasn't any error handling for this kzalloc().
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
>>> index c06b8e5..d8293f2 100644
>>> --- a/drivers/scsi/osd/osd_initiator.c
>>> +++ b/drivers/scsi/osd/osd_initiator.c
>>> @@ -144,6 +144,10 @@ static int _osd_get_print_system_info(struct osd_dev *od,
>>>  	odi->osdname_len = get_attrs[a].len;
>>>  	/* Avoid NULL for memcmp optimization 0-length is good enough */
>>>  	odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
>>> +	if (!odi->osdname) {
>>> +		ret = -ENOMEM;
>>> +		goto out;
>>> +	}
>>>  	if (odi->osdname_len)
>>>  		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>>>  	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
>>> --
>>
>> this looks like strdup() ?
>>
> 
> Maybe?  It's a funny thing going on with the NUL terminator and I
> don't understand what the comment is about.
> 
> It appears that normally "get_attrs[a].val_ptr" is a NUL terminated
> string but "get_attrs[a].len" does not count the terminator.
> 
> Odd.
> 
i have no clue what the programmer was thinking. if i read this correct
osdname is u8 *osdname; so a simple strdup() or strndup() would be ok
the comment seems to indicate that get_attrs[a].val_ptr could be NULL
but where is the check ?
Perhaps they are not using ascii here ? then a memdup(get_attrs[a].len)
would be better.

re,
 wh


