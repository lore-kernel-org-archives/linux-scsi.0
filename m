From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Sun, 11 Nov 2018 14:26:45 +0100
Message-ID: <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181110190521.GA2627@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181110190521.GA2627@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 10/11/2018 20:05, Theodore Y. Ts'o wrote:
> I wonder if a better way of adding SG_IO command filtering is via
> eBPF?  We are currently carrying a inside Google a patch which allows
> a specific of SCSI commands to non-root processes --- if the process
> belonged to a particular Unix group id.
> 
> It's pretty specific to our use case, in terms of the specific SCSI
> commands we want to allow through.  I can imagine people wanting
> different filters based on the type of the SCSI device, or a HDD's
> WWID, not just a group id.  For example, this might be useful for
> people wanting to do crazy things with containers --- maybe you'd
> want to allow container root to send a SANITIZE ERASE command to one
> of its exclusively assigned disks, but not to other HDD's.
> 
> So having something that's more general than a flat file in sysfs
> might be preferable to resurrecting an interface which we would then
> after to support forever, even if we come up with a more general
> interface.

Heh, this was exactly the answer I dreaded, because I can't deny it
makes sense. :)

My main argument against it is that while superseding an interface and
still having to support it forever sucks, having a super-complex
interface is also bad (back in 2012 I wrote
https://lwn.net/Articles/501742/ which I'm not particularly enthusiastic
about).  In many cases a combination of MAC policies, ACLs, etc. can be
just as effective.

I'm not very eBPF savvy, the question I have is: what kind of
information about the running process is available in an eBPF program?
For example, even considering only the examples you make, would it be
able to access the CDB, the capabilities and uid/gid of the task, the
SCSI device type, the WWN?  Of course you also need the mode of the file
descriptor in order to allow SANITIZE ERASE if the disk is opened for write.

Paolo
