From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 3/7] [SCSI] scst: Add scst_local driver.
Date: Tue, 28 Dec 2010 13:51:19 -0500
Message-ID: <201012281351.20087.konrad@darnok.org>
References: <201012201849.03930.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:52208 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0L1V47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 16:56:59 -0500
In-Reply-To: <201012201849.03930.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, realrichardsharpe@gmail.com

On Monday 20 
> +#define TRUE 1
> +#define FALSE 0

can't you use 'true' or 'false'?
.. snip..
> +static int scst_local_get_sas_transport_id(struct scst_local_sess *sess,
> +	uint8_t **transport_id, int *len)
> +{
> +	int res = 0;
> +	int tr_id_size = 0;
> +	uint8_t *tr_id = NULL;
> +
> +	tr_id_size = 24;  /* A SAS TransportID */
> +
> +	tr_id = kzalloc(tr_id_size, GFP_KERNEL);
> +	if (tr_id == NULL) {
> +		PRINT_ERROR("Allocation of TransportID (size %d) failed",
> +			tr_id_size);

pr_err? Or is this based on a module parameter?

> +		res = -ENOMEM;
> +		goto out;
> +	}
> +
> +	tr_id[0] = 0x00 | SCSI_TRANSPORTID_PROTOCOLID_SAS;

Hmm, why the 0x00? Can't you just do an assigment?

