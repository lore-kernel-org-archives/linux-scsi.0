From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] ata: ahci_platform: fix owner module reference
 mismatch for scsi host
Date: Tue, 27 Jan 2015 11:21:31 -0500
Message-ID: <20150127162131.GC12314@htj.dyndns.org>
References: <1422315299-4614-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422315299-4614-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Jan 27, 2015 at 08:34:58AM +0900, Akinobu Mita wrote:
> The owner module reference of the ahci platform's scsi_host is
> initialized to libahci_platform's one, because these drivers use a
> scsi_host_template defined in libahci_platform.  So these drivers can
> be unloaded even if the scsi device is being accessed.
> 
> This fixes it by pushing the scsi_host_template from libahci_platform
> to all leaf drivers.  The scsi_host_template is passed through a new
> argument of ahci_platform_init_host().

Two things.

* It proly would be a better idea to use the specific platform driver
  name for each sht.

* Can you please add comments on top of the SHT macros that these must
  be instantiated by the edge drivers and explain why?

Thanks.

-- 
tejun
