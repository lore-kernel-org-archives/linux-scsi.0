From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: *solved* megaraid /proc under kernel 2.6.2
Date: Tue, 17 Feb 2004 18:36:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <D9CCD5AC-616F-11D8-B07A-000A95CD704C@kungfoocoder.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org> <1076890712.2943.276.camel@morsel.kungfoocoder.org> <1076972673.2259.56.camel@morsel.kungfoocoder.org> <20040217165739.GV31168@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0 (Apple Message framework v612)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-22--52044661"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out3.xs4all.nl ([194.109.24.13]:37391 "EHLO
	smtp-out3.xs4all.nl") by vger.kernel.org with ESMTP id S266369AbUBQRg4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 12:36:56 -0500
In-Reply-To: <20040217165739.GV31168@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>


--Apple-Mail-22--52044661
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed


On Feb 17, 2004, at 17:57, Matthew Wilcox wrote:

> On Tue, Feb 17, 2004 at 12:04:33AM +0100, Paul Wagland wrote:
>> Hi all,
>>
>> OK, I now know what the problem is with the /proc entries and the
>> megaraid driver.
>>
>> It turns out that pci_driver.probe member (in this case
>> megaraid_probe_one()) is called before the module_init() declared
>> function, in this case megaraid_init().
>
> Hang on.  The pci_driver isn't registered magically, it happens by an
> explicit call.  Oh look, here's the problem:

I had the same brainwave while at work today... I am planning on 
reversing those and testing that now... if it works then I will be 
sending a patch through in about a half hour :-)

For some reason last night I was just assuming that it was hotplug 
events that were causing megaraid_probe_one() to be called. In reality, 
I probably should of just gone to sleep earlier ;-)

Thanks for the input,
Paul

--Apple-Mail-22--52044661
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFAMlEwtch0EvEFvxURAi3WAJ41n+xiipiUHwCDYuZCpiZbbM1gfgCfc3oK
oJ6GLtbQjf0qEbJ85RSwyog=
=AjVL
-----END PGP SIGNATURE-----

--Apple-Mail-22--52044661--

