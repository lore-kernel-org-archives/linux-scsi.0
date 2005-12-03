From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: [PATCH] aic79xx should be able to ignore HostRAID enabled adapters
Date: Sat, 3 Dec 2005 17:39:49 +0100
Message-ID: <20051203163949.GA3431@merlin.emma.line.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E318@otce2k03.adaptec.com> <20051201144745.GI2782@redhat.com> <20051203112208.GC31216@merlin.emma.line.org> <4391C575.6030501@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:31212 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751297AbVLCQjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Dec 2005 11:39:53 -0500
Content-Disposition: inline
In-Reply-To: <4391C575.6030501@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthias Andree <matthias.andree@gmx.de>, Heinz Mauelshagen <mauelshagen@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, 03 Dec 2005, Jeff Garzik wrote:

> Matthias Andree wrote:
> >In my message I asked whether it was feasible for you to look at
> >FreeBSD's "ataraid(4)" driver to learn the Intel ICHx-R SoftRAID format.
> >I know FreeBSD understands this format, and dmraid did not when I sent
> >the email.
> 
> Read the readme :)
> 
> http://people.redhat.com/~heinzm/sw/dmraid/readme
> 
> The following ATARAID types are supported:
> 
> Highpoint HPT37X
> Highpoint HPT45X
> Intel Software RAID
> [...]

I know it claimed support, but didn't appear to work for me (kernel
2.6.13 as on SUSE 10.0, ICH7-R chipset).

What good is this readme if "dmraid -s" doesn't come up with anything?

I cannot recreate the problem any more, as the machine, as I wrote, has
moved forward to an Escalade 8000 series controller (it's more
convenient anyhow).

Attached my original message from 4 weeks ago.

-- 
Matthias Andree

--sdtB3X0nJg68CQEu
Content-Type: message/rfc822
Content-Disposition: inline

Date: Tue, 8 Nov 2005 23:19:48 +0100
From: Matthias Andree <matthias.andree@gmx.de>
To: Mauelshagen@RedHat.com
Subject: dmraid vs. ICH7-R fakeraid
Message-ID: <20051108221948.GA26912@merlin.emma.line.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.11

Heinz,

I'm not sure if you can read German or if that's adequate, so I'm
writing in English.  But if you find German more convenient, feel free
to use it in your reply.

I was recently asked to install SUSE Linux on a Primergy RX100S3, to
find out that Linux's libata AHCI driver 1. doesn't support hotplug yet
(as of 2.6.13, to be more precise), 2. doesn't understand the BIOS RAID
stuff. It exposes my SATA RAID1 physical volumes as block devices though.

I tried dmraid 1.0.0.rc8, but apparently it is unable to understand this
Intel metadata layout.

I then tried FreeBSD 6 since it claims support, and it (ataraid(4))
indeed detects the Intel software RAID layout properly; unfortunately
the underlying ata(4) driver only detects the drive if the BIOS is set
to "compatibility" mode which makes one drive disappear - so FreeBSD
doesn't work for this particular machine yet (I presume 6.1 will do).

However, as the FreeBSD kernel sources are open source and AFAIR without
BSD advertising clause, it should be safe to ask: could you have a look
at the FreeBSD ataraid(4) source code and see if you can learn the
ICH7-R metadata layout and bring it into dmraid 1.0.0.rc10?

Thank you.

Kind regards,

-- 
Matthias Andree

--sdtB3X0nJg68CQEu--
