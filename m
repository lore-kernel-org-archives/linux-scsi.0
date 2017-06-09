From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/15] qla2xxx: Add Target Multiqueue support
Date: Thu, 08 Jun 2017 23:34:50 -0700
Message-ID: <1496990090.28997.47.camel@haakon3.risingtidesystems.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu & Quinn,

On Wed, 2017-06-07 at 14:43 -0700, Himanshu Madhani wrote:
> Hi Nic,
> 
> This patch series adds support for multiqueue for qla2xxx target mode driver.
> 
> I've also added patch ("qla2xxx: Include Exchange offload/Extended Login
> into FW dump") which was dropped from earlier series for rework.
> 
> Please apply this series to target-pending for inclusion in 4.13 merge window.

Bart's comments in patch #1 are reasonable to consider, but IMHO not a
blocker to initial merge.

That said, as-is this series doesn't apply (see below) to
target-pending/for-next, presumably due to dependencies on what's in
MKP's tree.

So I'm happy to accept a version that does apply.  ;)

Checking patch drivers/scsi/qla2xxx/qla_def.h...
Hunk #1 succeeded at 435 (offset -2 lines).
Hunk #2 succeeded at 3296 (offset -2 lines).
Hunk #3 succeeded at 4260 (offset -6 lines).
Checking patch drivers/scsi/qla2xxx/qla_gbl.h...
Hunk #1 succeeded at 833 (offset -1 lines).
Checking patch drivers/scsi/qla2xxx/qla_inline.h...
Hunk #1 succeeded at 262 (offset 12 lines).
Checking patch drivers/scsi/qla2xxx/qla_isr.c...
Hunk #2 succeeded at 2263 (offset -17 lines).
Hunk #3 succeeded at 2627 (offset -13 lines).
Hunk #4 succeeded at 2650 (offset -13 lines).
Hunk #5 succeeded at 2759 (offset -13 lines).
Checking patch drivers/scsi/qla2xxx/qla_os.c...
Hunk #1 succeeded at 1637 (offset -12 lines).
error: while searching for:
		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
			sp = req->outstanding_cmds[cnt];
			if (sp) {
				/* Don't abort commands in adapter during EEH
				 * recovery as it's not accessible/responding.
				 */
				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy &&
				    (sp->type == SRB_SCSI_CMD)) {
					/* Get a reference to the sp and drop the lock.
					 * The reference ensures this sp->done() call
					 * - and not the call in qla2xxx_eh_abort() -
					 * ends the SCSI command (with result 'res').
					 */
					sp_get(sp);
					spin_unlock_irqrestore(&ha->hardware_lock, flags);
					status = qla2xxx_eh_abort(GET_CMD_SP(sp));
					spin_lock_irqsave(&ha->hardware_lock, flags);
					/* Get rid of extra reference if immediate exit
					 * from ql2xxx_eh_abort */
					if (status == FAILED && (qla2x00_isp_reg_stat(ha)))
						atomic_dec(&sp->ref_count);
				}
				req->outstanding_cmds[cnt] = NULL;
				sp->done(sp, res);
			}
		}
	}

error: patch failed: drivers/scsi/qla2xxx/qla_os.c:1662
error: drivers/scsi/qla2xxx/qla_os.c: patch does not apply
Checking patch drivers/scsi/qla2xxx/qla_target.c...
Hunk #2 succeeded at 2278 (offset -11 lines).
Hunk #3 succeeded at 2317 (offset -11 lines).
Hunk #4 succeeded at 2336 (offset -11 lines).
Hunk #5 succeeded at 2881 (offset -12 lines).
Hunk #6 succeeded at 2987 (offset -12 lines).
Hunk #7 succeeded at 3675 (offset -6 lines).
Hunk #8 succeeded at 3719 (offset -6 lines).
Hunk #9 succeeded at 3754 (offset -6 lines).
Hunk #10 succeeded at 4035 (offset -6 lines).
Hunk #11 succeeded at 6622 (offset 27 lines).
Checking patch drivers/scsi/qla2xxx/qla_target.h...
Hunk #4 succeeded at 865 (offset 1 line).
Hunk #5 succeeded at 1090 (offset 2 lines).
