From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 01:26:40 +0100
Message-ID: <98fe5cf7-722a-37d6-156d-842e8812e430@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181110190521.GA2627@thunk.org>
 <566bc821-f12a-f7c1-e7c7-99092807ee27@redhat.com>
 <20181111141426.GA7377@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111141426.GA7377@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 11/11/2018 15:14, Theodore Y. Ts'o wrote:
> On Sun, Nov 11, 2018 at 02:26:45PM +0100, Paolo Bonzini wrote:
>>
>> I'm not very eBPF savvy, the question I have is: what kind of
>> information about the running process is available in an eBPF program?
>> For example, even considering only the examples you make, would it be
>> able to access the CDB, the capabilities and uid/gid of the task, the
>> SCSI device type, the WWN?  Of course you also need the mode of the file
>> descriptor in order to allow SANITIZE ERASE if the disk is opened for write.
> 
> The basic uid/gid of the task is certainly available.  For storage
> stack specific things, it's a matter of what we make available to the
> eBPF function.  For example, there is an experimental netfilter
> replacement which uses eBPF; obviously that requires making the packet
> which is being inspecting so it can be given a thumbs up or thumbs
> down result.  That's going to require letting the eBPF function to
> have access to the network header, access to the connection tracking
> tables, etc.

Yeah, and there are even already helpers such as
bpf_get_current_uid_gid.  So that part can be done in a sort-of generic way.

I can try and do the work, but I'd like some agreement on the design
first...  For example a more important question is how would the BPF
filter be attached?  Two possibilities that come to mind are:

- add it to the /dev/sg* or /dev/sd* struct file(*) via a ioctl, and use
pass the file descriptor to the unprivileged QEMU after setting up the
BPF filter, via either fork() or SCM_RIGHTS.  This would be a very nice
model for privilege separation, but I'm afraid it would not work for
your use case

- add BPF programs to cgroups, in the form of a new
BPF_PROG_TYPE_CGROUP_CDB_FILTER or something like that.  That would also
work for my usecase, and it seems to be in line with how the network
guys are doing things.  So it would seem like the way to go.

Some other details...  Registering the first cgroup-based filter would
disable the default filter; if multiple filters are attached, the
outcomes of all filters would be AND-ed, also similarly to how socket
and sockaddr cgroup BPF works.  Finally, filters would be applied also
to processes with CAP_SYS_RAWIO, unlike the current filter.

Needless to say, this would not add special case code, but it would
still add a substantial amount of code, probably comparable to this series.

Christoph?

Paolo

(*) that's not immediate for /dev/sd*, because it would require using
the block device file's private_data; that's not possible yet via struct
block_device_operations, but as far as I can tell block devices
themselves do not need the private_data, so it is at least doable.
