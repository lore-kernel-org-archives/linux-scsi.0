From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Date: Tue, 23 Sep 2014 17:11:44 -0500
Message-ID: <5421F020.1030309@canonical.com>
References: <20140923071154.GB3867@infradead.org> <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org
Cc: bruce.lucas@mongodb.com, adam.radford@avagotech.com, kashyap.desai@avagotech.com, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/23/2014 09:22 AM, Chris J Arges wrote:
> When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
> data can be improperly zeroed out using the mptfusion driver. This patch
> disables write_same for this driver and the vmware subsystem_vendor which
> ensures that manual zeroing out is used instead.
> 
> BugLink: http://bugs.launchpad.net/bugs/1371591
> Reported-by: Bruce Lucas <bruce.lucas@mongodb.com>
> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> ---
>  drivers/message/fusion/mptspi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 787933d..613231c 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -1419,6 +1419,11 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto out_mptspi_probe;
>          }
>  
> +	/* VMWare emulation doesn't properly implement WRITE_SAME
> +	 */
> +	if (pdev->subsystem_vendor == 0x15AD)
> +		sh->no_write_same = 1;
> +
>  	spin_lock_irqsave(&ioc->FreeQlock, flags);
>  
>  	/* Attach the SCSI Host to the IOC structure
> 

As a workaround one can do the following:

# Set the scsi disk max_write_same_blocks to 0 to disable write_same.
(Your paths may vary...)
echo 0 >
/sys/devices/pci0000:00/0000:00:10.0/host32/target32:0:0/32:0:0:0/scsi_disk/32:0:0:0/max_write_same_blocks

# Force the dm device to reload (thus calling dm_table_set_restrictions
and checking for the new max_write_same_blocks value)
dmsetup table /dev/dm-0 save
dmsetup suspend /dev/dm-0; dmsetup reload /dev/dm-0 save; dmsetup resume
/dev/dm-0

# Now the dm device shows write_same_max_bytes as 0
cat /sys/block/dm-0/queue/write_same_max_bytes

# Run the test case in the original bug, it now passes.

So a few questions:
1) Does this workaround make sense? Perhaps there is an easier way?
2) Do we expect changing max_write_same_blocks at the scsi_disk level to
propagate the right write_same flags to other layers such as dm?
3) In light of this workaround, does this patch still make sense? Would
there be a better layer to fix this?

Thanks,
--chris j arges
