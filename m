From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Tue, 18 Dec 2012 15:32:15 +0100
Message-ID: <50D07E6F.6040701@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<20121218133606.GC26110@redhat.com> <50D07317.8050902@redhat.com>
	<20121218135938.GG26110@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20121218135938.GG26110@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

Il 18/12/2012 14:59, Michael S. Tsirkin ha scritto:
>>> Can't we track state internally to the virtqueue? Exposing it
>>> seems to buy us nothing since you can't call add_buf between
>>> start and end anyway.
>> 
>> I wanted to keep the state for these functions separate from the
>> rest. I don't think it makes much sense to move it to struct
>> virtqueue unless virtqueue_add_buf is converted to use the new API
>> (doesn't make much sense, could even be a tad slower).
> 
> Why would it be slower?

virtqueue_add_buf could be slower if it used the new API.  That's
because of the overhead of writing and reading from struct
virtqueue_buf, instead of using variables in registers.

>> On the other hand moving it there would eliminate the dependency
>> on virtio_ring.h.  Rusty, what do you think?
>> 
>>> And idea: in practice virtio scsi seems to always call
>>> sg_init_one, no? So how about we pass in void* or something and
>>> avoid using sg and count? This would make it useful for -net
>>> BTW.
>> 
>> It also passes the scatterlist from the LLD.  It calls sg_init_one
>> for the request/response headers.
> 
> Try adding a _single variant. You might see unrolling a loop gives
> more of a benefit than this whole optimization.

Makes sense, I'll try.  However, note that I *do* need the
infrastructure in this patch because virtio-scsi could never use a
hypothetical virtqueue_add_buf_single; requests always have at least 2
buffers for the headers.

However I could add virtqueue_add_sg_single and use it for those
headers.  The I/O buffer can keep using virtqueue_add_sg.

Paolo
