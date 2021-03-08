Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BCBC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 20:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A1DD65285
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCHUlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhCHUlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Mar 2021 15:41:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A37365272;
        Mon,  8 Mar 2021 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615236091;
        bh=xOjktTqUitc+u1lOxtaIEmtkCUS5Jbq0EmElj0l8lV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q10DS0UtjUUmLvXYNaUX3vwPngvfe7lurRbXNzKnAiWlO7g1p9N2VaaXLXNkiGHk5
         isvxwEDp7HIiUqCiKNjdc9QltPw735qpEpZ1TvcfuHzsSDgjtX28Lk7KC1aJmMsLRa
         ibfaGioCMssSiSasd5VfrJZ+ClxHRugUZquKR4P2UPxBJ7RKH7fnnf3GorIDhjt45n
         AKUkLRLxuInqHpLM5XlxOOLiavSlM/hZpC0/wIf4f9EL8kcDte3CDInpGrxvBcrEa2
         GVIi0B4qgto4IBfgHynXSihi6bK95g8MpkSah8oTfWV8z4ZYnlEfB+0w0dRtAAaR1m
         SV3b9kR09lL8A==
Date:   Mon, 8 Mar 2021 14:41:29 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: mpt3sas: Replace one-element array with
 flexible-array in struct _MPI2_CONFIG_PAGE_IO_UNIT_3
Message-ID: <20210308204129.GA214076@embeddedor>
References: <20210202235118.GA314410@embeddedor>
 <20210308193237.GA212624@embeddedor>
 <88d9dda39a70df25b48e72247b9752d3dc5e2e8d.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88d9dda39a70df25b48e72247b9752d3dc5e2e8d.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 08, 2021 at 12:12:59PM -0800, James Bottomley wrote:
> On Mon, 2021-03-08 at 13:32 -0600, Gustavo A. R. Silva wrote:
> > Hi all,
> > 
> > Friendly ping: who can review/take this, please?
> 
> Well, before embarking on a huge dynamic update, let's ask Broadcom the
> simpler question of why isn't MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX simply
> set to 36?  There's no dynamic allocation of anything in the current
> code ... it's all hard coded to allocate 36 entries.  If there's no
> need for anything dynamic then the kzalloc could become 

Yeah; and if that is the case, then there is no even need for kzalloc()
at all, and it can be replaced by memset():

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 43a3bf8ff428..d00431f553e1 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -992,7 +992,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
  *one and check the value returned for GPIOCount at runtime.
  */
 #ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
-#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
+#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (36)
 #endif

 typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 44f9a05db94e..23fcf29bfd67 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3203,7 +3203,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 {
        struct Scsi_Host *shost = class_to_shost(cdev);
        struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
-       Mpi2IOUnitPage3_t *io_unit_pg3 = NULL;
+       Mpi2IOUnitPage3_t io_unit_pg3;
        Mpi2ConfigReply_t mpi_reply;
        u16 backup_rail_monitor_status = 0;
        u16 ioc_status;
@@ -3221,16 +3221,10 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
                goto out;

        /* allocate upto GPIOVal 36 entries */
-       sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
-       io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
-       if (!io_unit_pg3) {
-               rc = -ENOMEM;
-               ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
-                       __func__, sz);
-               goto out;
-       }
+       sz = sizeof(io_unit_pg3);
+       memset(&io_unit_pg3, 0, sz);

-       if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
+       if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, &io_unit_pg3, sz) !=
            0) {
                ioc_err(ioc, "%s: failed reading iounit_pg3\n",
                        __func__);
@@ -3246,19 +3240,18 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
                goto out;
        }

-       if (io_unit_pg3->GPIOCount < 25) {
-               ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
-                       __func__, io_unit_pg3->GPIOCount);
+       if (io_unit_pg3.GPIOCount < 25) {
+               ioc_err(ioc, "%s: iounit_pg3.GPIOCount less than 25 entries, detected (%d) entries\n",
+                       __func__, io_unit_pg3.GPIOCount);
                rc = -EINVAL;
                goto out;
        }

        /* BRM status is in bit zero of GPIOVal[24] */
-       backup_rail_monitor_status = le16_to_cpu(io_unit_pg3->GPIOVal[24]);
+       backup_rail_monitor_status = le16_to_cpu(io_unit_pg3.GPIOVal[24]);
        rc = snprintf(buf, PAGE_SIZE, "%d\n", (backup_rail_monitor_status & 1));

  out:
-       kfree(io_unit_pg3);
        mutex_unlock(&ioc->pci_access_mutex);
        return rc;
 }

> 
> 	io_unit_pg3 = kzalloc(sizeof(*io_unit_pg3), GFP_KERNEL);
>

Thanks
--
Gustavo
