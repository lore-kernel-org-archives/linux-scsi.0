From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: [PATCH 2/3] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Sat, 1 Jun 2019 15:40:07 +0000
Message-ID: <AT5PR8401MB1169E817136F8B8587C7A716AB1A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <1559397700-15585-1-git-send-email-info@metux.net>
 <1559397700-15585-3-git-send-email-info@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559397700-15585-3-git-send-email-info@metux.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <info@metux.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>, "jdelvare@suse.com" <jdelvare@suse.com>, "linux@roeck-us.net" <linux@roeck-us.net>, "khalid@gonehiking.org" <khalid@gonehiking.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@microsemi.com" <aacraid@microsemi.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Enrico Weigelt, metux IT consult
> Sent: Saturday, June 01, 2019 9:02 AM
> Subject: [PATCH 2/3] drivers: scsi: remove unnecessary #ifdef MODULE
> 
> The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
> so the extra check here is not necessary.
> 
...
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
...
> 
> -#ifdef MODULE
>  static struct pci_device_id dptids[] = {
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID,
> PCI_ANY_ID,},
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID,
> PCI_ANY_ID,},
>  	{ 0, }
>  };
> -#endif
> -
>  MODULE_DEVICE_TABLE(pci,dptids);

I don't see any reply to James' comment that these changes result in
static struct definitions that are unused, which should result in
complaints by the compiler like:
    warning: 'dptids' defined by not used [-Wunused-variable]
