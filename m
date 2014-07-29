From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Write cache and surface error behaviour
Date: Mon, 28 Jul 2014 18:43:13 -0700
Message-ID: <53D6FC31.3040908@interlog.com>
References: <53CC3A92.5000501@shiftmail.org> <53D6E35C.5020107@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33368 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaG2BnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 21:43:24 -0400
In-Reply-To: <53D6E35C.5020107@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, joystick <joystick@shiftmail.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 14-07-28 04:57 PM, Jeremy Linton wrote:
> On 7/20/2014 4:54 PM, joystick wrote:
>> So what happens when the disk tries to write it to the platter and
>> discovers that there is a media error on that sector? (suppose relocation
>> does not happen ; maybe sectors exhausted) Does Linux receive the write
>> error upon the next flush it issues?
>
> 	At least for SCSI I believe the situation you describe is covered in the SCSI
> specifications as a deferred error. Basically, the device returns a check
> condition indicating a deferred failure in response to another command.
>
> 	My understanding (and I'm sure others can correct it) is that the device
> server can issue these check conditions anytime it wants. The only guarantee is
> that data written before the last successful SYNC is on the media (doesn't mean
> you can read it!). So, in order to guarantee data is not lost, a system using
> writeback should retain all of the writeback data until a successful SYNC CACHE
> operation.
>
> 	For example see, SPC4 4.5.7 note 6.
>
> 	If you consider what happens during power loss to a write-back cache, its the
> same situation. Bottom line, make sure to issue sync's for data you want to
> retain and use a filesystem/device that supports barriers and SYNC CACHE/CACHE
> FLUSH correctly. Still YMMV.

Another possibility is to use the WRITE AND VERIFY commands
which have 10, 16 and 32 byte variants. They always write to
the medium and never (as far as I can see) lead to deferred
errors being generated for some subsequent commands. So if
the write "goes bad" and can't be re-assigned to another
part of the medium (because that is disallowed or resources are
depleted) then the application client will be informed in the
status and sense data for the offending WRITE AND VERIFY.

So a remaining issue is how well the WRITE AND VERIFY command
is supported by modern disks and RAIDs.

Doug Gilbert






