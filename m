From: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 11:00:42 -0500
Message-ID: <5006DDAA.6080304@us.ibm.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org> <20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com> <1342561819.18004.470.camel@haakon2.linux-iscsi.org> <5006BD3D.7090104@us.ibm.com> <20120718155338.GA21817@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20120718155338.GA21817@infradead.org>
Sender: kvm-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/18/2012 10:53 AM, Christoph Hellwig wrote:
> On Wed, Jul 18, 2012 at 08:42:21AM -0500, Anthony Liguori wrote:
>>
>> If you add support for a new command, you need to provide userspace
>> a way to disable this command.  If you change what gets reported for
>> VPD, you need to provide userspace a way to make VPD look like what
>> it did in a previous version.
>>
>> Basically, you need to be able to make a TCM device behave 100% the
>> same as it did in an older version of the kernel.
>>
>> This is unique to virtualization due to live migration.  If you
>> migrate from a 3.6 kernel to a 3.8 kernel, you need to make sure
>> that the 3.8 kernel's TCM device behaves exactly like the 3.6 kernel
>> because the guest that is interacting with it does not realize that
>> live migration happened.
>
> I don't think these strict live migration rules apply to SCSI targets.
>
> Real life storage systems get new features and different behaviour with
> firmware upgrades all the time, and SCSI initiators deal with that just
> fine.  I don't see any reason to be more picky just because we're
> virtualized.

But would this happen while a system is running live?

I agree that in general, SCSI targets don't need this, but I'm pretty sure that 
if a guest probes for a command, you migrate to an old version, and that command 
is no longer there, badness will ensue.

It's different when you're talking about a reboot happening or a 
disconnect/reconnect due to firmware upgrade.  The OS would naturally be 
reprobing in this case.

Regards,

Anthony Liguori

>

