From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 4/7] scsi: libsas: split the replacement of sas disks
 in two steps
Date: Thu, 31 Jan 2019 10:04:28 +0800
Message-ID: <5C5257AC.3040303@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
 <20190130082412.9357-5-yanaijie@huawei.com>
 <17908564-35f2-4c5d-e9e4-4fe109fae4cc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17908564-35f2-4c5d-e9e4-4fe109fae4cc@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 2019/1/31 1:22, John Garry wrote:
> On 30/01/2019 08:24, Jason Yan wrote:
>> Now if a new device replaced a old device, the sas address will change.
>
> Hmmm... not if it's a SATA disk, which would have some same invented SAS
> address.
>

Yes, it's only for a SAS disk.

>> We unregister the old device and discover the new device in one
>> revalidation process. But after we deferred the sas_port_delete(), the
>> sas port is not deleted when we registering the new port and device.
>> The sas port cannot be added because the name of the new port is the
>> same as the old.
>>
>> Fix this by doing the replacement in two steps. The first revalidation
>> only delete the old device and trigger a new revalidation. The second
>> revalidation discover the new device. To keep the event processing
>> synchronised to the original event,
>
> Did I originally suggest this? It seems to needlessly make the code more
> complicated.
>

Yes, my first version was raise a new bcast event, and you said it's not 
synchronised to the original event.  Shall I get back to that approach?

> we wrapped a loop and added a new
>> parameter to see if we should revalidate again.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: chenxiang <chenxiang66@hisilicon.com>
>> CC: John Garry <john.garry@huawei.com>
>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>> CC: Ewan Milne <emilne@redhat.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> CC: Tomas Henzl <thenzl@redhat.com>
>> CC: Dan Williams <dan.j.williams@intel.com>
>> CC: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/libsas/sas_discover.c | 20 +++++++++++++++-----
>>  drivers/scsi/libsas/sas_expander.c | 20 ++++++++++++++------
>>  include/scsi/libsas.h              |  2 +-
>>  3 files changed, 30 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c
>> b/drivers/scsi/libsas/sas_discover.c
>> index ffc571a12916..c825c89fbddd 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -498,12 +498,10 @@ static void sas_discover_domain(struct
>> work_struct *work)
>>           task_pid_nr(current), error);
>>  }
>>
>> -static void sas_revalidate_domain(struct work_struct *work)
>> +static void sas_do_revalidate_domain(struct asd_sas_port *port, bool
>> *retry)
>>  {
>> -    struct sas_discovery_event *ev = to_sas_discovery_event(work);
>> -    struct asd_sas_port *port = ev->port;
>> -    struct sas_ha_struct *ha = port->ha;
>>      struct domain_device *ddev = port->port_dev;
>> +    struct sas_ha_struct *ha = port->ha;
>>
>>      /* prevent revalidation from finding sata links in recovery */
>>      mutex_lock(&ha->disco_mutex);
>> @@ -520,7 +518,7 @@ static void sas_revalidate_domain(struct
>> work_struct *work)
>>
>>      if (ddev && (ddev->dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
>>               ddev->dev_type == SAS_EDGE_EXPANDER_DEVICE))
>> -        sas_ex_revalidate_domain(ddev);
>> +        sas_ex_revalidate_domain(ddev, retry);
>>
>>      pr_debug("done REVALIDATING DOMAIN on port %d, pid:%d\n",
>>           port->id, task_pid_nr(current));
>> @@ -532,6 +530,18 @@ static void sas_revalidate_domain(struct
>> work_struct *work)
>>      sas_probe_devices(port);
>>  }
>>
>> +static void sas_revalidate_domain(struct work_struct *work)
>> +{
>> +    struct sas_discovery_event *ev = to_sas_discovery_event(work);
>> +    struct asd_sas_port *port = ev->port;
>> +    bool retry;
>> +
>> +    do {
>> +        retry = false;
>> +        sas_do_revalidate_domain(port, &retry);
>> +    } while (retry);
>> +}
>> +
>>  /* ---------- Events ---------- */
>>
>>  static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work
>> *sw)
>> diff --git a/drivers/scsi/libsas/sas_expander.c
>> b/drivers/scsi/libsas/sas_expander.c
>> index 5cd720f93f96..cdbf8d8a28bf 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1994,7 +1994,8 @@ static bool dev_type_flutter(enum
>> sas_device_type new, enum sas_device_type old)
>>      return false;
>>  }
>>
>> -static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>> bool last)
>> +static int sas_unregister(struct domain_device *dev, int phy_id, bool
>> last,
>> +                  bool *retry)
>>  {
>>      struct expander_device *ex = &dev->ex_dev;
>>      struct ex_phy *phy = &ex->ex_phy[phy_id];
>> @@ -2045,7 +2046,12 @@ static int sas_rediscover_dev(struct
>> domain_device *dev, int phy_id, bool last)
>>          SAS_ADDR(phy->attached_sas_addr));
>>      sas_unregister_devs_sas_addr(dev, phy_id, last);
>>
>> -    return sas_discover_new(dev, phy_id);
>> +    /* force the next revalidation find this phy and bring it up */
>> +    phy->phy_change_count = -1;
>> +    ex->ex_change_count = -1;
>> +    *retry = true;
>
> Ohh, sorry to say, but that's a real hack :)
>

