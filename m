Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0065B10A22;
	Thu, 25 Apr 2024 01:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714010290; cv=none; b=HzlecLodwPXE/d90PkzKFWa3yEs6PWYcU6qX5eVebTN7EXDa+4BVDfWSRg7or33wkEhVGZCKBrSekG/NZEtiNdhvOeKi7FrCOnJkyQv+j8mV5fWAdDXxdcKE2U2Tenh5pBdi/L0fKI54j4F7jrvVU/ZW6LO1CujXCx7BHvSNzNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714010290; c=relaxed/simple;
	bh=FijTadZiQvDrmRmd9+9OK33UEMFnjAkJBXsNPUVx/aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WwzFXYaU1nn9SysZIgw6Se1hfG+tQbuN8J693wqOVpykE+R06Ex3jlF1dSeWy30H/BiZzEUSByUFYQqEPW+68Unnnk7VegjbRikzWJqQ7WAqlWmNapeWlZmlZvuThhFdnitW312ZupBN8W3GGnQz60F4dXrDhSYNyLNiHBsM99g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i/VqEWwE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/VqEWwE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0hpPi011500;
	Thu, 25 Apr 2024 01:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=y/IH+dwowyXx6zFMUjLoi6/J7l1DbgA6+TyLeUVYpow=;
 b=i/VqEWwE+g5lzFaBBrTlaXsQFPJyDPqRZPji2f5GhbtfrkOLHZ1jfE6gj/rf/Kg+itLU
 qEc8qL/svVJAjWPDTb9Esiq2SnH2Zk1xMJ512efPHJvFRJpvGxTb9TvYNsxJiZMeQDcq
 6ckEEpBbksQXGjZM7QTmcg4ZqKCtYGjJ7SJ+JRBBaMTqxozYt7FSDGKzRA4ZvZzzSFyM
 eYtHjAqBc0U+zL7oOAefbKpLddshEk+sucL/Dhz0XSAmqlGaHJLOBN70svY3/QemTxaJ
 6z1S5anqXzjRWJ2SUN2M+2qwTVc2SVpzYaG6hfukVIzJ64BJUZ9GUMHTwATUmJumCJ6S IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm5ausg4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:57:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0Sks8025252;
	Thu, 25 Apr 2024 01:57:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45fyh23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:57:14 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43P1vCuP009586;
	Thu, 25 Apr 2024 01:57:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xm45fyh1b-3;
	Thu, 25 Apr 2024 01:57:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: convert SCSI to atomic queue limits, part 1 (v3)
Date: Wed, 24 Apr 2024 21:57:02 -0400
Message-ID: <171362345502.571343.9746199181827642774.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240409143748.980206-1-hch@lst.de>
References: <20240409143748.980206-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_01,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250012
X-Proofpoint-ORIG-GUID: USRSK6KOfQ5vH9L6gr8AM_aaScaBYiB0
X-Proofpoint-GUID: USRSK6KOfQ5vH9L6gr8AM_aaScaBYiB0

On Tue, 09 Apr 2024 16:37:25 +0200, Christoph Hellwig wrote:

> this series converts the SCSI midlayer and LLDDs to use atomic queue limits
> API.  It is pretty straight forward, except for the mpt3mr driver which
> does really weird and probably already broken things by setting limits
> from unlocked device iteration callbacks.
> 
> I will probably defer the (more complicated) ULD changes to the next
> merge window as they would heavily conflict with Damien's zone write
> plugging series.  With that the series could go in through the SCSI
> tree if Jens' ACKs the core block layer bits.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[01/23] block: add a helper to cancel atomic queue limit updates
        https://git.kernel.org/mkp/scsi/c/293066264fb4
[02/23] bsg: pass queue_limits to bsg_setup_queue
        https://git.kernel.org/mkp/scsi/c/4373d2ecca7f
[03/23] mpi3mr: pass queue_limits to bsg_setup_queue
        https://git.kernel.org/mkp/scsi/c/9042fb6d2c08
[04/23] scsi: initialize scsi midlayer limits before allocating the queue
        https://git.kernel.org/mkp/scsi/c/afd53a3d8528
[05/23] scsi_transport_fc: add a max_bsg_segments field to struct fc_function_template
        https://git.kernel.org/mkp/scsi/c/7eaae991c30d
[06/23] scsi: add a no_highmem flag to struct Scsi_Host
        https://git.kernel.org/mkp/scsi/c/6248d7f7714f
[07/23] scsi: add a dma_alignment field to the host and host template
        https://git.kernel.org/mkp/scsi/c/5b7dfbeff92a
[08/23] ufs-exynos: move setting the the dma alignment to the init method
        https://git.kernel.org/mkp/scsi/c/67144d3c58b4
[09/23] scsi: use the atomic queue limits API in scsi_add_lun
        https://git.kernel.org/mkp/scsi/c/693a1e8cbe12
[10/23] scsi: add a device_configure method to the host template
        https://git.kernel.org/mkp/scsi/c/b7eefcf11f3f
[11/23] megaraid_sas: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/b57089d32c2c
[12/23] mpt3sas: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/8c9289e66be6
[13/23] sbp2: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/c1f99322fc84
[14/23] hptiop: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/f65eb761f811
[15/23] ipr: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/c8bc8392b2bc
[16/23] pmcraid: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/9ca2dc2f0701
[17/23] usb-storage: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/70a7949335e5
[18/23] sata_nv: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/3cfedd59cd55
[19/23] pata_macio: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/a92041bd5f15
[20/23] libata: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/a25a9c85d17f
[21/23] mpi3mr: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/310887f688f7
[21/23] mpi3mr: switch to using ->device_configure
        https://git.kernel.org/mkp/scsi/c/30efd3823f2c
[23/23] block: remove now unused queue limits helpers
        https://git.kernel.org/mkp/scsi/c/ec84ca4025c0

-- 
Martin K. Petersen	Oracle Linux Engineering
