From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 12 Dec 2003 20:59:34 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312122059.34248.krmurthy@cisco.com>
References: <200312112117.46216.krmurthy@cisco.com> <20031212124854.GH27116@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_ADGSOFIC5ZABK8VGMKJ5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:51244 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S265243AbTLLP3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 10:29:46 -0500
In-Reply-To: <20031212124854.GH27116@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI -DEVEL <linux-scsi@vger.kernel.org>, davmyers@cisco.com


--------------Boundary-00=_ADGSOFIC5ZABK8VGMKJ5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,
=09Please find code  attached.
Thanx
N.C.Krishna Murthy
On Friday 12 Dec 2003 6:18 pm, Matthew Wilcox wrote:
> On Thu, Dec 11, 2003 at 09:17:46PM +0530, N.C.Krishna Murthy wrote:
> > Hi,
> > =09One of your comments was
> > "having multiple kmap() in the same process at the same time can
> > deadlock(), you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_d=
ata
> > not to do that. for the tx path use ->sendpage to avoid a data copy a=
nd
> > kmapping altogether".
> >
> > I did try using sendpage in iscsi_xmit_data.
> > Whenever the scatterlist->length was 4096 sendpage did succeed.
> > When it was 8192 I did see a panic
>
> could you post the code for that?

--------------Boundary-00=_ADGSOFIC5ZABK8VGMKJ5
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="code-drop"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="code-drop"