This is the way sas_resume_port() already in use.

> Could we just add a flag for the expander PHY to force a discovery
> instead of this?
>

of course we can add a flag instead of this, but I don't think it worth
to do this. We have to change the logic of sas_find_bcast_dev() and
sas_find_bcast_phy() to achieve this. Or we have to add a new function
to find out which PHY's flag is set.

> I assume that you need to do this as the expander PHY change count will
> not be modified for the next revalidation (so no discovery on that PHY).
>

To save one instruction(assign), we have to add two(check and assign)?
And how to predict if the PHY change count will be modified or not?
It's unnessesary to do this.

>> +
>> +    return 0;
>>  }
>>
>>  /**
>> @@ -2062,7 +2068,8 @@ static int sas_rediscover_dev(struct
>> domain_device *dev, int phy_id, bool last)
>>   * first phy,for other phys in this port, we add it to the port to
>>   * forming the wide-port.
>>   */
>> -static void sas_rediscover(struct domain_device *dev, const int phy_id)
>> +static void sas_rediscover(struct domain_device *dev, const int phy_id,
>> +               bool *retry)
>>  {
>>      struct expander_device *ex = &dev->ex_dev;
>>      struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
>> @@ -2087,7 +2094,7 @@ static void sas_rediscover(struct domain_device
>> *dev, const int phy_id)
>>                  break;
>>              }
>>          }
>> -        res = sas_rediscover_dev(dev, phy_id, last);
>> +        res = sas_unregister(dev, phy_id, last, retry);
>>      } else
>>          res = sas_discover_new(dev, phy_id);
>>
>> @@ -2098,13 +2105,14 @@ static void sas_rediscover(struct
>> domain_device *dev, const int phy_id)
>>  /**
>>   * sas_ex_revalidate_domain - revalidate the domain
>>   * @port_dev: port domain device.
>> + * @retry: do we need to revalidate again
>>   *
>>   * NOTE: this process _must_ quit (return) as soon as any connection
>>   * errors are encountered.  Connection recovery is done elsewhere.
>>   * Discover process only interrogates devices in order to discover the
>>   * domain.
>>   */
>> -void sas_ex_revalidate_domain(struct domain_device *port_dev)
>> +void sas_ex_revalidate_domain(struct domain_device *port_dev, bool
>> *retry)
>>  {
>>      int res;
>>      struct domain_device *dev = NULL;
>> @@ -2119,7 +2127,7 @@ void sas_ex_revalidate_domain(struct
>> domain_device *port_dev)
>>              res = sas_find_bcast_phy(dev, &phy_id, i, true);
>>              if (phy_id == -1)
>>                  break;
>> -            sas_rediscover(dev, phy_id);
>> +            sas_rediscover(dev, phy_id, retry);
>>              i = phy_id + 1;
>>          } while (i < ex->num_phys);
>>      }
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index e557bcb0c266..deb75765e555 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -692,7 +692,7 @@ int  sas_discover_root_expander(struct
>> domain_device *);
>>
>>  void sas_init_ex_attr(void);
>>
>> -void sas_ex_revalidate_domain(struct domain_device *);
>> +void sas_ex_revalidate_domain(struct domain_device *port_dev, bool
>> *retry);
>>
>>  void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>>  void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>>
>
>
>
> .
>
