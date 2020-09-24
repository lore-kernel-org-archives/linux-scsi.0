Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E043EC4346E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 15:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B2C2311A
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 15:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HjEMEvNb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgIXPdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:33:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgIXPdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 11:33:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OFElqh122833;
        Thu, 24 Sep 2020 15:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=3QoIa80vjBXbMTD8oILmbPH0nePlE98HPxpyod5LC3Y=;
 b=HjEMEvNbDj/CL2d0izKC/ztKN4kTT/sIdskM5Jl04xQSWf/MoUelrYQp4ENeMGJExbFL
 IKgvcJMB48wxDaglHatNL7nCz53oU1GUuM3dC2jy1bvd+a5VGxPDdShuY8M+Gn3QXNwM
 AO1/P+FLCpgOMoZUe3AGwYDU7dS8qgj52grfGEshlgzZqLAvzP3NXFt/NeQxVUC8tFDd
 C9aMNVLSagaJXF8sMjYD11kBxkmfVCC+r3fZ6M8R0o892va2WBsEq54M87qZUIx0qmr9
 E9mz2RyJTjrguXEFZ8XFne4NEYvbUVEn5Ye1wNso+OXD/sjqWLtQwv1L3Imoqsm8lbwa iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnus2h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 15:33:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OFUYFf054252;
        Thu, 24 Sep 2020 15:31:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurwb7fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 15:31:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08OFVXVQ020397;
        Thu, 24 Sep 2020 15:31:33 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 08:31:33 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 3/8] vhost scsi: alloc cmds per vq instead of session
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <20200924022107-mutt-send-email-mst@kernel.org>
Date:   Thu, 24 Sep 2020 10:31:30 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BE3F7F89-D0BF-44BA-921A-112E104C96C5@oracle.com>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-4-git-send-email-michael.christie@oracle.com>
 <20200924022107-mutt-send-email-mst@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 24, 2020, at 1:22 AM, Michael S. Tsirkin <mst@redhat.com> =
wrote:
>=20
> On Mon, Sep 21, 2020 at 01:23:03PM -0500, Mike Christie wrote:
>> We currently are limited to 256 cmds per session. This leads to =
problems
>> where if the user has increased virtqueue_size to more than 2 or
>> cmd_per_lun to more than 256 vhost_scsi_get_tag can fail and the =
guest
>> will get IO errors.
>>=20
>> This patch moves the cmd allocation to per vq so we can easily match
>> whatever the user has specified for num_queues and
>> virtqueue_size/cmd_per_lun. It also makes it easier to control how =
much
>> memory we preallocate. For cases, where perf is not as important and
>> we can use the current defaults (1 vq and 128 cmds per vq) memory use
>> from preallocate cmds is cut in half. For cases, where we are willing
>> to use more memory for higher perf, cmd mem use will now increase as
>> the num queues and queue depth increases.
>>=20
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>> drivers/vhost/scsi.c | 204 =
++++++++++++++++++++++++++++++++-------------------
>> 1 file changed, 127 insertions(+), 77 deletions(-)
>>=20
>> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>> index b22adf0..13311b8 100644
>> --- a/drivers/vhost/scsi.c
>> +++ b/drivers/vhost/scsi.c
>> @@ -52,7 +52,6 @@
>> #define VHOST_SCSI_VERSION  "v0.1"
>> #define VHOST_SCSI_NAMELEN 256
>> #define VHOST_SCSI_MAX_CDB_SIZE 32
>> -#define VHOST_SCSI_DEFAULT_TAGS 256
>> #define VHOST_SCSI_PREALLOC_SGLS 2048
>> #define VHOST_SCSI_PREALLOC_UPAGES 2048
>> #define VHOST_SCSI_PREALLOC_PROT_SGLS 2048
>> @@ -189,6 +188,9 @@ struct vhost_scsi_virtqueue {
>> 	 * Writers must also take dev mutex and flush under it.
>> 	 */
>> 	int inflight_idx;
>> +	struct vhost_scsi_cmd *scsi_cmds;
>> +	struct sbitmap scsi_tags;
>> +	int max_cmds;
>> };
>>=20
>> struct vhost_scsi {
>> @@ -324,7 +326,9 @@ static void vhost_scsi_release_cmd(struct se_cmd =
*se_cmd)
>> {
>> 	struct vhost_scsi_cmd *tv_cmd =3D container_of(se_cmd,
>> 				struct vhost_scsi_cmd, tvc_se_cmd);
>> -	struct se_session *se_sess =3D tv_cmd->tvc_nexus->tvn_se_sess;
>> +	struct vhost_scsi_virtqueue *svq =3D =
container_of(tv_cmd->tvc_vq,
>> +				struct vhost_scsi_virtqueue, vq);
>> +	struct vhost_scsi_inflight *inflight =3D tv_cmd->inflight;
>> 	int i;
>>=20
>> 	if (tv_cmd->tvc_sgl_count) {
>> @@ -336,8 +340,8 @@ static void vhost_scsi_release_cmd(struct se_cmd =
*se_cmd)
>> 			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
>> 	}
>>=20
>> -	vhost_scsi_put_inflight(tv_cmd->inflight);
>> -	target_free_tag(se_sess, se_cmd);
>> +	sbitmap_clear_bit(&svq->scsi_tags, se_cmd->map_tag);
>> +	vhost_scsi_put_inflight(inflight);
>> }
>>=20
>> static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
>> @@ -566,13 +570,14 @@ static void vhost_scsi_complete_cmd_work(struct =
vhost_work *work)
>> }
>>=20
>> static struct vhost_scsi_cmd *
>> -vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct vhost_scsi_tpg =
*tpg,
>> +vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg =
*tpg,
>> 		   unsigned char *cdb, u64 scsi_tag, u16 lun, u8 =
task_attr,
>> 		   u32 exp_data_len, int data_direction)
>> {
>> +	struct vhost_scsi_virtqueue *svq =3D container_of(vq,
>> +					struct vhost_scsi_virtqueue, =
vq);
>> 	struct vhost_scsi_cmd *cmd;
>> 	struct vhost_scsi_nexus *tv_nexus;
>> -	struct se_session *se_sess;
>> 	struct scatterlist *sg, *prot_sg;
>> 	struct page **pages;
>> 	int tag, cpu;
>> @@ -582,15 +587,14 @@ static void vhost_scsi_complete_cmd_work(struct =
vhost_work *work)
>> 		pr_err("Unable to locate active struct =
vhost_scsi_nexus\n");
>> 		return ERR_PTR(-EIO);
>> 	}
>> -	se_sess =3D tv_nexus->tvn_se_sess;
>>=20
>> -	tag =3D sbitmap_queue_get(&se_sess->sess_tag_pool, &cpu);
>> +	tag =3D sbitmap_get(&svq->scsi_tags, 0, false);
>> 	if (tag < 0) {
>> 		pr_err("Unable to obtain tag for vhost_scsi_cmd\n");
>> 		return ERR_PTR(-ENOMEM);
>> 	}
>=20
>=20
> After this change, cpu is uninitialized.

I=E2=80=99ve fixed this.

We don=E2=80=99t use the cmd=E2=80=99s map_cpu field anymore, so I have =
deleted it and the cpu var above.=
