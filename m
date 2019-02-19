From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] scsi: sd: block: Fix regressions in read-only block
 device handling
Date: Tue, 19 Feb 2019 09:36:54 +0800
Message-ID: <CACVXFVN9LXodRP8+T_Vd8+5g9K=+hke7ik7N21=heb3csFhh=w@mail.gmail.com>
References: <yq1d0nxuf73.fsf@oracle.com> <20190213025717.20057-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190213025717.20057-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Jeremy Cline <jeremy@jcline.org>, Oleksii Kurochko <olkuroch@cisco.com>, stable <stable@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 13, 2019 at 5:01 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Some devices come online in write protected state and switch to
> read-write once they are ready to process I/O requests. These devices
> broke with commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
> re-reading partition") because we had no way to distinguish between a
> user decision to set a block_device read-only and the actual hardware
> device being write-protected.
>
> Because partitions are dropped and recreated on revalidate we are
> unable to persist any user-provided policy in hd_struct. Introduce a
> bitmap in struct gendisk to track the user configuration. This bitmap
> is updated when BLKROSET is called on a given disk or partition.
>
> A helper function, get_user_ro(), is provided to determine whether the
> ioctl has forced read-only state for a given block device. This helper
> is used by set_disk_ro() and add_partition() to ensure that both
> existing and newly created partitions will get the correct state.

Hi Martin & Oleksii,

>From the Bugzilla, looks it is only reported on the "Kingston DT Ultimate G3"
USB flash drive.

If it is true, this particular issue might be addressed simply by applying one
quirk on this drive, such as, by adding one delay before calling
sd_spinup_disk()
in the 1st sd_revalidate_disk() to wait until it is ready to process
I/O requests.

Otherwise if there are many such devices, I think your approach is good.

Thanks,
Ming Lei
