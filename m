From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Allow EA reservation holders to read from device.
Date: Wed, 07 Jan 2015 08:31:39 -0800
Message-ID: <1420648299.12144.13.camel@haakon3.risingtidesystems.com>
References: <54AADCC8.2010403@suse.com>
	 <1420579407.6927.20.camel@haakon3.risingtidesystems.com>
	 <54ACA313.9040209@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54ACA313.9040209@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-01-06 at 19:08 -0800, Lee Duncan wrote:
> On 01/06/2015 01:23 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2015-01-05 at 10:49 -0800, Lee Duncan wrote:
> >> From: Lee Duncan <lduncan@suse.com>
> >>
> >> For PGR reservation type Exclusive Access, allow all
> >> registrants to read from the device.
> >>
> >> Signed-off-by: Lee Duncan <lduncan@suse.com>
> >> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> >> ---
> >>  drivers/target/target_core_pr.c | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> >> index 85564998500a..cb762b174c08 100644
> >> --- a/drivers/target/target_core_pr.c
> >> +++ b/drivers/target/target_core_pr.c
> >> @@ -551,6 +551,18 @@ static int core_scsi3_pr_seq_non_holder(
> >>
> >>                         return 0;
> >>                 }
> >> +       } else if (we && registered_nexus) {
> >> +               /*
> >> +                * Reads are allowed for Write Exclusive locks
> >> +                * from all registrants.
> >> +                */
> >> +               if (cmd->data_direction == DMA_FROM_DEVICE) {
> >> +                       pr_debug("Allowing READ CDB: 0x%02x for %s"
> >> +                               " reservation\n", cdb[0],
> >> +                               core_scsi3_pr_dump_type(pr_reg_type));
> >> +
> >> +                       return 0;
> >> +               }
> >>         }
> >>         pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
> >>                 " for %s reservation\n", transport_dump_cmd_direction(cmd),
> > 
> > I'm confused as to why this is necessary..
> > 
> > Doesn't the conditional check directly above this one ensure that
> > all_reg=true && registered_nexus=true implicitly allow READ CDBs to be
> > processed..?
> 
> No, the section right above it handles "All Registrants" or "Registrants
> Only" reservations, but not "normal" reservations.
> 
> In other words, if using "sg_persist" to create the registration, the
> problem occurs for type 1, i.e. regular old "write exclusive".
> 
> And the section above it is allowing reads and writes, and we only want
> to allow READs for the non-reservation holders in this case.
> > 
> > How is this new check for PR_TYPE_WRITE_EXCLUSIVE_ALLREG reservation any
> > different..?
> 
> Er, I believe they are totally different. That patch was about allowing
> re-registration. This one is about allowing non-reservation-holding
> registrants to read from the device when the reservation is of type
> Write Exclusive. Can we agree that this should be allowed?
> 

Ah, I was getting confused by the 'all registrants' part of the commit
message.

Applying to target-pending/master now with a more explicit commit
message.

Thanks Lee!

--nab
