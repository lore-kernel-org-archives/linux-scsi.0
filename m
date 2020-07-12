Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F305DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 07:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47C02070B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 07:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uyVy2Par"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGLHW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 03:22:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36303 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgGLHW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 03:22:27 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200712072222epoutp028b3d342ab697021fa4232fb7ea3c8493~g8FsSNLX_1557415574epoutp020
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2020 07:22:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200712072222epoutp028b3d342ab697021fa4232fb7ea3c8493~g8FsSNLX_1557415574epoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594538542;
        bh=2VOYhEkfmNjOCXCJBU10sgoNXdtdoQFwB5ky+ZxAajw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=uyVy2Par09lVmLdLyTDd7xcPkLGoqjUa7BxyKIbHSEIW1hADjiFUUW9vfE8UK5crg
         6Ld0UCEDlRGsvehw9JrdDFjeNSO7XtDbrjHPrhHYgEUfS8Mu+9EfNX3NGKNAToIBXq
         iWgbuEZtG6rqXT0rTqY2dAMudDoRL2sCSjbrM7bE=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200712072221epcas5p413abc6e136eaef67d67fff81d1cac891~g8Fr1BVR52144521445epcas5p4e;
        Sun, 12 Jul 2020 07:22:21 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.16.09467.D2ABA0F5; Sun, 12 Jul 2020 16:22:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200712015541epcas5p4623c06331d837f7aefef7ee0658ebeaf~g3oeEAHmg1944819448epcas5p4c;
        Sun, 12 Jul 2020 01:55:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200712015541epsmtrp16172aa0e6d43fefc4e298a60810c30f5~g3oeDEpLi1447314473epsmtrp11;
        Sun, 12 Jul 2020 01:55:41 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-1c-5f0aba2de3ef
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.D8.08303.D9D6A0F5; Sun, 12 Jul 2020 10:55:41 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200712015538epsmtip16012df5251c5d621e27c2d62358ad728~g3oa2hAH42275322753epsmtip1F;
        Sun, 12 Jul 2020 01:55:38 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>
