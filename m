From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH][SCSI] megaraid_sas: addded support for big endian
 architecture
Date: Wed, 11 Sep 2013 11:51:26 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A01F3380@inbmail01.lsi.com>
References: <201309061020.r86AKpAY015172@cosmhbs0.lsi.com>
 <1378851112.23501.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:33696
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab3IKGVe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 02:21:34 -0400
In-Reply-To: <1378851112.23501.53.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "aradford@gmail.com" <aradford@gmail.com>


>-----Original Message-----
>From: James Bottomley [mailto:jbottomley@parallels.com]
>Sent: Wednesday, September 11, 2013 3:42 AM
>To: Saxena, Sumit
>Cc: linux-scsi@vger.kernel.org; Desai, Kashyap; aradford@gmail.com
>Subject: Re: [PATCH][SCSI] megaraid_sas: addded support for big endian
>architecture
>
>On Fri, 2013-09-06 at 15:50 +0530, Sumit.Saxena@lsi.com wrote:
>> This patch will add big endian architecture support to megaraid_sas
>> driver. The support added is for LSI MegaRAID all generation
>controllers- (3Gb/s, 6Gb/s and 12 Gb/s controllers).
>>
>> This patch will be applied on top of recently submitted patch for Hi=
gh
>> Avaibility support-
>> http://marc.info/?l=3Dlinux-scsi&m=3D137799326426659&w=3D2
>> We have done basic sanity test @ppc64 arch and @x86_64. Additional
>testing/observations are welcome.
>
>Well, no it won't actually; it gives a rejection here:
>
>
>> --- drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -5097,8 +5142,9 @@
>>
>>  	for (i =3D 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
>>  		dma_free_coherent(&instance->pdev->dev,
>> -				    kern_sge32[i].length,
>> -				    kbuff_arr[i], kern_sge32[i].phys_addr);
>> +				  le32_to_cpu(kern_sge32[i].length),
>> +				  kbuff_arr[i],
>> +				  le32_to_cpu(kern_sge32[i].phys_addr));
>>  	}
>>
>>  	megasas_return_cmd(instance, cmd);
>
>Because you didn't take into account this patch:
>
>Author: Bj=F8rn Mork <bjorn@mork.no>
>Date:   Wed Nov 21 09:54:48 2012 +0100
>
>    [SCSI] megaraid_sas: fix memory leak if SGL has zero length entrie=
s
>
>I fixed it up this time, but could you please work against the misc
>branch of the scsi git repo to prevent this type of problem in future?

Sorry for inconvenience. In future, I will take care of this.

>
>Thanks,
>
>James
>

Thanks,
Sumit

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
