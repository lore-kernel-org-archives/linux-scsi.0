Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F83CC41513
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 01:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjHNBT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Aug 2023 21:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjHNBTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2023 21:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA771B5;
        Sun, 13 Aug 2023 18:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD8F3627F7;
        Mon, 14 Aug 2023 01:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E62FC433C7;
        Mon, 14 Aug 2023 01:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691975968;
        bh=2r4SrXgWvxdddgK2CyZN0rbI3plOx6MYyNp/XA7y7ss=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qFdXlUQOYu755yyGCW1/bzs0DKNmWbg+5/OUkVArDj+PTSLZcGuAfpfnbTBJ0Sygp
         tOhuNJFYkAHA410wslCJKlMqjlngexQtfNnbZt5bRNSgiVx7HlsB2jb6w1HGTuGeRq
         3NqRlbUT3AFHYeXWQ3IPbbw8EWBLLmKFpboNZHIPOaI0GRJuZa/v8KhBnWVCsnihPy
         k/4JximUlZ2Mwnw9z8x1g7uUOSURvGIZb/Qy2sSZddGWa0fRMkpJzg8VF6NDWpXXlV
         cjEdWbzT2n6x/TfWuqCB9Z+DspfIe+7sW3N7l7r0ZT2tkAilsm1iPd7uE/aKPisFsA
         ehgpx6du4ow/g==
Message-ID: <29cca660-4e66-002c-7378-2d2df5c79a08@kernel.org>
Date:   Mon, 14 Aug 2023 10:19:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 3/9] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-4-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230811213604.548235-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 06:35, Bart Van Assche wrote:
> Make the error handler call .eh_prepare_resubmit() before resubmitting

This reads like the eh_prepare_resubmit callback already exists. But you are
adding it. So you should state that.

> commands. A later patch will use this functionality to sort SCSI
> commands per LBA from inside the SCSI disk driver.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/Kconfig           |  2 +
>  drivers/scsi/Kconfig.kunit     |  4 ++
>  drivers/scsi/Makefile          |  2 +
>  drivers/scsi/Makefile.kunit    |  1 +
>  drivers/scsi/scsi_error.c      | 43 ++++++++++++++++
>  drivers/scsi/scsi_error_test.c | 92 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_priv.h       |  1 +
>  include/scsi/scsi_driver.h     |  1 +
>  8 files changed, 146 insertions(+)
>  create mode 100644 drivers/scsi/Kconfig.kunit
>  create mode 100644 drivers/scsi/Makefile.kunit
>  create mode 100644 drivers/scsi/scsi_error_test.c
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 4962ce989113..fc288f8fb800 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -232,6 +232,8 @@ config SCSI_SCAN_ASYNC
>  	  Note that this setting also affects whether resuming from
>  	  system suspend will be performed asynchronously.
>  
> +source "drivers/scsi/Kconfig.kunit"
> +
>  menu "SCSI Transports"
>  	depends on SCSI
>  
> diff --git a/drivers/scsi/Kconfig.kunit b/drivers/scsi/Kconfig.kunit
> new file mode 100644
> index 000000000000..68e3d90d49e9
> --- /dev/null
> +++ b/drivers/scsi/Kconfig.kunit
> @@ -0,0 +1,4 @@
> +config SCSI_ERROR_TEST
> +	tristate "scsi_error.c unit tests" if !KUNIT_ALL_TESTS
> +	depends on SCSI_MOD && KUNIT
> +	default KUNIT_ALL_TESTS
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index f055bfd54a68..1c5c3afb6c6e 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -168,6 +168,8 @@ scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
>  scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
>  scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
>  
> +include $(srctree)/drivers/scsi/Makefile.kunit
> +
>  hv_storvsc-y			:= storvsc_drv.o
>  
>  sd_mod-objs	:= sd.o
> diff --git a/drivers/scsi/Makefile.kunit b/drivers/scsi/Makefile.kunit
> new file mode 100644
> index 000000000000..3e98053b2709
> --- /dev/null
> +++ b/drivers/scsi/Makefile.kunit
> @@ -0,0 +1 @@
> +obj-$(CONFIG_SCSI_ERROR_TEST) += scsi_error_test.o

