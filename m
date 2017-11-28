From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] libsas: flush pending destruct work in sas_unregister_domain_devices()
Date: Tue, 28 Nov 2017 09:00:54 -0800
Message-ID: <CAM_iQpV-uy9VXfVx9s5AX8TN5-0G=7Ny0uvmCCn7V7ys_gBbWw@mail.gmail.com>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com> <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 28, 2017 at 12:20 AM, Johannes Thumshirn <jthumshirn@suse.de> w=
rote:
> On Mon, Nov 27, 2017 at 04:24:45PM -0800, Cong Wang wrote:
>> We saw dozens of the following kernel waring:
>>
>>  WARNING: CPU: 0 PID: 705 at fs/sysfs/group.c:224 sysfs_remove_group+0x5=
4/0x88()
>>  sysfs group ffffffff81ab7670 not found for kobject '6:0:3:0'
>>  Modules linked in: cpufreq_ondemand x86_pkg_temp_thermal coretemp kvm_i=
ntel kvm microcode raid0 iTCO_wdt iTCO_vendor_support sb_edac edac_core lpc=
_ich mfd_core ioatdma i2c_i801 shpchp wmi hed acpi_cpufreq lp parport tcp_d=
iag inet_diag ipmi_si ipmi_devintf ipmi_msghandler sch_fq_codel igb ptp pps=
_core i2c_algo_bit i2c_core crc32c_intel isci libsas scsi_transport_sas dca=
 ipv6
>>  CPU: 0 PID: 705 Comm: kworker/u240:0 Not tainted 4.1.35.el7.x86_64 #1
>
> This should by now be fixed with commit fbce4d97fd43 ("scsi: fixup kernel
> warning during rmmod()" which went into v4.14-rc6.

I don't see the full backtrace in commit fbce4d97fd43, but it is probably
not rmmod path in our case.
