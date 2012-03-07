From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Date: Wed, 07 Mar 2012 16:58:33 +0100
Message-ID: <4F5785A9.2040707@bfs.de>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com> <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn> <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com> <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:1144 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab2CGP6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 10:58:36 -0500
In-Reply-To: <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: santoshprasadnayak@gmail.com, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>



Am 07.03.2012 16:11, schrieb Mark Salyzyn:
> One more NAK:
> 
>> @@ -3497,7 +3499,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> {
>> 	u32 pHeader = (u32)*(u32 *)piomb;
>> -	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
>> +	u8 opc = (u8)(pHeader & 0xFFF);
>>
>> 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
> 
> The swap is necessary. Should be:
> 
> 	__le32 pHeader = (__le32)*(__le32 *)piomb;
> 
> instead ...
> 

hi,

would it help to make piomb __le32 instead of void ?

Also i do not understand what want to gain from 0xFFF
Doing (u8) is effectively doing & 0xFF.

re,
 wh



