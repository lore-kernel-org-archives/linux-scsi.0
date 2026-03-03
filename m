Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EFE227EB9;
	Tue,  3 Mar 2026 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574332; cv=none; b=NWoj9Y87l7avyGCHNRUKUUeDrcS3CqRfUUYW8V/dQUWFth5r27npF+E2thvFZCLdHTZ+7RCJkYsrCUOyBd2g1zbACh2UIou7Is0FUyPKNXVYRYHXAOwXVG3raSNefCbtSSj27BSzt+Ek9trGD4w5WGvO8GbM6iZaxlQvaWokpDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574332; c=relaxed/simple;
	bh=akBhoEbue+savF20VufnHcTBz7Ya6Se5TJcza/g/BAE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FiPCWMt59VgZdD9ghVAK7suzTwwXb7WxiIzoUzPAblTrR0ehLiIAt78bi/jbhU6VXo/mWSuwLl7TFGhlZohpk3u8IjaxnLGjjuNvUT0vmrnOUQWBhJaqrvLB8GdyVePDmYPCyI6QOHXix/vmiRushwJvZ1CU85o8Msoaz3d4pp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BY11qorQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BY11qorQ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623HvHhW1952726;
	Tue, 3 Mar 2026 21:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=63eIU8
	o8Q7zAMTxVx3xYRedmz9y574WSPae7H346HCM=; b=BY11qorQGBqvZs5k4vD2En
	tRl7IEHnINPRqT9FviaypGmY3KPSGQ2L35RKkzCaTCcNiv2IBex1EcXey5rSTSxE
	upPxoBkZUQcHswL0K7squqgLBUj6HrI5iq4FRNeU50wf7b/soDt19FiXvWZzSATn
	wnPi2PK1BSwfMl1TbkK3aLfY03ktz6ynv+WY5q73VWgJePBEaKXeqtEmKYH85WKZ
	oWkFk5Ig35geKGz7BnqZN5IWP+loAKdnx13o3uDxWUOk2rhNiA97JbaiIteplAES
	UyBTa73aK373LVBqhaA/EMIogPEGKVdzASJSKU2hRkjXB3epJ9HNU2T0MdMoKDnA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrj50js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 21:45:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623II2Ws016397;
	Tue, 3 Mar 2026 21:45:23 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmbpn45dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 21:45:23 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623LjMUg18285140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 21:45:22 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 397935805A;
	Tue,  3 Mar 2026 21:45:22 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44C865803F;
	Tue,  3 Mar 2026 21:45:21 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.97.94])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 21:45:21 +0000 (GMT)
Message-ID: <77b2b44d7101d55151c8e9852ce41783205ed987.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
From: Eric Farman <farman@linux.ibm.com>
To: Joshua Daley <jdaley@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mjrosato@linux.ibm.com, frankja@linux.ibm.com
Date: Tue, 03 Mar 2026 16:45:20 -0500
In-Reply-To: <20260226204345.1904786-2-jdaley@linux.ibm.com>
References: <20260226204345.1904786-1-jdaley@linux.ibm.com>
	 <20260226204345.1904786-2-jdaley@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a75674 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=OoLDd18DN7KcugGRceQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE3OCBTYWx0ZWRfX9UV+9tKVerIM
 k10Vj2ibRJ8eww0ccLke/e0k0hZswnhSv7Dtw/F/rqVEjA3f+LOI5SnCldZe+nTAq+cWReKtMb4
 KjrpWkPpznsGS5fNGk1yXarMN+lnSUpjegM1kHo8lJQSn88KaWaJQwj45fTtEZnKb7W5DBc/SPI
 PNlXp1X2DAGnLx0YDgn1OgLyZT/fsqKJPGRsv4g41cFePt4/Vt/R+Z++kU47TjEem0nPamikORv
 kKgSLqSIksZW2awxqAVxqbSHZiYdZVhj8sST8ttrduRR6xrExTVxUEynL1+dtSCEpAl28As7Emq
 ZvdvKRTV7GgeHAyPXJ3R0yIr0NDsh6Ukqzxu3c4c/TCLOzzas6ZT+HxGWP+qBaJ1jGoQOhvh5sz
 ddIds/XKb9rf2Wdf9mHv97lwz0Fp1nIcyPlTTXxdGR4PpnDT994XcDDhncWyu8hE8KELMsHv3kz
 HcZentz7j5rknyj+1Hg==
