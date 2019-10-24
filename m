Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32933CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 22:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD1AD2166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 22:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbfJXW1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 18:27:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44852 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfJXW1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 18:27:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id e10so152182pgd.11
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 15:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3h4nkOce9sdlsxxmSUSZYX1nqTOhbAr4t2hUvvzQrGw=;
        b=A+1lje3Tog2F/TE7cxMLi4Kp0qk/kaOPmaNiqX9t/NpDumr6roDHTXPOTtmaJeQZKn
         /ZdQyaoZaTehV2Q9WeqaziXu2zPFOnmPmKd08ZW9oXa6MGEByorepja4CfUV6/rnfZ+a
         Q7RqUH4abH/iyexuiWBOQ9SNtztcrEEPuzkbdTjpBxYM56PNQqmSKjsEWdVorsEVfTDd
         lfITcISMKTFOuTFiVX88O4JrWiIvno2im/Hb6KHg27CCL6QWn/Fq347eg7t1oK6wGnA0
         vvPcAVCk7+sJg60sOxeQMUj/uYvVuNxStNUZePQOXhZR4wiJnc8SjbE8DM0fVSpN2abF
         RoRw==
X-Gm-Message-State: APjAAAXLiSJSX2VEWAN6POanSmBdieS26POSBrNxHJKPAX4aSxrLvy/i
        adiUQggvXRNxsrwFTV9msTc=
X-Google-Smtp-Source: APXvYqwl1AWZZzKaqw+8VF4QUdMTAdtcsR0tw/8ie/UNnMzHDW+Tx/RPNry4tdPVf0gNlWslW8QSmQ==
X-Received: by 2002:a63:778f:: with SMTP id s137mr388034pgc.147.1571956069722;
        Thu, 24 Oct 2019 15:27:49 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s202sm28771925pfs.24.2019.10.24.15.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 15:27:48 -0700 (PDT)
Subject: Re: [PATCH 24/32] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-25-jsmart2021@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5eae53c2-daee-f1f3-8586-e92fd61a5544@acm.org>
Date:   Thu, 24 Oct 2019 15:27:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191023215557.12581-25-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/19 2:55 PM, James Smart wrote:
> diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
> new file mode 100644
> index 000000000000..c2661ab3e9c3
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_lio.c
> @@ -0,0 +1,2643 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_tcq.h>
> +#include <target/target_core_base.h>
> +#include <target/target_core_fabric.h>

Please do not include SCSI initiator header files in a SCSI target 
driver. See also commit ba929992522b ("target: Minimize SCSI header 
#include directives").

> +#define	FABRIC_NAME		"efct"
> +#define FABRIC_NAME_NPIV	"efct_npiv"

Some time ago Christoph Hellwig asked not to use the prefix "fabric" but 
to use the prefix "target" instead.

 > +#define	FABRIC_SNPRINTF_LEN	32

"FABRIC_SNPRINTF_LEN" is a bad choice for the name for this constant. 
Please change this into a name that refers to what the purpose of this 
constant is (wwn string?) instead of how that string is generated.

> +#define	FABRIC_SNPRINTF(str, len, pre, wwn)	snprintf(str, len, \
> +		"%s%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", pre,  \
> +	    (u8)((wwn >> 56) & 0xff), (u8)((wwn >> 48) & 0xff),    \
> +	    (u8)((wwn >> 40) & 0xff), (u8)((wwn >> 32) & 0xff),    \
> +	    (u8)((wwn >> 24) & 0xff), (u8)((wwn >> 16) & 0xff),    \
> +	    (u8)((wwn >>  8) & 0xff), (u8)((wwn & 0xff)))

Please convert this macro into a function and choose a better name, e.g. 
efct_format_wwn().

