From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Mon, 18 Nov 2013 10:54:22 -0500
Message-ID: <528A382E.10400@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com> <5289573A.9070307@interlog.com> <52896806.4040907@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52896806.4040907@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/17/2013 8:06 PM, Phillip Susi wrote:
> I don't see anything particularly inefficient about issuing the
> command in the eh path ( in fact, libata always uses the eh path to
> handle power management ).  You can of course, use the
> manage_start_stop flag to have the disk start on resume if you
> really want.

Yikes, I think I see now why scsi eh is so bad: the entire host, not
just the device is quiesced.

I suppose now the question is how to issue the START STOP UNIT from
sd_prep_fn()?  I gather you can't just call scsi_execute_req() from
there?  Is there maybe a way to insert a START STOP UNIT request into
the queue ahead of the current request being prepped?  Can
sd_prep_fn() be called concurrently on multiple cpus?  Hrm.. what
about TCQ?  Would it be bad if the original request were queued ( to
the drive ) before the START STOP UNIT command completed?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSijguAAoJEJrBOlT6nu75AlIH/3n1XFrWWjU2D209hwaBlRCu
OHdAI40OUW0dqRrF7hyhH62X6SmDFG9pkZcCeZUNmSOEBtvkVjxJRv2VvpXpQL50
xXEiLCLukOYWG7krnVhD1BCrt9SfAjMsCpWmbC14m3epCWd9OQNFfU9vqU7mW18b
2NJPBukq+l8nzZtCl+8UMIQxH4RSkceJs3X7y4PhM65nN4kDMmJUABjJhHBZX30/
MQqu6pu2AW6Wf6SH0Sh1qIWfu45cIneuSDRP9qK5U/9902vhmGCLlt4zgbow8CQh
muspp8A+bhcVQAJVdZvHz9gQMHS0dDRjLgBE23Yik0t+zBl0wvoFsaAG4BEi0lY=
=6HCd
-----END PGP SIGNATURE-----
