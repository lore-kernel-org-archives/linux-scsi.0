From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Wed, 23 Feb 2005 15:11:48 -0800
Message-ID: <1109200308.24787.222.camel@haakon>
References: <1109187935.15154.164.camel@haakon> <421CEF9F.2070305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp819.mail.sc5.yahoo.com ([66.163.170.5]:21631 "HELO
	smtp819.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261667AbVBWXPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 18:15:19 -0500
In-Reply-To: <421CEF9F.2070305@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>, Andre Hedrick <andre@pyxtechnologies.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Jeff,

On Wed, 2005-02-23 at 16:03 -0500, Jeff Garzik wrote:
> Comments from an initial scan of the code.  This does not include any 
> review of iSCSI interaction itself.
> 
> 
> 1) the TRACE stuff uses too much stack space


Aside from TRACE_ERROR, the other TRACE_**** defs are not compiled in
per default and not intended for production use. (This is set with
DEBUG_ISCSI=1 in drivers/scsi/iscsi-initiator-core/Makefile).  I will
also be sure to add this as a Kconfig item.  As far as reducing stack
usage in the DEBUG_ISCSI=0 case, what do you recommend?

> 
> 2) style:  way too many interal headers; feel free to disagree, though, 
> this is maintainer's preference.
> 

I will look into thinning this out a bit.

> 
> 3) non-standard function definitions:
> 
> +extern void iscsi_non_scsi_queue_cmd (
> +       iscsi_cmd_t *cmd,
> +       iscsi_session_t *sess)
> +{
> 
> Use the standard style instead.
> 

Ok.

> 
> 4) My initial reaction upon reading the following code is, "where is the 
> document describing this mess of locking?"
> 
> +       if (atomic_read(&sess->nconn) == 1) {
> +               up(&sess->schedule_conn->tx_sem);
> +               spin_unlock_irqrestore(&sess->conn_schedule_lock, flags);
> +               return;
> +       }
> 
> Presumably, sess->nconn need not be atomic?
> 
> In practice, I have found that use of atomic_t often _creates_ races.
> 

These bits are the simple round robin scheduling algortim to determine
which connection TX thread needs to get activated in order to do work.
This lock is only held in two other locations:

A) When a new connection moves into Full Feature Phase (LOGGED_IN
state).

B) When a connection leaves a LOGGED_IN state for various exception
reasons.

This is to ensure that the above function (which as you know can be
called from the SCSI bottom half to send SCSI tasks) does not get a
stale iscsi_conn_t entry.

> 
> 5) style:  these function headers are completely pointless, conveying no 
> additional insight or information:
> 
> +/*     iscsi_add_nopout_noqueue():
> + *
> + *
> + */
> 

Ok.

> 
> 6) This is very worrisome, at the beginning of your queuecommand hook:
> 
> +       /*
> +       * Get the assoicated iSCSI Channel for this active SCSI Task.
> +       */
> +       spin_unlock_irq(sc->device->host->host_lock);
> 
> 
> It's fairly dangerous to assume that this will work, if, e.g. 
> ->queuecommand() is called from BH context.
> 
> Also, it means you are accessing the internal LUN list without any 
> locking at all.
> 

This in fact is the only thing that would not cause a deadlock. Having
to disable hard interrupts with struct Scsi_Host->host_lock while
needing to access a single iscsi_channel_t and three iscsi_session_t
spinlocks from within an bottom half is a nightmare.  I recall the sfnet
implementation doing the same thing to avoid a related deadlock issue.
Also, nothing aside from getting struct scsi_cmnd->device is being
accessed from within ->queuecommand().  Everything else related to
accessing the LUN list is protected by the usual means.

I am open to other suggestions on this one.


> 
> 7) leak on error:
> 
> +       if (!(cmd = iscsi_allocate_cmd(sess, NULL)))
> +               return(-1);
> +
> +       if ((padding = ((text_len) & 3)) != 0) {
> +               TRACE(TRACE_ISCSI, "Attaching %u additional bytes for"
> +                       " padding.\n", padding);
> +       }
> +
> +       if (!(text = (unsigned char *) kmalloc((text_len + padding), 
> GFP_ATOMIC)
> )) {
> +               TRACE_ERROR("Unable to allocate memory for outgoing 
> text\n");
> +               return(-1);
> +       }
> 
> 

Ok.

> 
> 8) iscsi_build_scsi_cmd() appears to leak cmd->buf_ptr on error, but I 
> could be wrong
> 
> 
> 9) style:  Linux kernel style discourages use of "foo_t", and prefers 
> "struct foo"
> 

Ok, I will make an effort take care of this in the next release.

