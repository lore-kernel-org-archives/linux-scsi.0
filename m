From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: re: [SCSI] qla2xxx: Add support for ISP8044.
Date: Tue, 3 Sep 2013 16:19:21 -0400
Message-ID: <alpine.WNT.2.00.1309031618560.7184@N5102REMCQXM4BS.qlogic.org>
References: <20130902092030.GC30037@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:54499 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248Ab3ICUT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 16:19:27 -0400
In-Reply-To: <20130902092030.GC30037@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Atul Deshmukh <atul.deshmukh@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

Dan,

Thanks for the heads up.  We'll fix this.

--Chad

On Mon, 2 Sep 2013, Dan Carpenter wrote:

> Hello Atul Deshmukh,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch ef4647420025: "[SCSI] qla2xxx: Add support for ISP8044."
> from Aug 27, 2013, leads to the following Smatch complaint:
>
> drivers/scsi/qla2xxx/qla_os.c:2962 qla2x00_probe_one()
> 	 error: we previously assumed 'base_vha' could be null (see line 2632)
>
> drivers/scsi/qla2xxx/qla_os.c
>  2631		base_vha = qla2x00_create_host(sht, ha);
>  2632		if (!base_vha) {
>                     ^^^^^^^^
> Existing check.
>
>  2633			ret = -ENOMEM;
>  2634			qla2x00_mem_free(ha);
>  2635			qla2x00_free_req_que(ha, req);
>  2636			qla2x00_free_rsp_que(ha, rsp);
>  2637			goto probe_hw_failed;
>  2638		}
>
> [ snip ]
>
>  2954	probe_hw_failed:
>  2955		if (IS_QLA82XX(ha)) {
>  2956			qla82xx_idc_lock(ha);
>  2957			qla82xx_clear_drv_active(ha);
>  2958			qla82xx_idc_unlock(ha);
>  2959		}
>  2960		if (IS_QLA8044(ha)) {
>  2961			qla8044_idc_lock(ha);
>  2962			qla8044_clear_drv_active(base_vha);
>                                                 ^^^^^^^^
> Patch adds dereference.
>
>  2963			qla8044_idc_unlock(ha);
>  2964		}
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
