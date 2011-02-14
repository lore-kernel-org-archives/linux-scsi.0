From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 10:42:54 +0900
Message-ID: <20110214104108N.fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4D543951.2000207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33678 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab1BNBnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2011 20:43:02 -0500
In-Reply-To: <4D543951.2000207@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, nab@linux-iscsi.org

On Thu, 10 Feb 2011 13:15:29 -0600
Brian King <brking@linux.vnet.ibm.com> wrote:

> On 02/10/2011 06:21 AM, FUJITA Tomonori wrote:
> 
> > +static int process_mad_iu(struct iu_entry *iue)
> > +{
> > +	union viosrp_iu *iu = vio_iu(iue);
> > +	struct viosrp_adapter_info *info;
> > +	struct viosrp_host_config *conf;
> > +
> > +	switch (iu->mad.empty_iu.common.type) {
> > +	case VIOSRP_EMPTY_IU_TYPE:
> > +		printk(KERN_ERR "%s\n", "Unsupported EMPTY MAD IU");
> > +		break;
> > +	case VIOSRP_ERROR_LOG_TYPE:
> > +		printk(KERN_ERR "%s\n", "Unsupported ERROR LOG MAD IU");
> > +		iu->mad.error_log.common.status = 1;
> > +		send_iu(iue, sizeof(iu->mad.error_log),	VIOSRP_MAD_FORMAT);
> > +		break;
> > +	case VIOSRP_ADAPTER_INFO_TYPE:
> > +		info = &iu->mad.adapter_info;
> > +		info->common.status = send_adapter_info(iue, info->buffer,
> > +							info->common.length);
> > +		send_iu(iue, sizeof(*info), VIOSRP_MAD_FORMAT);
> > +		break;
> > +	case VIOSRP_HOST_CONFIG_TYPE:
> > +		conf = &iu->mad.host_config;
> > +		conf->common.status = 1;
> > +		send_iu(iue, sizeof(*conf), VIOSRP_MAD_FORMAT);
> > +		break;
> > +	default:
> > +		printk(KERN_ERR "Unknown type %u\n", iu->srp.rsp.opcode);
> 
> We should be sending back the MAD not supported response here (0xF1):
> 
> iu->mad.common.status = 0xF1;
> send_iu(iue, sizeof(iu->mad.common), VIOSRP_MAD_FORMAT);
> 
> Should also be doing this for the unsupported MAD types above, otherwise
> the client never receives a response to these commands and times them out.

I'll fix.


> > +static int ibmvscsis_inquery(struct ibmvscsis_adapter *adapter,
> 
> /inquery/inquiry/

Oops.


> > +			      struct srp_cmd *cmd, char *data)
> > +{
> > +	struct se_portal_group *se_tpg = &adapter->se_tpg;
> > +	struct inquiry_data *id = (struct inquiry_data *)data;
> > +	u64 unpacked_lun, lun = cmd->lun;
> > +	u8 *cdb = cmd->cdb;
> > +	int len;
> > +
> > +	if (!data)
> > +		printk(KERN_INFO "%s %d: oomu\n", __func__, __LINE__);
> > +
> > +	if (((cdb[1] & 0x3) == 0x3) || (!(cdb[1] & 0x3) && cdb[2])) {
> > +		printk(KERN_INFO "%s %d: invalid req\n", __func__, __LINE__);
> > +		return 0;
> > +	}
> > +
> > +	if (cdb[1] & 0x3)
> > +		printk(KERN_INFO "%s %d: needs the normal path\n",
> > +		       __func__, __LINE__);
> > +	else {
> > +		id->qual_type = TYPE_DISK;
> > +		id->rmb_reserve = 0x00;
> > +		id->version = 0x84; /* ISO/IE */
> > +		id->aerc_naca_hisup_format = 0x22; /* naca & fmt 0x02 */
> > +		id->addl_len = sizeof(*id) - 4;
> > +		id->bque_encserv_vs_multip_mchngr_reserved = 0x00;
> > +		id->reladr_reserved_linked_cmdqueue_vs = 0x02; /* CMDQ */
> > +		memcpy(id->vendor, "IBM	    ", 8);
> > +		/*
> > +		 * Don't even ask about the next bit.  AIX uses
> > +		 * hardcoded device naming to recognize device types
> > +		 * and their client won't  work unless we use VOPTA and
> > +		 * VDASD.
> > +		 */
> > +		if (id->qual_type == TYPE_ROM)
> > +			memcpy(id->product, "VOPTA blkdev    ", 16);
> > +		else
> > +			memcpy(id->product, "VDASD blkdev    ", 16);
> > +
> > +		memcpy(id->revision, "0001", 4);
> > +
> > +		snprintf(id->unique, sizeof(id->unique),
> > +			 "IBM-VSCSI-%s-P%d-%x-%d-%d-%d\n",
> > +			 system_id,
> > +			 partition_number,
> > +			 adapter->dma_dev->unit_address,
> > +			 GETBUS(lun),
> > +			 GETTARGET(lun),
> > +			 GETLUN(lun));
> > +	}
> 
> Do we have any persistent unique identifying data which we could use to
> build a page 0x83 response such that persistent naming would work in the client?

I guess that we could enable it to be configured via configfs.

Thanks,
