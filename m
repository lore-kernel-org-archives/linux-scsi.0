From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Thu, 09 Jan 2014 12:03:58 -0500
Message-ID: <52CED67E.7080706@ubuntu.com>
References: <20140108005607.GB29556@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140108005607.GB29556@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com, tj@kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 7:56 PM, Todd E Brandt wrote:
> On resume, the ATA port driver currently waits until the AHCI
> controller finishes executing the port wakeup command. This patch
> changes the ata_port_resume callback to issue the wakeup and then
> return immediately, thus allowing the next device in the pm queue
> to resume. Any commands issued to the AHCI hardware during the
> wakeup will be queued up and executed once the port is physically
> online. Thus no information is lost.
> 
> This patch only changes the behavior of the resume callback, not
> restore, thaw, or runtime-resume. This is because thaw and restore
> are used after a suspend-to-disk, which means that an image needs
> to be read from swap and reloaded into RAM. The swap disk will
> always need to be fully restored/thawed in order for resume to
> continue.
> 
> The return value from ata_resume_async is now an indicator of
> whether the resume was initiated, rather than if it was completed.
> I'm letting the ata driver assume control over its own error
> reporting in this case (which it does already). If you look at the
> ata_port resume code you'll see that the ata_port_resume callback
> returns the status of the ahci_port_resume callback, which is
> always 0. So I don't see any harm in ignoring it.
> 
> If somebody requests suspend while ATA port resume is still
> running, the request is queued until the resume has completed. I've
> tested that case very heavily. Basically if you do two suspends in
> a row (within seconds of each other) you lose any performance
> benefit, but that's a use case that should happen only very rarerly
> (and wouldn't be expected to be of any power benefit since too many
> sequential suspends actually takes more power than just letting the
> machine stay in run mode).

I think my patch for this "libata: resume in the background" was a LOT
simpler.  It just used the existing behavior of becoming async when
the async argument was !NULL, and fixed the one caller that didn't
actually care about the result to pass in a pointer anyhow.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSztZ+AAoJEI5FoCIzSKrwQ6QH/jA1kIDsDC5LBQDGtDjZ/cvB
hLddAkDmqswfMXDmtD+u5lQuc+a0GbjINvrMYtq6bilDuPO39ccR//jUL69PULDo
qcn3RMjzSIIqyfCiKj6iAIZyuTTR9SLgA9F9V2b0RBPn1FFD84y+qEitzrqb+/z6
pBjVYbbjfpj+Sfr00dbk7a6BTzB2FHTSEwA/Kv5gM2MJKGPrjmML8awl3gSG+lGT
mOYV8yR+kycrnkp8Rcr+7hNb6LfJlKWBh33UA4TKxrE5WZg0nX+kU83BoCpRgvCm
nfYynvakJ1E0Wz2fiYQq1NeNy1ZUZ7iyDdsl70KslaAhPFBQUH/tsoXL1syHSRo=
=rXVR
-----END PGP SIGNATURE-----
