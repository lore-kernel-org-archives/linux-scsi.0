From: Kaushik Datta <kdatta@npd.hcltech.com>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 17:11:50 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE8E0FE.EF3FA868@npd.hcltech.com>
References: <E179lnL-0005Re-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: rabeeh@galileo.co.il
Cc: linux-scsi@vger.kernel.org, kdatta@npd.hcltech.com

A small cut'n paste from man proc !


          scsi   This is a listing of all SCSI devices known to the kernel. The
                     listing is similar to the one seen during bootup.  scsi currently
                     supports only the add-single-device command which allows root to
                     add a hotplugged device to the list of known devices.

                     An echo 'scsi add-single-device 1 0 5 0' > /proc/scsi/scsi will
                     cause host scsi1 to scan on SCSI channel 0 for a device on ID 5 LUN
                     0. If there is already a device known on this address or the
                     address is invalid an error will be returned.

Alan Cox wrote:

> > 1.. How is it possible to signal SCSI mid-layer (or other layers) of a
> > presence of a newly hot-plugged disk ?
>
> aacraid is one example that does this, but via its config tools.
>
> > 2.. Can an adapter's device driver trigger SCSI subsystem to scan
> > channels for new LUNs / Targets ?
>
> It is designed so user space can do so - so yes
>
> > 3.. Is this can be handled in a kernel level ? is there a user space
> > application that can be triggered to start scanning adapters (obviously
> > through SCSI subsystem) and registering new LUNs / Targets etc... ?
>
> echo "scsi-add-single-device a b c d" /proc/scsi/scsi
>

To be precise  :

  echo 'scsi  add-single-device a b c d ' > /proc/scsi/scsi

Thanks,
Kaushik

>
> if I remember it right
>
> Alan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

