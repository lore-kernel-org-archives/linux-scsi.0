From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Fri, 13 Aug 2010 15:21:36 +0200
Message-ID: <4C6546E0.7070208@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C6540C5.8070108@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/13/2010 02:55 PM, Vladislav Bolkhovitin wrote:
> If requested, I can develop the interface further.

I still think the benefit of ordering by tag would be marginal at
best, and what have you guys measured there?  Under the current
framework, there's no easy way to measure full ordered-by-tag
implementation.  The mechanism for filesystems to communicate the
ordering information (which would be a partially ordered graph) just
isn't there and there is no way the current usage of ordering-by-tag
only for barrier sequence can achieve anything close to that level of
difference.

Ripping out the original ordering by tag mechanism doesn't amount to
much.  The use of ordering-by-tag was pretty half-assed there anyway.
If you think exporting full ordering information from filesystem to
the lower layers is worthwhile, please go ahead.  It would be very
interesting to see how much actual difference it can make compared to
ordering-by-filesystem and if it's actually better and the added
complexity is manageable, there's no reason not to do that.

Thank you.

-- 
tejun
