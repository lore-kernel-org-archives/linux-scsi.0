Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E597C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 03:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5970B20656
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 03:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgAID4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 22:56:11 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:56283 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgAID4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 22:56:11 -0500
Received: by mail-pj1-f53.google.com with SMTP id d5so528722pjz.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 19:56:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GdK3lxzd0opzdFX0LTXN5uwz5VzIFJvCkrvjuvwIPf8=;
        b=l4DdDvtgcQ8tBebdiGtsJ+GkBGJ9NQaG452O3veGi2JzRGV/rb/c/rx0TnDQM5ws8x
         p4AClh+1EM7WEqHPmyLWvVGkiwHqKohqloqhNhY03h2Gn7iMPRUaYUOlmr0R3p3h1tez
         LA8GkbdhAZDiW/eeqvn0pHORtuBx+9oqTzwx0xZd6veE/qUpRb69uAeqpBAumZ9vXQvl
         HXssmYu94rM5D6dmf0Xg+sT/gAkS4WEEMPp3FC8kCGD68aFO2dbOT5CaKieOv1RCARq/
         ivjEvqBPQxhgTBcHchRMrwrOniFmQ19jhiSFs0s3V3ZDqU/tCKuvKDYRZ+Ry+jo1igXf
         /foQ==
X-Gm-Message-State: APjAAAXsF/Kj6XLnUQJMnYM0/QncLwMldp1acGsyq88eOm9OtylnF2aR
        FGWWemlf3GbfW4ijeBKcRYU=
X-Google-Smtp-Source: APXvYqzHLyU78oqg8yY9l4QfsXiEXJnH7Rt5GwiArrn1QR8w4pgNjSUTWDDoeO9wvDieMH0f5RpqJw==
X-Received: by 2002:a17:902:700b:: with SMTP id y11mr9515070plk.304.1578542170290;
        Wed, 08 Jan 2020 19:56:10 -0800 (PST)
Received: from ?IPv6:2601:647:4000:13e0:f4e4:e61b:5262:7ebf? ([2601:647:4000:13e0:f4e4:e61b:5262:7ebf])
        by smtp.gmail.com with ESMTPSA id s18sm5321514pfh.179.2020.01.08.19.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 19:56:09 -0800 (PST)
Subject: Re: [PATCH v2 24/32] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-25-jsmart2021@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <a1c547a3-f5b8-54bc-b9e9-5b0ad0786ed3@acm.org>
Date:   Wed, 8 Jan 2020 19:56:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-25-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-20 14:37, James Smart wrote:
> +#include <scsi/scsi_tcq.h>

Including the scsi_tcq.h header file is only useful in source files that
implement initiator functionality. This source file implements SCSI
target functionality. Is this include really necessary?

