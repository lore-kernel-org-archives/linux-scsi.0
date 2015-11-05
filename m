From: Todd Gill <tgill@redhat.com>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Thu, 5 Nov 2015 15:34:11 -0500
Message-ID: <563BBD43.2060706@redhat.com>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-20-git-send-email-hare@suse.de>
 <20150901111517.GB10589@lst.de> <55E5A0D5.5070402@suse.de>
 <20150902063927.GA13399@lst.de> <55E6B7E4.7010308@suse.de>
Reply-To: tgill@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbbKEUeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2015 15:34:13 -0500
In-Reply-To: <55E6B7E4.7010308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>

On 09/02/2015 04:48 AM, Hannes Reinecke wrote:
> On 09/02/2015 08:39 AM, Christoph Hellwig wrote:
>> On Tue, Sep 01, 2015 at 02:57:57PM +0200, Hannes Reinecke wrote:
>>
>> It might be a good idea to prioritize that.  Todd has been asking
>> for multipath monitoring APIs and suggested adding D-BUS APIs to
>> multipathd.  I'd much prefer them directly talking to the kernel
>> instead of cementing multipathd, which is a bit of a wart.

I have a working prototype of a D-Bus API implemented as a new thread of
multipathd.  The good news is it would be very easy to move to another
process.

>>
> Precisely my idea.
> I'm fine with having a device-mapper D-Bus API, so that any application
> can retrieve the device-mapper layout via D-Bus.
> (It might as well be using sysfs directly, but who am I to argue here)
> Path events, however, out of necessity are instantiated within the
> kernel, and should be send out from the kernel via uevents.
> 
> D-Bus can be added on top of that, but multipathd should not generate
> path events for D-Bus.
> 

Where should D-Bus events be layered on top of the uevents if not inside
multipathd?

Would putting it inside multipathd be a reasonable first step?  We could
maintain the same public D-Bus API and move it to a different process.

Thanks,
Todd
