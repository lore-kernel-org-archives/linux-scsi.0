From: Horms <horms@verge.net.au>
Subject: Re: cdrecord and newer Linux kernels
Date: Wed, 16 Nov 2005 12:39:03 +0900 (JST)
Message-ID: <20051116033903.07B1234031@koto.vergenet.net>
References: <20051111000913.GU4682@einval.com>
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
In-Reply-To: <20051111000913.GU4682@einval.com>
Resent-Message-ID: <tQYUj.A.CG.ZnqeDB@murphy>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
To: Steve McIntyre <steve@einval.com>
Cc: debian-kernel@lists.debian.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In article <20051111000913.GU4682@einval.com> you wrote:
> [-- text/plain, encoding quoted-printable, charset: us-ascii, 33 lines --]
> 
> [ Bugger, got the cdrtools-devel address wrong on the first mail. Now
>  fixed. ]
> 
> On Fri, Nov 11, 2005 at 12:53:00AM +0100, Christoph Hellwig wrote:
>>On Thu, Nov 10, 2005 at 11:47:29PM +0000, Steve McIntyre wrote:
>>> In kernel 2.6.8 and later, SCSI generic commands are verified for
>>> safety. This may be a reasonable measure in some respects, but it
>>> makes effective non-root CD/DVD burning rather difficult. For best
>>> performance cdrecord, growisofs and friends may often need to send
>>> SCSI commands to drives that the kernel may neither know about nor
>>> understand. And (to add to the pain) these commands are very often
>>> vendor- or device-specific, so simply allowing those commands in the
>>> kernel will defeat the point of the verification in the first place.
>>
>>The whole point of the verification is to allow safe access to a
>>selected set of raw commands for normal users.  root (or rather
>>a process that has CAP_SYS_RAWIO) can send any command.  if you need
>>unknown commands just make sure to burn as root, as everything else
>>would be unsafe anyway.
> 
> That does make it rather difficult to have any safe CD/DVD writing
> software - do you think it's a good idea to have end users run apps as
> root to burn CDs? I've read too much of the cdrecord source to be
> happy running that as root! :-) My thought is that it might be better
> to allow specific commands on specific drives, and let the local admin
> configure that for themselves...
> 

The whole problem is that some IOCTLS are not safe. And there is no
definitive list of IOCTLs, so safe ones are added as they are known. And
the others are disabled.  If you have discovered ioctls which are indeed
safe, then they should be added to the whitelist.

As for allowing root to have a mechanism to allow users to access
arbitary (unsafe) ioctls, that sounds like a can of worms to me.
I have CCed the SCSI maintainers for comment.

For their reference, your original post and patch, allong with
the rest of this thread is at:

http://lists.debian.org/debian-kernel/2005/11/msg00748.html

-- 
Horms
