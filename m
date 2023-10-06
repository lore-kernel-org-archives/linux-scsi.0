Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A69E81E1E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjJFSoT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjJFSoT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 14:44:19 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 61C66BF
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 11:44:16 -0700 (PDT)
Received: (qmail 54149 invoked by uid 1000); 6 Oct 2023 14:44:15 -0400
Date:   Fri, 6 Oct 2023 14:44:15 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 4/6] usb-storage,uas: use host helper to generate
 driver info
Message-ID: <65bd429f-6740-4aa6-af00-e72d27074115@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-5-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-5-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Okay, this one is a bit of a mess.  Unavoidably so, I'm afraid.

On Fri, Oct 06, 2023 at 02:54:43PM +0200, Milan Broz wrote:
> The USB mass storage quirks flags are stored in driver_info,
> a 32-bit integer (unsigned long on 32-bit platforms).
> As this attribute cannot be enlarged, we need to use some form
> of translation of 64-bit quirk bits.
> 
> This problem was discussed on USB list
> https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/
> 
> The initial solution to use static array extensively increased the size
> of the kernel module, so I decided to try the second suggested solution:
> generate a table by host-compiled program and use bit 31 to indicate
> that the value is index and not actual value.
> 
> This patch adds a host-compiled program that processes unusual_devs.h
> (and unusual_uas.h) and generates files unusual-flags.c and unusual-flags-uas.c
> (for pre-processed USB device table with 32 bit device info) and unusual-flags.h
> with function to translate flags to 64-bits from device-info.
> 
> The separate generated header file is needed as storage and UAS drivers headers
> are tightly bound together and any ohter solution seems to be more pervasive.
> 
> Translation function is used only in usb-storage and uas modules; all other
> USB storage modules store flags directly, using only 32-bit integers.
> 
> This translation is unnecessary for a 64-bit system, but I keep it
> in place for simplicity.
> (Also, I did not find a reliable way a host-compiled program can detect
> that the target platform has 32-bit unsigned long (usual macros do not
> work here!).

How about testing CONFIG_64BIT?  Would that not do what you want?

However, I agree that it's better to keep things simple by using the 
same code base for 32-bit and 64-bit kernels.

> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
> 
>  drivers/usb/storage/Makefile       |  25 ++++
>  drivers/usb/storage/mkflags.c      | 212 +++++++++++++++++++++++++++++
>  drivers/usb/storage/uas-detect.h   |   2 +-
>  drivers/usb/storage/uas.c          |  17 +--
>  drivers/usb/storage/usb.c          |   7 +-
>  drivers/usb/storage/usual-tables.c |  23 +---
>  6 files changed, 248 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/usb/storage/mkflags.c
> 
> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
> index 46635fa4a340..1eacdbb387cd 100644
> --- a/drivers/usb/storage/Makefile
> +++ b/drivers/usb/storage/Makefile
> @@ -45,3 +45,28 @@ ums-realtek-y		:= realtek_cr.o
>  ums-sddr09-y		:= sddr09.o
>  ums-sddr55-y		:= sddr55.o
>  ums-usbat-y		:= shuttle_usbat.o
> +

Suggestion: Add a comment here, explaining what the following code does 
and why it is necessary.

> +$(obj)/usb.o: $(obj)/unusual-flags.h
> +$(obj)/usual-tables.o: $(obj)/unusual-flags.c
> +$(obj)/uas.o: $(obj)/unusual-flags.h $(obj)/unusual-flags-uas.c
> +clean-files		:= unusual-flags.h unusual-flags.c unusual-flags-uas.c
> +HOSTCFLAGS_mkflags.o	:= -I $(srctree)/include/
> +hostprogs		+= mkflags
> +
> +quiet_cmd_mkflag_flags = FLAGS   $@
> +      cmd_mkflag_flags = $(obj)/mkflags flags > $@
> +
> +quiet_cmd_mkflag_storage = FLAGS   $@
> +      cmd_mkflag_storage = $(obj)/mkflags storage > $@
> +
> +quiet_cmd_mkflag_uas = FLAGS   $@
> +      cmd_mkflag_uas = $(obj)/mkflags uas > $@
> +
> +$(obj)/unusual-flags.h: $(obj)/mkflags FORCE
> +	$(call if_changed,mkflag_flags)
> +
> +$(obj)/unusual-flags.c: $(obj)/mkflags FORCE
> +	$(call if_changed,mkflag_storage)
> +
> +$(obj)/unusual-flags-uas.c: $(obj)/mkflags FORCE
> +	$(call if_changed,mkflag_uas)

My make-fu isn't so hot.  Do you really need to use this indirect way of 
specifying whether and how to rebuild the new files?

> diff --git a/drivers/usb/storage/mkflags.c b/drivers/usb/storage/mkflags.c
> new file mode 100644
> index 000000000000..11aa6579e7e1
> --- /dev/null
> +++ b/drivers/usb/storage/mkflags.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0+

There needs to be a big comment here, explaining why this program is 
needed and exactly what it does.

> +
> +#include <stdio.h>
> +#include <string.h>
> +
> +/*
> + * Cannot use userspace <inttypes.h> as code below
> + * processes internal kernel headers
> + */
> +#include <linux/types.h>
> +
> +/*
> + * Silence warning for definitions in headers we do not use
> + */
> +struct usb_device_id {};
> +struct usb_interface;
> +
> +#include <linux/usb_usual.h>
> +
> +struct svals {
> +	unsigned int type;
> +
> +	/*interface */
> +	uint8_t bDeviceSubClass;
> +	uint8_t bDeviceProtocol;
> +
> +	/* device */
> +	uint16_t idVendor;
> +	uint16_t idProduct;
> +	uint16_t bcdDevice_lo;
> +	uint16_t bcdDevice_hi;
> +
> +	uint64_t flags;
> +	unsigned int set;
> +	unsigned int idx;
> +};
> +
> +enum { TYPE_DEVICE_STORAGE, TYPE_DEVICE_UAS, TYPE_CLASS };
> +enum { FLAGS_NOT_SET, FLAGS_SET, FLAGS_DUPLICATE };
> +#define FLAGS_END (uint64_t)-1
> +
> +#define IS_ENABLED(x) 0
> +
> +static struct svals vals[] = {
> +#define USUAL_DEV(useProto, useTrans) \
> +{ TYPE_CLASS, useProto, useTrans, 0, 0, 0, 0, 0, FLAGS_NOT_SET, 0 }
> +
> +#define COMPLIANT_DEV  UNUSUAL_DEV
> +#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
> +		    vendorName, productName, useProtocol, useTransport, \
> +		    initFunction, flags) \
> +{ TYPE_DEVICE_STORAGE, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
> +
> +#include "unusual_devs.h"
> +
> +/* UAS */

If you're going to put this comment line here, why isn't there a similar 
comment line "/* Mass-Storage */" at the start of the structure 
initializer?

> +#undef UNUSUAL_DEV
> +#define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
> +		    vendorName, productName, useProtocol, useTransport, \
> +		    initFunction, flags) \
> +{ TYPE_DEVICE_UAS, 0, 0, id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, flags, FLAGS_NOT_SET, 0 }
> +
> +#include "unusual_uas.h"
> +
> +{ .flags = FLAGS_END }
> +};
> +#undef UNUSUAL_DEV
> +#undef USUAL_DEV
> +#undef COMPLIANT_DEV
> +#undef IS_ENABLED
> +
> +#define HI32 (uint32_t)0x80000000
> +
> +static unsigned long get_device_info(uint64_t flags, unsigned int idx)
> +{
> +	if (flags < HI32)
> +		return (unsigned long)flags;
> +
> +	/* Use index that will be processed in usb_stor_di2flags */
> +	return HI32 + idx;
> +}
> +
> +static void print_class(uint8_t bDeviceSubClass, uint8_t bDeviceProtocol)
> +{
> +	printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO, ");
> +	printf(".bInterfaceClass = USB_CLASS_MASS_STORAGE, ");
> +	printf(".bInterfaceSubClass = 0x%x, .bInterfaceProtocol = 0x%x },\n",
> +		bDeviceSubClass, bDeviceProtocol);
> +}
> +static void print_type(unsigned int type)
> +{
> +	for (int i = 0; vals[i].flags != FLAGS_END; i++) {
> +		if (vals[i].type != type)
> +			continue;
> +
> +		if (type == TYPE_DEVICE_STORAGE || type == TYPE_DEVICE_UAS) {
> +			printf("\t{ .match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION, ");
> +			printf(".idVendor = 0x%x, .idProduct =0x%x, "
> +				".bcdDevice_lo = 0x%x, .bcdDevice_hi = 0x%x, .driver_info = 0x%lx },\n",
> +				vals[i].idVendor, vals[i].idProduct,
> +				vals[i].bcdDevice_lo, vals[i].bcdDevice_hi,
> +				get_device_info(vals[i].flags, vals[i].idx));
> +		} else if (type == TYPE_CLASS)
> +			print_class(vals[i].bDeviceSubClass, vals[i].bDeviceProtocol);
> +	}
> +}
> +
> +static void print_usb_flags(void)
> +{
> +	int i;
> +
> +	printf("#include <linux/types.h>\n\n");
> +
> +	/* usb_stor_di2flags */
> +	printf("static u64 usb_stor_di2flags(unsigned long idx)\n{\n");
> +	printf("\tu64 flags = 0;\n\n");
> +	printf("\tif (idx < 0x%x) \n\t\treturn idx;\n\n", HI32);
> +	printf("\tswitch(idx - 0x%x) {\n", HI32);
> +	for (i = 0; vals[i].flags != FLAGS_END; i++) {
> +		if (vals[i].set == FLAGS_SET)
> +			printf("\tcase %u: flags = 0x%llx; break;\n", vals[i].idx, vals[i].flags);
> +	}
> +	printf("\t}\n\n");
> +	printf("\treturn flags;\n");
> +	printf("}\n");
> +}

