Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44FE1B9B50
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 04:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727757855; cv=none; b=RzI8PsJQgMMXawGdVy3HHn8QbxHjuwOCp+OCUWcmSJsPypBg3c1L54VQFwQndXMsL+f1uK1G4Rf/EHUrUNSnYohTRm0eQbF9YUlfyBL54Bss+wPHsaS2cOV8CCTdCrjWDfQTjQQ5q0T9TDpZbVd2B8njCz+L4u5z5BUl93TzbL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727757855; c=relaxed/simple;
	bh=lhMw1/Ygy2wJFmIwEs7VZIerNPK5+KFZZzuBDchXnkQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WQJHUzDncsCD2A4O6AN6KkDPGZwhEvsEN/Li4SXAiW01Gtmuz9KmvgdYbp5CXBfB/1GOVUNh4e41hhR+OMh3CyppnHowVywlqcUetKymps2jd+wnWvloGYlMi88QZ8bklTHgNkVQb6unT8YtNjg+Fi08f9TtrPXTb7QRxZTrlAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NmQ72w9L; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NmQ72w9L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1VgkaIMRKQsmRKvyL8cVnNA635ZDAOsM3FhjQI7aung=; b=NmQ72w9LLUDWJj6DXJ/wgEzBgN
	itwq+pPF6K0/3a2XOXVPuW+fV6Iwqt9uumVHWrAlTmwV2gZcLLSsCI2pFpcPJgfo5nsh+3n6AHHhS
	XCptPGbYoxGwSNZgpg8h7X67oGZRjCEgpXXa4sLAH6KOMygdbxzZTtcOPmT51dCnMroTJ9fq2PMv+
	GNZJDbhNAnAyE30mqpjdIyObU5ndtEhJdQkmtjfWC4BWzq3GYXS4CedxAcxZDSOqeXbDvUf4wXAjK
	bucRhdu9i6UmqgNKAePUuFrPvhvyw1JIuVII0u72LRNl8rpmbPfFI/Jf5Dok/9wnK2Pyl1O1wCOe+
	Fbi+hqug==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svUju-00000002y0N-1j2W;
	Tue, 01 Oct 2024 04:43:58 +0000
Message-ID: <8d2e260d-399e-44b3-90a1-abed3b434370@infradead.org>
Date: Mon, 30 Sep 2024 21:43:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
From: Randy Dunlap <rdunlap@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Niklas Cassel <cassel@kernel.org>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Tariq Toukan <tariqt@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Steffen Maier <maier@linux.ibm.com>,
 Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Hannes Reinecke <hare@suse.com>, Anil Gurumurthy
 <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Oliver Neukum <oliver@neukum.org>,
 Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Yihang Li <liyihang9@huawei.com>,
 Don Brace <don.brace@microchip.com>, Tyrel Datwyler <tyreld@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@us.ibm.com>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Matthew Wilcox <willy@infradead.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Garry
 <john.g.garry@oracle.com>, Soumya Negi <soumya.negi97@gmail.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
 <d5d5f76a-c10f-4334-8e14-bde6f9992f6d@infradead.org>
Content-Language: en-US
In-Reply-To: <d5d5f76a-c10f-4334-8e14-bde6f9992f6d@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/30/24 8:26 PM, Randy Dunlap wrote:
> 
> 
> On 9/30/24 1:18 PM, Bart Van Assche wrote:
>> There is agreement that the word "slave" should not be used in Linux
>> kernel source code. Hence this patch that renames .slave_alloc() into
> 
> New uses should be avoided....
> 
> However, I don't object to the patch.
> 
>> .device_alloc() and .slave_destroy() into .device_destroy() in the SCSI
>> core, SCSI drivers, ATA drivers and also in the SCSI documentation.
>> Do not modify Documentation/scsi/ChangeLog.lpfc. No functionality has
>> been changed.
>>
>> This patch has been created as follows:
>> * Change the text "slave_alloc" into "device_alloc" in all source files
>>   except in the LPFC driver changelog.
>> * Change the text "slave_destroy" into "device_destroy" in all source
>>   files except in the LPFC driver changelog.
>> * Rename lpfc_no_slave() into lpfc_no_device().
>> * Manually adjust whitespace where necessary to restore vertical
>>   alignment (dc395x driver and include/linux/libata.h).
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

For all 4 patches:

Tested-by: Randy Dunlap <rdunlap@infradead.org> # doc builds


