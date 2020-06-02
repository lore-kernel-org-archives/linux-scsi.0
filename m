Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA0CC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 22:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14A5206C3
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 22:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pIvPR16e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgFBWhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:37:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBWhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 18:37:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MW68R016387;
        Tue, 2 Jun 2020 22:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mf7r9TOEHRPO8UnN3epGYrZ8FLps5leiGH+TawNTa0s=;
 b=pIvPR16eU/b6L+c186AJqEx4GqsKL1i0RC9XpgnRGskZ8MywT3VOqBXeBZ0kRr6SsqfI
 gT0tvt4ujK37CR2GgHNzuBAxNBkmPoqcrJYODbFSVDH4H5b67Pq0UEDq2NBTZgjCUSnu
 sYxNHzo4tGO/eCECGl2w6ogg5YgJ4IQn0QK1RDBZPdmSN9vTYqzEO2n2hnlc217NOR/M
 T8p43N6ajSMDxtua+rKEorNkp0Ar/FKkm/xJWQKsNDCud2Uq3FnNin0m8+wXsqp26kWB
 OP5Q3ozEcSHyse59lg1t0RNEb9EiuBxUiAYuM8tQd0f7S7mt4LT3E5PjWZAge6UKNK7p Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqxeav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 22:37:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MXGMZ126664;
        Tue, 2 Jun 2020 22:37:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dy09be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 22:37:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052Mb3vd025232;
        Tue, 2 Jun 2020 22:37:03 GMT
MIME-Version: 1.0
Message-ID: <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
Date:   Tue, 2 Jun 2020 15:37:02 -0700 (PDT)
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     Michael Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>
Subject: RE: [PATCH v3 2/3] target: fix NULL pointer dereference
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
In-Reply-To: <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 15.0.5215.0 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> You should follow the coding style in the rest of the code. Do "/*" then
> start your text or do it all on one line if it fits:
>=20
> /*
>   * Copy the CDB here to allow trace_target_cmd_complete() to

Thanks, I will fix this.

>=20
>=20
> > +=09 * print the cdb to the trace buffers.
> > +=09 */
> > +=09memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned
> int)TCM_MAX_COMMAND_SIZE));
>=20
> Use 80 char cols like you did in the rest of the patch and the other code=
.

I recently noticed that 80 char limitation was relaxed from mainline by com=
mit bdc48fa11e46f867ea4d75fa59ee87a7f48be144. The new limit is 100 char. I =
was confused whether to stick to 80 or the new limit. Let me know.

>=20
> > +=09return ret;
> >   }
> >   EXPORT_SYMBOL(target_cmd_init_cdb);
> >
> > @@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
> >   =09struct se_device *dev =3D cmd->se_dev;
> >   =09sense_reason_t ret;
> >
> > -=09target_cmd_init_cdb(cmd, cdb);
> > -
> >   =09ret =3D dev->transport->parse_cdb(cmd);
> >   =09if (ret =3D=3D TCM_UNSUPPORTED_SCSI_OPCODE)
> >   =09=09pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x,
> sending CHECK_CONDITION.\n",
> > @@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd
> *se_cmd, struct se_session *se_sess
> >   =09transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> >   =09=09=09=09data_length, data_dir, task_attr, sense);
> >
>=20
> This should maybe be in transport_init_se_cmd. It might be useful there
> for the tmr case, if we wanted to add a trace point there too.
>=20
> At least a comment and some cleanup, because it's not obvious why we set
> it here then also set it again in transport_lookup_cmd_lun.

Yes, I thought of initializing the cdb in transport_init_se_cmd() but reali=
zed later that TMR requests are transport level entities and hence they don=
't have an associated cdb with them. So, in future if we want to trace tmr =
request, then we may have to introduce new set of trace functions that do n=
ot reference cdb. What do you think?

>=20
>=20
> > +=09se_cmd->orig_fe_lun =3D unpacked_lun; > +=09rc =3D
> target_cmd_init_cdb(se_cmd, cdb);
> > +=09if (rc) {
> > +=09=09transport_send_check_condition_and_sense(se_cmd, rc, 0);
>=20
> Can we do this before doing a get() on the cmd? If the fabric module is
> such that it does a put() on the cmd (the callers using SCF_ACK_KREF) in
> its cmd clean up path, then we would end up with unbalanced
> sess->cmd_count and cmd refcounts.
>=20
> Maybe move this to after target_get_sess_cmd().

I moved it before target_get_sess_cmd() because if target_get_sess_cmd() fa=
ils then we have NULL pointer dereference issue again. For instance, the se=
quence
  vhost_scsi_submission_work
     target_submit_cmd_map_sgls
       target_get_sess_cmd() -- Suppose this fails
     transport_send_check_condition_and_sense
        trace_target_cmd_complete -- NULL ptr derefence.

Still thinking how to address both these issues together.

Thanks
Sudhakar
