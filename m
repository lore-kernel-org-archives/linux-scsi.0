From: "Karen Xie" <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 2/3] cxgb4i v5: iscsi driver
Date: Wed, 11 Aug 2010 13:17:07 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33408403C5F@maui.asicdesigners.com>
References: <201008091753.o79HrTmr020149@localhost.localdomain> <4C62EDEB.3030007@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCNvLk8fsDxDjjIzjBBoEjuupQA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-class: urn:content-classes:message
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rakesh Ranjan <rakesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Yes, you are right. I will fix it to make sure iscsi transport
registration happens only once.
Thanks,
Karen

-----Original Message-----
From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org] 
Sent: Wednesday, August 11, 2010 11:38 AM
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Karen Xie; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
Rakesh Ranjan; James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Subject: Re: [PATCH 2/3] cxgb4i v5: iscsi driver

On 08/09/2010 12:53 PM, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org wrote:
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
> +		cxgb4i_log_info("t4 device 0x%p, register failed.\n",
lldi);
> +		return NULL;
> +	}
> +	cxgb4i_log_debug(1<<  CXGBI_DBG_DEV,
> +			"t4 0x%p,0x%x, ports %u,%s, chan %u, q %u,%u, wr
%u.\n",
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

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
