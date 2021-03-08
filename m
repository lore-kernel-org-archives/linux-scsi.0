Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8BEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 19:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C4365287
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 19:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhCHTdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 14:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhCHTck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Mar 2021 14:32:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05F0652A8;
        Mon,  8 Mar 2021 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615231960;
        bh=pTZnKtJTe2m07YW60C6Y46vT7s8TcSgE3dn8DlEK4ZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cTbCe6T3F+3ADUqxrHdZ5K7QXm3AgxEHrBcNKxxEf0G6weNYDeMyxY1zT1K6RGR2M
         PY5rtwWg7Wzu4YSCG+KLmqghptQDrzlQRUt/UgSziJvJai8sUa9U1bgR/LCbs+JJM3
         /qzwvDj2fHKEWOjZCUzvZ78xQuu+NgmZsxYusoMSWhAoQjLo89f6+zvSU9Bra0S/Iw
         vCkJ44fQEXrbxb1xtQKjaR6o2Z2tZSAFNLTvTP00O8+N+vxQCwwFGkNxbajEUIEHTk
         axNAWJHNUSvGLn6vSjOxsmkYh0INEx7HlGEdJkuciQtuuQkkOKVaQBLhs/cM2WZsNt
         UDzQOyslAuEFQ==
Date:   Mon, 8 Mar 2021 13:32:37 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: mpt3sas: Replace one-element array with
 flexible-array in struct _MPI2_CONFIG_PAGE_IO_UNIT_3
Message-ID: <20210308193237.GA212624@embeddedor>
References: <20210202235118.GA314410@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202235118.GA314410@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Friendly ping: who can review/take this, please?

Thanks!
--
Gustavo

On Tue, Feb 02, 2021 at 05:51:18PM -0600, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct _MPI2_CONFIG_PAGE_IO_UNIT_3, instead of a one-element array,
> and use the struct_size() helper to calculate the size for the
> allocation.
> 
> Also, this helps the ongoing efforts to enable -Warray-bounds and fix the
> following warnings:
> 
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:3193:63: warning: array subscript 24
> is above array bounds of ‘U16[1]’ {aka ‘short unsigned int[1]’}
> [-Warray-bounds]
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/109
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>  - Fix format specifier: use %zu for size_t type.
> 
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 11 +----------
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  6 +++---
>  2 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> index 43a3bf8ff428..908b0ca63204 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> @@ -987,21 +987,12 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
>  
>  /*IO Unit Page 3 */
>  
> -/*
> - *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
> - *one and check the value returned for GPIOCount at runtime.
> - */
> -#ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
> -#define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (1)
> -#endif
> -
>  typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_3 {
>  	MPI2_CONFIG_PAGE_HEADER Header;			 /*0x00 */
>  	U8                      GPIOCount;		 /*0x04 */
>  	U8                      Reserved1;		 /*0x05 */
>  	U16                     Reserved2;		 /*0x06 */
> -	U16
> -		GPIOVal[MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX];/*0x08 */
> +	U16			GPIOVal[];		 /*0x08 */
>  } MPI2_CONFIG_PAGE_IO_UNIT_3,
>  	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_3,
>  	Mpi2IOUnitPage3_t, *pMpi2IOUnitPage3_t;
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index c8a0ce18f2c5..ffb21f873058 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3143,7 +3143,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
>  	Mpi2ConfigReply_t mpi_reply;
>  	u16 backup_rail_monitor_status = 0;
>  	u16 ioc_status;
> -	int sz;
> +	size_t sz;
>  	ssize_t rc = 0;
>  
>  	if (!ioc->is_warpdrive) {
> @@ -3157,11 +3157,11 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
>  		goto out;
>  
>  	/* allocate upto GPIOVal 36 entries */
> -	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
> +	sz = struct_size(io_unit_pg3, GPIOVal, 36);
>  	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
>  	if (!io_unit_pg3) {
>  		rc = -ENOMEM;
> -		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
> +		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%zu) bytes\n",
>  			__func__, sz);
>  		goto out;
>  	}
> -- 
> 2.27.0
> 
