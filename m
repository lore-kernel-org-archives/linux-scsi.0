From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Revisiting task tags and Linux SCSI
Date: Wed, 8 May 2002 20:35:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0205082032350.763-100000@beppo>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C5E9D@mercury.infiniconsys.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <08628CA53C6CBA4ABAFB9E808A5214CB0C5E9D@mercury.infiniconsys.com>
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org


scsi_scan.c:

        /*
         * Set the tagged_queue flag for SCSI-II devices that purport to
support
         * tagged queuing in the INQUIRY data.
         */
        SDpnt->tagged_queue = 0;
        if ((SDpnt->scsi_level >= SCSI_2) &&
            (scsi_result[7] & 2) &&
            !(bflags & BLIST_NOTQ)) {
                SDpnt->tagged_supported = 1;
                SDpnt->current_tag = 0;
        }

This just generates the usage of multiple commands outstanding for this nexus.

I don't think you're looking very hard.

The actually tag generation and management is left up to each HBA driver.

On Wed, 8 May 2002, Heinz, Michael wrote:

> Okay guys,
> 
> Maybe I'm an idiot - but I cannot find *anywhere* in sd.c, sg.c, scsi.c
> or elsewhere that the scsi_cmnd.tag field is set to anything except
> zero, nor can I find anywhere in the high level SCSI drivers that the
> "scsi_device.tagged_*" fields are used. 
> 
> Am I wrong here? I can certainly generate task tags that are guaranteed
> to be unique (I already have to do that anyway), and I can certainly
> 'or' them with ORDERED_QUEUE_TAG but I'm not sure how that's going to
> impact the higher level SCSI drivers since they never pay attention to
> the values of any of the "tagged_*" fields anyway.....
> 
> --
> Michael Heinz
> Infinicon Systems, Inc.
> http://www.infiniconsys.com 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

