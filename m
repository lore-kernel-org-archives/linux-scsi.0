From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Reject immediate data underflow larger
 than SCSI transfer length
Date: Thu, 13 Jul 2017 12:27:17 -0700
Message-ID: <1499974037.7987.24.camel@haakon3.daterainc.com>
References: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
         <1496936253.3028.1.camel@wdc.com>
         <1496991302.28997.66.camel@haakon3.risingtidesystems.com>
         <1499757761.28145.45.camel@haakon3.daterainc.com>
         <1499789824.2586.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499789824.2586.16.camel@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "roland@purestorage.com" <roland@purestorage.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-07-11 at 16:17 +0000, Bart Van Assche wrote:
> On Tue, 2017-07-11 at 00:22 -0700, Nicholas A. Bellinger wrote:
> > So rejecting this case as already done in commit abb85a9b51 is the
> > correct approach for >= v4.3.y.
> 
> Hello Nic,
> 
> I hope that you agree that the current target_cmd_size_check() implementation
> is complicated and ugly. Patch 30/33 of the patch series I referred to in my
> e-mail removes a significant number of lines of code from that function. So
> my patch series not only makes target_cmd_size_check() easier to maintain and
> to verify but it makes that function also faster. Hence please reconsider the
> approach from my patch series. For patch 30/33, see also
> https://www.spinics.net/lists/target-devel/msg15384.html.

For reference, here is the patch your advocating:

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c28e3b58150b..6cd49fe578a7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1164,23 +1164,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
 				cmd->data_length, size, cmd->t_task_cdb[0]);
-
-		if (cmd->data_direction == DMA_TO_DEVICE &&
-		    cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
-			pr_err("Rejecting underflow/overflow WRITE data\n");
-			return TCM_INVALID_CDB_FIELD;
-		}
-		/*
-		 * Reject READ_* or WRITE_* with overflow/underflow for
-		 * type SCF_SCSI_DATA_CDB.
-		 */
-		if (dev->dev_attrib.block_size != 512)  {
-			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
-				" CDB on non 512-byte sector setup subsystem"
-				" plugin: %s\n", dev->transport->name);
-			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
-			return TCM_INVALID_CDB_FIELD;
-		}
 		/*
 		 * For the overflow case keep the existing fabric provided
 		 * ->data_length.  Otherwise for the underflow case, reset

The original code is not 'complicated' or 'ugly', and the proposed
change doesn't make anything 'faster' nor removes a 'significant' number
of LoC.

So no, I don't buy any of that line of reasoning.  ;-)

It comes down to two items.  First, if SCF_SCSI_DATA_CDBs with
underflow/overflow will be allowed, and second the block_size != 512
check.

For the former, I've still never seen a host environment in the wild
over the last 15 years that generates underflow/overflow for DATA CDBs
with an LBA.  So I'm reluctant to randomly allow this for all cases and
fabrics, considering no host environment actually requires it.

That said, I do understand libiscsi generates this for WRITE_VERIFY, but
I'm still undecided if that's a good enough a reason to enable it for
all cases in upstream.

For the latter item, it's fine to drop the legacy block_size != 512
check, and I'll take a patch for that separate from the other bit.
