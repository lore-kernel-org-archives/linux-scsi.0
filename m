From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Tue, 30 Jan 2018 09:33:18 +0100
Message-ID: <1831727.Vh41F2Boqi@merkaba>
References: <20180129154455.GB17176@ming.t460p> <1517259390.3969.41.camel@HansenPartnership.com> <20180130012408.GD17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180130012408.GD17176@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, John Garry <john.garry@huawei.com>, lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Ming Lei - 30.01.18, 02:24:
> > > SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In
> > > V4.13-rc1, it is enabled at default, but later the patch is reverted
> > > in V4.13-rc7, and becomes disabled at default too.
> > > 
> > > Now both the original reported PM issue(actually SCSI quiesce) and
> > > the sequential IO performance issue have been addressed.
> > 
> > Is the blocker bug just not closed because no-one thought to do it:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=178381
> > 
> > (we have confirmed that this issue is now fixed with the original
> > reporter?)
> 
> From a developer view, this issue is fixed by the following commit:
> 3a0a52997(block, scsi: Make SCSI quiesce and resume work reliably),
> and it is verified by kernel list reporter.

I never seen any suspend / hibernate related issues with blk-mq + bfq since 
then. Using heavily utilized BTRFS dual SSD RAID 1.

% egrep "MQ|BFQ" /boot/config-4.15.0-tp520-btrfstrim+
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_MQ_IOSCHED_DEADLINE=m
CONFIG_MQ_IOSCHED_KYBER=m
CONFIG_IOSCHED_BFQ=m
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_SCSI_MQ_DEFAULT is not set
# CONFIG_DM_MQ_DEFAULT is not set
CONFIG_DM_CACHE_SMQ=m

% cat /proc/cmdline 
BOOT_IMAGE=/vmlinuz-4.15.0-tp520-btrfstrim+ root=UUID=[…] ro 
rootflags=subvol=debian resume=/dev/mapper/sata-swap init=/bin/systemd 
thinkpad_acpi.fan_control=1 systemd.restore_state=0 scsi_mod.use_blk_mq=1

% cat /sys/block/sda/queue/scheduler 
[bfq] none

Thanks,
-- 
Martin
