From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Tue, 17 Dec 2013 09:24:54 -0500
Message-ID: <52B05EB6.5070905@ubuntu.com>
References: <20131017193331.GA11747@linux.intel.com> <527AF287.7020700@ubuntu.com> <20131109012023.GA8978@linux.intel.com> <527EA218.6010604@ubuntu.com> <20131111165920.GA25366@linux.intel.com> <52810F21.9070605@ubuntu.com> <20131217121527.GB29989@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20131217121527.GB29989@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: todd.e.brandt@linux.intel.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/17/2013 7:15 AM, Tejun Heo wrote:
> On Mon, Nov 11, 2013 at 12:08:49PM -0500, Phillip Susi wrote:
>> No, I did not tune my system; I fixed the kernel so that
>> userspace's activities do not start those disks.
> 
> So, umm, implementing things in kernel to facilitate userland is
> great but please don't try to work around userland from kernel.  It
> may be easy now but inevitably becomes a maintenance burden where
> we don't have much visibility into what userland is depending on.
> If a certain feature needs cooperation from userland, update
> userland accordingly.

udisks already cooperates by checking the power status before issuing
more commands that would cause the drive to spin up.  I suppose I
could have added a sysfs flag exposing the sleep state and had
userspace check that first, but it seems silly to add a whole new ABI
and to check the power state rather than simply fixing the existing
command to not wake the disk in order to tell userspace what we
already know using a code path we already have.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSsF61AAoJEI5FoCIzSKrwMvEH/3IOti/mKMvwm6b0ie3+knMT
QLDPuq7K/7qkbHPuSD/Bm2OwJR69SRFYSUYLpLL/u8r1JAgRKJJx1YywFgpmRJm9
43bE+R3uXhpYxSy5zf0s8T1VbNalWWVZKjfrrXjJic+H37y0E/lZcUtq8fSPnNu9
xNXLZ2/dkmWbAw+zu2Zszao3zPeYtP3bqhYa6HFZYDKxFEl4IPg9uKnQ9rAq7D/Y
/WtqOlckSqWdPSLKbQh3nbEd9dvdIqEx2wuqK8jthoHR0+HFoAGRqRHY6PKLKal5
bnxl7T8Wr6dRlb13vZZy6TwHU6HRxK6w9vCmRhSg04hHvtA8q2DmDM5Go+4PZEg=
=w2m9
-----END PGP SIGNATURE-----
