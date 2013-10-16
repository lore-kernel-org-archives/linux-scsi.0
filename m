From: Praveen Murali <pmurali@logicube.com>
Subject: Re: eSATA Drive Detection issues on mvsas
Date: Wed, 16 Oct 2013 10:28:21 -0700
Message-ID: <525ECCB5.8040104@logicube.com>
References: <525C89D3.5090008@logicube.com> <525DDABB.2040906@logicube.com> <CAPcyv4hdCYkdxoK_1zjdRt-vDHk0K8wLV6OnpnkXVGJzKg0PMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:33667 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761215Ab3JPR2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 13:28:53 -0400
In-Reply-To: <CAPcyv4hdCYkdxoK_1zjdRt-vDHk0K8wLV6OnpnkXVGJzKg0PMg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com


On 10/15/2013 06:11 PM, Dan Williams wrote:
> On Tue, Oct 15, 2013 at 5:15 PM, Praveen Murali <pmurali@logicube.com> wrote:
>> Dan/James,
>>   Can you please take a look at this and let me know if I am at the right
>> place? Or point me in the right direction? As I understand, this deost not
>> look like an mvsas driver issue.
>>
> Looks like a latent bug in libsas to me.  Commit 110dd8f1 "[SCSI]
> libsas: fix scr_read/write users and update the libata documentation"
> looks like a compile fix when the build was broken by commit  9977126c
> "libata: add @is_cmd to ata_tf_to_fis()" where libata changed the
> interface for ata_tf_to_fis().  We were passing 0 for pmp prior to
> that and changed to 1 here, probably a typo intending 'is_cmd to
> always be 1.
>
> Somehow we have gotten away with is_cmd being 0?  Does the following
> patch work for you:
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 161c98efade9..d0fb99d5da95 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct
> ata_queued_cmd *qc)
>                  qc->tf.nsect = 0;
>          }
>
> -       ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
> +       ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8*)&task->ata_task.fis);
>          task->uldd_task = qc;
>          if (ata_is_atapi(qc->tf.protocol)) {
>                  memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
>
Hi Dan,
   I tested this patch and it works great!

Thanks,
Praveen
> That being said I don't think anybody has really checked out
> port-multiplier support on libsas, but we shouldn't be setting this
> bit by default.
>
> --
> Dan
>
>
>> On 10/14/2013 05:18 PM, Praveen Murali wrote:
>>> Hi,
>>>    I have couple of external drives (Western Digital and Seagate) that have
>>> an eSATA interface. My Linux box with a Marvell HBA (9445) running Ubuntu
>>> 12.04 with 3.2.48 kernel doest not seem to detect the drive. I tried with
>>> the latest upstream kernel and it behaves the same. But both the drives
>>> detect fine if I enter the mvsas BIOS during bootup. So I have hooked up a
>>> SATA analyzer and this is what I found
>>> - When I tried to detect the drives in the mvsas BIOS, all the ATA
>>> commands that the bios issues have the port multiplier byte set to 0.
>>> - If I bootup my Linux system and then connect the drives, the first
>>> IDENTIFY command has the port multiplier set to 0 (this one is successful)
>>> and the subsequent IDENTIFY command has port multiplier set to 1 (this one
>>> fails).
> I assume the first IDENTIFY is coming from the BIOS, not Linux correct?
>
>>> - If I connect any other SATA drives I have to the HBA, all the ATA
>>> commands have port multiplier set to 1 but they detects and work fine.
>>>
>>> Just to rule out the port-multiplier possibility I changed the following
>>> line in drivers/scsi/libsas/sas_ata.c - fucntion sas_ata_qc_issue()
>>>
>>> ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
>>>
>>> to
>>>
>>> ata_tf_to_fis(&qc->tf, 0, 0, (u8*)&task->ata_task.fis);
>>>
>>> now all my drives seem to detect just fine. I believe, the eSATA interface
>>> on these external drives is a port multiplier, which is why the command
>>> fails. Also, the normal drives ignore this field thats why they work fine
>>> with port multiplier being set to either 0 or 1.
>>>
>>> Question(s): Are my above assumtions correct? If so, what is the reasoning
>>> behind setting the port multiplier to 1 by default in libsas layer?
>>>
>>> Thanks,
>>> Praveen
>>>
>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

