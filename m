From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Sat, 10 Nov 2018 14:05:21 -0500
Message-ID: <20181110190521.GA2627@thunk.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

I wonder if a better way of adding SG_IO command filtering is via
eBPF?  We are currently carrying a inside Google a patch which allows
a specific of SCSI commands to non-root processes --- if the process
belonged to a particular Unix group id.

It's pretty specific to our use case, in terms of the specific SCSI
commands we want to allow through.  I can imagine people wanting
different filters based on the type of the SCSI device, or a HDD's
WWID, not just a group id.  For example, this might be useful for
people wanting to do crazy things with containers --- maybe you'd
want to allow container root to send a SANITIZE ERASE command to one
of its exclusively assigned disks, but not to other HDD's.

So having something that's more general than a flat file in sysfs
might be preferable to resurrecting an interface which we would then
after to support forever, even if we come up with a more general
interface.

					- Ted
