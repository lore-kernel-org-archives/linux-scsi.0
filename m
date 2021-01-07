Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45ACC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 17:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED5D23428
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 17:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbhAGRyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 12:54:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbhAGRyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 12:54:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107Hj0NV120116;
        Thu, 7 Jan 2021 17:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8QyeGNO3YqoTH+m/1zpUJa/W+f5MpfAvttRUc5/bmOI=;
 b=XvwbZDRCsjpKUSnndLGi9g1zl06eSgLl4DwkDuftPmDpK4jLyGya2JhyhMMFa9xQhOxr
 CoArH7vMi0aTivSEdepfRMjjKE5aYO5oUDuCwmtedvlQ90HRaTUB0rt0uJrXWubvhZIx
 065hjlG+3/lEGBO/p3T66mx0dV/QZ9/NtXAtjN2OTzxMcj6SdYjm1EujPiJ55JIuILrC
 56r+7KRrRVLyRyFmo0G0ZUzafvgPOAODKlUHGS3MduPF/tv4W5MTqgTxcTQqdIuIZy0C
 P0i1wRnCHn/mvPCzDSpEUjAo1pam9hPym8uWky8Yna7ZpOKBSJjxXIXBD7hxfjyIcQ4D 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmdjr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 17:54:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107HkYgf032486;
        Thu, 7 Jan 2021 17:52:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35w3qu1c60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 17:52:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107Hq7wQ008443;
        Thu, 7 Jan 2021 17:52:07 GMT
Received: from [192.168.63.242] (/71.42.68.90)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 17:51:45 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [EXT] [PATCH v3 3/7] qla2xxx: Move some messages from debug to
 normal log level
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <BN8PR18MB30258A9BFBC37C8C9CB9E80DD2AF9@BN8PR18MB3025.namprd18.prod.outlook.com>
Date:   Thu, 7 Jan 2021 11:51:45 -0600
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C683E56E-D2E2-448A-B8F3-959161A5D352@oracle.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-4-njavali@marvell.com>
 <DABC7D0B-6734-4229-9812-DB573235246F@oracle.com>
 <BN8PR18MB30258A9BFBC37C8C9CB9E80DD2AF9@BN8PR18MB3025.namprd18.prod.outlook.com>