> +#define	ARRAY2WWN(w, a)	(w = ((((u64)(a)[0]) << 56) | (((u64)(a)[1]) << 48) | \
> +			    (((u64)(a)[2]) << 40) | (((u64)(a)[3]) << 32) | \
> +			    (((u64)(a)[4]) << 24) | (((u64)(a)[5]) << 16) | \
> +			    (((u64)(a)[6]) <<  8) | (((u64)(a)[7]))))

Is this perhaps an open-coded version of get_unaligned_be64()?

> +/* Per-target data for virtual targets */
> +struct efct_lio_vport_data_t {
> +	struct list_head list_entry;
> +	bool initiator_mode;
> +	bool target_mode;
> +	u64 phy_wwpn;
> +	u64 phy_wwnn;
> +	u64 vport_wwpn;
> +	u64 vport_wwnn;
> +	struct efct_lio_vport *lio_vport;
> +};
> +
> +/* Per-target data for virtual targets */
> +struct efct_lio_vport_list_t {
> +	struct list_head list_entry;
> +	struct efct_lio_vport *lio_vport;
> +};

Two times the same comment for two different data structures? 
Additionally, what is a "virtual target"?

> +/* local prototypes */
> +static char *efct_lio_get_npiv_fabric_wwn(struct se_portal_group *);
> +static char *efct_lio_get_fabric_wwn(struct se_portal_group *);
> +static u16 efct_lio_get_tag(struct se_portal_group *);
> +static u16 efct_lio_get_npiv_tag(struct se_portal_group *);
> +static int efct_lio_check_demo_mode(struct se_portal_group *);
> +static int efct_lio_check_demo_mode_cache(struct se_portal_group *);
> +static int efct_lio_check_demo_write_protect(struct se_portal_group *);
> +static int efct_lio_check_prod_write_protect(struct se_portal_group *);
> +static int efct_lio_npiv_check_demo_write_protect(struct se_portal_group *);
> +static int efct_lio_npiv_check_prod_write_protect(struct se_portal_group *);
> +static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *);
> +static int efct_lio_check_stop_free(struct se_cmd *se_cmd);
> +static void efct_lio_aborted_task(struct se_cmd *se_cmd);
> +static void efct_lio_release_cmd(struct se_cmd *);
> +static void efct_lio_close_session(struct se_session *);
> +static u32 efct_lio_sess_get_index(struct se_session *);
> +static int efct_lio_write_pending(struct se_cmd *);
> +static void efct_lio_set_default_node_attrs(struct se_node_acl *);
> +static int efct_lio_get_cmd_state(struct se_cmd *);
> +static int efct_lio_queue_data_in(struct se_cmd *);
> +static int efct_lio_queue_status(struct se_cmd *);
> +static void efct_lio_queue_tm_rsp(struct se_cmd *);
> +static struct se_wwn *efct_lio_make_sport(struct target_fabric_configfs *,
> +					  struct config_group *, const char *);
> +static void efct_lio_drop_sport(struct se_wwn *);
> +static void efct_lio_npiv_drop_sport(struct se_wwn *);
> +static int efct_lio_parse_wwn(const char *, u64 *, u8 npiv);
> +static int efct_lio_parse_npiv_wwn(const char *name, size_t size,
> +				   u64 *wwpn, u64 *wwnn);
> +static struct se_portal_group *efct_lio_make_tpg(struct se_wwn *,
> +						 const char *);
> +static struct se_portal_group *efct_lio_npiv_make_tpg(struct se_wwn *,
> +						      const char *);
> +static void efct_lio_drop_tpg(struct se_portal_group *);
> +static struct se_wwn *efct_lio_npiv_make_sport(struct target_fabric_configfs *,
> +					       struct config_group *,
> +					       const char *);
> +static int
> +efct_lio_parse_npiv_wwn(const char *name, size_t size, u64 *wwpn, u64 *wwnn);
> +static void efct_lio_npiv_drop_tpg(struct se_portal_group *);
> +static int efct_lio_async_worker(struct efct_s *efct);
> +static void efct_lio_sg_unmap(struct efct_io_s *io);
> +static int efct_lio_abort_tgt_cb(struct efct_io_s *io,
> +				 enum efct_scsi_io_status_e scsi_status,
> +				    u32 flags, void *arg);
> +
> +static int efct_lio_init_nodeacl(struct se_node_acl *, const char *);
> +
> +static int efct_lio_check_demo_mode_login_only(struct se_portal_group *);
> +static int efct_lio_npiv_check_demo_mode_login_only(struct se_portal_group *);

