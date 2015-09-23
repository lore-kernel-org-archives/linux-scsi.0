From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] storvsc: get rid of homegrown copy_{to,
 from}_bounce_buffer()
Date: Wed, 23 Sep 2015 13:32:58 +0200
Message-ID: <87pp19gyl1.fsf@vitty.brq.redhat.com>
References: <1442939270-9651-1-git-send-email-vkuznets@redhat.com>
 <20150922215310.GA29802@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150922215310.GA29802@infradead.org> (Christoph Hellwig's
 message of "Tue, 22 Sep 2015 14:53:10 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Radim Kr??m???? <rkrcmar@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, Sep 22, 2015 at 06:27:50PM +0200, Vitaly Kuznetsov wrote:
>> Storvsc driver needs to ensure there are no 'holes' in the presented
>> sg list (all segments in the middle of the list need to be of PAGE_SIZE).
>
> I think it should instead set a virt_boundary.  That's what we added for
> the NVMe driver which has the same requirements, and Sagi recently also
> switched iSER to it after we ensured that flag is handled correctly by
> the SG_IO ioctl.

Wow,

I checked and blk_queue_virt_boundary(sdevice->request_queue, PAGE_SIZE
- 1) seems to be solving the issue completely, no bounce buffer
required. I'll test more and send v2 with removing the rest.

-- 
  Vitaly
