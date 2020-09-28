Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF0FC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4216E208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUdlTqoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgI1VBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:01:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgI1VBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 17:01:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKxWpI084746;
        Mon, 28 Sep 2020 21:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kI/jNLCNlLf1G88+nFRVWYbabCa7iYQ7K3+RPS17ryY=;
 b=LUdlTqoUDxJWY0vwuUXhS8A29Ntc/v92MEpfT4iuSACXS4c5hr8Q9uxhGaCsdadbNCJw
 tjTYyQGtOWz1a6LAzLORuCFY31vEG9gFQc+4xECPsc5aYacdd5HbqUV2skzC+jp0rHQN
 ClYszZOGcSsxvfTKnCGcCnQqbTePy+pTG/0vYSIzmsVSyOnEY2hcU4Ym1FWM5AEJ6FHi
 Pv3IXURgm56nrRs6hrOyXPwJX8ROPDPlPAwsYLZUTTazfCX5JkgZg/BJDGYlfaFzOMC/
 eprSjzjZhyDofXNRe8F4traxyVl/g8DSdWwx2V55wQPd8kOJHyG8vPatDOWJWd5NQwfB wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkqbu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 21:01:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKtfNr153120;
        Mon, 28 Sep 2020 20:59:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33tfjvkcyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 20:59:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SKxCqh024125;
        Mon, 28 Sep 2020 20:59:14 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 13:59:12 -0700
Subject: Re: [PATCH 4/7] qla2xxx: Fix reset of MPI firmware
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-5-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <94ab5c30-3970-ad69-1716-5962ad9d3acd@oracle.com>
Date:   Mon, 28 Sep 2020 15:59:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Normally, the MPI firmware is reset when an MPI dump is collected.
> If an unsaved MPI dump exists in the driver, though, an alternate
> mechanism is used. This mechanism, which was not fully correct, is
> not recommended and instead an MPI dump template walk is suggested
> to perform the MPI reset.
> 
> To allow for the MPI dump template walk, extra space is reserved
> in the MPI dump buffer, which gets used only when there is already
> an MPI dump in place.
> 
> Fixes: qla2xxx: Fix MPI failure AEN (8200) handling

missing commit hash and wrong format.. Please use following (for future)

Fixes: cbb01c2f2f630 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")

> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 10 +++++--
>   drivers/scsi/qla2xxx/qla_gbl.h  |  1 -
>   drivers/scsi/qla2xxx/qla_init.c |  2 ++
>   drivers/scsi/qla2xxx/qla_tmpl.c | 49 +++++++++------------------------
>   4 files changed, 23 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 1ee747ba4ecc..284b1cc91c80 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -157,6 +157,14 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
>   			       vha->host_no);
>   		}
>   		break;
> +	case 10:
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +			ql_log(ql_log_info, vha, 0x70e9,
> +			       "Issuing MPI firmware dump on host#%ld.\n",
> +			       vha->host_no);
> +			ha->isp_ops->mpi_fw_dump(vha, 0);
> +		}
> +		break;
>   	}
>   	return count;
>   }
> @@ -744,8 +752,6 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
>   			qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);
>   			qla83xx_idc_unlock(vha, 0);
>   			break;
> -		} else if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> -			qla27xx_reset_mpi(vha);
>   		} else {
>   			/* Make sure FC side is not in reset */
>   			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 9c4d077edf9e..26dc055d93b3 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -945,6 +945,5 @@ extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
>   
>   /* nvme.c */
>   void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> -void qla27xx_reset_mpi(scsi_qla_host_t *vha);
>   void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
>   #endif /* _QLA_GBL_H */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 6b88b0e6d91a..9c57e29020ad 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3288,6 +3288,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
>   			    j, fwdt->dump_size);
>   			dump_size += fwdt->dump_size;
>   		}
> +		/* Add space for spare MPI fw dump. */
> +		dump_size += ha->fwdt[1].dump_size;
>   	} else {
>   		req_q_size = req->length * sizeof(request_t);
>   		rsp_q_size = rsp->length * sizeof(response_t);
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index 591df89a4d13..0af3e7fa31f0 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -12,33 +12,6 @@
>   #define IOBASE(vha)	IOBAR(ISPREG(vha))
>   #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
>   
> -/* hardware_lock assumed held. */
> -static void
> -qla27xx_write_remote_reg(struct scsi_qla_host *vha,
> -			 u32 addr, u32 data)
> -{
> -	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
> -
> -	ql_dbg(ql_dbg_misc, vha, 0xd300,
> -	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
> -
> -	wrt_reg_dword(&reg->iobase_addr, 0x40);
> -	wrt_reg_dword(&reg->iobase_c4, data);
> -	wrt_reg_dword(&reg->iobase_window, addr);
> -}
> -
> -void
> -qla27xx_reset_mpi(scsi_qla_host_t *vha)
> -{
> -	ql_dbg(ql_dbg_misc + ql_dbg_verbose, vha, 0xd301,
> -	       "Entered %s.\n", __func__);
> -
> -	qla27xx_write_remote_reg(vha, 0x104050, 0x40004);
> -	qla27xx_write_remote_reg(vha, 0x10405c, 0x4);
> -
> -	vha->hw->stat.num_mpi_reset++;
> -}
> -
>   static inline void
>   qla27xx_insert16(uint16_t value, void *buf, ulong *len)
>   {
> @@ -1028,7 +1001,6 @@ void
>   qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   {
>   	ulong flags = 0;
> -	bool need_mpi_reset = true;
>   
>   #ifndef __CHECKER__
>   	if (!hardware_locked)
> @@ -1036,14 +1008,20 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   #endif
>   	if (!vha->hw->mpi_fw_dump) {
>   		ql_log(ql_log_warn, vha, 0x02f3, "-> mpi_fwdump no buffer\n");
> -	} else if (vha->hw->mpi_fw_dumped) {
> -		ql_log(ql_log_warn, vha, 0x02f4,
> -		       "-> MPI firmware already dumped (%p) -- ignoring request\n",
> -		       vha->hw->mpi_fw_dump);
>   	} else {
>   		struct fwdt *fwdt = &vha->hw->fwdt[1];
>   		ulong len;
>   		void *buf = vha->hw->mpi_fw_dump;
> +		bool walk_template_only = false;
> +
> +		if (vha->hw->mpi_fw_dumped) {
> +			/* Use the spare area for any further dumps. */
> +			buf += fwdt->dump_size;
> +			walk_template_only = true;
> +			ql_log(ql_log_warn, vha, 0x02f4,
> +			       "-> MPI firmware already dumped -- dump saving to temporary buffer %p.\n",
> +			       buf);
> +		}
>   
>   		ql_log(ql_log_warn, vha, 0x02f5, "-> fwdt1 running...\n");
>   		if (!fwdt->template) {
> @@ -1058,9 +1036,10 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   			ql_log(ql_log_warn, vha, 0x02f7,
>   			       "-> fwdt1 fwdump residual=%+ld\n",
>   			       fwdt->dump_size - len);
> -		} else {
> -			need_mpi_reset = false;
>   		}
> +		vha->hw->stat.num_mpi_reset++;
> +		if (walk_template_only)
> +			goto bailout;
>   
>   		vha->hw->mpi_fw_dump_len = len;
>   		vha->hw->mpi_fw_dumped = 1;
> @@ -1072,8 +1051,6 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
>   	}
>   
>   bailout:
> -	if (need_mpi_reset)
> -		qla27xx_reset_mpi(vha);
>   #ifndef __CHECKER__
>   	if (!hardware_locked)
>   		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
> 
small nit with the Fixes tag. Otherwise looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
