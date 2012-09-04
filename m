From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 04 Sep 2012 16:30:35 +0200
Message-ID: <5046108B.8030609@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
	<1346154857-12487-6-git-send-email-pbonzini@redhat.com>
	<20120904124800.GE9805@redhat.com> <504606F6.4080603@redhat.com>
	<20120904142154.GL9805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120904142154.GL9805@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 04/09/2012 16:21, Michael S. Tsirkin ha scritto:
> > One reason is that, even though in practice I expect roughly the same
> > number of targets and VCPUs, hotplug means the number of targets is
> > difficult to predict and is usually fixed to 256.
> > 
> > The other reason is that per-target vq didn't give any performance
> > advantage.  The bonus comes from cache locality and less process
> > migrations, more than from the independent virtqueues.
> 
> Okay, and why is per-target worse for cache locality?

Because per-target doesn't have IRQ affinity for a particular CPU.

Assuming that the thread that is sending requests to the device is
I/O-bound, it is likely to be sleeping at the time the ISR is executed,
and thus executing the ISR on the same processor that sent the requests
is cheap.

But if you have many such I/O-bound processes, the kernel will execute
the ISR on a random processor, rather than the one that is sending
requests to the device.

Paolo
