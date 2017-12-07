From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] libsas: flush pending destruct work in sas_unregister_domain_devices()
Date: Thu, 7 Dec 2017 14:57:58 -0800
Message-ID: <CAM_iQpVWmeq5BMvxJmD2FP6Zm6s7O05+NqzYQ6uCAp7iE1asnw@mail.gmail.com>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
 <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site> <922397da-7dd3-c24e-1d94-e4804a769331@huawei.com>
 <CAM_iQpVXuO=jHg=wyse7OoGDzLNrz3hFc_aqAPR=FsF_+s5gaw@mail.gmail.com> <877cfb17-ba90-da91-a549-418bb6eb6391@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877cfb17-ba90-da91-a549-418bb6eb6391@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 7, 2017 at 5:37 AM, John Garry <john.garry@huawei.com> wrote:
> On 28/11/2017 17:04, Cong Wang wrote:
>>
>> I don't understand, the only caller of sas_unregister_domain_devices()
>> is sas_deform_port().
>>
>
> And sas_deform_port() may be called from another worker on the same queue,
> right? As in sas_phye_loss_of_signal()->sas_deform_port()

Oh, good catch! I didn't notice this subtle call path.

Do you have any better idea to fix this? We saw this on 4.9 too.

>
> The device destruct takes place in a separate worker from which
> sas_deform_port() is called, but the same queue. So we have this queued
> destruct happen after the port is fully deformed -> hence the WARN.
>
> I guess you only tested your patch on disks attached through an expander.

I have very limited scsi hardware, so my testing is limited too.
