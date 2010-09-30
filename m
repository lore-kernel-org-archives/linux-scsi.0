From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Thu, 30 Sep 2010 12:07:02 -0500
Message-ID: <4CA4C3B6.9000104__45601.3106894263$1285866435$gmane$org@redhat.com>
References: <yq1pqvzcddq.fsf@sermon.lab.mkp.net> <4CA118FF.1080100@fusionio.com> <yq18w2mddav.fsf@sermon.lab.mkp.net> <20100927231551.GA15653@redhat.com> <4CA16F6A.1090904@fusionio.com> <4CA17B13.7080801@redhat.com> <20100928141545.GA21587@redhat.com> <20100928205741.GA22257@thunk.org> <yq162xpa7dj.fsf@sermon.lab.mkp.net> <4CA25FEA.6040505@redhat.com> <20100930163047.GA4098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab0I3RHJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 13:07:09 -0400
In-Reply-To: <20100930163047.GA4098@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, James.Bottomley@hansenpartnership

On 09/30/2010 11:30 AM, Ted Ts'o wrote:
> On Tue, Sep 28, 2010 at 04:36:42PM -0500, Eric Sandeen wrote:
>> Ok, then it sounds like mkfs.ext4's refusal to make fs blocksize less
>> than device physical sectorsize without -F is broken, and that should
>> be removed.  I'd say issue a warning in the case but if there's a 16k
>> physical device maybe there's no point in warning either?
> 
> If the device physical sectorsize is that big, should we perhaps use
> that as a hint to align writes to that blocks aligned with that
> physical sectorsize?  Right now we use the optimal I/O size, but if
> the optimal I/O size is not specified and the physical sectorsize is,

I can't keep track of all the parameters, is it ever true that optimal
I/O size isn't specified?

> say, 16k or 32k, maybe we should use to calculate for
> s_raid_stripe_width?

Perhaps, though really ext4 still doesn't do -that- much with the value,
anyway...

-Eric
