From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 18:39:05 +0200
Message-ID: <e2e108260805020939o9a53680sfb6169cd4ce33fc5@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:15040 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYEBQjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:39:08 -0400
Received: by fg-out-1718.google.com with SMTP id 19so985486fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 09:39:05 -0700 (PDT)
In-Reply-To: <1209745084.3121.39.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 2, 2008 at 6:18 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2008-05-02 at 18:06 +0200, Bart Van Assche wrote:
>> Regarding inclusion of SCSI target code in the mainline, this subject
>> has already been discussed extensively in the past
>> (http://lkml.org/lkml/2008/1/23/134). The conclusion was clear: SCST
>> is faster than any other existing iSCSI target for Linux (IET, STGT,
>> LIO), stable, well maintained and the most standards compliant target.
>> Why do you want to reopen this discussion ?
>
> That's an interesting rewrite of history.  The evidence you presented
> showed fairly identical results apart from on one contrived IB benchmark
> that couldn't directly compare the two.
>
> I'm also on record in the thread saying that was insufficient proof for
> me to justify throwing STGT out and replacing it with SCST.

The trend of the measurements I did was very clear: SCST has a higher
bandwidth and a lower latency than the other three iSCSI
implementations I benchmarked. While this difference is neglectible
for 100 Mbit/s media, the difference is significant for 10 Gbit/s
media. One of the tests I did was with iSCSI via IPoIB. These results
allow direct comparison between STGT and SCST.

>> James Bottomley clearly expressed in that thread that he doesn't want
>> to maintain two SCSI target frameworks. So what I propose is that SCST
>> is included in the mainline and afterwards that it is evaluated
>> whether or not it is desirable to keep other target code in the
>> mainline kernel.
>
> That's hardly sufficient.  STGT is already in use.  Their either has to
> be a migration path or, the preferred option, take the pieces of SCST
> that are actual improvements and embed them in STGT.

In the thread I referred to it has been explained that for optimal
speed and minimum latency a kernelspace implementation is required.
Since most of STGT is implemented in userspace, embedding pieces of
SCST in STGT is not an option.

Bart.
