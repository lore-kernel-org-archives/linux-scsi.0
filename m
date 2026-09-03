Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EDF43F8CB;
	Thu,  3 Sep 2026 11:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788433617; cv=none; b=f9GjPrWCE6dyJJ3NPjKq54u99NZMZueA8icDXClgVqbbx0wgV/Rx7xv6ekysVc4py8Se6sYosIKrmQxEJxXKwTOheKJvDQ7bcyAHgzOuO9h+9yTZAeLo93DL5xzqRAvRiXrmfmLbDoAN7SvcozAOL2dGCbmqyoUVf7RIt71oawg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788433617; c=relaxed/simple;
	bh=kIECYLJ0Lhld+rc4UMBxA6Qh7mWAjQPTPcvrmtj6vv4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=HhFjBdf//7uaHEUre0kLyRvPdnlo1JZd79boAhPbZP9tBQZDmGCMjdqs0ux5stUWapQizyjsc+BrFDH5/fI7+2yALNQSv/do4rWCGaYC8o2ijqWymJG8Lx1HEJEj4uqqhbqWWeRqSNh023cvrvn4y33fQkzaji+0WBT+IivW3CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dQkF38sX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dQkF38sX"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683AVuWY863506;
	Thu, 3 Sep 2026 11:06:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NFgNB7
	axdDrw4t8l2n5ehgvwhVrE0e5iyT2tbSd2QJ0=; b=dQkF38sXl4GH7ts5110nDO
	con9P5XzcEAG1SJN/xZUvX9xDKkU4ntmF7iHykPcR7dZwV7e0Xupo1aIMdcy/xWD
	Rk6YhuhTvTs9d4oc1cS5R/SSbWZCZPhLJnV5T+l1u7u8NRfUs/MBzrRevWLzM8oc
	WUANsHc4DKw/igmWM9PklO+2/3uatwZD4rkud3CLOSN95ySmGJpaxBUTQTSz7rqV
	3DTBwh6ii625PUImhhHGnxzY4ZNS/9uQvChpLZAqqqagjtxVBMH4NtiCQpq0Fd6q
	TZn2leB2Q7jLCFWMUs32rkqDX+5DUxKx9LyF7/Mgt0KmDQ0n2iv4yV4xBBlU61LA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq3rmen2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 11:06:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683AuGMC032089;
	Thu, 3 Sep 2026 11:06:42 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcarkfbk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 11:06:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683B6fUW3146256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 11:06:41 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39F7C58095;
	Thu,  3 Sep 2026 11:06:41 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C7175806F;
	Thu,  3 Sep 2026 11:06:40 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Sep 2026 11:06:40 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 16:36:40 +0530
From: pavrampu <pavrampu@linux.ibm.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, mkp@kernel.org,
        tyreld@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] scsi: ibmvfc: Add Kconfig dependency to fix link failure
 when NVME_FC=m
In-Reply-To: <20260903074329.6705-1-venkat88@linux.ibm.com>
References: <20260903074329.6705-1-venkat88@linux.ibm.com>
Message-ID: <fabf9740a05f3613e27c326b6764cb27@linux.ibm.com>
X-Sender: pavrampu@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EIc2FVZC c=1 sm=1 tr=0 ts=6a9954c3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=CSFViTR-3ySk4wZe9v0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDA5NiBTYWx0ZWRfXyLhfRTNyWT/b
 LuC9XRPxUlAq+7oV8lOURXL5aSx+ZGv+t1ovNR7UrR719Apta6ET1jstqPkWv8RWnR6l0LWx0yL
 CMkuKcbG9hFs0e2iQinxfokkW8Qvb24YXSPN7CT1LLi0pVJfmQOqzIgsGDm1eozM+DgqJpLNyuj
 UUQEi0AmsjLr7cjUmeWi8wErteQuYEWGgWW4S2tsoYDzKEbyRu6iHiQHHclmfYU7X+PlD5ksS9a
 9fh2bnkNriiAr5oqZY72nrKrmaIn+H6CQW3mjvG/mgJsungaI1TLIC1tIYTUa3eg2Bi5wUG4Unl
 EMzvxIsqgUPDc/84xzSAbKt28G7eWIA3/MVjG5d/kNS+7iW1vNLr2o9O4Y4viAmEthKRfSGSbfP
 jqeDGJtTcCJlvzjR6n2mfk27FWKU7D3LdQquNpOVBJXUJ2eZaIlXeTEbMcwE+48P9ZKV45pXfNY
 TW57htNl8ZfV5UyaTbA==
X-Proofpoint-GUID: SoeDcYRIpi6tzGHZgBrlDmKD2KZ45vSH
X-Proofpoint-ORIG-GUID: SoeDcYRIpi6tzGHZgBrlDmKD2KZ45vSH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDA5NiBTYWx0ZWRfX0zLigq4GTwEg
 JUTkdnQfLLemozIGMF6Srug9jNiXk0O35WAAidOvAK90kbbid/IvZaTZEXltAq07M+NIKscT6BA
 76QqepjQg9uOWGuZ6rfnlvPHUYJqg9A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_03,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030096