Please reorder the code in this file such that most or all of these 
function declarations disappear.

> +static ssize_t
> +efct_lio_wwn_version_show(struct config_item *item, char *page)
> +{
> +	return sprintf(page, "Emulex EFCT fabric module version %s\n",
> +		       __stringify(EFCT_LIO_VERSION));
> +}

Version numbers are not useful in upstream code. Please remove this 
attribute and also the EFCT_LIO_VERSION constant.

> +static struct efct_lio_tpg *
> +efct_get_vport_tpg(struct efc_node_s *node)
> +{
> +	struct efct_s *efct;
> +	u64 wwpn = node->sport->wwpn;
> +	struct efct_lio_vport_list_t *vport, *next;
> +	struct efct_lio_vport *lio_vport = NULL;
> +	struct efct_lio_tpg *tpg = NULL;
> +	unsigned long flags = 0;
> +
> +	efct = node->efc->base;
> +	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
> +		list_for_each_entry_safe(vport, next,
> +				 &efct->tgt_efct.vport_list, list_entry) {
> +			lio_vport = vport->lio_vport;
> +			if (wwpn && lio_vport &&
> +			    lio_vport->npiv_wwpn == wwpn) {
> +				efc_log_test(efct, "found tpg on vport\n");
> +				tpg = lio_vport->tpg;
> +				break;
> +			}
> +		}
> +	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
> +	return tpg;
> +}

The indentation in this function is wrong. list_for_each_entry() should 
occur at the same level as spin_lock_irqsave().

> +/* local static data */

 > +/* local static data */

Are these comments useful?

