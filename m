From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Wed, 18 Aug 2010 23:30:40 +0400
Message-ID: <4C6C34E0.3050601@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C6546E0.7070208@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

Tejun Heo, on 08/13/2010 05:21 PM wrote:
>> If requested, I can develop the interface further.
>
> I still think the benefit of ordering by tag would be marginal at
> best, and what have you guys measured there?  Under the current
> framework, there's no easy way to measure full ordered-by-tag
> implementation.  The mechanism for filesystems to communicate the
> ordering information (which would be a partially ordered graph) just
> isn't there and there is no way the current usage of ordering-by-tag
> only for barrier sequence can achieve anything close to that level of
> difference.

Basically, I measured how iSCSI link utilization depends from amount of 
queued commands and queued data size. This is why I made it as a table. 
 From it you can see which improvement you will have removing queue 
draining after 1, 2, 4, etc. commands depending of commands sizes.

For instance, on my previous XFS rm example, where rm of 4 files took 
3.5 minutes with nobarrier option, I could see that XFS was sending 1-3 
  32K commands in a row. From my table you can see that if it sent all 
them at once without draining, it would have about 150-200% speed increase.

Vlad