In-Reply-To: <71f2a8e3fdfcf9f60cc8b5e14acf3a57cf22d4f8.1594450408.git.kwmad.kim@samsung.com>
Subject: RE: [RFC PATCH v5 2/3] ufs: exynos: introduce command history
Date:   Sun, 12 Jul 2020 07:25:36 +0530
Message-ID: <000001d657ef$8c084200$a418c600$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIueMtDWjJeafEhyFhDluPRduUJOgLIn2wwAYGYW/OoMJhMEA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmuq7uLq54g1dNMhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG8YbXLAVfZComdK1kbWD8Id7FyMkhIWAicejhd7YuRi4OIYHdjBLX
        3yxih3A+MUocnrqYGcL5zCjR+uolO0zLyRkXoFp2MUo83fKVFcJ5wyixasEbFpAqNgFdiR2L
        28CqRARuM0msPdoJ1s4MlDj5ZCkTiM0pECOxZfs0sAZhATeJU227wGwWAVWJGde2sILYvAKW
        Ev9nbGeGsAUlTs58wgIxR1ti2cLXzBAnKUj8fLoMrF5EwEliffNrqF3iEkd/9oD9ICFwh0Pi
        8pXfQM0cQI6LxP2HORC9whKvjm+Bek1K4mV/GztESbZEzy5jiHCNxNJ5x1ggbHuJA1fmgE1h
        FtCUWL9LHyIsKzH11DomiK18Er2/nzBBxHkldsyDsVUlmt9dhRojLTGxu5t1AqPSLCSPzULy
        2CwkD8xC2LaAkWUVo2RqQXFuemqxaYFhXmq5XnFibnFpXrpecn7uJkZwqtPy3MF498EHvUOM
        TByMhxglOJiVRHijRTnjhXhTEiurUovy44tKc1KLDzFKc7AoifMq/TgTJySQnliSmp2aWpBa
        BJNl4uCUamBaf5Z1sZHl1k0mzbJh/5VncblG5k27/Pt1ttXCVE/u0n/XmBkXaHvtYLjJ9yro
        YG6o13mToppV8cHT+xNUNggZHWiRLBOwaIm46z9nae6LpsVZYrmPhWW6Az5dLsj6NVmv7LtC
        I4u9+xvFyNdp06pe2lSqnFjb6zTlu+iaMpetE0JP3G+4/SmvY5dS4NZNakuEvN7dYq6TmSom
        4Gi59vkpQ628v4uYjXLcGj/GPEv+f3C7uV3RqhBTLvfsL0mRRns3m1fxeAbzeS3u+aJ09dLX
        J/0/HabbzOxinqim1siac25BmPzHxdofrttwe0mznT8yx+s4832dJOcrTsF/5JsN+NY/KT+3
        73OjRpzECiWW4oxEQy3mouJEAPbVt37kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnO7cXK54g4sfVSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6Mxh83WAqmyVS8+naLqYFxkngXIyeHhICJxMkZF9hAbCGBHYwSr69a
        QsSlJa5vnMAOYQtLrPz3HMjmAqp5xSixe+E7RpAEm4CuxI7FbWwgCRGB10wS9878YgJJMAMl
        Tj5ZygQx9RajxOx1xiA2p0CMxJbt01hAbGEBN4lTbbvAbBYBVYkZ17awgti8ApYS/2dsZ4aw
        BSVOznzCAjFTW+Lpzadw9rKFr5khrlOQ+Pl0GViviICTxPrm1+wQNeISR3/2ME9gFJ6FZNQs
        JKNmIRk1C0nLAkaWVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwRGrpbWDcc+qD3qH
        GJk4GA8xSnAwK4nwRotyxgvxpiRWVqUW5ccXleakFh9ilOZgURLn/TprYZyQQHpiSWp2ampB
        ahFMlomDU6qBacncKEbP/bdXtM2Tmz3zv2aK1qNnvdf3ZWtKKfe3HypSs9Hz7nm+bNXLwN4N
        C9nPGlScX3ykWdNpks2kvWY7beOWHJ18LPBIzJPnH+4bKWjbv7D8+n/VxM29ddkNk5+ExHy/
        eV09Zsbd9TbpcbWfLM9HW+2uvHv7WtuUBLUvX8yuSf+Z8EtrS/h+A/lpcSsy/vUEB0pc3uf4
        OyvnmQ/33qqgT/NP+DvNttx6p/Hsxx3sE/g6T+xRWvd67fnAj86fzgYZrZ25/GfShZj/222l
        mx5c8l3WHXqeq3gLe7/25GvVj9+f3qHmZ/bSwz9m5ZVrhxgbm1wnvMrdd07+8e8J89KF07oc
        97P63/i+1zSRqXGyEktxRqKhFnNRcSIAMYFSCkcDAAA=
X-CMS-MailID: 20200712015541epcas5p4623c06331d837f7aefef7ee0658ebeaf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200711070544epcas2p4d3a75d2f56b8162c09efa0eeaf012fa2
References: <cover.1594450408.git.kwmad.kim@samsung.com>
        <CGME20200711070544epcas2p4d3a75d2f56b8162c09efa0eeaf012fa2@epcas2p4.samsung.com>
        <71f2a8e3fdfcf9f60cc8b5e14acf3a57cf22d4f8.1594450408.git.kwmad.kim@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong,