To:     Saurav Kashyap <skashyap@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 6, 2021, at 11:51 PM, Saurav Kashyap <skashyap@marvell.com> =
wrote:
>=20
> Hi Himanshu,
> Thanks for the review, comments inline..
>=20
>> -----Original Message-----
>> From: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Sent: Wednesday, January 6, 2021 8:37 PM
>> To: Nilesh Javali <njavali@marvell.com>; Saurav Kashyap
>> <skashyap@marvell.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>; linux-
>> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
>> Upstream@marvell.com>
>> Subject: [EXT] Re: [PATCH v3 3/7] qla2xxx: Move some messages from =
debug to
>> normal log level
>>=20
>> External Email
>>=20
>> =
----------------------------------------------------------------------
>> Hi Saurav,
>>=20
>>> On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>>>=20
>>> From: Saurav Kashyap <skashyap@marvell.com>
>>>=20
>>> This change will aid in debugging issues where debug level is not =
set.
>>>=20
>>> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
>>> Signed-off-by: Nilesh Javali <njavali@marvell.com>
>>> ---
>>> drivers/scsi/qla2xxx/qla_init.c | 10 +++----
>>> drivers/scsi/qla2xxx/qla_isr.c  | 52 =
++++++++++++++++-----------------
>>> 2 files changed, 30 insertions(+), 32 deletions(-)
>>>=20
>>> diff --git a/drivers/scsi/qla2xxx/qla_init.c =
b/drivers/scsi/qla2xxx/qla_init.c
>>> index 410ff5534a59..221369cdf71f 100644
>>> --- a/drivers/scsi/qla2xxx/qla_init.c
>>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>>> @@ -347,11 +347,11 @@ qla2x00_async_login(struct scsi_qla_host *vha,
>> fc_port_t *fcport,
>>> 	if (NVME_TARGET(vha->hw, fcport))
>>> 		lio->u.logio.flags |=3D SRB_LOGIN_SKIP_PRLI;
>>>=20
>>> -	ql_dbg(ql_dbg_disc, vha, 0x2072,
>>> -	    "Async-login - %8phC hdl=3D%x, loopid=3D%x =
portid=3D%02x%02x%02x "
>>> -		"retries=3D%d.\n", fcport->port_name, sp->handle, =
fcport-
>>> loop_id,
>>> -	    fcport->d_id.b.domain, fcport->d_id.b.area, =
fcport->d_id.b.al_pa,
>>> -	    fcport->login_retry);
>>> +	ql_log(ql_log_warn, vha, 0x2072,
>>> +	       "Async-login - %8phC hdl=3D%x, loopid=3D%x =
portid=3D%02x%02x%02x
>> retries=3D%d.\n",
>>> +	       fcport->port_name, sp->handle, fcport->loop_id,
>>> +	       fcport->d_id.b.domain, fcport->d_id.b.area, =
fcport->d_id.b.al_pa,
>>> +	       fcport->login_retry);
>>>=20
>>> 	rval =3D qla2x00_start_sp(sp);
>>> 	if (rval !=3D QLA_SUCCESS) {
>>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c =
b/drivers/scsi/qla2xxx/qla_isr.c
>>> index 9cf8326ab9fc..bfc8bbaeea46 100644
>>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>>> @@ -1455,9 +1455,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, =
struct
>> rsp_que *rsp, uint16_t *mb)
>>> 		if (ha->flags.npiv_supported && vha->vp_idx !=3D (mb[3] =
& 0xff))
>>> 			break;
>>>=20
>>> -		ql_dbg(ql_dbg_async, vha, 0x5013,
>>> -		    "RSCN database changed -- %04x %04x %04x.\n",
>>> -		    mb[1], mb[2], mb[3]);
>>> +		ql_log(ql_log_warn, vha, 0x5013,
>>> +		       "RSCN database changed -- %04x %04x %04x.\n",
>>> +		       mb[1], mb[2], mb[3]);
>>>=20
>>> 		rscn_entry =3D ((mb[1] & 0xff) << 16) | mb[2];
>>> 		host_pid =3D (vha->d_id.b.domain << 16) | =
(vha->d_id.b.area <<
>> 8)
>>> @@ -2221,12 +2221,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, =
struct
>> req_que *req,
>>> 		break;
>>> 	}
>>>=20
>>> -	ql_dbg(ql_dbg_async, sp->vha, 0x5037,
>>> -	    "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC
>> comp_status=3D%x iop0=3D%x iop1=3D%x\n",
>>> -	    type, sp->handle, fcport->d_id.b24, fcport->port_name,
>>> -	    le16_to_cpu(logio->comp_status),
>>> -	    le32_to_cpu(logio->io_parameter[0]),
>>> -	    le32_to_cpu(logio->io_parameter[1]));
>>> +	ql_log(ql_log_warn, sp->vha, 0x5037,
>>> +	       "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC
>> comp_status=3D%x iop0=3D%x iop1=3D%x\n",
>>> +	       type, sp->handle, fcport->d_id.b24, fcport->port_name,
>>> +	       le16_to_cpu(logio->comp_status),
>>> +	       le32_to_cpu(logio->io_parameter[0]),
>>> +	       le32_to_cpu(logio->io_parameter[1]));
>>>=20
>>> logio_done:
>>> 	sp->done(sp, 0);
>>> @@ -2389,9 +2389,9 @@ static void
>> qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>>>=20
>>> 		tgt_xfer_len =3D be32_to_cpu(rsp_iu->xfrd_len);
>>> 		if (fd->transferred_length !=3D tgt_xfer_len) {
>>> -			ql_dbg(ql_dbg_io, fcport->vha, 0x3079,
>>> -				"Dropped frame(s) detected
>> (sent/rcvd=3D%u/%u).\n",
>>> -				tgt_xfer_len, fd->transferred_length);
>>> +			ql_log(ql_log_warn, fcport->vha, 0x3079,
>>> +			       "Dropped frame(s) detected
>> (sent/rcvd=3D%u/%u).\n",
>>> +			       tgt_xfer_len, fd->transferred_length);
>>> 			logit =3D 1;
>>> 		} else if (le16_to_cpu(comp_status) =3D=3D =
CS_DATA_UNDERRUN) {
>>> 			/*
>>> @@ -3112,9 +3112,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct
>> rsp_que *rsp, void *pkt)
>>> 		scsi_set_resid(cp, resid);
>>> 		if (scsi_status & SS_RESIDUAL_UNDER) {
>>> 			if (IS_FWI2_CAPABLE(ha) && fw_resid_len !=3D
>> resid_len) {
>>> -				ql_dbg(ql_dbg_io, fcport->vha, 0x301d,
>>> -				    "Dropped frame(s) detected (0x%x of =
0x%x
>> bytes).\n",
>>> -				    resid, scsi_bufflen(cp));
>>> +				ql_log(ql_log_warn, fcport->vha, 0x301d,
>>> +				       "Dropped frame(s) detected (0x%x =
of 0x%x
>> bytes).\n",
>>> +				       resid, scsi_bufflen(cp));
>>>=20
>>> 				vha->interface_err_cnt++;
>>>=20
>>> @@ -3139,9 +3139,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, =
struct
>> rsp_que *rsp, void *pkt)
>>> 			 * task not completed.
>>> 			 */
>>>=20
>>> -			ql_dbg(ql_dbg_io, fcport->vha, 0x301f,
>>> -			    "Dropped frame(s) detected (0x%x of 0x%x
>> bytes).\n",
>>> -			    resid, scsi_bufflen(cp));
>>> +			ql_log(ql_log_warn, fcport->vha, 0x301f,
>>> +			       "Dropped frame(s) detected (0x%x of 0x%x
>> bytes).\n",
>>> +			       resid, scsi_bufflen(cp));
>>>=20
>>> 			vha->interface_err_cnt++;
>>>=20
>>> @@ -3257,15 +3257,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
>> struct rsp_que *rsp, void *pkt)
>>>=20
>>> out:
>>> 	if (logit)
>>> -		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
>>> -		    "FCP command status: 0x%x-0x%x (0x%x) =
nexus=3D%ld:%d:%llu
>> "
>>> -		    "portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN =
len=3D0x%x "
>>> -		    "rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p =
cp=3D%p.\n",
>>> -		    comp_status, scsi_status, res, vha->host_no,
>>> -		    cp->device->id, cp->device->lun, =
fcport->d_id.b.domain,
>>> -		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
>>> -		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
>>> -		    resid_len, fw_resid_len, sp, cp);
>>> +		ql_log(ql_log_warn, fcport->vha, 0x3022,
>>> +		       "FCP command status: 0x%x-0x%x (0x%x)
>> nexus=3D%ld:%d:%llu portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN =
len=3D0x%x
>> rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p cp=3D%p.\n",
>>> +		       comp_status, scsi_status, res, vha->host_no,
>>> +		       cp->device->id, cp->device->lun, =
fcport->d_id.b.domain,
>>> +		       fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
>>> +		       cp->cmnd, scsi_bufflen(cp), rsp_info_len,
>>> +		       resid_len, fw_resid_len, sp, cp);
>>>=20
>>> 	if (rsp->status_srb =3D=3D NULL)
>>> 		sp->done(sp, res);
>>> --
>>> 2.19.0.rc0
>>>=20
>>=20
>> I like the direction of this patch.
>>=20
>> Can you consider removing "logit" variable. Since logit was designed =
to print
>> messages only when a specific debug (IO bits in this case) was set.
> <SK> logit is set under certain IO error conditions not based on any =
debug. If logit is removed,
> this print will be come for each and every IO.=20
>=20

Yeah. I see that and so it was more of a suggestion while you are =
optimizing debugging effort without having to enable extended logging. =
if you can optimize logit logic while at it would be nice. I=E2=80=99ll =
leave it upto you. No objection to patch itself.

However, when you submit v2 of this patchset, I do want more descriptive =
commit message. Usually small things like this can escape scrutiny under =
=E2=80=9Cdebug level change=E2=80=9D description.=20

> Thanks,
> ~Saurav
>>=20
>> --
>> Himanshu Madhani	 Oracle Linux Engineering

--
Himanshu Madhani	 Oracle Linux Engineering

