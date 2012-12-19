From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Wed, 19 Dec 2012 13:04:08 +0100
Message-ID: <50D1AD38.7070606@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<20121219104722.GA5832@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20121219104722.GA5832@stefanha-thinkpad.redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 19/12/2012 11:47, Stefan Hajnoczi ha scritto:
> On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
>> +/**
>> + * virtqueue_start_buf - start building buffer for the other end
>> + * @vq: the struct virtqueue we're talking about.
>> + * @buf: a struct keeping the state of the buffer
>> + * @data: the token identifying the buffer.
>> + * @count: the number of buffers that will be added
> 
> Perhaps count should be named count_bufs or num_bufs.

Ok.

>> + * @count_sg: the number of sg lists that will be added
> 
> What is the purpose of count_sg?

It is needed to decide whether to use an indirect or a direct buffer.
The idea is to avoid a memory allocation if the driver is providing us
with separate sg elements (under the assumption that they will be few).

Originally I wanted to use a mix of direct and indirect buffer (direct
if add_buf received a one-element scatterlist, otherwise indirect).  It
would have had the same effect, without having to specify count_sg in
advance.  The spec is not clear if that is allowed or not, but in the
end they do not work with either QEMU or vhost, so I chose this
alternative instead.

Paolo


> Stefan
> 
