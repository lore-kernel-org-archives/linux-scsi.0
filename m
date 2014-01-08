From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 10:36:10 +0800
Message-ID: <52CCB99A.4090201@intel.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com> <52CCAF8C.7040407@ubuntu.com> <52CCB3E8.5010101@intel.com> <52CCB5C4.7020206@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CCB5C4.7020206@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On 01/08/2014 10:19 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 01/07/2014 09:11 PM, Aaron Lu wrote:
>> I thought that feature is used to control if a disk should be spun
>> up once powered from the host side.
> 
> That *is* what it sounds like, only ATA disks either spin up as soon
> as power is applied, or wait for an actual command issued by higher
> layers.  There doesn't seem to be any low level SATA mechanism to spin
> the drive up that the SSS feature could toggle, so it seems to simply
> be a hint to libata, and possibly the bios.

I think the host controller can decide not to power all its ports, only
when a specific reg in the port's memory range is set, it will give
power to that port and thus spin up the drive. Makes sense?

> 
>> Too bad for a jumper, that's beyond our control. And about the
>> hdparm, does the setting survive a power cycle?
> 
> Yes, otherwise there wouldn't be much point to a setting that only
> matters at power on ;)

Oh, of course, my stupid :-)
Then I suddenly think my patches can kind of work - let's say we have
done the hdparm setting thing before suspend and the disk will be spun
up in standby mode next time it is powered. Then during system resume
phase, remove the pm_request_resume call in both SCSI and ATA's system
resume callback,
  - if the disk is powered, it will be in standby mode and its runtime
    status is RPM_SUSPENDED, match its real status(sort of);
  - if the disk is not powered due to some host feature or whatever, it
    will be in unpowered mode and its runtime status is RPM_SUSPENDED,
    still match its real status.

