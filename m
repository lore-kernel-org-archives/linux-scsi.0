From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sat, 16 Nov 2013 22:50:01 -0500
Message-ID: <52883CE9.9040102@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>	 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>	 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com> <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/16/2013 01:20 PM, James Bottomley wrote:
> No disk does, neither SCSI nor ATA.  The error handler is not 
> automatically activated for a not ready/initializing command
> required because of multi-path.  We override the default behaviour
> via allow_restart only for IBM vfc/vscsi and ATA disks.  With this
> patch SCSI devices would no longer ever restart after suspend.

I don't follow.  A scsi disk returns a sense status saying it requires
a START UNIT command when issued a command before being started.  This
triggers the eh which notices that sense status and issues the
command.  My first version seemed to cause hdparm to fail on an ata
drive that required SET FEATURES command to start up after power on,
so the next version I set the DFLAG_SLEEPING bit which causes a
preemptive start command on access even for SGIO, which otherwise
seems to suppress eh.

> As Doug said, if you don't restart a SCSI device after resume, it
> will never get started.

If something ( and I am still not clear on what ) is suppressing the
error handling code for scsi disks, it should be able to be handled in
a simiar way to ata: set a flag that causes preemptive startup even if
eh is suppressed.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSiDzoAAoJEJrBOlT6nu75kXIIAJ+7wO8jcnw4LzlBoB8ELY8m
pZxsgvM0c4fQlqNvsCgXbhRYaNK5aHTk1RtguTuV4iJ8rQj+73jmuftar4kq5As2
yZZ2LCYKNdHgBhCe0t2o+vVFKdh6Vaqawm0Gsaqy1D6WNUWXh8D0wicD9gLwJBxo
R1nH2UNw337e6fnhTvF6uzA3OKUC9mJyJIrfrM7djCg46I/QkL0G2gDif8EQbTvo
/XpHywFheFUz5LEz6Ctbxb7VvacE62Nj9kmnDNc2rE+bpP/GeQ72sxmKCtVcm515
HqMRaU8efo8EIRIBNUqYRxZuIDr9vA9rsHq5XxtDAeWPXfjibcEaA/iwBZp6oyY=
=vVEg
-----END PGP SIGNATURE-----