I suspect the usb_stor_di2flags() function doesn't have to be created by 
this preprocessor.  It ought to be possible to put a slightly altered 
version directly into uas-detect.h or some similar place (again, along 
with a comment explaining just what it does and why), and then generate 
here a simple array of 64-bit flags values which the function can index 
into rather than looking values up in a large "switch" statement.

> +static void print_usb_storage(void)
> +{
> +	printf("#include <linux/usb.h>\n\n");
> +
> +	/* usb_storage_usb_ids */
> +	printf("const struct usb_device_id usb_storage_usb_ids[] = {\n");
> +
> +	/* USB storage devices */
> +	print_type(TYPE_DEVICE_STORAGE);
> +
> +	/* UAS storage devices */
> +	printf("#if IS_ENABLED(CONFIG_USB_UAS)\n");
> +	print_type(TYPE_DEVICE_UAS);
> +	printf("#endif\n");
> +
> +	/* transport subclasses */
> +	print_type(TYPE_CLASS);
> +
> +	printf("\t{ }\t\t/* Terminating entry */\n};\n");
> +	printf("MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);\n");
> +}
> +
> +static void print_usb_uas(void)
> +{
> +	printf("#include <linux/usb.h>\n\n");
> +
> +	/* uas_usb_ids */
> +	printf("const struct usb_device_id uas_usb_ids[] = {\n");
> +
> +	/* UAS storage devices */
> +	print_type(TYPE_DEVICE_UAS);
> +
> +	/* transport subclasses */
> +	print_class(USB_SC_SCSI, USB_PR_BULK);
> +	print_class(USB_SC_SCSI, USB_PR_UAS);
> +
> +	printf("\t{ }\t\t/* Terminating entry */\n};\n");
> +	printf("MODULE_DEVICE_TABLE(usb, uas_usb_ids);\n");
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int i, j, idx = 0, idx_old, skip = 0;
> +
> +	if (argc != 2 || (strcmp(argv[1], "flags") &&
> +	    strcmp(argv[1], "storage") && strcmp(argv[1], "uas"))) {
> +		printf("Please specify type: storage, uas or flags.\n");
> +		return 1;
> +	}
> +
> +	for (i = 0; vals[i].flags != FLAGS_END; i++) {
> +		if (vals[i].type == TYPE_CLASS)
> +			continue;
> +		skip = 0;
> +		if (vals[i].flags >= HI32) {
> +			for (j = 0; j < i; j++) {
> +				if (vals[j].flags == vals[i].flags &&
> +				    vals[j].set == FLAGS_SET) {
> +					skip = 1;
> +					idx_old = vals[j].idx;
> +					break;
> +				}
> +			}

This de-duplication may be a little premature.  But I guess it doesn't 
hurt.

> +			if (skip) {
> +				vals[i].idx = idx_old;
> +				vals[i].set = FLAGS_DUPLICATE;
> +			} else {
> +				vals[i].idx = idx;
> +				vals[i].set = FLAGS_SET;
> +				idx++;
> +			}
> +		}
> +	}
> +
> +	if (!strcmp(argv[1], "flags"))
> +		print_usb_flags();
> +	else if (!strcmp(argv[1], "storage"))
> +		print_usb_storage();
> +	else if (!strcmp(argv[1], "uas"))
> +		print_usb_uas();
> +	else
> +		return 1;
> +
> +	return 0;
> +}

The rest of the patch looks pretty straightforward.

Alan Stern
