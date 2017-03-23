From: Ilias Tsitsimpis <iliastsi@arrikto.com>
Subject: Re: [PATCHv4 0/4] tcmu: bug fix and dynamic growing data area support
Date: Thu, 23 Mar 2017 18:02:37 +0200
Message-ID: <20170323160237.qqofpc7v7aoazfqd@iliastsi-m.arr>
References: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hi Xiubo,

On Tue, Mar 21, 2017 at 04:36PM, lixiubo@cmss.chinamobile.com wrote:
> [...]
>   tcmu: Fix possible overwrite of t_data_sg's last iov[]
>   tcmu: Fix wrongly calculating of the base_command_size

I tested these two patches, which try to fix the broken support for
BIDI commands in target/user.

Both look good to me, but unfortunately, there is also another
regression which got introduced with the use of the data_bitmap. More
specifically, in case of BIDI commands, the data bitmap records both the
Data-Out and the Data-In buffer, and so when gathering the data in the
tcmu_handle_completion() function, care should be taken in order to
discard the Data-Out buffer before gathering the Data-In buffer.
Something like this should do the trick:

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1108bf5..7075161 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -610,10 +610,22 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
                               se_cmd->scsi_sense_length);
                free_data_area(udev, cmd);
        } else if (se_cmd->se_cmd_flags & SCF_BIDI) {
+               struct scatterlist *sg;
+               int n, block, sg_remaining = 0;
                DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);

-               /* Get Data-In buffer before clean up */
                bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
+
+               /* Discard Data-Out buffer */
+               for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, n) {
+                       sg_remaining += sg->length;
+                       while (sg_remaining > 0) {
+                               block = find_first_bit(bitmap, DATA_BLOCK_BITS);
+                               clear_bit(block, bitmap);
+                               sg_remaining -= DATA_BLOCK_SIZE;
+                       }
+               }
+
+               /* Get Data-In buffer before clean up */
                gather_data_area(udev, bitmap,
                        se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents);
                free_data_area(udev, cmd);

With your patches, and the above diff, support for BIDI commands in the
target/user seems to be working again.

Could you please validate the above snippet, and update your patches to
include it?

-- 
Ilias
