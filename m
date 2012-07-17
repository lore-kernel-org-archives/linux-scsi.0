From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Tue, 17 Jul 2012 14:50:19 -0700
Message-ID: <1342561819.18004.470.camel@haakon2.linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com>  <5005B52E.20509@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <5005B52E.20509@us.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-17 at 13:55 -0500, Anthony Liguori wrote:
> On 07/17/2012 10:05 AM, Michael S. Tsirkin wrote:
> > On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:

<SNIP>

> >
> > It still seems not 100% clear whether this driver will have major
> > userspace using it. And if not, it would be very hard to support a driver
> > when recent userspace does not use it in the end.
> 
> I don't think this is a good reason to exclude something from the kernel. 
> However, there are good reasons why this doesn't make sense for something like 
> QEMU--specifically because we have a large number of features in our block layer 
> that tcm_vhost would bypass.
> 

I can definitely appreciate your concern here as the QEMU maintainer.

> But perhaps it makes sense for something like native kvm tool.  And if it did go 
> into the kernel, we would certainly support it in QEMU.
> 

...

> But I do think the kernel should carefully consider whether it wants to support 
> an interface like this.  This an extremely complicated ABI with a lot of subtle 
> details around state and compatibility.
> 
> Are you absolutely confident that you can support a userspace application that 
> expects to get exactly the same response from all possible commands in 20 kernel 
> versions from now?  Virtualization requires absolutely precise compatibility in 
> terms of bugs and features.  This is probably not something the TCM stack has 
> had to consider yet.
> 

We most certainly have thought about long term userspace compatibility
with TCM.  Our userspace code (that's now available in all major
distros) is completely forward-compatible with new fabric modules such
as tcm_vhost.  No update required.

Also, by virtue of the fact that we are using configfs + rtslib (python
object library) on top, it's very easy to keep any type of compatibility
logic around in python code.  With rtslib, we are able to hide configfs
ABI changes from higher level apps.

So far we've had a track record of 100% userspace ABI compatibility in
mainline since .38, and I don't intend to merge a patch that breaks this
any time soon.  But if that ever happens, apps using rtslib are not
going to be effected.

> > I think a good idea for 3.6 would be to make it depend on CONFIG_STAGING.
> > Then we don't commit to an ABI.
> 
> I think this is a good idea.  Even if it goes in, a really clear policy would be 
> needed wrt the userspace ABI.
> 
> While tcm_vhost is probably more useful than vhost_blk, it's a much more complex 
> ABI to maintain.
> 

As far as I am concerned, the kernel API (eg: configfs directory layout)
as it is now in sys/kernel/config/target/vhost/ is not going to change.
It's based on the same drivers/target/target_core_fabric_configfs.c
generic layout that we've had since .38.

The basic functional fabric layout in configfs is identical (with fabric
dependent WWPN naming of course) regardless of fabric driver, and by
virtue of being generic it means we can add things like fabric dependent
attributes + parameters in the future for existing fabrics without
breaking userspace.

So while I agree the ABI is more complex than vhost-blk, the logic in
target_core_fabric_configfs.c is a basic ABI fabric definition that we
are enforcing across all fabric modules in mainline for long term
compatibility.

--nab
