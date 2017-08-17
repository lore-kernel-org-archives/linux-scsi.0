From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 15:43:10 +0200
Message-ID: <5c89b7a8-df87-c6aa-6cd2-af4e9635d1b1@fastmail.fm>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
 <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
 <20170817132519.GD3238792@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59263 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752261AbdHQNnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Aug 2017 09:43:12 -0400
In-Reply-To: <20170817132519.GD3238792@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Bernd Schubert <Bernd.Schubert@fastmail.fm>
Cc: linux-ide@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>, linux-scsi@vger.kernel.org



On 08/17/2017 03:25 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 17, 2017 at 03:18:06PM +0200, Bernd Schubert wrote:
>> So for Gionatan the root cause was an instable power supply, but in my
>> case there wasn't any power loss, there were just failed sata commands.
>> I'm not sure if this was a port or cable issue - once I changed port and
>> sata cable the errors disappeared. I didn't change the power supply or
>> power cable. I'm now basically fighting with the data corruption that
>> caused - for btrfs it at least has a checksum, but I didn't have ext4
>> checksum enabled, so it is hard to figure out which files are corrupts -
>> silent data corruption is not well handled by backups either.
> 
> No idea there.  Retried and recovered errors shouldn't cause data
> corruptions.  Flaky power can behave in unexpected ways tho.  What
> happens if you hook up the drive on a different power supply but
> revert to the port / cable which showed the problem?  What does your
> SMART counters say across those failures?

Hmm, well, I think I through away the cable already, and I also don't
have spare power supplies at home. It also wasn't that easy to reproduce
the errors, they came up when my wife was working on her system - not
when I was controlling it ;)

> 
>> Is it possible that sata eh recovery sends resets to the device, which
>> makes it evict its cache?
> 
> That'd be a very broken device.  It sure is theoretically possible but
> I haven't seen any reports on such behaviors yet.

I wonder if we just couldn't make the error handler to report issues for
people who are running raid. Gionatans powerloss and my unclear
corruption issue probably wouldn't have happened if the upper md layer
would have gotten an information that it should report errors instead of
recovering them. Although I admit it is a difficult decision what to
with link glitches.


Thanks,
Bernd
