Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A656C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD2C61076
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhDTR1w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:27:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231549AbhDTR1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 13:27:51 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KH4p6D080198;
        Tue, 20 Apr 2021 13:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=NY2KldLCtsHoNDxJgDC9hiC6/yo7XL1wPRpur5BsyfU=;
 b=r8emIWpvPVSmXpVyroOzLLAi/TKM6LAHOAtdPFum7Jz/nK0wvNh2jwA1xFhsfgAfdrVN
 dBSNOVExlNfCddJqL1a7Ej7w41rnwHIpJAIYBQ6+4SEgkH8XICCos5n+u7IcXB3iquTm
 vjkd6Ub+fdoGBZQ8uQZWRNZi7K+h33nQP3nn7fgJKddD8QwxbQ1TqzGyMayJMmiMprtU
 aZ9WAxjlQewbftx1+liHLFi0Jligz9HfKXaj+cmXQqz3JIQUgxKCVaL1tMJUTPMeoSK+
 YypV79LIdv3nKh3JqZS061yZtSWjcSIxUf9qgvTb1hOG6EuirEgch9lP6kiCkDcEpjZs Ww== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38217vms12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 13:27:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KHMMKB028037;
        Tue, 20 Apr 2021 17:27:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37yqa8hums-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 17:27:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KHR1hb21234066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 17:27:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B41464C05A;
        Tue, 20 Apr 2021 17:27:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E62A4C044;
        Tue, 20 Apr 2021 17:27:01 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.82.95])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Apr 2021 17:27:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lYu9N-003Q9j-0p; Tue, 20 Apr 2021 19:27:01 +0200
Date:   Tue, 20 Apr 2021 19:27:00 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
Message-ID: <YH8O5AaapQRg6Msq@t480-pf1aa2c2.linux.ibm.com>
References: <20210419100014.47144-1-dwagner@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210419100014.47144-1-dwagner@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hkkQMQDjyt4Ag5VEfOHXQXOSTQT7j56M
X-Proofpoint-GUID: hkkQMQDjyt4Ag5VEfOHXQXOSTQT7j56M
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_08:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 12:00:14PM +0200, Daniel Wagner wrote:
> Allow to set the default dev_loss_tmo value as kernel module option.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
> 
> During array upgrade tests with NVMe/FC on systems equiped with QLogic
> HBAs we faced the problem with the default setting of dev_loss_tmo.
> 
> When the default timeout hit after 60 seconds the file system went
> into read only mode. The fix was to set the dev_loss_tmo to infinity
> (note this patch can't handle this).
> 
> For lpfc devices we could use the sysfs interface under
> fc_remote_ports which exposed the dev_loss_tmo for SCSI and NVMe
> rports.
> 
> The QLogic only expose the rports via fc_remote_ports if SCSI is used.
> There is the debugfs interface to set the dev_loss_tmo but this has
> two issues. First, it's not watched by udevd hence no rules work. This
> could be somehow worked around by setting it statically, but that is
> really only an option for testing. Even if the debugfs interface is
> used there is a bug in the code. In qla_nvme_register_remote() the
> value 0 is assigned to dev_loss_tmo and the NVMe core will use it's
> default value 60 (this code path is exercised if the rport droppes
> twice).
> 
> Anyway, this patch is just to get the discussion going. Maybe the
> driver could implement the fc_remote_port interface? Hannes was
> pointing out it might make sense to think about an controller sysfs
> API as there is already a host and the NVMe protocol is all about host
> and controller.
> 
> Thanks,
> Daniel
> 
>  drivers/scsi/qla2xxx/qla_attr.c | 4 ++--
>  drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 5 +++++
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3aa9869f6fae..0d2386ba65c0 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3036,7 +3036,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
>  	}
>  
>  	/* initialize attributes */
> -	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
> +	fc_host_dev_loss_tmo(vha->host) = ql2xdev_loss_tmo;
>  	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
>  	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
>  	fc_host_supported_classes(vha->host) =
> @@ -3260,7 +3260,7 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
>  	struct qla_hw_data *ha = vha->hw;
>  	u32 speeds = FC_PORTSPEED_UNKNOWN;
>  
> -	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
> +	fc_host_dev_loss_tmo(vha->host) = ql2xdev_loss_tmo;
>  	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
>  	fc_host_port_name(vha->host) = wwn_to_u64(vha->port_name);
>  	fc_host_supported_classes(vha->host) = ha->base_qpair->enable_class_2 ?
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..0b9c24475711 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -178,6 +178,7 @@ extern int ql2xdifbundlinginternalbuffers;
>  extern int ql2xfulldump_on_mpifail;
>  extern int ql2xenforce_iocb_limit;
>  extern int ql2xabts_wait_nvme;
> +extern int ql2xdev_loss_tmo;
>  
>  extern int qla2x00_loop_reset(scsi_qla_host_t *);
>  extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0cacb667a88b..cdc5b5075407 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -41,7 +41,7 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
>  	req.port_name = wwn_to_u64(fcport->port_name);
>  	req.node_name = wwn_to_u64(fcport->node_name);
>  	req.port_role = 0;
> -	req.dev_loss_tmo = 0;
> +	req.dev_loss_tmo = ql2xdev_loss_tmo;
>  
>  	if (fcport->nvme_prli_service_param & NVME_PRLI_SP_INITIATOR)
>  		req.port_role = FC_PORT_ROLE_NVME_INITIATOR;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d74c32f84ef5..c686522ff64e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -338,6 +338,11 @@ static void qla2x00_free_device(scsi_qla_host_t *);
>  static int qla2xxx_map_queues(struct Scsi_Host *shost);
>  static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
>  
> +int ql2xdev_loss_tmo = 60;
> +module_param(ql2xdev_loss_tmo, int, 0444);
> +MODULE_PARM_DESC(ql2xdev_loss_tmo,
> +		"Time to wait for device to recover before reporting\n"
> +		"an error. Default is 60 seconds\n");

Wouldn't that be really really confusing, if you set essentially the
same thing with two different knobs for one FC HBA? We already have
a `dev_loss_tmo` kernel parameter - granted, only for scsi_transport_fc;
but doesn't qla implement that as well?

I don't really have any horses in this race here, but that sounds
strange.


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
