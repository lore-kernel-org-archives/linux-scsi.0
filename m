From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/7] qla2xxx: Added change to enable ZIO for FC-NVMe
 devices
Date: Thu, 20 Jul 2017 09:00:16 +0200
Message-ID: <20170720070016.GE5240@linux-x5ow.site>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
 <20170719185151.8564-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34859 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751810AbdGTHAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jul 2017 03:00:21 -0400
Content-Disposition: inline
In-Reply-To: <20170719185151.8564-5-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Wed, Jul 19, 2017 at 11:51:48AM -0700, Himanshu Madhani wrote:
> +	mcp->out_mb = MBX_2|MBX_1|MBX_0;
> +	mcp->in_mb = MBX_2|MBX_0;

Please add spaces around the '|'. Checkpatch should've warned you about that.

> +	mcp->tov = MBX_TOV_SECONDS;
> +	mcp->flags = 0;
> +
> +	rval = qla2x00_mailbox_command(vha, mcp);
> +	if (rval != QLA_SUCCESS) {
> +		ql_dbg(ql_dbg_mbx, vha, 0x1201, "Failed=%x.\n", rval);
> +	} else {
> +		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1202,
> +		    "Done %s.\n", __func__);
> +	}

In patch 1 you change all the 
if (rval != QLA_SUCCESS) {
	qla_dbg();
} else {
	qla_dbg();
}
into a single qla_dbg. Now you re-introduce the pattern here.


> +int qla27xx_get_zio_threshold(scsi_qla_host_t *vha, uint16_t *value)

See above comment

Thanks,	
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
