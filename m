From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: fix compiler warning in lpfc_bus_reset_handler
Date: Wed, 20 Aug 2008 12:13:47 -0400
Message-ID: <48AC42BB.70703@emulex.com>
References: <1213498358.10002.10.camel@localhost.localdomain> <1219242909-9068-1-git-send-email-bhalevy@panasas.com> <48AC3F44.4010005@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58339 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYHTQOI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 12:14:08 -0400
In-Reply-To: <48AC3F44.4010005@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Benny Halevy <bhalevy@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Actually, I'm about to post another set of patches, and this fix is=20
included. So pick it up there...

-- james s

Smart, James wrote:
> Acked-by: James Smart <james.smart@emulex.com>
>=20
> -- james s
>=20
> Benny Halevy wrote:
>> gcc 4.3.0 prints this warning:
>>
>> drivers/scsi/lpfc/lpfc_scsi.c: In function =E2=80=98lpfc_bus_reset_h=
andler=E2=80=99:
>> drivers/scsi/lpfc/lpfc_scsi.c:1245:\
>>  warning: =E2=80=98status=E2=80=99 may be used uninitialized in this=
 function
>>
>> It seems like the warning is bogus.  However, this patch makes
>> sure status is always initialized before used.
>>
>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  drivers/scsi/lpfc/lpfc_scsi.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_=
scsi.c
>> index 1bcebbd..9eda9b2 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -1278,8 +1278,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>>                                                      ndlp->rport->dd=
_data);
>>                         if (status !=3D TIMEOUT_ERROR)
>>                                 lpfc_release_scsi_buf(phba, lpfc_cmd=
);
>> -               }
>> -               if (!lpfc_cmd || status !=3D SUCCESS) {
>> +               } else
>> +                       status =3D FAILED;
>> +               if (status !=3D SUCCESS) {
>>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
>>                                          "0700 Bus Reset on target %=
d failed\n",
>>                                          i);
>> --
>> 1.6.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