> +#define LIO_IOFMT "[%04x][i:%0*x t:%0*x h:%04x][c:%02x]"
> +#define LIO_TMFIOFMT "[%04x][i:%0*x t:%0*x h:%04x][f:%02x]"
> +#define LIO_IOFMT_ITT_SIZE(efct)	4
> +
> +#define efct_lio_io_printf(io, fmt, ...) \
> +	efc_log_debug(io->efct, "[%s]" LIO_IOFMT " " fmt,	\
> +	io->node->display_name, io->instance_index,		\
> +	LIO_IOFMT_ITT_SIZE(io->efct), io->init_task_tag,		\
> +	LIO_IOFMT_ITT_SIZE(io->efct), io->tgt_task_tag, io->hw_tag,\
> +	(io->tgt_io.cdb ? io->tgt_io.cdb[0] : 0xFF), ##__VA_ARGS__)
> +#define efct_lio_tmfio_printf(io, fmt, ...) \
> +	efc_log_debug(io->efct, "[%s]" LIO_TMFIOFMT " " fmt,\
> +	io->node->display_name, io->instance_index,		\
> +	LIO_IOFMT_ITT_SIZE(io->efct), io->init_task_tag,		\
> +	LIO_IOFMT_ITT_SIZE(io->efct), io->tgt_task_tag, io->hw_tag,\
> +	io->tgt_io.tmf,  ##__VA_ARGS__)

Please remove the LIO_IOFMT, LIO_TMFIOFMT and LIO_IOFMT_ITT_SIZE macros 
and expand these macros where these are used. I think that will make the 
above logging functions much more easy to read.

> +#define efct_lio_io_state_trace(io, value) (io->tgt_io.state |= value)

This macro has "trace" in its name but does not trace anything. Please 
either remove this macro or choose a better name.

> +static int  efct_lio_tgt_session_data(struct efct_s *efct, u64 wwpn,
> +				      char *buf, int size)
> +{
> +	struct efc_sli_port_s *sport = NULL;
> +	struct efc_node_s *node = NULL;
> +	struct efc_lport *efc = efct->efcport;
> +	u16 loop_id = 0;
> +	int off = 0, rc = 0;
> +
> +	if (!efc->domain) {
> +		efc_log_err(efct, "failed to find efct/domain\n");
> +		return -1;
> +	}
> +
> +	list_for_each_entry(sport, &efc->domain->sport_list, list_entry) {
> +		if (sport->wwpn == wwpn) {
> +			list_for_each_entry(node, &sport->node_list,
> +					    list_entry) {
> +				/* Dump sessions only remote NPORT
> +				 * sessions
> +				 */
> +				if (efct_lio_node_is_initiator(node)) {
> +					rc = snprintf(buf + off,
> +						      size - off,
> +						"0x%016llx,0x%08x,0x%04x\n",
> +						be64_to_cpup((__force __be64 *)
> +								node->wwpn),
> +						node->rnode.fc_id,
> +						loop_id);
> +					if (rc < 0)
> +						break;
> +					off += rc;
> +				}
> +			}
> +		}
> +	}
> +
> +	buf[size - 1] = '\0';
> +	return 0;
> +}

Please use get_unaligned_be64() instead of using __force casts.

> +static const struct file_operations efct_debugfs_session_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= efct_debugfs_session_open,
> +	.release	= efct_debugfs_session_close,
> +	.read		= efct_debugfs_session_read,
> +	.write		= efct_debugfs_session_write,
> +	.llseek		= default_llseek,
> +};
> +
> +static const struct file_operations efct_npiv_debugfs_session_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= efct_npiv_debugfs_session_open,
> +	.release	= efct_debugfs_session_close,
> +	.read		= efct_debugfs_session_read,
> +	.write		= efct_debugfs_session_write,
> +	.llseek		= default_llseek,
> +};

Since the information that is exported through debugfs (logged in 
initiators) is information that is also useful for other target drivers, 
I think this functionality should be implemented in the target core 
instead of in this target driver.

> +/* command has been aborted, cleanup here */
> +static void efct_lio_aborted_task(struct se_cmd *se_cmd)
> +{
> +	int rc;
> +	struct efct_scsi_tgt_io_s *ocp = container_of(se_cmd,
> +						     struct efct_scsi_tgt_io_s,
> +						     cmd);
> +	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
> +
> +	efct_lio_io_trace(io, "%s\n", __func__);
> +	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_ABORTED_TASK);
> +
> +	if (!(se_cmd->transport_state & CMD_T_ABORTED) || ocp->rsp_sent)
> +		return;
> +
> +	/*
> +	 * if io is non-null, take a reference out on it so it isn't
> +	 * freed until the abort operation is complete.
> +	 */
> +	if (kref_get_unless_zero(&io->ref) == 0) {
> +		/* command no longer active */
> +		struct efct_s *efct = io->efct;
> +
> +		efc_log_test(efct,
> +			      "success: command no longer active (exists=%d)\n",
> +			     (io != NULL));
> +		return;
> +	}
> +
> +	efct_lio_io_printf(io, "CMD_T_ABORTED set, aborting=%d\n",
> +			   ocp->aborting);
> +	ocp->aborting = true;
> +	/* set to non-success so data moves won't continue */
> +	ocp->err = EFCT_SCSI_STATUS_ABORTED;
> +
> +	/* wait until abort is complete; once we return, LIO will call
> +	 * queue_tm_rsp() which will send response to TMF
> +	 */
> +	init_completion(&io->tgt_io.done);
> +
> +	rc = efct_scsi_tgt_abort_io(io, efct_lio_abort_tgt_cb, NULL);
> +	if (rc == 0) {
> +		/* wait for abort to complete before returning */
> +		rc = wait_for_completion_timeout(&io->tgt_io.done,
> +						 usecs_to_jiffies(10000000));
> +
> +		/* done with reference on aborted IO */
> +		kref_put(&io->ref, io->release);
> +
> +		if (rc) {
> +			efct_lio_io_printf(io,
> +					   "abort completed successfully\n");
> +			/* check if TASK_ABORTED status should be sent
> +			 * for this IO
> +			 */
> +		} else {
> +			efct_lio_io_printf(io,
> +					   "timeout waiting for abort completed\n");
> +		}
> +	} else {
> +		efct_lio_io_printf(io, "Failed to abort\n");
> +	}
> +}

