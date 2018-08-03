From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sr: Avoid that opening a CD-ROM hangs with runtime power
 management enabled
Date: Fri, 3 Aug 2018 10:28:45 +0200
Message-ID: <20180803082845.nntzwgny6fprg54r@linux-x5ow.site>
References: <20180802174442.7310-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180802174442.7310-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 02, 2018 at 10:44:42AM -0700, Bart Van Assche wrote:
> Surround scsi_execute() calls with scsi_autopm_get_device() and
> scsi_autopm_put_device(). Note: removing sr_mutex protection from
> the scsi_cd_get() and scsi_cd_put() calls is safe because the
> purpose of sr_mutex is to serialize cdrom_*() calls.
> 
[...]

Hi Bart,

With this patch I still have the hang on next-20180801:

[  247.875657] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  247.877560]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  247.878703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.880497] swapper/0       D13496     1      0 0x80000000
[  247.881542] Call Trace:
[  247.882638]  ? __schedule+0x253/0x700
[  247.882898]  schedule+0x23/0x80
[  247.883149]  async_synchronize_cookie_domain+0x89/0xd0
[  247.883509]  ? wait_woken+0x80/0x80
[  247.883712]  ? rest_init+0xb0/0xb0
[  247.883907]  kernel_init+0xa/0x100
[  247.884096]  ret_from_fork+0x35/0x40
[  370.755258] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  370.756735]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  370.757931] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  370.759417] swapper/0       D13496     1      0 0x80000000
[  370.760567] Call Trace:
[  370.761141]  ? __schedule+0x253/0x700
[  370.761982]  schedule+0x23/0x80
[  370.762534]  async_synchronize_cookie_domain+0x89/0xd0
[  370.762818]  ? wait_woken+0x80/0x80
[  370.763020]  ? rest_init+0xb0/0xb0
[  370.763279]  kernel_init+0xa/0x100
[  370.763478]  ret_from_fork+0x35/0x40
[  493.635108] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  493.636403]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  493.637449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  493.638803] swapper/0       D13496     1      0 0x80000000
[  493.639963] Call Trace:
[  493.640669]  ? __schedule+0x253/0x700
[  493.641446]  schedule+0x23/0x80
[  493.642023]  async_synchronize_cookie_domain+0x89/0xd0
[  493.643114]  ? wait_woken+0x80/0x80
[  493.643923]  ? rest_init+0xb0/0xb0
[  493.644411]  kernel_init+0xa/0x100
[  493.644680]  ret_from_fork+0x35/0x40
[  616.515472] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  616.516773]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  616.517790] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  616.519260] swapper/0       D13496     1      0 0x80000000
[  616.520322] Call Trace:
[  616.520854]  ? __schedule+0x253/0x700
[  616.521662]  schedule+0x23/0x80
[  616.522249]  async_synchronize_cookie_domain+0x89/0xd0
[  616.523402]  ? wait_woken+0x80/0x80
[  616.524002]  ? rest_init+0xb0/0xb0
[  616.524779]  kernel_init+0xa/0x100
[  616.525054]  ret_from_fork+0x35/0x40
[  739.394997] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  739.396351]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  739.397411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  739.398751] swapper/0       D13496     1      0 0x80000000
[  739.399841] Call Trace:
[  739.400506]  ? __schedule+0x253/0x700
[  739.401152]  schedule+0x23/0x80
[  739.401856]  async_synchronize_cookie_domain+0x89/0xd0
[  739.402527]  ? wait_woken+0x80/0x80
[  739.402773]  ? rest_init+0xb0/0xb0
[  739.402997]  kernel_init+0xa/0x100
[  739.403311]  ret_from_fork+0x35/0x40
[  862.275229] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  862.276636]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  862.277882] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.279358] swapper/0       D13496     1      0 0x80000000
[  862.280492] Call Trace:
[  862.281074]  ? __schedule+0x253/0x700
[  862.281958]  schedule+0x23/0x80
[  862.282765]  async_synchronize_cookie_domain+0x89/0xd0
[  862.283921]  ? wait_woken+0x80/0x80
[  862.284836]  ? rest_init+0xb0/0xb0
[  862.285327]  kernel_init+0xa/0x100
[  862.285520]  ret_from_fork+0x35/0x40
[  985.155031] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  985.156626]       Not tainted 4.18.0-rc7-next-20180801+ #131
[  985.157699] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  985.159032] swapper/0       D13496     1      0 0x80000000
[  985.160313] Call Trace:
[  985.160819]  ? __schedule+0x253/0x700
[  985.161303]  schedule+0x23/0x80
[  985.161480]  async_synchronize_cookie_domain+0x89/0xd0
[  985.161734]  ? wait_woken+0x80/0x80
[  985.161914]  ? rest_init+0xb0/0xb0
[  985.162080]  kernel_init+0xa/0x100
[  985.162334]  ret_from_fork+0x35/0x40


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
