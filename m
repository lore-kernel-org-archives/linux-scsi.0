From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Wed, 19 Dec 2012 18:52:51 +0200
Message-ID: <20121219165251.GA13705@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<20121219104722.GA5832@stefanha-thinkpad.redhat.com>
	<50D1AD38.7070606@redhat.com> <20121219165130.GA13684@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20121219165130.GA13684@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 19, 2012 at 06:51:30PM +0200, Michael S. Tsirkin wrote:
> On Wed, Dec 19, 2012 at 01:04:08PM +0100, Paolo Bonzini wrote:
> > Il 19/12/2012 11:47, Stefan Hajnoczi ha scritto:
> > > On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
> > >> +/**
> > >> + * virtqueue_start_buf - start building buffer for the other end
> > >> + * @vq: the struct virtqueue we're talking about.
> > >> + * @buf: a struct keeping the state of the buffer
> > >> + * @data: the token identifying the buffer.
> > >> + * @count: the number of buffers that will be added
> > > 
> > > Perhaps count should be named count_bufs or num_bufs.
> > 
> > Ok.
> > 
> > >> + * @count_sg: the number of sg lists that will be added
> > > 
> > > What is the purpose of count_sg?
> > 
> > It is needed to decide whether to use an indirect or a direct buffer.
> > The idea is to avoid a memory allocation if the driver is providing us
> > with separate sg elements (under the assumption that they will be few).
> > 
> > Originally I wanted to use a mix of direct and indirect buffer (direct
> > if add_buf received a one-element scatterlist, otherwise indirect).  It
> > would have had the same effect, without having to specify count_sg in
> > advance.  The spec is not clear if that is allowed or not, but in the
> > end they do not work with either QEMU or vhost, so I chose this
> > alternative instead.
> > 
> > Paolo
> 
> Hmm it should work with vhost.

BTW passing in num_in + num_out would be nicer than explicit direction:
closer to the current add_buf.

> > 
> > > Stefan
> > > 
