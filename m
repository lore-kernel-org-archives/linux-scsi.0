From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Thu, 07 Nov 2013 16:16:57 -0500
Message-ID: <527C0349.5010301@ubuntu.com>
References: <527AF287.7020700@ubuntu.com> <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com> <527BDA11.6060603@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40242 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3KGVRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 16:17:04 -0500
In-Reply-To: <527BDA11.6060603@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/7/2013 1:21 PM, Douglas Gilbert wrote:
> On 13-11-06 08:57 PM, Phillip Susi wrote:
>> Don't bother forcing disks to spin up on resume, as they will do
>> so automatically when accessed, and forcing them to spin up slows
>> down the resume.  Add a second bit to the manage_start_stop flag
>> to restore the previous behavior.
> 
> SCSI disks when in STOP state do not spin up "automatically when
> accessed".

The drive does not, but the scsi error handling notices when a command
fails because the drive needs started, starts it, and retries the command.

> And your choice of bits looks like it will favour fixing broken
> SATA behaviour but as a by-product break working SCSI disk
> behaviour.

No, it has nothing to do with sata behavior; it has to do with whether
or not all disk drives should be restarted immediately after a resume,
or only when they are accessed.  I happen to have a few older drives
that I very rarely access and would rather they not start up every
time I resume.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSfANJAAoJEJrBOlT6nu75BIAIALHveooj3EuVQ9DmzsCKezT2
ILHsGKAecgojAbxNFp4JXTwmlnNMUQzGaaxfXgoTES4WBiDnba0sedVW+aPqI8Ul
cA8FXeIPtk1U5/xA6iW9XFInOTkvpXSnl9yeX7zldtcjxBm0bQ49JUk4zI68jQwF
YPxEb0bxPpJvUcoYbM6eo+I6GnBqpCU9FDVoy0wnb1Zp6qQEY59kOvQc51Pl10KR
Vwmayc7B9dncfk9+46knt4ocBUdSdX1rzRqN0EfGIZtkWysP6w5HmA0ejocEIyHT
YErI94JvAEOZkzGHZgaMykxTE5SGYX8Fz3w3LVc9uAc40oIf3qFHb5Bob6Ecy6Q=
=SkP3
-----END PGP SIGNATURE-----
