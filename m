From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v7] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Thu, 23 Jun 2016 11:17:09 -0500
Message-ID: <7BD61114-FF3C-4DBA-9B18-A12588DD7B8F@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1466433229-8812-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <20160623142213.GA30453@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21572 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634AbcFWQRR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2016 12:17:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5NGDl1J145466
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 12:17:17 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23q6r60tx1-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 12:17:16 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Thu, 23 Jun 2016 10:17:14 -0600
In-Reply-To: <20160623142213.GA30453@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: nab@linux-iscsi.org, joe@perches.com, mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com



On 6/23/16, 9:22 AM, "Christoph Hellwig" <target-devel-owner@vger.kerne=
l.org on behalf of hch@infradead.org> wrote:

>> -config SCSI_SRP
>> -	tristate "SCSI RDMA Protocol helper library"
>> -	depends on SCSI && PCI
>> -	select SCSI_TGT
>> -	help
>> -	  If you wish to use SRP target drivers, say Y.
>> -
>> -	  To compile this driver as a module, choose M here: the
>> -	  module will be called libsrp.
>> -
>
>Please split that removal of libsrp into a separate patch before
>adding the new driver.

Why do you suggest splitting the path up for the libsrp stuff? The curr=
ent upstream
does not contain libsrp. The only reason the patch shows that there is =
a removal of
libsrp is that James Bottomley suggested doing a revert of:=20
libsrp: removal - commit f6667938cfceefd8afe6355ceb6497dce4883ae9
to make it clear that I=E2=80=99m bringing back what had existed a year=
 ago within the upstream.

>
>> new file mode 100644
>> index 0000000..887574d
>> --- /dev/null
>> +++ b/drivers/scsi/ibmvscsi_tgt/Makefile
>> @@ -0,0 +1,4 @@
>> +obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvscsis.o
>> +
>> +ibmvscsis-objs :=3D libsrp.o ibmvscsi_tgt.o
>
>please use module-y for adding objects.  Also what's the reason
>for splitting these files?
>

I will change to module-y. The reason is we are possibly going to write
another target fabric in the future with the IBMVFC driver so just inca=
se
we want to leave it separated for now.=20

>> +/******************************************************************=
*************
>> + * IBM Virtual SCSI Target Driver
>> + * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM =
Corp.
>> + *			   Santiago Leon (santil@us.ibm.com) IBM Corp.
>> + *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
>> + *
>> + * Copyright (C) 2005-2011 FUJITA Tomonori <tomof@acm.org>
>> + * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
>> + * Copyright (C) 2016 Bryant G. Ly <bryantly@linux.vnet.ibm.com> IB=
M Corp.
>> + *
>> + * Authors: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
>> + * Authors: Michael Cyr <mikecyr@linux.vnet.ibm.com>
>
>What's the reational for the copyright vs Authors lines?

No reason, ill remove the copyright.=20

>
>> +#include "ibmvscsi_tgt.h"
>> +
>> +#ifndef H_GET_PARTNER_INFO
>> +#define H_GET_PARTNER_INFO      0x0000000000000008LL
>> +#endif
>
>Should this be in a header with the other hcalls?

Yes, Moved.

>
>> +static const char ibmvscsis_driver_name[] =3D "ibmvscsis";
>
>I think you can just assign the name directly in the driver ops
>structure.

=46ixed.

>
>> +static const char ibmvscsis_workq_name[] =3D "ibmvscsis";
>
>This one seems unused.

Removed

>
>> +		vscsi->flags &=3D (~PROCESSING_MAD);
>
>No need for the braces here. (ditto for many other places later on)
>
>> +static long ibmvscsis_parse_command(struct scsi_info *vscsi,
>> +				    struct viosrp_crq *crq);
>
>Can you avoid forward declarations where easily possible, and if not
>keep them all at the beginning of the file?

Will do.

<SNIP>

>> +static int ibmvscsis_alloc_cmds(struct scsi_info *vscsi, int num)
>> +{
>> +	struct ibmvscsis_cmd *cmd;
>> +	int i;
>> +
>> +	INIT_LIST_HEAD(&vscsi->free_cmd);
>> +	vscsi->cmd_pool =3D kcalloc(num, sizeof(struct ibmvscsis_cmd),
>> +				  GFP_KERNEL);
>> +	if (!vscsi->cmd_pool)
>> +		return -ENOMEM;
>> +
>> +	for (i =3D 0, cmd =3D (struct ibmvscsis_cmd *)vscsi->cmd_pool; i <=
 num;
>> +	     i++, cmd++) {
>> +		cmd->adapter =3D vscsi;
>> +		INIT_WORK(&cmd->work, ibmvscsis_scheduler);
>> +		list_add_tail(&cmd->list, &vscsi->free_cmd);
>> +	}
>> +
>> +	return 0;
>> +}
>
>Why can't you use the existing infrastructure for cmd pools in the
>target core?
>

I wasn=E2=80=99t aware there was existing infrastructure.

<SNIP>

>> +	rc =3D srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdm=
a, 1,
>> +			       1);
>> +	if (rc) {
>> +		pr_err("srp_transfer_data failed: %d\n", rc);
>> +		sd =3D se_cmd->sense_buffer;
>> +		se_cmd->scsi_sense_length =3D 18;
>> +		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
>> +		/* Current error */
>> +		sd[0] =3D 0x70;
>> +		/* sense key =3D Medium Error */
>> +		sd[2] =3D 3;
>> +		/* additional length (length - 8) */
>> +		sd[7] =3D 10;
>> +		/* asc/ascq 0x801 =3D Logical Unit Communication time-out */
>> +		sd[12] =3D 8;
>> +		sd[13] =3D 1;
>
>The Fabrics driver shouldn't generate it's own sense codes.  This
>would for example break for a lun using descriptor format sense data.

Changed to:

        if (rc) {
                pr_err("srp_transfer_data failed: %d\n", rc);
                sd =3D se_cmd->sense_buffer;
                se_cmd->scsi_sense_length =3D 18;
                memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_leng=
th);
                /* Fixed/Current Error =3D 0
                 * Sense Key =3D Medium Error (0x03)
                 * Additonal Length =3D 0xa
                 * Logical Unit Communication Time-out asc/ascq =3D 0x8=
01
                 */
                scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM=
_ERROR,
                                        0x08, 0x01);
        }

>--
>To unsubscribe from this list: send the line "unsubscribe target-devel=
" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
