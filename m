From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Wed, 19 Dec 2012 13:40:57 +0100
Message-ID: <CAJSP0QUNQHSak_jUWA0jfDuKgfVFsyJb0252OxWzQzUcj653bg@mail.gmail.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<20121219104722.GA5832@stefanha-thinkpad.redhat.com>
	<50D1AD38.7070606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <50D1AD38.7070606@redhat.com>
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
Cc: kvm <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, hutao@cn.fujitsu.com, linux-kernel <linux-kernel@vger.kernel.org>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 19, 2012 at 1:04 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 19/12/2012 11:47, Stefan Hajnoczi ha scritto:
>> On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
>> What is the purpose of count_sg?
>
> It is needed to decide whether to use an indirect or a direct buffer.
> The idea is to avoid a memory allocation if the driver is providing us
> with separate sg elements (under the assumption that they will be few).

Ah, this makes sense now.  I saw it affects the decision whether to go
indirect or not but it wasn't obvious why.

> Originally I wanted to use a mix of direct and indirect buffer (direct
> if add_buf received a one-element scatterlist, otherwise indirect).  It
> would have had the same effect, without having to specify count_sg in
> advance.  The spec is not clear if that is allowed or not, but in the
> end they do not work with either QEMU or vhost, so I chose this
> alternative instead.

Okay.

Stefan
