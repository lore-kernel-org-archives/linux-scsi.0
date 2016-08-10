From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for
 LBA48 devices
Date: Wed, 10 Aug 2016 00:10:42 -0400
Message-ID: <20160810041042.GH25053@mtj.duckdns.org>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Aug 09, 2016 at 10:45:47PM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Currently block layer limit max_hw_sectors is set to
> ATA_MAX_SECTORS_LBA48 (65535), for devices with LBA48 support.
> 
> However, block layer limit max_sectors (which is the effective
> one; also adjustable, upper-bounded by max_hw_sectors) is set to
> BLK_DEF_MAX_SECTORS (currently 2560) by the scsi disk driver,
> since libata's SATL does not report an Optimal Transfer Length.
> 
> This does not make much sense, especially when the current
> BLK_DEF_MAX_SECTORS appears to be unsafe for some ATA devices
> (see ATA_HORKAGE_MAX_SEC_1024). Truth is, the current value
> appears to be arbitrary anyway. See commit d2be537c3ba3
> ("block: bump BLK_DEF_MAX_SECTORS to 2560").
> 
> Therefore, avoid setting dev->max_sectors when it is strictly
> necessary. Leave it as 0 otherwise, so that both block layer
> limits will remain as SCSI_DEFAULT_MAX_SECTORS (currently 1024).

These changes feel rather gratuitous.  What's the upside here?

Thanks.

-- 
tejun
