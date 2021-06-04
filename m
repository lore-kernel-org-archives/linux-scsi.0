Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA915C47083
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14E061359
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 05:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFDFYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 01:24:06 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:53728 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230034AbhFDFYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 01:24:06 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 42277182CED28;
        Fri,  4 Jun 2021 05:22:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 36C122550F1;
        Fri,  4 Jun 2021 05:22:19 +0000 (UTC)
Message-ID: <e841993b4b04a5c1dd2e266f1fe22c7debe8a425.camel@perches.com>
Subject: Re: [PATCH -next] scsi: mpi3mr: Make some symbols static
From:   Joe Perches <joe@perches.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Thu, 03 Jun 2021 22:22:17 -0700
In-Reply-To: <20210604051105.1122667-1-yangyingliang@huawei.com>
References: <20210604051105.1122667-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9673tp1kh46gaffywb5itthguctk6xyw
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 36C122550F1
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/v5QND0qMyewxkn8J4JIOAiKoX6asC/Ag=
X-HE-Tag: 1622784139-79509
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-06-04 at 13:11 +0800, Yang Yingliang wrote:
> Fix the following warnings:
> 
>   drivers/scsi/mpi3mr/mpi3mr_os.c:24:5: warning: symbol 'prot_mask' was not declared. Should it be static?
>   drivers/scsi/mpi3mr/mpi3mr_os.c:28:5: warning: symbol 'prot_guard_mask' was not declared. Should it be static?
>   drivers/scsi/mpi3mr/mpi3mr_os.c:31:5: warning: symbol 'logging_level' was not declared. Should it be static?
[]
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
[]
> @@ -21,14 +21,14 @@ MODULE_LICENSE(MPI3MR_DRIVER_LICENSE);
>  MODULE_VERSION(MPI3MR_DRIVER_VERSION);
>  
> 
>  /* Module parameters*/
> -int prot_mask = -1;
> +static int prot_mask = -1;
>  module_param(prot_mask, int, 0);
>  MODULE_PARM_DESC(prot_mask, "Host protection capabilities mask, def=0x07");

drivers/scsi/mpi3mr/mpi3mr_fw.c:extern int prot_mask;
drivers/scsi/mpi3mr/mpi3mr_fw.c:        if (prot_mask & (SHOST_DIX_TYPE0_PROTEC>

This should probably be put in a .h file instead.


