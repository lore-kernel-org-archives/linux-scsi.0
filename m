From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] qedi: Fix truncation of name and secret
Date: Tue, 6 Feb 2018 07:11:27 +0000
Message-ID: <D69F4C24.28881%nilesh.javali@cavium.com>
References: <20180201065734.20441-1-nilesh.javali@cavium.com>
 <a8cbb894-63d9-ebb8-6ac0-c59118b08c61@suse.com>
 <37d8588f-5e80-5a5c-3e73-90555ee06ceb@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:5088
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750974AbeBFHL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 02:11:29 -0500
In-Reply-To: <37d8588f-5e80-5a5c-3e73-90555ee06ceb@suse.com>
Content-Language: en-US
Content-ID: <1C18CD40A0A5844FAA4340E6C3520679@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "cleech@redhat.com" <cleech@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>


On 2/6/18, 12:51 AM, "Lee Duncan" <lduncan@suse.com> wrote:

>On 02/05/2018 11:15 AM, Lee Duncan wrote:
>> On 01/31/2018 10:57 PM, Nilesh Javali wrote:
>>> Adjust the NULL byte added by snprintf.
>>>
>>> Signed-off-by: Nilesh Javali <nilesh.javali@cavium.com>
>>> ---
>>>  drivers/scsi/qedi/qedi_main.c | 12 ++++++------
>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/scsi/qedi/qedi_main.c
>>>b/drivers/scsi/qedi/qedi_main.c
>>> index cccc34a..cf8badb 100644
>>> --- a/drivers/scsi/qedi/qedi_main.c
>>> +++ b/drivers/scsi/qedi/qedi_main.c
>>> @@ -1840,7 +1840,7 @@ static ssize_t qedi_show_boot_ini_info(void
>>>*data, int type, char *buf)
>>> =20
>>>  	switch (type) {
>>>  	case ISCSI_BOOT_INI_INITIATOR_NAME:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
>>>  			      initiator->initiator_name.byte);
>>>  		break;
>>>  	default:
>>> @@ -1908,7 +1908,7 @@ static umode_t qedi_ini_get_attr_visibility(void
>>>*data, int type)
>>> =20
>>>  	switch (type) {
>>>  	case ISCSI_BOOT_TGT_NAME:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN + 1, "%s",
>>>  			      block->target[idx].target_name.byte);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_IP_ADDR:
>>> @@ -1930,19 +1930,19 @@ static umode_t
>>>qedi_ini_get_attr_visibility(void *data, int type)
>>>  			      block->target[idx].lun.value[0]);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_CHAP_NAME:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
>>>  			      chap_name);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_CHAP_SECRET:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
>>>  			      chap_secret);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN + 1, "%s",
>>>  			      mchap_name);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
>>> -		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN, "%s\n",
>>> +		rc =3D snprintf(str, NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN + 1, "%s",
>>>  			      mchap_secret);
>>>  		break;
>>>  	case ISCSI_BOOT_TGT_FLAGS:
>>>
>>=20
>> Reviewed-by: Lee Duncan <lduncan@suse.com>
>>=20
>
>Assuming you address Bart's comments.
>--=20
>Lee Duncan
>SUSE Labs

Bart, Lee,

Thanks for the review and comments. Please ignore the current patch.

The data in NVRAM is not guaranteed to be NUL terminated.
Hence in V2 solution, the data would be copied upto the element size or to
the first NUL
in the byte-stream and then append a NUL.

I would post V2 of the solution shortly.


Thanks,
Nilesh
