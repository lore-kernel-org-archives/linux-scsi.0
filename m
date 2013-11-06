From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: Disk wakeup on resume
Date: Wed, 06 Nov 2013 13:49:43 +0800
Message-ID: <5279D877.2010200@intel.com>
References: <527859D9.3030607@ubuntu.com> <5278B4DB.7080302@intel.com> <527963F9.5030006@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <527963F9.5030006@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "Brandt, Todd E" <todd.e.brandt@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 11/06/2013 05:32 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/5/2013 4:05 AM, Aaron Lu wrote:
>> Are you using an ATA drive? Last time I checked, the spin up
>> actually happened while the ata port is resumed(when it will be
>> reset): https://lkml.org/lkml/2013/2/4/361
> 
> Is there a reason these patches weren't applied?  It looks like it

The problem is system PM and runtime PM are independently
configurable... some system may have CONFIG_SUSPEND enabled but not
CONFIG_PM_RUNTIME, that would make this not usable.

> should be pretty simple to have ata_port_resume return without
> blocking on the reset, but I wonder if that would cause a problem?

Todd has been optimising system resume for SATA drives without touching
runtime PM:
http://www.spinics.net/lists/linux-scsi/msg69532.html
You may want to take a look.

-Aaron

> 
> Doesn't the pm core sequence the resume of the various devices, so
> that the ata device is resumed after the ata port has been resumed, so
> wouldn't returning before the reset has finished mess up the ata
> device resume, which expects that the port is already online?
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJSeWP5AAoJEJrBOlT6nu757vUIALEW810IW5FMyCQp6qx80U1w
> QnEcY212ZdBCLqCiF/u8BaoVECM7VsdwjfVeI3CKUYvemNAXPJBCTpB/5KUMWL43
> KbpK3A0EkrdEsNjescmP+i0mYEIWXhB9Kj8IDMKR3HypNESua8X8YUaiNzkxNNGz
> aK11EsNn1Ut5FC0jzWInBfUq8E9WwYmPItxddb8ISIxr8vSbI5AME8HuupH+tT8f
> 6VVmCFQwxj5zbiGOJEUZPmwTvE0GgzY+rSYVKvRLRoi+Cv8C2AI/nAMEpYlzuGYT
> Ku8RzUxV3nO8AAlX4yrnvplgWV2HDX0FvW7jl38fDJsxW1306j4BECJ8Rs8tbCQ=
> =Ylq6
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

