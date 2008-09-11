From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
	interface
Date: Thu, 11 Sep 2008 11:32:35 +0200
Message-ID: <20080911093234.GA4762@schmichrtp.de.ibm.com>
References: <0C1F2063-A090-4E57-AAFC-C74B32B43BD5@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:46501 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYIKJc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2008 05:32:59 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id m8B9WuV6018936
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 09:32:56 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8B9Wtuu2764900
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 11:32:56 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8B9Wpo0005706
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2008 11:32:52 +0200
Content-Disposition: inline
In-Reply-To: <0C1F2063-A090-4E57-AAFC-C74B32B43BD5@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James.Smart@Emulex.Com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>, Sven Schuetz <sven@linux.vnet.ibm.com>

On Wed, Sep 10, 2008 at 07:04:01AM -0700, Seokmann Ju wrote:

[...]
> +struct fc_frame_header {
> +	__u8          fh_r_ctl;	/* routing control */
> +	__u8          fh_d_id[3];	/* Destination ID */
> +
> +	__u8          fh_cs_ctl;	/* class of service control / pri */
> +	__u8          fh_s_id[3];	/* Source ID */
> +
> +	__u8          fh_type;		/* see enum fc_fh_type below */
> +	__u8          fh_f_ctl[3];	/* frame control */
> +
> +	__u8          fh_seq_id;	/* sequence ID */
> +	__u8          fh_df_ctl;	/* data field control */
> +	__be16        fh_seq_cnt;	/* sequence count */
> +
> +	__be16        fh_ox_id;		/* originator exchange ID */
> +	__be16        fh_rx_id;		/* responder exchange ID */
> +	__be32        fh_parm_offset;	/* parameter or relative offset */
> +};
> +
> +/* TBD - fc_els_hdr to move to ~/include/scsi/fc/fc_els.h */
> +struct fc_els_hdr {
> +	__u8	els_cmd;
> +	__u8	els_param[3];
> +};
> +
> +/* NOTE - fc_ct_hdr is already defined in open-fcoe-upstream branch */
> +/*
> + * Fibre Channel Services - Common Transport.
> + * From T11.org FC-GS-2 Rev 5.3 November 1998.
> + */
> +
> +struct fc_ct_hdr {
> +	__u8		ct_rev;		/* revision */
> +	__u8		ct_in_id[3];	/* N_Port ID of original requestor */
> +	__u8		ct_fs_type;	/* type of fibre channel service */
> +	__u8		ct_fs_subtype;	/* subtype */
> +	__u8		ct_options;
> +	__u8		_ct_resvd1;
> +	__be16		ct_cmd;		/* command / response code */
> +	__be16		ct_mr_size;	/* maximum / residual size */
> +	__u8		_ct_resvd2;
> +	__u8		ct_reason;	/* reject reason */
> +	__u8		ct_explan;	/* reason code explanation */
> +	__u8		ct_vendor;	/* vendor unique data */
> +};
> +
> +struct fc_els_frame {
> +	struct fc_frame_header fc_hdr;
> +	struct fc_els_hdr els_hdr;
> +	u32 els_cmd[4];
> +};
> +
> +struct fc_ct_frame {
> +	struct fc_frame_header fc_hdr;
> +	struct fc_ct_hdr ct_hdr;
> +	u32 ct_cmd[1];
> +};

I was just reading he patch and i am wondering why the fc_frame_header
is included here. There was a discussion in August and the conclusion
was to only include the common ct_hdr in the LLD interface:

http://marc.info/?t=121908849700001&r=1&w=2

The zfcp driver does not care about the FC headers, this is hidden in
the System z FCP HBA. I would prefer that the interface to the LLD
does not include the frame_header, otherwise userspace would fill the
frame_header and zfcp would simply discard it.

Christof