X-Proofpoint-GUID: M9-a5C4YNMae_nxfA-v5ZeCBMvDe9zWq
X-Proofpoint-ORIG-GUID: M9-a5C4YNMae_nxfA-v5ZeCBMvDe9zWq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_03,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030178

On Thu, 2026-02-26 at 21:43 +0100, Joshua Daley wrote:
> The last step of virtscsi_handle_event is to call virtscsi_kick_event,
> which calls INIT_WORK on it's own work item. INIT_WORK resets the
> work item's data bits to 0.
>=20
> If this occurs while the work item is being flushed by
> cancel_work_sync, then kernel/workqueue.c/work_offqd_enable triggers a
> kernel warning, as it expects the "disable" bit to be 1:
>=20
> [   21.450115] workqueue: work disable count underflowed
> [   21.450117] WARNING: CPU: 1 PID: 56 at kernel/workqueue.c:4328 enable_=
work+0x10a/0x120
> ...
> [   21.450171] Call Trace:
> [   21.450173]  [<000003db2e5bdc3e>] enable_work+0x10e/0x120
> [   21.450176] ([<000003db2e5bdc3a>] enable_work+0x10a/0x120)
> [   21.450178]  [<000003db2e5bdd86>] cancel_work_sync+0x86/0xa0
> [   21.450181]  [<000003daae97d9e4>] virtscsi_remove+0xb4/0xd0 [virtio_sc=
si]
> [   21.450184]  [<000003db2ef3b5ca>] virtio_dev_remove+0x6a/0xd0
> [   21.450186]  [<000003db2ef9106c>] device_release_driver_internal+0x1ac=
/0x260
> [   21.450190]  [<000003db2ef8edc8>] bus_remove_device+0xf8/0x190
> [   21.450192]  [<000003db2ef88d72>] device_del+0x142/0x340
> [   21.450194]  [<000003db2ef88fa0>] device_unregister+0x30/0xa0
> [   21.450196]  [<000003db2ef3b2fa>] unregister_virtio_device+0x2a/0x40
>=20
> This warning may occur if a controller is detached immediately
> following a disk detach.
>=20
> Move the INIT_WORK call to prevent this. Don't re-init event list
> work items in virtscsi_kick_event, init them only once in
> virtscsi_init instead.
>=20
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>

The fact that the INIT_WORK points to virtscsi_handle_event(), which itself=
 calls
virtscsi_kick_event() and re-inits the workqueue struct today, does seem od=
d. Moving this to _init,
as part of the _probe() process, seems correct to me. One nit below, but FW=
IW:

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>

> ---
>  drivers/scsi/virtio_scsi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0ed8558dad72..173092931df6 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -242,7 +242,6 @@ static int virtscsi_kick_event(struct virtio_scsi *vs=
csi,

Just before this hunk is a prototype for virtscsi_handle_event(), since it =
was previously used in
this function but defined afterwards. I suspect it can be removed now?

>  	struct scatterlist sg;
>  	unsigned long flags;
> =20
> -	INIT_WORK(&event_node->work, virtscsi_handle_event);
>  	sg_init_one(&sg, event_node->event, sizeof(struct virtio_scsi_event));
> =20
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> @@ -898,6 +897,11 @@ static int virtscsi_init(struct virtio_device *vdev,
>  	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>  	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
> =20
> +	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
> +		for (i =3D 0; i < VIRTIO_SCSI_EVENT_LEN; i++)
> +			INIT_WORK(&vscsi->event_list[i].work, virtscsi_handle_event);
> +	}
> +
>  	err =3D 0;
> =20
>  out:
