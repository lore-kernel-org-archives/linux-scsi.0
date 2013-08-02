From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH v3 05/10] [RFC] SCSI: esas2r: Add interrupt and IO functions
Date: Fri, 2 Aug 2013 12:59:52 -0400
Message-ID: <1375462797-2128-6-git-send-email-bgrove@attotech.com>
References: <1375462797-2128-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:25285 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754665Ab3HBREo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Aug 2013 13:04:44 -0400
In-Reply-To: <1375462797-2128-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, jseba@attotech.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_int.c | 941 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_io.c  | 883 ++++++++++++++++++++++++++++++++++++
 2 files changed, 1824 insertions(+)
 create mode 100644 drivers/scsi/esas2r/esas2r_int.c
 create mode 100644 drivers/scsi/esas2r/esas2r_io.c

diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
new file mode 100644
index 0000000..c2d4ff5
--- /dev/null
+++ b/drivers/scsi/esas2r/esas2r_int.c
@@ -0,0 +1,941 @@
+/*
+ *  linux/drivers/scsi/esas2r/esas2r_int.c
+ *      esas2r interrupt handling
+ *
+ *  Copyright (c) 2001-2013 ATTO Technology, Inc.
+ *  (mailto:linuxdrivers@attotech.com)
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  NO WARRANTY
+ *  THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ *  CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ *  LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ *  MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ *  solely responsible for determining the appropriateness of using and
+ *  distributing the Program and assumes all risks associated with its
+ *  exercise of rights under this Agreement, including but not limited to
+ *  the risks and costs of program errors, damage to or loss of data,
+ *  programs or equipment, and unavailability or interruption of operations.
+ *
+ *  DISCLAIMER OF LIABILITY
+ *  NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ *  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ *  DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ *  USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ *  HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+#include "esas2r.h"
+
+/* Local function prototypes */
+static void esas2r_doorbell_interrupt(struct esas2r_adapter *a, u32 doorbell);
+static void esas2r_get_outbound_responses(struct esas2r_adapter *a);
+static void esas2r_process_bus_reset(struct esas2r_adapter *a);
+
+/*
+ * Poll the adapter for interrupts and service them.
+ * This function handles both legacy interrupts and MSI.
+ */
+void esas2r_polled_interrupt(struct esas2r_adapter *a)
+{
+	u32 intstat;
+	u32 doorbell;
+
+	esas2r_disable_chip_interrupts(a);
+
+	intstat = esas2r_read_register_dword(a, MU_INT_STATUS_OUT);
+
+	if (intstat & MU_INTSTAT_POST_OUT) {
+		/* clear the interrupt */
+
+		esas2r_write_register_dword(a, MU_OUT_LIST_INT_STAT,
+					    MU_OLIS_INT);
+		esas2r_flush_register_dword(a, MU_OUT_LIST_INT_STAT);
+
+		esas2r_get_outbound_responses(a);
+	}
+
+	if (intstat & MU_INTSTAT_DRBL) {
+		doorbell = esas2r_read_register_dword(a, MU_DOORBELL_OUT);
+		if (doorbell != 0)
+			esas2r_doorbell_interrupt(a, doorbell);
+	}
+
+	esas2r_enable_chip_interrupts(a);
+
+	if (atomic_read(&a->disable_cnt) == 0)
+		esas2r_do_deferred_processes(a);
+}
+
+/*
+ * Legacy and MSI interrupt handlers.  Note that the legacy interrupt handler
+ * schedules a TASKLET to process events, whereas the MSI handler just
+ * processes interrupt events directly.
+ */
+irqreturn_t esas2r_interrupt(int irq, void *dev_id)
+{
+	struct esas2r_adapter *a = (struct esas2r_adapter *)dev_id;
+
+	if (!esas2r_adapter_interrupt_pending(a))
+		return IRQ_NONE;
+
+	esas2r_lock_set_flags(&a->flags2, AF2_INT_PENDING);
+	esas2r_schedule_tasklet(a);
+
+	return IRQ_HANDLED;
+}
+
+void esas2r_adapter_interrupt(struct esas2r_adapter *a)
+{
+	u32 doorbell;
+
+	if (likely(a->int_stat & MU_INTSTAT_POST_OUT)) {
+		/* clear the interrupt */
+		esas2r_write_register_dword(a, MU_OUT_LIST_INT_STAT,
+					    MU_OLIS_INT);
+		esas2r_flush_register_dword(a, MU_OUT_LIST_INT_STAT);
+		esas2r_get_outbound_responses(a);
+	}
+
+	if (unlikely(a->int_stat & MU_INTSTAT_DRBL)) {
+		doorbell = esas2r_read_register_dword(a, MU_DOORBELL_OUT);
+		if (doorbell != 0)
+			esas2r_doorbell_interrupt(a, doorbell);
+	}
+
+	a->int_mask = ESAS2R_INT_STS_MASK;
+
+	esas2r_enable_chip_interrupts(a);
+
+	if (likely(atomic_read(&a->disable_cnt) == 0))
+		esas2r_do_deferred_processes(a);
+}
+
+irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id)
+{
+	struct esas2r_adapter *a = (struct esas2r_adapter *)dev_id;
+	u32 intstat;
+	u32 doorbell;
+
+	intstat = esas2r_read_register_dword(a, MU_INT_STATUS_OUT);
+
+	if (likely(intstat & MU_INTSTAT_POST_OUT)) {
+		/* clear the interrupt */
+
+		esas2r_write_register_dword(a, MU_OUT_LIST_INT_STAT,
+					    MU_OLIS_INT);
+		esas2r_flush_register_dword(a, MU_OUT_LIST_INT_STAT);
+
+		esas2r_get_outbound_responses(a);
+	}
+
+	if (unlikely(intstat & MU_INTSTAT_DRBL)) {
+		doorbell = esas2r_read_register_dword(a, MU_DOORBELL_OUT);
+		if (doorbell != 0)
+			esas2r_doorbell_interrupt(a, doorbell);
+	}
+
+	/*
+	 * Work around a chip bug and force a new MSI to be sent if one is
+	 * still pending.
+	 */
+	esas2r_disable_chip_interrupts(a);
+	esas2r_enable_chip_interrupts(a);
+
+	if (likely(atomic_read(&a->disable_cnt) == 0))
+		esas2r_do_deferred_processes(a);
+
+	esas2r_do_tasklet_tasks(a);
+
+	return 1;
+}
+
+
+
+static void esas2r_handle_outbound_rsp_err(struct esas2r_adapter *a,
+					   struct esas2r_request *rq,
+					   struct atto_vda_ob_rsp *rsp)
+{
+
+	/*
+	 * For I/O requests, only copy the response if an error
+	 * occurred and setup a callback to do error processing.
+	 */
+	if (unlikely(rq->req_stat != RS_SUCCESS)) {
+		memcpy(&rq->func_rsp, &rsp->func_rsp, sizeof(rsp->func_rsp));
+
+		if (rq->req_stat == RS_ABORTED) {
+			if (rq->timeout > RQ_MAX_TIMEOUT)
+				rq->req_stat = RS_TIMEOUT;
+		} else if (rq->req_stat == RS_SCSI_ERROR) {
+			u8 scsistatus = rq->func_rsp.scsi_rsp.scsi_stat;
+
+			esas2r_trace("scsistatus: %x", scsistatus);
+
+			/* Any of these are a good result. */
+			if (scsistatus == SAM_STAT_GOOD || scsistatus ==
+			    SAM_STAT_CONDITION_MET || scsistatus ==
+			    SAM_STAT_INTERMEDIATE || scsistatus ==
+			    SAM_STAT_INTERMEDIATE_CONDITION_MET) {
+				rq->req_stat = RS_SUCCESS;
+				rq->func_rsp.scsi_rsp.scsi_stat =
+					SAM_STAT_GOOD;
+			}
+		}
+	}
+}
+
+static void esas2r_get_outbound_responses(struct esas2r_adapter *a)
+{
+	struct atto_vda_ob_rsp *rsp;
+	u32 rspput_ptr;
+	u32 rspget_ptr;
+	struct esas2r_request *rq;
+	u32 handle;
+	unsigned long flags;
+
+	LIST_HEAD(comp_list);
+
+	esas2r_trace_enter();
+
+	spin_lock_irqsave(&a->queue_lock, flags);
+
+	/* Get the outbound limit and pointers */
+	rspput_ptr = le32_to_cpu(*a->outbound_copy) & MU_OLC_WRT_PTR;
+	rspget_ptr = a->last_read;
+
+	esas2r_trace("rspput_ptr: %x, rspget_ptr: %x", rspput_ptr, rspget_ptr);
+
+	/* If we don't have anything to process, get out */
+	if (unlikely(rspget_ptr == rspput_ptr)) {
+		spin_unlock_irqrestore(&a->queue_lock, flags);
+		esas2r_trace_exit();
+		return;
+	}
+
+	/* Make sure the firmware is healthy */
+	if (unlikely(rspput_ptr >= a->list_size)) {
+		spin_unlock_irqrestore(&a->queue_lock, flags);
+		esas2r_bugon();
+		esas2r_local_reset_adapter(a);
+		esas2r_trace_exit();
+		return;
+	}
+
+	do {
+		rspget_ptr++;
+
+		if (rspget_ptr >= a->list_size)
+			rspget_ptr = 0;
+
+		rsp = (struct atto_vda_ob_rsp *)a->outbound_list_md.virt_addr
+		      + rspget_ptr;
+
+		handle = rsp->handle;
+
+		/* Verify the handle range */
+		if (unlikely(LOWORD(handle) == 0
+			     || LOWORD(handle) > num_requests +
+			     num_ae_requests + 1)) {
+			esas2r_bugon();
+			continue;
+		}
+
+		/* Get the request for this handle */
+		rq = a->req_table[LOWORD(handle)];
+
+		if (unlikely(rq == NULL || rq->vrq->scsi.handle != handle)) {
+			esas2r_bugon();
+			continue;
+		}
+
+		list_del(&rq->req_list);
+
+		/* Get the completion status */
+		rq->req_stat = rsp->req_stat;
+
+		esas2r_trace("handle: %x", handle);
+		esas2r_trace("rq: %p", rq);
+		esas2r_trace("req_status: %x", rq->req_stat);
+
+		if (likely(rq->vrq->scsi.function == VDA_FUNC_SCSI)) {
+			esas2r_handle_outbound_rsp_err(a, rq, rsp);
+		} else {
+			/*
+			 * Copy the outbound completion struct for non-I/O
+			 * requests.
+			 */
+			memcpy(&rq->func_rsp, &rsp->func_rsp,
+			       sizeof(rsp->func_rsp));
+		}
+
+		/* Queue the request for completion. */
+		list_add_tail(&rq->comp_list, &comp_list);
+
+	} while (rspget_ptr != rspput_ptr);
+
+	a->last_read = rspget_ptr;
+	spin_unlock_irqrestore(&a->queue_lock, flags);
+
+	esas2r_comp_list_drain(a, &comp_list);
+	esas2r_trace_exit();
+}
+
+/*
+ * Perform all deferred processes for the adapter.  Deferred
+ * processes can only be done while the current interrupt
+ * disable_cnt for the adapter is zero.
+ */
+void esas2r_do_deferred_processes(struct esas2r_adapter *a)
+{
+	int startreqs = 2;
+	struct esas2r_request *rq;
+	unsigned long flags;
+
+	/*
+	 * startreqs is used to control starting requests
+	 * that are on the deferred queue
+	 *  = 0 - do not start any requests
+	 *  = 1 - can start discovery requests
+	 *  = 2 - can start any request
+	 */
+
+	if (a->flags & (AF_CHPRST_PENDING | AF_FLASHING))
+		startreqs = 0;
+	else if (a->flags & AF_DISC_PENDING)
+		startreqs = 1;
+
+	atomic_inc(&a->disable_cnt);
+
+	/* Clear off the completed list to be processed later. */
+
+	if (esas2r_is_tasklet_pending(a)) {
+		esas2r_schedule_tasklet(a);
+
+		startreqs = 0;
+	}
+
+	/*
+	 * If we can start requests then traverse the defer queue
+	 * looking for requests to start or complete
+	 */
+	if (startreqs && !list_empty(&a->defer_list)) {
+		LIST_HEAD(comp_list);
+		struct list_head *element, *next;
+
+		spin_lock_irqsave(&a->queue_lock, flags);
+
+		list_for_each_safe(element, next, &a->defer_list) {
+			rq = list_entry(element, struct esas2r_request,
+					req_list);
+
+			if (rq->req_stat != RS_PENDING) {
+				list_del(element);
+				list_add_tail(&rq->comp_list, &comp_list);
+			}
+			/*
+			 * Process discovery and OS requests separately.  We
+			 * can't hold up discovery requests when discovery is
+			 * pending.  In general, there may be different sets of
+			 * conditions for starting different types of requests.
+			 */
+			else if (rq->req_type == RT_DISC_REQ) {
+				list_del(element);
+				esas2r_disc_local_start_request(a, rq);
+			} else if (startreqs == 2) {
+				list_del(element);
+				esas2r_local_start_request(a, rq);
+
+				/*
+				 * Flashing could have been set by last local
+				 * start
+				 */
+				if (a->flags & AF_FLASHING)
+					break;
+			}
+		}
+
+		spin_unlock_irqrestore(&a->queue_lock, flags);
+		esas2r_comp_list_drain(a, &comp_list);
+	}
+
+	atomic_dec(&a->disable_cnt);
+}
+
+/*
+ * Process an adapter reset (or one that is about to happen)
+ * by making sure all outstanding requests are completed that
+ * haven't been already.
+ */
+void esas2r_process_adapter_reset(struct esas2r_adapter *a)
+{
+	struct esas2r_request *rq = &a->general_req;
+	unsigned long flags;
+	struct esas2r_disc_context *dc;
+
+	LIST_HEAD(comp_list);
+	struct list_head *element;
+
+	esas2r_trace_enter();
+
+	spin_lock_irqsave(&a->queue_lock, flags);
+
+	/* abort the active discovery, if any.   */
+
+	if (rq->interrupt_cx) {
+		dc = (struct esas2r_disc_context *)rq->interrupt_cx;
+
+		dc->disc_evt = 0;
+
+		esas2r_lock_clear_flags(&a->flags, AF_DISC_IN_PROG);
+	}
+
+	/*
+	 * just clear the interrupt callback for now.  it will be dequeued if
+	 * and when we find it on the active queue and we don't want the
+	 * callback called.  also set the dummy completion callback in case we
+	 * were doing an I/O request.
+	 */
+
+	rq->interrupt_cx = NULL;
+	rq->interrupt_cb = NULL;
+
+	rq->comp_cb = esas2r_dummy_complete;
+
+	/* Reset the read and write pointers */
+
+	*a->outbound_copy =
+		a->last_write =
+			a->last_read = a->list_size - 1;
+
+	esas2r_lock_set_flags(&a->flags, AF_COMM_LIST_TOGGLE);
+
+	/* Kill all the requests on the active list */
+	list_for_each(element, &a->defer_list) {
+		rq = list_entry(element, struct esas2r_request, req_list);
+
+		if (rq->req_stat == RS_STARTED)
+			if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
+				list_add_tail(&rq->comp_list, &comp_list);
+	}
+
+	spin_unlock_irqrestore(&a->queue_lock, flags);
+	esas2r_comp_list_drain(a, &comp_list);
+	esas2r_process_bus_reset(a);
+	esas2r_trace_exit();
+}
+
+static void esas2r_process_bus_reset(struct esas2r_adapter *a)
+{
+	struct esas2r_request *rq;
+	struct list_head *element;
+	unsigned long flags;
+
+	LIST_HEAD(comp_list);
+
+	esas2r_trace_enter();
+
+	esas2r_hdebug("reset detected");
+
+	spin_lock_irqsave(&a->queue_lock, flags);
+
+	/* kill all the requests on the deferred queue */
+	list_for_each(element, &a->defer_list) {
+		rq = list_entry(element, struct esas2r_request, req_list);
+		if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
+			list_add_tail(&rq->comp_list, &comp_list);
+	}
+
+	spin_unlock_irqrestore(&a->queue_lock, flags);
+
+	esas2r_comp_list_drain(a, &comp_list);
+
+	if (atomic_read(&a->disable_cnt) == 0)
+		esas2r_do_deferred_processes(a);
+
+	esas2r_lock_clear_flags(&a->flags, AF_OS_RESET);
+
+	esas2r_trace_exit();
+}
+
+static void esas2r_chip_rst_needed_during_tasklet(struct esas2r_adapter *a)
+{
+
+	esas2r_lock_clear_flags(&a->flags, AF_CHPRST_NEEDED);
+	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_NEEDED);
+	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_DETECTED);
+	esas2r_lock_clear_flags(&a->flags, AF_BUSRST_PENDING);
+	/*
+	 * Make sure we don't get attempt more than 3 resets
+	 * when the uptime between resets does not exceed one
+	 * minute.  This will stop any situation where there is
+	 * really something wrong with the hardware.  The way
+	 * this works is that we start with uptime ticks at 0.
+	 * Each time we do a reset, we add 20 seconds worth to
+	 * the count.  Each time a timer tick occurs, as long
+	 * as a chip reset is not pending, we decrement the
+	 * tick count.  If the uptime ticks ever gets to 60
+	 * seconds worth, we disable the adapter from that
+	 * point forward.  Three strikes, you're out.
+	 */
+	if (!esas2r_is_adapter_present(a) || (a->chip_uptime >=
+					      ESAS2R_CHP_UPTIME_MAX)) {
+		esas2r_hdebug("*** adapter disabled ***");
+
+		/*
+		 * Ok, some kind of hard failure.  Make sure we
+		 * exit this loop with chip interrupts
+		 * permanently disabled so we don't lock up the
+		 * entire system.  Also flag degraded mode to
+		 * prevent the heartbeat from trying to recover.
+		 */
+
+		esas2r_lock_set_flags(&a->flags, AF_DEGRADED_MODE);
+		esas2r_lock_set_flags(&a->flags, AF_DISABLED);
+		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_PENDING);
+		esas2r_lock_clear_flags(&a->flags, AF_DISC_PENDING);
+
+		esas2r_disable_chip_interrupts(a);
+		a->int_mask = 0;
+		esas2r_process_adapter_reset(a);
+
+		esas2r_log(ESAS2R_LOG_CRIT,
+			   "Adapter disabled because of hardware failure");
+	} else {
+		u32 flags =
+			esas2r_lock_set_flags(&a->flags, AF_CHPRST_STARTED);
+
+		if (!(flags & AF_CHPRST_STARTED))
+			/*
+			 * Only disable interrupts if this is
+			 * the first reset attempt.
+			 */
+			esas2r_disable_chip_interrupts(a);
+
+		if ((a->flags & AF_POWER_MGT) && !(a->flags & AF_FIRST_INIT) &&
+		    !(flags & AF_CHPRST_STARTED)) {
+			/*
+			 * Don't reset the chip on the first
+			 * deferred power up attempt.
+			 */
+		} else {
+			esas2r_hdebug("*** resetting chip ***");
+			esas2r_reset_chip(a);
+		}
+
+		/* Kick off the reinitialization */
+		a->chip_uptime += ESAS2R_CHP_UPTIME_CNT;
+		a->chip_init_time = jiffies_to_msecs(jiffies);
+		if (!(a->flags & AF_POWER_MGT)) {
+			esas2r_process_adapter_reset(a);
+
+			if (!(flags & AF_CHPRST_STARTED)) {
+				/* Remove devices now that I/O is cleaned up. */
+				a->prev_dev_cnt =
+					esas2r_targ_db_get_tgt_cnt(a);
+				esas2r_targ_db_remove_all(a, false);
+			}
+		}
+
+		a->int_mask = 0;
+	}
+}
+
+static void esas2r_handle_chip_rst_during_tasklet(struct esas2r_adapter *a)
+{
+	while (a->flags & AF_CHPRST_DETECTED) {
+		/*
+		 * Balance the enable in esas2r_initadapter_hw.
+		 * Esas2r_power_down already took care of it for power
+		 * management.
+		 */
+		if (!(a->flags & AF_DEGRADED_MODE) && !(a->flags &
+							AF_POWER_MGT))
+			esas2r_disable_chip_interrupts(a);
+
+		/* Reinitialize the chip. */
+		esas2r_check_adapter(a);
+		esas2r_init_adapter_hw(a, 0);
+
+		if (a->flags & AF_CHPRST_NEEDED)
+			break;
+
+		if (a->flags & AF_POWER_MGT) {
+			/* Recovery from power management. */
+			if (a->flags & AF_FIRST_INIT) {
+				/* Chip reset during normal power up */
+				esas2r_log(ESAS2R_LOG_CRIT,
+					   "The firmware was reset during a normal power-up sequence");
+			} else {
+				/* Deferred power up complete. */
+				esas2r_lock_clear_flags(&a->flags,
+							AF_POWER_MGT);
+				esas2r_send_reset_ae(a, true);
+			}
+		} else {
+			/* Recovery from online chip reset. */
+			if (a->flags & AF_FIRST_INIT) {
+				/* Chip reset during driver load */
+			} else {
+				/* Chip reset after driver load */
+				esas2r_send_reset_ae(a, false);
+			}
+
+			esas2r_log(ESAS2R_LOG_CRIT,
+				   "Recovering from a chip reset while the chip was online");
+		}
+
+		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_STARTED);
+		esas2r_enable_chip_interrupts(a);
+
+		/*
+		 * Clear this flag last!  this indicates that the chip has been
+		 * reset already during initialization.
+		 */
+		esas2r_lock_clear_flags(&a->flags, AF_CHPRST_DETECTED);
+	}
+}
+
+
+/* Perform deferred tasks when chip interrupts are disabled */
+void esas2r_do_tasklet_tasks(struct esas2r_adapter *a)
+{
+	if (a->flags & (AF_CHPRST_NEEDED | AF_CHPRST_DETECTED)) {
+		if (a->flags & AF_CHPRST_NEEDED)
+			esas2r_chip_rst_needed_during_tasklet(a);
+
+		esas2r_handle_chip_rst_during_tasklet(a);
+	}
+
+	if (a->flags & AF_BUSRST_NEEDED) {
+		esas2r_hdebug("hard resetting bus");
+
+		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_NEEDED);
+
+		if (a->flags & AF_FLASHING)
+			esas2r_lock_set_flags(&a->flags, AF_BUSRST_DETECTED);
+		else
+			esas2r_write_register_dword(a, MU_DOORBELL_IN,
+						    DRBL_RESET_BUS);
+	}
+
+	if (a->flags & AF_BUSRST_DETECTED) {
+		esas2r_process_bus_reset(a);
+
+		esas2r_log_dev(ESAS2R_LOG_WARN,
+			       &(a->host->shost_gendev),
+			       "scsi_report_bus_reset() called");
+
+		scsi_report_bus_reset(a->host, 0);
+
+		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_DETECTED);
+		esas2r_lock_clear_flags(&a->flags, AF_BUSRST_PENDING);
+
+		esas2r_log(ESAS2R_LOG_WARN, "Bus reset complete");
+	}
+
+	if (a->flags & AF_PORT_CHANGE) {
+		esas2r_lock_clear_flags(&a->flags, AF_PORT_CHANGE);
+
+		esas2r_targ_db_report_changes(a);
+	}
+
+	if (atomic_read(&a->disable_cnt) == 0)
+		esas2r_do_deferred_processes(a);
+}
+
+static void esas2r_doorbell_interrupt(struct esas2r_adapter *a, u32 doorbell)
+{
+	if (!(doorbell & DRBL_FORCE_INT)) {
+		esas2r_trace_enter();
+		esas2r_trace("doorbell: %x", doorbell);
+	}
+
+	/* First clear the doorbell bits */
+	esas2r_write_register_dword(a, MU_DOORBELL_OUT, doorbell);
+
+	if (doorbell & DRBL_RESET_BUS)
+		esas2r_lock_set_flags(&a->flags, AF_BUSRST_DETECTED);
+
+	if (doorbell & DRBL_FORCE_INT)
+		esas2r_lock_clear_flags(&a->flags, AF_HEARTBEAT);
+
+	if (doorbell & DRBL_PANIC_REASON_MASK) {
+		esas2r_hdebug("*** Firmware Panic ***");
+		esas2r_log(ESAS2R_LOG_CRIT, "The firmware has panicked");
+	}
+
+	if (doorbell & DRBL_FW_RESET) {
+		esas2r_lock_set_flags(&a->flags2, AF2_COREDUMP_AVAIL);
+		esas2r_local_reset_adapter(a);
+	}
+
+	if (!(doorbell & DRBL_FORCE_INT))
+		esas2r_trace_exit();
+}
+
+void esas2r_force_interrupt(struct esas2r_adapter *a)
+{
+	esas2r_write_register_dword(a, MU_DOORBELL_IN, DRBL_FORCE_INT |
+				    DRBL_DRV_VER);
+}
+
+
+static void esas2r_lun_event(struct esas2r_adapter *a, union atto_vda_ae *ae,
+			     u16 target, u32 length)
+{
+	struct esas2r_target *t = a->targetdb + target;
+	u32 cplen = length;
+	unsigned long flags;
+
+	if (cplen > sizeof(t->lu_event))
+		cplen = sizeof(t->lu_event);
+
+	esas2r_trace("ae->lu.dwevent: %x", ae->lu.dwevent);
+	esas2r_trace("ae->lu.bystate: %x", ae->lu.bystate);
+
+	spin_lock_irqsave(&a->mem_lock, flags);
+
+	t->new_target_state = TS_INVALID;
+
+	if (ae->lu.dwevent  & VDAAE_LU_LOST) {
+		t->new_target_state = TS_NOT_PRESENT;
+	} else {
+		switch (ae->lu.bystate) {
+		case VDAAE_LU_NOT_PRESENT:
+		case VDAAE_LU_OFFLINE:
+		case VDAAE_LU_DELETED:
+		case VDAAE_LU_FACTORY_DISABLED:
+			t->new_target_state = TS_NOT_PRESENT;
+			break;
+
+		case VDAAE_LU_ONLINE:
+		case VDAAE_LU_DEGRADED:
+			t->new_target_state = TS_PRESENT;
+			break;
+		}
+	}
+
+	if (t->new_target_state != TS_INVALID) {
+		memcpy(&t->lu_event, &ae->lu, cplen);
+
+		esas2r_disc_queue_event(a, DCDE_DEV_CHANGE);
+	}
+
+	spin_unlock_irqrestore(&a->mem_lock, flags);
+}
+
+
+
+void esas2r_ae_complete(struct esas2r_adapter *a, struct esas2r_request *rq)
+{
+	union atto_vda_ae *ae =
+		(union atto_vda_ae *)rq->vda_rsp_data->ae_data.event_data;
+	u32 length = le32_to_cpu(rq->func_rsp.ae_rsp.length);
+	union atto_vda_ae *last =
+		(union atto_vda_ae *)(rq->vda_rsp_data->ae_data.event_data
+				      + length);
+
+	esas2r_trace_enter();
+	esas2r_trace("length: %d", length);
+
+	if (length > sizeof(struct atto_vda_ae_data)
+	    || (length & 3) != 0
+	    || length == 0) {
+		esas2r_log(ESAS2R_LOG_WARN,
+			   "The AE request response length (%p) is too long: %d",
+			   rq, length);
+
+		esas2r_hdebug("aereq->length (0x%x) too long", length);
+		esas2r_bugon();
+
+		last = ae;
+	}
+
+	while (ae < last) {
+		u16 target;
+
+		esas2r_trace("ae: %p", ae);
+		esas2r_trace("ae->hdr: %p", &(ae->hdr));
+
+		length = ae->hdr.bylength;
+
+		if (length > (u32)((u8 *)last - (u8 *)ae)
+		    || (length & 3) != 0
+		    || length == 0) {
+			esas2r_log(ESAS2R_LOG_CRIT,
+				   "the async event length is invalid (%p): %d",
+				   ae, length);
+
+			esas2r_hdebug("ae->hdr.length (0x%x) invalid", length);
+			esas2r_bugon();
+
+			break;
+		}
+
+		esas2r_nuxi_ae_data(ae);
+
+		esas2r_queue_fw_event(a, fw_event_vda_ae, ae,
+				      sizeof(union atto_vda_ae));
+
+		switch (ae->hdr.bytype) {
+		case VDAAE_HDR_TYPE_RAID:
+
+			if (ae->raid.dwflags & (VDAAE_GROUP_STATE
+						| VDAAE_RBLD_STATE
+						| VDAAE_MEMBER_CHG
+						| VDAAE_PART_CHG)) {
+				esas2r_log(ESAS2R_LOG_INFO,
+					   "RAID event received - name:%s rebuild_state:%d group_state:%d",
+					   ae->raid.acname,
+					   ae->raid.byrebuild_state,
+					   ae->raid.bygroup_state);
+			}
+
+			break;
+
+		case VDAAE_HDR_TYPE_LU:
+			esas2r_log(ESAS2R_LOG_INFO,
+				   "LUN event received: event:%d target_id:%d LUN:%d state:%d",
+				   ae->lu.dwevent,
+				   ae->lu.id.tgtlun.wtarget_id,
+				   ae->lu.id.tgtlun.bylun,
+				   ae->lu.bystate);
+
+			target = ae->lu.id.tgtlun.wtarget_id;
+
+			if (target < ESAS2R_MAX_TARGETS)
+				esas2r_lun_event(a, ae, target, length);
+
+			break;
+
+		case VDAAE_HDR_TYPE_DISK:
+			esas2r_log(ESAS2R_LOG_INFO, "Disk event received");
+			break;
+
+		default:
+
+			/* Silently ignore the rest and let the apps deal with
+			 * them.
+			 */
+
+			break;
+		}
+
+		ae = (union atto_vda_ae *)((u8 *)ae + length);
+	}
+
+	/* Now requeue it. */
+	esas2r_start_ae_request(a, rq);
+	esas2r_trace_exit();
+}
+
+/* Send an asynchronous event for a chip reset or power management. */
+void esas2r_send_reset_ae(struct esas2r_adapter *a, bool pwr_mgt)
+{
+	struct atto_vda_ae_hdr ae;
+
+	if (pwr_mgt)
+		ae.bytype = VDAAE_HDR_TYPE_PWRMGT;
+	else
+		ae.bytype = VDAAE_HDR_TYPE_RESET;
+
+	ae.byversion = VDAAE_HDR_VER_0;
+	ae.byflags = 0;
+	ae.bylength = (u8)sizeof(struct atto_vda_ae_hdr);
+
+	if (pwr_mgt)
+		esas2r_hdebug("*** sending power management AE ***");
+	else
+		esas2r_hdebug("*** sending reset AE ***");
+
+	esas2r_queue_fw_event(a, fw_event_vda_ae, &ae,
+			      sizeof(union atto_vda_ae));
+}
+
+void esas2r_dummy_complete(struct esas2r_adapter *a, struct esas2r_request *rq)
+{}
+
+static void esas2r_check_req_rsp_sense(struct esas2r_adapter *a,
+				       struct esas2r_request *rq)
+{
+	u8 snslen, snslen2;
+
+	snslen = snslen2 = rq->func_rsp.scsi_rsp.sense_len;
+
+	if (snslen > rq->sense_len)
+		snslen = rq->sense_len;
+
+	if (snslen) {
+		if (rq->sense_buf)
+			memcpy(rq->sense_buf, rq->data_buf, snslen);
+		else
+			rq->sense_buf = (u8 *)rq->data_buf;
+
+		/* See about possible sense data */
+		if (snslen2 > 0x0c) {
+			u8 *s = (u8 *)rq->data_buf;
+
+			esas2r_trace_enter();
+
+			/* Report LUNS data has changed */
+			if (s[0x0c] == 0x3f && s[0x0d] == 0x0E) {
+				esas2r_trace("rq->target_id: %d",
+					     rq->target_id);
+				esas2r_target_state_changed(a, rq->target_id,
+							    TS_LUN_CHANGE);
+			}
+
+			esas2r_trace("add_sense_key=%x", s[0x0c]);
+			esas2r_trace("add_sense_qual=%x", s[0x0d]);
+			esas2r_trace_exit();
+		}
+	}
+
+	rq->sense_len = snslen;
+}
+
+
+void esas2r_complete_request(struct esas2r_adapter *a,
+			     struct esas2r_request *rq)
+{
+	if (rq->vrq->scsi.function == VDA_FUNC_FLASH
+	    && rq->vrq->flash.sub_func == VDA_FLASH_COMMIT)
+		esas2r_lock_clear_flags(&a->flags, AF_FLASHING);
+
+	/* See if we setup a callback to do special processing */
+
+	if (rq->interrupt_cb) {
+		(*rq->interrupt_cb)(a, rq);
+
+		if (rq->req_stat == RS_PENDING) {
+			esas2r_start_request(a, rq);
+			return;
+		}
+	}
+
+	if (likely(rq->vrq->scsi.function == VDA_FUNC_SCSI)
+	    && unlikely(rq->req_stat != RS_SUCCESS)) {
+		esas2r_check_req_rsp_sense(a, rq);
+		esas2r_log_request_failure(a, rq);
+	}
+
+	(*rq->comp_cb)(a, rq);
+}
diff --git a/drivers/scsi/esas2r/esas2r_io.c b/drivers/scsi/esas2r/esas2r_io.c
new file mode 100644
index 0000000..02ec7aa
--- /dev/null
+++ b/drivers/scsi/esas2r/esas2r_io.c
@@ -0,0 +1,880 @@
+/*
+ *  linux/drivers/scsi/esas2r/esas2r_io.c
+ *      For use with ATTO ExpressSAS R6xx SAS/SATA RAID controllers
+ *
+ *  Copyright (c) 2001-2013 ATTO Technology, Inc.
+ *  (mailto:linuxdrivers@attotech.com)mpt3sas/mpt3sas_trigger_diag.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+ *
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+#include "esas2r.h"
+
+void esas2r_start_request(struct esas2r_adapter *a, struct esas2r_request *rq)
+{
+	struct esas2r_target *t = NULL;
+	struct esas2r_request *startrq = rq;
+	unsigned long flags;
+
+	if (unlikely(a->flags & (AF_DEGRADED_MODE | AF_POWER_DOWN))) {
+		if (rq->vrq->scsi.function == VDA_FUNC_SCSI)
+			rq->req_stat = RS_SEL2;
+		else
+			rq->req_stat = RS_DEGRADED;
+	} else if (likely(rq->vrq->scsi.function == VDA_FUNC_SCSI)) {
+		t = a->targetdb + rq->target_id;
+
+		if (unlikely(t >= a->targetdb_end
+			     || !(t->flags & TF_USED))) {
+			rq->req_stat = RS_SEL;
+		} else {
+			/* copy in the target ID. */
+			rq->vrq->scsi.target_id = cpu_to_le16(t->virt_targ_id);
+
+			/*
+			 * Test if we want to report RS_SEL for missing target.
+			 * Note that if AF_DISC_PENDING is set than this will
+			 * go on the defer queue.
+			 */
+			if (unlikely(t->target_state != TS_PRESENT
+				     && !(a->flags & AF_DISC_PENDING)))
+				rq->req_stat = RS_SEL;
+		}
+	}
+
+	if (unlikely(rq->req_stat != RS_PENDING)) {
+		esas2r_complete_request(a, rq);
+		return;
+	}
+
+	esas2r_trace("rq=%p", rq);
+	esas2r_trace("rq->vrq->scsi.handle=%x", rq->vrq->scsi.handle);
+
+	if (rq->vrq->scsi.function == VDA_FUNC_SCSI) {
+		esas2r_trace("rq->target_id=%d", rq->target_id);
+		esas2r_trace("rq->vrq->scsi.flags=%x", rq->vrq->scsi.flags);
+	}
+
+	spin_lock_irqsave(&a->queue_lock, flags);
+
+	if (likely(list_empty(&a->defer_list) &&
+		   !(a->flags &
+		     (AF_CHPRST_PENDING | AF_FLASHING | AF_DISC_PENDING))))
+		esas2r_local_start_request(a, startrq);
+	else
+		list_add_tail(&startrq->req_list, &a->defer_list);
+
+	spin_unlock_irqrestore(&a->queue_lock, flags);
+}
+
+/*
+ * Starts the specified request.  all requests have RS_PENDING set when this
+ * routine is called.  The caller is usually esas2r_start_request, but
+ * esas2r_do_deferred_processes will start request that are deferred.
+ *
+ * The caller must ensure that requests can be started.
+ *
+ * esas2r_start_request will defer a request if there are already requests
+ * waiting or there is a chip reset pending.  once the reset condition clears,
+ * esas2r_do_deferred_processes will call this function to start the request.
+ *
+ * When a request is started, it is placed on the active list and queued to
+ * the controller.
+ */
+void esas2r_local_start_request(struct esas2r_adapter *a,
+				struct esas2r_request *rq)
+{
+	esas2r_trace_enter();
+	esas2r_trace("rq=%p", rq);
+	esas2r_trace("rq->vrq:%p", rq->vrq);
+	esas2r_trace("rq->vrq_md->phys_addr:%x", rq->vrq_md->phys_addr);
+
+	if (unlikely(rq->vrq->scsi.function == VDA_FUNC_FLASH
+		     && rq->vrq->flash.sub_func == VDA_FLASH_COMMIT))
+		esas2r_lock_set_flags(&a->flags, AF_FLASHING);
+
+	list_add_tail(&rq->req_list, &a->active_list);
+	esas2r_start_vda_request(a, rq);
+	esas2r_trace_exit();
+	return;
+}
+
+void esas2r_start_vda_request(struct esas2r_adapter *a,
+			      struct esas2r_request *rq)
+{
+	struct esas2r_inbound_list_source_entry *element;
+	u32 dw;
+
+	rq->req_stat = RS_STARTED;
+	/*
+	 * Calculate the inbound list entry location and the current state of
+	 * toggle bit.
+	 */
+	a->last_write++;
+	if (a->last_write >= a->list_size) {
+		a->last_write = 0;
+		/* update the toggle bit */
+		if (a->flags & AF_COMM_LIST_TOGGLE)
+			esas2r_lock_clear_flags(&a->flags,
+						AF_COMM_LIST_TOGGLE);
+		else
+			esas2r_lock_set_flags(&a->flags, AF_COMM_LIST_TOGGLE);
+	}
+
+	element =
+		(struct esas2r_inbound_list_source_entry *)a->inbound_list_md.
+		virt_addr
+		+ a->last_write;
+
+	/* Set the VDA request size if it was never modified */
+	if (rq->vda_req_sz == RQ_SIZE_DEFAULT)
+		rq->vda_req_sz = (u16)(a->max_vdareq_size / sizeof(u32));
+
+	element->address = cpu_to_le64(rq->vrq_md->phys_addr);
+	element->length = cpu_to_le32(rq->vda_req_sz);
+
+	/* Update the write pointer */
+	dw = a->last_write;
+
+	if (a->flags & AF_COMM_LIST_TOGGLE)
+		dw |= MU_ILW_TOGGLE;
+
+	esas2r_trace("rq->vrq->scsi.handle:%x", rq->vrq->scsi.handle);
+	esas2r_trace("dw:%x", dw);
+	esas2r_trace("rq->vda_req_sz:%x", rq->vda_req_sz);
+	esas2r_write_register_dword(a, MU_IN_LIST_WRITE, dw);
+}
+
+/*
+ * Build the scatter/gather list for an I/O request according to the
+ * specifications placed in the s/g context.  The caller must initialize
+ * context prior to the initial call by calling esas2r_sgc_init().
+ */
+bool esas2r_build_sg_list_sge(struct esas2r_adapter *a,
+			      struct esas2r_sg_context *sgc)
+{
+	struct esas2r_request *rq = sgc->first_req;
+	union atto_vda_req *vrq = rq->vrq;
+
+	while (sgc->length) {
+		u32 rem = 0;
+		u64 addr;
+		u32 len;
+
+		len = (*sgc->get_phys_addr)(sgc, &addr);
+
+		if (unlikely(len == 0))
+			return false;
+
+		/* if current length is more than what's left, stop there */
+		if (unlikely(len > sgc->length))
+			len = sgc->length;
+
+another_entry:
+		/* limit to a round number less than the maximum length */
+		if (len > SGE_LEN_MAX) {
+			/*
+			 * Save the remainder of the split.  Whenever we limit
+			 * an entry we come back around to build entries out
+			 * of the leftover.  We do this to prevent multiple
+			 * calls to the get_phys_addr() function for an SGE
+			 * that is too large.
+			 */
+			rem = len - SGE_LEN_MAX;
+			len = SGE_LEN_MAX;
+		}
+
+		/* See if we need to allocate a new SGL */
+		if (unlikely(sgc->sge.a64.curr > sgc->sge.a64.limit)) {
+			u8 sgelen;
+			struct esas2r_mem_desc *sgl;
+
+			/*
+			 * If no SGls are available, return failure.  The
+			 * caller can call us later with the current context
+			 * to pick up here.
+			 */
+			sgl = esas2r_alloc_sgl(a);
+
+			if (unlikely(sgl == NULL))
+				return false;
+
+			/* Calculate the length of the last SGE filled in */
+			sgelen = (u8)((u8 *)sgc->sge.a64.curr
+				      - (u8 *)sgc->sge.a64.last);
+
+			/*
+			 * Copy the last SGE filled in to the first entry of
+			 * the new SGL to make room for the chain entry.
+			 */
+			memcpy(sgl->virt_addr, sgc->sge.a64.last, sgelen);
+
+			/* Figure out the new curr pointer in the new segment */
+			sgc->sge.a64.curr =
+				(struct atto_vda_sge *)((u8 *)sgl->virt_addr +
+							sgelen);
+
+			/* Set the limit pointer and build the chain entry */
+			sgc->sge.a64.limit =
+				(struct atto_vda_sge *)((u8 *)sgl->virt_addr
+							+ sgl_page_size
+							- sizeof(struct
+								 atto_vda_sge));
+			sgc->sge.a64.last->length = cpu_to_le32(
+				SGE_CHAIN | SGE_ADDR_64);
+			sgc->sge.a64.last->address =
+				cpu_to_le64(sgl->phys_addr);
+
+			/*
+			 * Now, if there was a previous chain entry, then
+			 * update it to contain the length of this segment
+			 * and size of this chain.  otherwise this is the
+			 * first SGL, so set the chain_offset in the request.
+			 */
+			if (sgc->sge.a64.chain) {
+				sgc->sge.a64.chain->length |=
+					cpu_to_le32(
+						((u8 *)(sgc->sge.a64.
+							last + 1)
+						 - (u8 *)rq->sg_table->
+						 virt_addr)
+						+ sizeof(struct atto_vda_sge) *
+						LOBIT(SGE_CHAIN_SZ));
+			} else {
+				vrq->scsi.chain_offset = (u8)
+							 ((u8 *)sgc->
+							  sge.a64.last -
+							  (u8 *)vrq);
+
+				/*
+				 * This is the first SGL, so set the
+				 * chain_offset and the VDA request size in
+				 * the request.
+				 */
+				rq->vda_req_sz =
+					(vrq->scsi.chain_offset +
+					 sizeof(struct atto_vda_sge) +
+					 3)
+					/ sizeof(u32);
+			}
+
+			/*
+			 * Remember this so when we get a new SGL filled in we
+			 * can update the length of this chain entry.
+			 */
+			sgc->sge.a64.chain = sgc->sge.a64.last;
+
+			/* Now link the new SGL onto the primary request. */
+			list_add(&sgl->next_desc, &rq->sg_table_head);
+		}
+
+		/* Update last one filled in */
+		sgc->sge.a64.last = sgc->sge.a64.curr;
+
+		/* Build the new SGE and update the S/G context */
+		sgc->sge.a64.curr->length = cpu_to_le32(SGE_ADDR_64 | len);
+		sgc->sge.a64.curr->address = cpu_to_le32(addr);
+		sgc->sge.a64.curr++;
+		sgc->cur_offset += len;
+		sgc->length -= len;
+
+		/*
+		 * Check if we previously split an entry.  If so we have to
+		 * pick up where we left off.
+		 */
+		if (rem) {
+			addr += len;
+			len = rem;
+			rem = 0;
+			goto another_entry;
+		}
+	}
+
+	/* Mark the end of the SGL */
+	sgc->sge.a64.last->length |= cpu_to_le32(SGE_LAST);
+
+	/*
+	 * If there was a previous chain entry, update the length to indicate
+	 * the length of this last segment.
+	 */
+	if (sgc->sge.a64.chain) {
+		sgc->sge.a64.chain->length |= cpu_to_le32(
+			((u8 *)(sgc->sge.a64.curr) -
+			 (u8 *)rq->sg_table->virt_addr));
+	} else {
+		u16 reqsize;
+
+		/*
+		 * The entire VDA request was not used so lets
+		 * set the size of the VDA request to be DMA'd
+		 */
+		reqsize =
+			((u16)((u8 *)sgc->sge.a64.last - (u8 *)vrq)
+			 + sizeof(struct atto_vda_sge) + 3) / sizeof(u32);
+
+		/*
+		 * Only update the request size if it is bigger than what is
+		 * already there.  We can come in here twice for some management
+		 * commands.
+		 */
+		if (reqsize > rq->vda_req_sz)
+			rq->vda_req_sz = reqsize;
+	}
+	return true;
+}
+
+
+/*
+ * Create PRD list for each I-block consumed by the command. This routine
+ * determines how much data is required from each I-block being consumed
+ * by the command. The first and last I-blocks can be partials and all of
+ * the I-blocks in between are for a full I-block of data.
+ *
+ * The interleave size is used to determine the number of bytes in the 1st
+ * I-block and the remaining I-blocks are what remeains.
+ */
+static bool esas2r_build_prd_iblk(struct esas2r_adapter *a,
+				  struct esas2r_sg_context *sgc)
+{
+	struct esas2r_request *rq = sgc->first_req;
+	u64 addr;
+	u32 len;
+	struct esas2r_mem_desc *sgl;
+	u32 numchain = 1;
+	u32 rem = 0;
+
+	while (sgc->length) {
+		/* Get the next address/length pair */
+
+		len = (*sgc->get_phys_addr)(sgc, &addr);
+
+		if (unlikely(len == 0))
+			return false;
+
+		/* If current length is more than what's left, stop there */
+
+		if (unlikely(len > sgc->length))
+			len = sgc->length;
+
+another_entry:
+		/* Limit to a round number less than the maximum length */
+
+		if (len > PRD_LEN_MAX) {
+			/*
+			 * Save the remainder of the split.  whenever we limit
+			 * an entry we come back around to build entries out
+			 * of the leftover.  We do this to prevent multiple
+			 * calls to the get_phys_addr() function for an SGE
+			 * that is too large.
+			 */
+			rem = len - PRD_LEN_MAX;
+			len = PRD_LEN_MAX;
+		}
+
+		/* See if we need to allocate a new SGL */
+		if (sgc->sge.prd.sge_cnt == 0) {
+			if (len == sgc->length) {
+				/*
+				 * We only have 1 PRD entry left.
+				 * It can be placed where the chain
+				 * entry would have gone
+				 */
+
+				/* Build the simple SGE */
+				sgc->sge.prd.curr->ctl_len = cpu_to_le32(
+					PRD_DATA | len);
+				sgc->sge.prd.curr->address = cpu_to_le64(addr);
+
+				/* Adjust length related fields */
+				sgc->cur_offset += len;
+				sgc->length -= len;
+
+				/* We use the reserved chain entry for data */
+				numchain = 0;
+
+				break;
+			}
+
+			if (sgc->sge.prd.chain) {
+				/*
+				 * Fill # of entries of current SGL in previous
+				 * chain the length of this current SGL may not
+				 * full.
+				 */
+
+				sgc->sge.prd.chain->ctl_len |= cpu_to_le32(
+					sgc->sge.prd.sgl_max_cnt);
+			}
+
+			/*
+			 * If no SGls are available, return failure.  The
+			 * caller can call us later with the current context
+			 * to pick up here.
+			 */
+
+			sgl = esas2r_alloc_sgl(a);
+
+			if (unlikely(sgl == NULL))
+				return false;
+
+			/*
+			 * Link the new SGL onto the chain
+			 * They are in reverse order
+			 */
+			list_add(&sgl->next_desc, &rq->sg_table_head);
+
+			/*
+			 * An SGL was just filled in and we are starting
+			 * a new SGL. Prime the chain of the ending SGL with
+			 * info that points to the new SGL. The length gets
+			 * filled in when the new SGL is filled or ended
+			 */
+
+			sgc->sge.prd.chain = sgc->sge.prd.curr;
+
+			sgc->sge.prd.chain->ctl_len = cpu_to_le32(PRD_CHAIN);
+			sgc->sge.prd.chain->address =
+				cpu_to_le64(sgl->phys_addr);
+
+			/*
+			 * Start a new segment.
+			 * Take one away and save for chain SGE
+			 */
+
+			sgc->sge.prd.curr =
+				(struct atto_physical_region_description *)sgl
+				->
+				virt_addr;
+			sgc->sge.prd.sge_cnt = sgc->sge.prd.sgl_max_cnt - 1;
+		}
+
+		sgc->sge.prd.sge_cnt--;
+		/* Build the simple SGE */
+		sgc->sge.prd.curr->ctl_len = cpu_to_le32(PRD_DATA | len);
+		sgc->sge.prd.curr->address = cpu_to_le64(addr);
+
+		/* Used another element.  Point to the next one */
+
+		sgc->sge.prd.curr++;
+
+		/* Adjust length related fields */
+
+		sgc->cur_offset += len;
+		sgc->length -= len;
+
+		/*
+		 * Check if we previously split an entry.  If so we have to
+		 * pick up where we left off.
+		 */
+
+		if (rem) {
+			addr += len;
+			len = rem;
+			rem = 0;
+			goto another_entry;
+		}
+	}
+
+	if (!list_empty(&rq->sg_table_head)) {
+		if (sgc->sge.prd.chain) {
+			sgc->sge.prd.chain->ctl_len |=
+				cpu_to_le32(sgc->sge.prd.sgl_max_cnt
+					    - sgc->sge.prd.sge_cnt
+					    - numchain);
+		}
+	}
+
+	return true;
+}
+
+bool esas2r_build_sg_list_prd(struct esas2r_adapter *a,
+			      struct esas2r_sg_context *sgc)
+{
+	struct esas2r_request *rq = sgc->first_req;
+	u32 len = sgc->length;
+	struct esas2r_target *t = a->targetdb + rq->target_id;
+	u8 is_i_o = 0;
+	u16 reqsize;
+	struct atto_physical_region_description *curr_iblk_chn;
+	u8 *cdb = (u8 *)&rq->vrq->scsi.cdb[0];
+
+	/*
+	 * extract LBA from command so we can determine
+	 * the I-Block boundary
+	 */
+
+	if (rq->vrq->scsi.function == VDA_FUNC_SCSI
+	    && t->target_state == TS_PRESENT
+	    && !(t->flags & TF_PASS_THRU)) {
+		u32 lbalo = 0;
+
+		switch (rq->vrq->scsi.cdb[0]) {
+		case    READ_16:
+		case    WRITE_16:
+		{
+			lbalo =
+				MAKEDWORD(MAKEWORD(cdb[9],
+						   cdb[8]),
+					  MAKEWORD(cdb[7],
+						   cdb[6]));
+			is_i_o = 1;
+			break;
+		}
+
+		case    READ_12:
+		case    WRITE_12:
+		case    READ_10:
+		case    WRITE_10:
+		{
+			lbalo =
+				MAKEDWORD(MAKEWORD(cdb[5],
+						   cdb[4]),
+					  MAKEWORD(cdb[3],
+						   cdb[2]));
+			is_i_o = 1;
+			break;
+		}
+
+		case    READ_6:
+		case    WRITE_6:
+		{
+			lbalo =
+				MAKEDWORD(MAKEWORD(cdb[3],
+						   cdb[2]),
+					  MAKEWORD(cdb[1] & 0x1F,
+						   0));
+			is_i_o = 1;
+			break;
+		}
+
+		default:
+			break;
+		}
+
+		if (is_i_o) {
+			u32 startlba;
+
+			rq->vrq->scsi.iblk_cnt_prd = 0;
+
+			/* Determine size of 1st I-block PRD list       */
+			startlba = t->inter_block - (lbalo & (t->inter_block -
+							      1));
+			sgc->length = startlba * t->block_size;
+
+			/* Chk if the 1st iblk chain starts at base of Iblock */
+			if ((lbalo & (t->inter_block - 1)) == 0)
+				rq->flags |= RF_1ST_IBLK_BASE;
+
+			if (sgc->length > len)
+				sgc->length = len;
+		} else {
+			sgc->length = len;
+		}
+	} else {
+		sgc->length = len;
+	}
+
+	/* get our starting chain address   */
+
+	curr_iblk_chn =
+		(struct atto_physical_region_description *)sgc->sge.a64.curr;
+
+	sgc->sge.prd.sgl_max_cnt = sgl_page_size /
+				   sizeof(struct
+					  atto_physical_region_description);
+
+	/* create all of the I-block PRD lists          */
+
+	while (len) {
+		sgc->sge.prd.sge_cnt = 0;
+		sgc->sge.prd.chain = NULL;
+		sgc->sge.prd.curr = curr_iblk_chn;
+
+		/* increment to next I-Block    */
+
+		len -= sgc->length;
+
+		/* go build the next I-Block PRD list   */
+
+		if (unlikely(!esas2r_build_prd_iblk(a, sgc)))
+			return false;
+
+		curr_iblk_chn++;
+
+		if (is_i_o) {
+			rq->vrq->scsi.iblk_cnt_prd++;
+
+			if (len > t->inter_byte)
+				sgc->length = t->inter_byte;
+			else
+				sgc->length = len;
+		}
+	}
+
+	/* figure out the size used of the VDA request */
+
+	reqsize = ((u16)((u8 *)curr_iblk_chn - (u8 *)rq->vrq))
+		  / sizeof(u32);
+
+	/*
+	 * only update the request size if it is bigger than what is
+	 * already there.  we can come in here twice for some management
+	 * commands.
+	 */
+
+	if (reqsize > rq->vda_req_sz)
+		rq->vda_req_sz = reqsize;
+
+	return true;
+}
+
+static void esas2r_handle_pending_reset(struct esas2r_adapter *a, u32 currtime)
+{
+	u32 delta = currtime - a->chip_init_time;
+
+	if (delta <= ESAS2R_CHPRST_WAIT_TIME) {
+		/* Wait before accessing registers */
+	} else if (delta >= ESAS2R_CHPRST_TIME) {
+		/*
+		 * The last reset failed so try again. Reset
+		 * processing will give up after three tries.
+		 */
+		esas2r_local_reset_adapter(a);
+	} else {
+		/* We can now see if the firmware is ready */
+		u32 doorbell;
+
+		doorbell = esas2r_read_register_dword(a, MU_DOORBELL_OUT);
+		if (doorbell == 0xFFFFFFFF || !(doorbell & DRBL_FORCE_INT)) {
+			esas2r_force_interrupt(a);
+		} else {
+			u32 ver = (doorbell & DRBL_FW_VER_MSK);
+
+			/* Driver supports API version 0 and 1 */
+			esas2r_write_register_dword(a, MU_DOORBELL_OUT,
+						    doorbell);
+			if (ver == DRBL_FW_VER_0) {
+				esas2r_lock_set_flags(&a->flags,
+						      AF_CHPRST_DETECTED);
+				esas2r_lock_set_flags(&a->flags,
+						      AF_LEGACY_SGE_MODE);
+
+				a->max_vdareq_size = 128;
+				a->build_sgl = esas2r_build_sg_list_sge;
+			} else if (ver == DRBL_FW_VER_1) {
+				esas2r_lock_set_flags(&a->flags,
+						      AF_CHPRST_DETECTED);
+				esas2r_lock_clear_flags(&a->flags,
+							AF_LEGACY_SGE_MODE);
+
+				a->max_vdareq_size = 1024;
+				a->build_sgl = esas2r_build_sg_list_prd;
+			} else {
+				esas2r_local_reset_adapter(a);
+			}
+		}
+	}
+}
+
+
+/* This function must be called once per timer tick */
+void esas2r_timer_tick(struct esas2r_adapter *a)
+{
+	u32 currtime = jiffies_to_msecs(jiffies);
+	u32 deltatime = currtime - a->last_tick_time;
+
+	a->last_tick_time = currtime;
+
+	/* count down the uptime */
+	if (a->chip_uptime
+	    && !(a->flags & (AF_CHPRST_PENDING | AF_DISC_PENDING))) {
+		if (deltatime >= a->chip_uptime)
+			a->chip_uptime = 0;
+		else
+			a->chip_uptime -= deltatime;
+	}
+
+	if (a->flags & AF_CHPRST_PENDING) {
+		if (!(a->flags & AF_CHPRST_NEEDED)
+		    && !(a->flags & AF_CHPRST_DETECTED))
+			esas2r_handle_pending_reset(a, currtime);
+	} else {
+		if (a->flags & AF_DISC_PENDING)
+			esas2r_disc_check_complete(a);
+
+		if (a->flags & AF_HEARTBEAT_ENB) {
+			if (a->flags & AF_HEARTBEAT) {
+				if ((currtime - a->heartbeat_time) >=
+				    ESAS2R_HEARTBEAT_TIME) {
+					esas2r_lock_clear_flags(&a->flags,
+								AF_HEARTBEAT);
+					esas2r_hdebug("heartbeat failed");
+					esas2r_log(ESAS2R_LOG_CRIT,
+						   "heartbeat failed");
+					esas2r_bugon();
+					esas2r_local_reset_adapter(a);
+				}
+			} else {
+				esas2r_lock_set_flags(&a->flags, AF_HEARTBEAT);
+				a->heartbeat_time = currtime;
+				esas2r_force_interrupt(a);
+			}
+		}
+	}
+
+	if (atomic_read(&a->disable_cnt) == 0)
+		esas2r_do_deferred_processes(a);
+}
+
+/*
+ * Send the specified task management function to the target and LUN
+ * specified in rqaux.  in addition, immediately abort any commands that
+ * are queued but not sent to the device according to the rules specified
+ * by the task management function.
+ */
+bool esas2r_send_task_mgmt(struct esas2r_adapter *a,
+			   struct esas2r_request *rqaux, u8 task_mgt_func)
+{
+	u16 targetid = rqaux->target_id;
+	u8 lun = (u8)le32_to_cpu(rqaux->vrq->scsi.flags);
+	bool ret = false;
+	struct esas2r_request *rq;
+	struct list_head *next, *element;
+	unsigned long flags;
+
+	LIST_HEAD(comp_list);
+
+	esas2r_trace_enter();
+	esas2r_trace("rqaux:%p", rqaux);
+	esas2r_trace("task_mgt_func:%x", task_mgt_func);
+	spin_lock_irqsave(&a->queue_lock, flags);
+
+	/* search the defer queue looking for requests for the device */
+	list_for_each_safe(element, next, &a->defer_list) {
+		rq = list_entry(element, struct esas2r_request, req_list);
+
+		if (rq->vrq->scsi.function == VDA_FUNC_SCSI
+		    && rq->target_id == targetid
+		    && (((u8)le32_to_cpu(rq->vrq->scsi.flags)) == lun
+			|| task_mgt_func == 0x20)) { /* target reset */
+			/* Found a request affected by the task management */
+			if (rq->req_stat == RS_PENDING) {
+				/*
+				 * The request is pending or waiting.  We can
+				 * safelycomplete the request now.
+				 */
+				if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
+					list_add_tail(&rq->comp_list,
+						      &comp_list);
+			}
+		}
+	}
+
+	/* Send the task management request to the firmware */
+	rqaux->sense_len = 0;
+	rqaux->vrq->scsi.length = 0;
+	rqaux->target_id = targetid;
+	rqaux->vrq->scsi.flags |= cpu_to_le32(lun);
+	memset(rqaux->vrq->scsi.cdb, 0, sizeof(rqaux->vrq->scsi.cdb));
+	rqaux->vrq->scsi.flags |=
+		cpu_to_le16(task_mgt_func * LOBIT(FCP_CMND_TM_MASK));
+
+	if (a->flags & AF_FLASHING) {
+		/* Assume success.  if there are active requests, return busy */
+		rqaux->req_stat = RS_SUCCESS;
+
+		list_for_each_safe(element, next, &a->active_list) {
+			rq = list_entry(element, struct esas2r_request,
+					req_list);
+			if (rq->vrq->scsi.function == VDA_FUNC_SCSI
+			    && rq->target_id == targetid
+			    && (((u8)le32_to_cpu(rq->vrq->scsi.flags)) == lun
+				|| task_mgt_func == 0x20))  /* target reset */
+				rqaux->req_stat = RS_BUSY;
+		}
+
+		ret = true;
+	}
+
+	spin_unlock_irqrestore(&a->queue_lock, flags);
+
+	if (!(a->flags & AF_FLASHING))
+		esas2r_start_request(a, rqaux);
+
+	esas2r_comp_list_drain(a, &comp_list);
+
+	if (atomic_read(&a->disable_cnt) == 0)
+		esas2r_do_deferred_processes(a);
+
+	esas2r_trace_exit();
+
+	return ret;
+}
+
+void esas2r_reset_bus(struct esas2r_adapter *a)
+{
+	esas2r_log(ESAS2R_LOG_INFO, "performing a bus reset");
+
+	if (!(a->flags & AF_DEGRADED_MODE)
+	    && !(a->flags & (AF_CHPRST_PENDING | AF_DISC_PENDING))) {
+		esas2r_lock_set_flags(&a->flags, AF_BUSRST_NEEDED);
+		esas2r_lock_set_flags(&a->flags, AF_BUSRST_PENDING);
+		esas2r_lock_set_flags(&a->flags, AF_OS_RESET);
+
+		esas2r_schedule_tasklet(a);
+	}
+}
+
+bool esas2r_ioreq_aborted(struct esas2r_adapter *a, struct esas2r_request *rq,
+			  u8 status)
+{
+	esas2r_trace_enter();
+	esas2r_trace("rq:%p", rq);
+	list_del_init(&rq->req_list);
+	if (rq->timeout > RQ_MAX_TIMEOUT) {
+		/*
+		 * The request timed out, but we could not abort it because a
+		 * chip reset occurred.  Return busy status.
+		 */
+		rq->req_stat = RS_BUSY;
+		esas2r_trace_exit();
+		return true;
+	}
+
+	rq->req_stat = status;
+	esas2r_trace_exit();
+	return true;
+}
-- 
1.8.1.4

