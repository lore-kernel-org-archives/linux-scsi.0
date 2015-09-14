From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI device
 hot-removal
Date: Mon, 14 Sep 2015 16:33:24 +0800
Message-ID: <55F68654.4070709@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
 <55F6837A.5020807@suse.de>
 <EB35ED741F0E024A8A7C30A8B22D7DA61FAF5D3D98@MX27A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <EB35ED741F0E024A8A7C30A8B22D7DA61FAF5D3D98@MX27A.corp.emc.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Ballabio, Dario" <dario.ballabio@emc.com>, Hannes Reinecke <hare@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2015/9/14 16:31, Ballabio, Dario wrote:
> Agreed, It does not make sense to have  this driver converted to a hot plug api.
Thanks, got the point:)
Originally i thought user may trigger PCI device hot-removal by sysfs
interfaces and there's comment mentioning that eata driver breaks
PCI hotplug, so I tried to solve it. If it's no real use, we may
just drop the third patch.
Thanks!
Gerry

> 
> Cheers,
> 
> 
> 
> ***************************************
> Ph.D. Dario Ballabio
> Principal Field Support Specialist, EMC EMEA 
> Mobile phone: +393487978851
> 
> 
> 
> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de] 
> Sent: Monday, September 14, 2015 10:21 AM
> To: Jiang Liu; Thomas Gleixner; Bjorn Helgaas; Arthur Marsh; Ballabio, Dario; James E.J. Bottomley
> Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; linux-scsi@vger.kernel.org; x86@kernel.org
> Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI device hot-removal
> 
> On 09/14/2015 05:08 AM, Jiang Liu wrote:
>> Due to having no hardware for testing, this is just a sample code to 
>> support PCI device hot-removal. It just passing compilation, no any 
>> tests.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/scsi/eata.c |   26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c index 
>> b92e6856f909..f3bd7cbf260e 100644
>> --- a/drivers/scsi/eata.c
>> +++ b/drivers/scsi/eata.c
>> @@ -1474,6 +1474,21 @@ static unsigned int port_probe(unsigned long 
>> port_base,  #ifdef CONFIG_PCI  static int eata2x_pci_device_count;
>>  
>> +/* TODO: need help here to shutdown the scsi host and release 
>> +resources */ static void port_remove(unsigned int id, resource_size_t port_base,
>> +			struct pci_dev *pdev)
>> +{
>> +	struct Scsi_Host *shost = sh[id];
>> +
>> +	/* TODO: stop scsi device */
>> +	scsi_unregister(shost);
>> +	/* TODO: clean up resources allocated by port_detect() */
>> +	clear_bit(id, eata_board_bitmap);
>> +	free_irq(shost->irq, &sha[id]);
>> +	release_region(port_base, REGION_SIZE);
>> +	ida_simple_remove(&eata_ida, id);
>> +}
>> +
>>  static int eata2x_pci_probe(struct pci_dev *dev, const struct 
>> pci_device_id *id)  {
>>  	int i, ret = -ENXIO;
>> @@ -1521,6 +1536,16 @@ out_error:
>>  	return ret;
>>  }
>>  
>> +static void eata2x_pci_remove(struct pci_dev *pdev) {
>> +	int id = (int)(long)dev_get_drvdata(&pdev->dev);
>> +	resource_size_t port_base;
>> +
>> +	port_base = pci_resource_start(pdev, 0) + PCI_BASE_ADDRESS_0;
>> +	port_remove(id, port_base, pdev);
>> +	pci_disable_device(pdev);
>> +}
>> +
>>  static struct pci_device_id eata2x_tbl[] = {
>>  	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_SCSI << 8, PCI_ANY_ID) },
>>  	{ },
>> @@ -1531,6 +1556,7 @@ static struct pci_driver eata2x_pci_driver = {
>>  	.name		= "eata",
>>  	.id_table	= eata2x_tbl,
>>  	.probe		= eata2x_pci_probe,
>> +	.remove		= eata2x_pci_remove,
>>  };
>>  
>>  static int eata2x_probe_pci_devices(struct scsi_host_template *tpnt)
>>
> Welll ... if you don't have hardware (and I strongly hope you refer to 'hardware able to do hotplugging', not 'hardware for the eata driver'
> ...) why add the code at all?
> Chances are no-one will ever need eata PCI hotplug; SCSI parallel typically isn't very good at hotplugging, so throwing in PCI hotplug will only confuse matters more.
> Plus due to the sheer mechanics involved here I find it very unlikely anyone will be using it in real life.
> 
> Cheers,
> 
> Hannes
> 
