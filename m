From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 3/7] scsi: megaraid_sas - Online COntroller Reset (OCR)
 PART-III
Date: Tue, 18 May 2010 14:58:06 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D03FD42D@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80BE9@cosmail02.lsi.com>
 <4BE40D6B.5020501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39586 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab0ERU6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2010 16:58:40 -0400
In-Reply-To: <4BE40D6B.5020501@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

Tomas,

For the space, my e-mail shows tab.  Can you setup your e-mail as "plain text" to see if resolve this problem?

for (wait = 0; wait < 30; wait++) {
> +                       msleep(1000);
> +               }
>   

It can be replaced by ssleep(30);

Also change: 
> +               printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
To:
> +               printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine, "

Thanks,

Bo Yang


-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Friday, May 07, 2010 8:54 AM
To: Yang, Bo
Cc: 'James.Bottomley@HansenPartnership.com'; 'James.Bottomley@suse.de'; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Daftardar, Jayant
Subject: Re: [PATCH 3/7] scsi: megaraid_sas - Online COntroller Reset (OCR) PART-III

On 05/06/2010 05:52 PM, Yang, Bo wrote:
> This is third part of the Online Controller Reset. In ISR routine, if driver receive the FW state change interrupt
> And the online controller reset support enabled in FW, driver will read the controller register.  Driver will issue
> Controller reset if the FW register state failure.  Also driver will back up the pending cmds for the re-fire after
> the reset finished.
>
> Also Driver added the CTIO support to this patch.
>
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>
> +static void
> +process_fw_state_change_wq(struct work_struct *work)
> +{
> +       struct megasas_instance *instance =
> +               container_of(work, struct megasas_instance, work_init);
> +       u32 wait;
> +       unsigned long flags;
> +
> +       if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
> +               printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
> +                               instance->adprecovery);
> +               return ;
> +       }
> +
> +       if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
> +               printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
> +                                       "state, restarting it...\n");
> +
> +               instance->instancet->disable_intr(instance->reg_set);
> +               atomic_set(&instance->fw_outstanding, 0);
> +
> +               atomic_set(&instance->fw_reset_no_pci_access, 1);
> +               instance->instancet->adp_reset(instance, instance->reg_set);
> +               atomic_set(&instance->fw_reset_no_pci_access, 0 );
> +
> +               printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
> +                                       "initiating next stage...\n");
> +
> +               printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
> +                                       "state 2 starting...\n");
> +
> +               /*waitting for about 20 second before start the second init*/
> +               for (wait = 0; wait < 30; wait++) {
> +                       msleep(1000);
> +               }
>   
Hi Bo,
I'm only curios - couldn't be the above loop replaced by ssleep(30); 
and have the u32 wait; removed?
+		ssleep(30); /* wait for about 30 second before second init */

I guess you wanted to have a space after the comma in the printk, if yes I think
you should do this -> printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine, "

It might be a problem with my mail reader, but it seems to me that you are using 
spaces instead of tabs almost everywhere.

Tomas