All the above kunit changes (and the test changes below) seem unrelated to what
the commit message describes. Should these be split into a different patch ?

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c67cdcdc3ba8..0d7835bdc8af 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -27,6 +27,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
> +#include <linux/list_sort.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -2186,6 +2187,46 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
>  
> +/*
> + * Comparison function that allows to sort SCSI commands by ULD driver.
> + */
> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
> +			const struct list_head *_b)
> +{
> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
> +
> +	/* See also the comment above the list_sort() definition. */
> +	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
> +}
> +
> +void scsi_call_prepare_resubmit(struct list_head *done_q)
> +{
> +	struct scsi_cmnd *scmd, *next;
> +
> +	/* Sort pending SCSI commands by ULD. */
> +	list_sort(NULL, done_q, scsi_cmp_uld);
> +
> +	/*
> +	 * Call .eh_prepare_resubmit for each range of commands with identical
> +	 * ULD driver pointer.
> +	 */
> +	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
> +		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
> +		struct list_head *prev, uld_cmd_list;
> +
> +		while (&next->eh_entry != done_q &&
> +		       scsi_cmd_to_driver(next) == uld)
> +			next = list_next_entry(next, eh_entry);
> +		if (!uld->eh_prepare_resubmit)
> +			continue;
> +		prev = scmd->eh_entry.prev;
> +		list_cut_position(&uld_cmd_list, prev, next->eh_entry.prev);
> +		uld->eh_prepare_resubmit(&uld_cmd_list);

Is it guaranteed that all uld implement eh_prepare_resubmit ?

> +		list_splice(&uld_cmd_list, prev);
> +	}
> +}
> +
>  /**
>   * scsi_eh_flush_done_q - finish processed commands or retry them.
>   * @done_q:	list_head of processed commands.
> @@ -2194,6 +2235,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>  {
>  	struct scsi_cmnd *scmd, *next;
>  
> +	scsi_call_prepare_resubmit(done_q);
> +
>  	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>  		list_del_init(&scmd->eh_entry);
>  		if (scsi_device_online(scmd->device) &&
> diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
> new file mode 100644
> index 000000000000..fd616527f726
> --- /dev/null
> +++ b/drivers/scsi/scsi_error_test.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2023 Google LLC
> + */
> +#include <kunit/test.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_driver.h>
> +#include "scsi_priv.h"
> +
> +static struct kunit *kunit_test;
> +
> +static struct scsi_driver *uld1, *uld2, *uld3;
> +
> +static void uld1_prepare_resubmit(struct list_head *cmd_list)
> +{
> +	struct scsi_cmnd *cmd;
> +
> +	KUNIT_EXPECT_EQ(kunit_test, list_count_nodes(cmd_list), 2);
> +	list_for_each_entry(cmd, cmd_list, eh_entry)
> +		KUNIT_EXPECT_PTR_EQ(kunit_test, scsi_cmd_to_driver(cmd), uld1);
> +}
> +
> +static void uld2_prepare_resubmit(struct list_head *cmd_list)
> +{
> +	struct scsi_cmnd *cmd;
> +
> +	KUNIT_EXPECT_EQ(kunit_test, list_count_nodes(cmd_list), 2);
> +	list_for_each_entry(cmd, cmd_list, eh_entry)
> +		KUNIT_EXPECT_PTR_EQ(kunit_test, scsi_cmd_to_driver(cmd), uld2);
> +}
> +
> +static void test_prepare_resubmit(struct kunit *test)
> +{
> +	static struct scsi_cmnd cmd1, cmd2, cmd3, cmd4, cmd5, cmd6;
> +	static struct scsi_device dev1, dev2, dev3;
> +	struct scsi_driver *uld;
> +	LIST_HEAD(cmd_list);
> +
> +	uld = kzalloc(3 * sizeof(uld), GFP_KERNEL);
> +	uld1 = &uld[0];
> +	uld1->eh_prepare_resubmit = uld1_prepare_resubmit;
> +	uld2 = &uld[1];
> +	uld2->eh_prepare_resubmit = uld2_prepare_resubmit;
> +	uld3 = &uld[2];
> +	dev1.sdev_gendev.driver = &uld1->gendrv;
> +	dev2.sdev_gendev.driver = &uld2->gendrv;
> +	dev3.sdev_gendev.driver = &uld3->gendrv;
> +	cmd1.device = &dev1;
> +	cmd2.device = &dev1;
> +	cmd3.device = &dev2;
> +	cmd4.device = &dev2;
> +	cmd5.device = &dev3;
> +	cmd6.device = &dev3;
> +	list_add_tail(&cmd1.eh_entry, &cmd_list);
> +	list_add_tail(&cmd3.eh_entry, &cmd_list);
> +	list_add_tail(&cmd5.eh_entry, &cmd_list);
> +	list_add_tail(&cmd2.eh_entry, &cmd_list);
> +	list_add_tail(&cmd4.eh_entry, &cmd_list);
> +	list_add_tail(&cmd6.eh_entry, &cmd_list);
> +
> +	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
> +	kunit_test = test;
> +	scsi_call_prepare_resubmit(&cmd_list);
> +	kunit_test = NULL;
> +	KUNIT_EXPECT_EQ(test, list_count_nodes(&cmd_list), 6);
> +	KUNIT_EXPECT_TRUE(test, uld1 < uld2);
> +	KUNIT_EXPECT_TRUE(test, uld2 < uld3);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next, &cmd1.eh_entry);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next, &cmd2.eh_entry);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next, &cmd3.eh_entry);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next,
> +			    &cmd4.eh_entry);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next,
> +			    &cmd5.eh_entry);
> +	KUNIT_EXPECT_PTR_EQ(test, cmd_list.next->next->next->next->next->next,
> +			    &cmd6.eh_entry);
> +	kfree(uld);
> +}
> +
> +static struct kunit_case prepare_resubmit_test_cases[] = {
> +	KUNIT_CASE(test_prepare_resubmit),
> +	{}
> +};
> +
> +static struct kunit_suite prepare_resubmit_test_suite = {
> +	.name = "prepare_resubmit",
> +	.test_cases = prepare_resubmit_test_cases,
> +};
> +kunit_test_suite(prepare_resubmit_test_suite);
> +
> +MODULE_AUTHOR("Bart Van Assche");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index f42388ecb024..df4af4645430 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  		      struct list_head *done_q);
>  bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
>  void scsi_eh_done(struct scsi_cmnd *scmd);
> +void scsi_call_prepare_resubmit(struct list_head *done_q);
>  
>  /* scsi_lib.c */
>  extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 4ce1988b2ba0..2b11be896eee 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -18,6 +18,7 @@ struct scsi_driver {
>  	int (*done)(struct scsi_cmnd *);
>  	int (*eh_action)(struct scsi_cmnd *, int);
>  	void (*eh_reset)(struct scsi_cmnd *);
> +	void (*eh_prepare_resubmit)(struct list_head *cmd_list);
>  };
>  #define to_scsi_driver(drv) \
>  	container_of((drv), struct scsi_driver, gendrv)

-- 
Damien Le Moal
Western Digital Research