void
iscsi_xmit_data(struct iscsi_task *task, uint32_t ttt, uint32_t data_offset,
		uint32_t data_length)
{
	struct msghdr msg;
	struct IscsiDataHdr stdh;
	Scsi_Cmnd *sc = NULL;
	struct iscsi_session *session = task->session;
	struct scatterlist *sglist = NULL, *sg = NULL, *first_sg = NULL, *last_sg = NULL;
	int wlen, rc, iovn = 0, first_data_iovn = 0;
	unsigned int segment_offset = 0, index = 0;
	int remain, xfrlen;
	uint32_t data_sn = 0;
	int bytes_to_fill, bytes_from_segment;
	char padding[4];
	int pad_bytes;
	uint32_t header_crc32c;
	uint32_t data_crc32c;

	/* This is a TEST code intended to test sendpage.
	 *   I ENSURE THAT HeaderDigest and DataDigest are not used.
	 * I also ensure that padbytes are not required.
	 */
	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);

	printk("%s Entry for data length of %d \n",__FUNCTION__,data_length);

	sc = task->scsi_cmnd;
	/* make sure we have data to send when we expect to */
	if (sc && (iscsi_expected_data_length(sc) == 0)
	    && ((sc->request_bufflen == 0) || (sc->request_buffer == NULL))) {
		printk
		    ("iSCSI: xmit_data for itt %u, sc 0x%x, dlength %u, "
		     "expected %u, no data in buffer\n"
		     "       request_buffer %p len %u, buffer %p len %u\n",
		     task->itt, sc->cmnd[0], data_length,
		     iscsi_expected_data_length(sc), sc->request_buffer,
		     sc->request_bufflen, sc->buffer, sc->bufflen);
		print_cmnd(sc);
		return;
	}

	remain = data_length;
	if (sc == NULL)
		remain = 0;

	memset(&stdh, 0, sizeof (stdh));
	stdh.opcode = ISCSI_OP_SCSI_DATA;
	stdh.itt = htonl(task->itt);
	stdh.ttt = ttt;
	stdh.offset = htonl(data_offset);

	/* PDU header */
	session->tx_iov[0].iov_base = &stdh;
	session->tx_iov[0].iov_len = sizeof (stdh);


	DEBUG_FLOW("iSCSI: xmit_data for itt %u, credit %d @ %u\n"
		   "       request_buffer %p len %u, buffer %p len %u\n",
		   task->itt, remain, data_offset,
		   sc->request_buffer, sc->request_bufflen, sc->buffer,
		   sc->bufflen);

	/* Find the segment and offset within the segment to 
	 * start writing from.  
	 */
	if (sc && sc->use_sg) {
		sg = sglist = (struct scatterlist *) sc->request_buffer;

		segment_offset = data_offset;

		for (index = 0; index < sc->use_sg; index++) {
			if (segment_offset < sglist[index].length)
				break;
			else
				segment_offset -= sglist[index].length;
		}

		if (index >= sc->use_sg) {
			/* didn't find the offset, command will 
			 * eventually timeout 
			 */
			printk
			    ("iSCSI: session iscsi bus %d target id %d "
			     "xmit_data for itt %u couldn't find offset %u "
			     "in sglist %p, sc %p, bufflen %u, use_sg %u\n",
			     session->iscsi_bus, session->target_id, task->itt,
			     data_offset, sglist, sc, sc->request_bufflen,
			     sc->use_sg);
			print_cmnd(sc);
			ISCSI_TRACE(ISCSI_TRACE_OutOfData, sc, task, index,
				    sc->use_sg);
			return;
		}
	}

	ISCSI_TRACE(ISCSI_TRACE_TxData, sc, task, data_offset, data_length);

	do {
		if (signal_pending(current))
			break;

#if (INVALID_ORDERING_ASSUMPTIONS == 0)
		/* since this loop may take a while, check 
		 * for TIMEDOUT tasks and commands 
		 */
		/* Note: this means a task may have a non-zero 
		 * refcount during timeout processing 
		 */
		if (test_bit(SESSION_TASK_TIMEDOUT, &session->control_bits)) {
			process_timedout_tasks(session);
		}
		if (test_bit(SESSION_COMMAND_TIMEDOUT, &session->control_bits)) {
			process_timedout_commands(session);
		}

		/* also queue up command retries */
		if (test_and_clear_bit
		    (SESSION_RETRY_COMMANDS, &session->control_bits)) {
			/* try to queue up delayed commands for retries */
			iscsi_retry_commands(session);
		}

		/* if command PDUs are small (no immediate data),
		 * start commands as soon as possible, so that we can
		 * overlap the R2T latency with the time it takes to
		 * send data for commands already issued.  This increases 
		 * throughput without significantly increasing the completion 
		 * time of commands already issued.  Some broken targets
		 * such as the one by Intel Labs will choke if they receive
		 * another command before they get all of the data for preceding
		 * commands, so this can be conditionally compiled out.
		 */
		if (!session->ImmediateData) {
			DEBUG_FLOW
			    ("iSCSI: checking for new commands before "
			     "sending data to %s\n",
			     session->log_name);
			iscsi_xmit_queued_cmnds(session);
		}
#endif

		iovn = 1;
		wlen = sizeof (stdh);
		if (session->HeaderDigest == ISCSI_DIGEST_CRC32C) {
			/* we'll need to send a digest, 
			 * but can't compute it yet 
			 */
			session->tx_iov[1].iov_base = &header_crc32c;
			session->tx_iov[1].iov_len = sizeof (header_crc32c);
			iovn = 2;
			wlen += sizeof (header_crc32c);
		}

		first_data_iovn = iovn;

		stdh.datasn = htonl(data_sn++);
		stdh.offset = htonl(data_offset);
		stdh.expstatsn = htonl(session->ExpStatSn);

		if (session->MaxXmitDataSegmentLength
		    && (remain > session->MaxXmitDataSegmentLength)) {
			/* enforce the target's data segment limit */
			bytes_to_fill = session->MaxXmitDataSegmentLength;
		} else {
			/* final PDU of a data burst */
			bytes_to_fill = remain;
			stdh.flags = ISCSI_FLAG_FINAL;
		}

		/* check if we need to pad the PDU */
		if (bytes_to_fill % PAD_WORD_LEN) {
			pad_bytes =
			    PAD_WORD_LEN - (bytes_to_fill % PAD_WORD_LEN);
			memset(padding, 0x0, sizeof (padding));
		} else {
			pad_bytes = 0;
		}

		DEBUG_FLOW
		    ("iSCSI: remain %d, bytes_to_fill %d, "
		     "sc->use_sg %u, MaxRecvDataSegmentLength %d\n",
		     remain, bytes_to_fill, sc->use_sg,
		     session->MaxRecvDataSegmentLength);

		xfrlen = 0;

		if (sc) {
			/* find all the PDU data */
			if (sc->use_sg) {
				/* while there is more data and 
				 * we want to send more data 
				 */
				while (bytes_to_fill > 0) {

					if (index >= sc->use_sg) {
						printk
						    ("iSCSI: session iscsi bus "
						     "%d target id %d xmit_data"
						     " index %d exceeds "
						     "sc->use_sg %d, "
						     "bytes_to_fill %d, "
						     "out of buffers\n",
						     session->iscsi_bus,
						     session->target_id, index,
						     sc->use_sg, bytes_to_fill);
						/* the command will eventually 
						 * timeout 
						 */
						print_cmnd(sc);
						ISCSI_TRACE
						    (ISCSI_TRACE_OutOfData, sc,
						     task, index, sc->use_sg);
						goto done;
					}
					if (signal_pending(current)) {
						DEBUG_FLOW
						    ("iSCSI: session iscsi bus "
						     "%d target id %d signal "
						     "pending, returning from "
						     "xmit_data\n",
						     session->iscsi_bus,
						     session->target_id);
						goto done;
					}

					sg = &sglist[index];


					if (first_sg == NULL) {
						first_sg = sg;
					}
					last_sg = sg;

					/* sanity check the sglist 
					 * segment length 
					 */
					if (sg->length <= segment_offset) {
						/* the sglist is corrupt */
						printk
						    ("iSCSI: session iscsi bus "
						     "%d target id %d xmit_data"
						     " index %d, length %u too "
						     "small for offset %u, "
						     "bytes_to_fill %d, sglist "
						     "has been corrupted\n",
						     session->iscsi_bus,
						     session->target_id, index,
						     sg->length, segment_offset,
						     bytes_to_fill);
						/* the command will eventually 
						 * timeout 
						 */
						print_cmnd(sc);
						ISCSI_TRACE
						    (ISCSI_TRACE_BadTxSeg, sc,
						     task, sg->length,
						     segment_offset);
						goto done;
					}

					bytes_from_segment =
					    sg->length - segment_offset;
					if (bytes_from_segment > bytes_to_fill) {
						/* only need part of 
						 * this segment 
						 */
						session->tx_iov[iovn].iov_base =
						 (unsigned char *)  segment_offset;
						session->tx_iov[iovn].iov_len =
						    bytes_to_fill;
						xfrlen += bytes_to_fill;
						printk
						    ("iSCSI: session iscsi bus "
						     "%d target id %d xmit_data"
						     " xfrlen %d, to_fill %d, "
						     "from_segment %d, iov[%2d]"
						     " = partial sg[%2d]\n",
						     session->iscsi_bus,
						     session->target_id, xfrlen,
						     bytes_to_fill,
						     bytes_from_segment, iovn,
						     index);
						iovn++;
						segment_offset += bytes_to_fill;
						break;
					} else {
						/* need all of this segment, and
						 * possibly more from the next 
						 */
						session->tx_iov[iovn].iov_base =
						   (unsigned char *) segment_offset;
						session->tx_iov[iovn].iov_len =
						    bytes_from_segment;
		
						xfrlen += bytes_from_segment;
						printk
						    ("iSCSI: session iscsi bus "
						     "%d target id %d xmit_data"
						     " xfrlen %d, to_fill %d, "
						     "from_segment %d, iov[%2d]"
						     " = sg[%2d]\n",
						     session->iscsi_bus,
						     session->target_id, xfrlen,
						     bytes_to_fill,
						     bytes_from_segment, iovn,
						     index);
						bytes_to_fill -=
						    bytes_from_segment;
						iovn++;
						/* any remaining data starts at 						 * offset 0 of the next segment
						 */
						index++;
						segment_offset = 0;
					}
				}

				if (xfrlen <= 0) {
					printk
					    ("iSCSI: session iscsi bus %d "
					     "target id %d xmit_data picked "
					     "xfrlen of 0, sc->use_sg %d, "
					     "bytes_to_fill %d\n",
					     session->iscsi_bus,
					     session->target_id, sc->use_sg,
					     bytes_to_fill);
					iscsi_drop_session(session);
					goto done;
				}
			} else {
				/* no scatter-gather */
				if ((sc->request_buffer + data_offset +
				     bytes_to_fill) <=
				    (sc->request_buffer +
				     sc->request_bufflen)) {
					/* send all the data */
					session->tx_iov[iovn].iov_base =
					    sc->request_buffer + data_offset;
					session->tx_iov[iovn].iov_len = xfrlen =
					    bytes_to_fill;
					iovn++;
				} else if ((sc->request_buffer + data_offset) <
					   (sc->request_buffer +
					    sc->request_bufflen)) {
					/* send some data, but can't send all 
					 * requested 
					 */
					xfrlen =
					    sc->request_bufflen - data_offset;
					printk
					    ("iSCSI: xmit_data ran out of data,"
					     " buffer %p len %u but offset %d "
					     "length %d, sending final %d "
					     "bytes\n",
					     sc->request_buffer,
					     sc->request_bufflen, data_offset,
					     bytes_to_fill, xfrlen);
					session->tx_iov[iovn].iov_base =
					    sc->request_buffer + data_offset;
					session->tx_iov[iovn].iov_len = xfrlen;
					iovn++;
					stdh.flags = ISCSI_FLAG_FINAL;
					remain = xfrlen;
				} else {
					/* can't send any data */
					printk
					    ("iSCSI: xmit_data ran out of data,"
					     " buffer %p len %u but offset %d "
					     "length %d, sending no more "
					     "data\n",
					     sc->request_buffer,
					     sc->request_bufflen, data_offset,
					     bytes_to_fill);
					goto done;
				}
			}
			if (pad_bytes) {
				session->tx_iov[iovn].iov_base = padding;
				session->tx_iov[iovn].iov_len = pad_bytes;
				iovn++;
				wlen += pad_bytes;
			}
		}

		/* put the data length in the PDU header */
		hton24(stdh.dlength, xfrlen);
		wlen += xfrlen;

		/* header complete, we can finally calculate the HeaderDigest */
		if (session->HeaderDigest == ISCSI_DIGEST_CRC32C)
			header_crc32c = iscsi_crc32c(&stdh, sizeof (stdh));

		/* DataDigest */
		if (xfrlen && (session->DataDigest == ISCSI_DIGEST_CRC32C)) {
			int i;

			data_crc32c =
			    iscsi_crc32c(session->tx_iov[first_data_iovn].
					 iov_base,
					 session->tx_iov[first_data_iovn].
					 iov_len);
			for (i = first_data_iovn + 1; i < iovn; i++) {
				data_crc32c =
				    iscsi_crc32c_continued(session->tx_iov[i].
							   iov_base,
							   session->tx_iov[i].
							   iov_len,
							   data_crc32c);
			}

			/* FIXME: this may not be SMP safe, but it's only for 
			 * testing anyway, so it probably doesn't need to be 
			 */
			if (session->fake_write_data_mismatch > 0) {
				session->fake_write_data_mismatch--;
				smp_mb();
				printk
				    ("iSCSI: session iscsi bus %d target id %d "
				     "faking DataDigest mismatch for itt %u\n",
				     session->iscsi_bus, session->target_id,
				     task->itt);
				data_crc32c = 0x01020304;
			}

			session->tx_iov[iovn].iov_base = &data_crc32c;
			session->tx_iov[iovn].iov_len = sizeof (data_crc32c);
			iovn++;
			wlen += sizeof (data_crc32c);
		}

		if (xfrlen && (session->DataDigest == ISCSI_DIGEST_CRC32C)) {
			memset(&msg, 0, sizeof (msg));
			msg.msg_iov = &session->tx_iov[0];
			msg.msg_iovlen = iovn;

			ISCSI_TRACE(ISCSI_TRACE_TxDataPDU, sc, task,
				    data_offset, xfrlen);

			rc = iscsi_sendmsg(session, &msg, wlen);
			if (rc != wlen) {
				printk
				    ("iSCSI: session iscsi bus %d target id %d "
					     "xmit_data failed to send "
					     "%d bytes, rc %d\n",
				     session->iscsi_bus, session->target_id,
				     wlen, rc);
				iscsi_drop_session(session);
				goto done;
			}
		} else {

	/* Send header*/
			memset(&msg, 0, sizeof (msg));
			msg.msg_iov = &session->tx_iov[0];
			msg.msg_iovlen = 1;
                        rc = iscsi_sendmsg(session, &msg, 48);
			/* I have ensured that header and data digest are not
			 *  set. So Send data
			 */
			
			if (first_sg == NULL) {
				memset(&msg, 0, sizeof (msg));
				msg.msg_iov = &session->tx_iov[1];
				msg.msg_iovlen = iovn-1;
			ISCSI_TRACE(ISCSI_TRACE_TxDataPDU, sc, task,
				    data_offset, xfrlen);
				printk("No SG about to use iscsi_sendmsg\n");
				rc = iscsi_sendmsg(session, &msg, 
							wlen - session->tx_iov[0].iov_len);
				if (rc != (wlen - session->tx_iov[0].iov_len)) {
					printk
				    ("iSCSI: session iscsi_bus %d target id %d "
				     "xmit_data failed to send %d bytes, rc "
				     "%d\n", session->iscsi_bus,
				     session->target_id, wlen, rc);
					iscsi_drop_session(session);
					goto done;
				}
			} else {
				iovn = 1;
				for (sg = first_sg; sg <= last_sg ;sg++) {
					printk("About to send page %p,offset %d len %d \n",sg->page,sg->offset+(int)(session->tx_iov[iovn].iov_base),session->tx_iov[iovn].iov_len);
#if 0
					if (session->tx_iov[iovn].iov_len >
					    4096) {
			                        sendpage = sock_no_sendpage;
					}
					else
#endif
						sendpage = session->socket->ops->sendpage;
					rc = sendpage(session->socket,sg->page,sg->offset+(int)(session->tx_iov[iovn].iov_base),session->tx_iov[iovn].iov_len,0);
					printk("return value of sendpage = %d\n",rc);
					iovn++;
				}
			}
		}

		remain -= xfrlen;

		printk
		    ("iSCSI: xmit_data sent %d @ %u for itt %u, "
		     "remaining %d, final %d\n",
		     xfrlen, data_offset, task->itt, remain,
		     stdh.flags & ISCSI_FLAG_FINAL);

		data_offset += xfrlen;
		if (first_sg) {
			first_sg = last_sg = NULL;
		}

	} while (remain);

      done:
}

Log message:
---------------------------------------------------------------------
About to send page c11d0e48,offset 0 len 8192
Dec 12 08:49:24 linux-3 kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000004
-----------------------------------------------------------------------

--------------Boundary-00=_ADGSOFIC5ZABK8VGMKJ5--