The .aborted_task() callback function must not wait until the aborted 
command has finished but instead must free the resources owned by the 
aborted command.

The comment "check if TASK_ABORTED status should be sent for this IO" is 
wrong. .aborted_task() is only called if no response will be sent to the 
initiator.

> +/**
> + * @brief Housekeeping for LIO SG mapping.
> + *
> + * @param io Pointer to IO context.
> + *
> + * @return count Count returned by pci_map_sg.
> + */

The above comment follows the Doxygen syntax. Kernel function headers 
must use the kernel-doc syntax. See also 
Documentation/process/kernel-docs.rst.

> +static struct se_wwn *
> +efct_lio_make_sport(struct target_fabric_configfs *tf,
> +		    struct config_group *group, const char *name)
> +{
> +	struct efct_lio_sport *lio_sport;
> +	struct efct_s *efct;
> +	int efctidx, ret;
> +	u64 wwpn;
> +	char *sessions_name;
> +
> +	ret = efct_lio_parse_wwn(name, &wwpn, 0);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	/* Now search for the HBA that has this WWPN */
> +	for (efctidx = 0; efctidx < MAX_EFCT_DEVICES; efctidx++) {
> +		u64 pwwn;
> +		u8 pn[8];
> +
> +		efct = efct_devices[efctidx];
> +		if (!efct)
> +			continue;
> +		memcpy(pn, efct_hw_get_ptr(&efct->hw, EFCT_HW_WWN_PORT),
> +		       sizeof(pn));
> +		ARRAY2WWN(pwwn, pn);
> +		if (pwwn == wwpn)
> +			break;
> +	}
> +	if (efctidx == MAX_EFCT_DEVICES) {
> +		pr_err("cannot find EFCT for wwpn %s\n", name);
> +		return ERR_PTR(-ENXIO);
> +	}
> +	efct = efct_devices[efctidx];
> +	lio_sport = kzalloc(sizeof(*lio_sport), GFP_KERNEL);
> +	if (!lio_sport)
> +		return ERR_PTR(-ENOMEM);
> +	lio_sport->efct = efct;
> +	lio_sport->wwpn = wwpn;
> +	FABRIC_SNPRINTF(lio_sport->wwpn_str, sizeof(lio_sport->wwpn_str),
> +			"naa.", wwpn);
> +	efct->tgt_efct.lio_sport = lio_sport;
> +
> +	sessions_name = kasprintf(GFP_KERNEL, "efct-sessions-%d",
> +				  efct->instance_index);
> +	if (sessions_name && efct->sess_debugfs_dir)
> +		lio_sport->sessions = debugfs_create_file(sessions_name,
> +							  0644,
> +						efct->sess_debugfs_dir,
> +						lio_sport,
> +						&efct_debugfs_session_fops);
> +	kfree(sessions_name);
> +
> +	return &lio_sport->sport_wwn;
> +}
> +
> +static struct se_wwn *
> +efct_lio_npiv_make_sport(struct target_fabric_configfs *tf,
> +			 struct config_group *group, const char *name)
> +{
> +	struct efct_lio_vport *lio_vport;
> +	struct efct_s *efct;
> +	int efctidx, ret = -1;
> +	u64 p_wwpn, npiv_wwpn, npiv_wwnn;
> +	char *p, tmp[128];
> +	struct efct_lio_vport_list_t *vport_list;
> +	char *sessions_name;
> +	struct fc_vport *new_fc_vport;
> +	struct fc_vport_identifiers vport_id;
> +	unsigned long flags = 0;
> +
> +	snprintf(tmp, 128, "%s", name);
> +
> +	p = strchr(tmp, '@');
> +
> +	if (!p) {
> +		pr_err("Unable to find separator operator(@)\n");
> +		return ERR_PTR(ret);
> +	}
> +	*p++ = '\0';
> +
> +	ret = efct_lio_parse_wwn(tmp, &p_wwpn, 0);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = efct_lio_parse_npiv_wwn(p, strlen(p) + 1, &npiv_wwpn, &npiv_wwnn);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	 /* Now search for the HBA that has this WWPN */
> +	for (efctidx = 0; efctidx < MAX_EFCT_DEVICES; efctidx++) {
> +		u64 pwwn;
> +		u8 pn[8];
> +
> +		efct = efct_devices[efctidx];
> +		if (!efct)
> +			continue;
> +		if (!efct->xport->req_wwpn) {
> +			memcpy(pn, efct_hw_get_ptr(&efct->hw,
> +				   EFCT_HW_WWN_PORT), sizeof(pn));
> +			ARRAY2WWN(pwwn, pn);
> +		} else {
> +			pwwn = efct->xport->req_wwpn;
> +		}
> +		if (pwwn == p_wwpn)
> +			break;
> +	}
> +	if (efctidx == MAX_EFCT_DEVICES) {
> +		pr_err("cannot find EFCT for base wwpn %s\n", name);
> +		return ERR_PTR(-ENXIO);
> +	}
> +	efct = efct_devices[efctidx];
> +	lio_vport = kzalloc(sizeof(*lio_vport), GFP_KERNEL);
> +	if (!lio_vport)
> +		return ERR_PTR(-ENOMEM);
> +
> +	lio_vport->efct = efct;
> +	lio_vport->wwpn = p_wwpn;
> +	lio_vport->npiv_wwpn = npiv_wwpn;
> +	lio_vport->npiv_wwnn = npiv_wwnn;
> +
> +	FABRIC_SNPRINTF(lio_vport->wwpn_str, sizeof(lio_vport->wwpn_str),
> +			"naa.", npiv_wwpn);
> +
> +	vport_list = kmalloc(sizeof(*vport_list), GFP_KERNEL);
> +	if (!vport_list) {
> +		kfree(lio_vport);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	memset(vport_list, 0, sizeof(struct efct_lio_vport_list_t));
> +	vport_list->lio_vport = lio_vport;
> +	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
> +	INIT_LIST_HEAD(&vport_list->list_entry);
> +	list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
> +	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
> +
> +	sessions_name = kasprintf(GFP_KERNEL, "sessions-npiv-%d",
> +				  efct->instance_index);
> +	if (sessions_name && efct->sess_debugfs_dir)
> +		lio_vport->sessions = debugfs_create_file(sessions_name,
> +							  0644,
> +					   efct->sess_debugfs_dir,
> +					   lio_vport,
> +					   &efct_npiv_debugfs_session_fops);
> +	kfree(sessions_name);
> +	memset(&vport_id, 0, sizeof(vport_id));
> +	vport_id.port_name = npiv_wwpn;
> +	vport_id.node_name = npiv_wwnn;
> +	vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
> +	vport_id.vport_type = FC_PORTTYPE_NPIV;
> +	vport_id.disable = false;
> +
> +	new_fc_vport = fc_vport_create(efct->shost, 0, &vport_id);
> +	if (!new_fc_vport) {
> +		efc_log_err(efct, "fc_vport_create failed\n");
> +		kfree(lio_vport);
> +		kfree(vport_list);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	lio_vport->fc_vport = new_fc_vport;
> +
> +	return &lio_vport->vport_wwn;
> +}

Please rework efct_lio_make_sport() and efct_lio_npiv_make_sport() such 
that the amount of duplicate code is reduced significantly.

> +
> +	/* Create kernel worker thread to service async requests
> +	 * (new/delete initiator, new cmd/tmf). Previously, a worker thread
> +	 * was needed to make upcalls into LIO because the HW completion
> +	 * context ran in an interrupt context (tasklet).
> +	 * This is no longer necessary now that HW completions run in a
> +	 * kernel thread context. However, performance is much better when
> +	 * these types of reqs have their own thread.
> +	 *
> +	 * Note: We've seen better performance when IO completion (non-async)
> +	 * upcalls into LIO are not given an additional kernel thread.
> +	 * Thus,make such upcalls directly from the HW completion kernel thread
> +	 */
> +
> +	worker = &efct->tgt_efct.async_worker;
> +	efct_mqueue_init(efct, &worker->wq);
> +
> +	worker->thread = kthread_create((int(*)(void *)) efct_lio_async_worker,
> +					efct, "efct_lio_async_worker");
> +
> +	if (IS_ERR(worker->thread)) {
> +		efc_log_err(efct, "kthread_create failed: %ld\n",
> +			     PTR_ERR(worker->thread));
> +		worker->thread = NULL;
> +		return -1;
> +	}
> +
> +	wake_up_process(worker->thread);

Please use the kernel workqueue infrastructure instead of duplicating it.

> +/**
> + * @brief Worker thread for LIO commands.
> + *
> + * @par Description
> + * This thread is used to make LIO upcalls associated with
> + * asynchronous requests (i.e. new commands received, register
> + * sessions, unregister sessions).
> + *
> + * @param mythread Pointer to the thread object.
> + *
> + * @return Always returns 0.
> + */
> +static int efct_lio_async_worker(struct efct_s *efct)
> +{
> +	struct efct_lio_wq_data_s *wq_data;
> +	struct efc_node_s *node;
> +	struct se_session *se_sess;
> +	int done = 0;
> +	bool free_data = true;
> +	struct efct_scsi_tgt_io_s *ocp;
> +	int dir, rc = 0;
> +	struct efct_io_s *io;
> +	struct efct_io_s *tmfio;
> +	struct efct_scsi_tgt_node_s *tgt_node = NULL;
> +
> +	while (!done) {
> +		/* Poll with a timeout, to keep the kernel from complaining
> +		 * of not periodically running
> +		 */
> +		wq_data = efct_mqueue_get(&efct->tgt_efct.async_worker.wq,
> +					  10000000);
> +		if (kthread_should_stop())
> +			break;
> +
> +		if (!wq_data)
> +			continue;
> +
> [ ... ]
> +		}
> +		if (free_data)
> +			kfree(wq_data);
> +	}
> +
> +	complete(&efct->tgt_efct.async_worker.done);
> +
> +	return 0;
> +}

Same comment here: please use the kernel workqueue infrastructure 
instead of duplicating it.

> +#define scsi_pack_result(key, code, qualifier) (((key & 0xff) << 16) | \
> +				((code && 0xff) << 8) | (qualifier & 0xff))

Where is this macro used? I haven't found any uses of this macro in this 
patch.

> +#define FABRIC_SNPRINTF_LEN     32

Please choose a better name for this constant. Or even better, leave out 
this define entirely and use sizeof().

> +static inline int
> +efct_mqueue_init(struct efct_s *efct, struct efct_mqueue_s *q)
> +{
> +	memset(q, 0, sizeof(*q));
> +	q->efct = efct;
> +	spin_lock_init(&q->lock);
> +	init_completion(&q->prod);
> +	INIT_LIST_HEAD(&q->queue);
> +	return 0;
> +}

Functions that are not in the hot path should be defined in a .c file 
instead of in a header file.

Thanks,

Bart.
