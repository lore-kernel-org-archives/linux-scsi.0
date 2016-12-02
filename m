From: Hannes Reinecke <hare@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 2 Dec 2016 15:10:01 +0100
Message-ID: <9af9525a-be53-c3ee-6977-dd7aa30385f9@suse.de>
References: <1479752642.19792.43.camel@localhost.localdomain>
 <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <1479839407.28416.21.camel@localhost.localdomain>
 <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
 <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
 <1479932524.28416.43.camel@localhost.localdomain>
 <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
 <1194718949.74785.1480096576577.JavaMail.zimbra@redhat.com>
 <1480523188.28416.94.camel@localhost.localdomain>
 <yq18trzhink.fsf@sermon.lab.mkp.net> <20161202122133.GA14247@infradead.org>
 <1480685383.28416.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbcLBOKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 09:10:03 -0500
In-Reply-To: <1480685383.28416.147.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Laurence Oberman <loberman@redhat.com>, Eyal Ben David <bdeyal@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On 12/02/2016 02:29 PM, Ewan D. Milne wrote:
> On Fri, 2016-12-02 at 04:21 -0800, Christoph Hellwig wrote:
>> On Thu, Dec 01, 2016 at 08:40:31AM -0500, Martin K. Petersen wrote:
>>> Specifically, the problem appears to be caused by the removal of
>>> the setting of bio->bi_bdev, which would previously be set to NULL.
>>> If I add:
>>
>> Very odd.  For one I would expect it to be NULL anyway, second
>> I don't see why the behavior changed.  But given that this reverts
>> to the original assignment and makes things work I'll happily hack it
>> to get things working again:
>>
>> Acked-by: Christoph Hellwig <hch@lst.de>
>
> Yeah, I'm not sure I understand this either, apart from the change
> adjusting the code to effectively do what it used to and making the
> test case work.  I'm reluctant to cc: stable yet, let me look at this
> a bit more and I'll post the actual patch soon.
>
Plus we found that this is basically a timing issue; we've found that 
supposedly fixed bugs will crop up after ~4k iterations.
(Johannes did a _lot_ of testing here :-)
So just because the bug failed to materialize can also mean that you 
simply didn't test long enough.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
