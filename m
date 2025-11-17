Received: from mail-m19731120.qiye.163.com (mail-m19731120.qiye.163.com [220.197.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9D174BE1
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 06:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763360962; cv=none; b=KegvF6+atvCZsqUdeeKijeqQXMqJ/gPNdavv2wMRV1UgxfVnlF9eHTcIRGlavXRIkcMonn/Ek0cOH5VMueONFiN5pdu3Svy16YgOs81eA0pvcI123qypPEnXAdowHtPaJFhBhfYbJD++mtilJCwfSnFfQ6pAfOlL3qVdGLKbp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763360962; c=relaxed/simple;
	bh=D1BMprU+eg16S+m5d5oFzbEkakEEkGpIYmJ2NB54Ob8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLVfD5HWEtS5WLJBF7h1XHbZC8spvqJJArermybtqjE+LCySkyAVtuJTk1C8WDQVO5I60dkoBf1jL7lN2T+AkNIjJe6TMS6wNklFCR9657LJ8ir8/yd53fpYxCiByCsReM5bYtq6+VSEMRdsq+dovoKLpxZj/trcCgpjJsjCT9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=UFx1kQv8; arc=none smtp.client-ip=220.197.31.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="UFx1kQv8"
Received: from [192.168.240.223] (unknown [112.46.64.67])
	by smtp.qiye.163.com (Hmail) with ESMTP id 29ce63475;
	Mon, 17 Nov 2025 14:29:08 +0800 (GMT+08:00)
Message-ID: <6ea84718-8b1e-4570-bce2-7f8519b54857@leap-io-kernel.com>
Date: Mon, 17 Nov 2025 14:29:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: leapraid: Add new scsi driver
To: Damien Le Moal <dlemoal@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
References: <20251017072807.3327789-1-doubled@leap-io-kernel.com>
 <20251021033153.1424410-1-doubled@leap-io-kernel.com>
 <aG1haWxfaXNfbm9fMQ.287b84c7-7efb-4386-9d8a-accf3c18c497@kernel.org>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <aG1haWxfaXNfbm9fMQ.287b84c7-7efb-4386-9d8a-accf3c18c497@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a9080c15109cckunm66ba1fb774cc53
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGkpLVhgeHhgZQhpMSENJTlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSklVT01VTU9VTUxZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQkpVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=UFx1kQv8rG80qQu2bjAQKQ9fRKjqZCqEfuZYDgn1DJNfuskhVfpF2fHZhfsJR2jDTf2J47wzxX9SRUmeU+RtYRk/YsZkoJ9PjmYd0cJ6aPf/H9yRrMKu11WRex67ZdQBfNK73xE/MDdnC89kpBjUdQTiaIxpndcxX16izKu7JM74NoLLh8c7cBRKodti2R7J5+kgFSNnXTbQmAhAgyTfYbO0qkJBnX83VPIrwXc+rSvbAxQIpboEVxb8QG3RpOlc3bqgitQvEo/lq8pkgzAniy6CX/plFfwYLgATUCxTt/m/QH1LeHMFQ4dxjE5tAUloh0+DMGg6hbGaQfAIAx6F9w==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=Th23XhXiOtPYooaj0sVQ9tmno9bDcfDYYjbZ9IzqCgw=;
	h=date:mime-version:subject:message-id:from;

Damien Le Moal wrote:
> On 10/21/25 12:31, doubled wrote:
>> This commit adds support for the LeapIO
>> RAID controller. It supports RAID levels
>> 0, 1, 5, 6, 10, 50, and 60, and works with
>> both SAS and SATA HDDs/SSDs.
> 
> Please format your commit message to use up to 72 chars per line.
> Also, given the size of this patch, a little more explanation regarding the
> structure of the driver would be welcome here.
> 

Thank you very much for reviewing our patches and for your time.
I should have replied to your comments promptly and provided an 
estimated completion time — that was my mistake.

We have now submitted v4, which resolves all the issues you pointed out 
during the review.

In the new commit message, we included an introduction to the driver’s 
file structure and their corresponding functionalities, as well as a 
description of the core data structures.

>> Signed-off-by: doubled <doubled@leap-io-kernel.com>
> 
> Is "doubled" the name of a real person ? If yes, please capitalize it. But I
> doubt it is, and we need a real person name here. The author(s).
> 

My name is Hao Dongdong, and I initially thought that “doubled” would be 
an acceptable handle in the community. However, I realize now that it 
was not appropriate. In future submissions, I have replaced all 
instances of “doubled” with Hao Dongdong. Thank you very much for your 
reminder.

>> ---
>> Changes in v3:
>>   - fix sparse warnings for writel() argument type mismatch
>>   - Link to v2: https://lore.kernel.org/all/20251017072807.3327789-1-doubled@leap-io-kernel.com/
>>
>> Changes in v2:
>>   - fix unused variable and undocumented struct member warnings
>>   - refactor volume event handling and drive hotplug logic
>>   - Link to v1: https://lore.kernel.org/all/20250919100032.3931476-1-doubled@leap-io-kernel.com/
>>
>> Signed-off-by: doubled <doubled@leap-io-kernel.com>
> 
> No need for the SoB here.
> 
>> ---
> 
> Odd format. That separator is not needed.
> 

We have removed the separator in v4.

>>   Documentation/scsi/index.rst               |    1 +
>>   Documentation/scsi/leapraid.rst            |   35 +
>>   MAINTAINERS                                |    7 +
>>   drivers/scsi/Kconfig                       |    1 +
>>   drivers/scsi/Makefile                      |    1 +
>>   drivers/scsi/leapraid/Kconfig              |   11 +
>>   drivers/scsi/leapraid/Makefile             |   10 +
>>   drivers/scsi/leapraid/leapraid.h           | 1128 +++
>>   drivers/scsi/leapraid/leapraid_app.c       |  713 ++
>>   drivers/scsi/leapraid/leapraid_func.c      | 8355 ++++++++++++++++++++
>>   drivers/scsi/leapraid/leapraid_func.h      | 1347 ++++
>>   drivers/scsi/leapraid/leapraid_os.c        | 2390 ++++++
>>   drivers/scsi/leapraid/leapraid_transport.c | 1235 +++
>>   13 files changed, 15234 insertions(+)
>>   create mode 100644 Documentation/scsi/leapraid.rst
>>   create mode 100644 drivers/scsi/leapraid/Kconfig
>>   create mode 100644 drivers/scsi/leapraid/Makefile
>>   create mode 100644 drivers/scsi/leapraid/leapraid.h
>>   create mode 100644 drivers/scsi/leapraid/leapraid_app.c
>>   create mode 100644 drivers/scsi/leapraid/leapraid_func.c
>>   create mode 100644 drivers/scsi/leapraid/leapraid_func.h
>>   create mode 100644 drivers/scsi/leapraid/leapraid_os.c
>>   create mode 100644 drivers/scsi/leapraid/leapraid_transport.c
>>
>> diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
>> index f15a0f348ae4..52970f0159ca 100644
>> --- a/Documentation/scsi/index.rst
>> +++ b/Documentation/scsi/index.rst
>> @@ -56,6 +56,7 @@ SCSI host adapter drivers
>>      g_NCR5380
>>      hpsa
>>      hptiop
>> +   leapraid
>>      libsas
>>      lpfc
>>      megaraid
>> diff --git a/Documentation/scsi/leapraid.rst b/Documentation/scsi/leapraid.rst
>> new file mode 100644
>> index 000000000000..3fb464bb1aef
>> --- /dev/null
>> +++ b/Documentation/scsi/leapraid.rst
>> @@ -0,0 +1,35 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=========================
>> +LeapRaid Driver for Linux
>> +=========================
>> +
>> +Introduction
>> +============
>> +
>> +LeapRaid is a storage RAID controller driver developed by LeapIO Tech.
>> +The controller targets enterprise storage, cloud infrastructure, high
>> +performance computing (HPC), and AI workloads.
>> +
>> +It provides high-performance storage virtualization over PCI Express
>> +Gen4 and supports both SAS and SATA HDDs and SSDs. It offers both Host
>> +Bus Adapter (HBA) and RAID modes to meet diverse deployment requirements.
>> +
>> +Features
>> +========
>> +- PCIe Gen4 x8 host interface
>> +- Support for SAS and SATA devices
>> +- RAID levels: 0, 1, 10, 5, 50, 6, 60
>> +- Advanced error handling and end-to-end data integrity
>> +- NVMe/SATA/SAS tri-mode connectivity (future roadmap)
> 
> If that is not supported now, then please remove that and add it back only once
> you have models that do support it.
> 

We have already made the corresponding removal in v4.

>> +
>> +File Location
>> +=============
>> +The driver source is located at:
>> +
>> +``drivers/scsi/leapraid/``
>> +
>> +.. note::
>> +
>> +   This document is intended for kernel developers and system
>> +   integrators who need to build, test, and deploy the LeapRaid driver.
> 
> Not much help is provided in this file at all. Building will be through the
> regular config+make. Rather, this document should describe (if any) the kernel
> module arguments and setup procedure if anything special is needed.
> 

In the next revision (v4), we not only include a description of the 
kernel module parameters, but also document the new attributes added 
under the sysfs directory. Thank you for the suggestion.

>> \ No newline at end of file
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index a20ec47e42ee..17ebb8830a25 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -13836,6 +13836,13 @@ S:	Maintained
>>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/hardening
>>   F:	scripts/leaking_addresses.pl
>>   
>> +LEAPIO SCSI RAID DRIVER
>> +M:	doubled <doubled@leap-io-kernel.com>
> 
> Same as for the signed-off tag: we need a person name here.
> 

doubled to Hao Dongdong here.

>> +L:	linux-scsi@vger.kernel.org
>> +S:	Supported
>> +F:	Documentation/scsi/leapraid.rst
>> +F:	drivers/scsi/leapraid/
>> +
> 
>> diff --git a/drivers/scsi/leapraid/Kconfig b/drivers/scsi/leapraid/Kconfig
>> new file mode 100644
>> index 000000000000..d32b5e4a7bde
>> --- /dev/null
>> +++ b/drivers/scsi/leapraid/Kconfig
>> @@ -0,0 +1,11 @@
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +config SCSI_LEAPRAID
>> +	tristate "LeapIO RAID Adapter"
>> +	depends on PCI && SCSI
>> +	select SCSI_SAS_ATTRS
>> +	help
>> +	  Driver for LeapIO Storage & RAID
>> +	  Controllers.
> 
> Why the early line split here ?

It was my fault. This has been fixed in v4.

> 
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called leapraid.
> 
> 
>> diff --git a/drivers/scsi/leapraid/leapraid.h b/drivers/scsi/leapraid/leapraid.h
>> new file mode 100644
>> index 000000000000..bfdab9700269
>> --- /dev/null
>> +++ b/drivers/scsi/leapraid/leapraid.h
>> @@ -0,0 +1,1128 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2025 LeapIO Tech Inc.
>> + */
>> +
>> +#ifndef LEAPRAID_H
>> +#define LEAPRAID_H
>> +
>> +#define REP_POST_HOST_IDX_REG_CNT (16)
> 
> The parenthesis around the value are not needed. Same comment applies to all the
> definitions below.
> 
>> +#define LEAPRAID_DB_RESET		(0x00000000)
>> +#define LEAPRAID_DB_READY		(0x10000000)
>> +#define LEAPRAID_DB_OPERATIONAL	(0x20000000)
>> +#define LEAPRAID_DB_FAULT		(0x40000000)
>> +#define LEAPRAID_DB_MASK		(0xF0000000)
> 
> [...]
> 
> A comment describing what this structure represent would be nice. Same for the
> following struct definitions.
> 
> And the same applies to the macro definitions before. Commenting groups of
> macros to describe what they are would be nice.
>

we have fixed them in v4. Thanks.

>> +struct leapraid_reg_base {
>> +	__le32 db;
>> +	__le32 ws;
>> +	__le32 host_diag;
>> +	__le32 r1[9];
>> +	__le32 host_int_status;
>> +	__le32 host_int_mask;
>> +	__le32 r2[4];
>> +	__le32 rep_msg_host_idx;
>> +	__le32 r3[29];
>> +	__le32 r4[2];
>> +	__le32 atomic_req_desc_post;
>> +	__le32 adapter_log_buf_pos;
>> +	__le32 host_log_buf_pos;
>> +	__le32 r5[142];
>> +	struct leapraid_rep_post_reg_idx {
>> +		__le32 idx;
>> +		__le32 r1;
>> +		__le32 r2;
>> +		__le32 r3;
>> +	} rep_post_reg_idx[REP_POST_HOST_IDX_REG_CNT];
>> +} __packed;
>> +
> 
>> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
>> new file mode 100644
>> index 000000000000..329244b93eef
>> --- /dev/null
>> +++ b/drivers/scsi/leapraid/leapraid_app.c
>> @@ -0,0 +1,713 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2025 LeapIO Tech Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + *
>> + * NO WARRANTY
>> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES
>> + * OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING,
>> + * WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE,
>> + * NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR
>> + * PURPOSE. Each Recipient is solely responsible for determining
>> + * the appropriateness of using and distributing the Program and
>> + * assumes all risks associated with its exercise of rights under
>> + * this Agreement, including but not limited to the risks and costs
>> + * of program errors, damage to or loss of data, programs or equipment,
>> + * and unavailability or interruption of operations.
>> +
>> + * DISCLAIMER OF LIABILITY
>> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY
>> + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
>> + * CONSEQUENTIAL DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS),
>> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
>> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
>> + * ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE PROGRAM OR
>> + * THE EXERCISE OF ANY RIGHTS GRANTED HEREUNDER, EVEN IF ADVISED OF
>> + * THE POSSIBILITY OF SUCH DAMAGES
> 
> No need for all this text. The SPDX header implies it.
> 
> [...]
> 

we have removed it in v4. Thanks.

>> +struct leapraid_ioctl_locate {
>> +	struct leapraid_ioctl_header hdr;
>> +	uint32_t id;
>> +	uint32_t bus;
>> +	uint16_t hdl;
>> +	uint16_t r0;
>> +};
>> +
>> +
> 
> Double whiteline not needed.
> 

The issue was introduced by our code-processing script. We have 
corrected the script’s logic to prevent this from happening again.

>> +static struct leapraid_adapter *
>> +leapraid_ctl_lookup_adapter(int adapter_number)
> 
> s/adapter_number/adapter_id ?
> 

Indeed, adapter_id is a better choice.

>> +{
>> +	struct leapraid_adapter *adapter;
>> +
>> +	spin_lock(&leapraid_adapter_lock);
>> +	list_for_each_entry(adapter, &leapraid_adapter_list, list) {
>> +		if (adapter->adapter_attr.id == adapter_number) {
>> +			spin_unlock(&leapraid_adapter_lock);
>> +			return adapter;
>> +		}
>> +	}
>> +	spin_unlock(&leapraid_adapter_lock);
>> +
>> +	return NULL;
>> +}
>> +
>> +static void
> 
> Why the line break here ? This is not the usual kernel code style.
> 

Emmm, our understanding has been wrong all along, influenced by my 
personal bias. It has been fixed in the next version.

>> +leapraid_cli_scsiio_cmd(struct leapraid_adapter *adapter,
>> +	 struct leapraid_req *ctl_sp_mpi_req, u16 taskid,
>> +	 dma_addr_t h2c_dma_addr, size_t h2c_size,
>> +	 dma_addr_t c2h_dma_addr, size_t c2h_size,
>> +	 u16 dev_hdl, void *psge)
> 
> The one tab identation of the arguments makes reading harder as they align with
> the code. Please use at least 2 tabs or align them with the function "(".
> 
> This comment and the one before apply to all other functions it seems.
> 

we have fixed in v4. Thanks.

>> +{
>> +	struct leapraid_mpi_scsiio_req *scsiio_request
>> +		 = (struct leapraid_mpi_scsiio_req *) ctl_sp_mpi_req;
>> +
>> +	scsiio_request->sense_buffer_len = SCSI_SENSE_BUFFERSIZE;
>> +	scsiio_request->sense_buffer_low_add =
>> +		 leapraid_get_sense_buffer_dma(adapter, taskid);
>> +	memset((void *)(&adapter->driver_cmds.ctl_cmd.sense),
>> +		 0, SCSI_SENSE_BUFFERSIZE);
>> +	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
>> +		 h2c_size, c2h_dma_addr, c2h_size);
>> +	if (scsiio_request->func == LEAPRAID_FUNC_SCSIIO_REQ)
>> +		leapraid_fire_scsi_io(adapter, taskid, dev_hdl);
>> +	else
>> +		leapraid_fire_task(adapter, taskid);
>> +}
>> +
>> +static void
>> +leapraid_ctl_smp_passthrough_cmd(struct leapraid_adapter *adapter,
>> +	 struct leapraid_req *ctl_sp_mpi_req, u16 taskid,
>> +	 dma_addr_t h2c_dma_addr, size_t h2c_size,
>> +	 dma_addr_t c2h_dma_addr, size_t c2h_size,
>> +	 void *psge, void *h2c)
>> +{
>> +	struct leapraid_smp_passthrough_req *smp_pt_req =
>> +		 (struct leapraid_smp_passthrough_req *) ctl_sp_mpi_req;
>> +	u8 *data;
>> +
>> +	if (!adapter->adapter_attr.enable_mp)
>> +		smp_pt_req->physical_port = LEAPRAID_DISABLE_MP_PORT_ID;
>> +	if (smp_pt_req->passthrough_flg & 0x80)
>> +		data = (u8 *) &smp_pt_req->sgl;
>> +	else
>> +		data = h2c;
>> +
>> +	if (data[1] == 0x91 && (data[10] == 1 || data[10] == 2))
> 
> What are these magic numbers ? Using a macro definition for them would make
> things more intelligible.
> 

We have reviewed all magic numbers and replaced them with standardized 
macros.

>> +		adapter->reset_desc.adapter_link_resetting = true;
>> +	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr,
>> +		 h2c_size, c2h_dma_addr, c2h_size);
>> +	leapraid_fire_task(adapter, taskid);
>> +}
>> +
>> +static void
>> +leapraid_ctl_fire_ieee_cmd(struct leapraid_adapter *adapter,
>> +	 dma_addr_t h2c_dma_addr, size_t h2c_size,
>> +	 dma_addr_t c2h_dma_addr, size_t c2h_size,
>> +	 void *psge, u16 taskid)
>> +{
>> +	leapraid_build_ieee_sg(adapter, psge, h2c_dma_addr, h2c_size,
>> +		 c2h_dma_addr, c2h_size);
> 
> Odd alignment. Please align with "adapter" on the previous line.
> 

Get! We have fixed in next version V4.

>> +	leapraid_fire_task(adapter, taskid);
>> +}
> 
> 
>> +static long
>> +leapraid_ctl_do_command(struct leapraid_adapter *adapter,
>> +	 struct leapraid_ioctl_command *karg, void __user *mf)
>> +{
>> +	struct leapraid_req *leap_mpi_req = NULL;
>> +	struct leapraid_req *ctl_sp_mpi_req = NULL;
>> +	u16 taskid;
>> +	void *h2c = NULL;
>> +	size_t h2c_size = 0;
>> +	dma_addr_t h2c_dma_addr = 0;
>> +	void *c2h = NULL;
>> +	size_t c2h_size = 0;
>> +	dma_addr_t c2h_dma_addr = 0;
>> +	void *psge;
>> +	unsigned long timeout;
>> +	u16 dev_hdl = LEAPRAID_INVALID_DEV_HANDLE;
>> +	bool issue_reset = false;
>> +	u32 sz;
>> +	long rc = 0;
>> +
>> +	rc = leapraid_check_adapter_is_op(adapter);
>> +	if (rc)
>> +		goto out;
>> +
>> +	leap_mpi_req = kzalloc(LEAPRAID_REQUEST_SIZE, GFP_KERNEL);
>> +	if (!leap_mpi_req) {
>> +		rc = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	if (karg->data_sge_offset * 4 > LEAPRAID_REQUEST_SIZE
>> +		 || karg->data_sge_offset > ((~0U) / 4)) {
> 
> Code style: "||" should be on the previous line. And align with the if "(".
> Same code style problems below.
> 

We have reviewed all similar issues and completed the fixes in v4.

> ~0U is UINT_MAX.
>

fixed!

>> +		rc = -EINVAL;
>> +		goto out;
>> +	}
> 
> I stop here. This patch is too long. Scanning it, I see the same code style
> issues all over it:
>   - Lots of double blank lines.
>   - Odd line breaks and parameter alignments
>   - if conditions formatting
> 
> 

Consistent with the common issues described earlier, we have completed 
the corresponding fixes in V4.

Thank you again for reviewing our code.

Best regards,
Haodongdong

