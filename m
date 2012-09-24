From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH] libata: scsi: flush cache on scsi stop command
Date: Mon, 24 Sep 2012 17:14:31 +0800
Message-ID: <20120924091430.GA2038@mint-spring.sh.intel.com>
References: <1348045019-21532-1-git-send-email-aaron.lu@intel.com>
 <CAMHSBOWwGjsov2WMUn1SRH-MkASTCbNVFABPVFPmXwtZ_Gh2oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMHSBOWwGjsov2WMUn1SRH-MkASTCbNVFABPVFPmXwtZ_Gh2oA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 21, 2012 at 12:05:33PM -0700, Gwendal Grignou wrote:
> On Wed, Sep 19, 2012 at 1:56 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> > scsi stop command is used to put a device into stopped power
> > condition, and scsi devices will take care of its internal cache
> > before entering this power condition. For ata devices, this command
> > should be translated to flush cache + standby immediate, currently,
> > we are translating it to only standby.
> >
> > This patch handle this by sending flush cache command when standby is
> > to be sent, and in its qc complete function, send the actual standby.
> >
> > This patch will be used to support poweroff hard disk either when
> > runtime or when system is going to S3/S4/S5. The sd_suspend will be
> > modified to only send a stop command to the device if device manages
> > start_stop, the current implementation will send a sync cache command,
> > which is not necessary per the scsi spec.
> >
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > ---
> >  drivers/ata/libata-scsi.c | 32 ++++++++++++++++++++++++++++++--
> >  1 file changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index 8ec81ca..de6e734 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -1759,6 +1759,27 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
> >         ata_qc_free(qc);
> >  }
> >
> > +static void ata_flush_qc_complete(struct ata_queued_cmd *qc)
> > +{
> > +       if (qc->err_mask) {
> > +               ata_gen_ata_sense(qc);
> > +               qc->scsidone(qc->scsicmd);
> > +               ata_qc_free(qc);
> > +       } else {
> > +               qc->complete_fn = ata_scsi_qc_complete;
> > +               qc->tf.command = ATA_CMD_STANDBYNOW1;
> > +               ata_qc_issue(qc);
> > +       }
> > +}
> > +
> > +static void ata_qc_issue_flush(struct ata_queued_cmd *qc)
> > +{
> > +       qc->complete_fn = ata_flush_qc_complete;
> > +       qc->tf.command = qc->dev->flags & ATA_DFLAG_FLUSH_EXT ?
> > +                               ATA_CMD_FLUSH_EXT : ATA_CMD_FLUSH;
> > +       ata_qc_issue(qc);
> > +}
> > +
> >  /**
> >   *     ata_scsi_translate - Translate then issue SCSI command to ATA device
> >   *     @dev: ATA device to which the command is addressed
> > @@ -1821,8 +1842,15 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
> >                         goto defer;
> >         }
> >
> > -       /* select device, send command to hardware */
> > -       ata_qc_issue(qc);
> > +       /*
> > +        * If we received scsi stop command,
> > +        * we will need to flush cache first
> > +        */
> > +       if (qc->tf.command == ATA_CMD_STANDBYNOW1 && ata_try_flush_cache(dev))
> You are adding tests on the data path.
> What about changing the xlat function ata_scsi_start_stop_xlat to -
> when stop is requested:
> - if try_flush_cache is true,
>  change qc->complete_fn to ata_flush_qc_complete
>  build a flush command
> - else
>  do as usual.
> 
> ata_flush_qc_complete remains the same.
> 

Thanks for the advice :-)
Will send v2 in the v3 "support runtime power off of HDD" patch set.

-Aaron

> > +               ata_qc_issue_flush(qc);
> > +       else
> > +               /* select device, send command to hardware */
> > +               ata_qc_issue(qc);
> >
> >         VPRINTK("EXIT\n");
> >         return 0;
> > --
> > 1.7.12.21.g871e293
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
