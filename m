From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Sun, 11 Nov 2018 09:14:26 -0500
Message-ID: <20181111141426.GA7377@thunk.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181110190521.GA2627@thunk.org>
 <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 11, 2018 at 02:26:45PM +0100, Paolo Bonzini wrote:
> 
> I'm not very eBPF savvy, the question I have is: what kind of
> information about the running process is available in an eBPF program?
> For example, even considering only the examples you make, would it be
> able to access the CDB, the capabilities and uid/gid of the task, the
> SCSI device type, the WWN?  Of course you also need the mode of the file
> descriptor in order to allow SANITIZE ERASE if the disk is opened for write.

The basic uid/gid of the task is certainly available.  For storage
stack specific things, it's a matter of what we make available to the
eBPF function.  For example, there is an experimental netfilter
replacement which uses eBPF; obviously that requires making the packet
which is being inspecting so it can be given a thumbs up or thumbs
down result.  That's going to require letting the eBPF function to
have access to the network header, access to the connection tracking
tables, etc.

You can basically think of it as passing arguments to a function
except it's it's written in eBPF instead of C.  You can also define
eBPF functions implemented in C which can be called from eBPF code.

						- Ted
