From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Mon, 09 Nov 2015 16:05:53 +0100
Message-ID: <5640B651.1010506@suse.de>
References: <1447080465-17858-1-git-send-email-lvivier@redhat.com> <1447080465-17858-4-git-send-email-lvivier@redhat.com> <5640B2A6.20401@suse.de> <5640B4DC.9010706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbbKIPFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:05:55 -0500
In-Reply-To: <5640B4DC.9010706@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: martin.petersen@oracle.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/09/2015 03:59 PM, Laurent Vivier wrote:
>=20
>=20
> On 09/11/2015 15:50, Hannes Reinecke wrote:
>> On 11/09/2015 03:47 PM, Laurent Vivier wrote:
>>> This patch allows to define the maximum LUN numbers.
>>> As defined in 4.6.9 of SAM-4, the encoding of LUN is
>>> on 5 bits (max_lun=3D32) and the current value is only 8.
>>>
>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>> ---
>>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 9 ++++++++-
>>>  drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
>>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvsc=
si/ibmvscsi.c
>>> index 04de287..adcd5e8 100644
>>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>>> @@ -84,6 +84,7 @@
>>>   */
>>>  static int max_id =3D 64;
>>>  static int max_channel =3D 3;
>>> +static int max_lun =3D 8;
>>>  static int init_timeout =3D 300;
>>>  static int login_timeout =3D 60;
>>>  static int info_timeout =3D 30;
>>> @@ -117,6 +118,9 @@ module_param_named(fast_fail, fast_fail, int, S=
_IRUGO | S_IWUSR);
>>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=3D1]");
>>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/r=
elease");
>>> +module_param(max_lun, int, S_IRUGO);
>>> +MODULE_PARM_DESC(max_lun, "Maximum allowed LUN "
>>> +                          "[Default=3D8,Max=3D"__stringify(IBMVSCS=
I_MAX_LUN)"]");
>>> =20
>>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>>  				struct ibmvscsi_host_data *hostdata);
>>> @@ -2289,7 +2293,7 @@ static int ibmvscsi_probe(struct vio_dev *vde=
v, const struct vio_device_id *id)
>>>  		goto init_pool_failed;
>>>  	}
>>> =20
>>> -	host->max_lun =3D 8;
>>> +	host->max_lun =3D max_lun;
>>>  	host->max_id =3D max_id;
>>>  	host->max_channel =3D max_channel;
>>>  	host->max_cmd_len =3D 16;
>>> @@ -2414,6 +2418,9 @@ int __init ibmvscsi_module_init(void)
>>>  {
>>>  	int ret;
>>> =20
>>> +	if (max_lun > IBMVSCSI_MAX_LUN)
>>> +		return -EINVAL;
>>> +
>>>  	/* Ensure we have two requests to do error recovery */
>>>  	driver_template.can_queue =3D max_requests;
>>>  	max_events =3D max_requests + 2;
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvsc=
si/ibmvscsi.h
>>> index 7d64867..1067367 100644
>>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.h
>>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
>>> @@ -48,6 +48,7 @@ struct Scsi_Host;
>>>  #define IBMVSCSI_CMDS_PER_LUN_DEFAULT 16
>>>  #define IBMVSCSI_MAX_SECTORS_DEFAULT 256 /* 32 * 8 =3D default max=
 I/O 32 pages */
>>>  #define IBMVSCSI_MAX_CMDS_PER_LUN 64
>>> +#define IBMVSCSI_MAX_LUN 32
>>> =20
>>>  /* ------------------------------------------------------------
>>>   * Data Structures
>>>
>> Please set max_lun to 31, and remove everything else.
>> As discussed, max_lun is the max number of LUNs supported by the
>> hardware/HBA. There is no point in restricting it further.
>=20
> You mean no module parameter and a simple "host->max_lun =3D 31" ?
>=20
Yes.

> I'm wondering if it should be "host->max_lun =3D 32". What about this=
 ?
>=20
'max_lun' is used as the stopping condition while scanning LUNs
sequentially in drivers/scsi/scsi_scan.c:

	for (lun =3D 1; lun < max_dev_lun; ++lun)
		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
					    NULL) !=3D SCSI_SCAN_LUN_PRESENT) &&

so indeed it needs to be set to '32'.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
