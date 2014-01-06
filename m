From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Mon, 06 Jan 2014 09:40:39 -0500
Message-ID: <52CAC067.20601@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CA744F.2080609@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/6/2014 4:15 AM, Aaron Lu wrote:
> My guess why it doesn't work for you is that, when you call 
> blk_pre_runtime_suspend in sd_resume_work, there are requests left
> in the queue so that call will simply fail, it's not meant to be
> used that way.

There should be no other requests during the system resume callback.

> It seems you are making use of runtime PM to speed up disk resume,
> if that is the case, I think we can simply make sure the disk's
> block queue is put into the same state as runtime suspended and
> then mark it as runtime suspended during system suspend phase; on
> system resume, call

I think I tried that and it didn't work; when it is runtime suspended
when the system suspends, it's no longer runtime suspended when the
system resume function was called.  Hence why I'm using the
blk_pre_runtime_suspend to force it into RPM_SUSPENDING so as to make
sure that after the system resume function returns, user space IO will
be blocked until we can verify whether the disk has spun up on its own
or not.

> pm_request_resume for the device in its system resume callback
> should be enough, or if you want to further delay it, just leave it
> as it is. Once there is a new request comes in, it will be
> automatically runtime resumed(actually, there are some user space
> tools accessing it during system resume, so it will be resumed
> pretty soon after kernel thaw user space process, unless you have
> made those app gone). It's simple and clean. The only problem is,
> it depends on RUNTIME_PM, while Todd's implementation doesn't.

Yes, that's the idea; leave it runtime suspended until someone
actually tries to access it.  Unless the drive spins up on its own (
as ATA disks without PuiS enabled do ).

>>> that this is not the case, and only requests with the type set
>>> to REQ_TYPE_PM_RESUME are dispatched during suspend/resume.
>>> The following patch fixes the hang, but I'm not sure why it is
>>> needed or if it is generally appropriate:
>>> 
>> 
>> Adding Aaron Lu, author of block layer runtime PM. I have seen
>> similar issue and fixed it by relaxing the rpm_status check to
>> allow processing of requests while suspended -
> 
> I'm not sure what exactly the issue you have is, care to explain?

The issue is that the REQ_PM flagged REQUEST SENSE command issued
during the system_resume is never dispatched.  I patched scsi_execute
to make the request type REQ_TYPE_PM_RESUME and that got the request
dispatched.

Looking at the code a bit more today, it looks like REQ_PM has
blk_peek_request return the request to scsi_request_fn, but it refuses
to dispatch it unless it is of type REQ_TYPE_PM_RESUME apparently
because the queue is stopped.  I suppose now the question is why is it
stopped?

> The queue is not supposed to get a REQ_PM request while it is in 
> RPM_SUSPENDED state, at least, this is the case when we first made
> this function.

Right... that's why I forced it into RPM_SUSPENDING; so I can issue
the REQUEST SENSE, but other IO is blocked.  Then either complete the
transition to RPM_SUSPENDED, or abort and go back to RPM_ACTIVE.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSysBnAAoJEI5FoCIzSKrwM5MH/R+Pvk2hdzk1adSrxuvi28RV
bGxHSRc2RCqU0CyIwpZtNnZlUiqk34xuM1hzcqsPMdRStmOCpQciGuBhxynoODDW
Lm2XLtCfaNihsfuOHrc/nVmBZGPtzXP+OdOWEi9JfkUEcsS8ePFRh9YNXJOl1g26
pU41dmTwWrPYSnN7SRO+xArb1TWh7jcCSGqyxY2BVJL1aSpSicIlbnJDzijFSQ2h
+Rs7fZwnnzRLbQFmNcpems++vIVIYLRbuOJNFjeMLKt1KEX+Eiq4q/p5bJmt1H9n
zre1zoz7P5kU2zW90W+seFfAW2ka8stq4BAQGvz4KwEiV+altbEpYHLbtanXXEo=
=ZDJw
-----END PGP SIGNATURE-----
