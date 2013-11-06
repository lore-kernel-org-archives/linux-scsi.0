From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk wakeup on resume
Date: Wed, 06 Nov 2013 09:40:28 -0500
Message-ID: <527A54DC.3050702@ubuntu.com>
References: <527859D9.3030607@ubuntu.com> <5278B4DB.7080302@intel.com> <527963F9.5030006@ubuntu.com> <5279D877.2010200@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:44557 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3KFOkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2013 09:40:31 -0500
In-Reply-To: <5279D877.2010200@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "Brandt, Todd E" <todd.e.brandt@intel.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/6/2013 12:49 AM, Aaron Lu wrote:
> Todd has been optimising system resume for SATA drives without
> touching runtime PM: 
> http://www.spinics.net/lists/linux-scsi/msg69532.html You may want
> to take a look.

Thanks for the pointer, but is there somewhere you can download the
bloody full original message with headers so I can generate a proper
reply?

Also, last night I noticed that ata_port_resume() ( which is called
both for runtime and system resume ) was explicitly calling into the
pm core to set the runtime status to active.  I thought that was the
problem so I disabled that code and made it work the other related
functions and just return success without resetting the link if it is
runtime suspended, but it seems that the runtime suspend state is
being cleared already by the time the system resume is called and I
haven't figured out where yet.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSelTcAAoJEJrBOlT6nu75L3cH/0/cRtaW2n8viQvIJgwM2N5P
t2WnQMEgYse9zOrkuDNWQyTXOib0ccYR3aQZuu9XXWVXG+w3KvT+D8yyWlyFkvz2
pQZErEF0vZeWVNlJPzQZqWlQQfpIocF6Ebleo5j6i0xzgNFxwVMC+ICqCLPYbjZa
lxGTP3bX1TMEdA4D9rTkIfi3naVSbITY9pm0oe+aKzknFjDKmx5Zj6SIjdUFfm9B
CUJxvYCcj4NKhLqcBJRTiNnIK/Wtg1twbXWbGSWvIGe01aShD7FXRDxmCL4FgYG1
YZ/MSlb4R4IQxtetgxaqC/ujOkf6FNvCUV3Y8qvlvSKdeVSzoz0wDgjgK4VWDmg=
=GpAA
-----END PGP SIGNATURE-----
