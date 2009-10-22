From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 2/4] scsi_dh: Make rdac hardware handler's activate()
 async
Date: Thu, 22 Oct 2009 17:30:18 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48737424B@cosmail01.lsi.com>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
 <20091021162251.8473.16503.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:34027 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZJVXa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Oct 2009 19:30:28 -0400
In-Reply-To: <20091021162251.8473.16503.sendpatchset@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>

I have tested this patch on LSI rdac storage. It works pretty well..

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Chandra Seetharaman
> Sent: Wednesday, October 21, 2009 11:23 AM
> To: linux-scsi@vger.kernel.org
> Cc: dm-devel@redhat.com; Moger, Babu; michaelc@cs.wisc.edu;
> Benoit_Arthur@emc.com; Eddie.Williams@steeleye.com;
> berthiaume_wayne@emc.com; Chandra Seetharaman
> Subject: [PATCH 2/4] scsi_dh: Make rdac hardware handler's activate()
> async
> 
> Batch up MODE_SELECT in rdac device handler.
> 
> LSI RDAC storage has the capability of handling mode selects for
> multiple luns in a same command. Make use of that ability to send
> as few MODE SELECTs as possible to the storage controller as possible.
> 
> This patch creates a work queue and queues up activate requests
> when a MODE SELECT is sent down the wire. When that MODE SELECT
> completes, it compiles queued up activate requests for multiple
> luns into a single MODE SELECT.
> 
> This reduces the time to do failover/failback of large number of LUNS.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Tested-by: Babu Moger <babu.moger@lsi.com>

