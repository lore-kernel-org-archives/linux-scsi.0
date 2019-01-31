From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 3/7] scsi: libsas: optimize the debug print of the
 revalidate process
Date: Thu, 31 Jan 2019 09:31:14 +0800
Message-ID: <5C524FE2.9070801@huawei.com>
References: <20190130082412.9357-1-yanaijie@huawei.com>
 <20190130082412.9357-4-yanaijie@huawei.com>
 <2ffa6821-93d4-7925-d435-e34338f323ec@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2ffa6821-93d4-7925-d435-e34338f323ec@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiexiuqi@huawei.com, tj@kernel.org, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 2019/1/31 0:41, John Garry wrote:
> On 30/01/2019 08:24, Jason Yan wrote:
>> sas_rediscover() returns error code if discover failed for a expander
>> phy. And sas_ex_revalidate_domain() only returns the last phy's error
>> code. So when sas_revalidate_domain() prints the return value of the
>> discover process, we do not know if the revalidation for every phy is
>> successful or not. We just know the last bcast phy revalidation
>> succeeded or not.
>>
>> No need to return a error code for sas_ex_revalidate_domain() and
>> sas_rediscover(), and just print the debug log for each bcast phy
>> directly
>> in sas_rediscover().
>
> do we want to know about every PHY, or just the PHY where res != 0?
>

Here I mean every PHY that raises bcast.

>>
>
> I don't see any optimisation here. Maybe an improvement.
>

Thanks, I will change the wording.

>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: John Garry <john.garry@huawei.com>
>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>> CC: Ewan Milne <emilne@redhat.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> CC: Tomas Henzl <thenzl@redhat.com>
>> CC: Dan Williams <dan.j.williams@intel.com>
>> CC: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/libsas/sas_discover.c |  7 +++----
>>  drivers/scsi/libsas/sas_expander.c | 11 ++++++-----
>>  include/scsi/libsas.h              |  2 +-
>>  3 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c
>> b/drivers/scsi/libsas/sas_discover.c
>> index 726ada9b8c79..ffc571a12916 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -500,7 +500,6 @@ static void sas_discover_domain(struct work_struct
>> *work)
>>
>>  static void sas_revalidate_domain(struct work_struct *work)
>>  {
>> -    int res = 0;
>>      struct sas_discovery_event *ev = to_sas_discovery_event(work);
>>      struct asd_sas_port *port = ev->port;
>>      struct sas_ha_struct *ha = port->ha;
>> @@ -521,10 +520,10 @@ static void sas_revalidate_domain(struct
>> work_struct *work)
>>
>>      if (ddev && (ddev->dev_type == SAS_FANOUT_EXPANDER_DEVICE ||
>>               ddev->dev_type == SAS_EDGE_EXPANDER_DEVICE))
>> -        res = sas_ex_revalidate_domain(ddev);
>> +        sas_ex_revalidate_domain(ddev);
>>
>> -    pr_debug("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
>> -         port->id, task_pid_nr(current), res);
>> +    pr_debug("done REVALIDATING DOMAIN on port %d, pid:%d\n",
>> +         port->id, task_pid_nr(current));
>>   out:
>>      mutex_unlock(&ha->disco_mutex);
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c
>> b/drivers/scsi/libsas/sas_expander.c
>> index 7b0e6dcef6e6..5cd720f93f96 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -2062,7 +2062,7 @@ static int sas_rediscover_dev(struct
>> domain_device *dev, int phy_id, bool last)
>>   * first phy,for other phys in this port, we add it to the port to
>>   * forming the wide-port.
>>   */
>> -static int sas_rediscover(struct domain_device *dev, const int phy_id)
>> +static void sas_rediscover(struct domain_device *dev, const int phy_id)
>>  {
>>      struct expander_device *ex = &dev->ex_dev;
>>      struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
>> @@ -2090,7 +2090,9 @@ static int sas_rediscover(struct domain_device
>> *dev, const int phy_id)
>>          res = sas_rediscover_dev(dev, phy_id, last);
>>      } else
>>          res = sas_discover_new(dev, phy_id);
>> -    return res;
>> +
>> +    pr_debug("ex %016llx phy%d discover returned 0x%x\n",
>
> Hmmm.. this is not just discover, but also rediscover
>

Yes, will fix.

>> +         SAS_ADDR(dev->sas_addr), phy_id, res);
>>  }
>>
>>  /**
>> @@ -2102,7 +2104,7 @@ static int sas_rediscover(struct domain_device
>> *dev, const int phy_id)
>>   * Discover process only interrogates devices in order to discover the
>>   * domain.
>>   */
>> -int sas_ex_revalidate_domain(struct domain_device *port_dev)
>> +void sas_ex_revalidate_domain(struct domain_device *port_dev)
>>  {
>>      int res;
>>      struct domain_device *dev = NULL;
>> @@ -2117,11 +2119,10 @@ int sas_ex_revalidate_domain(struct
>> domain_device *port_dev)
>>              res = sas_find_bcast_phy(dev, &phy_id, i, true);
>
> this was missed

Yes, the return value of sas_find_bcast_phy() is actually unused, and
inside the function debug info has been printed. So we can directly
make it a void function.

>
>>              if (phy_id == -1)
>>                  break;
>> -            res = sas_rediscover(dev, phy_id);
>> +            sas_rediscover(dev, phy_id);
>>              i = phy_id + 1;
>>          } while (i < ex->num_phys);
>>      }
>> -    return res;
>>  }
>>
>>  void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index 420156cea3ee..e557bcb0c266 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -692,7 +692,7 @@ int  sas_discover_root_expander(struct
>> domain_device *);
>>
>>  void sas_init_ex_attr(void);
>>
>> -int  sas_ex_revalidate_domain(struct domain_device *);
>> +void sas_ex_revalidate_domain(struct domain_device *);
>>
>>  void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>>  void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>>
>
>
>
> .
>
