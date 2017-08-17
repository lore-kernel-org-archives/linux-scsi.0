From: Bernd Schubert <"Bernd Schubert"@fastmail.fm>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 15:18:06 +0200
Message-ID: <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170817124821.GA3238792@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-ide@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Tejun,

On 08/17/2017 02:48 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 17, 2017 at 11:24:22AM +0200, Bernd Schubert wrote:
>>> More concerning is the fact that these undetected errors can make their
>>> way even when the higher application consistently calls sync() and/or
>>> fsync. In other words, it seems than even acknowledged writes can fail
>>> in this manner (and this is consistent with the first machine corrupting
>>> its filesystem due to journal trashing - XFS journal surely uses sync()
>>> where appropriate). The mechanism seems the following:
>>>
>>> - an higher layer application issue sync();
>>> - a write barrier is generated;
>>> - a first FLUSH CACHE command is sent to the disk;
>>> - data are written to the disk's DRAM cache;
>>> - power is lost! The volatile cache lose its content;
>>> - power is re-established and the disk become responsive again;
>>> - a second FLUSH CACHE command is sent to the disk;
>>> - the disk acks each SATA command, but real data are lost.
> 
> Recovered errors aren't reported as IO errors and at least from link
> state proper there's no way for the driver to tell apart link
> glitches and buffer-erasing power issues.
> 
>>> Now, I have few questions:
>>> - is the above explanation plausible, or I am (horribly) missing something?
> 
> For the most part, yes.  To be more accurate, the failure is coming
> from libata not being able to tell apart link glitches from the device
> getting reset due to power issues.

So for Gionatan the root cause was an instable power supply, but in my
case there wasn't any power loss, there were just failed sata commands.
I'm not sure if this was a port or cable issue - once I changed port and
sata cable the errors disappeared. I didn't change the power supply or
power cable. I'm now basically fighting with the data corruption that
caused - for btrfs it at least has a checksum, but I didn't have ext4
checksum enabled, so it is hard to figure out which files are corrupts -
silent data corruption is not well handled by backups either.

> 
>>> - why the scsi midlevel does not respond to a power loss event by
>>> immediately offlining the disks?
> 
> Because we don't wanna be ditching disks on temporary link glitches,
> which do happen once in a while.
> 
>>> - is the scsi midlevel behavior configurable (I know I can lower eh
>>> timeout, but is this the right solution)?
>>> - how to deal with this problem (other than being 100% sure power is
>>> never lost by any disks)?
> 
> So, the right way to deal with the problem probably is making use of
> the SMART counter which indicates power loss events and verify that
> the counter hasn't increased over link issues.  If it changed, the
> device should be detached and re-probed, which will make it come back
> as a different block device.  Unfortunately, I haven't had the chance
> to actually implement that.

Is it possible that sata eh recovery sends resets to the device, which
makes it evict its cache?

Thanks,
Bernd



