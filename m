From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Wed, 23 Feb 2005 16:03:27 -0500
Message-ID: <421CEF9F.2070305@pobox.com>
References: <1109187935.15154.164.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23756 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261587AbVBWVDs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 16:03:48 -0500
In-Reply-To: <1109187935.15154.164.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>, Andre Hedrick <andre@pyxtechnologies.com>, linux-scsi <linux-scsi@vger.kernel.org>

Comments from an initial scan of the code.  This does not include any 
review of iSCSI interaction itself.


1) the TRACE stuff uses too much stack space


2) style:  way too many interal headers; feel free to disagree, though, 
this is maintainer's preference.


3) non-standard function definitions:

+extern void iscsi_non_scsi_queue_cmd (
+       iscsi_cmd_t *cmd,
+       iscsi_session_t *sess)
+{

Use the standard style instead.


4) My initial reaction upon reading the following code is, "where is the 
document describing this mess of locking?"

+       if (atomic_read(&sess->nconn) == 1) {
+               up(&sess->schedule_conn->tx_sem);
+               spin_unlock_irqrestore(&sess->conn_schedule_lock, flags);
+               return;
+       }

Presumably, sess->nconn need not be atomic?

In practice, I have found that use of atomic_t often _creates_ races.


5) style:  these function headers are completely pointless, conveying no 
additional insight or information:

+/*     iscsi_add_nopout_noqueue():
+ *
+ *
+ */


6) This is very worrisome, at the beginning of your queuecommand hook:

+       /*
+       * Get the assoicated iSCSI Channel for this active SCSI Task.
+       */
+       spin_unlock_irq(sc->device->host->host_lock);


It's fairly dangerous to assume that this will work, if, e.g. 
->queuecommand() is called from BH context.

Also, it means you are accessing the internal LUN list without any 
locking at all.


7) leak on error:

+       if (!(cmd = iscsi_allocate_cmd(sess, NULL)))
+               return(-1);
+
+       if ((padding = ((text_len) & 3)) != 0) {
+               TRACE(TRACE_ISCSI, "Attaching %u additional bytes for"
+                       " padding.\n", padding);
+       }
+
+       if (!(text = (unsigned char *) kmalloc((text_len + padding), 
GFP_ATOMIC)
)) {
+               TRACE_ERROR("Unable to allocate memory for outgoing 
text\n");
+               return(-1);
+       }



8) iscsi_build_scsi_cmd() appears to leak cmd->buf_ptr on error, but I 
could be wrong


9) style:  Linux kernel style discourages use of "foo_t", and prefers 
"struct foo"


10) iscsi_build_dataout() leak on error:

+               if (!(pdu = iscsi_get_pdu_holder_from_r2t(cmd, r2t)))
+                       return(-1);
...
+               if ((iov_ret = iscsi_map_scatterlists((void *)&map_sg,
+                                       (void *)unmap_sg)) < 0)
+                       return(-1);


11) excessive stack usage.  will cause crash with 4K stacks:

+       unsigned char ping_data[ISCSI_MAX_PING_DATA_BYTES];


12) general comment:  It is damned difficult to figure out which context 
these functions are operating in.  In iscsi_build_text_req() I see you 
grab a spinlock with spin_lock().  May we presume that local_irq_save() 
is active?  Have you audited this code for ABBA deadlocks?


13) delete all of the following #ifdefs:

+#ifdef CRYPTO_API_CRC32C

and replace with a requirement in Kconfig.


14) Many instances where iscsi_find_cmd_from_itt_or_dump() returns a 
command, and then function returns on error without releasing cmd.

This -may- be a leak on error, maybe not.


15) locking bug: conn->state_lock is locked with spin_lock() in process 
context, spin_lock_bh() in other contexts.


16) stack usage:

+extern int iscsi_initiator_rx_thread (void *arg)
+{
+       int ret;
+       u8 buffer[ISCSI_HDR_LEN], opcode;


17) potential race in iscsi_create_connection():

+       if ((atomic_read(&sess->nconn) + 
atomic_read(&c->connection_count)) >


18) excessive stack usage:

+extern int iscsi_free_session (iscsi_session_t *sess)
+{
+       int i = 0, j = 0;
+       iscsi_conn_t *conn, *conn_next = NULL;
+       iscsi_conn_t *conn_array[ISCSI_MAX_CONNECTIONS];


19) ditto:

+extern int iscsi_stop_session (iscsi_session_t *sess, int 
session_sleep, int co
nnection_sleep)
+{
+       int i = 0, j = 0;
+       iscsi_conn_t *conn, *conn_next = NULL;
+       iscsi_conn_t *conn_array[ISCSI_MAX_CONNECTIONS];



20) numerous code bloat, by checking for NULL before calling kfree():

+               if (c)
+                       kfree(c);

kfree(NULL) is ok.


21) delete FULL_PARAMS_COUNT constant, use ARRAY_SIZE() macro in 
linux/kernel.h


22) excessive stack usage:

+static int iscsi_setup_full_params (iscsi_channel_t *c)
+{
+       unsigned char buf[512];


23) ditto:

+extern int iscsi_init_channel (iscsi_channel_t *channel, u32 
max_sectors, int f
ull_init)
+{
+       unsigned char buf[512];



I stopped reading at this point.

In general,

a) locking is completely unreviewable, incomprehensible and 
unmaintainable by anyone except the author(s).  Either a locking 
rewrite, or a locking proof document, is needed.

b) aside from locking, stack usage, and leaks on error, the code seems 
reasonably clean.


