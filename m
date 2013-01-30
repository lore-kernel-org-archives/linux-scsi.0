From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [scsi:for-next 23/27] drivers/scsi/fnic/fnic_scsi.c:1260
 fnic_rport_exch_reset() error: we previously assumed 'sc->device' could be
 null (see line 1237)
Date: Wed, 30 Jan 2013 00:12:55 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B128919436@xmb-rcd-x08.cisco.com>
References: <20121217134920.GP5083@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:4122 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A3AWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 19:22:42 -0500
In-Reply-To: <20121217134920.GP5083@mwanda>
Content-Language: en-US
Content-ID: <F518075452D5D14E9C0131B7E79583E8@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <JBottomley@Parallels.com>, "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kbuild@01.org" <kbuild@01.org>

Hi Dan,

I have fixed the new smatch warnings which was introduced by fnic update
patches and resubmitted new patches.

Thanks,
Hiral

On 12/17/12 5:49 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>[ It doesn't make sense to check for NULL, print an error and then
>  dereference the pointer.  The normal Oops message is easy to debug
>  without the extra code added here.  Or maybe it is possible for
>  the pointer to be NULL in that case we should handle it
>  correctly. ]
>
>Hi Hiral,
>
>FYI, there are new smatch warnings show up in
>
>tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>for-next
>head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
>commit: 188061001ac78b40780af042dd2156e2213e29ed [23/27] [SCSI]
>fnic:fixing issues in device and firmware reset code
>
>  drivers/scsi/fnic/fnic_scsi.c:404 fnic_queuecommand_lck() error:
>potential NULL dereference 'rport'.
>  drivers/scsi/fnic/fnic_scsi.c:303 fnic_queue_wq_copy_desc() error:
>potential NULL dereference 'rport'.
>+ drivers/scsi/fnic/fnic_scsi.c:1260 fnic_rport_exch_reset() error: we
>previously assumed 'sc->device' could be null (see line 1237)
>+ drivers/scsi/fnic/fnic_scsi.c:1325 fnic_terminate_rport_io() error: we
>previously assumed 'sc->device' could be null (see line 1314)
>  drivers/scsi/fnic/fnic_scsi.c:1431 fnic_abort_cmd() error: potential
>NULL dereference 'rport'.
>  drivers/scsi/fnic/fnic_scsi.c:1787 fnic_device_reset() error: potential
>NULL dereference 'rport'.
>
>git remote add scsi
>git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>git remote update scsi
>git checkout 188061001ac78b40780af042dd2156e2213e29ed
>vim +1260 drivers/scsi/fnic/fnic_scsi.c
>
>18806100 Hiral Patel       2012-12-10  1231  		if (io_req->abts_done) {
>18806100 Hiral Patel       2012-12-10  1232  			shost_printk(KERN_ERR,
>fnic->lport->host,
>18806100 Hiral Patel       2012-12-10  1233  			"fnic_rport_exch_reset:
>io_req->abts_done is set "
>18806100 Hiral Patel       2012-12-10  1234  			"state is %s\n",
>18806100 Hiral Patel       2012-12-10  1235
>			fnic_ioreq_state_to_str(CMD_STATE(sc)));
>18806100 Hiral Patel       2012-12-10  1236  		}
>18806100 Hiral Patel       2012-12-10 @1237  		if (sc->device == NULL)
>18806100 Hiral Patel       2012-12-10  1238  			shost_printk(KERN_ERR,
>fnic->lport->host,
>18806100 Hiral Patel       2012-12-10  1239  			"fnic_rport_exch_reset:
>sc->device is null state is "
>18806100 Hiral Patel       2012-12-10  1240  			"%s\n",
>fnic_ioreq_state_to_str(CMD_STATE(sc)));
>18806100 Hiral Patel       2012-12-10  1241
>5df6d737 Abhijeet Joglekar 2009-04-17  1242  		old_ioreq_state =
>CMD_STATE(sc);
>5df6d737 Abhijeet Joglekar 2009-04-17  1243  		CMD_STATE(sc) =
>FNIC_IOREQ_ABTS_PENDING;
>5df6d737 Abhijeet Joglekar 2009-04-17  1244  		CMD_ABTS_STATUS(sc) =
>FCPIO_INVALID_CODE;
>18806100 Hiral Patel       2012-12-10  1245  		if (CMD_FLAGS(sc) &
>FNIC_DEVICE_RESET) {
>18806100 Hiral Patel       2012-12-10  1246  			abt_tag = (tag |
>FNIC_TAG_DEV_RST);
>18806100 Hiral Patel       2012-12-10  1247  			FNIC_SCSI_DBG(KERN_DEBUG,
>fnic->lport->host,
>18806100 Hiral Patel       2012-12-10  1248  			"fnic_rport_exch_reset
>dev rst sc 0x%p\n",
>18806100 Hiral Patel       2012-12-10  1249  			sc);
>18806100 Hiral Patel       2012-12-10  1250  		}
>5df6d737 Abhijeet Joglekar 2009-04-17  1251
>5df6d737 Abhijeet Joglekar 2009-04-17  1252  		BUG_ON(io_req->abts_done);
>5df6d737 Abhijeet Joglekar 2009-04-17  1253
>5df6d737 Abhijeet Joglekar 2009-04-17  1254  		FNIC_SCSI_DBG(KERN_DEBUG,
>fnic->lport->host,
>5df6d737 Abhijeet Joglekar 2009-04-17  1255  			
>"fnic_rport_reset_exch: Issuing abts\n");
>5df6d737 Abhijeet Joglekar 2009-04-17  1256
>5df6d737 Abhijeet Joglekar 2009-04-17  1257
>		spin_unlock_irqrestore(io_lock, flags);
>5df6d737 Abhijeet Joglekar 2009-04-17  1258
>5df6d737 Abhijeet Joglekar 2009-04-17  1259  		/* Now queue the abort
>command to firmware */
>5df6d737 Abhijeet Joglekar 2009-04-17 @1260
>		int_to_scsilun(sc->device->lun, &fc_lun);
>5df6d737 Abhijeet Joglekar 2009-04-17  1261
>18806100 Hiral Patel       2012-12-10  1262  		if
>(fnic_queue_abort_io_req(fnic, abt_tag,
>5df6d737 Abhijeet Joglekar 2009-04-17  1263  					
>FCPIO_ITMF_ABT_TASK_TERM,
>5df6d737 Abhijeet Joglekar 2009-04-17  1264  					    fc_lun.scsi_lun,
>io_req)) {
>5df6d737 Abhijeet Joglekar 2009-04-17  1265  			/*
>5df6d737 Abhijeet Joglekar 2009-04-17  1266  			 * Revert the cmd state
>back to old state, if
>25985edc Lucas De Marchi   2011-03-30  1267  			 * it hasn't changed in
>between. This cmd will get
>5df6d737 Abhijeet Joglekar 2009-04-17  1268  			 * aborted later by
>scsi_eh, or cleaned up during
>5df6d737 Abhijeet Joglekar 2009-04-17  1269  			 * lun reset
>5df6d737 Abhijeet Joglekar 2009-04-17  1270  			 */
>5df6d737 Abhijeet Joglekar 2009-04-17  1271
>			spin_lock_irqsave(io_lock, flags);
>5df6d737 Abhijeet Joglekar 2009-04-17  1272  			if (CMD_STATE(sc) ==
>FNIC_IOREQ_ABTS_PENDING)
>5df6d737 Abhijeet Joglekar 2009-04-17  1273  				CMD_STATE(sc) =
>old_ioreq_state;
>5df6d737 Abhijeet Joglekar 2009-04-17  1274
>			spin_unlock_irqrestore(io_lock, flags);
>18806100 Hiral Patel       2012-12-10  1275  		} else {
>18806100 Hiral Patel       2012-12-10  1276
>			spin_lock_irqsave(io_lock, flags);
>18806100 Hiral Patel       2012-12-10  1277  			CMD_FLAGS(sc) |=
>FNIC_DEV_RST_TERM_ISSUED;
>18806100 Hiral Patel       2012-12-10  1278
>			spin_unlock_irqrestore(io_lock, flags);
>5df6d737 Abhijeet Joglekar 2009-04-17  1279  		}
>5df6d737 Abhijeet Joglekar 2009-04-17  1280  	}
>5df6d737 Abhijeet Joglekar 2009-04-17  1281
>5df6d737 Abhijeet Joglekar 2009-04-17  1282  }
>5df6d737 Abhijeet Joglekar 2009-04-17  1283
>5df6d737 Abhijeet Joglekar 2009-04-17  1284  void
>fnic_terminate_rport_io(struct fc_rport *rport)
>5df6d737 Abhijeet Joglekar 2009-04-17  1285  {
>5df6d737 Abhijeet Joglekar 2009-04-17  1286  	int tag;
>18806100 Hiral Patel       2012-12-10  1287  	int abt_tag;
>5df6d737 Abhijeet Joglekar 2009-04-17  1288  	struct fnic_io_req *io_req;
>5df6d737 Abhijeet Joglekar 2009-04-17  1289  	spinlock_t *io_lock;
>5df6d737 Abhijeet Joglekar 2009-04-17  1290  	unsigned long flags;
>5df6d737 Abhijeet Joglekar 2009-04-17  1291  	struct scsi_cmnd *sc;
>5df6d737 Abhijeet Joglekar 2009-04-17  1292  	struct scsi_lun fc_lun;
>5df6d737 Abhijeet Joglekar 2009-04-17  1293  	struct fc_rport_libfc_priv
>*rdata = rport->dd_data;
>5df6d737 Abhijeet Joglekar 2009-04-17  1294  	struct fc_lport *lport =
>rdata->local_port;
>5df6d737 Abhijeet Joglekar 2009-04-17  1295  	struct fnic *fnic =
>lport_priv(lport);
>5df6d737 Abhijeet Joglekar 2009-04-17  1296  	struct fc_rport *cmd_rport;
>5df6d737 Abhijeet Joglekar 2009-04-17  1297  	enum fnic_ioreq_state
>old_ioreq_state;
>5df6d737 Abhijeet Joglekar 2009-04-17  1298
>5df6d737 Abhijeet Joglekar 2009-04-17  1299  	FNIC_SCSI_DBG(KERN_DEBUG,
>5df6d737 Abhijeet Joglekar 2009-04-17  1300  		      fnic->lport->host,
>"fnic_terminate_rport_io called"
>18806100 Hiral Patel       2012-12-10  1301  		      " wwpn 0x%llx,
>wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
>18806100 Hiral Patel       2012-12-10  1302  		      rport->port_name,
>rport->node_name, rport,
>5df6d737 Abhijeet Joglekar 2009-04-17  1303  		      rport->port_id);
>5df6d737 Abhijeet Joglekar 2009-04-17  1304
>5df6d737 Abhijeet Joglekar 2009-04-17  1305  	if (fnic->in_remove)
>5df6d737 Abhijeet Joglekar 2009-04-17  1306  		return;
>5df6d737 Abhijeet Joglekar 2009-04-17  1307
>5df6d737 Abhijeet Joglekar 2009-04-17  1308  	for (tag = 0; tag <
>FNIC_MAX_IO_REQ; tag++) {
>18806100 Hiral Patel       2012-12-10  1309  		abt_tag = tag;
>5df6d737 Abhijeet Joglekar 2009-04-17  1310  		sc =
>scsi_host_find_tag(fnic->lport->host, tag);
>5df6d737 Abhijeet Joglekar 2009-04-17  1311  		if (!sc)
>5df6d737 Abhijeet Joglekar 2009-04-17  1312  			continue;
>5df6d737 Abhijeet Joglekar 2009-04-17  1313
>18806100 Hiral Patel       2012-12-10 @1314  		if (sc->device == NULL)
>18806100 Hiral Patel       2012-12-10  1315  			shost_printk(KERN_ERR,
>fnic->lport->host,
>18806100 Hiral Patel       2012-12-10  1316  			"fnic_terminate_rport_io:
>sc->device is null "
>18806100 Hiral Patel       2012-12-10  1317  			"state is %s tag is %d\n",
>18806100 Hiral Patel       2012-12-10  1318
>			fnic_ioreq_state_to_str(CMD_STATE(sc)), tag);
>18806100 Hiral Patel       2012-12-10  1319  		else if
>(sc->device->sdev_gendev.parent == NULL)
>18806100 Hiral Patel       2012-12-10  1320  			shost_printk(KERN_ERR,
>fnic->lport->host,
>18806100 Hiral Patel       2012-12-10  1321  			"fnic_terminate_rport_io:
>parent is null "
>18806100 Hiral Patel       2012-12-10  1322  			"state is %s  tag is
>%d\n",
>18806100 Hiral Patel       2012-12-10  1323
>			fnic_ioreq_state_to_str(CMD_STATE(sc)), tag);
>18806100 Hiral Patel       2012-12-10  1324
>5df6d737 Abhijeet Joglekar 2009-04-17 @1325  		cmd_rport =
>starget_to_rport(scsi_target(sc->device));
>5df6d737 Abhijeet Joglekar 2009-04-17  1326  		if (rport != cmd_rport)
>5df6d737 Abhijeet Joglekar 2009-04-17  1327  			continue;
>5df6d737 Abhijeet Joglekar 2009-04-17  1328
>
>---
>0-DAY kernel build testing backend         Open Source Technology Center
>Fengguang Wu, Yuanhan Liu                              Intel Corporation

