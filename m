From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/5] target: user: Fix sense data handling
Date: Thu, 06 Jul 2017 21:50:18 -0700
Message-ID: <1499403018.30628.27.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-5-damien.lemoal@wdc.com>
         <5eb219c5-c4a7-ea75-ff31-d732e10c72ae@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5eb219c5-c4a7-ea75-ff31-d732e10c72ae@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hey MNC & Co,

On Wed, 2017-06-28 at 12:44 -0500, Mike Christie wrote:
> On 06/28/2017 12:58 AM, Damien Le Moal wrote:
> > If the user request handler completed the request with a CHECK CONDITION
> > status, tcmu_handle_completion() copies the command entry sense data
> > into the session request structure sense data. However, the sense data
> > length indicated by the field scsi_sense_length is not set and equal to
> > 0, resulting in the copy being a no-op and failure to propagate the
> > sense data back to the initiator. To fix this, properly set the session
> > command sense data length and also set the session command
> > SCF_TRANSPORT_TASK_SENSE flag to indicate that the command has valid
> > sense data.
> > 
> > Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> > ---
> >  drivers/target/target_core_user.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> > index beb5f09..7426b4c 100644
> > --- a/drivers/target/target_core_user.c
> > +++ b/drivers/target/target_core_user.c
> > @@ -831,7 +831,9 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
> >  		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
> >  	} else if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
> >  		memcpy(se_cmd->sense_buffer, entry->rsp.sense_buffer,
> > -			       se_cmd->scsi_sense_length);
> > +		       TRANSPORT_SENSE_BUFFER);
> > +		se_cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
> > +		se_cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
> >  	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
> >  		/* Get Data-In buffer before clean up */
> >  		gather_data_area(udev, cmd, true);
> > 
> 
> I have a patch similar to this and 5/5 in my set:
> 
> https://www.spinics.net/lists/target-devel/msg15430.html
> 
> If yours gets merged first then I will build my set over them, so patch
> looks ok to me.
> 
> Reviewed-by: Mike Christie <mchristi@redhat.com>

The RFC patches above from May 31st weren't merged because I thought you
where going to send out a second series..

https://www.spinics.net/lists/target-devel/msg15505.html

Since that hasn't been the case, I'll go ahead and merge the bugfixes in
patches #1-6 for v4.13 now.  :)

Please resend patches #7-13 as post v4.13 items at your earliest
convenience.

Apologies for the confusion.
