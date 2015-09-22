From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] storvsc: get rid of homegrown
 copy_{to,from}_bounce_buffer()
Date: Tue, 22 Sep 2015 14:53:10 -0700
Message-ID: <20150922215310.GA29802@infradead.org>
References: <1442939270-9651-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442939270-9651-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Radim Kr??m???? <rkrcmar@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 22, 2015 at 06:27:50PM +0200, Vitaly Kuznetsov wrote:
> Storvsc driver needs to ensure there are no 'holes' in the presented
> sg list (all segments in the middle of the list need to be of PAGE_SIZE).

I think it should instead set a virt_boundary.  That's what we added for
the NVMe driver which has the same requirements, and Sagi recently also
switched iSER to it after we ensured that flag is handled correctly by
the SG_IO ioctl.
