Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD53201
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 06:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727763074; cv=none; b=Clk/PgSZDYfi4OkXZP8KRDTnM/V6P5whjk5GAbpVeKw18bv56jRowWDE3LJPd8Px/1yjtrYgwG3KI+ziqoBrMgAlmNFvXQi2dNm4FqQhEZGg3yp/D+Cp7q0DdTIkXY9n8qh9Vkvu+c/gpL/6dOssDPX17cIX0f1KO80rLCDYdWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727763074; c=relaxed/simple;
	bh=pr2qTEVmaZQMqPKpCQA1F7uNhDSCag5GBiG83Rfwlg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM/Onuh0v2Kfmj+udVOBUyjiiRIe122wjQfsvZXBmtcuETy6Uuj0cqbk7f5pOnGEFa6YXjhOKo7JJxWfMFBYiK4vAYAyeQatKi45FNGP1QvalcUQDWrrAUb0LOuyjBTwQ7V+zg5DAsArOxVJMaMihG3SLhkvUiQNn4vsgvsay74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjA6Bk+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjA6Bk+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C1BC4CEC6;
	Tue,  1 Oct 2024 06:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727763073;
	bh=pr2qTEVmaZQMqPKpCQA1F7uNhDSCag5GBiG83Rfwlg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjA6Bk+vZPHIKvsyYgt+YDMzk8DOs9cpRPF/ymi65wdl6ZgC4T+2rmq3iDExZD2bs
	 EjRV1xAj7bq9Tc1FiBPNeTVVoxpAvz5srvtd43Yq6eCCf4CTFbrR7+1m9w4fBPe6uc
	 /UudNGfs0C7aVLw+t4GTsTex19KajBMquGP6V3sGF3A/ocnauNNr0O4dXJNs1Yu+lf
	 /cNSkfHUs7y7FI/ESnpWq6l0pBJV1XgFLeY4x3vzxTerWQ5OEBs/QCA8BRhaN6pl4U
	 XtW6G2qfd6aS5E2rIGO7b0ymiOt9pskxbvjFUvtun+t4fL9Nt8oq6umA2WDroz/sbJ
	 JjefkoeUninjg==
Date: Tue, 1 Oct 2024 09:11:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Steffen Maier <maier@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Geoff Levand <geoff@infradead.org>,
	Nilesh Javali <njavali@marvell.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	ching Huang <ching2048@areca.com.tw>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Soumya Negi <soumya.negi97@gmail.com>
Subject: Re: [PATCH 2/4] scsi: Convert SCSI drivers to .device_configure()
Message-ID: <20241001061110.GE459313@unreal>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930201937.2020129-3-bvanassche@acm.org>

On Mon, Sep 30, 2024 at 01:18:48PM -0700, Bart Van Assche wrote:
> There is agreement that the word "slave" should not be used in Linux
> kernel source code. 

I think that "there is agreement" is over-statement. It is good thing to
avoid using "slave" in the new code, but it is not a universally agreed
to change old code to new naming.

> Hence this patch that converts all SCSI drivers from
> .slave_configure() to .device_configure(). No functionality has been
> changed.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c         |  5 +++--

Because of such small changes in RDMA, I'm not going to object for this
patch, but my opinion is that this type of patches do more harm than
benefit (for example backporting to older kernels).

Thanks

>  drivers/message/fusion/mptfc.c              |  2 +-
>  drivers/message/fusion/mptsas.c             |  6 +++---
>  drivers/message/fusion/mptscsih.c           |  4 ++--
>  drivers/message/fusion/mptscsih.h           |  3 ++-
>  drivers/message/fusion/mptspi.c             |  7 ++++---
>  drivers/net/ethernet/allwinner/sun4i-emac.c |  4 ++--
>  drivers/s390/scsi/zfcp_scsi.c               |  5 +++--
>  drivers/scsi/3w-9xxx.c                      |  7 ++++---
>  drivers/scsi/3w-sas.c                       |  7 ++++---
>  drivers/scsi/3w-xxxx.c                      |  9 ++++----
>  drivers/scsi/53c700.c                       |  7 ++++---
>  drivers/scsi/BusLogic.c                     |  7 ++++---
>  drivers/scsi/BusLogic.h                     |  3 ++-
>  drivers/scsi/aacraid/linit.c                |  8 ++++---
>  drivers/scsi/advansys.c                     | 23 +++++++++++----------
>  drivers/scsi/aic7xxx/aic79xx_osm.c          |  4 ++--
>  drivers/scsi/aic7xxx/aic7xxx_osm.c          |  4 ++--
>  drivers/scsi/arcmsr/arcmsr_hba.c            |  8 ++++---
>  drivers/scsi/bfa/bfad_im.c                  |  6 +++---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  5 +++--
>  drivers/scsi/csiostor/csio_scsi.c           |  6 +++---
>  drivers/scsi/esp_scsi.c                     |  7 ++++---
>  drivers/scsi/hpsa.c                         |  8 ++++---
>  drivers/scsi/ibmvscsi/ibmvfc.c              |  7 ++++---
>  drivers/scsi/ibmvscsi/ibmvscsi.c            |  8 ++++---
>  drivers/scsi/ips.c                          |  6 +++---
>  drivers/scsi/ips.h                          |  3 ++-
>  drivers/scsi/lpfc/lpfc_scsi.c               | 21 ++++++++++++-------
>  drivers/scsi/mvumi.c                        |  5 +++--
>  drivers/scsi/myrb.c                         |  5 +++--
>  drivers/scsi/myrs.c                         |  5 +++--
>  drivers/scsi/ncr53c8xx.c                    |  5 +++--
>  drivers/scsi/ps3rom.c                       |  5 +++--
>  drivers/scsi/qedf/qedf_main.c               |  5 +++--
>  drivers/scsi/qla1280.c                      |  6 +++---
>  drivers/scsi/qla2xxx/qla_os.c               |  4 ++--
>  drivers/scsi/qlogicpti.c                    |  5 +++--
>  drivers/scsi/scsi_debug.c                   |  7 ++++---
>  drivers/scsi/scsi_scan.c                    |  2 +-
>  drivers/scsi/smartpqi/smartpqi_init.c       |  5 +++--
>  drivers/scsi/snic/snic_main.c               |  6 +++---
>  drivers/scsi/stex.c                         |  4 ++--
>  drivers/scsi/storvsc_drv.c                  |  5 +++--
>  drivers/scsi/sym53c8xx_2/sym_glue.c         |  5 +++--
>  drivers/scsi/xen-scsifront.c                |  7 ++++---
>  drivers/staging/rts5208/rtsx.c              |  4 ++--
>  47 files changed, 166 insertions(+), 124 deletions(-)
