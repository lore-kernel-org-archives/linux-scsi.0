From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4] scsi: xen-scsifront: add error handling for
 xenbus_printf
Date: Fri, 15 Jun 2018 14:04:07 +0800
Message-ID: <201806151359.YAoVhcz2%fengguang.wu@intel.com>
References: <1529027312-56770-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1529027312-56770-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, Zhouyang Jia <jiazhouyang09@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xen-tip/linux-next]
[also build test WARNING on v4.17 next-20180614]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/linux-kernel-owner-vger-kernel-org/scsi-xen-scsifront-add-error-handling-for-xenbus_printf/20180615-094919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git linux-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/xen-scsifront.c:267:21: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:440:33: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:440:33: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:473:33: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:473:33: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:474:33: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:474:33: sparse: expression using sizeof(void)
>> drivers/scsi/xen-scsifront.c:663:43: sparse: incorrect type in argument 1 (different base types) @@    expected struct xenbus_device *dev @@    got sstruct xenbus_device *dev @@
   drivers/scsi/xen-scsifront.c:663:43:    expected struct xenbus_device *dev
   drivers/scsi/xen-scsifront.c:663:43:    got struct xenbus_device **<noident>
   drivers/scsi/xen-scsifront.c:681:43: sparse: incorrect type in argument 1 (different base types) @@    expected struct xenbus_device *dev @@    got sstruct xenbus_device *dev @@
   drivers/scsi/xen-scsifront.c:681:43:    expected struct xenbus_device *dev
   drivers/scsi/xen-scsifront.c:681:43:    got struct xenbus_device **<noident>
   drivers/scsi/xen-scsifront.c:1063:19: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:1064:19: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c:1065:19: sparse: expression using sizeof(void)
   drivers/scsi/xen-scsifront.c: In function 'scsifront_sdev_configure':
   drivers/scsi/xen-scsifront.c:663:21: error: passing argument 1 of 'xenbus_dev_error' from incompatible pointer type [-Werror=incompatible-pointer-types]
       xenbus_dev_error(&info->dev, err,
                        ^
   In file included from drivers/scsi/xen-scsifront.c:50:0:
   include/xen/xenbus.h:224:6: note: expected 'struct xenbus_device *' but argument is of type 'struct xenbus_device **'
    void xenbus_dev_error(struct xenbus_device *dev, int err, const char *fmt, ...);
         ^~~~~~~~~~~~~~~~
   drivers/scsi/xen-scsifront.c: In function 'scsifront_sdev_destroy':
   drivers/scsi/xen-scsifront.c:681:21: error: passing argument 1 of 'xenbus_dev_error' from incompatible pointer type [-Werror=incompatible-pointer-types]
       xenbus_dev_error(&info->dev, err,
                        ^
   In file included from drivers/scsi/xen-scsifront.c:50:0:
   include/xen/xenbus.h:224:6: note: expected 'struct xenbus_device *' but argument is of type 'struct xenbus_device **'
    void xenbus_dev_error(struct xenbus_device *dev, int err, const char *fmt, ...);
         ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +663 drivers/scsi/xen-scsifront.c

   653	
   654	static int scsifront_sdev_configure(struct scsi_device *sdev)
   655	{
   656		struct vscsifrnt_info *info = shost_priv(sdev->host);
   657		int err;
   658	
   659		if (info && current == info->curr) {
   660			err = xenbus_printf(XBT_NIL, info->dev->nodename,
   661				      info->dev_state_path, "%d", XenbusStateConnected);
   662			if (err) {
 > 663				xenbus_dev_error(&info->dev, err,
   664					"%s: writing dev_state_path", __func__);
   665				return err;
   666			}
   667		}
   668	
   669		return 0;
   670	}
   671	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
