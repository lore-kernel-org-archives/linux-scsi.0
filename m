From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] iscsi: Use struct scsi_lun in iscsi structs instead of
 u8[8]
Date: Fri, 17 Jun 2011 14:38:07 +0200
Message-ID: <20110617143807.485b7e35@stein>
References: <1308265029-32337-1-git-send-email-agrover@redhat.com>
	<4DFAECB2.2010107@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60830 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab1FQMiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2011 08:38:18 -0400
In-Reply-To: <4DFAECB2.2010107@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, Eddie Wai <eddie.wai@broadcom.com>

On Jun 17 Ankit Jain wrote:
> On 06/17/2011 04:27 AM, Andy Grover wrote:
> > --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > @@ -430,7 +430,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
> >  	default:
> >  		tmfabort_wqe->ref_itt = RESERVED_ITT;
> >  	}
> > -	memcpy(scsi_lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
> > +	memcpy(scsi_lun, &tmfabort_hdr->lun, sizeof(struct scsi_lun));
> >  	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
> >  	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
> >  
> > @@ -547,7 +547,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
> >  
> >  	nopout_wqe->op_code = nopout_hdr->opcode;
> >  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
> > -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
> > +	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);
> 
> Should you be using "sizeof (..)" here (and similar instances), rather
> than 8? It is being done that way in other instances and it would be
> better practice, IMHO.

sizeof or not sizeof is the least of the coding style issues in drivers/scsi/bnx2i/.
Exhibit one from 57xx_iscsi_hsi.h:

struct bnx2i_nop_out_request {
#if defined(__BIG_ENDIAN)
[...]
#elif defined(__LITTLE_ENDIAN)
[...]
#endif

This kind of coding leads to obfuscated CPU accessors to DMA data/ on the wire data.
If a structure for on-the-wire contains a bitfield (e.g. a 32 bits wide bitfield),
just use __be... or __le... data types (e.g. __be32 or __le32) as required by the
device or protocol.  When the CPU needs to read and write certain bits and bytes in
the word, use the usual cpu_to_... and ..._to_cpu accessors on the entire bitfield,
plus CPU-side shifts and masks.

The end result should be obvious to the reader of the code, and intrinsically clean
in a CF="-D__CHECK_ENDIAN__" run of make.

Did nobody ask about that when this code was staged for merge into 2.6.31?

Hard to tell at a first glance whether the introduction of struct scsi_lun into the
mix makes this code better or worse.
-- 
Stefan Richter
-=====-==-== -==- =---=
http://arcgraph.de/sr/
