From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] cxgb4i v5: iscsi driver
Date: Wed, 11 Aug 2010 13:37:31 -0500
Message-ID: <4C62EDEB.3030007@cs.wisc.edu>
References: <201008091753.o79HrTmr020149@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201008091753.o79HrTmr020149@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rranjan@chelsio.com, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

On 08/09/2010 12:53 PM, kxie@chelsio.com wrote:
> +
> +static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
> +{
> +	struct cxgbi_device *cdev;
> +	struct port_info *pi;
> +	int i, rc;
> +
> +	cxgb4i_log_info("%s", version);
> +
> +	cdev = cxgbi_device_register(sizeof(*lldi), lldi->nports);
> +	if (!cdev) {
> +		cxgb4i_log_info("t4 device 0x%p, register failed.\n", lldi);
> +		return NULL;
> +	}
> +	cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +			"t4 0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr %u.\n",
> +			cdev, lldi->adapter_type, lldi->nports,
> +			lldi->ports[0]->name, lldi->nchan, lldi->ntxq,
> +			lldi->nrxq, lldi->wr_cred);
> +	for (i = 0; i<  lldi->nrxq; i++)
> +			cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +				"t4 0x%p, rxq id #%d: %u.\n",
> +				cdev, i, lldi->rxq_ids[i]);
> +
> +	memcpy(cxgbi_cdev_priv(cdev), lldi, sizeof(*lldi));
> +	cdev->flags = CXGBI_FLAG_DEV_T4;
> +	cdev->pdev = lldi->pdev;
> +	cdev->ports = lldi->ports;
> +	cdev->nports = lldi->nports;
> +	cdev->mtus = lldi->mtus;
> +	cdev->nmtus = NMTUS;
> +	cdev->snd_win = cxgb4i_snd_win;
> +	cdev->rcv_win = cxgb4i_rcv_win;
> +	cdev->rx_credit_thres = cxgb4i_rx_credit_thres;
> +	cdev->skb_tx_rsvd = CXGB4I_TX_HEADER_LEN;
> +	cdev->skb_rx_extra = sizeof(struct cpl_iscsi_hdr);
> +	cdev->itp =&cxgb4i_iscsi_transport;
> +
> +	rc = cxgbi_iscsi_init(cdev);
> +	if (rc) {
> +		cxgb4i_log_info("t4 0x%p iscsi init failed\n", cdev);
> +		goto err_out;
> +	}

For each LLD (cxgb3i and cxgb4i) could it get called more than once? I 
mean if you had multiple cxgb3i HBAs could it get called once for each 
or is it called just once time for all cxgb3i hbas? If more than once 
the cxgbi_iscsi_init call to iscsi_register_transport would fail on the 
second call, because the iscsi class would not allow you to register the 
same transport twice.