> -----Original Message-----
> From: Kiwoong Kim <kwmad.kim=40samsung.com>
> Sent: 11 July 2020 12:28
> To: linux-scsi=40vger.kernel.org; alim.akhtar=40samsung.com;
> avri.altman=40wdc.com; jejb=40linux.ibm.com; martin.petersen=40oracle.com=
;
> beanhuo=40micron.com; asutoshd=40codeaurora.org; cang=40codeaurora.org;
> bvanassche=40acm.org; grant.jung=40samsung.com; sc.suh=40samsung.com;
> hy50.seo=40samsung.com; sh425.lee=40samsung.com
> Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
> Subject: =5BRFC PATCH v5 2/3=5D ufs: exynos: introduce command history
>=20
> This includes functions to record contexts of incoming commands in a circ=
ular
> queue. ufshcd.c has already some function tracer calls to get command his=
tory
> but ftrace would be gone when system dies before you get the information,
> such as panic cases.
>=20
> This patch also implements callbacks compl_xfer_req to store IO contexts =
at
> completion times.
>=20
> When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG, the driver collects
> the information from incoming commands in the circular queue.
>=20
> Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> +void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
> +			      struct ufs_hba *hba, int tag)
> +=7B
> +	struct ufs_s_dbg_mgr *mgr =3D (struct ufs_s_dbg_mgr *)handle->private;
> +	struct scsi_cmnd *cmd =3D hba->lrb=5Btag=5D.cmd;
> +	int cpu =3D raw_smp_processor_id();
> +	struct cmd_data *cmd_log =3D &mgr->cmd_log;	/* temp buffer to put
> */
> +	u64 lba =3D 0;
> +	u32 sct =3D 0;
> +
> +	if (mgr->active =3D=3D 0)
> +		return;
> +
> +	cmd_log->start_time =3D cpu_clock(cpu);
> +	cmd_log->op =3D cmd->cmnd=5B0=5D;
> +	cmd_log->tag =3D tag;
> +
> +	/* This function runtime is protected by spinlock from outside */
> +	cmd_log->outstanding_reqs =3D hba->outstanding_reqs;
> +
> +	/* Now assume using WRITE_10 and READ_10 */
> +	put_unaligned(cpu_to_le32(*(u32 *)cmd->cmnd=5B2=5D), (u32 *)&lba);
This gives compilation error, you need to include <asm-generic/unaligned.h>
Also type casting to u32 is not needed, will give build warnings.

> +	put_unaligned(cpu_to_le16(*(u16 *)cmd->cmnd=5B7=5D), (u16 *)&sct);
Type casting to u16 is not needed.

> +	if (cmd->cmnd=5B0=5D =21=3D UNMAP)
> +		cmd_log->lba =3D lba;
> +
> +	cmd_log->sct =3D sct;
> +	cmd_log->retries =3D cmd->allowed;
> +
> +	ufs_s_put_cmd_log(mgr, cmd_log);
> +=7D
> +
> +void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
> +			    struct ufs_hba *hba, int tag)
> +=7B
> +	struct ufs_s_dbg_mgr *mgr =3D (struct ufs_s_dbg_mgr *)handle->private;
> +	struct scsi_cmnd *cmd =3D hba->lrb=5Btag=5D.cmd;
Unused variable =22cmd=22

> +	struct ufs_cmd_info *cmd_info =3D &mgr->cmd_info;
> +	int cpu =3D raw_smp_processor_id();
> +
> +	if (mgr->active =3D=3D 0)
> +		return;
> +
> +	cmd_info->pdata=5Btag=5D->end_time =3D cpu_clock(cpu); =7D
> +
> +int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device
> +*dev) =7B
> +	struct ufs_s_dbg_mgr *mgr;
> +
> +	mgr =3D devm_kzalloc(dev, sizeof(struct ufs_s_dbg_mgr), GFP_KERNEL);
> +	if (=21mgr)
> +		return -ENOMEM;
> +	handle->private =3D (void *)mgr;
> +	mgr->handle =3D handle;
> +	mgr->active =3D 1;
> +
> +	/* cmd log */
> +	spin_lock_init(&mgr->cmd_lock);
> +
> +	return 0;
> +=7D
> +MODULE_AUTHOR(=22Kiwoong Kim <kwmad.kim=40samsung.com>=22);
> +MODULE_DESCRIPTION(=22Exynos UFS debug information=22);
> +MODULE_LICENSE(=22GPL=22); MODULE_VERSION(=220.1=22);
May be =22GPL v2=22

> diff --git a/drivers/scsi/ufs/ufs-exynos-if.h b/drivers/scsi/ufs/ufs-exyn=
os-if.h
> new file mode 100644
> 2.7.4


