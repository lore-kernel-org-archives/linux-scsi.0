From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Wed, 04 Nov 2015 14:02:04 +0100
Message-ID: <563A01CC.20809@suse.de>
References: <1446632451-22365-1-git-send-email-lvivier@redhat.com> <1446632451-22365-4-git-send-email-lvivier@redhat.com> <5639E904.1070100@suse.de> <5639F020.4010308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5639F020.4010308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>, martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/04/2015 12:46 PM, Laurent Vivier wrote:
>=20
>=20
> On 04/11/2015 12:16, Hannes Reinecke wrote:
>> On 11/04/2015 11:20 AM, Laurent Vivier wrote:
>>> QEMU allows until 32 LUNs.
>>>
>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>> ---
>>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvsc=
si/ibmvscsi.c
>>> index 04de287..4480d3e 100644
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
>>> @@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S=
_IRUGO | S_IWUSR);
>>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=3D1]");
>>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/r=
elease");
>>> +module_param(max_lun, int, S_IRUGO);
>>> +MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=3D8]");
>>> =20
>>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>>  				struct ibmvscsi_host_data *hostdata);
>>> @@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vde=
v, const struct vio_device_id *id)
>>>  		goto init_pool_failed;
>>>  	}
>>> =20
>>> -	host->max_lun =3D 8;
>>> +	host->max_lun =3D max_lun;
>>>  	host->max_id =3D max_id;
>>>  	host->max_channel =3D max_channel;
>>>  	host->max_cmd_len =3D 16;
>>>
>> Please, don't do this.
>>
>> 'max_lun' should only be set if the HBA / transport has some hard
>> limitations on the number of bytes it can use.
>> Otherwise the scanning algorithm in scsi_scan.c should do the
>> correct thing, independent on the 'max_lun' setting.
>=20
> So you are saying we can remove the line ?
>=20
Ho-hum. In principle you could, as ibmvscsi is using SRP internally,
which does support 64 bit LUNs.

However, due to some weird design decisions there is
the function 'lun_from_dev()', which mangles the incoming LUN number
into something ... else.
Which leaves only 4 bits free for the actual LUN number, requiring
you to use max_lun =3D 16.

Personally I would just do away with that function and use the
incoming LUN numbers as is.

Brian? Any comments?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
