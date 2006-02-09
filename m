From: Tejun Heo <htejun@gmail.com>
Subject: Re: Regarding ordered-tag support.
Date: Thu, 09 Feb 2006 13:12:00 +0900
Message-ID: <43EAC110.5030700@gmail.com>
References: <43E99248.7090505@gmail.com>	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>	 <43EA2313.9030506@gmail.com>	 <1139418451.3003.37.camel@mulgrave.il.steeleye.com>	 <43EA27E4.9080105@gmail.com> <1139419637.3003.43.camel@mulgrave.il.steeleye.com> <43EA329F.2000906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.201]:41784 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1422792AbWBIEMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 23:12:06 -0500
Received: by wproxy.gmail.com with SMTP id 55so221979wri
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2006 20:12:05 -0800 (PST)
In-Reply-To: <43EA329F.2000906@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> James Bottomley wrote:
> 
>> I suppose I'm a broken record, but I really think linked tasks are the
>> better way to enforce the required ordering guarantees for SCSI TCQ.
>> The problem being that this would present a slightly different API at
>> the block level (you have individual writes that are now ordered, not
>> wholesale barriers).
> 
> I strongly agree, since fundamentally, linked tasks is what is really 
> going on.

Hello, James.  Hello, Jeff.

Maybe I have misunderstood, but, AFAICS, linked task doesn't assure any 
ordering relation with respect to other tasks unlike ordered tag.  So, 
it doesn't make much difference compared to simple & stupid ordering by 
draining.  For a barrier to work, the following order should be kept.

pre-barrier writes -> cache flush -> barrier write (FUA) -> other writes

Issuing cache flush and barrier write with ordered tags accomplishes all 
the ordering requirements (if it works, that is.).  I can see linked 
task can be used for 'cache flush -> barrier write (FUA)' segment but 
that leaves us with two unhandled ordering requirements.

Another thing I'm curious about linked task is what advantages linked 
task has over simply issuing and completing the commands sequentially. 
Commands in a linked task has to be issued and completed sequentially 
anyway, so I don't really see the difference.

Thanks.

-- 
tejun
