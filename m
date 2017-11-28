From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] libsas: flush pending destruct work in
 sas_unregister_domain_devices()
Date: Tue, 28 Nov 2017 11:18:24 +0000
Message-ID: <922397da-7dd3-c24e-1d94-e4804a769331@huawei.com>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
 <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 28/11/2017 08:20, Johannes Thumshirn wrote:
> On Mon, Nov 27, 2017 at 04:24:45PM -0800, Cong Wang wrote:
>> We saw dozens of the following kernel waring:
>>
>>  WARNING: CPU: 0 PID: 705 at fs/sysfs/group.c:224 sysfs_remove_group+0x54/0x88()
>>  sysfs group ffffffff81ab7670 not found for kobject '6:0:3:0'
>>  Modules linked in: cpufreq_ondemand x86_pkg_temp_thermal coretemp kvm_intel kvm microcode raid0 iTCO_wdt iTCO_vendor_support sb_edac edac_core lpc_ich mfd_core ioatdma i2c_i801 shpchp wmi hed acpi_cpufreq lp parport tcp_diag inet_diag ipmi_si ipmi_devintf ipmi_msghandler sch_fq_codel igb ptp pps_core i2c_algo_bit i2c_core crc32c_intel isci libsas scsi_transport_sas dca ipv6
>>  CPU: 0 PID: 705 Comm: kworker/u240:0 Not tainted 4.1.35.el7.x86_64 #1
>
> This should by now be fixed with commit fbce4d97fd43 ("scsi: fixup kernel
> warning during rmmod()" which went into v4.14-rc6.
>

Is that the same issue? I think Cong Wang is just trying to deal with 
the longstanding libsas hotplug WARN.

We at Huawei are still working to fix it. Our patchset is under internal 
test at the moment.

As for this patch:
 >  drivers/scsi/libsas/sas_discover.c | 7 ++++++-
 >  1 file changed, 6 insertions(+), 1 deletion(-)
 >
 > diff --git a/drivers/scsi/libsas/sas_discover.c 
b/drivers/scsi/libsas/sas_discover.c
 > index 60de66252fa2..27c11fc7aa2b 100644
 > --- a/drivers/scsi/libsas/sas_discover.c
 > +++ b/drivers/scsi/libsas/sas_discover.c
 > @@ -388,6 +388,11 @@ void sas_unregister_dev(struct asd_sas_port 
*port, struct domain_device *dev)
 >  	}
 >  }
 >
 > +static void sas_flush_work(struct asd_sas_port *port)
 > +{
 > +	scsi_flush_work(port->ha->core.shost);
 > +}
 > +
 >  void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 >  {
 >  	struct domain_device *dev, *n;
 > @@ -401,8 +406,8 @@ void sas_unregister_domain_devices(struct 
asd_sas_port *port, int gone)
 >  	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 >  		sas_unregister_dev(port, dev);
 >
 > +	sas_flush_work(port);

How can this work as sas_unregister_domain_devices() may be called from 
the same workqueue which you're trying to flush?

 >  	port->port->rphy = NULL;
 > -
 >  }
 >
 >  void sas_device_set_phy(struct domain_device *dev, struct sas_port 
*port)
 >

Thanks,
John