> 
> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c |  108
> +++++++++++++++++++++++++++--
>  1 file changed, 100 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
> ===================================================================
> --- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> 	2009-10-20 18:26:14.000000000 -0700
> +++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 10-20 18:26:29.000000000 -0700
> @@ -22,6 +22,7 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dh.h>
> +#include <linux/workqueue.h>
> 
>  #define RDAC_NAME "rdac"
>  #define RDAC_RETRY_COUNT 5
> @@ -138,7 +139,13 @@
>  	} mode_select;
>  	u8	index;
>  	u8	array_name[ARRAY_LABEL_LEN];
> +	spinlock_t		ms_lock;
> +	int			ms_queued;
> +	struct work_struct	ms_work;
> +	struct scsi_device	*ms_sdev;
> +	struct list_head	ms_head;
>  };
> +
>  struct c8_inquiry {
>  	u8	peripheral_info;
>  	u8	page_code; /* 0xC8 */
> @@ -198,8 +205,17 @@
>  	"owned (AVT mode)",
>  };
> 
> +struct rdac_queue_data {
> +	struct list_head	entry;
> +	struct rdac_dh_data	*h;
> +	activate_complete	callback_fn;
> +	void			*callback_data;
> +};
> +
>  static LIST_HEAD(ctlr_list);
>  static DEFINE_SPINLOCK(list_lock);
> +static struct workqueue_struct *kmpath_rdacd;
> +static void send_mode_select(struct work_struct *work);
> 
>  /*
>   * module parameter to enable rdac debug logging.
> @@ -281,7 +297,6 @@
>  		rdac_pg->subpage_code = 0x1;
>  		rdac_pg->page_len[0] = 0x01;
>  		rdac_pg->page_len[1] = 0x28;
> -		rdac_pg->lun_table[h->lun] = 0x81;
>  	} else {
>  		struct rdac_pg_legacy *rdac_pg;
> 
> @@ -291,7 +306,6 @@
>  		common = &rdac_pg->common;
>  		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
>  		rdac_pg->page_len = 0x68;
> -		rdac_pg->lun_table[h->lun] = 0x81;
>  	}
>  	common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
>  	common->quiescence_timeout = RDAC_QUIESCENCE_TIME;
> @@ -325,6 +339,7 @@
>  	struct rdac_controller *ctlr;
>  	ctlr = container_of(kref, struct rdac_controller, kref);
> 
> +	flush_workqueue(kmpath_rdacd);
>  	spin_lock(&list_lock);
>  	list_del(&ctlr->node);
>  	spin_unlock(&list_lock);
> @@ -363,6 +378,11 @@
> 
>  	kref_init(&ctlr->kref);
>  	ctlr->use_ms10 = -1;
> +	ctlr->ms_queued = 0;
> +	ctlr->ms_sdev = NULL;
> +	spin_lock_init(&ctlr->ms_lock);
> +	INIT_WORK(&ctlr->ms_work, send_mode_select);
> +	INIT_LIST_HEAD(&ctlr->ms_head);
>  	list_add(&ctlr->node, &ctlr_list);
>  done:
>  	spin_unlock(&list_lock);
> @@ -490,7 +510,7 @@
>  }
> 
>  static int mode_select_handle_sense(struct scsi_device *sdev,
> -				    unsigned char *sensebuf)
> +					unsigned char *sensebuf)
>  {
>  	struct scsi_sense_hdr sense_hdr;
>  	int err = SCSI_DH_IO, ret;
> @@ -533,11 +553,29 @@
>  	return err;
>  }
> 
> -static int send_mode_select(struct scsi_device *sdev, struct
> rdac_dh_data *h)
> +static void send_mode_select(struct work_struct *work)
>  {
> +	struct rdac_controller *ctlr =
> +		container_of(work, struct rdac_controller, ms_work);
>  	struct request *rq;
> +	struct scsi_device *sdev = ctlr->ms_sdev;
> +	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	struct request_queue *q = sdev->request_queue;
>  	int err, retry_cnt = RDAC_RETRY_COUNT;
> +	struct rdac_queue_data *tmp, *qdata;
> +	LIST_HEAD(list);
> +	u8 *lun_table;
> +
> +	spin_lock(&ctlr->ms_lock);
> +	list_splice_init(&ctlr->ms_head, &list);
> +	ctlr->ms_queued = 0;
> +	ctlr->ms_sdev = NULL;
> +	spin_unlock(&ctlr->ms_lock);
> +
> +	if (ctlr->use_ms10)
> +		lun_table = ctlr->mode_select.expanded.lun_table;
> +	else
> +		lun_table = ctlr->mode_select.legacy.lun_table;
> 
>  retry:
>  	err = SCSI_DH_RES_TEMP_UNAVAIL;
> @@ -545,6 +583,10 @@
>  	if (!rq)
>  		goto done;
> 
> +	list_for_each_entry(qdata, &list, entry) {
> +		lun_table[qdata->h->lun] = 0x81;
> +	}
> +
>  	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
>  		"%s MODE_SELECT command",
>  		(char *) h->ctlr->array_name, h->ctlr->index,
> @@ -565,7 +607,41 @@
>  	}
> 
>  done:
> -	return err;
> +	list_for_each_entry_safe(qdata, tmp, &list, entry) {
> +		list_del(&qdata->entry);
> +		if (err == SCSI_DH_OK)
> +			qdata->h->state = RDAC_STATE_ACTIVE;
> +		if (qdata->callback_fn)
> +			qdata->callback_fn(qdata->callback_data, err);
> +		kfree(qdata);
> +	}
> +	return;
> +}
> +
> +static int queue_mode_select(struct scsi_device *sdev,
> +				activate_complete fn, void *data)
> +{
> +	struct rdac_queue_data *qdata;
> +	struct rdac_controller *ctlr;
> +
> +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> +	if (!qdata)
> +		return SCSI_DH_RETRY;
> +
> +	qdata->h = get_rdac_data(sdev);
> +	qdata->callback_fn = fn;
> +	qdata->callback_data = data;
> +
> +	ctlr = qdata->h->ctlr;
> +	spin_lock(&ctlr->ms_lock);
> +	list_add_tail(&qdata->entry, &ctlr->ms_head);
> +	if (!ctlr->ms_queued) {
> +		ctlr->ms_queued = 1;
> +		ctlr->ms_sdev = sdev;
> +		queue_work(kmpath_rdacd, &ctlr->ms_work);
> +	}
> +	spin_unlock(&ctlr->ms_lock);
> +	return SCSI_DH_OK;
>  }
> 
>  static int rdac_activate(struct scsi_device *sdev,
> @@ -578,8 +654,11 @@
>  	if (err != SCSI_DH_OK)
>  		goto done;
> 
> -	if (h->lun_state == RDAC_LUN_UNOWNED)
> -		err = send_mode_select(sdev, h);
> +	if (h->lun_state == RDAC_LUN_UNOWNED) {
> +		err = queue_mode_select(sdev, fn, data);
> +		if (err == SCSI_DH_OK)
> +			return 0;
> +	}
>  done:
>  	if (fn)
>  		fn(data, err);
> @@ -793,13 +872,26 @@
>  	int r;
> 
>  	r = scsi_register_device_handler(&rdac_dh);
> -	if (r != 0)
> +	if (r != 0) {
>  		printk(KERN_ERR "Failed to register scsi device handler.");
> +		goto done;
> +	}
> +
> +	/*
> +	 * Create workqueue to handle mode selects for rdac
> +	 */
> +	kmpath_rdacd = create_singlethread_workqueue("kmpath_rdacd");
> +	if (!kmpath_rdacd) {
> +		scsi_unregister_device_handler(&rdac_dh);
> +		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
> +	}
> +done:
>  	return r;
>  }
> 
>  static void __exit rdac_exit(void)
>  {
> +	destroy_workqueue(kmpath_rdacd);
>  	scsi_unregister_device_handler(&rdac_dh);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