> +static struct workqueue_struct *lio_wq;
> +
> +static int
> +efct_format_wwn(char *str, size_t len, char *pre, u64 wwn)
> +{
> +	u8 a[8];
> +
> +	put_unaligned_be64(wwn, a);
> +	return snprintf(str, len,
> +			"%s%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
> +			pre, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
> +}

Can the type of 'pre' be changed from 'char *' into 'const char *'?

Can %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x be changed into %8phC?

> +static int
> +efct_lio_parse_wwn(const char *name, u64 *wwp, u8 npiv)
> +{
> +	int a[8], num;
> +	u8 b[8];
> +
> +	if (npiv) {
> +		num = sscanf(name, "%02x%02x%02x%02x%02x%02x%02x%02x",
> +			     &a[0], &a[1], &a[2], &a[3], &a[4],
> +				 &a[5], &a[6], &a[7]);
> +	} else {
> +		num = sscanf(name,
> +			     "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
> +			     &a[0], &a[1], &a[2], &a[3], &a[4],
> +			     &a[5], &a[6], &a[7]);
> +	}
> +
> +	if (num != 8)
> +		return -EINVAL;
> +
> +	for (num = 0; num < 8; ++num)
> +		b[num] = (u8) a[num];
> +
> +	*wwp = get_unaligned_be64(b);
> +	return 0;
> +}

If the %02x sscanf specifiers are changed into %02hhx, can the int a[8]
array be left out?

> +static ssize_t
> +efct_lio_npiv_tpg_enable_store(struct config_item *item, const char *page,
> +			       size_t count)
> +{
> +	struct se_portal_group *se_tpg = to_tpg(item);
> +	struct efct_lio_tpg *tpg = container_of(se_tpg,
> +						struct efct_lio_tpg, tpg);
> +	struct efct_lio_vport *lio_vport = tpg->vport;
> +	struct efct_lio_vport_data_t *vport_data;
> +	struct efct *efct;
> +	struct efc *efc;
> +	int ret = -1;
> +	unsigned long op, flags = 0;
> +
> +	if (kstrtoul(page, 0, &op) < 0)
> +		return -EINVAL;
> +
> +	if (!lio_vport) {
> +		pr_err("Unable to find vport\n");
> +		return -EINVAL;
> +	}
> +
> +	efct = lio_vport->efct;
> +	efc = efct->efcport;
> +
> +	if (op == 1) {
> +		atomic_set(&tpg->enabled, 1);
> +		efc_log_debug(efct, "enable portal group %d\n", tpg->tpgt);
> +
> +		if (efc->domain) {
> +			ret = efc_sport_vport_new(efc->domain,
> +						  lio_vport->npiv_wwpn,
> +						  lio_vport->npiv_wwnn,
> +						  U32_MAX, false, true,
> +						  NULL, NULL, true);
> +			if (ret != 0) {
> +				efc_log_err(efct, "Failed to create Vport\n");
> +				return ret;
> +			}
> +			return count;
> +		}
> +
> +		vport_data = kmalloc(sizeof(*vport_data), GFP_KERNEL);
> +		if (!vport_data)
> +			return ret;
> +
> +		memset(vport_data, 0, sizeof(struct efct_lio_vport_data_t));
> +		vport_data->phy_wwpn            = lio_vport->wwpn;
> +		vport_data->vport_wwpn          = lio_vport->npiv_wwpn;
> +		vport_data->vport_wwnn          = lio_vport->npiv_wwnn;
> +		vport_data->target_mode         = 1;
> +		vport_data->initiator_mode      = 0;
> +		vport_data->lio_vport           = lio_vport;
> +
> +		/* There is no domain.  Add to pending list. When the
> +		 * domain is created, the driver will create the vport.
> +		 */
> +		efc_log_debug(efct, "link down, move to pending\n");
> +		spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
> +		INIT_LIST_HEAD(&vport_data->list_entry);
> +		list_add_tail(&vport_data->list_entry,
> +			      &efct->tgt_efct.vport_pend_list);
> +		spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
> +
> +	} else if (op == 0) {
> +		struct efct_lio_vport_data_t *virt_target_data, *next;
> +
> +		efc_log_debug(efct, "disable portal group %d\n", tpg->tpgt);
> +
> +		atomic_set(&tpg->enabled, 0);
> +		/* only physical sport should exist, free lio_sport
> +		 * allocated in efct_lio_make_sport
> +		 */
> +		if (efc->domain) {
> +			efc_sport_vport_del(efct->efcport, efc->domain,
> +					    lio_vport->npiv_wwpn,
> +					    lio_vport->npiv_wwnn);
> +			return count;
> +		}
> +		spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
> +		list_for_each_entry_safe(virt_target_data, next,
> +					 &efct->tgt_efct.vport_pend_list,
> +					 list_entry) {
> +			if (virt_target_data->lio_vport == lio_vport) {
> +				list_del(&virt_target_data->list_entry);
> +				kfree(virt_target_data);
> +				break;
> +			}
> +		}
> +		spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
> +	} else {
> +		return -EINVAL;
> +	}
> +	return count;
> +}

I think the above function can return -1. Please make sure that this
function returns an appropriate error code if something fails.

> +static bool efct_lio_node_is_initiator(struct efc_node *node)
> +{
> +	if (!node)
> +		return 0;
> +
> +	if (node->rnode.fc_id && node->rnode.fc_id != FC_FID_FLOGI &&
> +	    node->rnode.fc_id != FC_FID_DIR_SERV &&
> +	    node->rnode.fc_id != FC_FID_FCTRL) {
> +		return 1;
> +	}
> +
> +	return 0;
> +}

Should return 0 / return 1 perhaps be changed into return false / return
true?

> +static int  efct_lio_tgt_session_data(struct efct *efct, u64 wwpn,
> +				      char *buf, int size)
> +{
> +	struct efc_sli_port *sport = NULL;
> +	struct efc_node *node = NULL;
> +	struct efc *efc = efct->efcport;
> +	u16 loop_id = 0;
> +	int off = 0, rc = 0;
> +
> +	if (!efc->domain) {
> +		efc_log_err(efct, "failed to find efct/domain\n");
> +		return -1;
> +	}
> +
> +	list_for_each_entry(sport, &efc->domain->sport_list, list_entry) {
> +		if (sport->wwpn != wwpn)
> +			continue;
> +		list_for_each_entry(node, &sport->node_list,
> +				    list_entry) {
> +			/* Dump only remote NPORT sessions */
> +			if (!efct_lio_node_is_initiator(node))
> +				continue;
> +
> +			rc = snprintf(buf + off, size - off,
> +				"0x%016llx,0x%08x,0x%04x\n",
> +				get_unaligned_be64(node->wwpn),
> +				node->rnode.fc_id, loop_id);
> +			if (rc < 0)
> +				break;
> +			off += rc;
> +		}
> +	}
> +
> +	buf[size - 1] = '\0';
> +	return 0;
> +}

Does the caller of this function initialize buf[]? If not, should this
function initialize buf[] before calling snprintf()?

Since snprintf() guarantees '\0' termination I think that the buf[size -
1] = '\0' at the end of this function can be left out.

> +static int
> +efct_lio_datamove_done(struct efct_io *io, enum efct_scsi_io_status scsi_status,
> +		       u32 flags, void *arg);

Can this forward declaration be avoided by reordering the function
definitions?

> +static struct se_wwn *
> +efct_lio_npiv_make_sport(struct target_fabric_configfs *tf,
> +			 struct config_group *group, const char *name)
> +{
> +	struct efct_lio_vport *lio_vport;
> +	struct efct *efct;
> +	int ret = -1;
> +	u64 p_wwpn, npiv_wwpn, npiv_wwnn;
> +	char *p, tmp[128];
> +	struct efct_lio_vport_list_t *vport_list;
> +	struct fc_vport *new_fc_vport;
> +	struct fc_vport_identifiers vport_id;
> +	unsigned long flags = 0;
> +
> +	snprintf(tmp, 128, "%s", name);

How about using sizeof(tmp) instead of hardcoding the array size?

> +	p = strchr(tmp, '@');
> +
> +	if (!p) {
> +		pr_err("Unable to find separator operator(@)\n");
> +		return ERR_PTR(ret);
> +	}
> +	*p++ = '\0';

Can this be changed into a strsep() call?

> +int efct_scsi_tgt_del_device(struct efct *efct)
> +{
> +	int rc = 0;
> +
> +	flush_workqueue(lio_wq);
> +
> +	return rc;
> +}

Is the 'rc' variable necessary in the above function? Can it be removed?

> +/* Called by the libefc when an initiator goes away. */
> +int efct_scsi_del_initiator(struct efc *efc, struct efc_node *node,
> +			int reason)
> +{
> +	struct efct *efct = node->efc->base;
> +	struct efct_lio_wq_data *wq_data;
> +	int watermark;
> +	int initiator_count;
> +
> +	if (reason == EFCT_SCSI_INITIATOR_MISSING)
> +		return EFCT_SCSI_CALL_COMPLETE;
> +
> +	wq_data = kmalloc(sizeof(*wq_data), GFP_ATOMIC);
> +	if (!wq_data)
> +		return EFCT_SCSI_CALL_COMPLETE;
> +
> +	memset(wq_data, 0, sizeof(*wq_data));
> +	wq_data->ptr = node;
> +	wq_data->efct = efct;
> +	INIT_WORK(&wq_data->work, efct_lio_remove_session);
> +	queue_work(lio_wq, &wq_data->work);
> +
> +	/*
> +	 * update IO watermark: decrement initiator count
> +	 */
> +	initiator_count =
> +		atomic_sub_return(1, &efct->tgt_efct.initiator_count);
> +	watermark = (efct->tgt_efct.watermark_max -
> +			initiator_count * EFCT_IO_WATERMARK_PER_INITIATOR);
> +	watermark = (efct->tgt_efct.watermark_min > watermark) ?
> +			efct->tgt_efct.watermark_min : watermark;
> +	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
> +
> +	return EFCT_SCSI_CALL_ASYNC;
> +}

Is the lio_wq work queue really necessary? Could one of the system
workqueues have been used instead?

> +	ret = kstrtoul(page, 0, &val);					  \
> +	if (ret < 0) {							  \
> +		pr_err("kstrtoul() failed with ret: %d\n", ret);	  \
> +		return -EINVAL;						  \
> +	}								  \

Has it been considered to return 'ret' (the kstrtoul() return value)
instead of -EINVAL?

> +	ret = kstrtoul(page, 0, &val);					   \
> +	if (ret < 0) {							   \
> +		pr_err("kstrtoul() failed with ret: %d\n", ret);	   \
> +		return -EINVAL;						   \
> +	}								   \

Same comment here.

> +#define efct_set_lio_io_state(io, value) (io->tgt_io.state |= value)

Is this macro really useful? Can it be removed?

> +struct efct_scsi_tgt_io {
> +	struct se_cmd		cmd;
> +	unsigned char		sense_buffer[TRANSPORT_SENSE_BUFFER];
> +	int			ddir;

Should 'int' perhaps be changed into 'enum dma_data_direction'?

> +	u8			cdb_opcode;

Does this duplicate cmd.t_task_cdb[0]? If so, is it useful to duplicate
that value?

> +	u32			cdb_len;

Is this value identical to scsi_command_size(cmd.t_task_cdb)? Is it
essential to have this member in this data structure?

Thanks,

Bart.
