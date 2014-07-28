From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: Write cache and surface error behaviour
Date: Mon, 28 Jul 2014 18:57:16 -0500
Message-ID: <53D6E35C.5020107@tributary.com>
References: <53CC3A92.5000501@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.54]:5863 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaG2AC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2014 20:02:28 -0400
In-Reply-To: <53CC3A92.5000501@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joystick <joystick@shiftmail.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 7/20/2014 4:54 PM, joystick wrote:
> So what happens when the disk tries to write it to the platter and 
> discovers that there is a media error on that sector? (suppose relocation
> does not happen ; maybe sectors exhausted) Does Linux receive the write
> error upon the next flush it issues? 

	At least for SCSI I believe the situation you describe is covered in the SCSI
specifications as a deferred error. Basically, the device returns a check
condition indicating a deferred failure in response to another command.

	My understanding (and I'm sure others can correct it) is that the device
server can issue these check conditions anytime it wants. The only guarantee is
that data written before the last successful SYNC is on the media (doesn't mean
you can read it!). So, in order to guarantee data is not lost, a system using
writeback should retain all of the writeback data until a successful SYNC CACHE
operation.

	For example see, SPC4 4.5.7 note 6.

	If you consider what happens during power loss to a write-back cache, its the
same situation. Bottom line, make sure to issue sync's for data you want to
retain and use a filesystem/device that supports barriers and SYNC CACHE/CACHE
FLUSH correctly. Still YMMV.















