From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/9] target: Skip ->queue_data_in() callbacks for
 COMPARE_AND_WRITE
Date: Wed, 21 Aug 2013 00:20:45 -0700
Message-ID: <1377069645.32763.16.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-6-git-send-email-nab@daterainc.com>
	 <20130821063223.GG25506@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130821063223.GG25506@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-08-20 at 23:32 -0700, Christoph Hellwig wrote:
> > @@ -1832,7 +1832,8 @@ static void transport_complete_qf(struct se_cmd *cmd)
> >  		ret = cmd->se_tfo->queue_data_in(cmd);
> >  		break;
> >  	case DMA_TO_DEVICE:
> > -		if (cmd->t_bidi_data_sg) {
> > +		if (cmd->t_bidi_data_sg &&
> > +		    cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {
> 
> This is not the place to hardcode specific cdb opcodes.  Should be
> a flag with a defined meaning on the command.
> 

Since this code path is only ever reached after a successful comparison
+ submission of the subsequent write payload, this is fine to change to
use SCF_COMPARE_AND_WRITE_POST flag..

Folding in the following patch.

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60d1336..70a6adb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1833,7 +1833,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
                break;
        case DMA_TO_DEVICE:
                if (cmd->t_bidi_data_sg &&
-                   cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {
+                   !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
                        ret = cmd->se_tfo->queue_data_in(cmd);
                        if (ret < 0)
                                break;
@@ -1949,7 +1949,7 @@ static void target_complete_ok_work(struct work_struct *work)
                 * Check if we need to send READ payload for BIDI-COMMAND
                 */
                if (cmd->t_bidi_data_sg &&
-                   cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {
+                   !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
                        spin_lock(&cmd->se_lun->lun_sep_lock);
                        if (cmd->se_lun->lun_sep) {
                                cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