On 2026-09-03 13:13, Venkat Rao Bagalkote wrote:
> Building with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in a
> link failure:
> 
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_remoteport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_remoteport'
>   ibmvfc-core.o: undefined reference to `nvme_fc_rescan_remoteport'
> 
> IS_ENABLED() evaluates to 1 for both =y and =m, so the nvme_fc_*
> call sites are kept in the object file. When SCSI_IBMVFC=y (built-in)
> but NVME_FC=m (loadable module), the linker cannot resolve these
> symbols at vmlinux link time.
> 
> Add the same "depends on NVME_FC || NVME_FC=n" constraint already
> used by SCSI_LPFC to prevent this configuration.
> 
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes:
> https://lore.kernel.org/all/327877a29337aa526cc50ac88fbddb86@linux.ibm.com/
> Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> ---

Hi Venkat,

Tested the patch, compilation issue is not observed with patch.

Logs:
-----
without patch:
:/home/linux-next # make -j 80
   UPD     include/generated/utsversion.h
   CC      init/version-timestamp.o
   KSYMS   .tmp_vmlinux0.kallsyms.S
   AS      .tmp_vmlinux0.kallsyms.o
   LD      .tmp_vmlinux1
/usr/bin/ld.bfd: warning: discarding dynamic section .glink
/usr/bin/ld.bfd: warning: discarding dynamic section .plt
/usr/bin/ld.bfd: linkage table error against 
`nvme_fc_unregister_remoteport'
/usr/bin/ld.bfd: stubs don't match calculated size
/usr/bin/ld.bfd: can not build stubs: bad value
/usr/bin/ld.bfd: drivers/scsi/ibmvscsi/ibmvfc-core.o: in function 
`ibmvfc_rport_add_thread':
ibmvfc-core.c:(.text+0x70dc): undefined reference to 
`nvme_fc_rescan_remoteport'
/usr/bin/ld.bfd: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_register_remoteport':
ibmvfc-nvme.c:(.text+0x1420): undefined reference to 
`nvme_fc_register_remoteport'
/usr/bin/ld.bfd: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_unregister_remoteport':
ibmvfc-nvme.c:(.text+0x153c): undefined reference to 
`nvme_fc_unregister_remoteport'
/usr/bin/ld.bfd: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_register':
ibmvfc-nvme.c:(.text+0x164c): undefined reference to 
`nvme_fc_register_localport'
/usr/bin/ld.bfd: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_unregister':
ibmvfc-nvme.c:(.text+0x1778): undefined reference to 
`nvme_fc_unregister_localport'
make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 1
make[1]: *** [/home/linux-next/Makefile:1390: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2

with patch:

:/home/linux-next # patch -p1 < patch
patching file drivers/scsi/Kconfig
:/home/linux-next # make -j 80
   SYNC    include/config/auto.conf
   UPD     include/config/kernel.release
   UPD     include/generated/utsrelease.h
.
.
   COPY    arch/powerpc/boot/fdt_rw.c
   COPY    arch/powerpc/boot/fdt_sw.c
   COPY    arch/powerpc/boot/fdt_wip.c
   BOOTCC  arch/powerpc/boot/libfdt-wrapper.o
   BOOTCC  arch/powerpc/boot/inffast.o
   COPY    arch/powerpc/boot/decompress_inflate.c
   BOOTCC  arch/powerpc/boot/empty.o
   BOOTCC  arch/powerpc/boot/fdt.o
   BOOTCC  arch/powerpc/boot/fdt_ro.o
   BOOTCC  arch/powerpc/boot/fdt_rw.o
   BOOTCC  arch/powerpc/boot/fdt_strerror.o
   BOOTCC  arch/powerpc/boot/fdt_sw.o
   BOOTCC  arch/powerpc/boot/fdt_wip.o
   BOOTCC  arch/powerpc/boot/inflate.o
   BOOTCC  arch/powerpc/boot/inftrees.o
   BOOTCC  arch/powerpc/boot/decompress.o
   BOOTAR  arch/powerpc/boot/wrapper.a
   WRAP    arch/powerpc/boot/zImage.pseries
   WRAP    arch/powerpc/boot/zImage.epapr

Please add below tag:

Tested-by: Pavithra <pavrampu@linux.ibm.com>

Thanks,
Pavithra

>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4a2af0f702e1..1eec66195cf4 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -753,6 +753,7 @@ config SCSI_IBMVFC
>  	tristate "IBM Virtual FC support"
>  	depends on PPC_PSERIES && SCSI
>  	depends on SCSI_FC_ATTRS
> +	depends on NVME_FC || NVME_FC=n
>  	help
>  	  This is the IBM POWER Virtual FC Client

