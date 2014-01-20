From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Mon, 20 Jan 2014 09:30:34 -0500
Message-ID: <52DD330A.4050509@ubuntu.com>
References: <20140116220409.GA1183@linux.intel.com>	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>	<CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>	<52D9976C.2010009@ubuntu.com>	<CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>	<52D9F27F.8060705@ubuntu.com> <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com> <52DD18B7.7030303@crashplan.pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49795 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaATOag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2014 09:30:36 -0500
In-Reply-To: <52DD18B7.7030303@crashplan.pro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: CrashPlan Pro <linux-scsi@crashplan.pro>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/20/2014 7:38 AM, CrashPlan Pro wrote:
> Dan Williams wrote at 18-01-14 05:09:
>> Larger systems are less likely to ever sleep.
> 
> I have to agree with this. There is almost no storage server that
> will be suspended to sleep.
> 
> Users of storage servers rather see an improvement at reboot time.
> 
> For example by not re-enumerating all 40 / 80 / 100 attached PuiS
> ATA drives or not spinning the drive while enumerating. Only the
> boot drive needs to be spin up. Currently the reboot proces does
> wake each drive that was previously spun down. At a rate of 1
> concurrent drive that takes approximately 6 seconds to spin up, the
> re-enumeration part takes around 8 minutes during reboot.

I wasn't thinking quite that big.  I'm thinking 3 or 4 drive home NAS
type systems, which people do like to make use of suspend on to save
power.

As for not spinning up drives during boot, the problem with that seems
to be that some drives ( possibly most? ) won't return correct
IDENTIFY information until they have been spun up.

For systems *that* large, I'd say what they could use is for the
enumeration to be somewhere in between one at a time, and all at once.
 The power supply on such a beast should be able to handle starting up
say, 4-8 drives at once, so that would cut down on the startup time
considerably.

On the other hand, as long as the drives holding the root filesystem
are the first to spin up, the system should boot up quickly while the
other drives come up in the background.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS3TMIAAoJEI5FoCIzSKrw5ScH/0nDSPvqrxK8r3mHwqRkLANn
5390lj8OTS7JKuR4GThOvggdBftJ+6KaPqOhZ4dw0fJSmuiB2QumO3fVGFvEpJY1
J5ZCpKhmpdxQbGQHDktjY0ImQ52elsjjGMIIj7elXhjP4UWTqcLLyozIvGVbfEUa
NT3ggKHZQ5ORl25IyiL/yObgezKK1fXcltvQZd2jp47OGQgByxjsH9NrQQiNlU2o
MMG8yDJA7lExuqMPm9z2OJJZuEgukPY6Y6Eg5u9rHriskvEIo/LOy+EGyAzq11tV
o9LyBShnAljhCzQ+dASsdKJYqQSY7Jy5kGAsOEvifS3MRtukddmzMkf6plzwe7M=
=4ab9
-----END PGP SIGNATURE-----
