From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] scsi: pm8001: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 12:30:45 +0200
Message-ID: <820dee0c-8231-ecc6-1999-d6f9e38991b4@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <20170329094122.9997-4-jthumshirn@suse.de>
 <CAMGffEmv-fkF1NOvOsc=YooJWeGW4BjJa00gXUoOYCi6rhYsFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEmv-fkF1NOvOsc=YooJWeGW4BjJa00gXUoOYCi6rhYsFg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/29/2017 12:27 PM, Jinpu Wang wrote:
> On Wed, Mar 29, 2017 at 11:41 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
>> removal path of kernfs to make it recursive we have to remove the SAS host
>> before the SCSI host or we will see sysfs warnings on not found sysfs groups for
>> kobjects.
>>
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> ---
>>  drivers/scsi/pm8001/pm8001_init.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index 417368c..9116e9c 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -1086,11 +1086,21 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>>  {
>>         struct sas_ha_struct *sha = pci_get_drvdata(pdev);
>>         struct pm8001_hba_info *pm8001_ha;
>> +       unsigned long flags;
>> +       struct Scsi_Host *shost;
>>         int i, j;
>>         pm8001_ha = sha->lldd_ha;
>> -       scsi_remove_host(pm8001_ha->shost);
>> +       shost = pm8001_ha->shost;
>> +
>> +       spin_lock_irqsave(shost->host_lock, flags);
>> +       if (scsi_host_set_state(shost, SHOST_CANCEL))
>> +               WARN_ON(scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY));
>> +       spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>>         sas_unregister_ha(sha);
>> -       sas_remove_host(pm8001_ha->shost);
>> +       sas_remove_host(shost);
>> +       scsi_remove_host(shost);
>> +
>>         list_del(&pm8001_ha->list);
>>         PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
>>         PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>> --
>> 1.8.5.6
>>
> Thanks Johannes for taking care of this. Looks good to me,
> 
> I have a question regarding the scsi_host_set_state change, why do we need that?
> Can't we simply change the order of sas_remove_host and scsi_remove_host?
> 
If we don't do that I/O might still be coming in for the attached ports
while we're trying to remove the same. Which might cause all sorts of
race conditions.
So it's better to set the host state to CANCEL to stop I/O before
removing the ports.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
