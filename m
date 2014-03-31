From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 3/4] target/rd: T10-Dif: Add init/format support
Date: Mon, 31 Mar 2014 16:14:30 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CE9A4A@avmb2.qlogic.org>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
 <1396047927-14189-4-git-send-email-quinn.tran@qlogic.com>
 <533610D2.5030205@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9A4Aavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:47362 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbaCaQOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 12:14:33 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s2VGDWDH010397
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 09:14:33 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1jwyhbm0da-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2014 09:14:32 -0700
In-Reply-To: <533610D2.5030205@mellanox.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sagi grimberg <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9A4Aavmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D596C9AB8FB304FBC488311C8EBB5E0@qlogic.com>
Content-Transfer-Encoding: quoted-printable


Regards,
Quinn Tran




On 3/28/14 5:16 PM, "sagi grimberg" <sagig@mellanox.com> wrote:

>On 3/29/2014 2:05 AM, Quinn Tran wrote:
>> This patch is borrow code from
>>
>> commit 0f5e2ec46dd64579c0770f3822764f94db4fa465
>> Author: Nicholas Bellinger <nab@linux-iscsi.org>
>> Date:   Sat Jan 18 09:32:56 2014 +0000
>>
>>      target/file: Add DIF protection init/format support
>>
>>      This patch adds support for DIF protection init/format support into
>>      the FILEIO backend.
>>
>>      It involves using a seperate $FILE.protection for storing PI that
>>is
>>      opened via fd_init_prot() using the common pi_prot_type attribute.
>>      The actual formatting of the protection is done via
>>fd_format_prot()
>>      using the common pi_prot_format attribute, that will populate the
>>      initial PI data based upon the currently configured pi_prot_type.
>>
>>      Based on original FILEIO code from Sagi.
>>
>>      v1 changes:
>>        - Fix sparse warnings in fd_init_format_buf (Fengguang)
>>
>>      Cc: Martin K. Petersen <martin.petersen@oracle.com>
>>      Cc: Christoph Hellwig <hch@lst.de>
>>      Cc: Hannes Reinecke <hare@suse.de>
>>      Cc: Sagi Grimberg <sagig@mellanox.com>
>>      Cc: Or Gerlitz <ogerlitz@mellanox.com>
>>      Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>> ---
>>   drivers/target/target_core_rd.c | 64
>>++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_rd.c
>>b/drivers/target/target_core_rd.c
>> index 66a5aba..01dda0b 100644
>> --- a/drivers/target/target_core_rd.c
>> +++ b/drivers/target/target_core_rd.c
>> @@ -603,7 +603,7 @@ static int rd_init_prot(struct se_device *dev)
>>   {
>>      struct rd_dev *rd_dev =3D RD_DEV(dev);
>>
>> -        if (!dev->dev_attrib.pi_prot_type)
>> +    if (!dev->dev_attrib.pi_prot_type)
>>              return 0;
>>
>>      return rd_build_prot_space(rd_dev, dev->prot_length);
>> @@ -616,6 +616,67 @@ static void rd_free_prot(struct se_device *dev)
>>      rd_release_prot_space(rd_dev);
>>   }
>>
>> +static void rd_init_format_buf(struct se_device *dev, unsigned char
>>*buf,
>> +                           u32 unit_size, u32 *ref_tag, u16 app_tag,
>> +                           bool inc_reftag)
>> +{
>> +    unsigned char *p =3D buf;
>> +    int i;
>> +
>> +    for (i =3D 0; i < unit_size; i +=3D dev->prot_length) {
>> +            *((u16 *)&p[0]) =3D 0xffff;
>> +            *((__be16 *)&p[2]) =3D cpu_to_be16(app_tag);
>> +            *((__be32 *)&p[4]) =3D cpu_to_be32(*ref_tag);
>> +
>> +            if (inc_reftag)
>> +                    (*ref_tag)++;
>> +
>> +            p +=3D dev->prot_length;
>> +    }
>> +}
>> +
>> +static int rd_format_prot(struct se_device *dev)
>> +{
>> +    struct rd_dev *rd_dev =3D RD_DEV(dev);
>> +    u32 ref_tag =3D 0;
>> +    int i,j;
>> +    bool inc_reftag =3D false;
>> +    struct rd_dev_sg_table *pt;
>> +    struct scatterlist *sg;
>> +    void *paddr;
>> +
>> +    if (!dev->dev_attrib.pi_prot_type) {
>> +            pr_err("Unable to format_prot while pi_prot_type =3D=3D 0\n=
");
>> +            return -ENODEV;
>> +    }
>> +
>> +    switch (dev->dev_attrib.pi_prot_type) {
>> +    case TARGET_DIF_TYPE3_PROT:
>> +            ref_tag =3D 0xffffffff;
>> +            break;
>> +    case TARGET_DIF_TYPE2_PROT:
>> +    case TARGET_DIF_TYPE1_PROT:
>> +            inc_reftag =3D true;
>> +            break;
>> +    default:
>> +            break;
>> +    }
>> +
>> +    for (i=3D0; i < rd_dev->sg_prot_count; i++) {
>> +            pt=3D &rd_dev->sg_prot_array[i];
>> +            for_each_sg(pt->sg_table, sg, pt->rd_sg_count, j) {
>> +                    paddr =3D kmap(sg_page(sg)) + sg->offset;
>> +
>> +                    rd_init_format_buf(dev, paddr, sg->length, &ref_tag=
,
>> +                                    0xffff, inc_reftag);
>> +                    kunmap(paddr);
>> +            }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +
>>   static struct sbc_ops rd_sbc_ops =3D {
>>      .execute_rw             =3D rd_execute_rw,
>>   };
>> @@ -642,6 +703,7 @@ static struct se_subsystem_api rd_mcp_template =3D {
>>      .get_device_type        =3D sbc_get_device_type,
>>      .get_blocks             =3D rd_get_blocks,
>>      .init_prot              =3D rd_init_prot,
>> +    .format_prot            =3D rd_format_prot,
>>      .free_prot              =3D rd_free_prot,
>>   };
>>
>
>This patch is redundant altogether. rd_mcp already init protection with
>escape values:
>rc =3D rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);

QT> I see.  Will re-examine my code to live without this function.

>


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9A4Aavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
aJogz27AU9RqgSKRZHmLIY6h3+wCTMCMggVgjqBoq5Z1sFsZkFbhdvcwHaBzIQdyv4XAThP3MFox
VJH5QWz5dP+wty4Y2PD5gHCQ+VF1oIrAT4rC1YKkh6uVUVSOAEl37LF3AD+gV6/Q9jC1UC3JlFBh
bY2hIG1sIIVA/4xABHKAkJoQbTMvoI6w0pDtaTFmv5Bs4y5zrHqWc6xf15B6/3vbc6xpE21usHP/
M1HFoJQwfoFsIPuhLWG/8fpkWkB1fhCeMGlAhUCeMD5h9lCLITfUbQK1QG9tWCBRTGrA6vFDLSBw
fy0ggSTPwY6gaUAFcMiwbHB5LW93y6JS8v2Qaf3AQGlusHex+6B2MCtAInC/ilGMoIogjECeMISg
bHUQOkn/4HkvoMWgtVAgbj8FQWrxnhLSYHLxRcFjaf9ToH/xjACG4oVih2Jr4owA+ZtAcHmxIfwB
DZFM4Yog/c/BdRmxd8OAyYaXy/B3EX2IcWV3AbTwd8MNgGpQc/918H4wbQKAkQPBLSAu0biDf4dS
/9BsIIeiGbCUMYMRbf9+EISR+8CDsCJwbCC1UFRw/2wgdaA4AK/QfoNq8a9ghiCfuIBUoXfDfhV4
ln19q+ABldAAAB8AQgABAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AZQABAAAALAAA
AHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwBkAAEAAAAKAAAA
UwBNAFQAUAAAAAAAAgFBAAEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBu
ACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAB8AAl0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAHwDlXwEAAAA0AAAAcwBpAHAAOgBxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAB8AGgwBAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AHwwB
AAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAeDAEA
AAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1
AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAHwD4PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAjQAEA
AAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfACJAAQAA
AAoAAABTAE0AVABQAAAAAAACAfk/AQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUA
aQBuAG4AIABUAHIAYQBuAAAAUwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAHwAJXQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAa
AAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQsw
AQAAABAAAABomxhaGiJETqL9lLicUeS3AwAXAAEAAABAADkAAHeMS/xMzwFAAAgw2BqcS/xMzwEL
AACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4A
AABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAHgAAABSAGUAOgAgAFsAUABBAFQA
QwBIACAAMwAvADQAXQAgAHQAYQByAGcAZQB0AC8AcgBkADoAIABUADEAMAAtAEQAaQBmADoAIABB
AGQAZAAgAGkAbgBpAHQALwBmAG8AcgBtAGEAdAAgAHMAdQBwAHAAbwByAHQAAAAfAD0AAQAAAAoA
AABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAQAAAADwANQAzADMANgAxADAARAAyAC4ANQAw
ADMAMAAyADAANQBAAG0AZQBsAGwAYQBuAG8AeAAuAGMAbwBtAD4AAAACAXEAAQAAACAAAAABAc9K
312uMBVTO3gjS6aIYnXlWLT5mvenzwCAA7sGAB8AcAABAAAAcAAAAFsAUABBAFQAQwBIACAAMwAv
ADQAXQAgAHQAYQByAGcAZQB0AC8AcgBkADoAIABUADEAMAAtAEQAaQBmADoAIABBAGQAZAAgAGkA
bgBpAHQALwBmAG8AcgBtAGEAdAAgAHMAdQBwAHAAbwByAHQAAAAfADUQAQAAAHgAAAA8ADUAMAA0
AEUAQgA2ADYARABBAEMAOABEADIAMwA0AEUAQgA4AEUAOAA1ADYAMAA5ADgANQBDADIARAA3AEEA
RAA0ADYAQwBFADkAQQA0AEEAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAf
ADkQAQAAACgBAAA8ADEAMwA5ADYAMAA0ADcAOQAyADcALQAxADQAMQA4ADkALQAxAC0AZwBpAHQA
LQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBj
AC4AYwBvAG0APgAgADwAMQAzADkANgAwADQANwA5ADIANwAtADEANAAxADgAOQAtADQALQBnAGkA
dAAtAHMAZQBuAGQALQBlAG0AYQBpAGwALQBxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQA+ACAAPAA1ADMAMwA2ADEAMABEADIALgA1ADAAMwAwADIAMAA1AEAAbQBlAGwA
bABhAG4AbwB4AC4AYwBvAG0APgAAAAMA3j+fTgAAQAAHMLj2lEv8TM8BAwAmAAAAAAACAUcAAQAA
AC8AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE0MDMzMTE2MTQzMFotMTc1MDk4AAAfABUQ
AQAAAFgAAAA0AEQANQA5ADYAQwA5AEEAQgA4AEYAQgAzADAANABGAEIAQwA0ADgAOAAzADEAMQBD
ADgARQBCAEIANQBFADAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAMAAAAZQEAAKil
mbZSAAAAHwD6PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEAAABGAAAATQBpAGMAcgBvAHMA
bwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4AMwAuADkALgAxADMAMQAwADMAMAAA
AAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkA
bgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAABABAABJAEkAPQAwADEAMAAxAEMARgA0
AEMARgBDADQAQgA0AEQAOABBADYAMwA2ADIAQgA5AEEAQwBEADYANAA0AEEAQwA0ADUANQBDAEEA
QgA4AEIAMABEADEAQQA4ADcAOwBTAEIATQBJAEQAPQAzADsAUwAxAD0APAA1ADMAMwA2ADEAMABE
ADIALgA1ADAAMwAwADIAMAA1AEAAbQBlAGwAbABhAG4AbwB4AC4AYwBvAG0APgA7AFYAZQByAHMA
aQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1AGkAbABkACAAMwA4ADcALgAw
ACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAA
IAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAA
AAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEA
AAAcAAAAWwAxADcAMgAuADMAMAAuADQALgA5ADAAXQAAAKV0

--_000_504EB66DAC8D234EB8E8560985C2D7AD46CE9A4Aavmb2qlogicorg_--