>> ---
>>  Documentation/scsi/scsi_mid_low_api.rst   | 50 +++++++++++------------
>>  drivers/ata/libata-scsi.c                 | 12 +++---
>>  drivers/firewire/sbp2.c                   |  4 +-
>>  drivers/message/fusion/mptfc.c            | 12 +++---
>>  drivers/message/fusion/mptsas.c           |  8 ++--
>>  drivers/message/fusion/mptscsih.c         |  6 +--
>>  drivers/message/fusion/mptscsih.h         |  2 +-
>>  drivers/message/fusion/mptspi.c           | 12 +++---
>>  drivers/net/ethernet/mellanox/mlx4/main.c | 12 +++---
>>  drivers/s390/scsi/zfcp_scsi.c             | 10 ++---
>>  drivers/s390/scsi/zfcp_sysfs.c            |  2 +-
>>  drivers/s390/scsi/zfcp_unit.c             |  2 +-
>>  drivers/scsi/53c700.c                     | 12 +++---
>>  drivers/scsi/aic7xxx/aic79xx_osm.c        |  4 +-
>>  drivers/scsi/aic7xxx/aic7xxx_osm.c        |  4 +-
>>  drivers/scsi/bfa/bfad_im.c                | 20 ++++-----
>>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  2 +-
>>  drivers/scsi/csiostor/csio_scsi.c         | 12 +++---
>>  drivers/scsi/dc395x.c                     | 12 +++---
>>  drivers/scsi/esp_scsi.c                   |  8 ++--
>>  drivers/scsi/fcoe/fcoe.c                  |  2 +-
>>  drivers/scsi/fnic/fnic_main.c             |  4 +-
>>  drivers/scsi/hisi_sas/hisi_sas.h          |  2 +-
>>  drivers/scsi/hisi_sas/hisi_sas_main.c     |  6 +--
>>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |  2 +-
>>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |  2 +-
>>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  2 +-
>>  drivers/scsi/hpsa.c                       | 12 +++---
>>  drivers/scsi/ibmvscsi/ibmvfc.c            |  6 +--
>>  drivers/scsi/ipr.c                        | 12 +++---
>>  drivers/scsi/libfc/fc_fcp.c               |  6 +--
>>  drivers/scsi/libsas/sas_scsi_host.c       |  4 +-
>>  drivers/scsi/lpfc/lpfc_scsi.c             | 22 +++++-----
>>  drivers/scsi/megaraid/megaraid_sas_base.c |  8 ++--
>>  drivers/scsi/mpi3mr/mpi3mr_os.c           | 12 +++---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 16 ++++----
>>  drivers/scsi/myrb.c                       | 16 ++++----
>>  drivers/scsi/myrs.c                       |  8 ++--
>>  drivers/scsi/ncr53c8xx.c                  |  4 +-
>>  drivers/scsi/pmcraid.c                    | 14 +++----
>>  drivers/scsi/qla2xxx/qla_os.c             |  8 ++--
>>  drivers/scsi/qla4xxx/ql4_os.c             |  6 +--
>>  drivers/scsi/scsi_debug.c                 | 12 +++---
>>  drivers/scsi/scsi_scan.c                  |  8 ++--
>>  drivers/scsi/scsi_sysfs.c                 |  4 +-
>>  drivers/scsi/smartpqi/smartpqi_init.c     |  8 ++--
>>  drivers/scsi/snic/snic_main.c             |  6 +--
>>  drivers/scsi/storvsc_drv.c                |  2 +-
>>  drivers/scsi/sym53c8xx_2/sym_glue.c       | 10 ++---
>>  drivers/scsi/virtio_scsi.c                |  2 +-
>>  drivers/scsi/xen-scsifront.c              |  4 +-
>>  drivers/staging/rts5208/rtsx.c            |  4 +-
>>  drivers/ufs/core/ufshcd.c                 | 12 +++---
>>  drivers/usb/image/microtek.c              |  4 +-
>>  drivers/usb/storage/scsiglue.c            |  6 +--
>>  drivers/usb/storage/uas.c                 |  4 +-
>>  include/linux/libata.h                    |  8 ++--
>>  include/scsi/libfc.h                      |  2 +-
>>  include/scsi/libsas.h                     |  4 +-
>>  include/scsi/scsi_device.h                |  4 +-
>>  include/scsi/scsi_host.h                  | 16 ++++----
>>  61 files changed, 250 insertions(+), 250 deletions(-)
>>
