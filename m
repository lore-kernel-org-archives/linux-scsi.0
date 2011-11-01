From: Tejun Heo <tj@kernel.org>
Subject: Re: Is there any elegant way to re-identify and re-configure xfer mode
Date: Tue, 1 Nov 2011 11:19:57 -0700
Message-ID: <CAOS58YPxZSdGWT+3Wgo7mvrL0xzJE-F7WGKC7LryVUFuUe9xSQ@mail.gmail.com>
References: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: JiSheng Zhang <jszhang3@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2011 at 11:27 PM, JiSheng Zhang <jszhang3@gmail.com> wrote:
> The problem is the model, vendor and xfer mode etc is changed also, I
> need to re-identify and re-configure it.
> I did these by manually call
> ata_scsi_find_dev()=>ata_dev_read_id()=>ata_dev_configure()=>ata_set_mode()

>From userland,

# echo - - - > /sys/class/scsi_host/hostX/rescan

>From kernel,

    spin_lock_irqsave(ap->lock, flags);
    dev->link.eh_info.dev_action[dev->devno] |= ATA_EH_REVALIDATE;
    ata_port_schedule_eh(ap);
    spin_unlock_irqrestore(ap->lock, flags);

-- 
tejun
