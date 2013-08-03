From: Nick Alcock <nick.alcock@esperi.org.uk>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Sat, 03 Aug 2013 12:17:31 +0100
Message-ID: <87vc3nuipg.fsf@spindle.srvr.nix>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
	<51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
	<51FA71E2.6010501@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <51FA71E2.6010501@fastmail.fm> (Bernd Schubert's message of "Thu,
	01 Aug 2013 16:34:10 +0200")
Sender: stable-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 1 Aug 2013, Bernd Schubert stated:

> Once I noticed that scsi_get_vpd_page() works fine from other function
> calls and that it is not 0x89, but already 0x0 that fails fixing it became
> easy.
>
> Nix, any chance you could verify it also works for you?

Confirmed, thank you!

> Somehow older areca firmware versions have issues with
> scsi_get_vpd_page() and a large buffer.

I wonder if they're using math modulo SD_BUF_SIZE-1 by mistake, so they
misinterpret this as zero? (Still, doing math modulo 511 seems very
odd, even if this firmware *does* only support 512-byte sectors.)

-- 
NULL && (void)
