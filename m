From: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 14:12:13 -0500
Message-ID: <50070A8D.7020203@us.ibm.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org> <20120717150548.GA11587@redhat.com> <5005B52E.20509@us.ibm.com> <1342561819.18004.470.camel@haakon2.linux-iscsi.org> <5006BD3D.7090104@us.ibm.com> <20120718155338.GA21817@infradead.org> <5006DDAA.6080304@us.ibm.com> <1342630038.3022.111.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342630038.3022.111.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/18/2012 11:47 AM, James Bottomley wrote:
> On Wed, 2012-07-18 at 11:00 -0500, Anthony Liguori wrote:
>
> Of course: Think about the consequences: you want to upgrade one array
> on your SAN.  You definitely don't want to shut down your entire data
> centre to achieve it.  In place upgrades on running SANs have been
> common in enterprise environments for a while.

Would firmware upgrades ever result in major OS visible changes though?

Maybe OSes are more robust with SCSI than with other types of buses, but I don't 
think it's safe to completely ignore the problem.

>> I agree that in general, SCSI targets don't need this, but I'm pretty sure that
>> if a guest probes for a command, you migrate to an old version, and that command
>> is no longer there, badness will ensue.
>
> What command are we talking about?  Operation of initiators is usually
> just READ and WRITE.  So perhaps we might have inline UNMAP ... but the
> world wouldn't come to an end even if the latter stopped working.

Is that true for all OSes?  Linux may handle things gracefully if UNMAP starts 
throwing errors but that doesn't mean that Windows will.

There are other cases where this creates problems.  Windows (and some other 
OSes) fingerprint the hardware profile in order to do license enforcement.  If 
the hardware changes beyond a certain amount, then they refuse to boot.

Windows does this with a points system and I do believe that INQUIRY responses 
from any local disks are included in this tally.

> Most of the complex SCSI stuff is done at start of day; it's actually
> only then we'd notice things like changes in INQUIRY strings or mode
> pages.
>
> Failover, which is what you're talking about, requires reinstatement of
> all the operating parameters of the source/target system, but that's not
> wholly the responsibility of the storage system ...

It's the responsibility of the hypervisor when dealing with live migration.

Regards,

Anthony Liguori

>
> James
>
>> It's different when you're talking about a reboot happening or a
>> disconnect/reconnect due to firmware upgrade.  The OS would naturally be
>> reprobing in this case.
>
>
>
