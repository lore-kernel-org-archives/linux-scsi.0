From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 06/13] qla4xxx: Prevent other port reinitialization
 during remove_adapter
Date: Wed, 16 Mar 2011 05:27:09 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8722659E4D1@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA872263B150C@AVEXMB1.qlogic.org>
 <4D7E9188.8010606@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA872263B1779@AVEXMB1.qlogic.org>
 <4D801080.5010801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:3738
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840Ab1CPM1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2011 08:27:35 -0400
In-Reply-To: <4D801080.5010801@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Wednesday, March 16, 2011 6:51 AM
>To: Vikas Chaudhary
>Cc: James Bottomley; linux-scsi@vger.kernel.org; Ravi Anand; Lalit
>Chandivade; Karen Higgins
>Subject: Re: [PATCH 06/13] qla4xxx: Prevent other port reinitialization
>during remove_adapter
>
>On 03/15/2011 04:21 AM, Vikas Chaudhary wrote:
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>> owner@vger.kernel.org] On Behalf Of Mike Christie
>>> Sent: Tuesday, March 15, 2011 3:37 AM
>>> To: Vikas Chaudhary
>>> Cc: James Bottomley; linux-scsi@vger.kernel.org; Ravi Anand; Lalit
>>> Chandivade; Karen Higgins
>>> Subject: Re: [PATCH 06/13] qla4xxx: Prevent other port reinitialization
>>> during remove_adapter
>>>
>>> On 03/14/2011 12:24 AM, Vikas Chaudhary wrote:
>>>> index 6068f80..59c5552 100644
>>>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>>>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>>>> @@ -27,6 +27,11 @@ static char qla4xxx_version_str[40];
>>>>    static struct kmem_cache *srb_cachep;
>>>>
>>>>    /*
>>>> + * List of host adapters
>>>> + */
>>>> +static struct klist qla4xxx_hostlist;
>>>> +
>>>
>>>
>>>
>>>>
>>>>    /**
>>>> + * qla4xxx_prevent_other_port_reinit - Mark the other ISP-4xxx port to
>>> indicate
>>>> + * that the driver is being removed, so that the other port will not
>>>> + * re-initialize while in the process of removing the ha due to driver
>>> unload
>>>> + * or hba hotplug.
>>>
>>> For docbook comments you use a one line description on the first line,
>>> then add more informative stuff after the params.
>>>
>>
>> Ok, I will be sending updated patch in next email.
>>
>>>
>>>> + * @ha: pointer to adapter structure
>>>> + **/
>>>> +static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host
>*ha)
>>>> +{
>>>> +       struct scsi_qla_host *ha_listp;
>>>> +       struct klist_iter i;
>>>> +       struct klist_node *n;
>>>> +
>>>> +       klist_iter_init(&qla4xxx_hostlist,&i);
>>>> +       while ((n = klist_next(&i)) != NULL) {
>>>> +               ha_listp = container_of(n, struct scsi_qla_host, node);
>>>> +               if (ha == ha_listp)
>>>> +                       continue;
>>>> +
>>>> +               if ((pci_domain_nr(ha->pdev->bus) ==
>>>> +                   pci_domain_nr(ha_listp->pdev->bus))&&
>>>> +                   (ha->pdev->bus->number ==
>>>> +                   ha_listp->pdev->bus->number)&&
>>>> +                   (PCI_SLOT(ha->pdev->devfn) ==
>>>> +                   PCI_SLOT(ha_listp->pdev->devfn))) {
>>>> +
>>>
>>> Is there a qla4xxx specific reason why you need to prevent other ports
>>>from re-initing when removing a port? Does the hardware cause the other
>>> ports to be disrupted and that causes them to run the re-init code?
>>
>> Yes, its ISP40XX specific. While unloading driver we make call to
>function
>> "qla4xxx_hw_reset" from "qla4xxx_free_adapter". When driver do hw_reset
>> for one port, hardware will generate interrupt for other ports to inform
>> reset is about to happen. After this interrupt driver will schedule reset
>> for other port by setting dpc flag "DPC_RESET_HA_INTR" in function
>> "qla4xxx_intr_handler" this will cause re-initialization of other port
>> after reset, but while unloading driver we don't want to schedule reset
>> for the other port as other port does not need re-initialization".
>>
>
>Ok.
>
>I think that the driver should not be needing to manage a list of hosts
>though. We have the driver model related lists already. There is also
>the pci bus stuff.  So I think you should be using one of those.

Agreed. Sending modified patch in next email.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

