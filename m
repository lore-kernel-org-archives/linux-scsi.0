From: Tejun Heo <htejun@gmail.com>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
	fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 14:00:26 -0400
Message-ID: <20150917180026.GB15447@htj.duckdns.org>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	<1442449758-14594-2-git-send-email-s-anna@ti.com>
	<20150917082425-mutt-send-email-mst@redhat.com>
	<1442499344.4073.0.camel@HansenPartnership.com>
	<20150917190538-mutt-send-email-mst@redhat.com>
	<1442508517.4073.13.camel@HansenPartnership.com>
	<20150917171529.GA15447@htj.duckdns.org>
	<1442512709.4073.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1442512709.4073.24.camel@HansenPartnership.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Suman Anna <s-anna@ti.com>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On Thu, Sep 17, 2015 at 10:58:29AM -0700, James Bottomley wrote:
> The argument is that we shouldn't have to explicitly destroy a
> statically initialized object, so 
> 
> DEFINE_IDA(someida);
> 
> Should just work without having to explicitly do
> 
> ida_destory(someida);
> 
> somewhere in the exit code.  It's about usage patterns.  Michael's
> argument is that if we can't follow the no destructor pattern for
> DEFINE_IDA() then we shouldn't have it at all, because it's confusing
> kernel design patterns.  The pattern we would have would be
> 
> struct ida someida:
> 
> ida_init(&someida);
> 
> ...
> 
> ida_destroy(&someida);
> 
> so the object explicitly has a constructor matched to a destructor.

Yeah, I get that.  I'm just not convinced that this matters enough
especially if we can get debugobj/ksan/whatever trip on it.

Thanks.

-- 
tejun
