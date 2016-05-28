From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Sat, 28 May 2016 02:19:36 -0700
Message-ID: <20160528091936.GA10153@infradead.org>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, James.Bottomley@HansenPartnership.com, bart.vanassche@sandisk.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A few comments below, not really a full review yet:

> When reviving the old libsrp, I stripped out all that utilized
> scsi to submit commands to the target. Hence there is no more
> scsi_tgt_if_*, and scsi_transport_* files and fully utilizes
> LIO instead. This driver does however use the SRP protocol
> for communication between guests/and or hosts, but its all
> synchronous data transfers due to the utilization of
> H_COPY_RDMA, a VIO mechanism which means that others like
> ib_srp, ib_srpt which are asynchronous can't use this driver.
> This was also the reason for moving libsrp out of the
> drivers/scsi/. and into the ibmvscsi folder.

Is there any chared code with the ibmvscsi initiator?  If yes please
make the initiator use it.  If not please drop the separate libsrp
concept and add the code directly to the vscsi target driver.

> +config SCSI_SRP
> +	tristate "SCSI RDMA Protocol helper library"
> +	depends on SCSI && PCI
> +	help
> +	  This SCSI SRP module is a library for ibmvscsi target driver.
> +	  This module can only be used by SRP drivers that utilize synchron=
ous
> +	  data transfers and not by SRP drivers that use asynchronous.
> +
> +	  If you wish to use SRP target drivers, say Y.
> +
> +	  To compile this driver as a module, choose M here. The module wil=
l
> +	  be called libsrp.

But either way this shouldn't an exposed config option.

> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_tcq.h>

Most of this shouldn't be needed in a target driver, please
start with scsi/scsi_proto.h and scsi/scsi_common.h and see if you
really need anything else.

> +#include <target/target_core_backend.h>

As the name suggest this is for storage backends, a fronted driver
shouldn't really need it.

> +static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
> +{
> +	struct se_device *dev =3D se_cmd->se_dev;
> +	u32 cmd_len =3D se_cmd->data_length;
> +	unsigned char *buf =3D NULL;
> +
> +	if (cmd_len <=3D INQ_DATA_OFFSET)
> +		return;
> +
> +	buf =3D transport_kmap_data_sg(se_cmd);
> +	if (buf) {
> +		memcpy(&buf[8], "IBM	     ", 8);
> +		if (dev->transport->get_device_type(dev) =3D=3D TYPE_ROM)
> +			memcpy(&buf[16], "VOPTA           ", 16);
> +		else
> +			memcpy(&buf[16], "3303      NVDISK", 16);
> +		memcpy(&buf[32], "0001", 4);
> +		transport_kunmap_data_sg(se_cmd);
> +	}
> +}

Eww, why?

> +static struct se_portal_group *ibmvscsis_make_nexus(struct ibmvscsis=
_tport
> +						    *tport,
> +						    const char *name)
> +{
> +	struct se_node_acl *acl;
> +
> +	if (tport->se_sess) {
> +		pr_debug("tport->se_sess already exists\n");
> +		return &tport->se_tpg;
> +	}
> +
> +	/*
> +	 *  Initialize the struct se_session pointer and setup tagpool
> +	 *  for struct ibmvscsis_cmd descriptors
> +	 */
> +	tport->se_sess =3D transport_init_session(TARGET_PROT_NORMAL);
> +	if (IS_ERR(tport->se_sess))
> +		goto transport_init_fail;

Please use target_alloc_session instead of open coding it.

> +static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
> +			    struct ibmvscsis_cmd *vsc,
> +			    struct srp_cmd *scmd)
> +{

should be merged into the caller.

> +	unpacked_lun =3D ibmvscsis_unpack_lun((u8 *)&scmd->lun,
> +					    sizeof(scmd->lun));

Thois should probably use scsilun_to_int, see commit
e1dd413ccff7a35c4d8b14781668ed27bae64823 in the srp target for =E6n
example.

> +	ret =3D target_submit_cmd(se_cmd, adapter->tport.se_sess,
> +				&scmd->cdb[0], &vsc->sense_buf[0], unpacked_lun,
> +				data_len, attr, srp_cmd_direction(scmd),
> +				TARGET_SCF_ACK_KREF);
> +	if (ret !=3D 0) {
> +		ret =3D TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +		pr_debug("tcm_queuecommand fail submit_cmd\n");
> +		goto send_sense;
> +	}
> +	return 0;
> +
> +send_sense:
> +	transport_send_check_condition_and_sense(&vsc->se_cmd, ret, 0);
> +	transport_generic_free_cmd(&vsc->se_cmd, 0);

this will cause a crash if target_submit_cmd failed.

> +static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
> +				  struct iu_entry *iue)

please give this function a more sensible name. =20

> +	if (scsi_sg_count(sc)) {
> +		if (srp->cdb[0] =3D=3D REPORT_LUNS &&
> +		    adapter->client_data.os_type !=3D LINUX)
> +			ibmvscsis_modify_rep_luns(se_cmd);

A fabrics driver has no business doing this.  Add support to the
core for different LUN addressing modes instead.
