From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Thu, 15 Nov 2018 16:37:34 -0800
Message-ID: <1542328654.100259.18.camel@acm.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
         <20181110190521.GA2627@thunk.org>
         <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
         <20181111141426.GA7377@thunk.org>
         <98fe5cf7-722a-37d6-156d-842e8812e430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <98fe5cf7-722a-37d6-156d-842e8812e430@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-11-16 at 01:26 +-0100, Paolo Bonzini wrote:
+AD4 Yeah, and there are even already helpers such as
+AD4 bpf+AF8-get+AF8-current+AF8-uid+AF8-gid.  So that part can be done in a sort-of generic way.
+AD4 
+AD4 I can try and do the work, but I'd like some agreement on the design
+AD4 first...  For example a more important question is how would the BPF
+AD4 filter be attached?  Two possibilities that come to mind are:
+AD4 
+AD4 - add it to the /dev/sg+ACo or /dev/sd+ACo struct file(+ACo) via a ioctl, and use
+AD4 pass the file descriptor to the unprivileged QEMU after setting up the
+AD4 BPF filter, via either fork() or SCM+AF8-RIGHTS.  This would be a very nice
+AD4 model for privilege separation, but I'm afraid it would not work for
+AD4 your use case
+AD4 
+AD4 - add BPF programs to cgroups, in the form of a new
+AD4 BPF+AF8-PROG+AF8-TYPE+AF8-CGROUP+AF8-CDB+AF8-FILTER or something like that.  That would also
+AD4 work for my usecase, and it seems to be in line with how the network
+AD4 guys are doing things.  So it would seem like the way to go.
+AD4 
+AD4 Some other details...  Registering the first cgroup-based filter would
+AD4 disable the default filter+ADs if multiple filters are attached, the
+AD4 outcomes of all filters would be AND-ed, also similarly to how socket
+AD4 and sockaddr cgroup BPF works.  Finally, filters would be applied also
+AD4 to processes with CAP+AF8-SYS+AF8-RAWIO, unlike the current filter.
+AD4 
+AD4 Needless to say, this would not add special case code, but it would
+AD4 still add a substantial amount of code, probably comparable to this series.

All user space interfaces in the Linux kernel for storage that I'm familiar
with not only allow configuration of parameters but also make it easy to
query which parameters have been configured. The existing sysfs and configfs
interfaces demonstrate this. Using BPF to configure SG/IO access has a
significant disadvantage, namely that it is very hard to figure out what has
been configured. Figuring out what has been configured namely requires
disassembling BPF. I'm not sure anyone will be enthusiast about this.

Bart.
