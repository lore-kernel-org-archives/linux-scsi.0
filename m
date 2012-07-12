From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Subject: Re: [PATCH] libfcoe: fix section mismatches
Date: Thu, 12 Jul 2012 19:59:12 +0000
Message-ID: <7A90C06A-0CE4-4787-8254-289B4BC7EF01@intel.com>
References: <20120711110210.GA3619@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5792 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2GLT7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2012 15:59:30 -0400
In-Reply-To: <20120711110210.GA3619@osiris.boeblingen.de.ibm.com>
Content-Language: en-US
Content-ID: <48D40C6997C8E7498973BA68E3C86D1C@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <JBottomley@Parallels.com>, "Love, Robert W" <robert.w.love@intel.com>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>

On Jul 11, 2012, at 4:02 AM, Heiko Carstens wrote:

> Fix this warning:
> 
> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c):
> Section mismatch in reference from the function init_module()
> to the function .exit.text:fcoe_transport_exit()

As far as I can see, resolving this issue only requires removing the __exit annotation from the fcoe_transport_exit function, as three previous patches have done. I believe that is the correct fix and I have verified that by building with full section analysis turned on.

> libfcoe_init() calls fcoe_transport_exit() which is annotated with
> __exit which puts it into the exit section.
> If the driver would be compiled into the kernel the exit section
> could be discarded at compile time, so all calls to functions which
> reside in the exit section would be jumps to random data.
> 
> Not really an issue currently since the exit section is currently
> only discarded at runtime together with the init section. So this
> patch only removes the compile time warning.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> drivers/scsi/fcoe/fcoe_sysfs.c     |    2 +-
> drivers/scsi/fcoe/fcoe_transport.c |    4 ++--
> include/scsi/fcoe_sysfs.h          |    2 +-
> 3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> index 2bc1631..7d6c119 100644
> --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> @@ -826,7 +826,7 @@ int __init fcoe_sysfs_setup(void)
> 	return 0;
> }
> 
> -void __exit fcoe_sysfs_teardown(void)
> +void fcoe_sysfs_teardown(void)
> {
> 	bus_unregister(&fcoe_bus_type);
> }
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index b46f43d..ea87f6b 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
> 	return 0;
> }
> 
> -static int __exit fcoe_transport_exit(void)
> +static int fcoe_transport_exit(void)
> {
> 	struct fcoe_transport *ft;
> 
> @@ -832,7 +832,7 @@ module_init(libfcoe_init);
> /**
>  * libfcoe_exit() - Tear down libfcoe.ko
>  */
> -static void __exit libfcoe_exit(void)
> +static void libfcoe_exit(void)
> {
> 	fcoe_sysfs_teardown();
> 	fcoe_transport_exit();
> diff --git a/include/scsi/fcoe_sysfs.h b/include/scsi/fcoe_sysfs.h
> index 604cb9b..8e7a41a 100644
> --- a/include/scsi/fcoe_sysfs.h
> +++ b/include/scsi/fcoe_sysfs.h
> @@ -119,6 +119,6 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *,
> void fcoe_fcf_device_delete(struct fcoe_fcf_device *);
> 
> int __init fcoe_sysfs_setup(void);
> -void __exit fcoe_sysfs_teardown(void);
> +void fcoe_sysfs_teardown(void);
> 
> #endif /* FCOE_SYSFS */

So, please use the earlier patch and not this one.

-- 
Mark Rustad, LAN Access Division, Intel Corporation

