From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 16:32:41 -0500
Message-ID: <527963F9.5030006@ubuntu.com>
References: <527859D9.3030607@ubuntu.com> <5278B4DB.7080302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:56986 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3KEVco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2013 16:32:44 -0500
In-Reply-To: <5278B4DB.7080302@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/5/2013 4:05 AM, Aaron Lu wrote:
> Are you using an ATA drive? Last time I checked, the spin up
> actually happened while the ata port is resumed(when it will be
> reset): https://lkml.org/lkml/2013/2/4/361

Is there a reason these patches weren't applied?  It looks like it
should be pretty simple to have ata_port_resume return without
blocking on the reset, but I wonder if that would cause a problem?

Doesn't the pm core sequence the resume of the various devices, so
that the ata device is resumed after the ata port has been resumed, so
wouldn't returning before the reset has finished mess up the ata
device resume, which expects that the port is already online?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSeWP5AAoJEJrBOlT6nu757vUIALEW810IW5FMyCQp6qx80U1w
QnEcY212ZdBCLqCiF/u8BaoVECM7VsdwjfVeI3CKUYvemNAXPJBCTpB/5KUMWL43
KbpK3A0EkrdEsNjescmP+i0mYEIWXhB9Kj8IDMKR3HypNESua8X8YUaiNzkxNNGz
aK11EsNn1Ut5FC0jzWInBfUq8E9WwYmPItxddb8ISIxr8vSbI5AME8HuupH+tT8f
6VVmCFQwxj5zbiGOJEUZPmwTvE0GgzY+rSYVKvRLRoi+Cv8C2AI/nAMEpYlzuGYT
Ku8RzUxV3nO8AAlX4yrnvplgWV2HDX0FvW7jl38fDJsxW1306j4BECJ8Rs8tbCQ=
=Ylq6
-----END PGP SIGNATURE-----
