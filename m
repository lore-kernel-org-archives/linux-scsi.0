Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE05C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 22:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52D72072F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 22:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iXqCzy0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFBWA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:00:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBWAZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 18:00:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052LptUL158476;
        Tue, 2 Jun 2020 22:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4c/+SW0QfIBdBOMpN+6arQLMEHQuWxRtaKBXSbyk/EE=;
 b=iXqCzy0coPRr25i/3RqiN7VpzQzqeeBNM8oxBUwhVVaZZ2rzbhUxniRcdODpvQmIbmNh
 iEWT8cxOW4yjmWZLZ8GwWtsT8z+GYHylpeY8M96K25jQ4fq+yR5LZXNS5bCJHb6l7x77
 vqDrYqJXWZ0gB+IygVsUbll0zvohD8OtZ+i7W2IsNpFttGzH+aDdKW2o74kcjqj9NAsE
 fTrMYGHoKQRO7MXCWqysWDA6jE8Nlez7IbPwDP5R5GE8+S2XMhtCbtIa+IfosP72Iqwq
 bCvhZAfqd7xZcZ7gwgByMtzgRMYRWmoube0KWnv3qwf6Hj+dbPWrRiudPfI7QpaZZmMl 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqxb8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 22:00:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052LrIOJ171283;
        Tue, 2 Jun 2020 22:00:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31c1dxy3c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 22:00:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052M0NkO014468;
        Tue, 2 Jun 2020 22:00:23 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 15:00:23 -0700
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
Date:   Tue, 2 Jun 2020 17:00:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/2/20 1:33 PM, Sudhakar Panneerselvam wrote:
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index f2f7c5b818cc..4282fa98ff35 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1412,6 +1412,9 @@ void transport_init_se_cmd(
>   sense_reason_t
>   target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
>   {
> +	sense_reason_t ret;
> +
> +	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
>   	/*
>   	 * Ensure that the received CDB is less than the max (252 + 8) bytes
>   	 * for VARIABLE_LENGTH_CMD
> @@ -1420,7 +1423,8 @@ void transport_init_se_cmd(
>   		pr_err("Received SCSI CDB with command_size: %d that"
>   			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
>   			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
> -		return TCM_INVALID_CDB_FIELD;
> +		ret = TCM_INVALID_CDB_FIELD;
> +		goto err;
>   	}
>   	/*
>   	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
> @@ -1435,10 +1439,10 @@ void transport_init_se_cmd(
>   				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
>   				scsi_command_size(cdb),
>   				(unsigned long)sizeof(cmd->__t_task_cdb));
> -			return TCM_OUT_OF_RESOURCES;
> +			ret = TCM_OUT_OF_RESOURCES;
> +			goto err;
>   		}
> -	} else
> -		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
> +	}
>   	/*
>   	 * Copy the original CDB into cmd->
>   	 */
> @@ -1446,6 +1450,13 @@ void transport_init_se_cmd(
>   
>   	trace_target_sequencer_start(cmd);
>   	return 0;
> +
> +err:
> +	/* Copy the CDB here to allow trace_target_cmd_complete() to

You should follow the coding style in the rest of the code. Do "/*" then 
start your text or do it all on one line if it fits:

/*
  * Copy the CDB here to allow trace_target_cmd_complete() to


> +	 * print the cdb to the trace buffers.
> +	 */
> +	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned int)TCM_MAX_COMMAND_SIZE));

Use 80 char cols like you did in the rest of the patch and the other code.

> +	return ret;
>   }
>   EXPORT_SYMBOL(target_cmd_init_cdb);
>   
> @@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
>   	struct se_device *dev = cmd->se_dev;
>   	sense_reason_t ret;
>   
> -	target_cmd_init_cdb(cmd, cdb);
> -
>   	ret = dev->transport->parse_cdb(cmd);
>   	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
>   		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
> @@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
>   				data_length, data_dir, task_attr, sense);
>   

This should maybe be in transport_init_se_cmd. It might be useful there 
for the tmr case, if we wanted to add a trace point there too.

At least a comment and some cleanup, because it's not obvious why we set 
it here then also set it again in transport_lookup_cmd_lun.


> +	se_cmd->orig_fe_lun = unpacked_lun; > +	rc = target_cmd_init_cdb(se_cmd, cdb);
> +	if (rc) {
> +		transport_send_check_condition_and_sense(se_cmd, rc, 0);

Can we do this before doing a get() on the cmd? If the fabric module is 
such that it does a put() on the cmd (the callers using SCF_ACK_KREF) in 
its cmd clean up path, then we would end up with unbalanced 
sess->cmd_count and cmd refcounts.

Maybe move this to after target_get_sess_cmd().


> +		return 0;
> +	}
> +
>   	if (flags & TARGET_SCF_USE_CPUID)
>   		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
>   	else
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index bd3ed6ce7571..fdd8234906b6 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
>   	}
>   	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>   
> +	if (target_cmd_init_cdb(cmd, cdb))
> +		return -EINVAL;
> +
>   	cmd->tag = 0;
>   	if (target_setup_cmd_from_cdb(cmd, cdb))
>   		return -EINVAL;
> 