> 
> 10) iscsi_build_dataout() leak on error:
> 
> +               if (!(pdu = iscsi_get_pdu_holder_from_r2t(cmd, r2t)))
> +                       return(-1);
> ...
> +               if ((iov_ret = iscsi_map_scatterlists((void *)&map_sg,
> +                                       (void *)unmap_sg)) < 0)
> +                       return(-1);
> 
> 

Ok.

> 11) excessive stack usage.  will cause crash with 4K stacks:
> 
> +       unsigned char ping_data[ISCSI_MAX_PING_DATA_BYTES];
> 

Will change to dynamic allocation.

> 
> 12) general comment:  It is damned difficult to figure out which context 
> these functions are operating in.  In iscsi_build_text_req() I see you 
> grab a spinlock with spin_lock().  May we presume that local_irq_save() 
> is active?  Have you audited this code for ABBA deadlocks?
> 

Yes, a huge amount of effort has gone into making sure the locks are
aquired and released in the correct order.  Another area that has been
worked on extensively is the interaction between the locks that need to
be held in the ->queuecommand() codepath.  I can document these locks as
well.

> 
> 13) delete all of the following #ifdefs:
> 
> +#ifdef CRYPTO_API_CRC32C
> 
> and replace with a requirement in Kconfig.
> 
> 

Ok.

> 14) Many instances where iscsi_find_cmd_from_itt_or_dump() returns a 
> command, and then function returns on error without releasing cmd.
> 
> This -may- be a leak on error, maybe not.
> 

When iscsi_cmd_t cannot be located by iscsi_find_cmd_from_itt_or_dump()
the datain buffer gets dumped and returns.  This is not a leak error and
is intented to handle various within command recovery situations.  One
example is re-requesting datain that was presumed lost, but in fact was
intact and its assoicated SCSI task completed.  Once the recovery DataIn
arrived for the SCSI task that has already been completed this function
will dump the length of the DataIn after an Initiator Task Tag (ITT)
cannot be found.

> 
> 15) locking bug: conn->state_lock is locked with spin_lock() in process 
> context, spin_lock_bh() in other contexts.
> 

Ok, double check and fix.

> 
> 16) stack usage:
> 
> +extern int iscsi_initiator_rx_thread (void *arg)
> +{
> +       int ret;
> +       u8 buffer[ISCSI_HDR_LEN], opcode;
> 

This one is 48 bytes.  If I could keep anyone statically allocated it
would be this one.

> 
> 17) potential race in iscsi_create_connection():
> 
> +       if ((atomic_read(&sess->nconn) + 
> atomic_read(&c->connection_count)) >
> 

Will look into this one.

> 
> 18) excessive stack usage:
> 
> +extern int iscsi_free_session (iscsi_session_t *sess)
> +{
> +       int i = 0, j = 0;
> +       iscsi_conn_t *conn, *conn_next = NULL;
> +       iscsi_conn_t *conn_array[ISCSI_MAX_CONNECTIONS];
> 

Will change to dynamically allocated memory.

> 
> 19) ditto:
> 
> +extern int iscsi_stop_session (iscsi_session_t *sess, int 
> session_sleep, int co
> nnection_sleep)
> +{
> +       int i = 0, j = 0;
> +       iscsi_conn_t *conn, *conn_next = NULL;
> +       iscsi_conn_t *conn_array[ISCSI_MAX_CONNECTIONS];
> 

Will change to dynamically allocated memory.

> 
> 
> 20) numerous code bloat, by checking for NULL before calling kfree():
> 
> +               if (c)
> +                       kfree(c);
> 
> kfree(NULL) is ok.
> 

Ok, will spend time going through and replacing this.

> 
> 21) delete FULL_PARAMS_COUNT constant, use ARRAY_SIZE() macro in 
> linux/kernel.h
> 

Ok.

> 
> 22) excessive stack usage:
> 
> +static int iscsi_setup_full_params (iscsi_channel_t *c)
> +{
> +       unsigned char buf[512];
> 

Will change to dynamically allocated memory.

> 
> 23) ditto:
> 
> +extern int iscsi_init_channel (iscsi_channel_t *channel, u32 
> max_sectors, int f
> ull_init)
> +{
> +       unsigned char buf[512];
> 
> 

Will change to dynamically allocated memory.

> 
> I stopped reading at this point.
> 
> In general,
> 
> a) locking is completely unreviewable, incomprehensible and 
> unmaintainable by anyone except the author(s).  Either a locking 
> rewrite, or a locking proof document, is needed.
> 

I can spend time working on a document that outlines the important locks
in iscsi_cmd_t, iscsi_conn_t, iscsi_session_t and iscsi_channel_t in
order to give reviewers a clearer idea of how locking is handled.  Also
a better explanation of the limitiations of disabling hard interrupts
with struct Scsi_Host->host_lock as it applies to the iSCSI Initiator
Core can be included.

> b) aside from locking, stack usage, and leaks on error, the code seems 
> reasonably clean.
> 

Thanks for your input!!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

