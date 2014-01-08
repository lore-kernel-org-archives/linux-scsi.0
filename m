From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 09:32:23 +0800
Message-ID: <52CCAAA7.4070104@intel.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CCA6E3.2090400@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On 01/08/2014 09:16 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 01/07/2014 08:03 PM, Aaron Lu wrote:
>> You mean you want to leave the disk runtime suspended after a
>> system resume and in the meantime make sure the disk is indeed not
>> spun up?
> 
> Yep.  If it is spun up, then the runtime status should be updated to
> reflect that, otherwise it tricks user space programs into avoiding
> doing IO to the disk for fear of waking it, and prevents the runtime
> autosuspend timer from kicking in.

The ATA and SCSI devices are all resumed in my patches, notice there is
a single pm_request_resume call in both ATA and SCSI's system resume
callback, so the runtime status and the disk's state is synced.
The pm_request_resume call is asynchronous to the system resume, so it
doesn't block system resume.

But I see your point, my patch will not achieve that, it can only speed
up S3 for a typical PC with a traditional disk. I can omit the
pm_request_resume call in the system resume callback, but then if the
disk is spun up by itself, then the runtime status indeed doesn't
reflect the actual state. I suppose for SATA controllers that support
Staggered Spin-up wouldn't do this?
